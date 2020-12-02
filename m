Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E793C2CB425
	for <lists+stable@lfdr.de>; Wed,  2 Dec 2020 06:00:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728443AbgLBE7U (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 1 Dec 2020 23:59:20 -0500
Received: from mailout4.samsung.com ([203.254.224.34]:27183 "EHLO
        mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727744AbgLBE7U (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 1 Dec 2020 23:59:20 -0500
Received: from epcas1p3.samsung.com (unknown [182.195.41.47])
        by mailout4.samsung.com (KnoxPortal) with ESMTP id 20201202045838epoutp04ccc4228e631f18b93d5115297811918a~MzYBfhzuZ2032820328epoutp04J
        for <stable@vger.kernel.org>; Wed,  2 Dec 2020 04:58:38 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout4.samsung.com 20201202045838epoutp04ccc4228e631f18b93d5115297811918a~MzYBfhzuZ2032820328epoutp04J
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1606885118;
        bh=OFa7pYNsfTU8WW6Yo79jxkGXP6RWMrOeNC/0D673u8E=;
        h=From:To:Cc:In-Reply-To:Subject:Date:References:From;
        b=fSw+wuFbVnCMUTQktfpyQ0ESvWKjk/b1zgFFBe0261NTjPK7GBZMnGA0TvMUBpuej
         Y3Mxyw6mKBa5k8DgXTqyKbiLiWnDvOqKJHUHLgX2MxKu05xeoVCA5l6ELAJbckpkZg
         vS5LC72EaF/DXpu2u1C9BD+vHFiLmN+XdHm5bKgQ=
Received: from epsnrtp4.localdomain (unknown [182.195.42.165]) by
        epcas1p3.samsung.com (KnoxPortal) with ESMTP id
        20201202045837epcas1p393672f0ec5cf1722ae48d4aff71ddaa6~MzYBFWLL82934329343epcas1p3d;
        Wed,  2 Dec 2020 04:58:37 +0000 (GMT)
Received: from epsmges1p1.samsung.com (unknown [182.195.40.162]) by
        epsnrtp4.localdomain (Postfix) with ESMTP id 4Cm6Dr5smtzMqYkj; Wed,  2 Dec
        2020 04:58:36 +0000 (GMT)
Received: from epcas1p4.samsung.com ( [182.195.41.48]) by
        epsmges1p1.samsung.com (Symantec Messaging Gateway) with SMTP id
        10.99.02418.CFE17CF5; Wed,  2 Dec 2020 13:58:36 +0900 (KST)
Received: from epsmtrp2.samsung.com (unknown [182.195.40.14]) by
        epcas1p1.samsung.com (KnoxPortal) with ESMTPA id
        20201202045836epcas1p1fc945fed4a7be7244a12f235c508061a~MzX-ooRSt0860908609epcas1p1h;
        Wed,  2 Dec 2020 04:58:36 +0000 (GMT)
Received: from epsmgms1p1new.samsung.com (unknown [182.195.42.41]) by
        epsmtrp2.samsung.com (KnoxPortal) with ESMTP id
        20201202045836epsmtrp2f0b52555b45c379dcbf376882303bb3e~MzX-n1vfd2222622226epsmtrp2k;
        Wed,  2 Dec 2020 04:58:36 +0000 (GMT)
X-AuditID: b6c32a35-c23ff70000010972-88-5fc71efcd26b
Received: from epsmtip2.samsung.com ( [182.195.34.31]) by
        epsmgms1p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
        39.F5.13470.CFE17CF5; Wed,  2 Dec 2020 13:58:36 +0900 (KST)
Received: from W10PB11329 (unknown [10.253.152.129]) by epsmtip2.samsung.com
        (KnoxPortal) with ESMTPA id
        20201202045836epsmtip2f75f1796c3062fc595b538e52fd7cd08~MzX-fAQSr2582325823epsmtip23;
        Wed,  2 Dec 2020 04:58:36 +0000 (GMT)
From:   "Sungjong Seo" <sj1557.seo@samsung.com>
To:     "'Artem Labazov'" <123321artyom@gmail.com>
Cc:     <stable@vger.kernel.org>,
        "'Namjae Jeon'" <namjae.jeon@samsung.com>,
        <linux-fsdevel@vger.kernel.org>, <linux-kernel@vger.kernel.org>
In-Reply-To: <20201124194749.4041176-1-123321artyom@gmail.com>
Subject: RE: [PATCH] exfat: Avoid allocating upcase table using kcalloc()
Date:   Wed, 2 Dec 2020 13:58:35 +0900
Message-ID: <001101d6c867$ca8c5730$5fa50590$@samsung.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Mailer: Microsoft Outlook 15.0
Thread-Index: AQGAh9ZISCX29VPYFR7X7vXspJxNNgFOHEJzqoVNqkA=
Content-Language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFmpmk+LIzCtJLcpLzFFi42LZdljTQPeP3PF4g3ln9Cw23fzGarFn70kW
        i8u75rBZ/Jheb7Fg4yNGB1aPnbPusnv0bVnF6PF5k1wAc1SOTUZqYkpqkUJqXnJ+SmZeuq2S
        d3C8c7ypmYGhrqGlhbmSQl5ibqqtkotPgK5bZg7QRiWFssScUqBQQGJxsZK+nU1RfmlJqkJG
        fnGJrVJqQUpOgaFBgV5xYm5xaV66XnJ+rpWhgYGRKVBlQk7Gt3fLWQpec1csmT2HrYHxIWcX
        IyeHhICJxOGzn1m7GLk4hAR2MEosOvSXHcL5xCjxq7ObGcL5xijxetc8NpiWx+3/mSASexkl
        OqdeZ4NwXjJKnF43kxGkik1AV+LJjZ/MILaIgJ7EiZ07wEYxC3QxSjze9ZsFJMEpYCfx+MMm
        oG4ODmEBT4mdCzVBwiwCKhJt1+eCzeEVsJR4/eEdlC0ocXLmE7BWZgF5ie1v5zBDXKQgsfvT
        UVaIXVYSNzr+sEHUiEjM7mwD2ysh8Jdd4vXmqawguyQEXCQm97FC9ApLvDq+hR3ClpL4/G4v
        1Jf1Ev/nr2WH6G1hlHj4aRsTRK+9xPtLFiAms4CmxPpd+hDlihI7f0OczCzAJ/Huaw/UJl6J
        jjYhiBIVie8fdrLAbLry4yrTBEalWUgem4XksVlIHpiFsGwBI8sqRrHUguLc9NRiwwJD5Mje
        xAhOjVqmOxgnvv2gd4iRiYPxEKMEB7OSCC/LvyPxQrwpiZVVqUX58UWlOanFhxhNgUE9kVlK
        NDkfmJzzSuINTY2MjY0tTMzMzUyNlcR5/2h3xAsJpCeWpGanphakFsH0MXFwSjUwud2OVrVK
        udLwf/mqwgyt1ZvZy0zPLJSW0U/zuLv3yfkVTbufNXtYn+q9vCdSbe269zYKAUyP5WInBou6
        zJKMbBZ2WugXVtjcw/GkU6MvweHByerVM3yVPTqjyufN/m57e33EawfZSaubPyXIyM4yr+nL
        NKq66JXDMPEBi2qScZ5L0363KSzLX3JkR8+oWqr49tzl38atX3ZY8WTc85nj6leufSOy9f6l
        ju4VaXYTzP0P8Zu5HGc03CBlzHso+MLPmwVNBxY1rPOcUlE/M+jgg5ql+mXuN9MvafbW8Yv8
        XtvRpLmoaPaN2wWhVXel7zGtjIp+oh6jrVF05aL84aiyE+c6jFNUzy89If6uWl2JpTgj0VCL
        uag4EQAkreZXFgQAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrFLMWRmVeSWpSXmKPExsWy7bCSvO4fuePxBre/8llsuvmN1WLP3pMs
        Fpd3zWGz+DG93mLBxkeMDqweO2fdZffo27KK0ePzJrkA5igum5TUnMyy1CJ9uwSujG/vlrMU
        vOauWDJ7DlsD40POLkZODgkBE4nH7f+Zuhi5OIQEdjNK3J12n7GLkQMoISVxcJ8mhCkscfhw
        MUTJc0aJxZ3XWUB62QR0JZ7c+MkMYosI6Emc2LmDGaSIWaCPUeJrRx87SEJIoJ9R4umPEBCb
        U8BO4vGHTWwgQ4UFPCV2LtQECbMIqEi0XZ/LCGLzClhKvP7wDsoWlDg58wkLSDkz0Py2jWBh
        ZgF5ie1v5zBDnK8gsfvTUVaIE6wkbnT8YYOoEZGY3dnGPIFReBaSSbMQJs1CMmkWko4FjCyr
        GCVTC4pz03OLDQsM81LL9YoTc4tL89L1kvNzNzGCo0NLcwfj9lUf9A4xMnEwHmKU4GBWEuFl
        +XckXog3JbGyKrUoP76oNCe1+BCjNAeLkjjvjcKFcUIC6YklqdmpqQWpRTBZJg5OqQamvDUX
        fY4s630ysWnaGlbbSDavlnnv/y+WebHmq5m2zuV37oriR84eNHnU6/RAdEb7t/s8Hxf8vnP9
        H1OUyCLBmfLai17Ns/RKbnsTcsve7o+Zo8bOVnP3mt/aWY1dRV8CXBPScvxfHDRc8fRrS8MD
        4cvxDyfKsc5WvOiT8izB5r+q88fKNpH3b9nefju8vuSwXIf4jrWH126vfVtYweN1YOXad5vv
        sVyr8fhy4PXWOvd7ygk/l2yf0vq9x2abC882oRDzOxUHbyxasqbZ62aXWWcG20nFox65c7JO
        ml1O5FPYL3FmXttJpQpuu7lyHgGdmh5SP4I3HXjAKFU1xSNhnojBzK8LVGrOvd7c+MojTIml
        OCPRUIu5qDgRAHUrGJP9AgAA
X-CMS-MailID: 20201202045836epcas1p1fc945fed4a7be7244a12f235c508061a
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: SVC_REQ_APPROVE
CMS-TYPE: 101P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20201124194858epcas1p49cacda6a9b4877ff125f25f4dc5fcadf
References: <CGME20201124194858epcas1p49cacda6a9b4877ff125f25f4dc5fcadf@epcas1p4.samsung.com>
        <20201124194749.4041176-1-123321artyom@gmail.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

> The table for Unicode upcase conversion requires an order-5 allocation,
> which may fail on a highly-fragmented system:
> 
>  pool-udisksd: page allocation failure: order:5,
> mode:0x40dc0(GFP_KERNEL|__GFP_COMP|__GFP_ZERO),
> nodemask=(null),cpuset=/,mems_allowed=0
>  CPU: 4 PID: 3756880 Comm: pool-udisksd Tainted: G     U
5.8.10-
> 200.fc32.x86_64 #1
>  Hardware name: Dell Inc. XPS 13 9360/0PVG6D, BIOS 2.13.0 11/14/2019  Call
> Trace:
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
> Make the driver use vmalloc() to eliminate the issue.

I have not yet received a report of the same issue.
But I agree that this problem is likely to occur even if it is low
probability.

I think it would be more appropriate to use kvcalloc and kvfree instead.
Could you send me v2 patch?


