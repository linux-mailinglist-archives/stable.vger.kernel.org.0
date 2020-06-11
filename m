Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 094D91F6C8D
	for <lists+stable@lfdr.de>; Thu, 11 Jun 2020 19:06:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726379AbgFKRGc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 11 Jun 2020 13:06:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56022 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726703AbgFKRGb (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 11 Jun 2020 13:06:31 -0400
Received: from mail-pg1-x541.google.com (mail-pg1-x541.google.com [IPv6:2607:f8b0:4864:20::541])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B3BA0C08C5C2
        for <stable@vger.kernel.org>; Thu, 11 Jun 2020 10:06:30 -0700 (PDT)
Received: by mail-pg1-x541.google.com with SMTP id l63so541279pge.12
        for <stable@vger.kernel.org>; Thu, 11 Jun 2020 10:06:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=pI2G9x8XySR9DruVGRJidO1nAqjYW7jZcLJ0jduQuLM=;
        b=NqEJ5GA/ehM6UXoHjGGuPNm3B3rfMC1cOHvni2EJcnW9zfClcUy4MFwL3d6X4Umn1G
         gf95qNdFanqgDq/iJc7qrRLil0x0D2wngwpf5nyMmOSpv1Miw+RLTpCnQCyf6U6A9UgB
         BIjwZ5q8ylSnAuU3U7wqC1G+YIOYg5ZQMEwwIqa27NlLx4wfBto6cqvEmfhOoIkAQg2D
         OcPRn7du2QLzn0LYY7+6DIXok09q0JSmnm0eTyfsKq7lCxHphLZiuK/LRFrgjljjDgV4
         ztCU39IhEGgwqTb3durCnfrOGlFCcAyCoaR7e4UepPjSEK/zT+pqQFMs2xMPU5fiE7jk
         MPbg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=pI2G9x8XySR9DruVGRJidO1nAqjYW7jZcLJ0jduQuLM=;
        b=IccoXf8vwZ+/6cnHHFWEiw4V0uNmgREd8GFPrvDQAQ3o+XCV84PimoPxgCcrsfSl0o
         qCl11Y2VGd2wiXxiVhFcKLpk7JKHh2Ce6pM7/DwxsdYrLEHbw4naSpX6l5e7qcsuPfOG
         GwT6ITTjqT0AckeTLoRl2KuxhkcbDAzb3Dbo8x09s4/A2Lbwhw9h2WdONvC4Mcf3kxpE
         LbfA9yFpqHHIDihbAfp6+XI/vifq7Q5hqKf9nl28R7OV+Mei423AnsjeXFkFXa3KFRtX
         EhlLpAtm1QgKq3MSx9gsuLTf4npQy+GaugXy2TmcmRPw0MrYFy94EhumxVRrkA2vDNoH
         uNJQ==
X-Gm-Message-State: AOAM532Jl66OX2R7xUso3njLnfhqRvaZY4qWYHuoUadm2AE4/muz7IXp
        Gl6Dm5wQMsfo8z5yKehGSOf1fpMgVH5dif/PV5d54A==
X-Google-Smtp-Source: ABdhPJwIaddzPZfkreOWkm5D3KkSKXIx2FEPb4DMs82rwvXYSe+SfQFOSBO/0V8ZUaC6ymLwx/6gIHy0Sny57CDe07w=
X-Received: by 2002:a62:7e95:: with SMTP id z143mr8049365pfc.108.1591895189671;
 Thu, 11 Jun 2020 10:06:29 -0700 (PDT)
MIME-Version: 1.0
References: <CAMj1kXErFuvOoG=DB6sz5HBvDuHDiKwWD8uOyLuxaX-u8-+dbA@mail.gmail.com>
 <20200601231805.207441-1-ndesaulniers@google.com> <BYAPR11MB3096A0EA2D03BCB76C91F80AF0830@BYAPR11MB3096.namprd11.prod.outlook.com>
 <CAKwvOdnh6Zh+P9SM_qFiy-9u7Y21fn=byTJtG4fTTRJqqU9bcQ@mail.gmail.com>
 <9f4322a5-eea6-fb65-449c-90f3d85f753e@FreeBSD.org> <BYAPR11MB3096904AD67CC83A67A38215F0800@BYAPR11MB3096.namprd11.prod.outlook.com>
In-Reply-To: <BYAPR11MB3096904AD67CC83A67A38215F0800@BYAPR11MB3096.namprd11.prod.outlook.com>
From:   Nick Desaulniers <ndesaulniers@google.com>
Date:   Thu, 11 Jun 2020 10:06:19 -0700
Message-ID: <CAKwvOdndPdAWVSJ530mgT5onG4zsHExqO79=QvvLvpz51D8LsQ@mail.gmail.com>
Subject: Re: [Devel] Re: [PATCH] ACPICA: fix UBSAN warning using __builtin_offsetof
To:     "Kaneda, Erik" <erik.kaneda@intel.com>
Cc:     Jung-uk Kim <jkim@freebsd.org>,
        "Wysocki, Rafael J" <rafael.j.wysocki@intel.com>,
        Ard Biesheuvel <ardb@kernel.org>,
        "dvyukov@google.com" <dvyukov@google.com>,
        "glider@google.com" <glider@google.com>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "lorenzo.pieralisi@arm.com" <lorenzo.pieralisi@arm.com>,
        "mark.rutland@arm.com" <mark.rutland@arm.com>,
        "pcc@google.com" <pcc@google.com>,
        "rjw@rjwysocki.net" <rjw@rjwysocki.net>,
        "will@kernel.org" <will@kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>,
        "devel@acpica.org" <devel@acpica.org>
Content-Type: text/plain; charset="UTF-8"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Jun 11, 2020 at 9:45 AM Kaneda, Erik <erik.kaneda@intel.com> wrote:
>
> > From: Jung-uk Kim <jkim@FreeBSD.org>
> >
> > Actually, I think we should let platform-specific acfoo.h decide what to
> > do here, i.e.,
>
> That's a better solution. For Linux, it would look something like this:
>
> --- a/include/acpi/actypes.h
> +++ b/include/acpi/actypes.h
> @@ -508,10 +508,15 @@ typedef u64 acpi_integer;
>
>  #define ACPI_TO_POINTER(i)              ACPI_CAST_PTR (void, (acpi_size) (i))
>  #define ACPI_TO_INTEGER(p)              ACPI_PTR_DIFF (p, (void *) 0)
> -#define ACPI_OFFSET(d, f)               ACPI_PTR_DIFF (&(((d *) 0)->f), (void *) 0)
>  #define ACPI_PHYSADDR_TO_PTR(i)         ACPI_TO_POINTER(i)
>  #define ACPI_PTR_TO_PHYSADDR(i)         ACPI_TO_INTEGER(i)
>
> +/* Platforms may want to define their own ACPI_OFFSET */
> +
> +#ifndef ACPI_OFFSET
> +#define ACPI_OFFSET(d, f)               ACPI_PTR_DIFF (&(((d *) 0)->f), (void *) 0)
> +#endif
> +
>  /* Optimizations for 4-character (32-bit) acpi_name manipulation */
>
>  #ifndef ACPI_MISALIGNMENT_NOT_SUPPORTED
> diff --git a/include/acpi/platform/aclinux.h b/include/acpi/platform/aclinux.h
> index 987e2af7c335..5d1ca6015fce 100644
> --- a/include/acpi/platform/aclinux.h
> +++ b/include/acpi/platform/aclinux.h
> @@ -71,6 +71,11 @@
>  #undef ACPI_DEBUG_DEFAULT
>  #define ACPI_DEBUG_DEFAULT          (ACPI_LV_INFO | ACPI_LV_REPAIR)
>
> +/* Use gcc's builtin offset instead of the default */
> +
> +#undef ACPI_OFFSET
> +#define ACPI_OFFSET(a,b)            __builtin_offsetof(a,b)
> +
>  #ifndef CONFIG_ACPI
>

Looks good at first glance.  Wouldn't actypes.h need to include
platform/acenv.h first though?  Otherwise you put some header
inclusion order dependency on folks who include actypes.h to first
include acenv.h otherwise we're not getting the definition in terms of
__builtin_offsetof.

-- 
Thanks,
~Nick Desaulniers
