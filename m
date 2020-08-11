Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CB7E9241E07
	for <lists+stable@lfdr.de>; Tue, 11 Aug 2020 18:19:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728947AbgHKQTU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 11 Aug 2020 12:19:20 -0400
Received: from mail.kernel.org ([198.145.29.99]:37506 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728797AbgHKQTU (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 11 Aug 2020 12:19:20 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 560D0206B5;
        Tue, 11 Aug 2020 16:19:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597162759;
        bh=g/fdYmsXjS4o0XDyDu82txzCGkPcfkqggldKPafqBN0=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=gBzKfuas9PPoggObxXtHS7dl8D8FppKiJNgldOTLKA05O8mv0+uOKv6vdsFOuFXyo
         Jj+ocgSCJx2g55ZwX66KkiuY8cDMLuFnZhvDSnUGhUNjtPwpQ/ICPfeuIBOmKuLTwM
         UBOsYRzJzLwdMmnwk0sgnp+PQtJP3/7bCvLeH3ts=
Date:   Tue, 11 Aug 2020 18:19:28 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Shuah Khan <skhan@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, ben.hutchings@codethink.co.uk,
        lkft-triage@lists.linaro.org, stable@vger.kernel.org
Subject: Re: [PATCH 5.8 00/38] 5.8.1-rc1 review
Message-ID: <20200811161928.GA440280@kroah.com>
References: <20200810151803.920113428@linuxfoundation.org>
 <4ee644b4-55ee-35b0-bddb-0c4e95259151@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4ee644b4-55ee-35b0-bddb-0c4e95259151@linuxfoundation.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Aug 10, 2020 at 05:04:26PM -0600, Shuah Khan wrote:
> On 8/10/20 9:18 AM, Greg Kroah-Hartman wrote:
> > This is the start of the stable review cycle for the 5.8.1 release.
> > There are 38 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> > 
> > Responses should be made by Wed, 12 Aug 2020 15:17:47 +0000.
> > Anything received after that time might be too late.
> > 
> > The whole patch series can be found in one patch at:
> > 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.8.1-rc1.gz
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
