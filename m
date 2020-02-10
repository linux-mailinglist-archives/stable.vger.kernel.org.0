Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3E021157AE1
	for <lists+stable@lfdr.de>; Mon, 10 Feb 2020 14:26:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728887AbgBJNZ6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 Feb 2020 08:25:58 -0500
Received: from mail.kernel.org ([198.145.29.99]:57106 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728536AbgBJMgu (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 10 Feb 2020 07:36:50 -0500
Received: from localhost (unknown [209.37.97.194])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C93C924649;
        Mon, 10 Feb 2020 12:36:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1581338209;
        bh=4ZvtdWXt8ILhmlZ1K0mOPyL+G3mcDfkBS6LGeAH6atY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=gdy3Wq5B6EBNJp92jO7Vv40Si9BCnTSW8dM1G4lMSB3a40cuHZSjE019bf5Dp5HAl
         zV1BP2P57mqmLA4fhADjRcrtOHe1w7Er3e7SpTEHPbekufeMWaS5rO9dbqNJvyrK46
         W2uGGY6JTLPMT/zwEMpL8l1PJmZmLLX519t9Bb4k=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Israel Rukshin <israelr@mellanox.com>,
        Max Gurtovoy <maxg@mellanox.com>,
        Christoph Hellwig <hch@lst.de>, Keith Busch <kbusch@kernel.org>
Subject: [PATCH 5.4 032/309] nvmet: Fix error print message at nvmet_install_queue function
Date:   Mon, 10 Feb 2020 04:29:48 -0800
Message-Id: <20200210122409.159491617@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200210122406.106356946@linuxfoundation.org>
References: <20200210122406.106356946@linuxfoundation.org>
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
@@ -132,7 +132,7 @@ static u16 nvmet_install_queue(struct nv
 
 		if (ret) {
 			pr_err("failed to install queue %d cntlid %d ret %x\n",
-				qid, ret, ctrl->cntlid);
+				qid, ctrl->cntlid, ret);
 			return ret;
 		}
 	}


