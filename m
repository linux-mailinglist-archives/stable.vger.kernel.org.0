Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3D08532E853
	for <lists+stable@lfdr.de>; Fri,  5 Mar 2021 13:27:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229963AbhCEM0T (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 5 Mar 2021 07:26:19 -0500
Received: from mail.kernel.org ([198.145.29.99]:32984 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231244AbhCEMZu (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 5 Mar 2021 07:25:50 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5A39B6502B;
        Fri,  5 Mar 2021 12:25:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614947149;
        bh=uNPsiKjotprz8hABvgEZoEYJtZTtcm+14N1heKP7OFU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Hf34BXqaZIPM+R3GDuyYLqVa1LxKaaUbYmVhFf7FHnio8PoKrCVKTkifBcRNMdku+
         40/uFzyOCufDNf0O1tTxZGnzJa3s6gZdEKKdepRngJYX8JIUkhlanjASN4TPZtTZQE
         Yhn3QT53Ud4E0JBVygAPoTu1gVEj+zDCJ4i4YRas=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        V Sujith Kumar Reddy <vsujithk@codeaurora.org>,
        Srinivasa Rao <srivasam@codeaurora.org>,
        Srinivas Kandagatla <srinivas.kandagatla@linaro.org>,
        Cheng-Yi Chiang <cychiang@chromium.org>,
        Stephen Boyd <swboyd@chromium.org>,
        Mark Brown <broonie@kernel.org>
Subject: [PATCH 5.11 036/104] ASoC: qcom: Remove useless debug print
Date:   Fri,  5 Mar 2021 13:20:41 +0100
Message-Id: <20210305120904.939022800@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210305120903.166929741@linuxfoundation.org>
References: <20210305120903.166929741@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Stephen Boyd <swboyd@chromium.org>

commit 16117beb16f01a470d40339960ffae1e287c03be upstream.

This looks like a left over debug print that tells us that HDMI is
enabled. Let's remove it as that's definitely not an error to have HDMI
enabled.

Cc: V Sujith Kumar Reddy <vsujithk@codeaurora.org>
Cc: Srinivasa Rao <srivasam@codeaurora.org>
Cc: Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
Cc: Cheng-Yi Chiang <cychiang@chromium.org>
Fixes: 7cb37b7bd0d3 ("ASoC: qcom: Add support for lpass hdmi driver")
Signed-off-by: Stephen Boyd <swboyd@chromium.org>
Reviewed-by: Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
Link: https://lore.kernel.org/r/20210115034327.617223-2-swboyd@chromium.org
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/soc/qcom/lpass-cpu.c |    1 -
 1 file changed, 1 deletion(-)

--- a/sound/soc/qcom/lpass-cpu.c
+++ b/sound/soc/qcom/lpass-cpu.c
@@ -743,7 +743,6 @@ static void of_lpass_cpu_parse_dai_data(
 		}
 		if (id == LPASS_DP_RX) {
 			data->hdmi_port_enable = 1;
-			dev_err(dev, "HDMI Port is enabled: %d\n", id);
 		} else {
 			data->mi2s_playback_sd_mode[id] =
 				of_lpass_cpu_parse_sd_lines(dev, node,


