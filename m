Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 12C2A60EF06
	for <lists+stable@lfdr.de>; Thu, 27 Oct 2022 06:28:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234383AbiJ0E2u (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 27 Oct 2022 00:28:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47500 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234005AbiJ0E2X (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 27 Oct 2022 00:28:23 -0400
Received: from mga11.intel.com (mga11.intel.com [192.55.52.93])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2CC67157F6A
        for <stable@vger.kernel.org>; Wed, 26 Oct 2022 21:27:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1666844857; x=1698380857;
  h=date:from:to:cc:subject:message-id:mime-version:
   in-reply-to;
  bh=MfPsCzfLOlIBltS0R7RzoY3tLcLX3j5Kt0+Bo4TiNTo=;
  b=ZkmwLU6DDGyA4k8fsDv3vcTWrpLi2q6XrRN6MvPhh1I+lcALjSX460Zo
   VviSFrxYAN9Z4Bx9RAqJkvr0O6fpMzX9+pw50kof7+JAEgKTNVjKbaLa6
   3Qg9yaomc27dvB4mMFGn0lVg67sG0CPvrVuRtRHYzKu4yLr6JixxUNLcd
   FkctTuZ0JEP7C5AfS0ee38ZHlIQH1PiWgs6i5uCFrxjVGPwd8vmYVr8SV
   7+hAOspmNwF6NGXAnmF+zFWhWR0Sim46k7FkDDkaQSsSR+0Mtzj+D1x4J
   fydeH/OHMQomddwzJfot4I8AM77YTleKTVk2jHtYj9A5jEmMZkMHhY5Z6
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10512"; a="305740527"
X-IronPort-AV: E=Sophos;i="5.95,215,1661842800"; 
   d="scan'208";a="305740527"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Oct 2022 21:27:36 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10512"; a="583412994"
X-IronPort-AV: E=Sophos;i="5.95,215,1661842800"; 
   d="scan'208";a="583412994"
Received: from lkp-server02.sh.intel.com (HELO b6d29c1a0365) ([10.239.97.151])
  by orsmga003.jf.intel.com with ESMTP; 26 Oct 2022 21:27:35 -0700
Received: from kbuild by b6d29c1a0365 with local (Exim 4.96)
        (envelope-from <lkp@intel.com>)
        id 1onuUR-0008GN-0J;
        Thu, 27 Oct 2022 04:27:35 +0000
Date:   Thu, 27 Oct 2022 12:26:56 +0800
From:   kernel test robot <lkp@intel.com>
To:     Shuai Xue <xueshuai@linux.alibaba.com>
Cc:     stable@vger.kernel.org, kbuild-all@lists.01.org
Subject: Re: [PATCH] ACPI: APEI: set memory failure flags as
 MF_ACTION_REQUIRED on action required events
Message-ID: <Y1oIkIzI6hY5dpvH@dba927f25f90>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221027042445.60108-1-xueshuai@linux.alibaba.com>
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi,

Thanks for your patch.

FYI: kernel test robot notices the stable kernel rule is not satisfied.

Rule: 'Cc: stable@vger.kernel.org' or 'commit <sha1> upstream.'
Subject: [PATCH] ACPI: APEI: set memory failure flags as MF_ACTION_REQUIRED on action required events
Link: https://lore.kernel.org/stable/20221027042445.60108-1-xueshuai%40linux.alibaba.com

The check is based on https://www.kernel.org/doc/html/latest/process/stable-kernel-rules.html

-- 
0-DAY CI Kernel Test Service
https://01.org/lkp



