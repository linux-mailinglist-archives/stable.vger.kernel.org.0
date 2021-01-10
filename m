Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A7A502F06A1
	for <lists+stable@lfdr.de>; Sun, 10 Jan 2021 12:30:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726112AbhAJLaN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 10 Jan 2021 06:30:13 -0500
Received: from mail.kernel.org ([198.145.29.99]:48138 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726069AbhAJLaM (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 10 Jan 2021 06:30:12 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id D88532311E;
        Sun, 10 Jan 2021 11:29:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1610278172;
        bh=aVFfL+7IVr5QEX3XXjO8lxYRoseIcZq37018dnoD3HY=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=IAwlxiztm9PbLBOgp+O3hcU+Zg/ZMuxd2ei2ArKIcLq0WOaXqWLq7T+kUgLkl5nj5
         xXjJrcQVfceco+WfjVkVrW1vf2quVus4DkstL6eyGnh5Wc43b8DDWVDkCWUXDqZnTS
         K/P8cDuLRaV2/ZETofdyrRLV6SvktG3akhCi1uKI=
Date:   Sun, 10 Jan 2021 12:30:45 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Shuah Khan <skhan@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        stable@vger.kernel.org
Subject: Re: [PATCH 5.10 00/20] 5.10.6-rc1 review
Message-ID: <X/rlZag4lZ9AW8rH@kroah.com>
References: <20210107143052.392839477@linuxfoundation.org>
 <21133ac9-92b5-1954-da31-cb2d4afb5217@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <21133ac9-92b5-1954-da31-cb2d4afb5217@linuxfoundation.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Jan 07, 2021 at 06:10:15PM -0700, Shuah Khan wrote:
> On 1/7/21 7:33 AM, Greg Kroah-Hartman wrote:
> > This is the start of the stable review cycle for the 5.10.6 release.
> > There are 20 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> > 
> > Responses should be made by Sat, 09 Jan 2021 14:30:35 +0000.
> > Anything received after that time might be too late.
> > 
> > The whole patch series can be found in one patch at:
> > 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.6-rc1.gz
> > or in the git tree and branch at:
> > 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.10.y
> > and the diffstat can be found below.
> > 
> > thanks,
> > 
> > greg k-h
> > 
> 
> Compiled and booted on my test system. No dmesg regressions.
> 
> Tested-by: Shuah Khan <skhan@linuxfoundation.org>

Thanks for testing them and letting me know.

greg k-h
