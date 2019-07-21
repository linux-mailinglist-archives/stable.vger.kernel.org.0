Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2E2B86F59C
	for <lists+stable@lfdr.de>; Sun, 21 Jul 2019 22:38:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726462AbfGUUi2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 21 Jul 2019 16:38:28 -0400
Received: from mail-pg1-f193.google.com ([209.85.215.193]:38295 "EHLO
        mail-pg1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725796AbfGUUi2 (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 21 Jul 2019 16:38:28 -0400
Received: by mail-pg1-f193.google.com with SMTP id f5so7797900pgu.5;
        Sun, 21 Jul 2019 13:38:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=iO+iPyFQkM1ZL64hEc+0DL6isJZcUzSGAfleOmXyrUU=;
        b=LMQwJjQ1tvUUG9mJ4W7Gca0Yc5nhcZfMc0lZdT1IMdS0t7/9Tk9w6qo/s5QkJBcW/C
         1ftte1/ukUFVue3R8ivPdZa9E6LUeynw5lqcGXf17ki9uKboYB3hDTNRM/ayUuGU/sO+
         W59tWrHWiO7v6P68I+ssoLzSpiUT0gYiiUQZqqxpgdaQJU0vONYIVAPylB5LZ6wfuJIq
         nzzuA4EbyXaIYKpetASY1taTNmd8ncSRIPBaKsJFlHL8PgtmdE0uGH1YJ7iqxBlS/r4S
         xpByDI/QFv6bSBNbS6KB6uojAySrkexc2XtTktKQATWJvDF64L3vgH/zVfOnrS5H/qTo
         7LRg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=iO+iPyFQkM1ZL64hEc+0DL6isJZcUzSGAfleOmXyrUU=;
        b=hgmTTqTyRlRx9DpzIFRuDN/ZS5sT5RrNIr53UvAN4K2/T7JjqXyCikVIZ2kxh5QiG8
         WN8OwcG0DuTfx5wsm5uOvgpHq5DxMS/jtezaHJgI5BLi/WHgrsNvZrajtFGjd5gol8Lw
         EVsWWxfTEzNj4MEdCFIOwrnwW+1Lk5RgsXTsaRJZxtAJ2GHnCAgsDWffsjFZZ4SPMO7H
         +6hj4/Ar14ljt3PMlcn6gvbaXGAf+wLfurq5BacjCUQ5rOYmindNp1GSWhV6W0zNMUEU
         qyt7Is/prA8TgVO95J8MXKzCsX4+xGV+8xXEDaPyz5ZIHKEYahe9Mrq5szfYat3nU9co
         85nw==
X-Gm-Message-State: APjAAAVWwyMGFQ3Y0kRO3kIpLZVyUQYdlt8vn5gcRmNIgIa2YtfaJdXu
        3LUwle+0IUBjAbgJZsl6jt1vuRR11a4MPA==
X-Google-Smtp-Source: APXvYqyIOZZW6KCdylHdgxsQuzgVif6+z4WdtfFUvlAFJ5VELeWzPFv/BBI76DVMExvQACcQaMY52g==
X-Received: by 2002:a17:90a:ac14:: with SMTP id o20mr73981057pjq.114.1563741506878;
        Sun, 21 Jul 2019 13:38:26 -0700 (PDT)
Received: from Gentoo ([103.231.91.69])
        by smtp.gmail.com with ESMTPSA id a3sm38982421pfo.49.2019.07.21.13.38.19
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 21 Jul 2019 13:38:25 -0700 (PDT)
Date:   Mon, 22 Jul 2019 02:08:07 +0530
From:   Bhaskar Chowdhury <unixbhaskar@gmail.com>
To:     Greg KH <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        torvalds@linux-foundation.org, stable@vger.kernel.org, lwn@lwn.net,
        Jiri Slaby <jslaby@suse.cz>
Subject: Re: Linux 5.2.2
Message-ID: <20190721203803.GA7362@Gentoo>
References: <20190721134918.GA23461@kroah.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="jRHKVT23PllUwdXP"
Content-Disposition: inline
In-Reply-To: <20190721134918.GA23461@kroah.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--jRHKVT23PllUwdXP
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline


Thanks, a bunch Greg!

On 15:49 Sun 21 Jul , Greg KH wrote:
>I'm announcing the release of the 5.2.2 kernel.
>
>All users of the 5.2 kernel series must upgrade.
>
>The updated 5.2.y git tree can be found at:
>	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linux-5.2.y
>and can be browsed at the normal kernel.org git web browser:
>	https://git.kernel.org/?p=linux/kernel/git/stable/linux-stable.git;a=summary
>
>thanks,
>
>greg k-h
>
>------------
>
> Makefile                                   |    2
> arch/arc/kernel/unwind.c                   |    9 +-
> arch/s390/include/asm/facility.h           |   21 ++++--
> arch/s390/include/asm/sclp.h               |    1
> arch/s390/kernel/ipl.c                     |    7 --
> arch/x86/entry/entry_32.S                  |   24 +++++++
> arch/x86/entry/entry_64.S                  |   30 +++++++-
> arch/x86/include/asm/hw_irq.h              |    5 +
> arch/x86/kernel/apic/apic.c                |   33 ++++++---
> arch/x86/kernel/apic/io_apic.c             |   46 +++++++++++++
> arch/x86/kernel/apic/vector.c              |    4 -
> arch/x86/kernel/idt.c                      |    3
> arch/x86/kernel/irq.c                      |    2
> drivers/base/cacheinfo.c                   |    3
> drivers/base/firmware_loader/fallback.c    |    2
> drivers/crypto/nx/nx-842-powernv.c         |    8 +-
> drivers/crypto/talitos.c                   |   99 ++++++++++++-----------------
> drivers/crypto/talitos.h                   |   30 ++++++++
> drivers/input/mouse/synaptics.c            |    1
> drivers/net/ethernet/intel/e1000e/netdev.c |   21 +++---
> drivers/s390/char/sclp_early.c             |    1
> drivers/s390/cio/qdio_setup.c              |    2
> drivers/s390/cio/qdio_thinint.c            |    5 -
> include/linux/cpuhotplug.h                 |    1
> include/uapi/linux/nilfs2_ondisk.h         |   24 +++----
> kernel/irq/autoprobe.c                     |    6 -
> kernel/irq/chip.c                          |    6 +
> kernel/irq/cpuhotplug.c                    |    2
> kernel/irq/internals.h                     |    5 +
> kernel/irq/manage.c                        |   90 ++++++++++++++++++++------
> 30 files changed, 341 insertions(+), 152 deletions(-)
>
>Arnd Bergmann (1):
>      ARC: hide unused function unw_hdr_alloc
>
>Christophe Leroy (2):
>      crypto: talitos - move struct talitos_edesc into talitos.h
>      crypto: talitos - fix hash on SEC1.
>
>Cole Rogers (1):
>      Input: synaptics - enable SMBUS on T480 thinkpad trackpad
>
>Greg Kroah-Hartman (1):
>      Linux 5.2.2
>
>Haren Myneni (1):
>      crypto/NX: Set receive window credits to max number of CRBs in RxFIFO
>
>Heiko Carstens (1):
>      s390: fix stfle zero padding
>
>James Morse (1):
>      drivers: base: cacheinfo: Ensure cpu hotplug work is done before Intel RDT
>
>Jiri Slaby (1):
>      x86/entry/32: Fix ENDPROC of common_spurious
>
>Julian Wiedmann (2):
>      s390/qdio: (re-)initialize tiqdio list entries
>      s390/qdio: don't touch the dsci in tiqdio_add_input_queues()
>
>Konstantin Khlebnikov (2):
>      Revert "e1000e: fix cyclic resets at link up with active tx"
>      e1000e: start network tx queue only when link is up
>
>Masahiro Yamada (1):
>      nilfs2: do not use unexported cpu_to_le32()/le32_to_cpu() in uapi header
>
>Philipp Rudo (1):
>      s390/ipl: Fix detection of has_secure attribute
>
>Sven Van Asbroeck (1):
>      firmware: improve LSM/IMA security behaviour
>
>Thomas Gleixner (6):
>      genirq: Delay deactivation in free_irq()
>      genirq: Fix misleading synchronize_irq() documentation
>      genirq: Add optional hardware synchronization for shutdown
>      x86/ioapic: Implement irq_get_irqchip_state() callback
>      x86/irq: Handle spurious interrupt after shutdown gracefully
>      x86/irq: Seperate unused system vectors from spurious entry again
>



--jRHKVT23PllUwdXP
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCAAdFiEEnwF+nWawchZUPOuwsjqdtxFLKRUFAl00zScACgkQsjqdtxFL
KRVh3QgA0cmZqjBdqm8sfTKIj1yWyJUHABDWdT+/s0+GrmuZNhj3axQU7I4RO3v8
hd7MAH1lDMY9JsqS+yU3tZvusf82eSVRZwHKA/SqJv/XhJO3G3oI8ds/4fQJB0IO
Z9bmdy9aRU1JBGm54AtXwFmpyox6m/c5Jq4HvQKbxy3TNS+aWs712VXEF4ylvpdu
vlOjJdDozMrWrD5omSDvdoEOk8+1VQP1Rj1XULWq+nbwdQbygDeWQAg1fWu8o+MZ
nLu9pHdcHIHUfPVHziZ9heVxPov8UMePIWUxBlLdnjaTX5+fEGaUtOHvFxbcF5qj
lXltw77Vaflk8kNxTxx8iiWHJkr6Zg==
=Vb6f
-----END PGP SIGNATURE-----

--jRHKVT23PllUwdXP--
