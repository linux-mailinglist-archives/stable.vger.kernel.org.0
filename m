Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 03F541C1648
	for <lists+stable@lfdr.de>; Fri,  1 May 2020 16:08:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731606AbgEANnN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 1 May 2020 09:43:13 -0400
Received: from mail.kernel.org ([198.145.29.99]:44070 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731598AbgEANnL (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 1 May 2020 09:43:11 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 55EB820757;
        Fri,  1 May 2020 13:43:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1588340590;
        bh=PSaJ1BEBQU3mfy6N4+Y8OwifRG6WIWfcHfx4ODH8A0g=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=udB9CA1H2+t5DZ2vOPkMH3tPRTF8NjzOo/8E27I9aj3ECPBDz9w/v9Hh8Xwoi6bua
         9zBOMl0+9pRscwCNWRdBFZVgYTJT9BmydP9ICw30ljecXpvRFVSXSDqWnf4NeKIFUY
         Hpys9esUuDklzafANu9Hib/brL6/X6Wi1P6IAAlg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Raymond Pang <RaymondPang-oc@zhaoxin.com>,
        Bjorn Helgaas <bhelgaas@google.com>
Subject: [PATCH 5.6 044/106] PCI: Add Zhaoxin Vendor ID
Date:   Fri,  1 May 2020 15:23:17 +0200
Message-Id: <20200501131549.008314812@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200501131543.421333643@linuxfoundation.org>
References: <20200501131543.421333643@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Raymond Pang <RaymondPang-oc@zhaoxin.com>

commit 3375590623e4a132b19a8740512f4deb95728933 upstream.

Add Zhaoxin Vendor ID to pci_ids.h

Link: https://lore.kernel.org/r/20200327091148.5190-2-RaymondPang-oc@zhaoxin.com
Signed-off-by: Raymond Pang <RaymondPang-oc@zhaoxin.com>
Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 include/linux/pci_ids.h |    2 ++
 1 file changed, 2 insertions(+)

--- a/include/linux/pci_ids.h
+++ b/include/linux/pci_ids.h
@@ -2583,6 +2583,8 @@
 
 #define PCI_VENDOR_ID_AMAZON		0x1d0f
 
+#define PCI_VENDOR_ID_ZHAOXIN		0x1d17
+
 #define PCI_VENDOR_ID_HYGON		0x1d94
 
 #define PCI_VENDOR_ID_HXT		0x1dbf


