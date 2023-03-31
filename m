Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 651B56D1FCF
	for <lists+stable@lfdr.de>; Fri, 31 Mar 2023 14:13:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230332AbjCaMNp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 31 Mar 2023 08:13:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54170 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232111AbjCaMNo (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 31 Mar 2023 08:13:44 -0400
Received: from mga06.intel.com (mga06b.intel.com [134.134.136.31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 47D371EFFE
        for <stable@vger.kernel.org>; Fri, 31 Mar 2023 05:13:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1680264820; x=1711800820;
  h=date:from:to:cc:subject:message-id:mime-version:
   in-reply-to;
  bh=1HSYvc/2MSoXPTF8gyGbdgCwK9wLMPPADEFHj/kFmGo=;
  b=TsQ58KaqHjLuMBolkjUWEQU7A/MBzm5GFpsfcJ0KnGwcK5zltFlh7IXR
   quVawTHcaJNVh2zIKfHaZaU7EJj4EsSM7tNTLLnbEEfrZo6SAjekWd7kk
   wA3nyvz+MnRzScU/EvB91YgROTg/bO9MR46iPesoyM7FZTvm2TAV4Jfpg
   3o2kBk4YWIiDHp6WZayIlQhFODV3s9iLjGWVneJho/+89OHDis8PKF3EZ
   anFxb9o9f4f0eYOYRp+YndgmX42QZu1FH9ecKDlT4LdTbQDxoP5ZnQNiJ
   PtUrtx0XoVB3tOcBVEma3h6FRasbD4PUjVe2u0RCP/LECoHVuRaYK5S9S
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10665"; a="404155073"
X-IronPort-AV: E=Sophos;i="5.98,307,1673942400"; 
   d="scan'208";a="404155073"
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 Mar 2023 05:13:37 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10665"; a="685112575"
X-IronPort-AV: E=Sophos;i="5.98,307,1673942400"; 
   d="scan'208";a="685112575"
Received: from lkp-server01.sh.intel.com (HELO b613635ddfff) ([10.239.97.150])
  by orsmga002.jf.intel.com with ESMTP; 31 Mar 2023 05:13:36 -0700
Received: from kbuild by b613635ddfff with local (Exim 4.96)
        (envelope-from <lkp@intel.com>)
        id 1piDdP-000LlC-1P;
        Fri, 31 Mar 2023 12:13:35 +0000
Date:   Fri, 31 Mar 2023 20:12:49 +0800
From:   kernel test robot <lkp@intel.com>
To:     Sascha Hauer <s.hauer@pengutronix.de>
Cc:     stable@vger.kernel.org, oe-kbuild-all@lists.linux.dev
Subject: Re: [PATCH 1/2] wifi: rtw88: usb: fix priority queue to endpoint
 mapping
Message-ID: <ZCbOQTYSR2KZegdt@ec83ac1404bb>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230331121054.112758-2-s.hauer@pengutronix.de>
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi,

Thanks for your patch.

FYI: kernel test robot notices the stable kernel rule is not satisfied.

Rule: 'Cc: stable@vger.kernel.org' or 'commit <sha1> upstream.'
Subject: [PATCH 1/2] wifi: rtw88: usb: fix priority queue to endpoint mapping
Link: https://lore.kernel.org/stable/20230331121054.112758-2-s.hauer%40pengutronix.de

The check is based on https://www.kernel.org/doc/html/latest/process/stable-kernel-rules.html

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests



