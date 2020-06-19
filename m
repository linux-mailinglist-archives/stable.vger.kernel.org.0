Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 62E2A2014E1
	for <lists+stable@lfdr.de>; Fri, 19 Jun 2020 18:21:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391045AbgFSPDn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 19 Jun 2020 11:03:43 -0400
Received: from mail.kernel.org ([198.145.29.99]:60496 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2391041AbgFSPDm (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 19 Jun 2020 11:03:42 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 97AC42193E;
        Fri, 19 Jun 2020 15:03:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592579023;
        bh=jL57LjiGswb6H7HnMJrD39KF0xhoV9ZcfKG7asJMdfA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=oIkND0hlnMsfjm7kPth2Z8U5reIbREm0hNZC/REDQQ/5KiwGPxwArl71ubCV+72RM
         d5cZHRkYsQVTTwf6CnvZNMRClpklIqBD4fvqhQDqZKYPtfm8kSDBLtkpmVZhT9W+3+
         LctTHdK2dwgY/RC7yFalTBUj862TY5FzTdtjnEpI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Ben Chuang <ben.chuang@genesyslogic.com.tw>,
        Michael K Johnson <johnsonm@danlj.org>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Ulf Hansson <ulf.hansson@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 219/267] PCI: Add Genesys Logic, Inc. Vendor ID
Date:   Fri, 19 Jun 2020 16:33:24 +0200
Message-Id: <20200619141659.226560568@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200619141648.840376470@linuxfoundation.org>
References: <20200619141648.840376470@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ben Chuang <ben.chuang@genesyslogic.com.tw>

[ Upstream commit 4460d68f0b2f9092273531fbc65613e1855c2e07 ]

Add the Genesys Logic, Inc. vendor ID to pci_ids.h.

Signed-off-by: Ben Chuang <ben.chuang@genesyslogic.com.tw>
Co-developed-by: Michael K Johnson <johnsonm@danlj.org>
Signed-off-by: Michael K Johnson <johnsonm@danlj.org>
Acked-by: Adrian Hunter <adrian.hunter@intel.com>
Signed-off-by: Ulf Hansson <ulf.hansson@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/pci_ids.h | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/include/linux/pci_ids.h b/include/linux/pci_ids.h
index bd682fcb9768..3329387261df 100644
--- a/include/linux/pci_ids.h
+++ b/include/linux/pci_ids.h
@@ -2409,6 +2409,8 @@
 #define PCI_DEVICE_ID_RDC_R6061		0x6061
 #define PCI_DEVICE_ID_RDC_D1010		0x1010
 
+#define PCI_VENDOR_ID_GLI		0x17a0
+
 #define PCI_VENDOR_ID_LENOVO		0x17aa
 
 #define PCI_VENDOR_ID_QCOM		0x17cb
-- 
2.25.1



