Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3EF1B20745A
	for <lists+stable@lfdr.de>; Wed, 24 Jun 2020 15:21:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388123AbgFXNVN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Jun 2020 09:21:13 -0400
Received: from mga06.intel.com ([134.134.136.31]:18944 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387687AbgFXNVN (ORCPT <rfc822;Stable@vger.kernel.org>);
        Wed, 24 Jun 2020 09:21:13 -0400
IronPort-SDR: CSnuiI85yYMBW+kxSea1FrM0WZmFeou0+KUy0N9y7RvmKugzEMeDGbOyb/6RBKo3RQPyyFb3eX
 wuMCJ12C7SPQ==
X-IronPort-AV: E=McAfee;i="6000,8403,9661"; a="205955658"
X-IronPort-AV: E=Sophos;i="5.75,275,1589266800"; 
   d="scan'208";a="205955658"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Jun 2020 06:21:11 -0700
IronPort-SDR: 9WYRVYLaJEhuS5D0eP1K263UOykjlRv5NBsmEVTwR8KSEh3fl9P0R4l4Xj+nWC1NC+GJuvCNVA
 X3Gpp6bMRjYQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.75,275,1589266800"; 
   d="scan'208";a="452633693"
Received: from chenyu-office.sh.intel.com ([10.239.158.173])
  by orsmga005.jf.intel.com with ESMTP; 24 Jun 2020 06:21:09 -0700
Date:   Wed, 24 Jun 2020 21:22:12 +0800
From:   Chen Yu <yu.c.chen@intel.com>
To:     Sasha Levin <sashal@kernel.org>
Cc:     gregkh@linuxfoundation.org, Stable@vger.kernel.org,
        aaron.f.brown@intel.com, andriy.shevchenko@linux.intel.com,
        jeffrey.t.kirsher@intel.com, rafael.j.wysocki@intel.com
Subject: Re: FAILED: patch "[PATCH] e1000e: Do not wake up the system via WOL
 if device wakeup is" failed to apply to 4.9-stable tree
Message-ID: <20200624132212.GA18576@chenyu-office.sh.intel.com>
References: <15929135091516@kroah.com>
 <20200623135342.GZ1931@sasha-vm>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200623135342.GZ1931@sasha-vm>
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Jun 23, 2020 at 09:53:42AM -0400, Sasha Levin wrote:
> On Tue, Jun 23, 2020 at 01:58:29PM +0200, gregkh@linuxfoundation.org wrote:
> > 
> > The patch below does not apply to the 4.9-stable tree.
> > If someone wants it applied there, or to any other stable or longterm
> > tree, then please email the backport, including the original git commit
> > id to <stable@vger.kernel.org>.
> > 
> > thanks,
> > 
> > greg k-h
> > 
> > ------------------ original commit in Linus's tree ------------------
> > 
> 
> Conflict was because we don't have c8744f44aeae ("e1000e: Add Support
> for CannonLake") on 4.9 and 4.4. I've worked around that and queued this
> patch for both of those branches.
>
Thanks for pointing this out, Sasha.

Best,
Chenyu
> -- 
> Thanks,
> Sasha
