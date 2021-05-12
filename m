Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8E81037D204
	for <lists+stable@lfdr.de>; Wed, 12 May 2021 20:06:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230375AbhELSEi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 May 2021 14:04:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41402 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345985AbhELRMi (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 12 May 2021 13:12:38 -0400
Received: from mail-qt1-x835.google.com (mail-qt1-x835.google.com [IPv6:2607:f8b0:4864:20::835])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 29846C061348
        for <stable@vger.kernel.org>; Wed, 12 May 2021 10:04:13 -0700 (PDT)
Received: by mail-qt1-x835.google.com with SMTP id c11so17634150qth.2
        for <stable@vger.kernel.org>; Wed, 12 May 2021 10:04:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kaishome.de; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=oLi1mcmerH+rqfkJPQwkDVKMnOt9Ah8OQvO3USWjQEY=;
        b=bxVsfcaIReSLEU7C0MlvMrpMUN3lsMcxPHZ4Y1tW64aZFFDXsZFchQniUUWNorTwgx
         CDcsJwx/la2s5+Nd6B8khChsWyR7YiVWkF4b+NpcCsRUjt5XNHiHdCuVjT+8wwmMkYxK
         JGKFSxLuqScOGIicifpEGqwbuSlxhhbrDG3Bs=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=oLi1mcmerH+rqfkJPQwkDVKMnOt9Ah8OQvO3USWjQEY=;
        b=YZWTrEGZrjxPmPaSOI+mMzB/cazVTjAsI8g43ThrDkMuunGMCKsqkIeMx1oA42Ye1t
         ab6YsffENtwtpO9ilo2A4fNelvYIVBjS9J7wk12ExkSxSYKUVzUZGP8CUUOXWykvZwYo
         4L4KzQgg+p6Cdx0WFoT3lpjw7dPoo4WEo/eBwyolZcdzvnqSD1yQ5FSews6TAD6beiPG
         FxftUkQV/PI8xBbm3HYqpzqRhQ7tJFT4wbrda9iLt6F5xfRs6mUrRDP6HIiEQV12ruwu
         IV5haiGjZ/9NEHolMGYdfJnPiXL7Kil40zni662n/1hTcEYq96JkYYfiVbnBUeeCE1vM
         89Qw==
X-Gm-Message-State: AOAM5303u4OXOuua0lGAaYnBZv43ap6sn99tUXaKPlHhzyBuIuyw9ZiW
        9fF4MIYBSGNr45UM4IvTxrxcjo9J2z3yPfBb6NsNI9U2gOI=
X-Google-Smtp-Source: ABdhPJw9nb/MeAp+Jm7n0y5TQPS2lxmyTSRTXUosZP4Su8i9T4smqd8Y6EjnoA5P5VMtMD+48iIVXpmE48uhAs6rSeM=
X-Received: by 2002:ac8:7355:: with SMTP id q21mr18042001qtp.383.1620839052362;
 Wed, 12 May 2021 10:04:12 -0700 (PDT)
MIME-Version: 1.0
References: <20210512133407.52330-1-szymon.janc@codecoup.pl>
In-Reply-To: <20210512133407.52330-1-szymon.janc@codecoup.pl>
From:   Kai Krakow <kai@kaishome.de>
Date:   Wed, 12 May 2021 19:04:01 +0200
Message-ID: <CAC2ZOYvax0WGO7wMzbPXQMGb2NDouAF6XRgd5TH+h-f6uWvhtg@mail.gmail.com>
Subject: Re: [PATCH] Bluetooth: Remove spurious error message
To:     Szymon Janc <szymon.janc@codecoup.pl>
Cc:     linux-bluetooth@vger.kernel.org, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Szymon!

Am Mi., 12. Mai 2021 um 15:34 Uhr schrieb Szymon Janc <szymon.janc@codecoup.pl>:
>
> Even with rate limited reporting this is very spammy and since
> it is remote device that is providing bogus data there is no
> need to report this as error.
>
[...]
> [72464.546319] Bluetooth: hci0: advertising data len corrected
> [72464.857318] Bluetooth: hci0: advertising data len corrected
> [72465.163332] Bluetooth: hci0: advertising data len corrected
> [72465.278331] Bluetooth: hci0: advertising data len corrected
> [72465.432323] Bluetooth: hci0: advertising data len corrected
> [72465.891334] Bluetooth: hci0: advertising data len corrected
> [72466.045334] Bluetooth: hci0: advertising data len corrected
> [72466.197321] Bluetooth: hci0: advertising data len corrected
> [72466.340318] Bluetooth: hci0: advertising data len corrected
> [72466.498335] Bluetooth: hci0: advertising data len corrected
> [72469.803299] bt_err_ratelimited: 10 callbacks suppressed
>
> Signed-off-by: Szymon Janc <szymon.janc@codecoup.pl>
> Fixes: https://bugzilla.kernel.org/show_bug.cgi?id=203753
> Cc: stable@vger.kernel.org
> ---
>  net/bluetooth/hci_event.c | 2 --
>  1 file changed, 2 deletions(-)
>
> diff --git a/net/bluetooth/hci_event.c b/net/bluetooth/hci_event.c
> index 5e99968939ce..abdc44dc0b2f 100644
> --- a/net/bluetooth/hci_event.c
> +++ b/net/bluetooth/hci_event.c
> @@ -5476,8 +5476,6 @@ static void process_adv_report(struct hci_dev *hdev, u8 type, bdaddr_t *bdaddr,
>
>         /* Adjust for actual length */
>         if (len != real_len) {
> -               bt_dev_err_ratelimited(hdev, "advertising data len corrected %u -> %u",
> -                                      len, real_len);
>                 len = real_len;
>         }

This renders the "if" quite useless since it now always ensures len =
real_len and nothing else. At this point, the "if" can be removed, and
len can be set unconditionally. Depending on the further context of
the patch, destinction between real_len and len may not be needed at
all and real_len could be renamed to len, ditching the unused original
which is potentially bogus data anyways according to your commit
description.

Regards,
Kai
