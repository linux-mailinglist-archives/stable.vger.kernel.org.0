Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 866C4157B02
	for <lists+stable@lfdr.de>; Mon, 10 Feb 2020 14:27:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728750AbgBJN0p (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 Feb 2020 08:26:45 -0500
Received: from mail.kernel.org ([198.145.29.99]:56566 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728472AbgBJMgm (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 10 Feb 2020 07:36:42 -0500
Received: from localhost (unknown [209.37.97.194])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 80C662051A;
        Mon, 10 Feb 2020 12:36:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1581338201;
        bh=VOS8l+8h754/Kct7mPhTe9ZEIvqJpnlDf+dQg/7zPl0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=XZ/bSKs+CrFmJXD5lXr6vEnFctKx4+o9yKA8/ZaKuGP6eWA36sEOCx9c0z5DXZ1lQ
         zRqvuoMbSwni+jNTOopkuEUL5iRyj/TNe0GmAcOwHZZXXcl+i1DH0AmAfKT3aWRnM6
         AW1EXqLHwYTCTqFda4/wXPbJv1e/hZygo1sxdvUE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Shannon Nelson <snelson@pensando.io>,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 5.4 018/309] ionic: fix rxq comp packet type mask
Date:   Mon, 10 Feb 2020 04:29:34 -0800
Message-Id: <20200210122407.739393002@linuxfoundation.org>
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

From: Shannon Nelson <snelson@pensando.io>

[ Upstream commit b5ce31b5e11b768b7d685b2bab7db09ad5549493 ]

Be sure to include all the packet type bits in the mask.

Fixes: fbfb8031533c ("ionic: Add hardware init and device commands")
Signed-off-by: Shannon Nelson <snelson@pensando.io>
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/pensando/ionic/ionic_if.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/net/ethernet/pensando/ionic/ionic_if.h
+++ b/drivers/net/ethernet/pensando/ionic/ionic_if.h
@@ -862,7 +862,7 @@ struct ionic_rxq_comp {
 #define IONIC_RXQ_COMP_CSUM_F_VLAN	0x40
 #define IONIC_RXQ_COMP_CSUM_F_CALC	0x80
 	u8     pkt_type_color;
-#define IONIC_RXQ_COMP_PKT_TYPE_MASK	0x0f
+#define IONIC_RXQ_COMP_PKT_TYPE_MASK	0x7f
 };
 
 enum ionic_pkt_type {


