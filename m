Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 04025E7326
	for <lists+stable@lfdr.de>; Mon, 28 Oct 2019 15:01:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389983AbfJ1OAo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Oct 2019 10:00:44 -0400
Received: from mail.kernel.org ([198.145.29.99]:57430 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728529AbfJ1OAn (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Oct 2019 10:00:43 -0400
Received: from localhost (unknown [91.217.168.176])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 403E321783;
        Mon, 28 Oct 2019 14:00:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1572271242;
        bh=0DzRlT6GW4RFtOqB/ZUdVCgi10ablCqFDkwAQ6nC/Do=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=KrYF0EkHAD1kcxERsM4t0uub2IViVS30FfrJ5lMo8bANnp4c4d3nSDpdZYskQcHka
         T360Cv6mMxNAKvBCg4f5cEvFWpCLp5gnu1gzPb4IIbrPyq8rifS8E9BLYahli752Kc
         FTiDf+Yd1Hkqx6VTND0nKlZWUi4UmJzN5ohog4HQ=
Date:   Mon, 28 Oct 2019 15:00:40 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Didik Setiawan <ds@didiksetiawan.com>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, ben.hutchings@codethink.co.uk,
        lkft-triage@lists.linaro.org, stable@vger.kernel.org
Subject: Re: [PATCH 5.3 000/197] 5.3.8-stable review
Message-ID: <20191028140040.GB97917@kroah.com>
References: <20191027203351.684916567@linuxfoundation.org>
 <20191028043855.GA18500@notebook>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191028043855.GA18500@notebook>
User-Agent: Mutt/1.12.2 (2019-09-21)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Oct 28, 2019 at 11:38:55AM +0700, Didik Setiawan wrote:
> On Sun, Oct 27, 2019 at 09:58:38PM +0100, Greg Kroah-Hartman wrote:
> > This is the start of the stable review cycle for the 5.3.8 release.
> > There are 197 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> > 
> > Responses should be made by Tue 29 Oct 2019 08:27:02 PM UTC.
> > Anything received after that time might be too late.
> > 
> > The whole patch series can be found in one patch at:
> > 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.3.8-rc1.gz
> > or in the git tree and branch at:
> > 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.3.y
> > and the diffstat can be found below.
> > 
> > thanks,
> > 
> > greg k-h
>  
> Compiled, booted, and no regressions found on my x86_64 system.

Thanks for testing all of these and letting me know.

greg k-h
