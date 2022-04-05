Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 984B94F2601
	for <lists+stable@lfdr.de>; Tue,  5 Apr 2022 09:51:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232370AbiDEHxk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Apr 2022 03:53:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57164 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232311AbiDEHvB (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Apr 2022 03:51:01 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D129D631F;
        Tue,  5 Apr 2022 00:47:18 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 74C33B81B98;
        Tue,  5 Apr 2022 07:47:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D2757C340EE;
        Tue,  5 Apr 2022 07:47:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649144836;
        bh=dlYk8rC60OvZeHn5CTD5I6a5wqwswMluROqrjoBv3YU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=rPWt1r8E6QBsUP6SPiKo/PBcgm/b9jyTd9mZGhhwbpRp6ADk3UpDaCemSHUuhZvzk
         wy8u3RGa7cG96SVFh7/+1jKPczWorNY7FNfWiBw6ZJO8yecSg2S5eDjhO0EeTK7ftL
         iMklNIIJ0n5jdLeYW8rLKdBUInKSRR3ZRkhCStAw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Linus Walleij <linus.walleij@linaro.org>,
        Arend van Spriel <arend.vanspriel@broadcom.com>,
        Hector Martin <marcan@marcan.st>, Kalle Valo <kvalo@kernel.org>
Subject: [PATCH 5.17 0189/1126] brcmfmac: pcie: Declare missing firmware files in pcie.c
Date:   Tue,  5 Apr 2022 09:15:36 +0200
Message-Id: <20220405070413.154598067@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220405070407.513532867@linuxfoundation.org>
References: <20220405070407.513532867@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Hector Martin <marcan@marcan.st>

commit 6d766d8cb505ec1fae63da8faef4fc5712c3d794 upstream.

Move one of the declarations from sdio.c to pcie.c, since it makes no
sense in the former (SDIO support is optional), and add missing ones.

Fixes: 75729e110e68 ("brcmfmac: expose firmware config files through modinfo")
Reviewed-by: Linus Walleij <linus.walleij@linaro.org>
Reviewed-by: Arend van Spriel <arend.vanspriel@broadcom.com>
Cc: stable@vger.kernel.org
Signed-off-by: Hector Martin <marcan@marcan.st>
Signed-off-by: Kalle Valo <kvalo@kernel.org>
Link: https://lore.kernel.org/r/20220131160713.245637-5-marcan@marcan.st
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/wireless/broadcom/brcm80211/brcmfmac/pcie.c |    7 +++++++
 drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.c |    1 -
 2 files changed, 7 insertions(+), 1 deletion(-)

--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/pcie.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/pcie.c
@@ -59,6 +59,13 @@ BRCMF_FW_DEF(4366B, "brcmfmac4366b-pcie"
 BRCMF_FW_DEF(4366C, "brcmfmac4366c-pcie");
 BRCMF_FW_DEF(4371, "brcmfmac4371-pcie");
 
+/* firmware config files */
+MODULE_FIRMWARE(BRCMF_FW_DEFAULT_PATH "brcmfmac*-pcie.txt");
+MODULE_FIRMWARE(BRCMF_FW_DEFAULT_PATH "brcmfmac*-pcie.*.txt");
+
+/* per-board firmware binaries */
+MODULE_FIRMWARE(BRCMF_FW_DEFAULT_PATH "brcmfmac*-pcie.*.bin");
+
 static const struct brcmf_firmware_mapping brcmf_pcie_fwnames[] = {
 	BRCMF_FW_ENTRY(BRCM_CC_43602_CHIP_ID, 0xFFFFFFFF, 43602),
 	BRCMF_FW_ENTRY(BRCM_CC_43465_CHIP_ID, 0xFFFFFFF0, 4366C),
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.c
@@ -629,7 +629,6 @@ BRCMF_FW_CLM_DEF(43752, "brcmfmac43752-s
 
 /* firmware config files */
 MODULE_FIRMWARE(BRCMF_FW_DEFAULT_PATH "brcmfmac*-sdio.*.txt");
-MODULE_FIRMWARE(BRCMF_FW_DEFAULT_PATH "brcmfmac*-pcie.*.txt");
 
 /* per-board firmware binaries */
 MODULE_FIRMWARE(BRCMF_FW_DEFAULT_PATH "brcmfmac*-sdio.*.bin");


