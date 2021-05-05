Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 373483739FB
	for <lists+stable@lfdr.de>; Wed,  5 May 2021 14:05:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233328AbhEEMGm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 5 May 2021 08:06:42 -0400
Received: from mail.kernel.org ([198.145.29.99]:45338 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233335AbhEEMGh (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 5 May 2021 08:06:37 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9000E61222;
        Wed,  5 May 2021 12:05:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1620216341;
        bh=D43CEFh8/2XTryuk4LBNw5hHX7BGGzaJdt4gIQk39sY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=D4wNxY6/mrO/JJrsqrxNm+q0ruW4kq889Ls7NnV0dBEpneRV329xVSQWo7PbEQ/kE
         XDOEPSbe6TxfhyNL3ySqrnEG1eSv4NL40zfMH0XV7R8IdPm2fmn+k8agHronHqpKCm
         7xwK9V0S1EqKcEWqN6L8HNyZuNxCJlHx7tchkgv0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Shengjiu Wang <shengjiu.wang@nxp.com>,
        Mark Brown <broonie@kernel.org>
Subject: [PATCH 4.19 12/15] ASoC: ak4458: Add MODULE_DEVICE_TABLE
Date:   Wed,  5 May 2021 14:05:17 +0200
Message-Id: <20210505120504.176996279@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210505120503.781531508@linuxfoundation.org>
References: <20210505120503.781531508@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Shengjiu Wang <shengjiu.wang@nxp.com>

commit f84b4524005238fc9fd5cf615bb426fa40a99494 upstream.

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
@@ -653,6 +653,7 @@ static struct i2c_driver ak4458_i2c_driv
 	.probe_new = ak4458_i2c_probe,
 	.remove = ak4458_i2c_remove,
 };
+MODULE_DEVICE_TABLE(of, ak4458_of_match);
 
 module_i2c_driver(ak4458_i2c_driver);
 


