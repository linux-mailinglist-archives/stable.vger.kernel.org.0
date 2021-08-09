Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2623A3E3F1C
	for <lists+stable@lfdr.de>; Mon,  9 Aug 2021 06:49:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229483AbhHIEst (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 9 Aug 2021 00:48:49 -0400
Received: from smtp-relay-canonical-1.canonical.com ([185.125.188.121]:44992
        "EHLO smtp-relay-canonical-1.canonical.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232971AbhHIEst (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 9 Aug 2021 00:48:49 -0400
Received: from mail-ed1-f70.google.com (mail-ed1-f70.google.com [209.85.208.70])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by smtp-relay-canonical-1.canonical.com (Postfix) with ESMTPS id AC38340643
        for <stable@vger.kernel.org>; Mon,  9 Aug 2021 04:48:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canonical.com;
        s=20210705; t=1628484508;
        bh=75h4o/MRkSGQlACcTQoPuz+b5eVZCxMSWFiFrjOFsLc=;
        h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
         To:Cc:Content-Type;
        b=SvdfsqJ3X7rnzltrc4Os17QXAewv6AVNimJeugjAjElrE0MQhZRr9VgE7Wy4WQXDq
         exgw8NO0sLhX0WXPRR9faHKtxJuq3Xk+aCEOdqaBiZ+ibutT2FA68+ZQo/NKr4BSzw
         iO3GZLgXitnCvZq7tM5HsareLaF3WQOQgqco2aTGQ0RdiNGG72sK8f0uCZ48lv52ZM
         CCdJlA6JsJnt6FN1cWVeiyFUvsu2amWEpIDxTaehC13RK/ks+FgWbxqtUc91mhLPRd
         Ch7/P9BW2BxADpsnPCH164RL/JpJ7r1yzjcscaMejHcRCj0VCMj/nlNT5ES4mzeysM
         zc/LU6mn3MJDA==
Received: by mail-ed1-f70.google.com with SMTP id dh21-20020a0564021d35b02903be0aa37025so6028551edb.7
        for <stable@vger.kernel.org>; Sun, 08 Aug 2021 21:48:28 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=75h4o/MRkSGQlACcTQoPuz+b5eVZCxMSWFiFrjOFsLc=;
        b=D6V7yVxA0JuoOUWKA/5nnLeXt7KPa67xfxeqBpjcCFekXGizCcFd/lrWly/LtTc5vy
         C+soLVfBrEySrT8QOfL/Q4AcTyK/wbMCT0h32KSA4ZG5DiIY6LWHLKlffg3g28H/IUy7
         NTmVZzqm4oRPMJEdeccDExHgXbK7QZhUprMaF8ALSu15AQDgGZFSBJES1nX4usR66kLK
         O+DifxTv9ebkGFWfiGNG0n5Mb0tUpJRSEGvmZ1XyCF2C6A6MJwgwW5E9/NJKBkJ0DLCD
         0VLz6VJ8UK3Z5e/NpJ6plrpppLlyqiiL30ok6SbVhv8mnC2UUIxhLtQqMhttAzbQCC9y
         ndgA==
X-Gm-Message-State: AOAM532B2NbZ08CkoMOxP1c8TnNk2ezQuWgcwvQF/RearPcoNlRnAcFd
        dv/cmm8QKBj2MseZbJ2kOWtEwW8DaznWw8wq9lQAZVbGchgALTY18hNpzn6vqBYJqXNpw78UB7x
        kwUHSRAlDpDR8dWaH8qbCkyIgqWdbiqZGE8vyhx0cYEZBE70C/g==
X-Received: by 2002:a05:6402:2074:: with SMTP id bd20mr27472485edb.123.1628484508305;
        Sun, 08 Aug 2021 21:48:28 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwz4qXl+RqN1KbXWuCRy6DA54lZwbFdEL+BEhMJC6y1Ykwc6evnkoz1Ly4jxJgL+Hk4IBjokfD2+7ZStioPZsU=
X-Received: by 2002:a05:6402:2074:: with SMTP id bd20mr27472473edb.123.1628484508028;
 Sun, 08 Aug 2021 21:48:28 -0700 (PDT)
MIME-Version: 1.0
References: <a9cd03da-b816-eed3-7e77-d539924cbe88@roeck-us.net>
 <CAAd53p4r5_Hvnt-v0imb1Q6fQaMmRvw-skRdrTAh-GmgegBCdg@mail.gmail.com> <20210809041025.GA2968009@roeck-us.net>
In-Reply-To: <20210809041025.GA2968009@roeck-us.net>
From:   Kai-Heng Feng <kai.heng.feng@canonical.com>
Date:   Mon, 9 Aug 2021 12:48:16 +0800
Message-ID: <CAAd53p7b_uHGqx5FT-s=8+M+PZVREX=3igEsGRgR4JL-TK64QA@mail.gmail.com>
Subject: Re: regression: Bluetooth interface broken on systems with Mediatek CPU
To:     Guenter Roeck <linux@roeck-us.net>
Cc:     regressions@lists.linux.dev, stable <stable@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Marcel Holtmann <marcel@holtmann.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Guenter,

On Mon, Aug 9, 2021 at 12:10 PM Guenter Roeck <linux@roeck-us.net> wrote:
>
> On Mon, Aug 09, 2021 at 10:35:34AM +0800, Kai-Heng Feng wrote:
> > On Sat, Aug 7, 2021 at 6:22 AM Guenter Roeck <linux@roeck-us.net> wrote:
> > >
> > > [ Greg asked me to submit a report to regressions@, so here it is. ]
> > >
> > > The following error was observed on Chromebooks with MT8183 CPU
> > > (ASUS Chromebook Detachable CM3, HP Chromebook 11a, and others):
> > >
> > > [  224.735198] Bluetooth: qca_setup() hci0: setting up ROME/QCA6390
> > > [  225.205024] Bluetooth: qca_read_soc_version() hci0: QCA Product ID   :0x00000008
> > > [  225.205040] Bluetooth: qca_read_soc_version() hci0: QCA SOC Version  :0x00000044
> > > [  225.205045] Bluetooth: qca_read_soc_version() hci0: QCA ROM Version  :0x00000302
> > > [  225.205049] Bluetooth: qca_read_soc_version() hci0: QCA Patch Version:0x000003e8
> > > [  225.205055] Bluetooth: qca_uart_setup() hci0: QCA controller version 0x00440302
> > > [  225.205061] Bluetooth: qca_download_firmware() hci0: QCA Downloading qca/rampatch_00440302.bin
> > > [  227.252653] Bluetooth: hci_cmd_timeout() hci0: command 0xfc00 tx timeout
> > > ...
> > > [  223.604971] Bluetooth: qca_recv() hci0: Frame reassembly failed (-84)
> > > [  223.605027] Bluetooth: qca_recv() hci0: Frame reassembly failed (-84)
> > > (repeated several times)
> > > ...
> > >
> > > The Bluetooth interface on those Chromebooks can not be enabled.
> > >
> > > Bisect suggests that upstream commit 0ea9fd001a14 ("Bluetooth: Shutdown
> > > controller after workqueues are flushed or cancelled") introduced the problem.
> > > Reverting it fixes the problem.
> > >
> > > The problem was also reported at [1] on a Mediatek Pumpkin board.
> > >
> > > As of this writing, the problem is still present in the upstream kernel
> > > as well as in all stable releases which include commit 0ea9fd001a14.
> >
> > Thanks. Can you please test the following patch:
> >
> I would love to, but I am unable to apply the patch. It failed to apply
> to mainline, to linux-next, and to all stable releases I tried.

I think it has something to do with how the code gets pasted to the mail client.
So can you please give this a try:
https://paste.ubuntu.com/p/CsRrQWNYKr/

Kai-Heng

>
> Guenter
>
> > diff --git a/net/bluetooth/hci_core.c b/net/bluetooth/hci_core.c
> > index 2560ed2f144d4..131e69a9a66a0 100644
> > --- a/net/bluetooth/hci_core.c
> > +++ b/net/bluetooth/hci_core.c
> > @@ -1757,6 +1757,14 @@ int hci_dev_do_close(struct hci_dev *hdev)
> >                         cancel_delayed_work_sync(&adv_instance->rpa_expired_cb);
> >         }
> >
> > +       if (!hci_dev_test_flag(hdev, HCI_UNREGISTER) &&
> > +           !hci_dev_test_flag(hdev, HCI_USER_CHANNEL) &&
> > +           test_bit(HCI_UP, &hdev->flags)) {
> > +               /* Execute vendor specific shutdown routine */
> > +               if (hdev->shutdown)
> > +                       hdev->shutdown(hdev);
> > +       }
> > +
> >         /* Avoid potential lockdep warnings from the *_flush() calls by
> >          * ensuring the workqueue is empty up front.
> >          */
> > @@ -1798,14 +1806,6 @@ int hci_dev_do_close(struct hci_dev *hdev)
> >                 clear_bit(HCI_INIT, &hdev->flags);
> >         }
> >
> > -       if (!hci_dev_test_flag(hdev, HCI_UNREGISTER) &&
> > -           !hci_dev_test_flag(hdev, HCI_USER_CHANNEL) &&
> > -           test_bit(HCI_UP, &hdev->flags)) {
> > -               /* Execute vendor specific shutdown routine */
> > -               if (hdev->shutdown)
> > -                       hdev->shutdown(hdev);
> > -       }
> > -
> >         /* flush cmd  work */
> >         flush_work(&hdev->cmd_work);
> >
> >
> > >
> > > Thanks,
> > > Guenter
> > >
> > > ---
> > > [1] https://lkml.org/lkml/2021/7/28/569
