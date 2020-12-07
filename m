Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DE5F52D09BC
	for <lists+stable@lfdr.de>; Mon,  7 Dec 2020 05:34:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728657AbgLGEdW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 6 Dec 2020 23:33:22 -0500
Received: from mailout1.samsung.com ([203.254.224.24]:24483 "EHLO
        mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726489AbgLGEdV (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 6 Dec 2020 23:33:21 -0500
Received: from epcas1p2.samsung.com (unknown [182.195.41.46])
        by mailout1.samsung.com (KnoxPortal) with ESMTP id 20201207043237epoutp01cfde2d4beeb58eb94911687166fbfcc5~OVPvlt9_X1262612626epoutp01i
        for <stable@vger.kernel.org>; Mon,  7 Dec 2020 04:32:37 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout1.samsung.com 20201207043237epoutp01cfde2d4beeb58eb94911687166fbfcc5~OVPvlt9_X1262612626epoutp01i
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1607315557;
        bh=Tide8Qzcd1wBEYRq2DlXDubvem7js4dUXECRaFokmXc=;
        h=From:To:Cc:In-Reply-To:Subject:Date:References:From;
        b=XtdAxiwbZgdui4X79mt04WVggwG3I+WMz8qpvT3EgwvFvhk9pq+1LUWEWQ0Y1bk6p
         kkcyMCeeYLhYzjMxE2/e9VCOHhMCn1e05BDX0834JczqkYtvB2MvC55KvBlxVNNsH6
         iAFRhCUA4EUtbxDgz82zqlpWJIAt5wgSjEo2vluM=
Received: from epsnrtp1.localdomain (unknown [182.195.42.162]) by
        epcas1p3.samsung.com (KnoxPortal) with ESMTP id
        20201207043236epcas1p383bb508d91e04de0b81786c5f5e515c8~OVPufl6-w2791327913epcas1p36;
        Mon,  7 Dec 2020 04:32:36 +0000 (GMT)
Received: from epsmges1p4.samsung.com (unknown [182.195.40.166]) by
        epsnrtp1.localdomain (Postfix) with ESMTP id 4Cq9QW5FjZz4x9Ps; Mon,  7 Dec
        2020 04:32:35 +0000 (GMT)
Received: from epcas1p2.samsung.com ( [182.195.41.46]) by
        epsmges1p4.samsung.com (Symantec Messaging Gateway) with SMTP id
        B8.E8.10463.360BDCF5; Mon,  7 Dec 2020 13:32:35 +0900 (KST)
Received: from epsmtrp1.samsung.com (unknown [182.195.40.13]) by
        epcas1p1.samsung.com (KnoxPortal) with ESMTPA id
        20201207043235epcas1p1446adf522518089bb229d3aaa91e3f55~OVPs_Nu-D1972719727epcas1p1C;
        Mon,  7 Dec 2020 04:32:35 +0000 (GMT)
Received: from epsmgms1p2.samsung.com (unknown [182.195.42.42]) by
        epsmtrp1.samsung.com (KnoxPortal) with ESMTP id
        20201207043235epsmtrp11ce9e709c29e6221a547d4c89bfc896c~OVPs9kkBX2580925809epsmtrp1P;
        Mon,  7 Dec 2020 04:32:35 +0000 (GMT)
X-AuditID: b6c32a38-f11ff700000028df-c3-5fcdb0630ea5
Received: from epsmtip2.samsung.com ( [182.195.34.31]) by
        epsmgms1p2.samsung.com (Symantec Messaging Gateway) with SMTP id
        56.93.08745.260BDCF5; Mon,  7 Dec 2020 13:32:34 +0900 (KST)
Received: from namjaejeon01 (unknown [10.88.104.63]) by epsmtip2.samsung.com
        (KnoxPortal) with ESMTPA id
        20201207043234epsmtip2da9617598b3c34589b2e32954f381a4f~OVPsxKuWe1231112311epsmtip2N;
        Mon,  7 Dec 2020 04:32:34 +0000 (GMT)
From:   "Namjae Jeon" <namjae.jeon@samsung.com>
To:     "'Artem Labazov'" <123321artyom@gmail.com>
Cc:     <stable@vger.kernel.org>,
        "'Sungjong Seo'" <sj1557.seo@samsung.com>,
        <linux-fsdevel@vger.kernel.org>, <linux-kernel@vger.kernel.org>
In-Reply-To: <20201204133348.555024-1-123321artyom@gmail.com>
Subject: RE: [PATCH v2] exfat: Avoid allocating upcase table using kcalloc()
Date:   Mon, 7 Dec 2020 13:32:34 +0900
Message-ID: <000301d6cc51$fc2b6d10$f4824730$@samsung.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Mailer: Microsoft Outlook 16.0
Thread-Index: AQJLXyJfxD6HCJurO6uIAS3PJP5HfAKOOt2OAQ3muqmo5QRQEA==
Content-Language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFmphk+LIzCtJLcpLzFFi42LZdlhTTzd5w9l4g7srVCw23fzGarFn70kW
        i8u75rBZbPl3hNViwcZHjA6sHjtn3WX36NuyitHj8ya5AOaoHJuM1MSU1CKF1Lzk/JTMvHRb
        Je/geOd4UzMDQ11DSwtzJYW8xNxUWyUXnwBdt8wcoJVKCmWJOaVAoYDE4mIlfTubovzSklSF
        jPziElul1IKUnAJDgwK94sTc4tK8dL3k/FwrQwMDI1OgyoScjAvnjrAWnOGumD/pM2MD4yXO
        LkZODgkBE4l1/fPZuhi5OIQEdjBK/Fi+mwXC+cQoceb+XGYI5zOjxNv509lgWs6074Nq2cUo
        sf7xHEYI5yWjxK7bv9hBqtgEdCX+/dkP1iEioCdxYucOsFHMAl2MEv+mzmYFSXAK2EpMnn4e
        rEFYwEdi0982RhCbRUBFYuKcDqAaDg5eAUuJrjUCIGFeAUGJkzOfsIDYzALyEtvfzmGGuEhB
        4ufTZawQu5wkHm+bwQxRIyIxu7MNbK+EwF92idmHLkO94CJxftFtVghbWOLV8S3sELaUxMv+
        NnaQvRIC1RIf90PN72CUePHdFsI2lri5fgPYacwCmhLrd+lDhBUldv6eywixlk/i3dceVogp
        vBIdbUIQJaoSfZcOM0HY0hJd7R/YJzAqzULy2Cwkj81C8sAshGULGFlWMYqlFhTnpqcWGxaY
        IEf2JkZwctSy2ME49+0HvUOMTByMhxglOJiVRHjVpM7GC/GmJFZWpRblxxeV5qQWH2I0BYb0
        RGYp0eR8YHrOK4k3NDUyNja2MDEzNzM1VhLn/aPdES8kkJ5YkpqdmlqQWgTTx8TBKdXA5HD5
        +snUExO8BXSyEraoJp7+ErG23v3QUSclnf17n/5aH77ikQfviTm1Qo0ZMZYfahkdN0R8WiuW
        vOaoUV1CvUCTQVPtxZbcdf+D11ssuXhUg2vR7MhUzmQ28U+ciru+XxEQ6hfxdHDY3P6zcYqJ
        zSeOmH0ii72F587fqybWp/dF/rM/i6fRgattD3+F8pm/jdCa9/PFJY13QRsVveuqf87Ie273
        5/GpQwUqd3eIM62sy3p77PrPH6/lLxxo72m0apsXEeDKpHVrwrv5HFu8L8cX3DxRYX9y5yLf
        4vzL+7bHH7xZHPxGdmed5NWUjT4hi3fVVHNMXX9ATcB6TcOJzKXTJyrsON0berBl3aRjHkos
        xRmJhlrMRcWJAOerPCMXBAAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrNLMWRmVeSWpSXmKPExsWy7bCSvG7ShrPxBhsv2lhsuvmN1WLP3pMs
        Fpd3zWGz2PLvCKvFgo2PGB1YPXbOusvu0bdlFaPH501yAcxRXDYpqTmZZalF+nYJXBkXzh1h
        LTjDXTF/0mfGBsZLnF2MnBwSAiYSZ9r3sYHYQgI7GCXOrXOBiEtLHDtxhrmLkQPIFpY4fLi4
        i5ELqOQ5o8SZ//dYQGrYBHQl/v3ZD9YrIqAncWLnDmaQImaBPkaJu7O2QA3dwyjReVgAxOYU
        sJWYPP08O4gtLOAjselvGyOIzSKgIjFxTgcryDJeAUuJrjVg5bwCghInZz5hAQkzA81v2whW
        zSwgL7H97RxmiDMVJH4+XcYKcYKTxONtM5ghakQkZne2MU9gFJ6FZNIshEmzkEyahaRjASPL
        KkbJ1ILi3PTcYsMCo7zUcr3ixNzi0rx0veT83E2M4PjQ0trBuGfVB71DjEwcjIcYJTiYlUR4
        1aTOxgvxpiRWVqUW5ccXleakFh9ilOZgURLnvdB1Ml5IID2xJDU7NbUgtQgmy8TBKdXAtIJ9
        3se8KJ/J/i///9OdXHkmKtp01R2hxOr2OLPHigmR7VGda4/qyuo+uLP9xJqH5kdkZE48PKeg
        k3DF8/Z55tk1r+dyb5fK6s8ViX32s5Nf9AF3mMNXDfMTB+/G2XNP3Ju54OOvV+4aHns/JX1Q
        DCiJWRu6YIH4sQeTeQ5HvlcMDXwoGvI2m1+L/ezn3S9+L/u6dmLBdtUwj2MN0z78rjV55TvB
        w8zSrMHEpHb3nlmntribLbHyNBGuLjyidfWhbwpD/cxN/Gd/3g41/G2cKCi346qO288bMa+v
        +u/xKwq9tGChI9PDMyeOakYWtMj/zJs9xa2zcmNf5Ex2xfhzSXmXLorsjVG76XGoubnokhJL
        cUaioRZzUXEiAB22hbb+AgAA
X-CMS-MailID: 20201207043235epcas1p1446adf522518089bb229d3aaa91e3f55
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: SVC_REQ_APPROVE
CMS-TYPE: 101P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20201204133512epcas1p4381b107d0fc72d92920d336df9683a22
References: <001101d6c867$ca8c5730$5fa50590$@samsung.com>
        <CGME20201204133512epcas1p4381b107d0fc72d92920d336df9683a22@epcas1p4.samsung.com>
        <20201204133348.555024-1-123321artyom@gmail.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

> The table for Unicode upcase conversion requires an order-5 allocation, which may fail on a highly-
> fragmented system:
> 
>  pool-udisksd: page allocation failure: order:5, mode:0x40dc0(GFP_KERNEL|__GFP_COMP|__GFP_ZERO),
> nodemask=(null),cpuset=/,mems_allowed=0
>  CPU: 4 PID: 3756880 Comm: pool-udisksd Tainted: G     U            5.8.10-200.fc32.x86_64 #1
>  Hardware name: Dell Inc. XPS 13 9360/0PVG6D, BIOS 2.13.0 11/14/2019  Call Trace:
>   dump_stack+0x6b/0x88
>   warn_alloc.cold+0x75/0xd9
>   ? _cond_resched+0x16/0x40
>   ? __alloc_pages_direct_compact+0x144/0x150
>   __alloc_pages_slowpath.constprop.0+0xcfa/0xd30
>   ? __schedule+0x28a/0x840
>   ? __wait_on_bit_lock+0x92/0xa0
>   __alloc_pages_nodemask+0x2df/0x320
>   kmalloc_order+0x1b/0x80
>   kmalloc_order_trace+0x1d/0xa0
>   exfat_create_upcase_table+0x115/0x390 [exfat]
>   exfat_fill_super+0x3ef/0x7f0 [exfat]
>   ? sget_fc+0x1d0/0x240
>   ? exfat_init_fs_context+0x120/0x120 [exfat]
>   get_tree_bdev+0x15c/0x250
>   vfs_get_tree+0x25/0xb0
>   do_mount+0x7c3/0xaf0
>   ? copy_mount_options+0xab/0x180
>   __x64_sys_mount+0x8e/0xd0
>   do_syscall_64+0x4d/0x90
>   entry_SYSCALL_64_after_hwframe+0x44/0xa9
> 
> Make the driver use vzalloc() to eliminate the issue.
> 
> Cc: stable@vger.kernel.org # v5.7+
> Signed-off-by: Artem Labazov <123321artyom@gmail.com>
> ---
> v2: replace vmalloc with vzalloc to avoid uninitialized memory access
Applied.
Thanks for your work!

