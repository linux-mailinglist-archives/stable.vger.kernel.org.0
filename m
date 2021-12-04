Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BFE274687A6
	for <lists+stable@lfdr.de>; Sat,  4 Dec 2021 22:32:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354805AbhLDVfh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 4 Dec 2021 16:35:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41556 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231646AbhLDVfh (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 4 Dec 2021 16:35:37 -0500
Received: from mail-wr1-x42c.google.com (mail-wr1-x42c.google.com [IPv6:2a00:1450:4864:20::42c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5A46CC061751
        for <stable@vger.kernel.org>; Sat,  4 Dec 2021 13:32:11 -0800 (PST)
Received: by mail-wr1-x42c.google.com with SMTP id d9so13632026wrw.4
        for <stable@vger.kernel.org>; Sat, 04 Dec 2021 13:32:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=baylibre-com.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=RkY3blJ2Gldzm+0qHRdrD81J+3rGk6mYv8Gy9C8RedM=;
        b=aqZqdI52CCuOAzXWDjKPlSTeHkT8Hj7N35FGkJQXpRJXcBTbw6LMePty77LTPMmNNL
         vYkgtDk9ub3H9STsrSWnmqf49LC7f6YoetGg8f6nubRf/GlGzvPzU7kDYXFXds8JVxQj
         aKCJWivUG4hJ9WyjDtbHoYPMWt5xn3pDSwdMIeuT4MIsIZy1PD/DL4EKKCtsk76arzhq
         IdF1UG5oo1HFBwe90zGSAu5PxRlSM9ZB66C2aCVfKv9wRyeD6oUCLke/SWuJraXPdalI
         Of910fz47WNMsHc1Cbq1OcX7NLNcDLeT0Yn6faN5FJ24e2cx/LrSVklwsveiuKsZrXnG
         0b+Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=RkY3blJ2Gldzm+0qHRdrD81J+3rGk6mYv8Gy9C8RedM=;
        b=IwnrKJTJtjagb+2Onw3KIkme5FbSaAOr39WmrQyOuMR94tjQmMvQe9nIC2nvHGhhPU
         zYDGzxvB+S5wVBgqCrljDdCK7/T3w/DioNB/MXiIErlAKxvDBVxnRhW0ugTNFLREqYX5
         U347r9hFxZDJgayIQvvzMJ/lLtzdW2/2dAZ5Iubo6+zC0J19NkxMMhFPl34ndTJKNxHS
         lOOn1yWPGSDJco/NGwjHxMAclfXHvzhRth5UNp1HYz1dH0NPXrhqhhXLlTRgibwsXGZ0
         s9Zi7+73ytbMKehhjHYSeOxF65FsrschLTwpi3oUf1v7TftgHZcSjsDkktdHBM2qVwUX
         hQpQ==
X-Gm-Message-State: AOAM531gkEvBDmhsX1ADJvIbNszJom4k0DAtbZKc9M3CM0PWo4Y0DOLQ
        C9SIV7pk1aEZuT6/Am4MSPswjA==
X-Google-Smtp-Source: ABdhPJySTG4c/z2C68cNyuWV71sWaNj8aQK267LRo47C1gEMe3wfNA9R9GzwZ1O6OlP6rHjs2wFPXA==
X-Received: by 2002:a05:6000:381:: with SMTP id u1mr32036226wrf.383.1638653529560;
        Sat, 04 Dec 2021 13:32:09 -0800 (PST)
Received: from jackdaw.lan (82-65-169-74.subs.proxad.net. [82.65.169.74])
        by smtp.googlemail.com with ESMTPSA id n184sm8980868wme.2.2021.12.04.13.32.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 04 Dec 2021 13:32:09 -0800 (PST)
From:   Jerome Brunet <jbrunet@baylibre.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org
Cc:     Jerome Brunet <jbrunet@baylibre.com>,
        linux-amlogic@lists.infradead.org, Artem Lapkin <art@khadas.com>,
        Kevin Hilman <khilman@baylibre.com>,
        Neil Armstrong <narmstrong@baylibre.com>
Subject: [PATCH 5.10] Revert "drm: meson_drv add shutdown function"
Date:   Sat,  4 Dec 2021 22:31:57 +0100
Message-Id: <20211204213157.27551-1-jbrunet@baylibre.com>
X-Mailer: git-send-email 2.34.0
In-Reply-To: <20210315135545.132503808@linuxfoundation.org>
References: <20210315135545.132503808@linuxfoundation.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This reverts commit d66083c0d6f5125a4d982aa177dd71ab4cd3d212
and commit d4ec1ffbdaa8939a208656e9c1440742c457ef16.

On v5.10 stable, reboot gets stuck on gxl and g12a chip family (at least).
This was tested on the aml-s905x-cc from libretch and the u200 reference
design.

Bisecting on the v5.10 stable branch lead to
commit d4ec1ffbdaa8 ("drm: meson_drv add shutdown function").

Reverting it (and a fixes on the it) sloves the problem.

Signed-off-by: Jerome Brunet <jbrunet@baylibre.com>
---

Hi Greg,

Things are fine on master but it breaks on v5.10-y.
I did not check v5.14-y yet. I'll try next week.


 drivers/gpu/drm/meson/meson_drv.c | 12 ------------
 1 file changed, 12 deletions(-)

diff --git a/drivers/gpu/drm/meson/meson_drv.c b/drivers/gpu/drm/meson/meson_drv.c
index 2753067c08e6..3d1de9cbb1c8 100644
--- a/drivers/gpu/drm/meson/meson_drv.c
+++ b/drivers/gpu/drm/meson/meson_drv.c
@@ -482,17 +482,6 @@ static int meson_probe_remote(struct platform_device *pdev,
 	return count;
 }
 
-static void meson_drv_shutdown(struct platform_device *pdev)
-{
-	struct meson_drm *priv = dev_get_drvdata(&pdev->dev);
-
-	if (!priv)
-		return;
-
-	drm_kms_helper_poll_fini(priv->drm);
-	drm_atomic_helper_shutdown(priv->drm);
-}
-
 static int meson_drv_probe(struct platform_device *pdev)
 {
 	struct component_match *match = NULL;
@@ -564,7 +553,6 @@ static const struct dev_pm_ops meson_drv_pm_ops = {
 
 static struct platform_driver meson_drm_platform_driver = {
 	.probe      = meson_drv_probe,
-	.shutdown   = meson_drv_shutdown,
 	.driver     = {
 		.name	= "meson-drm",
 		.of_match_table = dt_match,
-- 
2.34.0

