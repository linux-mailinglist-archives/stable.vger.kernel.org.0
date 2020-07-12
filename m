Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9B01E21C9F6
	for <lists+stable@lfdr.de>; Sun, 12 Jul 2020 17:25:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728942AbgGLPZJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 12 Jul 2020 11:25:09 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:39926 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1728826AbgGLPZJ (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 12 Jul 2020 11:25:09 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1594567508;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc; bh=n8o3ePgic4naJPCVQ1wtcacm70aGxOgRT3KJzb6/xpk=;
        b=UKrhXOcfllu6vT6Dr0vPXFzF6Tu2KA0XKbINjsHOCWQR0XXEm+usEqlhVLRhYAwex8lSRd
        l0wJHXFHQokFa1i+E7xhlPdmo/Qf3VWrqti9knhNkU5IhKs3vWzYZskpRT1a3kcjwcPFmz
        DY3DxAVPCVQqzTFo1s5BRPLPG5OCuRg=
Received: from mail-qv1-f71.google.com (mail-qv1-f71.google.com
 [209.85.219.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-365-3jsCZp6YOheiuvXpf1U2IQ-1; Sun, 12 Jul 2020 11:25:04 -0400
X-MC-Unique: 3jsCZp6YOheiuvXpf1U2IQ-1
Received: by mail-qv1-f71.google.com with SMTP id l12so6127747qvu.21
        for <stable@vger.kernel.org>; Sun, 12 Jul 2020 08:25:04 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=n8o3ePgic4naJPCVQ1wtcacm70aGxOgRT3KJzb6/xpk=;
        b=thI9vofhVxP5aMNJ7VaXIF44vKlb6XLg59dYuWtKnbVtGUa1bC0+wB/bc9p0aaM9jX
         VdEbMWJMK2+W+v100/ipH9IZBkF57KCppusi6sXiG6VllxSGXLk+r5qwgkkX2sjDt/6E
         Ho5//vtZkQl8cKjEHEXP/pvT98mTxSuIlasL2uyZtrU2rPQsU8PsrYQujDTJ9lqj4obL
         m7nsEGGu3SdiXYmZPin1L2Agz5MNY4Ha8dsCC88QdLR+RUw0tIGgcFpGAuDCCclSv0k4
         cINk0A/7emaQ6Ow8617JAdoF72VR3AjxVk6L4nj2RDBmDYQbdLp9NhfwlzCsqjLjpmzn
         QJqg==
X-Gm-Message-State: AOAM532bpHSNjZjJ7r/8PKxdVXgw07ob0OOU58MNYnBocN1l9KEOsAL8
        +Wy/HJjbZMLVf9KJ3NjhRctCquDmWqHocA+2FyLvi5GSptMJADX3yfUJJKbVzGmYOdzZ3+o/IJw
        5mV6jbR/DB2S9lmBT
X-Received: by 2002:ac8:19ad:: with SMTP id u42mr81124463qtj.168.1594567501933;
        Sun, 12 Jul 2020 08:25:01 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwl77Yeo2vRgSclJ0lpU+vhDmXAKPXH0ay/FXIRBXDB1L7WTw8VZGr76FSRgh/J2hBHT9EZkA==
X-Received: by 2002:ac8:19ad:: with SMTP id u42mr81124448qtj.168.1594567501723;
        Sun, 12 Jul 2020 08:25:01 -0700 (PDT)
Received: from trix.remote.csb (075-142-250-213.res.spectrum.com. [75.142.250.213])
        by smtp.gmail.com with ESMTPSA id o20sm16321336qtk.56.2020.07.12.08.24.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 12 Jul 2020 08:25:00 -0700 (PDT)
From:   trix@redhat.com
To:     a.hajda@samsung.com, narmstrong@baylibre.com,
        Laurent.pinchart@ideasonboard.com, jonas@kwiboo.se,
        jernej.skrabec@siol.net, airlied@linux.ie, daniel@ffwll.ch,
        architt@codeaurora.org
Cc:     dri-devel@lists.freedesktop.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org, Tom Rix <trix@redhat.com>
Subject: [PATCH] drm/bridge: sil_sii8620: initialize return of sii8620_readb
Date:   Sun, 12 Jul 2020 08:24:53 -0700
Message-Id: <20200712152453.27510-1-trix@redhat.com>
X-Mailer: git-send-email 2.18.1
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Tom Rix <trix@redhat.com>

clang static analysis flags this error

sil-sii8620.c:184:2: warning: Undefined or garbage value
  returned to caller [core.uninitialized.UndefReturn]
        return ret;
        ^~~~~~~~~~

sii8620_readb calls sii8620_read_buf.
sii8620_read_buf can return without setting its output
pararmeter 'ret'.

So initialize ret.

Fixes: ce6e153f414a ("drm/bridge: add Silicon Image SiI8620 driver")

Signed-off-by: Tom Rix <trix@redhat.com>
---
 drivers/gpu/drm/bridge/sil-sii8620.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/bridge/sil-sii8620.c b/drivers/gpu/drm/bridge/sil-sii8620.c
index 3540e4931383..da933d477e5f 100644
--- a/drivers/gpu/drm/bridge/sil-sii8620.c
+++ b/drivers/gpu/drm/bridge/sil-sii8620.c
@@ -178,7 +178,7 @@ static void sii8620_read_buf(struct sii8620 *ctx, u16 addr, u8 *buf, int len)
 
 static u8 sii8620_readb(struct sii8620 *ctx, u16 addr)
 {
-	u8 ret;
+	u8 ret = 0;
 
 	sii8620_read_buf(ctx, addr, &ret, 1);
 	return ret;
-- 
2.18.1

