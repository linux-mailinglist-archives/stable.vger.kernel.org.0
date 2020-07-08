Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5F5DD218B31
	for <lists+stable@lfdr.de>; Wed,  8 Jul 2020 17:28:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729950AbgGHP2F (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 8 Jul 2020 11:28:05 -0400
Received: from mail.kernel.org ([198.145.29.99]:42548 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729910AbgGHP2F (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 8 Jul 2020 11:28:05 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8574C20786;
        Wed,  8 Jul 2020 15:28:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1594222085;
        bh=q6H2MgomFwB1RePMLnNiDwgJsDS/PcygRl+huPQQ0x8=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=dC6UhLb1AbGooN9jirdPGALczpea5Ixd0NZpTeVsXEp+e/nWOUycm2jtjJPgDH89d
         wI75Z1xAFStAHh7V2F4eBfSBsCwPJU2uBONQTtU4NwO2dT8kHpHCvIwcWBgeCXiCS3
         N6rTEZSxdu3uBdHH3YWFCdZzNnou4lzL0fT4UFDM=
Date:   Wed, 8 Jul 2020 17:28:00 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Shuah Khan <skhan@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, ben.hutchings@codethink.co.uk,
        lkft-triage@lists.linaro.org, stable@vger.kernel.org
Subject: Re: [PATCH 5.7 000/112] 5.7.8-rc1 review
Message-ID: <20200708152800.GA714318@kroah.com>
References: <20200707145800.925304888@linuxfoundation.org>
 <552f9118-eac9-56cc-c321-dd9b97eff09e@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <552f9118-eac9-56cc-c321-dd9b97eff09e@linuxfoundation.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Jul 08, 2020 at 07:05:12AM -0600, Shuah Khan wrote:
> On 7/7/20 9:16 AM, Greg Kroah-Hartman wrote:
> > This is the start of the stable review cycle for the 5.7.8 release.
> > There are 112 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> > 
> > Responses should be made by Thu, 09 Jul 2020 14:57:34 +0000.
> > Anything received after that time might be too late.
> > 
> > The whole patch series can be found in one patch at:
> > 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.7.8-rc1.gz
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

Thanks for testing all of these and letting me know.

greg k-h
