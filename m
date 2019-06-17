Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6A4D949562
	for <lists+stable@lfdr.de>; Tue, 18 Jun 2019 00:47:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726898AbfFQWrV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 Jun 2019 18:47:21 -0400
Received: from mail-pg1-f196.google.com ([209.85.215.196]:34885 "EHLO
        mail-pg1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725839AbfFQWrV (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 17 Jun 2019 18:47:21 -0400
Received: by mail-pg1-f196.google.com with SMTP id s27so6570293pgl.2;
        Mon, 17 Jun 2019 15:47:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=x92Aza9jCNmVRM2Nosfan3LRA81lLexSKzqeyp5AkVQ=;
        b=Jwyt0Gi7i6IZYUPNpCDeG5Y8Vz/iiqg+OrOKJgn84ED80FJv4jiYiC6PNdaneUZAp1
         O8HIJkRgqeMHF1JAH8XUA+kI2zXS431TlJ1aDYyUZg6s5URU2ESuIwX3nbKuzZtCpzID
         VK+2CBYKZJjmIPoefjiBtzuv+QP4mA8lwE/5g+Hnd+vWIo2FPrcGFG2N49NDdqIAxa1W
         pPo59yNC1g7de5H2h6kryK1eEAnKWmIOCXZga3NVjUt81fyzX8Np8Aw/yAqA1v0k+6gT
         i/RM7PljXeJjr65PIMsnsjr2CW8INXgAluttGU9KEI8x9JY+K/SHjhnovwVL8eHqZBG0
         0cHg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=x92Aza9jCNmVRM2Nosfan3LRA81lLexSKzqeyp5AkVQ=;
        b=dMbLzkrzNH7O0zbrkd7Kuep7/Kkb4/SLOVBV5zjUJi8DF+U3r0kQVkSqVqYThN2sDn
         9MfAVIaFlzIpDYarkMAE4dv3cyr7xb3L/fkZC/USULze9zaM54/cs5Ti2/gh0wZH3e0d
         5WUP99EmpsDN8k0hQgn25QbzQ/zuqfDqvi/gecXks4wCTLk+boJmGFhYI9uNADLrbnPe
         FQ5HOpzzvEisIFBnXleetTy4UlhV5QUR2tsabCrpUvS4p8in6oSYJEvyYDY9saI8rzYw
         IxKSyahf3X1FCuxDBDjBdEj4l6Rm+r0bYEVOPck/6PdHZplLrGyDuE4w1V5pcCgc+qES
         Q7+w==
X-Gm-Message-State: APjAAAUyIPKQ+lIV7PT51TjJIM/mgZXGNiPHIpZMp60KfEgV6QfOWf66
        /Bwqzaq8p8S//GmRI2/rkPI=
X-Google-Smtp-Source: APXvYqxHtAfylvCP56eWkQvDkttRjJFDRaouEYspgpRiV0+q0SkHxXkcTDaTC2c4DT+tnngNj2/OEQ==
X-Received: by 2002:a62:1bd1:: with SMTP id b200mr91086764pfb.210.1560811640999;
        Mon, 17 Jun 2019 15:47:20 -0700 (PDT)
Received: from ArchLinux ([103.231.91.66])
        by smtp.gmail.com with ESMTPSA id p2sm17663408pfb.118.2019.06.17.15.47.14
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Mon, 17 Jun 2019 15:47:19 -0700 (PDT)
Date:   Tue, 18 Jun 2019 04:17:07 +0530
From:   Bhaskar Chowdhury <unixbhaskar@gmail.com>
To:     Greg KH <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        torvalds@linux-foundation.org, stable@vger.kernel.org, lwn@lwn.net,
        Jiri Slaby <jslaby@suse.cz>
Subject: Re: Linux 5.1.11
Message-ID: <20190617224707.GA30899@ArchLinux>
References: <20190617180944.GA16975@kroah.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="UugvWAfsgieZRqgk"
Content-Disposition: inline
In-Reply-To: <20190617180944.GA16975@kroah.com>
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--UugvWAfsgieZRqgk
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline



Thanks, a bunch Greg!

On 20:09 Mon 17 Jun , Greg KH wrote:
>I'm announcing the release of the 5.1.11 kernel.
>
>All users of the 5.1 kernel series must upgrade.
>
>The updated 5.1.y git tree can be found at:
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
> Documentation/networking/ip-sysctl.txt |    8 ++++++++
> Makefile                               |    2 +-
> include/linux/tcp.h                    |    4 ++++
> include/net/netns/ipv4.h               |    1 +
> include/net/tcp.h                      |    2 ++
> include/uapi/linux/snmp.h              |    1 +
> net/ipv4/proc.c                        |    1 +
> net/ipv4/sysctl_net_ipv4.c             |   11 +++++++++++
> net/ipv4/tcp.c                         |    1 +
> net/ipv4/tcp_input.c                   |   26 ++++++++++++++++++++------
> net/ipv4/tcp_ipv4.c                    |    1 +
> net/ipv4/tcp_output.c                  |   10 +++++++---
> net/ipv4/tcp_timer.c                   |    1 +
> 13 files changed, 59 insertions(+), 10 deletions(-)
>
>Eric Dumazet (4):
>      tcp: limit payload size of sacked skbs
>      tcp: tcp_fragment() should apply sane memory limits
>      tcp: add tcp_min_snd_mss sysctl
>      tcp: enforce tcp_min_snd_mss in tcp_mtu_probing()
>
>Greg Kroah-Hartman (1):
>      Linux 5.1.11
>



--UugvWAfsgieZRqgk
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCAAdFiEEnwF+nWawchZUPOuwsjqdtxFLKRUFAl0IGGYACgkQsjqdtxFL
KRWjVwf9FxyxD1R5TDrakjqnps5/1HB7ZZDWENzK5f69icEXHbPejEpipJXw/85k
CYeVXZxhc9T5WdxmSheFNsJ85LLSR7n3/FxF6Ga70Rh4ShDONoe9eJIX5Dnrdfka
2PsUAuIjqCPflUnm9bEskHSmXDezl1a+ojgjTimD0dq4Z8zv2RH3VkZcg/JgMKNy
0+ji/r9gQ/wVRhLNmwW/mYEMopC8K8bhaGbirVd4t5fMw8EgogsUzCfsYAzNEOlZ
CYmx8isnxNVhH3LIxaqLtDuNmuJ/AbiphbhFe4DeIACklM1s0VlNxsQXf/xFjJ4Q
I5xhRwDh9vPd4G5Ped1seX9CBCCj9Q==
=ynAQ
-----END PGP SIGNATURE-----

--UugvWAfsgieZRqgk--
