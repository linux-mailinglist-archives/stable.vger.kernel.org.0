Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 53A60582F0E
	for <lists+stable@lfdr.de>; Wed, 27 Jul 2022 19:20:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230385AbiG0RUE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 27 Jul 2022 13:20:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33706 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241899AbiG0RTS (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 27 Jul 2022 13:19:18 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BFB1C7A524;
        Wed, 27 Jul 2022 09:44:11 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 6402BB8200C;
        Wed, 27 Jul 2022 16:44:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 36566C433D6;
        Wed, 27 Jul 2022 16:44:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1658940248;
        bh=wNIplsC///Z+1aLsiUGI7BR3SSo4CPpuOnzTbHZt7Zg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=YSJrcV21spXwIq9Ks7zoYJnNwXVVvTodcRSZe4PmjZ4X4RUpx7vitFJ9gOJbN+51z
         rh8EEP5CZ8zruLVUOEKIuv00m5qIvWdIM1rBKauKNDWLkcDwAUxUhB1Uwdn3f3UkEQ
         sRU+DxEoda/6jHkzU+5PCJmBPvbKXiW+FcGWRBVQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Johannes Berg <johannes.berg@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 157/201] iwlwifi: fw: uefi: add missing include guards
Date:   Wed, 27 Jul 2022 18:11:01 +0200
Message-Id: <20220727161034.339315972@linuxfoundation.org>
X-Mailer: git-send-email 2.37.1
In-Reply-To: <20220727161026.977588183@linuxfoundation.org>
References: <20220727161026.977588183@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Johannes Berg <johannes.berg@intel.com>

[ Upstream commit 91000fdf82195b66350b4f88413c2e8b5f94d994 ]

We still don't use #pragma once in the kernel, but even if
we did it'd be missing. Add the missing include guards.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Fixes: 84c3c9952afb ("iwlwifi: move UEFI code to a separate file")
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
Link: https://lore.kernel.org/r/iwlwifi.20211024181719.7fc9988ed49b.I87e300fab664047581e51fb9b02744c75320d08c@changeid
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/intel/iwlwifi/fw/uefi.h | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/fw/uefi.h b/drivers/net/wireless/intel/iwlwifi/fw/uefi.h
index 45d0b36d79b5..d552c656ac9f 100644
--- a/drivers/net/wireless/intel/iwlwifi/fw/uefi.h
+++ b/drivers/net/wireless/intel/iwlwifi/fw/uefi.h
@@ -2,7 +2,8 @@
 /*
  * Copyright(c) 2021 Intel Corporation
  */
-
+#ifndef __iwl_fw_uefi__
+#define __iwl_fw_uefi__
 
 #define IWL_UEFI_OEM_PNVM_NAME		L"UefiCnvWlanOemSignedPnvm"
 #define IWL_UEFI_REDUCED_POWER_NAME	L"UefiCnvWlanReducedPower"
@@ -40,3 +41,5 @@ void *iwl_uefi_get_reduced_power(struct iwl_trans *trans, size_t *len)
 	return ERR_PTR(-EOPNOTSUPP);
 }
 #endif /* CONFIG_EFI */
+
+#endif /* __iwl_fw_uefi__ */
-- 
2.35.1



