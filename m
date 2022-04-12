Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8678C4FD472
	for <lists+stable@lfdr.de>; Tue, 12 Apr 2022 12:03:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355723AbiDLH3I (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 12 Apr 2022 03:29:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45710 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1353157AbiDLHOx (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 12 Apr 2022 03:14:53 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 737BE37AA4;
        Mon, 11 Apr 2022 23:56:38 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id F16FCB81B44;
        Tue, 12 Apr 2022 06:56:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5C090C385A1;
        Tue, 12 Apr 2022 06:56:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649746595;
        bh=sFmGLkUacBWBHi4zv6UXeP0p70b8wzsnAfwnEIHGy90=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=CqpzXyLV7f3Oy/VceWFRFDc5Z/fAHOJIDGT652YNKPN/B/BgsOnqk9kaqluYPMa+M
         yl2l8CECZft4RZg1m1ySPCFPvFOCYNHhnIQZco/oQuvCITx+orJ5T+zFFHxEU3hpcE
         JwtcjwdbvF1WIRMDo9amVhhUVJPygsG/pt4By8Mc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Luca Coelho <luciano.coelho@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.16 061/285] iwlwifi: fix small doc mistake for iwl_fw_ini_addr_val
Date:   Tue, 12 Apr 2022 08:28:38 +0200
Message-Id: <20220412062945.431114402@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220412062943.670770901@linuxfoundation.org>
References: <20220412062943.670770901@linuxfoundation.org>
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

From: Luca Coelho <luciano.coelho@intel.com>

[ Upstream commit 3009c797c4b3840495e8f48d8d07f48d2ddfed80 ]

There was a small copy and paste mistake in the doc declaration of
iwl_fw_ini_addr_val.  Fix it.

Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
Link: https://lore.kernel.org/r/iwlwifi.20220205112029.aeec71c397b3.I0ba3234419eb8c8c7512a2ca531a6dbb55046cf7@changeid
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/intel/iwlwifi/fw/api/dbg-tlv.h | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/fw/api/dbg-tlv.h b/drivers/net/wireless/intel/iwlwifi/fw/api/dbg-tlv.h
index 3988f5fea33a..6b2a2828cb83 100644
--- a/drivers/net/wireless/intel/iwlwifi/fw/api/dbg-tlv.h
+++ b/drivers/net/wireless/intel/iwlwifi/fw/api/dbg-tlv.h
@@ -1,6 +1,6 @@
 /* SPDX-License-Identifier: GPL-2.0 OR BSD-3-Clause */
 /*
- * Copyright (C) 2018-2021 Intel Corporation
+ * Copyright (C) 2018-2022 Intel Corporation
  */
 #ifndef __iwl_fw_dbg_tlv_h__
 #define __iwl_fw_dbg_tlv_h__
@@ -244,11 +244,10 @@ struct iwl_fw_ini_hcmd_tlv {
 } __packed; /* FW_TLV_DEBUG_HCMD_API_S_VER_1 */
 
 /**
-* struct iwl_fw_ini_conf_tlv - preset configuration TLV
+* struct iwl_fw_ini_addr_val - Address and value to set it to
 *
 * @address: the base address
 * @value: value to set at address
-
 */
 struct iwl_fw_ini_addr_val {
 	__le32 address;
-- 
2.35.1



