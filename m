Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D945323E844
	for <lists+stable@lfdr.de>; Fri,  7 Aug 2020 09:48:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726428AbgHGHrw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 7 Aug 2020 03:47:52 -0400
Received: from mail.kernel.org ([198.145.29.99]:48942 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726212AbgHGHrw (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 7 Aug 2020 03:47:52 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B2064221E5;
        Fri,  7 Aug 2020 07:47:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1596786472;
        bh=5R+4najtzM3yfQRgJ3YeObkH6HYTewpywc77wWpzhxI=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=svJuHAWZR76RQynac9APy26eLZpMjS7OOXSSkEfzcVUMYQdzlrWmM0vFCxcyLeG7U
         tB3LEjc9IuYaCRmpPoy2CTC07UVREogXEMvHCR7q5ujaXqi5qZoCRrPBdnqXfJpjkP
         A1Jj5zLdbAPpp2XYCjZz76uT+l+gx7iWDHnhhWME=
Date:   Fri, 7 Aug 2020 09:48:05 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Shuah Khan <skhan@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, ben.hutchings@codethink.co.uk,
        lkft-triage@lists.linaro.org, stable@vger.kernel.org
Subject: Re: [PATCH 5.7 0/7] 5.7.14-rc2 review
Message-ID: <20200807074805.GA3048107@kroah.com>
References: <20200805195916.183355405@linuxfoundation.org>
 <fb676589-8646-0120-d743-a3744663326d@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <fb676589-8646-0120-d743-a3744663326d@linuxfoundation.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Aug 06, 2020 at 01:31:02PM -0600, Shuah Khan wrote:
> On 8/5/20 1:59 PM, Greg Kroah-Hartman wrote:
> > This is the start of the stable review cycle for the 5.7.14 release.
> > There are 7 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> > 
> > Responses should be made by Fri, 07 Aug 2020 19:59:06 +0000.
> > Anything received after that time might be too late.
> > 
> > The whole patch series can be found in one patch at:
> > 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.7.14-rc2.gz
> > or in the git tree and branch at:
> > 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.7.y
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
