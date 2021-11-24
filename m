Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 32AAD45BFFD
	for <lists+stable@lfdr.de>; Wed, 24 Nov 2021 14:01:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343820AbhKXNEB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Nov 2021 08:04:01 -0500
Received: from mail.kernel.org ([198.145.29.99]:41112 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1346114AbhKXNCV (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 24 Nov 2021 08:02:21 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id E9F716117A;
        Wed, 24 Nov 2021 12:35:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1637757333;
        bh=2vXNAOMZNI0ZRvHjroL+2tM1qJvlSSylceOHL8Q+7CA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=1CwynYw2Rva0YUIaI/3nZf17VJ4svmfHz5n9c+kwnqZ0sTO+QdZBnMrueW2CTVeCz
         O9F06z7ryHdYSWeEcnSk72G6dmGR4zEbEvsGWIp9m5dNZU0q28WjgD/R4mXQ+FLSEZ
         L7sS9nv2PxW1djYUYA+RdY8wtjDU8yg4ag9/SatY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hans Verkuil <hverkuil-cisco@xs4all.nl>,
        Kees Cook <keescook@chromium.org>,
        Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 134/323] media: si470x: Avoid card name truncation
Date:   Wed, 24 Nov 2021 12:55:24 +0100
Message-Id: <20211124115723.451422346@linuxfoundation.org>
X-Mailer: git-send-email 2.34.0
In-Reply-To: <20211124115718.822024889@linuxfoundation.org>
References: <20211124115718.822024889@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Kees Cook <keescook@chromium.org>

[ Upstream commit 2908249f3878a591f7918368fdf0b7b0a6c3158c ]

The "card" string only holds 31 characters (and the terminating NUL).
In order to avoid truncation, use a shorter card description instead of
the current result, "Silicon Labs Si470x FM Radio Re".

Suggested-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
Fixes: 78656acdcf48 ("V4L/DVB (7038): USB radio driver for Silicon Labs Si470x FM Radio Receivers")
Fixes: cc35bbddfe10 ("V4L/DVB (12416): radio-si470x: add i2c driver for si470x")
Signed-off-by: Kees Cook <keescook@chromium.org>
Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
Signed-off-by: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/radio/si470x/radio-si470x-i2c.c | 2 +-
 drivers/media/radio/si470x/radio-si470x-usb.c | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/media/radio/si470x/radio-si470x-i2c.c b/drivers/media/radio/si470x/radio-si470x-i2c.c
index aa12fd2663895..cc68bdac0c367 100644
--- a/drivers/media/radio/si470x/radio-si470x-i2c.c
+++ b/drivers/media/radio/si470x/radio-si470x-i2c.c
@@ -20,7 +20,7 @@
 
 /* driver definitions */
 #define DRIVER_AUTHOR "Joonyoung Shim <jy0922.shim@samsung.com>";
-#define DRIVER_CARD "Silicon Labs Si470x FM Radio Receiver"
+#define DRIVER_CARD "Silicon Labs Si470x FM Radio"
 #define DRIVER_DESC "I2C radio driver for Si470x FM Radio Receivers"
 #define DRIVER_VERSION "1.0.2"
 
diff --git a/drivers/media/radio/si470x/radio-si470x-usb.c b/drivers/media/radio/si470x/radio-si470x-usb.c
index 19e381dd58089..ba43a727c0b95 100644
--- a/drivers/media/radio/si470x/radio-si470x-usb.c
+++ b/drivers/media/radio/si470x/radio-si470x-usb.c
@@ -25,7 +25,7 @@
 
 /* driver definitions */
 #define DRIVER_AUTHOR "Tobias Lorenz <tobias.lorenz@gmx.net>"
-#define DRIVER_CARD "Silicon Labs Si470x FM Radio Receiver"
+#define DRIVER_CARD "Silicon Labs Si470x FM Radio"
 #define DRIVER_DESC "USB radio driver for Si470x FM Radio Receivers"
 #define DRIVER_VERSION "1.0.10"
 
-- 
2.33.0



