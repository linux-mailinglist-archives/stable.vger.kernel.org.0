Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 34E342EC03D
	for <lists+stable@lfdr.de>; Wed,  6 Jan 2021 16:19:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726195AbhAFPRq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 6 Jan 2021 10:17:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36374 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726109AbhAFPRp (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 6 Jan 2021 10:17:45 -0500
Received: from mail-wr1-x42a.google.com (mail-wr1-x42a.google.com [IPv6:2a00:1450:4864:20::42a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9D5E6C06134D
        for <stable@vger.kernel.org>; Wed,  6 Jan 2021 07:17:04 -0800 (PST)
Received: by mail-wr1-x42a.google.com with SMTP id r7so2750317wrc.5
        for <stable@vger.kernel.org>; Wed, 06 Jan 2021 07:17:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=raspberrypi.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=PE0jOtNMjFje+mvhguTZNdxmt10fdjmfoJdtuZiVuXQ=;
        b=e1rsNgAlHPp3/TCa+MY7d3ka4llX4r09bOvkvcB0TvQPov2f3/vd9mKoadQoiOORVi
         9g62BhwSFqwjdMZ0bKtc0OB7O9bkU24x6IpoD+kEPYWeFr/SHMuPsowv5CHWAeMHj1UB
         VtfvsSKdxZzkrPoHeHDxfDNXePRTX27XXlwVUtoOARqPSiUvXO6mJZwdSBgWTC+y9+Vh
         ya45nnh90VdsQzhHROD+YrpAXbPZ0Eq7ET/8LqfQsBK7tHxjNeDRUqlmErSQLq50uomi
         rtcj8IrmslUT5TQYcwxUBhH6jPTcmSu1PSU90D5dy6G7sX+zOcAqo2yhkn585e8of5VT
         OyqQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=PE0jOtNMjFje+mvhguTZNdxmt10fdjmfoJdtuZiVuXQ=;
        b=o8xoPp+iBVm0nbTkXW6G5p9ZrzPtfinTeN8xCsIkhEsQF59HvA3V1ikJFooyqFGIVU
         KLPZPxdzu2GsKvyPaiDPewrnRmxrLwBW8jQoueX8DYOtggY/g3sKUNdiLbkHEyBpoazS
         4fyWT2wtgFN63vbMAVW01nAHe3QbPLH1cRGD71MXwrk01NZyEnql9OkpO1Y55ej0Qydj
         gonw7WpBtb48LzTa9xID/hfaph3Z83kCD7Q9urSuXKaHIKNvaHrOaQoMZlFEByIlzqL+
         TOyCgLvUMVzKo3mNLjcHJ3k0/M/nv4ASukipwQUV6vtYuF4vgccB1b0yeIBx+Abwvy/K
         fK6g==
X-Gm-Message-State: AOAM5306Hs5anK13sIiEIMYZ1rCKuQ3vxiqTVy2WqjoXa+5zGTS+qHe7
        X8z9qgSGtMDq78lSBATzB4vsrA==
X-Google-Smtp-Source: ABdhPJwvYDioKJZF+OaUlEWuT+zvSLBsig/DSHQudgEfm6KcaYex2YUi4t7nR5ejcmC6XdvDxjyD0A==
X-Received: by 2002:a5d:6ccb:: with SMTP id c11mr4775211wrc.224.1609946223362;
        Wed, 06 Jan 2021 07:17:03 -0800 (PST)
Received: from naushir-VirtualBox.patuck.local ([88.97.76.4])
        by smtp.gmail.com with ESMTPSA id o83sm3408512wme.21.2021.01.06.07.17.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 06 Jan 2021 07:17:02 -0800 (PST)
From:   Naushir Patuck <naush@raspberrypi.com>
To:     linux-media@vger.kernel.org
Cc:     laurent.pinchart@ideasonboard.com,
        Naushir Patuck <naush@raspberrypi.com>, stable@vger.kernel.org,
        Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>
Subject: [PATCH v2] Revert "media: videobuf2: Fix length check for single plane dmabuf queueing"
Date:   Wed,  6 Jan 2021 15:16:57 +0000
Message-Id: <20210106151657.16210-1-naush@raspberrypi.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210106135210.12337-1-naush@raspberrypi.com>
References: <20210106135210.12337-1-naush@raspberrypi.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The updated length check for dmabuf types broke existing usage in v4l2
userland clients.

Fixes: 961d3b27 ("media: videobuf2: Fix length check for single plane dmabuf queueing")
Cc: stable@vger.kernel.org
Signed-off-by: Naushir Patuck <naush@raspberrypi.com>
Tested-by: Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>
Reviewed-by: Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>
---
 drivers/media/common/videobuf2/videobuf2-v4l2.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/media/common/videobuf2/videobuf2-v4l2.c b/drivers/media/common/videobuf2/videobuf2-v4l2.c
index 96d3b2b2aa31..3f61f5863bf7 100644
--- a/drivers/media/common/videobuf2/videobuf2-v4l2.c
+++ b/drivers/media/common/videobuf2/videobuf2-v4l2.c
@@ -118,8 +118,7 @@ static int __verify_length(struct vb2_buffer *vb, const struct v4l2_buffer *b)
 				return -EINVAL;
 		}
 	} else {
-		length = (b->memory == VB2_MEMORY_USERPTR ||
-			  b->memory == VB2_MEMORY_DMABUF)
+		length = (b->memory == VB2_MEMORY_USERPTR)
 			? b->length : vb->planes[0].length;
 
 		if (b->bytesused > length)
-- 
2.25.1

