Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BED9213FD6
	for <lists+stable@lfdr.de>; Sun,  5 May 2019 15:57:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727034AbfEEN5k (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 5 May 2019 09:57:40 -0400
Received: from mail-pg1-f195.google.com ([209.85.215.195]:44004 "EHLO
        mail-pg1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726397AbfEEN5k (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 5 May 2019 09:57:40 -0400
Received: by mail-pg1-f195.google.com with SMTP id t22so5097537pgi.10;
        Sun, 05 May 2019 06:57:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=kiLfJH5jU/hOkiz3x6H+KTq6Vc5gQmTSfx+f2yO7Agc=;
        b=eUMlyLcGrtyJ0eK5QZBklMa26KdKmMUarCA+XZ9Gs9flgsZ1uHyQ4LLbnrEaOawauk
         Se6MjQEt3ltfTWYlrOsKFVU7+q9urHRGjCFzyBodwsgq/g1+CEh1CwgrWMWq17GR9gKS
         kbfiucNQjGORRiMiiexz6Mxd9uI5GkIfJWuicdMiiNheyTSKy5yJoRqIY0DYS+S55brU
         eeMJFCDsbJzhykdbYeXF4xzCbb/6WD0AFVYQufGneTm+XVjby5SHS8Fky58Uhj87mqDx
         LnplESUH6OeQ4r2oZc88Jrnwq+ZQPzcel4UvivxJGe5mlJR27f/SjYlPBodVuINHZG/D
         FOwA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=kiLfJH5jU/hOkiz3x6H+KTq6Vc5gQmTSfx+f2yO7Agc=;
        b=VtnAUTSQ1PEMfck+4dcNWKgsTQ4R561iHnaGNch+01xSGyfa1y3XIGJc6xSaKs29ze
         CvhIzbF0Lx9s03ZWxqCzOuBLaC7lMssACyh1SX+nH9CRwRnGdAWOFyeUWBCopfjhA9+7
         dBMlFkxUNA3UoO71bqUMTZixqNhoyJh8cX34Alsx3GEbvjZoNgxtnnDoogyD69aamRE9
         AKjKvNRRZisulcEsozBiLWZvN4K1tU7yHdmwJieSnJY5qsfzZ5Daz/zxDAxl+OXHzS5y
         f5MigasAOqIWiu9XYSfE94TxK8wwoufL1rWLGk5zmKfKvBwpb6EdsZJ3MCo4+TpJPRj3
         NqAQ==
X-Gm-Message-State: APjAAAVfzahtkWJK6HvgJBpYAXeIZg0ejcQ/aTaMWq6mbr7Bou/yB7gZ
        EMjEoH486XYyI/PZ+vs73Ug=
X-Google-Smtp-Source: APXvYqyVveF+Pc66wf/A7U2VQt9NP+b4tfWWPWzg/7K8UEackNkzHjLDQdsJ5XH1qWwlRgi8/Z++nA==
X-Received: by 2002:aa7:9151:: with SMTP id 17mr25227560pfi.192.1557064659203;
        Sun, 05 May 2019 06:57:39 -0700 (PDT)
Received: from Gentoo ([103.231.91.70])
        by smtp.gmail.com with ESMTPSA id y4sm9023637pgj.34.2019.05.05.06.57.31
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 05 May 2019 06:57:37 -0700 (PDT)
Date:   Sun, 5 May 2019 19:27:25 +0530
From:   Bhaskar Chowdhury <unixbhaskar@gmail.com>
To:     Greg KH <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        torvalds@linux-foundation.org, stable@vger.kernel.org, lwn@lwn.net,
        Jiri Slaby <jslaby@suse.cz>
Subject: Re: Linux 5.0.13
Message-ID: <20190505135725.GB11883@Gentoo>
References: <20190505134151.GA8399@kroah.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="4SFOXa2GPu3tIq4H"
Content-Disposition: inline
In-Reply-To: <20190505134151.GA8399@kroah.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--4SFOXa2GPu3tIq4H
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline

Thanks, a bunch man!

On 15:41 Sun 05 May , Greg KH wrote:
>I'm announcing the release of the 5.0.13 kernel.
>
>All users of the 5.0 kernel series must upgrade.
>
>The updated 5.0.y git tree can be found at:
>	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linux-5.0.y
>and can be browsed at the normal kernel.org git web browser:
>	http://git.kernel.org/?p=linux/kernel/git/stable/linux-stable.git;a=summary
>
>thanks,
>
>greg k-h
>
>------------
>
> Makefile                                             |    2
> arch/x86/include/uapi/asm/kvm.h                      |    1
> arch/x86/kvm/vmx/nested.c                            |    4 -
> arch/x86/kvm/x86.c                                   |   21 ++++++
> drivers/net/dsa/bcm_sf2_cfp.c                        |    6 +
> drivers/net/ethernet/broadcom/bnxt/bnxt.c            |   53 ++++++++++------
> drivers/net/phy/marvell.c                            |    6 +
> drivers/net/wireless/ath/ath10k/mac.c                |    4 -
> drivers/net/wireless/intel/iwlwifi/mvm/debugfs-vif.c |    5 +
> include/net/sctp/command.h                           |    1
> net/ipv4/ip_output.c                                 |    1
> net/ipv4/tcp_ipv4.c                                  |   13 +++-
> net/ipv4/udp_offload.c                               |   16 +++--
> net/ipv6/ip6_fib.c                                   |    4 -
> net/ipv6/ip6_flowlabel.c                             |   22 ++++--
> net/ipv6/route.c                                     |   47 ++++++--------
> net/l2tp/l2tp_core.c                                 |   10 +--
> net/packet/af_packet.c                               |   37 +++++++----
> net/rxrpc/call_object.c                              |   32 +++++-----
> net/sctp/sm_sideeffect.c                             |   29 ---------
> net/sctp/sm_statefuns.c                              |   35 ++++++++---
> net/tls/tls_device.c                                 |   39 ++++++++----
> net/tls/tls_device_fallback.c                        |    3
> sound/usb/line6/driver.c                             |   60 +++++++++++--------
> sound/usb/line6/podhd.c                              |   21 +++---
> sound/usb/line6/toneport.c                           |   24 +++++--
> tools/testing/selftests/net/fib_rule_tests.sh        |   10 ++-
> 27 files changed, 308 insertions(+), 198 deletions(-)
>
>Andrew Lunn (1):
>      net: phy: marvell: Fix buffer overrun with stats counters
>
>Dan Carpenter (1):
>      net: dsa: bcm_sf2: fix buffer overflow doing set_rxnfc
>
>David Ahern (1):
>      selftests: fib_rule_tests: Fix icmp proto with ipv6
>
>David Howells (1):
>      rxrpc: Fix net namespace cleanup
>
>Eric Dumazet (6):
>      ipv6: fix races in ip6_dst_destroy()
>      ipv6/flowlabel: wait rcu grace period before put_pid()
>      l2ip: fix possible use-after-free
>      l2tp: use rcu_dereference_sk_user_data() in l2tp_udp_encap_recv()
>      tcp: add sanity tests in tcp_add_backlog()
>      udp: fix GRO packet of death
>
>Greg Kroah-Hartman (3):
>      ALSA: line6: use dynamic buffers
>      iwlwifi: mvm: properly check debugfs dentry before using it
>      Linux 5.0.13
>
>Hangbin Liu (1):
>      selftests: fib_rule_tests: print the result and return 1 if any tests failed
>
>Jakub Kicinski (3):
>      net/tls: avoid NULL pointer deref on nskb->sk in fallback
>      net/tls: don't copy negative amounts of data in reencrypt
>      net/tls: fix copy to fragments in reencrypt
>
>Jim Mattson (1):
>      KVM: nVMX: Fix size checks in vmx_set_nested_state
>
>Martin KaFai Lau (1):
>      ipv6: A few fixes on dereferencing rt->from
>
>Michael Chan (5):
>      bnxt_en: Improve multicast address setup logic.
>      bnxt_en: Fix possible crash in bnxt_hwrm_ring_free() under error conditions.
>      bnxt_en: Pass correct extended TX port statistics size to firmware.
>      bnxt_en: Fix statistics context reservation logic.
>      bnxt_en: Fix uninitialized variable usage in bnxt_rx_pkt().
>
>Paolo Abeni (1):
>      udp: fix GRO reception in case of length mismatch
>
>Rafael J. Wysocki (1):
>      ath10k: Drop WARN_ON()s that always trigger during system resume
>
>Sean Christopherson (1):
>      KVM: x86: Whitelist port 0x7e for pre-incrementing %rip
>
>Shmulik Ladkani (1):
>      ipv4: ip_do_fragment: Preserve skb_iif during fragmentation
>
>Vasundhara Volam (1):
>      bnxt_en: Free short FW command HWRM memory in error path in bnxt_init_one()
>
>Willem de Bruijn (3):
>      ipv6: invert flowlabel sharing check in process and user mode
>      packet: validate msg_namelen in send directly
>      packet: in recvmsg msg_name return at least sizeof sockaddr_ll
>
>Xin Long (1):
>      sctp: avoid running the sctp state machine recursively
>



--4SFOXa2GPu3tIq4H
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCAAdFiEEnwF+nWawchZUPOuwsjqdtxFLKRUFAlzO68QACgkQsjqdtxFL
KRV6kAgAjIQ/TyZ3/420I36z0aDWsLEEDasg1NyyusYK0XdNmHF9oFYwU5yUKWDn
j7T7criPSxAOG5Rgbb1QbpiIMfUUecCUaUbBtMFDvr5LeRNQ/GEaQHBisNyghBhQ
Y7n/wpuaEpviee4YIovPFuClzYNXu/kzA5kvhrgizg4HJ/XDLNx4jzIxfftRpoKG
ogMWmzDb9aYrQ4ffsjo+Xn8xOd9AbZVwdJN47oYxiwlMnSZdAT4wD6KQZyA30fj7
5Oeorpw7RMvNjM72IXdVsmuKDwpVocvJ4A9yONlbwXDnJOQCMMfiDajOJfiLbLF3
wqXLpp7XxlYfmgLcmZ229QKbH9V0ZA==
=659X
-----END PGP SIGNATURE-----

--4SFOXa2GPu3tIq4H--
