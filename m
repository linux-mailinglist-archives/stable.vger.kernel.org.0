Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D6D956B383A
	for <lists+stable@lfdr.de>; Fri, 10 Mar 2023 09:11:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230413AbjCJILd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 10 Mar 2023 03:11:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60364 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230417AbjCJIKz (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 10 Mar 2023 03:10:55 -0500
Received: from mga07.intel.com (mga07.intel.com [134.134.136.100])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 683A75B409
        for <stable@vger.kernel.org>; Fri, 10 Mar 2023 00:10:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1678435828; x=1709971828;
  h=date:from:to:cc:subject:message-id:mime-version:
   in-reply-to;
  bh=5z+w57fc5zODylGZ3zk3CkPbrq5nVBSIKRAeXpL/OzU=;
  b=ehumNbm7cZN2ua9zNKoEnNZv38j1WNiY9mGe6W7QirX919WSb3/QKDAN
   fJwc5ZYxBtB+EnOo6JcvOQ5wQrhFKpfzpzi9itIf1hWjf0i1h/dacmtZk
   WYMTQvSnhbtoYjMXllrsqEgOR3SDCws5R0ZUvQ3inH+2qyaPheknY2Sp9
   X15i9Ed6nk7R61vfPpyWUweMHgfK8eYUS4gBQhqvkbkEv7pnquDR0NvQ9
   YVNz8hE4C9d9QrWJCrMYMhWHKmUdT2Jikkf/WFt0zfB0rfE9LcB3Yt9WW
   SMWFCCoxCZADiNwkTVzED9ABNyPu61rVA7os/3qZukvlJTPJ0Ig2/1mNl
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10644"; a="401537140"
X-IronPort-AV: E=Sophos;i="5.98,249,1673942400"; 
   d="scan'208";a="401537140"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Mar 2023 00:09:41 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10644"; a="766748348"
X-IronPort-AV: E=Sophos;i="5.98,249,1673942400"; 
   d="scan'208";a="766748348"
Received: from lkp-server01.sh.intel.com (HELO b613635ddfff) ([10.239.97.150])
  by FMSMGA003.fm.intel.com with ESMTP; 10 Mar 2023 00:09:10 -0800
Received: from kbuild by b613635ddfff with local (Exim 4.96)
        (envelope-from <lkp@intel.com>)
        id 1paXoL-0003ej-29;
        Fri, 10 Mar 2023 08:09:09 +0000
Date:   Fri, 10 Mar 2023 16:09:02 +0800
From:   kernel test robot <lkp@intel.com>
To:     Sasha Finkelstein via B4 Relay 
        <devnull+fnkl.kernel.gmail.com@kernel.org>
Cc:     stable@vger.kernel.org, oe-kbuild-all@lists.linux.dev
Subject: Re: [PATCH RESEND] bluetooth: btbcm: Fix logic error in forming the
 board name.
Message-ID: <ZArlnsW2EfEIMdBP@0f0c699f4fc0>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230224-btbcm-wtf-v1-1-d2dbd7ca7ae4@gmail.com>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE,URIBL_BLOCKED autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi,

Thanks for your patch.

FYI: kernel test robot notices the stable kernel rule is not satisfied.

Rule: 'Cc: stable@vger.kernel.org' or 'commit <sha1> upstream.'
Subject: [PATCH RESEND] bluetooth: btbcm: Fix logic error in forming the board name.
Link: https://lore.kernel.org/stable/20230224-btbcm-wtf-v1-1-d2dbd7ca7ae4%40gmail.com

The check is based on https://www.kernel.org/doc/html/latest/process/stable-kernel-rules.html

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests



