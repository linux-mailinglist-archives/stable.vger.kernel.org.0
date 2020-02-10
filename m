Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0372315819E
	for <lists+stable@lfdr.de>; Mon, 10 Feb 2020 18:46:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728114AbgBJRqM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 Feb 2020 12:46:12 -0500
Received: from mail-lj1-f196.google.com ([209.85.208.196]:43840 "EHLO
        mail-lj1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728010AbgBJRqM (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 10 Feb 2020 12:46:12 -0500
Received: by mail-lj1-f196.google.com with SMTP id a13so8193601ljm.10
        for <stable@vger.kernel.org>; Mon, 10 Feb 2020 09:46:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=Z4z8BRuWcC+QkJYDhpaWFFyqDv+1mRelBaa/f8a991E=;
        b=pYSOGOcQ9uaCsYbmN/IxKPKn96NbhXp5GsbvrbC8v3ZglBigQQfx4O5Ykr9Ydkbanl
         rB0Z0x54vjW7H6Rj1oSZ9ZKVc2VY+SVWK/nIRP0Je91bvW93u+g4tZFywYAHcShIevJx
         jrm8aNTaklNHe6xjHpiDgolC8z9hlxwIGLjJ9gSGzhI2zKIbiCOitK+NZ8+pRUgLtJVA
         yrrXxDotNYtv64nQnxo0OJFylJsGgbc1TZx66YsVtPQClqed85pG8bueHS9XNpoSk7CZ
         LsljRi0F/4hDnXUsAZrHAc+hHdL72jRdALRs1FldhkqtD+Sq3ACaavMcv0Gt3mfWAd6V
         xMGA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=Z4z8BRuWcC+QkJYDhpaWFFyqDv+1mRelBaa/f8a991E=;
        b=DKW+EenS/f8ytY0I5gL+5u4P8FQ4+8Jo09kdn569rY/hiyIZQMPag3LqaoB+Q5x1BB
         a9HZpAbMlfwAxX3/boswlqxDKhHMbXx26UxSF+5TA375e67+YA10jWlhvd0Lzipnp8g6
         qacL8T2mV8dsRugj/WiXan/wRp1mlEJphu20Ch/1YfaN0vy+JSElTq8lV4l8XcTZVdIn
         0SlSABNFYDuRc8u46RHH95+5iDSPKxW4nngvQ3imLYQRobyYY0ppQeuORE+lfFllbWv6
         Ml+QrqDe5Put4CJTflcGI6fDXRrC3knCB2nKEfeDVwh9F6Vh7iVfgWazBlCPG128LRCk
         xV7Q==
X-Gm-Message-State: APjAAAVqw3iuR1qy9t5KK+0o2DiVfmSEvpr84bMQ95IO3VH9f8epCFUU
        t+FBlGtCW3psYDDuH+3qx7RHfH3Cwb5J2ID9WFIGrQ==
X-Google-Smtp-Source: APXvYqwvwdxKcgfSobDtIom2b5AmerOMretDeCPOWFtP3z5u0bdI8BjifSOAfOQTNB8RrifO7KUHOQ8u72a5FCwc6qo=
X-Received: by 2002:a2e:84d0:: with SMTP id q16mr1651834ljh.138.1581356770206;
 Mon, 10 Feb 2020 09:46:10 -0800 (PST)
MIME-Version: 1.0
References: <20200210122423.695146547@linuxfoundation.org> <20200210122450.176337512@linuxfoundation.org>
 <CA+G9fYu4pDFaG-dA2KbVp61HGNzA1R3F_=Z5isC8_ammG4iZkQ@mail.gmail.com> <CAK8P3a0iq1fj7iVuYMYczbg2ij-x5b0D5OeKiy_2Pebk+ucMeA@mail.gmail.com>
In-Reply-To: <CAK8P3a0iq1fj7iVuYMYczbg2ij-x5b0D5OeKiy_2Pebk+ucMeA@mail.gmail.com>
From:   =?UTF-8?B?RGFuaWVsIETDrWF6?= <daniel.diaz@linaro.org>
Date:   Mon, 10 Feb 2020 11:45:58 -0600
Message-ID: <CAEUSe787_LxgSWmo4cxU52Ti3mq3ydtco5J7A87Eec7HeLMCNQ@mail.gmail.com>
Subject: Re: [PATCH 5.5 284/367] compat: scsi: sg: fix v3 compat read/write interface
To:     Arnd Bergmann <arnd@arndb.de>
Cc:     Naresh Kamboju <naresh.kamboju@linaro.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        open list <linux-kernel@vger.kernel.org>,
        linux- stable <stable@vger.kernel.org>,
        Ben Hutchings <ben.hutchings@codethink.co.uk>,
        Sasha Levin <sashal@kernel.org>, lkft-triage@lists.linaro.org,
        Basil Eljuse <Basil.Eljuse@arm.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Helo!

On Mon, 10 Feb 2020 at 09:58, Arnd Bergmann <arnd@arndb.de> wrote:
> On Mon, Feb 10, 2020 at 4:41 PM Naresh Kamboju
> <naresh.kamboju@linaro.org> wrote:
> >
> > The arm64 architecture 64k page size enabled build failed on stable rc =
5.5
> > CONFIG_ARM64_64K_PAGES=3Dy
> > CROSS_COMPILE=3Daarch64-linux-gnu-
> > Toolchain gcc-9
> >
> > In file included from ../block/scsi_ioctl.c:23:
> >  ../include/scsi/sg.h:75:2: error: unknown type name =E2=80=98compat_in=
t_t=E2=80=99
> >   compat_int_t interface_id; /* [i] 'S' for SCSI generic (required) */
> >   ^~~~~~~~~~~~
> >  ../include/scsi/sg.h:76:2: error: unknown type name =E2=80=98compat_in=
t_t=E2=80=99
> >   compat_int_t dxfer_direction; /* [i] data transfer direction  */
> >   ^~~~~~~~~~~~
> >
> > ...
> >  ../include/scsi/sg.h:97:2: error: unknown type name =E2=80=98compat_ui=
nt_t=E2=80=99
> >   compat_uint_t info;  /* [o] auxiliary information */
>
> Hi Naresh,
>
> Does it work if you backport 071aaa43513a ("compat: ARM64: always include
> asm-generic/compat.h")?

Yes, cherry-picking 556d687a4ccd ("compat: ARM64: always include
asm-generic/compat.h") gets it back on track.

Thanks and greetings!

Daniel D=C3=ADaz
daniel.diaz@linaro.org
