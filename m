Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E180F19C8F8
	for <lists+stable@lfdr.de>; Thu,  2 Apr 2020 20:43:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389475AbgDBSn3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 2 Apr 2020 14:43:29 -0400
Received: from mail.kernel.org ([198.145.29.99]:34204 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387866AbgDBSn3 (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 2 Apr 2020 14:43:29 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id BCC9220675;
        Thu,  2 Apr 2020 18:43:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1585853007;
        bh=/N8RpHRBkiax7dlAoubTa4nq/TFtKL/RpzapX5Q8Nsw=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=fEYckbJNwlGtK010RzAuxXfvMz/2z46GwXBEtcjcaaro9SvQzPeh0YR9iNC8waFr2
         b24PGO5l9IOWDAla18i/ji/n2ZIg4HvN5HI/EyQ0/Ut64W4UYNiKxSXkKjvHRjCmtm
         Him1J55PD4rB25m/1RoPhjHh04zjYnJvA2podwOs=
Date:   Thu, 2 Apr 2020 20:43:24 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     shuah <shuah@kernel.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net,
        patches@kernelci.org, ben.hutchings@codethink.co.uk,
        lkft-triage@lists.linaro.org, stable@vger.kernel.org
Subject: Re: [PATCH 5.5 00/30] 5.5.15-rc1 review
Message-ID: <20200402184324.GA3235262@kroah.com>
References: <20200401161414.345528747@linuxfoundation.org>
 <72d786ac-e838-2c3a-8938-1bcb01923843@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <72d786ac-e838-2c3a-8938-1bcb01923843@kernel.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Apr 02, 2020 at 10:45:52AM -0600, shuah wrote:
> On 4/1/20 10:17 AM, Greg Kroah-Hartman wrote:
> > This is the start of the stable review cycle for the 5.5.15 release.
> > There are 30 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> > 
> > Responses should be made by Fri, 03 Apr 2020 16:09:36 +0000.
> > Anything received after that time might be too late.
> > 
> > The whole patch series can be found in one patch at:
> > 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.5.15-rc1.gz
> > or in the git tree and branch at:
> > 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.5.y
> > and the diffstat can be found below.
> > 
> > thanks,
> > 
> > greg k-h
> > 
> 
> Compiled and booted on my test system. No dmesg regressions.

Thanks for testing all of these and letting me know.

greg k-h
