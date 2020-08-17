Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4A77C247693
	for <lists+stable@lfdr.de>; Mon, 17 Aug 2020 21:39:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732491AbgHQTjK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 Aug 2020 15:39:10 -0400
Received: from mail.kernel.org ([198.145.29.99]:35680 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729547AbgHQP0i (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 17 Aug 2020 11:26:38 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1273923A9A;
        Mon, 17 Aug 2020 15:26:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597677997;
        bh=UZUBwEF4e/RfXG5mcWp5oc22U3LXwLC+GXqXMZIrbZY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=MB03q+OSxKLUuDqCjf7g1kaYbmQvpg+ZUPEs+Jo62TOL9oluR3QPv91TWA7NpcVTZ
         tFnnPXXqgxXmO/mG4Renhm1tEbgrQvaFQE+ACJpifuJq6Xelg24jazOGjzPdwpGDYL
         O+zqutCLqPpfYgARLKUMpwgz/8zyjnSfsZtRgc6A=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Mark Starovoytov <mstarovoitov@marvell.com>,
        Igor Russkikh <irusskikh@marvell.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.8 182/464] net: atlantic: MACSec offload statistics checkpatch fix
Date:   Mon, 17 Aug 2020 17:12:15 +0200
Message-Id: <20200817143842.535570375@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200817143833.737102804@linuxfoundation.org>
References: <20200817143833.737102804@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Mark Starovoytov <mstarovoitov@marvell.com>

[ Upstream commit 3a8b44546979cf682324bd2fd61e539f428911b4 ]

This patch fixes a checkpatch warning.

Fixes: aec0f1aac58e ("net: atlantic: MACSec offload statistics implementation")

Signed-off-by: Mark Starovoytov <mstarovoitov@marvell.com>
Signed-off-by: Igor Russkikh <irusskikh@marvell.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/aquantia/atlantic/aq_ethtool.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/aquantia/atlantic/aq_ethtool.c b/drivers/net/ethernet/aquantia/atlantic/aq_ethtool.c
index 743d3b13b39d7..bb1fc6052bcf1 100644
--- a/drivers/net/ethernet/aquantia/atlantic/aq_ethtool.c
+++ b/drivers/net/ethernet/aquantia/atlantic/aq_ethtool.c
@@ -123,21 +123,21 @@ static const char aq_macsec_stat_names[][ETH_GSTRING_LEN] = {
 	"MACSec OutUnctrlHitDropRedir",
 };
 
-static const char *aq_macsec_txsc_stat_names[] = {
+static const char * const aq_macsec_txsc_stat_names[] = {
 	"MACSecTXSC%d ProtectedPkts",
 	"MACSecTXSC%d EncryptedPkts",
 	"MACSecTXSC%d ProtectedOctets",
 	"MACSecTXSC%d EncryptedOctets",
 };
 
-static const char *aq_macsec_txsa_stat_names[] = {
+static const char * const aq_macsec_txsa_stat_names[] = {
 	"MACSecTXSC%dSA%d HitDropRedirect",
 	"MACSecTXSC%dSA%d Protected2Pkts",
 	"MACSecTXSC%dSA%d ProtectedPkts",
 	"MACSecTXSC%dSA%d EncryptedPkts",
 };
 
-static const char *aq_macsec_rxsa_stat_names[] = {
+static const char * const aq_macsec_rxsa_stat_names[] = {
 	"MACSecRXSC%dSA%d UntaggedHitPkts",
 	"MACSecRXSC%dSA%d CtrlHitDrpRedir",
 	"MACSecRXSC%dSA%d NotUsingSa",
-- 
2.25.1



