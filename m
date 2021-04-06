Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D2D08354CF6
	for <lists+stable@lfdr.de>; Tue,  6 Apr 2021 08:33:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237872AbhDFGdm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 6 Apr 2021 02:33:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51618 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237859AbhDFGdm (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 6 Apr 2021 02:33:42 -0400
Received: from mail-il1-x134.google.com (mail-il1-x134.google.com [IPv6:2607:f8b0:4864:20::134])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F2BEAC06174A;
        Mon,  5 Apr 2021 23:33:33 -0700 (PDT)
Received: by mail-il1-x134.google.com with SMTP id p8so7773252ilm.13;
        Mon, 05 Apr 2021 23:33:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:reply-to:from:date:message-id
         :subject:to:cc;
        bh=YclcbZ+01yOe2Y4RWo3drdGY4HnFs/FnK/QDmZ3CspM=;
        b=JLU2V0NeOjUOxTZwOmi0PFOf+ojXYlFd31249WDobTVv5dnlQ1xtrm9BToC2ee6+oP
         TxAkW7vwRGC+NjOdAi/GhI7dJjaAVcnq6Ppgy0HHSMMT4elJzYRGQlcFHEtNPVUiqSkI
         bZAIH4EGBOZophikiOxnvjyKZWMcwlvem1Yv3hSQHbDVuQd657jRLbEaQ6OOiwQ9F/i+
         lBdVGj63HZDI7W4fpqJcETVvE8fZTIVKsul/NFhu+pFXrjCpeblU1B2Nv3o0K/HDLI12
         +CBm4c55OZQ5LaLGrddZz3F/oUKDIGoucqrm81Yl9Kd603zpi3WwJvYiHFxCYwil0t6A
         2BTA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:reply-to
         :from:date:message-id:subject:to:cc;
        bh=YclcbZ+01yOe2Y4RWo3drdGY4HnFs/FnK/QDmZ3CspM=;
        b=UK5KEAYXl+TgQ5+e7JPRvxeZryr6Vgn6E3jSW0vDLMIH6Y4tC4SofBA+5yqurTlQWS
         /D5GgMprDyJzZEzcc+z77pOgt84e1yyg9aUebbWJ8FpM/1kIZxZQveynNcN18xIsQuU4
         vGCCkyoWC+YrqZw/TixD8zdsYBr1ZRyU1K903Usc8p2Bu8D3/6TKoshIwbAujDoLhpoC
         5JtyFR5FfvMVcONmvtI25RIONTiby6G2H/9lbzlsakm7WvEzvXiYT9cWz4HKULD1984h
         Vbd/ZjmVnLp8r9Ul6bgHKUpJRnXxdJpp9UqUTY6H6pOK5vCJklx8pkcRGf2XAESlbDIB
         CBOA==
X-Gm-Message-State: AOAM532XApz6StMOSsLFcDHZDuSFtdHFz8l/ULxsvtPyKf7TE4hFXvX7
        B7WFiJffIiBDjb2UWmKSt8XAerx24I6ou3B6DlFCd2IG1q0=
X-Google-Smtp-Source: ABdhPJzxKELBFbd8rqATxsC27bWUIAhfFgNUQr9htiFY6wCyDgPTupIMbva1DLRpQ8apqiVvMmfumeMLw1juu1wITbc=
X-Received: by 2002:a92:d78f:: with SMTP id d15mr22474033iln.112.1617690813213;
 Mon, 05 Apr 2021 23:33:33 -0700 (PDT)
MIME-Version: 1.0
References: <20210319232510.f1a139cfdd9c.Ic5c7c9d1d28972059e132ea653a21a427c326678@changeid>
In-Reply-To: <20210319232510.f1a139cfdd9c.Ic5c7c9d1d28972059e132ea653a21a427c326678@changeid>
Reply-To: sedat.dilek@gmail.com
From:   Sedat Dilek <sedat.dilek@gmail.com>
Date:   Tue, 6 Apr 2021 08:33:00 +0200
Message-ID: <CA+icZUX0ToCQouzVaYfdPNyMphz27=sjVgnsprJWSAACVo4_jw@mail.gmail.com>
Subject: Re: [PATCH] rfkill: revert back to old userspace API by default
To:     Johannes Berg <johannes@sipsolutions.net>
Cc:     linux-wireless@vger.kernel.org,
        Johannes Berg <johannes.berg@intel.com>,
        stable@vger.kernel.org, Takashi Iwai <tiwai@suse.de>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Mar 19, 2021 at 11:26 PM Johannes Berg
<johannes@sipsolutions.net> wrote:
>
> From: Johannes Berg <johannes.berg@intel.com>
>
> Recompiling with the new extended version of struct rfkill_event
> broke systemd in *two* ways:
>  - It used "sizeof(struct rfkill_event)" to read the event, but
>    then complained if it actually got something != 8, this broke
>    it on new kernels (that include the updated API);
>  - It used sizeof(struct rfkill_event) to write a command, but
>    didn't implement the intended expansion protocol where the
>    kernel returns only how many bytes it accepted, and errored
>    out due to the unexpected smaller size on kernels that didn't
>    include the updated API.
>
> Even though systemd has now been fixed, that fix may not be always
> deployed, and other applications could potentially have similar
> issues.
>
> As such, in the interest of avoiding regressions, revert the
> default API "struct rfkill_event" back to the original size.
>
> Instead, add a new "struct rfkill_event_ext" that extends it by
> the new field, and even more clearly document that applications
> should be prepared for extensions in two ways:
>  * write might only accept fewer bytes on older kernels, and
>    will return how many to let userspace know which data may
>    have been ignored;
>  * read might return anything between 8 (the original size) and
>    whatever size the application sized its buffer at, indicating
>    how much event data was supported by the kernel.
>
> Perhaps that will help avoid such issues in the future and we
> won't have to come up with another version of the struct if we
> ever need to extend it again.
>
> Applications that want to take advantage of the new field will
> have to be modified to use struct rfkill_event_ext instead now,
> which comes with the danger of them having already been updated
> to use it from 'struct rfkill_event', but I found no evidence
> of that, and it's still relatively new.
>
> Cc: stable@vger.kernel.org # 5.11
> Reported-by: Takashi Iwai <tiwai@suse.de>
> Signed-off-by: Johannes Berg <johannes.berg@intel.com>

Thanks for the patch.

Tested-by: Sedat Dilek <sedat.dilek@gmail.com> # LLVM/Clang v12.0.0-r4 (x86-64)

- Sedat -

> ---
>  include/uapi/linux/rfkill.h | 80 +++++++++++++++++++++++++++++++------
>  net/rfkill/core.c           |  7 ++--
>  2 files changed, 72 insertions(+), 15 deletions(-)
>
> diff --git a/include/uapi/linux/rfkill.h b/include/uapi/linux/rfkill.h
> index 03e8af87b364..9b77cfc42efa 100644
> --- a/include/uapi/linux/rfkill.h
> +++ b/include/uapi/linux/rfkill.h
> @@ -86,34 +86,90 @@ enum rfkill_hard_block_reasons {
>   * @op: operation code
>   * @hard: hard state (0/1)
>   * @soft: soft state (0/1)
> + *
> + * Structure used for userspace communication on /dev/rfkill,
> + * used for events from the kernel and control to the kernel.
> + */
> +struct rfkill_event {
> +       __u32 idx;
> +       __u8  type;
> +       __u8  op;
> +       __u8  soft;
> +       __u8  hard;
> +} __attribute__((packed));
> +
> +/**
> + * struct rfkill_event_ext - events for userspace on /dev/rfkill
> + * @idx: index of dev rfkill
> + * @type: type of the rfkill struct
> + * @op: operation code
> + * @hard: hard state (0/1)
> + * @soft: soft state (0/1)
>   * @hard_block_reasons: valid if hard is set. One or several reasons from
>   *     &enum rfkill_hard_block_reasons.
>   *
>   * Structure used for userspace communication on /dev/rfkill,
>   * used for events from the kernel and control to the kernel.
> + *
> + * See the extensibility docs below.
>   */
> -struct rfkill_event {
> +struct rfkill_event_ext {
>         __u32 idx;
>         __u8  type;
>         __u8  op;
>         __u8  soft;
>         __u8  hard;
> +
> +       /*
> +        * older kernels will accept/send only up to this point,
> +        * and if extended further up to any chunk marked below
> +        */
> +
>         __u8  hard_block_reasons;
>  } __attribute__((packed));
>
> -/*
> - * We are planning to be backward and forward compatible with changes
> - * to the event struct, by adding new, optional, members at the end.
> - * When reading an event (whether the kernel from userspace or vice
> - * versa) we need to accept anything that's at least as large as the
> - * version 1 event size, but might be able to accept other sizes in
> - * the future.
> +/**
> + * DOC: Extensibility
> + *
> + * Originally, we had planned to allow backward and forward compatible
> + * changes by just adding fields at the end of the structure that are
> + * then not reported on older kernels on read(), and not written to by
> + * older kernels on write(), with the kernel reporting the size it did
> + * accept as the result.
> + *
> + * This would have allowed userspace to detect on read() and write()
> + * which kernel structure version it was dealing with, and if was just
> + * recompiled it would have gotten the new fields, but obviously not
> + * accessed them, but things should've continued to work.
> + *
> + * Unfortunately, while actually exercising this mechanism to add the
> + * hard block reasons field, we found that userspace (notably systemd)
> + * did all kinds of fun things not in line with this scheme:
> + *
> + * 1. treat the (expected) short writes as an error;
> + * 2. ask to read sizeof(struct rfkill_event) but then compare the
> + *    actual return value to RFKILL_EVENT_SIZE_V1 and treat any
> + *    mismatch as an error.
> + *
> + * As a consequence, just recompiling with a new struct version caused
> + * things to no longer work correctly on old and new kernels.
> + *
> + * Hence, we've rolled back &struct rfkill_event to the original version
> + * and added &struct rfkill_event_ext. This effectively reverts to the
> + * old behaviour for all userspace, unless it explicitly opts in to the
> + * rules outlined here by using the new &struct rfkill_event_ext.
> + *
> + * Userspace using &struct rfkill_event_ext must adhere to the following
> + * rules
>   *
> - * One exception is the kernel -- we already have two event sizes in
> - * that we've made the 'hard' member optional since our only option
> - * is to ignore it anyway.
> + * 1. accept short writes, optionally using them to detect that it's
> + *    running on an older kernel;
> + * 2. accept short reads, knowing that this means it's running on an
> + *    older kernel;
> + * 3. treat reads that are as long as requested as acceptable, not
> + *    checking against RFKILL_EVENT_SIZE_V1 or such.
>   */
> -#define RFKILL_EVENT_SIZE_V1   8
> +#define RFKILL_EVENT_SIZE_V1   sizeof(struct rfkill_event)
>
>  /* ioctl for turning off rfkill-input (if present) */
>  #define RFKILL_IOC_MAGIC       'R'
> diff --git a/net/rfkill/core.c b/net/rfkill/core.c
> index 68d6ef9e59fc..ac15a944573f 100644
> --- a/net/rfkill/core.c
> +++ b/net/rfkill/core.c
> @@ -69,7 +69,7 @@ struct rfkill {
>
>  struct rfkill_int_event {
>         struct list_head        list;
> -       struct rfkill_event     ev;
> +       struct rfkill_event_ext ev;
>  };
>
>  struct rfkill_data {
> @@ -253,7 +253,8 @@ static void rfkill_global_led_trigger_unregister(void)
>  }
>  #endif /* CONFIG_RFKILL_LEDS */
>
> -static void rfkill_fill_event(struct rfkill_event *ev, struct rfkill *rfkill,
> +static void rfkill_fill_event(struct rfkill_event_ext *ev,
> +                             struct rfkill *rfkill,
>                               enum rfkill_operation op)
>  {
>         unsigned long flags;
> @@ -1237,7 +1238,7 @@ static ssize_t rfkill_fop_write(struct file *file, const char __user *buf,
>                                 size_t count, loff_t *pos)
>  {
>         struct rfkill *rfkill;
> -       struct rfkill_event ev;
> +       struct rfkill_event_ext ev;
>         int ret;
>
>         /* we don't need the 'hard' variable but accept it */
> --
> 2.30.2
>
