Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 47EC113FDCF
	for <lists+stable@lfdr.de>; Fri, 17 Jan 2020 00:30:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391297AbgAPX3e (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Jan 2020 18:29:34 -0500
Received: from mail.kernel.org ([198.145.29.99]:35288 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2391266AbgAPX3d (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 Jan 2020 18:29:33 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2B5A52072E;
        Thu, 16 Jan 2020 23:29:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579217371;
        bh=prQ0q8gvC79NNbn3+0ntZWUuhxJax8zUKx2jk+josZQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=LQuEJ69zGQQRfCgGhFb71LvejpxQj5CucYwLS7KVPL4qvGmVXTmm2xBCHAOMsaBbN
         m4hH7PbBageI/m44KCn2a6BD3mZK5mU34Y85ep5vIKVhEzZfz+T9aExf+u4ViX+JFN
         ooARh2m7KVTvzJnW9ehtxhuMuACa9/6SCvhxlUsc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Bjorn Helgaas <bhelgaas@google.com>,
        Andrew Murray <andrew.murray@arm.com>,
        Jonathan Yong <jonathan.yong@intel.com>
Subject: [PATCH 4.19 55/84] PCI/PTM: Remove spurious "d" from granularity message
Date:   Fri, 17 Jan 2020 00:18:29 +0100
Message-Id: <20200116231720.275767106@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200116231713.087649517@linuxfoundation.org>
References: <20200116231713.087649517@linuxfoundation.org>
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
@@ -21,7 +21,7 @@ static void pci_ptm_info(struct pci_dev
 		snprintf(clock_desc, sizeof(clock_desc), ">254ns");
 		break;
 	default:
-		snprintf(clock_desc, sizeof(clock_desc), "%udns",
+		snprintf(clock_desc, sizeof(clock_desc), "%uns",
 			 dev->ptm_granularity);
 		break;
 	}


