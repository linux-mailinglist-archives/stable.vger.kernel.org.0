Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id ABB28BB6D0
	for <lists+stable@lfdr.de>; Mon, 23 Sep 2019 16:32:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2439961AbfIWOcE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 23 Sep 2019 10:32:04 -0400
Received: from mail-pf1-f193.google.com ([209.85.210.193]:34260 "EHLO
        mail-pf1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2437427AbfIWOcE (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 23 Sep 2019 10:32:04 -0400
Received: by mail-pf1-f193.google.com with SMTP id b128so9259211pfa.1;
        Mon, 23 Sep 2019 07:32:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=NdWL2Xiq3cS/BfrYS0FnV72zAIIRU8nsmqTk9Q6D73w=;
        b=N+sph3QsTYxFcVE4teLhSOS62PeOUnNTYuHCACNp8IP+DxF/jMGabVX/dzhbnS3w8c
         5HrfWEBRIhutPZWCM5HD2OBf8RQOM6LEWmpgAGu3CgTUA7zLIAweiUmtSPJkTOZ4cGRu
         5uPWJgVR5/nr8OvHIyj53u5BvkmwfNu7VstGFAndgKpgMWx43zhDm4lSQxLmYBaxCc4v
         bFETaNs51UwkWP2a/zA5OjhiwkE9ZX10hIppNckrMPiRTuaTi11B1zhMElbK7aZVBr2D
         Pxfk8Updtto8c+BYP2sb4kZHfgXqpAbbqmjcoAkLHcimrHm9Z2jA/eU43oyoK1lPU3y1
         IitA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=NdWL2Xiq3cS/BfrYS0FnV72zAIIRU8nsmqTk9Q6D73w=;
        b=JLAv+9qg1ZQwz5pGiXY/i/KRGdBc3Jv8JD4YOa3yVfEaXUJPRcXCU2xYZjKDNgxWg2
         kRqKYZCoiGoX4exbB2AT/8LgSVSKNNpgyHpkvCWXA426S9KXRco5YKKR3+5vGSJe2Hve
         QwaY3/LKXHpbT4SM9HTDTNN8tjjd1cL4UjFRvIcysHez/iF5iBteFerVBwKoIeECWVr5
         eLmcCpLHMsNxPC4YsfS9eFkrkTbwUVMMl9lWM/dzSF/8nC9sg070j0a2ASyEG2MHTKT4
         SvuT7/2f4BSmnQvirI5OZ2rh0hq3roIAy94Kaj/wZMMshZ8vYz5cLPsNja7YfFZRXxAA
         lkBQ==
X-Gm-Message-State: APjAAAWR9XlqMY2yqtXZR93m0Dfv30vE3Fe4jZXrTH7nTX118+hyPjs2
        ggOaYpwMrrBBhAY+wKaSyD3NtzoD
X-Google-Smtp-Source: APXvYqwVxWY2hR1+J8pjDw5gRFB44H/IjwFJtZUdUo2dJ+GvCZD4N9S5ELVmVfG9Lgyzp4bzrtEfIg==
X-Received: by 2002:a63:515a:: with SMTP id r26mr242299pgl.121.1569249123574;
        Mon, 23 Sep 2019 07:32:03 -0700 (PDT)
Received: from Gentoo ([103.231.91.35])
        by smtp.gmail.com with ESMTPSA id bx18sm9556925pjb.26.2019.09.23.07.31.56
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 23 Sep 2019 07:32:02 -0700 (PDT)
Date:   Mon, 23 Sep 2019 20:01:48 +0530
From:   Bhaskar Chowdhury <unixbhaskar@gmail.com>
To:     Greg KH <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        torvalds@linux-foundation.org, stable@vger.kernel.org, lwn@lwn.net,
        Jiri Slaby <jslaby@suse.cz>
Subject: Re: Linux 5.3.1
Message-ID: <20190923143145.GA17787@Gentoo>
References: <20190921063708.GA1083465@kroah.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="lrZ03NoBR/3+SXJZ"
Content-Disposition: inline
In-Reply-To: <20190921063708.GA1083465@kroah.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--lrZ03NoBR/3+SXJZ
Content-Type: text/plain; charset=iso-8859-1; format=flowed
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On 08:37 Sat 21 Sep 2019, Greg KH wrote:
>I'm announcing the release of the 5.3.1 kernel.
>
>All users of the 5.3 kernel series must upgrade.
>
>The updated 5.3.y git tree can be found at:
>	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git lin=
ux-5.3.y
>and can be browsed at the normal kernel.org git web browser:
>	https://git.kernel.org/?p=3Dlinux/kernel/git/stable/linux-stable.git;a=3D=
summary
>
>thanks,
>
>greg k-h

Thanks, a bunch Greg! :)

Thanks,
Bhaskar
>
>------------
>
> Documentation/filesystems/overlayfs.txt           |    2
> Documentation/sphinx/automarkup.py                |    2
> Makefile                                          |    2
> arch/arm64/include/asm/pgtable.h                  |   12 ++-
> drivers/block/floppy.c                            |    4 -
> drivers/firmware/google/vpd.c                     |    4 -
> drivers/firmware/google/vpd_decode.c              |   55 +++++++++-------
> drivers/firmware/google/vpd_decode.h              |    6 -
> drivers/media/usb/dvb-usb/technisat-usb2.c        |   22 +++---
> drivers/media/usb/tm6000/tm6000-dvb.c             |    3
> drivers/net/ethernet/stmicro/stmmac/stmmac_main.c |   12 ++-
> drivers/net/xen-netfront.c                        |    2
> drivers/phy/qualcomm/phy-qcom-qmp.c               |   33 ++++-----
> drivers/phy/renesas/phy-rcar-gen3-usb2.c          |    2
> drivers/tty/serial/atmel_serial.c                 |    1
> drivers/tty/serial/sprd_serial.c                  |    2
> drivers/usb/core/config.c                         |   12 ++-
> fs/overlayfs/ovl_entry.h                          |    1
> fs/overlayfs/super.c                              |   73 ++++++++++++++--=
------
> include/net/pkt_sched.h                           |    7 +-
> include/net/sock_reuseport.h                      |   20 +++++-
> net/core/dev.c                                    |   16 +++-
> net/core/sock_reuseport.c                         |   15 +++-
> net/dsa/dsa2.c                                    |    2
> net/ipv4/datagram.c                               |    2
> net/ipv4/udp.c                                    |    5 -
> net/ipv6/datagram.c                               |    2
> net/ipv6/ip6_gre.c                                |    2
> net/ipv6/udp.c                                    |    5 -
> net/sched/sch_generic.c                           |    3
> net/wireless/nl80211.c                            |    4 -
> virt/kvm/coalesced_mmio.c                         |   19 +++--
> 32 files changed, 226 insertions(+), 126 deletions(-)
>
>Alan Stern (1):
>      USB: usbcore: Fix slab-out-of-bounds bug during device reset
>
>Amir Goldstein (1):
>      ovl: fix regression caused by overlapping layers detection
>
>Andrew Lunn (1):
>      net: dsa: Fix load order between DSA drivers and taggers
>
>Bjorn Andersson (1):
>      phy: qcom-qmp: Correct ready status, again
>
>Chunyan Zhang (1):
>      serial: sprd: correct the wrong sequence of arguments
>
>Cong Wang (1):
>      net_sched: let qdisc_put() accept NULL pointer
>
>Dongli Zhang (1):
>      xen-netfront: do not assume sk_buff_head list is empty in error hand=
ling
>
>Greg Kroah-Hartman (1):
>      Linux 5.3.1
>
>Hung-Te Lin (1):
>      firmware: google: check if size is valid when decoding VPD data
>
>Jann Horn (1):
>      floppy: fix usercopy direction
>
>Jonathan Neusch=E4fer (1):
>      Documentation: sphinx: Add missing comma to list of strings
>
>Jose Abreu (1):
>      net: stmmac: Hold rtnl lock in suspend/resume callbacks
>
>Masashi Honma (1):
>      nl80211: Fix possible Spectre-v1 for CQM RSSI thresholds
>
>Matt Delco (1):
>      KVM: coalesced_mmio: add bounds checking
>
>Paolo Abeni (1):
>      net/sched: fix race between deactivation and dequeue for NOLOCK qdisc
>
>Razvan Stefanescu (1):
>      tty/serial: atmel: reschedule TX after RX was started
>
>Sean Young (2):
>      media: tm6000: double free if usb disconnect while streaming
>      media: technisat-usb2: break out of loop at end of buffer
>
>Will Deacon (1):
>      Revert "arm64: Remove unnecessary ISBs from set_{pte,pmd,pud}"
>
>Willem de Bruijn (1):
>      udp: correct reuseport selection with connected sockets
>
>Xin Long (1):
>      ip6_gre: fix a dst leak in ip6erspan_tunnel_xmit
>
>Yoshihiro Shimoda (1):
>      phy: renesas: rcar-gen3-usb2: Disable clearing VBUS in over-current
>



--lrZ03NoBR/3+SXJZ
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCAAdFiEEnwF+nWawchZUPOuwsjqdtxFLKRUFAl2I100ACgkQsjqdtxFL
KRVd1wf8Cn9lZ+rU6FwMb1+W/8nLyh8EK7c9rSQWkuZWwhLQlMbLWs/CS8Uzwhhy
+q36BCH05L7hn1XeI8/Rs30oriZqOzp3lJBgxAL31AJ8rOwGZiPXyg03DszCL2js
Al8Ej7rYd7wBbQKWuqh/tMptoog3bUMituZl1JlFSmqimINNC4MztwaDowfrwSJt
OQDDXP+X+M8tkY59BEe5KN+6qydAr5ZeRcQAI73X2TFw44KaEKSO8zULopeyMkUe
a2HBSb1/mRCfAqyu/U2PKCkgUcBeTr1dd2qcNHttshKlsg46/q8qYHFRPWtsmE4T
bNBNlD7nwA0JovQHzHIxjlN0wUZDNw==
=S0eI
-----END PGP SIGNATURE-----

--lrZ03NoBR/3+SXJZ--
