Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4D04C5BB187
	for <lists+stable@lfdr.de>; Fri, 16 Sep 2022 19:15:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229515AbiIPRPO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 16 Sep 2022 13:15:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44792 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229510AbiIPRPN (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 16 Sep 2022 13:15:13 -0400
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 370CD3DBF2
        for <stable@vger.kernel.org>; Fri, 16 Sep 2022 10:15:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1663348512; x=1694884512;
  h=date:from:to:cc:subject:message-id:mime-version:
   in-reply-to;
  bh=TiG71hSSNG76uSTPd3kDDaTIb40JUbGrl7Z/Zi9RV8w=;
  b=nieNqYZ24pFsaFRI+GMG03WiU9qESDoTLvn9t0d4Z+b87QqXEmcsOqMu
   A8Wvu3gy4Y55pAsVB3AfnyJfky4D5eX43o76aJtt05jzOzpKHMrzacNHo
   eXyidSntKDeVHwpQzaz4twsl+7o6ujQjCVxXxN2tLnKL6DmsCjOneqB9t
   04LZj/MoAXE1WWWITtXE9dX299hBZ0ht6rhHTfWmCCcFQX0LR3PCXCySv
   KUh8H7NqZZjHPRq1fTL+EjI35E6ZAHGyUzX0fl4z9/fwpHhzbXSRT0pMa
   lBqiSuvZ84k4vqXrfyxuFO457JNvvnSvqpIRXz+BfaXrGZLIaHmK9BUFc
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10472"; a="299860718"
X-IronPort-AV: E=Sophos;i="5.93,320,1654585200"; 
   d="scan'208";a="299860718"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Sep 2022 10:15:11 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.93,320,1654585200"; 
   d="scan'208";a="650939290"
Received: from lkp-server02.sh.intel.com (HELO 41300c7200ea) ([10.239.97.151])
  by orsmga001.jf.intel.com with ESMTP; 16 Sep 2022 10:15:10 -0700
Received: from kbuild by 41300c7200ea with local (Exim 4.96)
        (envelope-from <lkp@intel.com>)
        id 1oZEvm-0001zA-0v;
        Fri, 16 Sep 2022 17:15:10 +0000
Date:   Sat, 17 Sep 2022 01:14:27 +0800
From:   kernel test robot <lkp@intel.com>
To:     Martin Rodriguez Reboredo <yakoyoku@gmail.com>
Cc:     stable@vger.kernel.org, kbuild-all@lists.01.org
Subject: Re: [PATCH stable 5.19] kbuild: Add skip_encoding_btf_enum64 option
 to pahole
Message-ID: <YySu8wg7kKiNfG+Z@facefcfb2e4a>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220916171234.841556-1-yakoyoku@gmail.com>
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
Subject: [PATCH stable 5.19] kbuild: Add skip_encoding_btf_enum64 option to pahole
Link: https://lore.kernel.org/stable/20220916171234.841556-1-yakoyoku%40gmail.com

The check is based on https://www.kernel.org/doc/html/latest/process/stable-kernel-rules.html

-- 
0-DAY CI Kernel Test Service
https://01.org/lkp



