Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D76C13CE23E
	for <lists+stable@lfdr.de>; Mon, 19 Jul 2021 18:14:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347901AbhGSP3i (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 19 Jul 2021 11:29:38 -0400
Received: from mail.kernel.org ([198.145.29.99]:46008 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1346834AbhGSP1P (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 19 Jul 2021 11:27:15 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8889E610D2;
        Mon, 19 Jul 2021 16:07:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626710874;
        bh=8eobUuQb0nnIyN8H1ub91qT3MywiOl/yDIoK+PJlCpE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=1kvdMrnj/EODkzWoshlQZuIva/3qxj0x3Bb8SFen7tnuD+5AhUoXuu47hYNpBQ3fA
         r32L5e2lZTbID3yEbh0s8NHXHPEv0tX0Gr/X2yy50FLYCYKyTstOXQ1GSf1OmKf+Fg
         gbdDca0MpQaWijc/RH1tdREcskaM7T0ubIpf9A6M=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hans de Goede <hdegoede@redhat.com>,
        Fabio Aiuto <fabioaiuto83@gmail.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.13 141/351] staging: rtl8723bs: fix macro value for 2.4Ghz only device
Date:   Mon, 19 Jul 2021 16:51:27 +0200
Message-Id: <20210719144949.142289328@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210719144944.537151528@linuxfoundation.org>
References: <20210719144944.537151528@linuxfoundation.org>
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
index ff21343fbe0b..a428b0d7e37c 100644
--- a/drivers/staging/rtl8723bs/hal/odm.h
+++ b/drivers/staging/rtl8723bs/hal/odm.h
@@ -197,10 +197,7 @@ struct odm_rate_adaptive {
 
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



