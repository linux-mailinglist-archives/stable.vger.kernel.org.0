Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 45F6F13FE9D
	for <lists+stable@lfdr.de>; Fri, 17 Jan 2020 00:36:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2403912AbgAPXb2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Jan 2020 18:31:28 -0500
Received: from mail.kernel.org ([198.145.29.99]:37398 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2403989AbgAPXaa (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 Jan 2020 18:30:30 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3C77220684;
        Thu, 16 Jan 2020 23:30:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579217429;
        bh=kAOaVjnWMYC/RpKKbmuTL0WR4dJhxwrxKVKAogktUJ4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=IWJd1ifoBSXf0XPrptx/XFKOuxAmU4hvVSEtvN9Mie4DYahIgM9shjciwMoy09m/b
         JU/vBqOK3Mf6K9/EXrFeZE+JWdNwKravHX2q+PW8x8N+jBqpQtx1wesgIkd8ZEXOt2
         hT8/jiwmOEDTJwgrspagaVraOrtwACpMd5KEHCj4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        "Ben Dooks (Codethink)" <ben.dooks@codethink.co.uk>,
        Liviu Dudau <Liviu.Dudau@arm.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 79/84] drm/arm/mali: make malidp_mw_connector_helper_funcs static
Date:   Fri, 17 Jan 2020 00:18:53 +0100
Message-Id: <20200116231722.790733579@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200116231713.087649517@linuxfoundation.org>
References: <20200116231713.087649517@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ben Dooks (Codethink) <ben.dooks@codethink.co.uk>

[ Upstream commit ac2917b01992c098b8d4e6837115e3ca347fdd90 ]

The malidp_mw_connector_helper_funcs is not referenced by name
outside of the file it is in, so make it static to avoid the
following warning:

drivers/gpu/drm/arm/malidp_mw.c:59:41: warning: symbol 'malidp_mw_connector_helper_funcs' was not declared. Should it be static?

Signed-off-by: Ben Dooks (Codethink) <ben.dooks@codethink.co.uk>
Signed-off-by: Liviu Dudau <Liviu.Dudau@arm.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20191217115309.2133503-1-ben.dooks@codethink.co.uk
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/arm/malidp_mw.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/arm/malidp_mw.c b/drivers/gpu/drm/arm/malidp_mw.c
index 91472e5e0c8b..7266d3c8b8f4 100644
--- a/drivers/gpu/drm/arm/malidp_mw.c
+++ b/drivers/gpu/drm/arm/malidp_mw.c
@@ -55,7 +55,7 @@ malidp_mw_connector_mode_valid(struct drm_connector *connector,
 	return MODE_OK;
 }
 
-const struct drm_connector_helper_funcs malidp_mw_connector_helper_funcs = {
+static const struct drm_connector_helper_funcs malidp_mw_connector_helper_funcs = {
 	.get_modes = malidp_mw_connector_get_modes,
 	.mode_valid = malidp_mw_connector_mode_valid,
 };
-- 
2.20.1



