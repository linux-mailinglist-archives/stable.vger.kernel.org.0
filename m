Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0CEAA6DBE4E
	for <lists+stable@lfdr.de>; Sun,  9 Apr 2023 04:24:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229436AbjDICYX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 8 Apr 2023 22:24:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34176 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229446AbjDICYW (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 8 Apr 2023 22:24:22 -0400
Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4A3E35243
        for <stable@vger.kernel.org>; Sat,  8 Apr 2023 19:24:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1681007062; x=1712543062;
  h=date:from:to:cc:subject:message-id:mime-version:
   in-reply-to;
  bh=5cXp/UETmgZUxg/Kvhm8EcBgAyXOBBw5N36N/zux0N0=;
  b=KmCxVIs6/lGjDvoDb9iq2Su7ow8jg7XZkCfDeKhnp7QiVdPYWOB3e3p3
   Agu7tzTRFTI5Eiev7RyG/NE3R4ORlRGl9Rx/YmykSlYOMKbMn/pzYEdVN
   wRezG4GpjhpVlMrjpEsPMovnXXJmZwR8fb9nR7R8m8tA5eA5AOmue2Xd9
   jVgEZitDfk5W4QzjcHlgEb9ssdDLb3m3UipKfdku4aT9Ez1sD9tAykXyo
   WM+2JOVGiqYajyqbkzohWkpwkAXA5HGxfeiNgVe6gWpghYGFDq5A26CGD
   mYzlrbYdh6OAOekRi6eLJx2xVYPD6bHX8JcAn9G9qyNAYE6kq0a9YMvG2
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10674"; a="341932742"
X-IronPort-AV: E=Sophos;i="5.98,330,1673942400"; 
   d="scan'208";a="341932742"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Apr 2023 19:24:21 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10674"; a="799100074"
X-IronPort-AV: E=Sophos;i="5.98,330,1673942400"; 
   d="scan'208";a="799100074"
Received: from lkp-server01.sh.intel.com (HELO b613635ddfff) ([10.239.97.150])
  by fmsmga002.fm.intel.com with ESMTP; 08 Apr 2023 19:24:20 -0700
Received: from kbuild by b613635ddfff with local (Exim 4.96)
        (envelope-from <lkp@intel.com>)
        id 1plKj6-000UHx-0L;
        Sun, 09 Apr 2023 02:24:20 +0000
Date:   Sun, 9 Apr 2023 10:23:26 +0800
From:   kernel test robot <lkp@intel.com>
To:     Chen Aotian <chenaotian2@163.com>
Cc:     stable@vger.kernel.org, oe-kbuild-all@lists.linux.dev
Subject: Re: [PATH wpan v3] ieee802154: hwsim: Fix possible memory leaks
Message-ID: <ZDIhnvA98VPDpyBC@ec83ac1404bb>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230409022048.61223-1-chenaotian2@163.com>
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
Subject: [PATH wpan v3] ieee802154: hwsim: Fix possible memory leaks
Link: https://lore.kernel.org/stable/20230409022048.61223-1-chenaotian2%40163.com

The check is based on https://www.kernel.org/doc/html/latest/process/stable-kernel-rules.html

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests



