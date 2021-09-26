Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 068AE41882E
	for <lists+stable@lfdr.de>; Sun, 26 Sep 2021 12:59:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230128AbhIZLAn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 26 Sep 2021 07:00:43 -0400
Received: from mail-40137.protonmail.ch ([185.70.40.137]:36308 "EHLO
        mail-40137.protonmail.ch" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230025AbhIZLAn (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 26 Sep 2021 07:00:43 -0400
X-Greylist: delayed 12927 seconds by postgrey-1.27 at vger.kernel.org; Sun, 26 Sep 2021 07:00:42 EDT
Date:   Sun, 26 Sep 2021 10:58:59 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=protonmail.com;
        s=protonmail; t=1632653945;
        bh=eN1JvIwk0mKAqB7zSf10C2kR5+le/DOV0a05om7SYkQ=;
        h=Date:To:From:Cc:Reply-To:Subject:In-Reply-To:References:From;
        b=mYXYPqwKNOeeuniL7leVuIOFBRj/Vgs39aU9don5KgQtkAbdqai7DjctVQjUP7LBT
         ywGj3iptUHo8NvxC5crIDK9J5jW/yMVrLDKzABBN7TurYRPQ599RmM/wRIULLwFcLZ
         eGlcRJgAWgGSWMcRabck3OxUfkGcXH08gua+8hL8=
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
Message-ID: <xxvm9EznCQoQ_-YYhxhEknGTxHEnVW584ypJShT__L09eV-JOfFtr-K4M33xRa3VTL5tNgOGvJSUqWthW-El4IwTi6Vt4B_XZA-xMB6vOEY=@protonmail.com>
In-Reply-To: <YVA9l9svFyDgLPJy@kroah.com>
References: <qscod31lyVG7t-CW63o_pnsara-v9Wf6qXz9eSfUZnxtHk2AkeJ73yvER1XYO_311Wxo2wC8L2JuTdLJm8vgvhVVaGa5fdumXx5iHWarqwA=@protonmail.com> <YVAhOlTsb0NK0BVi@kroah.com> <YVArDZSq9oaTFakz@eldamar.lan> <YVA9l9svFyDgLPJy@kroah.com>
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

On Sunday, September 26th, 2021 at 12:29, Greg Kroah-Hartman <gregkh@linuxf=
oundation.org> wrote:
> On Sun, Sep 26, 2021 at 10:10:53AM +0200, Salvatore Bonaccorso wrote:
> > Recently prompted due to https://bugs.debian.org/987266 the check was
> > removed in the postinst script of libc in Debian:
> > https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=3D987266 .
>
> Wonderful, thanks for pointing this out!
> Jari, try asking whatever distro you are getting these rebuilt packages
> from to update their scripts and all should be good.

It is/was mostly self-inflicted pain, using Rasbian distro userland and
self-compiled kernel.org kernel.

Since that problem seems to be fixed in upstream glibc, that problem is not
going to persist forever.

--
Jari Ruusu=C2=A0 4096R/8132F189 12D6 4C3A DCDA 0AA4 27BD=C2=A0 ACDF F073 3C=
80 8132 F189

