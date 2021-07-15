Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 20EA63CAA53
	for <lists+stable@lfdr.de>; Thu, 15 Jul 2021 21:11:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240459AbhGOTMy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 15 Jul 2021 15:12:54 -0400
Received: from mail.kernel.org ([198.145.29.99]:45628 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S243914AbhGOTKO (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 15 Jul 2021 15:10:14 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1CA46613C0;
        Thu, 15 Jul 2021 19:07:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626376033;
        bh=EqQNBl3CNqqZRBiml33T3vY8ViHrVfDUbE1/Zsy0Ars=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=O9XV9gK71EyKDOJzZW3m8FJ++UQrdgvM7HIUSOwyStLW1ssE+BQ6plWm8hvSlYdZB
         wTAgYtJ6zZm6vYiQKiqTQE5ncAEhxVp738bCaZQMwAlj0gM7fyOj/kaatfIEH36apy
         OZKsUwxXrmVuLQmamsZLV+uqGcJ0uXs8q9fuNmts=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Lijun Pan <lijunp213@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.13 098/266] ibmvnic: fix kernel build warnings in build_hdr_descs_arr
Date:   Thu, 15 Jul 2021 20:37:33 +0200
Message-Id: <20210715182631.364601240@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210715182613.933608881@linuxfoundation.org>
References: <20210715182613.933608881@linuxfoundation.org>
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
index ede65b32f821..efc98903c0b7 100644
--- a/drivers/net/ethernet/ibm/ibmvnic.c
+++ b/drivers/net/ethernet/ibm/ibmvnic.c
@@ -1554,7 +1554,8 @@ static int create_hdr_descs(u8 hdr_field, u8 *hdr_data, int len, int *hdr_len,
 
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



