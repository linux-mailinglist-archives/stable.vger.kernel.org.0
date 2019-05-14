Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6DD641E4E4
	for <lists+stable@lfdr.de>; Wed, 15 May 2019 00:20:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726303AbfENWTz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 14 May 2019 18:19:55 -0400
Received: from mail-pf1-f193.google.com ([209.85.210.193]:46425 "EHLO
        mail-pf1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727079AbfENWTx (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 14 May 2019 18:19:53 -0400
Received: by mail-pf1-f193.google.com with SMTP id y11so210253pfm.13;
        Tue, 14 May 2019 15:19:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=NpNKWpk0dhZtsgjTpnTjpNeuJvE2ie8OCm0VYOC11Yw=;
        b=Ymgdp0ww36ijbybPmnjvX3CkRq8JPXQuyDODxbY7p/eQxFpqNA6vOJ49PcY+/1cDes
         eIoCiQMMnyb9BOfiEzd6N30U0mawYsZHeiMHLNyzLztJBjMApyFqL3Y03kJFhxh/Y5VE
         vjZ0H0n9+dsPGZpubSkJS0eAHSKoXcdTA0tNEi6A3P236THgmS3AMtVZPjmfi/o/bi2b
         Z4e/7HfO3g0l4GRy1AQKdXN8xQtwRZdoakoaEvhirIiwkNNF1YbbrvHss4QfhOatCM6W
         Fd9dKd/l/1SdoK4OzQ9V9noV7kZ4djcjtxvsEkljmjcMIEZZJ3UrQdm0B7JamQNImMsA
         pkZw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=NpNKWpk0dhZtsgjTpnTjpNeuJvE2ie8OCm0VYOC11Yw=;
        b=qmuHB2tV2FijE/J1gyoS1d2TmU6WfyweHdYQKhf7ZuMmKsM1hvNRWZEhFFxlhRqOmJ
         31FAAD04qm6X7dJpZVJJH3MFnm2nyBnUy7TKqDkBw+IU+NVo404dzFe20vw9IM5jX7SF
         Gdov3eMeRPvO3OKRvGqTqTu8Gaxot5rKtdeessM2ncyQZt+JNftpy9NY8Y0Oo0gVWEX+
         6+Od88s7QbjMYk2UuWQyOMrAK4989E8TO53A5FPivuXOWgYIsZZLZv9a1Fu4ksO9F9ZQ
         XSwFBxk5lzfT+rFoy6rEtS6nbwz6TN81Hyp0oib/cHJl825S5SNbUpprRb5JP7bRU4BC
         BoYA==
X-Gm-Message-State: APjAAAWJ/qLgCE+CHqYewVRVcVl6Gcv6MbWOMDt6YRauSLAvRy8BJ/bx
        K5bnqrf6qJZAuGjtlsv5PnqSwYa79Do=
X-Google-Smtp-Source: APXvYqwSr/tHvF6QYBxfVFYDBHbQN2t1+/McP1SUoNaQ0m1qacR4Hoh/Bvnh7fzBfICIgJtPCcEPAw==
X-Received: by 2002:a63:3c14:: with SMTP id j20mr40679521pga.410.1557872392566;
        Tue, 14 May 2019 15:19:52 -0700 (PDT)
Received: from Gentoo ([103.231.91.66])
        by smtp.gmail.com with ESMTPSA id i17sm141046pfo.103.2019.05.14.15.19.45
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 14 May 2019 15:19:51 -0700 (PDT)
Date:   Wed, 15 May 2019 03:49:39 +0530
From:   Bhaskar Chowdhury <unixbhaskar@gmail.com>
To:     Greg KH <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        torvalds@linux-foundation.org, stable@vger.kernel.org, lwn@lwn.net,
        Jiri Slaby <jslaby@suse.cz>
Subject: Re: Linux 5.1.2
Message-ID: <20190514221939.GA18303@Gentoo>
References: <20190514180424.GA11131@kroah.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="3V7upXqbjpZ4EhLz"
Content-Disposition: inline
In-Reply-To: <20190514180424.GA11131@kroah.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--3V7upXqbjpZ4EhLz
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline

Thanks, a bunch Greg!

On 20:04 Tue 14 May , Greg KH wrote:
>I'm announcing the release of the 5.1.2 kernel.
>
>All users of the 5.1 kernel series must upgrade.  Well, kind of, let me rephrase that...
>
>All users of Intel processors made since 2011 must upgrade.
>
>Note, this release, and the other stable releases that are all being
>released right now at the same time, just went out all contain patches
>that have only seen the "public eye" for about 5 minutes.  So be
>forwarned, they might break things, they might not build, but hopefully
>they fix things.  Odds are we will be fixing a number of small things in
>this area for the next few weeks as things shake out on real hardware
>and workloads.  So don't think you are done updating your kernel, you
>never are done with that :)
>
>As for what specifically these changes fix, I'll let the tech news sites
>fill you in on the details.  Or go read the excellently written Xen
>Security Advisory 297:
>	https://xenbits.xen.org/xsa/advisory-297.html
>That should give you a good idea of what a number of people have been
>dealing with for many many many months now.
>
>Many thanks goes out to Thomas Gleixner for going above and beyond to do
>the backports to the 5.1, 5.0, 4.19, and 4.14 kernel trees, and to Ben
>Hutchings for doing the 4.9 work.  And of course to all of the
>developers who have been working on this in secret and doing reviews of
>the many different proposals and versions of the patches.
>
>As I said before just over a year ago, Intel once again owes a bunch of
>people a lot of drinks for fixing their hardware bugs, in our
>software...
>
>Anyway, as usual, the updated 5.1.y git tree can be found at:
>	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linux-5.1.y
>and can be browsed at the normal kernel.org git web browser:
>	https://git.kernel.org/?p=linux/kernel/git/stable/linux-stable.git;a=summary
>
>thanks,
>
>greg k-h
>
>------------
>
> Documentation/ABI/testing/sysfs-devices-system-cpu |    4
> Documentation/admin-guide/hw-vuln/index.rst        |   13
> Documentation/admin-guide/hw-vuln/l1tf.rst         |  615 +++++++++++++++++++++
> Documentation/admin-guide/hw-vuln/mds.rst          |  308 ++++++++++
> Documentation/admin-guide/index.rst                |    6
> Documentation/admin-guide/kernel-parameters.txt    |   62 ++
> Documentation/admin-guide/l1tf.rst                 |  614 --------------------
> Documentation/index.rst                            |    1
> Documentation/x86/conf.py                          |   10
> Documentation/x86/index.rst                        |    8
> Documentation/x86/mds.rst                          |  225 +++++++
> Makefile                                           |    2
> arch/powerpc/kernel/security.c                     |    6
> arch/powerpc/kernel/setup_64.c                     |    2
> arch/s390/kernel/nospec-branch.c                   |    3
> arch/x86/entry/common.c                            |    3
> arch/x86/include/asm/cpufeatures.h                 |    3
> arch/x86/include/asm/irqflags.h                    |    4
> arch/x86/include/asm/msr-index.h                   |   39 -
> arch/x86/include/asm/mwait.h                       |    7
> arch/x86/include/asm/nospec-branch.h               |   50 +
> arch/x86/include/asm/processor.h                   |    6
> arch/x86/kernel/cpu/bugs.c                         |  146 ++++
> arch/x86/kernel/cpu/common.c                       |  121 ++--
> arch/x86/kernel/nmi.c                              |    4
> arch/x86/kernel/traps.c                            |    8
> arch/x86/kvm/cpuid.c                               |    3
> arch/x86/kvm/vmx/vmx.c                             |    7
> arch/x86/mm/pti.c                                  |    4
> drivers/base/cpu.c                                 |    8
> include/linux/cpu.h                                |   26
> kernel/cpu.c                                       |   15
> tools/power/x86/turbostat/Makefile                 |    2
> tools/power/x86/x86_energy_perf_policy/Makefile    |    2
> 34 files changed, 1632 insertions(+), 705 deletions(-)
>
>Andi Kleen (2):
>      x86/speculation/mds: Add basic bug infrastructure for MDS
>      x86/kvm: Expose X86_FEATURE_MD_CLEAR to guests
>
>Boris Ostrovsky (1):
>      x86/speculation/mds: Fix comment
>
>Greg Kroah-Hartman (1):
>      Linux 5.1.2
>
>Josh Poimboeuf (9):
>      x86/speculation/mds: Add mds=full,nosmt cmdline option
>      x86/speculation: Move arch_smt_update() call to after mitigation decisions
>      x86/speculation/mds: Add SMT warning message
>      cpu/speculation: Add 'mitigations=' cmdline option
>      x86/speculation: Support 'mitigations=' cmdline option
>      powerpc/speculation: Support 'mitigations=' cmdline option
>      s390/speculation: Support 'mitigations=' cmdline option
>      x86/speculation/mds: Add 'mitigations=' support for MDS
>      x86/speculation/mds: Fix documentation typo
>
>Konrad Rzeszutek Wilk (1):
>      x86/speculation/mds: Print SMT vulnerable on MSBDS with mitigations off
>
>Thomas Gleixner (12):
>      x86/msr-index: Cleanup bit defines
>      x86/speculation: Consolidate CPU whitelists
>      x86/speculation/mds: Add BUG_MSBDS_ONLY
>      x86/speculation/mds: Add mds_clear_cpu_buffers()
>      x86/speculation/mds: Clear CPU buffers on exit to user
>      x86/kvm/vmx: Add MDS protection when L1D Flush is not active
>      x86/speculation/mds: Conditionally clear CPU buffers on idle entry
>      x86/speculation/mds: Add mitigation control for MDS
>      x86/speculation/mds: Add sysfs reporting for MDS
>      x86/speculation/mds: Add mitigation mode VMWERV
>      Documentation: Move L1TF to separate directory
>      Documentation: Add MDS vulnerability documentation
>
>Tyler Hicks (1):
>      Documentation: Correct the possible MDS sysfs values
>
>speck for Pawan Gupta (1):
>      x86/mds: Add MDSUM variant to the MDS documentation
>



--3V7upXqbjpZ4EhLz
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCAAdFiEEnwF+nWawchZUPOuwsjqdtxFLKRUFAlzbPvcACgkQsjqdtxFL
KRVIYwf/d4rMZRSS+y1x9heAi7GgBYRpVpMZGAG6uKgSNd61XnNK6nqoC8ZOxU6w
Z8zk7BFeQNXimKcS7+MMkIlntqBvXQUMSAVa5JHvVSTYug9Q8YRtj7A+RiybYtwI
uXG1/FvYFXwkq7+Os9kxm71ul+MBVUIxK2MElnoUOQ65dhkHkp2iPd+/gqZnBwez
uM8axjJMtElkxgHps6Z4o+njs7NH4ZvAjt5dirTsznvoaRqXhpcWTkfPeklo+Jqv
xG+CpaOM0LXCLwKK1SLQ708ocmJag/BnSkZQo89w+EMIWX0Qqk7In75+zkwRDNOc
DeoY1GjBKuj7Q1NWisjzP6d2pAqeHA==
=8SQM
-----END PGP SIGNATURE-----

--3V7upXqbjpZ4EhLz--
