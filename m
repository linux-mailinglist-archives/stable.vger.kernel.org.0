Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B7CA33441D8
	for <lists+stable@lfdr.de>; Mon, 22 Mar 2021 13:37:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231390AbhCVMg2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 22 Mar 2021 08:36:28 -0400
Received: from mail.kernel.org ([198.145.29.99]:57028 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231757AbhCVMfE (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 22 Mar 2021 08:35:04 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 536CE61931;
        Mon, 22 Mar 2021 12:34:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1616416497;
        bh=LR7agzxBL4O2xDBujyo+F2KjM7G5Pww7SPEqwuV/A40=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=surrGZDKwqWvP5MMKeq28F0W1JmhSMYuCm52QajyV9b+Q+x4SC5KIRrRh14kN39cC
         eeGftaOcjNJanSsdu34zMqSVROPooqwYWZxmu24/lP3povTdZn7bqkQzppsSm33F2d
         hj/weBPXZwi4IluZP+6jyCBHj2W1YMp+gC0lmuQ4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Shengjiu Wang <shengjiu.wang@nxp.com>,
        Mark Brown <broonie@kernel.org>
Subject: [PATCH 5.10 001/157] ASoC: ak4458: Add MODULE_DEVICE_TABLE
Date:   Mon, 22 Mar 2021 13:25:58 +0100
Message-Id: <20210322121933.793162657@linuxfoundation.org>
X-Mailer: git-send-email 2.31.0
In-Reply-To: <20210322121933.746237845@linuxfoundation.org>
References: <20210322121933.746237845@linuxfoundation.org>
User-Agent: quilt/0.66
X-stable: review
X-Patchwork-Hint: ignore
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Shengjiu Wang <shengjiu.wang@nxp.com>

commit 4ec5b96775a88dd9b1c3ba1d23c43c478cab95a2 upstream.

Add missed MODULE_DEVICE_TABLE for the driver can be loaded
automatically at boot.

Fixes: 08660086eff9 ("ASoC: ak4458: Add support for AK4458 DAC driver")
Cc: <stable@vger.kernel.org>
Signed-off-by: Shengjiu Wang <shengjiu.wang@nxp.com>
Link: https://lore.kernel.org/r/1614149872-25510-1-git-send-email-shengjiu.wang@nxp.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/soc/codecs/ak4458.c |    1 +
 1 file changed, 1 insertion(+)

--- a/sound/soc/codecs/ak4458.c
+++ b/sound/soc/codecs/ak4458.c
@@ -812,6 +812,7 @@ static const struct of_device_id ak4458_
 	{ .compatible = "asahi-kasei,ak4497", .data = &ak4497_drvdata},
 	{ },
 };
+MODULE_DEVICE_TABLE(of, ak4458_of_match);
 
 static struct i2c_driver ak4458_i2c_driver = {
 	.driver = {


