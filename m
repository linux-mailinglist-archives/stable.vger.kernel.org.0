Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0058030595D
	for <lists+stable@lfdr.de>; Wed, 27 Jan 2021 12:15:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234201AbhA0K7G (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 27 Jan 2021 05:59:06 -0500
Received: from mail.kernel.org ([198.145.29.99]:56070 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236195AbhA0K4x (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 27 Jan 2021 05:56:53 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2CD0520771;
        Wed, 27 Jan 2021 10:56:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1611744972;
        bh=Oc/LjMbCQwC6lPDi6hc/JRaRlkVCoH6ODFD3QvUngXU=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=vysqP8+Es41r50y0GweKqcF77Ws+u7WbhUa2+UYAbJIurL9CdxZ57JPtvgk3mgm2g
         e8NSQG5fIkY+5N8w2/Pjm4CwLRPTViV1RjvmhKNSfu2O/iVgrPghhRhmVO57lF2LLp
         yDM15zCgGLGzSYxXPRc7zLbfRIIweQbSUb6NDS9Y=
Date:   Wed, 27 Jan 2021 11:56:09 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Shuah Khan <skhan@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        stable@vger.kernel.org
Subject: Re: [PATCH 5.10 000/203] 5.10.11-rc2 review
Message-ID: <YBFGyYn6zBXH93K+@kroah.com>
References: <20210126094313.589480033@linuxfoundation.org>
 <10222e50-155c-3f01-36eb-a2857fe39c36@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <10222e50-155c-3f01-36eb-a2857fe39c36@linuxfoundation.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Jan 26, 2021 at 04:35:53PM -0700, Shuah Khan wrote:
> On 1/26/21 3:03 AM, Greg Kroah-Hartman wrote:
> > This is the start of the stable review cycle for the 5.10.11 release.
> > There are 203 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> > 
> > Responses should be made by Thu, 28 Jan 2021 09:42:40 +0000.
> > Anything received after that time might be too late.
> > 
> > The whole patch series can be found in one patch at:
> > 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.11-rc2.gz
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

Thanks for testing these and letting me know.

greg k-h
