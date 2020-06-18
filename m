Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A27CB1FF069
	for <lists+stable@lfdr.de>; Thu, 18 Jun 2020 13:20:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729461AbgFRLUG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 18 Jun 2020 07:20:06 -0400
Received: from sonic316-8.consmr.mail.gq1.yahoo.com ([98.137.69.32]:43632 "EHLO
        sonic316-8.consmr.mail.gq1.yahoo.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729402AbgFRLUE (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 18 Jun 2020 07:20:04 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=aol.com; s=a2048; t=1592479203; bh=dxLr5Sac0lejPsIBqUUe96IPZz24J89p+FcMiUYdm/s=; h=From:To:Cc:Subject:Date:References:From:Subject; b=IdjASJHxuiD+tymW+DPVdxsWgbi1J+uj+R5xOg+aU3JxynB/ukTsVvnGq7fS2cXF+jHlic8ZgBxFwsm4H3CEooTFyAzO+rN5gc0td0Wol0JDZKSRYprje1yXoCqYwSk2Fcrwt7wXG5envMuRS49yvtY8SKB/rKcLqLzx7G0UKMY/TpACRpSCYkGZAJMSa+eIKU3tNhSjlfN3EQlCvKA5tBroNUCg6zeLVZcF0gofL6u4h788UeFndVAJwRon1uQuRcrRkd01iRVrlCRV/lEjiGMnSXNnIODAJ3BIQMXmc+KhSOXMmW8p3zsTbJspZiZGpKSfEeOf4e0mSi0A6JCZ+w==
X-YMail-OSG: B22.dV4VM1kVZzmBsXXUQgjdYN358GoSAxGLH_QYMWwz_W0kwgJe1fpVoD1On37
 NUPN84WnwyO_peJQbJ4l.f8xHladpKR76K.GgSb7fSeZKoDewHuPCebf3Z_2mS1oekR.HbaVFrVz
 5S62sP2lrLQUV32hMb_CMGf5LgxLBydZCr1_LC_s4rvjtIDUTvw7bxwh.t6qYghuSldy88Y2BIe3
 TfYbbmaTqEztLRENPoK26sLYlILdvBn6qWJDODoP_4QHmVdZQ8SMSM2E22q_hQX9pNkOY9FYl69P
 Mj.HJQG7YAgxydLXDd9VxhLYWkrJ433fgaQx8dnftPVYtZHMwrpj1Oaq480lWvgUTUNHfx34Kl8L
 5oeWjRFiv3ZhNKfSoT5CpjzPF4RtODvC0moYOO2z9gkdFunuR.liqknL3bdmwPJELOhqlbfjguFZ
 my7ENcBXQmD8VdtLJfBhOCvyeMfD5lwZD1dNeaWNxiMTAsnIc96gWeTbEWGhsnT0XcKk68wR5tQM
 PDofUkv90IQYlx.E0moQCt7TEJ.P66vuGLCNJU.fk570vq2MMC61NbIKQMd4BKtEGVgPP.kwvXlV
 ONecITZhZYreKuwafqQnzIY38Q2NmVVFahTfgCXttiUf.ykOTFAMgmGQ5f40_bfQkeLTKk8DJPwK
 i8b8jqWuFI34R45wfeDSGwNFgpwaFQBr3yTkrAe9wP3wZPz2L94gZFZW81IfEDMqmmWpAb9FC.Kh
 vGE0bGAY69giUGQNEj1wtsR9k3PIh.CLtnTHM_1hP6dSewAUwFpMxGllNTXU1s7FZSrXIc160anO
 uR89DT6hLLOG.4RRuAmiA.SDLKqw0oIJKwuXrzCzgCFHNAzl_YCPlOLQNgEOrWBOGkHqDBC5vt_S
 7BwYfw.M7wjhvjfORXsS.ibeSTVNRM_BDL62U.gao7Nhw4HGKQNP4jWQ2xXnXf.RkVh59V77kXVa
 xJO_VSl6wrmLhxrPwRS59vFSCeYD5wQjKEacsFhNYB7WoJEVp4jQaWFDxi5OSU17t7ibvsEkm5YK
 0o8mwe2TJUUKGYvnHIBbdtg.clpFi6tJFp6Xf_dxkaB_lyx.dSbSRYZWD54Usba19RlCU_zTJrZl
 82f01LA7zkFae8p.MxLzjIDZtMyffycGmFaQPzNoaZmaqaAGc3LaDgQWMgEElzyrtXV5zYhwYeGV
 RwIqVvrWmlYNXykFoC4lwoiF49V6Aguoy.hdBh23ECjIGdzNypbe.ldq3hkoWeh7VqZo0JcjJuJr
 mfYlsUAKl7rAz6as0jOb3rI46rK3VVsGgO_WZWjX.WyE9I599Q1gQsSN.ZM8T2vWBN0LFdw7rJH.
 Is2HPYM9WTtu8PuiikhPaB_dq_S70ulOxgUiOsLxBF2BnBBtCb0o75nw0lx8X580tm3Oz8OT3U2p
 QlVg6esQqKR5sFRozNt60f4FUWouCa7I.
Received: from sonic.gate.mail.ne1.yahoo.com by sonic316.consmr.mail.gq1.yahoo.com with HTTP; Thu, 18 Jun 2020 11:20:03 +0000
Received: by smtp416.mail.gq1.yahoo.com (VZM Hermes SMTP Server) with ESMTPA ID be5fb830dad37ee084f7e0af79317143;
          Thu, 18 Jun 2020 11:20:01 +0000 (UTC)
From:   Gao Xiang <hsiangkao@aol.com>
To:     linux-erofs@lists.ozlabs.org, Chao Yu <yuchao0@huawei.com>
Cc:     Chao Yu <chao@kernel.org>, Li Guifu <bluce.liguifu@huawei.com>,
        Fang Wei <fangwei1@huawei.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Gao Xiang <hsiangkao@redhat.com>,
        Hongyu Jin <hongyu.jin@unisoc.com>, stable@vger.kernel.org
Subject: [PATCH] erofs: fix partially uninitialized misuse in z_erofs_onlinepage_fixup
Date:   Thu, 18 Jun 2020 19:19:36 +0800
Message-Id: <20200618111936.19845-1-hsiangkao@aol.com>
X-Mailer: git-send-email 2.24.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
References: <20200618111936.19845-1-hsiangkao.ref@aol.com>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Gao Xiang <hsiangkao@redhat.com>

Hongyu reported "id != index" in z_erofs_onlinepage_fixup() with
specific aarch64 environment easily, which wasn't shown before.

After digging into that, I found that high 32 bits of page->private
was set to 0xaaaaaaaa rather than 0 (due to z_erofs_onlinepage_init
behavior with specific compiler options). Actually we only use low
32 bits to keep the page information since page->private is only 4
bytes on most 32-bit platforms. However z_erofs_onlinepage_fixup()
uses the upper 32 bits by mistake.

Let's fix it now.

Reported-by: Hongyu Jin <hongyu.jin@unisoc.com>
Fixes: 3883a79abd02 ("staging: erofs: introduce VLE decompression support")
Cc: <stable@vger.kernel.org> # 4.19+
Signed-off-by: Gao Xiang <hsiangkao@redhat.com>
---
 fs/erofs/zdata.h | 20 +++++++++++---------
 1 file changed, 11 insertions(+), 9 deletions(-)

diff --git a/fs/erofs/zdata.h b/fs/erofs/zdata.h
index 7824f5563a55..92fbc0f0ba85 100644
--- a/fs/erofs/zdata.h
+++ b/fs/erofs/zdata.h
@@ -144,22 +144,24 @@ static inline void z_erofs_onlinepage_init(struct page *page)
 static inline void z_erofs_onlinepage_fixup(struct page *page,
 	uintptr_t index, bool down)
 {
-	unsigned long *p, o, v, id;
+	union z_erofs_onlinepage_converter u;
+	int orig, orig_index, val;
+
 repeat:
-	p = &page_private(page);
-	o = READ_ONCE(*p);
+	u.v = &page_private(page);
+	orig = atomic_read(u.o);
 
-	id = o >> Z_EROFS_ONLINEPAGE_INDEX_SHIFT;
-	if (id) {
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

