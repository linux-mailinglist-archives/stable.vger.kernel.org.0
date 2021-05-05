Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A075C3739DF
	for <lists+stable@lfdr.de>; Wed,  5 May 2021 14:05:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233222AbhEEMGF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 5 May 2021 08:06:05 -0400
Received: from mail.kernel.org ([198.145.29.99]:43322 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233187AbhEEMF5 (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 5 May 2021 08:05:57 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6C99F61154;
        Wed,  5 May 2021 12:04:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1620216299;
        bh=Kg9XDvIRl/wDoyRZ1bXMceu42/FKsbFngzG5D9s4x3o=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=bN7jzTMZeXeN6C2DHDoW/DRfIcv9zpvWWp5d6SoNeeQLA07uWO6t5a/J5AgeRadGj
         wyb+UqMunPOt8HB5MRC4aauJsAQU2d8Z5BF0py5/CoIpqUbCT0FBHQ7cveRBwb5GgZ
         O/Cqdx4KyorkuSscWGy8dgCEV8S9qy5HCiTsGFCI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Shengjiu Wang <shengjiu.wang@nxp.com>,
        Mark Brown <broonie@kernel.org>
Subject: [PATCH 5.4 17/21] ASoC: ak5558: Add MODULE_DEVICE_TABLE
Date:   Wed,  5 May 2021 14:04:31 +0200
Message-Id: <20210505112325.297289588@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210505112324.729798712@linuxfoundation.org>
References: <20210505112324.729798712@linuxfoundation.org>
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
@@ -400,6 +400,7 @@ static struct i2c_driver ak5558_i2c_driv
 	.probe_new = ak5558_i2c_probe,
 	.remove = ak5558_i2c_remove,
 };
+MODULE_DEVICE_TABLE(of, ak5558_i2c_dt_ids);
 
 module_i2c_driver(ak5558_i2c_driver);
 


