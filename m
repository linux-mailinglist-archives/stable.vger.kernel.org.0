Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 18E9952CB6C
	for <lists+stable@lfdr.de>; Thu, 19 May 2022 07:14:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231864AbiESFO2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 19 May 2022 01:14:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51742 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233875AbiESFO1 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 19 May 2022 01:14:27 -0400
Received: from mo-csw-fb.securemx.jp (mo-csw-fb1114.securemx.jp [210.130.202.173])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2B34F994D5
        for <stable@vger.kernel.org>; Wed, 18 May 2022 22:14:26 -0700 (PDT)
Received: by mo-csw-fb.securemx.jp (mx-mo-csw-fb1114) id 24J4qCMm004533; Thu, 19 May 2022 13:52:12 +0900
Received: by mo-csw.securemx.jp (mx-mo-csw1115) id 24J4px3W023136; Thu, 19 May 2022 13:52:00 +0900
X-Iguazu-Qid: 2wHH68dypx481virL6
X-Iguazu-QSIG: v=2; s=0; t=1652935919; q=2wHH68dypx481virL6; m=hnKN3WLnD9PbQWIO6DSfSQXZhwb4sETv/S5LkixZjOE=
Received: from imx2-a.toshiba.co.jp (imx2-a.toshiba.co.jp [106.186.93.35])
        by relay.securemx.jp (mx-mr1110) id 24J4puaa028344
        (version=TLSv1.2 cipher=AES128-GCM-SHA256 bits=128 verify=NOT);
        Thu, 19 May 2022 13:51:57 +0900
From:   Nobuhiro Iwamatsu <nobuhiro1.iwamatsu@toshiba.co.jp>
To:     stable@vger.kernel.org
Cc:     daichi1.fukui@toshiba.co.jp,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sasha Neftin <sasha.neftin@intel.com>,
        Dvora Fuxbrumer <dvorax.fuxbrumer@linux.intel.com>,
        Tony Nguyen <anthony.l.nguyen@intel.com>,
        Nechama Kraus <nechamax.kraus@linux.intel.com>,
        Nobuhiro Iwamatsu <nobuhiro1.iwamatsu@toshiba.co.jp>
Subject: [PATCH for 5.10.y 0/3] Intel igc backports
Date:   Thu, 19 May 2022 13:51:42 +0900
X-TSB-HOP2: ON
Message-Id: <20220519045145.114240-1-nobuhiro1.iwamatsu@toshiba.co.jp>
X-Mailer: git-send-email 2.36.0
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

Hi,

Intel igc ethernet device does not work on 5.10.y due to a problem with the PHY check
of igc driver.

```
igc: probe of 0000:03:00.0 failed with error -2
```

To fix this issue, we'll need three commits that have been fixed in upstream.

Best regards,
  Nobuhiro

Sasha Neftin (3):
  igc: Remove _I_PHY_ID checking
  igc: Remove phy->type checking
  igc: Update I226_K device ID

 drivers/net/ethernet/intel/igc/igc_base.c | 10 +---------
 drivers/net/ethernet/intel/igc/igc_hw.h   |  1 +
 drivers/net/ethernet/intel/igc/igc_main.c | 18 +++++-------------
 drivers/net/ethernet/intel/igc/igc_phy.c  |  6 ++----
 4 files changed, 9 insertions(+), 26 deletions(-)

-- 
2.36.0


