Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0A2F73388C3
	for <lists+stable@lfdr.de>; Fri, 12 Mar 2021 10:35:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232790AbhCLJee (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 12 Mar 2021 04:34:34 -0500
Received: from wout4-smtp.messagingengine.com ([64.147.123.20]:48599 "EHLO
        wout4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232781AbhCLJeP (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 12 Mar 2021 04:34:15 -0500
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailout.west.internal (Postfix) with ESMTP id BA55118AD;
        Fri, 12 Mar 2021 04:34:14 -0500 (EST)
Received: from mailfrontend1 ([10.202.2.162])
  by compute4.internal (MEProxy); Fri, 12 Mar 2021 04:34:15 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=sakamocchi.jp;
         h=from:to:cc:subject:date:message-id:mime-version
        :content-transfer-encoding; s=fm1; bh=vwRKwAmpvTdtGnmYiNdeCL/mi0
        xGimvcUnHRyBB0y2c=; b=u501xOcENHpDqt8YcEEA48mlyqns2cuGVwjR3hSVLl
        4DgSmAZC9PxtzA/AjU9bEom1vFD0p3hpaYq6FVrnv44uOo6nbP5YBxVf4fzzKO36
        zH8w0P3eg2fEDpaEsckNvcKOvEkw+cbZhBHJK0twZB8se6bRscn7ZwF4Y+FcaOgm
        sUzWY+BW084nlc20IsLivNhllzdBrese/i5N1VqQOBUp4En+/9ABB1kpOLiN5dnB
        XYDFch0cxUKnSvX3lbyA76IIFilDwrau/45RgR/2S5+MM0/w8d/a93IWxLKC9gfM
        bVrqaU8CK13cNFgXHhzBBjeQxfnPZFWFny3O1grDVnbQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :message-id:mime-version:subject:to:x-me-proxy:x-me-proxy
        :x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=vwRKwAmpvTdtGnmYi
        NdeCL/mi0xGimvcUnHRyBB0y2c=; b=XetWkQi1AgTVBxsIdm0KcBpUBBl0cZwQL
        31r1rfDxFgOjE4Lf5nmxX5UTXWZbPqdWFEwUya+ho87A7T1oyvu2uJlzyhHPUlrV
        26++ko6mLXOEk561laELyLEAgyyEpKIq8kMcerKvvbvUFVZCjs7YgjoMsHr521Dh
        Lx3sSOd/FgVXFw/ISSzLU8pMCmxzRFotDkF7eL4TCUHQIsLJN5pUgwkz3spdAOpU
        4h1NH4FPdAW8RlrWli4+EFGCpLXm0EVxgGLfoRwuaEUniTvBeHFCRnEtgTIZH9xt
        65YuAeuNc80hI4PPhzQO30y7Rl+aL0d0m7ArwDgo/LYfUviMQHW7w==
X-ME-Sender: <xms:lDVLYFw9Jk_GV2O7pLbI8-7JI75mv6hsBVrh6pmBU69w4AEPvfHvSw>
    <xme:lDVLYFNJrs_IeSF5eOSrMwWtXfayK0IF8pciDqC-mXCYzccYOw8Q2h0njt2fcYgG8
    clFnBTizFnBKbbGBYs>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledruddvvddgtdehucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefhvffufffkofgggfestdekredtre
    dttdenucfhrhhomhepvfgrkhgrshhhihcuufgrkhgrmhhothhouceoohdqthgrkhgrshhh
    ihesshgrkhgrmhhotggthhhirdhjpheqnecuggftrfgrthhtvghrnhepudejteelhfdttd
    ekgfdtueeilefhgfetjeejheekgeevuddvveegieehueeukeejnecukfhppedugedrfedr
    ieehrddujeehnecuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrh
    homhepohdqthgrkhgrshhhihesshgrkhgrmhhotggthhhirdhjph
X-ME-Proxy: <xmx:lDVLYMO_vjbagHdJTgFVPagUUvIKvSOlT4gtfxqyEWfgBYOeOK7FxA>
    <xmx:lDVLYPTE71LBmzvK3DJ9Hek8L-gnBAoyqnu-YUi7cvL2KeHW8GIr2A>
    <xmx:lDVLYGAd-fLAxB1xQedCtS9lQfi3N9iMAsOKZxuj7fqNnW8CpMVyuw>
    <xmx:ljVLYBctKBmUf_xg0a-S5BNsMJWO8jqTsG8bmf6ci76ChQ8DLFt7fw>
Received: from workstation.flets-east.jp (ae065175.dynamic.ppp.asahi-net.or.jp [14.3.65.175])
        by mail.messagingengine.com (Postfix) with ESMTPA id 7520C24005C;
        Fri, 12 Mar 2021 04:34:11 -0500 (EST)
From:   Takashi Sakamoto <o-takashi@sakamocchi.jp>
To:     tiwai@suse.de, perex@perex.cz
Cc:     clemens@ladisch.de, alsa-devel@alsa-project.org,
        ffado-devel@lists.sourceforge.net, stable@vger.kernel.org
Subject: [PATCH] ALSA: dice: fix null pointer dereference when node is disconnected
Date:   Fri, 12 Mar 2021 18:34:07 +0900
Message-Id: <20210312093407.23437-1-o-takashi@sakamocchi.jp>
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

When node is removed from IEEE 1394 bus, any transaction fails to the node.
In the case, ALSA dice driver doesn't stop isochronous contexts even if
they are running. As a result, null pointer dereference occurs in callback
from the running context.

This commit fixes the bug to release isochronous contexts always.

Cc: <stable@vger.kernel.org> # v5.4 or later
Fixes: e9f21129b8d8 ("ALSA: dice: support AMDTP domain")
Signed-off-by: Takashi Sakamoto <o-takashi@sakamocchi.jp>
---
 sound/firewire/dice/dice-stream.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/sound/firewire/dice/dice-stream.c b/sound/firewire/dice/dice-stream.c
index 8e0c0380b4c4..1a14c083e8ce 100644
--- a/sound/firewire/dice/dice-stream.c
+++ b/sound/firewire/dice/dice-stream.c
@@ -493,11 +493,10 @@ void snd_dice_stream_stop_duplex(struct snd_dice *dice)
 	struct reg_params tx_params, rx_params;
 
 	if (dice->substreams_counter == 0) {
-		if (get_register_params(dice, &tx_params, &rx_params) >= 0) {
-			amdtp_domain_stop(&dice->domain);
+		if (get_register_params(dice, &tx_params, &rx_params) >= 0)
 			finish_session(dice, &tx_params, &rx_params);
-		}
 
+		amdtp_domain_stop(&dice->domain);
 		release_resources(dice);
 	}
 }
-- 
2.27.0

