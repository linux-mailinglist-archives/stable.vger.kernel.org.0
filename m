Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 702FF3192D
	for <lists+stable@lfdr.de>; Sat,  1 Jun 2019 05:08:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726678AbfFADIJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 31 May 2019 23:08:09 -0400
Received: from wout2-smtp.messagingengine.com ([64.147.123.25]:54967 "EHLO
        wout2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726547AbfFADIJ (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 31 May 2019 23:08:09 -0400
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
        by mailout.west.internal (Postfix) with ESMTP id BE3751234;
        Fri, 31 May 2019 23:08:07 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute1.internal (MEProxy); Fri, 31 May 2019 23:08:08 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=sakamocchi.jp;
         h=from:to:cc:subject:date:message-id:mime-version
        :content-transfer-encoding; s=fm1; bh=VGVBhByXJBs/Thj5O+O4Fr707/
        XLIrNFaMGYre5Xmkk=; b=L/9bNPZaQWm0TMRrkHYUlOkA29WIiezfr48J6KdUYX
        Ac/F0tDkwzoIs5oWtyBN9FNpYddTQnIso+C/icwNVkKderXkS313TtnByx8BAe7P
        iWPdLEhYTEy9JlH3jtr6LWbcjt+0/vGZpJkEwm7oYDx4bTqVKfTF9KJfm2aPTZZQ
        vNpeZEc1rOPNAHrj80ee2DuoQn0opS2GQvS+7DQCtGT+JNVKUIGxAl6+U6l2LJfM
        IYcGvZFW8kxckLfS4sTnaM0bajzwvJudsg25aHLkVvXAVWPTKKDzb+NFLvJDtEtv
        DZXzLtTI8ysbsSCbPOW7kNquFEHMZzqpcAgI4SOIhT5Q==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :message-id:mime-version:subject:to:x-me-proxy:x-me-proxy
        :x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=VGVBhByXJBs/Thj5O
        +O4Fr707/XLIrNFaMGYre5Xmkk=; b=26Lebn79JkJzPzizFQ1ePwxsJ0Oh8ccCW
        TtdTtKwWorlcxoDu+PbbieeeaU6xCJfc5icuGmLhyM6f70q2i4EO7eck0UbPnHVO
        zE1AcHCxd0RFdK/ymGCMULEe+JIGpLGRb1SwBeVXNs+mCNjrnhlrCHdMRNefUTup
        sus+E3v+UEBQ1mXDjT/C30H/MnIBkX07zWFXM4PFlO4xJXIS07yW2j8mHEbchaVm
        4Ruq/S+qvx+hHZhoWXJ/FEh36x5WsGLAFGMV2hoV+kQyou1dL7AIMDQUdtTdueLt
        O7wjEFC5Eu8npfYB0p70QlzbS/xjG2Exb6/m7tWNeWBim1IbCvdrw==
X-ME-Sender: <xms:FuzxXB85VfheV5sjOmEfx-VNISZVmZCGzUBDjMY91B3CuZPrty1kDQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduuddrudefvddgieelucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefhvffufffkofgggfestdekredtre
    dttdenucfhrhhomhepvfgrkhgrshhhihcuufgrkhgrmhhothhouceoohdqthgrkhgrshhh
    ihesshgrkhgrmhhotggthhhirdhjpheqnecukfhppedugedrfedrjeehrddukedunecurf
    grrhgrmhepmhgrihhlfhhrohhmpehoqdhtrghkrghshhhisehsrghkrghmohgttghhihdr
    jhhpnecuvehluhhsthgvrhfuihiivgeptd
X-ME-Proxy: <xmx:FuzxXD-ypzrILpjEuhrtv1ofZnYXiTKmpqGT0ZWkn7hBkEcOEq2YxQ>
    <xmx:FuzxXIXC7Y45aq87aOtXl2veHSzH4EYzVoHv5t-9kVJyYK_YNHrlhQ>
    <xmx:FuzxXIcjgBesMKOWrl8e2jCM3QBuFvl2zbbV-jKY05Kz4HDcV6SYGw>
    <xmx:F-zxXGuAMtfV8r0wlGaH-U4cqzfX8pRAvBeXjcNiaxsRKcAuYgCq6Q>
Received: from localhost.localdomain (ae075181.dynamic.ppp.asahi-net.or.jp [14.3.75.181])
        by mail.messagingengine.com (Postfix) with ESMTPA id CFDC080059;
        Fri, 31 May 2019 23:08:04 -0400 (EDT)
From:   Takashi Sakamoto <o-takashi@sakamocchi.jp>
To:     clemens@ladisch.de, tiwai@suse.de
Cc:     alsa-devel@alsa-project.org, stable@vger.kernel.org
Subject: [PATCH] ALSA: firewire-motu: fix destruction of data for isochronous resources
Date:   Sat,  1 Jun 2019 12:08:01 +0900
Message-Id: <20190601030801.3675-1-o-takashi@sakamocchi.jp>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The data for isochronous resources is not destroyed in expected place.
This commit fixes the bug.

Cc: <stable@vger.kernel.org> # v4.12+
Fixes: 9b2bb4f2f4a2 ("ALSA: firewire-motu: add stream management functionality")
Signed-off-by: Takashi Sakamoto <o-takashi@sakamocchi.jp>
---
 sound/firewire/motu/motu-stream.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/sound/firewire/motu/motu-stream.c b/sound/firewire/motu/motu-stream.c
index 73e7a5e527fc..483a8771d502 100644
--- a/sound/firewire/motu/motu-stream.c
+++ b/sound/firewire/motu/motu-stream.c
@@ -345,7 +345,7 @@ static void destroy_stream(struct snd_motu *motu,
 	}
 
 	amdtp_stream_destroy(stream);
-	fw_iso_resources_free(resources);
+	fw_iso_resources_destroy(resources);
 }
 
 int snd_motu_stream_init_duplex(struct snd_motu *motu)
-- 
2.20.1

