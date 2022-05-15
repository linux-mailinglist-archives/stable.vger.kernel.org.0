Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1263B52781F
	for <lists+stable@lfdr.de>; Sun, 15 May 2022 16:38:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234945AbiEOOiV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 15 May 2022 10:38:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38602 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234262AbiEOOiU (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 15 May 2022 10:38:20 -0400
Received: from mailout1.samsung.com (mailout1.samsung.com [203.254.224.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 471321401B
        for <stable@vger.kernel.org>; Sun, 15 May 2022 07:38:18 -0700 (PDT)
Received: from epcas1p4.samsung.com (unknown [182.195.41.48])
        by mailout1.samsung.com (KnoxPortal) with ESMTP id 20220515143814epoutp0150649c23b7eb7da052e78ed982ac881e~vTiGph-Fb1407914079epoutp01z
        for <stable@vger.kernel.org>; Sun, 15 May 2022 14:38:14 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout1.samsung.com 20220515143814epoutp0150649c23b7eb7da052e78ed982ac881e~vTiGph-Fb1407914079epoutp01z
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1652625494;
        bh=7RsPuR6maoTSQ3xD/FzglrkwUTukPTBdJ2U8wdye52o=;
        h=From:To:Cc:In-Reply-To:Subject:Date:References:From;
        b=P2oFmD1eBKLlV+VbfKs0HoR7h7Wp4ZDxyifkp/fmlrQVUqPI09iA0YLT5FRi8LwFA
         vuQULIYZDPxxJqS/iQlI3lKzqDdkJJzBRobQ72ZDf5UVEGwF0CVbNXuuUwM2q4GBBt
         yEORxywXLrKJ81NZ9EFbKwz1/Dm6wwzwQp039RE0=
Received: from epsnrtp1.localdomain (unknown [182.195.42.162]) by
        epcas1p4.samsung.com (KnoxPortal) with ESMTP id
        20220515143813epcas1p4f322632a98f6906e8cb2a7602215245b~vTiFRL2G_1901619016epcas1p45;
        Sun, 15 May 2022 14:38:13 +0000 (GMT)
Received: from epsmges1p3.samsung.com (unknown [182.195.36.226]) by
        epsnrtp1.localdomain (Postfix) with ESMTP id 4L1Q3S6zRsz4x9Pr; Sun, 15 May
        2022 14:38:12 +0000 (GMT)
Received: from epcas1p1.samsung.com ( [182.195.41.45]) by
        epsmges1p3.samsung.com (Symantec Messaging Gateway) with SMTP id
        D3.D7.10038.45011826; Sun, 15 May 2022 23:38:12 +0900 (KST)
Received: from epsmtrp2.samsung.com (unknown [182.195.40.14]) by
        epcas1p1.samsung.com (KnoxPortal) with ESMTPA id
        20220515143811epcas1p1c801016b8952f9102d723dc32b9f2669~vTiDvIeKY2746327463epcas1p1o;
        Sun, 15 May 2022 14:38:11 +0000 (GMT)
Received: from epsmgms1p2.samsung.com (unknown [182.195.42.42]) by
        epsmtrp2.samsung.com (KnoxPortal) with ESMTP id
        20220515143811epsmtrp2dbb99eb395622cc60d4aa9f68e41b5ed~vTiDrXXto1416314163epsmtrp2g;
        Sun, 15 May 2022 14:38:11 +0000 (GMT)
X-AuditID: b6c32a37-127ff70000002736-3b-628110540658
Received: from epsmtip1.samsung.com ( [182.195.34.30]) by
        epsmgms1p2.samsung.com (Symantec Messaging Gateway) with SMTP id
        56.D4.08924.35011826; Sun, 15 May 2022 23:38:11 +0900 (KST)
Received: from W10PB11329 (unknown [10.253.152.129]) by epsmtip1.samsung.com
        (KnoxPortal) with ESMTPA id
        20220515143811epsmtip1167796d618e2558a06dd2bb69342c084~vTiDgKOaf0777507775epsmtip1i;
        Sun, 15 May 2022 14:38:11 +0000 (GMT)
From:   "Sungjong Seo" <sj1557.seo@samsung.com>
To:     "'Tadeusz Struk'" <tadeusz.struk@linaro.org>,
        <linkinjeon@kernel.org>
Cc:     <linux-fsdevel@vger.kernel.org>, <stable@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <sj1557.seo@samsung.com>
In-Reply-To: <20220511185909.175110-1-tadeusz.struk@linaro.org>
Subject: RE: [PATCH v2 1/2] exfat: move is_valid_cluster to a common header
Date:   Sun, 15 May 2022 23:38:11 +0900
Message-ID: <000001d86869$66d66110$34832330$@samsung.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Mailer: Microsoft Outlook 15.0
Thread-Index: AQHMB4wnXVnWWJdAVeLcAg1Vsxu+wwF3Brc3rS0K6LA=
Content-Language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrAJsWRmVeSWpSXmKPExsWy7bCmrm6IQGOSwdIfBhYTpy1lttiz9ySL
        xeVdc9gstvw7wmqxYOMjRosHD/+zOrB5bFrVyeZx59oeNo++LasYPT5vkgtgiWpgtEksSs7I
        LEtVSM1Lzk/JzEu3VQoNcdO1UFLIyC8usVWKNjQ00jM0MNczMjLSM7aMtTIyVVLIS8xNtVWq
        0IXqVVIoSi4Aqs2tLAYakJOqBxXXK07NS3HIyi8FuVivODG3uDQvXS85P1dJoSwxpxRohJJ+
        wjfGjL/zb7IXPOCt+LZoMUsD43zuLkZODgkBE4mVjd3MXYxcHEICOxglNs6bxgbhfGKUmLti
        HQuE85lR4visD0wwLa0PtrFDJHYxSvxc9oAFJCEk8JJRYvmnVBCbTUBX4smNn8wgtoiAp0TD
        h/mMIDazQKVEx9cGdhCbU8Be4vblU2C2sIC3RO+7pWALWARUJe40/gDr5RWwlGjds5ANwhaU
        ODnzCQvEHHmJ7W/nMEMcpCCx+9NR1i5GDqBdVhJzbwhAlIhIzO5sA3tNQqCTQ2LS5RssEPUu
        EptaV0HZwhKvjm9hh7ClJD6/28sGYTczSjQ3GkHYHYwSTzfKgsyXALr5/SULEJNZQFNi/S59
        iApFiZ2/5zJC2IISp691M0OcwCfx7msPK0Qnr0RHmxBEiYrE9w87WSYwKs9C8tcsJH/NQvLA
        LIRlCxhZVjGKpRYU56anFhsWGCPH9iZGcGLVMt/BOO3tB71DjEwcjIcYJTiYlUR4DSoakoR4
        UxIrq1KL8uOLSnNSiw8xJgNDeiKzlGhyPjC155XEG5oYGxgYAROhuaW5MRHClgYmZkYmFsaW
        xmZK4ryrpp1OFBJITyxJzU5NLUgtgtnCxMEp1cAUYM1QfW+i9uXgE3Y5HpHr5MqfxvNP0Ll9
        S8X/+d5EGZELG5OjWTg0JqzXFswzWdrklnpH0+jsl4xpWfkFRzY0yP6+Ob0voXSuLruTYYti
        xpFohq7b3Xea1KUPuVU/cnRc+zHXdfWU6Z0fD3MsvHBNX1XoxK0NLf0zUplmpzif9ks+o6Ih
        LPAnpGsDR7OmdNXan62dDUFlRTYdZ083h2YvmneM+5ZP/e5biY63vqyR2s6bZ+jz55XtugdT
        mz4HH/CYWvrWgo/faL+3/tqYhJrMsjnKKjMmm4rPalcMyGvNXOPvVtGU/2NTsUnM8YXO0+4z
        5a+/u/xK88+W01zlzsZPdePfHPq+7lXk5wWTZiqxFGckGmoxFxUnAgCBqp/2YwQAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrKLMWRmVeSWpSXmKPExsWy7bCSnG6wQGOSwds2WYuJ05YyW+zZe5LF
        4vKuOWwWW/4dYbVYsPERo8WDh/9ZHdg8Nq3qZPO4c20Pm0ffllWMHp83yQWwRHHZpKTmZJal
        FunbJXBl/J1/k73gAW/Ft0WLWRoY53N3MXJySAiYSLQ+2MbexcjFISSwg1Fi5dmDjF2MHEAJ
        KYmD+zQhTGGJw4eLIUqeM0osP3uDHaSXTUBX4smNn8wgtoiAt8TLg52sIDazQK1E375brBAN
        ExglFj2cBdbAKWAvcfvyKTBbGKih991SJhCbRUBV4k7jD7BBvAKWEq17FrJB2IISJ2c+YQE5
        gllAT6JtIyPEfHmJ7W/nMEPcryCx+9NRVpASEQEribk3BCBKRCRmd7YxT2AUnoVk0CyEQbOQ
        DJqFpGMBI8sqRsnUguLc9NxiwwKjvNRyveLE3OLSvHS95PzcTYzgmNHS2sG4Z9UHvUOMTByM
        hxglOJiVRHgNKhqShHhTEiurUovy44tKc1KLDzFKc7AoifNe6DoZLySQnliSmp2aWpBaBJNl
        4uCUamDavsf6apGTsrG8r227kFVsW8iL3xuWptYrvU5Mv861wyhh2lzrxG8M2fOW3fVkCKzY
        sGP2rHl3ZaRbDS6unrMp/XSTZE5bg9WXGK3fPU+SRLf/Ws3FwRVcJ1V5seY1e3NxKX+Tzd/9
        nMnzvi/vnXCbcet6puLynUmWZt+V7L5Ls0W0HTn1zfcWx7uf/zZn7slS2+QjbLqfM3pC+PRm
        g2/5tUtvxM+cVxQTWXJu5tMLNxxmd5249Sn17gf/SX1hTyouMd7KnvYx6s6fr07dc/Lyvl6c
        e8xeZs0T9qn8ftvOTPRM/q5o7l6Qc0n7f+m27Ye3P7d6HbKl+cGWLLPMvYUW/acfaYZf73ll
        GuKhfktMiaU4I9FQi7moOBEAqEhp3wgDAAA=
X-CMS-MailID: 20220515143811epcas1p1c801016b8952f9102d723dc32b9f2669
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: SVC_REQ_APPROVE
X-ArchiveUser: EV
CMS-TYPE: 101P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20220511185940epcas1p3c5eb0603b969fe2753b4f16f6f8842a7
References: <CGME20220511185940epcas1p3c5eb0603b969fe2753b4f16f6f8842a7@epcas1p3.samsung.com>
        <20220511185909.175110-1-tadeusz.struk@linaro.org>
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

> Move the is_valid_cluster() helper from fatent.c to a common header to
> make it reusable in other *.c files.
> 
> Cc: Namjae Jeon <linkinjeon@kernel.org>
> Cc: Sungjong Seo <sj1557.seo@samsung.com>
> Cc: linux-fsdevel@vger.kernel.org
> Cc: stable@vger.kernel.org
> Cc: linux-kernel@vger.kernel.org
> 
> Signed-off-by: Tadeusz Struk <tadeusz.struk@linaro.org>

Looks good, thanks for your patch!

Reviewed-by: Sungjong Seo <sj1557.seo@samsung.com>

> ---
>  fs/exfat/exfat_fs.h | 6 ++++++
>  fs/exfat/fatent.c   | 6 ------
>  2 files changed, 6 insertions(+), 6 deletions(-)
> 
> diff --git a/fs/exfat/exfat_fs.h b/fs/exfat/exfat_fs.h index
> c6800b880920..42d06c68d5c5 100644
> --- a/fs/exfat/exfat_fs.h
> +++ b/fs/exfat/exfat_fs.h
> @@ -381,6 +381,12 @@ static inline int exfat_sector_to_cluster(struct
> exfat_sb_info *sbi,
>  		EXFAT_RESERVED_CLUSTERS;
>  }
> 
> +static inline bool is_valid_cluster(struct exfat_sb_info *sbi,
> +		unsigned int clus)
> +{
> +	return clus >= EXFAT_FIRST_CLUSTER && clus < sbi->num_clusters; }
> +
>  /* super.c */
>  int exfat_set_volume_dirty(struct super_block *sb);  int
> exfat_clear_volume_dirty(struct super_block *sb); diff --git
> a/fs/exfat/fatent.c b/fs/exfat/fatent.c index a3464e56a7e1..421c27353104
> 100644
> --- a/fs/exfat/fatent.c
> +++ b/fs/exfat/fatent.c
> @@ -81,12 +81,6 @@ int exfat_ent_set(struct super_block *sb, unsigned int
> loc,
>  	return 0;
>  }
> 
> -static inline bool is_valid_cluster(struct exfat_sb_info *sbi,
> -		unsigned int clus)
> -{
> -	return clus >= EXFAT_FIRST_CLUSTER && clus < sbi->num_clusters;
> -}
> -
>  int exfat_ent_get(struct super_block *sb, unsigned int loc,
>  		unsigned int *content)
>  {
> --
> 2.36.1


