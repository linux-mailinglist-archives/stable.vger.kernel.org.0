Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 49701642889
	for <lists+stable@lfdr.de>; Mon,  5 Dec 2022 13:31:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231436AbiLEMbx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 5 Dec 2022 07:31:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36458 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230503AbiLEMbw (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 5 Dec 2022 07:31:52 -0500
Received: from mga06.intel.com (mga06b.intel.com [134.134.136.31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3231117077
        for <stable@vger.kernel.org>; Mon,  5 Dec 2022 04:31:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1670243511; x=1701779511;
  h=date:from:to:cc:subject:message-id:mime-version:
   in-reply-to;
  bh=HiO/bqBJRcdt9+KbkMH9woa2zMBLwh4i0I84oQ9/ADQ=;
  b=RYUYA07VPNP/iKGAnZcaN6M5ZTXcI5fjH+QEST1yRRJYcDIARaK6w1aC
   XU6bS2GcqkZSHR1a6RApwLaZMAsrm19GRBhx5JxYPrXoMgGSqNcGIzXFh
   ux6cKr4iplIx4bBHaMpGK74LFnCy/4WPlywgUR2ZChx8/RSTFKlEJw5KP
   XCK4nr2d47ok6joIj4dxY8EABehUaoFQDHNBzyujk6izi6/KybA6AxP6e
   nvuvlaALR6sBQdAtX0ohjtWWv/sjxixsfADdpFK0dI6Ca0pjM9LsAJs8Y
   c6GY+AwPEFtDMGWiSsIdHCyw4jDmYi4tNQKu/fvrDLA0nkBK+CEOIyIWF
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10551"; a="378493307"
X-IronPort-AV: E=Sophos;i="5.96,219,1665471600"; 
   d="scan'208";a="378493307"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Dec 2022 04:31:50 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10551"; a="788057983"
X-IronPort-AV: E=Sophos;i="5.96,219,1665471600"; 
   d="scan'208";a="788057983"
Received: from lkp-server01.sh.intel.com (HELO b3c45e08cbc1) ([10.239.97.150])
  by fmsmga001.fm.intel.com with ESMTP; 05 Dec 2022 04:31:49 -0800
Received: from kbuild by b3c45e08cbc1 with local (Exim 4.96)
        (envelope-from <lkp@intel.com>)
        id 1p2AdR-00005H-0J;
        Mon, 05 Dec 2022 12:31:49 +0000
Date:   Mon, 5 Dec 2022 20:31:34 +0800
From:   kernel test robot <lkp@intel.com>
To:     Ming Lei <ming.lei@redhat.com>
Cc:     stable@vger.kernel.org, oe-kbuild-all@lists.linux.dev
Subject: Re: [PATCH 5.10.y stable] block: unhash blkdev part inode when the
 part is deleted
Message-ID: <Y43kpjx4rs/6tbSW@0d7994225921>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221205122502.841896-1-ming.lei@redhat.com>
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
Subject: [PATCH 5.10.y stable] block: unhash blkdev part inode when the part is deleted
Link: https://lore.kernel.org/stable/20221205122502.841896-1-ming.lei%40redhat.com

The check is based on https://www.kernel.org/doc/html/latest/process/stable-kernel-rules.html

-- 
0-DAY CI Kernel Test Service
https://01.org/lkp



