Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4FE7D373A56
	for <lists+stable@lfdr.de>; Wed,  5 May 2021 14:09:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233646AbhEEMKI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 5 May 2021 08:10:08 -0400
Received: from mail.kernel.org ([198.145.29.99]:50342 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233758AbhEEMJ2 (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 5 May 2021 08:09:28 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id DA5A8613C0;
        Wed,  5 May 2021 12:08:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1620216481;
        bh=MiPXZre8KlbHSL12Q2OeNCZNaDN15rE92NK/WpPJIlw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=nUHvsuBZgLVQYuJWYdqgYSC0f1gGylqPDjfOmTpnjvJW8cHvoNbvvWoP5DeXHrz1t
         oeD3m9Dgq4B+xrBlVAsYKdK0tQjq/BJYn8FW7XPfyPP2ibC1iDJiy9D3OrE9c6ukp3
         wYKoNEPlulFWbW7IUwURfnkHLA0bqaXZ1DShNIU4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Shengjiu Wang <shengjiu.wang@nxp.com>,
        Mark Brown <broonie@kernel.org>
Subject: [PATCH 5.12 14/17] ASoC: ak4458: Add MODULE_DEVICE_TABLE
Date:   Wed,  5 May 2021 14:06:09 +0200
Message-Id: <20210505112325.418662812@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210505112324.956720416@linuxfoundation.org>
References: <20210505112324.956720416@linuxfoundation.org>
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
@@ -823,6 +823,7 @@ static struct i2c_driver ak4458_i2c_driv
 	.probe_new = ak4458_i2c_probe,
 	.remove = ak4458_i2c_remove,
 };
+MODULE_DEVICE_TABLE(of, ak4458_of_match);
 
 module_i2c_driver(ak4458_i2c_driver);
 


