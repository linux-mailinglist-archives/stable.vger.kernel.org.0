Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C4D8F64384B
	for <lists+stable@lfdr.de>; Mon,  5 Dec 2022 23:44:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231934AbiLEWoZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 5 Dec 2022 17:44:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40634 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230035AbiLEWoY (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 5 Dec 2022 17:44:24 -0500
Received: from mga06.intel.com (mga06b.intel.com [134.134.136.31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B5021F59F
        for <stable@vger.kernel.org>; Mon,  5 Dec 2022 14:44:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1670280263; x=1701816263;
  h=date:from:to:cc:subject:message-id:mime-version:
   in-reply-to;
  bh=LrqQqpaEESsz7SewEP8oIKHbeC+IvTF6rSakgpHvfBU=;
  b=fFn0REl94BY60RYPe0zj2Eh9xmQIOroRhYlN77SOSTXONs25CAixIZzC
   YartUUN/siyQLgVbUtsLyzgXZjDRz7EE6NI89lGme6EXKtLwLu8k+XhHq
   o2nzZLqR47Jw2XkW+O25hMSiWA3mMACaSiDLCE2qjiiNMVwIiFh12sii0
   vHX/BJz4A6QR+/W8cVhiwaT8RYEwPD/0cWqFZWEoX020tU5UZDyYrrP+H
   vlp03etVqY8egzikflW63BrJLaRnrQxK9K5zXNQEf0aBZoKxwqwBHtOXf
   CCDhz5spsgaZLEZgtrwaNrOvcC7W/tCGqt4bVy5FR0rAXfV/Kvlm9VGbR
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10552"; a="378644565"
X-IronPort-AV: E=Sophos;i="5.96,220,1665471600"; 
   d="scan'208";a="378644565"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Dec 2022 14:44:23 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10552"; a="752382239"
X-IronPort-AV: E=Sophos;i="5.96,220,1665471600"; 
   d="scan'208";a="752382239"
Received: from lkp-server01.sh.intel.com (HELO b3c45e08cbc1) ([10.239.97.150])
  by fmsmga002.fm.intel.com with ESMTP; 05 Dec 2022 14:44:21 -0800
Received: from kbuild by b3c45e08cbc1 with local (Exim 4.96)
        (envelope-from <lkp@intel.com>)
        id 1p2KCD-0000ON-05;
        Mon, 05 Dec 2022 22:44:21 +0000
Date:   Tue, 6 Dec 2022 06:43:49 +0800
From:   kernel test robot <lkp@intel.com>
To:     Ronak Doshi <doshir@vmware.com>
Cc:     stable@vger.kernel.org, oe-kbuild-all@lists.linux.dev
Subject: Re: [PATCH v2 net  2/2] vmxnet3: use correct intrConf reference when
 using extended queues
Message-ID: <Y450JZe6JIyWTFm/@0d7994225921>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221205224256.22830-3-doshir@vmware.com>
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
Subject: [PATCH v2 net  2/2] vmxnet3: use correct intrConf reference when using extended queues
Link: https://lore.kernel.org/stable/20221205224256.22830-3-doshir%40vmware.com

The check is based on https://www.kernel.org/doc/html/latest/process/stable-kernel-rules.html

-- 
0-DAY CI Kernel Test Service
https://01.org/lkp



