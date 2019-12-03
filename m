Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D9273110620
	for <lists+stable@lfdr.de>; Tue,  3 Dec 2019 21:47:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727457AbfLCUrx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Dec 2019 15:47:53 -0500
Received: from mail-ot1-f68.google.com ([209.85.210.68]:42806 "EHLO
        mail-ot1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727244AbfLCUrw (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 3 Dec 2019 15:47:52 -0500
Received: by mail-ot1-f68.google.com with SMTP id 66so4215272otd.9
        for <stable@vger.kernel.org>; Tue, 03 Dec 2019 12:47:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=zYsmHUF0tXmrZprhwHJMNIIa6jJV57cu814Qjawqjdo=;
        b=Y0npibml5WGqp7rUC91avYbZMswDym3bfg06WJM36BQq2Xg72W/KUi2DuBhsJr18do
         KvKPVUOtgG2aZ7pyOmG/ezKEX0L0N8JzP95HzXfk8OKEYQioYfLPnxm09dVgMTlCJ/sL
         lGSVZMFzxiM7ydDFP3SDWi7DLRs5XP/ptO7J+LVVZGiPw4CcaAhHzvJV0cfSC3ODoNNK
         NIt0iF1orCmJLeWPCMqbqSzdmojKS5wzeZ1dM6Mk6ABSERCZ6NrIY2vtO8nkZBti67mw
         KBJ8L5BR0zoJafKGLSV9wOnYYkFYel7RW0cQGvwhBKiSOkyrbZSZkhaLrCZ5ZBuFh1w3
         qXlg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=zYsmHUF0tXmrZprhwHJMNIIa6jJV57cu814Qjawqjdo=;
        b=k4nkwOxm9jl0cFuWjkfe8wE3O/++8+ATyUIQ6U9MxHOLeE7WsD0A1rC8dGrLenrkCh
         9Ix9hCGKX3uT+LWReP+S1FyUXpNUbnUZYmQDjYXHXq6xubf/9SiK5HWy/ylF3Qy8ny0O
         bEt0MurUUuvPAPQ0NeDpzy6GPiXyJTlWXPcZD/yS71Vu0y1F6jNXja6pwKV8qHuQYl3j
         BUACodpSdy5vjk78CnbO75groh08m33YniJq0dPb216AnAp/xVBr5S9kBv2YkbvUa3ZP
         xv7BJUR13e72epvVBOLk4bYJNsjmXvvAxGpFmuj2pscFe0iE3ft1ZlL6C3UT6EltxZ3W
         fCEA==
X-Gm-Message-State: APjAAAV/6WjPDna4Zm7Vl3pPahSdLBjSeGxjs+4VrbXs3xz3Qg2a/oNw
        VUX1AXgsrJkXzkerLLa8yL+WUFLKd/6feOBD4bU=
X-Google-Smtp-Source: APXvYqyGjQ7WvKGA/6HCmMgrfGT1q9pN8ffUvTaQIqB3EaLNO+q/Q9fH+C7BJprOSVV1GOFgwtS6DIP4GBUxy5DgELg=
X-Received: by 2002:a9d:6654:: with SMTP id q20mr4682025otm.284.1575406071200;
 Tue, 03 Dec 2019 12:47:51 -0800 (PST)
MIME-Version: 1.0
References: <2379623.yQyDp7EeDN@debian64> <20191202184248.GB734264@kroah.com>
In-Reply-To: <20191202184248.GB734264@kroah.com>
From:   Christian Lamparter <chunkeey@gmail.com>
Date:   Tue, 3 Dec 2019 21:47:38 +0100
Message-ID: <CAAd0S9ApFEC7AqiPEiZzpdVymgZDNLSiYe0aLq6hsAydVpzGNw@mail.gmail.com>
Subject: Re: [PATCH for-4.4-stable] ath10k: restore QCA9880-AR1A (v1) detection
To:     Greg KH <gregkh@linuxfoundation.org>
Cc:     Stable <stable@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Dec 2, 2019 at 7:42 PM Greg KH <gregkh@linuxfoundation.org> wrote:
>
> On Fri, Nov 29, 2019 at 09:53:50PM +0100, Christian Lamparter wrote:
> > commit f8914a14623a79b73f72b2b1ee4cd9b2cb91b735 upstream
> > ---
> > >From f8914a14623a79b73f72b2b1ee4cd9b2cb91b735 Mon Sep 17 00:00:00 2001
> > From: Christian Lamparter <chunkeey@gmail.com>
> > Date: Mon, 25 Mar 2019 13:50:19 +0100
> > Subject: [PATCH 4.4] ath10k: restore QCA9880-AR1A (v1) detection
> > To: linux-wireless@vger.kernel.org,
> >     ath10k@lists.infradead.org
> > Cc: Kalle Valo <kvalo@codeaurora.org>
> >
> > This patch restores the old behavior that read
> > the chip_id on the QCA988x before resetting the
> > chip. This needs to be done in this order since
> > the unsupported QCA988x AR1A chips fall off the
> > bus when resetted. Otherwise the next MMIO Op
> > after the reset causes a BUS ERROR and panic.
> >
> > Cc: stable@vger.kernel.org # 4.4
> > Fixes: 1a7fecb766c8 ("ath10k: reset chip before reading chip_id in prob=
e")
> > Signed-off-by: Christian Lamparter <chunkeey@gmail.com>
> > ---
> >  drivers/net/wireless/ath/ath10k/pci.c | 36 +++++++++++++++++++--------
> >  1 file changed, 25 insertions(+), 11 deletions(-)
> >
> > diff --git a/drivers/net/wireless/ath/ath10k/pci.c b/drivers/net/wirele=
ss/ath/ath10k/pci.c
> > --- a/drivers/net/wireless/ath/ath10k/pci.c   2019-09-08 00:07:21.37456=
5470 +0200
> > +++ b/drivers/net/wireless/ath/ath10k/pci.c   2019-09-08 00:17:15.36591=
2133 +0200
> > @@ -2988,12 +2988,13 @@ static int ath10k_pci_probe(struct pci_d
> >       struct ath10k_pci *ar_pci;
> >       enum ath10k_hw_rev hw_rev;
> >       u32 chip_id;
> > -     bool pci_ps;
> > +     bool pci_ps, is_qca988x =3D false;
> >
> >       switch (pci_dev->device) {
> >       case QCA988X_2_0_DEVICE_ID:
> >               hw_rev =3D ATH10K_HW_QCA988X;
> >               pci_ps =3D false;
> > +             is_qca988x =3D true;
> >               break;
> >       case QCA6164_2_1_DEVICE_ID:
> >       case QCA6174_2_1_DEVICE_ID:
> > @@ -3087,6 +3088,19 @@ static int ath10k_pci_probe(struct pci_d
> >               goto err_deinit_irq;
> >       }
> >
> > +     /* Read CHIP_ID before reset to catch QCA9880-AR1A v1 devices tha=
t
> > +      * fall off the bus during chip_reset. These chips have the same =
pci
> > +      * device id as the QCA9880 BR4A or 2R4E. So that's why the check=
.
> > +      */
> > +     if (is_qca988x) {
> > +             chip_id =3D ath10k_pci_soc_read32(ar, SOC_CHIP_ID_ADDRESS=
);
> > +             if (chip_id !=3D 0xffffffff) {
> > +                     if (!ath10k_pci_chip_is_supported(pdev->device,
> > +                                                       chip_id))
> > +                             goto err_unsupported;
> > +             }
> > +     }
> > +
> >       ret =3D ath10k_pci_chip_reset(ar);
> >       if (ret) {
> >               ath10k_err(ar, "failed to reset chip: %d\n", ret);
> > @@ -3099,11 +3113,8 @@ static int ath10k_pci_probe(struct pci_d
> >               goto err_free_irq;
> >       }
> >
> > -     if (!ath10k_pci_chip_is_supported(pdev->device, chip_id)) {
> > -             ath10k_err(ar, "device %04x with chip_id %08x isn't suppo=
rted\n",
> > -                        pdev->device, chip_id);
> > -             goto err_free_irq;
> > -     }
> > +     if (!ath10k_pci_chip_is_supported(pdev->device, chip_id))
> > +             goto err_unsupported;
> >
> >       ret =3D ath10k_core_register(ar, chip_id);
> >       if (ret) {
> > @@ -3113,6 +3124,10 @@ static int ath10k_pci_probe(struct pci_d
> >
> >       return 0;
> >
> > +err_unsupported:
> > +     ath10k_err(ar, "device %04x with chip_id %08x isn't supported\n",
> > +                pdev->device, bus_params.chip_id);
>
> Backports are great, but as I mentioned before, this breaks the build,
> so we can't take it:
>
> drivers/net/wireless/ath/ath10k/pci.c: In function =E2=80=98ath10k_pci_pr=
obe=E2=80=99:
> drivers/net/wireless/ath/ath10k/pci.c:3129:20: error: =E2=80=98bus_params=
=E2=80=99 undeclared (first use in this function); did you mean =E2=80=98ke=
y_params=E2=80=99?
>  3129 |      pdev->device, bus_params.chip_id);
>       |                    ^~~~~~~~~~
>       |                    key_params
>
Ok, I see. That "bus_params." there has to go so just "chip_id" remains.

But, I'm sorry that I caused this havoc.
For a little bit of background: Getting the QCA9880-AR1A and the board
it works back, will
take until next year. Since this card either doesn't fit (it's
oversized mini-pcie) or flat-out
doesn't work (it crashes the vast majority of x86/AMD64 system during post)=
.
So doing tests with the hardware involves going through custom OpenWrt-buil=
ds.

> Please fix this up and resend backports again.
I guess, I can do that. Question is, given the bug has been around
since 2015 and the
response for this patch has been negative (even from those who have
crashes from it).
I'm thinking that I'll rather drop this and take the time off by doing
something else for
a while.

Yours,
Christian
