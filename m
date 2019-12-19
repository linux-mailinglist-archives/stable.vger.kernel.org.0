Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5EC9012696A
	for <lists+stable@lfdr.de>; Thu, 19 Dec 2019 19:37:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727822AbfLSShZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 19 Dec 2019 13:37:25 -0500
Received: from mail.kernel.org ([198.145.29.99]:55010 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727818AbfLSShZ (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 19 Dec 2019 13:37:25 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2A21D2467F;
        Thu, 19 Dec 2019 18:37:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1576780644;
        bh=ScASG/VjKteCyDiSyPA9ri5oFWrggjTwuysKo02NQB0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=NDqbVa2qaxiUwYX5KQoCrO0WB7kWL8KoseHcMJ9lRGgOuUJ8hKCejPafx/pkT0AyK
         QrFHWxGWJMVgibKC80HHzARf024Rp73/Grok57Hzb+RqWHf1GkGVRtLWYaVK3ZWyNC
         vjwC+hirqfI5g3dWQO7PMVtEUqjM/n9plOuF0rQ4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Stephen Rothwell <sfr@canb.auug.org.au>,
        Vinod Koul <vkoul@kernel.org>
Subject: [PATCH 4.4 031/162] dmaengine: coh901318: Remove unused variable
Date:   Thu, 19 Dec 2019 19:32:19 +0100
Message-Id: <20191219183209.593181643@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20191219183150.477687052@linuxfoundation.org>
References: <20191219183150.477687052@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Vinod Koul <vkoul@kernel.org>

commit 35faaf0df42d285b40f8a6310afbe096720f7758 upstream.

Commit 627469e4445b ("dmaengine: coh901318: Fix a double-lock bug") left
flags variable unused, so remove it to fix the warning.

drivers/dma/coh901318.c: In function 'coh901318_config':
drivers/dma/coh901318.c:1805:16: warning: unused variable 'flags' [-Wunused-variable]
  unsigned long flags;
                ^~~~~

Fixes: 627469e4445b ("dmaengine: coh901318: Fix a double-lock bug")
Reported-By: Stephen Rothwell <sfr@canb.auug.org.au>
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/dma/coh901318.c |    1 -
 1 file changed, 1 deletion(-)

--- a/drivers/dma/coh901318.c
+++ b/drivers/dma/coh901318.c
@@ -1810,7 +1810,6 @@ static struct dma_chan *coh901318_xlate(
 static int coh901318_config(struct coh901318_chan *cohc,
 			    struct coh901318_params *param)
 {
-	unsigned long flags;
 	const struct coh901318_params *p;
 	int channel = cohc->id;
 	void __iomem *virtbase = cohc->base->virtbase;


