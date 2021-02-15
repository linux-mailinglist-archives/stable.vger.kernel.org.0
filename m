Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 338B531BCB1
	for <lists+stable@lfdr.de>; Mon, 15 Feb 2021 16:33:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231255AbhBOPdq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Feb 2021 10:33:46 -0500
Received: from mail.kernel.org ([198.145.29.99]:45570 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231250AbhBOPcd (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Feb 2021 10:32:33 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9CFA164E9D;
        Mon, 15 Feb 2021 15:29:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1613402996;
        bh=aDrOIhhLPS8fdsbA/Tn0kJqNlUVarlzIKJs+IVnVuM0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=DI0XAZfGNE2IzbupiOhNLncDXOyiwp2rCImtd4IV7ojjueigevFFgVJgvRCjwcF0C
         Yr2jLh9x7wVrgk+mQ9ghlIhUoT2F79YNe5Ba+MOQHQp9P1a2o3DtRDMbBuK89t4vMB
         p2DwAT6+ge8e2IZPsjN2AYCEs6znOwsgPCVx6ZHM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Felipe Balbi <balbi@kernel.org>,
        Sudip Mukherjee <sudipm.mukherjee@gmail.com>
Subject: [PATCH 5.4 47/60] usb: dwc3: ulpi: fix checkpatch warning
Date:   Mon, 15 Feb 2021 16:27:35 +0100
Message-Id: <20210215152716.875389388@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210215152715.401453874@linuxfoundation.org>
References: <20210215152715.401453874@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Felipe Balbi <balbi@kernel.org>

commit 2a499b45295206e7f3dc76edadde891c06cc4447 upstream

no functional changes.

Signed-off-by: Felipe Balbi <balbi@kernel.org>
Signed-off-by: Sudip Mukherjee <sudipm.mukherjee@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/dwc3/ulpi.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/usb/dwc3/ulpi.c
+++ b/drivers/usb/dwc3/ulpi.c
@@ -19,7 +19,7 @@
 
 static int dwc3_ulpi_busyloop(struct dwc3 *dwc)
 {
-	unsigned count = 1000;
+	unsigned int count = 1000;
 	u32 reg;
 
 	while (count--) {


