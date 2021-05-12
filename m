Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 659F837ED83
	for <lists+stable@lfdr.de>; Thu, 13 May 2021 00:41:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345976AbhELUhr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 May 2021 16:37:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60728 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1357312AbhELSiX (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 12 May 2021 14:38:23 -0400
Received: from mail-oo1-xc36.google.com (mail-oo1-xc36.google.com [IPv6:2607:f8b0:4864:20::c36])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CB981C06135B
        for <stable@vger.kernel.org>; Wed, 12 May 2021 11:35:36 -0700 (PDT)
Received: by mail-oo1-xc36.google.com with SMTP id s1-20020a4ac1010000b02901cfd9170ce2so5148309oop.12
        for <stable@vger.kernel.org>; Wed, 12 May 2021 11:35:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=nZFOyyXBKCVxmTHei8WqaYqRSiqzWm2DLlZyJ5bNF0M=;
        b=UGFmHWnZd5QjL4xBwBlac6osWkLaUHtX6929sOkYWN73jejloRBbtOgHAcLmZJWOQP
         cwP5MKsrrkXojeQ9jJ4ocYHkwCvzNPRq8YshRqBrJUMGkW0tqpMiZxUQLCjCHsxIT6Cv
         xoYjNIDazEhOTfurUtlAK4l2Eb2GBhbUODSHE=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=nZFOyyXBKCVxmTHei8WqaYqRSiqzWm2DLlZyJ5bNF0M=;
        b=c0ZNSdXVyNcAMPw8JiD4M6xgupOn938mXcwTwYQvHGf/vkqpyqAtrHL174ZhzmC0PF
         zAbiOtyhbOi3VjFPkt8BSQl0jj2uKrxmTlasQnO4n6PCwO/gsrIsJYdJRejtWL7pVoFu
         x/gUb6lXtD0t57GsooJMiPFqqA+hhfP5hcsideUK2ufqhTME060X19EL69mjXzbJ2y7O
         y97k7ROcgRTgUmOBUKm0trkjOz5ccKWgYao5FSxoaoKAtQIFBlJxTTH2NV5pze5JcdgR
         H2nQMNGg70V48UtGzKu0zbUhemNY0GdHkJFsBu7aMopriZWZxt1gBWeMBRr+n4+Y/Qer
         DFIw==
X-Gm-Message-State: AOAM533+bObHEFwRlOwXCLbrv+WvTnAJRf9X4HiHxlnXliLpEZV9pIY0
        gEgL2bNXIz44GCTditSIKJF0Lx8D0iQRgQ==
X-Google-Smtp-Source: ABdhPJxkgrutnAdnrHPjXYhHRQU2Z3EMk/HtaaSxdQ6EjOMc3y0BbPABP7vtz+ligUgYQZpKU63FGQ==
X-Received: by 2002:a4a:5242:: with SMTP id d63mr28719781oob.93.1620844535913;
        Wed, 12 May 2021 11:35:35 -0700 (PDT)
Received: from mail-oi1-f181.google.com (mail-oi1-f181.google.com. [209.85.167.181])
        by smtp.gmail.com with ESMTPSA id p21sm56912ota.26.2021.05.12.11.35.35
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 12 May 2021 11:35:35 -0700 (PDT)
Received: by mail-oi1-f181.google.com with SMTP id z3so21916070oib.5
        for <stable@vger.kernel.org>; Wed, 12 May 2021 11:35:35 -0700 (PDT)
X-Received: by 2002:aca:f144:: with SMTP id p65mr8428701oih.117.1620844534896;
 Wed, 12 May 2021 11:35:34 -0700 (PDT)
MIME-Version: 1.0
References: <20210511180259.159598-1-johannes@sipsolutions.net> <20210511200110.11968c725b5c.Idd166365ebea2771c0c0a38c78b5060750f90e17@changeid>
In-Reply-To: <20210511200110.11968c725b5c.Idd166365ebea2771c0c0a38c78b5060750f90e17@changeid>
From:   Brian Norris <briannorris@chromium.org>
Date:   Wed, 12 May 2021 11:35:23 -0700
X-Gmail-Original-Message-ID: <CA+ASDXPwAWEEvWBdiLpMrm-PTcSH7QQHwx_T5nxN+faQt=Wi_g@mail.gmail.com>
Message-ID: <CA+ASDXPwAWEEvWBdiLpMrm-PTcSH7QQHwx_T5nxN+faQt=Wi_g@mail.gmail.com>
Subject: Re: [PATCH 14/18] ath10k: drop MPDU which has discard flag set by
 firmware for SDIO
To:     Johannes Berg <johannes@sipsolutions.net>
Cc:     linux-wireless <linux-wireless@vger.kernel.org>,
        Wen Gong <wgong@codeaurora.org>,
        stable <stable@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, May 11, 2021 at 11:03 AM Johannes Berg
<johannes@sipsolutions.net> wrote:
> --- a/drivers/net/wireless/ath/ath10k/htt_rx.c
> +++ b/drivers/net/wireless/ath/ath10k/htt_rx.c
> @@ -2312,6 +2312,11 @@ static bool ath10k_htt_rx_proc_rx_ind_hl(struct ath10k_htt *htt,
>         fw_desc = &rx->fw_desc;
>         rx_desc_len = fw_desc->len;
>
> +       if (fw_desc->u.bits.discard) {
> +               ath10k_dbg(ar, ATH10K_DBG_HTT, "htt discard mpdu\n");
> +               goto err;
> +       }
> +
>         /* I have not yet seen any case where num_mpdu_ranges > 1.
>          * qcacld does not seem handle that case either, so we introduce the
>          * same limitiation here as well.
> diff --git a/drivers/net/wireless/ath/ath10k/rx_desc.h b/drivers/net/wireless/ath/ath10k/rx_desc.h
> index f2b6bf8f0d60..705b6295e466 100644
> --- a/drivers/net/wireless/ath/ath10k/rx_desc.h
> +++ b/drivers/net/wireless/ath/ath10k/rx_desc.h
> @@ -1282,7 +1282,19 @@ struct fw_rx_desc_base {
>  #define FW_RX_DESC_UDP              (1 << 6)
>
>  struct fw_rx_desc_hl {
> -       u8 info0;
> +       union {
> +               struct {
> +               u8 discard:1,
> +                  forward:1,
> +                  any_err:1,
> +                  dup_err:1,
> +                  reserved:1,
> +                  inspect:1,
> +                  extension:2;
> +               } bits;
> +               u8 info0;
> +       } u;

Am I misled here, or are you introducing endianness issues here? From C99:

"The order of allocation of bit-fields within a unit (high-order to
low-order or low-order to high-order) is implementation-defined."

Now, we're pretty well attuned to two implementations (big and little
endian), and this should work for the most common one (little endian),
but it's not wise to assume everyone is little endian.

Brian
