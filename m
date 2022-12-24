Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1D9C7655916
	for <lists+stable@lfdr.de>; Sat, 24 Dec 2022 09:13:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229541AbiLXINl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 24 Dec 2022 03:13:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56366 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230073AbiLXINi (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 24 Dec 2022 03:13:38 -0500
Received: from mga06.intel.com (mga06b.intel.com [134.134.136.31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 47C39DF43
        for <stable@vger.kernel.org>; Sat, 24 Dec 2022 00:13:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1671869618; x=1703405618;
  h=date:from:to:cc:subject:message-id:mime-version:
   in-reply-to;
  bh=n9UIn0gp6wXIjJ6U5Zqlb8UO/bmOZiFQMTGme/Q2mpw=;
  b=CnbIPxkB3xfLScWk7t8U4iGP4/TtUugm35LVB8OB9un5LyGRsP3WyrkX
   2ovqRxGtuR4vS8VDGEYqFCDCccml4l+CuuEDd4Vq3GBCZwyDebozOyQlW
   TtanPB6A+s6MfbjaSYCFUmUUB6Zqb+gERpoine4ucBRlRX0pGm2DwaXga
   cs6vpTK6wNewGIZB5LsSG7AzbHRaLwKTVWx0kFgLmii1XGjnfd5BF2k74
   TyveuOLMY447QVSB8+XDIC4A83FsBa9GkB3sP+cOaoSSsYFl98NuOMiXn
   myVLd/iL1qiLToyFZJN2I+0eukg2HBY0zbRkOM/qcbr8xDxT4BAk0XxHL
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10570"; a="382679198"
X-IronPort-AV: E=Sophos;i="5.96,270,1665471600"; 
   d="scan'208";a="382679198"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Dec 2022 00:13:37 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10570"; a="682905779"
X-IronPort-AV: E=Sophos;i="5.96,270,1665471600"; 
   d="scan'208";a="682905779"
Received: from lkp-server01.sh.intel.com (HELO b5d47979f3ad) ([10.239.97.150])
  by orsmga008.jf.intel.com with ESMTP; 24 Dec 2022 00:13:36 -0800
Received: from kbuild by b5d47979f3ad with local (Exim 4.96)
        (envelope-from <lkp@intel.com>)
        id 1p8zex-000DFb-37;
        Sat, 24 Dec 2022 08:13:35 +0000
Date:   Sat, 24 Dec 2022 16:13:30 +0800
From:   kernel test robot <lkp@intel.com>
To:     Zach O'Keefe <zokeefe@google.com>
Cc:     stable@vger.kernel.org, oe-kbuild-all@lists.linux.dev
Subject: Re: [PATCH v2 1/2] mm/MADV_COLLAPSE: don't expand collapse when
 vm_end is past requested end
Message-ID: <Y6a0qplz7zoXOfp3@181616e551cc>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221224081203.3193960-1-zokeefe@google.com>
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
Subject: [PATCH v2 1/2] mm/MADV_COLLAPSE: don't expand collapse when vm_end is past requested end
Link: https://lore.kernel.org/stable/20221224081203.3193960-1-zokeefe%40google.com

The check is based on https://www.kernel.org/doc/html/latest/process/stable-kernel-rules.html

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests



