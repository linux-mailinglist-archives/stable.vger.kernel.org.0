Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9BD8150A28F
	for <lists+stable@lfdr.de>; Thu, 21 Apr 2022 16:33:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1385664AbiDUOfN convert rfc822-to-8bit (ORCPT
        <rfc822;lists+stable@lfdr.de>); Thu, 21 Apr 2022 10:35:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42570 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1381577AbiDUOfM (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 21 Apr 2022 10:35:12 -0400
Received: from mail-yw1-f173.google.com (mail-yw1-f173.google.com [209.85.128.173])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A57933E5F8;
        Thu, 21 Apr 2022 07:32:22 -0700 (PDT)
Received: by mail-yw1-f173.google.com with SMTP id 00721157ae682-2ec04a2ebadso53909057b3.12;
        Thu, 21 Apr 2022 07:32:22 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=zLYXNeE3TuA/2tAV1QeSt3PrPzeHIxzHNtRO5UdYfuw=;
        b=a4SI0pQgZczTBgavsCOblyY/8wLXiM5Lqzp7u3OQ47/RkDjmEYx/SQaQRzr/LQk2cX
         iPVvvS4NnCOG8H9jmZQ3G+0w3zq6QmAHPFgCUFS6FcrXUrGqK+PikvHeW8pti2UZN0NU
         v91HoYqEZPpSZMbDJyoOE6QLr/mAzPv2Qx8KYjAdeqMafxOK6oRR+4EpJWyMUm2AkXlc
         EfG1QYINHn3AkB21R4mnRV/l0DQ43xGx7IH/c4SsW5/ZXbIWO6kD69lohHFUs3WCtb0Q
         hw1ytk1aeUTvUdsUZshrLNGYRXwwnQD1qJYqbSDE0WylL6PZ6nyez9blccM0fD/98KQK
         T2DQ==
X-Gm-Message-State: AOAM531EYqEMSZpu5gK/wE3GjMKkgAcdvGpL6bMRTnfylhWASI4e6hWi
        w+iFhThlHt74luO6gyQ7gVQyY9AC2Qu6uK0sO+k=
X-Google-Smtp-Source: ABdhPJzKRVVgSxGlmLKR/2iTzFQqLeY9rH/zcvXdYf6vc/O7+9Dtqr/swUDcXlQtdIpI1SZ8syFE/sB1oK26VdyIM+s=
X-Received: by 2002:a81:1096:0:b0:2ec:4a46:7e5a with SMTP id
 144-20020a811096000000b002ec4a467e5amr26831849ywq.196.1650551541903; Thu, 21
 Apr 2022 07:32:21 -0700 (PDT)
MIME-Version: 1.0
References: <20220420134417.24546-1-ville.syrjala@linux.intel.com> <20220421133634.19489-1-ville.syrjala@linux.intel.com>
In-Reply-To: <20220421133634.19489-1-ville.syrjala@linux.intel.com>
From:   "Rafael J. Wysocki" <rafael@kernel.org>
Date:   Thu, 21 Apr 2022 16:32:10 +0200
Message-ID: <CAJZ5v0jnebMxHZE0Y8KYstoych8MwaecGzk3SGeoTNzaEu6gog@mail.gmail.com>
Subject: Re: [PATCH v2 1/2] ACPI: processor: Do not use C3 w/o ARB_DIS=1
To:     Ville Syrjala <ville.syrjala@linux.intel.com>
Cc:     ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        Len Brown <lenb@kernel.org>, Stable <stable@vger.kernel.org>,
        Woody Suwalski <wsuwalski@gmail.com>,
        Mario Limonciello <mario.limonciello@amd.com>,
        Richard Gong <richard.gong@amd.com>,
        "Rafael J . Wysocki" <rafael.j.wysocki@intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Spam-Status: No, score=-1.4 required=5.0 tests=BAYES_00,
        FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Apr 21, 2022 at 3:36 PM Ville Syrjala
<ville.syrjala@linux.intel.com> wrote:
>
> From: Ville Syrjälä <ville.syrjala@linux.intel.com>

Thanks for the updating!

I'm going to apply this for 5.18-rc along with the [2/2].

However, I'm going to change the subject of this patch to "ACPI:
processor: idle: Avoid falling back to C3 type C-states".

> commit d6b88ce2eb9d ("ACPI: processor idle: Allow playing dead in C3 state")
> was supposedly just trying to enable C3 when the CPU is offlined,
> but it also mistakenly enabled C3 usage without setting ARB_DIS=1
> in normal idle scenarios.

And I'm going to replace the above paragraph in the changelog with:

"The "safe state" index is used by acpi_idle_enter_bm() to avoid
entering a C-state that may require bus mastering to be disabled
on entry in the cases when this is not going to happen.  For this
reason, it should not be set to point to C3 type of C-states, because
they may require bus mastering to be disabled on entry in principle.

This was broken by commit d6b88ce2eb9d ("ACPI: processor idle: Allow
playing dead in C3 state") which inadvertently allowed the "safe
state" index to point to C3 type of C-states."

> This results in a machine that won't boot past the point when it first
> enters C3. Restore the correct behaviour (either demote to C1/C2, or
> use C3 but also set ARB_DIS=1).
>
> I hit this on a Fujitsu Siemens Lifebook S6010 (P3) machine.
>
> Cc: stable@vger.kernel.org
> Cc: Woody Suwalski <wsuwalski@gmail.com>
> Cc: Mario Limonciello <mario.limonciello@amd.com>
> Cc: Richard Gong <richard.gong@amd.com>
> Cc: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
> Fixes: d6b88ce2eb9d ("ACPI: processor idle: Allow playing dead in C3 state")
> Signed-off-by: Ville Syrjälä <ville.syrjala@linux.intel.com>
> ---
> v2: Paint it in a different color (Rafael)
>
>  drivers/acpi/processor_idle.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
>
> diff --git a/drivers/acpi/processor_idle.c b/drivers/acpi/processor_idle.c
> index 4556c86c3465..5f296e099bce 100644
> --- a/drivers/acpi/processor_idle.c
> +++ b/drivers/acpi/processor_idle.c
> @@ -795,7 +795,8 @@ static int acpi_processor_setup_cstates(struct acpi_processor *pr)
>                 if (cx->type == ACPI_STATE_C1 || cx->type == ACPI_STATE_C2 ||
>                     cx->type == ACPI_STATE_C3) {
>                         state->enter_dead = acpi_idle_play_dead;
> -                       drv->safe_state_index = count;
> +                       if (cx->type != ACPI_STATE_C3)
> +                               drv->safe_state_index = count;
>                 }
>                 /*
>                  * Halt-induced C1 is not good for ->enter_s2idle, because it
> --
> 2.35.1
>
