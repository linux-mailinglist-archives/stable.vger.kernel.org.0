Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BDCF23C53B6
	for <lists+stable@lfdr.de>; Mon, 12 Jul 2021 12:52:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348479AbhGLHzn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Jul 2021 03:55:43 -0400
Received: from mail.kernel.org ([198.145.29.99]:36654 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1350665AbhGLHvM (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Jul 2021 03:51:12 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 01F1D61C33;
        Mon, 12 Jul 2021 07:47:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626076027;
        bh=+kn2t7F8N6gHn30c1y7H9Zqs2VZPF+DtrHblFRjYkQw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=kndxg35JxOVyq+g8/hfdzbsK1JlWgDtqcY03rOpZQus0+hDH6ARECUWXb0Q3fJbYU
         jNpqu+EQbe8ZN1I2mDCheBHOiQoMT19oEV/5Y7NHpgaNu8HSkSFubBh8DZgyBHCjAi
         gIeFgKuts17P7U+kMJTM5whI9of4cnFPwpEIisPY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Matthias Brugger <mbrugger@suse.com>,
        Hans de Goede <hdegoede@redhat.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.13 465/800] brcmfmac: Delete second brcm folder hierarchy
Date:   Mon, 12 Jul 2021 08:08:08 +0200
Message-Id: <20210712061016.592834772@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210712060912.995381202@linuxfoundation.org>
References: <20210712060912.995381202@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Matthias Brugger <mbrugger@suse.com>

[ Upstream commit 4a26aafe4886a4ec9965171c280ce16df30dc362 ]

BRCMF_FW_DEFAULT_PATH already defines the brcm folder, delete the second
folder to match with Linux firmware repository layout.

Fixes: 75729e110e68 ("brcmfmac: expose firmware config files through modinfo")
Signed-off-by: Matthias Brugger <mbrugger@suse.com>
Reviewed-by: Hans de Goede <hdegoede@redhat.com>
Signed-off-by: Kalle Valo <kvalo@codeaurora.org>
Link: https://lore.kernel.org/r/20210602144305.4481-1-matthias.bgg@kernel.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.c
index 3a1c98a046f0..faf5f8e5eee3 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.c
@@ -626,8 +626,8 @@ BRCMF_FW_DEF(4373, "brcmfmac4373-sdio");
 BRCMF_FW_DEF(43012, "brcmfmac43012-sdio");
 
 /* firmware config files */
-MODULE_FIRMWARE(BRCMF_FW_DEFAULT_PATH "brcm/brcmfmac*-sdio.*.txt");
-MODULE_FIRMWARE(BRCMF_FW_DEFAULT_PATH "brcm/brcmfmac*-pcie.*.txt");
+MODULE_FIRMWARE(BRCMF_FW_DEFAULT_PATH "brcmfmac*-sdio.*.txt");
+MODULE_FIRMWARE(BRCMF_FW_DEFAULT_PATH "brcmfmac*-pcie.*.txt");
 
 static const struct brcmf_firmware_mapping brcmf_sdio_fwnames[] = {
 	BRCMF_FW_ENTRY(BRCM_CC_43143_CHIP_ID, 0xFFFFFFFF, 43143),
-- 
2.30.2



