Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B90D9145165
	for <lists+stable@lfdr.de>; Wed, 22 Jan 2020 10:53:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730263AbgAVJei (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 22 Jan 2020 04:34:38 -0500
Received: from mail.kernel.org ([198.145.29.99]:49136 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730950AbgAVJef (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 22 Jan 2020 04:34:35 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id DC8D724673;
        Wed, 22 Jan 2020 09:34:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579685675;
        bh=SsX/k2xeN4IXLK0x1RYt3G4o6ggs1tN8WKdreVTRxjQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=f9E9MszPubYpNkoMcVlGM04r2IIs/3EwLSV7shH8ez7Uw98we93L0Iet8Plu/Qk6o
         D59zoPGI1VUVtJXAwZ7/fJONWCSeexyuqU+SLzss5JgZAJ1dAZ6wByQJJ8ga6+4Nzw
         I7nP0tke0OkwRJAQbU+6+oeZkqUE++z+MQBTsBDY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Bjorn Helgaas <bhelgaas@google.com>,
        Andrew Murray <andrew.murray@arm.com>,
        Jonathan Yong <jonathan.yong@intel.com>
Subject: [PATCH 4.9 33/97] PCI/PTM: Remove spurious "d" from granularity message
Date:   Wed, 22 Jan 2020 10:28:37 +0100
Message-Id: <20200122092801.787833358@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200122092755.678349497@linuxfoundation.org>
References: <20200122092755.678349497@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Bjorn Helgaas <bhelgaas@google.com>

commit 127a7709495db52a41012deaebbb7afc231dad91 upstream.

The granularity message has an extra "d":

  pci 0000:02:00.0: PTM enabled, 4dns granularity

Remove the "d" so the message is simply "PTM enabled, 4ns granularity".

Fixes: 8b2ec318eece ("PCI: Add PTM clock granularity information")
Link: https://lore.kernel.org/r/20191106222420.10216-2-helgaas@kernel.org
Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
Reviewed-by: Andrew Murray <andrew.murray@arm.com>
Cc: Jonathan Yong <jonathan.yong@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/pci/pcie/ptm.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/pci/pcie/ptm.c
+++ b/drivers/pci/pcie/ptm.c
@@ -29,7 +29,7 @@ static void pci_ptm_info(struct pci_dev
 		snprintf(clock_desc, sizeof(clock_desc), ">254ns");
 		break;
 	default:
-		snprintf(clock_desc, sizeof(clock_desc), "%udns",
+		snprintf(clock_desc, sizeof(clock_desc), "%uns",
 			 dev->ptm_granularity);
 		break;
 	}


