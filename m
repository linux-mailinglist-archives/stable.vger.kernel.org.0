Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AD51737885D
	for <lists+stable@lfdr.de>; Mon, 10 May 2021 13:43:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239198AbhEJLVP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 May 2021 07:21:15 -0400
Received: from mail.kernel.org ([198.145.29.99]:46088 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237030AbhEJLLL (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 10 May 2021 07:11:11 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 941C5614A7;
        Mon, 10 May 2021 11:06:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1620644786;
        bh=WD0VxmD0jXbOJpnFSBMcKfcwq8epPpFBO2mhB3tNRkA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ZcHC2sI4BDf0qVKxAGK5UT3pI0UIVWjlgwnzXytRalliEpnlYLknnRe8qiCMnxRVW
         vei3RupeBmB8HhXCx93E0b6zRIMx8YYWQcYcu8XGonkD38ssvicZTEuiDcgvfkVANU
         jGd7aWmb9FxeoJ/XZgvcpE+Nhfy2dwFz4hutzWyw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.12 222/384] media: uvcvideo: Fix XU id print in forward scan
Date:   Mon, 10 May 2021 12:20:11 +0200
Message-Id: <20210510102022.221922409@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210510102014.849075526@linuxfoundation.org>
References: <20210510102014.849075526@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>

[ Upstream commit 3293448632ff2ae8c7cde4c3475da96138e24ca7 ]

An error message in the forward scan code incorrectly prints the ID of
the source entity instead of the XU entity being scanned. Fix it.

Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Signed-off-by: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/usb/uvc/uvc_driver.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/usb/uvc/uvc_driver.c b/drivers/media/usb/uvc/uvc_driver.c
index 30ef2a3110f7..e55cf02baad6 100644
--- a/drivers/media/usb/uvc/uvc_driver.c
+++ b/drivers/media/usb/uvc/uvc_driver.c
@@ -1712,7 +1712,7 @@ static int uvc_scan_chain_forward(struct uvc_video_chain *chain,
 			if (forward->bNrInPins != 1) {
 				uvc_dbg(chain->dev, DESCR,
 					"Extension unit %d has more than 1 input pin\n",
-					entity->id);
+					forward->id);
 				return -EINVAL;
 			}
 
-- 
2.30.2



