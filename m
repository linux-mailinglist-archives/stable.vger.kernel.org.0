Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E6E4E307351
	for <lists+stable@lfdr.de>; Thu, 28 Jan 2021 11:02:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231386AbhA1KBB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 28 Jan 2021 05:01:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41790 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229834AbhA1KA6 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 28 Jan 2021 05:00:58 -0500
Received: from mail-qk1-x731.google.com (mail-qk1-x731.google.com [IPv6:2607:f8b0:4864:20::731])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A259FC061573;
        Thu, 28 Jan 2021 02:00:16 -0800 (PST)
Received: by mail-qk1-x731.google.com with SMTP id d85so4672549qkg.5;
        Thu, 28 Jan 2021 02:00:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:mail-followup-to:references
         :mime-version:content-disposition:in-reply-to;
        bh=AWc8KbESS9mJ8p+tOqaI0aagaEEXTN59mONEsTPgI6U=;
        b=NDghICO8DfPgv8VUAnSiBvdZJp8JxmGDVRBi/G5QMGSQP4B2pBbFZcz/RTSNaIecNe
         hrHAYz149B3G8ACoDK6IUrj/x9YoCn60aHtdY6mMVT30Qy4lMEt0pFWJKQN48pwbBjEI
         eGHhswtmEjkJVhAM6XDnsQ48cpQXM0sjlQ8OuM55F6imVM1o/+f52u8fHVxKRHCMsA5I
         mHEpDQzGF97XNPwN1dGKBe9yXlcLXY1ne8jsCOmuTIqrCmM8BS5AfbPMLz2I1gVW1zyj
         GzvsCRbtDxjGl4oj/pCm1O7ID8vO270n/CiSkDH6fZlSODK5+C5FoWaEUro+0YUMk878
         lFmg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id
         :mail-followup-to:references:mime-version:content-disposition
         :in-reply-to;
        bh=AWc8KbESS9mJ8p+tOqaI0aagaEEXTN59mONEsTPgI6U=;
        b=T9/GJkpP4FN+ruAX2zXZ+KoH8WvV4TLJTsSaGrnXxOiTkGnhQhwizL7Ia5THmg7pOD
         iWHD28H5fal4uucbgtCjfBQFS/pBDyEvAWBYA3si7Vuj1rQiTyWtbGAmXd1C+SHlFdYI
         iNdtF473vI0VXIdQ/Bj6RIM1Q0LUqkkLMjyxbr6fYyrpLYkaIApUFqFClpvjxtDt6L8I
         BEAAw7Oi342B7xVMTJwsOIbFsyiScBNJFfnbjEMgcX6AW+XWaKYEUrZPUBGPPdAMQfh7
         TbR2LnQneCsFBMq2dLGJAx9alKgqQuZ78gqTrAb6Cbww1NVKWEXhgC0iusjJb7Hfk58Z
         gglw==
X-Gm-Message-State: AOAM531YYTozpCkOve5itiYZ6WPvPLbFPFtdHkjFWF+h3Gyuh0+xy4vp
        PLcxjDKoBbtQ6VS/zBpGhvc=
X-Google-Smtp-Source: ABdhPJyDLw4SI4XFY0fuwJsD3kQhk2FdNL0BBjHu6yEYxvR4EfThLfIvjHGfOi3SBepy1kOipT6P1A==
X-Received: by 2002:a37:79c1:: with SMTP id u184mr14371545qkc.313.1611828015894;
        Thu, 28 Jan 2021 02:00:15 -0800 (PST)
Received: from Slackware ([156.146.37.144])
        by smtp.gmail.com with ESMTPSA id d26sm2923152qtw.58.2021.01.28.02.00.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 28 Jan 2021 02:00:14 -0800 (PST)
Date:   Thu, 28 Jan 2021 15:30:08 +0530
From:   Bhaskar Chowdhury <unixbhaskar@gmail.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     Chris Clayton <chris2553@googlemail.com>,
        LKML <linux-kernel@vger.kernel.org>, stable@vger.kernel.org
