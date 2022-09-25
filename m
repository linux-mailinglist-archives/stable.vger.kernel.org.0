Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 00CEC5E9228
	for <lists+stable@lfdr.de>; Sun, 25 Sep 2022 12:37:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231906AbiIYKhO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 25 Sep 2022 06:37:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33984 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231981AbiIYKgt (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 25 Sep 2022 06:36:49 -0400
Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CB28C2DA87
        for <stable@vger.kernel.org>; Sun, 25 Sep 2022 03:36:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1664102207; x=1695638207;
  h=date:from:to:cc:subject:message-id:mime-version:
   in-reply-to;
  bh=C1h0jPzFYp5ppB3UY3wpJoLF3nVGgo06vdfroiC1WN4=;
  b=cDf2Ko4k2ztrIQJjZXMe3e1qGSiqcoDtye5lVlwJ1X1j0N3eirQJ08Ck
   X4V2nW5SYxQUAGSC54fK0qQ9hVzAF4YLSPoxQsUZXcKcbCD5nJsr2Th54
   IHGAYHltRFHV9x9byUIDwdYq50tmOSwnWVjPLGRER5ow4KXptgDJWKAXD
   AJoGoiG16Yum6UKUHd9T31CDCNdFqERE/97/d2IoD0VbsQLmHrvbB5pHG
   4Jz/6og7pVAwIAsojzWpyRlWQidlBwAkiVFlSAZoTHeVVKZ7KXpl2Jjg4
   7OsJOLlvbF5KlF5ADYazzo/lKLObWxuEa5YuFCMvHofvn1/+tCpujrsSS
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10480"; a="387141453"
X-IronPort-AV: E=Sophos;i="5.93,344,1654585200"; 
   d="scan'208";a="387141453"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Sep 2022 03:36:47 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.93,344,1654585200"; 
   d="scan'208";a="763127520"
Received: from lkp-server01.sh.intel.com (HELO c0a60f19fe7e) ([10.239.97.150])
  by fmsmga001.fm.intel.com with ESMTP; 25 Sep 2022 03:36:46 -0700
Received: from kbuild by c0a60f19fe7e with local (Exim 4.96)
        (envelope-from <lkp@intel.com>)
        id 1ocP09-0007pZ-2I;
        Sun, 25 Sep 2022 10:36:45 +0000
Date:   Sun, 25 Sep 2022 18:36:39 +0800
From:   kernel test robot <lkp@intel.com>
To:     wangyong <yongw.pur@gmail.com>
Cc:     stable@vger.kernel.org, kbuild-all@lists.01.org
Subject: Re: [PATCH v2 stable-4.19 1/3] mm/page_alloc: use ac->high_zoneidx
 for classzone_idx
Message-ID: <YzAvN5avDk6Knx5P@320659cf58f4>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220925103529.13716-2-yongw.pur@gmail.com>
X-Spam-Status: No, score=-4.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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
Subject: [PATCH v2 stable-4.19 1/3] mm/page_alloc: use ac->high_zoneidx for classzone_idx
Link: https://lore.kernel.org/stable/20220925103529.13716-2-yongw.pur%40gmail.com

The check is based on https://www.kernel.org/doc/html/latest/process/stable-kernel-rules.html

-- 
0-DAY CI Kernel Test Service
https://01.org/lkp



