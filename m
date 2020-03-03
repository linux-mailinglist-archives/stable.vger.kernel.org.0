Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5D223178133
	for <lists+stable@lfdr.de>; Tue,  3 Mar 2020 20:01:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387621AbgCCSBM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Mar 2020 13:01:12 -0500
Received: from mail.kernel.org ([198.145.29.99]:45238 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387451AbgCCSBL (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 3 Mar 2020 13:01:11 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 395FC206E6;
        Tue,  3 Mar 2020 18:01:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1583258470;
        bh=FnzoUfbU4XGvURm4/EiVNcLjZo35WEklWlICANhp3AI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=RHs82jPzkpIA/761SC77ytpZIoeyh9Eo9ssbCwag2Xgg7Hmr/ifpDKW7KggzshzVn
         tXdux65sGqkBrZLQTYr/LrT8A+30OmbIn+dB4/5X+W5KUQtoXdCYRZryrNQs1JgWyV
         utRCPgsY7S7ezDPDIGiXbSpL0c20wJ5AD5HuQBtU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Peter Chen <peter.chen@nxp.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 60/87] usb: charger: assign specific number for enum value
Date:   Tue,  3 Mar 2020 18:43:51 +0100
Message-Id: <20200303174355.750234821@linuxfoundation.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200303174349.075101355@linuxfoundation.org>
References: <20200303174349.075101355@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Peter Chen <peter.chen@nxp.com>

commit ca4b43c14cd88d28cfc6467d2fa075aad6818f1d upstream.

To work properly on every architectures and compilers, the enum value
needs to be specific numbers.

Suggested-by: Greg KH <gregkh@linuxfoundation.org>
Signed-off-by: Peter Chen <peter.chen@nxp.com>
Link: https://lore.kernel.org/r/1580537624-10179-1-git-send-email-peter.chen@nxp.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 include/uapi/linux/usb/charger.h |   16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

--- a/include/uapi/linux/usb/charger.h
+++ b/include/uapi/linux/usb/charger.h
@@ -14,18 +14,18 @@
  * ACA (Accessory Charger Adapters)
  */
 enum usb_charger_type {
-	UNKNOWN_TYPE,
-	SDP_TYPE,
-	DCP_TYPE,
-	CDP_TYPE,
-	ACA_TYPE,
+	UNKNOWN_TYPE = 0,
+	SDP_TYPE = 1,
+	DCP_TYPE = 2,
+	CDP_TYPE = 3,
+	ACA_TYPE = 4,
 };
 
 /* USB charger state */
 enum usb_charger_state {
-	USB_CHARGER_DEFAULT,
-	USB_CHARGER_PRESENT,
-	USB_CHARGER_ABSENT,
+	USB_CHARGER_DEFAULT = 0,
+	USB_CHARGER_PRESENT = 1,
+	USB_CHARGER_ABSENT = 2,
 };
 
 #endif /* _UAPI__LINUX_USB_CHARGER_H */


