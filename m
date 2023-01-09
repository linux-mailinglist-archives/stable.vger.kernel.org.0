Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 619DC661C2D
	for <lists+stable@lfdr.de>; Mon,  9 Jan 2023 02:59:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230449AbjAIB7m (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 8 Jan 2023 20:59:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47442 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233243AbjAIB7k (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 8 Jan 2023 20:59:40 -0500
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 56C7B10077
        for <stable@vger.kernel.org>; Sun,  8 Jan 2023 17:59:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1673229580; x=1704765580;
  h=date:from:to:cc:subject:message-id:mime-version:
   in-reply-to;
  bh=hCmcEr/ASfDMCwvmyC+9aNJzaGADgUDUzOQA6DiBWS4=;
  b=Vz1D0hDMRWiPQkTdG5jN6TIDgsKLwUG3uRCoo0hLjxbd2Jab5lntzQyX
   q2iwbTUm3o3eDkI31R4tBiJTutj/rGLCYY9QtW0etohBz2/9ETwTT43uj
   EjwSagDNmfp4ChsjSjSxmSN62L72jqbVcJOiwzeeV4vXrYgA8R0g8yw2G
   ZNL5xi0w/IGytmMDY5sVWJmdObhocnfjdLrKJg4gKL5EOrdV13a7OUhw7
   jEmA8VfxfDIvHm7JbSDRaa94vrmWv4cUGsqcetkDRD+uqXacL/LkhS88N
   XHEpZLDZAEShh1kXAglJTaGRepBL+F9eXgMhHSwYHJddfbCW0y9MuEkQ7
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10584"; a="322849005"
X-IronPort-AV: E=Sophos;i="5.96,311,1665471600"; 
   d="scan'208";a="322849005"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Jan 2023 17:59:40 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10584"; a="649867581"
X-IronPort-AV: E=Sophos;i="5.96,311,1665471600"; 
   d="scan'208";a="649867581"
Received: from lkp-server02.sh.intel.com (HELO f1920e93ebb5) ([10.239.97.151])
  by orsmga007.jf.intel.com with ESMTP; 08 Jan 2023 17:59:38 -0800
Received: from kbuild by f1920e93ebb5 with local (Exim 4.96)
        (envelope-from <lkp@intel.com>)
        id 1pEhRq-0005yo-0T;
        Mon, 09 Jan 2023 01:59:38 +0000
Date:   Mon, 9 Jan 2023 09:59:34 +0800
From:   kernel test robot <lkp@intel.com>
To:     coolqyj@163.com
Cc:     stable@vger.kernel.org, oe-kbuild-all@lists.linux.dev
Subject: Re: [PATCH] mm/filemap: fix page end in filemap_get_read_batch
Message-ID: <Y7t1Btc4PWz4JAyy@3aeda0d71eb3>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230109015812.47027-1-coolqyj@163.com>
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
Subject: [PATCH] mm/filemap: fix page end in filemap_get_read_batch
Link: https://lore.kernel.org/stable/20230109015812.47027-1-coolqyj%40163.com

The check is based on https://www.kernel.org/doc/html/latest/process/stable-kernel-rules.html

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests



