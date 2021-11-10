Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 751DE44C439
	for <lists+stable@lfdr.de>; Wed, 10 Nov 2021 16:19:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232411AbhKJPV5 convert rfc822-to-8bit (ORCPT
        <rfc822;lists+stable@lfdr.de>); Wed, 10 Nov 2021 10:21:57 -0500
Received: from mail-oo1-f48.google.com ([209.85.161.48]:33445 "EHLO
        mail-oo1-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232406AbhKJPVt (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 10 Nov 2021 10:21:49 -0500
Received: by mail-oo1-f48.google.com with SMTP id q39-20020a4a962a000000b002b8bb100791so906262ooi.0;
        Wed, 10 Nov 2021 07:19:01 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=Gn4NXulRfPuVM6KUv95m+3nADi6hotMYCA1rfCDNUYU=;
        b=Tgg0OOUSATaZ9S/vBRNQ9QduR9tY7ZqKYvMNXUoVaew3kZfCO3WHbn/7QSNTZqlwOJ
         Vtl/qQksxxhanLhQqQyKGGEDweS7LaKH/hv5AV2kfGIoWjo2cvCdLLy58b71FEutqCit
         ILPZ8sfvWinBjNbvRZnA3Fnp9z5HiDAsSzROVdZCrNYquy3jzDTruSV36qZAOGLgjVDj
         4PxXN9SAuffyqk4Vt3BMlIy+zYobFQHw82ANP11RLlX9UWgAFloTQiG332pfPJjENb0E
         wtKbukkfCzRtEbJ7Uo4vs1uC3z34xU5Lgb3+/qMz0H0Q1rb3OrP+OfNHn/QoKNV5A9mw
         Nzbw==
X-Gm-Message-State: AOAM5327z9Zg1qaBfP+sLrmuQuso3gsTw7VNA4Ohfr9luVFZHiRU4s0l
        8NseVgm4zWRY1OxslC9Ge/gadpczkEvBqJBHgyUm9URLj5k=
X-Google-Smtp-Source: ABdhPJxEoDknBuyxRYbB8eHBw8gzAsCfZbuy4YPeQ8DvlEGEZWVpK1ilNlBT5BrZN69YTfeATsp39ve5q/88cBFJAmI=
X-Received: by 2002:a4a:ab04:: with SMTP id i4mr321251oon.91.1636557528836;
 Wed, 10 Nov 2021 07:18:48 -0800 (PST)
MIME-Version: 1.0
References: <20211109010918.1192063-1-sashal@kernel.org> <20211109010918.1192063-15-sashal@kernel.org>
 <BYAPR11MB3256001FA32D50DE6F56425087939@BYAPR11MB3256.namprd11.prod.outlook.com>
In-Reply-To: <BYAPR11MB3256001FA32D50DE6F56425087939@BYAPR11MB3256.namprd11.prod.outlook.com>
From:   "Rafael J. Wysocki" <rafael@kernel.org>
Date:   Wed, 10 Nov 2021 16:18:37 +0100
Message-ID: <CAJZ5v0gwW=5CNObEi3SpXLhaA8oeP4VYfkWoQv9iDjwQLxE_yA@mail.gmail.com>
Subject: Re: [PATCH AUTOSEL 4.4 15/30] ACPICA: Avoid evaluating methods too
 early during system resume
To:     "Moore, Robert" <robert.moore@intel.com>
Cc:     Sasha Levin <sashal@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        "Wysocki, Rafael J" <rafael.j.wysocki@intel.com>,
        Reik Keutterling <spielkind@gmail.com>,
        "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>,
        "devel@acpica.org" <devel@acpica.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Bob,

This is the Linux version of ACPICA commit
0762982923f95eb652cf7ded27356b247c9774de and now it has been
automatically selected for backporting into the "stable" kernel
versions.

On Wed, Nov 10, 2021 at 4:10 PM Moore, Robert <robert.moore@intel.com> wrote:
>
> Sasha,
> Can you re-do this patch in native ACPICA format, then add a pull request to our github?
>
> Thanks,
> Bob
>
>
> -----Original Message-----
> From: Sasha Levin <sashal@kernel.org>
> Sent: Monday, November 08, 2021 5:09 PM
> To: linux-kernel@vger.kernel.org; stable@vger.kernel.org
> Cc: Wysocki, Rafael J <rafael.j.wysocki@intel.com>; Reik Keutterling <spielkind@gmail.com>; Sasha Levin <sashal@kernel.org>; Moore, Robert <robert.moore@intel.com>; linux-acpi@vger.kernel.org; devel@acpica.org
> Subject: [PATCH AUTOSEL 4.4 15/30] ACPICA: Avoid evaluating methods too early during system resume
>
> From: "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>
>
> [ Upstream commit d3c4b6f64ad356c0d9ddbcf73fa471e6a841cc5c ]
>
> ACPICA commit 0762982923f95eb652cf7ded27356b247c9774de
>
> During wakeup from system-wide sleep states, acpi_get_sleep_type_data() is called and it tries to get memory from the slab allocator in order to evaluate a control method, but if KFENCE is enabled in the kernel, the memory allocation attempt causes an IRQ work to be queued and a self-IPI to be sent to the CPU running the code which requires the memory controller to be ready, so if that happens too early in the wakeup path, it doesn't work.
>
> Prevent that from taking place by calling acpi_get_sleep_type_data() for S0 upfront, when preparing to enter a given sleep state, and saving the data obtained by it for later use during system wakeup.
>
> BugLink: https://bugzilla.kernel.org/show_bug.cgi?id=214271
> Reported-by: Reik Keutterling <spielkind@gmail.com>
> Tested-by: Reik Keutterling <spielkind@gmail.com>
> Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
> Signed-off-by: Sasha Levin <sashal@kernel.org>
> ---
>  drivers/acpi/acpica/acglobal.h  |  2 ++  drivers/acpi/acpica/hwesleep.c  |  8 ++------
>  drivers/acpi/acpica/hwsleep.c   | 11 ++++-------
>  drivers/acpi/acpica/hwxfsleep.c |  7 +++++++
>  4 files changed, 15 insertions(+), 13 deletions(-)
>
> diff --git a/drivers/acpi/acpica/acglobal.h b/drivers/acpi/acpica/acglobal.h index faa97604d878e..f178d11597c09 100644
> --- a/drivers/acpi/acpica/acglobal.h
> +++ b/drivers/acpi/acpica/acglobal.h
> @@ -256,6 +256,8 @@ extern struct acpi_bit_register_info
>
>  ACPI_GLOBAL(u8, acpi_gbl_sleep_type_a);  ACPI_GLOBAL(u8, acpi_gbl_sleep_type_b);
> +ACPI_GLOBAL(u8, acpi_gbl_sleep_type_a_s0); ACPI_GLOBAL(u8,
> +acpi_gbl_sleep_type_b_s0);
>
>  /*****************************************************************************
>   *
> diff --git a/drivers/acpi/acpica/hwesleep.c b/drivers/acpi/acpica/hwesleep.c index e5599f6108083..e4998cc0ce283 100644
> --- a/drivers/acpi/acpica/hwesleep.c
> +++ b/drivers/acpi/acpica/hwesleep.c
> @@ -184,17 +184,13 @@ acpi_status acpi_hw_extended_sleep(u8 sleep_state)
>
>  acpi_status acpi_hw_extended_wake_prep(u8 sleep_state)  {
> -       acpi_status status;
>         u8 sleep_type_value;
>
>         ACPI_FUNCTION_TRACE(hw_extended_wake_prep);
>
> -       status = acpi_get_sleep_type_data(ACPI_STATE_S0,
> -                                         &acpi_gbl_sleep_type_a,
> -                                         &acpi_gbl_sleep_type_b);
> -       if (ACPI_SUCCESS(status)) {
> +       if (acpi_gbl_sleep_type_a_s0 != ACPI_SLEEP_TYPE_INVALID) {
>                 sleep_type_value =
> -                   ((acpi_gbl_sleep_type_a << ACPI_X_SLEEP_TYPE_POSITION) &
> +                   ((acpi_gbl_sleep_type_a_s0 << ACPI_X_SLEEP_TYPE_POSITION) &
>                      ACPI_X_SLEEP_TYPE_MASK);
>
>                 (void)acpi_write((u64)(sleep_type_value | ACPI_X_SLEEP_ENABLE), diff --git a/drivers/acpi/acpica/hwsleep.c b/drivers/acpi/acpica/hwsleep.c index 7d21cae6d6028..7e44ba8c6a1ab 100644
> --- a/drivers/acpi/acpica/hwsleep.c
> +++ b/drivers/acpi/acpica/hwsleep.c
> @@ -217,7 +217,7 @@ acpi_status acpi_hw_legacy_sleep(u8 sleep_state)
>
>  acpi_status acpi_hw_legacy_wake_prep(u8 sleep_state)  {
> -       acpi_status status;
> +       acpi_status status = AE_OK;
>         struct acpi_bit_register_info *sleep_type_reg_info;
>         struct acpi_bit_register_info *sleep_enable_reg_info;
>         u32 pm1a_control;
> @@ -230,10 +230,7 @@ acpi_status acpi_hw_legacy_wake_prep(u8 sleep_state)
>          * This is unclear from the ACPI Spec, but it is required
>          * by some machines.
>          */
> -       status = acpi_get_sleep_type_data(ACPI_STATE_S0,
> -                                         &acpi_gbl_sleep_type_a,
> -                                         &acpi_gbl_sleep_type_b);
> -       if (ACPI_SUCCESS(status)) {
> +       if (acpi_gbl_sleep_type_a_s0 != ACPI_SLEEP_TYPE_INVALID) {
>                 sleep_type_reg_info =
>                     acpi_hw_get_bit_register_info(ACPI_BITREG_SLEEP_TYPE);
>                 sleep_enable_reg_info =
> @@ -254,9 +251,9 @@ acpi_status acpi_hw_legacy_wake_prep(u8 sleep_state)
>
>                         /* Insert the SLP_TYP bits */
>
> -                       pm1a_control |= (acpi_gbl_sleep_type_a <<
> +                       pm1a_control |= (acpi_gbl_sleep_type_a_s0 <<
>                                          sleep_type_reg_info->bit_position);
> -                       pm1b_control |= (acpi_gbl_sleep_type_b <<
> +                       pm1b_control |= (acpi_gbl_sleep_type_b_s0 <<
>                                          sleep_type_reg_info->bit_position);
>
>                         /* Write the control registers and ignore any errors */ diff --git a/drivers/acpi/acpica/hwxfsleep.c b/drivers/acpi/acpica/hwxfsleep.c index d62a61612b3f1..b04e2b0f62246 100644
> --- a/drivers/acpi/acpica/hwxfsleep.c
> +++ b/drivers/acpi/acpica/hwxfsleep.c
> @@ -372,6 +372,13 @@ acpi_status acpi_enter_sleep_state_prep(u8 sleep_state)
>                 return_ACPI_STATUS(status);
>         }
>
> +       status = acpi_get_sleep_type_data(ACPI_STATE_S0,
> +                                         &acpi_gbl_sleep_type_a_s0,
> +                                         &acpi_gbl_sleep_type_b_s0);
> +       if (ACPI_FAILURE(status)) {
> +               acpi_gbl_sleep_type_a_s0 = ACPI_SLEEP_TYPE_INVALID;
> +       }
> +
>         /* Execute the _PTS method (Prepare To Sleep) */
>
>         arg_list.count = 1;
> --
> 2.33.0
>
