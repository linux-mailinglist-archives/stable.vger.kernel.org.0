Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2918469F36A
	for <lists+stable@lfdr.de>; Wed, 22 Feb 2023 12:24:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230109AbjBVLYw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 22 Feb 2023 06:24:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49066 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231915AbjBVLY3 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 22 Feb 2023 06:24:29 -0500
Received: from mga11.intel.com (mga11.intel.com [192.55.52.93])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 95C353929B
        for <stable@vger.kernel.org>; Wed, 22 Feb 2023 03:24:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1677065058; x=1708601058;
  h=date:from:to:cc:subject:message-id:mime-version:
   in-reply-to;
  bh=NrpDAn4F4TO5JZB0hlyUQr9Nzum65oGQ/vOmrgvMTi8=;
  b=QF3DH/JCf1nDtqZvZ32uKaf3a4ew0if9VtsUMFQfYXl8BNvZ+H4SPmG9
   i7b8u7sUTWNGmLtoGhOLtgcXG6JpmrDlnDN1M0RHPTcRNmBhz2j9ksfi8
   /mmOBN/WA5PBSZh4+ZX8PtrLNXp8OFXhOoRv2W7yQxA0KVPS5ejdylAea
   3rmzjVP61DwqYl9ih29LamLdEyXDUUhvAFTy4bMMP26fsxafYI/yOehOo
   073KN4vlAZ1yUO+CZthB5xQagDliKt7VzAakIbozHsgMTfzj9qd3Q7YNH
   g8BtZDBMhgZbu6r41YZQGHyGAtKkocQlBCMA40td4rTvcPZ+o8OA2yEWG
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10628"; a="330626544"
X-IronPort-AV: E=Sophos;i="5.97,318,1669104000"; 
   d="scan'208";a="330626544"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Feb 2023 03:24:12 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10628"; a="760926308"
X-IronPort-AV: E=Sophos;i="5.97,318,1669104000"; 
   d="scan'208";a="760926308"
Received: from lkp-server01.sh.intel.com (HELO 3895f5c55ead) ([10.239.97.150])
  by FMSMGA003.fm.intel.com with ESMTP; 22 Feb 2023 03:24:11 -0800
Received: from kbuild by 3895f5c55ead with local (Exim 4.96)
        (envelope-from <lkp@intel.com>)
        id 1pUnEI-0000Ib-1i;
        Wed, 22 Feb 2023 11:24:10 +0000
Date:   Wed, 22 Feb 2023 19:23:44 +0800
From:   kernel test robot <lkp@intel.com>
To:     maennich@google.com
Cc:     stable@vger.kernel.org, oe-kbuild-all@lists.linux.dev
Subject: Re: [PATCH 1/5] MAINTAINERS: Add scripts/pahole-flags.sh to BPF
 section
Message-ID: <Y/X7QOnBbFGjm5vV@f839a3c1ca0d>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230222112141.278066-2-maennich@google.com>
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
Subject: [PATCH 1/5] MAINTAINERS: Add scripts/pahole-flags.sh to BPF section
Link: https://lore.kernel.org/stable/20230222112141.278066-2-maennich%40google.com

The check is based on https://www.kernel.org/doc/html/latest/process/stable-kernel-rules.html

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests



