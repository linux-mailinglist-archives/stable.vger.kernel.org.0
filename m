Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 25CEF4512D1
	for <lists+stable@lfdr.de>; Mon, 15 Nov 2021 20:41:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347457AbhKOTjy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Nov 2021 14:39:54 -0500
Received: from mail.kernel.org ([198.145.29.99]:44642 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S245063AbhKOTTI (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Nov 2021 14:19:08 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8D4B4634FF;
        Mon, 15 Nov 2021 18:27:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1637000872;
        bh=JhA5kIFdh1rFkY7tHxTWH7qcNVtn0gR0p3Xj6C8YNQY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=aYHCLKI/S/tHK0Ra/6j7w7EpmBJa/yxu9r1gZ//QRSThsc2dVxXYxBY0MxH8abQ7H
         9ycMH1eC0ACaH3LtvEwyrc0dfuiWkF5IZATBnNT3QITSrvpRZfi6LRN541nPqheA6G
         am5yKvj67Tyu9OwDcwKLEMwJpfbFlUSMbnUPQ2SU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Mathieu Poirier <mathieu.poirier@linaro.org>,
        Dong Aisheng <aisheng.dong@nxp.com>,
        Peng Fan <peng.fan@nxp.com>
Subject: [PATCH 5.14 825/849] remoteproc: imx_rproc: Fix rsc-table name
Date:   Mon, 15 Nov 2021 18:05:08 +0100
Message-Id: <20211115165448.143005053@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211115165419.961798833@linuxfoundation.org>
References: <20211115165419.961798833@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dong Aisheng <aisheng.dong@nxp.com>

commit e90547d59d4e29e269e22aa6ce590ed0b41207d2 upstream.

Usually the dash '-'  is preferred in node name.
So far, not dts in upstream kernel, so we just update node name
in driver.

Cc: Bjorn Andersson <bjorn.andersson@linaro.org>
Cc: Mathieu Poirier <mathieu.poirier@linaro.org>
Fixes: 5e4c1243071d ("remoteproc: imx_rproc: support remote cores booted before Linux Kernel")
Reviewed-and-tested-by: Peng Fan <peng.fan@nxp.com>
Signed-off-by: Dong Aisheng <aisheng.dong@nxp.com>
Signed-off-by: Peng Fan <peng.fan@nxp.com>
Cc: stable <stable@vger.kernel.org>
Link: https://lore.kernel.org/r/20210910090621.3073540-6-peng.fan@oss.nxp.com
Signed-off-by: Mathieu Poirier <mathieu.poirier@linaro.org>
Signed-off-by: Bjorn Andersson <bjorn.andersson@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/remoteproc/imx_rproc.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/remoteproc/imx_rproc.c
+++ b/drivers/remoteproc/imx_rproc.c
@@ -604,7 +604,7 @@ static int imx_rproc_addr_init(struct im
 		}
 		priv->mem[b].sys_addr = res.start;
 		priv->mem[b].size = resource_size(&res);
-		if (!strcmp(node->name, "rsc_table"))
+		if (!strcmp(node->name, "rsc-table"))
 			priv->rsc_table = priv->mem[b].cpu_addr;
 		b++;
 	}


