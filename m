Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4A75C1D0D11
	for <lists+stable@lfdr.de>; Wed, 13 May 2020 11:50:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732715AbgEMJtx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 13 May 2020 05:49:53 -0400
Received: from mail.kernel.org ([198.145.29.99]:49212 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1733282AbgEMJtw (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 13 May 2020 05:49:52 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0BE4B206D6;
        Wed, 13 May 2020 09:49:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1589363392;
        bh=EmhaWnMJs2rNLcaSpb9zLJURxrpzqCuRzKcepAnQlmM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=eFsvQbXNy3K8aUDfh80QXZwLfLcAGMPXO9w3KHPGLzLOvrvjND0nCquDGlkG21OPp
         rYIfMAoNfTDSVZSeOJBMsdlbInUHrG2DIKWefPvoMDWMtoQ4xKwYfprf7NFIiZ11sn
         ZDuQI3ol9wWqaudmdhJeb4kOBIU5KEzdRerUd8hA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, "H. Nikolaus Schaller" <hns@goldelico.com>,
        Paul Cercueil <paul@crapouillou.net>
Subject: [PATCH 5.4 56/90] drm: ingenic-drm: add MODULE_DEVICE_TABLE
Date:   Wed, 13 May 2020 11:44:52 +0200
Message-Id: <20200513094415.324244497@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200513094408.810028856@linuxfoundation.org>
References: <20200513094408.810028856@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: H. Nikolaus Schaller <hns@goldelico.com>

commit c59359a02d14a7256cd508a4886b7d2012df2363 upstream.

so that the driver can load by matching the device tree
if compiled as module.

Cc: stable@vger.kernel.org # v5.3+
Fixes: 90b86fcc47b4 ("DRM: Add KMS driver for the Ingenic JZ47xx SoCs")
Signed-off-by: H. Nikolaus Schaller <hns@goldelico.com>
Signed-off-by: Paul Cercueil <paul@crapouillou.net>
Link: https://patchwork.freedesktop.org/patch/msgid/1694a29b7a3449b6b662cec33d1b33f2ee0b174a.1588574111.git.hns@goldelico.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/gpu/drm/ingenic/ingenic-drm.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/gpu/drm/ingenic/ingenic-drm.c
+++ b/drivers/gpu/drm/ingenic/ingenic-drm.c
@@ -824,6 +824,7 @@ static const struct of_device_id ingenic
 	{ .compatible = "ingenic,jz4725b-lcd", .data = &jz4725b_soc_info },
 	{ /* sentinel */ },
 };
+MODULE_DEVICE_TABLE(of, ingenic_drm_of_match);
 
 static struct platform_driver ingenic_drm_driver = {
 	.driver = {


