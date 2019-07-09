Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0176D63144
	for <lists+stable@lfdr.de>; Tue,  9 Jul 2019 08:56:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726062AbfGIG43 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 9 Jul 2019 02:56:29 -0400
Received: from mail.kernel.org ([198.145.29.99]:53766 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725818AbfGIG43 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 9 Jul 2019 02:56:29 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 609BF21537;
        Tue,  9 Jul 2019 06:56:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1562655388;
        bh=kXkni4R9byt/uWAIaqVUflyuYvAyhSCWRD/FB+IZfN4=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=aa3ttZoU59JbUNRrcr+F13cLKS2tKf1el9JKhMWitE+vN+kawdKV3reiW+XunEG1j
         LmUwQRpNfxOLGD7+2a00jgcYvxBeg/u10faz2I3lJJN8iuobdghw6PADqvzm2cFfjU
         s9cZLwq+8mPh6CKglZMU2YXyIRBui/0a2HDP3soo=
Date:   Tue, 9 Jul 2019 08:56:26 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     shuah <shuah@kernel.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net,
        patches@kernelci.org, ben.hutchings@codethink.co.uk,
        lkft-triage@lists.linaro.org, stable@vger.kernel.org
Subject: Re: [PATCH 5.1 00/96] 5.1.17-stable review
Message-ID: <20190709065626.GA13978@kroah.com>
References: <20190708150526.234572443@linuxfoundation.org>
 <d6a655e7-c303-98cd-e007-c1ed24469c07@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <d6a655e7-c303-98cd-e007-c1ed24469c07@kernel.org>
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Jul 08, 2019 at 06:52:57PM -0600, shuah wrote:
> On 7/8/19 9:12 AM, Greg Kroah-Hartman wrote:
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
> 
> Compiled and booted on my test system. No dmesg regressions.

Thanks for testing all of these and letting me know.

greg k-h
