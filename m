Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DBE014510CB
	for <lists+stable@lfdr.de>; Mon, 15 Nov 2021 19:52:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243103AbhKOSzW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Nov 2021 13:55:22 -0500
Received: from mail.kernel.org ([198.145.29.99]:54308 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S243149AbhKOSw1 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Nov 2021 13:52:27 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3917B633BA;
        Mon, 15 Nov 2021 18:09:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1636999773;
        bh=dQiUjyVYhqppDt0Inm25W2OeF8CpFYuGtBwEO0Vfj6o=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=QMpQnIyScMPv8aQq4/wz7n/0nRUs6yNw4Ex2jpmvyZm//cx4RC8cT/+MBgN8fyj1T
         k0u/JDkBXQqd72zAQHxmHBzYOfeUqpBl5d6MWRjlS1XjsEN+BFO+qafNigDXO7i6us
         EXWTPjiRGswnS98S3szOs1p2yW+81YPRS1/IJO/E=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hans Verkuil <hverkuil-cisco@xs4all.nl>,
        Kees Cook <keescook@chromium.org>,
        Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.14 391/849] media: radio-wl1273: Avoid card name truncation
Date:   Mon, 15 Nov 2021 17:57:54 +0100
Message-Id: <20211115165433.477791012@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211115165419.961798833@linuxfoundation.org>
References: <20211115165419.961798833@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Kees Cook <keescook@chromium.org>

[ Upstream commit dfadec236aa99f6086141949c9dc3ec50f3ff20d ]

The "card" string only holds 31 characters (and the terminating NUL).
In order to avoid truncation, use a shorter card description instead of
the current result, "Texas Instruments Wl1273 FM Rad".

Suggested-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
Fixes: 87d1a50ce451 ("[media] V4L2: WL1273 FM Radio: TI WL1273 FM radio driver")
Signed-off-by: Kees Cook <keescook@chromium.org>
Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
Signed-off-by: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/radio/radio-wl1273.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/radio/radio-wl1273.c b/drivers/media/radio/radio-wl1273.c
index 1123768731676..484046471c03f 100644
--- a/drivers/media/radio/radio-wl1273.c
+++ b/drivers/media/radio/radio-wl1273.c
@@ -1279,7 +1279,7 @@ static int wl1273_fm_vidioc_querycap(struct file *file, void *priv,
 
 	strscpy(capability->driver, WL1273_FM_DRIVER_NAME,
 		sizeof(capability->driver));
-	strscpy(capability->card, "Texas Instruments Wl1273 FM Radio",
+	strscpy(capability->card, "TI Wl1273 FM Radio",
 		sizeof(capability->card));
 	strscpy(capability->bus_info, radio->bus_type,
 		sizeof(capability->bus_info));
-- 
2.33.0



