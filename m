Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CA847114500
	for <lists+stable@lfdr.de>; Thu,  5 Dec 2019 17:43:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726589AbfLEQnU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 5 Dec 2019 11:43:20 -0500
Received: from mail-pg1-f195.google.com ([209.85.215.195]:33334 "EHLO
        mail-pg1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726257AbfLEQnU (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 5 Dec 2019 11:43:20 -0500
Received: by mail-pg1-f195.google.com with SMTP id 6so1866116pgk.0;
        Thu, 05 Dec 2019 08:43:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=/Kg3ic6vfzzY+tD+Eb6Mef6O1iQduVFjM0GirwvkKkM=;
        b=BkEGAI4jJlzmkY07OkDdIIztw00ozz9cB/gcTTYv6r0/4BEefrKF9B2oXOFfc/u/8U
         S/HQLA99+Dnv07XB6XBUjOavjbxlp4bJqsqt9RyoXcIk+F9dMeEm1AptJMLMypjHvB69
         afZxyhgDPT870L7vj3N1mVeU/yLil65lcilgMqdxHi8cjkic7pf3gs9qEsnsr+eX3wvQ
         1AQVijQfM4Vf6en4CQlaT4+n9QK/12KKBpgifOpw01ASwaDi7dGqrGV+XkAnSE6X6e7w
         LcFTYXoUHWe2uEB0rwjXgcei/Cr79XUmY7b+84Dod9232xc5Ut4cav6FW+mFGIWXWz3U
         w5zA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=/Kg3ic6vfzzY+tD+Eb6Mef6O1iQduVFjM0GirwvkKkM=;
        b=Ccv624BMoVeIQ4DFebTyChX+MziQadGmXSdgH3vORe1z8Aao4CKPMlO5VIbqBA/7wV
         WzOKOEmp2qQhn+ufwtWNtVL6fTR09BktowZpIQHzxBQUQep7wYwoCC9xZjcTJys7/N3m
         Ef5uOhDHO+imQSaKsENrAaEED2Bijo4I1uLC2Dh4i4YHUeQQiqZxSEDQPdLxMDP8Eis/
         1ey2PogZ1kX0BNsQOSKJI4j9LTb+FZikwxlGV0CQV2Fo4w/AkoECoTx5gYz0PYtvnmiA
         y6IUEj0HM/ddkCwHjY4nqhbDgPxBwN7Yr+C1OnR1+TXxKYZmS9+KPc/ILM4E4WWoOcrz
         fh4A==
X-Gm-Message-State: APjAAAUIGV2tjnVbdrx5eUWaaHsKXD0CxFMnfPNOtnuDpK2l4kZsRAqu
        m4GA0x8DRaxwTBTjEtF+Ce2066HYcEY=
X-Google-Smtp-Source: APXvYqwv0MiaCl9L82w5TpnSBWgpq9wBfwL4FJZ5xXsxoJ9nOdyzZ9YQjvIONuujWxzvfJI42jLf7Q==
X-Received: by 2002:a63:2acc:: with SMTP id q195mr10082478pgq.26.1575564199593;
        Thu, 05 Dec 2019 08:43:19 -0800 (PST)
Received: from workstation-kernel-dev ([103.211.17.187])
        by smtp.gmail.com with ESMTPSA id h3sm12231251pgr.81.2019.12.05.08.43.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 05 Dec 2019 08:43:18 -0800 (PST)
Date:   Thu, 5 Dec 2019 22:13:12 +0530
From:   Amol Grover <frextrite@gmail.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, ben.hutchings@codethink.co.uk,
        lkft-triage@lists.linaro.org, stable@vger.kernel.org
Subject: Re: [PATCH 5.4 00/46] 5.4.2-stable review
Message-ID: <20191205164312.GA6105@workstation-kernel-dev>
References: <20191203212705.175425505@linuxfoundation.org>
 <20191204132318.GA14649@workstation-kernel-dev>
 <20191204171322.GB3627415@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191204171322.GB3627415@kroah.com>
User-Agent: Mutt/1.12.2 (2019-09-21)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Dec 04, 2019 at 06:13:22PM +0100, Greg Kroah-Hartman wrote:
> On Wed, Dec 04, 2019 at 06:53:18PM +0530, Amol Grover wrote:
> > On Tue, Dec 03, 2019 at 11:35:20PM +0100, Greg Kroah-Hartman wrote:
> > > This is the start of the stable review cycle for the 5.4.2 release.
> > > There are 46 patches in this series, all will be posted as a response
> > > to this one.  If anyone has any issues with these being applied, please
> > > let me know.
> > > 
> > > Responses should be made by Thu, 05 Dec 2019 21:20:36 +0000.
> > > Anything received after that time might be too late.
> > > 
> > > The whole patch series can be found in one patch at:
> > > 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.4.2-rc1.gz
> > > or in the git tree and branch at:
> > > 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.4.y
> > > and the diffstat can be found below.
> > > 
> > > thanks,
> > > 
> > > greg k-h
> > > 
> > > -------------
> > > Pseudo-Shortlog of commits:
> > > 
> > > Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> > >     Linux 5.4.2-rc1
> > > 
> > > Hans de Goede <hdegoede@redhat.com>
> > >     platform/x86: hp-wmi: Fix ACPI errors caused by passing 0 as input size
> > > 
> > > Hans de Goede <hdegoede@redhat.com>
> > >     platform/x86: hp-wmi: Fix ACPI errors caused by too small buffer
> > > 
> > > Candle Sun <candle.sun@unisoc.com>
> > >     HID: core: check whether Usage Page item is after Usage ID items
> > > 
> > > Herbert Xu <herbert@gondor.apana.org.au>
> > >     crypto: talitos - Fix build error by selecting LIB_DES
> > > 
> > > Joel Stanley <joel@jms.id.au>
> > >     Revert "jffs2: Fix possible null-pointer dereferences in jffs2_add_frag_to_fragtree()"
> > > 
> > > Theodore Ts'o <tytso@mit.edu>
> > >     ext4: add more paranoia checking in ext4_expand_extra_isize handling
> > > 
> > > Heiner Kallweit <hkallweit1@gmail.com>
> > >     r8169: fix resume on cable plug-in
> > > 
> > > Heiner Kallweit <hkallweit1@gmail.com>
> > >     r8169: fix jumbo configuration for RTL8168evl
> > > 
> > > Thadeu Lima de Souza Cascardo <cascardo@canonical.com>
> > >     selftests: pmtu: use -oneline for ip route list cache
> > > 
> > > John Rutherford <john.rutherford@dektech.com.au>
> > >     tipc: fix link name length check
> > > 
> > > Jakub Kicinski <jakub.kicinski@netronome.com>
> > >     selftests: bpf: correct perror strings
> > > 
> > > Jakub Kicinski <jakub.kicinski@netronome.com>
> > >     selftests: bpf: test_sockmap: handle file creation failures gracefully
> > > 
> > > Jakub Kicinski <jakub.kicinski@netronome.com>
> > >     net/tls: use sg_next() to walk sg entries
> > > 
> > > Jakub Kicinski <jakub.kicinski@netronome.com>
> > >     net/tls: remove the dead inplace_crypto code
> > > 
> > > Jakub Kicinski <jakub.kicinski@netronome.com>
> > >     selftests/tls: add a test for fragmented messages
> > > 
> > 
> > Hi,
> > I'm not sure if this is relevant but I tested out the latest revision
> > of tools/testing/selftests/net/tls (run as sudo) with 5.3.9, 5.3.13,
> > and 5.4.1, and all of them resulted in Oops. I'm not sure that it
> > happens only on my PC but the old version worked fine on all 3 kernels.
> > 
> > More information available in this thread:
> > https://lore.kernel.org/stable/20191203171817.GA24581@workstation-portable/
> 
> Any specific commit cause this issue?  Should I drop one/any of these?
> 

The specific commit I'm talking about is the 32nd patch in this series
[PATCH 5.4 32/46] selftests/tls: add a test for fragmented messages
[ Upstream commit 65190f77424d7b82c4aad7326c9cce6bd91a2fcc ]

But it looks like everything is working fine for everyone, so maybe,
it could be a problem specific to my distro/hardware/settings.

Thanks
Amol

> thanks,
> 
> greg k-h
