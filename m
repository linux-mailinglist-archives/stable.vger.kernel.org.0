Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0066932871D
	for <lists+stable@lfdr.de>; Mon,  1 Mar 2021 18:21:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237566AbhCARUC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Mar 2021 12:20:02 -0500
Received: from mail.kernel.org ([198.145.29.99]:48192 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237782AbhCARNS (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Mar 2021 12:13:18 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id A83AE64E41;
        Mon,  1 Mar 2021 16:44:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614617046;
        bh=MeykdVwE57Mz2rAOj7Qxs1H3NaB4PGkuqDXtW+yHYBg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=QGmT5rA19Wp409ntZMlrY+/lC84AqiM5SnTCuIKQneIco1WxSTpTfFlGzW01Xxnqp
         nv3W2AOlUiGkrLXXx4eKbr3ibXgPE7JQPbtyMil0yiu7Qgs649EMcrWEId0D6udPOh
         8He6TWqJc1wzC8aDcb1Qi9IIw1O8eCE35xgjrac4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?Olivier=20Cr=C3=AAte?= <olivier.crete@ocrete.ca>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>
Subject: [PATCH 4.19 183/247] Input: xpad - add support for PowerA Enhanced Wired Controller for Xbox Series X|S
Date:   Mon,  1 Mar 2021 17:13:23 +0100
Message-Id: <20210301161040.617384615@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210301161031.684018251@linuxfoundation.org>
References: <20210301161031.684018251@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Olivier Crête <olivier.crete@ocrete.ca>

commit 42ffcd1dba1796bcda386eb6f260df9fc23c90af upstream.

Signed-off-by: Olivier Crête <olivier.crete@ocrete.ca>
Link: https://lore.kernel.org/r/20210204005318.615647-1-olivier.crete@collabora.com
Cc: stable@vger.kernel.org
Signed-off-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/input/joystick/xpad.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/input/joystick/xpad.c
+++ b/drivers/input/joystick/xpad.c
@@ -319,6 +319,7 @@ static const struct xpad_device {
 	{ 0x1bad, 0xfd00, "Razer Onza TE", 0, XTYPE_XBOX360 },
 	{ 0x1bad, 0xfd01, "Razer Onza", 0, XTYPE_XBOX360 },
 	{ 0x20d6, 0x2001, "BDA Xbox Series X Wired Controller", 0, XTYPE_XBOXONE },
+	{ 0x20d6, 0x2009, "PowerA Enhanced Wired Controller for Xbox Series X|S", 0, XTYPE_XBOXONE },
 	{ 0x20d6, 0x281f, "PowerA Wired Controller For Xbox 360", 0, XTYPE_XBOX360 },
 	{ 0x2e24, 0x0652, "Hyperkin Duke X-Box One pad", 0, XTYPE_XBOXONE },
 	{ 0x24c6, 0x5000, "Razer Atrox Arcade Stick", MAP_TRIGGERS_TO_BUTTONS, XTYPE_XBOX360 },


