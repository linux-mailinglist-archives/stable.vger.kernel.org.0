Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4A37E209979
	for <lists+stable@lfdr.de>; Thu, 25 Jun 2020 07:26:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389754AbgFYF0f (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 25 Jun 2020 01:26:35 -0400
Received: from sonic308-8.consmr.mail.gq1.yahoo.com ([98.137.68.32]:43626 "EHLO
        sonic308-8.consmr.mail.gq1.yahoo.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2389753AbgFYF0e (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 25 Jun 2020 01:26:34 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=aol.com; s=a2048; t=1593062794; bh=UI3MnVRcoC7IXe6/MF3z2voS16XTSftvJq41/v0i0mQ=; h=From:To:Cc:Subject:Date:References:From:Subject; b=q+FLrgcNq9vG8GAxW9nvdywce0SSUTQus1YoFMCEPcxjO6ebYukowjfltl7oQomoc5Q7LiaIOiDNd2MbVxtmY6r2Vftgmt1bvLeTlw2aguYVrBdDFUHF8fQ9kig6+MNcu82R9zTlLeEZz+COaVqx+9NO+8NclLcOR+wVu8cPDeS8KNhsZTkpnzxkujL2P/yz+CaWHvC9wj9lpE0XM/rWY8vw6b+csDmYBg34U8pxPnIgWwJYtyMSsQO45LBj5DVayy8OAJmJEDxOZvVWjGkWiRXK9Ye6xDN5n018oJfbxnnTXn0mw64rBVDLbtqVGkxWc+g1/bY4kC7bkxtl6VDSMg==
X-YMail-OSG: bsdlrlgVM1mkmtWAtBgP9cd7AhcmSERQIEcd2YkdBf.6gO4emVzjvB2dLmUFp8r
 cjny56dghxTfkipUFC6.qaE301sz9IPqjVuRndFGBZ8mBVdcD2Iqf3SWeqdGxbpwl.I77lAhGc_B
 LQ9naH_UKJYbWqZLqrDXMK3tYqfwT43G4iqxmVkOGkEGPUfL4I2JSj3hpZgNo07Ec2QrgPLRpM2A
 NRcxZ5811BcyCae3uFFyxKjyt3SvNkbY0pH6KiFo_RbwfchbeABwU0mIZ46SToRQnduLM5ZcXD3I
 GFEi0uAMe5KZ52pCUi7E0zOTexz4nP6WLcie1bGmJqb1YmmnOw8uUiy4xihO6M3lpF3_.K8_vnhw
 1UFrUBXJ0Bwv_b8CQG_RMhWC99KIkNr6NZ2z2vjf5qKl6noXFuf54c2afLbxQHzO4V_QS9jKobKr
 MV2qd4fbaMeoEkMYFhCTc1p7wHPgXVFiKUYLtziXnelQb1itno0u6Ii0Z7xrAFEw.expXc5ZNi1j
 TdMksTyzUP9rfh9i_MzUUN8aLbhHZc2Je.qHbkffDuEapCJ0BiwT.JFr.PU7bNkxCoeFOoU0d9k3
 M7L4OPaxK4FwcOygWJdMLcKyv5j1l7Od.Et9Q9R6B1iv9CclUE5pbh._nh4rVzy.Y_ANVNFVK6Wh
 1L9DjEgUJ_rAOmcH2VAa44xD_Vci73YuFCJcHjOwGxgJweYQbG0wg.7IPfScGCz3IF6OYWBa0YIL
 LMRItIqaov8NPZEAIkSSZBqwvLdYEi4xSsT5VilBlsZ6yNjfZPC5nIaLcBntjvfRlB3fFFi2i8Cx
 HJ4geP6EqOrqjX3GMHxGZnK2q9TOu28fRU9TH8GGE.ReLgDSI_wHSEyHRxGHXnlqpzpy.9OZ1Uet
 6UuSECRy2lYpxLL3Cepusfs0cz4SRvX_GcDAKiVdMFlGJX01UAVXyRnI5oN.P.INUfY6EKN34mFA
 fJeg6t6hhwLJp3N5zoiKAFm5Vv2_BBnTAwXIRfhIaqXztduINazwS_D9R4sT5QRmq1NVmQMjLh1L
 LzM4DoSqWXtpw4kbwO1XsCY9E15J5AhLhbdri3lnEZ2BOJ57ofyx6O4NUd2vwRpYfje91YX9U8xq
 1MgcmW3WMb1kDSx10794rWiETZLyPf7xBTuoGqp35K8HVcnZ.SUqUfrk4sqZWnTQXyVtxYvCxbXW
 d7jfkloEzhFR3cOggEviexMQjQYnE2O.OgIPVPX2CmWwo0.ZSdlCNnO8OPXZ7uRuByHRmuQGAT9l
 cooqJzFXJ0BR9WX1PDHS.5u1fq1ICoOKLoNrqdKSudbsJOhdSvvaDCHm0FfhD_6AgraWuh4TuLK2
 SS8wuamo5utNLN448QDdvff7CpYuPykX5dQXpL7EDDdMr0_OEjvsCUbR1F2TwF6xlLimOkxwOnNt
 _pQbABiWGWC1j245qO6II2T1BWsUKsltFFaA-
Received: from sonic.gate.mail.ne1.yahoo.com by sonic308.consmr.mail.gq1.yahoo.com with HTTP; Thu, 25 Jun 2020 05:26:34 +0000
Received: by smtp413.mail.gq1.yahoo.com (VZM Hermes SMTP Server) with ESMTPA ID 834819637f2457c34ebb73ab79a37a10;
          Thu, 25 Jun 2020 05:26:31 +0000 (UTC)
From:   Gao Xiang <hsiangkao@aol.com>
To:     stable@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-erofs@lists.ozlabs.org, LKML <linux-kernel@vger.kernel.org>,
        Gao Xiang <hsiangkao@redhat.com>,
        Hongyu Jin <hongyu.jin@unisoc.com>,
        Chao Yu <yuchao0@huawei.com>
Subject: [PATCH 5.7.y] erofs: fix partially uninitialized misuse in z_erofs_onlinepage_fixup
Date:   Thu, 25 Jun 2020 13:26:18 +0800
Message-Id: <20200625052618.2316-1-hsiangkao@aol.com>
X-Mailer: git-send-email 2.24.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
References: <20200625052618.2316-1-hsiangkao.ref@aol.com>
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
The same as 5.4.y.

 fs/erofs/zdata.h | 20 ++++++++++----------
 1 file changed, 10 insertions(+), 10 deletions(-)

diff --git a/fs/erofs/zdata.h b/fs/erofs/zdata.h
index 7824f5563a55..9b66c28b3ae9 100644
--- a/fs/erofs/zdata.h
+++ b/fs/erofs/zdata.h
@@ -144,22 +144,22 @@ static inline void z_erofs_onlinepage_init(struct page *page)
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
 
-		DBG_BUGON(id != index);
+		DBG_BUGON(orig_index != index);
 	}
 
-	v = (index << Z_EROFS_ONLINEPAGE_INDEX_SHIFT) |
-		((o & Z_EROFS_ONLINEPAGE_COUNT_MASK) + (unsigned int)down);
-	if (cmpxchg(p, o, v) != o)
+	val = (index << Z_EROFS_ONLINEPAGE_INDEX_SHIFT) |
+		((orig & Z_EROFS_ONLINEPAGE_COUNT_MASK) + (unsigned int)down);
+	if (atomic_cmpxchg(u.o, orig, val) != orig)
 		goto repeat;
 }
 
-- 
2.24.0

