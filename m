Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A4E88418856
	for <lists+stable@lfdr.de>; Sun, 26 Sep 2021 13:31:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231138AbhIZLdD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 26 Sep 2021 07:33:03 -0400
Received: from mail-0201.mail-europe.com ([51.77.79.158]:53265 "EHLO
        mail-0201.mail-europe.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230509AbhIZLdD (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 26 Sep 2021 07:33:03 -0400
Date:   Sun, 26 Sep 2021 11:31:20 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=protonmail.com;
        s=protonmail; t=1632655884;
        bh=HHLlpH1kjyc1Xeunklt7JnCYU17HEKGNGAS0d4JTGE0=;
        h=Date:To:From:Cc:Reply-To:Subject:In-Reply-To:References:From;
        b=A4mdmJ7oVxSisbUtxxnAf7GO+cX4CgSBRZegeqamM1dBWOqcG4yR0Aa3lHAdKgUw+
         R81aOpTW5ofdmghdmQFLMdN97W2wrafMJuh2WrIbWs5A0+UzfWzDOZqjQdfPhWz42e
         5PR1gJATm8/kii+0lYWViTMR66Z6te6Hg+M3y0b8=
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
Message-ID: <gjSfoj7RAJMOeVL1pzzsZl5SjMGR_BXqigZqgkJe4G_8PPfm3EhxRlrRi-I7-Z0guYL0DAFOWeSWmrt_R8RcgzNq6Bcnk7BlQ9g3_G9aT2w=@protonmail.com>
In-Reply-To: <YVBYfQY94j7K39qc@kroah.com>
References: <qscod31lyVG7t-CW63o_pnsara-v9Wf6qXz9eSfUZnxtHk2AkeJ73yvER1XYO_311Wxo2wC8L2JuTdLJm8vgvhVVaGa5fdumXx5iHWarqwA=@protonmail.com> <YVAhOlTsb0NK0BVi@kroah.com> <YVArDZSq9oaTFakz@eldamar.lan> <YVA9l9svFyDgLPJy@kroah.com> <xxvm9EznCQoQ_-YYhxhEknGTxHEnVW584ypJShT__L09eV-JOfFtr-K4M33xRa3VTL5tNgOGvJSUqWthW-El4IwTi6Vt4B_XZA-xMB6vOEY=@protonmail.com> <YVBYfQY94j7K39qc@kroah.com>
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

On Sunday, September 26th, 2021 at 14:24, Greg Kroah-Hartman <gregkh@linuxf=
oundation.org> wrote:
> Why use an older kernel tree on this device? Rasbian seems to be on
> 4.19.y at the least right now, is there something in those older kernel
> trees that you need?

Due to circumstances, I need "smallest possible" kernel with all extra
stripped out. 4.9.y kernels are smaller than newer ones.

--
Jari Ruusu=C2=A0 4096R/8132F189 12D6 4C3A DCDA 0AA4 27BD=C2=A0 ACDF F073 3C=
80 8132 F189

