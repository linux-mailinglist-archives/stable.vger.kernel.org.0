Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 750C05AF3C4
	for <lists+stable@lfdr.de>; Tue,  6 Sep 2022 20:39:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229658AbiIFSiA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 6 Sep 2022 14:38:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39558 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229773AbiIFShx (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 6 Sep 2022 14:37:53 -0400
Received: from mga06.intel.com (mga06b.intel.com [134.134.136.31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2DFC3B6014
        for <stable@vger.kernel.org>; Tue,  6 Sep 2022 11:37:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1662489462; x=1694025462;
  h=date:from:to:cc:subject:message-id:mime-version:
   in-reply-to;
  bh=GfSy3ezT400bvJak5fSiavS//y9X+8+/Aaa3m9vhd9c=;
  b=LP0GLBEiXpdkk2y78INF+0UNCYdAH7RROF83OeLMcixyjkfXS8CKgfoD
   PQ1WQUtE0uTNqmO194i+7WekTMxw87cXmYBZBr3pwq/BZ3q+SUT10yNK5
   nmLWO4vXmTJRJpm6mi2tJ17nTOoF9JrfDokPbSPtVkvZyZSTkBB7eswub
   haNZKw2Tm9mDHn46pIj/p/vwUq2hbYnCju7gYsLbiOvBdcmwDy0qYihFh
   LxyE7gcz12Jx7/fqO97FLiaiW6azHsVb0JA0yqfgy3fcDjYX2nwPI2uES
   T7fIKvBTk0Kar7EKbMCbmwSIWhcuvaidkSSAO5Bt+Tz7gwf9u+am23FHA
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10462"; a="358390166"
X-IronPort-AV: E=Sophos;i="5.93,294,1654585200"; 
   d="scan'208";a="358390166"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Sep 2022 11:37:41 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.93,294,1654585200"; 
   d="scan'208";a="644279100"
Received: from lkp-server02.sh.intel.com (HELO 95dfd251caa2) ([10.239.97.151])
  by orsmga008.jf.intel.com with ESMTP; 06 Sep 2022 11:37:39 -0700
Received: from kbuild by 95dfd251caa2 with local (Exim 4.96)
        (envelope-from <lkp@intel.com>)
        id 1oVdS7-0005TG-0w;
        Tue, 06 Sep 2022 18:37:39 +0000
Date:   Wed, 7 Sep 2022 02:37:36 +0800
From:   kernel test robot <lkp@intel.com>
To:     Varsha Teratipally <teratipally@google.com>
Cc:     stable@vger.kernel.org, kbuild-all@lists.01.org
Subject: Re: [PATCH] xfs: fix up non-directory creation in SGID directories
Message-ID: <YxeTcCVHwVfLW1yL@facefcfb2e4a>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220906183600.1926315-2-teratipally@google.com>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi,

Thanks for your patch.

FYI: kernel test robot notices the stable kernel rule is not satisfied.

Rule: 'Cc: stable@vger.kernel.org' or 'commit <sha1> upstream.'
Subject: [PATCH] xfs: fix up non-directory creation in SGID directories
Link: https://lore.kernel.org/stable/20220906183600.1926315-2-teratipally%40google.com

The check is based on https://www.kernel.org/doc/html/latest/process/stable-kernel-rules.html

-- 
0-DAY CI Kernel Test Service
https://01.org/lkp



