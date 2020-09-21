Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 50BC0272D84
	for <lists+stable@lfdr.de>; Mon, 21 Sep 2020 18:41:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728508AbgIUQk4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 21 Sep 2020 12:40:56 -0400
Received: from mail.kernel.org ([198.145.29.99]:43750 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728887AbgIUQkn (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 21 Sep 2020 12:40:43 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C2C58235F9;
        Mon, 21 Sep 2020 16:40:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1600706443;
        bh=I8vTKPKPUh/H/WNeeEyNJZRVJ2gJ3oDIQYlO/tpd1WQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=k4Tgz5Ng+9sP/kPe9nCAtrt2l42S3sZv0t4a6dDWB2Pv50a+4hOPP2xnklAJYsQAS
         jsV76SiCU7RVWIXVHt9M5NGabvLC4GgCE9e/kF8uGkAFhfsr19faC8bRfrScFuqS7o
         IMEz9ywV+iyXGvbkq/KwueuZwY3Gt7RpM68jyYEc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Adam Borowski <kilobyte@angband.pl>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        linux-usb@vger.kernel.org, Ingo Molnar <mingo@kernel.org>,
        Andy Shevchenko <andy.shevchenko@gmail.com>
Subject: [PATCH 4.14 94/94] x86/defconfig: Enable CONFIG_USB_XHCI_HCD=y
Date:   Mon, 21 Sep 2020 18:28:21 +0200
Message-Id: <20200921162039.881390757@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200921162035.541285330@linuxfoundation.org>
References: <20200921162035.541285330@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Adam Borowski <kilobyte@angband.pl>

commit 72a9c673636b779e370983fea08e40f97039b981 upstream.

A spanking new machine I just got has all but one USB ports wired as 3.0.
Booting defconfig resulted in no keyboard or mouse, which was pretty
uncool.  Let's enable that -- USB3 is ubiquitous rather than an oddity.
As 'y' not 'm' -- recovering from initrd problems needs a keyboard.

Also add it to the 32-bit defconfig.

Signed-off-by: Adam Borowski <kilobyte@angband.pl>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: linux-usb@vger.kernel.org
Link: http://lkml.kernel.org/r/20181009062803.4332-1-kilobyte@angband.pl
Signed-off-by: Ingo Molnar <mingo@kernel.org>
Cc: Andy Shevchenko <andy.shevchenko@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/x86/configs/i386_defconfig   |    1 +
 arch/x86/configs/x86_64_defconfig |    1 +
 2 files changed, 2 insertions(+)

--- a/arch/x86/configs/i386_defconfig
+++ b/arch/x86/configs/i386_defconfig
@@ -246,6 +246,7 @@ CONFIG_USB_HIDDEV=y
 CONFIG_USB=y
 CONFIG_USB_ANNOUNCE_NEW_DEVICES=y
 CONFIG_USB_MON=y
+CONFIG_USB_XHCI_HCD=y
 CONFIG_USB_EHCI_HCD=y
 CONFIG_USB_EHCI_TT_NEWSCHED=y
 CONFIG_USB_OHCI_HCD=y
--- a/arch/x86/configs/x86_64_defconfig
+++ b/arch/x86/configs/x86_64_defconfig
@@ -242,6 +242,7 @@ CONFIG_USB_HIDDEV=y
 CONFIG_USB=y
 CONFIG_USB_ANNOUNCE_NEW_DEVICES=y
 CONFIG_USB_MON=y
+CONFIG_USB_XHCI_HCD=y
 CONFIG_USB_EHCI_HCD=y
 CONFIG_USB_EHCI_TT_NEWSCHED=y
 CONFIG_USB_OHCI_HCD=y


