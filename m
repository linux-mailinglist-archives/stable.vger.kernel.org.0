Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5927A3C3143
	for <lists+stable@lfdr.de>; Sat, 10 Jul 2021 04:48:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233958AbhGJClD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 9 Jul 2021 22:41:03 -0400
Received: from mail.kernel.org ([198.145.29.99]:58378 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234926AbhGJCjS (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 9 Jul 2021 22:39:18 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id B7C05613EC;
        Sat, 10 Jul 2021 02:35:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1625884510;
        bh=uyH98worKDCuEIvIP5fQMxJG9xlQztNJsqIkPCqEcSY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Y0L4KCl+k72C5tZMl++fcq2RqdDfEqYL27lezT/cFWZZBpjS8EFTPrVqQHQvsGwbk
         lRFZZyMaUAN+5FOhSUN+55Ilo2U8HJcvNTOtNG6AZhy66wcvaThrQHFpZ1YUPqQCLi
         yMFiyfls8WDn4eWDhHrWjOjDw+AAHCWjlIa8dDvfJdFqFplZXgPrsedEJKd1jgvspm
         znc+dZYjjySXL+omYuiGpM3DQdv0Q3yFvRNJ5XSgnufmGjtjIcJ9PtNkj/1Rue3hwS
         rCacfCghHKwz9c7MOQz2YQsZTQFaxPm9wV+WLbCIBQltdiqcSPcx4R9Xynv0rvfp1/
         yivuCnmj4Dh3w==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Fabio Aiuto <fabioaiuto83@gmail.com>,
        Hans de Goede <hdegoede@redhat.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>, linux-staging@lists.linux.dev
Subject: [PATCH AUTOSEL 4.19 36/39] staging: rtl8723bs: fix macro value for 2.4Ghz only device
Date:   Fri,  9 Jul 2021 22:32:01 -0400
Message-Id: <20210710023204.3171428-36-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210710023204.3171428-1-sashal@kernel.org>
References: <20210710023204.3171428-1-sashal@kernel.org>
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
index 23ab160ac2c8..ff8e22d70d4c 100644
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

