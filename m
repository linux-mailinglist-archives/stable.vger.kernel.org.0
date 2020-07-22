Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5E4E322987A
	for <lists+stable@lfdr.de>; Wed, 22 Jul 2020 14:48:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732305AbgGVMsu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 22 Jul 2020 08:48:50 -0400
Received: from mail.kernel.org ([198.145.29.99]:45274 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732154AbgGVMst (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 22 Jul 2020 08:48:49 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 069B3206C1;
        Wed, 22 Jul 2020 12:48:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1595422129;
        bh=E4QKQcz5E2jeceZ6ITI1hvBgZYFa+z7lTVwNAGLsmSU=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=DHBQi/1HQpbk0YU58yglL91aOFcbXQRCehT62uNviuWIvp2Kdcezvv2RdKZ/PHtux
         uy/wpzSwSBVpcoM2mluOmfkuJHsszKyqu9JZKur+m1QKqh444Ir3NnnUdYgeGJv5fv
         vzGzaMsid68JGYJnxoJFlCsn1K2QZjW+2SM9zSzQ=
Date:   Wed, 22 Jul 2020 14:48:55 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Pavel Machek <pavel@denx.de>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, ben.hutchings@codethink.co.uk,
        lkft-triage@lists.linaro.org, stable@vger.kernel.org
Subject: Re: [PATCH 4.19 000/133] 4.19.134-rc1 review
Message-ID: <20200722124855.GC3155653@kroah.com>
References: <20200720152803.732195882@linuxfoundation.org>
 <20200721115633.GA26436@amd>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200721115633.GA26436@amd>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Jul 21, 2020 at 01:56:33PM +0200, Pavel Machek wrote:
> Hi!
> 
> > This is the start of the stable review cycle for the 4.19.134 release.
> > There are 133 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> > 
> > Responses should be made by Wed, 22 Jul 2020 15:27:31 +0000.
> > Anything received after that time might be too late.
> > 
> > The whole patch series can be found in one patch at:
> > 	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.19.134-rc1.gz
> > or in the git tree and branch at:
> > 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-4.19.y
> > and the diffstat can be found below.
> 
> Seems to pass basic testing from CIP project:
> 
> https://gitlab.com/cip-project/cip-testing/linux-stable-rc-ci/-/tree/linux-4.19.y

Thanks for testing 2 of these,

greg k-h
