Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6BE1D1F439B
	for <lists+stable@lfdr.de>; Tue,  9 Jun 2020 19:55:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731802AbgFIRy5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 9 Jun 2020 13:54:57 -0400
Received: from mail.kernel.org ([198.145.29.99]:46938 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730316AbgFIRy4 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 9 Jun 2020 13:54:56 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 76BA42074B;
        Tue,  9 Jun 2020 17:54:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1591725295;
        bh=Es5pHFAq7C4C4t/s9Cs/BOCCeaIGYNiWTOPz+6neDk4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Vo4FEcirkt4B3dLGF8VZrsEXeaHse1+PEjTs9VWGDTcKlkQbW46nOArAlyz7qESpY
         gbkiKm19bFF2hArJL4h4dH93o8PJRWuH3Ld1ed5/AoCvB9JCccZh+dkpZGlzD6tM7Y
         mw9fNEcaCwo+3Zn2cBRMAjTEIvLi0rbIaEqVHnjA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Matt Jolly <Kangie@footclan.ninja>,
        Johan Hovold <johan@kernel.org>
Subject: [PATCH 5.7 01/24] USB: serial: qcserial: add DW5816e QDL support
Date:   Tue,  9 Jun 2020 19:45:32 +0200
Message-Id: <20200609174149.393518043@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200609174149.255223112@linuxfoundation.org>
References: <20200609174149.255223112@linuxfoundation.org>
User-Agent: quilt/0.66
X-stable: review
X-Patchwork-Hint: ignore
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Matt Jolly <Kangie@footclan.ninja>

commit 3429444abdd9dbd5faebd9bee552ec6162b17ad6 upstream.

Add support for Dell Wireless 5816e Download Mode (AKA boot & hold mode /
QDL download mode) to drivers/usb/serial/qcserial.c

This is required to update device firmware.

Signed-off-by: Matt Jolly <Kangie@footclan.ninja>
Cc: stable@vger.kernel.org
Signed-off-by: Johan Hovold <johan@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/usb/serial/qcserial.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/usb/serial/qcserial.c
+++ b/drivers/usb/serial/qcserial.c
@@ -173,6 +173,7 @@ static const struct usb_device_id id_tab
 	{DEVICE_SWI(0x413c, 0x81b3)},	/* Dell Wireless 5809e Gobi(TM) 4G LTE Mobile Broadband Card (rev3) */
 	{DEVICE_SWI(0x413c, 0x81b5)},	/* Dell Wireless 5811e QDL */
 	{DEVICE_SWI(0x413c, 0x81b6)},	/* Dell Wireless 5811e QDL */
+	{DEVICE_SWI(0x413c, 0x81cb)},	/* Dell Wireless 5816e QDL */
 	{DEVICE_SWI(0x413c, 0x81cc)},	/* Dell Wireless 5816e */
 	{DEVICE_SWI(0x413c, 0x81cf)},   /* Dell Wireless 5819 */
 	{DEVICE_SWI(0x413c, 0x81d0)},   /* Dell Wireless 5819 */


