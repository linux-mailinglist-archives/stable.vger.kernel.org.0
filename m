Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CA00F41874D
	for <lists+stable@lfdr.de>; Sun, 26 Sep 2021 10:10:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231240AbhIZIMd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 26 Sep 2021 04:12:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51188 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231236AbhIZIMd (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 26 Sep 2021 04:12:33 -0400
Received: from mail-ed1-x52c.google.com (mail-ed1-x52c.google.com [IPv6:2a00:1450:4864:20::52c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DF7EDC061570;
        Sun, 26 Sep 2021 01:10:56 -0700 (PDT)
Received: by mail-ed1-x52c.google.com with SMTP id bx4so55172630edb.4;
        Sun, 26 Sep 2021 01:10:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=SLdov9PG/6476MQBl4zOLliPuTRrEl5E7EqXQ4oiFXY=;
        b=XUYZKA4ydEfj9kmRhlF0xxxuHABVP75cLPUWDryf3FSpJV5RH99E+FQZYLjrE/uLjK
         5gYXaxiq/1CnC4Ay6SQbm7ltARLntPuOH4WCdn+QMMwQqitho6AxqxMU7iZ2ClqAi2zI
         baAJU46T6PUq73u8PMVVWUWlAeRX91R+W9+y7h5SC9pctHX4wSK1VUvehDX6ipx+fKZc
         3aum3b+5GErZlVq3jiQ6+feEP+3yIL70EsRrBEIXrg+8o79pec+vIJbSn2L6T5G18EDY
         WHHzalKNlUf3ynxD8tO21DfuLKM0SOEJROrkJcP9TDozHSFChhWwMxgG4t64d5IOjfCL
         HDVQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to;
        bh=SLdov9PG/6476MQBl4zOLliPuTRrEl5E7EqXQ4oiFXY=;
        b=40AVkIe229EZC7t49mOdeZcIe1K7llWVF3ljUV+GSHk5yCGo0pSvWvYGhwI5udGpgd
         gKzyq/0hbYmlECxgtXMWgMuLdKCbPXUm3KTilp5a/XjPaGCBIqoFmAem50fwtGH+l3gr
         vxfaTZaBcjcOQNHPWN8Ns07rvG1QRQlnFgKRiQwH484ItZ6+RrukjpPq+oZPsWmUsjM4
         nwwXjYLpr8Nyk+GclxvGzBBFO0iPeeNU/LHpCpoEe5HwH6sEo2RCb8bk5aU/Jfw3gRyB
         XnyXPwfs3jGGN0FZ+pGkJHG2MBGGU0VDB4p23abEa5X84HU27IX+6pZk2NsND1sc+T3z
         mLjw==
X-Gm-Message-State: AOAM530rEHeKnpxkZm8Jluegq7zGQ/EOulWaadfTI5zxkj3HXlfh45W3
        K6fyCxckQG1vwGwTkv91E70=
X-Google-Smtp-Source: ABdhPJz1iPtbHF31tHNG6wnEe2ibF/pgCDaaHF2tqfwbwiTKpjElYhkyRuHzYxAtVDNrtyvdNB19hg==
X-Received: by 2002:aa7:ca19:: with SMTP id y25mr16139810eds.197.1632643854896;
        Sun, 26 Sep 2021 01:10:54 -0700 (PDT)
Received: from eldamar (80-218-24-251.dclient.hispeed.ch. [80.218.24.251])
        by smtp.gmail.com with ESMTPSA id d15sm7002827ejo.4.2021.09.26.01.10.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 26 Sep 2021 01:10:54 -0700 (PDT)
Sender: Salvatore Bonaccorso <salvatore.bonaccorso@gmail.com>
Date:   Sun, 26 Sep 2021 10:10:53 +0200
From:   Salvatore Bonaccorso <carnil@debian.org>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     Jari Ruusu <jariruusu@protonmail.com>,
        Sasha Levin <sashal@kernel.org>, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org, Jiri Slaby <jirislaby@kernel.org>,
        Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Aurelien Jarno <aurelien@aurel32.net>
Subject: Re: glibc VETO for kernel version SUBLEVEL >= 255
Message-ID: <YVArDZSq9oaTFakz@eldamar.lan>
References: <qscod31lyVG7t-CW63o_pnsara-v9Wf6qXz9eSfUZnxtHk2AkeJ73yvER1XYO_311Wxo2wC8L2JuTdLJm8vgvhVVaGa5fdumXx5iHWarqwA=@protonmail.com>
 <YVAhOlTsb0NK0BVi@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YVAhOlTsb0NK0BVi@kroah.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi,

On Sun, Sep 26, 2021 at 09:28:58AM +0200, Greg Kroah-Hartman wrote:
> On Sun, Sep 26, 2021 at 07:23:33AM +0000, Jari Ruusu wrote:
> > Earlier this year there was some discussion about kernel version numbers
> > after 4.9.255 and 4.4.255. Problem was 8-bit limitation for SUBLEVEL
> > number in stable kernel versions. The fix was to freeze LINUX_VERSION_CODE
> > number at x.x.255 and to continue incrementing SUBLEVEL number. Seems
> > there are more more fallout from that decision. At least some versions of
> > glibc do not play well with larger SUBLEVEL numbers.
> > 
> > 
> > # uname -s -r -m
> > Linux 4.9.283-QEMU armv6l
> > # apt upgrade
> > Reading package lists... Done
> > Building dependency tree
> > Reading state information... Done
> > Calculating upgrade... Done
> > The following packages will be upgraded:
> >  [SNIP]
> > Fetched 145 MB in 1min 57s (1244 kB/s)
> > Reading changelogs... Done
> > Preconfiguring packages ...
> > (Reading database ... 39028 files and directories currently installed.)
> > Preparing to unpack .../libc6-dbg_2.28-10+rpt2+rpi1_armhf.deb ...
> > Unpacking libc6-dbg:armhf (2.28-10+rpt2+rpi1) over (2.28-10+rpi1) ...
> > Preparing to unpack .../libc6-dev_2.28-10+rpt2+rpi1_armhf.deb ...
> > Unpacking libc6-dev:armhf (2.28-10+rpt2+rpi1) over (2.28-10+rpi1) ...
> > Preparing to unpack .../libc-dev-bin_2.28-10+rpt2+rpi1_armhf.deb ...
> > Unpacking libc-dev-bin (2.28-10+rpt2+rpi1) over (2.28-10+rpi1) ...
> > Preparing to unpack .../linux-libc-dev_1%3a1.20210831-3~buster_armhf.deb ...
> > Unpacking linux-libc-dev:armhf (1:1.20210831-3~buster) over (1:1.20210527-1) ...
> > Preparing to unpack .../libc6_2.28-10+rpt2+rpi1_armhf.deb ...
> > ERROR: Your kernel version indicates a revision number
> > of 255 or greater.  Glibc has a number of built in
> > assumptions that this revision number is less than 255.
> > If you\'ve built your own kernel, please make sure that any
> > custom version numbers are appended to the upstream
> > kernel number with a dash or some other delimiter.
> > 
> > dpkg: error processing archive /var/cache/apt/archives/libc6_2.28-10+rpt2+rpi1_armhf.deb (--unpack):
> >  new libc6:armhf package pre-installation script subprocess returned error exit status 1
> > Errors were encountered while processing:
> >  /var/cache/apt/archives/libc6_2.28-10+rpt2+rpi1_armhf.deb
> > E: Sub-process /usr/bin/dpkg returned an error code (1)
> > 
> > 
> > 
> > Above upgrade works normally if I edit top level Linux source Makefile to
> > say "SUBLEVEL = 0" and re-compile new kernel.
> > 
> > I am not pointing any fingers here, but it seems that either glibc code or
> > stable kernel versioning is messed up.
> 
> Are you sure this isn't just a warning coming from a script that apt is
> running when trying to install glibc?  Or is this from the glibc package
> itself?
> 
> And what exactly is it testing?  We fixed the build time detection of
> the kernel version here, so you should be able to build glibc properly.
> 
> This is the first time we've seen this reported, are people using the
> newer kernels on systems that are not using glibc?

They are probably not using a problematic combination or a
distribution kernel on those systems. Looking from the mentioned
versions above this looks like a version derived from Debian buster.

Recently prompted due to https://bugs.debian.org/987266 the check was
removed in the postinst script of libc in Debian:
https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=987266 .

Regards,
Salvatore
