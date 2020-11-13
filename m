Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 666322B1814
	for <lists+stable@lfdr.de>; Fri, 13 Nov 2020 10:20:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726275AbgKMJUt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 13 Nov 2020 04:20:49 -0500
Received: from out2-smtp.messagingengine.com ([66.111.4.26]:56221 "EHLO
        out2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726181AbgKMJUs (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 13 Nov 2020 04:20:48 -0500
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailout.nyi.internal (Postfix) with ESMTP id 9A9D75C00AA;
        Fri, 13 Nov 2020 04:20:47 -0500 (EST)
Received: from mailfrontend2 ([10.202.2.163])
  by compute4.internal (MEProxy); Fri, 13 Nov 2020 04:20:47 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=sakamocchi.jp;
         h=from:to:cc:subject:date:message-id:mime-version
        :content-transfer-encoding; s=fm3; bh=JH0Zw1m/P1vJ8jE5L5LU7f6T5N
        wpkPgNZm4zieFMjY8=; b=SX7pIIQRTPEEJ04MIzAcwZguY7fxZyZ7wkFP3q6cOT
        Wd+9pfilbY+tcfws5getbzzSykxeLqIq6Hw6nZufwzHg9nz9dtDXXWIv+cTIZcNg
        ZkUyFZU5mf3PIF24MLHPgvQdeGp8Q8I1YtgyWAe3UhE/RGbcnOn2FWtKCjhpKU5Y
        Y7Rqovm9fjdy9pKwm+KfnyVPVYQxllrnkSOwJTgzOD5ReT9O4hyz+p9H5evRLGHj
        nGi4+auOdxIZt8N2Coaszmigiu1Ogb7jMDyy4FyMZsTpS1jq5pjzXHgRXL01HoLp
        ldglOEx9RcGta8MCjW6AMKt/bt26+XeZB+vMKmKSw2vg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :message-id:mime-version:subject:to:x-me-proxy:x-me-proxy
        :x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=JH0Zw1m/P1vJ8jE5L
        5LU7f6T5NwpkPgNZm4zieFMjY8=; b=iTx3UkfP5S1HjccJrgJpvpN5uZ/tm+nkV
        Vuo4boE0uFqdrZQ+mmaYP8ND07Uy/csHeyQwk+m2UJgfKf690Gu7w2PKTboMJZla
        NVScqrJ0VbBhjyNInyNXsOAzFOLvSqVs1puoBWm5BvxFSe4ClgNQw8SJE3N6usPS
        +SN+/gFE3jDOEek43UJMNAdF2f2by2hss9vTk5SNQJwrx/kyDFJowbEJZb+6nueS
        dw5Ykf7IDDZE8ouVqMjvJweZN6k88/QqhNNEBQSQh6hagrF3jCFkRubIjoWZOxPu
        neJSA2C6mclBur4wOWFOBeKViHO4w/0p55OyA2Y5vZuBiNo/0njig==
X-ME-Sender: <xms:7k-uXzm7LIX-Bns1IbZjHkIJZe5A5NMwkyzJwUuM_6C91VF91X_Kpg>
    <xme:7k-uX20JwzIZOcSlsiy_MyBQHwLP8_mgaE3u4fh9baLjut5y-XaqGyIDgJD_iflSc
    hfo8Zn3WwBcKOquVFk>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedujedruddvhedgtddvucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefhvffufffkofgggfestdekredtre
    dttdenucfhrhhomhepvfgrkhgrshhhihcuufgrkhgrmhhothhouceoohdqthgrkhgrshhh
    ihesshgrkhgrmhhotggthhhirdhjpheqnecuggftrfgrthhtvghrnhepudejteelhfdttd
    ekgfdtueeilefhgfetjeejheekgeevuddvveegieehueeukeejnecukfhppedugedrfedr
    ieegrddvtdejnecuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrh
    homhepohdqthgrkhgrshhhihesshgrkhgrmhhotggthhhirdhjph
X-ME-Proxy: <xmx:7k-uX5pJXwXRJSDRN4jpZqpP-tKzWUsNmX-67j1CGxUmqjB7JhlOMA>
    <xmx:7k-uX7kejpCCrq7Sxli-8ddRAn6ig7EUP1uS3AMHzYdXZyRfY22mzA>
    <xmx:7k-uXx0P7TiTz5pfohXtwVhTFdo74AS1AXaAcL0bxam9ZK8rUc7aIQ>
    <xmx:70-uXy_oeloho6E6O--IdVPM_bI5kpBSgRgar588VztTW1CN96FPdA>
Received: from workstation.flets-east.jp (ae064207.dynamic.ppp.asahi-net.or.jp [14.3.64.207])
        by mail.messagingengine.com (Postfix) with ESMTPA id C56603064AA6;
        Fri, 13 Nov 2020 04:20:45 -0500 (EST)
From:   Takashi Sakamoto <o-takashi@sakamocchi.jp>
To:     tiwai@suse.de, perex@perex.cz
Cc:     alsa-devel@alsa-project.org, stable@vger.kernel.org
Subject: [PATCH] ALSA: ctl: fix error path at adding user-defined element set
Date:   Fri, 13 Nov 2020 18:20:43 +0900
Message-Id: <20201113092043.16148-1-o-takashi@sakamocchi.jp>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

When processing request to add/replace user-defined element set, check
of given element identifier and decision of numeric identifier is done
in "__snd_ctl_add_replace()" helper function. When the result of check
is wrong, the helper function returns error code. The error code shall
be returned to userspace application.

Current implementation includes bug to return zero to userspace application
regardless of the result. This commit fixes the bug.

Cc: <stable@vger.kernel.org>
Fixes: e1a7bfe38079 ("ALSA: control: Fix race between adding and removing a user element")
Signed-off-by: Takashi Sakamoto <o-takashi@sakamocchi.jp>
---
 sound/core/control.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/sound/core/control.c b/sound/core/control.c
index 421ddc7..f341fc4 100644
--- a/sound/core/control.c
+++ b/sound/core/control.c
@@ -1539,7 +1539,7 @@ static int snd_ctl_elem_add(struct snd_ctl_file *file,
 
  unlock:
 	up_write(&card->controls_rwsem);
-	return 0;
+	return err;
 }
 
 static int snd_ctl_elem_add_user(struct snd_ctl_file *file,
-- 
2.25.1

