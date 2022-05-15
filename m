Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C12DF527846
	for <lists+stable@lfdr.de>; Sun, 15 May 2022 16:52:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237276AbiEOOwT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 15 May 2022 10:52:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56330 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237275AbiEOOwO (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 15 May 2022 10:52:14 -0400
Received: from mailout1.samsung.com (mailout1.samsung.com [203.254.224.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4947A2DF8
        for <stable@vger.kernel.org>; Sun, 15 May 2022 07:52:11 -0700 (PDT)
Received: from epcas1p1.samsung.com (unknown [182.195.41.45])
        by mailout1.samsung.com (KnoxPortal) with ESMTP id 20220515145206epoutp01b67ba070829d8236f53150b00723ae18~vTuM4X35M2750727507epoutp01X
        for <stable@vger.kernel.org>; Sun, 15 May 2022 14:52:06 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout1.samsung.com 20220515145206epoutp01b67ba070829d8236f53150b00723ae18~vTuM4X35M2750727507epoutp01X
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1652626326;
        bh=YecPhC80F8OYFafQAk1lG9Dp3FXRZApg8GB4Gfqp7Es=;
        h=From:To:Cc:In-Reply-To:Subject:Date:References:From;
        b=fbWugHz7ChVxNnpksUUhZYmpz3ElOHvS2zKE5E9KGZgHQLg5ngGuz+44hBA8omcUV
         Pgu+YYAdN9VNqWhNLW7/fyDqI0zGXQE1br7hxNvGUqjYkxeIRnHz/Mfaj4GSBTZpNy
         CO3ofyF81Y7v0G89s4Mmt/7e3ab8l7trZI2syxgk=
Received: from epsnrtp2.localdomain (unknown [182.195.42.163]) by
        epcas1p3.samsung.com (KnoxPortal) with ESMTP id
        20220515145205epcas1p361c3a642e954a05905a00adc0c066f14~vTuMJnz752825028250epcas1p3K;
        Sun, 15 May 2022 14:52:05 +0000 (GMT)
Received: from epsmges1p2.samsung.com (unknown [182.195.38.248]) by
        epsnrtp2.localdomain (Postfix) with ESMTP id 4L1QMS5LVdz4x9Pt; Sun, 15 May
        2022 14:52:04 +0000 (GMT)
Received: from epcas1p4.samsung.com ( [182.195.41.48]) by
        epsmges1p2.samsung.com (Symantec Messaging Gateway) with SMTP id
        01.99.09785.49311826; Sun, 15 May 2022 23:52:04 +0900 (KST)
Received: from epsmtrp1.samsung.com (unknown [182.195.40.13]) by
        epcas1p2.samsung.com (KnoxPortal) with ESMTPA id
        20220515145203epcas1p26cb049179c6116ecf6f0316f61f793d5~vTuKyB0k70904109041epcas1p2Q;
        Sun, 15 May 2022 14:52:03 +0000 (GMT)
Received: from epsmgms1p2.samsung.com (unknown [182.195.42.42]) by
        epsmtrp1.samsung.com (KnoxPortal) with ESMTP id
        20220515145203epsmtrp1051a7b9242fe484a5a2f97ccc5120f34~vTuKuBAoz1949719497epsmtrp1U;
        Sun, 15 May 2022 14:52:03 +0000 (GMT)
X-AuditID: b6c32a36-c9dff70000002639-f1-628113944e86
Received: from epsmtip1.samsung.com ( [182.195.34.30]) by
        epsmgms1p2.samsung.com (Symantec Messaging Gateway) with SMTP id
        B2.F4.08924.39311826; Sun, 15 May 2022 23:52:03 +0900 (KST)
Received: from W10PB11329 (unknown [10.253.152.129]) by epsmtip1.samsung.com
        (KnoxPortal) with ESMTPA id
        20220515145203epsmtip17dc50ce0893c9f9353e75ebe88b4538d~vTuKgcPVn2152621526epsmtip1J;
        Sun, 15 May 2022 14:52:03 +0000 (GMT)
From:   "Sungjong Seo" <sj1557.seo@samsung.com>
To:     "'Tadeusz Struk'" <tadeusz.struk@linaro.org>,
        <linkinjeon@kernel.org>
Cc:     <linux-fsdevel@vger.kernel.org>, <stable@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>,
        <syzbot+a4087e40b9c13aad7892@syzkaller.appspotmail.com>,
        <sj1557.seo@samsung.com>
In-Reply-To: <20220511185909.175110-2-tadeusz.struk@linaro.org>
Subject: RE: [PATCH v2 2/2] exfat: check if cluster num is valid
Date:   Sun, 15 May 2022 23:52:03 +0900
Message-ID: <000101d8686b$56d88750$048995f0$@samsung.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Mailer: Microsoft Outlook 15.0
Thread-Index: AQF3Brc3FXm9T2wCvxI2g4ISsAr4jwHO2GdrArq74xStvnjDkA==
Content-Language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrNJsWRmVeSWpSXmKPExsWy7bCmge4U4cYkgycX1SwmTlvKbLFn70kW
        i8u75rBZbPl3hNViwcZHjBbPbk5gtnjw8D+rA7vHplWdbB53ru1h8+jbsorRY+ZbNY/Pm+QC
        WKMaGG0Si5IzMstSFVLzkvNTMvPSbZVCQ9x0LZQUMvKLS2yVog0NjfQMDcz1jIyM9IwtY62M
        TJUU8hJzU22VKnShepUUipILgGpzK4uBBuSk6kHF9YpT81IcsvJLQU7XK07MLS7NS9dLzs9V
        UihLzCkFGqGkn/CNMWPxz+eMBTfEK67/ecrYwDhHpIuRk0NCwETi4LXJjF2MXBxCAjsYJRb2
        PYByPjFKfJm9lhnC+cwo8WHdM7YuRg6wlknHtSHiuxglTt2fyw7hvGSUmPp6MRvIXDYBXYkn
        N34yg9giAp4SDR/mg41lFtjGKNG8fCkrSIJTwF7iy89DLCC2sICDxL47s9lBbBYBVYkd36aB
        2bwClhI3OvcyQ9iCEidnPgGrZxaQl9j+dg4zxBMKErs/HWWFWOYksX5lHzNEjYjE7M42sBck
        BKZySCy7NJEFosFF4s2q96wQtrDEq+Nb2CFsKYmX/W1QdjPQpY1GEHYHo8TTjbIQ79tLvL9k
        AWIyC2hKrN+lD1GhKLHz91xGCFtQ4vS1bqgT+CTefe1hhejklehoE4IoUZH4/mEnywRG5VlI
        HpuF5LFZSB6YhbBsASPLKkax1ILi3PTUYsMCI+T43sQITrdaZjsYJ739oHeIkYmD8RCjBAez
        kgivQUVDkhBvSmJlVWpRfnxRaU5q8SHGZGBQT2SWEk3OByb8vJJ4QxNjAwMjYDI0tzQ3JkLY
        0sDEzMjEwtjS2ExJnHfVtNOJQgLpiSWp2ampBalFMFuYODilGpjY6lzYrJOehTLXzH8sIvj2
        2talKXWLV04Vu5Y+i037w/MSf1eVQoWCjV2dE+uP+UpbR7iuFL4pZz1/3t3Nzze+84jZvM2j
        8aPlwqtid7bL2xtaewVGy/3f+GZ1SZfLGfu99+3/e567Ldlpco35cl/uNO2+Vye11lrHXpnW
        pP+7uv+2wr/aO5Krnl7ICRaaP1HC6bH40mVd+ZHPfOK+3PAx6GZefKXeZEZm0tyFuifjvNfs
        PLv+y+W2lMVTN3o81D6/8rwYt3OCi8SuSZfc2fqiZG0XmFrWzF6WxHjj1nHbuX8Mvr448uO9
        wcUO1TAfw8UnzZZdrDhg2z2TMXkyp0/MS1uvlRYLVy3/IHG1Ol5QiaU4I9FQi7moOBEA7vO8
        Wm4EAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrHLMWRmVeSWpSXmKPExsWy7bCSnO5k4cYkgzcb1SwmTlvKbLFn70kW
        i8u75rBZbPl3hNViwcZHjBbPbk5gtnjw8D+rA7vHplWdbB53ru1h8+jbsorRY+ZbNY/Pm+QC
        WKO4bFJSczLLUov07RK4Mhb/fM5YcEO84vqfp4wNjHNEuhg5OCQETCQmHdfuYuTkEBLYwSgx
        pTELIiwlcXCfJoQpLHH4cHEXIxdQxXNGiVl325lAytkEdCWe3PjJDGKLCHhLvDzYyQpSxAwy
        5tquF2wQHYcZJV7seQpWxSlgL/Hl5yEWEFtYwEFi353Z7CA2i4CqxI5v08BsXgFLiRude5kh
        bEGJkzOfsIBcwSygJ9G2kREkzCwgL7H97RywEgkBBYndn46yQhzhJLF+ZR8zRI2IxOzONuYJ
        jMKzkEyahTBpFpJJs5B0LGBkWcUomVpQnJueW2xYYJSXWq5XnJhbXJqXrpecn7uJERxFWlo7
        GPes+qB3iJGJg/EQowQHs5IIr0FFQ5IQb0piZVVqUX58UWlOavEhRmkOFiVx3gtdJ+OFBNIT
        S1KzU1MLUotgskwcnFINTMKKClFnj0v2zXJWXWpSFvGKc6nJ5qVcj+1Ovy9O/pvAw2PWHzn3
        ptuEC3cULzo4neSovWs+fV203yl283eb9X+dedPp7CHtXF672yemQUXNqC5E99s7zWDLC2oa
        MdM/XHc4m230XvhS1+ac50sK/n5emfmaK+NP8zOVUvN/37ILLnEpHv1Q3OgmqWXWkFVlamqV
        E6u8jdtt817Xv1oTZrxY4B/IN1MxefuEn4ac/dsUd52MYzh+STNb5YJTsOrePCm1NwtLHh7f
        0bpVynfCqwPZfz7m/u3+qhdQtVHa27Hr3xXZV0dY1ncsnDDtcerzVVsl2s66LVbMvblVb9f1
        J84F+58vYk2OOT0vJfbTBSWW4oxEQy3mouJEAASdrIURAwAA
X-CMS-MailID: 20220515145203epcas1p26cb049179c6116ecf6f0316f61f793d5
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: SVC_REQ_APPROVE
X-ArchiveUser: EV
CMS-TYPE: 101P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20220511185940epcas1p1e51c30e41ff82ae642f8f949ffa4b189
References: <20220511185909.175110-1-tadeusz.struk@linaro.org>
        <CGME20220511185940epcas1p1e51c30e41ff82ae642f8f949ffa4b189@epcas1p1.samsung.com>
        <20220511185909.175110-2-tadeusz.struk@linaro.org>
X-Spam-Status: No, score=-4.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

> Syzbot reported slab-out-of-bounds read in exfat_clear_bitmap.
> This was triggered by reproducer calling truncute with size 0, which
> causes the following trace:
> 
> BUG: KASAN: slab-out-of-bounds in exfat_clear_bitmap+0x147/0x490
> fs/exfat/balloc.c:174 Read of size 8 at addr ffff888115aa9508 by task syz-
> executor251/365
> 
> Call Trace:
>  __dump_stack lib/dump_stack.c:77 [inline]  dump_stack_lvl+0x1e2/0x24b
> lib/dump_stack.c:118
>  print_address_description+0x81/0x3c0 mm/kasan/report.c:233
> __kasan_report mm/kasan/report.c:419 [inline]
>  kasan_report+0x1a4/0x1f0 mm/kasan/report.c:436
>  __asan_report_load8_noabort+0x14/0x20 mm/kasan/report_generic.c:309
>  exfat_clear_bitmap+0x147/0x490 fs/exfat/balloc.c:174
>  exfat_free_cluster+0x25a/0x4a0 fs/exfat/fatent.c:181
>  __exfat_truncate+0x99e/0xe00 fs/exfat/file.c:217
>  exfat_truncate+0x11b/0x4f0 fs/exfat/file.c:243
>  exfat_setattr+0xa03/0xd40 fs/exfat/file.c:339
>  notify_change+0xb76/0xe10 fs/attr.c:336
>  do_truncate+0x1ea/0x2d0 fs/open.c:65
> 
> Add checks to validate if cluster number is within valid range in
> exfat_clear_bitmap() and exfat_set_bitmap()
> 
> Cc: Namjae Jeon <linkinjeon@kernel.org>
> Cc: Sungjong Seo <sj1557.seo@samsung.com>
> Cc: linux-fsdevel@vger.kernel.org
> Cc: stable@vger.kernel.org
> Cc: linux-kernel@vger.kernel.org
> 
> Link: https://protect2.fireeye.com/v1/url?k=24a746d8-45dcec51-24a6cd97-
> 74fe48600034-8e4653a49a463f3c&q=1&e=0efc824d-6463-4253-9cd7-
> ce3199dbf513&u=https%3A%2F%2Fsyzkaller.appspot.com%2Fbug%3Fid%3D50381fc738
> 21ecae743b8cf24b4c9a04776f767c
> Reported-by: syzbot+a4087e40b9c13aad7892@syzkaller.appspotmail.com
> Fixes: 1e49a94cf707 ("exfat: add bitmap operations")
> Signed-off-by: Tadeusz Struk <tadeusz.struk@linaro.org>

Looks good.
And it seems that WARN_ON() is no longer needed.

Reviewed-by: Sungjong Seo <sj1557.seo@samsung.com>

> ---
> v2:
>  - Use is_valid_cluster() helper to validate clu
> ---
>  fs/exfat/balloc.c | 6 ++++++
>  1 file changed, 6 insertions(+)
> 
> diff --git a/fs/exfat/balloc.c b/fs/exfat/balloc.c index
> 03f142307174..92f5b5b5a0d0 100644
> --- a/fs/exfat/balloc.c
> +++ b/fs/exfat/balloc.c
> @@ -149,6 +149,9 @@ int exfat_set_bitmap(struct inode *inode, unsigned int
> clu, bool sync)
>  	struct exfat_sb_info *sbi = EXFAT_SB(sb);
> 
>  	WARN_ON(clu < EXFAT_FIRST_CLUSTER);
> +	if (!is_valid_cluster(sbi, clu))
> +		return -EINVAL;
> +
>  	ent_idx = CLUSTER_TO_BITMAP_ENT(clu);
>  	i = BITMAP_OFFSET_SECTOR_INDEX(sb, ent_idx);
>  	b = BITMAP_OFFSET_BIT_IN_SECTOR(sb, ent_idx); @@ -167,6 +170,9 @@
> void exfat_clear_bitmap(struct inode *inode, unsigned int clu, bool sync)
>  	struct exfat_mount_options *opts = &sbi->options;
> 
>  	WARN_ON(clu < EXFAT_FIRST_CLUSTER);
> +	if (!is_valid_cluster(sbi, clu))
> +		return;
> +
>  	ent_idx = CLUSTER_TO_BITMAP_ENT(clu);
>  	i = BITMAP_OFFSET_SECTOR_INDEX(sb, ent_idx);
>  	b = BITMAP_OFFSET_BIT_IN_SECTOR(sb, ent_idx);
> --
> 2.36.1


