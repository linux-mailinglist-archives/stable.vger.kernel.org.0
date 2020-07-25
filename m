Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9D8B222D57C
	for <lists+stable@lfdr.de>; Sat, 25 Jul 2020 08:27:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726704AbgGYG1O (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 25 Jul 2020 02:27:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54990 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725941AbgGYG1M (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 25 Jul 2020 02:27:12 -0400
Received: from mail-lj1-x241.google.com (mail-lj1-x241.google.com [IPv6:2a00:1450:4864:20::241])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 06820C0619D3;
        Fri, 24 Jul 2020 23:27:11 -0700 (PDT)
Received: by mail-lj1-x241.google.com with SMTP id q6so12089392ljp.4;
        Fri, 24 Jul 2020 23:27:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:from:to:cc:subject:in-reply-to:references:date:message-id
         :mime-version;
        bh=DZbwfaEBRgiNSMLmB+hmno1nnRXEndqEiTZ6s1uNVWA=;
        b=d+50j1+WY9qofRIynl4xXCtSqf4lbZqs2QvGXmWy1yNOKk7PcYouf3qQ9OCRyyyxoA
         MG2wzbXD7NIhZFYJOWphWI7XJZD+ki2E7v8FpkAaVNUTzk5abtGDkDJiYBqlD3NtIUcs
         NdMiFGU018FVXkwJYEy8D57xpkJTp/sUgbSE1MdAXFfptQ0MzDFbrm/oWmD0pVxyn264
         YNOW1IWPmY1zK/MG3uzNxCbX8bczVbtMm2HMkmWMj7ptbM2xind8GgGl501wnvRDmv1t
         P6AOp0ZBYCHBB87dzKISg7qOiKVSakDPtT0fr21iddXHlTyl1E/d3cKDT3+nRckSqDv3
         Q0jw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:from:to:cc:subject:in-reply-to:references
         :date:message-id:mime-version;
        bh=DZbwfaEBRgiNSMLmB+hmno1nnRXEndqEiTZ6s1uNVWA=;
        b=IedkLzc/FyGzSCRstAKwNUSohmTaHsKNPHhQt64FfsnAEdgpdxH75O43TdIAhiD1IS
         lgGjtDysGO9oPnIp7wSpYkC3h5LjiSiT8J+KvKpiatMbGwZYEUkka8+bi1qg8wiu3OQ8
         0EtHSUDwUK0X3j1VpItXBGd665DChGpGfFysNWakLOLr+Gc/PfqrrCSPVHcOgbYGmnb5
         p0LnzMBcVDB0JLv3FXGx3pYH33VEUeoo8OW39Zwv+1Rw35ZviiMpcgx2RipJ2KdO8Ek+
         EfRJ4vjR204FVJwGTJujh5yE2FCnjT9ecZ02WEu4PdMkQybv0v1RB5AmjcaqUwza4l/v
         npQg==
X-Gm-Message-State: AOAM533vD32pYpkd7EcceeEt8vrL+uIKlnG0uHPpMLzaRoxRhIqhUDf1
        X3vwGed7ZtQK+AVKKMgD7fMQoggkevA=
X-Google-Smtp-Source: ABdhPJw7x01MBJZlxXTgZ/4GAEJs0iC4GA2rkvNB4Ni5qLBSZN1ej2FVug39LJfQnGTgwJG9pcl5Zw==
X-Received: by 2002:a2e:5cc6:: with SMTP id q189mr5431938ljb.251.1595658430105;
        Fri, 24 Jul 2020 23:27:10 -0700 (PDT)
Received: from saruman (91-155-214-58.elisa-laajakaista.fi. [91.155.214.58])
        by smtp.gmail.com with ESMTPSA id v18sm979479lfd.78.2020.07.24.23.27.09
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Fri, 24 Jul 2020 23:27:09 -0700 (PDT)
From:   Felipe Balbi <balbi@kernel.org>
To:     Nathan Chancellor <natechancellor@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     Minas Harutyunyan <hminas@synopsys.com>,
        Felipe Balbi <felipe.balbi@linux.intel.com>,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        clang-built-linux@googlegroups.com, stable@vger.kernel.org
Subject: Re: [PATCH] usb: dwc2: Fix parameter type in function pointer prototype
In-Reply-To: <20200725062359.GA457524@ubuntu-n2-xlarge-x86>
References: <20200725060354.177009-1-natechancellor@gmail.com> <20200725061947.GA1051290@kroah.com> <20200725062359.GA457524@ubuntu-n2-xlarge-x86>
Date:   Sat, 25 Jul 2020 09:27:05 +0300
Message-ID: <87imecnm86.fsf@kernel.org>
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


Hi,

Nathan Chancellor <natechancellor@gmail.com> writes:

> On Sat, Jul 25, 2020 at 08:19:47AM +0200, Greg Kroah-Hartman wrote:
>> On Fri, Jul 24, 2020 at 11:03:54PM -0700, Nathan Chancellor wrote:
>> > When booting up on a Raspberry Pi 4 with Control Flow Integrity checki=
ng
>> > enabled, the following warning/panic happens:
>> >=20
>> > [    1.626435] CFI failure (target: dwc2_set_bcm_params+0x0/0x4):
>> > [    1.632408] WARNING: CPU: 0 PID: 32 at kernel/cfi.c:30 __cfi_check_=
fail+0x54/0x5c
>> > [    1.640021] Modules linked in:
>> > [    1.643137] CPU: 0 PID: 32 Comm: kworker/0:1 Not tainted 5.8.0-rc6-=
next-20200724-00051-g89ba619726de #1
>> > [    1.652693] Hardware name: Raspberry Pi 4 Model B Rev 1.2 (DT)
>> > [    1.658637] Workqueue: events deferred_probe_work_func
>> > [    1.663870] pstate: 60000005 (nZCv daif -PAN -UAO BTYPE=3D--)
>> > [    1.669542] pc : __cfi_check_fail+0x54/0x5c
>> > [    1.673798] lr : __cfi_check_fail+0x54/0x5c
>> > [    1.678050] sp : ffff8000102bbaa0
>> > [    1.681419] x29: ffff8000102bbaa0 x28: ffffab09e21c7000
>> > [    1.686829] x27: 0000000000000402 x26: ffff0000f6e7c228
>> > [    1.692238] x25: 00000000fb7cdb0d x24: 0000000000000005
>> > [    1.697647] x23: ffffab09e2515000 x22: ffffab09e069a000
>> > [    1.703055] x21: 4c550309df1cf4c1 x20: ffffab09e2433c60
>> > [    1.708462] x19: ffffab09e160dc50 x18: ffff0000f6e8cc78
>> > [    1.713870] x17: 0000000000000041 x16: ffffab09e0bce6f8
>> > [    1.719278] x15: ffffab09e1c819b7 x14: 0000000000000003
>> > [    1.724686] x13: 00000000ffffefff x12: 0000000000000000
>> > [    1.730094] x11: 0000000000000000 x10: 00000000ffffffff
>> > [    1.735501] x9 : c932f7abfc4bc600 x8 : c932f7abfc4bc600
>> > [    1.740910] x7 : 077207610770075f x6 : ffff0000f6c38f00
>> > [    1.746317] x5 : 0000000000000000 x4 : 0000000000000000
>> > [    1.751723] x3 : 0000000000000000 x2 : 0000000000000000
>> > [    1.757129] x1 : ffff8000102bb7d8 x0 : 0000000000000032
>> > [    1.762539] Call trace:
>> > [    1.765030]  __cfi_check_fail+0x54/0x5c
>> > [    1.768938]  __cfi_check+0x5fa6c/0x66afc
>> > [    1.772932]  dwc2_init_params+0xd74/0xd78
>> > [    1.777012]  dwc2_driver_probe+0x484/0x6ec
>> > [    1.781180]  platform_drv_probe+0xb4/0x100
>> > [    1.785350]  really_probe+0x228/0x63c
>> > [    1.789076]  driver_probe_device+0x80/0xc0
>> > [    1.793247]  __device_attach_driver+0x114/0x160
>> > [    1.797857]  bus_for_each_drv+0xa8/0x128
>> > [    1.801851]  __device_attach.llvm.14901095709067289134+0xc0/0x170
>> > [    1.808050]  bus_probe_device+0x44/0x100
>> > [    1.812044]  deferred_probe_work_func+0x78/0xb8
>> > [    1.816656]  process_one_work+0x204/0x3c4
>> > [    1.820736]  worker_thread+0x2f0/0x4c4
>> > [    1.824552]  kthread+0x174/0x184
>> > [    1.827837]  ret_from_fork+0x10/0x18
>> >=20
>> > CFI validates that all indirect calls go to a function with the same
>> > exact function pointer prototype. In this case, dwc2_set_bcm_params
>> > is the target, which has a parameter of type 'struct dwc2_hsotg *',
>> > but it is being implicitly cast to have a parameter of type 'void *'
>> > because that is the set_params function pointer prototype. Make the
>> > function pointer protoype match the definitions so that there is no
>> > more violation.
>> >=20
>> > Cc: stable@vger.kernel.org
>>=20
>> Why does this matter for stable kernels, given that CFI is not in any
>> kernel tree yet?
>>=20
>> thanks,
>>=20
>> greg k-h
>
> It might not be available upstream but it is in all downstream Android
> kernels. Furthermore, all of the previous CFI fixes I have done have

If we were to accept patches in stable because some downstream kernel
needs it even though the feature isn't in upstream, Greg would have a
hard time sorting through all the patches :-)

I think this falls into the category of "downstream folks can manually
pick this into their tree".

> inevitably ended up in stable trees through AUTOSEL, I figured I would
> save Sasha the hassle this time around. It does not personally matter to
> me though, I am fine with stripping the tag since I do all of my
> personal testing with mainline/next so if this is needed in stable
> later due to an OEM or someone else tripping over it, it can just be
> added then.

Makes sense to me, thanks :-)

