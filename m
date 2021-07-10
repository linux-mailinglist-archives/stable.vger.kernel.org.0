Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 392223C2F80
	for <lists+stable@lfdr.de>; Sat, 10 Jul 2021 04:29:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233725AbhGJCbe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 9 Jul 2021 22:31:34 -0400
Received: from mail.kernel.org ([198.145.29.99]:42628 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234708AbhGJC3m (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 9 Jul 2021 22:29:42 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1586F613D9;
        Sat, 10 Jul 2021 02:26:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1625884017;
        bh=JZXQHFg4/VJ/jucyBM7SkBKJjHxpQUEN45s+FDtcn6s=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=lW0kZW7alJU4cQnNZqJ8BJEGzhT6hE778ICZGMW5tYFzOFuoJYjF8J3XnjpAMl7Ah
         2eEX8MfsZx1Bn98gi8ldl6r78WDi6C2al+SHBF57mUPtWdEWfqPixTPdKHFD8k+DRU
         v72w3p+2sMa8fU03bnVzigogkIx5pyOKu2m8TYmyxmRHa+LOxjp916jeiJk99fBsfA
         BqSfSZQkZCNbzE7JRcQVNnKYy7quig76onC2UABC+dD5RnAoidCxwEoSFePU0roB0p
         vFAGhccwny1AI3vFkKvJHCMrHm28NqVh7Ipbrr6XzmNhUlgBKCKiQ09LncG5SCqygq
         VZiCl7hfT5MTw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Fabio Aiuto <fabioaiuto83@gmail.com>,
        Hans de Goede <hdegoede@redhat.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>, linux-staging@lists.linux.dev
Subject: [PATCH AUTOSEL 5.10 88/93] staging: rtl8723bs: fix macro value for 2.4Ghz only device
Date:   Fri,  9 Jul 2021 22:24:22 -0400
Message-Id: <20210710022428.3169839-88-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210710022428.3169839-1-sashal@kernel.org>
References: <20210710022428.3169839-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
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
index 16e8f66a3171..a8d232245227 100644
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

