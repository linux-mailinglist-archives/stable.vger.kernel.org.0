Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F0D5440960B
	for <lists+stable@lfdr.de>; Mon, 13 Sep 2021 16:47:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344763AbhIMOrZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Sep 2021 10:47:25 -0400
Received: from mail.kernel.org ([198.145.29.99]:60466 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1346230AbhIMOpS (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 13 Sep 2021 10:45:18 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id C2463619F6;
        Mon, 13 Sep 2021 13:58:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1631541499;
        bh=H/ydzq93aeLbVtV02Xop3vluAow9yzIJh75abIg4f0Y=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=OsSCqlX3jOu5q9UgVP4KsOMUsK3rArLFyIYTQy6IztpYvvp+3y5CI9lCZd+Tj6+AI
         F43QDNG6jWEDZ3Vy8f2FRy6ge9NZeBvYTGLgQ1BLbYrEgCokW7qq8UVjHie3Q+mIVx
         h2WtX9Meh4yUXypzNVKdgvTEJ+oyDGBcg2hfV30I=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jarkko Sakkinen <jarkko@kernel.org>,
        Adrian Ratiu <adrian.ratiu@collabora.com>
Subject: [PATCH 5.14 322/334] char: tpm: Kconfig: remove bad i2c cr50 select
Date:   Mon, 13 Sep 2021 15:16:16 +0200
Message-Id: <20210913131124.320311581@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210913131113.390368911@linuxfoundation.org>
References: <20210913131113.390368911@linuxfoundation.org>
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


