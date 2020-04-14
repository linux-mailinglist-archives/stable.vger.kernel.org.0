Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8F2D31A835D
	for <lists+stable@lfdr.de>; Tue, 14 Apr 2020 17:40:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2440621AbgDNPjd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 14 Apr 2020 11:39:33 -0400
Received: from sonic311-51.consmr.mail.ne1.yahoo.com ([66.163.188.232]:42544
        "EHLO sonic311-51.consmr.mail.ne1.yahoo.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2440613AbgDNPjV (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 14 Apr 2020 11:39:21 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=aol.com; s=a2048; t=1586878760; bh=vkB/clz6YmS8RFZV7y01FLVNhgwTckfRLpoP/PFDv7E=; h=From:To:Cc:Subject:Date:References:From:Subject; b=MgpgB8FvNs47shVCiWXXxTRhFh/dtZZrhmqouGN49gc2R1Hn3NdxngCoSHxXyUlT7Rf72oCsZWFs3RBZkGwUsRDerTjSLp7ObdOVQYOTaEEgqWrqmecLihWFK7bbo8OmmIoB9HPvtFrhsHOdFDd4T+MHonioBykLTqzuXWLHR7WPPEjLAd5WUEzdBkIOHAAqR7NtM6jCf43k4ui+S22ZiglTFbyFLlKlZ6lFDs4cBkWfnM9rhAr11pFRydSYaMPbGbbZXAfd+aU95vvsHiEfTpeCzDZg8HfSPWtYSlquYGsFy1l2ROXktcN6VpdPJJ9Rumh/483wNThaz/7tQpoPbQ==
X-YMail-OSG: gHkvCXAVM1kCZvdzvSiKCpNrU_3g5Uv.MuKB_Y0jW4kvT87rIpskPkLVxw_9KUF
 oqAUnzwC25V5rUOT6oxifMwXYO8OLaz0MciOGno9l5sppY5JpprLRI.8B5w4LKFvlEdwvdUJUoup
 BdJpGnnnEV7Ksr32hYqgn4JR_608qOLmAyESQTrYqKOT3nWF_Pzpp0XYCpwbKm_bbYiS2o58xRux
 AxN50dbjLYMpC7lCwkYthAMtheTEjhu.0WESN_uJcDWJrHtm8aEaPvEYoYEQR0Cmo.MNijQSG53o
 7UXPmK1UsmNg_uUn3Lnpo6ap2RZurAK2ubc_tGcs5TezaRj.KGtTKnezNR22fUkSkv2PLdbrHXzt
 Sh8xKgI78YuduMphIUGKafb2wrfJNfgQ15CXyGu7qxIVZtqDInuuycaiC0VPcO3nNY_0yZ79d0zo
 XCngaPKg8I1oTAnZXomrb.SNkq6ibz4ODsBMsRS1gVppsDgrupy6QNJo4ZJ9UcKc5JQLBnFQXGAS
 ZEgxpfiiVgzsQvW0szpwb2vs1ELSxzOPniwDvpb9YR4vm23QTRbtY283q_2S4R8HnTE612SrHK9b
 J0xic_awjHdGcyyDqF29k59t8F6ILaJbgr6D6TkpEUVXAaNmAuJSjHfjNxtUPOpndOwwx01gRkC_
 IL96zLhK07XFEZeT9t_K_xxc2V_HO78w.tx6AUp0IDY3r2JGeVsK.BofX7KzJHCRieUYFinNGs3l
 cfXZJ4bKoq4z8lI83nHrcIpTeLGvJKHNG_HMAf.Wh1y_O6p_8rGny28YSDAnxTp85jxVYvxECuXd
 7hhosr7Km1Ya95n.iqDUIJjiJEAQscXU3.0PlXYL5hxfFCaDenxFpr6N85I0SY1aqVYyvH7SBRmk
 jKSCG.KF5cPHaNmk9aCyVU.iONdza3yDTC6xu2KkxrcxnOvZpTc6ibQsBsDLq_mJppU5kgad.pG9
 5cMBfpXOnJpVxJ1fDyL9VNs.GxgK1Z1cOABGkpE9hmXahyqPap9NiGKJH66oNpkkTlAkfAtad3V8
 rlLWSQFrHURZj6ij_KB9myowrj0IyUX1faQupLN6pNJ9.68nyGCS95EE5NWd8Of3dqpmv_WN0mFL
 9ItkXJjOA5QMJgmExpAtidFKWxq9AVB9gpENuEI_5vegc7QaRqhUNgIUXANVeJE9emR8_zOi0fzx
 iZOimT4ROMQ3K6eyltU_KUU_q5SamZ1h8I1rcL3Y3PMaZkDQyNRlLog4ncnPszLcrbD0mRsiKPDl
 g7oiGzTMPv9baEDAtYwLkK3.xsTZcm_87xD_DgyVxXkG6E4WvpY3zwlxeCpm.wVBUd9DxxQg65Py
 qIwWLhwZlsFVeJHIrx6PPCM5X5Z7IezFpQVHgJCLpfKZrY6oEctJIIuANxmJTT3Ne_8amA0.b2s0
 7GId1Shbti9Y58pefAhZMfDex.AzlZZ3CxENxrupypSh1fcRxFKmEt.Inyj6SIdRX.Q6hWVBW_.W
 ORwM-
Received: from sonic.gate.mail.ne1.yahoo.com by sonic311.consmr.mail.ne1.yahoo.com with HTTP; Tue, 14 Apr 2020 15:39:20 +0000
Received: by smtp420.mail.gq1.yahoo.com (VZM Hermes SMTP Server) with ESMTPA ID a901f02470a3884c85e3d3dd55f951e5;
          Tue, 14 Apr 2020 15:37:18 +0000 (UTC)
From:   Gao Xiang <hsiangkao@aol.com>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        LKML <linux-kernel@vger.kernel.org>,
        linux-erofs@lists.ozlabs.org, Chao Yu <yuchao0@huawei.com>,
        Gao Xiang <gaoxiang25@huawei.com>
Subject: [PATCH 5.4.y] erofs: correct the remaining shrink objects
Date:   Tue, 14 Apr 2020 23:37:00 +0800
Message-Id: <20200414153700.28802-1-hsiangkao@aol.com>
X-Mailer: git-send-email 2.24.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
References: <20200414153700.28802-1-hsiangkao.ref@aol.com>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Gao Xiang <gaoxiang25@huawei.com>

commit 9d5a09c6f3b5fb85af20e3a34827b5d27d152b34 upstream.

The remaining count should not include successful
shrink attempts.

Fixes: e7e9a307be9d ("staging: erofs: introduce workstation for decompression")
Cc: <stable@vger.kernel.org> # 4.19+
Link: https://lore.kernel.org/r/20200226081008.86348-1-gaoxiang25@huawei.com
Reviewed-by: Chao Yu <yuchao0@huawei.com>
Signed-off-by: Gao Xiang <gaoxiang25@huawei.com>
---

trivial adaption, build verified.

 fs/erofs/utils.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/erofs/utils.c b/fs/erofs/utils.c
index d92b3e753a6f..3e28fd082df0 100644
--- a/fs/erofs/utils.c
+++ b/fs/erofs/utils.c
@@ -294,7 +294,7 @@ static unsigned long erofs_shrink_scan(struct shrinker *shrink,
 		spin_unlock(&erofs_sb_list_lock);
 		sbi->shrinker_run_no = run_no;
 
-		freed += erofs_shrink_workstation(sbi, nr, false);
+		freed += erofs_shrink_workstation(sbi, nr - freed, false);
 
 		spin_lock(&erofs_sb_list_lock);
 		/* Get the next list element before we move this one */
-- 
2.24.0

