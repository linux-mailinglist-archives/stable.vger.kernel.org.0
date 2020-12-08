Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E624D2D35B7
	for <lists+stable@lfdr.de>; Tue,  8 Dec 2020 23:04:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730486AbgLHWA4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 8 Dec 2020 17:00:56 -0500
Received: from mail-02.mail-europe.com ([51.89.119.103]:41888 "EHLO
        mail-02.mail-europe.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730482AbgLHWAz (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 8 Dec 2020 17:00:55 -0500
Date:   Tue, 08 Dec 2020 21:59:20 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=protonmail.com;
        s=protonmail; t=1607464771;
        bh=1hYjg8WRlU6tVQsFOn5GFB0I2LWqf6gUYIXfyucinX4=;
        h=Date:To:From:Cc:Reply-To:Subject:In-Reply-To:References:From;
        b=nKjIEnl2xqbnAdHa3plEidQMmJHMMIei9SGArs5wH22tQYMzuEecV9oVT5x4ESqvp
         9VbyUN5vu9jQCPcx7ljela/wjzt284ZVALWvOOvJSgW1by19+NniG3tmpfgjPy8kyE
         2CXMAzxMbTcJlAV2Yl/30w+PugqCvtlHJJzMn080=
To:     Greg KH <gregkh@linuxfoundation.org>
From:   =?utf-8?Q?Barnab=C3=A1s_P=C5=91cze?= <pobrn@protonmail.com>
Cc:     Coiby Xu <coiby.xu@gmail.com>,
        "linux-input@vger.kernel.org" <linux-input@vger.kernel.org>,
        Helmut Stult <helmut.stult@schinfo.de>,
        Baq Domalaq <domalak@gmail.com>,
        Pedro Ribeiro <pedrib@gmail.com>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        Jiri Kosina <jikos@kernel.org>,
        Benjamin Tissoires <benjamin.tissoires@redhat.com>,
        open list <linux-kernel@vger.kernel.org>
Reply-To: =?utf-8?Q?Barnab=C3=A1s_P=C5=91cze?= <pobrn@protonmail.com>
Subject: Re: [PATCH v4] HID: i2c-hid: add polling mode based on connected GPIO chip's pin status
Message-ID: <B3Hx1v5x_ZWS8XSi8-0vZov1KLuINEHyS5yDUGBaoBN4d9wTi9OlCoFX1h6sqYG8dCZr_OKcKeImWX9eyKh8X4X3ZMdAUQ-KVwmG5e9LJeI=@protonmail.com>
In-Reply-To: <X75zL12q+FF6KBHi@kroah.com>
References: <20201125141022.321643-1-coiby.xu@gmail.com> <X75zL12q+FF6KBHi@kroah.com>
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

2020. november 25., szerda 16:07 keltez=C3=A9ssel, Greg KH =C3=ADrta:

> [...]
> > +static u8 polling_mode;
> > +module_param(polling_mode, byte, 0444);
> > +MODULE_PARM_DESC(polling_mode, "How to poll (default=3D0) - 0 disabled=
; 1 based on GPIO pin's status");
>
> Module parameters are for the 1990's, they are global and horrible to
> try to work with. You should provide something on a per-device basis,
> as what happens if your system requires different things here for
> different devices? You set this for all devices :(
> [...]

Hi

do you think something like what the usbcore has would be better?
A module parameter like "quirks=3D<vendor-id>:<product-id>:<flags>[,<vendor=
-id>:<product-id>:<flags>]*"?


Regards,
Barnab=C3=A1s P=C5=91cze
