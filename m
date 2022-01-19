Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7E386493878
	for <lists+stable@lfdr.de>; Wed, 19 Jan 2022 11:32:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353736AbiASKcF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 19 Jan 2022 05:32:05 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:44184 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1353717AbiASKcF (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 19 Jan 2022 05:32:05 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 20B8CB8197F;
        Wed, 19 Jan 2022 10:32:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6B356C004E1;
        Wed, 19 Jan 2022 10:32:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1642588323;
        bh=JsrRS0cmXH/lJOrKmmgC2hkdYY6FQ0fZiLqUAAqm5vU=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=x1E5QLjmwz92HIQ59iSj8664xW1+ynSwcu/YR8DGoW/jU7Q8fpM+Vrltuj24VJ1D5
         J3VooejGfALojTrj6qAT+1f64Zov9zIJKUTE7fQlayiLbo9i6miRbQjT3Wt9m3ywxC
         sNrqSh2WOAMGp+oLQD46O7gARGDbOs77uNLNjn2U=
Date:   Wed, 19 Jan 2022 11:32:00 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Pavel Machek <pavel@denx.de>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org,
        jonathanh@nvidia.com, f.fainelli@gmail.com, stable@vger.kernel.org
Subject: Re: 4.4 series end of line was Re: [PATCH 4.4 00/17] 4.4.297-rc1
 review
Message-ID: <YefooANkr6eem49U@kroah.com>
References: <20211227151315.962187770@linuxfoundation.org>
 <20220119102858.GB4984@amd>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220119102858.GB4984@amd>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Jan 19, 2022 at 11:28:58AM +0100, Pavel Machek wrote:
> Hi!
> 
> > This is the start of the stable review cycle for the 4.4.297 release.
> > There are 17 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> 
> 4.4.X series is scheduled for EOL next month. Do you have any
> estimates if it will be more like Feb 2 or Feb 27?

I would bet on Feb 1 :)

good luck!

greg k-h
