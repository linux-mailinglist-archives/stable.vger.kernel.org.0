Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 13C3215787F
	for <lists+stable@lfdr.de>; Mon, 10 Feb 2020 14:08:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729424AbgBJMja (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 Feb 2020 07:39:30 -0500
Received: from mail.kernel.org ([198.145.29.99]:37324 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729004AbgBJMj3 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 10 Feb 2020 07:39:29 -0500
Received: from localhost (unknown [209.37.97.194])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1898420838;
        Mon, 10 Feb 2020 12:39:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1581338369;
        bh=m0L9b/qmqflIdZ3pPSM1fXSOfPRP6K0tcqrkvc8V284=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=O/QZIFHVXtmDl0GymjFNDhzAcO/IZdRscgQy4CCVRAtDtnqW0QxaNeciBEHGW7Sfr
         hBUCQSFDooxL8MBYOYD4RHVWzTur1OSkHj/DQUgDfu+R1qUkKwEwfjP6xy0qHgorwr
         x0g2CvHxVcwXPEEzjoyc47wz/mSPz2wh0mJYN/Dg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Israel Rukshin <israelr@mellanox.com>,
        Max Gurtovoy <maxg@mellanox.com>,
        Christoph Hellwig <hch@lst.de>, Keith Busch <kbusch@kernel.org>
Subject: [PATCH 5.5 038/367] nvmet: Fix error print message at nvmet_install_queue function
Date:   Mon, 10 Feb 2020 04:29:11 -0800
Message-Id: <20200210122427.505896558@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200210122423.695146547@linuxfoundation.org>
References: <20200210122423.695146547@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Israel Rukshin <israelr@mellanox.com>

commit 0b87a2b795d66be7b54779848ef0f3901c5e46fc upstream.

Place the arguments in the correct order.

Fixes: 1672ddb8d691 ("nvmet: Add install_queue callout")
Signed-off-by: Israel Rukshin <israelr@mellanox.com>
Reviewed-by: Max Gurtovoy <maxg@mellanox.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Keith Busch <kbusch@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/nvme/target/fabrics-cmd.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/nvme/target/fabrics-cmd.c
+++ b/drivers/nvme/target/fabrics-cmd.c
@@ -136,7 +136,7 @@ static u16 nvmet_install_queue(struct nv
 
 		if (ret) {
 			pr_err("failed to install queue %d cntlid %d ret %x\n",
-				qid, ret, ctrl->cntlid);
+				qid, ctrl->cntlid, ret);
 			return ret;
 		}
 	}


