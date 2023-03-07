Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D07296AE60D
	for <lists+stable@lfdr.de>; Tue,  7 Mar 2023 17:12:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230206AbjCGQMp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Mar 2023 11:12:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39676 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230240AbjCGQMB (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Mar 2023 11:12:01 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B7B96898ED
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 08:11:43 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 74F9FB81929
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 16:11:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9D6BEC433EF;
        Tue,  7 Mar 2023 16:11:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678205501;
        bh=+nKz5WhYlOvSfT49etDFUXPUsteAJGsTTgbFnrqmhag=;
        h=Subject:To:Cc:From:Date:From;
        b=KyJ8/TBWvrcM7nnL57aC6FvAj1GuIQHghS0h2CuMBXfZvmY8REoRCPEon3IaBX7kb
         EvtKN8psRJjDlr65DdTtp9E0oo6x8lRRZiS4BnLWZk2rlVUQ1fURM8qpc/YzPAnYXL
         TJ9kkUWeP8agxmawvsv8R1SdJr2lszRno3JAV4D4=
Subject: FAILED: patch "[PATCH] drm/gud: Fix UBSAN warning" failed to apply to 5.15-stable tree
To:     noralf@tronnes.org, javierm@redhat.com, stable@vger.kernel.org,
        tzimmermann@suse.de
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Tue, 07 Mar 2023 17:11:37 +0100
Message-ID: <167820549723129@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 5.15-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

To reproduce the conflict and resubmit, you may use the following commands:

git fetch https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux.git/ linux-5.15.y
git checkout FETCH_HEAD
git cherry-pick -x 951df98024f7272f85df5044eca7374f5b5b24ef
# <resolve conflicts, build, test, etc.>
git commit -s
git send-email --to '<stable@vger.kernel.org>' --in-reply-to '167820549723129@kroah.com' --subject-prefix 'PATCH 5.15.y' HEAD^..

Possible dependencies:

951df98024f7 ("drm/gud: Fix UBSAN warning")
edbe262acf92 ("drm/format-helper: Merge drm_fb_memcpy() and drm_fb_memcpy_toio()")
71bf55872cbe ("drm/format-helper: Provide drm_fb_blit()")
de40c281fe0b ("drm/simpledrm: Convert to atomic helpers")
c25b69604fc4 ("drm/simpledrm: Inline device-init helpers")
03d38605cee7 ("drm/simpledrm: Remove mem field from device structure")
f9929f69de94 ("drm/simpledrm: Fix return type of simpledrm_simple_display_pipe_mode_valid()")
4f4dc37e374c ("drm/mgag200: Reorganize before dropping simple-KMS helpers")
475e2b970cc3 ("drm/mgag200: Split up connector's mode_valid helper")
69340e529a06 ("drm/mgag200: Test memory requirements in drm_mode_config_funcs.mode_valid")
8219f11fdaf5 ("drm/mgag200: Remove struct mga_connector")
b279df242972 ("drm/mgag200: Switch I2C code to managed cleanup")
16f1456466c2 ("drm/mgag200: Implement connector's get_modes with helper")
d50f74790bbb ("drm/mgag200: Fail on I2C initialization errors")
5913ab941d6e ("drm/mgag200: Acquire I/O lock while reading EDID")
c48a36301634 ("drm/mgag200: Optimize damage clips")
931e3f3a0e99 ("drm/mgag200: Protect concurrent access to I/O registers with lock")
41fd6f0a6dd6 ("drm/format-helper: Implement drm_fb_swab() with per-line helpers")
d7442505de92 ("drm/simpledrm: Use fbdev defaults for shadow buffering")
e08a99d00558 ("drm/format-helper: Add RGB565-to-XRGB8888 conversion")

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 951df98024f7272f85df5044eca7374f5b5b24ef Mon Sep 17 00:00:00 2001
From: =?UTF-8?q?Noralf=20Tr=C3=B8nnes?= <noralf@tronnes.org>
Date: Wed, 30 Nov 2022 20:26:49 +0100
Subject: [PATCH] drm/gud: Fix UBSAN warning
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

UBSAN complains about invalid value for bool:

[  101.165172] [drm] Initialized gud 1.0.0 20200422 for 2-3.2:1.0 on minor 1
[  101.213360] gud 2-3.2:1.0: [drm] fb1: guddrmfb frame buffer device
[  101.213426] usbcore: registered new interface driver gud
[  101.989431] ================================================================================
[  101.989441] UBSAN: invalid-load in linux/include/linux/iosys-map.h:253:9
[  101.989447] load of value 121 is not a valid value for type '_Bool'
[  101.989451] CPU: 1 PID: 455 Comm: kworker/1:6 Not tainted 5.18.0-rc5-gud-5.18-rc5 #3
[  101.989456] Hardware name: Hewlett-Packard HP EliteBook 820 G1/1991, BIOS L71 Ver. 01.44 04/12/2018
[  101.989459] Workqueue: events_long gud_flush_work [gud]
[  101.989471] Call Trace:
[  101.989474]  <TASK>
[  101.989479]  dump_stack_lvl+0x49/0x5f
[  101.989488]  dump_stack+0x10/0x12
[  101.989493]  ubsan_epilogue+0x9/0x3b
[  101.989498]  __ubsan_handle_load_invalid_value.cold+0x44/0x49
[  101.989504]  dma_buf_vmap.cold+0x38/0x3d
[  101.989511]  ? find_busiest_group+0x48/0x300
[  101.989520]  drm_gem_shmem_vmap+0x76/0x1b0 [drm_shmem_helper]
[  101.989528]  drm_gem_shmem_object_vmap+0x9/0xb [drm_shmem_helper]
[  101.989535]  drm_gem_vmap+0x26/0x60 [drm]
[  101.989594]  drm_gem_fb_vmap+0x47/0x150 [drm_kms_helper]
[  101.989630]  gud_prep_flush+0xc1/0x710 [gud]
[  101.989639]  ? _raw_spin_lock+0x17/0x40
[  101.989648]  gud_flush_work+0x1e0/0x430 [gud]
[  101.989653]  ? __switch_to+0x11d/0x470
[  101.989664]  process_one_work+0x21f/0x3f0
[  101.989673]  worker_thread+0x200/0x3e0
[  101.989679]  ? rescuer_thread+0x390/0x390
[  101.989684]  kthread+0xfd/0x130
[  101.989690]  ? kthread_complete_and_exit+0x20/0x20
[  101.989696]  ret_from_fork+0x22/0x30
[  101.989706]  </TASK>
[  101.989708] ================================================================================

The source of this warning is in iosys_map_clear() called from
dma_buf_vmap(). It conditionally sets values based on map->is_iomem. The
iosys_map variables are allocated uninitialized on the stack leading to
->is_iomem having all kinds of values and not only 0/1.

Fix this by zeroing the iosys_map variables.

Fixes: 40e1a70b4aed ("drm: Add GUD USB Display driver")
Cc: <stable@vger.kernel.org> # v5.18+
Reviewed-by: Javier Martinez Canillas <javierm@redhat.com>
Reviewed-by: Thomas Zimmermann <tzimmermann@suse.de>
Signed-off-by: Noralf Trønnes <noralf@tronnes.org>
Link: https://patchwork.freedesktop.org/patch/msgid/20221122-gud-shadow-plane-v2-1-435037990a83@tronnes.org

diff --git a/drivers/gpu/drm/gud/gud_pipe.c b/drivers/gpu/drm/gud/gud_pipe.c
index 7c6dc2bcd14a..61f4abaf1811 100644
--- a/drivers/gpu/drm/gud/gud_pipe.c
+++ b/drivers/gpu/drm/gud/gud_pipe.c
@@ -157,8 +157,8 @@ static int gud_prep_flush(struct gud_device *gdrm, struct drm_framebuffer *fb,
 {
 	struct dma_buf_attachment *import_attach = fb->obj[0]->import_attach;
 	u8 compression = gdrm->compression;
-	struct iosys_map map[DRM_FORMAT_MAX_PLANES];
-	struct iosys_map map_data[DRM_FORMAT_MAX_PLANES];
+	struct iosys_map map[DRM_FORMAT_MAX_PLANES] = { };
+	struct iosys_map map_data[DRM_FORMAT_MAX_PLANES] = { };
 	struct iosys_map dst;
 	void *vaddr, *buf;
 	size_t pitch, len;

