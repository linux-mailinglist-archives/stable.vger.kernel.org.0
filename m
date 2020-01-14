Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4DC2C13A528
	for <lists+stable@lfdr.de>; Tue, 14 Jan 2020 11:08:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730035AbgANKFE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 14 Jan 2020 05:05:04 -0500
Received: from mail.kernel.org ([198.145.29.99]:32916 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730025AbgANKFD (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 14 Jan 2020 05:05:03 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D567D2467E;
        Tue, 14 Jan 2020 10:05:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1578996303;
        bh=6x5H/qSfeoUdvmRrLY1/QJTMbneI6c4ICGyYoLfZWVg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=mIph/3NXmVvsx2oRPconjLXu7BXg/74S/4ShLMlS2fDNebEcvZpysqVVdQ75u7Rvr
         uly4Pv3Ib6lhHRfE0l8NrFS4ly/4PbIkyoCI/4lTKoT/l0DedckP3pc7/vdC16swCX
         xJZ2kZ4SX/7quAzSW4zGXM+9oJaHbyQqUjijqv1g=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Malcolm Priestley <tvboxspy@gmail.com>
Subject: [PATCH 5.4 50/78] staging: vt6656: correct return of vnt_init_registers.
Date:   Tue, 14 Jan 2020 11:01:24 +0100
Message-Id: <20200114094400.201384767@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200114094352.428808181@linuxfoundation.org>
References: <20200114094352.428808181@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Malcolm Priestley <tvboxspy@gmail.com>

commit 7de6155c8968a3342d1bef3f7a2084d31ae6e4be upstream.

The driver standard error returns remove bool false conditions.

Cc: stable <stable@vger.kernel.org> # v5.3+
Signed-off-by: Malcolm Priestley <tvboxspy@gmail.com>
Link: https://lore.kernel.org/r/072ec0b3-425f-277e-130c-1e3a116c90d6@gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/staging/vt6656/main_usb.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/staging/vt6656/main_usb.c
+++ b/drivers/staging/vt6656/main_usb.c
@@ -950,7 +950,7 @@ static const struct ieee80211_ops vnt_ma
 
 int vnt_init(struct vnt_private *priv)
 {
-	if (!(vnt_init_registers(priv)))
+	if (vnt_init_registers(priv))
 		return -EAGAIN;
 
 	SET_IEEE80211_PERM_ADDR(priv->hw, priv->permanent_net_addr);


