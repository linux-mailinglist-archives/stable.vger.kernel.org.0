Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 732FA5F771B
	for <lists+stable@lfdr.de>; Fri,  7 Oct 2022 12:54:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229514AbiJGKyb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 7 Oct 2022 06:54:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59394 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229454AbiJGKya (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 7 Oct 2022 06:54:30 -0400
Received: from mga06.intel.com (mga06b.intel.com [134.134.136.31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2CBEF74E35
        for <stable@vger.kernel.org>; Fri,  7 Oct 2022 03:54:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1665140069; x=1696676069;
  h=date:from:to:cc:subject:message-id:mime-version:
   in-reply-to;
  bh=Fgqv5wWn1yp2QeJtfkulmaWDvn9L5AP8j3qnAz/ZwWg=;
  b=FOBho9n2qNjrF0f9Sx625GHjd8pnJRAJ6mPUd/Ny3QbGe1ERSWzat6gc
   6WvX2CdocMMIhglQz06u/5kuNAiqSCZivcYh9Bcxx5991cYqwOuznyqG9
   1r9vZfp80asA1QigelpqfugPaPfI54v69PYpdmVuywIzb9euw3SMwi7AT
   r3nP7ScYiQYwha/baqycoyMLtFpsGgUNM/PGRwyhtgO8wR65pyEodBZrD
   rC9kxuKlbZnSydxQTAq0izzq06sRWanP8pU2l8gP/UopV7xjKlIttJsR8
   jxb/7noIaGOXguOY/H5OxqYxfsp/zMWYXsdMmMYlckujN5zQKE26wmvNa
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10492"; a="365649091"
X-IronPort-AV: E=Sophos;i="5.95,166,1661842800"; 
   d="scan'208";a="365649091"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Oct 2022 03:54:28 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10492"; a="602831267"
X-IronPort-AV: E=Sophos;i="5.95,166,1661842800"; 
   d="scan'208";a="602831267"
Received: from lkp-server01.sh.intel.com (HELO 3c15167049b7) ([10.239.97.150])
  by orsmga006.jf.intel.com with ESMTP; 07 Oct 2022 03:54:27 -0700
Received: from kbuild by 3c15167049b7 with local (Exim 4.96)
        (envelope-from <lkp@intel.com>)
        id 1ogkzq-00015H-2y;
        Fri, 07 Oct 2022 10:54:27 +0000
Date:   Fri, 7 Oct 2022 18:53:49 +0800
From:   kernel test robot <lkp@intel.com>
To:     Andrew Chernyakov <acherniakov@astralinux.ru>
Cc:     stable@vger.kernel.org, kbuild-all@lists.01.org
Subject: Re: [PATCH 5.10 1/1] Backport of rpmsg: qcom: glink: replace
 strncpy() with  strscpy_pad()
Message-ID: <Y0AFPdluKIWAG74Q@3ef77ca61dc2>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221007104120.75208-2-acherniakov@astralinux.ru>
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
Subject: [PATCH 5.10 1/1] Backport of rpmsg: qcom: glink: replace strncpy() with  strscpy_pad()
Link: https://lore.kernel.org/stable/20221007104120.75208-2-acherniakov%40astralinux.ru

The check is based on https://www.kernel.org/doc/html/latest/process/stable-kernel-rules.html

-- 
0-DAY CI Kernel Test Service
https://01.org/lkp



