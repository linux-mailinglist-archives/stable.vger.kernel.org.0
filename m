Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0118A11CF15
	for <lists+stable@lfdr.de>; Thu, 12 Dec 2019 15:02:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729593AbfLLOCg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 12 Dec 2019 09:02:36 -0500
Received: from mail-wm1-f65.google.com ([209.85.128.65]:36499 "EHLO
        mail-wm1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729567AbfLLOCg (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 12 Dec 2019 09:02:36 -0500
Received: by mail-wm1-f65.google.com with SMTP id p17so2647170wma.1
        for <stable@vger.kernel.org>; Thu, 12 Dec 2019 06:02:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=u2RUDl0mYLvmXxjsLkAo20DZhbBWkB25mVRHhxsu6eI=;
        b=Og0OIM3ERcWxCnRN++RWWG4z6rzmr5a6nHC6FsZO8HVaAVTtF1LczCuN6879Xt0VbM
         rtvTvkjllgM1I2VrJQitukSJtlMPazhlm11Eah76iznHoRB3K14Tt5F4kvYqB5FJxaf5
         cvb+o1m/OKAS7Sg4eHfWZPgI8/P0KTHHdS2q3CM0n6DmXuEy7UM/0tFCR+2D1qLBZjBA
         4dDgTIEpIdAa5yyroiTlCgmjN97ODLzvGmGwfwOdkI+U0IKJUOokU2BTHsCFXnJ+fsvc
         LjqAhgryPODrbsbMMp69/CKJtew/4PWTYKeo2iyVqC95uEJSKCPbCY9VSDzMj+uwuQH9
         hviw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=u2RUDl0mYLvmXxjsLkAo20DZhbBWkB25mVRHhxsu6eI=;
        b=A7Krg/M5B9DUt2x908LTVcW1X3Qy8ioXWiVI+rYykZhekequ6lLEcX+JKPGaxJY/9d
         ICONBhdWUf1ae9WpVvHSFSqATyyFoVL+ixTi6tdi6DELxh0Fng1gUVZq0IZ/tIDm4sOZ
         9aMa4MhOdhJlueePhdzdA/bggEDmpn//fwos7VZ+4VHJc5BSVRgy5xLmUFHv0sHKNedL
         eR4UjpAXUv1lTNi0j17Dsu+aIT0zM17p2eK8ATb0dXdqTo0J85plDRtNX0v6DgbZiiup
         1aexF8oYN7/6rYpY8+sxMXTyOxFdF8bVRXThotu4iXnEF14KaNUrYqixtqmLF+8aVz76
         sACA==
X-Gm-Message-State: APjAAAUlfTVEdlLM4gDhrhbvPVyfILxeqHKCPXawCkq2OFg7dSpl4cdg
        eIIlyvKCBoTwb8BbduJrJ4voPYmEPTIg4bmSWtVJeQ==
X-Google-Smtp-Source: APXvYqxbofXUzxSXHnSYtdpsEwkoDNF3YT6M3W65sasL+TC5Y8hxcYGpm8mGi9TIXs/EUWoX6MrXiLHTPwCwSvhT8tk=
X-Received: by 2002:a7b:c95a:: with SMTP id i26mr6726628wml.67.1576159354472;
 Thu, 12 Dec 2019 06:02:34 -0800 (PST)
MIME-Version: 1.0
References: <20191212103158.4958-1-hdegoede@redhat.com> <20191212103158.4958-3-hdegoede@redhat.com>
 <CAKv+Gu9AjYVvLot9+enuwSWfyfzqgCWSuW3ioccm3FJ7KFA8eA@mail.gmail.com> <82c65f05-1140-e10e-ba2f-0c4c5c85bbc8@redhat.com>
In-Reply-To: <82c65f05-1140-e10e-ba2f-0c4c5c85bbc8@redhat.com>
From:   Ard Biesheuvel <ard.biesheuvel@linaro.org>
Date:   Thu, 12 Dec 2019 15:02:15 +0100
Message-ID: <CAKv+Gu9StgwBs=y6KU2Pb_P499SfH8po978gHoAbXVL8mB722A@mail.gmail.com>
Subject: Re: [PATCH 5.5 regression fix 2/2] efi/libstub/helper: Initialize
 pointer variables to zero for mixed mode
To:     Hans de Goede <hdegoede@redhat.com>
Cc:     Thomas Gleixner <tglx@linutronix.de>,
        Dominik Brodowski <linux@dominikbrodowski.net>,
        "the arch/x86 maintainers" <x86@kernel.org>,
        linux-efi <linux-efi@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        stable <stable@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, 12 Dec 2019 at 13:45, Hans de Goede <hdegoede@redhat.com> wrote:
>
> Hi,
>
> On 12-12-2019 12:29, Ard Biesheuvel wrote:
> > On Thu, 12 Dec 2019 at 11:32, Hans de Goede <hdegoede@redhat.com> wrote:
> >>
> >> When running in EFI mixed mode (running a 64 bit kernel on 32 bit EFI
> >> firmware), we _must_ initialize any pointers which are returned by
> >> reference by an EFI call to NULL before making the EFI call.
> >>
> >> In mixed mode pointers are 64 bit, but when running on a 32 bit firmware,
> >> EFI calls which return a pointer value by reference only fill the lower
> >> 32 bits of the passed pointer, leaving the upper 32 bits uninitialized
> >> unless we explicitly set them to 0 before the call.
> >>
> >> We have had this bug in the efi-stub-helper.c file reading code for
> >> a while now, but this has likely not been noticed sofar because
> >> this code only gets triggered when LILO style file=... arguments are
> >> present on the kernel cmdline.
> >>
> >> Cc: stable@vger.kernel.org
> >> Signed-off-by: Hans de Goede <hdegoede@redhat.com>
> >> ---
> >>   drivers/firmware/efi/libstub/efi-stub-helper.c | 4 ++--
> >>   1 file changed, 2 insertions(+), 2 deletions(-)
> >>
> >> diff --git a/drivers/firmware/efi/libstub/efi-stub-helper.c b/drivers/firmware/efi/libstub/efi-stub-helper.c
> >> index e02579907f2e..6ca7d86743af 100644
> >> --- a/drivers/firmware/efi/libstub/efi-stub-helper.c
> >> +++ b/drivers/firmware/efi/libstub/efi-stub-helper.c
> >> @@ -365,7 +365,7 @@ static efi_status_t efi_file_size(efi_system_table_t *sys_table_arg, void *__fh,
> >>                                    u64 *file_sz)
> >>   {
> >>          efi_file_handle_t *h, *fh = __fh;
> >
> > What about h? Doesn't it suffer from the same problem?
> >
> >> -       efi_file_info_t *info;
> >> +       efi_file_info_t *info = NULL;
> >>          efi_status_t status;
> >>          efi_guid_t info_guid = EFI_FILE_INFO_ID;
> >>          unsigned long info_sz;
> >
> > And info_sz?
>
> And "efi_file_io_interface_t *io" and "efi_file_handle_t *fh"
> in efi_open_volume().
>
> I think that is all of them.
>

OK.

I'll fix it up locally.
