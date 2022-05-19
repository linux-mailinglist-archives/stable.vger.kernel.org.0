Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 418A252CB7C
	for <lists+stable@lfdr.de>; Thu, 19 May 2022 07:32:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233967AbiESFcF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 19 May 2022 01:32:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60216 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229833AbiESFcF (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 19 May 2022 01:32:05 -0400
Received: from mo-csw-fb.securemx.jp (mo-csw-fb1116.securemx.jp [210.130.202.175])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 98AAC11479
        for <stable@vger.kernel.org>; Wed, 18 May 2022 22:32:02 -0700 (PDT)
Received: by mo-csw-fb.securemx.jp (mx-mo-csw-fb1116) id 24J4qB3M015631; Thu, 19 May 2022 13:52:11 +0900
Received: by mo-csw.securemx.jp (mx-mo-csw1115) id 24J4q00t023146; Thu, 19 May 2022 13:52:00 +0900
X-Iguazu-Qid: 2wHHP0VxHnq8JqxyGl
X-Iguazu-QSIG: v=2; s=0; t=1652935919; q=2wHHP0VxHnq8JqxyGl; m=5IOqbL/uHQ/JrA13bsCBeFedxEgckIYVoQ8MuXPeAQo=
Received: from imx2-a.toshiba.co.jp (imx2-a.toshiba.co.jp [106.186.93.35])
        by relay.securemx.jp (mx-mr1111) id 24J4pxWk032270
        (version=TLSv1.2 cipher=AES128-GCM-SHA256 bits=128 verify=NOT);
        Thu, 19 May 2022 13:51:59 +0900
From:   Nobuhiro Iwamatsu <nobuhiro1.iwamatsu@toshiba.co.jp>
To:     stable@vger.kernel.org
Cc:     daichi1.fukui@toshiba.co.jp,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sasha Neftin <sasha.neftin@intel.com>,
        Dvora Fuxbrumer <dvorax.fuxbrumer@linux.intel.com>,
        Tony Nguyen <anthony.l.nguyen@intel.com>,
        Nechama Kraus <nechamax.kraus@linux.intel.com>,
        Nobuhiro Iwamatsu <nobuhiro1.iwamatsu@toshiba.co.jp>
Subject: [PATCH 3/3] igc: Update I226_K device ID
Date:   Thu, 19 May 2022 13:51:45 +0900
X-TSB-HOP2: ON
Message-Id: <20220519045145.114240-4-nobuhiro1.iwamatsu@toshiba.co.jp>
X-Mailer: git-send-email 2.36.0
In-Reply-To: <20220519045145.114240-1-nobuhiro1.iwamatsu@toshiba.co.jp>
References: <20220519045145.114240-1-nobuhiro1.iwamatsu@toshiba.co.jp>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_LOW,
        SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sasha Neftin <sasha.neftin@intel.com>

commit 79cc8322b6d82747cb63ea464146c0bf5b5a6bc1 upstream.

The device ID for I226_K was incorrectly assigned, update the device
ID to the correct one.

Fixes: bfa5e98c9de4 ("igc: Add new device ID")
Signed-off-by: Sasha Neftin <sasha.neftin@intel.com>
Tested-by: Nechama Kraus <nechamax.kraus@linux.intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
Signed-off-by: Nobuhiro Iwamatsu <nobuhiro1.iwamatsu@toshiba.co.jp>
---
 drivers/net/ethernet/intel/igc/igc_hw.h | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/ethernet/intel/igc/igc_hw.h b/drivers/net/ethernet/intel/igc/igc_hw.h
index 55dae7c4703f..7e29f41f70e0 100644
--- a/drivers/net/ethernet/intel/igc/igc_hw.h
+++ b/drivers/net/ethernet/intel/igc/igc_hw.h
@@ -22,6 +22,7 @@
 #define IGC_DEV_ID_I220_V			0x15F7
 #define IGC_DEV_ID_I225_K			0x3100
 #define IGC_DEV_ID_I225_K2			0x3101
+#define IGC_DEV_ID_I226_K			0x3102
 #define IGC_DEV_ID_I225_LMVP			0x5502
 #define IGC_DEV_ID_I225_IT			0x0D9F
 #define IGC_DEV_ID_I226_LM			0x125B
-- 
2.36.0


