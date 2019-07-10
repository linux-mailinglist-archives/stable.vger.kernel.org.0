Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2873264313
	for <lists+stable@lfdr.de>; Wed, 10 Jul 2019 09:50:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726275AbfGJHuS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 10 Jul 2019 03:50:18 -0400
Received: from mail.kernel.org ([198.145.29.99]:36564 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726043AbfGJHuS (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 10 Jul 2019 03:50:18 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9B1FA20651;
        Wed, 10 Jul 2019 07:50:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1562745017;
        bh=exaz+qLfEjNdZCRHTVw4B1zq/sgPHEuhCmHhmJF4SIg=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=17XxH+RjqlAcNBBMbQLWJJUTeotMr7ox9zSc5XV3SFN2AYFYdNmNzsVy8MDwY+HnW
         mxS9VuFugZNWGqmg+F7vHfNwuXkIsVzWSzJWFVdS1Z2R4ZIFIDCedtYaPtQSdHgg0d
         3ZHcWC20He/gKsnIJQ6cUB0UcSHIDlp1TOdhemIQ=
Date:   Wed, 10 Jul 2019 09:50:14 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Phong Tran <tranmanphong@gmail.com>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, ben.hutchings@codethink.co.uk,
        lkft-triage@lists.linaro.org, stable@vger.kernel.org,
        linux-kernel-mentees@lists.linuxfoundation.org
Subject: Re: [PATCH 5.1 00/96] 5.1.17-stable review
Message-ID: <20190710075014.GC5186@kroah.com>
References: <20190708150526.234572443@linuxfoundation.org>
 <c1498293-f0f6-0599-bd72-4156370a7599@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <c1498293-f0f6-0599-bd72-4156370a7599@gmail.com>
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Jul 09, 2019 at 12:49:48AM +0700, Phong Tran wrote:
> On 7/8/19 10:12 PM, Greg Kroah-Hartman wrote:
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
> 
> build and boot fine with qemu-system-riscv64
> 
> root@(none):~# uname  -a
> Linux (none) 5.1.17-rc1-00097-gb64119f8dffe #4 SMP Tue Jul 9 00:44:23 +07
> 2019 riscv64 GNU/Linux
> root@(none):~# cat /proc/cpuinfo
> processor	: 0
> hart		: 0
> isa		: rv64imafdcu
> mmu		: sv48
> 

riscv on quemu, interesting choice!

Note, Guenter's tests do check this type of thing already, but thanks
for doing this.

greg k-h
