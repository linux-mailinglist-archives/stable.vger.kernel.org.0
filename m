Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 01CDA1A0B7E
	for <lists+stable@lfdr.de>; Tue,  7 Apr 2020 12:27:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728378AbgDGK1I (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Apr 2020 06:27:08 -0400
Received: from mail.kernel.org ([198.145.29.99]:39432 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729279AbgDGK1F (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 7 Apr 2020 06:27:05 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5CF772078A;
        Tue,  7 Apr 2020 10:27:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1586255224;
        bh=7d/wJqUuz5hIfd5ZLbF0o2zPbMj1oDOeQJTFbf3ygB8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=vbGfCIqEdCD9oLndXrXQGpjWMO1fh626n1j86oBsTDsG3IXbHK3qJ7PiG2ySvY8JJ
         GN7G4hnirqOW324nWv71ZEE7rVwR7/aRsiuPOGwRY0HIc10WjL1X4pxMtFxIvONtNJ
         yrw+vvzTYn1nkxLm5mUxj/0RoT+Nh8OtrrSCSs8I=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, "Dmitry V. Levin" <ldv@altlinux.org>,
        Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 5.6 26/29] Revert "ALSA: uapi: Drop asound.h inclusion from asoc.h"
Date:   Tue,  7 Apr 2020 12:22:23 +0200
Message-Id: <20200407101455.292977095@linuxfoundation.org>
X-Mailer: git-send-email 2.26.0
In-Reply-To: <20200407101452.046058399@linuxfoundation.org>
References: <20200407101452.046058399@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Takashi Iwai <tiwai@suse.de>

commit b6f69c795547f59ddf1db17cddbd2b9a15c656ed upstream.

This reverts commit 645c08f17f477915f6d900b767e789852f150054
which was reported to break the build a program using this header.

The original issue was addressed in the alsa-lib side recently, so we
can make the header more self-contained again.

Reported-by: Dmitry V. Levin <ldv@altlinux.org>
Fixes: 645c08f17f47 ("ALSA: uapi: Drop asound.h inclusion from asoc.h")
Cc: <stable@vger.kernel.org>
Link: https://lore.kernel.org/r/20200331090023.8112-1-tiwai@suse.de
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 include/uapi/sound/asoc.h |    1 +
 1 file changed, 1 insertion(+)

--- a/include/uapi/sound/asoc.h
+++ b/include/uapi/sound/asoc.h
@@ -17,6 +17,7 @@
 #define __LINUX_UAPI_SND_ASOC_H
 
 #include <linux/types.h>
+#include <sound/asound.h>
 
 /*
  * Maximum number of channels topology kcontrol can represent.


