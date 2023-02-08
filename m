Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 029DE68E60C
	for <lists+stable@lfdr.de>; Wed,  8 Feb 2023 03:26:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229457AbjBHC0v (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Feb 2023 21:26:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46718 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229695AbjBHC0u (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Feb 2023 21:26:50 -0500
Received: from mga17.intel.com (mga17.intel.com [192.55.52.151])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5C85546B9
        for <stable@vger.kernel.org>; Tue,  7 Feb 2023 18:26:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1675823207; x=1707359207;
  h=date:from:to:cc:subject:message-id:mime-version:
   in-reply-to;
  bh=3x7uSzC4CDKmwnSD23oNR+JAtTnvTVeeqvk4Or4ncGA=;
  b=TVBO54IyVECWlnfuvYTaUWT9oZ+3beU0ezJyG05D796xzlAZ8ymwsm2j
   aOCwS3cg+681WdpKOcgBbxB5hUqsRq303QOf4iDtc7WlIy0xE9CPwRr0+
   28uTIp9vrDJ2+KvQoG8C1yH70ZzFqwLk5yH3wQkru0Jz5e3l8vPGMp/Zy
   WJx9IOyIRTp2hVy6/nSzqE18KuThS4Ukn9M8cZ8BCTYrcGjjLW/sfzrk7
   d+trhDM9qQR9vHcbWzrtNqdCqnpe0D/VO4bUolC2aFivsQzeAtdQsqHcI
   8Msc8mqD5oo+SG6j1TqJt4ZpVLjOVtp7440wWTt7wPxtdozoQybs2oUPl
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10614"; a="310037096"
X-IronPort-AV: E=Sophos;i="5.97,279,1669104000"; 
   d="scan'208";a="310037096"
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Feb 2023 18:26:46 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10614"; a="735763480"
X-IronPort-AV: E=Sophos;i="5.97,279,1669104000"; 
   d="scan'208";a="735763480"
Received: from lkp-server01.sh.intel.com (HELO 4455601a8d94) ([10.239.97.150])
  by fmsmga004.fm.intel.com with ESMTP; 07 Feb 2023 18:26:45 -0800
Received: from kbuild by 4455601a8d94 with local (Exim 4.96)
        (envelope-from <lkp@intel.com>)
        id 1pPaAW-00044s-2Y;
        Wed, 08 Feb 2023 02:26:44 +0000
Date:   Wed, 8 Feb 2023 10:26:04 +0800
From:   kernel test robot <lkp@intel.com>
To:     coolqyj@163.com
Cc:     stable@vger.kernel.org, oe-kbuild-all@lists.linux.dev
Subject: Re: [PATCH] [PATCH V2] mm/filemap: fix page end in
 filemap_get_read_batch
Message-ID: <Y+MIPHQJFiZ+uEu/@a5b9dd7d9a79>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230208022400.28962-1-coolqyj@163.com>
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
Subject: [PATCH] [PATCH V2] mm/filemap: fix page end in filemap_get_read_batch
Link: https://lore.kernel.org/stable/20230208022400.28962-1-coolqyj%40163.com

The check is based on https://www.kernel.org/doc/html/latest/process/stable-kernel-rules.html

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests



