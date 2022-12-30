Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 60DCE659CA1
	for <lists+stable@lfdr.de>; Fri, 30 Dec 2022 23:02:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235569AbiL3WCI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 30 Dec 2022 17:02:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47288 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235518AbiL3WCA (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 30 Dec 2022 17:02:00 -0500
Received: from mga11.intel.com (mga11.intel.com [192.55.52.93])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 579DC19C37
        for <stable@vger.kernel.org>; Fri, 30 Dec 2022 14:01:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1672437719; x=1703973719;
  h=date:from:to:cc:subject:message-id:mime-version:
   in-reply-to;
  bh=dNNPFaYd08nXf1xSCk5cKNJc4YHMA/PaibmSIDYQYpI=;
  b=Qgh0QBrXnOILTUXwb/8AL+RYwjeYkeLgyCZfww/3KE4sjXwQZO4QZ9B+
   4EeplkmL6JY4uPyiVkJNqEO/Lavcm5uR0FFEJo6mn6M2QePpd8TLbKBbW
   dUQa0tPHBmXHIqlTLDP0UygTQoqLcmuTWQbH4zDmDi4JiVd9Q07/tJqkS
   Wy+b0wcf4XwPAhfj26oU5icBV09g2e609rzeJV9kIe3zUO0ckDs0yn12U
   inrwQA+FNOJOrOxqrpsrOrbtv5DASTsQ4B9C32xi6+u6FA7HzsZM5gV74
   AOw2C56ocVUZo2JrsXGqBIYJiA6+zP6tPIza4/QK7iS21mqX9nsBr4NcN
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10576"; a="318958086"
X-IronPort-AV: E=Sophos;i="5.96,288,1665471600"; 
   d="scan'208";a="318958086"
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Dec 2022 14:01:59 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10576"; a="778042389"
X-IronPort-AV: E=Sophos;i="5.96,288,1665471600"; 
   d="scan'208";a="778042389"
Received: from lkp-server01.sh.intel.com (HELO b5d47979f3ad) ([10.239.97.150])
  by orsmga004.jf.intel.com with ESMTP; 30 Dec 2022 14:01:57 -0800
Received: from kbuild by b5d47979f3ad with local (Exim 4.96)
        (envelope-from <lkp@intel.com>)
        id 1pBNRs-000ISP-2A;
        Fri, 30 Dec 2022 22:01:56 +0000
Date:   Sat, 31 Dec 2022 06:01:43 +0800
From:   kernel test robot <lkp@intel.com>
To:     Maciej =?utf-8?Q?=C5=BBenczykowski?= <zenczykowski@gmail.com>
Cc:     stable@vger.kernel.org, oe-kbuild-all@lists.linux.dev
Subject: Re: [PATCH] usb: storage: de-quirk Seagate Expansion Portable Drive
 SRD00F1 [0bc2:2320]
Message-ID: <Y69fx1KpwWivqLp0@181616e551cc>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221230215942.3241955-1-zenczykowski@gmail.com>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
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
Subject: [PATCH] usb: storage: de-quirk Seagate Expansion Portable Drive SRD00F1 [0bc2:2320]
Link: https://lore.kernel.org/stable/20221230215942.3241955-1-zenczykowski%40gmail.com

The check is based on https://www.kernel.org/doc/html/latest/process/stable-kernel-rules.html

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests



