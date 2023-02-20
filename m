Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B813E69D2BE
	for <lists+stable@lfdr.de>; Mon, 20 Feb 2023 19:29:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230062AbjBTS33 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Feb 2023 13:29:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42624 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229885AbjBTS32 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Feb 2023 13:29:28 -0500
Received: from mga11.intel.com (mga11.intel.com [192.55.52.93])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DB1459EDC
        for <stable@vger.kernel.org>; Mon, 20 Feb 2023 10:29:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1676917767; x=1708453767;
  h=date:from:to:cc:subject:message-id:mime-version:
   in-reply-to;
  bh=f5RO/joC0gXsF+yE2YILF5NEdjaki0fS57mNhKxw3ns=;
  b=abmorufRCLcNdbVs/tV1OFmUK1SGFYS9enhEFXig+I2UUccIilsiJkoU
   Dm9JAU2kbKl9xN8Ie3JaznjBt79a3Z1uqeTt+0jc/AoUeM82uddsAU1p0
   kK8ZvsgACAU17tGGHLUe9DL7n3FthecSLt+hR5jjZV+PfyM6chU0XA9Zp
   c1PQuktCU62+Qooq65VbJVps9yaRrmeaOyEqxH7+io7dkUTU2yfSP72NY
   vF9FxGe+0Bt4WJqrlH7UoR54iWUNZ9eO1mxBgJJ58G5bXi5dRD7slvgY0
   QZ5kKRXUxVBjDv0vVDJB563ghDzPwN1BsxVDVrCxDSoq827HhxZ8yGU7Y
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10627"; a="330180968"
X-IronPort-AV: E=Sophos;i="5.97,313,1669104000"; 
   d="scan'208";a="330180968"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Feb 2023 10:29:27 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10627"; a="648914113"
X-IronPort-AV: E=Sophos;i="5.97,313,1669104000"; 
   d="scan'208";a="648914113"
Received: from lkp-server01.sh.intel.com (HELO 4455601a8d94) ([10.239.97.150])
  by orsmga006.jf.intel.com with ESMTP; 20 Feb 2023 10:29:26 -0800
Received: from kbuild by 4455601a8d94 with local (Exim 4.96)
        (envelope-from <lkp@intel.com>)
        id 1pUAuj-000E6V-1W;
        Mon, 20 Feb 2023 18:29:25 +0000
Date:   Tue, 21 Feb 2023 02:28:31 +0800
From:   kernel test robot <lkp@intel.com>
To:     Josh Poimboeuf <jpoimboe@kernel.org>
Cc:     stable@vger.kernel.org, oe-kbuild-all@lists.linux.dev
Subject: Re: [PATCH] x86/bugs: Allow STIBP with IBRS
Message-ID: <Y/O7z6r6rzcIYN3q@a5b9dd7d9a79>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230220182717.uzrym2gtavlbjbxo@treble>
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
Subject: [PATCH] x86/bugs: Allow STIBP with IBRS
Link: https://lore.kernel.org/stable/20230220182717.uzrym2gtavlbjbxo%40treble

The check is based on https://www.kernel.org/doc/html/latest/process/stable-kernel-rules.html

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests



