Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C561A147AE7
	for <lists+stable@lfdr.de>; Fri, 24 Jan 2020 10:40:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731608AbgAXJjU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 24 Jan 2020 04:39:20 -0500
Received: from mail.kernel.org ([198.145.29.99]:36490 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730923AbgAXJjT (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 24 Jan 2020 04:39:19 -0500
Received: from localhost (unknown [145.15.244.15])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7493B20838;
        Fri, 24 Jan 2020 09:39:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579858759;
        bh=vTyqrbemP4Yg1Gi05XM+3Cmz6XpD+zp810ADQ29hNCc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=DAKbYtHdj02Unk8KSBCruB/QkrdS0c8E95ltXCAMLEuLHBzrdlk05wltyP3VF3aEp
         bGqSe1DIfYQ+iDrUFXryp3FROy5ffoUxPYIGCpiNBuf6lx1sUcn56uTXCszRMl45Qw
         /mJPmGOvEDbFhgmvOBtSvqDbKOALq0F0agVjPgC0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Lorenzo Bianconi <lorenzo@kernel.org>,
        Felix Fietkau <nbd@nbd.name>
Subject: [PATCH 5.4 032/102] mt76: mt76u: fix endpoint definition order
Date:   Fri, 24 Jan 2020 10:30:33 +0100
Message-Id: <20200124092811.084952886@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200124092806.004582306@linuxfoundation.org>
References: <20200124092806.004582306@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Lorenzo Bianconi <lorenzo@kernel.org>

commit 23cb16d2ccb5f819d7acff602e5a153157bf2884 upstream.

Even if they are not currently used fix BK/BE endpoint definition order.

Fixes: b40b15e1521f ("mt76: add usb support to mt76 layer")
Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
Signed-off-by: Felix Fietkau <nbd@nbd.name>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/net/wireless/mediatek/mt76/mt76.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/net/wireless/mediatek/mt76/mt76.h
+++ b/drivers/net/wireless/mediatek/mt76/mt76.h
@@ -367,8 +367,8 @@ enum mt76u_in_ep {
 
 enum mt76u_out_ep {
 	MT_EP_OUT_INBAND_CMD,
-	MT_EP_OUT_AC_BK,
 	MT_EP_OUT_AC_BE,
+	MT_EP_OUT_AC_BK,
 	MT_EP_OUT_AC_VI,
 	MT_EP_OUT_AC_VO,
 	MT_EP_OUT_HCCA,


