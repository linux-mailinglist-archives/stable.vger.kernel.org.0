Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D0E7C1C146F
	for <lists+stable@lfdr.de>; Fri,  1 May 2020 15:45:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731175AbgEANjW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 1 May 2020 09:39:22 -0400
Received: from mail.kernel.org ([198.145.29.99]:39046 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730865AbgEANjV (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 1 May 2020 09:39:21 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E770020757;
        Fri,  1 May 2020 13:39:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1588340361;
        bh=Pkpbdoe5bkkyKmNm0KMLHp0fuCNDJy+0OyX6Yx0cOGI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=pzQ8o+4/0oxpfoI3v/TqKmQYv+crHWTnJ8MrjVbrWwT25cEnFXcBqWppzqCp0uMyK
         fQ2wDs4zhF7zbChWBjhscQYegQmMoDhN9PjSX0UdUm1vctQB0kW/mt+qQ9EtKhwvtZ
         viwMeEuD7q+q7IEX4wBo3wsN4GlAlg4EyIM6tVQE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Raymond Pang <RaymondPang-oc@zhaoxin.com>,
        Bjorn Helgaas <bhelgaas@google.com>
Subject: [PATCH 5.4 34/83] PCI: Add Zhaoxin Vendor ID
Date:   Fri,  1 May 2020 15:23:13 +0200
Message-Id: <20200501131532.673294661@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200501131524.004332640@linuxfoundation.org>
References: <20200501131524.004332640@linuxfoundation.org>
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
@@ -2582,6 +2582,8 @@
 
 #define PCI_VENDOR_ID_AMAZON		0x1d0f
 
+#define PCI_VENDOR_ID_ZHAOXIN		0x1d17
+
 #define PCI_VENDOR_ID_HYGON		0x1d94
 
 #define PCI_VENDOR_ID_HXT		0x1dbf


