Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2DD9510BB53
	for <lists+stable@lfdr.de>; Wed, 27 Nov 2019 22:11:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730901AbfK0VLl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 27 Nov 2019 16:11:41 -0500
Received: from mail.kernel.org ([198.145.29.99]:40384 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732758AbfK0VLh (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 27 Nov 2019 16:11:37 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4933A2154A;
        Wed, 27 Nov 2019 21:11:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1574889096;
        bh=/cg2bAmI7uI2SxnxtxpG8PwGvgizfuvw/FEYoaE4u1I=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=FTIwgsNluVFfnc6EPJajKUQw3+e84f2Zau3aaSCn0Kds/V0iKbEnMy95B8O7HZEob
         Fu0jR8baPODM/O0xKyj3puEPW8qtfcJ10RDA5Ftyf8ualr1jPS7KrBU7C/ZUMu1rDK
         UrdWcnh//m/hW6OqFaHPzNih8P5a+rVDtuB6Y0KE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Oliver Neukum <oneukum@suse.com>,
        Shuah Khan <skhan@linuxfoundation.org>
Subject: [PATCH 5.3 81/95] USBIP: add config dependency for SGL_ALLOC
Date:   Wed, 27 Nov 2019 21:32:38 +0100
Message-Id: <20191127202949.441007397@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191127202845.651587549@linuxfoundation.org>
References: <20191127202845.651587549@linuxfoundation.org>
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
@@ -4,6 +4,7 @@ config USBIP_CORE
 	tristate "USB/IP support"
 	depends on NET
 	select USB_COMMON
+	select SGL_ALLOC
 	---help---
 	  This enables pushing USB packets over IP to allow remote
 	  machines direct access to USB devices. It provides the


