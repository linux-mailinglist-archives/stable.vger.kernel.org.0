Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 456573B9971
	for <lists+stable@lfdr.de>; Fri,  2 Jul 2021 01:34:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234265AbhGAXhG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 1 Jul 2021 19:37:06 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:25507 "EHLO
        mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234260AbhGAXhF (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 1 Jul 2021 19:37:05 -0400
Received: from epcas1p1.samsung.com (unknown [182.195.41.45])
        by mailout1.samsung.com (KnoxPortal) with ESMTP id 20210701233433epoutp017233b7f9c89eb11fc57f0ba130e50590~NztlBJqzG2456824568epoutp01-
        for <stable@vger.kernel.org>; Thu,  1 Jul 2021 23:34:33 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout1.samsung.com 20210701233433epoutp017233b7f9c89eb11fc57f0ba130e50590~NztlBJqzG2456824568epoutp01-
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1625182473;
        bh=MR6i795Z9h2ZYoQAPlWh6TEORJYNBnsE5kTXALfg9uw=;
        h=From:To:Cc:In-Reply-To:Subject:Date:References:From;
        b=aeo9Xiesv//ZKRV9AEXbEf3TSK9Tb6O+FmLt0aWc/DCqtNn+ejewLcQ6yBgTKrA2l
         Bb0sGGiE4LpuT90xlkhN3H+/kFiYK2wjJVaXN2aDWxGNUPtdkX0CsHVyVYAteUPwZ9
         zriulDrQZUOkwfQKlbp2QUiwrHeOrWw/W74OCyFM=
Received: from epsnrtp4.localdomain (unknown [182.195.42.165]) by
        epcas1p4.samsung.com (KnoxPortal) with ESMTP id
        20210701233432epcas1p4871c75658a01c84d37c9e659ab2390c5~NztkpdhEr2277322773epcas1p4t;
        Thu,  1 Jul 2021 23:34:32 +0000 (GMT)
Received: from epsmges1p1.samsung.com (unknown [182.195.40.165]) by
        epsnrtp4.localdomain (Postfix) with ESMTP id 4GGF1358wfz4x9Pw; Thu,  1 Jul
        2021 23:34:31 +0000 (GMT)
Received: from epcas1p1.samsung.com ( [182.195.41.45]) by
        epsmges1p1.samsung.com (Symantec Messaging Gateway) with SMTP id
        75.64.09952.7015ED06; Fri,  2 Jul 2021 08:34:31 +0900 (KST)
Received: from epsmtrp1.samsung.com (unknown [182.195.40.13]) by
        epcas1p1.samsung.com (KnoxPortal) with ESMTPA id
        20210701233430epcas1p1dd9e84341c510b430d8d630ebd84551c~Nzti4zKA82257722577epcas1p1K;
        Thu,  1 Jul 2021 23:34:30 +0000 (GMT)
Received: from epsmgms1p1new.samsung.com (unknown [182.195.42.41]) by
        epsmtrp1.samsung.com (KnoxPortal) with ESMTP id
        20210701233430epsmtrp14f57b7e9ef1eb892ba7e062188b35235~Nzti4RWY23002130021epsmtrp1P;
        Thu,  1 Jul 2021 23:34:30 +0000 (GMT)
X-AuditID: b6c32a35-45dff700000026e0-15-60de5107fe49
Received: from epsmtip1.samsung.com ( [182.195.34.30]) by
        epsmgms1p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
        BE.96.08394.6015ED06; Fri,  2 Jul 2021 08:34:30 +0900 (KST)
Received: from namjaejeon01 (unknown [10.89.31.77]) by epsmtip1.samsung.com
        (KnoxPortal) with ESMTPA id
        20210701233430epsmtip1d5139340da171a7eb06d83a27798e9de~NztinLQOI0863508635epsmtip14;
        Thu,  1 Jul 2021 23:34:30 +0000 (GMT)
From:   "Namjae Jeon" <namjae.jeon@samsung.com>
To:     "'Chris Down'" <chris@chrisdown.name>
Cc:     <linux-fsdevel@vger.kernel.org>, <flrncrmr@gmail.com>,
        <stable@vger.kernel.org>
In-Reply-To: <YN4RoCAWq5SMXmaN@chrisdown.name>
Subject: RE: [PATCH] exfat: handle wrong stream entry size in
 exfat_readdir()
Date:   Fri, 2 Jul 2021 08:34:30 +0900
Message-ID: <014f01d76ed1$a3c843f0$eb58cbd0$@samsung.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Mailer: Microsoft Outlook 16.0
Thread-Index: AQHtYa6HDZ3zKB0Tzc4hP4i9K19tVAGye6HqApO4bbaq4KexkA==
Content-Language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrDKsWRmVeSWpSXmKPExsWy7bCmri574L0Egw+nZC0uzPvLbNG7dgGb
        xZ69J1ksFmx8xOjA4rHm2nVWj52z7rJ7fN4kF8AclWOTkZqYklqkkJqXnJ+SmZduq+QdHO8c
        b2pmYKhraGlhrqSQl5ibaqvk4hOg65aZA7RNSaEsMacUKBSQWFyspG9nU5RfWpKqkJFfXGKr
        lFqQklNgaFCgV5yYW1yal66XnJ9rZWhgYGQKVJmQk3F5YgdzwULJikn9S5gbGA+JdDFyckgI
        mEjMPrmXpYuRi0NIYAejxN+bzcwQzidGid63c9ggnG+MEtfOtLLCtEw5+p0RIrGXUaLv+BFW
        COcFo8SOc89ZQKrYBHQl/v3ZzwZiiwhoSjw/Mg+og4ODWSBUYnNzPUiYU0BPYm7PViYQW1jA
        X+LI6/OMIDaLgIrE1rlfWUDKeQUsJbrfs4OEeQUEJU7OfAI2nVlAXmL72znMEPcoSPx8uowV
        YpOTxKtdj6BqRCRmd7ZB1Xxll+i8qAZhu0iser6FEcIWlnh1fAs7hC0l8bK/Dcoulzhx8hcT
        hF0jsWHePnaQcyQEjCV6XpRAPKIpsX6XPkSFosTO33MZIbbySbz72sMKUc0r0dEmBFGiKtF3
        6TDUQGmJrvYP7BMYlWYh+WsWkr9mIbl/FsKyBYwsqxjFUguKc9NTiw0LDJFjehMjOBlqme5g
        nPj2g94hRiYOxkOMEhzMSiK8E6bfTRDiTUmsrEotyo8vKs1JLT7EaAoM6InMUqLJ+cB0nFcS
        b2hqZGxsbGFiZm5maqwkzruT7VCCkEB6YklqdmpqQWoRTB8TB6dUA9P+ZdWOz73mO+3wmL0u
        86BQg9uMsw8nGn4SPDqPI6jnzaG3NzU4s3x80jnP+6Q/zu1OP6q7typcb/mRKJu22NyzCZMZ
        nLd0R79aU7x/042ll8x3F23ove23au2Lp698P6TOkz7IkiKt9eXM9Ikpd9xusCpwtzH6al+P
        vXxHJPjySwMVYRnZXzfK0iXr72zdKbr71v01aWc58k0Zq+5GSf5vZVvMlbHRzcD7pGX/tqud
        m5NfXQ5oO7hCXTF8Kd+0GP2lwXN25O/6Iqg2d9qjNV5Plzx1emhS5PHg3Z/8AlM14ydGu9e7
        aZSeLFggcmnO356qitAVH8LjF4ma3zxn5vVL8pGfw72DH9W6Vxu+Ll2uxFKckWioxVxUnAgA
        8rbOVQ8EAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrOLMWRmVeSWpSXmKPExsWy7bCSnC5b4L0Eg6/7lS0uzPvLbNG7dgGb
        xZ69J1ksFmx8xOjA4rHm2nVWj52z7rJ7fN4kF8AcxWWTkpqTWZZapG+XwJVxeWIHc8FCyYpJ
        /UuYGxgPiXQxcnJICJhITDn6nbGLkYtDSGA3o8SEj/1MEAlpiWMnzjB3MXIA2cIShw8XQ9Q8
        Y5Q4vmcjO0gNm4CuxL8/+9lAbBEBTYnnR+YxgtjMAuESbdffsEI0rGeUOHdrJliCU0BPYm7P
        VrAFwgK+Eo9OfgOLswioSGyd+5UFZBmvgKVE93uw+bwCghInZz4BCzMDtbZthBovL7H97Rxm
        iDMVJH4+XcYKcYKTxKtdj1ggakQkZne2MU9gFJ6FZNIshEmzkEyahaRjASPLKkbJ1ILi3PTc
        YsMCw7zUcr3ixNzi0rx0veT83E2M4LjQ0tzBuH3VB71DjEwcjIcYJTiYlUR4J0y/myDEm5JY
        WZValB9fVJqTWnyIUZqDRUmc90LXyXghgfTEktTs1NSC1CKYLBMHp1QD07pz5e636xwnOGkK
        Vazb5cHqbVQ4l0tD6dfR3fOjagQuuZzz2euXMLVlQsOsALXF933K/uzXfVBun7tW8moZ46Y+
        fWOJ0om6C+qS9nadOXjm29sn2f37d6yvCnTgXPNh7et13xbvmLZ7qrRie41/ENudfdk9H3Ja
        38Ud1njFm/bFqLXyUV79/8bVjFo8VXu3T/niHecj72g03XHimg1/y20lZ5h/2bth1gJOmcyp
        c35/YNxfqj33v1qEOcNKr8b75229VlqsWLZ8at/tdeZN3Vf+qMdNMtvPJCEq94O3ftvSG4p3
        3FY2XX6bwPx1Q+W2OVqMHAt+cXour2PUWFxa92LCsRe6UasO9cx/oPi+fb0SS3FGoqEWc1Fx
        IgBNLPk4+gIAAA==
X-CMS-MailID: 20210701233430epcas1p1dd9e84341c510b430d8d630ebd84551c
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: SVC_REQ_APPROVE
CMS-TYPE: 101P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20210611004956epcas1p262dc7907165782173692d7cf9e571dfe
References: <CGME20210611004956epcas1p262dc7907165782173692d7cf9e571dfe@epcas1p2.samsung.com>
        <20210611004024.2925-1-namjae.jeon@samsung.com>
        <YN4RoCAWq5SMXmaN@chrisdown.name>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

> Namjae Jeon writes:
> >The compatibility issue between linux exfat and exfat of some camera
> >company was reported from Florian. In their exfat, if the number of
> >files exceeds any limit, the DataLength in stream entry of the
> >directory is no longer updated. So some files created from camera does
> >not show in linux exfat. because linux exfat doesn't allow that cpos
> >becomes larger than DataLength of stream entry. This patch check
> >DataLength in stream entry only if the type is ALLOC_NO_FAT_CHAIN and
> >add the check ensure that dentry offset does not exceed max dentries
> >size(256 MB) to avoid the circular FAT chain issue.
> >
> >Fixes: ca06197382bd ("exfat: add directory operations")
> >Cc: stable@vger.kernel.org # v5.9
> >Reported-by: Florian Cramer <flrncrmr@gmail.com>
> >Reviewed-by: Sungjong Seo <sj1557.seo@samsung.com>
> >Signed-off-by: Namjae Jeon <namjae.jeon@samsung.com>
> 
> Tested-by: Chris Down <chris@chrisdown.name>
Thanks for your test!
> 
> Thanks, I came across this while debugging why directories produced on my Fuji
> X-T4 were truncated at 2^12 dentries.
> 
> If the other report was also Fuji, maybe this is worth asking them to fix in firmware?
Well, I am not sure that they will respond to your report well. If you can
reproduce same issue even when plugging your exfat into windows, I think
that it is worth reporting to them.

> >---
> > fs/exfat/dir.c | 8 +++++---
> > 1 file changed, 5 insertions(+), 3 deletions(-)
> >
> >diff --git a/fs/exfat/dir.c b/fs/exfat/dir.c index
> >c4523648472a..f4e4d8d9894d 100644
> >--- a/fs/exfat/dir.c
> >+++ b/fs/exfat/dir.c
> >@@ -63,7 +63,7 @@ static void exfat_get_uniname_from_ext_entry(struct
> >super_block *sb,  static int exfat_readdir(struct inode *inode, loff_t
> >*cpos, struct exfat_dir_entry *dir_entry)  {
> > 	int i, dentries_per_clu, dentries_per_clu_bits = 0, num_ext;
> >-	unsigned int type, clu_offset;
> >+	unsigned int type, clu_offset, max_dentries;
> > 	sector_t sector;
> > 	struct exfat_chain dir, clu;
> > 	struct exfat_uni_name uni_name;
> >@@ -86,6 +86,8 @@ static int exfat_readdir(struct inode *inode, loff_t
> >*cpos, struct exfat_dir_ent
> >
> > 	dentries_per_clu = sbi->dentries_per_clu;
> > 	dentries_per_clu_bits = ilog2(dentries_per_clu);
> >+	max_dentries = (unsigned int)min_t(u64, MAX_EXFAT_DENTRIES,
> >+					   (u64)sbi->num_clusters << dentries_per_clu_bits);
> >
> > 	clu_offset = dentry >> dentries_per_clu_bits;
> > 	exfat_chain_dup(&clu, &dir);
> >@@ -109,7 +111,7 @@ static int exfat_readdir(struct inode *inode, loff_t *cpos, struct exfat_dir_ent
> > 		}
> > 	}
> >
> >-	while (clu.dir != EXFAT_EOF_CLUSTER) {
> >+	while (clu.dir != EXFAT_EOF_CLUSTER && dentry < max_dentries) {
> > 		i = dentry & (dentries_per_clu - 1);
> >
> > 		for ( ; i < dentries_per_clu; i++, dentry++) { @@ -245,7 +247,7 @@
> >static int exfat_iterate(struct file *filp, struct dir_context *ctx)
> > 	if (err)
> > 		goto unlock;
> > get_new:
> >-	if (cpos >= i_size_read(inode))
> >+	if (ei->flags == ALLOC_NO_FAT_CHAIN && cpos >= i_size_read(inode))
> > 		goto end_of_dir;
> >
> > 	err = exfat_readdir(inode, &cpos, &de);
> >--
> >2.17.1
> >

