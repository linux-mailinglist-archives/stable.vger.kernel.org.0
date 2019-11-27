Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9CACD10BBAF
	for <lists+stable@lfdr.de>; Wed, 27 Nov 2019 22:15:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387646AbfK0VPG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 27 Nov 2019 16:15:06 -0500
Received: from mail.kernel.org ([198.145.29.99]:50028 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387642AbfK0VPG (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 27 Nov 2019 16:15:06 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C06B6216F4;
        Wed, 27 Nov 2019 21:15:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1574889305;
        bh=/cg2bAmI7uI2SxnxtxpG8PwGvgizfuvw/FEYoaE4u1I=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=V8NeAhZ276TR2r3egQYMHEQjfy37ZJ0hgdQbNULJdZPP2y0rmEjla6t7GcYziETay
         wSxrAhLVf14NySkW1xcnc0ZfcgYl+CSkI0yNpdq4ZN0ucSqWVk50/ZySnlMDDiZ5ss
         ktS2ForzkLXeF9XAaXdYEr+KtyFVL2HfU/ARw4/Y=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Oliver Neukum <oneukum@suse.com>,
        Shuah Khan <skhan@linuxfoundation.org>
Subject: [PATCH 5.4 53/66] USBIP: add config dependency for SGL_ALLOC
Date:   Wed, 27 Nov 2019 21:32:48 +0100
Message-Id: <20191127202733.747256473@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191127202632.536277063@linuxfoundation.org>
References: <20191127202632.536277063@linuxfoundation.org>
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


