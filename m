Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A8D802891A
	for <lists+stable@lfdr.de>; Thu, 23 May 2019 21:42:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392186AbfEWTas (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 23 May 2019 15:30:48 -0400
Received: from mail.kernel.org ([198.145.29.99]:44402 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2392184AbfEWTas (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 23 May 2019 15:30:48 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2E462217D7;
        Thu, 23 May 2019 19:30:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1558639847;
        bh=ld43xxN+ALfqwSMcS5c7IYDBke35KTl7y2i8iFVunyg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ud5wjYWDihcYpOFlIB8lHrmVnKnslCa2qvbC/9FPY+pxuONox2AeCXKDA4Z/lpycZ
         tDEsCfawcLt1CWcUPFDW4i4Dh+i47ldjq8iN8VBNLVTTj6sDV2bJdyhUBsncmFR/ad
         zol1LbPhBntxrcesVo7G7VQU9xXzUK8ksowhGX2E=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Jisheng Zhang <Jisheng.Zhang@synaptics.com>,
        Bjorn Helgaas <bhelgaas@google.com>
Subject: [PATCH 5.1 098/122] PCI/AER: Change pci_aer_init() stub to return void
Date:   Thu, 23 May 2019 21:07:00 +0200
Message-Id: <20190523181718.195270718@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190523181705.091418060@linuxfoundation.org>
References: <20190523181705.091418060@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jisheng Zhang <Jisheng.Zhang@synaptics.com>

commit 31f996efbd5a7825f4d30150469e9d110aea00e8 upstream.

Commit 60ed982a4e78 ("PCI/AER: Move internal declarations to
drivers/pci/pci.h") changed pci_aer_init() to return "void", but didn't
change the stub for when CONFIG_PCIEAER isn't enabled.  Change the stub to
match.

Fixes: 60ed982a4e78 ("PCI/AER: Move internal declarations to drivers/pci/pci.h")
Signed-off-by: Jisheng Zhang <Jisheng.Zhang@synaptics.com>
Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
CC: stable@vger.kernel.org	# v4.19+
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/pci/pci.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/pci/pci.h
+++ b/drivers/pci/pci.h
@@ -597,7 +597,7 @@ void pci_aer_clear_fatal_status(struct p
 void pci_aer_clear_device_status(struct pci_dev *dev);
 #else
 static inline void pci_no_aer(void) { }
-static inline int pci_aer_init(struct pci_dev *d) { return -ENODEV; }
+static inline void pci_aer_init(struct pci_dev *d) { }
 static inline void pci_aer_exit(struct pci_dev *d) { }
 static inline void pci_aer_clear_fatal_status(struct pci_dev *dev) { }
 static inline void pci_aer_clear_device_status(struct pci_dev *dev) { }


