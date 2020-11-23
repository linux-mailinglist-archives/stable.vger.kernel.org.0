Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B0A072BFE38
	for <lists+stable@lfdr.de>; Mon, 23 Nov 2020 03:41:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726861AbgKWCkN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 22 Nov 2020 21:40:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50004 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726630AbgKWCkN (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 22 Nov 2020 21:40:13 -0500
Received: from mail-pf1-x442.google.com (mail-pf1-x442.google.com [IPv6:2607:f8b0:4864:20::442])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0F4CCC061A4C
        for <stable@vger.kernel.org>; Sun, 22 Nov 2020 18:40:13 -0800 (PST)
Received: by mail-pf1-x442.google.com with SMTP id x24so1247494pfn.6
        for <stable@vger.kernel.org>; Sun, 22 Nov 2020 18:40:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=axtens.net; s=google;
        h=from:to:cc:subject:in-reply-to:references:date:message-id
         :mime-version:content-transfer-encoding;
        bh=Y8B0IVeEkVdysRl8MZY7gEKbNzxo5TUtivMnasiBLDI=;
        b=A7efsjKy8ky87s9QnpIvB642Gwi34u6vtw4B+X9j9nKH7akjDq0bUTT0xkHSSokJDM
         /P6KdsbMbfWW5O6BIelTDoYihef4+k3ACXhbWL4kcKwj4DOLBEiiLxkpw37hzNhmgU12
         oe8d4UZ7Nxllojk/NWLsr//Zmc2nXRC8+DXSk=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version:content-transfer-encoding;
        bh=Y8B0IVeEkVdysRl8MZY7gEKbNzxo5TUtivMnasiBLDI=;
        b=NXAfuNaqMVKG6zEHMQYJnA1suaEy5CM2o9Ch4e0LXtv79JcbQuYL19KdDLYfmqU/N6
         whG4xvo1PlnHTcnHPGYJ4HlnqaK2M2bLfDIM00xkzTuZL6hb9Tx/adGahNlcaVOeJ4by
         m2EjnqEKITOV8wL9XvCqp61/HusTT7ZaHdgSN4pVz9uHXfHf1RSsoiYayW239pdT9Ucj
         y+DeoSfK5GW0+36SEuJS+jWSJoyzmbPeTW1kIbWe2ooZkruHKCGmSnHSDUNZurrPXDPr
         DkxQNpm8tJhq+MuThMvultCFA9o4/TaqQQUjfy+BL01FgpdJkFR68ed92wFPVTv9uEHH
         20TA==
X-Gm-Message-State: AOAM53279m5OUm7pDVVbMWWKopUEeHWueVyMv+fOTObhSJtGMc3zrSX9
        X7tAUE4NNzgKjXWwfid17tzH8A==
X-Google-Smtp-Source: ABdhPJzOkE3V/pA4H9fe9G8Z6Lq8kqmQdpi9CFCo3MvoxlXcKci4cL+EplpKNksR8A0fiyB3DCruRg==
X-Received: by 2002:a17:90a:c695:: with SMTP id n21mr23056404pjt.86.1606099212543;
        Sun, 22 Nov 2020 18:40:12 -0800 (PST)
Received: from localhost (2001-44b8-1113-6700-7c33-03c1-9b47-98b6.static.ipv6.internode.on.net. [2001:44b8:1113:6700:7c33:3c1:9b47:98b6])
        by smtp.gmail.com with ESMTPSA id g9sm8858880pgk.73.2020.11.22.18.40.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 22 Nov 2020 18:40:11 -0800 (PST)
From:   Daniel Axtens <dja@axtens.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Guenter Roeck <linux@roeck-us.net>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, stable@vger.kernel.org
Subject: Re: [PATCH 4.4 00/15] 4.4.245-rc1 review
In-Reply-To: <X7oahkxvsgCgDtrG@kroah.com>
References: <20201120104539.534424264@linuxfoundation.org> <20201121182903.GB111877@roeck-us.net> <X7oahkxvsgCgDtrG@kroah.com>
Date:   Mon, 23 Nov 2020 13:40:08 +1100
Message-ID: <87lfeshk3b.fsf@dja-thinkpad.axtens.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi,
>> Build results:
>> 	total: 165 pass: 164 fail: 1
>> Failed builds:
>> 	powerpc:ppc64e_defconfig
>> Qemu test results:
>> 	total: 328 pass: 323 fail: 5
>> Failed tests:
>> 	ppc64:ppce500:corenet64_smp_defconfig:e5500:initrd
>> 	ppc64:ppce500:corenet64_smp_defconfig:e5500:nvme:rootfs
>> 	ppc64:ppce500:corenet64_smp_defconfig:e5500:sdhci:mmc:rootfs
>> 	ppc64:ppce500:corenet64_smp_defconfig:e5500:scsi[53C895A]:rootfs
>> 	ppc64:ppce500:corenet64_smp_defconfig:e5500:sata-sii3112:rootfs=09
>>=20
>> Failure in all cases is:
>>=20
>> In file included from arch/powerpc/kernel/ppc_ksyms.c:10:0:
>> arch/powerpc/include/asm/book3s/64/kup-radix.h:11:29: error: redefinitio=
n of =E2=80=98allow_user_access=E2=80=99
>>  static __always_inline void allow_user_access(void __user *to, const vo=
id __user *from,
>>                              ^~~~~~~~~~~~~~~~~
>> In file included from arch/powerpc/include/asm/uaccess.h:12:0,
>>                  from arch/powerpc/kernel/ppc_ksyms.c:8:
>> arch/powerpc/include/asm/kup.h:12:20: note: previous definition of =E2=
=80=98allow_user_access=E2=80=99 was here
>>  static inline void allow_user_access(void __user *to, const void __user=
 *from,
>>                     ^~~~~~~~~~~~~~~~~
>> In file included from arch/powerpc/kernel/ppc_ksyms.c:10:0:
>> arch/powerpc/include/asm/book3s/64/kup-radix.h:16:20: error: redefinitio=
n of =E2=80=98prevent_user_access=E2=80=99
>>  static inline void prevent_user_access(void __user *to, const void __us=
er *from,
>>                     ^~~~~~~~~~~~~~~~~~~
>> In file included from arch/powerpc/include/asm/uaccess.h:12:0,
>>                  from arch/powerpc/kernel/ppc_ksyms.c:8:
>> arch/powerpc/include/asm/kup.h:14:20: note: previous definition of =E2=
=80=98prevent_user_access=E2=80=99 was here
>>  static inline void prevent_user_access(void __user *to, const void __us=
er *from,
>>                     ^~~~~~~~~~~~~~~~~~~
>>=20
>> Tested-by: Guenter Roeck <linux@roeck-us.net>
>
> Thanks for testing these.
>
> Daniel, looks like your patches broke some configurations on powerpc as
> shown above.  Care to send a fix-up patch for these?

Will do. I tested ppc64e_defconfig but clearly that wasn't comprehensive
enough.

Kind regards,
Daniel

