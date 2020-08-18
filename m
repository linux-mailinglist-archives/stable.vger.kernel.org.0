Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 45B8D248A1A
	for <lists+stable@lfdr.de>; Tue, 18 Aug 2020 17:40:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726624AbgHRPkE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 18 Aug 2020 11:40:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34872 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726701AbgHRPjo (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 18 Aug 2020 11:39:44 -0400
Received: from mail-qk1-x743.google.com (mail-qk1-x743.google.com [IPv6:2607:f8b0:4864:20::743])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1397AC061389
        for <stable@vger.kernel.org>; Tue, 18 Aug 2020 08:39:29 -0700 (PDT)
Received: by mail-qk1-x743.google.com with SMTP id p25so18674642qkp.2
        for <stable@vger.kernel.org>; Tue, 18 Aug 2020 08:39:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=poorly.run; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=JlEbaHYaR5iCAEHZAy8fYMv93f5e3wjmXyGrPqhBCZY=;
        b=G8WqgCJWf/cSOJWN1YwgLgYjl7wOqScGHsqWTRi0Oic2r+4MJ/iqaPsff45VFfef/5
         JHxx40McViCZ8m/7Vt2xwrEHQLRjWP0QWHn+LMFfRGRTS0yTNkU1VeYZ1SbNC1hsdI0+
         ybq8zraAr5I2inGeX+qhNqJRhd9b2bJx8A+w/+pmq7Tdk/E958S+PTl3U1beawBHzczw
         brnXjYD9zWOju60MpHKxE91f51DcuwGloiXIllkaNMm5Q75+6Zj3qfk2+gwMlxFy0hWs
         GkOkCc+xydDNUwFsZFszmFbPoiQpXoNYCIZr3+q3frtzGXNywPZA1oQQPRauNmVfoBxq
         TCrQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=JlEbaHYaR5iCAEHZAy8fYMv93f5e3wjmXyGrPqhBCZY=;
        b=NxGwHd8FTZ8frAv0LsMxtWzNJJPMH169wUIk5/uXjWwcMAELdGbMa4ksg3n7nVzA7K
         vzoxdOAxp/aCMZ+mk6t+bHbGW9ppnJK67K7MOVs0f/Kzorpo8Dh5WrPDws/KlbST6oOd
         FETHRtueWol3zZRVIrDXKg53dmYZVbju0DD2mjtSUU4e3mzvQp1BH6FpebpXRpG2IEUq
         82w3mzczsheWBCi1dSQ8jIz5yPKb8g6VQLJKboBQ+BV8KE/phnA5DGpA3J8pdAvhiYZA
         6Npm+cl5iA4L98tFC+LtQVtxtlCJJmwF0MITI7dMg85UXixhGfOhcZbUWpPx2H0MMQ0d
         4P8w==
X-Gm-Message-State: AOAM531mEsvgcCV9WkmKH3/BOIehIiMg4RxuYS7X9n9qoekhUktLXaes
        nnuqk1QG1/w+sU9qBapWc6qGwg==
X-Google-Smtp-Source: ABdhPJyWrXPmAGKOml4LMyT67XExakcnnORvvugGrEJfCi/AFsob84q06g44W5yAWZ95MQk8gtT1sw==
X-Received: by 2002:a37:a848:: with SMTP id r69mr17014058qke.58.1597765168772;
        Tue, 18 Aug 2020 08:39:28 -0700 (PDT)
Received: from localhost (mobile-166-170-57-144.mycingular.net. [166.170.57.144])
        by smtp.gmail.com with ESMTPSA id a20sm23937189qtw.45.2020.08.18.08.39.28
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Tue, 18 Aug 2020 08:39:28 -0700 (PDT)
From:   Sean Paul <sean@poorly.run>
To:     dri-devel@lists.freedesktop.org, intel-gfx@lists.freedesktop.org,
        juston.li@intel.com, jani.nikula@linux.intel.com,
        joonas.lahtinen@linux.intel.com, rodrigo.vivi@intel.com,
        anshuman.gupta@intel.com
Cc:     ville.syrjala@linux.intel.com, daniel.vetter@ffwll.ch,
        Sean Paul <seanpaul@chromium.org>,
        Chris Wilson <chris@chris-wilson.co.uk>,
        Ramalingam C <ramalingam.c@intel.com>, stable@vger.kernel.org,
        David Airlie <airlied@linux.ie>,
        Daniel Vetter <daniel@ffwll.ch>,
        Maarten Lankhorst <maarten.lankhorst@linux.intel.com>,
        Maxime Ripard <mripard@kernel.org>,
        Thomas Zimmermann <tzimmermann@suse.de>,
        Ramalingam C <ramalingm.c@intel.com>
Subject: [PATCH v8 01/17] drm/i915: Fix sha_text population code
Date:   Tue, 18 Aug 2020 11:38:49 -0400
Message-Id: <20200818153910.27894-2-sean@poorly.run>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200818153910.27894-1-sean@poorly.run>
References: <20200818153910.27894-1-sean@poorly.run>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sean Paul <seanpaul@chromium.org>

This patch fixes a few bugs:

1- We weren't taking into account sha_leftovers when adding multiple
   ksvs to sha_text. As such, we were or'ing the end of ksv[j - 1] with
   the beginning of ksv[j]

2- In the sha_leftovers == 2 and sha_leftovers == 3 case, bstatus was
   being placed on the wrong half of sha_text, overlapping the leftover
   ksv value

3- In the sha_leftovers == 2 case, we need to manually terminate the
   byte stream with 0x80 since the hardware doesn't have enough room to
   add it after writing M0

The upside is that all of the HDCP supported HDMI repeaters I could
find on Amazon just strip HDCP anyways, so it turns out to be _really_
hard to hit any of these cases without an MST hub, which is not (yet)
supported. Oh, and the sha_leftovers == 1 case works perfectly!

Fixes: ee5e5e7a5e0f (drm/i915: Add HDCP framework + base implementation)
Cc: Chris Wilson <chris@chris-wilson.co.uk>
Cc: Ramalingam C <ramalingam.c@intel.com>
Cc: Daniel Vetter <daniel.vetter@ffwll.ch>
Cc: Sean Paul <seanpaul@chromium.org>
Cc: Jani Nikula <jani.nikula@linux.intel.com>
Cc: Joonas Lahtinen <joonas.lahtinen@linux.intel.com>
Cc: Rodrigo Vivi <rodrigo.vivi@intel.com>
Cc: intel-gfx@lists.freedesktop.org
Cc: <stable@vger.kernel.org> # v4.17+
Reviewed-by: Ramalingam C <ramalingam.c@intel.com>
Signed-off-by: Sean Paul <seanpaul@chromium.org>
Link: https://patchwork.freedesktop.org/patch/msgid/20191203173638.94919-2-sean@poorly.run #v1
Link: https://patchwork.freedesktop.org/patch/msgid/20191212190230.188505-2-sean@poorly.run #v2
Link: https://patchwork.freedesktop.org/patch/msgid/20200117193103.156821-2-sean@poorly.run #v3
Link: https://patchwork.freedesktop.org/patch/msgid/20200218220242.107265-2-sean@poorly.run #v4
Link: https://patchwork.freedesktop.org/patch/msgid/20200305201236.152307-2-sean@poorly.run #v5
Link: https://patchwork.freedesktop.org/patch/msgid/20200429195502.39919-2-sean@poorly.run #v6
Link: https://patchwork.freedesktop.org/patch/msgid/20200623155907.22961-2-sean@poorly.run #v7

Changes in v2:
-None
Changes in v3:
-None
Changes in v4:
-Rebased on intel_de_write changes
Changes in v5:
-None
Changes in v6:
-None
Changes in v7:
-None
Changes in v8:
-None
---
 drivers/gpu/drm/i915/display/intel_hdcp.c | 26 +++++++++++++++++------
 include/drm/drm_hdcp.h                    |  3 +++
 2 files changed, 23 insertions(+), 6 deletions(-)

diff --git a/drivers/gpu/drm/i915/display/intel_hdcp.c b/drivers/gpu/drm/i915/display/intel_hdcp.c
index 89a4d294822d..6189b7583277 100644
--- a/drivers/gpu/drm/i915/display/intel_hdcp.c
+++ b/drivers/gpu/drm/i915/display/intel_hdcp.c
@@ -336,8 +336,10 @@ int intel_hdcp_validate_v_prime(struct intel_connector *connector,
 
 		/* Fill up the empty slots in sha_text and write it out */
 		sha_empty = sizeof(sha_text) - sha_leftovers;
-		for (j = 0; j < sha_empty; j++)
-			sha_text |= ksv[j] << ((sizeof(sha_text) - j - 1) * 8);
+		for (j = 0; j < sha_empty; j++) {
+			u8 off = ((sizeof(sha_text) - j - 1 - sha_leftovers) * 8);
+			sha_text |= ksv[j] << off;
+		}
 
 		ret = intel_write_sha_text(dev_priv, sha_text);
 		if (ret < 0)
@@ -435,7 +437,7 @@ int intel_hdcp_validate_v_prime(struct intel_connector *connector,
 		/* Write 32 bits of text */
 		intel_de_write(dev_priv, HDCP_REP_CTL,
 			       rep_ctl | HDCP_SHA1_TEXT_32);
-		sha_text |= bstatus[0] << 24 | bstatus[1] << 16;
+		sha_text |= bstatus[0] << 8 | bstatus[1];
 		ret = intel_write_sha_text(dev_priv, sha_text);
 		if (ret < 0)
 			return ret;
@@ -450,17 +452,29 @@ int intel_hdcp_validate_v_prime(struct intel_connector *connector,
 				return ret;
 			sha_idx += sizeof(sha_text);
 		}
+
+		/*
+		 * Terminate the SHA-1 stream by hand. For the other leftover
+		 * cases this is appended by the hardware.
+		 */
+		intel_de_write(dev_priv, HDCP_REP_CTL,
+			       rep_ctl | HDCP_SHA1_TEXT_32);
+		sha_text = DRM_HDCP_SHA1_TERMINATOR << 24;
+		ret = intel_write_sha_text(dev_priv, sha_text);
+		if (ret < 0)
+			return ret;
+		sha_idx += sizeof(sha_text);
 	} else if (sha_leftovers == 3) {
-		/* Write 32 bits of text */
+		/* Write 32 bits of text (filled from LSB) */
 		intel_de_write(dev_priv, HDCP_REP_CTL,
 			       rep_ctl | HDCP_SHA1_TEXT_32);
-		sha_text |= bstatus[0] << 24;
+		sha_text |= bstatus[0];
 		ret = intel_write_sha_text(dev_priv, sha_text);
 		if (ret < 0)
 			return ret;
 		sha_idx += sizeof(sha_text);
 
-		/* Write 8 bits of text, 24 bits of M0 */
+		/* Write 8 bits of text (filled from LSB), 24 bits of M0 */
 		intel_de_write(dev_priv, HDCP_REP_CTL,
 			       rep_ctl | HDCP_SHA1_TEXT_8);
 		ret = intel_write_sha_text(dev_priv, bstatus[1]);
diff --git a/include/drm/drm_hdcp.h b/include/drm/drm_hdcp.h
index c6bab4986a65..fe58dbb46962 100644
--- a/include/drm/drm_hdcp.h
+++ b/include/drm/drm_hdcp.h
@@ -29,6 +29,9 @@
 /* Slave address for the HDCP registers in the receiver */
 #define DRM_HDCP_DDC_ADDR			0x3A
 
+/* Value to use at the end of the SHA-1 bytestream used for repeaters */
+#define DRM_HDCP_SHA1_TERMINATOR		0x80
+
 /* HDCP register offsets for HDMI/DVI devices */
 #define DRM_HDCP_DDC_BKSV			0x00
 #define DRM_HDCP_DDC_RI_PRIME			0x08
-- 
Sean Paul, Software Engineer, Google / Chromium OS

