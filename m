Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6AC3D6D3FC5
	for <lists+stable@lfdr.de>; Mon,  3 Apr 2023 11:12:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229670AbjDCJMG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 Apr 2023 05:12:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60422 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231310AbjDCJMF (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 3 Apr 2023 05:12:05 -0400
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6F71876A7
        for <stable@vger.kernel.org>; Mon,  3 Apr 2023 02:11:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1680513119; x=1712049119;
  h=date:from:to:cc:subject:message-id:mime-version:
   in-reply-to;
  bh=ZY2iWn53XwO4iPkNYdKhxUPsIYVR1gf5Wf884UVOc/c=;
  b=a3av7+GHffTr9oBM9IGEZGZJy49lnOMxj4NG/hEizxLELubzThPtYsYr
   ptyjzfDL9acMOefxGLW09cFXhnUdz8yo91f10wUzrzCEWPIiAvSC8h93a
   EpjsJ03SAz9xbd7eBUANWDVAjEA4lJciW99G7f5BjO2tTUa+IFibTizAX
   8IX9grmxn+4rqr8QU8puGDIk4NNF+oo1mGVyTVleYuPIBAfPymTpJ7Rsb
   6SC9zcri9863x5gAIt+mkKdszD3VXMljsmhfM+CnsYWTp1m/jPUun2UVV
   i7Q+QnTB4wrfy8ekbPAmKcSkfLpl3tJeKdpB1nXvG6R7my0HZrLVhsh7n
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10668"; a="341875277"
X-IronPort-AV: E=Sophos;i="5.98,314,1673942400"; 
   d="scan'208";a="341875277"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Apr 2023 02:11:59 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10668"; a="718475984"
X-IronPort-AV: E=Sophos;i="5.98,314,1673942400"; 
   d="scan'208";a="718475984"
Received: from lkp-server01.sh.intel.com (HELO b613635ddfff) ([10.239.97.150])
  by orsmga001.jf.intel.com with ESMTP; 03 Apr 2023 02:11:57 -0700
Received: from kbuild by b613635ddfff with local (Exim 4.96)
        (envelope-from <lkp@intel.com>)
        id 1pjGEG-000O8n-2P;
        Mon, 03 Apr 2023 09:11:56 +0000
Date:   Mon, 3 Apr 2023 17:11:15 +0800
From:   kernel test robot <lkp@intel.com>
To:     Peter Ujfalusi <peter.ujfalusi@linux.intel.com>
Cc:     stable@vger.kernel.org, oe-kbuild-all@lists.linux.dev
Subject: Re: [PATCH for v6.3-rc] ASoC: SOF: ipc4-topology: Clarify bind
 failure caused by missing fw_module
Message-ID: <ZCqYM9z14/FLtT9U@ec83ac1404bb>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230403090909.18233-1-peter.ujfalusi@linux.intel.com>
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
Subject: [PATCH for v6.3-rc] ASoC: SOF: ipc4-topology: Clarify bind failure caused by missing fw_module
Link: https://lore.kernel.org/stable/20230403090909.18233-1-peter.ujfalusi%40linux.intel.com

The check is based on https://www.kernel.org/doc/html/latest/process/stable-kernel-rules.html

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests



