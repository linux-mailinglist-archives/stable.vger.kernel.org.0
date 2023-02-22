Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 336B969FC3B
	for <lists+stable@lfdr.de>; Wed, 22 Feb 2023 20:30:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231214AbjBVTap (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 22 Feb 2023 14:30:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37110 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229756AbjBVTao (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 22 Feb 2023 14:30:44 -0500
Received: from mga12.intel.com (mga12.intel.com [192.55.52.136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5E8C73A853
        for <stable@vger.kernel.org>; Wed, 22 Feb 2023 11:30:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1677094231; x=1708630231;
  h=date:from:to:cc:subject:message-id:mime-version:
   in-reply-to;
  bh=QfUt1PgDBqn0coMx99OdE6cCnPnWz3BFGJxuYsipLy8=;
  b=FxQwYYhAhiaYYmEf4Hi4VREJL5JJx4XlbNrFTGu6SGrvrGaJUkBApxVC
   IFw+8jTBGH444DgvlfCxFNM0n6xqCglIgw1bBZuYVwyyEsaBL4/uWQTac
   KNwOyQIrNO8ksck6fmxERuCoplXVdoYy75vlQolvmBAbBTnJTN/8pMsCb
   kGbJA7JCgY9OjljWKtBD133G/HXC2MSVvioY1eN/EscJjh3k8R+qtTTAi
   6SISLTTp+O+RuwEShp0UMShNySatk4JXxO9GFTV9ihh6j7mWl2VxRYB2b
   ghBSJiOiRBPk7EFac/q0qcHbq2mEQxpx9GLo8yFg2TwpFZafNegaMAgwl
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10629"; a="312647380"
X-IronPort-AV: E=Sophos;i="5.97,319,1669104000"; 
   d="scan'208";a="312647380"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Feb 2023 11:30:30 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10629"; a="1001106550"
X-IronPort-AV: E=Sophos;i="5.97,319,1669104000"; 
   d="scan'208";a="1001106550"
Received: from lkp-server01.sh.intel.com (HELO 3895f5c55ead) ([10.239.97.150])
  by fmsmga005.fm.intel.com with ESMTP; 22 Feb 2023 11:30:30 -0800
Received: from kbuild by 3895f5c55ead with local (Exim 4.96)
        (envelope-from <lkp@intel.com>)
        id 1pUuov-0000gC-1I;
        Wed, 22 Feb 2023 19:30:29 +0000
Date:   Thu, 23 Feb 2023 03:30:19 +0800
From:   kernel test robot <lkp@intel.com>
To:     Edward Liaw <edliaw@google.com>
Cc:     stable@vger.kernel.org, oe-kbuild-all@lists.linux.dev
Subject: Re: [PATCH 4.14 v2 1/4] bpf: Do not use ax register in interpreter
 on div/mod
Message-ID: <Y/ZtS1X2XEZ31pvB@f839a3c1ca0d>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230222192925.1778183-2-edliaw@google.com>
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
Subject: [PATCH 4.14 v2 1/4] bpf: Do not use ax register in interpreter on div/mod
Link: https://lore.kernel.org/stable/20230222192925.1778183-2-edliaw%40google.com

The check is based on https://www.kernel.org/doc/html/latest/process/stable-kernel-rules.html

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests



