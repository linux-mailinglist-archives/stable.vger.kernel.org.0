Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 710014F4F9
	for <lists+stable@lfdr.de>; Sat, 22 Jun 2019 11:51:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726130AbfFVJvS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 22 Jun 2019 05:51:18 -0400
Received: from mail-pl1-f194.google.com ([209.85.214.194]:42554 "EHLO
        mail-pl1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726112AbfFVJvR (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 22 Jun 2019 05:51:17 -0400
Received: by mail-pl1-f194.google.com with SMTP id ay6so4159112plb.9;
        Sat, 22 Jun 2019 02:51:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=1P66UpgJ5K7fl5+fwU1y4c7FLmguZ7f7FGIScoMeTN0=;
        b=eyuwsRFtT8/bTEXjqGFen2w0mvTkhPXkt0NPqkK2XODvyHH28jOVa4Sp/94RE/cqni
         Nv9rzbkBzN312cFTtaB5O0dcdsu0QjLN7xzpMqWYEBDwLgB4i1U2A5B6cqbF+U3I+i9r
         HpxF015kcJ2MHT49sqXoE1a8rq1zGwvq0D2EgrTcyatk0iMU60TGtKFYfkR0f1vPJtR/
         1q69RjtxHuKyDJpKAAMBdnvNEStjFNBCULPh/V9hXfFMHTEg2MjbX/7Jnw2gElcCzTWH
         kgugAeyVK6V6l6ZO4jJb0PKXtZz06jDkc5duYEgY7QnXBgvuOx5IDKiBL2ZNpw8AaGxn
         83LA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=1P66UpgJ5K7fl5+fwU1y4c7FLmguZ7f7FGIScoMeTN0=;
        b=MrHnTSsN+Y8nTWmV9Zl19rS0mwZGTuZWEPnDQkYqOhGUGLlO0t7KHgcpeokWD6b1+7
         q8825uDWKbfWQ1NejqUtbmG04Vuw7z66mCi6OQcs1DuFAQ3QONWDWfPUpOZCF/S0a9qH
         j7izmhwDGIC6FiZz4xrQhO+ZzBlRqIAWoMq/D74hvNEkNUQ7wYJ5oX1jHyEp5eO+sPv/
         b0oB8lELMvQx9yg9dSymalLp/d+p629nKeJAwqwf+FWVRjTZ9aOHwPWOIXxFzH732IrZ
         5z0BiufBP2rjq4OrXxDUt+zXKWbfiFiekiPxbIyuJ73keadZpQNHt8fMtYhT6UbMgytt
         pXCg==
X-Gm-Message-State: APjAAAXa4uZjNeQDDM9x3Id3rZMwE7XY9AE0eCgKMdQTkcnXQHKso/PZ
        QyBjoC1Bldp67o+XM2S2qwnp1mm9XGPiEw==
X-Google-Smtp-Source: APXvYqxPdxYf3A7iMzMmRPqRD2I+7L/rG2UjIOR9CKvWk7Og1dQ8gm9I/IK3qvF9/SWsCY94DZAVfg==
X-Received: by 2002:a17:902:a607:: with SMTP id u7mr131720784plq.43.1561197077155;
        Sat, 22 Jun 2019 02:51:17 -0700 (PDT)
Received: from ArchLinux ([103.231.90.170])
        by smtp.gmail.com with ESMTPSA id b17sm6580043pgk.85.2019.06.22.02.51.11
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Sat, 22 Jun 2019 02:51:16 -0700 (PDT)
Date:   Sat, 22 Jun 2019 15:20:57 +0530
From:   Bhaskar Chowdhury <unixbhaskar@gmail.com>
To:     Greg KH <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        torvalds@linux-foundation.org, stable@vger.kernel.org, lwn@lwn.net,
        Jiri Slaby <jslaby@suse.cz>
Subject: Re: Linux 5.1.14
Message-ID: <20190622095057.GB10809@ArchLinux>
References: <20190622094743.GA12599@kroah.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="rJwd6BRFiFCcLxzm"
Content-Disposition: inline
In-Reply-To: <20190622094743.GA12599@kroah.com>
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--rJwd6BRFiFCcLxzm
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline




Important fix. Thanks, man! :)

On 11:47 Sat 22 Jun , Greg KH wrote:
>I'm announcing the release of the 5.1.14 kernel.
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
> Makefile              |    2 +-
> net/ipv4/tcp_output.c |    3 ++-
> 2 files changed, 3 insertions(+), 2 deletions(-)
>
>Eric Dumazet (1):
>      tcp: refine memory limit test in tcp_fragment()
>
>Greg Kroah-Hartman (1):
>      Linux 5.1.14
>



--rJwd6BRFiFCcLxzm
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCAAdFiEEnwF+nWawchZUPOuwsjqdtxFLKRUFAl0N+gEACgkQsjqdtxFL
KRXW2Af+Mukm6cZH8Qthae1SROxaY2Wv9WTdEZo3hZGC3HCCuqmKdyxQ8Wm+huao
IWqEpxRssBrZHOC/uFAb1vMqdN94GP4knCucELS3gYTX++G7Z2Mg2DYjv/xY0+dT
+e0xXfv0rsDpOrUUsJZ3r6WYJdP/4vybu0GqMAurd4F7eYamHam1Z30OKMhcVBlw
znyPNB0Ct7rLxhQ3zv2MuzEr/V6mzw/ucQ3u3hqCQ8rcgLr1vlbakqoU/IAGhg8y
WIS71eqkHYwOy/W/OQvq94l3KlMZMy9itGt6knfQz1YOCslb1YEaLVcM0wGYm+Xo
baqkJ/fm5G548FAP4QyuLL7r9ea0IQ==
=TErr
-----END PGP SIGNATURE-----

--rJwd6BRFiFCcLxzm--
