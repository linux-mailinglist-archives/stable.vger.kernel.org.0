Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 42C211150CE
	for <lists+stable@lfdr.de>; Fri,  6 Dec 2019 14:05:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726193AbfLFNFo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 6 Dec 2019 08:05:44 -0500
Received: from mail.kernel.org ([198.145.29.99]:59278 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726168AbfLFNFo (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 6 Dec 2019 08:05:44 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 907F821835;
        Fri,  6 Dec 2019 13:05:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1575637543;
        bh=jhg0LkIYrKedANT6EWfLBzewGJXYoCPDNQJXxq1WpK0=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=MR3HSVvtjAPowUsicpWKQpV7TguerTLnQwSp6ALu4L6X4ZKubK0QltPVmVet6SFzt
         w3FqlGH5bQTQGjk2tcq/MYXXaB7Ufgqa7XhrLCugCKd520u51gUobfkBkOyXolek8N
         XxiuHgcsEKmAgWYxGivp9ywK/B6rNb9j9ufRqRAc=
Date:   Fri, 6 Dec 2019 14:05:40 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Amol Grover <frextrite@gmail.com>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, ben.hutchings@codethink.co.uk,
        lkft-triage@lists.linaro.org, stable@vger.kernel.org
Subject: Re: [PATCH 5.4 00/46] 5.4.2-stable review
Message-ID: <20191206130540.GE1399220@kroah.com>
References: <20191203212705.175425505@linuxfoundation.org>
 <20191204132318.GA14649@workstation-kernel-dev>
 <20191204171322.GB3627415@kroah.com>
 <20191205164312.GA6105@workstation-kernel-dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191205164312.GA6105@workstation-kernel-dev>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Dec 05, 2019 at 10:13:12PM +0530, Amol Grover wrote:
> On Wed, Dec 04, 2019 at 06:13:22PM +0100, Greg Kroah-Hartman wrote:
> > On Wed, Dec 04, 2019 at 06:53:18PM +0530, Amol Grover wrote:
> > > On Tue, Dec 03, 2019 at 11:35:20PM +0100, Greg Kroah-Hartman wrote:
> > > > This is the start of the stable review cycle for the 5.4.2 release.
> > > > There are 46 patches in this series, all will be posted as a response
> > > > to this one.  If anyone has any issues with these being applied, please
> > > > let me know.
> > > > 
> > > > Responses should be made by Thu, 05 Dec 2019 21:20:36 +0000.
> > > > Anything received after that time might be too late.
> > > > 
> > > > The whole patch series can be found in one patch at:
> > > > 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.4.2-rc1.gz
> > > > or in the git tree and branch at:
> > > > 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.4.y
> > > > and the diffstat can be found below.
> > > > 
> > > > thanks,
> > > > 
> > > > greg k-h
> > > > 
> > > > -------------
> > > > Pseudo-Shortlog of commits:
> > > > 
> > > > Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> > > >     Linux 5.4.2-rc1
> > > > 
> > > > Hans de Goede <hdegoede@redhat.com>
> > > >     platform/x86: hp-wmi: Fix ACPI errors caused by passing 0 as input size
> > > > 
> > > > Hans de Goede <hdegoede@redhat.com>
> > > >     platform/x86: hp-wmi: Fix ACPI errors caused by too small buffer
> > > > 
> > > > Candle Sun <candle.sun@unisoc.com>
> > > >     HID: core: check whether Usage Page item is after Usage ID items
> > > > 
> > > > Herbert Xu <herbert@gondor.apana.org.au>
> > > >     crypto: talitos - Fix build error by selecting LIB_DES
> > > > 
> > > > Joel Stanley <joel@jms.id.au>
> > > >     Revert "jffs2: Fix possible null-pointer dereferences in jffs2_add_frag_to_fragtree()"
> > > > 
> > > > Theodore Ts'o <tytso@mit.edu>
> > > >     ext4: add more paranoia checking in ext4_expand_extra_isize handling
> > > > 
> > > > Heiner Kallweit <hkallweit1@gmail.com>
> > > >     r8169: fix resume on cable plug-in
> > > > 
> > > > Heiner Kallweit <hkallweit1@gmail.com>
> > > >     r8169: fix jumbo configuration for RTL8168evl
> > > > 
> > > > Thadeu Lima de Souza Cascardo <cascardo@canonical.com>
> > > >     selftests: pmtu: use -oneline for ip route list cache
> > > > 
> > > > John Rutherford <john.rutherford@dektech.com.au>
> > > >     tipc: fix link name length check
> > > > 
> > > > Jakub Kicinski <jakub.kicinski@netronome.com>
> > > >     selftests: bpf: correct perror strings
> > > > 
> > > > Jakub Kicinski <jakub.kicinski@netronome.com>
> > > >     selftests: bpf: test_sockmap: handle file creation failures gracefully
> > > > 
> > > > Jakub Kicinski <jakub.kicinski@netronome.com>
> > > >     net/tls: use sg_next() to walk sg entries
> > > > 
> > > > Jakub Kicinski <jakub.kicinski@netronome.com>
> > > >     net/tls: remove the dead inplace_crypto code
> > > > 
> > > > Jakub Kicinski <jakub.kicinski@netronome.com>
> > > >     selftests/tls: add a test for fragmented messages
> > > > 
> > > 
> > > Hi,
> > > I'm not sure if this is relevant but I tested out the latest revision
> > > of tools/testing/selftests/net/tls (run as sudo) with 5.3.9, 5.3.13,
> > > and 5.4.1, and all of them resulted in Oops. I'm not sure that it
> > > happens only on my PC but the old version worked fine on all 3 kernels.
> > > 
> > > More information available in this thread:
> > > https://lore.kernel.org/stable/20191203171817.GA24581@workstation-portable/
> > 
> > Any specific commit cause this issue?  Should I drop one/any of these?
> > 
> 
> The specific commit I'm talking about is the 32nd patch in this series
> [PATCH 5.4 32/46] selftests/tls: add a test for fragmented messages
> [ Upstream commit 65190f77424d7b82c4aad7326c9cce6bd91a2fcc ]
> 
> But it looks like everything is working fine for everyone, so maybe,
> it could be a problem specific to my distro/hardware/settings.

Does running Linus's tree right now with this commit in it also cause
problems for you?

thanks,

greg k-h
