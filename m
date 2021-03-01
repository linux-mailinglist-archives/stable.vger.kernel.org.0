Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7ECC93284CE
	for <lists+stable@lfdr.de>; Mon,  1 Mar 2021 17:44:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235196AbhCAQnR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Mar 2021 11:43:17 -0500
Received: from mail.kernel.org ([198.145.29.99]:41576 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233014AbhCAQgz (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Mar 2021 11:36:55 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id EB08564EBD;
        Mon,  1 Mar 2021 16:26:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614616007;
        bh=t5jl8b3jk72RF1zzvmMSF2PuMr6R5JKWJjDLDMpuIyc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=FMikxptmTAqk7GYFg0B+aL4rhOqmJ/WdzF1UhyvQfGQWB4IqI4EF50B6HOYo3uQnO
         eS+XiTeZAao0wI83g6hkv7zYtffwq4r+9tLkJAIqe02h8X9D4dnGUJd88Sqb41gbac
         gYin/0z63o9ZELSOV7HBZZGiYLgVebLPV3PKbNG0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Martin Kaiser <martin@kaiser.cx>
Subject: [PATCH 4.9 107/134] staging: rtl8188eu: Add Edimax EW-7811UN V2 to device table
Date:   Mon,  1 Mar 2021 17:13:28 +0100
Message-Id: <20210301161018.833752082@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210301161013.585393984@linuxfoundation.org>
References: <20210301161013.585393984@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Martin Kaiser <martin@kaiser.cx>

commit 7a8d2f1908a59003e55ef8691d09efb7fbc51625 upstream.

The Edimax EW-7811UN V2 uses an RTL8188EU chipset and works with this
driver.

Signed-off-by: Martin Kaiser <martin@kaiser.cx>
Cc: stable <stable@vger.kernel.org>
Link: https://lore.kernel.org/r/20210204085217.9743-1-martin@kaiser.cx
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/staging/rtl8188eu/os_dep/usb_intf.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/staging/rtl8188eu/os_dep/usb_intf.c
+++ b/drivers/staging/rtl8188eu/os_dep/usb_intf.c
@@ -49,6 +49,7 @@ static struct usb_device_id rtw_usb_id_t
 	{USB_DEVICE(0x2357, 0x0111)}, /* TP-Link TL-WN727N v5.21 */
 	{USB_DEVICE(0x2C4E, 0x0102)}, /* MERCUSYS MW150US v2 */
 	{USB_DEVICE(0x0df6, 0x0076)}, /* Sitecom N150 v2 */
+	{USB_DEVICE(0x7392, 0xb811)}, /* Edimax EW-7811UN V2 */
 	{USB_DEVICE(USB_VENDER_ID_REALTEK, 0xffef)}, /* Rosewill RNX-N150NUB */
 	{}	/* Terminating entry */
 };


