Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 01F97409330
	for <lists+stable@lfdr.de>; Mon, 13 Sep 2021 16:19:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344242AbhIMOSy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Sep 2021 10:18:54 -0400
Received: from mail.kernel.org ([198.145.29.99]:36542 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S244830AbhIMOQr (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 13 Sep 2021 10:16:47 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 53C2661B07;
        Mon, 13 Sep 2021 13:44:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1631540678;
        bh=H/ydzq93aeLbVtV02Xop3vluAow9yzIJh75abIg4f0Y=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Gpug6zeRRc8oS0AOk1BXQUuXG2knp3B4SyEwtluVbAgV7iso96rC47d6dnFG1OLa5
         TlQs5tSCd1Aln7ugFLBg7J6ngA50fdcMdIToObtr3asdesrg0uXmmbLQzl0kxTqpr/
         pDetUTpXxT1ID/V2MmX8DRtFZQd+2j0NtXZc3J7E=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jarkko Sakkinen <jarkko@kernel.org>,
        Adrian Ratiu <adrian.ratiu@collabora.com>
Subject: [PATCH 5.13 291/300] char: tpm: Kconfig: remove bad i2c cr50 select
Date:   Mon, 13 Sep 2021 15:15:52 +0200
Message-Id: <20210913131119.181837561@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210913131109.253835823@linuxfoundation.org>
References: <20210913131109.253835823@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Adrian Ratiu <adrian.ratiu@collabora.com>

commit 847fdae1579f4ee930b01f24a7847b8043bf468c upstream.

This fixes a minor bug which went unnoticed during the initial
driver upstreaming review: TCG_CR50 does not exist in mainline
kernels, so remove it.

Fixes: 3a253caaad11 ("char: tpm: add i2c driver for cr50")
Cc: stable@vger.kernel.org
Reviewed-by: Jarkko Sakkinen <jarkko@kernel.org>
Signed-off-by: Adrian Ratiu <adrian.ratiu@collabora.com>
Signed-off-by: Jarkko Sakkinen <jarkko@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/char/tpm/Kconfig |    1 -
 1 file changed, 1 deletion(-)

--- a/drivers/char/tpm/Kconfig
+++ b/drivers/char/tpm/Kconfig
@@ -89,7 +89,6 @@ config TCG_TIS_SYNQUACER
 config TCG_TIS_I2C_CR50
 	tristate "TPM Interface Specification 2.0 Interface (I2C - CR50)"
 	depends on I2C
-	select TCG_CR50
 	help
 	  This is a driver for the Google cr50 I2C TPM interface which is a
 	  custom microcontroller and requires a custom i2c protocol interface


