Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 26E355707C1
	for <lists+stable@lfdr.de>; Mon, 11 Jul 2022 17:57:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229927AbiGKP5g (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 11 Jul 2022 11:57:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50476 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229561AbiGKP5f (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 11 Jul 2022 11:57:35 -0400
Received: from mga12.intel.com (mga12.intel.com [192.55.52.136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3114A2F3AC
        for <stable@vger.kernel.org>; Mon, 11 Jul 2022 08:57:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1657555054; x=1689091054;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=izCGmemNoYvjRS6L9CFqC/6xD3cSmiJsQNvuW0QPoTQ=;
  b=jmtzpJmA0TGp2XYdnApuML5GIptH/rc3g0aVX6FOjpv/kDsc80GNGsw5
   bGRgU0czGhSpR5SzZ/VduxMJ/n05FnkZhwP/RFA27pFrVxXpgIIl2a52o
   RMksT5CP7NHDxZM1oXWlb/AVG42x7u5J8rQvi0zAlxFDHNSqRiGC1ZI51
   SAEYAlz50Fm9+4b1mUDDn1xl8vGP/S4gZ0Ytym/DL3i1udDq+4efnrOQh
   uOQ7+T9Haqhh87sDTqx9+R45rPm10LvnKQriUASNXjaEOMiIMG3fcCpYI
   IqJ7rmFPMjmJlxTgWHYRHaKPmJfqD+sMqMW04v5XTzXyDWYHUZqp5NSg4
   A==;
X-IronPort-AV: E=McAfee;i="6400,9594,10405"; a="264479642"
X-IronPort-AV: E=Sophos;i="5.92,263,1650956400"; 
   d="scan'208";a="264479642"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Jul 2022 08:57:33 -0700
X-IronPort-AV: E=Sophos;i="5.92,263,1650956400"; 
   d="scan'208";a="771553851"
Received: from jbeecha-mobl.amr.corp.intel.com (HELO pbossart-mobl3.intel.com) ([10.209.161.159])
  by orsmga005-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Jul 2022 08:57:32 -0700
From:   Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>
To:     stable@vger.kernel.org
Cc:     gregkh@linuxfoundation.org, broonie@kernel.org,
        peter.ujfalusi@linux.intel.com, ranjani.sridharan@linux.intel.com,
        Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>
Subject: [PATCH 0/3] [5.18.y backport] ASoC: SOF: Intel: fix resume from hibernate
Date:   Mon, 11 Jul 2022 10:57:16 -0500
Message-Id: <20220711155719.104952-1-pierre-louis.bossart@linux.intel.com>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_PASS,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Backport for 5.18 stable, the first two patches were not modified,
only the third patch had a missing dependency with 2a68ff846164
("ASoC: SOF: Intel: hda: Revisit IMR boot sequence")

Pierre-Louis Bossart (3):
  ASoC: SOF: pm: add explicit behavior for ACPI S1 and S2
  ASoC: SOF: pm: add definitions for S4 and S5 states
  ASoC: SOF: Intel: disable IMR boot when resuming from ACPI S4 and S5
    states

 sound/soc/sof/intel/hda-loader.c |  3 ++-
 sound/soc/sof/pm.c               | 21 ++++++++++++++++++++-
 sound/soc/sof/sof-priv.h         |  2 ++
 3 files changed, 24 insertions(+), 2 deletions(-)

-- 
2.34.1

