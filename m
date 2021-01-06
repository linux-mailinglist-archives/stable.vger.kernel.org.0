Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4F5032EBF17
	for <lists+stable@lfdr.de>; Wed,  6 Jan 2021 14:50:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727505AbhAFNpy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 6 Jan 2021 08:45:54 -0500
Received: from mail.kernel.org ([198.145.29.99]:49912 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727306AbhAFNpy (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 6 Jan 2021 08:45:54 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7CD1C22B40;
        Wed,  6 Jan 2021 13:45:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1609940714;
        bh=dzveg0rL9XKUMaosUdzq5ZPSRie1W3jtdMWmi/+hiZ8=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=pyfG6+RfMCFB39KoB8xKmp8vD9zh0nDfYmWpOYj7LCdVBpQK8hG0vq/vN/nkHYfBr
         DJCU2jAdJKODN8xDm0q4I4+m843AibGk8CBktIuQdVeT35U0dvvSktGs9JfHWQ9UQo
         o3EEj0i1kb05gbwhy9XZ5br02Dai+gG+fAbwpCz8=
Date:   Wed, 6 Jan 2021 14:46:32 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Shuah Khan <skhan@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        stable@vger.kernel.org
Subject: Re: [PATCH 4.19 00/35] 4.19.165-rc1 review
Message-ID: <X/W/OBYOyPB7jrRz@kroah.com>
References: <20210104155703.375788488@linuxfoundation.org>
 <46249e9b-218f-0a7f-24fc-23854e8ab7df@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <46249e9b-218f-0a7f-24fc-23854e8ab7df@linuxfoundation.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Jan 05, 2021 at 09:44:26AM -0700, Shuah Khan wrote:
> On 1/4/21 8:57 AM, Greg Kroah-Hartman wrote:
> > This is the start of the stable review cycle for the 4.19.165 release.
> > There are 35 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> > 
> > Responses should be made by Wed, 06 Jan 2021 15:56:52 +0000.
> > Anything received after that time might be too late.
> > 
> > The whole patch series can be found in one patch at:
> > 	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.19.165-rc1.gz
> > or in the git tree and branch at:
> > 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-4.19.y
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

Thanks for testing them all and letting me know.

greg k-h
