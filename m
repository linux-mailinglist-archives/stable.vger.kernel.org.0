Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2E9A380AD3
	for <lists+stable@lfdr.de>; Sun,  4 Aug 2019 14:09:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726180AbfHDMJv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 4 Aug 2019 08:09:51 -0400
Received: from mail-pf1-f193.google.com ([209.85.210.193]:33555 "EHLO
        mail-pf1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726017AbfHDMJv (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 4 Aug 2019 08:09:51 -0400
Received: by mail-pf1-f193.google.com with SMTP id g2so38219526pfq.0;
        Sun, 04 Aug 2019 05:09:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=0oU/P08csPbrsVNjlyA+PCEjGUi14iVClKVIfaCVVlo=;
        b=olwta0MF1ImQahZi4MRvxehHl8CP3KVoD0vV1nMtuqZCp6qNU6dAvljqwfHubwMDAo
         Xq6Lj1pY3Tk0becrAEwnGdZWnh+ZSiH+68MBzpRBLlEcbJOuN1IqFNshIK/tRjEGbEql
         5NYr+s6FJK8B7qi/w+upVtH/9jajjrxnxGJThL1aUee4fYmKvfsa/ooVmuWDTKao3UyK
         dnfyOZ0hy+inKSQgscCUxVFePHP0yfLfC1B0iEcGF+xyAPjZyapK7Dzw3ReFZ3lPy2OM
         qSbybWB86XovnRMnYaDY1yrD7J1QW+8WQr7ROp6AjVmxoGJqyCHODjaEsh9dZd08SMGx
         fw7w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=0oU/P08csPbrsVNjlyA+PCEjGUi14iVClKVIfaCVVlo=;
        b=VaeVu42r+VCQJQE8+YxpWqxaaPMAGiBQT68HKena/ie1uSu+j3R8+X7yx7tVx6LCPB
         6Ew9Pb6rDHe0nz3LiyjjXiI+Oohzs7AIo8E2tXlxpDBAUOT9FId3xePp8WySyQG/FPeX
         xb8QF+4YkklHJN8/ANgZSKAA++p2BmqMne9vDN74e1yL9lpYYumOzKhxO9Yrl9mH9F7t
         mIJ1I31nbmLyW/Pu2zwSoR5Z/b777qYuF/svV6dYaXCGJ9qKHWk3nbWZjaeiYUz2Wbtm
         HflSln4RxRWc4Ez/IcU66it8G7tXDTmHZOWFXWlcljnRCbte0VDYYdxHwIOjDSOhtipo
         bJLQ==
X-Gm-Message-State: APjAAAWNlI/ymi2CC+nbHxDuZqtJcrvrR+1jf1eMGVXZIVaDrEW21noa
        c4woTf6anWlHYWmSwVrf9R0=
X-Google-Smtp-Source: APXvYqxnq8FarMgEDje68eQqZg5zUCceyukO8REM/Vx0HfJ007iHS5UMtt72JbTyN7CAOPnCGwyrwA==
X-Received: by 2002:a17:90a:1904:: with SMTP id 4mr13685396pjg.116.1564920590033;
        Sun, 04 Aug 2019 05:09:50 -0700 (PDT)
Received: from Gentoo ([103.231.91.35])
        by smtp.gmail.com with ESMTPSA id r1sm74669092pgv.70.2019.08.04.05.09.43
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 04 Aug 2019 05:09:48 -0700 (PDT)
Date:   Sun, 4 Aug 2019 17:39:35 +0530
From:   Bhaskar Chowdhury <unixbhaskar@gmail.com>
To:     Greg KH <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        torvalds@linux-foundation.org, stable@vger.kernel.org, lwn@lwn.net,
        Jiri Slaby <jslaby@suse.cz>
Subject: Re: Linux 5.2.6
Message-ID: <20190804120932.GA13565@Gentoo>
References: <20190804101415.GA27152@kroah.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="envbJBWh7q8WU6mo"
Content-Disposition: inline
In-Reply-To: <20190804101415.GA27152@kroah.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--envbJBWh7q8WU6mo
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline


Thanks, a bunch Greg! :)


On 12:14 Sun 04 Aug 2019, Greg KH wrote:
>I'm announcing the release of the 5.2.6 kernel.
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
> Makefile                                     |    2
> arch/sh/boards/Kconfig                       |   14 --
> drivers/bluetooth/hci_ath.c                  |    3
> drivers/bluetooth/hci_bcm.c                  |    3
> drivers/bluetooth/hci_intel.c                |    3
> drivers/bluetooth/hci_ldisc.c                |   13 ++
> drivers/bluetooth/hci_mrvl.c                 |    3
> drivers/bluetooth/hci_qca.c                  |    3
> drivers/bluetooth/hci_uart.h                 |    1
> drivers/isdn/hardware/mISDN/hfcsusb.c        |    3
> drivers/media/radio/radio-raremono.c         |   30 ++++-
> drivers/media/usb/au0828/au0828-core.c       |   12 +-
> drivers/media/usb/cpia2/cpia2_usb.c          |    3
> drivers/media/usb/pvrusb2/pvrusb2-hdw.c      |    4
> drivers/media/usb/pvrusb2/pvrusb2-i2c-core.c |    6 -
> drivers/media/usb/pvrusb2/pvrusb2-std.c      |    2
> drivers/net/wireless/ath/ath10k/usb.c        |    2
> drivers/nvme/host/multipath.c                |    8 -
> drivers/nvme/host/nvme.h                     |    6 -
> drivers/pps/pps.c                            |    8 +
> fs/ceph/caps.c                               |   10 +
> fs/ceph/inode.c                              |    2
> fs/ceph/super.h                              |    2
> fs/exec.c                                    |    2
> fs/nfs/client.c                              |    4
> fs/proc/base.c                               |  132 ++++++++++++++----------
> include/linux/sched.h                        |   10 +
> include/linux/sched/numa_balancing.h         |    4
> kernel/bpf/btf.c                             |   12 +-
> kernel/fork.c                                |    2
> kernel/sched/fair.c                          |  144 ++++++++++++++++++---------
> net/vmw_vsock/af_vsock.c                     |   38 +------
> net/xfrm/xfrm_policy.c                       |   12 +-
> tools/testing/selftests/net/xfrm_policy.sh   |   27 ++++-
> 34 files changed, 334 insertions(+), 196 deletions(-)
>
>Andrey Konovalov (1):
>      media: pvrusb2: use a different format for warnings
>
>Benjamin Coddington (1):
>      NFS: Cleanup if nfs_match_client is interrupted
>
>Fabio Estevam (1):
>      ath10k: Change the warning message string
>
>Florian Westphal (1):
>      xfrm: policy: fix bydst hlist corruption on hash rebuild
>
>Greg Kroah-Hartman (1):
>      Linux 5.2.6
>
>Jann Horn (2):
>      sched/fair: Don't free p->numa_faults with concurrent readers
>      sched/fair: Use RCU accessors consistently for ->numa_group
>
>Linus Torvalds (2):
>      /proc/<pid>/cmdline: remove all the special cases
>      /proc/<pid>/cmdline: add back the setproctitle() special case
>
>Luke Nowakowski-Krijger (1):
>      media: radio-raremono: change devm_k*alloc to k*alloc
>
>Marta Rybczynska (1):
>      nvme: fix multipath crash when ANA is deactivated
>
>Miroslav Lichvar (1):
>      drivers/pps/pps.c: clear offset flags in PPS_SETPARAMS ioctl
>
>Oliver Neukum (1):
>      media: cpia2_usb: first wake up, then free in disconnect
>
>Phong Tran (1):
>      ISDN: hfcsusb: checking idx of ep configuration
>
>Sean Young (1):
>      media: au0828: fix null dereference in error path
>
>Stanislav Fomichev (1):
>      bpf: fix NULL deref in btf_type_is_resolve_source_only
>
>Sunil Muthuswamy (1):
>      vsock: correct removal of socket from the list
>
>Vladis Dronov (1):
>      Bluetooth: hci_uart: check for missing tty operations
>
>Yan, Zheng (1):
>      ceph: hold i_ceph_lock when removing caps for freeing inode
>
>Yoshinori Sato (1):
>      Fix allyesconfig output.
>



--envbJBWh7q8WU6mo
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCAAdFiEEnwF+nWawchZUPOuwsjqdtxFLKRUFAl1GyvUACgkQsjqdtxFL
KRVmawf7BEzQsoPUWEVEcKLT8fu2AzQ1Cr6rhLrocS1y0SGdKqyfAmPsrfP1lUkF
RcDT1swSrwRkZCrbxUimLMbnfmII8q/bmHU+gicFNIuB3ind292o0ancMVXRFUFR
U+CYLMQfnnfXQGKuQfs3x/dFm/aYizuouLXG+M2TXvsnHj+vdOLM+BHCRoNmAEEb
+U5Chu8Gksrb21f3doD9/D3vm7fHQq3QWwG1B0x3h3ECJ3Oy2FhB6bwranwXv6lp
lvU9lsz+bGQJbt4iXZPFCYjyOOsi+8vPKkMD80M5sxUVi0A3tq9oYDJbXQj0D/tM
VAYaR4CUjuWkg0ISe7zxhX0FI+hJIA==
=uett
-----END PGP SIGNATURE-----

--envbJBWh7q8WU6mo--
