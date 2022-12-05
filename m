Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3773D642968
	for <lists+stable@lfdr.de>; Mon,  5 Dec 2022 14:29:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232091AbiLEN3y (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 5 Dec 2022 08:29:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54752 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231149AbiLEN3x (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 5 Dec 2022 08:29:53 -0500
Received: from mga12.intel.com (mga12.intel.com [192.55.52.136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ED02EE4C
        for <stable@vger.kernel.org>; Mon,  5 Dec 2022 05:29:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1670246992; x=1701782992;
  h=date:from:to:cc:subject:message-id:mime-version:
   in-reply-to;
  bh=tYLhhn4pAQ6YWEivABYcF9aSMn3UnEaXEeCLPnJZ+VY=;
  b=QiyyaK8JMD3w4Ujiu87IcgGGMdTpXbpJrWXOd22Vrp2+ujotGClTsiwR
   WLQ8LdG9gKvpFIj7eBElcaiyv96BqtWQ4YFgBX02fsYlfyo5VGcyRm1V0
   pNJTI7B5Vish3AvWwLQyPIKpVf0oVDJ6mdSgQnodfoqP9Izva7mWqg98d
   TrTkoIEHVL3De+hfrsfqihTHcO3tFoGWofL+y9VA2swiMoWT1bMMesv9z
   JmsLLG1vzlJ6nykCiQftkpYUw6odRKeapczi2REVk56dwhPpuF6d+vmBg
   nVyoY9sQs6hHPGb929xLkfbhhROExtWXjlDAKkxcZPC8cb77s6OxjvAvH
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10551"; a="296041232"
X-IronPort-AV: E=Sophos;i="5.96,219,1665471600"; 
   d="scan'208";a="296041232"
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Dec 2022 05:29:52 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10551"; a="647940809"
X-IronPort-AV: E=Sophos;i="5.96,219,1665471600"; 
   d="scan'208";a="647940809"
Received: from lkp-server01.sh.intel.com (HELO b3c45e08cbc1) ([10.239.97.150])
  by fmsmga007.fm.intel.com with ESMTP; 05 Dec 2022 05:29:51 -0800
Received: from kbuild by b3c45e08cbc1 with local (Exim 4.96)
        (envelope-from <lkp@intel.com>)
        id 1p2BXb-00008K-0X;
        Mon, 05 Dec 2022 13:29:51 +0000
Date:   Mon, 5 Dec 2022 21:29:21 +0800
From:   kernel test robot <lkp@intel.com>
To:     Ming Lei <ming.lei@redhat.com>
Cc:     stable@vger.kernel.org, oe-kbuild-all@lists.linux.dev
Subject: Re: [PATCH 5.10.y stable v2] block: unhash blkdev part inode when
 the part is deleted
Message-ID: <Y43yMYuLMXq4EQMO@0d7994225921>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221205132739.844399-1-ming.lei@redhat.com>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi,

Thanks for your patch.

FYI: kernel test robot notices the stable kernel rule is not satisfied.

Rule: 'Cc: stable@vger.kernel.org' or 'commit <sha1> upstream.'
Subject: [PATCH 5.10.y stable v2] block: unhash blkdev part inode when the part is deleted
Link: https://lore.kernel.org/stable/20221205132739.844399-1-ming.lei%40redhat.com

The check is based on https://www.kernel.org/doc/html/latest/process/stable-kernel-rules.html

-- 
0-DAY CI Kernel Test Service
https://01.org/lkp



