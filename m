Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EC47E2D20C4
	for <lists+stable@lfdr.de>; Tue,  8 Dec 2020 03:23:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728035AbgLHCXb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 7 Dec 2020 21:23:31 -0500
Received: from mailout4.samsung.com ([203.254.224.34]:56922 "EHLO
        mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727744AbgLHCXa (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 7 Dec 2020 21:23:30 -0500
Received: from epcas1p2.samsung.com (unknown [182.195.41.46])
        by mailout4.samsung.com (KnoxPortal) with ESMTP id 20201208022246epoutp04775196857d9400d9870db8a93bd2ae3b~OnHp9dYke1960019600epoutp04B
        for <stable@vger.kernel.org>; Tue,  8 Dec 2020 02:22:46 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout4.samsung.com 20201208022246epoutp04775196857d9400d9870db8a93bd2ae3b~OnHp9dYke1960019600epoutp04B
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1607394166;
        bh=pe7CM9WyZt49YAm2pn0VpNtOQJ+3o4nLHVeJqrIcouQ=;
        h=From:To:Cc:In-Reply-To:Subject:Date:References:From;
        b=vfP46zEtA70sIZZLTfZ1cDtRhVc5OZt/KelAiu+DQjQHz1euI0SUljAOGXpzFolqX
         fmvKQWp2OHA5WCbvMtXFBhrq2xtPjQa8WKqGjvd58GRP+iniQ8fE9ht6bCDHckdN9Y
         I7Bj4Yl6ZaubW3RDNd7oD63NmxzrEM173TRYepPQ=
Received: from epsnrtp3.localdomain (unknown [182.195.42.164]) by
        epcas1p4.samsung.com (KnoxPortal) with ESMTP id
        20201208022245epcas1p429c7e3dda325d919c3633f090a441396~OnHoxsVOS2627826278epcas1p4W;
        Tue,  8 Dec 2020 02:22:45 +0000 (GMT)
Received: from epsmges1p4.samsung.com (unknown [182.195.40.162]) by
        epsnrtp3.localdomain (Postfix) with ESMTP id 4CqkVD47dhzMqYkk; Tue,  8 Dec
        2020 02:22:44 +0000 (GMT)
Received: from epcas1p1.samsung.com ( [182.195.41.45]) by
        epsmges1p4.samsung.com (Symantec Messaging Gateway) with SMTP id
        C7.DA.10463.273EECF5; Tue,  8 Dec 2020 11:22:42 +0900 (KST)
Received: from epsmtrp1.samsung.com (unknown [182.195.40.13]) by
        epcas1p3.samsung.com (KnoxPortal) with ESMTPA id
        20201208022241epcas1p3407f06febb01756b7affc67b14e65948~OnHlMmGQz1522615226epcas1p3l;
        Tue,  8 Dec 2020 02:22:41 +0000 (GMT)
Received: from epsmgms1p1new.samsung.com (unknown [182.195.42.41]) by
        epsmtrp1.samsung.com (KnoxPortal) with ESMTP id
        20201208022241epsmtrp17e24dd1604dc3bca6ab9fc0ce849229d~OnHlMBPT52794527945epsmtrp1R;
        Tue,  8 Dec 2020 02:22:41 +0000 (GMT)
X-AuditID: b6c32a38-f11ff700000028df-38-5fcee3727c39
Received: from epsmtip2.samsung.com ( [182.195.34.31]) by
        epsmgms1p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
        35.AE.13470.173EECF5; Tue,  8 Dec 2020 11:22:41 +0900 (KST)
Received: from W10PB11329 (unknown [10.253.152.129]) by epsmtip2.samsung.com
        (KnoxPortal) with ESMTPA id
        20201208022241epsmtip204f3f5ce76b5c1ffb770ec474cfacd3a~OnHlAlazF0089300893epsmtip2f;
        Tue,  8 Dec 2020 02:22:41 +0000 (GMT)
From:   "Sungjong Seo" <sj1557.seo@samsung.com>
To:     "'Artem Labazov'" <123321artyom@gmail.com>
Cc:     <stable@vger.kernel.org>,
        "'Namjae Jeon'" <namjae.jeon@samsung.com>,
        <linux-fsdevel@vger.kernel.org>, <linux-kernel@vger.kernel.org>
In-Reply-To: <20201207093424.833542-1-123321artyom@gmail.com>
Subject: RE: [PATCH v3] exfat: Avoid allocating upcase table using kcalloc()
Date:   Tue, 8 Dec 2020 11:22:41 +0900
Message-ID: <4be901d6cd09$01627dc0$04277940$@samsung.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Mailer: Microsoft Outlook 15.0
Thread-Index: AQIJ08XTvRooVCuidXKYwzhlRa4OcgEoymEIAbOacKCpb4aEoA==
Content-Language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFmpmk+LIzCtJLcpLzFFi42LZdlhTV7fo8bl4g309ghabbn5jtdiz9ySL
        xeVdc9gsfkyvt1iw8RGjA6vHzll32T36tqxi9Pi8SS6AOSrHJiM1MSW1SCE1Lzk/JTMv3VbJ
        OzjeOd7UzMBQ19DSwlxJIS8xN9VWycUnQNctMwdoo5JCWWJOKVAoILG4WEnfzqYov7QkVSEj
        v7jEVim1ICWnwNCgQK84Mbe4NC9dLzk/18rQwMDIFKgyISej5fclxoJmsYrHXxcxNjBOFupi
        5OSQEDCRmHJqDTuILSSwg1Hi0QyBLkYuIPsTo0THptdMEM43RolDqyawdTFygHVc+GcJEd/L
        KLHsUzM7hPOSUaJ9fycTyCg2AV2JJzd+MoPYIgJ6Eid27mAGKWIGGi7xeNdvFpAEp4CtxIPJ
        m9lAbGEBH4mvL3eD3cEioCLRdPI3I4jNK2ApsfjZF1YIW1Di5MwnYL3MAvIS29/OYYb4QUFi
        96ejrBDLnCQu9U5nhKgRkZjd2Qa2WELgL7vEsicbWCAaXCT2n1rECGELS7w6voUdwpaSeNnf
        BmXXS/yfv5YdormFUeLhp21MEP/bS7y/ZAFiMgtoSqzfpQ9Rriix8/dcqL18Eu++9rBCVPNK
        dLRBg1pF4vuHnSwwm678uMo0gVFpFpLPZiH5bBaSD2YhLFvAyLKKUSy1oDg3PbXYsMAEObI3
        MYJTo5bFDsa5bz/oHWJk4mA8xCjBwawkwqsmdTZeiDclsbIqtSg/vqg0J7X4EKMpMKwnMkuJ
        JucDk3NeSbyhqZGxsbGFiZm5mamxkjjvH+2OeCGB9MSS1OzU1ILUIpg+Jg5OqQamzNCmR5Nv
        sEdpdz01rihfOiMq5nr7ay3/FWvFXNILwyyeuEz5OivHOvlZwaHXsT7bq4r5vn03O/q5PuGK
        gr2Chu+y/5yOiVrtHaunSHwSvhnh+crvfNLxio0sO+csTSzyffJ2V72ttG/G86+/vSInLeGu
        Ocd+jX1Gl17x1rl/63wNQtR/nf06++Vkf9Pg2nmXNfg4ul2vxyzZL7328fmf3Zrb9fdwTn2k
        KpwkvH2x4cYrlubVnRNn6d4Qaz3mxDX9l5cni15u9rRTJz9d1OX99Ptbz88U63g7b/UP6Y6t
        xUsqwvfYH5oxTZxvAo9owEf+2tOuvLXnZZnqJ017kDx9xtJTEmvUazWkFn5Q0glWYinOSDTU
        Yi4qTgQAa8fhaRYEAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrNLMWRmVeSWpSXmKPExsWy7bCSvG7h43PxBi/2allsuvmN1WLP3pMs
        Fpd3zWGz+DG93mLBxkeMDqweO2fdZffo27KK0ePzJrkA5igum5TUnMyy1CJ9uwSujJbflxgL
        msUqHn9dxNjAOFmoi5GDQ0LAROLCP8suRi4OIYHdjBKLjtxkh4hLSRzcpwlhCkscPlwMUfKc
        UeLYiYNsXYycHGwCuhJPbvxkBrFFBPQkTuzcwQxSxCzQxyjxtaOPHaJjD6PE36tPWUGqOAVs
        JR5M3gzWLSzgI/H15W52EJtFQEWi6eRvRhCbV8BSYvGzL6wQtqDEyZlPWECuYAba0LYRrIRZ
        QF5i+9s5YIslBBQkdn86ygpxhJPEpd7pUDUiErM725gnMArPQjJpFsKkWUgmzULSsYCRZRWj
        ZGpBcW56brFhgWFearlecWJucWleul5yfu4mRnB8aGnuYNy+6oPeIUYmDsZDjBIczEoivGpS
        Z+OFeFMSK6tSi/Lji0pzUosPMUpzsCiJ817oOhkvJJCeWJKanZpakFoEk2Xi4JRqYNo/+6vV
        hO7Qw+L3j6SbMwSxy7DkB14O6LTqWLOWz2HfpbjYDyHP3uivP9U+N+ClUeEDXTvxGTvPHIms
        3bFsW4bQWc2Lsw7fvZRv25p0pfyLzra15Vzu6R1zXLfsbH71aE+e35u/wvb5uy+xux63F7B/
        8H/28puTk1/x5N4992jpKVP59B+c2ct3dvhE3nXb88LxTd6XJy987lrYzRaY27Vu8mYfltbA
        hF1Cx2IP7bZjSv49MfdWoE4V48LNXYpLVxxesOL5qVXy6o4NWu9tNh9+VMXm3fjl5L676W2H
        HyS0XwibVla6fEF4u0bxlr5C+cg3qyde3JrNrrIljyOTrUjl7su2d2yzv+hnOC8I8diqxFKc
        kWioxVxUnAgAvajiRv4CAAA=
X-CMS-MailID: 20201208022241epcas1p3407f06febb01756b7affc67b14e65948
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: SVC_REQ_APPROVE
CMS-TYPE: 101P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20201207093733epcas1p2c00c197d4f9f5db1e26c4c1c779eab7c
References: <40be01d6cc61$7d23cac0$776b6040$@samsung.com>
        <CGME20201207093733epcas1p2c00c197d4f9f5db1e26c4c1c779eab7c@epcas1p2.samsung.com>
        <20201207093424.833542-1-123321artyom@gmail.com>
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
> Convert kcalloc/kfree to their kv* variants to eliminate the issue.
> 
> Cc: stable@vger.kernel.org # v5.7+
> Signed-off-by: Artem Labazov <123321artyom@gmail.com>

Looks good.
Thanks for your contribution.

Reviewed-by: Sungjong Seo <sj1557.seo@samsung.com>

> ---
> v2: replace vmalloc with vzalloc to avoid uninitialized memory access
> v3: use kv* functions to attempt kmalloc first
> 
>  fs/exfat/nls.c | 6 +++---
>  1 file changed, 3 insertions(+), 3 deletions(-)
> 
> diff --git a/fs/exfat/nls.c b/fs/exfat/nls.c index
> 675d0e7058c5..314d5407a1be 100644
> --- a/fs/exfat/nls.c
> +++ b/fs/exfat/nls.c
> @@ -659,7 +659,7 @@ static int exfat_load_upcase_table(struct super_block
> *sb,
>  	unsigned char skip = false;
>  	unsigned short *upcase_table;
> 
> -	upcase_table = kcalloc(UTBL_COUNT, sizeof(unsigned short),
> GFP_KERNEL);
> +	upcase_table = kvcalloc(UTBL_COUNT, sizeof(unsigned short),
> +GFP_KERNEL);
>  	if (!upcase_table)
>  		return -ENOMEM;
> 
> @@ -715,7 +715,7 @@ static int exfat_load_default_upcase_table(struct
> super_block *sb)
>  	unsigned short uni = 0, *upcase_table;
>  	unsigned int index = 0;
> 
> -	upcase_table = kcalloc(UTBL_COUNT, sizeof(unsigned short),
> GFP_KERNEL);
> +	upcase_table = kvcalloc(UTBL_COUNT, sizeof(unsigned short),
> +GFP_KERNEL);
>  	if (!upcase_table)
>  		return -ENOMEM;
> 
> @@ -803,5 +803,5 @@ int exfat_create_upcase_table(struct super_block *sb)
> 
>  void exfat_free_upcase_table(struct exfat_sb_info *sbi)  {
> -	kfree(sbi->vol_utbl);
> +	kvfree(sbi->vol_utbl);
>  }
> --
> 2.26.2


