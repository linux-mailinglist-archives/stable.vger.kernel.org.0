Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 03EA32F927E
	for <lists+stable@lfdr.de>; Sun, 17 Jan 2021 14:22:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728676AbhAQNVm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 17 Jan 2021 08:21:42 -0500
Received: from mail.kernel.org ([198.145.29.99]:51498 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728538AbhAQNVi (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 17 Jan 2021 08:21:38 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4826C2222B;
        Sun, 17 Jan 2021 13:20:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1610889658;
        bh=0wVLckVQz7PHAAbMi5aAMRuA9NA60N5kWBKRy3Kes5k=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=ZlZHPEpOfrm7YB7+nXPkW9sxbJ6xYEifZguvC1UIVWoGHeRY0F/2TrBzdfblWaa/+
         Hr1T3KJLSPbsgJLIOeaozh+EcWk45/MAf/ImlpK6rmHGz6wkd15UFygE7Oi2RjkQxy
         jWb1HLWQjSol/VIsT3Ucl52/fmcrxiTIhZVRdpEw=
Date:   Sun, 17 Jan 2021 14:20:56 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Shuah Khan <skhan@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        stable@vger.kernel.org
Subject: Re: [PATCH 5.10 000/103] 5.10.8-rc1 review
Message-ID: <YAQ5uCawzR6J/KLD@kroah.com>
References: <20210115122006.047132306@linuxfoundation.org>
 <64c441ee-1010-7db0-fcce-3483b2da1bf8@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <64c441ee-1010-7db0-fcce-3483b2da1bf8@linuxfoundation.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Jan 15, 2021 at 02:13:25PM -0700, Shuah Khan wrote:
> On 1/15/21 5:26 AM, Greg Kroah-Hartman wrote:
> > This is the start of the stable review cycle for the 5.10.8 release.
> > There are 103 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> > 
> > Responses should be made by Sun, 17 Jan 2021 12:19:42 +0000.
> > Anything received after that time might be too late.
> > 
> > The whole patch series can be found in one patch at:
> > 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.8-rc1.gz
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

Thanks for testing and letting me know.

greg k-h
