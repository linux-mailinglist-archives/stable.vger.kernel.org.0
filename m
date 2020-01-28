Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F1F2914B390
	for <lists+stable@lfdr.de>; Tue, 28 Jan 2020 12:38:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726024AbgA1Lim (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 28 Jan 2020 06:38:42 -0500
Received: from mail-lf1-f65.google.com ([209.85.167.65]:33115 "EHLO
        mail-lf1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726010AbgA1Lil (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 28 Jan 2020 06:38:41 -0500
Received: by mail-lf1-f65.google.com with SMTP id n25so8841395lfl.0
        for <stable@vger.kernel.org>; Tue, 28 Jan 2020 03:38:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=shek/n2yaJ4xNGyr8p8VRMr5B9/J6o+UNlVfe5LW8Wk=;
        b=mx5ogHr3Q1649qfV1I/89WFMUGNodbkAskaHwYx5cV+jARa8ihf9fCZhc01yQAfR+w
         JnXP1BKtt/2eCZBD7+NcbS7CE4Yfwhdf9Cx9YSmr3gIc6GfseuM9j0A0pK1TffeqjIDg
         dxJQpOL/b87oMxS+jzmz0E0YBDIc74+4HveLL+xaUMfoe6FSwIR+BbTIyr95KqLShCjm
         oupWzKprvdeQuDYTNpSk+fXXwMTxNyiZjJm0OVBSTYcWyQmRjFFZGcNimiZcVUbbUDM7
         YWEEtgoBPCwI2TiiL3wP5SFOto8OVl4SFITf2ogKyERJf9tzX+lV/O7yFpo+eacRP3z/
         icXQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=shek/n2yaJ4xNGyr8p8VRMr5B9/J6o+UNlVfe5LW8Wk=;
        b=nR6vwmd+UdbMM4+Xf8EoiYapnuZeu5Vg7XtycvaAF9U5up8T63LXuOVoDvh4ViLBfX
         YfYM7SnXmAKvJ+ZaJ2exooaA3qalkwRfMuPtOc2IpsUmIASzbTfUaW4v1iMofacsocDi
         dJ+pwjJTmJghDuLtZCprXdJq4jPbZUhH+xik1wtZCZREjYGUK9s7AlMlToFUykgErXUP
         ScK0mHYfTA1o7PGRPITjF3NQjnIfdBFpriWInmRb0ZNJ8EXMCqY2fc5IDOzSlfGAF/rA
         AYhtU7+MiCdFOkcpEbnNHVaDqHHjVPINZmbrq8swCB312Oi503YOfgfyJf7qm+Btd46C
         vH6w==
X-Gm-Message-State: APjAAAWYp2ousAzII7wtVBdb/1Bj9LANBcfQIhv5GDM//lYxvlykrflG
        hVp8Z0ZOnD54fAPbdnnU9To9RAzjzAaYu39eKlYt4A==
X-Google-Smtp-Source: APXvYqxIGZaVMql0dzFVuAp0Npksnl5WAwwR8IJITZh402Xtqso4VRK/EtNCV+s++HoutkYkagjhKbkeoADGPMcI5j8=
X-Received: by 2002:ac2:5467:: with SMTP id e7mr2052345lfn.74.1580211518997;
 Tue, 28 Jan 2020 03:38:38 -0800 (PST)
MIME-Version: 1.0
References: <20180630201750.2588-1-andriy.shevchenko@linux.intel.com> <20180630201750.2588-4-andriy.shevchenko@linux.intel.com>
In-Reply-To: <20180630201750.2588-4-andriy.shevchenko@linux.intel.com>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Tue, 28 Jan 2020 17:08:27 +0530
Message-ID: <CA+G9fYs3GPid5fcHEWp2i9NKR1hQGc5h0zKaUK5xr1RGJ83xLg@mail.gmail.com>
Subject: Re: [PATCH v4 3/5] bitmap: Add bitmap_alloc(), bitmap_zalloc() and bitmap_free()
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc:     Alasdair Kergon <agk@redhat.com>,
        Mike Snitzer <snitzer@redhat.com>, dm-devel@redhat.com,
        Shaohua Li <shli@kernel.org>, linux-raid@vger.kernel.org,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        linux-input@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Yury Norov <ynorov@caviumnetworks.com>,
        open list <linux-kernel@vger.kernel.org>,
        mika.westerberg@linux.intel.com, Joe Perches <joe@perches.com>,
        linux- stable <stable@vger.kernel.org>,
        lkft-triage@lists.linaro.org
Content-Type: text/plain; charset="UTF-8"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sun, 1 Jul 2018 at 01:49, Andy Shevchenko
<andriy.shevchenko@linux.intel.com> wrote:
>
> A lot of code become ugly because of open coding allocations for bitmaps.
>
> Introduce three helpers to allow users be more clear of intention
> and keep their code neat.
>
> Note, due to multiple circular dependencies we may not provide
> the helpers as inliners. For now we keep them exported and, perhaps,
> at some point in the future we will sort out header inclusion and
> inheritance.
>
> Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
> ---
>  include/linux/bitmap.h |  8 ++++++++
>  lib/bitmap.c           | 19 +++++++++++++++++++
>  2 files changed, 27 insertions(+)
>
> diff --git a/include/linux/bitmap.h b/include/linux/bitmap.h
> index 1ee46f492267..acf5e8df3504 100644
> --- a/include/linux/bitmap.h
> +++ b/include/linux/bitmap.h
> @@ -104,6 +104,14 @@
>   * contain all bit positions from 0 to 'bits' - 1.
>   */
>
> +/*
> + * Allocation and deallocation of bitmap.
> + * Provided in lib/bitmap.c to avoid circular dependency.
> + */
> +extern unsigned long *bitmap_alloc(unsigned int nbits, gfp_t flags);
> +extern unsigned long *bitmap_zalloc(unsigned int nbits, gfp_t flags);
> +extern void bitmap_free(const unsigned long *bitmap);
> +
>  /*
>   * lib/bitmap.c provides these functions:
>   */
> diff --git a/lib/bitmap.c b/lib/bitmap.c
> index 33e95cd359a2..09acf2fd6a35 100644
> --- a/lib/bitmap.c
> +++ b/lib/bitmap.c
> @@ -13,6 +13,7 @@
>  #include <linux/bitops.h>
>  #include <linux/bug.h>
>  #include <linux/kernel.h>
> +#include <linux/slab.h>
>  #include <linux/string.h>
>  #include <linux/uaccess.h>
>
> @@ -1125,6 +1126,24 @@ void bitmap_copy_le(unsigned long *dst, const unsigned long *src, unsigned int n
>  EXPORT_SYMBOL(bitmap_copy_le);
>  #endif
>
> +unsigned long *bitmap_alloc(unsigned int nbits, gfp_t flags)
> +{
> +       return kmalloc_array(BITS_TO_LONGS(nbits), sizeof(unsigned long), flags);
> +}
> +EXPORT_SYMBOL(bitmap_alloc);
> +
> +unsigned long *bitmap_zalloc(unsigned int nbits, gfp_t flags)
> +{
> +       return bitmap_alloc(nbits, flags | __GFP_ZERO);
> +}
> +EXPORT_SYMBOL(bitmap_zalloc);
> +
> +void bitmap_free(const unsigned long *bitmap)
> +{
> +       kfree(bitmap);
> +}
> +EXPORT_SYMBOL(bitmap_free);
> +
>  #if BITS_PER_LONG == 64
>  /**
>   * bitmap_from_arr32 - copy the contents of u32 array of bits to bitmap

stable-rc 4.14 build failed due to these build error,

lib/bitmap.c: In function 'bitmap_from_u32array':
lib/bitmap.c:1133:1: warning: ISO C90 forbids mixed declarations and
code [-Wdeclaration-after-statement]
 unsigned long *bitmap_alloc(unsigned int nbits, gfp_t flags)
 ^~~~~~~~
In file included from
/srv/oe/build/tmp-lkft-glibc/work-shared/intel-corei7-64/kernel-source/lib/bitmap.c:8:0:
lib/bitmap.c:1138:15: error: non-static declaration of 'bitmap_alloc'
follows static declaration
 EXPORT_SYMBOL(bitmap_alloc);
               ^
include/linux/export.h:65:21: note: in definition of macro '___EXPORT_SYMBOL'
  extern typeof(sym) sym;      \
                     ^~~
lib/bitmap.c:1138:1: note: in expansion of macro 'EXPORT_SYMBOL'
 EXPORT_SYMBOL(bitmap_alloc);
 ^~~~~~~~~~~~~
lib/bitmap.c:1133:16: note: previous definition of 'bitmap_alloc' was here
 unsigned long *bitmap_alloc(unsigned int nbits, gfp_t flags)
                ^~~~~~~~~~~~
In file included from
/srv/oe/build/tmp-lkft-glibc/work-shared/intel-corei7-64/kernel-source/lib/bitmap.c:8:0:
lib/bitmap.c:1144:15: error: non-static declaration of 'bitmap_zalloc'
follows static declaration
 EXPORT_SYMBOL(bitmap_zalloc);
               ^
include/linux/export.h:65:21: note: in definition of macro '___EXPORT_SYMBOL'
  extern typeof(sym) sym;      \
                     ^~~
lib/bitmap.c:1144:1: note: in expansion of macro 'EXPORT_SYMBOL'
 EXPORT_SYMBOL(bitmap_zalloc);
 ^~~~~~~~~~~~~
lib/bitmap.c:1140:16: note: previous definition of 'bitmap_zalloc' was here
 unsigned long *bitmap_zalloc(unsigned int nbits, gfp_t flags)
                ^~~~~~~~~~~~~
In file included from
/srv/oe/build/tmp-lkft-glibc/work-shared/intel-corei7-64/kernel-source/lib/bitmap.c:8:0:
lib/bitmap.c:1150:15: error: non-static declaration of 'bitmap_free'
follows static declaration
 EXPORT_SYMBOL(bitmap_free);
               ^
include/linux/export.h:65:21: note: in definition of macro '___EXPORT_SYMBOL'
  extern typeof(sym) sym;      \
                     ^~~
lib/bitmap.c:1150:1: note: in expansion of macro 'EXPORT_SYMBOL'
 EXPORT_SYMBOL(bitmap_free);
 ^~~~~~~~~~~~~
lib/bitmap.c:1146:6: note: previous definition of 'bitmap_free' was here
 void bitmap_free(const unsigned long *bitmap)
      ^~~~~~~~~~~
  CC      drivers/char/random.o
scripts/Makefile.build:326: recipe for target 'lib/bitmap.o' failed
make[3]: *** [lib/bitmap.o] Error 1
Makefile:1052: recipe for target 'lib' failed
make[2]: *** [lib] Error 2
