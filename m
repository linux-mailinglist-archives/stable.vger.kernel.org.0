Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B4C0B4A45B8
	for <lists+stable@lfdr.de>; Mon, 31 Jan 2022 12:48:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1376498AbiAaLqc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 31 Jan 2022 06:46:32 -0500
Received: from wout1-smtp.messagingengine.com ([64.147.123.24]:46347 "EHLO
        wout1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1379004AbiAaLna (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 31 Jan 2022 06:43:30 -0500
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
        by mailout.west.internal (Postfix) with ESMTP id 75AC63201C39;
        Mon, 31 Jan 2022 06:43:28 -0500 (EST)
Received: from mailfrontend1 ([10.202.2.162])
  by compute1.internal (MEProxy); Mon, 31 Jan 2022 06:43:29 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=cerno.tech; h=cc
        :cc:content-transfer-encoding:date:date:from:from:in-reply-to
        :message-id:mime-version:reply-to:sender:subject:subject:to:to;
         s=fm2; bh=Tk4exGVRD8GPTmpzlgw0ILlHu0aw68S4ROu924EUDVc=; b=TAwww
        EkFHehwtYz1KSAmvnL0lrhbNRySqXJAJg87Ja1ISOJT5tuW4/is81P6UIz6QYdXE
        rls5eEyX7SH92PKnqHCuvqUxKA/IvxOGl3w/H1s65pj7MruTRQsnN65a2G3LqMZo
        Yqs8KYxGEOTKrg5VOcCDyaRGRiWCkLqxsZXTrIUKvzXMm2052NiIYT/7b0NQF8ma
        z3ALxdNCJ8JSr3hGMw1Dhcp8FM8g+Jr8oecCYf4s7ZiQdgmB50/E2NRqbDYmhtQG
        DvhntadeKYQiMrCeVCIE8iDxpL6Z7X4tkypgtpSxQ6vlVG7YF8fwWbWZG+2tFtR4
        Lm9zqrsmPn1dS4bfQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:cc:content-transfer-encoding:date:date
        :from:from:in-reply-to:message-id:mime-version:reply-to:sender
        :subject:subject:to:to:x-me-proxy:x-me-proxy:x-me-sender
        :x-me-sender:x-sasl-enc; s=fm2; bh=Tk4exGVRD8GPTmpzlgw0ILlHu0aw6
        8S4ROu924EUDVc=; b=Jp2bjI4tsPV5JJ8m1vRZjKx5bS1Iva0NaqXpjMg+feKTA
        p9ka6j0IwQ8511Z1m5iV8jhsSunjtIfBJbRn6BgvqjY1EFNn77FzT/6fza3qcI/i
        k2jUFFnMKWx2kW2d23Vaq8AX/OLJelME2OtBWV9Umv8P+WUFQjAQpfYK9Qww3ZmQ
        BJK7jBDxoX+breVW2SuQmDH8Wfq8Vr+0SKicUgjBpzLcXs2pVj73GyJs1/0lYLMy
        qfBewTLhAYPpNwid8tZfob1uV6wq6k6FEaszlhVr/W29LeQivyy4BW+gnrxDbVCQ
        Saz2ocY0caMkpCTWtdHOXFWDzfA8Lj5chJy/DGjBA==
X-ME-Sender: <xms:X8v3YU6yCByqoUtKybzlWnGQxQznYMY-cPZCYGbh9MpVOZN_iEK3Nw>
    <xme:X8v3YV4bxAsuG5CEwpj3z-XxakoYLHpQDgNKu3zOaZuYfmugohnsEytrVlrnhmSOI
    cri-TXHfWY3IxehVa8>
X-ME-Received: <xmr:X8v3YTdzHunrNDm9JRkVoscMc3YeBMCXi-F4U-sW6fl3es91vU8XslFjoUtsgrcbD72Tv13-Hnwe_Sp9sxn50CcLeg24wqbxO7bwo0Q>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvvddrgedugdefudcutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenuc
    fjughrpefhvffufffkofgggfestdekredtredttdenucfhrhhomhepofgrgihimhgvucft
    ihhprghrugcuoehmrgigihhmvgestggvrhhnohdrthgvtghhqeenucggtffrrghtthgvrh
    hnpeejffehuddvvddvlefhgeelleffgfeijedvhefgieejtdeiueetjeetfeeukeejgeen
    ucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpehmrgigih
    hmvgestggvrhhnohdrthgvtghh
X-ME-Proxy: <xmx:X8v3YZLkEcuNjXn48Ukrm7k-Nm1O9NXYNAwpfdPzHdVNbIFG0uCx6g>
    <xmx:X8v3YYJC1Rjk2qK_jhJ1Gsmy1RoSwd83XTknTlW-ToKM6eCW34z1uw>
    <xmx:X8v3Yay5TLmItKCXKQyxGLiFQt_Wr9wWD6ItqhvWqBukZZkpmYRTtQ>
    <xmx:YMv3YSjRqlGbmAXdOuJPJLgqFgI7wbJrZVy99F_1La1AeHl5Pe83oA>
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Mon,
 31 Jan 2022 06:43:27 -0500 (EST)
From:   Maxime Ripard <maxime@cerno.tech>
To:     stable@vger.kernel.org
Cc:     Dave Stevenson <dave.stevenson@raspberrypi.com>,
        Phil Elwell <phil@raspberrypi.com>,
        Tim Gover <tim.gover@raspberrypi.com>,
        Dom Cobley <dom@raspberrypi.com>,
        Maxime Ripard <maxime@cerno.tech>,
        Michael Stapelberg <michael+drm@stapelberg.ch>
Subject: [PATCH stable] drm/vc4: hdmi: Fix improper merge conflict with CEC
Date:   Mon, 31 Jan 2022 12:43:23 +0100
Message-Id: <20220131114323.406007-1-maxime@cerno.tech>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Commit 20b0dfa86bef0e80b41b0e5ac38b92f23b6f27f9 upstream.

The original commit depended on a rework commit (724fc856c09e ("drm/vc4:
hdmi: Split the CEC disable / enable functions in two")) that
(rightfully) didn't reach stable.

However, probably because the context changed, when the patch was
applied to stable the pm_runtime_put called got moved to the end of the
vc4_hdmi_cec_adap_enable function (that would have become
vc4_hdmi_cec_disable with the rework) to vc4_hdmi_cec_init.

This means that at probe time, we now drop our reference to the clocks
and power domains and thus end up with a CPU hang when the CPU tries to
access registers.

The call to pm_runtime_resume_and_get() is also problematic since the
.adap_enable CEC hook is called both to enable and to disable the
controller. That means that we'll now call pm_runtime_resume_and_get()
at disable time as well, messing with the reference counting.

The behaviour we should have though would be to have
pm_runtime_resume_and_get() called when the CEC controller is enabled,
and pm_runtime_put when it's disabled.

We need to move things around a bit to behave that way, but it aligns
stable with upstream.

Cc: <stable@vger.kernel.org> # 5.10.x
Cc: <stable@vger.kernel.org> # 5.15.x
Cc: <stable@vger.kernel.org> # 5.16.x
Reported-by: Michael Stapelberg <michael+drm@stapelberg.ch>
Signed-off-by: Maxime Ripard <maxime@cerno.tech>
---
 drivers/gpu/drm/vc4/vc4_hdmi.c | 27 ++++++++++++++-------------
 1 file changed, 14 insertions(+), 13 deletions(-)

diff --git a/drivers/gpu/drm/vc4/vc4_hdmi.c b/drivers/gpu/drm/vc4/vc4_hdmi.c
index 8465914892fa..e6aad838065b 100644
--- a/drivers/gpu/drm/vc4/vc4_hdmi.c
+++ b/drivers/gpu/drm/vc4/vc4_hdmi.c
@@ -1739,18 +1739,18 @@ static int vc4_hdmi_cec_adap_enable(struct cec_adapter *adap, bool enable)
 	u32 val;
 	int ret;
 
-	ret = pm_runtime_resume_and_get(&vc4_hdmi->pdev->dev);
-	if (ret)
-		return ret;
-
-	val = HDMI_READ(HDMI_CEC_CNTRL_5);
-	val &= ~(VC4_HDMI_CEC_TX_SW_RESET | VC4_HDMI_CEC_RX_SW_RESET |
-		 VC4_HDMI_CEC_CNT_TO_4700_US_MASK |
-		 VC4_HDMI_CEC_CNT_TO_4500_US_MASK);
-	val |= ((4700 / usecs) << VC4_HDMI_CEC_CNT_TO_4700_US_SHIFT) |
-	       ((4500 / usecs) << VC4_HDMI_CEC_CNT_TO_4500_US_SHIFT);
-
 	if (enable) {
+		ret = pm_runtime_resume_and_get(&vc4_hdmi->pdev->dev);
+		if (ret)
+			return ret;
+
+		val = HDMI_READ(HDMI_CEC_CNTRL_5);
+		val &= ~(VC4_HDMI_CEC_TX_SW_RESET | VC4_HDMI_CEC_RX_SW_RESET |
+			 VC4_HDMI_CEC_CNT_TO_4700_US_MASK |
+			 VC4_HDMI_CEC_CNT_TO_4500_US_MASK);
+		val |= ((4700 / usecs) << VC4_HDMI_CEC_CNT_TO_4700_US_SHIFT) |
+			((4500 / usecs) << VC4_HDMI_CEC_CNT_TO_4500_US_SHIFT);
+
 		HDMI_WRITE(HDMI_CEC_CNTRL_5, val |
 			   VC4_HDMI_CEC_TX_SW_RESET | VC4_HDMI_CEC_RX_SW_RESET);
 		HDMI_WRITE(HDMI_CEC_CNTRL_5, val);
@@ -1778,7 +1778,10 @@ static int vc4_hdmi_cec_adap_enable(struct cec_adapter *adap, bool enable)
 			HDMI_WRITE(HDMI_CEC_CPU_MASK_SET, VC4_HDMI_CPU_CEC);
 		HDMI_WRITE(HDMI_CEC_CNTRL_5, val |
 			   VC4_HDMI_CEC_TX_SW_RESET | VC4_HDMI_CEC_RX_SW_RESET);
+
+		pm_runtime_put(&vc4_hdmi->pdev->dev);
 	}
+
 	return 0;
 }
 
@@ -1889,8 +1892,6 @@ static int vc4_hdmi_cec_init(struct vc4_hdmi *vc4_hdmi)
 	if (ret < 0)
 		goto err_remove_handlers;
 
-	pm_runtime_put(&vc4_hdmi->pdev->dev);
-
 	return 0;
 
 err_remove_handlers:
-- 
2.34.1

