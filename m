Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 94AEA17BFC1
	for <lists+stable@lfdr.de>; Fri,  6 Mar 2020 14:59:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726498AbgCFN73 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 6 Mar 2020 08:59:29 -0500
Received: from mail.kernel.org ([198.145.29.99]:37620 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726299AbgCFN72 (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 6 Mar 2020 08:59:28 -0500
Received: from localhost (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 414FD20848;
        Fri,  6 Mar 2020 13:59:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1583503168;
        bh=zFeMv5aWwCUJaWWLDpHwzvEo6JJaiss/nDUJgacSkbw=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=wOBeHKU5xJ1OqcInHzoL0qq9jGB28M614R1rQs1v/acH5iZmf+bP2WTDN/oukRZpz
         Kr/5xzYr/Wbii5ftAMSI5pA9Q3CG7BxBw6U/ddH43axwnze5k0RuYmPAjm+28hxrj6
         usoMkJwX2DAQlVIQoRT9m3PLboW4glEhVYdjohU8=
Date:   Fri, 6 Mar 2020 08:59:27 -0500
From:   Sasha Levin <sashal@kernel.org>
To:     Jack Wang <jinpuwang@gmail.com>
Cc:     gregkh@linuxfoundation.org, stable@vger.kernel.org
Subject: Re: [stable-4.14 0/3] some backport for stable
Message-ID: <20200306135927.GR21491@sasha-vm>
References: <20200305163007.25659-1-jinpuwang@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1; format=flowed
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20200305163007.25659-1-jinpuwang@gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Mar 05, 2020 at 05:30:04PM +0100, Jack Wang wrote:
>Hi Greg, hi Sasha,
>
>Please consider following backport for next stable release.
>
>First patch for vhost_net has been tested with our in house regression tests
>with VM migration with kernel 4.14.171, but should be also applied to older
>stable tree.
>
>mce patch is to fix a call trace in EPYC Rome server during boot.
>
>EDAC one is to fix a regression backported to at least 4.14 and 4.19, should be
>applied to both tree, kernel 5.4/5.5 already have the patch.
>
>Regards,
>Jack Wang from IONOS SE.
>
>Eugenio Pérez (1):
>  vhost: Check docket sk_family instead of call getname
>
>Yazen Ghannam (2):
>  x86/mce: Handle varying MCA bank counts
>  EDAC/amd64: Set grain per DIMM
>
> arch/x86/kernel/cpu/mcheck/mce-inject.c | 14 +++++++-------
> arch/x86/kernel/cpu/mcheck/mce.c        | 22 +++++++---------------
> drivers/edac/amd64_edac.c               |  1 +
> drivers/vhost/net.c                     | 13 ++-----------
> 4 files changed, 17 insertions(+), 33 deletions(-)

Queued up. I took the EDAC commit to 4.19 as well.

-- 
Thanks,
Sasha
