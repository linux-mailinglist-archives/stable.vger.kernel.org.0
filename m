Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 41A1F680DE5
	for <lists+stable@lfdr.de>; Mon, 30 Jan 2023 13:40:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234488AbjA3MkG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 30 Jan 2023 07:40:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39102 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229769AbjA3MkF (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 30 Jan 2023 07:40:05 -0500
Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A0F11135
        for <stable@vger.kernel.org>; Mon, 30 Jan 2023 04:40:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1675082404; x=1706618404;
  h=date:from:to:cc:subject:message-id:mime-version:
   in-reply-to;
  bh=O10DwT3knlxYoTJUFWvltC0ZkL/SrOQ4uIPyFDdngjQ=;
  b=JBz4slbAC5bdK+n79UNlc5OxbsObvpAe58Gmq1chcXEog0jiHGjVkw2g
   xhrWBaFN+A6VA+M53D+bYUqzfTIC1Rq1jI8wYFSf4Ydb96GlWeMLtlK7N
   jmmBtOqQVpDDoqLXQpFc82HM/9JlsRNbTKR5loBGZehyCxPAhH1cw1Ote
   BnDb5DlmTGYX2pataIbCoAWe2+6yISfG3I2H7PYoTb0/KD/wU836U5s7g
   HtljhWYWyfJEeqH9AwmnvqUbxFyR3kWXjtK/aZ3EQntjBlOUsRjMSqLFx
   O1T7BSAuaKUE0isXfvrqhvVEwfys+sZUy+BqQ5U9kIM+O73MDgZ2OBR2R
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10605"; a="354860107"
X-IronPort-AV: E=Sophos;i="5.97,258,1669104000"; 
   d="scan'208";a="354860107"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Jan 2023 04:40:04 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10605"; a="772486334"
X-IronPort-AV: E=Sophos;i="5.97,258,1669104000"; 
   d="scan'208";a="772486334"
Received: from lkp-server01.sh.intel.com (HELO ffa7f14d1d0f) ([10.239.97.150])
  by fmsmga002.fm.intel.com with ESMTP; 30 Jan 2023 04:40:03 -0800
Received: from kbuild by ffa7f14d1d0f with local (Exim 4.96)
        (envelope-from <lkp@intel.com>)
        id 1pMTS6-0003cg-0I;
        Mon, 30 Jan 2023 12:40:02 +0000
Date:   Mon, 30 Jan 2023 20:39:18 +0800
From:   kernel test robot <lkp@intel.com>
To:     Nikita Zhandarovich <n.zhandarovich@fintech.ru>
Cc:     stable@vger.kernel.org, oe-kbuild-all@lists.linux.dev
Subject: Re: [PATCH 5.10 1/1] mt76: fix mt7615_init_tx_queues() return value
Message-ID: <Y9e6dixwiXvo4l/U@904499574ff1>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230130123655.86339-2-n.zhandarovich@fintech.ru>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi,

Thanks for your patch.

FYI: kernel test robot notices the stable kernel rule is not satisfied.

Rule: 'Cc: stable@vger.kernel.org' or 'commit <sha1> upstream.'
Subject: [PATCH 5.10 1/1] mt76: fix mt7615_init_tx_queues() return value
Link: https://lore.kernel.org/stable/20230130123655.86339-2-n.zhandarovich%40fintech.ru

The check is based on https://www.kernel.org/doc/html/latest/process/stable-kernel-rules.html

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests



