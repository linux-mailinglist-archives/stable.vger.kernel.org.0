Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8A39413FDA3
	for <lists+stable@lfdr.de>; Fri, 17 Jan 2020 00:30:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390236AbgAPX1b (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Jan 2020 18:27:31 -0500
Received: from mail.kernel.org ([198.145.29.99]:59398 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390190AbgAPX1b (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 Jan 2020 18:27:31 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D15ED20684;
        Thu, 16 Jan 2020 23:27:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579217250;
        bh=bfIGJ+MzNic2R6MQU04yvtS9AYnzU9GwJyidIlkxefY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=LZCKWibroajxeMmJkorue8AUHoCOeExf5/WG88sB+/Nrmh8j62sSJNGzRAx9+OUQi
         7lgMJ8rkuCha74BOAb0EFnuXwyZaDjCZL22Iw0euwhsLeKHbUKJ0eJZFFoxm6WmDDs
         NS3T5xrW9xb82TCSSlC/yu2nqYQya0sqbR+imU/A=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        "Ben Dooks (Codethink)" <ben.dooks@codethink.co.uk>,
        Liviu Dudau <Liviu.Dudau@arm.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 191/203] drm/arm/mali: make malidp_mw_connector_helper_funcs static
Date:   Fri, 17 Jan 2020 00:18:28 +0100
Message-Id: <20200116231800.940245236@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200116231745.218684830@linuxfoundation.org>
References: <20200116231745.218684830@linuxfoundation.org>
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
index 875a3a9eabfa..7d0e7b031e44 100644
--- a/drivers/gpu/drm/arm/malidp_mw.c
+++ b/drivers/gpu/drm/arm/malidp_mw.c
@@ -56,7 +56,7 @@ malidp_mw_connector_mode_valid(struct drm_connector *connector,
 	return MODE_OK;
 }
 
-const struct drm_connector_helper_funcs malidp_mw_connector_helper_funcs = {
+static const struct drm_connector_helper_funcs malidp_mw_connector_helper_funcs = {
 	.get_modes = malidp_mw_connector_get_modes,
 	.mode_valid = malidp_mw_connector_mode_valid,
 };
-- 
2.20.1



