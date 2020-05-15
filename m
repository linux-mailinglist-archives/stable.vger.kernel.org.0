Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E45C51D5A0A
	for <lists+stable@lfdr.de>; Fri, 15 May 2020 21:31:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726278AbgEOTbg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 15 May 2020 15:31:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53996 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726179AbgEOTbf (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 15 May 2020 15:31:35 -0400
Received: from mail-qk1-x743.google.com (mail-qk1-x743.google.com [IPv6:2607:f8b0:4864:20::743])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7D79DC061A0C;
        Fri, 15 May 2020 12:31:35 -0700 (PDT)
Received: by mail-qk1-x743.google.com with SMTP id m11so3823266qka.4;
        Fri, 15 May 2020 12:31:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=XJjN9ibCXjp8K2HY3J5E9z/6bT2jdDqqJ0d/+XKG9vQ=;
        b=dniOoFPQ7c23DT0Afwm9JEgn5XBiD0MJ6h8KMbkYTI2vePpgSgYxFiCsNpgfUpD/O6
         /rPMY15dxsJDreh7z1tApov7yco37WRK33EXdqo1IM6Df6+d/PJUFGJ0fBspixOPu+rz
         tO4QBg7bXoah+t9Cpn78a0cdMjTn0qT6dgk1N1NLQleLjrs1ksXXw9tnZehLM5PjgTOA
         jQiYcFOObFtTrsjB01d9DqG5m/Sa19um8Q9N4g9fPFeXX3z7K4aaxX5FycDcNoQ9r8SO
         ztd1mP9hNc8YkHed17zrzuacSBmGVeceQCR7s25mcn1xx/wv95/JSmcj5zxCEEk5jiQ7
         jZNA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=XJjN9ibCXjp8K2HY3J5E9z/6bT2jdDqqJ0d/+XKG9vQ=;
        b=nnjVMzkcLyBTJYJ8bJfTp55BPHyGmXTy9qfxWfO+GqlwPHnbXlUU4oQj/IMyzQtaM5
         /NfFgK+uK+RdndN6XEGZRTarjCIHNjS5bLmfgVaf1/5ON2Z9M35w3dXXmf3aQ8UUqI+T
         LwrMxP8qZr9nKz/F7ub2oSHTlGi43vT9N/A9k/0p1Bf3vTL7FiAjjLs5uZjk2l4tsJVK
         +bzkeP00ZJl6sM3O52JmOGOoHpymmbKGEGF8e1qKawZkfKDhp64/ppY+Ai0J2sgdjRhW
         HGuCVAWzPTE0Ua7h51gfbqIrasU8fCJP05z58Rm7uOz7as86CcsAqeI31/4xGaq9u1ez
         4+9g==
X-Gm-Message-State: AOAM533/rkLP/oRDe76xQbpoIqyohD8YRTJWqB/q+/4FWxZliZCFgX4U
        EQ7WwYYetcSVGA4zm+poWNiTTOs6nDFS3YN06cLGNVNz
X-Google-Smtp-Source: ABdhPJyNd96eqdXCuPIJTJrA0VIMk25vj1mM6UXo2olVu2fQHh+J16P1s2owxUvMvoj4fJ7NCubDvksDmfQTNsZnEHU=
X-Received: by 2002:a05:620a:2049:: with SMTP id d9mr5424186qka.449.1589571093217;
 Fri, 15 May 2020 12:31:33 -0700 (PDT)
MIME-Version: 1.0
References: <20200513074418.GE17565@shao2-debian> <20200513095835.GD102436@dhcp-12-153.nay.redhat.com>
 <20200513102634.GC871114@kroah.com> <20200514031420.GE102436@dhcp-12-153.nay.redhat.com>
 <20200514103017.GA1829391@kroah.com> <e5221ecb-04ad-bc77-d66f-b438c1a8b5c7@fb.com>
 <20200515085459.GH1474499@kroah.com>
In-Reply-To: <20200515085459.GH1474499@kroah.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Fri, 15 May 2020 12:31:21 -0700
Message-ID: <CAEf4Bza-9VcabritwoOn1MB98BOopBM9VtRiHu01zBjPJ9w7Sw@mail.gmail.com>
Subject: Re: [selftests/bpf] da43712a72: kernel-selftests.bpf.make_fail
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     Andrii Nakryiko <andriin@fb.com>,
        Hangbin Liu <liuhangbin@gmail.com>,
        linux- stable <stable@vger.kernel.org>, lkp@lists.01.org,
        bpf <bpf@vger.kernel.org>,
        kernel test robot <rong.a.chen@intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, May 15, 2020 at 1:55 AM Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> On Thu, May 14, 2020 at 11:38:27AM -0700, Andrii Nakryiko wrote:
> > On 5/14/20 3:30 AM, Greg Kroah-Hartman wrote:
> > > On Thu, May 14, 2020 at 11:14:20AM +0800, Hangbin Liu wrote:
> > > > On Wed, May 13, 2020 at 12:26:34PM +0200, Greg Kroah-Hartman wrote:
> > > > > On Wed, May 13, 2020 at 05:58:35PM +0800, Hangbin Liu wrote:
> > > > > >
> > > > > > Thanks test bot catch the issue.
> > > > > > On Wed, May 13, 2020 at 03:44:18PM +0800, kernel test robot wro=
te:
> > > > > > > Greeting,
> > > > > > >
> > > > > > > FYI, we noticed the following commit (built with gcc-7):
> > > > > > >
> > > > > > > commit: 77bb53cb094828a31cd3c5b402899810f63073c1 ("selftests/=
bpf: Fix perf_buffer test on systems w/ offline CPUs")
> > > > > > > https://git.kernel.org/cgit/linux/kernel/git/stable/linux-sta=
ble-rc.git linux-5.4.y
> > > > > >
> > > > > > The author for this commit is Andrii(cc'd).
> > > > > >
> > > > > > Mine is f1c3656c6d9c ("selftests/bpf: Skip perf hw events test =
if the setup disabled it")
> > > > > > > prog_tests/stacktrace_build_id_nmi.c:55:3: error: label =E2=
=80=98cleanup=E2=80=99 used but not defined
> > > > > > >     goto cleanup;
> > > > > > >     ^~~~
> > > > > >
> > > > > > Hi Greg, we are missing a depend commit
> > > > > > dde53c1b763b ("selftests/bpf: Convert few more selftest to skel=
etons").
> > > > > >
> > > > > > So either we need backport this patch, or if you like, we can a=
lso fix it by
> > > > > > changing 'goto cleanup;' to 'goto close_prog;'. So which one do=
 you prefer?
> >
> > Hi, sorry for late reply, missed emails earlier.
> >
> > The above "selftest to skeletons" commit will need some more after that=
,
> > it's going to be a pretty big back-port, so I think just fixing it up w=
ould
> > be ok.
> >
> > > > >
> > > > > I don't know, I have no context here at all, sorry.
> > > > >
> > > > > What stable kernel tree is failing, what patch needs to be change=
d, what
> > > > > patch caused this, and so on...
> > > > >
> > > > > confused,
> > > >
> > > > Oh, sorry, I should reply the full email. I will forward the full m=
essage in
> > > > the bellow. For your questions:
> > > >
> > > > the stable kernel tree is linux-5.4.y,
> > > > my patch is da43712a7262 ("selftests/bpf: Skip perf hw events test =
if the
> > > > setup disabled it")[1].
> > > >
> > > > The reason is we are lacking upstream commit
> > > > dde53c1b763b ("selftests/bpf: Convert few more selftest to skeleton=
s").
> > > >
> > > > This will call build warning
> > > > prog_tests/stacktrace_build_id_nmi.c:55:3: error: label =E2=80=98cl=
eanup=E2=80=99 used but not defined
> > > >     goto cleanup;
> > > >     ^~~~
> > > >
> > > > To fix it, I think the easiest way is change the "goto cleanup" to =
"goto
> > > > close_prog".
> > >
> > > Ok, can you send a patch for this, documenting all of the above so I
> > > know what's going on?
> > >
> > > > For the other error:
> > > >
> > > > prog_tests/perf_buffer.c: In function =E2=80=98test_perf_buffer=E2=
=80=99:
> > > > prog_tests/perf_buffer.c:39:8: warning: implicit declaration of fun=
ction =E2=80=98parse_cpu_mask_file=E2=80=99 [-Wimplicit-function-declaratio=
n]
> > > >    err =3D parse_cpu_mask_file("/sys/devices/system/cpu/online",
> > > >          ^~~~~~~~~~~~~~~~~~~
> > > > ../lib.mk:138: recipe for target '/usr/src/perf_selftests-x86_64-rh=
el-7.6-kselftests-da43712a7262891317883d4b3a909fb18dac4b1d/tools/testing/se=
lftests/bpf/test_progs' failed
> > > > make: *** [/usr/src/perf_selftests-x86_64-rhel-7.6-kselftests-da437=
12a7262891317883d4b3a909fb18dac4b1d/tools/testing/selftests/bpf/test_progs]=
 Error 1
> > > > make: Leaving directory '/usr/src/perf_selftests-x86_64-rhel-7.6-ks=
elftests-da43712a7262891317883d4b3a909fb18dac4b1d/tools/testing/selftests/b=
pf'
> > > >
> > > > I think Andrii may like help.
> > >
> > > That looks like a bug, we should revert the offending patch, right?
> >
> > 6803ee25f0ea ("libbpf: Extract and generalize CPU mask parsing logic") =
added
> > parse_cpu_mask_file() function, so back-porting that commit should solv=
e
> > this? It should be straightforward and shouldn't bring any more depende=
nt
> > commits.
>
> As this does not apply cleanly, can you provide a working backport so
> that I can apply that?

Sure, will do.

>
> tahnks,
>
> greg k-h
