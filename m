Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 645D23CE0FB
	for <lists+stable@lfdr.de>; Mon, 19 Jul 2021 18:10:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347001AbhGSPTH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 19 Jul 2021 11:19:07 -0400
Received: from mail.kernel.org ([198.145.29.99]:55734 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1347074AbhGSPPd (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 19 Jul 2021 11:15:33 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4EF1E60FD7;
        Mon, 19 Jul 2021 15:56:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626710172;
        bh=JZXQHFg4/VJ/jucyBM7SkBKJjHxpQUEN45s+FDtcn6s=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=n+Vvy3xnH3zsU1LfNhqpfPe+wmiKEN5XiLXVqZfMRXpbgY0BPqeqwt9q2AF5I11gM
         ehZwOcIDSMyOayvjToVusKj96Epurqy1uV5hpzqniEsDjhyMbOsFEot70PN9Af6B+U
         7kABP3SaRfTWTkAEmQYLeTLu3VZ6FDWiDxPuyawU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hans de Goede <hdegoede@redhat.com>,
        Fabio Aiuto <fabioaiuto83@gmail.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 105/243] staging: rtl8723bs: fix macro value for 2.4Ghz only device
Date:   Mon, 19 Jul 2021 16:52:14 +0200
Message-Id: <20210719144944.296944291@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210719144940.904087935@linuxfoundation.org>
References: <20210719144940.904087935@linuxfoundation.org>
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



