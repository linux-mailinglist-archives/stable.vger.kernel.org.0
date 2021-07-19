Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 095DB3CDF73
	for <lists+stable@lfdr.de>; Mon, 19 Jul 2021 17:51:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345208AbhGSPK1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 19 Jul 2021 11:10:27 -0400
Received: from mail.kernel.org ([198.145.29.99]:41268 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S245211AbhGSPIa (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 19 Jul 2021 11:08:30 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0B0C661165;
        Mon, 19 Jul 2021 15:48:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626709704;
        bh=tGoSPbNe/BAyKJJ0zzYq7WZad+nya4dN++5YmE21xRQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=hk4lo+gLglaF8DinQKIEmetPYiMUH9WPBNoL6oxG/NG6wtjoyDZngQQweiILqNG20
         SOpgeU36Zpf06Gx3e0Dh+XDVoPb9NLo6UP8aWvHhuxp0pqOHzgJRVaystmKJ+s1vd2
         AyiDZtieGvb0UU3gRnF0TE7e8HQctydBFdd/6D2M=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hans de Goede <hdegoede@redhat.com>,
        Fabio Aiuto <fabioaiuto83@gmail.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 065/149] staging: rtl8723bs: fix macro value for 2.4Ghz only device
Date:   Mon, 19 Jul 2021 16:52:53 +0200
Message-Id: <20210719144916.723198571@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210719144901.370365147@linuxfoundation.org>
References: <20210719144901.370365147@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Fabio Aiuto <fabioaiuto83@gmail.com>

[ Upstream commit 6d490a27e23c5fb79b766530016ab8665169498e ]

fix IQK_Matrix_Settings_NUM macro value to 14 which is
the max channel number value allowed in a 2.4Ghz device.

Acked-by: Hans de Goede <hdegoede@redhat.com>
Signed-off-by: Fabio Aiuto <fabioaiuto83@gmail.com>
Link: https://lore.kernel.org/r/0b4a876929949248aa18cb919da3583c65e4ee4e.1624367072.git.fabioaiuto83@gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/staging/rtl8723bs/hal/odm.h | 5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

diff --git a/drivers/staging/rtl8723bs/hal/odm.h b/drivers/staging/rtl8723bs/hal/odm.h
index fba3b9e1491b..ee867621aed9 100644
--- a/drivers/staging/rtl8723bs/hal/odm.h
+++ b/drivers/staging/rtl8723bs/hal/odm.h
@@ -197,10 +197,7 @@ typedef struct _ODM_RATE_ADAPTIVE {
 
 #define AVG_THERMAL_NUM		8
 #define IQK_Matrix_REG_NUM	8
-#define IQK_Matrix_Settings_NUM	(14 + 24 + 21) /*   Channels_2_4G_NUM
-						* + Channels_5G_20M_NUM
-						* + Channels_5G
-						*/
+#define IQK_Matrix_Settings_NUM	14 /* Channels_2_4G_NUM */
 
 #define		DM_Type_ByFW			0
 #define		DM_Type_ByDriver		1
-- 
2.30.2



