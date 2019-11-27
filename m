Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A28D310BADF
	for <lists+stable@lfdr.de>; Wed, 27 Nov 2019 22:07:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731987AbfK0VHZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 27 Nov 2019 16:07:25 -0500
Received: from mail.kernel.org ([198.145.29.99]:33514 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731116AbfK0VHX (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 27 Nov 2019 16:07:23 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8569F2080F;
        Wed, 27 Nov 2019 21:07:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1574888843;
        bh=pZ0s4DZ/i+FNCch0LkMrLmWilj61CkJzi7PQgtZDvo8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=jHcfPK9mb5Iw0T1I2PsXcowKN57v1V1B7GfNp40Uvn/P1jmPav/yCVlh3VE7/W5GO
         QLgkGznbfJzxo1Hmjv3pxRrGzsth6s1zWrfPV6wuXeD4qlNTt5VFIlzaV6A/ubwQok
         3dX0Ht3jOcrxwgSHZ+jNIQtr+4NSPf1MOelYXyvQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Oliver Neukum <oneukum@suse.com>,
        Shuah Khan <skhan@linuxfoundation.org>
Subject: [PATCH 4.19 292/306] USBIP: add config dependency for SGL_ALLOC
Date:   Wed, 27 Nov 2019 21:32:22 +0100
Message-Id: <20191127203136.086861109@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191127203114.766709977@linuxfoundation.org>
References: <20191127203114.766709977@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Oliver Neukum <oneukum@suse.com>

commit 1ec13abac58b6f24e32f0d3081ef4e7456e62ed8 upstream.

USBIP uses lib/scatterlist.h
Hence it needs to set CONFIG_SGL_ALLOC

Signed-off-by: Oliver Neukum <oneukum@suse.com>
Cc: stable <stable@vger.kernel.org>
Acked-by: Shuah Khan <skhan@linuxfoundation.org>
Link: https://lore.kernel.org/r/20191112154939.21217-1-oneukum@suse.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/usb/usbip/Kconfig |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/usb/usbip/Kconfig
+++ b/drivers/usb/usbip/Kconfig
@@ -2,6 +2,7 @@ config USBIP_CORE
 	tristate "USB/IP support"
 	depends on NET
 	select USB_COMMON
+	select SGL_ALLOC
 	---help---
 	  This enables pushing USB packets over IP to allow remote
 	  machines direct access to USB devices. It provides the


