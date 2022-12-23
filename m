Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5E378654992
	for <lists+stable@lfdr.de>; Fri, 23 Dec 2022 01:10:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235372AbiLWAKY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 22 Dec 2022 19:10:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42506 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231278AbiLWAKV (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 22 Dec 2022 19:10:21 -0500
Received: from out3-smtp.messagingengine.com (out3-smtp.messagingengine.com [66.111.4.27])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 062EA2315E;
        Thu, 22 Dec 2022 16:10:18 -0800 (PST)
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailout.nyi.internal (Postfix) with ESMTP id 722E55C011A;
        Thu, 22 Dec 2022 19:10:17 -0500 (EST)
Received: from mailfrontend2 ([10.202.2.163])
  by compute4.internal (MEProxy); Thu, 22 Dec 2022 19:10:17 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=tyhicks.com; h=
        cc:cc:content-transfer-encoding:date:date:from:from:in-reply-to
        :in-reply-to:message-id:mime-version:references:reply-to:sender
        :subject:subject:to:to; s=fm1; t=1671754217; x=1671840617; bh=TU
        q6QLAfgtkzRFmgm+1eHv8sP3D0VwkxRhMPteL5eRU=; b=jQ1Ho8O+fV6KYMif/M
        xtG8bmIxTiCYGIS2cit8HIiaePY8NDhLhFm3ROhswgkSWEltJcrFGHIVsMxfiBEn
        Ndu31gu7llLeBgHvGK3nA2XCuQH+wAUUw+3PGv1ihbfJ2LSzLVkjqVmIrzYqqCTy
        QKCHE4Yw0dr21XME2H+ZaBcP1VbxQvJsF4e02CUPHHg3uqKserLn3wFtAzelAYos
        sjeE8qpw7cxKjaAkSPXw00ET6xPIjOVVn0HkZNAs/VDXVvRCZkiJtQedbVhKXncC
        F3Dpj8KCJUX6m+yuuGahL6yhhhfOzAygAh3qhREE1pIxoFKwoKOA9XPFOSc+W36w
        EDAw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:cc:content-transfer-encoding:date:date
        :feedback-id:feedback-id:from:from:in-reply-to:in-reply-to
        :message-id:mime-version:references:reply-to:sender:subject
        :subject:to:to:x-me-proxy:x-me-proxy:x-me-sender:x-me-sender
        :x-sasl-enc; s=fm2; t=1671754217; x=1671840617; bh=TUq6QLAfgtkzR
        Fmgm+1eHv8sP3D0VwkxRhMPteL5eRU=; b=vPZeXw+fazvtT5Bn/tw8lVIxb9VCy
        FUmnCZCig0cx4f1aXy8UkP9c8UozVrBahRFCf4UhoqZ29p4mljFH19Xr5q3n7u4d
        bKhCy28nWgc+mApB6NkMc1eN9tg73Mr2c/cPwJ8LgT7RA7zL88kzq2yR2zbNwwOB
        YPwEvMG29QmE4zdvLjKMh2NRjfQRGKy0goRiRVCHjL4JYodytkPh3UbhvWJuWXqx
        bW/53ESeE/vYe3eQ4BIZMS6Biit/X4NLKWKoCqCQEE//YVIKhvoTUDHyqaPJTIJ6
        kxEpe17tizF3ZLMaifyEBk+xgCvWw0PYS/wScYHyUkYaU/Kq4cmel+Srw==
X-ME-Sender: <xms:6fGkY9FPBlrSNYcFH5RorfEB5sYBVbAwM6m1-1EtJz-hQZc5A1AIcg>
    <xme:6fGkYyXeBxs-lC18tAfdCsLtXEMONsEzqVGdA0cmR3jzMBa-mXCbZ9ZDgzocnmdeN
    w3EMoGeyCkl8Ff9slY>
X-ME-Received: <xmr:6fGkY_Ira2snfm8k8JVivCO5Fww48Ty_t879DUPoEMLJiwK9A8GSLsaqq4ALck0oy4u4uvzlZLNQnXuWHl7T>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvhedrhedugddulecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenuc
    fjughrpefhvfevufffkffojghfggfgsedtkeertdertddtnecuhfhrohhmpefvhihlvghr
    ucfjihgtkhhsuceotghouggvsehthihhihgtkhhsrdgtohhmqeenucggtffrrghtthgvrh
    hnpefhvddukeefleefffekuedvvdelheevkedugfefgedvfeffudfguedutdefueeujeen
    ucffohhmrghinhepkhgvrhhnvghlrdhorhhgnecuvehluhhsthgvrhfuihiivgeptdenuc
    frrghrrghmpehmrghilhhfrhhomheptghouggvsehthihhihgtkhhsrdgtohhm
X-ME-Proxy: <xmx:6fGkYzGOGKpsZXCU6FcxIXbIpbPHLp7g_s0HuQzFmVePnkI15DBSqg>
    <xmx:6fGkYzVVpEti1ySfNr0FKySmHq-lwi7AxxscB2UzQqXwEtnhEJ5g8w>
    <xmx:6fGkY-OBSN25SjwsFJrCWE45YKmEzW5PdDk2frRLhil4lzu41JhhVw>
    <xmx:6fGkY8OezonGRt2oEEULReFI7UugdxVuUvTUU9MK5EWoEi7XDp56LQ>
Feedback-ID: i78e14604:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Thu,
 22 Dec 2022 19:10:16 -0500 (EST)
From:   Tyler Hicks <code@tyhicks.com>
To:     gregkh@linuxfoundation.org, stable@vger.kernel.org
Cc:     Karolina Drobnik <karolinadrobnik@gmail.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Shuah Khan <shuah@kernel.org>, kvm@vger.kernel.org,
        linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org,
        Gavin Shan <gshan@redhat.com>, Marc Zyngier <maz@kernel.org>,
        Mike Rapoport <rppt@kernel.org>, Tyler Hicks <code@tyhicks.com>
Subject: [PATCH 5.15 1/2] tools/include: Add _RET_IP_ and math definitions to kernel.h
Date:   Thu, 22 Dec 2022 18:09:57 -0600
Message-Id: <20221223000958.729256-2-code@tyhicks.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20221223000958.729256-1-code@tyhicks.com>
References: <20221223000958.729256-1-code@tyhicks.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Karolina Drobnik <karolinadrobnik@gmail.com>

commit 5cf67a6051ea2558fd7c3d39c5a808db73073e9d upstream.

Add max_t, min_t and clamp functions, together with _RET_IP_
definition, so they can be used in testing.

Signed-off-by: Karolina Drobnik <karolinadrobnik@gmail.com>
Signed-off-by: Mike Rapoport <rppt@kernel.org>
Link: https://lore.kernel.org/r/230fea382cb1e1659cdd52a55201854d38a0a149.1643796665.git.karolinadrobnik@gmail.com
[tyhicks: Backport around contextual differences due to the lack of v5.16 commit
 d6e6a27d960f ("tools: Fix math.h breakage"). That commit fixed a commit
 that was merged in v5.16-rc1 and, therefore, doesn't need to go back to
 the stable branches.]
Signed-off-by: Tyler Hicks (Microsoft) <code@tyhicks.com>
---
 tools/include/linux/kernel.h | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/tools/include/linux/kernel.h b/tools/include/linux/kernel.h
index a7e54a08fb54..c2e109860fbc 100644
--- a/tools/include/linux/kernel.h
+++ b/tools/include/linux/kernel.h
@@ -14,6 +14,8 @@
 #define UINT_MAX	(~0U)
 #endif
 
+#define _RET_IP_		((unsigned long)__builtin_return_address(0))
+
 #define DIV_ROUND_UP(n,d) (((n) + (d) - 1) / (d))
 
 #define PERF_ALIGN(x, a)	__PERF_ALIGN_MASK(x, (typeof(x))(a)-1)
@@ -52,6 +54,10 @@
 	_min1 < _min2 ? _min1 : _min2; })
 #endif
 
+#define max_t(type, x, y)	max((type)x, (type)y)
+#define min_t(type, x, y)	min((type)x, (type)y)
+#define clamp(val, lo, hi)	min((typeof(val))max(val, lo), hi)
+
 #ifndef roundup
 #define roundup(x, y) (                                \
 {                                                      \
-- 
2.34.1

