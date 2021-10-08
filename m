Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4B816426972
	for <lists+stable@lfdr.de>; Fri,  8 Oct 2021 13:36:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241124AbhJHLhz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 8 Oct 2021 07:37:55 -0400
Received: from mail.kernel.org ([198.145.29.99]:60600 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S241597AbhJHLf5 (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 8 Oct 2021 07:35:57 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6144661371;
        Fri,  8 Oct 2021 11:31:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1633692712;
        bh=o1gLY2ZYXf8+Eu+p/sycKXvaHcg7lgTxIaE2Ew7Y0yY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=k4ALB2IytToUmf7oGjaAVQ3B19uqpe/aBn064wN1yoducFxALMjo83Vc7lZyztQyy
         8CbvXlSrzuIju3AsezrxSBJgalZ1Ll1R87N/qSDFZQ2z79APxBoLES2THYtIW2tK58
         3L4HuYITtP88+dH5uiC9Xw6frQ2T4qk+y9WgDcuY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Tobias Jakobi <tjakobi@math.uni-bielefeld.de>,
        =?UTF-8?q?Thomas=20Wei=C3=9Fschuh?= <thomas@weissschuh.net>,
        Hans de Goede <hdegoede@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.14 11/48] platform/x86: gigabyte-wmi: add support for B550I Aorus Pro AX
Date:   Fri,  8 Oct 2021 13:27:47 +0200
Message-Id: <20211008112720.403750223@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211008112720.008415452@linuxfoundation.org>
References: <20211008112720.008415452@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Tobias Jakobi <tjakobi@math.uni-bielefeld.de>

[ Upstream commit 6f6aab1caf6c7fef46852aaab03f4e8250779e52 ]

Tested with a AMD Ryzen 7 5800X.

Signed-off-by: Tobias Jakobi <tjakobi@math.uni-bielefeld.de>
Acked-by: Thomas Weißschuh <thomas@weissschuh.net>
Link: https://lore.kernel.org/r/20210921100702.3838-1-tjakobi@math.uni-bielefeld.de
Signed-off-by: Hans de Goede <hdegoede@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/platform/x86/gigabyte-wmi.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/platform/x86/gigabyte-wmi.c b/drivers/platform/x86/gigabyte-wmi.c
index 7f3a03f937f6..d53634c8a6e0 100644
--- a/drivers/platform/x86/gigabyte-wmi.c
+++ b/drivers/platform/x86/gigabyte-wmi.c
@@ -144,6 +144,7 @@ static const struct dmi_system_id gigabyte_wmi_known_working_platforms[] = {
 	DMI_EXACT_MATCH_GIGABYTE_BOARD_NAME("B550 AORUS ELITE"),
 	DMI_EXACT_MATCH_GIGABYTE_BOARD_NAME("B550 AORUS ELITE V2"),
 	DMI_EXACT_MATCH_GIGABYTE_BOARD_NAME("B550 GAMING X V2"),
+	DMI_EXACT_MATCH_GIGABYTE_BOARD_NAME("B550I AORUS PRO AX"),
 	DMI_EXACT_MATCH_GIGABYTE_BOARD_NAME("B550M AORUS PRO-P"),
 	DMI_EXACT_MATCH_GIGABYTE_BOARD_NAME("B550M DS3H"),
 	DMI_EXACT_MATCH_GIGABYTE_BOARD_NAME("Z390 I AORUS PRO WIFI-CF"),
-- 
2.33.0



