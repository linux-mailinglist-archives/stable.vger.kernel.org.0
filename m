Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D4C76406B92
	for <lists+stable@lfdr.de>; Fri, 10 Sep 2021 14:41:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233389AbhIJMcl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 10 Sep 2021 08:32:41 -0400
Received: from mail.kernel.org ([198.145.29.99]:49964 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233321AbhIJMch (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 10 Sep 2021 08:32:37 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 209B7611C8;
        Fri, 10 Sep 2021 12:31:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1631277086;
        bh=UFPg6g8EZ67ThjPvwToE4GQwtABdHpwXOQSFTDPLs5g=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=psaOW3JDTX8YkrLTWUua26OlWY1KkPNT7ZbvRKAz8M3Rzv7n7O+KqY2gsKoXXjIDV
         EK0vk3V6ayknCobgkgmOKBNTQ8sziqS/KLr8imvDIoAhWEuxBp2bsiH1bHcvp+Simj
         uCCvZQ+xiKv+U88aZN9hlCt47cRc+6voYSPogcME=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        "Li Qiang (Johnny Li)" <johnny.li@montage-tech.com>,
        Jonathan Cameron <Jonathan.Cameron@huawei.com>,
        Dan Williams <dan.j.williams@intel.com>
Subject: [PATCH 5.14 21/23] cxl/pci: Fix debug message in cxl_probe_regs()
Date:   Fri, 10 Sep 2021 14:30:11 +0200
Message-Id: <20210910122916.678625088@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210910122916.022815161@linuxfoundation.org>
References: <20210910122916.022815161@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Li Qiang (Johnny Li) <johnny.li@montage-tech.com>

commit da582aa5ad5787c46e3f475ab3f4602ec84c1617 upstream.

Indicator string for mbox and memdev register set to status
incorrectly in error message.

Cc: <stable@vger.kernel.org>
Fixes: 30af97296f48 ("cxl/pci: Map registers based on capabilities")
Signed-off-by: Li Qiang (Johnny Li) <johnny.li@montage-tech.com>
Reviewed-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Link: https://lore.kernel.org/r/163072205089.2250120.8103605864156687395.stgit@dwillia2-desk3.amr.corp.intel.com
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/cxl/pci.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/cxl/pci.c
+++ b/drivers/cxl/pci.c
@@ -1022,8 +1022,8 @@ static int cxl_probe_regs(struct cxl_mem
 		    !dev_map->memdev.valid) {
 			dev_err(dev, "registers not found: %s%s%s\n",
 				!dev_map->status.valid ? "status " : "",
-				!dev_map->mbox.valid ? "status " : "",
-				!dev_map->memdev.valid ? "status " : "");
+				!dev_map->mbox.valid ? "mbox " : "",
+				!dev_map->memdev.valid ? "memdev " : "");
 			return -ENXIO;
 		}
 


