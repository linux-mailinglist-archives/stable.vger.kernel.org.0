Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7982C3962D0
	for <lists+stable@lfdr.de>; Mon, 31 May 2021 16:59:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232559AbhEaPBI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 31 May 2021 11:01:08 -0400
Received: from mail.kernel.org ([198.145.29.99]:51028 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234050AbhEaO5U (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 31 May 2021 10:57:20 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 61E6661CC0;
        Mon, 31 May 2021 14:00:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1622469613;
        bh=ZkS9w7HymYeiWss7Yqmd0vpm+kQ5ikWbWZJWXV2QQGU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=UCduiBaMPpAYsbNvAD6fcxPyCIk9OmDhTNZIWqXHn9pcHb8P7Unn1Zna6xU3IA5AR
         61HtVHW+VozXXQlUHGcXgp7VznF84GYd6S5Go55lXeUp48sQfxrzUkYcyK1vWT0m4+
         bNBWytheUm1vS2wwIngfNoyqncJkVBrNiqzv03zQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Edwin Peer <edwin.peer@broadcom.com>,
        Andy Gospodarek <gospo@broadcom.com>,
        Michael Chan <michael.chan@broadcom.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.12 247/296] bnxt_en: Include new P5 HV definition in VF check.
Date:   Mon, 31 May 2021 15:15:02 +0200
Message-Id: <20210531130712.080325432@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210531130703.762129381@linuxfoundation.org>
References: <20210531130703.762129381@linuxfoundation.org>
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
index cf4249d59383..fc7345e57bc1 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
@@ -282,7 +282,8 @@ static bool bnxt_vf_pciid(enum board_idx idx)
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



