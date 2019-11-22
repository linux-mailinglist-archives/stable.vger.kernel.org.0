Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 63E25106B69
	for <lists+stable@lfdr.de>; Fri, 22 Nov 2019 11:44:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728290AbfKVKoD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 22 Nov 2019 05:44:03 -0500
Received: from mail.kernel.org ([198.145.29.99]:49754 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729293AbfKVKn7 (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 22 Nov 2019 05:43:59 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 23FBF20717;
        Fri, 22 Nov 2019 10:43:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1574419438;
        bh=ZPx3Vy/86jl0wKdRxpnPl9z9J+BNHaRp+RGaA7wUUqk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ttWceY6BIbJ8G5J/508ct2FaV3Itr+t0uurMf1hQYOt+Fg2CZGQSM+8UITPBokFNg
         ARhMQiev6zU/YhYDbtAiwlCzwhXQXnlDLxnAmGdG645xkEF9YEHR7vw0fLaqOgypDY
         BwGQaFj2NVPL0S8Ibwg+IuCZnDmXEUHyzbdHySiw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Brad Love <brad@nextdimension.cc>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Mauro Carvalho Chehab <mchehab+samsung@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.9 110/222] media: au0828: Fix incorrect error messages
Date:   Fri, 22 Nov 2019 11:27:30 +0100
Message-Id: <20191122100911.209989428@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191122100830.874290814@linuxfoundation.org>
References: <20191122100830.874290814@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Brad Love <brad@nextdimension.cc>

[ Upstream commit f347596f2bf114a3af3d80201c6e6bef538d884f ]

Correcting red herring error messages.

Where appropriate, replaces au0282_dev_register with:
- au0828_analog_register
- au0828_dvb_register

Signed-off-by: Brad Love <brad@nextdimension.cc>
Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
Signed-off-by: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/usb/au0828/au0828-core.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/media/usb/au0828/au0828-core.c b/drivers/media/usb/au0828/au0828-core.c
index 38e73ee5c8fb1..78f0bf8ee084c 100644
--- a/drivers/media/usb/au0828/au0828-core.c
+++ b/drivers/media/usb/au0828/au0828-core.c
@@ -639,7 +639,7 @@ static int au0828_usb_probe(struct usb_interface *interface,
 	/* Analog TV */
 	retval = au0828_analog_register(dev, interface);
 	if (retval) {
-		pr_err("%s() au0282_dev_register failed to register on V4L2\n",
+		pr_err("%s() au0828_analog_register failed to register on V4L2\n",
 			__func__);
 		goto done;
 	}
@@ -647,7 +647,7 @@ static int au0828_usb_probe(struct usb_interface *interface,
 	/* Digital TV */
 	retval = au0828_dvb_register(dev);
 	if (retval)
-		pr_err("%s() au0282_dev_register failed\n",
+		pr_err("%s() au0828_dvb_register failed\n",
 		       __func__);
 
 	/* Remote controller */
-- 
2.20.1



