Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 31B0E3960B6
	for <lists+stable@lfdr.de>; Mon, 31 May 2021 16:29:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232704AbhEaObC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 31 May 2021 10:31:02 -0400
Received: from mail.kernel.org ([198.145.29.99]:56026 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232207AbhEaO1U (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 31 May 2021 10:27:20 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id B13CD61580;
        Mon, 31 May 2021 13:47:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1622468845;
        bh=ZtNbghQJWtGQ8zRd12zVBehEKh1SjBVfofXe2nlYLeg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=KQ4fyeJOMLsC9KxE1JMCkrDTzH1RaFDlwH6tOzfEeMY9noI0++RECVM4lT5RZFb+2
         LaTTAKswGzgvnFyXFXspDCFZE3p4WPjrlMBplBLBdmt6ZiMXEDjqB8ymHx3L95gv40
         hB+AxLdkFPVvMRYfCsBmrEnrvcSJFknvEqMcEgPk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Edwin Peer <edwin.peer@broadcom.com>,
        Andy Gospodarek <gospo@broadcom.com>,
        Michael Chan <michael.chan@broadcom.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 150/177] bnxt_en: Include new P5 HV definition in VF check.
Date:   Mon, 31 May 2021 15:15:07 +0200
Message-Id: <20210531130653.114045445@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210531130647.887605866@linuxfoundation.org>
References: <20210531130647.887605866@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Andy Gospodarek <gospo@broadcom.com>

[ Upstream commit ab21494be9dc7d62736c5fcd06be65d49df713ee ]

Otherwise, some of the recently added HyperV VF IDs would not be
recognized as VF devices and they would not initialize properly.

Fixes: 7fbf359bb2c1 ("bnxt_en: Add PCI IDs for Hyper-V VF devices.")
Reviewed-by: Edwin Peer <edwin.peer@broadcom.com>
Signed-off-by: Andy Gospodarek <gospo@broadcom.com>
Signed-off-by: Michael Chan <michael.chan@broadcom.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/broadcom/bnxt/bnxt.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt.c b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
index 106f2b2ce17f..0dba28bb309a 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
@@ -280,7 +280,8 @@ static bool bnxt_vf_pciid(enum board_idx idx)
 {
 	return (idx == NETXTREME_C_VF || idx == NETXTREME_E_VF ||
 		idx == NETXTREME_S_VF || idx == NETXTREME_C_VF_HV ||
-		idx == NETXTREME_E_VF_HV || idx == NETXTREME_E_P5_VF);
+		idx == NETXTREME_E_VF_HV || idx == NETXTREME_E_P5_VF ||
+		idx == NETXTREME_E_P5_VF_HV);
 }
 
 #define DB_CP_REARM_FLAGS	(DB_KEY_CP | DB_IDX_VALID)
-- 
2.30.2



