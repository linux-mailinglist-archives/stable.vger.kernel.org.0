Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A573737FF45
	for <lists+stable@lfdr.de>; Thu, 13 May 2021 22:35:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232343AbhEMUgK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 13 May 2021 16:36:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40498 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233059AbhEMUgI (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 13 May 2021 16:36:08 -0400
Received: from mail-yb1-xb32.google.com (mail-yb1-xb32.google.com [IPv6:2607:f8b0:4864:20::b32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B007CC06174A;
        Thu, 13 May 2021 13:34:58 -0700 (PDT)
Received: by mail-yb1-xb32.google.com with SMTP id i204so4186655yba.4;
        Thu, 13 May 2021 13:34:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=gpOgFcz1Lz2Hvu1NQwtymjYfxRaZrwlVhsmIga9T8F0=;
        b=QonC5tSf39l7vkW2j6eGc/Vi5FwiLT1WsMbvD+jm5UD0Ihefbn5k5ZXgPmn43IbXMG
         RFc6H1BvYd0qiqGLX8EJWUFxorHJKqSCpHHWCMfcfpPRsMvlf7Bfd3Q01sErrDWJIOk/
         Nr5Q3HLV0q8PvsmDOpiX4BevbH/V7UwDhQ1HriS140gizu1Q4V/C4rMJXyZiBnAIpABT
         WiWj+iqIaWmSU6mDOFGaixhoiAMMHO76G5v99qpp8/zOvd648gC4BWPw6kzmottddj3C
         AXaXHMBhJ1Y47ruje6TTxotFGylAWyHza0WsP6EKguEs8ekIVMCwo/e0CEmyQ7rkJIew
         ZRCQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=gpOgFcz1Lz2Hvu1NQwtymjYfxRaZrwlVhsmIga9T8F0=;
        b=l5RxZ+w8/4+SRYDYJqg5oPBUECxNey3G3lWA8RhK9QQuM5mvS+St+Gf5cnud6ZGpcH
         4ehkjBQwjPZ8cAulDS/ClXU0gZ8X4QxSXIy3ooHhnUsOxXkPVdExVAu3/F8h5hXMDicG
         5M3W3tEXwqv/7QcTemMCNDxBuUHGVwiokpYlmlPiLYX/8+nltW4jumOxX64zaQCZgrln
         nMextFjp0ZbbGFkoNEq1+IcFr2KHAziAklirPUVCJGEZKlcRKs+edZCnusEt8Xbs3zuZ
         ARAhJCS7rB3GZg2QgNtxiYNpyAMhfCfnLDTZG9tHc+o0vIPuxLulDuyaGZiAD0PqJWL6
         nvKQ==
X-Gm-Message-State: AOAM533MY1oIjiLKV4ntrOCZOY8znto6Pyxsc6ueW3kzH3f5aVvmhfvP
        X9+s158sQj2/Dd/cDm696C4emDFxNwdRxJ10BuM6x24Brmk=
X-Google-Smtp-Source: ABdhPJzMRIKta7npUnYKHV3iMqxb5v3Zm8FVV8LMgvGmlECG43l62ufBogqhgM7KeZAyLuiXPY5m31aT/FUbeNAdE2U=
X-Received: by 2002:a25:ad8b:: with SMTP id z11mr30932382ybi.91.1620938097977;
 Thu, 13 May 2021 13:34:57 -0700 (PDT)
MIME-Version: 1.0
References: <20210513122220.313465-1-szymon.janc@codecoup.pl>
In-Reply-To: <20210513122220.313465-1-szymon.janc@codecoup.pl>
From:   Luiz Augusto von Dentz <luiz.dentz@gmail.com>
Date:   Thu, 13 May 2021 13:34:47 -0700
Message-ID: <CABBYNZLCBW3O21re8hnZ2PyGRWoWZA7vCFYA2yscsDM0Y7oR0w@mail.gmail.com>
Subject: Re: [PATCH v2] Bluetooth: Remove spurious error message
To:     Szymon Janc <szymon.janc@codecoup.pl>
Cc:     "linux-bluetooth@vger.kernel.org" <linux-bluetooth@vger.kernel.org>,
        stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Szymon,

On Thu, May 13, 2021 at 1:23 PM Szymon Janc <szymon.janc@codecoup.pl> wrote:
>
> Even with rate limited reporting this is very spammy and since
> it is remote device that is providing bogus data there is no
> need to report this as error.
>
> Since real_len variable was used only to allow conditional error
> message it is now also removed.
>
> [72454.143336] bt_err_ratelimited: 10 callbacks suppressed
> [72454.143337] Bluetooth: hci0: advertising data len corrected
> [72454.296314] Bluetooth: hci0: advertising data len corrected
> [72454.892329] Bluetooth: hci0: advertising data len corrected
> [72455.051319] Bluetooth: hci0: advertising data len corrected
> [72455.357326] Bluetooth: hci0: advertising data len corrected
> [72455.663295] Bluetooth: hci0: advertising data len corrected
> [72455.787278] Bluetooth: hci0: advertising data len corrected
> [72455.942278] Bluetooth: hci0: advertising data len corrected
> [72456.094276] Bluetooth: hci0: advertising data len corrected
> [72456.249137] Bluetooth: hci0: advertising data len corrected
> [72459.416333] bt_err_ratelimited: 13 callbacks suppressed
> [72459.416334] Bluetooth: hci0: advertising data len corrected
> [72459.721334] Bluetooth: hci0: advertising data len corrected
> [72460.011317] Bluetooth: hci0: advertising data len corrected
> [72460.327171] Bluetooth: hci0: advertising data len corrected
> [72460.638294] Bluetooth: hci0: advertising data len corrected
> [72460.946350] Bluetooth: hci0: advertising data len corrected
> [72461.225320] Bluetooth: hci0: advertising data len corrected
> [72461.690322] Bluetooth: hci0: advertising data len corrected
> [72462.118318] Bluetooth: hci0: advertising data len corrected
> [72462.427319] Bluetooth: hci0: advertising data len corrected
> [72464.546319] bt_err_ratelimited: 7 callbacks suppressed
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
Reviewed-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
> Fixes: https://bugzilla.kernel.org/show_bug.cgi?id=203753
> Cc: stable@vger.kernel.org
> ---
>  net/bluetooth/hci_event.c | 10 ++--------
>  1 file changed, 2 insertions(+), 8 deletions(-)
>
> diff --git a/net/bluetooth/hci_event.c b/net/bluetooth/hci_event.c
> index 5e99968939ce..26846d338fa7 100644
> --- a/net/bluetooth/hci_event.c
> +++ b/net/bluetooth/hci_event.c
> @@ -5441,7 +5441,7 @@ static void process_adv_report(struct hci_dev *hdev, u8 type, bdaddr_t *bdaddr,
>         struct hci_conn *conn;
>         bool match;
>         u32 flags;
> -       u8 *ptr, real_len;
> +       u8 *ptr;
>
>         switch (type) {
>         case LE_ADV_IND:
> @@ -5472,14 +5472,8 @@ static void process_adv_report(struct hci_dev *hdev, u8 type, bdaddr_t *bdaddr,
>                         break;
>         }
>
> -       real_len = ptr - data;
> -
>         /* Adjust for actual length */
> -       if (len != real_len) {
> -               bt_dev_err_ratelimited(hdev, "advertising data len corrected %u -> %u",
> -                                      len, real_len);
> -               len = real_len;
> -       }
> +       len = ptr - data;
>
>         /* If the direct address is present, then this report is from
>          * a LE Direct Advertising Report event. In that case it is
> --
> 2.31.1
>


-- 
Luiz Augusto von Dentz
