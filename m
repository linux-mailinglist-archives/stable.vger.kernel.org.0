Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 36730321771
	for <lists+stable@lfdr.de>; Mon, 22 Feb 2021 13:49:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230523AbhBVMsi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 22 Feb 2021 07:48:38 -0500
Received: from mail.kernel.org ([198.145.29.99]:56556 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231656AbhBVMol (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 22 Feb 2021 07:44:41 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4577364F08;
        Mon, 22 Feb 2021 12:41:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1613997694;
        bh=Tens+KZWgStKeLAY7QC1RTOow2s6QedXxInN0lRi6Qo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Tp23nPAIOs1sTiZ10FrzgIfmlw5qc4LDZzu70ybxZd0DxWfhLelBF7iawjpMmsqAq
         dhAPXiEL4yQ7+dLRWjpCjc+6d8xYeWjuIJnket/HP5/Tyn1dXdhVEx/GxjBIX9yRyx
         J4YtZ0uhjoftSsdsH3YVooFbTkQ3b2F3VaBHGvw0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Felipe Balbi <balbi@kernel.org>,
        Sudip Mukherjee <sudipm.mukherjee@gmail.com>
Subject: [PATCH 4.9 29/49] usb: dwc3: ulpi: fix checkpatch warning
Date:   Mon, 22 Feb 2021 13:36:27 +0100
Message-Id: <20210222121027.091734682@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210222121022.546148341@linuxfoundation.org>
References: <20210222121022.546148341@linuxfoundation.org>
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
@@ -22,7 +22,7 @@
 
 static int dwc3_ulpi_busyloop(struct dwc3 *dwc)
 {
-	unsigned count = 1000;
+	unsigned int count = 1000;
 	u32 reg;
 
 	while (count--) {


