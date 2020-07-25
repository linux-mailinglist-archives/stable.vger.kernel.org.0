Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DF05B22D578
	for <lists+stable@lfdr.de>; Sat, 25 Jul 2020 08:24:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726717AbgGYGYt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 25 Jul 2020 02:24:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54618 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725941AbgGYGYt (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 25 Jul 2020 02:24:49 -0400
Received: from mail-lj1-x244.google.com (mail-lj1-x244.google.com [IPv6:2a00:1450:4864:20::244])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A3CFCC0619D3;
        Fri, 24 Jul 2020 23:24:48 -0700 (PDT)
Received: by mail-lj1-x244.google.com with SMTP id d17so12092699ljl.3;
        Fri, 24 Jul 2020 23:24:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:from:to:cc:subject:in-reply-to:references:date:message-id
         :mime-version;
        bh=bDN8VcCw6Y6mP0rf5Aftyr2APB1lxp7tkcQtR3vKdhY=;
        b=gi/r339olVEMPoB3JaJYhMUW6YKPV9VbrgMWA6MvEdrYt6zZhEceI+ngUAkenl3GQW
         je//Gzdn3xC+FGOYm34nout4gxuxeTHfv29h5WMXeJQ5gwjGzCGRQet8IXbBpWY79RPi
         eVpDpfgRO6Z50wFaS3tF1JeyQI/6dvghY/KNzmiMMDPAb7kwGiReSG0sVU6bZQZX3MEk
         KH/jSvep61EgS6R2akpw9z2k6WKaIwGQqUqzuaxQpspLOaHAZRhvYusUKdpbKw5vMQus
         6XLRB45o/CejKGpt0vCjxpYelFWFUNkLUjkpH78O2Xjyili+wBPnr9iEUlBnJImY/dx+
         OPjQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:from:to:cc:subject:in-reply-to:references
         :date:message-id:mime-version;
        bh=bDN8VcCw6Y6mP0rf5Aftyr2APB1lxp7tkcQtR3vKdhY=;
        b=hCb55DKsMg9R7L3eLD+uGrPCqykKdksLpZZJvueGPFcujE3fHLbULQfb0DG5pIIm0R
         iQPoMvRLEMSzdVH1oxZTF3n2y1Z2W2qmgTRMigT3IN/n5C0EWq0OCGUt04BVSFlMz0Ed
         Ru4hW34fRk/2IQf5Wpdj2DYCC6/NJQWszdEWEQwqCicZ3YQYAqIho6GiBVmC1RTsKU0m
         cflja+A/LhK7ZG6OTXIEc3bFwTnIOEemyL+z5QEO7xpA6WIoDqF3DeYmR8bn2w7Q7XYk
         o1Gw8e9c4bV0toBCAavfu2huQiC0nzU4jafmvI9vGAowdE46tttWhc9x+Oj1qqTfP/s5
         f6sg==
X-Gm-Message-State: AOAM5322QM50IbdRUjY08X0zrhS7wF0o1kxSqQBV2ddzKtiiMVvF7oK9
        NllpLp8p0MdyVceXXEjX05pyZKLQroE=
X-Google-Smtp-Source: ABdhPJzoI8asbzhUWDHE11R1MA0uSK1CxRSOKgVipCqfAKNrrdUqapsDKmzK/UA6jKpomxdF3o39PA==
X-Received: by 2002:a2e:160f:: with SMTP id w15mr6083786ljd.28.1595658286903;
        Fri, 24 Jul 2020 23:24:46 -0700 (PDT)
Received: from saruman (91-155-214-58.elisa-laajakaista.fi. [91.155.214.58])
        by smtp.gmail.com with ESMTPSA id c4sm1102567lfs.27.2020.07.24.23.24.45
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Fri, 24 Jul 2020 23:24:46 -0700 (PDT)
From:   Felipe Balbi <balbi@kernel.org>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Nathan Chancellor <natechancellor@gmail.com>
Cc:     Minas Harutyunyan <hminas@synopsys.com>,
        Felipe Balbi <felipe.balbi@linux.intel.com>,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        clang-built-linux@googlegroups.com, stable@vger.kernel.org
Subject: Re: [PATCH] usb: dwc2: Fix parameter type in function pointer prototype
In-Reply-To: <20200725061947.GA1051290@kroah.com>
References: <20200725060354.177009-1-natechancellor@gmail.com> <20200725061947.GA1051290@kroah.com>
Date:   Sat, 25 Jul 2020 09:24:42 +0300
Message-ID: <87lfj8nmc5.fsf@kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
        micalg=pgp-sha256; protocol="application/pgp-signature"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

--=-=-=
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

Greg Kroah-Hartman <gregkh@linuxfoundation.org> writes:

> On Fri, Jul 24, 2020 at 11:03:54PM -0700, Nathan Chancellor wrote:
>> When booting up on a Raspberry Pi 4 with Control Flow Integrity checking
>> enabled, the following warning/panic happens:
>>=20
>> [    1.626435] CFI failure (target: dwc2_set_bcm_params+0x0/0x4):
>> [    1.632408] WARNING: CPU: 0 PID: 32 at kernel/cfi.c:30 __cfi_check_fa=
il+0x54/0x5c
>> [    1.640021] Modules linked in:
>> [    1.643137] CPU: 0 PID: 32 Comm: kworker/0:1 Not tainted 5.8.0-rc6-ne=
xt-20200724-00051-g89ba619726de #1
>> [    1.652693] Hardware name: Raspberry Pi 4 Model B Rev 1.2 (DT)
>> [    1.658637] Workqueue: events deferred_probe_work_func
>> [    1.663870] pstate: 60000005 (nZCv daif -PAN -UAO BTYPE=3D--)
>> [    1.669542] pc : __cfi_check_fail+0x54/0x5c
>> [    1.673798] lr : __cfi_check_fail+0x54/0x5c
>> [    1.678050] sp : ffff8000102bbaa0
>> [    1.681419] x29: ffff8000102bbaa0 x28: ffffab09e21c7000
>> [    1.686829] x27: 0000000000000402 x26: ffff0000f6e7c228
>> [    1.692238] x25: 00000000fb7cdb0d x24: 0000000000000005
>> [    1.697647] x23: ffffab09e2515000 x22: ffffab09e069a000
>> [    1.703055] x21: 4c550309df1cf4c1 x20: ffffab09e2433c60
>> [    1.708462] x19: ffffab09e160dc50 x18: ffff0000f6e8cc78
>> [    1.713870] x17: 0000000000000041 x16: ffffab09e0bce6f8
>> [    1.719278] x15: ffffab09e1c819b7 x14: 0000000000000003
>> [    1.724686] x13: 00000000ffffefff x12: 0000000000000000
>> [    1.730094] x11: 0000000000000000 x10: 00000000ffffffff
>> [    1.735501] x9 : c932f7abfc4bc600 x8 : c932f7abfc4bc600
>> [    1.740910] x7 : 077207610770075f x6 : ffff0000f6c38f00
>> [    1.746317] x5 : 0000000000000000 x4 : 0000000000000000
>> [    1.751723] x3 : 0000000000000000 x2 : 0000000000000000
>> [    1.757129] x1 : ffff8000102bb7d8 x0 : 0000000000000032
>> [    1.762539] Call trace:
>> [    1.765030]  __cfi_check_fail+0x54/0x5c
>> [    1.768938]  __cfi_check+0x5fa6c/0x66afc
>> [    1.772932]  dwc2_init_params+0xd74/0xd78
>> [    1.777012]  dwc2_driver_probe+0x484/0x6ec
>> [    1.781180]  platform_drv_probe+0xb4/0x100
>> [    1.785350]  really_probe+0x228/0x63c
>> [    1.789076]  driver_probe_device+0x80/0xc0
>> [    1.793247]  __device_attach_driver+0x114/0x160
>> [    1.797857]  bus_for_each_drv+0xa8/0x128
>> [    1.801851]  __device_attach.llvm.14901095709067289134+0xc0/0x170
>> [    1.808050]  bus_probe_device+0x44/0x100
>> [    1.812044]  deferred_probe_work_func+0x78/0xb8
>> [    1.816656]  process_one_work+0x204/0x3c4
>> [    1.820736]  worker_thread+0x2f0/0x4c4
>> [    1.824552]  kthread+0x174/0x184
>> [    1.827837]  ret_from_fork+0x10/0x18
>>=20
>> CFI validates that all indirect calls go to a function with the same
>> exact function pointer prototype. In this case, dwc2_set_bcm_params
>> is the target, which has a parameter of type 'struct dwc2_hsotg *',
>> but it is being implicitly cast to have a parameter of type 'void *'
>> because that is the set_params function pointer prototype. Make the
>> function pointer protoype match the definitions so that there is no
>> more violation.
>>=20
>> Cc: stable@vger.kernel.org
>
> Why does this matter for stable kernels, given that CFI is not in any
> kernel tree yet?

remove stable while applying to testing/next.

=2D-=20
balbi

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEElLzh7wn96CXwjh2IzL64meEamQYFAl8b0CoACgkQzL64meEa
mQbl2A/9FcHRXOjDIl2shSObm/ZhWLO5RHK5dNUeWzwC1oJKTZvpTfha2957bBv8
jZe5I3TcTc1D6hcqGPxyo+KXQW7oisebo+FXEUXBzYEVQ7bKXjVCpRPNUrcbm2OZ
kZjQj9hQfODzYXg2PffTZa7Qz+4U/NuVCzES+ag+y2It9MuV+uJVak+AiQKnIpmp
X+Hbte6OwLfzxgO6huTqUb16GVxM6AhOU4mu1iFN5HzqhhYDtVs8hzYA8vKkSzGP
vy/Yxp1YHaxIzYESwiH3fzBaHFlDnH49zy36mkQEq++gWvEqMhh/wmX8Im9a7sSb
S0aDeK2B9DNeh2or9g74iWJvExJh+ZzVHbnO5Kw0gH8KUU7b1LAsDSX1mh6o1AeD
uzKpe3TOXTh9z3VUhNckEIXeIKHG6RoB9WP+DJnzRS+ySmOYtDeCeM5VI0euO5E8
Y3SHO0CSghq2JoI/phqpxrm45AQmCqGqyB4162rO0rjkQi1xZmi+2i+akeYRCCnS
ZujfYT6bbK6z2tSBgtg5l1V12nf2m+m7f9xDFjQaG7j8oCZ9naDazGSPb2DnpZBf
kbnZua+ygYbzGwIO73fPrdUIXE3vZLiyWwTBOce1uJ3mdyvuAtKaani1j4awHirr
u0BKFkcaiAr1sHdedh1+QOKPDW3ks+nbUsJcZ4tcMb6It2bBXt0=
=Q70p
-----END PGP SIGNATURE-----
--=-=-=--
