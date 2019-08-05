Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BF59E811D2
	for <lists+stable@lfdr.de>; Mon,  5 Aug 2019 07:57:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727294AbfHEF5a (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 5 Aug 2019 01:57:30 -0400
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:36611 "EHLO
        out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726423AbfHEF5a (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 5 Aug 2019 01:57:30 -0400
Received: from compute6.internal (compute6.nyi.internal [10.202.2.46])
        by mailout.nyi.internal (Postfix) with ESMTP id BA1A920F44;
        Mon,  5 Aug 2019 01:57:28 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute6.internal (MEProxy); Mon, 05 Aug 2019 01:57:28 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=QCXBtT
        09eu6On8oomOVzo29mcHA/3u7PHMZ/SmP8aHo=; b=u/G8ptS4DdXOSFkQRjz27Y
        HiA5bp3/qvQlTPvHezv2c6Hj2fLYMccE80FV4EyrKdI5x4yRJVSxIvcg2jf2KHjk
        EK/XuyNxedojWadOXZvpP6knUFM3ppOD/pvgrc83OgEUUcSI4W6tpwTIxKdkyjxU
        8O4Aq94CWaZ0i1Tj8Ym6veuJmVACr+Tb/fT+xVzEtAdCE0bFo+XOMhVH+Cwj2B7t
        SzckLq5VTSjuqGw5u6X7uA24fEz8oWpimeiAgEIKpsuSGe6i7F77NTcuODHz82c5
        pi+MUuYKrSFu1D7BGDL9qqpE1/l7sFh9vHCUf24PeacKOtw1J3hI9yIoaeN+kv5w
        ==
X-ME-Sender: <xms:SMVHXam8_D2-PG3zMEgsIoiSikUs55y53K-P1v6RyWE2goeMNksqfw>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduvddruddtiedgledtucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtjeenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecuffhomhgrihhnpehfrhgvvgguvghskhhtohhprdhorhhgnecukfhppeekfedrke
    eirdekledruddtjeenucfrrghrrghmpehmrghilhhfrhhomhepghhrvghgsehkrhhorghh
    rdgtohhmnecuvehluhhsthgvrhfuihiivgeptd
X-ME-Proxy: <xmx:SMVHXZeFwmP8L0k7rJU9O5Ne0woxZYRcvU2Ina6WRM7usKz30cYk6Q>
    <xmx:SMVHXWSGdeVOEjTw5K0PLC5XX-wYy5STZghCEnMZTVL4EuiEDy3O6w>
    <xmx:SMVHXYvOhHke4eXDfnqPOiin531fqM1jIvXS-qnAyl1u4_XQ0C38fQ>
    <xmx:SMVHXToqHaCyaEeNvgRe-BKq0_yXRzujKUJyNCyu0kZONJcSVhK7eQ>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id 0345E380083;
        Mon,  5 Aug 2019 01:57:27 -0400 (EDT)
Subject: FAILED: patch "[PATCH] drm/i915: Make sure cdclk is high enough for DP audio on" failed to apply to 5.2-stable tree
To:     ville.syrjala@linux.intel.com, chris@chris-wilson.co.uk,
        gottwald@igel.com, jani.nikula@intel.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 05 Aug 2019 07:57:26 +0200
Message-ID: <156498464623047@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 5.2-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From a8f196a0fa6391a436f63f360a1fb57031fdf26c Mon Sep 17 00:00:00 2001
From: =?UTF-8?q?Ville=20Syrj=C3=A4l=C3=A4?= <ville.syrjala@linux.intel.com>
Date: Wed, 17 Jul 2019 14:45:36 +0300
Subject: [PATCH] drm/i915: Make sure cdclk is high enough for DP audio on
 VLV/CHV
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

On VLV/CHV there is some kind of linkage between the cdclk frequency
and the DP link frequency. The spec says:
"For DP audio configuration, cdclk frequency shall be set to
 meet the following requirements:
 DP Link Frequency(MHz) | Cdclk frequency(MHz)
 270                    | 320 or higher
 162                    | 200 or higher"

I suspect that would more accurately be expressed as
"cdclk >= DP link clock", and in any case we can express it like
that in the code because of the limited set of cdclk (200, 266,
320, 400 MHz) and link frequencies (162 and 270 MHz) we support.

Without this we can end up in a situation where the cdclk
is too low and enabling DP audio will kill the pipe. Happens
eg. with 2560x1440 modes where the 266MHz cdclk is sufficient
to pump the pixels (241.5 MHz dotclock) but is too low for
the DP audio due to the link frequency being 270 MHz.

v2: Spell out the cdclk and link frequencies we actually support

Cc: stable@vger.kernel.org
Tested-by: Stefan Gottwald <gottwald@igel.com>
Bugzilla: https://bugs.freedesktop.org/show_bug.cgi?id=111149
Signed-off-by: Ville Syrjälä <ville.syrjala@linux.intel.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20190717114536.22937-1-ville.syrjala@linux.intel.com
Acked-by: Chris Wilson <chris@chris-wilson.co.uk>
(cherry picked from commit bffb31f73b29a60ef693842d8744950c2819851d)
Signed-off-by: Jani Nikula <jani.nikula@intel.com>

diff --git a/drivers/gpu/drm/i915/display/intel_cdclk.c b/drivers/gpu/drm/i915/display/intel_cdclk.c
index 8993ab283562..0d19bbd08122 100644
--- a/drivers/gpu/drm/i915/display/intel_cdclk.c
+++ b/drivers/gpu/drm/i915/display/intel_cdclk.c
@@ -2239,6 +2239,17 @@ int intel_crtc_compute_min_cdclk(const struct intel_crtc_state *crtc_state)
 	if (crtc_state->has_audio && INTEL_GEN(dev_priv) >= 9)
 		min_cdclk = max(2 * 96000, min_cdclk);
 
+	/*
+	 * "For DP audio configuration, cdclk frequency shall be set to
+	 *  meet the following requirements:
+	 *  DP Link Frequency(MHz) | Cdclk frequency(MHz)
+	 *  270                    | 320 or higher
+	 *  162                    | 200 or higher"
+	 */
+	if ((IS_VALLEYVIEW(dev_priv) || IS_CHERRYVIEW(dev_priv)) &&
+	    intel_crtc_has_dp_encoder(crtc_state) && crtc_state->has_audio)
+		min_cdclk = max(crtc_state->port_clock, min_cdclk);
+
 	/*
 	 * On Valleyview some DSI panels lose (v|h)sync when the clock is lower
 	 * than 320000KHz.

