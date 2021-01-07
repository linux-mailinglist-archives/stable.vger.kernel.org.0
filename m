Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 647092ED249
	for <lists+stable@lfdr.de>; Thu,  7 Jan 2021 15:32:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729267AbhAGOcb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 7 Jan 2021 09:32:31 -0500
Received: from mail.kernel.org ([198.145.29.99]:46548 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728902AbhAGOca (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 7 Jan 2021 09:32:30 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1133C23356;
        Thu,  7 Jan 2021 14:31:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1610029900;
        bh=IStDZx0Whs4SNoEeR0gXBadLClxAGzhGwPQOlg1kl7w=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Ds6zYSWNWHJtf5gNOb5GvLrWQCMJlj0JRRWKZJRS7QPvqO6mfea3KxTM0r2r82f6O
         OsTLwITbJ9iwQEf7uiVJmGSukzTRIbG6xcPR0bOKvBgwDXRZDUleCkm7sesne+KLlj
         2rl6D1QdYgYEeIoLJMXD0mljEfPZ9iSjpQoTF3qY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Tudor Ambarus <tudor.ambarus@microchip.com>,
        Ludovic Desroches <ludovic.desroches@microchip.com>,
        Vinod Koul <vkoul@kernel.org>
Subject: [PATCH 4.19 2/8] dmaengine: at_hdmac: Substitute kzalloc with kmalloc
Date:   Thu,  7 Jan 2021 15:32:02 +0100
Message-Id: <20210107143047.875889703@linuxfoundation.org>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210107143047.586006010@linuxfoundation.org>
References: <20210107143047.586006010@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Tudor Ambarus <tudor.ambarus@microchip.com>

commit a6e7f19c910068cb54983f36acebedb376f3a9ac upstream.

All members of the structure are initialized below in the function,
there is no need to use kzalloc.

Signed-off-by: Tudor Ambarus <tudor.ambarus@microchip.com>
Acked-by: Ludovic Desroches <ludovic.desroches@microchip.com>
Link: https://lore.kernel.org/r/20200123140237.125799-1-tudor.ambarus@microchip.com
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/dma/at_hdmac.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/dma/at_hdmac.c
+++ b/drivers/dma/at_hdmac.c
@@ -1683,7 +1683,7 @@ static struct dma_chan *at_dma_xlate(str
 	dma_cap_zero(mask);
 	dma_cap_set(DMA_SLAVE, mask);
 
-	atslave = kzalloc(sizeof(*atslave), GFP_KERNEL);
+	atslave = kmalloc(sizeof(*atslave), GFP_KERNEL);
 	if (!atslave)
 		return NULL;
 


