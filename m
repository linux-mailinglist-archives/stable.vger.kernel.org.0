Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B4D984B666
	for <lists+stable@lfdr.de>; Wed, 19 Jun 2019 12:45:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726999AbfFSKpp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 19 Jun 2019 06:45:45 -0400
Received: from mail.kernel.org ([198.145.29.99]:37060 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726958AbfFSKpp (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 19 Jun 2019 06:45:45 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6AA6C2064A;
        Wed, 19 Jun 2019 10:45:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1560941144;
        bh=6+bqLgnYachX9qZffDdNnLFpav1BA3AXH8IDsRpWdpI=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=uzN35hFjI61IOr+0ek9kA6NUDfKdeKoxdMADMy73sCGP4UMNg0iosIUpbzlvN4P3f
         Je+ftlBcfmrc2i545e3AFCAEKw1fxCU/QRfe9sNFv70UdMSTIRDlr6Rc3rZfZWHKvc
         0oxART88UhZwKGtdnMSE6VLUqp1qYDCSaQD2K3pY=
Date:   Wed, 19 Jun 2019 12:45:42 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Jiunn Chang <c0d1n61at3@gmail.com>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, ben.hutchings@codethink.co.uk,
        lkft-triage@lists.linaro.org, stable@vger.kernel.org
Subject: Re: [PATCH 5.1 000/115] 5.1.12-stable review
Message-ID: <20190619104542.GB3150@kroah.com>
References: <20190617210759.929316339@linuxfoundation.org>
 <20190618232701.uqjdck5fzaggk3r5@rYz3n>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190618232701.uqjdck5fzaggk3r5@rYz3n>
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Jun 18, 2019 at 06:27:02PM -0500, Jiunn Chang wrote:
> On Mon, Jun 17, 2019 at 11:08:20PM +0200, Greg Kroah-Hartman wrote:
> > This is the start of the stable review cycle for the 5.1.12 release.
> > There are 115 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> > 
> > Responses should be made by Wed 19 Jun 2019 09:06:21 PM UTC.
> > Anything received after that time might be too late.
> > 
> > The whole patch series can be found in one patch at:
> > 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.1.12-rc1.gz
> > or in the git tree and branch at:
> > 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.1.y
> > and the diffstat can be found below.
> > 
> > thanks,
> > 
> > greg k-h
> > 
> > -------------
> 
> Compiled and booted.  No regressions x86_64.

Thanks for testing!

greg k-h