> Let me know if you want me to resend it without that tag.

Just applied to my testing/next without the stable tag.

=2D-=20
balbi

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEElLzh7wn96CXwjh2IzL64meEamQYFAl8b0LkACgkQzL64meEa
mQb3Gw//dPZkYuwQTjzlFIZkGW8I1fmmACKfqLeZm5IwJYBiunC6jhI5cHRIXu5t
7Ph+4jZXQ4jicZ55tDaP4U8OWNN4Nk3UAA8REoroPcL6SYAp8AO1y1N9YCV6V2Sl
tA+WMDvg6guczv/sWObvnl1p9lBDKStgp2UIGBnYUKFpcOdFV+B4g1Osngi/MI9r
AnDHGFSBLtxp/WK6ZLnpI1IQaZiM+1l3/xtmrwv0wWqPCFhBHlXACevqENumBgDD
YLLOnH+66wwrK9mUwB252KhSK9PpjQphFSIiKbjJ5MmkXbUsBHocOQw4IyxksxAf
vnUA5KXzcgeGHQLGfnmZlPg9ZOEPk0VxBmXLIPkmtX+MMgASMh3Xb+NpNXWxnPMk
53OFmWpsN0AjPHjuIQlsFTeCKHZo4mbJhBQ0XhBjdc/vE70IFBsahuyHUmI/fJKo
mb5wzJFuQ6apfN9nV+YQV+bRIn8B1uJXFkOU6++I/TR7mHi4HaBSTsgL+BL3bjnp
ev3l7nng4tWNjRdNytfJ4eeyr9dIOHRcgRo9WFYRg8EbmdXlWRTioIVbDT7LaYMg
8TcD6dq6Gh0NN2JOj08iHANaUZS+dfqPhlcRekIO8T/oewjKZ8MDGTXBDZ/pT3AD
O0SRUobEKZJrxBR/DNzjkEB2ISDGhOb8mMmNJcRATzLrg9HF8Hg=
=LQjU
-----END PGP SIGNATURE-----
--=-=-=--
