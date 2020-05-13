Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2DF941D0E2E
	for <lists+stable@lfdr.de>; Wed, 13 May 2020 11:58:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388112AbgEMJyf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 13 May 2020 05:54:35 -0400
Received: from mail.kernel.org ([198.145.29.99]:56996 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388105AbgEMJyb (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 13 May 2020 05:54:31 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6D2A7205ED;
        Wed, 13 May 2020 09:54:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1589363670;
        bh=Gfi63/hHDSs12PkUQ2zqadY7CKv2HaQWnYt1yzmH+sI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=i0LIkoXGcj7hceyei4r60UElT2jennMNnmU82Lk0UG3oxbwQq2rBGxW1USv6hgxxR
         z+TCTtAoHmcFVnfXK4ro0B4xs92CyVJjNocytTmbVK2HtbvCJsZWBfYxYKajSSepHK
         UcmoMe4OHTF37k1y37VkM3s3TsyiIckR9VB/77M4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, "H. Nikolaus Schaller" <hns@goldelico.com>,
        Paul Cercueil <paul@crapouillou.net>
Subject: [PATCH 5.6 079/118] drm: ingenic-drm: add MODULE_DEVICE_TABLE
Date:   Wed, 13 May 2020 11:44:58 +0200
Message-Id: <20200513094424.471966317@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200513094417.618129545@linuxfoundation.org>
References: <20200513094417.618129545@linuxfoundation.org>
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
@@ -843,6 +843,7 @@ static const struct of_device_id ingenic
 	{ .compatible = "ingenic,jz4770-lcd", .data = &jz4770_soc_info },
 	{ /* sentinel */ },
 };
+MODULE_DEVICE_TABLE(of, ingenic_drm_of_match);
 
 static struct platform_driver ingenic_drm_driver = {
 	.driver = {


