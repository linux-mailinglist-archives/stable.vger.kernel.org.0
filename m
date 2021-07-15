Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 767273CA8A7
	for <lists+stable@lfdr.de>; Thu, 15 Jul 2021 21:00:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242651AbhGOTCI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 15 Jul 2021 15:02:08 -0400
Received: from mail.kernel.org ([198.145.29.99]:35104 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S242840AbhGOTAC (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 15 Jul 2021 15:00:02 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4DECB613CC;
        Thu, 15 Jul 2021 18:57:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626375428;
        bh=Epu5Df6xEQfp3jQIPeK2nKJRr9rVgUOibI+mTwuHG74=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=yvA2mQMXJFSCx+4jlJfviooPImb7/M1mM5fw0a6goOX2q1VwuebEDOVtdQy1h08KT
         Bcrcc+yz0+tL/jZlRr4KF8JOhYfhYI0Prm1PbRMvvhc01am9UFo49hyHxR3/a4zBIW
         JE8kVGmuQ80+Vt8HE7NbqJY3r3rUf57B5LxXx9ns=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Lijun Pan <lijunp213@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.12 084/242] ibmvnic: fix kernel build warnings in build_hdr_descs_arr
Date:   Thu, 15 Jul 2021 20:37:26 +0200
Message-Id: <20210715182607.822210170@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210715182551.731989182@linuxfoundation.org>
References: <20210715182551.731989182@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Lijun Pan <lijunp213@gmail.com>

[ Upstream commit 73214a690c50a134bd364e1a4430e0e7ac81a8d8 ]

Fix the following kernel build warnings:
drivers/net/ethernet/ibm/ibmvnic.c:1516: warning: Function parameter or member 'skb' not described in 'build_hdr_descs_arr'
drivers/net/ethernet/ibm/ibmvnic.c:1516: warning: Function parameter or member 'indir_arr' not described in 'build_hdr_descs_arr'
drivers/net/ethernet/ibm/ibmvnic.c:1516: warning: Excess function parameter 'txbuff' description in 'build_hdr_descs_arr'

Signed-off-by: Lijun Pan <lijunp213@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/ibm/ibmvnic.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/ibm/ibmvnic.c b/drivers/net/ethernet/ibm/ibmvnic.c
index 3c77897b3f31..df10b87ca0f8 100644
--- a/drivers/net/ethernet/ibm/ibmvnic.c
+++ b/drivers/net/ethernet/ibm/ibmvnic.c
@@ -1528,7 +1528,8 @@ static int create_hdr_descs(u8 hdr_field, u8 *hdr_data, int len, int *hdr_len,
 
 /**
  * build_hdr_descs_arr - build a header descriptor array
- * @txbuff: tx buffer
+ * @skb: tx socket buffer
+ * @indir_arr: indirect array
  * @num_entries: number of descriptors to be sent
  * @hdr_field: bit field determining which headers will be sent
  *
-- 
2.30.2



