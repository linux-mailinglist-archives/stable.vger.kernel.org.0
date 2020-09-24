Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0454727776C
	for <lists+stable@lfdr.de>; Thu, 24 Sep 2020 19:06:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727687AbgIXRGw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 24 Sep 2020 13:06:52 -0400
Received: from mail.kernel.org ([198.145.29.99]:55672 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726458AbgIXRGv (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 24 Sep 2020 13:06:51 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id BD8AA238A1;
        Thu, 24 Sep 2020 17:06:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1600967211;
        bh=tnvlWQKIgUp7HDhjlLUx+u0eSX0MPoE5DdgY26B/JkI=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=J2S1a55j1ayfb5gMn9FIkP1iU4lmJ+R4BGJxu/RQm4pzp5jLhSOpODdztSrHQh3Jj
         meoJ63eayP7fF+aGuABAI6wJlv2Hg+DKp8gfoFCnNGtgoo+uQaLoGz7EuH5KQcMvY4
         Pw9Fl1QVgYr3BFZrj/PPfIWwYy1hl4dlfRmfgPlU=
Date:   Thu, 24 Sep 2020 19:07:07 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Nobuhiro Iwamatsu <nobuhiro1.iwamatsu@toshiba.co.jp>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, ben.hutchings@codethink.co.uk,
        lkft-triage@lists.linaro.org, pavel@denx.de, stable@vger.kernel.org
Subject: Re: [PATCH 4.4 00/46] 4.4.237-rc1 review
Message-ID: <20200924170707.GD1182944@kroah.com>
References: <20200921162033.346434578@linuxfoundation.org>
 <20200922095451.ryfke743wp6jajs6@toshiba.co.jp>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200922095451.ryfke743wp6jajs6@toshiba.co.jp>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Sep 22, 2020 at 06:54:51PM +0900, Nobuhiro Iwamatsu wrote:
> Hi,
> 
> On Mon, Sep 21, 2020 at 06:27:16PM +0200, Greg Kroah-Hartman wrote:
> > This is the start of the stable review cycle for the 4.4.237 release.
> > There are 46 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> > 
> > Responses should be made by Wed, 23 Sep 2020 16:20:12 +0000.
> > Anything received after that time might be too late.
> > 
> > The whole patch series can be found in one patch at:
> > 	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.4.237-rc1.gz
> > or in the git tree and branch at:
> > 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-4.4.y
> > and the diffstat can be found below.
> > 
> > thanks,
> > 
> > greg k-h
> >
> 
> There were no issues with CIP's kernel builds and tests[0].

Thanks for testing 2 of these and letting me know.

greg k-h
