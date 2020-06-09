Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2B7091F459E
	for <lists+stable@lfdr.de>; Tue,  9 Jun 2020 20:18:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732610AbgFIRuH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 9 Jun 2020 13:50:07 -0400
Received: from mail.kernel.org ([198.145.29.99]:37036 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728767AbgFIRuD (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 9 Jun 2020 13:50:03 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1BAB020835;
        Tue,  9 Jun 2020 17:50:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1591725003;
        bh=JWfUK1UurEc1IJd4vKsIl1wbDbG8V745DfuhATHNP6g=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=R4Re5ByHX0A5w3VxDhBxgywEMCawFcMPEHUeXQhYl2UU527tJ/MEf6J2z0KdNTdCN
         YQRY8x153NpDW8Am1ilnYVuFfr3KMndjFMPZ3Ps/9eol92VOKyT+5H+zDxvSt0aY6u
         7bI8jLvAm+pfwXgNpbhdbof8rO356+3vF2/3wqEI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Matt Jolly <Kangie@footclan.ninja>,
        Johan Hovold <johan@kernel.org>
Subject: [PATCH 4.14 30/46] USB: serial: qcserial: add DW5816e QDL support
Date:   Tue,  9 Jun 2020 19:44:46 +0200
Message-Id: <20200609174028.585482260@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200609174022.938987501@linuxfoundation.org>
References: <20200609174022.938987501@linuxfoundation.org>
User-Agent: quilt/0.66
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
@@ -177,6 +177,7 @@ static const struct usb_device_id id_tab
 	{DEVICE_SWI(0x413c, 0x81b3)},	/* Dell Wireless 5809e Gobi(TM) 4G LTE Mobile Broadband Card (rev3) */
 	{DEVICE_SWI(0x413c, 0x81b5)},	/* Dell Wireless 5811e QDL */
 	{DEVICE_SWI(0x413c, 0x81b6)},	/* Dell Wireless 5811e QDL */
+	{DEVICE_SWI(0x413c, 0x81cb)},	/* Dell Wireless 5816e QDL */
 	{DEVICE_SWI(0x413c, 0x81cc)},	/* Dell Wireless 5816e */
 	{DEVICE_SWI(0x413c, 0x81cf)},   /* Dell Wireless 5819 */
 	{DEVICE_SWI(0x413c, 0x81d0)},   /* Dell Wireless 5819 */


