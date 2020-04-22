Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 63BEE1B3FDD
	for <lists+stable@lfdr.de>; Wed, 22 Apr 2020 12:42:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729772AbgDVKl0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 22 Apr 2020 06:41:26 -0400
Received: from mail.kernel.org ([198.145.29.99]:57098 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729737AbgDVKUU (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 22 Apr 2020 06:20:20 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 92FF420780;
        Wed, 22 Apr 2020 10:20:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1587550820;
        bh=ZvNMqtxUubPqeUhvAc90/5pdocr+OX5tEhA7GA3JOzM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=U4q6ewE9k8UIOsJcghNhBcOBbjUGD7HvGReI29h7B2HyB4Ri2w78tgUf0B2pa0Qkm
         bGBzRnVinWvtT0fBS0p9wTxwhTckKVkTZWjazJ+Z47kKJmndaSiZ3Snw0h2enxlUG4
         7CaYRM0TzTf9snSEUPbESJE1vxPg1zqGSi7Uvj/M=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Nathan Chancellor <natechancellor@gmail.com>,
        Nick Desaulniers <ndesaulniers@google.com>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
Subject: [PATCH 5.4 106/118] fbmem: Adjust indentation in fb_prepare_logo and fb_blank
Date:   Wed, 22 Apr 2020 11:57:47 +0200
Message-Id: <20200422095048.497983297@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200422095031.522502705@linuxfoundation.org>
References: <20200422095031.522502705@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Nathan Chancellor <natechancellor@gmail.com>

commit 93166f5f2e4dc593cff8ca77ef828ac6f148b0f3 upstream.

Clang warns:

../drivers/video/fbdev/core/fbmem.c:665:3: warning: misleading
indentation; statement is not part of the previous 'else'
[-Wmisleading-indentation]
        if (fb_logo.depth > 4 && depth > 4) {
        ^
../drivers/video/fbdev/core/fbmem.c:661:2: note: previous statement is
here
        else
        ^
../drivers/video/fbdev/core/fbmem.c:1075:3: warning: misleading
indentation; statement is not part of the previous 'if'
[-Wmisleading-indentation]
        return ret;
        ^
../drivers/video/fbdev/core/fbmem.c:1072:2: note: previous statement is
here
        if (!ret)
        ^
2 warnings generated.

This warning occurs because there are spaces before the tabs on these
lines. Normalize the indentation in these functions so that it is
consistent with the Linux kernel coding style and clang no longer warns.

Fixes: 1692b37c99d5 ("fbdev: Fix logo if logo depth is less than framebuffer depth")
Link: https://github.com/ClangBuiltLinux/linux/issues/825
Signed-off-by: Nathan Chancellor <natechancellor@gmail.com>
Reviewed-by: Nick Desaulniers <ndesaulniers@google.com>
Signed-off-by: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20191218030025.10064-1-natechancellor@gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/video/fbdev/core/fbmem.c |   36 ++++++++++++++++++------------------
 1 file changed, 18 insertions(+), 18 deletions(-)

--- a/drivers/video/fbdev/core/fbmem.c
+++ b/drivers/video/fbdev/core/fbmem.c
@@ -662,20 +662,20 @@ int fb_prepare_logo(struct fb_info *info
 		fb_logo.depth = 1;
 
 
- 	if (fb_logo.depth > 4 && depth > 4) {
- 		switch (info->fix.visual) {
- 		case FB_VISUAL_TRUECOLOR:
- 			fb_logo.needs_truepalette = 1;
- 			break;
- 		case FB_VISUAL_DIRECTCOLOR:
- 			fb_logo.needs_directpalette = 1;
- 			fb_logo.needs_cmapreset = 1;
- 			break;
- 		case FB_VISUAL_PSEUDOCOLOR:
- 			fb_logo.needs_cmapreset = 1;
- 			break;
- 		}
- 	}
+	if (fb_logo.depth > 4 && depth > 4) {
+		switch (info->fix.visual) {
+		case FB_VISUAL_TRUECOLOR:
+			fb_logo.needs_truepalette = 1;
+			break;
+		case FB_VISUAL_DIRECTCOLOR:
+			fb_logo.needs_directpalette = 1;
+			fb_logo.needs_cmapreset = 1;
+			break;
+		case FB_VISUAL_PSEUDOCOLOR:
+			fb_logo.needs_cmapreset = 1;
+			break;
+		}
+	}
 
 	height = fb_logo.logo->height;
 	if (fb_center_logo)
@@ -1060,19 +1060,19 @@ fb_blank(struct fb_info *info, int blank
 	struct fb_event event;
 	int ret = -EINVAL;
 
- 	if (blank > FB_BLANK_POWERDOWN)
- 		blank = FB_BLANK_POWERDOWN;
+	if (blank > FB_BLANK_POWERDOWN)
+		blank = FB_BLANK_POWERDOWN;
 
 	event.info = info;
 	event.data = &blank;
 
 	if (info->fbops->fb_blank)
- 		ret = info->fbops->fb_blank(blank, info);
+		ret = info->fbops->fb_blank(blank, info);
 
 	if (!ret)
 		fb_notifier_call_chain(FB_EVENT_BLANK, &event);
 
- 	return ret;
+	return ret;
 }
 EXPORT_SYMBOL(fb_blank);
 


