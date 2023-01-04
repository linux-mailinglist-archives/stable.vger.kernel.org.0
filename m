Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AE1A765CC23
	for <lists+stable@lfdr.de>; Wed,  4 Jan 2023 04:22:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234251AbjADDWr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Jan 2023 22:22:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35512 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238100AbjADDWp (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 3 Jan 2023 22:22:45 -0500
Received: from mga12.intel.com (mga12.intel.com [192.55.52.136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 199691742B
        for <stable@vger.kernel.org>; Tue,  3 Jan 2023 19:22:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1672802564; x=1704338564;
  h=date:from:to:cc:subject:message-id:mime-version:
   in-reply-to;
  bh=hEiQu5M7KRBrCwlOTg41k2EiCqS+1FDwl6Uwzcfrw/U=;
  b=CrBvnKr8DeQmjIaZ2dBDwXIo5MgYfYPnIpxSc9VjmR7bccYFMiCr0x4H
   679iday56gLJT3d78Zn1BwgyXs4tv+NzJ1f90lQsl94YstP1o1jIzxtKJ
   OoHzsVgDuA0k7zXwM7/NmCaG+jLxTG/kZ8MlKJPo7xaTLprsi5Zoh2fF4
   nZyRRWs96UFb7nwnkBkidcW0og9GisnvHejG6coeRP/dCfMLPuNTAcTIr
   lXKNKO5hliGFoUq+N4RMD2JfLq9Ss+fXguEB9GAz3W8uMIDxVtwhY5tMH
   /OtvN+qC5CnO2yfq/VdKxAa95m5/CFWytM1qam0AZAs+J3hfiBgvObUb4
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10579"; a="301509290"
X-IronPort-AV: E=Sophos;i="5.96,297,1665471600"; 
   d="scan'208";a="301509290"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Jan 2023 19:22:43 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10579"; a="687394038"
X-IronPort-AV: E=Sophos;i="5.96,297,1665471600"; 
   d="scan'208";a="687394038"
Received: from lkp-server01.sh.intel.com (HELO b5d47979f3ad) ([10.239.97.150])
  by orsmga001.jf.intel.com with ESMTP; 03 Jan 2023 19:22:42 -0800
Received: from kbuild by b5d47979f3ad with local (Exim 4.96)
        (envelope-from <lkp@intel.com>)
        id 1pCuMT-000T69-2D;
        Wed, 04 Jan 2023 03:22:41 +0000
Date:   Wed, 4 Jan 2023 11:22:32 +0800
From:   kernel test robot <lkp@intel.com>
To:     coolqyj@163.com
Cc:     stable@vger.kernel.org, oe-kbuild-all@lists.linux.dev
Subject: Re: [PATCH] mm/filemap: fix page end in filemap_get_read_batch
Message-ID: <Y7Tw+Ii0ehUUpNJT@143a5a8bd1f0>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230104032124.72483-1-coolqyj@163.com>
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
Subject: [PATCH] mm/filemap: fix page end in filemap_get_read_batch
Link: https://lore.kernel.org/stable/20230104032124.72483-1-coolqyj%40163.com

The check is based on https://www.kernel.org/doc/html/latest/process/stable-kernel-rules.html

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests



