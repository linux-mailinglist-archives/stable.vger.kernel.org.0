Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9BFB7F67E6
	for <lists+stable@lfdr.de>; Sun, 10 Nov 2019 08:35:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726586AbfKJHfz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 10 Nov 2019 02:35:55 -0500
Received: from mail-wr1-f65.google.com ([209.85.221.65]:37579 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726657AbfKJHfy (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 10 Nov 2019 02:35:54 -0500
Received: by mail-wr1-f65.google.com with SMTP id t1so11339127wrv.4
        for <stable@vger.kernel.org>; Sat, 09 Nov 2019 23:35:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=XJTH1KK/naYx6O+S+TJH7JFLCWqs9kvcJkAi9iiE7mQ=;
        b=WN0TTkPN/msw1pSWCaDffkuNmFsHNGFksr04Fkts7exvy7/7kIXBDTItdg/namAfL6
         GduualXjDtCOX8WuNhObtQHbUVxIuuiYN9gsLHXIYhCQuRK/ZYgNEhIgvE0rGtmv1EAX
         zB2DiEsPO+AfAapanIL2QCdVCm5FpZQrMF0SRHuw0rHRvirfcwFf//VgRLpwX3blmdhN
         hHDNqYFTdD3xDkIztGFHCXo4T7fza1XdDxxPNtXTioF91/lWIGekE14Z9ik7gkONiLVS
         YomQXyuwhl+96BMAmHJsD2MaLqpgrInwhvr3ldsptY10tNSQyFRsB3h+mY+p6cfx0TJI
         AAWg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=XJTH1KK/naYx6O+S+TJH7JFLCWqs9kvcJkAi9iiE7mQ=;
        b=LYCmVoehSaXxtpVr5TA4cOkhbEKibwYjB/wvAiP3Z+jYrmHOPcl+Ccx+R3GaY0KO1z
         xoeb59BsLS1XKTgL0lrn4+fXnWwl5sZx8l9qs8rRC1perbJiCUv5xNharElEtirqPXKq
         UfUpRrrgdTS23RQU8uxwaXrMrwm3YEdn5B7OU3oifcBEj3Xsnt9lPFryWb4mr0Wxweuh
         n0YlU7T8nPxYiTWoVpX6UuS1gPuStnIiGnBzAAK2Y0X7uYwv+kDL+YCC/U3sE+FqDjfv
         8yNSC09kQ9dWxdjo9tuWwGy9hRHa8d1odbWSKpDD3x4t4tAlg88PKtrq6lqkOMZXSY+7
         SVIA==
X-Gm-Message-State: APjAAAU1N+vNNZ8WVbumjDvmMM3f434xgVpYTDkg5DYhqh/Pag4v58Sy
        gW7oHLj4J8dbplntFfeFPTROtq2CGRlsKxGrFXnUxxy9Hpo=
X-Google-Smtp-Source: APXvYqxrmw9WeHe5/66Iv6MH3EPvGSKsEKVjfxFR796TEzo2lH9NH1Ji91Ndk+VEdZTc34Qb1Ik4h7GPGvLReLCKjcs=
X-Received: by 2002:adf:f743:: with SMTP id z3mr15059320wrp.200.1573371351763;
 Sat, 09 Nov 2019 23:35:51 -0800 (PST)
MIME-Version: 1.0
References: <20191110024013.29782-1-sashal@kernel.org> <20191110024013.29782-134-sashal@kernel.org>
In-Reply-To: <20191110024013.29782-134-sashal@kernel.org>
From:   Ard Biesheuvel <ard.biesheuvel@linaro.org>
Date:   Sun, 10 Nov 2019 08:35:40 +0100
Message-ID: <CAKv+Gu-Ej9sjNpr4Xwhfy1d__mWbGXn6e7Q0YMQ5JT2SeDLPAQ@mail.gmail.com>
Subject: Re: [PATCH AUTOSEL 4.19 134/191] efi: Make efi_rts_work accessible to
 efi page fault handler
To:     Sasha Levin <sashal@kernel.org>
Cc:     Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        stable <stable@vger.kernel.org>,
        Sai Praneeth <sai.praneeth.prakhya@intel.com>,
        Bhupesh Sharma <bhsharma@redhat.com>,
        Matt Fleming <matt@codeblueprint.co.uk>,
        linux-efi <linux-efi@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sun, 10 Nov 2019 at 03:44, Sasha Levin <sashal@kernel.org> wrote:
>
> From: Sai Praneeth <sai.praneeth.prakhya@intel.com>
>
> [ Upstream commit 9dbbedaa6171247c4c7c40b83f05b200a117c2e0 ]
>
> After the kernel has booted, if any accesses by firmware causes a page
> fault, the efi page fault handler would freeze efi_rts_wq and schedules
> a new process. To do this, the efi page fault handler needs
> efi_rts_work. Hence, make it accessible.
>
> There will be no race conditions in accessing this structure, because
> all the calls to efi runtime services are already serialized.
>
> Tested-by: Bhupesh Sharma <bhsharma@redhat.com>
> Suggested-by: Matt Fleming <matt@codeblueprint.co.uk>
> Based-on-code-from: Ricardo Neri <ricardo.neri@intel.com>
> Signed-off-by: Sai Praneeth Prakhya <sai.praneeth.prakhya@intel.com>
> Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
> Signed-off-by: Sasha Levin <sashal@kernel.org>

NAK

Would it be possible to disregard all EFI patches for -stable unless
they have a fixes tag? EFI subtly depends on lots of firmware quirks
across various architectures, and so grabbing random patches and
backporting them is really not a good idea in general.

> ---
>  drivers/firmware/efi/runtime-wrappers.c | 53 +++++--------------------
>  include/linux/efi.h                     | 36 +++++++++++++++++
>  2 files changed, 45 insertions(+), 44 deletions(-)
>
> diff --git a/drivers/firmware/efi/runtime-wrappers.c b/drivers/firmware/efi/runtime-wrappers.c
> index 1606abead22cc..b31e3d3729a6d 100644
> --- a/drivers/firmware/efi/runtime-wrappers.c
> +++ b/drivers/firmware/efi/runtime-wrappers.c
> @@ -45,39 +45,7 @@
>  #define __efi_call_virt(f, args...) \
>         __efi_call_virt_pointer(efi.systab->runtime, f, args)
>
> -/* efi_runtime_service() function identifiers */
> -enum efi_rts_ids {
> -       GET_TIME,
> -       SET_TIME,
> -       GET_WAKEUP_TIME,
> -       SET_WAKEUP_TIME,
> -       GET_VARIABLE,
> -       GET_NEXT_VARIABLE,
> -       SET_VARIABLE,
> -       QUERY_VARIABLE_INFO,
> -       GET_NEXT_HIGH_MONO_COUNT,
> -       UPDATE_CAPSULE,
> -       QUERY_CAPSULE_CAPS,
> -};
> -
> -/*
> - * efi_runtime_work:   Details of EFI Runtime Service work
> - * @arg<1-5>:          EFI Runtime Service function arguments
> - * @status:            Status of executing EFI Runtime Service
> - * @efi_rts_id:                EFI Runtime Service function identifier
> - * @efi_rts_comp:      Struct used for handling completions
> - */
> -struct efi_runtime_work {
> -       void *arg1;
> -       void *arg2;
> -       void *arg3;
> -       void *arg4;
> -       void *arg5;
> -       efi_status_t status;
> -       struct work_struct work;
> -       enum efi_rts_ids efi_rts_id;
> -       struct completion efi_rts_comp;
> -};
> +struct efi_runtime_work efi_rts_work;
>
>  /*
>   * efi_queue_work:     Queue efi_runtime_service() and wait until it's done
> @@ -91,7 +59,6 @@ struct efi_runtime_work {
>   */
>  #define efi_queue_work(_rts, _arg1, _arg2, _arg3, _arg4, _arg5)                \
>  ({                                                                     \
> -       struct efi_runtime_work efi_rts_work;                           \
>         efi_rts_work.status = EFI_ABORTED;                              \
>                                                                         \
>         init_completion(&efi_rts_work.efi_rts_comp);                    \
> @@ -191,18 +158,16 @@ extern struct semaphore __efi_uv_runtime_lock __alias(efi_runtime_lock);
>   */
>  static void efi_call_rts(struct work_struct *work)
>  {
> -       struct efi_runtime_work *efi_rts_work;
>         void *arg1, *arg2, *arg3, *arg4, *arg5;
>         efi_status_t status = EFI_NOT_FOUND;
>
> -       efi_rts_work = container_of(work, struct efi_runtime_work, work);
> -       arg1 = efi_rts_work->arg1;
> -       arg2 = efi_rts_work->arg2;
> -       arg3 = efi_rts_work->arg3;
> -       arg4 = efi_rts_work->arg4;
> -       arg5 = efi_rts_work->arg5;
> +       arg1 = efi_rts_work.arg1;
> +       arg2 = efi_rts_work.arg2;
> +       arg3 = efi_rts_work.arg3;
> +       arg4 = efi_rts_work.arg4;
> +       arg5 = efi_rts_work.arg5;
>
> -       switch (efi_rts_work->efi_rts_id) {
> +       switch (efi_rts_work.efi_rts_id) {
>         case GET_TIME:
>                 status = efi_call_virt(get_time, (efi_time_t *)arg1,
>                                        (efi_time_cap_t *)arg2);
> @@ -260,8 +225,8 @@ static void efi_call_rts(struct work_struct *work)
>                  */
>                 pr_err("Requested executing invalid EFI Runtime Service.\n");
>         }
> -       efi_rts_work->status = status;
> -       complete(&efi_rts_work->efi_rts_comp);
> +       efi_rts_work.status = status;
> +       complete(&efi_rts_work.efi_rts_comp);
>  }
>
>  static efi_status_t virt_efi_get_time(efi_time_t *tm, efi_time_cap_t *tc)
> diff --git a/include/linux/efi.h b/include/linux/efi.h
> index f43fc61fbe2c9..9d4c25090fd04 100644
> --- a/include/linux/efi.h
> +++ b/include/linux/efi.h
> @@ -1666,6 +1666,42 @@ struct linux_efi_tpm_eventlog {
>
>  extern int efi_tpm_eventlog_init(void);
>
> +/* efi_runtime_service() function identifiers */
> +enum efi_rts_ids {
> +       GET_TIME,
> +       SET_TIME,
> +       GET_WAKEUP_TIME,
> +       SET_WAKEUP_TIME,
> +       GET_VARIABLE,
> +       GET_NEXT_VARIABLE,
> +       SET_VARIABLE,
> +       QUERY_VARIABLE_INFO,
> +       GET_NEXT_HIGH_MONO_COUNT,
> +       UPDATE_CAPSULE,
> +       QUERY_CAPSULE_CAPS,
> +};
> +
> +/*
> + * efi_runtime_work:   Details of EFI Runtime Service work
> + * @arg<1-5>:          EFI Runtime Service function arguments
> + * @status:            Status of executing EFI Runtime Service
> + * @efi_rts_id:                EFI Runtime Service function identifier
> + * @efi_rts_comp:      Struct used for handling completions
> + */
> +struct efi_runtime_work {
> +       void *arg1;
> +       void *arg2;
> +       void *arg3;
> +       void *arg4;
> +       void *arg5;
> +       efi_status_t status;
> +       struct work_struct work;
> +       enum efi_rts_ids efi_rts_id;
> +       struct completion efi_rts_comp;
> +};
> +
> +extern struct efi_runtime_work efi_rts_work;
> +
>  /* Workqueue to queue EFI Runtime Services */
>  extern struct workqueue_struct *efi_rts_wq;
>
> --
> 2.20.1
>
