Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5244F43D165
	for <lists+stable@lfdr.de>; Wed, 27 Oct 2021 21:06:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237182AbhJ0TJH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 27 Oct 2021 15:09:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51778 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237149AbhJ0TJG (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 27 Oct 2021 15:09:06 -0400
Received: from mail-qk1-x733.google.com (mail-qk1-x733.google.com [IPv6:2607:f8b0:4864:20::733])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F3BADC061570;
        Wed, 27 Oct 2021 12:06:40 -0700 (PDT)
Received: by mail-qk1-x733.google.com with SMTP id h20so3422915qko.13;
        Wed, 27 Oct 2021 12:06:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=5F5VdF34gZTh/RNT/t5KynaiA+RHIPB8PfM2MmmqZu0=;
        b=jXx+RbBRW63Pv8AeoMt67PxUyJ1nS4n7GtqHPnpsLoM7qrdqpjr0HmrtaC1dcnbA34
         2VH9fe5bntANGIG1uv+2cFh98hCS/EaI7VfGEd92nG75AolmJj1vYuGmuQ9AaKpHr2KQ
         fQ7by7YMNCnvErGbIS/0tQVCUL4brRElM0xUAweWwERkDX20/kNZAxOFrK7jLNXb/tnP
         DARtH9+b46xdX9zhGENIY6XezY2hRB7RNvmmojQQbw/q6rsYTByqSJAZdYycRm3OSKkH
         dt9M/2Ykp1jc45FuaDVGak6QbJUa+gB6VTN29FqzyU08GpOKqldZcqaKUkoolftN+852
         EsaQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=5F5VdF34gZTh/RNT/t5KynaiA+RHIPB8PfM2MmmqZu0=;
        b=AymXY0ur6QtMRvSx9IRvLt7QxTsZAhTqjqTxUW6HIoK/3dfIfqRAWc4kIY6Xwy0ySu
         pb/ur+EnplUoXNjtQ6lRYWxQSiZbT/GSk4X0ltgd+7gkzTHipH/FT0D1ASU7Q9/aDwKZ
         syLwZwLdQgO06N735tNcd/pkThw+8zSacx4TPZHude6Umvo3kQGGnENWF3K1fPqPQtRO
         TcW/ZUdMvXdjA32OmfP90LMu3OwAwv8lvjSVo539KuPBKA+Z07XZZ7dGFOfpLttwMoUX
         iJi3AWpTLWsTcJPlBnPLirMZAaXCveQAvqfOnZ/tK9etehdP1vvs2RrE0Yj+0o7ycEOm
         DmWA==
X-Gm-Message-State: AOAM530A1mUsyWBBKUnp/0Xpe5bQ67Y2lyNuK4H63zWZxea1t8Eb8w3e
        yq78fW0takNNfG21w/0vNDqzEnFxeSlzpOD7UEU=
X-Google-Smtp-Source: ABdhPJyw6DY4hTH+YrF1Hs2qj3oDxq5vBGx3PxRj9G1dkHrUuZOo+4axgv+VGFyiKj1AXqNneAEcuqcaghJBUbFls+E=
X-Received: by 2002:a05:620a:889:: with SMTP id b9mr585742qka.229.1635361600059;
 Wed, 27 Oct 2021 12:06:40 -0700 (PDT)
MIME-Version: 1.0
References: <20211022232837.18988-1-ping.cheng@wacom.com>
In-Reply-To: <20211022232837.18988-1-ping.cheng@wacom.com>
From:   Ping Cheng <pinglinux@gmail.com>
Date:   Wed, 27 Oct 2021 12:06:28 -0700
Message-ID: <CAF8JNhJKcB4n98SgD9Q-ETeF_465k7bqgijt+vDBLh5AqMWGrQ@mail.gmail.com>
Subject: Re: [PATCH] HID: input: fix the incorrectly reported
 BTN_TOOL_RUBBER/PEN tools
To:     jikos@kernel.org, Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Benjamin Tissoires <benjamin.tissoires@gmail.com>
Cc:     linux-input@vger.kernel.org, stable@vger.kernel.org,
        Jason Gerecke <killertofu@gmail.com>,
        Tatsunosuke Tobita <junkpainting@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi @Dmitry Torokhov and @Benjamin Tissoires,

Do you have any comments about this patch? The issue and the logic
behind the fix has been explained in the commit comment and in the
code. Jiri is probably waiting for an acknowledgment from one of
you...

Thank you,
Ping

On Fri, Oct 22, 2021 at 4:29 PM Ping Cheng <pinglinux@gmail.com> wrote:
>
> The HID_QUIRK_INVERT caused BTN_TOOL_RUBBER events were reported at the
> same time as events for BTN_TOOL_PEN/PENCIL/etc, if HID_QUIRK_INVERT
> was set by a stylus' sideswitch. The reality is that a pen can only be
> a stylus (writing/drawing) or an eraser, but not both at the same time.
> This patch makes that logic correct.
>
> CC: stable@vger.kernel.org # 2.4+
> Signed-off-by: Ping Cheng <ping.cheng@wacom.com>
> Reviewed-by: Jason Gerecke <killertofu@gmail.com>
> Tested-by: Tatsunosuke Tobita <junkpainting@gmail.com>
> ---
>  drivers/hid/hid-input.c | 24 ++++++++++++++++++++----
>  1 file changed, 20 insertions(+), 4 deletions(-)
>
> diff --git a/drivers/hid/hid-input.c b/drivers/hid/hid-input.c
> index 4b5ebeacd283..85741a2d828d 100644
> --- a/drivers/hid/hid-input.c
> +++ b/drivers/hid/hid-input.c
> @@ -1344,12 +1344,28 @@ void hidinput_hid_event(struct hid_device *hid, struct hid_field *field, struct
>         }
>
>         if (usage->hid == HID_DG_INRANGE) {
> +               /* when HID_QUIRK_INVERT is set by a stylus sideswitch, HID_DG_INRANGE could be
> +                * for stylus or eraser. Make sure events are only posted to the current valid tool:
> +                * BTN_TOOL_RUBBER vs BTN_TOOL_PEN/BTN_TOOL_PENCIL/BTN_TOOL_BRUSH/etc since a pen
> +                * can not be used as a stylus (to draw/write) and an erasaer at the same time
> +                */
> +               static unsigned int last_code = 0;
> +               unsigned int code = (*quirks & HID_QUIRK_INVERT) ? BTN_TOOL_RUBBER : usage->code;
>                 if (value) {
> -                       input_event(input, usage->type, (*quirks & HID_QUIRK_INVERT) ? BTN_TOOL_RUBBER : usage->code, 1);
> -                       return;
> +                       if (code != last_code) {
> +                               /* send the last tool out before allow the new one in */
> +                               if (last_code)
> +                                       input_event(input, usage->type, last_code, 0);
> +                               input_event(input, usage->type, code, 1);
> +                       }
> +                       last_code = code;
> +               } else {
> +                       /* only send the last valid tool out */
> +                       if (last_code)
> +                               input_event(input, usage->type, last_code, 0);
> +                       /* reset tool for next cycle */
> +                       last_code = 0;
>                 }
> -               input_event(input, usage->type, usage->code, 0);
> -               input_event(input, usage->type, BTN_TOOL_RUBBER, 0);
>                 return;
>         }
>
> --
> 2.25.1
>