Subject: Re: linux-5.10.11 build failure
Message-ID: <YBKLKEixoQ0sQ7yE@Slackware>
Mail-Followup-To: Bhaskar Chowdhury <unixbhaskar@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Chris Clayton <chris2553@googlemail.com>,
        LKML <linux-kernel@vger.kernel.org>, stable@vger.kernel.org
References: <f141f12d-a5b9-1e60-2740-388bf350b631@googlemail.com>
 <YBKFNUp5WYtdg9pE@kroah.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="bjpLAQC8R0vB0uWs"
Content-Disposition: inline
In-Reply-To: <YBKFNUp5WYtdg9pE@kroah.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--bjpLAQC8R0vB0uWs
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On 10:34 Thu 28 Jan 2021, Greg Kroah-Hartman wrote:
>On Thu, Jan 28, 2021 at 09:17:10AM +0000, Chris Clayton wrote:
>> Hi,
>>
>> Building 5.10.11 fails on my (x86-64) laptop thusly:
>>
>> ..
>>
>>  AS      arch/x86/entry/thunk_64.o
>>   CC      arch/x86/entry/vsyscall/vsyscall_64.o
>>   AS      arch/x86/realmode/rm/header.o
>>   CC      arch/x86/mm/pat/set_memory.o
>>   CC      arch/x86/events/amd/core.o
>>   CC      arch/x86/kernel/fpu/init.o
>>   CC      arch/x86/entry/vdso/vma.o
>>   CC      kernel/sched/core.o
>> arch/x86/entry/thunk_64.o: warning: objtool: missing symbol for insn at =
offset 0x3e
>>
>>   AS      arch/x86/realmode/rm/trampoline_64.o
>> make[2]: *** [scripts/Makefile.build:360: arch/x86/entry/thunk_64.o] Err=
or 255
>> make[2]: *** Deleting file 'arch/x86/entry/thunk_64.o'
>> make[2]: *** Waiting for unfinished jobs....
>>
>> ..
>>
>> Compiler is latest snapshot of gcc-10.
>>
>> Happy to test the fix but please cc me as I'm not subscribed
>
>Can you do 'git bisect' to track down the offending commit?
>
>And what exact gcc version are you using?
>
>thanks,
>
>greg k-h


Okay, as far as the kernel goes ...I have built the 5.10.11 kernel on 5
different distros (Gentoo, Slackware, Debian, Arch and Opensuse-Tumbleweed)
=66rom yesterday ...simple compile with little option tweak ..nothing break=
s.

Probably, good fortune of mine! :)

There is "Pathetically and awfully wrote" mundane bash script do the stuff =
for
me.

~Bhaskar

--bjpLAQC8R0vB0uWs
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCAAdFiEEnwF+nWawchZUPOuwsjqdtxFLKRUFAmASiyEACgkQsjqdtxFL
KRU17wf/aRSM/AD753wdS+W0ObBQAikcF0ATHiLCBznJoj8cNQpMFN0ItNv8ejHS
FmjLTkuBVxjbyRePHPDm65YHwIAK3zLPTe+qh+7xx/nuLnkp12bwcv0wh9fdHYcz
CO8vdYvoFg+dly6qZyz5HPIfERby/2J2J35B0aFiE2ATx4zXwRiX7X6PJfLdNMML
Nwe/pbNhYtiJArWYaIIqFgMXw1Tpwb5LP7kzyWf9eCtUOdr4YRkmIKu6mROj5ev9
YkBIeB8FtmMfg9lYE4/K5NKcpByA6ityAgSRGPiY7wwrcGUg1Ns9LtFqQW8C5xgP
ksp3BlMJ5esLaWXaXE/wjiv5INUQQg==
=t+8H
-----END PGP SIGNATURE-----

--bjpLAQC8R0vB0uWs--
