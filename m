Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D4447279A9A
	for <lists+stable@lfdr.de>; Sat, 26 Sep 2020 18:10:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729817AbgIZQKK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 26 Sep 2020 12:10:10 -0400
Received: from mail.kernel.org ([198.145.29.99]:58226 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729363AbgIZQKJ (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 26 Sep 2020 12:10:09 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E7BAF2177B;
        Sat, 26 Sep 2020 16:10:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1601136609;
        bh=ie9wmxg4W/s2uGx94pjCR+3jWNUVlv06w18sUFG7kUE=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=bipe90IsGckEKjgouBNH4oyH1aDVYU+lTmGhmgsL58RbJxpUYAZYVX5vLHw8eHugp
         yL8hDnPAVrQ25ZJPXdcHPTGc5JXmLemZmz3xP3/GOXx84DaawaDdOjL2wc3L8GKPOM
         WZEmbCjkwI6Y8fqLUZFEvv0l06Ghoo2OcFYModsI=
Date:   Sat, 26 Sep 2020 18:10:21 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Shuah Khan <skhan@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, ben.hutchings@codethink.co.uk,
        lkft-triage@lists.linaro.org, pavel@denx.de, stable@vger.kernel.org
Subject: Re: [PATCH 5.8 00/56] 5.8.12-rc1 review
Message-ID: <20200926161021.GC3361615@kroah.com>
References: <20200925124727.878494124@linuxfoundation.org>
 <da7b88bb-5e4d-a992-be18-e60e0a75558b@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <da7b88bb-5e4d-a992-be18-e60e0a75558b@linuxfoundation.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Sep 25, 2020 at 02:01:18PM -0600, Shuah Khan wrote:
> On 9/25/20 6:47 AM, Greg Kroah-Hartman wrote:
> > This is the start of the stable review cycle for the 5.8.12 release.
> > There are 56 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> > 
> > Responses should be made by Sun, 27 Sep 2020 12:47:02 +0000.
> > Anything received after that time might be too late.
> > 
> > The whole patch series can be found in one patch at:
> > 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.8.12-rc1.gz
> > or in the git tree and branch at:
> > 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.8.y
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

Thanks for testing all of these and letting me know.

greg k-h
