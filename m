Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5BD9F395F47
	for <lists+stable@lfdr.de>; Mon, 31 May 2021 16:08:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232054AbhEaOJz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 31 May 2021 10:09:55 -0400
Received: from mail.kernel.org ([198.145.29.99]:40182 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231610AbhEaOHY (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 31 May 2021 10:07:24 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id BC0EC61452;
        Mon, 31 May 2021 13:39:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1622468356;
        bh=TnT+fP6GtvsPoXUtUAtO2vjAMKV4Hgg9EQS4ZAGobCE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=glmlu7OWwMDz/U+ZQUqFM/zg4HZC+EXBUnWVH0kzX+aHLOLZ8Rj4RUJRNZreKur1y
         +wCgEdBZ88xmAWupALkfyc7lquY6ZtqVLuwxPrY0FHIHwC5eeCP7P2DBoGlqAqKXkf
         MDPeq4XD9Ecwcfq4U5tZ7BcuiCKixCQs+8Apdbis=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Edwin Peer <edwin.peer@broadcom.com>,
        Andy Gospodarek <gospo@broadcom.com>,
        Michael Chan <michael.chan@broadcom.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 212/252] bnxt_en: Include new P5 HV definition in VF check.
Date:   Mon, 31 May 2021 15:14:37 +0200
Message-Id: <20210531130705.218942704@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210531130657.971257589@linuxfoundation.org>
References: <20210531130657.971257589@linuxfoundation.org>
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
index 4385b42a2b63..ff86324c7fb8 100644
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



