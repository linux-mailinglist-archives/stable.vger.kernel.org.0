Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D290D51A6D7
	for <lists+stable@lfdr.de>; Wed,  4 May 2022 18:57:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354568AbiEDRAu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 4 May 2022 13:00:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37694 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1355612AbiEDRAS (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 4 May 2022 13:00:18 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9E00D4B437;
        Wed,  4 May 2022 09:51:55 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B25C661794;
        Wed,  4 May 2022 16:51:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F36B1C385A4;
        Wed,  4 May 2022 16:51:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1651683100;
        bh=bgToEcgNzqSGduzPEvX5C+xMWm9pac0XloT9o040au0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Cba9Obf/3bVh9UzdWeR629wbEQWEbeFbk4NDzG70UybFqBcWYUy0XjDzvE+O4dBSe
         ubeonkjrmkJa88DDGoV8UOF5wZ1Gpx3jeSdmAZQKFdP1U7SrF7QDghtL/lzRx2w4U7
         04BM9GkLoqOonMVznUMF86on/iLazjKtectjVp+A=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Lijun Pan <lijunp213@gmail.com>,
        Saeed Mahameed <saeedm@nvidia.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 096/129] ibmvnic: fix miscellaneous checks
Date:   Wed,  4 May 2022 18:44:48 +0200
Message-Id: <20220504153028.558964269@linuxfoundation.org>
X-Mailer: git-send-email 2.36.0
In-Reply-To: <20220504153021.299025455@linuxfoundation.org>
References: <20220504153021.299025455@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Lijun Pan <lijunp213@gmail.com>

[ Upstream commit 91dc5d2553fbf20e2e8384ac997f278a50c70561 ]

Fix the following checkpatch checks:
CHECK: Macro argument 'off' may be better as '(off)' to
avoid precedence issues
CHECK: Alignment should match open parenthesis
CHECK: multiple assignments should be avoided
CHECK: Blank lines aren't necessary before a close brace '}'
CHECK: Please use a blank line after function/struct/union/enum
declarations
CHECK: Unnecessary parentheses around 'rc != H_FUNCTION'

Signed-off-by: Lijun Pan <lijunp213@gmail.com>
Reviewed-by: Saeed Mahameed <saeedm@nvidia.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/ibm/ibmvnic.c | 17 +++++++++--------
 1 file changed, 9 insertions(+), 8 deletions(-)

diff --git a/drivers/net/ethernet/ibm/ibmvnic.c b/drivers/net/ethernet/ibm/ibmvnic.c
index 95bee3d91593..2cd849215913 100644
--- a/drivers/net/ethernet/ibm/ibmvnic.c
+++ b/drivers/net/ethernet/ibm/ibmvnic.c
@@ -117,7 +117,7 @@ struct ibmvnic_stat {
 
 #define IBMVNIC_STAT_OFF(stat) (offsetof(struct ibmvnic_adapter, stats) + \
 			     offsetof(struct ibmvnic_statistics, stat))
-#define IBMVNIC_GET_STAT(a, off) (*((u64 *)(((unsigned long)(a)) + off)))
+#define IBMVNIC_GET_STAT(a, off) (*((u64 *)(((unsigned long)(a)) + (off))))
 
 static const struct ibmvnic_stat ibmvnic_stats[] = {
 	{"rx_packets", IBMVNIC_STAT_OFF(rx_packets)},
@@ -2063,14 +2063,14 @@ static int do_reset(struct ibmvnic_adapter *adapter,
 			rc = reset_tx_pools(adapter);
 			if (rc) {
 				netdev_dbg(adapter->netdev, "reset tx pools failed (%d)\n",
-						rc);
+					   rc);
 				goto out;
 			}
 
 			rc = reset_rx_pools(adapter);
 			if (rc) {
 				netdev_dbg(adapter->netdev, "reset rx pools failed (%d)\n",
-						rc);
+					   rc);
 				goto out;
 			}
 		}
@@ -2331,7 +2331,8 @@ static int ibmvnic_reset(struct ibmvnic_adapter *adapter,
 
 	if (adapter->state == VNIC_PROBING) {
 		netdev_warn(netdev, "Adapter reset during probe\n");
-		ret = adapter->init_done_rc = EAGAIN;
+		adapter->init_done_rc = EAGAIN;
+		ret = EAGAIN;
 		goto err;
 	}
 
@@ -2744,7 +2745,6 @@ static int ibmvnic_set_channels(struct net_device *netdev,
 			    channels->rx_count, channels->tx_count,
 			    adapter->req_rx_queues, adapter->req_tx_queues);
 	return ret;
-
 }
 
 static void ibmvnic_get_strings(struct net_device *dev, u32 stringset, u8 *data)
@@ -2833,8 +2833,8 @@ static void ibmvnic_get_ethtool_stats(struct net_device *dev,
 		return;
 
 	for (i = 0; i < ARRAY_SIZE(ibmvnic_stats); i++)
-		data[i] = be64_to_cpu(IBMVNIC_GET_STAT(adapter,
-						ibmvnic_stats[i].offset));
+		data[i] = be64_to_cpu(IBMVNIC_GET_STAT
+				      (adapter, ibmvnic_stats[i].offset));
 
 	for (j = 0; j < adapter->req_tx_queues; j++) {
 		data[i] = adapter->tx_stats_buffers[j].packets;
@@ -2874,6 +2874,7 @@ static int ibmvnic_set_priv_flags(struct net_device *netdev, u32 flags)
 
 	return 0;
 }
+
 static const struct ethtool_ops ibmvnic_ethtool_ops = {
 	.get_drvinfo		= ibmvnic_get_drvinfo,
 	.get_msglevel		= ibmvnic_get_msglevel,
@@ -3119,7 +3120,7 @@ static int enable_scrq_irq(struct ibmvnic_adapter *adapter,
 		/* H_EOI would fail with rc = H_FUNCTION when running
 		 * in XIVE mode which is expected, but not an error.
 		 */
-		if (rc && (rc != H_FUNCTION))
+		if (rc && rc != H_FUNCTION)
 			dev_err(dev, "H_EOI FAILED irq 0x%llx. rc=%ld\n",
 				val, rc);
 	}
-- 
2.35.1



