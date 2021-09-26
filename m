Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 05C03418A1F
	for <lists+stable@lfdr.de>; Sun, 26 Sep 2021 18:19:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232069AbhIZQUn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 26 Sep 2021 12:20:43 -0400
Received: from mail-40137.protonmail.ch ([185.70.40.137]:17559 "EHLO
        mail-40137.protonmail.ch" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232078AbhIZQUm (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 26 Sep 2021 12:20:42 -0400
Date:   Sun, 26 Sep 2021 16:18:58 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=protonmail.com;
        s=protonmail; t=1632673144;
        bh=IiLHe0uL/GJl0ZHp7NbOVHu7wAIspmD7PYQcfvjWkrw=;
        h=Date:To:From:Cc:Reply-To:Subject:In-Reply-To:References:From;
        b=gQPw44IsE45jQH+VhnLwAW2tiVipAUbBmwZ0BcNAc2KI6Ne0KBnD5DjjRuXHm4mTd
         Q18dQpoztXdEdg3m8UHWNiw5iQgkE7fJ9MNkFTQqfSOpcDoCqqLlWgIehV7lgrffr5
         LA9wotpQaFBKLYRf7q6bQ+No5HH+OkiKyUwJQUGk=
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
From:   Jari Ruusu <jariruusu@protonmail.com>
Cc:     Salvatore Bonaccorso <carnil@debian.org>,
        Sasha Levin <sashal@kernel.org>, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org, Jiri Slaby <jirislaby@kernel.org>,
        Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Aurelien Jarno <aurelien@aurel32.net>
Reply-To: Jari Ruusu <jariruusu@protonmail.com>
Subject: Re: glibc VETO for kernel version SUBLEVEL >= 255
Message-ID: <rnxxyl-NZoSBj8j2vUT0vtOtezAJ9BgDbgPppIcmKc1-XG-xhY72DQVkA_IPeKCfGPtxxfUvwvG5BM95aqbjXEvWxCZjHE7rT7v-L1rJ9jA=@protonmail.com>
In-Reply-To: <YVBb9ZoDGgV4cbXb@kroah.com>
References: <qscod31lyVG7t-CW63o_pnsara-v9Wf6qXz9eSfUZnxtHk2AkeJ73yvER1XYO_311Wxo2wC8L2JuTdLJm8vgvhVVaGa5fdumXx5iHWarqwA=@protonmail.com> <YVAhOlTsb0NK0BVi@kroah.com> <YVArDZSq9oaTFakz@eldamar.lan> <YVA9l9svFyDgLPJy@kroah.com> <xxvm9EznCQoQ_-YYhxhEknGTxHEnVW584ypJShT__L09eV-JOfFtr-K4M33xRa3VTL5tNgOGvJSUqWthW-El4IwTi6Vt4B_XZA-xMB6vOEY=@protonmail.com> <YVBYfQY94j7K39qc@kroah.com> <gjSfoj7RAJMOeVL1pzzsZl5SjMGR_BXqigZqgkJe4G_8PPfm3EhxRlrRi-I7-Z0guYL0DAFOWeSWmrt_R8RcgzNq6Bcnk7BlQ9g3_G9aT2w=@protonmail.com> <YVBb9ZoDGgV4cbXb@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-1.2 required=10.0 tests=ALL_TRUSTED,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM shortcircuit=no
        autolearn=disabled version=3.4.4
X-Spam-Checker-Version: SpamAssassin 3.4.4 (2020-01-24) on
        mailout.protonmail.ch
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sunday, September 26th, 2021 at 14:39, Greg Kroah-Hartman <gregkh@linuxf=
oundation.org> wrote:
> On Sun, Sep 26, 2021 at 11:31:20AM +0000, Jari Ruusu wrote:
> > Due to circumstances, I need "smallest possible" kernel with all extra
> > stripped out. 4.9.y kernels are smaller than newer ones.
>
> Smaller by how much, and what portion grew? Are we building things into
> the kernel that previously was able to be compiled out? Or is there
> something new added after 4.9 that adds a huge memory increase?

Byte sizes of different kernels for my laptop. Everything needed built-in,
except for wifi modules. Same compiler, roughly same kernel configs:

6906816 vmlinuz-4.9.284
7603200 vmlinuz-4.19.208
8306752 vmlinuz-5.10.69

> Figuring that out would be good as you only have 1 more year for 4.9.y
> to be alive, that's not going to last for forever...

I will deal with that when 4.9.y updates run dry, or when Raspbian
userland starts requiring newer kernel.

--
Jari Ruusu=C2=A0 4096R/8132F189 12D6 4C3A DCDA 0AA4 27BD=C2=A0 ACDF F073 3C=
80 8132 F189

