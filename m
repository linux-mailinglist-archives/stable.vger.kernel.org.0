Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D0DD02024AF
	for <lists+stable@lfdr.de>; Sat, 20 Jun 2020 17:06:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728310AbgFTPGI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 20 Jun 2020 11:06:08 -0400
Received: from mail.kernel.org ([198.145.29.99]:33226 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728226AbgFTPGH (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 20 Jun 2020 11:06:07 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5F15B221F1;
        Sat, 20 Jun 2020 15:06:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592665567;
        bh=Gv4kx3hBBpTiBVPAAclamC5EuW79T88dliqeMeJydRM=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=GjkSGi23kUIm6tvs2tktxgnncU2OccJ6Bgi0KtVuI5Eb7CAmC5Ux1ZupngswGY4Lz
         dwRcFeKqzdetu2MDvt3TBZWO+/93PGTepjoFl649y2T+xEKNdyuaeIWes2uZcKvTHs
         DmxS/T3vUDmZcNiTOYr/KVsbBVj9Fxe/W/cjejjY=
Date:   Sat, 20 Jun 2020 17:06:01 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Guenter Roeck <linux@roeck-us.net>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        stable@vger.kernel.org
Subject: Re: [PATCH 4.4 000/101] 4.4.228-rc1 review
Message-ID: <20200620150601.GC3170217@kroah.com>
References: <20200619141614.001544111@linuxfoundation.org>
 <20200619164055.GA258515@roeck-us.net>
 <20200620074621.GB2298609@kroah.com>
 <6ca7eeb4-e092-bfc8-e3c3-1d33423a64b3@roeck-us.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <6ca7eeb4-e092-bfc8-e3c3-1d33423a64b3@roeck-us.net>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sat, Jun 20, 2020 at 07:04:33AM -0700, Guenter Roeck wrote:
> On 6/20/20 12:46 AM, Greg Kroah-Hartman wrote:
> > On Fri, Jun 19, 2020 at 09:40:55AM -0700, Guenter Roeck wrote:
> >> On Fri, Jun 19, 2020 at 04:31:49PM +0200, Greg Kroah-Hartman wrote:
> >>> This is the start of the stable review cycle for the 4.4.228 release.
> >>> There are 101 patches in this series, all will be posted as a response
> >>> to this one.  If anyone has any issues with these being applied, please
> >>> let me know.
> >>>
> >>> Responses should be made by Sun, 21 Jun 2020 14:15:50 +0000.
> >>> Anything received after that time might be too late.
> >>>
> >>
> >> Building powerpc:defconfig ... failed
> >> --------------
> >> Error log:
> >>
> >> drivers/macintosh/windfarm_pm112.c: In function ‘create_cpu_loop’:
> >> drivers/macintosh/windfarm_pm112.c:148:2: error: implicit declaration of function ‘kfree’
> >>
> >> Affects v4.4.y.queue and v4.9.y.queue.
> > 
> > Thanks, I've fixed this up by adding an #include <linux/slab.h> to the
> > top of that driver for those trees.
> > 
> 
> Guess you didn't update linux-stable-rc/linux-4.{4,9}.y, but v4.4.228 and
> v4.9.228 build ok, so looks like that fixed the problem.

I didn't do a new -rc for those, and thanks for testing.

greg k-h
