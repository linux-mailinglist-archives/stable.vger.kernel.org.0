Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F147E3739FE
	for <lists+stable@lfdr.de>; Wed,  5 May 2021 14:06:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233368AbhEEMGs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 5 May 2021 08:06:48 -0400
Received: from mail.kernel.org ([198.145.29.99]:45068 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233308AbhEEMGj (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 5 May 2021 08:06:39 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id ECE2C613C7;
        Wed,  5 May 2021 12:05:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1620216343;
        bh=bC3ef4u67Brh5Gfv4jVGl8QIziT3OxuFz7Byly6W42o=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=b3/Qfx2gI7oogcgby/x5QrWwCONpWv+bUcTAOpEI9iSCmHLaQslj5FXXuSuyk+XV1
         iHXIwVyXw6/IbY1L1hXn5vuv+OP7evhxP02aZgfo2tds2h0GE+F/6JfzZSIOUkSm0X
         7y6MOGBtOJC4D+Y/p8yZN/Be3B4pYZWJCGup8f1I=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Shengjiu Wang <shengjiu.wang@nxp.com>,
        Mark Brown <broonie@kernel.org>
Subject: [PATCH 4.19 13/15] ASoC: ak5558: Add MODULE_DEVICE_TABLE
Date:   Wed,  5 May 2021 14:05:18 +0200
Message-Id: <20210505120504.206500486@linuxfoundation.org>
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

commit 741c8397e5d0b339fb3e614a9ff5cb4bf7ae1a65 upstream.

Add missed MODULE_DEVICE_TABLE for the driver can be loaded
automatically at boot.

Fixes: 920884777480 ("ASoC: ak5558: Add support for AK5558 ADC driver")
Cc: <stable@vger.kernel.org>
Signed-off-by: Shengjiu Wang <shengjiu.wang@nxp.com>
Link: https://lore.kernel.org/r/1614149872-25510-2-git-send-email-shengjiu.wang@nxp.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/soc/codecs/ak5558.c |    1 +
 1 file changed, 1 insertion(+)

--- a/sound/soc/codecs/ak5558.c
+++ b/sound/soc/codecs/ak5558.c
@@ -407,6 +407,7 @@ static struct i2c_driver ak5558_i2c_driv
 	.probe_new = ak5558_i2c_probe,
 	.remove = ak5558_i2c_remove,
 };
+MODULE_DEVICE_TABLE(of, ak5558_i2c_dt_ids);
 
 module_i2c_driver(ak5558_i2c_driver);
 


