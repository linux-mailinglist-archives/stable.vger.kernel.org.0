Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4866A22BEEC
	for <lists+stable@lfdr.de>; Fri, 24 Jul 2020 09:19:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726591AbgGXHTl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 24 Jul 2020 03:19:41 -0400
Received: from mail.kernel.org ([198.145.29.99]:53252 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726559AbgGXHTl (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 24 Jul 2020 03:19:41 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 436962073E;
        Fri, 24 Jul 2020 07:19:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1595575180;
        bh=fQ2MhYrtQic6KyCYMLSCzKYCHaM7lCCpkK1HoIwD8KM=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=JuYC1zUqoVhphVK479nqK4xnPCazJevRNoKlLnY3KpX/XkQu+gten//6w8mT40PCz
         C9RLCFJWHfw57tjio9yXf2avx3mB5SXH4/Wvm2EYGMA/3y0v8T6m6Wao2tSiy+z9mI
         ZSIW1Xg66rnw5H36uy+7LMSBwKkb6yGdRnsrZ72s=
Date:   Fri, 24 Jul 2020 09:19:43 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Guenter Roeck <linux@roeck-us.net>
Cc:     stable@vger.kernel.org, Sasha Levin <sashal@kernel.org>
Subject: Re: Patches to apply to stable releases [7/23/2020]
Message-ID: <20200724071943.GD3948185@kroah.com>
References: <20200723155708.5233-1-linux@roeck-us.net>
 <20200723182402.GB2960332@kroah.com>
 <caa531e7-6a77-0fc8-330f-9478058ab854@roeck-us.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <caa531e7-6a77-0fc8-330f-9478058ab854@roeck-us.net>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Jul 23, 2020 at 12:13:41PM -0700, Guenter Roeck wrote:
> On 7/23/20 11:24 AM, Greg Kroah-Hartman wrote:
> > On Thu, Jul 23, 2020 at 08:57:08AM -0700, Guenter Roeck wrote:
> >> Hi,
> >>
> >> Please consider applying the following patches to the listed stable
> >> releases.
> >>
> >> The following patches were found to be missing in stable releases by the
> >> Chrome OS missing patch robot. The patches meet the following criteria.
> >> - The patch includes a Fixes: tag
> >>   Note that the Fixes: tag does not always point to the correct upstream
> >>   SHA. In that case the correct upstream SHA is listed below.
> >> - The patch referenced in the Fixes: tag has been applied to the listed
> >>   stable release
> >> - The patch has not been applied to that stable release
> >>
> >> All patches have been applied to the listed stable releases and to at least
> >> one Chrome OS branch. Resulting images have been build- and runtime-tested
> >> (where applicable) on real hardware and with virtual hardware on
> >> kerneltests.org.
> >>
> >> Thanks,
> >> Guenter
> >>
> >> ---
> >> Upstream commit 2aeb18835476 ("perf/core: Fix locking for children siblings group read")
> >>   upstream: v4.13-rc2
> >>     Fixes: ba5213ae6b88 ("perf/core: Correct event creation with PERF_FORMAT_GROUP")
> >>       in linux-4.4.y: a8dd3dfefcf5
> >>       in linux-4.9.y: 50fe37e83e14
> >>       upstream: v4.13-rc1
> >>     Affected branches:
> >>       linux-4.4.y
> >>       linux-4.9.y (already applied)
> >>
> >> Upstream commit d41f36a6464a ("spi: spi-fsl-dspi: Exit the ISR with IRQ_NONE when it's not ours")
> >>   upstream: v5.4-rc1
> >>     Fixes: 13aed2392741 ("spi: spi-fsl-dspi: use IRQF_SHARED mode to request IRQ")
> >>       in linux-4.14.y: c75e886e1270
> >>       in linux-4.19.y: eb336b9003b1
> >>       upstream: v5.0-rc1
> >>     Affected branches:
> >>       linux-4.14.y
> >>       linux-4.19.y
> > 
> > All now queued up, thanks!
> > 
> 
> Excellent. That concludes the applicable backlog. Everything else the robot
> has found was either cosmetic or resulted in conflicts, and I did not try
> to create a backport for a variety of reasons (minor, irrelevant for us,
> too complex, too risky, untestable, ...).

Great, glad we have caught up now!

greg k-h
