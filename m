Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3C4CC5A555B
	for <lists+stable@lfdr.de>; Mon, 29 Aug 2022 22:12:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230053AbiH2UML (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Aug 2022 16:12:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54922 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229457AbiH2UMK (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 29 Aug 2022 16:12:10 -0400
Received: from mail-yw1-x1131.google.com (mail-yw1-x1131.google.com [IPv6:2607:f8b0:4864:20::1131])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F3BC26A4BF;
        Mon, 29 Aug 2022 13:12:05 -0700 (PDT)
Received: by mail-yw1-x1131.google.com with SMTP id 00721157ae682-3376851fe13so224001797b3.6;
        Mon, 29 Aug 2022 13:12:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc;
        bh=Ij4GQ/Ar4uItMKz6clMJZmNuin21OuLTOJBGJwzmBDw=;
        b=mdGxFELukrS6iIfHzajJYWCjLQhfXFh4ahNloLNfUORmhV22DVaWPCtErrkCmQOPV1
         nVrQeFCcG0hCbKOi2FK4nDVEMkBeP4N1dTfuCQgnLu3uKTzvxXYaEQgnRF3j6Er0ryG8
         gIRG2YEN6cvpvpEQEJsZMFX+knNPv7LEA/oPwgoENDLd+mstC20BqwoxpH5SQ4q7gll3
         wjNH+tVAPwdlz9FT70o8gVTwLY3A9zoaf+JdjAUuzJkELsL1jdWYiAxnfnKnL25l6o6W
         7Y2AU9F3SFHD5cResrBQ2Culco0rvg7+Hb2YYZzuYFUIJQHTrg+63DIAZKS2bV0GisiP
         +nxA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc;
        bh=Ij4GQ/Ar4uItMKz6clMJZmNuin21OuLTOJBGJwzmBDw=;
        b=mznRQDmxYXEMNc2aqoczTtmEpX56MOyfHYFB5nK+U2nlIZXw/WBqWHNXzQb/50v30H
         bSUspxOr+MoLkwwe9SN+zSHyc1aLANdzlvM7UJVS0Gyb2h/8tM1OdREmrI2kSR5/1kxj
         DZcEtR8GoEOZTy7pGa3gwWKQNEkWOXjFB59MvIRr0u6BXsw70dNZ9n0p0rxo4MrW/y8F
         uJMmst8o4JOmukMsECnH9S2akyEEGUrVwx255movsn76FuJPmTk4ftfAFq8ObK80b9LN
         pLIF0Py0f+DxvikNMcxZ7Wa22/SKwH6pR454bzakEqtAaYHt3X0vzLwokpUwIh+8kBn0
         7+ig==
X-Gm-Message-State: ACgBeo3Di6KezYgO/szdlq1z49kxjQEYBsaPN5n1jcO9dyT0M8h/Oryp
        4vPnvJknZuy6gwAwPFBREFSK+SqmmkzUjabzcTX/uQPZ8oc=
X-Google-Smtp-Source: AA6agR6QHl92lh5CznbkfMxvf/g6/pHTgwdgxSo2cq94m/f/rjHGHUSGuJ9rWKlCbCoQt/NVMe2Ai2sn3HNFLb4tLZI=
X-Received: by 2002:a25:4147:0:b0:693:b23a:f529 with SMTP id
 o68-20020a254147000000b00693b23af529mr9817633yba.617.1661803925179; Mon, 29
 Aug 2022 13:12:05 -0700 (PDT)
MIME-Version: 1.0
References: <20220829105804.609007228@linuxfoundation.org>
In-Reply-To: <20220829105804.609007228@linuxfoundation.org>
From:   Sudip Mukherjee <sudipm.mukherjee@gmail.com>
Date:   Mon, 29 Aug 2022 21:11:28 +0100
Message-ID: <CADVatmOLoaGgAW951JqEk3v88EA7mn3qur84Xd30QJWP21+eVg@mail.gmail.com>
Subject: Re: [PATCH 5.15 000/136] 5.15.64-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel <linux-kernel@vger.kernel.org>,
        Stable <stable@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Guenter Roeck <linux@roeck-us.net>,
        Shuah Khan <shuah@kernel.org>, patches@kernelci.org,
        lkft-triage@lists.linaro.org, Pavel Machek <pavel@denx.de>,
        Jonathan Hunter <jonathanh@nvidia.com>,
        Florian Fainelli <f.fainelli@gmail.com>, slade@sladewatkins.com
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Greg,

On Mon, Aug 29, 2022 at 12:00 PM Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 5.15.64 release.
> There are 136 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Wed, 31 Aug 2022 10:57:37 +0000.
> Anything received after that time might be too late.

My builds are still running, but just an initial report for gcc-12. (I
know v5.15.y still does not build completely with gcc-12).

x86_64 and arm64 allmodconfig build fails with gcc-12, with the error:

drivers/acpi/thermal.c: In function 'acpi_thermal_resume':
drivers/acpi/thermal.c:1101:21: error: the comparison will always
evaluate as 'true' for the address of 'active' will never be NULL
[-Werror=address]
 1101 |                 if (!(&tz->trips.active[i]))
      |                     ^
drivers/acpi/thermal.c:151:36: note: 'active' declared here
  151 |         struct acpi_thermal_active active[ACPI_THERMAL_MAX_ACTIVE];

Will need e5b5d25444e9 ("ACPI: thermal: drop an always true check").

powerpc allmodconfig fails with gcc-12, the error is:

In function 'memcmp',
    inlined from 'bacmp' at ./include/net/bluetooth/bluetooth.h:278:9,
    inlined from 'l2cap_global_chan_by_psm' at
net/bluetooth/l2cap_core.c:2003:15:
./include/linux/fortify-string.h:19:33: error: '__builtin_memcmp'
specified bound 6 exceeds source size 0 [-Werror=stringop-overread]
   19 | #define __underlying_memcmp     __builtin_memcmp
      |                                 ^
./include/linux/fortify-string.h:235:16: note: in expansion of macro
'__underlying_memcmp'
  235 |         return __underlying_memcmp(p, q, size);
      |                ^~~~~~~~~~~~~~~~~~~
In function 'memcmp',
    inlined from 'bacmp' at ./include/net/bluetooth/bluetooth.h:278:9,
    inlined from 'l2cap_global_chan_by_psm' at
net/bluetooth/l2cap_core.c:2004:15:
./include/linux/fortify-string.h:19:33: error: '__builtin_memcmp'
specified bound 6 exceeds source size 0 [-Werror=stringop-overread]
   19 | #define __underlying_memcmp     __builtin_memcmp
      |                                 ^
./include/linux/fortify-string.h:235:16: note: in expansion of macro
'__underlying_memcmp'
  235 |         return __underlying_memcmp(p, q, size);
      |                ^~~~~~~~~~~~~~~~~~~

Introduced in v5.15.61 due to 2711bedab26c ("Bluetooth: L2CAP: Fix
l2cap_global_chan_by_psm regression").
But v5.19.y and mainline does not show the build failure as they also
have 41b7a347bf14 ("powerpc: Book3S 64-bit outline-only KASAN
support").


-- 
Regards
Sudip
