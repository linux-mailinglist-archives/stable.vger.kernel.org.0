Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C3DF812298
	for <lists+stable@lfdr.de>; Thu,  2 May 2019 21:32:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726138AbfEBTcC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 2 May 2019 15:32:02 -0400
Received: from mail-io1-f65.google.com ([209.85.166.65]:38635 "EHLO
        mail-io1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725962AbfEBTcC (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 2 May 2019 15:32:02 -0400
Received: by mail-io1-f65.google.com with SMTP id y6so3248518ior.5
        for <stable@vger.kernel.org>; Thu, 02 May 2019 12:32:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=ILaqFKrZSUHgd2yT3DIINx7+NJ9LGW1Bcu1j0Oy8loM=;
        b=NooMGiY6dOHwgaGzVC+9/2lW4jTTv+l9FQR9IrNttzNsnlFuN8f6y87boRxlxYDjOA
         chxKT8uBV7cb1tE48yc40YypKyvj/hANeeHNsndDrazWWzHKiUxbm0ChVdEORnAX9Ybm
         EcfJ1iRizYjT8/xObgZ/9dnrtgRwSCyJLPy8v3Q42JDqAaaZelfHWyOyQELorhKzPueR
         XvJhKffedxgKqyHUchYius6KuvvbuDcV8CAJvgioWN1nJipxXz5UVv7WNrtDjTZUw4xu
         UY2lCSxbimhYM6YywmUhUjXzc5EK7p+ptwgqA1fteAfwZeAxn9O2nWQvCnmxv88mVn87
         HU0A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=ILaqFKrZSUHgd2yT3DIINx7+NJ9LGW1Bcu1j0Oy8loM=;
        b=BQ24BoL9Y+hkMSu+UCOySFpvTF4bcXOwrfxALC2NQmF8uiL1dQspdt0xkbtJLlCtQN
         RnHrQ0KlJCnNXh/1v80Flk/Y8IhNUY8Elr+oOdmsaewbhPJx23dM7HhswQK4vhtAJLHe
         NJFMduKtBzfSjZYt2ugMAcLhIE82EyK+cQx9vuIr2kJj9GZqqbzJdXJvy6APsObh7Wes
         CD4wfcR36NL/0soRnYyFkIlsb+ogkCzayfnUf2qdw2gKP7vmrzbC3ks4J9w6v+dzwfsL
         Y+s6EG/bP4+bNuopsXNK3nWRAuTL9LSTtg4OPTsUx1fyyWP1qT+Heu1ynxj8KtPon8Me
         RKlg==
X-Gm-Message-State: APjAAAX9gd7kM2NRG5UNzMcDNOmY3GbvGfbanT8Ly9yzHTfo0qh8PmfQ
        StfT+oppAWCSBk+WGjSDd3M=
X-Google-Smtp-Source: APXvYqxH/q4OhSSO3Yloqy/WwoxP53tc0R6aI8Li1dSaK/woTmSEJ/aEPD+Wq8nUA5Zw5BIK40G/2A==
X-Received: by 2002:a6b:c0c6:: with SMTP id q189mr4134713iof.283.1556825521784;
        Thu, 02 May 2019 12:32:01 -0700 (PDT)
Received: from andres-vr.valvesoftware.com (135-23-65-40.cpe.pppoe.ca. [135.23.65.40])
        by smtp.gmail.com with ESMTPSA id 3sm5213173itk.1.2019.05.02.12.32.00
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 02 May 2019 12:32:00 -0700 (PDT)
From:   Andres Rodriguez <andresx7@gmail.com>
To:     dri-devel@lists.freedesktop.org
Cc:     Andres Rodriguez <andresx7@gmail.com>,
        Dave Airlie <airlied@redhat.com>, stable@vger.kernel.org
Subject: [PATCH] drm: add non-desktop quirk for Valve HMDs
Date:   Thu,  2 May 2019 15:31:57 -0400
Message-Id: <20190502193157.15692-1-andresx7@gmail.com>
X-Mailer: git-send-email 2.19.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Add vendor/product pairs for the Valve Index HMDs.

Signed-off-by: Andres Rodriguez <andresx7@gmail.com>
Cc: Dave Airlie <airlied@redhat.com>
Cc: <stable@vger.kernel.org> # v4.15
---
 drivers/gpu/drm/drm_edid.c | 19 +++++++++++++++++++
 1 file changed, 19 insertions(+)

diff --git a/drivers/gpu/drm/drm_edid.c b/drivers/gpu/drm/drm_edid.c
index 2c22ea446075..649cfd8b4200 100644
--- a/drivers/gpu/drm/drm_edid.c
+++ b/drivers/gpu/drm/drm_edid.c
@@ -162,6 +162,25 @@ static const struct edid_quirk {
 	/* Rotel RSX-1058 forwards sink's EDID but only does HDMI 1.1*/
 	{ "ETR", 13896, EDID_QUIRK_FORCE_8BPC },
 
+	/* Valve Index Headset */
+	{ "VLV", 0x91a8, EDID_QUIRK_NON_DESKTOP },
+	{ "VLV", 0x91b0, EDID_QUIRK_NON_DESKTOP },
+	{ "VLV", 0x91b1, EDID_QUIRK_NON_DESKTOP },
+	{ "VLV", 0x91b2, EDID_QUIRK_NON_DESKTOP },
+	{ "VLV", 0x91b3, EDID_QUIRK_NON_DESKTOP },
+	{ "VLV", 0x91b4, EDID_QUIRK_NON_DESKTOP },
+	{ "VLV", 0x91b5, EDID_QUIRK_NON_DESKTOP },
+	{ "VLV", 0x91b6, EDID_QUIRK_NON_DESKTOP },
+	{ "VLV", 0x91b7, EDID_QUIRK_NON_DESKTOP },
+	{ "VLV", 0x91b8, EDID_QUIRK_NON_DESKTOP },
+	{ "VLV", 0x91b9, EDID_QUIRK_NON_DESKTOP },
+	{ "VLV", 0x91ba, EDID_QUIRK_NON_DESKTOP },
+	{ "VLV", 0x91bb, EDID_QUIRK_NON_DESKTOP },
+	{ "VLV", 0x91bc, EDID_QUIRK_NON_DESKTOP },
+	{ "VLV", 0x91bd, EDID_QUIRK_NON_DESKTOP },
+	{ "VLV", 0x91be, EDID_QUIRK_NON_DESKTOP },
+	{ "VLV", 0x91bf, EDID_QUIRK_NON_DESKTOP },
+
 	/* HTC Vive and Vive Pro VR Headsets */
 	{ "HVR", 0xaa01, EDID_QUIRK_NON_DESKTOP },
 	{ "HVR", 0xaa02, EDID_QUIRK_NON_DESKTOP },
-- 
2.19.1

