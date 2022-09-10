Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 92E115B4473
	for <lists+stable@lfdr.de>; Sat, 10 Sep 2022 08:30:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229529AbiIJGaL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 10 Sep 2022 02:30:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41612 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229599AbiIJGaK (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 10 Sep 2022 02:30:10 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ABA562F650
        for <stable@vger.kernel.org>; Fri,  9 Sep 2022 23:30:08 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 66765B80686
        for <stable@vger.kernel.org>; Sat, 10 Sep 2022 06:30:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B645EC433C1;
        Sat, 10 Sep 2022 06:30:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1662791406;
        bh=FLG1DqUSQ1aFMWM2aXazaLM4S++8ao68ZRQH6ApmI1s=;
        h=Subject:To:Cc:From:Date:From;
        b=yaUoja4lTMF3XzNR4Hm/aNx98XQie8MFtMTsesefZuUeLDazpbk17Z/TqpHPzpdbH
         XpocDO3c5j+npUJNBQFlCvaLimdlknwtRnTgEN/h7OSMw7yD3HdPVgVKSIGsI9AFOV
         iLtNYKWG19eRSbENJcU1/vJ33rJ55pCCznm2Srk0=
Subject: FAILED: patch "[PATCH] drm/edid: Handle EDID 1.4 range descriptor h/vfreq offsets" failed to apply to 5.10-stable tree
To:     ville.syrjala@linux.intel.com, jani.nikula@intel.com,
        manasi.d.navare@intel.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Sat, 10 Sep 2022 08:30:18 +0200
Message-ID: <166279141823554@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 5.10-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

Possible dependencies:

c7943bb324e5 ("drm/edid: Handle EDID 1.4 range descriptor h/vfreq offsets")
45aa2336fa6d ("drm/edid: convert drm_for_each_detailed_block() to drm_edid")
2c54f87cf2fb ("drm/edid: convert get_monitor_name() to drm_edid")
874d98eed71a ("drm/edid: convert mode_in_range() and drm_monitor_supports_rb() to drm_edid")
67d87fac86dd ("drm/edid: convert drm_mode_std() and children to drm_edid")
7428bfbdb7c4 ("drm/edid: convert drm_cvt_modes_for_range() to drm_edid")
a77f7c89e62c ("drm/edid: convert drm_gtf_modes_for_range() to drm_edid")
084c7a7c7a0a ("drm/edid: convert drm_dmt_modes_for_range() to drm_edid")
dd0f4470a849 ("drm/edid: convert struct detailed_mode_closure to drm_edid")
40f71f5b2392 ("drm/edid: convert drm_edid_connector_update() to drm_edid fully")
a2f9790dcffe ("drm/edid: propagate drm_edid to drm_edid_to_eld()")
e42192b4c345 ("drm/edid: keep propagating drm_edid to display info")
ab1747ccf052 ("drm/edid: convert drm_for_each_detailed_block() to edid iter")
6ff1c19f5f28 ("drm/edid: sunset drm_find_cea_extension()")
58304630b830 ("drm/edid: skip CTA extension scan in drm_edid_to_eld() just for CTA rev")
8db73897698c ("drm/edid: detect color formats and CTA revision in all CTA extensions")
37852141965d ("drm/edid: convert drm_edid_to_eld() to use cea db iter")
dfc031259656 ("drm/edid: convert drm_parse_cea_ext() to use cea db iter")
537d9ed2f6c1 ("drm/edid: convert add_cea_modes() to use cea db iter")
9d72b7e2d2ce ("drm/edid: clean up CTA data block tag definitions")

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From c7943bb324e503baeeba3df2bc5ca8a377111bfa Mon Sep 17 00:00:00 2001
From: =?UTF-8?q?Ville=20Syrj=C3=A4l=C3=A4?= <ville.syrjala@linux.intel.com>
Date: Sat, 27 Aug 2022 00:34:51 +0300
Subject: [PATCH] drm/edid: Handle EDID 1.4 range descriptor h/vfreq offsets
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

EDID 1.4 introduced some extra flags in the range
descriptor to support min/max h/vfreq >= 255. Consult them
to correctly parse the vfreq limits.

Note that some combinations of the flags are documented
as "reserved" (as are some other values in the descriptor)
but explicitly checking for those doesn't seem particularly
worthwile since we end up with bogus results whether we
decode them or not.

v2: Increase the storage to u16 to make it work (Jani)
    Note the "reserved" values situation (Jani)
v3: Document the EDID version number in the defines
    Drop some bogus (u8) casts

Cc: stable@vger.kernel.org
Closes: https://gitlab.freedesktop.org/drm/intel/-/issues/6519
References: https://gitlab.freedesktop.org/drm/intel/-/issues/6484
Reviewed-by: Jani Nikula <jani.nikula@intel.com>
Signed-off-by: Ville Syrjälä <ville.syrjala@linux.intel.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20220826213501.31490-2-ville.syrjala@linux.intel.com
Reviewed-by: Manasi Navare <manasi.d.navare@intel.com>

diff --git a/drivers/gpu/drm/drm_debugfs.c b/drivers/gpu/drm/drm_debugfs.c
index 493922069c90..01ee3febb813 100644
--- a/drivers/gpu/drm/drm_debugfs.c
+++ b/drivers/gpu/drm/drm_debugfs.c
@@ -377,8 +377,8 @@ static int vrr_range_show(struct seq_file *m, void *data)
 	if (connector->status != connector_status_connected)
 		return -ENODEV;
 
-	seq_printf(m, "Min: %u\n", (u8)connector->display_info.monitor_range.min_vfreq);
-	seq_printf(m, "Max: %u\n", (u8)connector->display_info.monitor_range.max_vfreq);
+	seq_printf(m, "Min: %u\n", connector->display_info.monitor_range.min_vfreq);
+	seq_printf(m, "Max: %u\n", connector->display_info.monitor_range.max_vfreq);
 
 	return 0;
 }
