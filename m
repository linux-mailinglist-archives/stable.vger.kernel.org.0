Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 525B620995B
	for <lists+stable@lfdr.de>; Thu, 25 Jun 2020 07:20:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389720AbgFYFT7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 25 Jun 2020 01:19:59 -0400
Received: from sonic313-21.consmr.mail.gq1.yahoo.com ([98.137.65.84]:38040
        "EHLO sonic313-21.consmr.mail.gq1.yahoo.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2389683AbgFYFT7 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 25 Jun 2020 01:19:59 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=aol.com; s=a2048; t=1593062398; bh=nNbuaihPm9AroQRBhAhelCSNPjnrx2O1HLOA95a0Tpc=; h=From:To:Cc:Subject:Date:References:From:Subject; b=JZLYbqBtckbSqh99naE4PZDvlo/BBokQhph46/oaqGM5Fi6OACDHIs0q0yMmhPvrOrxOi8EvHKHxusufvhHfjg2rSXgdyjwyuOlwhzmLPcVDu9W/fNdYBVqgaCjP4/GJNsVEmblhS1SFqG0BeG7yIptPdix8ukt+F+eyy/Af3YBvQpPqE+/1diaeIO3W+oCYecVoPK9drKmkchMkjccjDzN5NIxniFu8iSaYTpFqXN8FS+L69k3Olw2lWHsIQDKl+nRc9o5Rpu0YPMurxASTZSQCECTYdTmaFFRK8WsieSieHv2l9yRgg7bFtpW8JspxfPA8iXDoI9wzJYBUEo6btw==
X-YMail-OSG: G2xB2kwVM1lGJZBr8SL9gjGkCVNgX1RfQcr10RSUT8npVu5HiA0byqQCBnG90EJ
 0A3MG0mqWo41.N8N_tK9z5uIe73bu5.1SOuq7gmDfGaAQkek5IvU2csHcqyGgwcSWVnQxJNBqxoB
 n7XF._gqnGj3PUdmlDzjdVyFNQC89TP0cstcYDhwaQCNAIZWqynq7hxjCfi8Yq0XzT4It.8YnREo
 awBE6K4rw9HCPj9Mrl.TYYgbwwcA9gKLoC5YL87M7Qb_zReGmbqnLwZv_jPC5DjbFkJtZYPlQl16
 fgfWq6zmVxhmy7AsgaLJdHp1naiPZkkcmQH071oFOzCpPKK4n6dnQrn5R5LrEGp_W6YbPexCuaqo
 MMTg7tkyPX1wglob.hh8KDV5SjDePuXFMyZBzLwkCuheXc_KOkcSKc.03z1aCP0CdExYCH891GdW
 AjqSRzIpfdmxoDVAb_mVNmhxznBlhteVIu1iefj8NqJyd3L3oum0NIY2Zl2_ekIlLg4mIKiXWboO
 GZwK9KnXHo8MT18KQ1gBfHcgxAZphiUCdOgBO3tYZ_kJcCuTDYPSnrrYydhWbXMyKDsLVbIAj33m
 iED6POCONZtI7cHfT1h26NW2Quf5IChtf.0pjaOBUUjx7TC79hqTlD979aVHade9hfkR8hLdWmZt
 F4LAp8cymGbQz1rLFWEnkzgIaBXvj3mU.a2glVRpBj_TXoNrJAQvQSwhAZm6rOu6RAEOM04uDXiC
 .ltP8AiVbntejVMZrqhi6w04IZKwSjIR_z4OR6i3gY3JjHOHt3WkuoT7GNPKfwvAEZ8dwxByAJSk
 J8.pS.HPMA9CK9ZCUnW8B7B85JzBTsNRI3HyW6FLoZfq3n5_BMF0EGjSn.UIkszKIrgu5lhKPeWh
 EA_5.1FSBbVJvLi47PDg5SQ1xNfeOlnOLlLkA_DLVyIbC4lLMvCUdU1KgQWMDHqqQDyyDgxB8N4p
 px4uzgNtEsuAiVpEeyTKhzKxbA4obf93CPQGD1IdSVhxkjYF__A9Nii6Yz6EKendnJ5ciUGa3xAw
 bJDYuL1xuKHWlLAN.CynwLXHn8TE6qEhfQOUVw6MzJa4BgswUwmCSn9ZSyMvWBAZv7aZoHxNuxL.
 .yWcA6jie.6yGcGdcf7RfKT5EYjNFbBacjvNbglhvVNGhNTP0MULavaa9xb8jBFruBme5igP2_F1
 JxYFkHqAMU7VBCqcWpJlVl2yzugsb9zBz0S_qdfmB.z_ZaWb8oEPtRHG3uDsJl5lPO7iCtXQdCLL
 zklMiUNBTGoQYWRCuPYlQL.SC_swGtv.1XclY3kVpKqqPfUL7s.pHucmQOw0EZ_C3WdcBBS_51hs
 mthXSfzxgGQC3sRhn3N8zWD5vyGZjtrvr_oN91ovJDkvwOOWvsP7XA1TECXNLc3QyQuBx8J06ETX
 BWaifbZ1yhAOfbkKnJ6zp.pq3R9x0
Received: from sonic.gate.mail.ne1.yahoo.com by sonic313.consmr.mail.gq1.yahoo.com with HTTP; Thu, 25 Jun 2020 05:19:58 +0000
Received: by smtp420.mail.gq1.yahoo.com (VZM Hermes SMTP Server) with ESMTPA ID 168749c4308c8b7d943811892a3c5e51;
          Thu, 25 Jun 2020 05:19:57 +0000 (UTC)
From:   Gao Xiang <hsiangkao@aol.com>
To:     stable@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-erofs@lists.ozlabs.org, LKML <linux-kernel@vger.kernel.org>,
        Gao Xiang <hsiangkao@redhat.com>,
        Hongyu Jin <hongyu.jin@unisoc.com>,
        Chao Yu <yuchao0@huawei.com>
Subject: [PATCH 4.19.y] erofs: fix partially uninitialized misuse in z_erofs_onlinepage_fixup
Date:   Thu, 25 Jun 2020 13:19:39 +0800
Message-Id: <20200625051939.32454-1-hsiangkao@aol.com>
X-Mailer: git-send-email 2.24.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
References: <20200625051939.32454-1-hsiangkao.ref@aol.com>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Gao Xiang <hsiangkao@redhat.com>

commit 3c597282887fd55181578996dca52ce697d985a5 upstream.

Hongyu reported "id != index" in z_erofs_onlinepage_fixup() with
specific aarch64 environment easily, which wasn't shown before.

After digging into that, I found that high 32 bits of page->private
was set to 0xaaaaaaaa rather than 0 (due to z_erofs_onlinepage_init
behavior with specific compiler options). Actually we only use low
32 bits to keep the page information since page->private is only 4
bytes on most 32-bit platforms. However z_erofs_onlinepage_fixup()
uses the upper 32 bits by mistake.

Let's fix it now.

Reported-and-tested-by: Hongyu Jin <hongyu.jin@unisoc.com>
Fixes: 3883a79abd02 ("staging: erofs: introduce VLE decompression support")
Cc: <stable@vger.kernel.org> # 4.19+
Reviewed-by: Chao Yu <yuchao0@huawei.com>
Link: https://lore.kernel.org/r/20200618234349.22553-1-hsiangkao@aol.com
Signed-off-by: Gao Xiang <hsiangkao@redhat.com>
---
This fix has been merged into Linus's tree just now (today).
Since the patch could not directly be applied to 4.19, manually handle this.

 drivers/staging/erofs/unzip_vle.h | 20 ++++++++++----------
 1 file changed, 10 insertions(+), 10 deletions(-)

diff --git a/drivers/staging/erofs/unzip_vle.h b/drivers/staging/erofs/unzip_vle.h
index 684ff06fc7bf..630fd1f4f123 100644
--- a/drivers/staging/erofs/unzip_vle.h
+++ b/drivers/staging/erofs/unzip_vle.h
@@ -169,22 +169,22 @@ static inline void z_erofs_onlinepage_init(struct page *page)
 static inline void z_erofs_onlinepage_fixup(struct page *page,
 	uintptr_t index, bool down)
 {
-	unsigned long *p, o, v, id;
-repeat:
-	p = &page_private(page);
-	o = READ_ONCE(*p);
+	union z_erofs_onlinepage_converter u = { .v = &page_private(page) };
+	int orig, orig_index, val;
 
-	id = o >> Z_EROFS_ONLINEPAGE_INDEX_SHIFT;
-	if (id) {
+repeat:
+	orig = atomic_read(u.o);
+	orig_index = orig >> Z_EROFS_ONLINEPAGE_INDEX_SHIFT;
+	if (orig_index) {
 		if (!index)
 			return;
 
-		BUG_ON(id != index);
+		DBG_BUGON(orig_index != index);
 	}
 
-	v = (index << Z_EROFS_ONLINEPAGE_INDEX_SHIFT) |
-		((o & Z_EROFS_ONLINEPAGE_COUNT_MASK) + (unsigned)down);
-	if (cmpxchg(p, o, v) != o)
+	val = (index << Z_EROFS_ONLINEPAGE_INDEX_SHIFT) |
+		((orig & Z_EROFS_ONLINEPAGE_COUNT_MASK) + (unsigned int)down);
+	if (atomic_cmpxchg(u.o, orig, val) != orig)
 		goto repeat;
 }
 
-- 
2.24.0

