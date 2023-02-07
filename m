Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E661468E151
	for <lists+stable@lfdr.de>; Tue,  7 Feb 2023 20:34:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230260AbjBGTec (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Feb 2023 14:34:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41524 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229836AbjBGTeb (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Feb 2023 14:34:31 -0500
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3A6D53B665
        for <stable@vger.kernel.org>; Tue,  7 Feb 2023 11:34:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1675798471; x=1707334471;
  h=date:from:to:cc:subject:message-id:mime-version:
   in-reply-to;
  bh=IdUD/f1dcDeWmsY/fkz1o45yPvTUbO5WZf1tvtrEa8k=;
  b=ZliLet1uWlydbLCTkOIsQbTjJ1nvpMqWa+ek+ykVrozldvw5DbdE0tDY
   +A2nAhGudJIRicomEab4KoiNvYnyMicR/BF+YZcjA7TcN6ymrJirPt22D
   1m7SaiRW/zR2yfcz8VUTGVVwc7xUOsuVi647U2Qa1vqGK9lmuSd67GUMT
   YwBf0YjrOYq01WVwqr0KRScrV3Nl/8oUqRg1YK3EDkRJPkudbcYwpDvI4
   ojZByp0IL+Dxs5aJcra8qgQcxaP5vegdm1EXQMAn27AXSYliXkXuEotbB
   EqtIbsrWgJO5O+AW5Mq7nVAqhzrvWiSymaSGLc34ravUimB3qUODqNxJH
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10614"; a="330896292"
X-IronPort-AV: E=Sophos;i="5.97,278,1669104000"; 
   d="scan'208";a="330896292"
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Feb 2023 11:34:30 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10614"; a="666957843"
X-IronPort-AV: E=Sophos;i="5.97,278,1669104000"; 
   d="scan'208";a="666957843"
Received: from lkp-server01.sh.intel.com (HELO 4455601a8d94) ([10.239.97.150])
  by orsmga002.jf.intel.com with ESMTP; 07 Feb 2023 11:34:29 -0800
Received: from kbuild by 4455601a8d94 with local (Exim 4.96)
        (envelope-from <lkp@intel.com>)
        id 1pPTjZ-0003p8-0d;
        Tue, 07 Feb 2023 19:34:29 +0000
Date:   Wed, 8 Feb 2023 03:34:09 +0800
From:   kernel test robot <lkp@intel.com>
To:     Ronak Doshi <doshir@vmware.com>
Cc:     stable@vger.kernel.org, oe-kbuild-all@lists.linux.dev
Subject: Re: [PATCH net ] vmxnet3: move rss code block under eop descriptor
Message-ID: <Y+KnsSL57EdGWzwC@a5b9dd7d9a79>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230207192849.2732-1-doshir@vmware.com>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi,

Thanks for your patch.

FYI: kernel test robot notices the stable kernel rule is not satisfied.

Rule: 'Cc: stable@vger.kernel.org' or 'commit <sha1> upstream.'
Subject: [PATCH net ] vmxnet3: move rss code block under eop descriptor
Link: https://lore.kernel.org/stable/20230207192849.2732-1-doshir%40vmware.com

The check is based on https://www.kernel.org/doc/html/latest/process/stable-kernel-rules.html

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests



