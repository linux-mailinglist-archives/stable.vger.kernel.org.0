Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0747CA91B9
	for <lists+stable@lfdr.de>; Wed,  4 Sep 2019 21:40:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732199AbfIDSYc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 4 Sep 2019 14:24:32 -0400
Received: from mail.kernel.org ([198.145.29.99]:40912 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388551AbfIDSBW (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 4 Sep 2019 14:01:22 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1C7C0233FF;
        Wed,  4 Sep 2019 18:01:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1567620081;
        bh=Agm7Gx9JZ79sv3rkp+il6lu4tb27ryMPb3LzsWceM2w=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=DMqZv7Ubhw/gn0neI7KNFhZ978vkRwCd7NDqjljykGap3TR7N1Djc4wf8YEO04P4O
         JMHEKvgX8tszkBjQ4B5ynZltWoXCW+P5odMQQDJVNrqWB3IclbZuC5eVJXZxiItxP7
         DdMpTBzKKre6iPbJM14Ngp7p0uAqZht4jbs8RKGM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Henk van der Laan <opensource@henkvdlaan.com>
Subject: [PATCH 4.9 65/83] usb-storage: Add new JMS567 revision to unusual_devs
Date:   Wed,  4 Sep 2019 19:53:57 +0200
Message-Id: <20190904175309.343129768@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20190904175303.488266791@linuxfoundation.org>
References: <20190904175303.488266791@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Henk van der Laan <opensource@henkvdlaan.com>

commit 08d676d1685c2a29e4d0e1b0242324e564d4589e upstream.

Revision 0x0117 suffers from an identical issue to earlier revisions,
therefore it should be added to the quirks list.

Signed-off-by: Henk van der Laan <opensource@henkvdlaan.com>
Cc: stable <stable@vger.kernel.org>
Link: https://lore.kernel.org/r/20190816200847.21366-1-opensource@henkvdlaan.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/usb/storage/unusual_devs.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/usb/storage/unusual_devs.h
+++ b/drivers/usb/storage/unusual_devs.h
@@ -2119,7 +2119,7 @@ UNUSUAL_DEV(  0x14cd, 0x6600, 0x0201, 0x
 		US_FL_IGNORE_RESIDUE ),
 
 /* Reported by Michael Büsch <m@bues.ch> */
-UNUSUAL_DEV(  0x152d, 0x0567, 0x0114, 0x0116,
+UNUSUAL_DEV(  0x152d, 0x0567, 0x0114, 0x0117,
 		"JMicron",
 		"USB to ATA/ATAPI Bridge",
 		USB_SC_DEVICE, USB_PR_DEVICE, NULL,


