Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DFF46ECF62
	for <lists+stable@lfdr.de>; Sat,  2 Nov 2019 16:09:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726454AbfKBPJ2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 2 Nov 2019 11:09:28 -0400
Received: from out4-smtp.messagingengine.com ([66.111.4.28]:48759 "EHLO
        out4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726440AbfKBPJ2 (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 2 Nov 2019 11:09:28 -0400
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
        by mailout.nyi.internal (Postfix) with ESMTP id 5888520E72;
        Sat,  2 Nov 2019 11:09:27 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute1.internal (MEProxy); Sat, 02 Nov 2019 11:09:27 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=sakamocchi.jp;
         h=from:to:cc:subject:date:message-id:mime-version
        :content-transfer-encoding; s=fm3; bh=7n7hiJWEp4TyIgvBs6OOKhwxBc
        f2hgKRHro7PFOOqSY=; b=tXe7s5auRgp0ztPbhMhJfqptTv0XMk74PJKcK7p9Xk
        pfTz6ehFQmNx3/R/VW/thx8KxXvjqoGUrE4DrDpDKpymdKkU6TZqGKlG00SuVVM8
        xHfFucfIq8eUMM3RzHm7xL35MAJyN3xrgfZSgz9VLy8eDxITTURwjB9OvkzxSyaD
        aGjPQgb9b4BZ3vavlhZ/aeyaqkB8aCS06ONUCfMGhlBNzc25OD7wGhvC2+XDnBp1
        FEIqnw+4d+5JY3oO09EXHCb3R+BoemeXp4rQZtjkTYcsi3I5qNfL95EgYoUXlhm+
        mKHFTnfPeRZWf65tJU94YKUZEv+hXTcDZ6ZhJPThxULA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :message-id:mime-version:subject:to:x-me-proxy:x-me-proxy
        :x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=7n7hiJWEp4TyIgvBs
        6OOKhwxBcf2hgKRHro7PFOOqSY=; b=EGd0lhVMxTLUno3kE8OshF3/Q1n3a3G+f
        zUU3gyCY6UTIwUs//lMV8LAnOcrcFZmMe9KSM3sIG4QfIvV74+zvDq3QlmoAsffY
        ZHxaXUlS11CRSk3V/X4EfXhIHgvj6HHhFVhgp58w+h4MzYSTFUJ//pZraMDGsxrY
        1EQxOTCmLVlfhRm395AvxzNbiHVqIZWj33iXXgPNxsy9QPqd+BcWG4PtUX4O+WDq
        KDwQ9FQnhxfmDdSp3SdGFiWAz8i9dyEkjixalcbpdmSvkhbSdpy+5Sn5Mu4SfN0f
        DP9l7aRu3x+UExGpj1ciokuFOx2+NtCZmNEMx0sH6UaOaVe3PRZXQ==
X-ME-Sender: <xms:JZy9XXYkN7ppLVWK0EUapWGDjf6Zgb1_iJqQQcjku7M4YkvtPvLqAw>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedufedruddtledgjedtucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefhvffufffkofgggfestdekredtre
    dttdenucfhrhhomhepvfgrkhgrshhhihcuufgrkhgrmhhothhouceoohdqthgrkhgrshhh
    ihesshgrkhgrmhhotggthhhirdhjpheqnecukfhppedugedrfedrjeehrddukedunecurf
    grrhgrmhepmhgrihhlfhhrohhmpehoqdhtrghkrghshhhisehsrghkrghmohgttghhihdr
    jhhpnecuvehluhhsthgvrhfuihiivgeptd
X-ME-Proxy: <xmx:JZy9XZna4cJTW_e0iHDa0DfRUDj6U_XZlbzddYTPP0qFUo3-_JSQDw>
    <xmx:JZy9XWGl9ZLU3Nc6VC8Ix2mKbZ4cRLCdwdzMqDqDmpdF8sTAB8VGCw>
    <xmx:JZy9XYGUYFu3qv35AJKvTSi1biqfuGMQ1cndy2ZeKsgQpYtKZWUWeQ>
    <xmx:J5y9XcGXdPelxvCHQxNqJyH8rNlEacthj-BUmIJ1x6LJF9qPrkw-GA>
Received: from workstation.flets-east.jp (ae075181.dynamic.ppp.asahi-net.or.jp [14.3.75.181])
        by mail.messagingengine.com (Postfix) with ESMTPA id F072180059;
        Sat,  2 Nov 2019 11:09:23 -0400 (EDT)
From:   Takashi Sakamoto <o-takashi@sakamocchi.jp>
To:     clemens@ladisch.de, tiwai@suse.de
Cc:     alsa-devel@alsa-project.org, stable@vger.kernel.org
Subject: [PATCH] ALSA: bebob: fix to detect configured source of sampling clock for Focusrite Saffire Pro i/o series
Date:   Sun,  3 Nov 2019 00:09:20 +0900
Message-Id: <20191102150920.20367-1-o-takashi@sakamocchi.jp>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

For Focusrite Saffire Pro i/o, the lowest 8 bits of register represents
configured source of sampling clock. The next lowest 8 bits represents
whether the configured source is actually detected or not just after
the register is changed for the source.

Current implementation evaluates whole the register to detect configured
source. This results in failure due to the next lowest 8 bits when the
source is connected in advance.

This commit fixes the bug.

Fixes: 25784ec2d034 ("ALSA: bebob: Add support for Focusrite Saffire/SaffirePro series")
Cc: <stable@vger.kernel.org> # v3.16+
Signed-off-by: Takashi Sakamoto <o-takashi@sakamocchi.jp>
---
 sound/firewire/bebob/bebob_focusrite.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/sound/firewire/bebob/bebob_focusrite.c b/sound/firewire/bebob/bebob_focusrite.c
index 32b864bee25f..06d6a37cd853 100644
--- a/sound/firewire/bebob/bebob_focusrite.c
+++ b/sound/firewire/bebob/bebob_focusrite.c
@@ -27,6 +27,8 @@
 #define SAFFIRE_CLOCK_SOURCE_SPDIF		1
 
 /* clock sources as returned from register of Saffire Pro 10 and 26 */
+#define SAFFIREPRO_CLOCK_SOURCE_SELECT_MASK	0x000000ff
+#define SAFFIREPRO_CLOCK_SOURCE_DETECT_MASK	0x0000ff00
 #define SAFFIREPRO_CLOCK_SOURCE_INTERNAL	0
 #define SAFFIREPRO_CLOCK_SOURCE_SKIP		1 /* never used on hardware */
 #define SAFFIREPRO_CLOCK_SOURCE_SPDIF		2
@@ -189,6 +191,7 @@ saffirepro_both_clk_src_get(struct snd_bebob *bebob, unsigned int *id)
 		map = saffirepro_clk_maps[1];
 
 	/* In a case that this driver cannot handle the value of register. */
+	value &= SAFFIREPRO_CLOCK_SOURCE_SELECT_MASK;
 	if (value >= SAFFIREPRO_CLOCK_SOURCE_COUNT || map[value] < 0) {
 		err = -EIO;
 		goto end;
-- 
2.20.1