diff --git a/drivers/gpu/drm/drm_edid.c b/drivers/gpu/drm/drm_edid.c
index bbc25e3b7220..eaa819381281 100644
--- a/drivers/gpu/drm/drm_edid.c
+++ b/drivers/gpu/drm/drm_edid.c
@@ -5971,12 +5971,14 @@ static void drm_parse_cea_ext(struct drm_connector *connector,
 }
 
 static
-void get_monitor_range(const struct detailed_timing *timing,
-		       void *info_monitor_range)
+void get_monitor_range(const struct detailed_timing *timing, void *c)
 {
-	struct drm_monitor_range_info *monitor_range = info_monitor_range;
+	struct detailed_mode_closure *closure = c;
+	struct drm_display_info *info = &closure->connector->display_info;
+	struct drm_monitor_range_info *monitor_range = &info->monitor_range;
 	const struct detailed_non_pixel *data = &timing->data.other_data;
 	const struct detailed_data_monitor_range *range = &data->data.range;
+	const struct edid *edid = closure->drm_edid->edid;
 
 	if (!is_display_descriptor(timing, EDID_DETAIL_MONITOR_RANGE))
 		return;
@@ -5992,18 +5994,28 @@ void get_monitor_range(const struct detailed_timing *timing,
 
 	monitor_range->min_vfreq = range->min_vfreq;
 	monitor_range->max_vfreq = range->max_vfreq;
+
+	if (edid->revision >= 4) {
+		if (data->pad2 & DRM_EDID_RANGE_OFFSET_MIN_VFREQ)
+			monitor_range->min_vfreq += 255;
+		if (data->pad2 & DRM_EDID_RANGE_OFFSET_MAX_VFREQ)
+			monitor_range->max_vfreq += 255;
+	}
 }
 
 static void drm_get_monitor_range(struct drm_connector *connector,
 				  const struct drm_edid *drm_edid)
 {
-	struct drm_display_info *info = &connector->display_info;
+	const struct drm_display_info *info = &connector->display_info;
+	struct detailed_mode_closure closure = {
+		.connector = connector,
+		.drm_edid = drm_edid,
+	};
 
 	if (!version_greater(drm_edid, 1, 1))
 		return;
 
-	drm_for_each_detailed_block(drm_edid, get_monitor_range,
-				    &info->monitor_range);
+	drm_for_each_detailed_block(drm_edid, get_monitor_range, &closure);
 
 	DRM_DEBUG_KMS("Supported Monitor Refresh rate range is %d Hz - %d Hz\n",
 		      info->monitor_range.min_vfreq,
diff --git a/include/drm/drm_connector.h b/include/drm/drm_connector.h
index a1705d6b3fba..7df7876b2ad5 100644
--- a/include/drm/drm_connector.h
+++ b/include/drm/drm_connector.h
@@ -319,8 +319,8 @@ enum drm_panel_orientation {
  *             EDID's detailed monitor range
  */
 struct drm_monitor_range_info {
-	u8 min_vfreq;
-	u8 max_vfreq;
+	u16 min_vfreq;
+	u16 max_vfreq;
 };
 
 /**
diff --git a/include/drm/drm_edid.h b/include/drm/drm_edid.h
index 2181977ae683..1ed61e2b30a4 100644
--- a/include/drm/drm_edid.h
+++ b/include/drm/drm_edid.h
@@ -92,6 +92,11 @@ struct detailed_data_string {
 	u8 str[13];
 } __attribute__((packed));
 
+#define DRM_EDID_RANGE_OFFSET_MIN_VFREQ (1 << 0) /* 1.4 */
+#define DRM_EDID_RANGE_OFFSET_MAX_VFREQ (1 << 1) /* 1.4 */
+#define DRM_EDID_RANGE_OFFSET_MIN_HFREQ (1 << 2) /* 1.4 */
+#define DRM_EDID_RANGE_OFFSET_MAX_HFREQ (1 << 3) /* 1.4 */
+
 #define DRM_EDID_DEFAULT_GTF_SUPPORT_FLAG   0x00
 #define DRM_EDID_RANGE_LIMITS_ONLY_FLAG     0x01
 #define DRM_EDID_SECONDARY_GTF_SUPPORT_FLAG 0x02

