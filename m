Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BDE1837ED7B
	for <lists+stable@lfdr.de>; Thu, 13 May 2021 00:41:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240853AbhELUga (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 May 2021 16:36:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56104 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1354023AbhELSQQ (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 12 May 2021 14:16:16 -0400
Received: from mail-yb1-xb35.google.com (mail-yb1-xb35.google.com [IPv6:2607:f8b0:4864:20::b35])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0B828C061349;
        Wed, 12 May 2021 11:13:31 -0700 (PDT)
Received: by mail-yb1-xb35.google.com with SMTP id 82so31836622yby.7;
        Wed, 12 May 2021 11:13:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=A0THslFn0Kgu1sWjV5jie9dbcrzud4y09B5VHnV/OvU=;
        b=h4G79n5j2Q9e7O4qyc9sCxuAqxg6oZDNwMRBD3YMzPGfOfL4TrCzbmi3KH9dx8Ykom
         o/Pt46mKPb43l6HMaeofOZRMmgOMrQas8OqcGBQcPBIMwoas46b0iL2IJ8mX8EnGC0CR
         G6XLTEpCjujxGJiKOX0E2tgtush+4/TxKjmrfP5eGM0qQs5Ndq220Oo4VYbUuDepsHYp
         wpwhpn1EcYkqAhq8H0Y4MYylRcWF4zPnjsYwZZ4vzMecmknR9xse61peQ066iRj6TjrD
         OUtu7Bn537FO7nz7E6LwGgJx0QpGUe734RHb7rvvbxTo9s7LwppQmfj9VxSNGOV39nw1
         o80Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=A0THslFn0Kgu1sWjV5jie9dbcrzud4y09B5VHnV/OvU=;
        b=KHuRhPJWO9lNosgawmjF+MCqCWHXPZCArefoO6gJTTZJ5tBJ32QK87KWtzvke9Ayj0
         YCEn7A9Url6dEhOEQk8k0HgbTAr3qQo7Fx578/EZ/v1lOAqCnqzCSmIpTpb/Szj3iH9k
         5GaCSZ9Qcmz3JXZheQqdKrMQNgG9ARejDclTkINaAa4QUA9QwQSGyyhEZvTPmbwJF5Ss
         EmEtJVzayb1kt49b2zFcv+a462kTEZW6exMruvWFwDNd7V3Dumyxf8Ci/srkC7Repd49
         LpZ8lqPNpn/5vTanTVyKp4PYIF6tNZXdkzuqCl80MD4JaSM0y73C/pKQJBbmk+g4Dc7q
         wiuA==
X-Gm-Message-State: AOAM5330AmsZHB0suHaAf22uE3OeVFBexY9aWdpajq7pAaHcH65UMRqz
        hQkdYU02ZPGh1gRrcC7jgjQZ9xJC0mWbcMG0PDJ6rt6A
X-Google-Smtp-Source: ABdhPJwodnVxq21dO5kaDNX8tBwkSXdpZBp9QurgW1NTiDItPl7d8pOO+UpBPW4T1G3YHHkEtiu4F0xVyB6xh9ImYgg=
X-Received: by 2002:a25:d0cb:: with SMTP id h194mr37698941ybg.408.1620843210333;
 Wed, 12 May 2021 11:13:30 -0700 (PDT)
MIME-Version: 1.0
References: <20210512133407.52330-1-szymon.janc@codecoup.pl> <CAC2ZOYvax0WGO7wMzbPXQMGb2NDouAF6XRgd5TH+h-f6uWvhtg@mail.gmail.com>
In-Reply-To: <CAC2ZOYvax0WGO7wMzbPXQMGb2NDouAF6XRgd5TH+h-f6uWvhtg@mail.gmail.com>
From:   Luiz Augusto von Dentz <luiz.dentz@gmail.com>
Date:   Wed, 12 May 2021 11:13:19 -0700
Message-ID: <CABBYNZKBW1wtTbkmcQbAybGm7zdcur16935yGNwid9oiGOxNFQ@mail.gmail.com>
Subject: Re: [PATCH] Bluetooth: Remove spurious error message
To:     Kai Krakow <kai@kaishome.de>
Cc:     Szymon Janc <szymon.janc@codecoup.pl>,
        "linux-bluetooth@vger.kernel.org" <linux-bluetooth@vger.kernel.org>,
        stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Kai,

On Wed, May 12, 2021 at 11:06 AM Kai Krakow <kai@kaishome.de> wrote:
>
> Hi Szymon!
>
> Am Mi., 12. Mai 2021 um 15:34 Uhr schrieb Szymon Janc <szymon.janc@codecoup.pl>:
> >
> > Even with rate limited reporting this is very spammy and since
> > it is remote device that is providing bogus data there is no
> > need to report this as error.
> >
> [...]
> > [72464.546319] Bluetooth: hci0: advertising data len corrected
> > [72464.857318] Bluetooth: hci0: advertising data len corrected
> > [72465.163332] Bluetooth: hci0: advertising data len corrected
> > [72465.278331] Bluetooth: hci0: advertising data len corrected
> > [72465.432323] Bluetooth: hci0: advertising data len corrected
> > [72465.891334] Bluetooth: hci0: advertising data len corrected
> > [72466.045334] Bluetooth: hci0: advertising data len corrected
> > [72466.197321] Bluetooth: hci0: advertising data len corrected
> > [72466.340318] Bluetooth: hci0: advertising data len corrected
> > [72466.498335] Bluetooth: hci0: advertising data len corrected
> > [72469.803299] bt_err_ratelimited: 10 callbacks suppressed
> >
> > Signed-off-by: Szymon Janc <szymon.janc@codecoup.pl>
> > Fixes: https://bugzilla.kernel.org/show_bug.cgi?id=203753
> > Cc: stable@vger.kernel.org
> > ---
> >  net/bluetooth/hci_event.c | 2 --
> >  1 file changed, 2 deletions(-)
> >
> > diff --git a/net/bluetooth/hci_event.c b/net/bluetooth/hci_event.c
> > index 5e99968939ce..abdc44dc0b2f 100644
> > --- a/net/bluetooth/hci_event.c
> > +++ b/net/bluetooth/hci_event.c
> > @@ -5476,8 +5476,6 @@ static void process_adv_report(struct hci_dev *hdev, u8 type, bdaddr_t *bdaddr,
> >
> >         /* Adjust for actual length */
> >         if (len != real_len) {
> > -               bt_dev_err_ratelimited(hdev, "advertising data len corrected %u -> %u",
> > -                                      len, real_len);
> >                 len = real_len;
> >         }
>
> This renders the "if" quite useless since it now always ensures len =
> real_len and nothing else. At this point, the "if" can be removed, and
> len can be set unconditionally. Depending on the further context of
> the patch, destinction between real_len and len may not be needed at
> all and real_len could be renamed to len, ditching the unused original
> which is potentially bogus data anyways according to your commit
> description.

That was introduced to truncate the len, the patch just removes the
logging but it does keep this logic, if you want to understand the
reason for it just use git blame and look at the history.


-- 
Luiz Augusto von Dentz
