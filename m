Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 76C1462E62D
	for <lists+stable@lfdr.de>; Thu, 17 Nov 2022 21:55:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235022AbiKQUzQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 17 Nov 2022 15:55:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45400 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239207AbiKQUzP (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 17 Nov 2022 15:55:15 -0500
Received: from mga06.intel.com (mga06b.intel.com [134.134.136.31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 815715ADDD
        for <stable@vger.kernel.org>; Thu, 17 Nov 2022 12:55:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1668718514; x=1700254514;
  h=date:from:to:cc:subject:message-id:mime-version:
   in-reply-to;
  bh=rDu+aQsStATdBBjnXPADjtc+xwJugK85m3JMNUEHqY8=;
  b=AXmyq5XNzl4ihM5hOvrZtxGthgi+7XXvrQ+GQ6hdB3S9WcEkiwzSjTYX
   HYK+L+Djl+qdFPoUpbw7QgPaG47v1wXO49aZSvq6Ni0rFCD9xD/YRnc/K
   aLrjcu2Mvo4HmUaSjFd6r7AnNw3Bd33fg0nEvXC7SIue3/08eIolWEaD0
   u+6lYUMQ81ZW7AfKxeBmm3c7m2plmdvh+nsX2KK0yxilPFZ8tod/eAztu
   NHeyrW1MJ0hOJQzqd+LNba2goQyeAC4h8E5PMDmY1j/2zp8pi7RiEr9yl
   VUU9CbWsjpfNh5ADYuMvFFrfxewQS54p9rBe9kiCfQgqUZtwSiUeOjL3x
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10534"; a="375102822"
X-IronPort-AV: E=Sophos;i="5.96,172,1665471600"; 
   d="scan'208";a="375102822"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Nov 2022 12:55:13 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10534"; a="728975937"
X-IronPort-AV: E=Sophos;i="5.96,172,1665471600"; 
   d="scan'208";a="728975937"
Received: from lkp-server01.sh.intel.com (HELO 55744f5052f8) ([10.239.97.150])
  by FMSMGA003.fm.intel.com with ESMTP; 17 Nov 2022 12:55:12 -0800
Received: from kbuild by 55744f5052f8 with local (Exim 4.96)
        (envelope-from <lkp@intel.com>)
        id 1ovluh-0000dL-31;
        Thu, 17 Nov 2022 20:55:11 +0000
Date:   Fri, 18 Nov 2022 04:54:55 +0800
From:   kernel test robot <lkp@intel.com>
To:     Ferry Toth <ftoth@exalondelft.nl>
Cc:     stable@vger.kernel.org, oe-kbuild-all@lists.linux.dev
Subject: Re: [PATCH v3 2/2] usb: dwc3: core: defer probe on ulpi_read_id
 timeout
Message-ID: <Y3afn82u6x4RpPZs@916a7fd48d89>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221117205411.11489-3-ftoth@exalondelft.nl>
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
Subject: [PATCH v3 2/2] usb: dwc3: core: defer probe on ulpi_read_id timeout
Link: https://lore.kernel.org/stable/20221117205411.11489-3-ftoth%40exalondelft.nl

The check is based on https://www.kernel.org/doc/html/latest/process/stable-kernel-rules.html

-- 
0-DAY CI Kernel Test Service
https://01.org/lkp



