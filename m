Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E24343739F3
	for <lists+stable@lfdr.de>; Wed,  5 May 2021 14:05:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233273AbhEEMGc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 5 May 2021 08:06:32 -0400
Received: from mail.kernel.org ([198.145.29.99]:44724 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233276AbhEEMGY (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 5 May 2021 08:06:24 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5DCAA61176;
        Wed,  5 May 2021 12:05:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1620216327;
        bh=ReSFvMJK/NtaG8TN4tfX8V5cylTcyQrqcd14EUr6yFQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=1mrv40lzsNuHjAFNnWZKHOFHRGiZtNE62StUJ4VXIJysKvORq7RdTm7snM/vHLrKJ
         li4C2zTnJW6RU7sL51sQvJ9V0z5IKjPc44Tl95lLfxHHF9FB37JWPjT9ivjdDMxJQm
         pQTCjSRvZW7y48KFZoDM9qRbgdDr8wV1k+qn7FU8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Shengjiu Wang <shengjiu.wang@nxp.com>,
        Mark Brown <broonie@kernel.org>
Subject: [PATCH 5.4 16/21] ASoC: ak4458: Add MODULE_DEVICE_TABLE
Date:   Wed,  5 May 2021 14:04:30 +0200
Message-Id: <20210505112325.263482990@linuxfoundation.org>
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
@@ -718,6 +718,7 @@ static struct i2c_driver ak4458_i2c_driv
 	.probe_new = ak4458_i2c_probe,
 	.remove = ak4458_i2c_remove,
 };
+MODULE_DEVICE_TABLE(of, ak4458_of_match);
 
 module_i2c_driver(ak4458_i2c_driver);
 


