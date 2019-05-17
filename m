Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 30278213CC
	for <lists+stable@lfdr.de>; Fri, 17 May 2019 08:38:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727758AbfEQGid (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 17 May 2019 02:38:33 -0400
Received: from mail.kernel.org ([198.145.29.99]:33804 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727145AbfEQGid (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 17 May 2019 02:38:33 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A0C4820868;
        Fri, 17 May 2019 06:38:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1558075112;
        bh=cnqh2JGt1y9QJqf7BpK+oNnJnkH4c3Cd+B1j7hpI0qY=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=1reB51MZK1nADLVvTzqbeVaDNkmOAScqZAdfke5fTrlG+ixZ9IeMnRGU3nIhwUwpN
         p8ZGU3IkNrS9wZ7gw3e1G4e1I1mo18Ri0LXTIofqSKOAxmx2NPNfl3kreS4eten6nE
         DVOs0//Idz8dAyqvPNlzduCuka2s5FNcnQhH17us=
Date:   Fri, 17 May 2019 08:38:29 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Kevin Hilman <khilman@baylibre.com>
Cc:     "kernelci.org bot" <bot@kernelci.org>,
        linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, ben.hutchings@codethink.co.uk,
        lkft-triage@lists.linaro.org, stable@vger.kernel.org
Subject: Re: [PATCH 4.4 000/266] 4.4.180-stable review
Message-ID: <20190517063829.GA12844@kroah.com>
References: <20190515090722.696531131@linuxfoundation.org>
 <5cdc2691.1c69fb81.bd8d8.7247@mx.google.com>
 <20190515151307.GA23599@kroah.com>
 <7h1s0y9fuq.fsf@baylibre.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <7h1s0y9fuq.fsf@baylibre.com>
User-Agent: Mutt/1.11.4 (2019-03-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, May 16, 2019 at 03:47:25PM -0700, Kevin Hilman wrote:
> Greg Kroah-Hartman <gregkh@linuxfoundation.org> writes:
> 
> > On Wed, May 15, 2019 at 07:47:45AM -0700, kernelci.org bot wrote:
> >> stable-rc/linux-4.4.y boot: 98 boots: 1 failed, 92 passed with 3 offline, 1 untried/unknown, 1 conflict (v4.4.179-267-gbe756dada5b7)
> >> 
> >> Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux-4.4.y/kernel/v4.4.179-267-gbe756dada5b7/
> >> Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-4.4.y/kernel/v4.4.179-267-gbe756dada5b7/
> >> 
> >> Tree: stable-rc
> >> Branch: linux-4.4.y
> >> Git Describe: v4.4.179-267-gbe756dada5b7
> >> Git Commit: be756dada5b771fe51be37a77ad0bdfba543fdae
> >> Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
> >> Tested: 44 unique boards, 21 SoC families, 14 builds out of 190
> >> 
> >> Boot Regressions Detected:
> >> 
> >> arm:
> >> 
> >>     omap2plus_defconfig:
> >>         gcc-8:
> >>           omap4-panda:
> >>               lab-baylibre: new failure (last pass: v4.4.179-254-gce69be0d452a)
> >
> > Odd, is this specific to this release?
> 
> No, looks like a lab-specific hiccup.
> 
> A little bit further down in the original report (I know, not a useful
> place for it) was this:
> 
> > Conflicting Boot Failure Detected: (These likely are not failures as other labs are reporting PASS. Needs review.)
> >  
> > arm:
> >     omap2plus_defconfig:
> > 	omap4-panda:
> > 	    lab-baylibre: FAIL (gcc-8)
> >	    lab-baylibre-seattle: PASS (gcc-8)
> 
> which means the same board passed in one lab, but not the other,
> suggesting something.
> 
> This is a bug in our email reports.  Regressions should not be reported
> whene there are conflicting results from labs.

Ah, thanks for the explaination, that makes more sense.

greg k-h
