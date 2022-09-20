Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A13FA5BF16F
	for <lists+stable@lfdr.de>; Wed, 21 Sep 2022 01:43:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229598AbiITXnu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 20 Sep 2022 19:43:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40082 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231368AbiITXn3 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 20 Sep 2022 19:43:29 -0400
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 29F33BF5
        for <stable@vger.kernel.org>; Tue, 20 Sep 2022 16:43:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1663717403; x=1695253403;
  h=date:from:to:cc:subject:message-id:mime-version:
   in-reply-to;
  bh=HKVvqo0t+2bPJwuNT6Pa7OZwOBROViLKO7mKkr+I4Ms=;
  b=gRyvZrOmIyCrHR4ndqhsDTt1AZ7HnM012otQi6EiY4jXhTI0UptY1Ol1
   VKsVjPr5/HdPszxNUbufASyfxQpAD8R2pJW/EnrPtuojfxw6ZyiIDy7V9
   eUN36abrylElBoo9XcQZS70A6mP5I4L5H6hCZ399pJQXm2+nX9qwP4DyG
   tu9Q5qwa8m1Ey7LEj7NQ4YZjB5OmJbCK+zSz+OyDv9nS6DZuCV80YmzaE
   D2TDmSurZG3PsDqfXob++CI7fzK0DfsKrOtzVYsJG9R1a15SddhgGh5m3
   Ztp5C6ucwsP1Lff2fsisEh0ktu72oWjesn40aBvOMsiub8Yp+i0AhbCzg
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10476"; a="301244950"
X-IronPort-AV: E=Sophos;i="5.93,331,1654585200"; 
   d="scan'208";a="301244950"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Sep 2022 16:43:19 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.93,331,1654585200"; 
   d="scan'208";a="570292859"
Received: from lkp-server01.sh.intel.com (HELO c0a60f19fe7e) ([10.239.97.150])
  by orsmga003.jf.intel.com with ESMTP; 20 Sep 2022 16:43:18 -0700
Received: from kbuild by c0a60f19fe7e with local (Exim 4.96)
        (envelope-from <lkp@intel.com>)
        id 1oamta-00032n-0N;
        Tue, 20 Sep 2022 23:43:18 +0000
Date:   Wed, 21 Sep 2022 07:42:32 +0800
From:   kernel test robot <lkp@intel.com>
To:     "Maciej W. Rozycki" <macro@orcam.me.uk>
Cc:     stable@vger.kernel.org, kbuild-all@lists.01.org
Subject: Re: [PATCH v2 3/3] serial: 8250: Switch UART port flags to using
 BIT_ULL
Message-ID: <YypP6ASzshtIbr8O@2e39709a3c0e>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.21.2209210007030.41633@angie.orcam.me.uk>
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
Subject: [PATCH v2 3/3] serial: 8250: Switch UART port flags to using BIT_ULL
Link: https://lore.kernel.org/stable/alpine.DEB.2.21.2209210007030.41633%40angie.orcam.me.uk

The check is based on https://www.kernel.org/doc/html/latest/process/stable-kernel-rules.html

-- 
0-DAY CI Kernel Test Service
https://01.org/lkp



