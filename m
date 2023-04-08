Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D29046DB99E
	for <lists+stable@lfdr.de>; Sat,  8 Apr 2023 10:21:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229895AbjDHIVm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 8 Apr 2023 04:21:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55298 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229886AbjDHIVm (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 8 Apr 2023 04:21:42 -0400
Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 26210D31C
        for <stable@vger.kernel.org>; Sat,  8 Apr 2023 01:21:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1680942101; x=1712478101;
  h=date:from:to:cc:subject:message-id:mime-version:
   in-reply-to;
  bh=l5zOmKSasWp+UDAYYwdi8VG1R8gRltk44Tg4eO4wgtk=;
  b=VR0Uv5XAL9hBQS1SgSsSWbtA7jGYE/JBG/S0QnF0wzS1K1jnCHWhHoiT
   THhz2VEMdzloQP7+8fwciIdOWHXngqPEVHb/qZcnkbfh2g5EEmZMhY4vn
   Y754/xrxaeRWqutG1u+o+It+N7DaNjTu1MsFBMAjn1RKjeyUzfBKN5yXE
   fAUJTn5bT9QWPavrl40gmwrgkK9I8UzkhuBj8SCfJP+aHd6R1cbk6M40K
   zhvsnB5z88hoWDjMd/euJHlzp6isLuFYhj7W3iXXhmiLMuY5KQg2y8cCW
   cbdBCW/YIIHK9XTSYebO9gx27k3X7r8yMElQw6pwxBNsDy509IGV2g9+i
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10673"; a="341874551"
X-IronPort-AV: E=Sophos;i="5.98,329,1673942400"; 
   d="scan'208";a="341874551"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Apr 2023 01:21:40 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10673"; a="681237997"
X-IronPort-AV: E=Sophos;i="5.98,329,1673942400"; 
   d="scan'208";a="681237997"
Received: from lkp-server01.sh.intel.com (HELO b613635ddfff) ([10.239.97.150])
  by orsmga007.jf.intel.com with ESMTP; 08 Apr 2023 01:21:39 -0700
Received: from kbuild by b613635ddfff with local (Exim 4.96)
        (envelope-from <lkp@intel.com>)
        id 1pl3pK-000TWb-2s;
        Sat, 08 Apr 2023 08:21:38 +0000
Date:   Sat, 8 Apr 2023 16:21:29 +0800
From:   kernel test robot <lkp@intel.com>
To:     Chen Aotian <chenaotian2@163.com>
Cc:     stable@vger.kernel.org, oe-kbuild-all@lists.linux.dev
Subject: Re: [PATH wpan v2] ieee802154: hwsim: Fix possible memory leaks
Message-ID: <ZDEkCaqKjTbvk93O@ec83ac1404bb>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230408081934.54002-1-chenaotian2@163.com>
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
Subject: [PATH wpan v2] ieee802154: hwsim: Fix possible memory leaks
Link: https://lore.kernel.org/stable/20230408081934.54002-1-chenaotian2%40163.com

The check is based on https://www.kernel.org/doc/html/latest/process/stable-kernel-rules.html

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests



