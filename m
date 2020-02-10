Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9E6A8157F48
	for <lists+stable@lfdr.de>; Mon, 10 Feb 2020 16:58:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727628AbgBJP6O convert rfc822-to-8bit (ORCPT
        <rfc822;lists+stable@lfdr.de>); Mon, 10 Feb 2020 10:58:14 -0500
Received: from mout.kundenserver.de ([212.227.126.130]:58053 "EHLO
        mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727143AbgBJP6O (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 10 Feb 2020 10:58:14 -0500
Received: from mail-qv1-f52.google.com ([209.85.219.52]) by
 mrelayeu.kundenserver.de (mreue011 [212.227.15.129]) with ESMTPSA (Nemesis)
 id 1MuDHR-1jLrUv1q8L-00uZVr; Mon, 10 Feb 2020 16:58:12 +0100
Received: by mail-qv1-f52.google.com with SMTP id p2so3379198qvo.10;
        Mon, 10 Feb 2020 07:58:12 -0800 (PST)
X-Gm-Message-State: APjAAAVsGZhZgoqiU0ziU8zxPyF/yTQiR6mYsSoMVgwWFsb8I+mBLRNy
        ex+wqK10oke2GToGOroa50hEH4KWBzF56op4XrQ=
X-Google-Smtp-Source: APXvYqwi4ZoFbnmw3nnhT4tDEWiydL4SiSFiHWpc+aE+XIZm51wr8kiVnmFwCTxhyqi/oKG97txows3MEsUheDXr6f8=
X-Received: by 2002:a0c:bd20:: with SMTP id m32mr10404841qvg.197.1581350291243;
 Mon, 10 Feb 2020 07:58:11 -0800 (PST)
MIME-Version: 1.0
References: <20200210122423.695146547@linuxfoundation.org> <20200210122450.176337512@linuxfoundation.org>
 <CA+G9fYu4pDFaG-dA2KbVp61HGNzA1R3F_=Z5isC8_ammG4iZkQ@mail.gmail.com>
In-Reply-To: <CA+G9fYu4pDFaG-dA2KbVp61HGNzA1R3F_=Z5isC8_ammG4iZkQ@mail.gmail.com>
From:   Arnd Bergmann <arnd@arndb.de>
Date:   Mon, 10 Feb 2020 16:57:55 +0100
X-Gmail-Original-Message-ID: <CAK8P3a0iq1fj7iVuYMYczbg2ij-x5b0D5OeKiy_2Pebk+ucMeA@mail.gmail.com>
Message-ID: <CAK8P3a0iq1fj7iVuYMYczbg2ij-x5b0D5OeKiy_2Pebk+ucMeA@mail.gmail.com>
Subject: Re: [PATCH 5.5 284/367] compat: scsi: sg: fix v3 compat read/write interface
To:     Naresh Kamboju <naresh.kamboju@linaro.org>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        open list <linux-kernel@vger.kernel.org>,
        linux- stable <stable@vger.kernel.org>,
        Ben Hutchings <ben.hutchings@codethink.co.uk>,
        Sasha Levin <sashal@kernel.org>, lkft-triage@lists.linaro.org,
        Basil Eljuse <Basil.Eljuse@arm.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Provags-ID: V03:K1:n9FNCikSD1JPbf7vQvz+QGtPowt3ouI5/nf1kp2EavgnD/55aBS
 mwulyxH8vMjUYmKlpFnKj99XwL8aaakFqfql/Y+u7/CKPlaviO9A3dti++Llppwcfsq/3LR
 bw6DTLJqv46FP6tt3zlvDFBLDNKUqYrvN2hwBW4bjAYOXB7487b2g/iqZtxtxyCEH+BOg9k
 HYWfUCweoqL+XmwF89CqA==
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:0W626MdKfhA=:56mFn6I/g/VKZRQ4Y+EitX
 oNHzDxBi+s3OfxRFxhKe5Rz2RfB54xgaKFqb1lCihwNWWIuQ8seP6XDoLDQUKQzVvG85vZVxI
 i7XhtqHMGzvKJdBrQGIhAaEQ86jbyFhQhXwexI3Io9zEI8Ec8wW+ws70KygJI2SHQrFoTSc1I
 0Uhj8rO7V0ry1NQEzabyPrQi+t5jaoIGBOMfX/nSxWSheBEZX3mtqnBJKkgBiOubiSg8Qj12R
 lhDr1c0d5vhZLsnxp470bYAWRbP5c1KSeEWmOVK4tZ7f3wVCutNUSe7e92hIHKFSdwt4NtziW
 BnDpsH4hbkLgWqfH/bTsOqiCryLLcM57n1qu1U+FNc/GZKZ0t+YrFmN8v7Yy0WAANHZRdP58q
 OU3M778mu+nakzYqxoeudrabOKqC7QgKozRt3kLkGR1LguTaukgbnIhPlkym5DI3PN2u2ATv5
 aouvWcR4cznxgtwDdbLE7C0CNrnfcjh7cZFEXgG/4StZCk1aC3GqNl9QiYoH5RFPZGyv/iE1L
 17L6U9cWqXbOwVEe+1j2rLfJCx3XSJy1g56Lfdq1Q5WdSk7d+ROFDwU5PaPL8nChhZ99gCrzZ
 B1II2chgIxRfFGNa6RQoz2tAHV+WqaObS3j6JtqBfkJogQsoEAzw/VcwIWzgdBzcJbKvhOBY+
 VUFfUTVbg+oQy5JsUpfOWAWBFyWzC67PuBDv6WowjJV/QeAJLf2Ck4yZ/UMw/7jvVTEF+WJ6Z
 jutxe/Ghi+nNYCTAhZqQSvGhE6br/YJCj1WR6JoU7/EgeRDXh2BgDTWSyJFtHsr5nvNh+EFKE
 AxMkW7Nfy5qdt9ANJF6xElDjutia/6T5Bbb7GX0vcJkzSXczHE=
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Feb 10, 2020 at 4:41 PM Naresh Kamboju
<naresh.kamboju@linaro.org> wrote:
>
> The arm64 architecture 64k page size enabled build failed on stable rc 5.5
> CONFIG_ARM64_64K_PAGES=y
> CROSS_COMPILE=aarch64-linux-gnu-
> Toolchain gcc-9
>
> In file included from ../block/scsi_ioctl.c:23:
>  ../include/scsi/sg.h:75:2: error: unknown type name ‘compat_int_t’
>   compat_int_t interface_id; /* [i] 'S' for SCSI generic (required) */
>   ^~~~~~~~~~~~
>  ../include/scsi/sg.h:76:2: error: unknown type name ‘compat_int_t’
>   compat_int_t dxfer_direction; /* [i] data transfer direction  */
>   ^~~~~~~~~~~~
>
> ...
>  ../include/scsi/sg.h:97:2: error: unknown type name ‘compat_uint_t’
>   compat_uint_t info;  /* [o] auxiliary information */

Hi Naresh,

Does it work if you backport 071aaa43513a ("compat: ARM64: always include
asm-generic/compat.h")?

        Arnd
