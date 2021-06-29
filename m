Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A8BCB3B6EB4
	for <lists+stable@lfdr.de>; Tue, 29 Jun 2021 09:27:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232242AbhF2H33 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 29 Jun 2021 03:29:29 -0400
Received: from mail.kernel.org ([198.145.29.99]:44616 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232227AbhF2H33 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 29 Jun 2021 03:29:29 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id E42BD61DD6;
        Tue, 29 Jun 2021 07:27:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1624951622;
        bh=/wC0kC8OS5dr+JvXY9eZyoD6DFcLuoL5e4QdrlGMkwU=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=dVAjEqJcmSZH0mpea9fRLTf/ER2mQBZQxAGP4l5xoEQ2PsCnhORVJFTRQfpOYOabx
         oAdbAx8MwE8Pyd7RtnD8k2jAW9pPVLdniQfogq1R1cCTdDeat5Yj+AqOWOG7tAl0/H
         6hXNi9wXoXBIHiLyb9Os4AF00fk/JecY5w7Xh+nw=
Date:   Tue, 29 Jun 2021 09:27:00 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     kajoljain <kjain@linux.ibm.com>
Cc:     will@kernel.org, hao.wu@intel.com, mark.rutland@arm.com,
        trix@redhat.com, yilun.xu@intel.com, mdf@kernel.org,
        linux-fpga@vger.kernel.org, maddy@linux.vnet.ibm.com,
        atrajeev@linux.vnet.ibm.com, linux-kernel@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org, rnsastry@linux.ibm.com,
        linux-perf-users@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH] fpga: dfl: fme: Fix cpu hotplug issue in performance
 reporting
Message-ID: <YNrLRLyyUeDemxTS@kroah.com>
References: <20210628101721.188991-1-kjain@linux.ibm.com>
 <adc3b013-d39b-a183-dfce-86ca857949b8@linux.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <adc3b013-d39b-a183-dfce-86ca857949b8@linux.ibm.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Jun 29, 2021 at 12:45:20PM +0530, kajoljain wrote:
> 
> 
> On 6/28/21 3:47 PM, Kajol Jain wrote:
> > The performance reporting driver added cpu hotplug
> > feature but it didn't add pmu migration call in cpu
> > offline function.
> > This can create an issue incase the current designated
> > cpu being used to collect fme pmu data got offline,
> > as based on current code we are not migrating fme pmu to
> > new target cpu. Because of that perf will still try to
> > fetch data from that offline cpu and hence we will not
> > get counter data.
> > 
> > Patch fixed this issue by adding pmu_migrate_context call
> > in fme_perf_offline_cpu function.
> > 
> 
> Adding stable@vger.kernel.org in cc list as suggested by Moritz Fischer.


<formletter>

This is not the correct way to submit patches for inclusion in the
stable kernel tree.  Please read:
    https://www.kernel.org/doc/html/latest/process/stable-kernel-rules.html
for how to do this properly.

</formletter>
