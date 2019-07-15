Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3355369A79
	for <lists+stable@lfdr.de>; Mon, 15 Jul 2019 20:07:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729302AbfGOSG2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Jul 2019 14:06:28 -0400
Received: from mail-io1-f68.google.com ([209.85.166.68]:33741 "EHLO
        mail-io1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729277AbfGOSG2 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Jul 2019 14:06:28 -0400
Received: by mail-io1-f68.google.com with SMTP id z3so35639526iog.0
        for <stable@vger.kernel.org>; Mon, 15 Jul 2019 11:06:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=0AenrY3LEbV9JBVK1GTVHoE0HIOkQpPGT9O4TxOBToI=;
        b=JkqRhmkn6rQx11n38k27xsl8XSRnjwd463DcpVF+w83CrH+jqqzEzSYd1DcnXA11Gq
         mgzdL1nEsMb/9ewjrU8DjMX4v9R+6m/cT+JDvfCnrPxnFg4Qq0qSepqvZNJ/st3RcwHs
         eshsEbMymtv81hEkhG5C/FNAb0ncexW27sC4o=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=0AenrY3LEbV9JBVK1GTVHoE0HIOkQpPGT9O4TxOBToI=;
        b=GLcEGukQtvvORt3CJST6O+2mITKhTfScKMMID18fIbAwDISMZ9llSEPsBzGYdh/qXH
         uyZl6K2Hq1TU132yuAq9+oB1+ORuPtG3vN+pi+fUe48uqzw0+ur5IaGpb/0A9EX0bRjm
         h826jay/agGNfz1Uyds0jtzLCqMJ4+qB+U5uVe3m0vcarsNUwjQOXcMpra+RPwGCXZDj
         G68W3yxpKxLExJV8LUMEamXieWQ2TJ3l3DUnxVCtf9znmmz50e7RxW4G4+SoFEhZna8O
         RLELv5ez56V/pXCy0nAYj5Uce0THLhDam0DKNKjA3aW38xjS33a41WvAL7+8YeGiHu4p
         R4OA==
X-Gm-Message-State: APjAAAVAkZ2lhUxZFWXsPUiQ8LqGfI9CtodEjr+riiNr74WzplWIlEQh
        fBwj/Rk+AvWmkD19rXFsL9rv0qHRLLI=
X-Google-Smtp-Source: APXvYqyDzLcQTZFi7gJGDAwv9sEu4/8XZv8LulhOykPSPQfnuLxw8xkLTmqzM5eqOzWhCkf2bociwg==
X-Received: by 2002:a02:662f:: with SMTP id k47mr29187199jac.4.1563213986719;
        Mon, 15 Jul 2019 11:06:26 -0700 (PDT)
Received: from localhost ([2620:15c:183:200:855f:8919:84a7:4794])
        by smtp.gmail.com with ESMTPSA id z26sm19074428ioi.85.2019.07.15.11.06.25
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 15 Jul 2019 11:06:26 -0700 (PDT)
From:   Ross Zwisler <zwisler@chromium.org>
X-Google-Original-From: Ross Zwisler <zwisler@google.com>
To:     stable@vger.kernel.org
Cc:     Dave Airlie <airlied@redhat.com>,
        Thomas Zimmermann <tzimmermann@suse.de>,
        Guenter Roeck <groeck@google.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Ross Zwisler <zwisler@google.com>
Subject: [v4.19.y PATCH 1/3] drm/udl: introduce a macro to convert dev to udl.
Date:   Mon, 15 Jul 2019 12:05:56 -0600
Message-Id: <20190715180558.221737-2-zwisler@google.com>
X-Mailer: git-send-email 2.22.0.510.g264f2c817a-goog
In-Reply-To: <20190715180558.221737-1-zwisler@google.com>
References: <20190715180558.221737-1-zwisler@google.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dave Airlie <airlied@redhat.com>

commit fd96e0dba19c53c2d66f2a398716bb74df8ca85e upstream.

This just makes it easier to later embed drm into udl.

Reviewed-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Dave Airlie <airlied@redhat.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20190405031715.5959-3-airlied@gmail.com
Signed-off-by: Ross Zwisler <zwisler@google.com>
---
 drivers/gpu/drm/udl/udl_drv.h  |  2 ++
 drivers/gpu/drm/udl/udl_fb.c   | 10 +++++-----
 drivers/gpu/drm/udl/udl_gem.c  |  2 +-
 drivers/gpu/drm/udl/udl_main.c | 12 ++++++------
 4 files changed, 14 insertions(+), 12 deletions(-)

diff --git a/drivers/gpu/drm/udl/udl_drv.h b/drivers/gpu/drm/udl/udl_drv.h
index 4ae67d882eae..b3e08e876d62 100644
--- a/drivers/gpu/drm/udl/udl_drv.h
+++ b/drivers/gpu/drm/udl/udl_drv.h
@@ -71,6 +71,8 @@ struct udl_device {
 	atomic_t cpu_kcycles_used; /* transpired during pixel processing */
 };
 
+#define to_udl(x) ((x)->dev_private)
+
 struct udl_gem_object {
 	struct drm_gem_object base;
 	struct page **pages;
diff --git a/drivers/gpu/drm/udl/udl_fb.c b/drivers/gpu/drm/udl/udl_fb.c
index dd9ffded223b..590323ea261f 100644
--- a/drivers/gpu/drm/udl/udl_fb.c
+++ b/drivers/gpu/drm/udl/udl_fb.c
@@ -82,7 +82,7 @@ int udl_handle_damage(struct udl_framebuffer *fb, int x, int y,
 		      int width, int height)
 {
 	struct drm_device *dev = fb->base.dev;
-	struct udl_device *udl = dev->dev_private;
+	struct udl_device *udl = to_udl(dev);
 	int i, ret;
 	char *cmd;
 	cycles_t start_cycles, end_cycles;
@@ -210,7 +210,7 @@ static int udl_fb_open(struct fb_info *info, int user)
 {
 	struct udl_fbdev *ufbdev = info->par;
 	struct drm_device *dev = ufbdev->ufb.base.dev;
-	struct udl_device *udl = dev->dev_private;
+	struct udl_device *udl = to_udl(dev);
 
 	/* If the USB device is gone, we don't accept new opens */
 	if (drm_dev_is_unplugged(udl->ddev))
@@ -441,7 +441,7 @@ static void udl_fbdev_destroy(struct drm_device *dev,
 
 int udl_fbdev_init(struct drm_device *dev)
 {
-	struct udl_device *udl = dev->dev_private;
+	struct udl_device *udl = to_udl(dev);
 	int bpp_sel = fb_bpp;
 	struct udl_fbdev *ufbdev;
 	int ret;
@@ -480,7 +480,7 @@ int udl_fbdev_init(struct drm_device *dev)
 
 void udl_fbdev_cleanup(struct drm_device *dev)
 {
-	struct udl_device *udl = dev->dev_private;
+	struct udl_device *udl = to_udl(dev);
 	if (!udl->fbdev)
 		return;
 
@@ -491,7 +491,7 @@ void udl_fbdev_cleanup(struct drm_device *dev)
 
 void udl_fbdev_unplug(struct drm_device *dev)
 {
-	struct udl_device *udl = dev->dev_private;
+	struct udl_device *udl = to_udl(dev);
 	struct udl_fbdev *ufbdev;
 	if (!udl->fbdev)
 		return;
diff --git a/drivers/gpu/drm/udl/udl_gem.c b/drivers/gpu/drm/udl/udl_gem.c
index bb7b58407039..3b3e17652bb2 100644
--- a/drivers/gpu/drm/udl/udl_gem.c
+++ b/drivers/gpu/drm/udl/udl_gem.c
@@ -203,7 +203,7 @@ int udl_gem_mmap(struct drm_file *file, struct drm_device *dev,
 {
 	struct udl_gem_object *gobj;
 	struct drm_gem_object *obj;
-	struct udl_device *udl = dev->dev_private;
+	struct udl_device *udl = to_udl(dev);
 	int ret = 0;
 
 	mutex_lock(&udl->gem_lock);
diff --git a/drivers/gpu/drm/udl/udl_main.c b/drivers/gpu/drm/udl/udl_main.c
index 19055dda3140..09ce98113c0e 100644
--- a/drivers/gpu/drm/udl/udl_main.c
+++ b/drivers/gpu/drm/udl/udl_main.c
@@ -29,7 +29,7 @@
 static int udl_parse_vendor_descriptor(struct drm_device *dev,
 				       struct usb_device *usbdev)
 {
-	struct udl_device *udl = dev->dev_private;
+	struct udl_device *udl = to_udl(dev);
 	char *desc;
 	char *buf;
 	char *desc_end;
@@ -165,7 +165,7 @@ void udl_urb_completion(struct urb *urb)
 
 static void udl_free_urb_list(struct drm_device *dev)
 {
-	struct udl_device *udl = dev->dev_private;
+	struct udl_device *udl = to_udl(dev);
 	int count = udl->urbs.count;
 	struct list_head *node;
 	struct urb_node *unode;
@@ -198,7 +198,7 @@ static void udl_free_urb_list(struct drm_device *dev)
 
 static int udl_alloc_urb_list(struct drm_device *dev, int count, size_t size)
 {
-	struct udl_device *udl = dev->dev_private;
+	struct udl_device *udl = to_udl(dev);
 	struct urb *urb;
 	struct urb_node *unode;
 	char *buf;
@@ -262,7 +262,7 @@ static int udl_alloc_urb_list(struct drm_device *dev, int count, size_t size)
 
 struct urb *udl_get_urb(struct drm_device *dev)
 {
-	struct udl_device *udl = dev->dev_private;
+	struct udl_device *udl = to_udl(dev);
 	int ret = 0;
 	struct list_head *entry;
 	struct urb_node *unode;
@@ -295,7 +295,7 @@ struct urb *udl_get_urb(struct drm_device *dev)
 
 int udl_submit_urb(struct drm_device *dev, struct urb *urb, size_t len)
 {
-	struct udl_device *udl = dev->dev_private;
+	struct udl_device *udl = to_udl(dev);
 	int ret;
 
 	BUG_ON(len > udl->urbs.size);
@@ -370,7 +370,7 @@ int udl_drop_usb(struct drm_device *dev)
 
 void udl_driver_unload(struct drm_device *dev)
 {
-	struct udl_device *udl = dev->dev_private;
+	struct udl_device *udl = to_udl(dev);
 
 	drm_kms_helper_poll_fini(dev);
 
-- 
2.22.0.510.g264f2c817a-goog

