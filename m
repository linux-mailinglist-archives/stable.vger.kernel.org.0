Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0E13BAABCF
	for <lists+stable@lfdr.de>; Thu,  5 Sep 2019 21:16:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388503AbfIETQH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 5 Sep 2019 15:16:07 -0400
Received: from mail.kernel.org ([198.145.29.99]:47250 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726097AbfIETQG (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 5 Sep 2019 15:16:06 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C64032070C;
        Thu,  5 Sep 2019 19:16:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1567710967;
        bh=1c56GflaBJYpW7I3V954ev68I6Ir7BAtdC3/zgNPSqI=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=E7LjTUVI7y9W4bUUFT0EKaEtlID3NjqyjFY7x8/xLimfn4sx6gjuIBcI6We6P6zs4
         RqbB3LKdzAzOll1M+g2fQEtZOcn2LkdBOMHrNx+6C7xWwA7xEbaJU9+Fo4DJvTjn/r
         fx17ENyj1rPGNUTbMwIa+jh6NwIvjlUg8/e6mAZw=
Date:   Thu, 5 Sep 2019 21:16:04 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Daniel =?iso-8859-1?Q?D=EDaz?= <daniel.diaz@linaro.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, ben.hutchings@codethink.co.uk,
        lkft-triage@lists.linaro.org, stable@vger.kernel.org
Subject: Re: [PATCH 5.2 000/143] 5.2.12-stable review
Message-ID: <20190905191604.GB15748@kroah.com>
References: <20190904175314.206239922@linuxfoundation.org>
 <f1f7fd91-061b-9646-20e8-297dfa2262c4@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <f1f7fd91-061b-9646-20e8-297dfa2262c4@linaro.org>
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Sep 05, 2019 at 12:29:57PM -0500, Daniel Díaz wrote:
> Hello!
> 
> On 9/4/19 12:52 PM, Greg Kroah-Hartman wrote:
> > This is the start of the stable review cycle for the 5.2.12 release.
> > There are 143 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> > 
> > Responses should be made by Fri 06 Sep 2019 05:50:23 PM UTC.
> > Anything received after that time might be too late.
> > 
> > The whole patch series can be found in one patch at:
> > 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.2.12-rc1.gz
> > or in the git tree and branch at:
> > 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.2.y
> > and the diffstat can be found below.
> > 
> > thanks,
> > 
> > greg k-h
> 
> Results from Linaro’s test farm.
> No regressions on arm64, arm, x86_64, and i386.

Thanks for testing all of these and letting me know.

greg k-h
