Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D1D671EF9B8
	for <lists+stable@lfdr.de>; Fri,  5 Jun 2020 15:58:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727097AbgFEN6I (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 5 Jun 2020 09:58:08 -0400
Received: from mx2.suse.de ([195.135.220.15]:33028 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727090AbgFEN6H (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 5 Jun 2020 09:58:07 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id F317CAC51;
        Fri,  5 Jun 2020 13:58:08 +0000 (UTC)
From:   Thomas Zimmermann <tzimmermann@suse.de>
To:     airlied@redhat.com, daniel@ffwll.ch, sam@ravnborg.org,
        emil.velikov@collabora.com, kraxel@redhat.com
Cc:     dri-devel@lists.freedesktop.org,
        Thomas Zimmermann <tzimmermann@suse.de>,
        Krzysztof Kozlowski <krzk@kernel.org>,
        Daniel Vetter <daniel.vetter@ffwll.ch>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        =?UTF-8?q?Noralf=20Tr=C3=B8nnes?= <noralf@tronnes.org>,
        Armijn Hemel <armijn@tjaldur.nl>,
        Alex Deucher <alexander.deucher@amd.com>,
        stable@vger.kernel.org
Subject: [PATCH 01/14] drm/mgag200: Remove declaration of mgag200_mmap() from header file
Date:   Fri,  5 Jun 2020 15:57:50 +0200
Message-Id: <20200605135803.19811-2-tzimmermann@suse.de>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200605135803.19811-1-tzimmermann@suse.de>
References: <20200605135803.19811-1-tzimmermann@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Commit 94668ac796a5 ("drm/mgag200: Convert mgag200 driver to VRAM MM")
removed the implementation of mgag200_mmap(). Also remove the declaration.

Signed-off-by: Thomas Zimmermann <tzimmermann@suse.de>
Fixes: 94668ac796a5 ("drm/mgag200: Convert mgag200 driver to VRAM MM")
Cc: Gerd Hoffmann <kraxel@redhat.com>
Cc: Dave Airlie <airlied@redhat.com>
Cc: Krzysztof Kozlowski <krzk@kernel.org>
Cc: Daniel Vetter <daniel.vetter@ffwll.ch>
Cc: Sam Ravnborg <sam@ravnborg.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: "Noralf Trønnes" <noralf@tronnes.org>
Cc: Armijn Hemel <armijn@tjaldur.nl>
Cc: Alex Deucher <alexander.deucher@amd.com>
Cc: Emil Velikov <emil.velikov@collabora.com>
Cc: <stable@vger.kernel.org> # v5.3+
---
 drivers/gpu/drm/mgag200/mgag200_drv.h | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/gpu/drm/mgag200/mgag200_drv.h b/drivers/gpu/drm/mgag200/mgag200_drv.h
index 47df62b1ad290..92b6679029fe5 100644
--- a/drivers/gpu/drm/mgag200/mgag200_drv.h
+++ b/drivers/gpu/drm/mgag200/mgag200_drv.h
@@ -198,6 +198,5 @@ void mgag200_i2c_destroy(struct mga_i2c_chan *i2c);
 
 int mgag200_mm_init(struct mga_device *mdev);
 void mgag200_mm_fini(struct mga_device *mdev);
-int mgag200_mmap(struct file *filp, struct vm_area_struct *vma);
 
 #endif				/* __MGAG200_DRV_H__ */
-- 
2.26.2

