Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 76DBE373A54
	for <lists+stable@lfdr.de>; Wed,  5 May 2021 14:09:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233639AbhEEMKF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 5 May 2021 08:10:05 -0400
Received: from mail.kernel.org ([198.145.29.99]:53680 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233759AbhEEMJ2 (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 5 May 2021 08:09:28 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3D0FF613C4;
        Wed,  5 May 2021 12:08:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1620216483;
        bh=sLXzNJfNNAwUVZkwkW/4vZLgIZ1OoV+SFmCkcbn/5F0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=X1GmeFh6DVs1452z4FjfO5CNHQnGKbGAaX30/hXHSawZgdboUf5bE8QHpX/qf+fa7
         7zDiX6f47Wq6ygHRcuIZ+WIELtLDHPzOCny8XGOBF7ADvneiPbaY905oyFMl3C8HRy
         euGLzWyg6wMmSjnDd3kPvJrv3zZgomFhSaLNczDI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Shengjiu Wang <shengjiu.wang@nxp.com>,
        Mark Brown <broonie@kernel.org>
Subject: [PATCH 5.12 15/17] ASoC: ak5558: Add MODULE_DEVICE_TABLE
Date:   Wed,  5 May 2021 14:06:10 +0200
Message-Id: <20210505112325.447507423@linuxfoundation.org>
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
@@ -430,6 +430,7 @@ static struct i2c_driver ak5558_i2c_driv
 	.probe_new = ak5558_i2c_probe,
 	.remove = ak5558_i2c_remove,
 };
+MODULE_DEVICE_TABLE(of, ak5558_i2c_dt_ids);
 
 module_i2c_driver(ak5558_i2c_driver);
 


