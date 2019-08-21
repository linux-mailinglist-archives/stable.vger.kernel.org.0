Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 31AF3984B6
	for <lists+stable@lfdr.de>; Wed, 21 Aug 2019 21:46:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729973AbfHUTqc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 21 Aug 2019 15:46:32 -0400
Received: from mail-io1-f67.google.com ([209.85.166.67]:35458 "EHLO
        mail-io1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729693AbfHUTqc (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 21 Aug 2019 15:46:32 -0400
Received: by mail-io1-f67.google.com with SMTP id i22so7093437ioh.2
        for <stable@vger.kernel.org>; Wed, 21 Aug 2019 12:46:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=nmacleod-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=IrhyO1xAriI0x3SJAPuRls7zHHEanwvviwP/gURxosE=;
        b=GfievykSxX+taJCq1ixH6D5IHrMNPeTe/QbjmzP7QeVJIH9gbDkspPIUiYXaLDSXuQ
         D9Kw6/wSIaF991TN63nLsO1t3QOgCAKx4NXqsIg86EFphb//xiOleNSubdDU4GAMhmyF
         b2LyCQATPIc0ixkEiFX7vyOGNhLyOExGYtO6v7/xegsISI8+FcQNJy0ikef45qa6thda
         nXzCqa56JDBqawJx0eQJItSV39MDW+eCYp8XCsq8IQq5lXFzHab6Gh5UFWWIhGWiLJFW
         7Cxklx2mDhT1qLB+yzrfF69DVW9QZSDIFtRaVUeM7QIOe7CAHif+58LdXjUwruhbD6ma
         WE+Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=IrhyO1xAriI0x3SJAPuRls7zHHEanwvviwP/gURxosE=;
        b=R3kTWtKqQ0gvpDLSDU7FweL3HqKwR/CrdOZPVJeyawmFIkxMeHGWMbefcsgVrYxoHa
         1VlN+JojS5gPjyOH8/92KBWH142MAk8K40Hf26hfobbJsI+f7OO8nHsgSFWaRilScDba
         AWnZ1q+/InBqsaO+2zzLgWuwfOTtL+ze6DYqEjRwus+O+SszKZjuZPxxctFsEu4gYvdy
         LQqfDmQSj/ShLmv9+zT8SVfc+JQPUNHIkI5A/y5vk3yfmuq9XadciEd5ILtt/SY0Nnp+
         rj7V93wRMA3FchaHoq5UXu74cbPKzLWEqfyFcMgfScAZ/migdpvTUDXkeFZRNI8shyrS
         DJNg==
X-Gm-Message-State: APjAAAWGCywWew+dkOAZE5LRaMdKDyn++/s9B2W37Z569hkK4gacVM4+
        4qvpJlQc/x4MbpXflhy9iGgqzgrv8N1kxzdBSwRIDw==
X-Google-Smtp-Source: APXvYqzkEGCbF52whPiC7JcrVWKDsn/1hFSQDxZirY2/IOn/+SfmgCqpDkQzuI7oaqgfNNMAlwa32d1DuAlHQjw27QE=
X-Received: by 2002:a5d:8908:: with SMTP id b8mr17412303ion.237.1566416791134;
 Wed, 21 Aug 2019 12:46:31 -0700 (PDT)
MIME-Version: 1.0
References: <CAFbqK8=RUaCnk_WkioodkdwLsDina=yW+eLvzckSbVx_3Py_-A@mail.gmail.com>
 <20190821192513.20126-1-jhubbard@nvidia.com>
In-Reply-To: <20190821192513.20126-1-jhubbard@nvidia.com>
From:   Neil MacLeod <neil@nmacleod.com>
Date:   Wed, 21 Aug 2019 20:46:12 +0100
Message-ID: <CAFbqK8=BodLiMr4pdHjdqsZtk8iHUC_9oyRRALJt0xLz4y_4sQ@mail.gmail.com>
Subject: Re: [PATCH] x86/boot: Fix boot failure regression
To:     John Hubbard <jhubbard@nvidia.com>
Cc:     "H . Peter Anvin" <hpa@zytor.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        gregkh@linuxfoundation.org, x86@kernel.org,
        LKML <linux-kernel@vger.kernel.org>, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

I can confirm 5.3-rc5 is booting again from internal M2 drive on
Skylake i5 NUC with this commit - many thanks!

Regards
Neil

On Wed, 21 Aug 2019 at 20:25, John Hubbard <jhubbard@nvidia.com> wrote:
>
> commit a90118c445cc ("x86/boot: Save fields explicitly, zero out
> everything else") had two errors:
>
>     * It preserved boot_params.acpi_rsdp_addr, and
>     * It failed to preserve boot_params.hdr
>
> Therefore, zero out acpi_rsdp_addr, and preserve hdr.
>
> Fixes: a90118c445cc ("x86/boot: Save fields explicitly, zero out everything else")
> Reported-by: Neil MacLeod <neil@nmacleod.com>
> Suggested-by: Thomas Gleixner <tglx@linutronix.de>
> Cc: H. Peter Anvin <hpa@zytor.com>
> Cc: stable@vger.kernel.org
> Signed-off-by: John Hubbard <jhubbard@nvidia.com>
> ---
>  arch/x86/include/asm/bootparam_utils.h | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/arch/x86/include/asm/bootparam_utils.h b/arch/x86/include/asm/bootparam_utils.h
> index f5e90a849bca..9e5f3c722c33 100644
> --- a/arch/x86/include/asm/bootparam_utils.h
> +++ b/arch/x86/include/asm/bootparam_utils.h
> @@ -59,7 +59,6 @@ static void sanitize_boot_params(struct boot_params *boot_params)
>                         BOOT_PARAM_PRESERVE(apm_bios_info),
>                         BOOT_PARAM_PRESERVE(tboot_addr),
>                         BOOT_PARAM_PRESERVE(ist_info),
> -                       BOOT_PARAM_PRESERVE(acpi_rsdp_addr),
>                         BOOT_PARAM_PRESERVE(hd0_info),
>                         BOOT_PARAM_PRESERVE(hd1_info),
>                         BOOT_PARAM_PRESERVE(sys_desc_table),
> @@ -71,6 +70,7 @@ static void sanitize_boot_params(struct boot_params *boot_params)
>                         BOOT_PARAM_PRESERVE(eddbuf_entries),
>                         BOOT_PARAM_PRESERVE(edd_mbr_sig_buf_entries),
>                         BOOT_PARAM_PRESERVE(edd_mbr_sig_buffer),
> +                       BOOT_PARAM_PRESERVE(hdr),
>                         BOOT_PARAM_PRESERVE(e820_table),
>                         BOOT_PARAM_PRESERVE(eddbuf),
>                 };
> --
> 2.22.1
>
