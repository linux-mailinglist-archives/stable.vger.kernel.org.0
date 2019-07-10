Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4E7276430E
	for <lists+stable@lfdr.de>; Wed, 10 Jul 2019 09:49:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726996AbfGJHtM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 10 Jul 2019 03:49:12 -0400
Received: from mail.kernel.org ([198.145.29.99]:36044 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726043AbfGJHtM (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 10 Jul 2019 03:49:12 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 625F620651;
        Wed, 10 Jul 2019 07:49:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1562744951;
        bh=2GY6xGP91VrrOubCUmyVWiPbFCKO1puaMd0qoZCzk8I=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=SOKpY0iW78B8erFiX6R1l7W+5WsvjehW5ZybD/ZRmBIbFWDjQhH8eotsGjh/mgBzx
         6ZX1BcF1MRnURTcYdsw7wrU8ZJLaioukoVjCkvollYh/o6GoSI0a/my0qyFknrVnmE
         /ZQR/7kJ3cjP7YkzxgGsFGO3MyewxPX+vmbxWzp8=
Date:   Wed, 10 Jul 2019 09:49:09 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Luke Nowakowski-Krijger <lnowakow@eng.ucsd.edu>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, ben.hutchings@codethink.co.uk,
        lkft-triage@lists.linaro.org, stable@vger.kernel.org
Subject: Re: [PATCH 5.1 00/96] 5.1.17-stable review
Message-ID: <20190710074909.GB5186@kroah.com>
References: <20190708150526.234572443@linuxfoundation.org>
 <20190708192956.GB4652@luke-XPS-13>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190708192956.GB4652@luke-XPS-13>
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Jul 08, 2019 at 12:29:56PM -0700, Luke Nowakowski-Krijger wrote:
> On Mon, Jul 08, 2019 at 05:12:32PM +0200, Greg Kroah-Hartman wrote:
> > This is the start of the stable review cycle for the 5.1.17 release.
> > There are 96 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> > 
> > Responses should be made by Wed 10 Jul 2019 03:03:52 PM UTC.
> > Anything received after that time might be too late.
> > 
> > The whole patch series can be found in one patch at:
> > 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.1.17-rc1.gz
> > or in the git tree and branch at:
> > 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.1.y
> > and the diffstat can be found below.
> > 
> > thanks,
> > 
> > greg k-h
> > 
> > -------------
> Hi Greg, 
> 
> Compiled and Booted on my x86_64 system. 

Thanks for testing 2 of these.

greg k-h
