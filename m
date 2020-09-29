Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 48A5927C778
	for <lists+stable@lfdr.de>; Tue, 29 Sep 2020 13:54:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729066AbgI2Lpx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 29 Sep 2020 07:45:53 -0400
Received: from mail.kernel.org ([198.145.29.99]:45546 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730426AbgI2Lpb (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 29 Sep 2020 07:45:31 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 67A3920702;
        Tue, 29 Sep 2020 11:45:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1601379930;
        bh=X7NytKC4NDpM1sbWSgBP+na9NA7KoELsEMPmR3pssUE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=zdITD/Nr3lmfEMbhlVVndHxJqze9DBoUlVtdRcZPbzZw22sC7ZjbdIOwoxTDKe6ms
         sqDzWNJnEnoePVMS6vcaAWQpIe90aBycxYnlGbvNtkD1VirZxjXtJl2BEPBf2hVXCp
         GAPL09aEUlhjrXYmGQIhsDSBxDxbMf6R00nl4xQI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Martin Cerveny <m.cerveny@computer.org>,
        Jernej Skrabec <jernej.skrabec@siol.net>,
        Maxime Ripard <maxime@cerno.tech>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 351/388] drm/sun4i: sun8i-csc: Secondary CSC register correction
Date:   Tue, 29 Sep 2020 13:01:22 +0200
Message-Id: <20200929110027.455714234@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200929110010.467764689@linuxfoundation.org>
References: <20200929110010.467764689@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Martin Cerveny <m.cerveny@computer.org>

[ Upstream commit cab4c03b4ba54c8d9378298cacb8bc0fd74ceece ]

"Allwinner V3s" has secondary video layer (VI).
Decoded video is displayed in wrong colors until
secondary CSC registers are programmed correctly.

Fixes: 883029390550 ("drm/sun4i: Add DE2 CSC library")
Signed-off-by: Martin Cerveny <m.cerveny@computer.org>
Reviewed-by: Jernej Skrabec <jernej.skrabec@siol.net>
Signed-off-by: Maxime Ripard <maxime@cerno.tech>
Link: https://patchwork.freedesktop.org/patch/msgid/20200906162140.5584-2-m.cerveny@computer.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/sun4i/sun8i_csc.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/sun4i/sun8i_csc.h b/drivers/gpu/drm/sun4i/sun8i_csc.h
index f42441b1b14dd..a55a38ad849c1 100644
--- a/drivers/gpu/drm/sun4i/sun8i_csc.h
+++ b/drivers/gpu/drm/sun4i/sun8i_csc.h
@@ -12,7 +12,7 @@ struct sun8i_mixer;
 
 /* VI channel CSC units offsets */
 #define CCSC00_OFFSET 0xAA050
-#define CCSC01_OFFSET 0xFA000
+#define CCSC01_OFFSET 0xFA050
 #define CCSC10_OFFSET 0xA0000
 #define CCSC11_OFFSET 0xF0000
 
-- 
2.25.1



