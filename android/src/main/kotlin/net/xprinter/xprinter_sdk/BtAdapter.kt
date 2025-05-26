package net.xprinter.xprinter_sdk

class BtAdapter(private val datas: MutableList<Bean>) {
    data class Bean(
        var isMatching: Boolean,
        var name: String?,
        var mac: String
    )
    fun getItemCount(): Int = datas.size
}