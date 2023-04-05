Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EF8ED6D7BD8
	for <lists+stable@lfdr.de>; Wed,  5 Apr 2023 13:46:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237866AbjDELqJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 5 Apr 2023 07:46:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59670 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237961AbjDELqF (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 5 Apr 2023 07:46:05 -0400
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5F1BC6182
        for <stable@vger.kernel.org>; Wed,  5 Apr 2023 04:45:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1680695146; x=1712231146;
  h=date:from:to:cc:subject:message-id:mime-version:
   in-reply-to;
  bh=HYktaKliGryaxGLKYhBAT0GfBTGVypPqih5kQf6VQdk=;
  b=RWlEbmMflYkAxdWk5dqNkap608AR+ptXXbPtEqKKEP+W+wwResSgFqiA
   5TOnI2Wrv8tLeZjoP2ClLyfN1Es518Jj9cCKMX6M+DtFUNfnN0ASW1Tq+
   24OU+dRyhm7DRpnCWwTwxx+qSE7YP5jG8giWAqw9u12HRYrwX95o+agFw
   llUIwSP1yaR/24kKVFEv/EBiHW//khzW0XwbhvFHGx1vTdd9L2eDRdYHB
   Cvi9mvdnEdBUmvzXWVD10zhUvFjKOgNnHecV9VJkU+povdVquVJ23Gccj
   puE29+as4NDmwB+XMHqKiRcq48vZiKEs0BR/XqTNjQq9TJfdjirCIQhyZ
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10670"; a="345009927"
X-IronPort-AV: E=Sophos;i="5.98,319,1673942400"; 
   d="scan'208";a="345009927"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Apr 2023 04:45:12 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10670"; a="680253498"
X-IronPort-AV: E=Sophos;i="5.98,319,1673942400"; 
   d="scan'208";a="680253498"
Received: from lkp-server01.sh.intel.com (HELO b613635ddfff) ([10.239.97.150])
  by orsmga007.jf.intel.com with ESMTP; 05 Apr 2023 04:45:11 -0700
Received: from kbuild by b613635ddfff with local (Exim 4.96)
        (envelope-from <lkp@intel.com>)
        id 1pk1Ze-000QVK-1L;
        Wed, 05 Apr 2023 11:45:10 +0000
Date:   Wed, 5 Apr 2023 19:44:38 +0800
From:   kernel test robot <lkp@intel.com>
To:     Pratyush Yadav <ptyadav@amazon.de>
Cc:     stable@vger.kernel.org, oe-kbuild-all@lists.linux.dev
Subject: Re: [PATCH 5.4] cifs/smb3: Fix NULL pointer dereference in
 smb2_query_info_compound()
Message-ID: <ZC1fJiHvpbXcysXi@ec83ac1404bb>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230405114220.108739-1-ptyadav@amazon.de>
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi,

Thanks for your patch.

FYI: kernel test robot notices the stable kernel rule is not satisfied.

Rule: 'Cc: stable@vger.kernel.org' or 'commit <sha1> upstream.'
Subject: [PATCH 5.4] cifs/smb3: Fix NULL pointer dereference in smb2_query_info_compound()
Link: https://lore.kernel.org/stable/20230405114220.108739-1-ptyadav%40amazon.de

The check is based on https://www.kernel.org/doc/html/latest/process/stable-kernel-rules.html

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests



