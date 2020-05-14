Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 72A8D1D255A
	for <lists+stable@lfdr.de>; Thu, 14 May 2020 05:14:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725935AbgENDOf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 13 May 2020 23:14:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43104 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725895AbgENDOf (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 13 May 2020 23:14:35 -0400
Received: from mail-pl1-x635.google.com (mail-pl1-x635.google.com [IPv6:2607:f8b0:4864:20::635])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 17DD1C061A0C;
        Wed, 13 May 2020 20:14:35 -0700 (PDT)
Received: by mail-pl1-x635.google.com with SMTP id b12so610565plz.13;
        Wed, 13 May 2020 20:14:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to;
        bh=ZiFDZemJWUvCrGbh5fjSH969NCF+JsZh7E452B2MMTk=;
        b=pF/mU2k3Ma+5Rdn/lvv71bqB5S/QMBW4YpUVpruTwMkdlIXQz7HoUE+fUa2fR4BaXL
         pB6u92HV88pe9mmlEHBFoMMGKYEY6sUcxiwjHJmmp8+1TqkaWQ13PBsidcjw9yQHs0iT
         WKELdNBVJj+CU9PPx+9Haji98uZcNz6YXAH5Y7mEqyPSP1QM3/c3XxPEVqa/AMFoIPUH
         P/bQvkR53ZynFZMXwiX/5ynmpVWnLuMoQ2oJ1SjzdtCkNHj1XNfidcq8tHnFmReCFP7A
         5VyJc/SbpCNCzCHEKojb+TWk/FsSvp+CfzdmV9CEOv02A46N94x1RmnCm+mDZjw0Rvr9
         jsmg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=ZiFDZemJWUvCrGbh5fjSH969NCF+JsZh7E452B2MMTk=;
        b=irdFbYo0OL2xkWNc5tFj7dGyadHTUO4gd6e0c2MwRFIGtvv9yXnksCCWcK1P/WEA6Z
         0jY9E9l2RQPPSjLk1oiKXd6OPBI+E7DBO8vVNDaOXSIGFRQ/IzfbNdF87pKsIb/89ouq
         MnPChrynYZH6C/9BPMxCrhsKo6k5/LDZ/zQij8kpJ9kRGNMh62g9i6uY1iT1hJF9p7GE
         ni5efPDQydJDkBpnN5kOHBCq5tpzWLICTtOfwmZRsHprzZwP8dctQLJdIl0roB3oLMqI
         4K+G3UJFa7ZpGA+ye9wR/zOX91P7K6RL18uia8tIsrFL0KAIqlQZlH6LJ8yXbUDJI6YL
         jsiQ==
X-Gm-Message-State: AOAM532Qqahb9mUfYMaznrXT43056DPWl6IpNnJODKbNVovicAZEK3K9
        Bn1RUww8fWKnexoSH37OVr4=
X-Google-Smtp-Source: ABdhPJzzMR8CrxQDa+f3BkREH/tJCyGUHFPiKvBF1a2TRJRit8oeS9+a8ZfL3+HqM8OT4DhCeHLM7A==
X-Received: by 2002:a17:902:9882:: with SMTP id s2mr2110794plp.184.1589426072764;
        Wed, 13 May 2020 20:14:32 -0700 (PDT)
Received: from dhcp-12-153.nay.redhat.com ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id w30sm859532pfj.25.2020.05.13.20.14.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 13 May 2020 20:14:31 -0700 (PDT)
Date:   Thu, 14 May 2020 11:14:20 +0800
From:   Hangbin Liu <liuhangbin@gmail.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     Andrii Nakryiko <andriin@fb.com>, stable@vger.kernel.org,
        lkp@lists.01.org, bpf@vger.kernel.org,
        kernel test robot <rong.a.chen@intel.com>
Subject: Re: [selftests/bpf] da43712a72: kernel-selftests.bpf.make_fail
Message-ID: <20200514031420.GE102436@dhcp-12-153.nay.redhat.com>
References: <20200513074418.GE17565@shao2-debian>
 <20200513095835.GD102436@dhcp-12-153.nay.redhat.com>
 <20200513102634.GC871114@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable
In-Reply-To: <20200513102634.GC871114@kroah.com>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, May 13, 2020 at 12:26:34PM +0200, Greg Kroah-Hartman wrote:
> On Wed, May 13, 2020 at 05:58:35PM +0800, Hangbin Liu wrote:
> >=20
> > Thanks test bot catch the issue.
> > On Wed, May 13, 2020 at 03:44:18PM +0800, kernel test robot wrote:
> > > Greeting,
> > >=20
> > > FYI, we noticed the following commit (built with gcc-7):
> > >=20
> > > commit: 77bb53cb094828a31cd3c5b402899810f63073c1 ("selftests/bpf: Fix=
 perf_buffer test on systems w/ offline CPUs")
> > > https://git.kernel.org/cgit/linux/kernel/git/stable/linux-stable-rc.g=
it linux-5.4.y
> >=20
> > The author for this commit is Andrii(cc'd).
> >=20
> > Mine is f1c3656c6d9c ("selftests/bpf: Skip perf hw events test if the s=
etup disabled it")
> > > prog_tests/stacktrace_build_id_nmi.c:55:3: error: label =E2=80=98clea=
nup=E2=80=99 used but not defined
> > >    goto cleanup;
> > >    ^~~~
> >=20
> > Hi Greg, we are missing a depend commit
> > dde53c1b763b ("selftests/bpf: Convert few more selftest to skeletons").
> >=20
> > So either we need backport this patch, or if you like, we can also fix =
it by
> > changing 'goto cleanup;' to 'goto close_prog;'. So which one do you pre=
fer?
>=20
> I don't know, I have no context here at all, sorry.
>=20
> What stable kernel tree is failing, what patch needs to be changed, what
> patch caused this, and so on...
>=20
> confused,

Oh, sorry, I should reply the full email. I will forward the full message in
the bellow. For your questions:

the stable kernel tree is linux-5.4.y,
my patch is da43712a7262 ("selftests/bpf: Skip perf hw events test if the
setup disabled it")[1].

The reason is we are lacking upstream commit
dde53c1b763b ("selftests/bpf: Convert few more selftest to skeletons").

This will call build warning
prog_tests/stacktrace_build_id_nmi.c:55:3: error: label =E2=80=98cleanup=E2=
=80=99 used but not defined
   goto cleanup;
   ^~~~

To fix it, I think the easiest way is change the "goto cleanup" to "goto
close_prog".


For the other error:

prog_tests/perf_buffer.c: In function =E2=80=98test_perf_buffer=E2=80=99:
prog_tests/perf_buffer.c:39:8: warning: implicit declaration of function =
=E2=80=98parse_cpu_mask_file=E2=80=99 [-Wimplicit-function-declaration]
  err =3D parse_cpu_mask_file("/sys/devices/system/cpu/online",
        ^~~~~~~~~~~~~~~~~~~
=2E./lib.mk:138: recipe for target '/usr/src/perf_selftests-x86_64-rhel-7.6=
-kselftests-da43712a7262891317883d4b3a909fb18dac4b1d/tools/testing/selftest=
s/bpf/test_progs' failed
make: *** [/usr/src/perf_selftests-x86_64-rhel-7.6-kselftests-da43712a72628=
91317883d4b3a909fb18dac4b1d/tools/testing/selftests/bpf/test_progs] Error 1
make: Leaving directory '/usr/src/perf_selftests-x86_64-rhel-7.6-kselftests=
-da43712a7262891317883d4b3a909fb18dac4b1d/tools/testing/selftests/bpf'

I think Andrii may like help.

[1] https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.=
git/commit/?h=3Dlinux-5.4.y&id=3Dda43712a7262891317883d4b3a909fb18dac4b1d

Thanks
Hangbin


----- Forwarded message from kernel test robot <rong.a.chen@intel.com> -----

Date: Wed, 13 May 2020 15:44:18 +0800
=46rom: kernel test robot <rong.a.chen@intel.com>
To: Hangbin Liu <liuhangbin@gmail.com>
Cc: lkp@lists.01.org, bpf@vger.kernel.org
Subject: [selftests/bpf] da43712a72: kernel-selftests.bpf.make_fail

Greeting,

FYI, we noticed the following commit (built with gcc-7):

commit: 77bb53cb094828a31cd3c5b402899810f63073c1 ("selftests/bpf: Fix perf_=
buffer test on systems w/ offline CPUs")
https://git.kernel.org/cgit/linux/kernel/git/stable/linux-stable-rc.git lin=
ux-5.4.y

in testcase: kernel-selftests
with following parameters:

	group: kselftests-bpf

test-description: The kernel contains a set of "self tests" under the tools=
/testing/selftests/ directory. These are intended to be small unit tests to=
 exercise individual code paths in the kernel.
test-url: https://www.kernel.org/doc/Documentation/kselftest.txt


on test machine: qemu-system-x86_64 -enable-kvm -cpu SandyBridge -smp 2 -m =
8G

caused below changes (please refer to attached dmesg/kmsg for entire log/ba=
cktrace):




If you fix the issue, kindly add following tag
Reported-by: kernel test robot <rong.a.chen@intel.com>



KERNEL SELFTESTS: linux_headers_dir is /usr/src/linux-headers-x86_64-rhel-7=
=2E6-kselftests-da43712a7262891317883d4b3a909fb18dac4b1d
2020-05-08 12:56:15 sed -i s/default_timeout=3D45/default_timeout=3D300/ ks=
elftest/runner.sh
2020-05-08 12:56:15 make -C bpf
make: Entering directory '/usr/src/perf_selftests-x86_64-rhel-7.6-kselftest=
s-da43712a7262891317883d4b3a909fb18dac4b1d/tools/testing/selftests/bpf'
gcc -I. -I/usr/src/perf_selftests-x86_64-rhel-7.6-kselftests-da43712a726289=
1317883d4b3a909fb18dac4b1d/tools/testing/selftests/bpf -g -Wall -O2 -I../..=
/../include/uapi -I../../../lib -I../../../lib/bpf -I../../../../include/ge=
nerated  -I../../../include -Dbpf_prog_load=3Dbpf_prog_test_load -Dbpf_load=
_program=3Dbpf_test_load_program -I. -I/usr/src/perf_selftests-x86_64-rhel-=
7.6-kselftests-da43712a7262891317883d4b3a909fb18dac4b1d/tools/testing/selft=
ests/bpf -Iverifier -c -o /usr/src/perf_selftests-x86_64-rhel-7.6-kselftest=
s-da43712a7262891317883d4b3a909fb18dac4b1d/tools/testing/selftests/bpf/test=
_stub.o test_stub.c
make -C ../../../lib/bpf OUTPUT=3D/usr/src/perf_selftests-x86_64-rhel-7.6-k=
selftests-da43712a7262891317883d4b3a909fb18dac4b1d/tools/testing/selftests/=
bpf/
make[1]: Entering directory '/usr/src/perf_selftests-x86_64-rhel-7.6-kselft=
ests-da43712a7262891317883d4b3a909fb18dac4b1d/tools/lib/bpf'

Auto-detecting system features:
=2E..                        libelf: [ =1B[32mon=1B[m  ]
=2E..                           bpf: [ =1B[32mon=1B[m  ]

  HOSTCC   /usr/src/perf_selftests-x86_64-rhel-7.6-kselftests-da43712a72628=
91317883d4b3a909fb18dac4b1d/tools/testing/selftests/bpf/fixdep.o
  HOSTLD   /usr/src/perf_selftests-x86_64-rhel-7.6-kselftests-da43712a72628=
91317883d4b3a909fb18dac4b1d/tools/testing/selftests/bpf/fixdep-in.o
  LINK     /usr/src/perf_selftests-x86_64-rhel-7.6-kselftests-da43712a72628=
91317883d4b3a909fb18dac4b1d/tools/testing/selftests/bpf/fixdep
  MKDIR    /usr/src/perf_selftests-x86_64-rhel-7.6-kselftests-da43712a72628=
91317883d4b3a909fb18dac4b1d/tools/testing/selftests/bpf/staticobjs/
  CC       /usr/src/perf_selftests-x86_64-rhel-7.6-kselftests-da43712a72628=
91317883d4b3a909fb18dac4b1d/tools/testing/selftests/bpf/staticobjs/libbpf.o
  CC       /usr/src/perf_selftests-x86_64-rhel-7.6-kselftests-da43712a72628=
91317883d4b3a909fb18dac4b1d/tools/testing/selftests/bpf/staticobjs/bpf.o
  CC       /usr/src/perf_selftests-x86_64-rhel-7.6-kselftests-da43712a72628=
91317883d4b3a909fb18dac4b1d/tools/testing/selftests/bpf/staticobjs/nlattr.o
  CC       /usr/src/perf_selftests-x86_64-rhel-7.6-kselftests-da43712a72628=
91317883d4b3a909fb18dac4b1d/tools/testing/selftests/bpf/staticobjs/btf.o
  CC       /usr/src/perf_selftests-x86_64-rhel-7.6-kselftests-da43712a72628=
91317883d4b3a909fb18dac4b1d/tools/testing/selftests/bpf/staticobjs/libbpf_e=
rrno.o
  CC       /usr/src/perf_selftests-x86_64-rhel-7.6-kselftests-da43712a72628=
91317883d4b3a909fb18dac4b1d/tools/testing/selftests/bpf/staticobjs/str_erro=
r.o
  CC       /usr/src/perf_selftests-x86_64-rhel-7.6-kselftests-da43712a72628=
91317883d4b3a909fb18dac4b1d/tools/testing/selftests/bpf/staticobjs/netlink.o
  CC       /usr/src/perf_selftests-x86_64-rhel-7.6-kselftests-da43712a72628=
91317883d4b3a909fb18dac4b1d/tools/testing/selftests/bpf/staticobjs/bpf_prog=
_linfo.o
  CC       /usr/src/perf_selftests-x86_64-rhel-7.6-kselftests-da43712a72628=
91317883d4b3a909fb18dac4b1d/tools/testing/selftests/bpf/staticobjs/libbpf_p=
robes.o
  CC       /usr/src/perf_selftests-x86_64-rhel-7.6-kselftests-da43712a72628=
91317883d4b3a909fb18dac4b1d/tools/testing/selftests/bpf/staticobjs/xsk.o
  CC       /usr/src/perf_selftests-x86_64-rhel-7.6-kselftests-da43712a72628=
91317883d4b3a909fb18dac4b1d/tools/testing/selftests/bpf/staticobjs/hashmap.o
  CC       /usr/src/perf_selftests-x86_64-rhel-7.6-kselftests-da43712a72628=
91317883d4b3a909fb18dac4b1d/tools/testing/selftests/bpf/staticobjs/btf_dump=
=2Eo
  LD       /usr/src/perf_selftests-x86_64-rhel-7.6-kselftests-da43712a72628=
91317883d4b3a909fb18dac4b1d/tools/testing/selftests/bpf/staticobjs/libbpf-i=
n.o
  LINK     /usr/src/perf_selftests-x86_64-rhel-7.6-kselftests-da43712a72628=
91317883d4b3a909fb18dac4b1d/tools/testing/selftests/bpf/libbpf.a
  MKDIR    /usr/src/perf_selftests-x86_64-rhel-7.6-kselftests-da43712a72628=
91317883d4b3a909fb18dac4b1d/tools/testing/selftests/bpf/sharedobjs/
  CC       /usr/src/perf_selftests-x86_64-rhel-7.6-kselftests-da43712a72628=
91317883d4b3a909fb18dac4b1d/tools/testing/selftests/bpf/sharedobjs/libbpf.o
  CC       /usr/src/perf_selftests-x86_64-rhel-7.6-kselftests-da43712a72628=
91317883d4b3a909fb18dac4b1d/tools/testing/selftests/bpf/sharedobjs/bpf.o
  CC       /usr/src/perf_selftests-x86_64-rhel-7.6-kselftests-da43712a72628=
91317883d4b3a909fb18dac4b1d/tools/testing/selftests/bpf/sharedobjs/nlattr.o
  CC       /usr/src/perf_selftests-x86_64-rhel-7.6-kselftests-da43712a72628=
91317883d4b3a909fb18dac4b1d/tools/testing/selftests/bpf/sharedobjs/btf.o
  CC       /usr/src/perf_selftests-x86_64-rhel-7.6-kselftests-da43712a72628=
91317883d4b3a909fb18dac4b1d/tools/testing/selftests/bpf/sharedobjs/libbpf_e=
rrno.o
  CC       /usr/src/perf_selftests-x86_64-rhel-7.6-kselftests-da43712a72628=
91317883d4b3a909fb18dac4b1d/tools/testing/selftests/bpf/sharedobjs/str_erro=
r.o
  CC       /usr/src/perf_selftests-x86_64-rhel-7.6-kselftests-da43712a72628=
91317883d4b3a909fb18dac4b1d/tools/testing/selftests/bpf/sharedobjs/netlink.o
  CC       /usr/src/perf_selftests-x86_64-rhel-7.6-kselftests-da43712a72628=
91317883d4b3a909fb18dac4b1d/tools/testing/selftests/bpf/sharedobjs/bpf_prog=
_linfo.o
  CC       /usr/src/perf_selftests-x86_64-rhel-7.6-kselftests-da43712a72628=
91317883d4b3a909fb18dac4b1d/tools/testing/selftests/bpf/sharedobjs/libbpf_p=
robes.o
  CC       /usr/src/perf_selftests-x86_64-rhel-7.6-kselftests-da43712a72628=
91317883d4b3a909fb18dac4b1d/tools/testing/selftests/bpf/sharedobjs/xsk.o
  CC       /usr/src/perf_selftests-x86_64-rhel-7.6-kselftests-da43712a72628=
91317883d4b3a909fb18dac4b1d/tools/testing/selftests/bpf/sharedobjs/hashmap.o
  CC       /usr/src/perf_selftests-x86_64-rhel-7.6-kselftests-da43712a72628=
91317883d4b3a909fb18dac4b1d/tools/testing/selftests/bpf/sharedobjs/btf_dump=
=2Eo
  LD       /usr/src/perf_selftests-x86_64-rhel-7.6-kselftests-da43712a72628=
91317883d4b3a909fb18dac4b1d/tools/testing/selftests/bpf/sharedobjs/libbpf-i=
n.o
  LINK     /usr/src/perf_selftests-x86_64-rhel-7.6-kselftests-da43712a72628=
91317883d4b3a909fb18dac4b1d/tools/testing/selftests/bpf/libbpf.so.0.0.5
  GEN      /usr/src/perf_selftests-x86_64-rhel-7.6-kselftests-da43712a72628=
91317883d4b3a909fb18dac4b1d/tools/testing/selftests/bpf/libbpf.pc
  LINK     /usr/src/perf_selftests-x86_64-rhel-7.6-kselftests-da43712a72628=
91317883d4b3a909fb18dac4b1d/tools/testing/selftests/bpf/test_libbpf
make[1]: Leaving directory '/usr/src/perf_selftests-x86_64-rhel-7.6-kselfte=
sts-da43712a7262891317883d4b3a909fb18dac4b1d/tools/lib/bpf'
gcc -g -Wall -O2 -I../../../include/uapi -I../../../lib -I../../../lib/bpf =
-I../../../../include/generated  -I../../../include -Dbpf_prog_load=3Dbpf_p=
rog_test_load -Dbpf_load_program=3Dbpf_test_load_program -I. -I/usr/src/per=
f_selftests-x86_64-rhel-7.6-kselftests-da43712a7262891317883d4b3a909fb18dac=
4b1d/tools/testing/selftests/bpf -Iverifier    test_verifier.c /usr/src/per=
f_selftests-x86_64-rhel-7.6-kselftests-da43712a7262891317883d4b3a909fb18dac=
4b1d/tools/testing/selftests/bpf/test_stub.o /usr/src/perf_selftests-x86_64=
-rhel-7.6-kselftests-da43712a7262891317883d4b3a909fb18dac4b1d/tools/testing=
/selftests/bpf/libbpf.a -lcap -lelf -lrt -lpthread -o /usr/src/perf_selftes=
ts-x86_64-rhel-7.6-kselftests-da43712a7262891317883d4b3a909fb18dac4b1d/tool=
s/testing/selftests/bpf/test_verifier
gcc -g -Wall -O2 -I../../../include/uapi -I../../../lib -I../../../lib/bpf =
-I../../../../include/generated  -I../../../include -Dbpf_prog_load=3Dbpf_p=
rog_test_load -Dbpf_load_program=3Dbpf_test_load_program    test_tag.c /usr=
/src/perf_selftests-x86_64-rhel-7.6-kselftests-da43712a7262891317883d4b3a90=
9fb18dac4b1d/tools/testing/selftests/bpf/test_stub.o /usr/src/perf_selftest=
s-x86_64-rhel-7.6-kselftests-da43712a7262891317883d4b3a909fb18dac4b1d/tools=
/testing/selftests/bpf/libbpf.a -lcap -lelf -lrt -lpthread -o /usr/src/perf=
_selftests-x86_64-rhel-7.6-kselftests-da43712a7262891317883d4b3a909fb18dac4=
b1d/tools/testing/selftests/bpf/test_tag
gcc -g -Wall -O2 -I../../../include/uapi -I../../../lib -I../../../lib/bpf =
-I../../../../include/generated  -I../../../include -Dbpf_prog_load=3Dbpf_p=
rog_test_load -Dbpf_load_program=3Dbpf_test_load_program -I. -I/usr/src/per=
f_selftests-x86_64-rhel-7.6-kselftests-da43712a7262891317883d4b3a909fb18dac=
4b1d/tools/testing/selftests/bpf    test_maps.c /usr/src/perf_selftests-x86=
_64-rhel-7.6-kselftests-da43712a7262891317883d4b3a909fb18dac4b1d/tools/test=
ing/selftests/bpf/test_stub.o /usr/src/perf_selftests-x86_64-rhel-7.6-kself=
tests-da43712a7262891317883d4b3a909fb18dac4b1d/tools/testing/selftests/bpf/=
libbpf.a map_tests/sk_storage_map.c -lcap -lelf -lrt -lpthread -o /usr/src/=
perf_selftests-x86_64-rhel-7.6-kselftests-da43712a7262891317883d4b3a909fb18=
dac4b1d/tools/testing/selftests/bpf/test_maps
gcc -g -Wall -O2 -I../../../include/uapi -I../../../lib -I../../../lib/bpf =
-I../../../../include/generated  -I../../../include -Dbpf_prog_load=3Dbpf_p=
rog_test_load -Dbpf_load_program=3Dbpf_test_load_program    test_lru_map.c =
/usr/src/perf_selftests-x86_64-rhel-7.6-kselftests-da43712a7262891317883d4b=
3a909fb18dac4b1d/tools/testing/selftests/bpf/test_stub.o /usr/src/perf_self=
tests-x86_64-rhel-7.6-kselftests-da43712a7262891317883d4b3a909fb18dac4b1d/t=
ools/testing/selftests/bpf/libbpf.a -lcap -lelf -lrt -lpthread -o /usr/src/=
perf_selftests-x86_64-rhel-7.6-kselftests-da43712a7262891317883d4b3a909fb18=
dac4b1d/tools/testing/selftests/bpf/test_lru_map
gcc -g -Wall -O2 -I../../../include/uapi -I../../../lib -I../../../lib/bpf =
-I../../../../include/generated  -I../../../include -Dbpf_prog_load=3Dbpf_p=
rog_test_load -Dbpf_load_program=3Dbpf_test_load_program    test_lpm_map.c =
/usr/src/perf_selftests-x86_64-rhel-7.6-kselftests-da43712a7262891317883d4b=
3a909fb18dac4b1d/tools/testing/selftests/bpf/test_stub.o /usr/src/perf_self=
tests-x86_64-rhel-7.6-kselftests-da43712a7262891317883d4b3a909fb18dac4b1d/t=
ools/testing/selftests/bpf/libbpf.a -lcap -lelf -lrt -lpthread -o /usr/src/=
perf_selftests-x86_64-rhel-7.6-kselftests-da43712a7262891317883d4b3a909fb18=
dac4b1d/tools/testing/selftests/bpf/test_lpm_map
gcc -g -Wall -O2 -I../../../include/uapi -I../../../lib -I../../../lib/bpf =
-I../../../../include/generated  -I../../../include -Dbpf_prog_load=3Dbpf_p=
rog_test_load -Dbpf_load_program=3Dbpf_test_load_program -I. -I/usr/src/per=
f_selftests-x86_64-rhel-7.6-kselftests-da43712a7262891317883d4b3a909fb18dac=
4b1d/tools/testing/selftests/bpf    test_progs.c /usr/src/perf_selftests-x8=
6_64-rhel-7.6-kselftests-da43712a7262891317883d4b3a909fb18dac4b1d/tools/tes=
ting/selftests/bpf/test_stub.o /usr/src/perf_selftests-x86_64-rhel-7.6-ksel=
ftests-da43712a7262891317883d4b3a909fb18dac4b1d/tools/testing/selftests/bpf=
/libbpf.a cgroup_helpers.c trace_helpers.c prog_tests/attach_probe.c prog_t=
ests/stacktrace_map.c prog_tests/raw_tp_writable_test_run.c prog_tests/xdp_=
adjust_tail.c prog_tests/signal_pending.c prog_tests/sockopt_inherit.c prog=
_tests/send_signal.c prog_tests/stacktrace_build_id.c prog_tests/tcp_rtt.c =
prog_tests/reference_tracking.c prog_tests/bpf_verif_scale.c prog_tests/pro=
g_run_xattr.c prog_tests/task_fd_query_tp.c prog_tests/tp_attach_query.c pr=
og_tests/get_stack_raw_tp.c prog_tests/pkt_md_access.c prog_tests/stacktrac=
e_build_id_nmi.c prog_tests/global_data.c prog_tests/queue_stack_map.c prog=
_tests/pkt_access.c prog_tests/spinlock.c prog_tests/sockopt.c prog_tests/t=
ask_fd_query_rawtp.c prog_tests/xdp.c prog_tests/sockopt_sk.c prog_tests/st=
acktrace_map_raw_tp.c prog_tests/skb_ctx.c prog_tests/tcp_estats.c prog_tes=
ts/perf_buffer.c prog_tests/raw_tp_writable_reject_nbd_invalid.c prog_tests=
/sockopt_multi.c prog_tests/flow_dissector.c prog_tests/l4lb_all.c prog_tes=
ts/flow_dissector_load_bytes.c prog_tests/obj_name.c prog_tests/map_lock.c =
prog_tests/xdp_noinline.c prog_tests/core_reloc.c prog_tests/bpf_obj_id.c -=
lcap -lelf -lrt -lpthread -o /usr/src/perf_selftests-x86_64-rhel-7.6-kselft=
ests-da43712a7262891317883d4b3a909fb18dac4b1d/tools/testing/selftests/bpf/t=
est_progs
prog_tests/stacktrace_build_id_nmi.c: In function =E2=80=98test_stacktrace_=
build_id_nmi=E2=80=99:
prog_tests/stacktrace_build_id_nmi.c:55:3: error: label =E2=80=98cleanup=E2=
=80=99 used but not defined
   goto cleanup;
   ^~~~
prog_tests/perf_buffer.c: In function =E2=80=98test_perf_buffer=E2=80=99:
prog_tests/perf_buffer.c:39:8: warning: implicit declaration of function =
=E2=80=98parse_cpu_mask_file=E2=80=99 [-Wimplicit-function-declaration]
  err =3D parse_cpu_mask_file("/sys/devices/system/cpu/online",
        ^~~~~~~~~~~~~~~~~~~
=2E./lib.mk:138: recipe for target '/usr/src/perf_selftests-x86_64-rhel-7.6=
-kselftests-da43712a7262891317883d4b3a909fb18dac4b1d/tools/testing/selftest=
s/bpf/test_progs' failed
make: *** [/usr/src/perf_selftests-x86_64-rhel-7.6-kselftests-da43712a72628=
91317883d4b3a909fb18dac4b1d/tools/testing/selftests/bpf/test_progs] Error 1
make: Leaving directory '/usr/src/perf_selftests-x86_64-rhel-7.6-kselftests=
-da43712a7262891317883d4b3a909fb18dac4b1d/tools/testing/selftests/bpf'


To reproduce:

        # build kernel
	cd linux
	cp config-5.4.18-00145-g77bb53cb09482 .config
	make HOSTCC=3Dgcc-7 CC=3Dgcc-7 ARCH=3Dx86_64 olddefconfig prepare modules_=
prepare bzImage

        git clone https://github.com/intel/lkp-tests.git
        cd lkp-tests
        bin/lkp qemu -k <bzImage> job-script # job-script is attached in th=
is email



Thanks,
Rong Chen


#!/bin/sh

export_top_env()
{
	export suite=3D'kernel-selftests'
	export testcase=3D'kernel-selftests'
	export category=3D'functional'
	export job_origin=3D'/cephfs/jenkins/jobs/lkp-stable/workspace@2/lkp-custo=
mers/linux/stable/function/lkp-skl-d01/kernel-selftests-bm.yaml'
	export queue=3D'vip'
	export testbox=3D'lkp-skl-d01'
	export commit=3D'da43712a7262891317883d4b3a909fb18dac4b1d'
	export branch=3D'linux-stable-rc/queue/5.4'
	export name=3D'/cephfs/jenkins/jobs/lkp-stable/workspace@2/lkp-customers/l=
inux/stable/function/lkp-skl-d01/kernel-selftests-bm.yaml'
	export kernel_cmdline=3D
	export tbox_group=3D'lkp-skl-d01'
	export submit_id=3D'5eb4d7a00b9a934bf19a48da'
	export job_file=3D'/lkp/jobs/scheduled/lkp-skl-d01/kernel-selftests-kselft=
ests-net-ucode=3D0xd6-debian-x86_64-20191114.cgz-da43712a7262891317883d4b3a=
909fb18dac4b1d-20200508-84977-rbase7-0.yaml'
	export id=3D'68a939ff1f15778648a0c99caf938421f045e236'
	export queuer_version=3D'/lkp/liuyd/.src-20200508-104605'
	export model=3D'Skylake'
	export nr_cpu=3D8
	export memory=3D'16G'
	export nr_hdd_partitions=3D1
	export hdd_partitions=3D'/dev/disk/by-id/ata-WDC_WD10EZEX-75WN4A0_WD-WCC6Y=
2JD9SLU-part1'
	export swap_partitions=3D'/dev/disk/by-id/ata-WDC_WD10EZEX-75WN4A0_WD-WCC6=
Y2JD9SLU-part3'
	export rootfs_partition=3D'/dev/disk/by-id/ata-WDC_WD10EZEX-75WN4A0_WD-WCC=
6Y2JD9SLU-part2'
	export brand=3D'Intel(R) Core(TM) i7-6700 CPU @ 3.40GHz'
	export cpu_info=3D'skylake i7-6700'
	export bios_version=3D'1.2.8'
	export need_kconfig_hw=3D'CONFIG_E1000E=3Dy
CONFIG_SATA_AHCI'
	export ucode=3D'0xd6'
	export need_kernel_headers=3Dtrue
	export need_kernel_selftests=3Dtrue
	export kconfig=3D'x86_64-rhel-7.6-kselftests'
	export need_kconfig=3D'CONFIG_BLOCK=3Dy
CONFIG_BTRFS_FS=3Dm
CONFIG_EFI=3Dy
CONFIG_EFIVAR_FS
CONFIG_FTRACE=3Dy
CONFIG_IP_ADVANCED_ROUTER=3Dy
CONFIG_IP_MULTIPLE_TABLES=3Dy
CONFIG_MEMORY_HOTPLUG_SPARSE=3Dy
CONFIG_MEMORY_NOTIFIER_ERROR_INJECT
CONFIG_NOTIFIER_ERROR_INJECTION
CONFIG_RC_CORE=3Dm ~ (4\.1[4-9]|4\.20|5\.)
CONFIG_RC_DECODERS=3Dy
CONFIG_RC_DEVICES=3Dy
CONFIG_RUNTIME_TESTING_MENU=3Dy
CONFIG_STAGING=3Dy
CONFIG_SYNC_FILE=3Dy
CONFIG_TEST_FIRMWARE
CONFIG_TEST_KMOD=3Dm
CONFIG_TEST_LKM=3Dm
CONFIG_TEST_USER_COPY
CONFIG_TUN=3Dm
CONFIG_XFS_FS=3Dm'
	export compiler=3D'gcc-7'
	export rootfs=3D'debian-x86_64-20191114.cgz'
	export enqueue_time=3D'2020-05-08 11:53:05 +0800'
	export _id=3D'5eb4d7a00b9a934bf19a48da'
	export _rt=3D'/result/kernel-selftests/kselftests-net-ucode=3D0xd6/lkp-skl=
-d01/debian-x86_64-20191114.cgz/x86_64-rhel-7.6-kselftests/gcc-7/da43712a72=
62891317883d4b3a909fb18dac4b1d'
	export user=3D'liuyd'
	export result_root=3D'/result/kernel-selftests/kselftests-net-ucode=3D0xd6=
/lkp-skl-d01/debian-x86_64-20191114.cgz/x86_64-rhel-7.6-kselftests/gcc-7/da=
43712a7262891317883d4b3a909fb18dac4b1d/0'
	export scheduler_version=3D'/lkp/lkp/.src-20200508-124504'
	export LKP_SERVER=3D'inn'
	export arch=3D'x86_64'
	export max_uptime=3D3600
	export initrd=3D'/osimage/debian/debian-x86_64-20191114.cgz'
	export bootloader_append=3D'root=3D/dev/ram0
user=3Dliuyd
job=3D/lkp/jobs/scheduled/lkp-skl-d01/kernel-selftests-kselftests-net-ucode=
=3D0xd6-debian-x86_64-20191114.cgz-da43712a7262891317883d4b3a909fb18dac4b1d=
-20200508-84977-rbase7-0.yaml
ARCH=3Dx86_64
kconfig=3Dx86_64-rhel-7.6-kselftests
branch=3Dlinux-stable-rc/queue/5.4
commit=3Dda43712a7262891317883d4b3a909fb18dac4b1d
BOOT_IMAGE=3D/pkg/linux/x86_64-rhel-7.6-kselftests/gcc-7/da43712a7262891317=
883d4b3a909fb18dac4b1d/vmlinuz-5.4.18-00152-gda43712a72628
max_uptime=3D3600
RESULT_ROOT=3D/result/kernel-selftests/kselftests-net-ucode=3D0xd6/lkp-skl-=
d01/debian-x86_64-20191114.cgz/x86_64-rhel-7.6-kselftests/gcc-7/da43712a726=
2891317883d4b3a909fb18dac4b1d/0
LKP_SERVER=3Dinn
nokaslr
selinux=3D0
debug
apic=3Ddebug
sysrq_always_enabled
rcupdate.rcu_cpu_stall_timeout=3D100
net.ifnames=3D0
printk.devkmsg=3Don
panic=3D-1
softlockup_panic=3D1
nmi_watchdog=3Dpanic
oops=3Dpanic
load_ramdisk=3D2
prompt_ramdisk=3D0
drbd.minor_count=3D8
systemd.log_level=3Derr
ignore_loglevel
console=3Dtty0
earlyprintk=3DttyS0,115200
console=3DttyS0,115200
vga=3Dnormal
rw'
	export modules_initrd=3D'/pkg/linux/x86_64-rhel-7.6-kselftests/gcc-7/da437=
12a7262891317883d4b3a909fb18dac4b1d/modules.cgz'
	export bm_initrd=3D'/osimage/deps/debian-x86_64-20180403.cgz/run-ipconfig_=
2018-04-03.cgz,/osimage/deps/debian-x86_64-20180403.cgz/lkp_2019-08-05.cgz,=
/osimage/deps/debian-x86_64-20180403.cgz/rsync-rootfs_2018-04-03.cgz,/osima=
ge/deps/debian-x86_64-20180403.cgz/kernel-selftests_20200428.cgz,/osimage/p=
kg/debian-x86_64-20180403.cgz/kernel-selftests-x86_64-4aa0c9c9-1_20200426.c=
gz,/osimage/deps/debian-x86_64-20180403.cgz/hw_2020-01-02.cgz'
	export linux_headers_initrd=3D'/pkg/linux/x86_64-rhel-7.6-kselftests/gcc-7=
/da43712a7262891317883d4b3a909fb18dac4b1d/linux-headers.cgz'
	export linux_selftests_initrd=3D'/pkg/linux/x86_64-rhel-7.6-kselftests/gcc=
-7/da43712a7262891317883d4b3a909fb18dac4b1d/linux-selftests.cgz'
	export ucode_initrd=3D'/osimage/ucode/intel-ucode-20191114.cgz'
	export lkp_initrd=3D'/osimage/user/liuyd/lkp-x86_64.cgz'
	export site=3D'inn'
	export LKP_CGI_PORT=3D80
	export LKP_CIFS_PORT=3D139
	export last_kernel=3D'4.20.0'
	export queue_cmdline_keys=3D'user'
	export schedule_notify_address=3D
	export kernel=3D'/pkg/linux/x86_64-rhel-7.6-kselftests/gcc-7/da43712a72628=
91317883d4b3a909fb18dac4b1d/vmlinuz-5.4.18-00152-gda43712a72628'
	export dequeue_time=3D'2020-05-08 12:54:52 +0800'
	export job_initrd=3D'/lkp/jobs/scheduled/lkp-skl-d01/kernel-selftests-ksel=
ftests-net-ucode=3D0xd6-debian-x86_64-20191114.cgz-da43712a7262891317883d4b=
3a909fb18dac4b1d-20200508-84977-rbase7-0.cgz'

	[ -n "$LKP_SRC" ] ||
	export LKP_SRC=3D/lkp/${user:-lkp}/src
}

run_job()
{
	echo $$ > $TMP/run-job.pid

	. $LKP_SRC/lib/http.sh
	. $LKP_SRC/lib/job.sh
	. $LKP_SRC/lib/env.sh

	export_top_env

	run_monitor $LKP_SRC/monitors/wrapper kmsg
	run_monitor $LKP_SRC/monitors/wrapper heartbeat
	run_monitor $LKP_SRC/monitors/wrapper meminfo
	run_monitor $LKP_SRC/monitors/wrapper oom-killer
	run_monitor $LKP_SRC/monitors/plain/watchdog

	run_test group=3D'kselftests-net' $LKP_SRC/tests/wrapper kernel-selftests
}

extract_stats()
{
	export stats_part_begin=3D
	export stats_part_end=3D

	$LKP_SRC/stats/wrapper kernel-selftests
	$LKP_SRC/stats/wrapper kmsg
	$LKP_SRC/stats/wrapper meminfo

	$LKP_SRC/stats/wrapper time kernel-selftests.time
	$LKP_SRC/stats/wrapper dmesg
	$LKP_SRC/stats/wrapper kmsg
	$LKP_SRC/stats/wrapper last_state
	$LKP_SRC/stats/wrapper stderr
	$LKP_SRC/stats/wrapper time
}

"$@"

KERNEL SELFTESTS: linux_headers_dir is /usr/src/linux-headers-x86_64-rhel-7=
=2E6-kselftests-da43712a7262891317883d4b3a909fb18dac4b1d
2020-05-08 12:56:15 sed -i s/default_timeout=3D45/default_timeout=3D300/ ks=
elftest/runner.sh
2020-05-08 12:56:15 make -C bpf
make: Entering directory '/usr/src/perf_selftests-x86_64-rhel-7.6-kselftest=
s-da43712a7262891317883d4b3a909fb18dac4b1d/tools/testing/selftests/bpf'
gcc -I. -I/usr/src/perf_selftests-x86_64-rhel-7.6-kselftests-da43712a726289=
1317883d4b3a909fb18dac4b1d/tools/testing/selftests/bpf -g -Wall -O2 -I../..=
/../include/uapi -I../../../lib -I../../../lib/bpf -I../../../../include/ge=
nerated  -I../../../include -Dbpf_prog_load=3Dbpf_prog_test_load -Dbpf_load=
_program=3Dbpf_test_load_program -I. -I/usr/src/perf_selftests-x86_64-rhel-=
7.6-kselftests-da43712a7262891317883d4b3a909fb18dac4b1d/tools/testing/selft=
ests/bpf -Iverifier -c -o /usr/src/perf_selftests-x86_64-rhel-7.6-kselftest=
s-da43712a7262891317883d4b3a909fb18dac4b1d/tools/testing/selftests/bpf/test=
_stub.o test_stub.c
make -C ../../../lib/bpf OUTPUT=3D/usr/src/perf_selftests-x86_64-rhel-7.6-k=
selftests-da43712a7262891317883d4b3a909fb18dac4b1d/tools/testing/selftests/=
bpf/
make[1]: Entering directory '/usr/src/perf_selftests-x86_64-rhel-7.6-kselft=
ests-da43712a7262891317883d4b3a909fb18dac4b1d/tools/lib/bpf'

Auto-detecting system features:
=2E..                        libelf: [ =1B[32mon=1B[m  ]
=2E..                           bpf: [ =1B[32mon=1B[m  ]

  HOSTCC   /usr/src/perf_selftests-x86_64-rhel-7.6-kselftests-da43712a72628=
91317883d4b3a909fb18dac4b1d/tools/testing/selftests/bpf/fixdep.o
  HOSTLD   /usr/src/perf_selftests-x86_64-rhel-7.6-kselftests-da43712a72628=
91317883d4b3a909fb18dac4b1d/tools/testing/selftests/bpf/fixdep-in.o
  LINK     /usr/src/perf_selftests-x86_64-rhel-7.6-kselftests-da43712a72628=
91317883d4b3a909fb18dac4b1d/tools/testing/selftests/bpf/fixdep
  MKDIR    /usr/src/perf_selftests-x86_64-rhel-7.6-kselftests-da43712a72628=
91317883d4b3a909fb18dac4b1d/tools/testing/selftests/bpf/staticobjs/
  CC       /usr/src/perf_selftests-x86_64-rhel-7.6-kselftests-da43712a72628=
91317883d4b3a909fb18dac4b1d/tools/testing/selftests/bpf/staticobjs/libbpf.o
  CC       /usr/src/perf_selftests-x86_64-rhel-7.6-kselftests-da43712a72628=
91317883d4b3a909fb18dac4b1d/tools/testing/selftests/bpf/staticobjs/bpf.o
  CC       /usr/src/perf_selftests-x86_64-rhel-7.6-kselftests-da43712a72628=
91317883d4b3a909fb18dac4b1d/tools/testing/selftests/bpf/staticobjs/nlattr.o
  CC       /usr/src/perf_selftests-x86_64-rhel-7.6-kselftests-da43712a72628=
91317883d4b3a909fb18dac4b1d/tools/testing/selftests/bpf/staticobjs/btf.o
  CC       /usr/src/perf_selftests-x86_64-rhel-7.6-kselftests-da43712a72628=
91317883d4b3a909fb18dac4b1d/tools/testing/selftests/bpf/staticobjs/libbpf_e=
rrno.o
  CC       /usr/src/perf_selftests-x86_64-rhel-7.6-kselftests-da43712a72628=
91317883d4b3a909fb18dac4b1d/tools/testing/selftests/bpf/staticobjs/str_erro=
r.o
  CC       /usr/src/perf_selftests-x86_64-rhel-7.6-kselftests-da43712a72628=
91317883d4b3a909fb18dac4b1d/tools/testing/selftests/bpf/staticobjs/netlink.o
  CC       /usr/src/perf_selftests-x86_64-rhel-7.6-kselftests-da43712a72628=
91317883d4b3a909fb18dac4b1d/tools/testing/selftests/bpf/staticobjs/bpf_prog=
_linfo.o
  CC       /usr/src/perf_selftests-x86_64-rhel-7.6-kselftests-da43712a72628=
91317883d4b3a909fb18dac4b1d/tools/testing/selftests/bpf/staticobjs/libbpf_p=
robes.o
  CC       /usr/src/perf_selftests-x86_64-rhel-7.6-kselftests-da43712a72628=
91317883d4b3a909fb18dac4b1d/tools/testing/selftests/bpf/staticobjs/xsk.o
  CC       /usr/src/perf_selftests-x86_64-rhel-7.6-kselftests-da43712a72628=
91317883d4b3a909fb18dac4b1d/tools/testing/selftests/bpf/staticobjs/hashmap.o
  CC       /usr/src/perf_selftests-x86_64-rhel-7.6-kselftests-da43712a72628=
91317883d4b3a909fb18dac4b1d/tools/testing/selftests/bpf/staticobjs/btf_dump=
=2Eo
  LD       /usr/src/perf_selftests-x86_64-rhel-7.6-kselftests-da43712a72628=
91317883d4b3a909fb18dac4b1d/tools/testing/selftests/bpf/staticobjs/libbpf-i=
n.o
  LINK     /usr/src/perf_selftests-x86_64-rhel-7.6-kselftests-da43712a72628=
91317883d4b3a909fb18dac4b1d/tools/testing/selftests/bpf/libbpf.a
  MKDIR    /usr/src/perf_selftests-x86_64-rhel-7.6-kselftests-da43712a72628=
91317883d4b3a909fb18dac4b1d/tools/testing/selftests/bpf/sharedobjs/
  CC       /usr/src/perf_selftests-x86_64-rhel-7.6-kselftests-da43712a72628=
91317883d4b3a909fb18dac4b1d/tools/testing/selftests/bpf/sharedobjs/libbpf.o
  CC       /usr/src/perf_selftests-x86_64-rhel-7.6-kselftests-da43712a72628=
91317883d4b3a909fb18dac4b1d/tools/testing/selftests/bpf/sharedobjs/bpf.o
  CC       /usr/src/perf_selftests-x86_64-rhel-7.6-kselftests-da43712a72628=
91317883d4b3a909fb18dac4b1d/tools/testing/selftests/bpf/sharedobjs/nlattr.o
  CC       /usr/src/perf_selftests-x86_64-rhel-7.6-kselftests-da43712a72628=
91317883d4b3a909fb18dac4b1d/tools/testing/selftests/bpf/sharedobjs/btf.o
  CC       /usr/src/perf_selftests-x86_64-rhel-7.6-kselftests-da43712a72628=
91317883d4b3a909fb18dac4b1d/tools/testing/selftests/bpf/sharedobjs/libbpf_e=
rrno.o
  CC       /usr/src/perf_selftests-x86_64-rhel-7.6-kselftests-da43712a72628=
91317883d4b3a909fb18dac4b1d/tools/testing/selftests/bpf/sharedobjs/str_erro=
r.o
  CC       /usr/src/perf_selftests-x86_64-rhel-7.6-kselftests-da43712a72628=
91317883d4b3a909fb18dac4b1d/tools/testing/selftests/bpf/sharedobjs/netlink.o
  CC       /usr/src/perf_selftests-x86_64-rhel-7.6-kselftests-da43712a72628=
91317883d4b3a909fb18dac4b1d/tools/testing/selftests/bpf/sharedobjs/bpf_prog=
_linfo.o
  CC       /usr/src/perf_selftests-x86_64-rhel-7.6-kselftests-da43712a72628=
91317883d4b3a909fb18dac4b1d/tools/testing/selftests/bpf/sharedobjs/libbpf_p=
robes.o
  CC       /usr/src/perf_selftests-x86_64-rhel-7.6-kselftests-da43712a72628=
91317883d4b3a909fb18dac4b1d/tools/testing/selftests/bpf/sharedobjs/xsk.o
  CC       /usr/src/perf_selftests-x86_64-rhel-7.6-kselftests-da43712a72628=
91317883d4b3a909fb18dac4b1d/tools/testing/selftests/bpf/sharedobjs/hashmap.o
  CC       /usr/src/perf_selftests-x86_64-rhel-7.6-kselftests-da43712a72628=
91317883d4b3a909fb18dac4b1d/tools/testing/selftests/bpf/sharedobjs/btf_dump=
=2Eo
  LD       /usr/src/perf_selftests-x86_64-rhel-7.6-kselftests-da43712a72628=
91317883d4b3a909fb18dac4b1d/tools/testing/selftests/bpf/sharedobjs/libbpf-i=
n.o
  LINK     /usr/src/perf_selftests-x86_64-rhel-7.6-kselftests-da43712a72628=
91317883d4b3a909fb18dac4b1d/tools/testing/selftests/bpf/libbpf.so.0.0.5
  GEN      /usr/src/perf_selftests-x86_64-rhel-7.6-kselftests-da43712a72628=
91317883d4b3a909fb18dac4b1d/tools/testing/selftests/bpf/libbpf.pc
  LINK     /usr/src/perf_selftests-x86_64-rhel-7.6-kselftests-da43712a72628=
91317883d4b3a909fb18dac4b1d/tools/testing/selftests/bpf/test_libbpf
make[1]: Leaving directory '/usr/src/perf_selftests-x86_64-rhel-7.6-kselfte=
sts-da43712a7262891317883d4b3a909fb18dac4b1d/tools/lib/bpf'
gcc -g -Wall -O2 -I../../../include/uapi -I../../../lib -I../../../lib/bpf =
-I../../../../include/generated  -I../../../include -Dbpf_prog_load=3Dbpf_p=
rog_test_load -Dbpf_load_program=3Dbpf_test_load_program -I. -I/usr/src/per=
f_selftests-x86_64-rhel-7.6-kselftests-da43712a7262891317883d4b3a909fb18dac=
4b1d/tools/testing/selftests/bpf -Iverifier    test_verifier.c /usr/src/per=
f_selftests-x86_64-rhel-7.6-kselftests-da43712a7262891317883d4b3a909fb18dac=
4b1d/tools/testing/selftests/bpf/test_stub.o /usr/src/perf_selftests-x86_64=
-rhel-7.6-kselftests-da43712a7262891317883d4b3a909fb18dac4b1d/tools/testing=
/selftests/bpf/libbpf.a -lcap -lelf -lrt -lpthread -o /usr/src/perf_selftes=
ts-x86_64-rhel-7.6-kselftests-da43712a7262891317883d4b3a909fb18dac4b1d/tool=
s/testing/selftests/bpf/test_verifier
gcc -g -Wall -O2 -I../../../include/uapi -I../../../lib -I../../../lib/bpf =
-I../../../../include/generated  -I../../../include -Dbpf_prog_load=3Dbpf_p=
rog_test_load -Dbpf_load_program=3Dbpf_test_load_program    test_tag.c /usr=
/src/perf_selftests-x86_64-rhel-7.6-kselftests-da43712a7262891317883d4b3a90=
9fb18dac4b1d/tools/testing/selftests/bpf/test_stub.o /usr/src/perf_selftest=
s-x86_64-rhel-7.6-kselftests-da43712a7262891317883d4b3a909fb18dac4b1d/tools=
/testing/selftests/bpf/libbpf.a -lcap -lelf -lrt -lpthread -o /usr/src/perf=
_selftests-x86_64-rhel-7.6-kselftests-da43712a7262891317883d4b3a909fb18dac4=
b1d/tools/testing/selftests/bpf/test_tag
gcc -g -Wall -O2 -I../../../include/uapi -I../../../lib -I../../../lib/bpf =
-I../../../../include/generated  -I../../../include -Dbpf_prog_load=3Dbpf_p=
rog_test_load -Dbpf_load_program=3Dbpf_test_load_program -I. -I/usr/src/per=
f_selftests-x86_64-rhel-7.6-kselftests-da43712a7262891317883d4b3a909fb18dac=
4b1d/tools/testing/selftests/bpf    test_maps.c /usr/src/perf_selftests-x86=
_64-rhel-7.6-kselftests-da43712a7262891317883d4b3a909fb18dac4b1d/tools/test=
ing/selftests/bpf/test_stub.o /usr/src/perf_selftests-x86_64-rhel-7.6-kself=
tests-da43712a7262891317883d4b3a909fb18dac4b1d/tools/testing/selftests/bpf/=
libbpf.a map_tests/sk_storage_map.c -lcap -lelf -lrt -lpthread -o /usr/src/=
perf_selftests-x86_64-rhel-7.6-kselftests-da43712a7262891317883d4b3a909fb18=
dac4b1d/tools/testing/selftests/bpf/test_maps
gcc -g -Wall -O2 -I../../../include/uapi -I../../../lib -I../../../lib/bpf =
-I../../../../include/generated  -I../../../include -Dbpf_prog_load=3Dbpf_p=
rog_test_load -Dbpf_load_program=3Dbpf_test_load_program    test_lru_map.c =
/usr/src/perf_selftests-x86_64-rhel-7.6-kselftests-da43712a7262891317883d4b=
3a909fb18dac4b1d/tools/testing/selftests/bpf/test_stub.o /usr/src/perf_self=
tests-x86_64-rhel-7.6-kselftests-da43712a7262891317883d4b3a909fb18dac4b1d/t=
ools/testing/selftests/bpf/libbpf.a -lcap -lelf -lrt -lpthread -o /usr/src/=
perf_selftests-x86_64-rhel-7.6-kselftests-da43712a7262891317883d4b3a909fb18=
dac4b1d/tools/testing/selftests/bpf/test_lru_map
gcc -g -Wall -O2 -I../../../include/uapi -I../../../lib -I../../../lib/bpf =
-I../../../../include/generated  -I../../../include -Dbpf_prog_load=3Dbpf_p=
rog_test_load -Dbpf_load_program=3Dbpf_test_load_program    test_lpm_map.c =
/usr/src/perf_selftests-x86_64-rhel-7.6-kselftests-da43712a7262891317883d4b=
3a909fb18dac4b1d/tools/testing/selftests/bpf/test_stub.o /usr/src/perf_self=
tests-x86_64-rhel-7.6-kselftests-da43712a7262891317883d4b3a909fb18dac4b1d/t=
ools/testing/selftests/bpf/libbpf.a -lcap -lelf -lrt -lpthread -o /usr/src/=
perf_selftests-x86_64-rhel-7.6-kselftests-da43712a7262891317883d4b3a909fb18=
dac4b1d/tools/testing/selftests/bpf/test_lpm_map
gcc -g -Wall -O2 -I../../../include/uapi -I../../../lib -I../../../lib/bpf =
-I../../../../include/generated  -I../../../include -Dbpf_prog_load=3Dbpf_p=
rog_test_load -Dbpf_load_program=3Dbpf_test_load_program -I. -I/usr/src/per=
f_selftests-x86_64-rhel-7.6-kselftests-da43712a7262891317883d4b3a909fb18dac=
4b1d/tools/testing/selftests/bpf    test_progs.c /usr/src/perf_selftests-x8=
6_64-rhel-7.6-kselftests-da43712a7262891317883d4b3a909fb18dac4b1d/tools/tes=
ting/selftests/bpf/test_stub.o /usr/src/perf_selftests-x86_64-rhel-7.6-ksel=
ftests-da43712a7262891317883d4b3a909fb18dac4b1d/tools/testing/selftests/bpf=
/libbpf.a cgroup_helpers.c trace_helpers.c prog_tests/attach_probe.c prog_t=
ests/stacktrace_map.c prog_tests/raw_tp_writable_test_run.c prog_tests/xdp_=
adjust_tail.c prog_tests/signal_pending.c prog_tests/sockopt_inherit.c prog=
_tests/send_signal.c prog_tests/stacktrace_build_id.c prog_tests/tcp_rtt.c =
prog_tests/reference_tracking.c prog_tests/bpf_verif_scale.c prog_tests/pro=
g_run_xattr.c prog_tests/task_fd_query_tp.c prog_tests/tp_attach_query.c pr=
og_tests/get_stack_raw_tp.c prog_tests/pkt_md_access.c prog_tests/stacktrac=
e_build_id_nmi.c prog_tests/global_data.c prog_tests/queue_stack_map.c prog=
_tests/pkt_access.c prog_tests/spinlock.c prog_tests/sockopt.c prog_tests/t=
ask_fd_query_rawtp.c prog_tests/xdp.c prog_tests/sockopt_sk.c prog_tests/st=
acktrace_map_raw_tp.c prog_tests/skb_ctx.c prog_tests/tcp_estats.c prog_tes=
ts/perf_buffer.c prog_tests/raw_tp_writable_reject_nbd_invalid.c prog_tests=
/sockopt_multi.c prog_tests/flow_dissector.c prog_tests/l4lb_all.c prog_tes=
ts/flow_dissector_load_bytes.c prog_tests/obj_name.c prog_tests/map_lock.c =
prog_tests/xdp_noinline.c prog_tests/core_reloc.c prog_tests/bpf_obj_id.c -=
lcap -lelf -lrt -lpthread -o /usr/src/perf_selftests-x86_64-rhel-7.6-kselft=
ests-da43712a7262891317883d4b3a909fb18dac4b1d/tools/testing/selftests/bpf/t=
est_progs
prog_tests/stacktrace_build_id_nmi.c: In function =E2=80=98test_stacktrace_=
build_id_nmi=E2=80=99:
prog_tests/stacktrace_build_id_nmi.c:55:3: error: label =E2=80=98cleanup=E2=
=80=99 used but not defined
   goto cleanup;
   ^~~~
prog_tests/perf_buffer.c: In function =E2=80=98test_perf_buffer=E2=80=99:
prog_tests/perf_buffer.c:39:8: warning: implicit declaration of function =
=E2=80=98parse_cpu_mask_file=E2=80=99 [-Wimplicit-function-declaration]
  err =3D parse_cpu_mask_file("/sys/devices/system/cpu/online",
        ^~~~~~~~~~~~~~~~~~~
=2E./lib.mk:138: recipe for target '/usr/src/perf_selftests-x86_64-rhel-7.6=
-kselftests-da43712a7262891317883d4b3a909fb18dac4b1d/tools/testing/selftest=
s/bpf/test_progs' failed
make: *** [/usr/src/perf_selftests-x86_64-rhel-7.6-kselftests-da43712a72628=
91317883d4b3a909fb18dac4b1d/tools/testing/selftests/bpf/test_progs] Error 1
make: Leaving directory '/usr/src/perf_selftests-x86_64-rhel-7.6-kselftests=
-da43712a7262891317883d4b3a909fb18dac4b1d/tools/testing/selftests/bpf'
ignored_by_lkp net.l2tp.sh test
2020-05-08 12:56:22 make run_tests -C net
make: Entering directory '/usr/src/perf_selftests-x86_64-rhel-7.6-kselftest=
s-da43712a7262891317883d4b3a909fb18dac4b1d/tools/testing/selftests/net'
make --no-builtin-rules ARCH=3Dx86 -C ../../../.. headers_install
make[1]: Entering directory '/usr/src/perf_selftests-x86_64-rhel-7.6-kselft=
ests-da43712a7262891317883d4b3a909fb18dac4b1d'
  HOSTCC  scripts/basic/fixdep
  HOSTCC  scripts/unifdef
  WRAP    arch/x86/include/generated/uapi/asm/bpf_perf_event.h
  WRAP    arch/x86/include/generated/uapi/asm/errno.h
  WRAP    arch/x86/include/generated/uapi/asm/fcntl.h
  WRAP    arch/x86/include/generated/uapi/asm/ioctl.h
  WRAP    arch/x86/include/generated/uapi/asm/ioctls.h
  WRAP    arch/x86/include/generated/uapi/asm/ipcbuf.h
  WRAP    arch/x86/include/generated/uapi/asm/param.h
  WRAP    arch/x86/include/generated/uapi/asm/poll.h
  WRAP    arch/x86/include/generated/uapi/asm/resource.h
  WRAP    arch/x86/include/generated/uapi/asm/socket.h
  WRAP    arch/x86/include/generated/uapi/asm/sockios.h
  WRAP    arch/x86/include/generated/uapi/asm/termbits.h
  WRAP    arch/x86/include/generated/uapi/asm/termios.h
  WRAP    arch/x86/include/generated/uapi/asm/types.h
  SYSTBL  arch/x86/include/generated/asm/syscalls_32.h
  SYSHDR  arch/x86/include/generated/uapi/asm/unistd_32.h
  SYSHDR  arch/x86/include/generated/uapi/asm/unistd_64.h
  SYSHDR  arch/x86/include/generated/uapi/asm/unistd_x32.h
  HOSTCC  arch/x86/tools/relocs_32.o
  HOSTCC  arch/x86/tools/relocs_64.o
  HOSTCC  arch/x86/tools/relocs_common.o
  HOSTLD  arch/x86/tools/relocs
  UPD     include/generated/uapi/linux/version.h
  HDRINST usr/include/video/sisfb.h
  HDRINST usr/include/video/edid.h
  HDRINST usr/include/video/uvesafb.h
  HDRINST usr/include/drm/r128_drm.h
  HDRINST usr/include/drm/via_drm.h
  HDRINST usr/include/drm/i810_drm.h
  HDRINST usr/include/drm/mga_drm.h
  HDRINST usr/include/drm/nouveau_drm.h
  HDRINST usr/include/drm/exynos_drm.h
  HDRINST usr/include/drm/qxl_drm.h
  HDRINST usr/include/drm/radeon_drm.h
  HDRINST usr/include/drm/vc4_drm.h
  HDRINST usr/include/drm/savage_drm.h
  HDRINST usr/include/drm/v3d_drm.h
  HDRINST usr/include/drm/lima_drm.h
  HDRINST usr/include/drm/drm.h
  HDRINST usr/include/drm/vgem_drm.h
  HDRINST usr/include/drm/virtgpu_drm.h
  HDRINST usr/include/drm/sis_drm.h
  HDRINST usr/include/drm/armada_drm.h
  HDRINST usr/include/drm/amdgpu_drm.h
  HDRINST usr/include/drm/etnaviv_drm.h
  HDRINST usr/include/drm/drm_sarea.h
  HDRINST usr/include/drm/panfrost_drm.h
  HDRINST usr/include/drm/tegra_drm.h
  HDRINST usr/include/drm/drm_fourcc.h
  HDRINST usr/include/drm/msm_drm.h
  HDRINST usr/include/drm/i915_drm.h
  HDRINST usr/include/drm/drm_mode.h
  HDRINST usr/include/drm/omap_drm.h
  HDRINST usr/include/drm/vmwgfx_drm.h
  HDRINST usr/include/mtd/mtd-abi.h
  HDRINST usr/include/mtd/nftl-user.h
  HDRINST usr/include/mtd/mtd-user.h
  HDRINST usr/include/mtd/ubi-user.h
  HDRINST usr/include/mtd/inftl-user.h
  HDRINST usr/include/xen/evtchn.h
  HDRINST usr/include/xen/privcmd.h
  HDRINST usr/include/xen/gntdev.h
  HDRINST usr/include/xen/gntalloc.h
  HDRINST usr/include/asm-generic/param.h
  HDRINST usr/include/asm-generic/swab.h
  HDRINST usr/include/asm-generic/mman-common.h
  HDRINST usr/include/asm-generic/sockios.h
  HDRINST usr/include/asm-generic/errno-base.h
  HDRINST usr/include/asm-generic/ipcbuf.h
  HDRINST usr/include/asm-generic/ioctls.h
  HDRINST usr/include/asm-generic/setup.h
  HDRINST usr/include/asm-generic/socket.h
  HDRINST usr/include/asm-generic/bitsperlong.h
  HDRINST usr/include/asm-generic/statfs.h
  HDRINST usr/include/asm-generic/resource.h
  HDRINST usr/include/asm-generic/mman.h
  HDRINST usr/include/asm-generic/int-ll64.h
  HDRINST usr/include/asm-generic/hugetlb_encode.h
  HDRINST usr/include/asm-generic/sembuf.h
  HDRINST usr/include/asm-generic/unistd.h
  HDRINST usr/include/asm-generic/siginfo.h
  HDRINST usr/include/asm-generic/fcntl.h
  HDRINST usr/include/asm-generic/signal-defs.h
  HDRINST usr/include/asm-generic/ioctl.h
  HDRINST usr/include/asm-generic/signal.h
  HDRINST usr/include/asm-generic/posix_types.h
  HDRINST usr/include/asm-generic/shmbuf.h
  HDRINST usr/include/asm-generic/poll.h
  HDRINST usr/include/asm-generic/msgbuf.h
  HDRINST usr/include/asm-generic/kvm_para.h
  HDRINST usr/include/asm-generic/termios.h
  HDRINST usr/include/asm-generic/ucontext.h
  HDRINST usr/include/asm-generic/bpf_perf_event.h
  HDRINST usr/include/asm-generic/termbits.h
  HDRINST usr/include/asm-generic/types.h
  HDRINST usr/include/asm-generic/errno.h
  HDRINST usr/include/asm-generic/stat.h
  HDRINST usr/include/asm-generic/auxvec.h
  HDRINST usr/include/asm-generic/int-l64.h
  HDRINST usr/include/rdma/hfi/hfi1_user.h
  HDRINST usr/include/rdma/hfi/hfi1_ioctl.h
  HDRINST usr/include/rdma/rdma_user_ioctl_cmds.h
  HDRINST usr/include/rdma/vmw_pvrdma-abi.h
  HDRINST usr/include/rdma/rdma_user_ioctl.h
  HDRINST usr/include/rdma/ocrdma-abi.h
  HDRINST usr/include/rdma/qedr-abi.h
  HDRINST usr/include/rdma/siw-abi.h
  HDRINST usr/include/rdma/mlx5-abi.h
  HDRINST usr/include/rdma/cxgb4-abi.h
  HDRINST usr/include/rdma/ib_user_verbs.h
  HDRINST usr/include/rdma/hns-abi.h
  HDRINST usr/include/rdma/rdma_user_rxe.h
  HDRINST usr/include/rdma/mlx5_user_ioctl_verbs.h
  HDRINST usr/include/rdma/i40iw-abi.h
  HDRINST usr/include/rdma/mlx5_user_ioctl_cmds.h
  HDRINST usr/include/rdma/mthca-abi.h
  HDRINST usr/include/rdma/rvt-abi.h
  HDRINST usr/include/rdma/ib_user_sa.h
  HDRINST usr/include/rdma/ib_user_mad.h
  HDRINST usr/include/rdma/bnxt_re-abi.h
  HDRINST usr/include/rdma/mlx4-abi.h
  HDRINST usr/include/rdma/rdma_netlink.h
  HDRINST usr/include/rdma/ib_user_ioctl_verbs.h
  HDRINST usr/include/rdma/cxgb3-abi.h
  HDRINST usr/include/rdma/ib_user_ioctl_cmds.h
  HDRINST usr/include/rdma/efa-abi.h
  HDRINST usr/include/rdma/rdma_user_cm.h
  HDRINST usr/include/misc/fastrpc.h
  HDRINST usr/include/misc/habanalabs.h
  HDRINST usr/include/misc/cxl.h
  HDRINST usr/include/misc/xilinx_sdfec.h
  HDRINST usr/include/misc/ocxl.h
  HDRINST usr/include/linux/iso_fs.h
  HDRINST usr/include/linux/nbd-netlink.h
  HDRINST usr/include/linux/sem.h
  HDRINST usr/include/linux/nfs_fs.h
  HDRINST usr/include/linux/igmp.h
  HDRINST usr/include/linux/bfs_fs.h
  HDRINST usr/include/linux/elf.h
  HDRINST usr/include/linux/aio_abi.h
  HDRINST usr/include/linux/param.h
  HDRINST usr/include/linux/msdos_fs.h
  HDRINST usr/include/linux/ipx.h
  HDRINST usr/include/linux/ethtool.h
  HDRINST usr/include/linux/if_pppol2tp.h
  HDRINST usr/include/linux/vfio_ccw.h
  HDRINST usr/include/linux/fiemap.h
  HDRINST usr/include/linux/isdn/capicmd.h
  HDRINST usr/include/linux/v4l2-dv-timings.h
  HDRINST usr/include/linux/atmsvc.h
  HDRINST usr/include/linux/vsockmon.h
  HDRINST usr/include/linux/tls.h
  HDRINST usr/include/linux/bpqether.h
  HDRINST usr/include/linux/lightnvm.h
  HDRINST usr/include/linux/ultrasound.h
  HDRINST usr/include/linux/cm4000_cs.h
  HDRINST usr/include/linux/rxrpc.h
  HDRINST usr/include/linux/nilfs2_api.h
  HDRINST usr/include/linux/qnx4_fs.h
  HDRINST usr/include/linux/if_addr.h
  HDRINST usr/include/linux/atmlec.h
  HDRINST usr/include/linux/tty.h
  HDRINST usr/include/linux/pg.h
  HDRINST usr/include/linux/netfilter_ipv6.h
  HDRINST usr/include/linux/stddef.h
  HDRINST usr/include/linux/cciss_defs.h
  HDRINST usr/include/linux/kd.h
  HDRINST usr/include/linux/radeonfb.h
  HDRINST usr/include/linux/mroute.h
  HDRINST usr/include/linux/sonet.h
  HDRINST usr/include/linux/virtio_gpu.h
  HDRINST usr/include/linux/n_r3964.h
  HDRINST usr/include/linux/posix_acl.h
  HDRINST usr/include/linux/input.h
  HDRINST usr/include/linux/dlm.h
  HDRINST usr/include/linux/rseq.h
  HDRINST usr/include/linux/firewire-cdev.h
  HDRINST usr/include/linux/cramfs_fs.h
  HDRINST usr/include/linux/uhid.h
  HDRINST usr/include/linux/phonet.h
  HDRINST usr/include/linux/if_arp.h
  HDRINST usr/include/linux/userio.h
  HDRINST usr/include/linux/membarrier.h
  HDRINST usr/include/linux/perf_event.h
  HDRINST usr/include/linux/meye.h
  HDRINST usr/include/linux/netdevice.h
  HDRINST usr/include/linux/map_to_7segment.h
  HDRINST usr/include/linux/virtio_scsi.h
  HDRINST usr/include/linux/tipc_sockets_diag.h
  HDRINST usr/include/linux/timerfd.h
  HDRINST usr/include/linux/hdlc.h
  HDRINST usr/include/linux/scc.h
  HDRINST usr/include/linux/auto_dev-ioctl.h
  HDRINST usr/include/linux/memfd.h
  HDRINST usr/include/linux/serial_reg.h
  HDRINST usr/include/linux/ip_vs.h
  HDRINST usr/include/linux/atmapi.h
  HDRINST usr/include/linux/ipmi.h
  HDRINST usr/include/linux/xfrm.h
  HDRINST usr/include/linux/smc.h
  HDRINST usr/include/linux/caif/if_caif.h
  HDRINST usr/include/linux/caif/caif_socket.h
  HDRINST usr/include/linux/tipc_netlink.h
  HDRINST usr/include/linux/reboot.h
  HDRINST usr/include/linux/if_bridge.h
  HDRINST usr/include/linux/arm_sdei.h
  HDRINST usr/include/linux/kexec.h
  HDRINST usr/include/linux/rfkill.h
  HDRINST usr/include/linux/usbdevice_fs.h
  HDRINST usr/include/linux/dlm_netlink.h
  HDRINST usr/include/linux/posix_acl_xattr.h
  HDRINST usr/include/linux/atmppp.h
  HDRINST usr/include/linux/vm_sockets.h
  HDRINST usr/include/linux/spi/spidev.h
  HDRINST usr/include/linux/if_packet.h
  HDRINST usr/include/linux/if_eql.h
  HDRINST usr/include/linux/mdio.h
  HDRINST usr/include/linux/pci_regs.h
  HDRINST usr/include/linux/btrfs_tree.h
  HDRINST usr/include/linux/swab.h
  HDRINST usr/include/linux/am437x-vpfe.h
  HDRINST usr/include/linux/nfs3.h
  HDRINST usr/include/linux/unix_diag.h
  HDRINST usr/include/linux/pcitest.h
  HDRINST usr/include/linux/ppdev.h
  HDRINST usr/include/linux/nl80211.h
  HDRINST usr/include/linux/keyctl.h
  HDRINST usr/include/linux/if_infiniband.h
  HDRINST usr/include/linux/thermal.h
  HDRINST usr/include/linux/v4l2-common.h
  HDRINST usr/include/linux/reiserfs_xattr.h
  HDRINST usr/include/linux/nfs_idmap.h
  HDRINST usr/include/linux/x25.h
  HDRINST usr/include/linux/sockios.h
  HDRINST usr/include/linux/vm_sockets_diag.h
  HDRINST usr/include/linux/hsi/hsi_char.h
  HDRINST usr/include/linux/hsi/cs-protocol.h
  HDRINST usr/include/linux/time.h
  HDRINST usr/include/linux/icmp.h
  HDRINST usr/include/linux/genetlink.h
  HDRINST usr/include/linux/pci.h
  HDRINST usr/include/linux/phantom.h
  HDRINST usr/include/linux/virtio_pci.h
  HDRINST usr/include/linux/sysctl.h
  HDRINST usr/include/linux/dqblk_xfs.h
  HDRINST usr/include/linux/atm_zatm.h
  HDRINST usr/include/linux/if_hippi.h
  HDRINST usr/include/linux/dlm_device.h
  HDRINST usr/include/linux/const.h
  HDRINST usr/include/linux/virtio_balloon.h
  HDRINST usr/include/linux/sync_file.h
  HDRINST usr/include/linux/atmbr2684.h
  HDRINST usr/include/linux/screen_info.h
  HDRINST usr/include/linux/coff.h
  HDRINST usr/include/linux/if_frad.h
  HDRINST usr/include/linux/acct.h
  HDRINST usr/include/linux/gsmmux.h
  HDRINST usr/include/linux/tc_act/tc_ife.h
  HDRINST usr/include/linux/tc_act/tc_bpf.h
  HDRINST usr/include/linux/tc_act/tc_skbedit.h
  HDRINST usr/include/linux/tc_act/tc_mpls.h
  HDRINST usr/include/linux/tc_act/tc_vlan.h
  HDRINST usr/include/linux/tc_act/tc_tunnel_key.h
  HDRINST usr/include/linux/tc_act/tc_ct.h
  HDRINST usr/include/linux/tc_act/tc_csum.h
  HDRINST usr/include/linux/tc_act/tc_nat.h
  HDRINST usr/include/linux/tc_act/tc_ctinfo.h
  HDRINST usr/include/linux/tc_act/tc_connmark.h
  HDRINST usr/include/linux/tc_act/tc_skbmod.h
  HDRINST usr/include/linux/tc_act/tc_sample.h
  HDRINST usr/include/linux/tc_act/tc_mirred.h
  HDRINST usr/include/linux/tc_act/tc_defact.h
  HDRINST usr/include/linux/tc_act/tc_pedit.h
  HDRINST usr/include/linux/tc_act/tc_gact.h
  HDRINST usr/include/linux/tc_act/tc_ipt.h
  HDRINST usr/include/linux/pkt_sched.h
  HDRINST usr/include/linux/dcbnl.h
  HDRINST usr/include/linux/ndctl.h
  HDRINST usr/include/linux/libc-compat.h
  HDRINST usr/include/linux/qnxtypes.h
  HDRINST usr/include/linux/mic_ioctl.h
  HDRINST usr/include/linux/utsname.h
  HDRINST usr/include/linux/scif_ioctl.h
  HDRINST usr/include/linux/serial_core.h
  HDRINST usr/include/linux/netfilter_arp.h
  HDRINST usr/include/linux/netfilter_ipv4/ipt_ecn.h
  HDRINST usr/include/linux/netfilter_ipv4/ipt_CLUSTERIP.h
  HDRINST usr/include/linux/netfilter_ipv4/ipt_TTL.h
  HDRINST usr/include/linux/netfilter_ipv4/ipt_ah.h
  HDRINST usr/include/linux/netfilter_ipv4/ipt_ECN.h
  HDRINST usr/include/linux/netfilter_ipv4/ipt_LOG.h
  HDRINST usr/include/linux/netfilter_ipv4/ipt_ttl.h
  HDRINST usr/include/linux/netfilter_ipv4/ip_tables.h
  HDRINST usr/include/linux/netfilter_ipv4/ipt_REJECT.h
  HDRINST usr/include/linux/fou.h
  HDRINST usr/include/linux/rose.h
  HDRINST usr/include/linux/fpga-dfl.h
  HDRINST usr/include/linux/if_slip.h
  HDRINST usr/include/linux/virtio_crypto.h
  HDRINST usr/include/linux/elf-em.h
  HDRINST usr/include/linux/rpmsg.h
  HDRINST usr/include/linux/ax25.h
  HDRINST usr/include/linux/tcp.h
  HDRINST usr/include/linux/ivtv.h
  HDRINST usr/include/linux/lwtunnel.h
  HDRINST usr/include/linux/socket.h
  HDRINST usr/include/linux/gfs2_ondisk.h
  HDRINST usr/include/linux/bsg.h
  HDRINST usr/include/linux/cn_proc.h
  HDRINST usr/include/linux/b1lli.h
  HDRINST usr/include/linux/limits.h
  HDRINST usr/include/linux/seccomp.h
  HDRINST usr/include/linux/connector.h
  HDRINST usr/include/linux/virtio_blk.h
  HDRINST usr/include/linux/hash_info.h
  HDRINST usr/include/linux/ip.h
  HDRINST usr/include/linux/atalk.h
  HDRINST usr/include/linux/wait.h
  HDRINST usr/include/linux/adb.h
  HDRINST usr/include/linux/resource.h
  HDRINST usr/include/linux/taskstats.h
  HDRINST usr/include/linux/smc_diag.h
  HDRINST usr/include/linux/mman.h
  HDRINST usr/include/linux/udf_fs_i.h
  HDRINST usr/include/linux/net_tstamp.h
  HDRINST usr/include/linux/wireless.h
  HDRINST usr/include/linux/tty_flags.h
  HDRINST usr/include/linux/psp-sev.h
  HDRINST usr/include/linux/virtio_ids.h
  HDRINST usr/include/linux/signalfd.h
  HDRINST usr/include/linux/fscrypt.h
  HDRINST usr/include/linux/input-event-codes.h
  HDRINST usr/include/linux/in_route.h
  HDRINST usr/include/linux/irqnr.h
  HDRINST usr/include/linux/ncsi.h
  HDRINST usr/include/linux/dm-ioctl.h
  HDRINST usr/include/linux/raid/md_p.h
  HDRINST usr/include/linux/raid/md_u.h
  HDRINST usr/include/linux/switchtec_ioctl.h
  HDRINST usr/include/linux/kdev_t.h
  HDRINST usr/include/linux/virtio_fs.h
  HDRINST usr/include/linux/if_macsec.h
  HDRINST usr/include/linux/llc.h
  HDRINST usr/include/linux/erspan.h
  HDRINST usr/include/linux/unistd.h
  HDRINST usr/include/linux/edd.h
  HDRINST usr/include/linux/dlmconstants.h
  HDRINST usr/include/linux/random.h
  HDRINST usr/include/linux/arcfb.h
  HDRINST usr/include/linux/mroute6.h
  HDRINST usr/include/linux/psample.h
  HDRINST usr/include/linux/v4l2-mediabus.h
  HDRINST usr/include/linux/mpls_iptunnel.h
  HDRINST usr/include/linux/bpfilter.h
  HDRINST usr/include/linux/android/binder.h
  HDRINST usr/include/linux/android/binderfs.h
  HDRINST usr/include/linux/uleds.h
  HDRINST usr/include/linux/wimax.h
  HDRINST usr/include/linux/parport.h
  HDRINST usr/include/linux/fcntl.h
  HDRINST usr/include/linux/tiocl.h
  HDRINST usr/include/linux/cgroupstats.h
  HDRINST usr/include/linux/hdreg.h
  HDRINST usr/include/linux/timex.h
  HDRINST usr/include/linux/fib_rules.h
  HDRINST usr/include/linux/atm.h
  HDRINST usr/include/linux/hsr_netlink.h
  HDRINST usr/include/linux/dlm_plock.h
  HDRINST usr/include/linux/smiapp.h
  HDRINST usr/include/linux/io_uring.h
  HDRINST usr/include/linux/eventpoll.h
  HDRINST usr/include/linux/tcp_metrics.h
  HDRINST usr/include/linux/netconf.h
  HDRINST usr/include/linux/mic_common.h
  HDRINST usr/include/linux/nubus.h
  HDRINST usr/include/linux/tipc_config.h
  HDRINST usr/include/linux/filter.h
  HDRINST usr/include/linux/netfilter_decnet.h
  HDRINST usr/include/linux/nfs_mount.h
  HDRINST usr/include/linux/in6.h
  HDRINST usr/include/linux/sctp.h
  HDRINST usr/include/linux/mqueue.h
  HDRINST usr/include/linux/cec-funcs.h
  HDRINST usr/include/linux/time_types.h
  HDRINST usr/include/linux/gtp.h
  HDRINST usr/include/linux/agpgart.h
  HDRINST usr/include/linux/if_bonding.h
  HDRINST usr/include/linux/hpet.h
  HDRINST usr/include/linux/gameport.h
  HDRINST usr/include/linux/genwqe/genwqe_card.h
  HDRINST usr/include/linux/gpio.h
  HDRINST usr/include/linux/rtnetlink.h
  HDRINST usr/include/linux/virtio_9p.h
  HDRINST usr/include/linux/nilfs2_ondisk.h
  HDRINST usr/include/linux/vbox_vmmdev_types.h
  HDRINST usr/include/linux/binfmts.h
  HDRINST usr/include/linux/nfs2.h
  HDRINST usr/include/linux/i2o-dev.h
  HDRINST usr/include/linux/nbd.h
  HDRINST usr/include/linux/if_ppp.h
  HDRINST usr/include/linux/ioctl.h
  HDRINST usr/include/linux/auto_fs4.h
  HDRINST usr/include/linux/atm_idt77105.h
  HDRINST usr/include/linux/seg6_hmac.h
  HDRINST usr/include/linux/sock_diag.h
  HDRINST usr/include/linux/elfcore.h
  HDRINST usr/include/linux/v4l2-controls.h
  HDRINST usr/include/linux/iio/events.h
  HDRINST usr/include/linux/iio/types.h
  HDRINST usr/include/linux/ife.h
  HDRINST usr/include/linux/capability.h
  HDRINST usr/include/linux/synclink.h
  HDRINST usr/include/linux/signal.h
  HDRINST usr/include/linux/vtpm_proxy.h
  HDRINST usr/include/linux/videodev2.h
  HDRINST usr/include/linux/lp.h
  HDRINST usr/include/linux/mount.h
  HDRINST usr/include/linux/patchkey.h
  HDRINST usr/include/linux/uio.h
  HDRINST usr/include/linux/batman_adv.h
  HDRINST usr/include/linux/auto_fs.h
  HDRINST usr/include/linux/hid.h
  HDRINST usr/include/linux/posix_types.h
  HDRINST usr/include/linux/cycx_cfm.h
  HDRINST usr/include/linux/max2175.h
  HDRINST usr/include/linux/sonypi.h
  HDRINST usr/include/linux/kernelcapi.h
  HDRINST usr/include/linux/userfaultfd.h
  HDRINST usr/include/linux/ipsec.h
  HDRINST usr/include/linux/if.h
  HDRINST usr/include/linux/string.h
  HDRINST usr/include/linux/rio_cm_cdev.h
  HDRINST usr/include/linux/ppp_defs.h
  HDRINST usr/include/linux/ppp-ioctl.h
  HDRINST usr/include/linux/prctl.h
  HDRINST usr/include/linux/pmu.h
  HDRINST usr/include/linux/blkzoned.h
  HDRINST usr/include/linux/vbox_err.h
  HDRINST usr/include/linux/snmp.h
  HDRINST usr/include/linux/poll.h
  HDRINST usr/include/linux/efs_fs_sb.h
  HDRINST usr/include/linux/dns_resolver.h
  HDRINST usr/include/linux/xilinx-v4l2-controls.h
  HDRINST usr/include/linux/mtio.h
  HDRINST usr/include/linux/fsi.h
  HDRINST usr/include/linux/if_phonet.h
  HDRINST usr/include/linux/kfd_ioctl.h
  HDRINST usr/include/linux/elf-fdpic.h
  HDRINST usr/include/linux/dccp.h
  HDRINST usr/include/linux/cryptouser.h
  HDRINST usr/include/linux/kvm_para.h
  HDRINST usr/include/linux/sound.h
  HDRINST usr/include/linux/route.h
  HDRINST usr/include/linux/atm_tcp.h
  HDRINST usr/include/linux/stm.h
  HDRINST usr/include/linux/kcov.h
  HDRINST usr/include/linux/atmarp.h
  HDRINST usr/include/linux/baycom.h
  HDRINST usr/include/linux/kernel-page-flags.h
  HDRINST usr/include/linux/if_plip.h
  HDRINST usr/include/linux/ptrace.h
  HDRINST usr/include/linux/tipc.h
  HDRINST usr/include/linux/hw_breakpoint.h
  HDRINST usr/include/linux/cdrom.h
  HDRINST usr/include/linux/kcm.h
  HDRINST usr/include/linux/if_xdp.h
  HDRINST usr/include/linux/ipmi_bmc.h
  HDRINST usr/include/linux/dm-log-userspace.h
  HDRINST usr/include/linux/kvm.h
  HDRINST usr/include/linux/btf.h
  HDRINST usr/include/linux/nexthop.h
  HDRINST usr/include/linux/virtio_console.h
  HDRINST usr/include/linux/keyboard.h
  HDRINST usr/include/linux/atmdev.h
  HDRINST usr/include/linux/un.h
  HDRINST usr/include/linux/inotify.h
  HDRINST usr/include/linux/netrom.h
  HDRINST usr/include/linux/vhost.h
  HDRINST usr/include/linux/atmmpc.h
  HDRINST usr/include/linux/netfilter_arp/arp_tables.h
  HDRINST usr/include/linux/netfilter_arp/arpt_mangle.h
  HDRINST usr/include/linux/seg6_genl.h
  HDRINST usr/include/linux/hyperv.h
  HDRINST usr/include/linux/tee.h
  HDRINST usr/include/linux/soundcard.h
  HDRINST usr/include/linux/bcache.h
  HDRINST usr/include/linux/ipmi_msgdefs.h
  HDRINST usr/include/linux/atmioc.h
  HDRINST usr/include/linux/atmclip.h
  HDRINST usr/include/linux/tc_ematch/tc_em_text.h
  HDRINST usr/include/linux/tc_ematch/tc_em_ipt.h
  HDRINST usr/include/linux/tc_ematch/tc_em_cmp.h
  HDRINST usr/include/linux/tc_ematch/tc_em_meta.h
  HDRINST usr/include/linux/tc_ematch/tc_em_nbyte.h
  HDRINST usr/include/linux/ipv6_route.h
  HDRINST usr/include/linux/times.h
  HDRINST usr/include/linux/ipv6.h
  HDRINST usr/include/linux/major.h
  HDRINST usr/include/linux/oom.h
  HDRINST usr/include/linux/fanotify.h
  HDRINST usr/include/linux/i2c-dev.h
  HDRINST usr/include/linux/seg6_local.h
  HDRINST usr/include/linux/utime.h
  HDRINST usr/include/linux/net_dropmon.h
  HDRINST usr/include/linux/cyclades.h
  HDRINST usr/include/linux/ip6_tunnel.h
  HDRINST usr/include/linux/netfilter.h
  HDRINST usr/include/linux/termios.h
  HDRINST usr/include/linux/suspend_ioctls.h
  HDRINST usr/include/linux/if_addrlabel.h
  HDRINST usr/include/linux/minix_fs.h
  HDRINST usr/include/linux/romfs_fs.h
  HDRINST usr/include/linux/bcm933xx_hcs.h
  HDRINST usr/include/linux/packet_diag.h
  HDRINST usr/include/linux/coda.h
  HDRINST usr/include/linux/nfsd/nfsfh.h
  HDRINST usr/include/linux/nfsd/export.h
  HDRINST usr/include/linux/nfsd/debug.h
  HDRINST usr/include/linux/nfsd/stats.h
  HDRINST usr/include/linux/nfsd/cld.h
  HDRINST usr/include/linux/magic.h
  HDRINST usr/include/linux/fuse.h
  HDRINST usr/include/linux/vboxguest.h
  HDRINST usr/include/linux/watchdog.h
  HDRINST usr/include/linux/mpls.h
  HDRINST usr/include/linux/virtio_ring.h
  HDRINST usr/include/linux/atmsap.h
  HDRINST usr/include/linux/can.h
  HDRINST usr/include/linux/dma-buf.h
  HDRINST usr/include/linux/if_vlan.h
  HDRINST usr/include/linux/fb.h
  HDRINST usr/include/linux/hiddev.h
  HDRINST usr/include/linux/wimax/i2400m.h
  HDRINST usr/include/linux/dn.h
  HDRINST usr/include/linux/v4l2-subdev.h
  HDRINST usr/include/linux/virtio_vsock.h
  HDRINST usr/include/linux/netlink.h
  HDRINST usr/include/linux/udmabuf.h
  HDRINST usr/include/linux/selinux_netlink.h
  HDRINST usr/include/linux/uvcvideo.h
  HDRINST usr/include/linux/jffs2.h
  HDRINST usr/include/linux/if_x25.h
  HDRINST usr/include/linux/joystick.h
  HDRINST usr/include/linux/nfs.h
  HDRINST usr/include/linux/msg.h
  HDRINST usr/include/linux/vfio.h
  HDRINST usr/include/linux/blkpg.h
  HDRINST usr/include/linux/omap3isp.h
  HDRINST usr/include/linux/atm_he.h
  HDRINST usr/include/linux/veth.h
  HDRINST usr/include/linux/atm_eni.h
  HDRINST usr/include/linux/netlink_diag.h
  HDRINST usr/include/linux/media.h
  HDRINST usr/include/linux/bt-bmc.h
  HDRINST usr/include/linux/if_ltalk.h
  HDRINST usr/include/linux/virtio_types.h
  HDRINST usr/include/linux/hdlcdrv.h
  HDRINST usr/include/linux/ptp_clock.h
  HDRINST usr/include/linux/usbip.h
  HDRINST usr/include/linux/if_team.h
  HDRINST usr/include/linux/a.out.h
  HDRINST usr/include/linux/coresight-stm.h
  HDRINST usr/include/linux/capi.h
  HDRINST usr/include/linux/nvram.h
  HDRINST usr/include/linux/bpf_perf_event.h
  HDRINST usr/include/linux/xdp_diag.h
  HDRINST usr/include/linux/iommu.h
  HDRINST usr/include/linux/virtio_input.h
  HDRINST usr/include/linux/virtio_rng.h
  HDRINST usr/include/linux/mei.h
  HDRINST usr/include/linux/uuid.h
  HDRINST usr/include/linux/if_fddi.h
  HDRINST usr/include/linux/isst_if.h
  HDRINST usr/include/linux/pr.h
  HDRINST usr/include/linux/if_pppox.h
  HDRINST usr/include/linux/wmi.h
  HDRINST usr/include/linux/vt.h
  HDRINST usr/include/linux/bpf.h
  HDRINST usr/include/linux/sysinfo.h
  HDRINST usr/include/linux/if_ether.h
  HDRINST usr/include/linux/cuda.h
  HDRINST usr/include/linux/audit.h
  HDRINST usr/include/linux/qemu_fw_cfg.h
  HDRINST usr/include/linux/openvswitch.h
  HDRINST usr/include/linux/can/j1939.h
  HDRINST usr/include/linux/can/gw.h
  HDRINST usr/include/linux/can/error.h
  HDRINST usr/include/linux/can/netlink.h
  HDRINST usr/include/linux/can/vxcan.h
  HDRINST usr/include/linux/can/bcm.h
  HDRINST usr/include/linux/can/raw.h
  HDRINST usr/include/linux/fadvise.h
  HDRINST usr/include/linux/firewire-constants.h
  HDRINST usr/include/linux/netfilter/xt_connbytes.h
  HDRINST usr/include/linux/netfilter/ipset/ip_set_bitmap.h
  HDRINST usr/include/linux/netfilter/ipset/ip_set_hash.h
  HDRINST usr/include/linux/netfilter/ipset/ip_set.h
  HDRINST usr/include/linux/netfilter/ipset/ip_set_list.h
  HDRINST usr/include/linux/netfilter/nfnetlink.h
  HDRINST usr/include/linux/netfilter/nf_tables.h
  HDRINST usr/include/linux/netfilter/xt_RATEEST.h
  HDRINST usr/include/linux/netfilter/nf_conntrack_tuple_common.h
  HDRINST usr/include/linux/netfilter/xt_LOG.h
  HDRINST usr/include/linux/netfilter/nf_tables_compat.h
  HDRINST usr/include/linux/netfilter/xt_recent.h
  HDRINST usr/include/linux/netfilter/x_tables.h
  HDRINST usr/include/linux/netfilter/nfnetlink_cthelper.h
  HDRINST usr/include/linux/netfilter/xt_mac.h
  HDRINST usr/include/linux/netfilter/xt_TEE.h
  HDRINST usr/include/linux/netfilter/xt_ipcomp.h
  HDRINST usr/include/linux/netfilter/nf_conntrack_common.h
  HDRINST usr/include/linux/netfilter/xt_multiport.h
  HDRINST usr/include/linux/netfilter/xt_nfacct.h
  HDRINST usr/include/linux/netfilter/xt_CLASSIFY.h
  HDRINST usr/include/linux/netfilter/xt_rateest.h
  HDRINST usr/include/linux/netfilter/xt_CT.h
  HDRINST usr/include/linux/netfilter/nf_nat.h
  HDRINST usr/include/linux/netfilter/xt_u32.h
  HDRINST usr/include/linux/netfilter/xt_pkttype.h
  HDRINST usr/include/linux/netfilter/xt_conntrack.h
  HDRINST usr/include/linux/netfilter/xt_esp.h
  HDRINST usr/include/linux/netfilter/xt_socket.h
  HDRINST usr/include/linux/netfilter/nfnetlink_compat.h
  HDRINST usr/include/linux/netfilter/xt_osf.h
  HDRINST usr/include/linux/netfilter/xt_dccp.h
  HDRINST usr/include/linux/netfilter/xt_sctp.h
  HDRINST usr/include/linux/netfilter/xt_statistic.h
  HDRINST usr/include/linux/netfilter/xt_time.h
  HDRINST usr/include/linux/netfilter/xt_NFQUEUE.h
  HDRINST usr/include/linux/netfilter/xt_set.h
  HDRINST usr/include/linux/netfilter/xt_comment.h
  HDRINST usr/include/linux/netfilter/xt_DSCP.h
  HDRINST usr/include/linux/netfilter/xt_connlimit.h
  HDRINST usr/include/linux/netfilter/xt_dscp.h
  HDRINST usr/include/linux/netfilter/nfnetlink_queue.h
  HDRINST usr/include/linux/netfilter/xt_ecn.h
  HDRINST usr/include/linux/netfilter/xt_cluster.h
  HDRINST usr/include/linux/netfilter/xt_quota.h
  HDRINST usr/include/linux/netfilter/xt_TCPMSS.h
  HDRINST usr/include/linux/netfilter/xt_state.h
  HDRINST usr/include/linux/netfilter/xt_helper.h
  HDRINST usr/include/linux/netfilter/xt_addrtype.h
  HDRINST usr/include/linux/netfilter/xt_rpfilter.h
  HDRINST usr/include/linux/netfilter/xt_SECMARK.h
  HDRINST usr/include/linux/netfilter/xt_cgroup.h
  HDRINST usr/include/linux/netfilter/xt_length.h
  HDRINST usr/include/linux/netfilter/nf_synproxy.h
  HDRINST usr/include/linux/netfilter/xt_LED.h
  HDRINST usr/include/linux/netfilter/xt_MARK.h
  HDRINST usr/include/linux/netfilter/nf_conntrack_tcp.h
  HDRINST usr/include/linux/netfilter/xt_realm.h
  HDRINST usr/include/linux/netfilter/xt_physdev.h
  HDRINST usr/include/linux/netfilter/xt_NFLOG.h
  HDRINST usr/include/linux/netfilter/xt_AUDIT.h
  HDRINST usr/include/linux/netfilter/xt_CONNSECMARK.h
  HDRINST usr/include/linux/netfilter/xt_connmark.h
  HDRINST usr/include/linux/netfilter/xt_TCPOPTSTRIP.h
  HDRINST usr/include/linux/netfilter/xt_devgroup.h
  HDRINST usr/include/linux/netfilter/nf_log.h
  HDRINST usr/include/linux/netfilter/xt_mark.h
  HDRINST usr/include/linux/netfilter/xt_policy.h
  HDRINST usr/include/linux/netfilter/nfnetlink_cttimeout.h
  HDRINST usr/include/linux/netfilter/xt_tcpudp.h
  HDRINST usr/include/linux/netfilter/nfnetlink_conntrack.h
  HDRINST usr/include/linux/netfilter/xt_cpu.h
  HDRINST usr/include/linux/netfilter/xt_hashlimit.h
  HDRINST usr/include/linux/netfilter/xt_l2tp.h
  HDRINST usr/include/linux/netfilter/xt_SYNPROXY.h
  HDRINST usr/include/linux/netfilter/nfnetlink_acct.h
  HDRINST usr/include/linux/netfilter/xt_string.h
  HDRINST usr/include/linux/netfilter/xt_TPROXY.h
  HDRINST usr/include/linux/netfilter/nf_conntrack_sctp.h
  HDRINST usr/include/linux/netfilter/nfnetlink_osf.h
  HDRINST usr/include/linux/netfilter/xt_CHECKSUM.h
  HDRINST usr/include/linux/netfilter/xt_ipvs.h
  HDRINST usr/include/linux/netfilter/xt_CONNMARK.h
  HDRINST usr/include/linux/netfilter/xt_iprange.h
  HDRINST usr/include/linux/netfilter/nf_conntrack_ftp.h
  HDRINST usr/include/linux/netfilter/xt_IDLETIMER.h
  HDRINST usr/include/linux/netfilter/xt_limit.h
  HDRINST usr/include/linux/netfilter/nfnetlink_log.h
  HDRINST usr/include/linux/netfilter/xt_connlabel.h
  HDRINST usr/include/linux/netfilter/xt_HMARK.h
  HDRINST usr/include/linux/netfilter/xt_tcpmss.h
  HDRINST usr/include/linux/netfilter/xt_owner.h
  HDRINST usr/include/linux/netfilter/xt_bpf.h
  HDRINST usr/include/linux/reiserfs_fs.h
  HDRINST usr/include/linux/media-bus-format.h
  HDRINST usr/include/linux/toshiba.h
  HDRINST usr/include/linux/kcmp.h
  HDRINST usr/include/linux/cifs/cifs_mount.h
  HDRINST usr/include/linux/zorro.h
  HDRINST usr/include/linux/adfs_fs.h
  HDRINST usr/include/linux/netfilter_bridge/ebt_ip6.h
  HDRINST usr/include/linux/netfilter_bridge/ebt_limit.h
  HDRINST usr/include/linux/netfilter_bridge/ebtables.h
  HDRINST usr/include/linux/netfilter_bridge/ebt_802_3.h
  HDRINST usr/include/linux/netfilter_bridge/ebt_log.h
  HDRINST usr/include/linux/netfilter_bridge/ebt_arpreply.h
  HDRINST usr/include/linux/netfilter_bridge/ebt_nflog.h
  HDRINST usr/include/linux/netfilter_bridge/ebt_ip.h
  HDRINST usr/include/linux/netfilter_bridge/ebt_nat.h
  HDRINST usr/include/linux/netfilter_bridge/ebt_pkttype.h
  HDRINST usr/include/linux/netfilter_bridge/ebt_among.h
  HDRINST usr/include/linux/netfilter_bridge/ebt_redirect.h
  HDRINST usr/include/linux/netfilter_bridge/ebt_stp.h
  HDRINST usr/include/linux/netfilter_bridge/ebt_mark_m.h
  HDRINST usr/include/linux/netfilter_bridge/ebt_mark_t.h
  HDRINST usr/include/linux/netfilter_bridge/ebt_vlan.h
  HDRINST usr/include/linux/netfilter_bridge/ebt_arp.h
  HDRINST usr/include/linux/ivtvfb.h
  HDRINST usr/include/linux/netfilter_bridge.h
  HDRINST usr/include/linux/raw.h
  HDRINST usr/include/linux/cec.h
  HDRINST usr/include/linux/inet_diag.h
  HDRINST usr/include/linux/if_arcnet.h
  HDRINST usr/include/linux/sched.h
  HDRINST usr/include/linux/zorro_ids.h
  HDRINST usr/include/linux/aspeed-lpc-ctrl.h
  HDRINST usr/include/linux/personality.h
  HDRINST usr/include/linux/uinput.h
  HDRINST usr/include/linux/usb/ch9.h
  HDRINST usr/include/linux/usb/g_uvc.h
  HDRINST usr/include/linux/usb/tmc.h
  HDRINST usr/include/linux/usb/midi.h
  HDRINST usr/include/linux/usb/cdc-wdm.h
  HDRINST usr/include/linux/usb/gadgetfs.h
  HDRINST usr/include/linux/usb/audio.h
  HDRINST usr/include/linux/usb/functionfs.h
  HDRINST usr/include/linux/usb/cdc.h
  HDRINST usr/include/linux/usb/g_printer.h
  HDRINST usr/include/linux/usb/video.h
  HDRINST usr/include/linux/usb/ch11.h
  HDRINST usr/include/linux/usb/charger.h
  HDRINST usr/include/linux/mmc/ioctl.h
  HDRINST usr/include/linux/cciss_ioctl.h
  HDRINST usr/include/linux/btrfs.h
  HDRINST usr/include/linux/sched/types.h
  HDRINST usr/include/linux/fsverity.h
  HDRINST usr/include/linux/mmtimer.h
  HDRINST usr/include/linux/virtio_config.h
  HDRINST usr/include/linux/quota.h
  HDRINST usr/include/linux/qrtr.h
  HDRINST usr/include/linux/rds.h
  HDRINST usr/include/linux/rio_mport_cdev.h
  HDRINST usr/include/linux/target_core_user.h
  HDRINST usr/include/linux/mempolicy.h
  HDRINST usr/include/linux/net_namespace.h
  HDRINST usr/include/linux/types.h
  HDRINST usr/include/linux/nfc.h
  HDRINST usr/include/linux/devlink.h
  HDRINST usr/include/linux/nfs4_mount.h
  HDRINST usr/include/linux/rtc.h
  HDRINST usr/include/linux/pps.h
  HDRINST usr/include/linux/gen_stats.h
  HDRINST usr/include/linux/mii.h
  HDRINST usr/include/linux/i8k.h
  HDRINST usr/include/linux/errno.h
  HDRINST usr/include/linux/futex.h
  HDRINST usr/include/linux/psci.h
  HDRINST usr/include/linux/virtio_net.h
  HDRINST usr/include/linux/ipc.h
  HDRINST usr/include/linux/seg6.h
  HDRINST usr/include/linux/errqueue.h
  HDRINST usr/include/linux/ppp-comp.h
  HDRINST usr/include/linux/icmpv6.h
  HDRINST usr/include/linux/l2tp.h
  HDRINST usr/include/linux/shm.h
  HDRINST usr/include/linux/falloc.h
  HDRINST usr/include/linux/hdlc/ioctl.h
  HDRINST usr/include/linux/if_tunnel.h
  HDRINST usr/include/linux/serio.h
  HDRINST usr/include/linux/fd.h
  HDRINST usr/include/linux/stat.h
  HDRINST usr/include/linux/batadv_packet.h
  HDRINST usr/include/linux/gigaset_dev.h
  HDRINST usr/include/linux/fsl_hypervisor.h
  HDRINST usr/include/linux/ila.h
  HDRINST usr/include/linux/virtio_mmio.h
  HDRINST usr/include/linux/i2c.h
  HDRINST usr/include/linux/auxvec.h
  HDRINST usr/include/linux/fs.h
  HDRINST usr/include/linux/hysdn_if.h
  HDRINST usr/include/linux/apm_bios.h
  HDRINST usr/include/linux/if_alg.h
  HDRINST usr/include/linux/xattr.h
  HDRINST usr/include/linux/nvme_ioctl.h
  HDRINST usr/include/linux/virtio_pmem.h
  HDRINST usr/include/linux/udp.h
  HDRINST usr/include/linux/omapfb.h
  HDRINST usr/include/linux/dvb/version.h
  HDRINST usr/include/linux/dvb/ca.h
  HDRINST usr/include/linux/dvb/frontend.h
  HDRINST usr/include/linux/dvb/osd.h
  HDRINST usr/include/linux/dvb/dmx.h
  HDRINST usr/include/linux/dvb/audio.h
  HDRINST usr/include/linux/dvb/video.h
  HDRINST usr/include/linux/dvb/net.h
  HDRINST usr/include/linux/if_link.h
  HDRINST usr/include/linux/serial.h
  HDRINST usr/include/linux/if_tun.h
  HDRINST usr/include/linux/blktrace_api.h
  HDRINST usr/include/linux/byteorder/little_endian.h
  HDRINST usr/include/linux/byteorder/big_endian.h
  HDRINST usr/include/linux/affs_hardblocks.h
  HDRINST usr/include/linux/nfsacl.h
  HDRINST usr/include/linux/lirc.h
  HDRINST usr/include/linux/neighbour.h
  HDRINST usr/include/linux/vhost_types.h
  HDRINST usr/include/linux/atm_nicstar.h
  HDRINST usr/include/linux/hidraw.h
  HDRINST usr/include/linux/nfs4.h
  HDRINST usr/include/linux/virtio_iommu.h
  HDRINST usr/include/linux/securebits.h
  HDRINST usr/include/linux/sed-opal.h
  HDRINST usr/include/linux/net.h
  HDRINST usr/include/linux/if_fc.h
  HDRINST usr/include/linux/in.h
  HDRINST usr/include/linux/sdla.h
  HDRINST usr/include/linux/fsmap.h
  HDRINST usr/include/linux/pfkeyv2.h
  HDRINST usr/include/linux/module.h
  HDRINST usr/include/linux/pktcdvd.h
  HDRINST usr/include/linux/bpf_common.h
  HDRINST usr/include/linux/vmcore.h
  HDRINST usr/include/linux/netfilter_ipv4.h
  HDRINST usr/include/linux/chio.h
  HDRINST usr/include/linux/netfilter_ipv6/ip6t_REJECT.h
  HDRINST usr/include/linux/netfilter_ipv6/ip6t_rt.h
  HDRINST usr/include/linux/netfilter_ipv6/ip6t_frag.h
  HDRINST usr/include/linux/netfilter_ipv6/ip6t_opts.h
  HDRINST usr/include/linux/netfilter_ipv6/ip6t_mh.h
  HDRINST usr/include/linux/netfilter_ipv6/ip6_tables.h
  HDRINST usr/include/linux/netfilter_ipv6/ip6t_hl.h
  HDRINST usr/include/linux/netfilter_ipv6/ip6t_NPT.h
  HDRINST usr/include/linux/netfilter_ipv6/ip6t_LOG.h
  HDRINST usr/include/linux/netfilter_ipv6/ip6t_ipv6header.h
  HDRINST usr/include/linux/netfilter_ipv6/ip6t_ah.h
  HDRINST usr/include/linux/netfilter_ipv6/ip6t_srh.h
  HDRINST usr/include/linux/netfilter_ipv6/ip6t_HL.h
  HDRINST usr/include/linux/if_cablemodem.h
  HDRINST usr/include/linux/sunrpc/debug.h
  HDRINST usr/include/linux/kernel.h
  HDRINST usr/include/linux/seg6_iptunnel.h
  HDRINST usr/include/linux/aspeed-p2a-ctrl.h
  HDRINST usr/include/linux/loop.h
  HDRINST usr/include/linux/nsfs.h
  HDRINST usr/include/linux/pkt_cls.h
  HDRINST usr/include/linux/matroxfb.h
  HDRINST usr/include/linux/fdreg.h
  HDRINST usr/include/sound/asequencer.h
  HDRINST usr/include/sound/hdspm.h
  HDRINST usr/include/sound/firewire.h
  HDRINST usr/include/sound/hdsp.h
  HDRINST usr/include/sound/compress_params.h
  HDRINST usr/include/sound/snd_sst_tokens.h
  HDRINST usr/include/sound/emu10k1.h
  HDRINST usr/include/sound/skl-tplg-interface.h
  HDRINST usr/include/sound/usb_stream.h
  HDRINST usr/include/sound/asoc.h
  HDRINST usr/include/sound/tlv.h
  HDRINST usr/include/sound/asound_fm.h
  HDRINST usr/include/sound/asound.h
  HDRINST usr/include/sound/sb16_csp.h
  HDRINST usr/include/sound/sof/fw.h
  HDRINST usr/include/sound/sof/abi.h
  HDRINST usr/include/sound/sof/tokens.h
  HDRINST usr/include/sound/sof/header.h
  HDRINST usr/include/sound/compress_offload.h
  HDRINST usr/include/sound/sfnt_info.h
  HDRINST usr/include/scsi/fc/fc_gs.h
  HDRINST usr/include/scsi/fc/fc_els.h
  HDRINST usr/include/scsi/fc/fc_ns.h
  HDRINST usr/include/scsi/fc/fc_fs.h
  HDRINST usr/include/scsi/scsi_netlink_fc.h
  HDRINST usr/include/scsi/scsi_bsg_ufs.h
  HDRINST usr/include/scsi/scsi_bsg_fc.h
  HDRINST usr/include/scsi/cxlflash_ioctl.h
  HDRINST usr/include/scsi/scsi_netlink.h
  HDRINST usr/include/linux/version.h
  HDRINST usr/include/asm/posix_types_64.h
  HDRINST usr/include/asm/msr.h
  HDRINST usr/include/asm/swab.h
  HDRINST usr/include/asm/debugreg.h
  HDRINST usr/include/asm/boot.h
  HDRINST usr/include/asm/hwcap2.h
  HDRINST usr/include/asm/setup.h
  HDRINST usr/include/asm/bitsperlong.h
  HDRINST usr/include/asm/statfs.h
  HDRINST usr/include/asm/mman.h
  HDRINST usr/include/asm/perf_regs.h
  HDRINST usr/include/asm/sembuf.h
  HDRINST usr/include/asm/unistd.h
  HDRINST usr/include/asm/siginfo.h
  HDRINST usr/include/asm/vmx.h
  HDRINST usr/include/asm/svm.h
  HDRINST usr/include/asm/mce.h
  HDRINST usr/include/asm/signal.h
  HDRINST usr/include/asm/ldt.h
  HDRINST usr/include/asm/posix_types.h
  HDRINST usr/include/asm/shmbuf.h
  HDRINST usr/include/asm/prctl.h
  HDRINST usr/include/asm/msgbuf.h
  HDRINST usr/include/asm/kvm_para.h
  HDRINST usr/include/asm/ptrace.h
  HDRINST usr/include/asm/hw_breakpoint.h
  HDRINST usr/include/asm/kvm.h
  HDRINST usr/include/asm/ptrace-abi.h
  HDRINST usr/include/asm/posix_types_32.h
  HDRINST usr/include/asm/byteorder.h
  HDRINST usr/include/asm/ucontext.h
  HDRINST usr/include/asm/ist.h
  HDRINST usr/include/asm/posix_types_x32.h
  HDRINST usr/include/asm/processor-flags.h
  HDRINST usr/include/asm/a.out.h
  HDRINST usr/include/asm/mtrr.h
  HDRINST usr/include/asm/sigcontext32.h
  HDRINST usr/include/asm/sigcontext.h
  HDRINST usr/include/asm/vm86.h
  HDRINST usr/include/asm/bootparam.h
  HDRINST usr/include/asm/stat.h
  HDRINST usr/include/asm/kvm_perf.h
  HDRINST usr/include/asm/auxvec.h
  HDRINST usr/include/asm/vsyscall.h
  HDRINST usr/include/asm/e820.h
  HDRINST usr/include/asm/unistd_x32.h
  HDRINST usr/include/asm/unistd_64.h
  HDRINST usr/include/asm/unistd_32.h
  HDRINST usr/include/asm/types.h
  HDRINST usr/include/asm/termios.h
  HDRINST usr/include/asm/termbits.h
  HDRINST usr/include/asm/sockios.h
  HDRINST usr/include/asm/socket.h
  HDRINST usr/include/asm/resource.h
  HDRINST usr/include/asm/poll.h
  HDRINST usr/include/asm/param.h
  HDRINST usr/include/asm/ipcbuf.h
  HDRINST usr/include/asm/ioctls.h
  HDRINST usr/include/asm/ioctl.h
  HDRINST usr/include/asm/fcntl.h
  HDRINST usr/include/asm/errno.h
  HDRINST usr/include/asm/bpf_perf_event.h
  INSTALL ./usr/include
make[1]: Leaving directory '/usr/src/perf_selftests-x86_64-rhel-7.6-kselfte=
sts-da43712a7262891317883d4b3a909fb18dac4b1d'
gcc -Wall -Wl,--no-as-needed -O2 -g -I../../../../usr/include/    reuseport=
_bpf.c  -o /usr/src/perf_selftests-x86_64-rhel-7.6-kselftests-da43712a72628=
91317883d4b3a909fb18dac4b1d/tools/testing/selftests/net/reuseport_bpf
gcc -Wall -Wl,--no-as-needed -O2 -g -I../../../../usr/include/    reuseport=
_bpf_cpu.c  -o /usr/src/perf_selftests-x86_64-rhel-7.6-kselftests-da43712a7=
262891317883d4b3a909fb18dac4b1d/tools/testing/selftests/net/reuseport_bpf_c=
pu
gcc -Wall -Wl,--no-as-needed -O2 -g -I../../../../usr/include/    reuseport=
_bpf_numa.c -lnuma -o /usr/src/perf_selftests-x86_64-rhel-7.6-kselftests-da=
43712a7262891317883d4b3a909fb18dac4b1d/tools/testing/selftests/net/reusepor=
t_bpf_numa
gcc -Wall -Wl,--no-as-needed -O2 -g -I../../../../usr/include/    reuseport=
_dualstack.c  -o /usr/src/perf_selftests-x86_64-rhel-7.6-kselftests-da43712=
a7262891317883d4b3a909fb18dac4b1d/tools/testing/selftests/net/reuseport_dua=
lstack
gcc -Wall -Wl,--no-as-needed -O2 -g -I../../../../usr/include/    reuseaddr=
_conflict.c  -o /usr/src/perf_selftests-x86_64-rhel-7.6-kselftests-da43712a=
7262891317883d4b3a909fb18dac4b1d/tools/testing/selftests/net/reuseaddr_conf=
lict
gcc -Wall -Wl,--no-as-needed -O2 -g -I../../../../usr/include/    tls.c  -o=
 /usr/src/perf_selftests-x86_64-rhel-7.6-kselftests-da43712a7262891317883d4=
b3a909fb18dac4b1d/tools/testing/selftests/net/tls
gcc -Wall -Wl,--no-as-needed -O2 -g -I../../../../usr/include/    socket.c =
 -o /usr/src/perf_selftests-x86_64-rhel-7.6-kselftests-da43712a726289131788=
3d4b3a909fb18dac4b1d/tools/testing/selftests/net/socket
gcc -Wall -Wl,--no-as-needed -O2 -g -I../../../../usr/include/    nettest.c=
  -o /usr/src/perf_selftests-x86_64-rhel-7.6-kselftests-da43712a72628913178=
83d4b3a909fb18dac4b1d/tools/testing/selftests/net/nettest
gcc -Wall -Wl,--no-as-needed -O2 -g -I../../../../usr/include/    psock_fan=
out.c  -o /usr/src/perf_selftests-x86_64-rhel-7.6-kselftests-da43712a726289=
1317883d4b3a909fb18dac4b1d/tools/testing/selftests/net/psock_fanout
gcc -Wall -Wl,--no-as-needed -O2 -g -I../../../../usr/include/    psock_tpa=
cket.c  -o /usr/src/perf_selftests-x86_64-rhel-7.6-kselftests-da43712a72628=
91317883d4b3a909fb18dac4b1d/tools/testing/selftests/net/psock_tpacket
gcc -Wall -Wl,--no-as-needed -O2 -g -I../../../../usr/include/    msg_zeroc=
opy.c  -o /usr/src/perf_selftests-x86_64-rhel-7.6-kselftests-da43712a726289=
1317883d4b3a909fb18dac4b1d/tools/testing/selftests/net/msg_zerocopy
gcc -Wall -Wl,--no-as-needed -O2 -g -I../../../../usr/include/    reuseport=
_addr_any.c  -o /usr/src/perf_selftests-x86_64-rhel-7.6-kselftests-da43712a=
7262891317883d4b3a909fb18dac4b1d/tools/testing/selftests/net/reuseport_addr=
_any
gcc -Wall -Wl,--no-as-needed -O2 -g -I../../../../usr/include/  -lpthread  =
tcp_mmap.c  -o /usr/src/perf_selftests-x86_64-rhel-7.6-kselftests-da43712a7=
262891317883d4b3a909fb18dac4b1d/tools/testing/selftests/net/tcp_mmap
gcc -Wall -Wl,--no-as-needed -O2 -g -I../../../../usr/include/  -lpthread  =
tcp_inq.c  -o /usr/src/perf_selftests-x86_64-rhel-7.6-kselftests-da43712a72=
62891317883d4b3a909fb18dac4b1d/tools/testing/selftests/net/tcp_inq
tcp_inq.c: In function =E2=80=98main=E2=80=99:
tcp_inq.c:168:4: warning: dereferencing type-punned pointer will break stri=
ct-aliasing rules [-Wstrict-aliasing]
    inq =3D *((int *) CMSG_DATA(cm));
    ^~~
gcc -Wall -Wl,--no-as-needed -O2 -g -I../../../../usr/include/    psock_snd=
=2Ec  -o /usr/src/perf_selftests-x86_64-rhel-7.6-kselftests-da43712a7262891=
317883d4b3a909fb18dac4b1d/tools/testing/selftests/net/psock_snd
gcc -Wall -Wl,--no-as-needed -O2 -g -I../../../../usr/include/    txring_ov=
erwrite.c  -o /usr/src/perf_selftests-x86_64-rhel-7.6-kselftests-da43712a72=
62891317883d4b3a909fb18dac4b1d/tools/testing/selftests/net/txring_overwrite
gcc -Wall -Wl,--no-as-needed -O2 -g -I../../../../usr/include/    udpgso.c =
 -o /usr/src/perf_selftests-x86_64-rhel-7.6-kselftests-da43712a726289131788=
3d4b3a909fb18dac4b1d/tools/testing/selftests/net/udpgso
udpgso.c: In function =E2=80=98send_one=E2=80=99:
udpgso.c:476:3: warning: dereferencing type-punned pointer will break stric=
t-aliasing rules [-Wstrict-aliasing]
   *((uint16_t *) CMSG_DATA(cm)) =3D gso_len;
   ^
gcc -Wall -Wl,--no-as-needed -O2 -g -I../../../../usr/include/    udpgso_be=
nch_tx.c  -o /usr/src/perf_selftests-x86_64-rhel-7.6-kselftests-da43712a726=
2891317883d4b3a909fb18dac4b1d/tools/testing/selftests/net/udpgso_bench_tx
gcc -Wall -Wl,--no-as-needed -O2 -g -I../../../../usr/include/    udpgso_be=
nch_rx.c  -o /usr/src/perf_selftests-x86_64-rhel-7.6-kselftests-da43712a726=
2891317883d4b3a909fb18dac4b1d/tools/testing/selftests/net/udpgso_bench_rx
gcc -Wall -Wl,--no-as-needed -O2 -g -I../../../../usr/include/    ip_defrag=
=2Ec  -o /usr/src/perf_selftests-x86_64-rhel-7.6-kselftests-da43712a7262891=
317883d4b3a909fb18dac4b1d/tools/testing/selftests/net/ip_defrag
gcc -Wall -Wl,--no-as-needed -O2 -g -I../../../../usr/include/    so_txtime=
=2Ec  -o /usr/src/perf_selftests-x86_64-rhel-7.6-kselftests-da43712a7262891=
317883d4b3a909fb18dac4b1d/tools/testing/selftests/net/so_txtime
gcc -Wall -Wl,--no-as-needed -O2 -g -I../../../../usr/include/    ipv6_flow=
label.c  -o /usr/src/perf_selftests-x86_64-rhel-7.6-kselftests-da43712a7262=
891317883d4b3a909fb18dac4b1d/tools/testing/selftests/net/ipv6_flowlabel
ipv6_flowlabel.c: In function =E2=80=98do_send=E2=80=99:
ipv6_flowlabel.c:58:3: warning: dereferencing type-punned pointer will brea=
k strict-aliasing rules [-Wstrict-aliasing]
   *(uint32_t *)CMSG_DATA(cm) =3D htonl(flowlabel);
   ^
ipv6_flowlabel.c: In function =E2=80=98do_recv=E2=80=99:
ipv6_flowlabel.c:114:3: warning: dereferencing type-punned pointer will bre=
ak strict-aliasing rules [-Wstrict-aliasing]
   flowlabel =3D ntohl(*(uint32_t *)CMSG_DATA(cm));
   ^~~~~~~~~
gcc -Wall -Wl,--no-as-needed -O2 -g -I../../../../usr/include/    ipv6_flow=
label_mgr.c  -o /usr/src/perf_selftests-x86_64-rhel-7.6-kselftests-da43712a=
7262891317883d4b3a909fb18dac4b1d/tools/testing/selftests/net/ipv6_flowlabel=
_mgr
gcc -Wall -Wl,--no-as-needed -O2 -g -I../../../../usr/include/    tcp_fasto=
pen_backup_key.c  -o /usr/src/perf_selftests-x86_64-rhel-7.6-kselftests-da4=
3712a7262891317883d4b3a909fb18dac4b1d/tools/testing/selftests/net/tcp_fasto=
pen_backup_key
TAP version 13
1..31
# selftests: net: reuseport_bpf
# ---- IPv4 UDP ----
# Testing EBPF mod 10...
# Socket 0: 0
# Socket 1: 1
# Socket 2: 2
# Socket 3: 3
# Socket 4: 4
# Socket 5: 5
# Socket 6: 6
# Socket 7: 7
# Socket 8: 8
# Socket 9: 9
# Socket 0: 10
# Socket 1: 11
# Socket 2: 12
# Socket 3: 13
# Socket 4: 14
# Socket 5: 15
# Socket 6: 16
# Socket 7: 17
# Socket 8: 18
# Socket 9: 19
# Reprograming, testing mod 5...
# Socket 0: 0
# Socket 1: 1
# Socket 2: 2
# Socket 3: 3
# Socket 4: 4
# Socket 0: 5
# Socket 1: 6
# Socket 2: 7
# Socket 3: 8
# Socket 4: 9
# Socket 0: 10
# Socket 1: 11
# Socket 2: 12
# Socket 3: 13
# Socket 4: 14
# Socket 0: 15
# Socket 1: 16
# Socket 2: 17
# Socket 3: 18
# Socket 4: 19
# Testing EBPF mod 20...
# Socket 0: 0
# Socket 1: 1
# Socket 2: 2
# Socket 3: 3
# Socket 4: 4
# Socket 5: 5
# Socket 6: 6
# Socket 7: 7
# Socket 8: 8
# Socket 9: 9
# Socket 10: 10
# Socket 11: 11
# Socket 12: 12
# Socket 13: 13
# Socket 14: 14
# Socket 15: 15
# Socket 16: 16
# Socket 17: 17
# Socket 18: 18
# Socket 19: 19
# Socket 0: 20
# Socket 1: 21
# Socket 2: 22
# Socket 3: 23
# Socket 4: 24
# Socket 5: 25
# Socket 6: 26
# Socket 7: 27
# Socket 8: 28
# Socket 9: 29
# Socket 10: 30
# Socket 11: 31
# Socket 12: 32
# Socket 13: 33
# Socket 14: 34
# Socket 15: 35
# Socket 16: 36
# Socket 17: 37
# Socket 18: 38
# Socket 19: 39
# Reprograming, testing mod 10...
# Socket 0: 0
# Socket 1: 1
# Socket 2: 2
# Socket 3: 3
# Socket 4: 4
# Socket 5: 5
# Socket 6: 6
# Socket 7: 7
# Socket 8: 8
# Socket 9: 9
# Socket 0: 10
# Socket 1: 11
# Socket 2: 12
# Socket 3: 13
# Socket 4: 14
# Socket 5: 15
# Socket 6: 16
# Socket 7: 17
# Socket 8: 18
# Socket 9: 19
# Socket 0: 20
# Socket 1: 21
# Socket 2: 22
# Socket 3: 23
# Socket 4: 24
# Socket 5: 25
# Socket 6: 26
# Socket 7: 27
# Socket 8: 28
# Socket 9: 29
# Socket 0: 30
# Socket 1: 31
# Socket 2: 32
# Socket 3: 33
# Socket 4: 34
# Socket 5: 35
# Socket 6: 36
# Socket 7: 37
# Socket 8: 38
# Socket 9: 39
# Testing CBPF mod 10...
# Socket 0: 0
# Socket 1: 1
# Socket 2: 2
# Socket 3: 3
# Socket 4: 4
# Socket 5: 5
# Socket 6: 6
# Socket 7: 7
# Socket 8: 8
# Socket 9: 9
# Socket 0: 10
# Socket 1: 11
# Socket 2: 12
# Socket 3: 13
# Socket 4: 14
# Socket 5: 15
# Socket 6: 16
# Socket 7: 17
# Socket 8: 18
# Socket 9: 19
# Reprograming, testing mod 5...
# Socket 0: 0
# Socket 1: 1
# Socket 2: 2
# Socket 3: 3
# Socket 4: 4
# Socket 0: 5
# Socket 1: 6
# Socket 2: 7
# Socket 3: 8
# Socket 4: 9
# Socket 0: 10
# Socket 1: 11
# Socket 2: 12
# Socket 3: 13
# Socket 4: 14
# Socket 0: 15
# Socket 1: 16
# Socket 2: 17
# Socket 3: 18
# Socket 4: 19
# Testing CBPF mod 20...
# Socket 0: 0
# Socket 1: 1
# Socket 2: 2
# Socket 3: 3
# Socket 4: 4
# Socket 5: 5
# Socket 6: 6
# Socket 7: 7
# Socket 8: 8
# Socket 9: 9
# Socket 10: 10
# Socket 11: 11
# Socket 12: 12
# Socket 13: 13
# Socket 14: 14
# Socket 15: 15
# Socket 16: 16
# Socket 17: 17
# Socket 18: 18
# Socket 19: 19
# Socket 0: 20
# Socket 1: 21
# Socket 2: 22
# Socket 3: 23
# Socket 4: 24
# Socket 5: 25
# Socket 6: 26
# Socket 7: 27
# Socket 8: 28
# Socket 9: 29
# Socket 10: 30
# Socket 11: 31
# Socket 12: 32
# Socket 13: 33
# Socket 14: 34
# Socket 15: 35
# Socket 16: 36
# Socket 17: 37
# Socket 18: 38
# Socket 19: 39
# Reprograming, testing mod 10...
# Socket 0: 0
# Socket 1: 1
# Socket 2: 2
# Socket 3: 3
# Socket 4: 4
# Socket 5: 5
# Socket 6: 6
# Socket 7: 7
# Socket 8: 8
# Socket 9: 9
# Socket 0: 10
# Socket 1: 11
# Socket 2: 12
# Socket 3: 13
# Socket 4: 14
# Socket 5: 15
# Socket 6: 16
# Socket 7: 17
# Socket 8: 18
# Socket 9: 19
# Socket 0: 20
# Socket 1: 21
# Socket 2: 22
# Socket 3: 23
# Socket 4: 24
# Socket 5: 25
# Socket 6: 26
# Socket 7: 27
# Socket 8: 28
# Socket 9: 29
# Socket 0: 30
# Socket 1: 31
# Socket 2: 32
# Socket 3: 33
# Socket 4: 34
# Socket 5: 35
# Socket 6: 36
# Socket 7: 37
# Socket 8: 38
# Socket 9: 39
# Testing too many filters...
# Testing filters on non-SO_REUSEPORT socket...
# ---- IPv6 UDP ----
# Testing EBPF mod 10...
# Socket 0: 0
# Socket 1: 1
# Socket 2: 2
# Socket 3: 3
# Socket 4: 4
# Socket 5: 5
# Socket 6: 6
# Socket 7: 7
# Socket 8: 8
# Socket 9: 9
# Socket 0: 10
# Socket 1: 11
# Socket 2: 12
# Socket 3: 13
# Socket 4: 14
# Socket 5: 15
# Socket 6: 16
# Socket 7: 17
# Socket 8: 18
# Socket 9: 19
# Reprograming, testing mod 5...
# Socket 0: 0
# Socket 1: 1
# Socket 2: 2
# Socket 3: 3
# Socket 4: 4
# Socket 0: 5
# Socket 1: 6
# Socket 2: 7
# Socket 3: 8
# Socket 4: 9
# Socket 0: 10
# Socket 1: 11
# Socket 2: 12
# Socket 3: 13
# Socket 4: 14
# Socket 0: 15
# Socket 1: 16
# Socket 2: 17
# Socket 3: 18
# Socket 4: 19
# Testing EBPF mod 20...
# Socket 0: 0
# Socket 1: 1
# Socket 2: 2
# Socket 3: 3
# Socket 4: 4
# Socket 5: 5
# Socket 6: 6
# Socket 7: 7
# Socket 8: 8
# Socket 9: 9
# Socket 10: 10
# Socket 11: 11
# Socket 12: 12
# Socket 13: 13
# Socket 14: 14
# Socket 15: 15
# Socket 16: 16
# Socket 17: 17
# Socket 18: 18
# Socket 19: 19
# Socket 0: 20
# Socket 1: 21
# Socket 2: 22
# Socket 3: 23
# Socket 4: 24
# Socket 5: 25
# Socket 6: 26
# Socket 7: 27
# Socket 8: 28
# Socket 9: 29
# Socket 10: 30
# Socket 11: 31
# Socket 12: 32
# Socket 13: 33
# Socket 14: 34
# Socket 15: 35
# Socket 16: 36
# Socket 17: 37
# Socket 18: 38
# Socket 19: 39
# Reprograming, testing mod 10...
# Socket 0: 0
# Socket 1: 1
# Socket 2: 2
# Socket 3: 3
# Socket 4: 4
# Socket 5: 5
# Socket 6: 6
# Socket 7: 7
# Socket 8: 8
# Socket 9: 9
# Socket 0: 10
# Socket 1: 11
# Socket 2: 12
# Socket 3: 13
# Socket 4: 14
# Socket 5: 15
# Socket 6: 16
# Socket 7: 17
# Socket 8: 18
# Socket 9: 19
# Socket 0: 20
# Socket 1: 21
# Socket 2: 22
# Socket 3: 23
# Socket 4: 24
# Socket 5: 25
# Socket 6: 26
# Socket 7: 27
# Socket 8: 28
# Socket 9: 29
# Socket 0: 30
# Socket 1: 31
# Socket 2: 32
# Socket 3: 33
# Socket 4: 34
# Socket 5: 35
# Socket 6: 36
# Socket 7: 37
# Socket 8: 38
# Socket 9: 39
# Testing CBPF mod 10...
# Socket 0: 0
# Socket 1: 1
# Socket 2: 2
# Socket 3: 3
# Socket 4: 4
# Socket 5: 5
# Socket 6: 6
# Socket 7: 7
# Socket 8: 8
# Socket 9: 9
# Socket 0: 10
# Socket 1: 11
# Socket 2: 12
# Socket 3: 13
# Socket 4: 14
# Socket 5: 15
# Socket 6: 16
# Socket 7: 17
# Socket 8: 18
# Socket 9: 19
# Reprograming, testing mod 5...
# Socket 0: 0
# Socket 1: 1
# Socket 2: 2
# Socket 3: 3
# Socket 4: 4
# Socket 0: 5
# Socket 1: 6
# Socket 2: 7
# Socket 3: 8
# Socket 4: 9
# Socket 0: 10
# Socket 1: 11
# Socket 2: 12
# Socket 3: 13
# Socket 4: 14
# Socket 0: 15
# Socket 1: 16
# Socket 2: 17
# Socket 3: 18
# Socket 4: 19
# Testing CBPF mod 20...
# Socket 0: 0
# Socket 1: 1
# Socket 2: 2
# Socket 3: 3
# Socket 4: 4
# Socket 5: 5
# Socket 6: 6
# Socket 7: 7
# Socket 8: 8
# Socket 9: 9
# Socket 10: 10
# Socket 11: 11
# Socket 12: 12
# Socket 13: 13
# Socket 14: 14
# Socket 15: 15
# Socket 16: 16
# Socket 17: 17
# Socket 18: 18
# Socket 19: 19
# Socket 0: 20
# Socket 1: 21
# Socket 2: 22
# Socket 3: 23
# Socket 4: 24
# Socket 5: 25
# Socket 6: 26
# Socket 7: 27
# Socket 8: 28
# Socket 9: 29
# Socket 10: 30
# Socket 11: 31
# Socket 12: 32
# Socket 13: 33
# Socket 14: 34
# Socket 15: 35
# Socket 16: 36
# Socket 17: 37
# Socket 18: 38
# Socket 19: 39
# Reprograming, testing mod 10...
# Socket 0: 0
# Socket 1: 1
# Socket 2: 2
# Socket 3: 3
# Socket 4: 4
# Socket 5: 5
# Socket 6: 6
# Socket 7: 7
# Socket 8: 8
# Socket 9: 9
# Socket 0: 10
# Socket 1: 11
# Socket 2: 12
# Socket 3: 13
# Socket 4: 14
# Socket 5: 15
# Socket 6: 16
# Socket 7: 17
# Socket 8: 18
# Socket 9: 19
# Socket 0: 20
# Socket 1: 21
# Socket 2: 22
# Socket 3: 23
# Socket 4: 24
# Socket 5: 25
# Socket 6: 26
# Socket 7: 27
# Socket 8: 28
# Socket 9: 29
# Socket 0: 30
# Socket 1: 31
# Socket 2: 32
# Socket 3: 33
# Socket 4: 34
# Socket 5: 35
# Socket 6: 36
# Socket 7: 37
# Socket 8: 38
# Socket 9: 39
# Testing too many filters...
# Testing filters on non-SO_REUSEPORT socket...
# ---- IPv6 UDP w/ mapped IPv4 ----
# Testing EBPF mod 20...
# Socket 0: 0
# Socket 1: 1
# Socket 2: 2
# Socket 3: 3
# Socket 4: 4
# Socket 5: 5
# Socket 6: 6
# Socket 7: 7
# Socket 8: 8
# Socket 9: 9
# Socket 10: 10
# Socket 11: 11
# Socket 12: 12
# Socket 13: 13
# Socket 14: 14
# Socket 15: 15
# Socket 16: 16
# Socket 17: 17
# Socket 18: 18
# Socket 19: 19
# Socket 0: 20
# Socket 1: 21
# Socket 2: 22
# Socket 3: 23
# Socket 4: 24
# Socket 5: 25
# Socket 6: 26
# Socket 7: 27
# Socket 8: 28
# Socket 9: 29
# Socket 10: 30
# Socket 11: 31
# Socket 12: 32
# Socket 13: 33
# Socket 14: 34
# Socket 15: 35
# Socket 16: 36
# Socket 17: 37
# Socket 18: 38
# Socket 19: 39
# Reprograming, testing mod 10...
# Socket 0: 0
# Socket 1: 1
# Socket 2: 2
# Socket 3: 3
# Socket 4: 4
# Socket 5: 5
# Socket 6: 6
# Socket 7: 7
# Socket 8: 8
# Socket 9: 9
# Socket 0: 10
# Socket 1: 11
# Socket 2: 12
# Socket 3: 13
# Socket 4: 14
# Socket 5: 15
# Socket 6: 16
# Socket 7: 17
# Socket 8: 18
# Socket 9: 19
# Socket 0: 20
# Socket 1: 21
# Socket 2: 22
# Socket 3: 23
# Socket 4: 24
# Socket 5: 25
# Socket 6: 26
# Socket 7: 27
# Socket 8: 28
# Socket 9: 29
# Socket 0: 30
# Socket 1: 31
# Socket 2: 32
# Socket 3: 33
# Socket 4: 34
# Socket 5: 35
# Socket 6: 36
# Socket 7: 37
# Socket 8: 38
# Socket 9: 39
# Testing EBPF mod 10...
# Socket 0: 0
# Socket 1: 1
# Socket 2: 2
# Socket 3: 3
# Socket 4: 4
# Socket 5: 5
# Socket 6: 6
# Socket 7: 7
# Socket 8: 8
# Socket 9: 9
# Socket 0: 10
# Socket 1: 11
# Socket 2: 12
# Socket 3: 13
# Socket 4: 14
# Socket 5: 15
# Socket 6: 16
# Socket 7: 17
# Socket 8: 18
# Socket 9: 19
# Reprograming, testing mod 5...
# Socket 0: 0
# Socket 1: 1
# Socket 2: 2
# Socket 3: 3
# Socket 4: 4
# Socket 0: 5
# Socket 1: 6
# Socket 2: 7
# Socket 3: 8
# Socket 4: 9
# Socket 0: 10
# Socket 1: 11
# Socket 2: 12
# Socket 3: 13
# Socket 4: 14
# Socket 0: 15
# Socket 1: 16
# Socket 2: 17
# Socket 3: 18
# Socket 4: 19
# Testing CBPF mod 10...
# Socket 0: 0
# Socket 1: 1
# Socket 2: 2
# Socket 3: 3
# Socket 4: 4
# Socket 5: 5
# Socket 6: 6
# Socket 7: 7
# Socket 8: 8
# Socket 9: 9
# Socket 0: 10
# Socket 1: 11
# Socket 2: 12
# Socket 3: 13
# Socket 4: 14
# Socket 5: 15
# Socket 6: 16
# Socket 7: 17
# Socket 8: 18
# Socket 9: 19
# Reprograming, testing mod 5...
# Socket 0: 0
# Socket 1: 1
# Socket 2: 2
# Socket 3: 3
# Socket 4: 4
# Socket 0: 5
# Socket 1: 6
# Socket 2: 7
# Socket 3: 8
# Socket 4: 9
# Socket 0: 10
# Socket 1: 11
# Socket 2: 12
# Socket 3: 13
# Socket 4: 14
# Socket 0: 15
# Socket 1: 16
# Socket 2: 17
# Socket 3: 18
# Socket 4: 19
# Testing CBPF mod 20...
# Socket 0: 0
# Socket 1: 1
# Socket 2: 2
# Socket 3: 3
# Socket 4: 4
# Socket 5: 5
# Socket 6: 6
# Socket 7: 7
# Socket 8: 8
# Socket 9: 9
# Socket 10: 10
# Socket 11: 11
# Socket 12: 12
# Socket 13: 13
# Socket 14: 14
# Socket 15: 15
# Socket 16: 16
# Socket 17: 17
# Socket 18: 18
# Socket 19: 19
# Socket 0: 20
# Socket 1: 21
# Socket 2: 22
# Socket 3: 23
# Socket 4: 24
# Socket 5: 25
# Socket 6: 26
# Socket 7: 27
# Socket 8: 28
# Socket 9: 29
# Socket 10: 30
# Socket 11: 31
# Socket 12: 32
# Socket 13: 33
# Socket 14: 34
# Socket 15: 35
# Socket 16: 36
# Socket 17: 37
# Socket 18: 38
# Socket 19: 39
# Reprograming, testing mod 10...
# Socket 0: 0
# Socket 1: 1
# Socket 2: 2
# Socket 3: 3
# Socket 4: 4
# Socket 5: 5
# Socket 6: 6
# Socket 7: 7
# Socket 8: 8
# Socket 9: 9
# Socket 0: 10
# Socket 1: 11
# Socket 2: 12
# Socket 3: 13
# Socket 4: 14
# Socket 5: 15
# Socket 6: 16
# Socket 7: 17
# Socket 8: 18
# Socket 9: 19
# Socket 0: 20
# Socket 1: 21
# Socket 2: 22
# Socket 3: 23
# Socket 4: 24
# Socket 5: 25
# Socket 6: 26
# Socket 7: 27
# Socket 8: 28
# Socket 9: 29
# Socket 0: 30
# Socket 1: 31
# Socket 2: 32
# Socket 3: 33
# Socket 4: 34
# Socket 5: 35
# Socket 6: 36
# Socket 7: 37
# Socket 8: 38
# Socket 9: 39
# ---- IPv4 TCP ----
# Testing EBPF mod 10...
# Socket 0: 0
# Socket 1: 1
# Socket 2: 2
# Socket 3: 3
# Socket 4: 4
# Socket 5: 5
# Socket 6: 6
# Socket 7: 7
# Socket 8: 8
# Socket 9: 9
# Socket 0: 10
# Socket 1: 11
# Socket 2: 12
# Socket 3: 13
# Socket 4: 14
# Socket 5: 15
# Socket 6: 16
# Socket 7: 17
# Socket 8: 18
# Socket 9: 19
# Reprograming, testing mod 5...
# Socket 0: 0
# Socket 1: 1
# Socket 2: 2
# Socket 3: 3
# Socket 4: 4
# Socket 0: 5
# Socket 1: 6
# Socket 2: 7
# Socket 3: 8
# Socket 4: 9
# Socket 0: 10
# Socket 1: 11
# Socket 2: 12
# Socket 3: 13
# Socket 4: 14
# Socket 0: 15
# Socket 1: 16
# Socket 2: 17
# Socket 3: 18
# Socket 4: 19
# Testing CBPF mod 10...
# Socket 0: 0
# Socket 1: 1
# Socket 2: 2
# Socket 3: 3
# Socket 4: 4
# Socket 5: 5
# Socket 6: 6
# Socket 7: 7
# Socket 8: 8
# Socket 9: 9
# Socket 0: 10
# Socket 1: 11
# Socket 2: 12
# Socket 3: 13
# Socket 4: 14
# Socket 5: 15
# Socket 6: 16
# Socket 7: 17
# Socket 8: 18
# Socket 9: 19
# Reprograming, testing mod 5...
# Socket 0: 0
# Socket 1: 1
# Socket 2: 2
# Socket 3: 3
# Socket 4: 4
# Socket 0: 5
# Socket 1: 6
# Socket 2: 7
# Socket 3: 8
# Socket 4: 9
# Socket 0: 10
# Socket 1: 11
# Socket 2: 12
# Socket 3: 13
# Socket 4: 14
# Socket 0: 15
# Socket 1: 16
# Socket 2: 17
# Socket 3: 18
# Socket 4: 19
# Testing too many filters...
# Testing filters on non-SO_REUSEPORT socket...
# ---- IPv6 TCP ----
# Testing EBPF mod 10...
# Socket 0: 0
# Socket 1: 1
# Socket 2: 2
# Socket 3: 3
# Socket 4: 4
# Socket 5: 5
# Socket 6: 6
# Socket 7: 7
# Socket 8: 8
# Socket 9: 9
# Socket 0: 10
# Socket 1: 11
# Socket 2: 12
# Socket 3: 13
# Socket 4: 14
# Socket 5: 15
# Socket 6: 16
# Socket 7: 17
# Socket 8: 18
# Socket 9: 19
# Reprograming, testing mod 5...
# Socket 0: 0
# Socket 1: 1
# Socket 2: 2
# Socket 3: 3
# Socket 4: 4
# Socket 0: 5
# Socket 1: 6
# Socket 2: 7
# Socket 3: 8
# Socket 4: 9
# Socket 0: 10
# Socket 1: 11
# Socket 2: 12
# Socket 3: 13
# Socket 4: 14
# Socket 0: 15
# Socket 1: 16
# Socket 2: 17
# Socket 3: 18
# Socket 4: 19
# Testing CBPF mod 10...
# Socket 0: 0
# Socket 1: 1
# Socket 2: 2
# Socket 3: 3
# Socket 4: 4
# Socket 5: 5
# Socket 6: 6
# Socket 7: 7
# Socket 8: 8
# Socket 9: 9
# Socket 0: 10
# Socket 1: 11
# Socket 2: 12
# Socket 3: 13
# Socket 4: 14
# Socket 5: 15
# Socket 6: 16
# Socket 7: 17
# Socket 8: 18
# Socket 9: 19
# Reprograming, testing mod 5...
# Socket 0: 0
# Socket 1: 1
# Socket 2: 2
# Socket 3: 3
# Socket 4: 4
# Socket 0: 5
# Socket 1: 6
# Socket 2: 7
# Socket 3: 8
# Socket 4: 9
# Socket 0: 10
# Socket 1: 11
# Socket 2: 12
# Socket 3: 13
# Socket 4: 14
# Socket 0: 15
# Socket 1: 16
# Socket 2: 17
# Socket 3: 18
# Socket 4: 19
# Testing too many filters...
# Testing filters on non-SO_REUSEPORT socket...
# ---- IPv6 TCP w/ mapped IPv4 ----
# Testing EBPF mod 10...
# Socket 0: 0
# Socket 1: 1
# Socket 2: 2
# Socket 3: 3
# Socket 4: 4
# Socket 5: 5
# Socket 6: 6
# Socket 7: 7
# Socket 8: 8
# Socket 9: 9
# Socket 0: 10
# Socket 1: 11
# Socket 2: 12
# Socket 3: 13
# Socket 4: 14
# Socket 5: 15
# Socket 6: 16
# Socket 7: 17
# Socket 8: 18
# Socket 9: 19
# Reprograming, testing mod 5...
# Socket 0: 0
# Socket 1: 1
# Socket 2: 2
# Socket 3: 3
# Socket 4: 4
# Socket 0: 5
# Socket 1: 6
# Socket 2: 7
# Socket 3: 8
# Socket 4: 9
# Socket 0: 10
# Socket 1: 11
# Socket 2: 12
# Socket 3: 13
# Socket 4: 14
# Socket 0: 15
# Socket 1: 16
# Socket 2: 17
# Socket 3: 18
# Socket 4: 19
# Testing CBPF mod 10...
# Socket 0: 0
# Socket 1: 1
# Socket 2: 2
# Socket 3: 3
# Socket 4: 4
# Socket 5: 5
# Socket 6: 6
# Socket 7: 7
# Socket 8: 8
# Socket 9: 9
# Socket 0: 10
# Socket 1: 11
# Socket 2: 12
# Socket 3: 13
# Socket 4: 14
# Socket 5: 15
# Socket 6: 16
# Socket 7: 17
# Socket 8: 18
# Socket 9: 19
# Reprograming, testing mod 5...
# Socket 0: 0
# Socket 1: 1
# Socket 2: 2
# Socket 3: 3
# Socket 4: 4
# Socket 0: 5
# Socket 1: 6
# Socket 2: 7
# Socket 3: 8
# Socket 4: 9
# Socket 0: 10
# Socket 1: 11
# Socket 2: 12
# Socket 3: 13
# Socket 4: 14
# Socket 0: 15
# Socket 1: 16
# Socket 2: 17
# Socket 3: 18
# Socket 4: 19
# Testing filter add without bind...
# SUCCESS
ok 1 selftests: net: reuseport_bpf
# selftests: net: reuseport_bpf_cpu
# ---- IPv4 UDP ----
# send cpu 0, receive socket 0
# send cpu 1, receive socket 1
# send cpu 2, receive socket 2
# send cpu 3, receive socket 3
# send cpu 4, receive socket 4
# send cpu 5, receive socket 5
# send cpu 6, receive socket 6
# send cpu 7, receive socket 7
# send cpu 7, receive socket 7
# send cpu 6, receive socket 6
# send cpu 5, receive socket 5
# send cpu 4, receive socket 4
# send cpu 3, receive socket 3
# send cpu 2, receive socket 2
# send cpu 1, receive socket 1
# send cpu 0, receive socket 0
# send cpu 0, receive socket 0
# send cpu 2, receive socket 2
# send cpu 4, receive socket 4
# send cpu 6, receive socket 6
# send cpu 1, receive socket 1
# send cpu 3, receive socket 3
# send cpu 5, receive socket 5
# send cpu 7, receive socket 7
# ---- IPv6 UDP ----
# send cpu 0, receive socket 0
# send cpu 1, receive socket 1
# send cpu 2, receive socket 2
# send cpu 3, receive socket 3
# send cpu 4, receive socket 4
# send cpu 5, receive socket 5
# send cpu 6, receive socket 6
# send cpu 7, receive socket 7
# send cpu 7, receive socket 7
# send cpu 6, receive socket 6
# send cpu 5, receive socket 5
# send cpu 4, receive socket 4
# send cpu 3, receive socket 3
# send cpu 2, receive socket 2
# send cpu 1, receive socket 1
# send cpu 0, receive socket 0
# send cpu 0, receive socket 0
# send cpu 2, receive socket 2
# send cpu 4, receive socket 4
# send cpu 6, receive socket 6
# send cpu 1, receive socket 1
# send cpu 3, receive socket 3
# send cpu 5, receive socket 5
# send cpu 7, receive socket 7
# ---- IPv4 TCP ----
# send cpu 0, receive socket 0
# send cpu 1, receive socket 1
# send cpu 2, receive socket 2
# send cpu 3, receive socket 3
# send cpu 4, receive socket 4
# send cpu 5, receive socket 5
# send cpu 6, receive socket 6
# send cpu 7, receive socket 7
# send cpu 7, receive socket 7
# send cpu 6, receive socket 6
# send cpu 5, receive socket 5
# send cpu 4, receive socket 4
# send cpu 3, receive socket 3
# send cpu 2, receive socket 2
# send cpu 1, receive socket 1
# send cpu 0, receive socket 0
# send cpu 0, receive socket 0
# send cpu 2, receive socket 2
# send cpu 4, receive socket 4
# send cpu 6, receive socket 6
# send cpu 1, receive socket 1
# send cpu 3, receive socket 3
# send cpu 5, receive socket 5
# send cpu 7, receive socket 7
# ---- IPv6 TCP ----
# send cpu 0, receive socket 0
# send cpu 1, receive socket 1
# send cpu 2, receive socket 2
# send cpu 3, receive socket 3
# send cpu 4, receive socket 4
# send cpu 5, receive socket 5
# send cpu 6, receive socket 6
# send cpu 7, receive socket 7
# send cpu 7, receive socket 7
# send cpu 6, receive socket 6
# send cpu 5, receive socket 5
# send cpu 4, receive socket 4
# send cpu 3, receive socket 3
# send cpu 2, receive socket 2
# send cpu 1, receive socket 1
# send cpu 0, receive socket 0
# send cpu 0, receive socket 0
# send cpu 2, receive socket 2
# send cpu 4, receive socket 4
# send cpu 6, receive socket 6
# send cpu 1, receive socket 1
# send cpu 3, receive socket 3
# send cpu 5, receive socket 5
# send cpu 7, receive socket 7
# SUCCESS
ok 2 selftests: net: reuseport_bpf_cpu
# selftests: net: reuseport_bpf_numa
# ---- IPv4 UDP ----
# send node 0, receive socket 0
# send node 0, receive socket 0
# ---- IPv6 UDP ----
# send node 0, receive socket 0
# send node 0, receive socket 0
# ---- IPv4 TCP ----
# send node 0, receive socket 0
# send node 0, receive socket 0
# ---- IPv6 TCP ----
# send node 0, receive socket 0
# send node 0, receive socket 0
# SUCCESS
ok 3 selftests: net: reuseport_bpf_numa
# selftests: net: reuseport_dualstack
# ---- UDP IPv4 created before IPv6 ----
# ---- UDP IPv6 created before IPv4 ----
# ---- UDP IPv4 created before IPv6 (large) ----
# ---- UDP IPv6 created before IPv4 (large) ----
# ---- TCP IPv4 created before IPv6 ----
# ---- TCP IPv6 created before IPv4 ----
# SUCCESS
ok 4 selftests: net: reuseport_dualstack
# selftests: net: reuseaddr_conflict
# Opening 127.0.0.1:9999
# Opening INADDR_ANY:9999
# bind: Address already in use
# Opening in6addr_any:9999
# Opening INADDR_ANY:9999
# bind: Address already in use
# Opening INADDR_ANY:9999 after closing ipv6 socket
# bind: Address already in use
# Successok 5 selftests: net: reuseaddr_conflict
# selftests: net: tls
# [=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D] Running 48 tests from 3 test cases.
# [ RUN      ] tls_basic.base_base
# [       OK ] tls_basic.base_base
# [ RUN      ] tls.sendfile
# [       OK ] tls.sendfile
# [ RUN      ] tls.send_then_sendfile
# [       OK ] tls.send_then_sendfile
# [ RUN      ] tls.recv_max
# [       OK ] tls.recv_max
# [ RUN      ] tls.recv_small
# [       OK ] tls.recv_small
# [ RUN      ] tls.msg_more
# [       OK ] tls.msg_more
# [ RUN      ] tls.msg_more_unsent
# [       OK ] tls.msg_more_unsent
# [ RUN      ] tls.sendmsg_single
# [       OK ] tls.sendmsg_single
# [ RUN      ] tls.sendmsg_fragmented
# [       OK ] tls.sendmsg_fragmented
# [ RUN      ] tls.sendmsg_large
# [       OK ] tls.sendmsg_large
# [ RUN      ] tls.sendmsg_multiple
# [       OK ] tls.sendmsg_multiple
# [ RUN      ] tls.sendmsg_multiple_stress
# [       OK ] tls.sendmsg_multiple_stress
# [ RUN      ] tls.splice_from_pipe
# [       OK ] tls.splice_from_pipe
# [ RUN      ] tls.splice_from_pipe2
# [       OK ] tls.splice_from_pipe2
# [ RUN      ] tls.send_and_splice
# [       OK ] tls.send_and_splice
# [ RUN      ] tls.splice_to_pipe
# [       OK ] tls.splice_to_pipe
# [ RUN      ] tls.recvmsg_single
# [       OK ] tls.recvmsg_single
# [ RUN      ] tls.recvmsg_single_max
# [       OK ] tls.recvmsg_single_max
# [ RUN      ] tls.recvmsg_multiple
# [       OK ] tls.recvmsg_multiple
# [ RUN      ] tls.single_send_multiple_recv
# [       OK ] tls.single_send_multiple_recv
# [ RUN      ] tls.multiple_send_single_recv
# [       OK ] tls.multiple_send_single_recv
# [ RUN      ] tls.single_send_multiple_recv_non_align
# [       OK ] tls.single_send_multiple_recv_non_align
# [ RUN      ] tls.recv_partial
# [       OK ] tls.recv_partial
# [ RUN      ] tls.recv_nonblock
# [       OK ] tls.recv_nonblock
# [ RUN      ] tls.recv_peek
# [       OK ] tls.recv_peek
# [ RUN      ] tls.recv_peek_multiple
# [       OK ] tls.recv_peek_multiple
# [ RUN      ] tls.recv_peek_multiple_records
# [       OK ] tls.recv_peek_multiple_records
# [ RUN      ] tls.recv_peek_large_buf_mult_recs
# [       OK ] tls.recv_peek_large_buf_mult_recs
# [ RUN      ] tls.recv_lowat
# [       OK ] tls.recv_lowat
# [ RUN      ] tls.bidir
# [       OK ] tls.bidir
# [ RUN      ] tls.pollin
# [       OK ] tls.pollin
# [ RUN      ] tls.poll_wait
# [       OK ] tls.poll_wait
# [ RUN      ] tls.poll_wait_split
# [       OK ] tls.poll_wait_split
# [ RUN      ] tls.blocking
# [       OK ] tls.blocking
# [ RUN      ] tls.nonblocking
# [       OK ] tls.nonblocking
# [ RUN      ] tls.mutliproc_even
# [       OK ] tls.mutliproc_even
# [ RUN      ] tls.mutliproc_readers
# [       OK ] tls.mutliproc_readers
# [ RUN      ] tls.mutliproc_writers
# [       OK ] tls.mutliproc_writers
# [ RUN      ] tls.mutliproc_sendpage_even
# [       OK ] tls.mutliproc_sendpage_even
# [ RUN      ] tls.mutliproc_sendpage_readers
# [       OK ] tls.mutliproc_sendpage_readers
# [ RUN      ] tls.mutliproc_sendpage_writers
# [       OK ] tls.mutliproc_sendpage_writers
# [ RUN      ] tls.control_msg
# [       OK ] tls.control_msg
# [ RUN      ] tls.shutdown
# [       OK ] tls.shutdown
# [ RUN      ] tls.shutdown_unsent
# [       OK ] tls.shutdown_unsent
# [ RUN      ] tls.shutdown_reuse
# [       OK ] tls.shutdown_reuse
# [ RUN      ] global.non_established
# [       OK ] global.non_established
# [ RUN      ] global.keysizes
# [       OK ] global.keysizes
# [ RUN      ] global.tls12
# [       OK ] global.tls12
# [=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D] 48 / 48 tests passed.
# [  PASSED  ]
ok 6 selftests: net: tls
# selftests: net: run_netsocktests
# --------------------
# running socket test
# --------------------
# [PASS]
ok 7 selftests: net: run_netsocktests
# selftests: net: run_afpackettests
# --------------------
# running psock_fanout test
# --------------------
# test: control single socket
# test: control multiple sockets
# test: unique ids
#=20
# test: datapath 0x0 ports 8000,8002
# info: count=3D0,0, expect=3D0,0
# info: count=3D5,15, expect=3D15,5
# info: count=3D5,20, expect=3D20,5
#=20
# test: datapath 0x1000 ports 8000,8002
# info: count=3D0,0, expect=3D0,0
# info: count=3D5,15, expect=3D15,5
# info: count=3D15,20, expect=3D20,15
#=20
# test: datapath 0x1 ports 8000,8002
# info: count=3D0,0, expect=3D0,0
# info: count=3D10,10, expect=3D10,10
# info: count=3D17,18, expect=3D18,17
#=20
# test: datapath 0x3 ports 8000,8002
# info: count=3D0,0, expect=3D0,0
# info: count=3D15,5, expect=3D15,5
# info: count=3D20,15, expect=3D20,15
#=20
# test: datapath 0x6 ports 8000,8002
# info: count=3D0,0, expect=3D0,0
# info: count=3D5,15, expect=3D15,5
# info: count=3D20,15, expect=3D15,20
#=20
# test: datapath 0x7 ports 8000,8002
# info: count=3D0,0, expect=3D0,0
# info: count=3D5,15, expect=3D15,5
# info: count=3D20,15, expect=3D15,20
#=20
# test: datapath 0x2 ports 8000,8002
# info: count=3D0,0, expect=3D0,0
# info: count=3D20,0, expect=3D20,0
# info: count=3D20,0, expect=3D20,0
#=20
# test: datapath 0x2 ports 8000,8002
# info: count=3D0,0, expect=3D0,0
# info: count=3D0,20, expect=3D0,20
# info: count=3D0,20, expect=3D0,20
#=20
# test: datapath 0x2000 ports 8000,8002
# info: count=3D0,0, expect=3D0,0
# info: count=3D20,20, expect=3D20,20
# info: count=3D20,20, expect=3D20,20
# OK. All tests passed
# [PASS]
# --------------------
# running psock_tpacket test
# --------------------
# test: TPACKET_V1 with PACKET_RX_RING .................... 100 pkts (14200=
 bytes)
# test: TPACKET_V1 with PACKET_TX_RING .................... 100 pkts (14200=
 bytes)
# test: TPACKET_V2 with PACKET_RX_RING .................... 100 pkts (14200=
 bytes)
# test: TPACKET_V2 with PACKET_TX_RING .................... 100 pkts (14200=
 bytes)
# test: TPACKET_V3 with PACKET_RX_RING .................... 100 pkts (14200=
 bytes)
# test: TPACKET_V3 with PACKET_TX_RING .................... 100 pkts (14200=
 bytes)
# OK. All tests passed
# [PASS]
# --------------------
# running txring_overwrite test
# --------------------
# read: a (0x61)
# read: b (0x62)
# [PASS]
ok 8 selftests: net: run_afpackettests
# selftests: net: test_bpf.sh
# test_bpf: ok
ok 9 selftests: net: test_bpf.sh
# selftests: net: netdevice.sh
# SKIP: eth0: interface already up
# Cannot get device udp-fragmentation-offload settings: Operation not suppo=
rted
# PASS: eth0: ethtool list features
# PASS: eth0: ethtool dump
# PASS: eth0: ethtool stats
# SKIP: eth0: interface kept up
ok 10 selftests: net: netdevice.sh
# selftests: net: rtnetlink.sh
# PASS: policy routing
# PASS: route get
# PASS: preferred_lft addresses have expired
# PASS: promote_secondaries complete
# PASS: tc htb hierarchy
# PASS: gre tunnel endpoint
# PASS: gretap
# PASS: ip6gretap
# PASS: erspan
# PASS: ip6erspan
# PASS: bridge setup
# PASS: ipv6 addrlabel
# PASS: set ifalias 4a156c3e-f9ed-4e11-ac86-57ef3c8e44c3 for test-dummy0
# PASS: vrf
# PASS: vxlan
# PASS: fou
# PASS: macsec
# PASS: ipsec
# SKIP: ipsec_offload can't load netdevsim
# PASS: bridge fdb get
# PASS: neigh get
ok 11 selftests: net: rtnetlink.sh
# selftests: net: xfrm_policy.sh
# PASS: policy before exception matches
# PASS: ping to .254 bypassed ipsec tunnel (exceptions)
# PASS: direct policy matches (exceptions)
# PASS: policy matches (exceptions)
# PASS: ping to .254 bypassed ipsec tunnel (exceptions and block policies)
# PASS: direct policy matches (exceptions and block policies)
# PASS: policy matches (exceptions and block policies)
# PASS: ping to .254 bypassed ipsec tunnel (exceptions and block policies a=
fter hresh changes)
# PASS: direct policy matches (exceptions and block policies after hresh ch=
anges)
# PASS: policy matches (exceptions and block policies after hresh changes)
# PASS: ping to .254 bypassed ipsec tunnel (exceptions and block policies a=
fter hthresh change in ns3)
# PASS: direct policy matches (exceptions and block policies after hthresh =
change in ns3)
# PASS: policy matches (exceptions and block policies after hthresh change =
in ns3)
# PASS: ping to .254 bypassed ipsec tunnel (exceptions and block policies a=
fter htresh change to normal)
# PASS: direct policy matches (exceptions and block policies after htresh c=
hange to normal)
# PASS: policy matches (exceptions and block policies after htresh change t=
o normal)
# PASS: policies with repeated htresh change
ok 12 selftests: net: xfrm_policy.sh
# selftests: net: test_blackhole_dev.sh
# test_blackhole_dev: ok
ok 13 selftests: net: test_blackhole_dev.sh
# selftests: net: fib_tests.sh
#=20
# Single path route test
#     Start point
#     TEST: IPv4 fibmatch                                                 [=
 OK ]
#     TEST: IPv6 fibmatch                                                 [=
 OK ]
#     Nexthop device deleted
#     TEST: IPv4 fibmatch - no route                                      [=
 OK ]
#     TEST: IPv6 fibmatch - no route                                      [=
 OK ]
#=20
# Multipath route test
#     Start point
#     TEST: IPv4 fibmatch                                                 [=
 OK ]
#     TEST: IPv6 fibmatch                                                 [=
 OK ]
#     One nexthop device deleted
#     TEST: IPv4 - multipath route removed on delete                      [=
 OK ]
#     TEST: IPv6 - multipath down to single path                          [=
 OK ]
#     Second nexthop device deleted
#     TEST: IPv6 - no route                                               [=
 OK ]
#=20
# Single path, admin down
#     Start point
#     TEST: IPv4 fibmatch                                                 [=
 OK ]
#     TEST: IPv6 fibmatch                                                 [=
 OK ]
#     Route deleted on down
#     TEST: IPv4 fibmatch                                                 [=
 OK ]
#     TEST: IPv6 fibmatch                                                 [=
 OK ]
#=20
# Admin down multipath
#     Verify start point
#     TEST: IPv4 fibmatch                                                 [=
 OK ]
#     TEST: IPv6 fibmatch                                                 [=
 OK ]
#     One device down, one up
#     TEST: IPv4 fibmatch on down device                                  [=
 OK ]
#     TEST: IPv6 fibmatch on down device                                  [=
 OK ]
#     TEST: IPv4 fibmatch on up device                                    [=
 OK ]
#     TEST: IPv6 fibmatch on up device                                    [=
 OK ]
#     TEST: IPv4 flags on down device                                     [=
 OK ]
#     TEST: IPv6 flags on down device                                     [=
 OK ]
#     TEST: IPv4 flags on up device                                       [=
 OK ]
#     TEST: IPv6 flags on up device                                       [=
 OK ]
#     Other device down and up
#     TEST: IPv4 fibmatch on down device                                  [=
 OK ]
#     TEST: IPv6 fibmatch on down device                                  [=
 OK ]
#     TEST: IPv4 fibmatch on up device                                    [=
 OK ]
#     TEST: IPv6 fibmatch on up device                                    [=
 OK ]
#     TEST: IPv4 flags on down device                                     [=
 OK ]
#     TEST: IPv6 flags on down device                                     [=
 OK ]
#     TEST: IPv4 flags on up device                                       [=
 OK ]
#     TEST: IPv6 flags on up device                                       [=
 OK ]
#     Both devices down
#     TEST: IPv4 fibmatch                                                 [=
 OK ]
#     TEST: IPv6 fibmatch                                                 [=
 OK ]
#=20
# Local carrier tests - single path
#     Start point
#     TEST: IPv4 fibmatch                                                 [=
 OK ]
#     TEST: IPv6 fibmatch                                                 [=
 OK ]
#     TEST: IPv4 - no linkdown flag                                       [=
 OK ]
#     TEST: IPv6 - no linkdown flag                                       [=
 OK ]
#     Carrier off on nexthop
#     TEST: IPv4 fibmatch                                                 [=
 OK ]
#     TEST: IPv6 fibmatch                                                 [=
 OK ]
#     TEST: IPv4 - linkdown flag set                                      [=
 OK ]
#     TEST: IPv6 - linkdown flag set                                      [=
 OK ]
#     Route to local address with carrier down
#     TEST: IPv4 fibmatch                                                 [=
 OK ]
#     TEST: IPv6 fibmatch                                                 [=
 OK ]
#     TEST: IPv4 linkdown flag set                                        [=
 OK ]
#     TEST: IPv6 linkdown flag set                                        [=
 OK ]
#=20
# Single path route carrier test
#     Start point
#     TEST: IPv4 fibmatch                                                 [=
 OK ]
#     TEST: IPv6 fibmatch                                                 [=
 OK ]
#     TEST: IPv4 no linkdown flag                                         [=
 OK ]
#     TEST: IPv6 no linkdown flag                                         [=
 OK ]
#     Carrier down
#     TEST: IPv4 fibmatch                                                 [=
 OK ]
#     TEST: IPv6 fibmatch                                                 [=
 OK ]
#     TEST: IPv4 linkdown flag set                                        [=
 OK ]
#     TEST: IPv6 linkdown flag set                                        [=
 OK ]
#     Second address added with carrier down
#     TEST: IPv4 fibmatch                                                 [=
 OK ]
#     TEST: IPv6 fibmatch                                                 [=
 OK ]
#     TEST: IPv4 linkdown flag set                                        [=
 OK ]
#     TEST: IPv6 linkdown flag set                                        [=
 OK ]
#=20
# IPv4 nexthop tests
# <<< write me >>>
#=20
# IPv6 nexthop tests
#     TEST: Directly connected nexthop, unicast address                   [=
 OK ]
#     TEST: Directly connected nexthop, unicast address with device       [=
 OK ]
#     TEST: Gateway is linklocal address                                  [=
 OK ]
#     TEST: Gateway is linklocal address, no device                       [=
 OK ]
#     TEST: Gateway can not be local unicast address                      [=
 OK ]
#     TEST: Gateway can not be local unicast address, with device         [=
 OK ]
#     TEST: Gateway can not be a local linklocal address                  [=
 OK ]
#     TEST: Gateway can be local address in a VRF                         [=
 OK ]
#     TEST: Gateway can be local address in a VRF, with device            [=
 OK ]
#     TEST: Gateway can be local linklocal address in a VRF               [=
 OK ]
#     TEST: Redirect to VRF lookup                                        [=
 OK ]
#     TEST: VRF route, gateway can be local address in default VRF        [=
 OK ]
#     TEST: VRF route, gateway can not be a local address                 [=
 OK ]
#     TEST: VRF route, gateway can not be a local addr with device        [=
 OK ]
# Cannot open network namespace "ns1": No such file or directory
# Cannot open network namespace "ns1": No such file or directory
# Cannot open network namespace "ns1": No such file or directory
# Cannot open network namespace "ns1": No such file or directory
# connect: Network is unreachable
# Cannot open network namespace "ns1": No such file or directory
# Cannot open network namespace "ns1": No such file or directory
#=20
# IPv6 route add / append tests
#     TEST: Attempt to add duplicate route - gw                           [=
 OK ]
#     TEST: Attempt to add duplicate route - dev only                     [=
 OK ]
#     TEST: Attempt to add duplicate route - reject route                 [=
 OK ]
#     TEST: Append nexthop to existing route - gw                         [=
 OK ]
#     TEST: Add multipath route                                           [=
 OK ]
#     TEST: Attempt to add duplicate multipath route                      [=
 OK ]
#     TEST: Route add with different metrics                              [=
 OK ]
#     TEST: Route delete with metric                                      [=
 OK ]
#=20
# IPv6 route replace tests
#     TEST: Single path with single path                                  [=
 OK ]
#     TEST: Single path with multipath                                    [=
 OK ]
#     TEST: Single path with single path via multipath attribute          [=
 OK ]
#     TEST: Invalid nexthop                                               [=
 OK ]
#     TEST: Single path - replace of non-existent route                   [=
 OK ]
#     TEST: Multipath with multipath                                      [=
 OK ]
#     TEST: Multipath with single path                                    [=
 OK ]
#     TEST: Multipath with single path via multipath attribute            [=
 OK ]
#     TEST: Multipath - invalid first nexthop                             [=
 OK ]
#     TEST: Multipath - invalid second nexthop                            [=
 OK ]
#     TEST: Multipath - replace of non-existent route                     [=
 OK ]
#=20
# IPv4 route add / append tests
#     TEST: Attempt to add duplicate route - gw                           [=
 OK ]
#     TEST: Attempt to add duplicate route - dev only                     [=
 OK ]
#     TEST: Attempt to add duplicate route - reject route                 [=
 OK ]
#     TEST: Add new nexthop for existing prefix                           [=
 OK ]
#     TEST: Append nexthop to existing route - gw                         [=
 OK ]
#     TEST: Append nexthop to existing route - dev only                   [=
 OK ]
#     TEST: Append nexthop to existing route - reject route               [=
 OK ]
#     TEST: Append nexthop to existing reject route - gw                  [=
 OK ]
#     TEST: Append nexthop to existing reject route - dev only            [=
 OK ]
#     TEST: add multipath route                                           [=
 OK ]
#     TEST: Attempt to add duplicate multipath route                      [=
 OK ]
#     TEST: Route add with different metrics                              [=
 OK ]
#     TEST: Route delete with metric                                      [=
 OK ]
#=20
# IPv4 route replace tests
#     TEST: Single path with single path                                  [=
 OK ]
#     TEST: Single path with multipath                                    [=
 OK ]
#     TEST: Single path with reject route                                 [=
 OK ]
#     TEST: Single path with single path via multipath attribute          [=
 OK ]
#     TEST: Invalid nexthop                                               [=
 OK ]
#     TEST: Single path - replace of non-existent route                   [=
 OK ]
#     TEST: Multipath with multipath                                      [=
 OK ]
#     TEST: Multipath with single path                                    [=
 OK ]
#     TEST: Multipath with single path via multipath attribute            [=
 OK ]
#     TEST: Multipath with reject route                                   [=
 OK ]
#     TEST: Multipath - invalid first nexthop                             [=
 OK ]
#     TEST: Multipath - invalid second nexthop                            [=
 OK ]
#     TEST: Multipath - replace of non-existent route                     [=
 OK ]
#=20
# IPv6 prefix route tests
#     TEST: Default metric                                                [=
 OK ]
#     TEST: User specified metric on first device                         [=
 OK ]
#     TEST: User specified metric on second device                        [=
 OK ]
#     TEST: Delete of address on first device                             [=
 OK ]
#     TEST: Modify metric of address                                      [=
 OK ]
#     TEST: Prefix route removed on link down                             [=
 OK ]
#     TEST: Prefix route with metric on link up                           [=
 OK ]
#=20
# IPv4 prefix route tests
#     TEST: Default metric                                                [=
 OK ]
#     TEST: User specified metric on first device                         [=
 OK ]
#     TEST: User specified metric on second device                        [=
 OK ]
#     TEST: Delete of address on first device                             [=
 OK ]
#     TEST: Modify metric of address                                      [=
 OK ]
#     TEST: Prefix route removed on link down                             [=
 OK ]
#     TEST: Prefix route with metric on link up                           [=
 OK ]
#     TEST: Modify metric of .0/24 address                                [=
 OK ]
#     TEST: Modify metric of address with peer route                      [=
 OK ]
#=20
# IPv6 routes with metrics
#     TEST: Single path route with mtu metric                             [=
 OK ]
#     TEST: Multipath route via 2 single routes with mtu metric on first  [=
 OK ]
#     TEST: Multipath route via 2 single routes with mtu metric on 2nd    [=
 OK ]
#     TEST:     MTU of second leg                                         [=
 OK ]
#     TEST: Multipath route with mtu metric                               [=
 OK ]
#     TEST: Using route with mtu metric                                   [=
 OK ]
#     TEST: Invalid metric (fails metric_convert)                         [=
 OK ]
#=20
# IPv4 route add / append tests
#     TEST: Single path route with mtu metric                             [=
 OK ]
#     TEST: Multipath route with mtu metric                               [=
 OK ]
#     TEST: Using route with mtu metric                                   [=
 OK ]
#     TEST: Invalid metric (fails metric_convert)                         [=
 OK ]
#=20
# IPv4 route with IPv6 gateway tests
#     TEST: Single path route with IPv6 gateway                           [=
 OK ]
#     TEST: Single path route with IPv6 gateway - ping                    [=
 OK ]
#     TEST: Single path route delete                                      [=
 OK ]
#     TEST: Multipath route add - v6 nexthop then v4                      [=
 OK ]
#     TEST:     Multipath route delete - nexthops in wrong order          [=
 OK ]
#     TEST:     Multipath route delete exact match                        [=
 OK ]
#     TEST: Multipath route add - v4 nexthop then v6                      [=
 OK ]
#     TEST:     Multipath route delete - nexthops in wrong order          [=
 OK ]
#     TEST:     Multipath route delete exact match                        [=
 OK ]
#=20
# IPv4 rp_filter tests
#     TEST: rp_filter passes local packets                                [=
FAIL]
#     TEST: rp_filter passes loopback packets                             [=
FAIL]
#=20
# Tests passed: 152
# Tests failed:   2
not ok 14 selftests: net: fib_tests.sh # exit=3D1
# selftests: net: fib-onlink-tests.sh
# Error: ipv4: FIB table does not exist.
# Flush terminated
# Error: ipv6: FIB table does not exist.
# Flush terminated
#=20
# ########################################
# Configuring interfaces
#=20
# ######################################################################
# TEST SECTION: IPv4 onlink
# ######################################################################
#=20
# #########################################
# TEST SUBSECTION: Valid onlink commands
#=20
# #########################################
# TEST SUBSECTION: default VRF - main table
#     TEST: unicast connected                                   [ OK ]
#     TEST: unicast recursive                                   [ OK ]
#=20
# #########################################
# TEST SUBSECTION: VRF lisa
#     TEST: unicast connected                                   [ OK ]
#     TEST: unicast recursive                                   [ OK ]
#=20
# #########################################
# TEST SUBSECTION: VRF device, PBR table
#     TEST: unicast connected                                   [ OK ]
#     TEST: unicast recursive                                   [ OK ]
#=20
# #########################################
# TEST SUBSECTION: default VRF - main table - multipath
#     TEST: unicast connected - multipath                       [ OK ]
#     TEST: unicast recursive - multipath                       [ OK ]
#     TEST: unicast connected - multipath onlink first only     [ OK ]
#     TEST: unicast connected - multipath onlink second only    [ OK ]
#=20
# #########################################
# TEST SUBSECTION: Invalid onlink commands
#     TEST: Invalid gw - local unicast address                  [ OK ]
#     TEST: Invalid gw - local unicast address, VRF             [ OK ]
#     TEST: No nexthop device given                             [ OK ]
#     TEST: Gateway resolves to wrong nexthop device            [ OK ]
#     TEST: Gateway resolves to wrong nexthop device - VRF      [ OK ]
#=20
# ######################################################################
# TEST SECTION: IPv6 onlink
# ######################################################################
#=20
# #########################################
# TEST SUBSECTION: Valid onlink commands
#=20
# #########################################
# TEST SUBSECTION: default VRF - main table
#     TEST: unicast connected                                   [ OK ]
#     TEST: unicast recursive                                   [ OK ]
#     TEST: v4-mapped                                           [ OK ]
#=20
# #########################################
# TEST SUBSECTION: VRF lisa
#     TEST: unicast connected                                   [ OK ]
#     TEST: unicast recursive                                   [ OK ]
#     TEST: v4-mapped                                           [ OK ]
#=20
# #########################################
# TEST SUBSECTION: VRF device, PBR table
#     TEST: unicast connected                                   [ OK ]
#     TEST: unicast recursive                                   [ OK ]
#     TEST: v4-mapped                                           [ OK ]
#=20
# #########################################
# TEST SUBSECTION: default VRF - main table - multipath
#     TEST: unicast connected - multipath onlink                [ OK ]
#     TEST: unicast recursive - multipath onlink                [ OK ]
#     TEST: v4-mapped - multipath onlink                        [ OK ]
#     TEST: unicast connected - multipath onlink both nexthops  [ OK ]
#     TEST: unicast connected - multipath onlink first only     [ OK ]
#     TEST: unicast connected - multipath onlink second only    [ OK ]
#=20
# #########################################
# TEST SUBSECTION: Invalid onlink commands
#     TEST: Invalid gw - local unicast address                  [ OK ]
#     TEST: Invalid gw - local linklocal address                [ OK ]
#     TEST: Invalid gw - multicast address                      [ OK ]
#     TEST: Invalid gw - local unicast address, VRF             [ OK ]
#     TEST: Invalid gw - local linklocal address, VRF           [ OK ]
#     TEST: Invalid gw - multicast address, VRF                 [ OK ]
#     TEST: No nexthop device given                             [ OK ]
#     TEST: Gateway resolves to wrong nexthop device - VRF      [ OK ]
#=20
# Tests passed:  38
# Tests failed:   0
ok 15 selftests: net: fib-onlink-tests.sh
# selftests: net: pmtu.sh
# TEST: ipv4: PMTU exceptions                                         [ OK ]
# TEST: ipv4: PMTU exceptions - nexthop objects                       [ OK ]
# TEST: ipv6: PMTU exceptions                                         [ OK ]
# TEST: ipv6: PMTU exceptions - nexthop objects                       [ OK ]
# TEST: IPv4 over vxlan4: PMTU exceptions                             [ OK ]
# TEST: IPv4 over vxlan4: PMTU exceptions - nexthop objects           [ OK ]
# TEST: IPv6 over vxlan4: PMTU exceptions                             [ OK ]
# TEST: IPv6 over vxlan4: PMTU exceptions - nexthop objects           [ OK ]
# TEST: IPv4 over vxlan6: PMTU exceptions                             [ OK ]
# TEST: IPv4 over vxlan6: PMTU exceptions - nexthop objects           [ OK ]
# TEST: IPv6 over vxlan6: PMTU exceptions                             [ OK ]
# TEST: IPv6 over vxlan6: PMTU exceptions - nexthop objects           [ OK ]
# TEST: IPv4 over geneve4: PMTU exceptions                            [ OK ]
# TEST: IPv4 over geneve4: PMTU exceptions - nexthop objects          [ OK ]
# TEST: IPv6 over geneve4: PMTU exceptions                            [ OK ]
# TEST: IPv6 over geneve4: PMTU exceptions - nexthop objects          [ OK ]
# TEST: IPv4 over geneve6: PMTU exceptions                            [ OK ]
# TEST: IPv4 over geneve6: PMTU exceptions - nexthop objects          [ OK ]
# TEST: IPv6 over geneve6: PMTU exceptions                            [ OK ]
# TEST: IPv6 over geneve6: PMTU exceptions - nexthop objects          [ OK ]
# TEST: IPv4 over fou4: PMTU exceptions                               [ OK ]
# TEST: IPv4 over fou4: PMTU exceptions - nexthop objects             [ OK ]
# TEST: IPv6 over fou4: PMTU exceptions                               [ OK ]
# TEST: IPv6 over fou4: PMTU exceptions - nexthop objects             [ OK ]
# TEST: IPv4 over fou6: PMTU exceptions                               [ OK ]
# TEST: IPv4 over fou6: PMTU exceptions - nexthop objects             [ OK ]
# TEST: IPv6 over fou6: PMTU exceptions                               [ OK ]
# TEST: IPv6 over fou6: PMTU exceptions - nexthop objects             [ OK ]
# TEST: IPv4 over gue4: PMTU exceptions                               [ OK ]
# TEST: IPv4 over gue4: PMTU exceptions - nexthop objects             [ OK ]
# TEST: IPv6 over gue4: PMTU exceptions                               [ OK ]
# TEST: IPv6 over gue4: PMTU exceptions - nexthop objects             [ OK ]
# TEST: IPv4 over gue6: PMTU exceptions                               [ OK ]
# TEST: IPv4 over gue6: PMTU exceptions - nexthop objects             [ OK ]
# TEST: IPv6 over gue6: PMTU exceptions                               [ OK ]
# TEST: IPv6 over gue6: PMTU exceptions - nexthop objects             [ OK ]
# TEST: vti6: PMTU exceptions                                         [ OK ]
# TEST: vti4: PMTU exceptions                                         [ OK ]
# TEST: vti4: default MTU assignment                                  [ OK ]
# TEST: vti6: default MTU assignment                                  [ OK ]
# TEST: vti4: MTU setting on link creation                            [ OK ]
# TEST: vti6: MTU setting on link creation                            [ OK ]
# TEST: vti6: MTU changes on link changes                             [ OK ]
# TEST: ipv4: cleanup of cached exceptions                            [ OK ]
# TEST: ipv4: cleanup of cached exceptions - nexthop objects          [ OK ]
# TEST: ipv6: cleanup of cached exceptions                            [ OK ]
# TEST: ipv6: cleanup of cached exceptions - nexthop objects          [ OK ]
# TEST: ipv4: list and flush cached exceptions                        [ OK ]
# TEST: ipv4: list and flush cached exceptions - nexthop objects      [ OK ]
# TEST: ipv6: list and flush cached exceptions                        [ OK ]
# TEST: ipv6: list and flush cached exceptions - nexthop objects      [ OK ]
ok 16 selftests: net: pmtu.sh
# selftests: net: udpgso.sh
# ipv4 cmsg
# device mtu (orig): 65536
# device mtu (test): 1500
# ipv4 tx:1 gso:0=20
# ipv4 tx:1472 gso:0=20
# ipv4 tx:1473 gso:0 (fail)
# ipv4 tx:1472 gso:1472=20
# ipv4 tx:1473 gso:1472=20
# ipv4 tx:2944 gso:1472=20
# ipv4 tx:2945 gso:1472=20
# ipv4 tx:64768 gso:1472=20
# ipv4 tx:65507 gso:1472=20
# ipv4 tx:65508 gso:1472 (fail)
# ipv4 tx:1 gso:1=20
# ipv4 tx:2 gso:1=20
# ipv4 tx:5 gso:2=20
# ipv4 tx:36 gso:1=20
# ipv4 tx:37 gso:1 (fail)
# OK
# ipv4 setsockopt
# device mtu (orig): 65536
# device mtu (test): 1500
# ipv4 tx:1 gso:0=20
# ipv4 tx:1472 gso:0=20
# ipv4 tx:1473 gso:0 (fail)
# ipv4 tx:1472 gso:1472=20
# ipv4 tx:1473 gso:1472=20
# ipv4 tx:2944 gso:1472=20
# ipv4 tx:2945 gso:1472=20
# ipv4 tx:64768 gso:1472=20
# ipv4 tx:65507 gso:1472=20
# ipv4 tx:65508 gso:1472 (fail)
# ipv4 tx:1 gso:1=20
# ipv4 tx:2 gso:1=20
# ipv4 tx:5 gso:2=20
# ipv4 tx:36 gso:1=20
# ipv4 tx:37 gso:1 (fail)
# OK
# ipv6 cmsg
# device mtu (orig): 65536
# device mtu (test): 1500
# ipv6 tx:1 gso:0=20
# ipv6 tx:1452 gso:0=20
# ipv6 tx:1453 gso:0 (fail)
# ipv6 tx:1452 gso:1452=20
# ipv6 tx:1453 gso:1452=20
# ipv6 tx:2904 gso:1452=20
# ipv6 tx:2905 gso:1452=20
# ipv6 tx:65340 gso:1452=20
# ipv6 tx:65527 gso:1452=20
# ipv6 tx:65528 gso:1452 (fail)
# ipv6 tx:1 gso:1=20
# ipv6 tx:2 gso:1=20
# ipv6 tx:5 gso:2=20
# ipv6 tx:16 gso:1=20
# ipv6 tx:17 gso:1 (fail)
# OK
# ipv6 setsockopt
# device mtu (orig): 65536
# device mtu (test): 1500
# ipv6 tx:1 gso:0=20
# ipv6 tx:1452 gso:0=20
# ipv6 tx:1453 gso:0 (fail)
# ipv6 tx:1452 gso:1452=20
# ipv6 tx:1453 gso:1452=20
# ipv6 tx:2904 gso:1452=20
# ipv6 tx:2905 gso:1452=20
# ipv6 tx:65340 gso:1452=20
# ipv6 tx:65527 gso:1452=20
# ipv6 tx:65528 gso:1452 (fail)
# ipv6 tx:1 gso:1=20
# ipv6 tx:2 gso:1=20
# ipv6 tx:5 gso:2=20
# ipv6 tx:16 gso:1=20
# ipv6 tx:17 gso:1 (fail)
# OK
# ipv4 connected
# device mtu (orig): 65536
# device mtu (test): 1600
# route mtu (test): 1500
# path mtu (read):  1500
# ipv4 tx:1 gso:0=20
# ipv4 tx:1472 gso:0=20
# ipv4 tx:1473 gso:0 (fail)
# ipv4 tx:1472 gso:1472=20
# ipv4 tx:1473 gso:1472=20
# ipv4 tx:2944 gso:1472=20
# ipv4 tx:2945 gso:1472=20
# ipv4 tx:64768 gso:1472=20
# ipv4 tx:65507 gso:1472=20
# ipv4 tx:65508 gso:1472 (fail)
# ipv4 tx:1 gso:1=20
# ipv4 tx:2 gso:1=20
# ipv4 tx:5 gso:2=20
# ipv4 tx:36 gso:1=20
# ipv4 tx:37 gso:1 (fail)
# OK
# ipv4 msg_more
# device mtu (orig): 65536
# device mtu (test): 1500
# ipv4 tx:1 gso:0=20
# ipv4 tx:1472 gso:0=20
# ipv4 tx:1473 gso:0 (fail)
# ipv4 tx:1472 gso:1472=20
# ipv4 tx:1473 gso:1472=20
# ipv4 tx:2944 gso:1472=20
# ipv4 tx:2945 gso:1472=20
# ipv4 tx:64768 gso:1472=20
# ipv4 tx:65507 gso:1472=20
# ipv4 tx:65508 gso:1472 (fail)
# ipv4 tx:1 gso:1=20
# ipv4 tx:2 gso:1=20
# ipv4 tx:5 gso:2=20
# ipv4 tx:36 gso:1=20
# ipv4 tx:37 gso:1 (fail)
# OK
# ipv6 msg_more
# device mtu (orig): 65536
# device mtu (test): 1500
# ipv6 tx:1 gso:0=20
# ipv6 tx:1452 gso:0=20
# ipv6 tx:1453 gso:0 (fail)
# ipv6 tx:1452 gso:1452=20
# ipv6 tx:1453 gso:1452=20
# ipv6 tx:2904 gso:1452=20
# ipv6 tx:2905 gso:1452=20
# ipv6 tx:65340 gso:1452=20
# ipv6 tx:65527 gso:1452=20
# ipv6 tx:65528 gso:1452 (fail)
# ipv6 tx:1 gso:1=20
# ipv6 tx:2 gso:1=20
# ipv6 tx:5 gso:2=20
# ipv6 tx:16 gso:1=20
# ipv6 tx:17 gso:1 (fail)
# OK
ok 17 selftests: net: udpgso.sh
# selftests: net: ip_defrag.sh
# ipv4 defrag
# PASS
# seed =3D 1588914030
# ipv4 defrag with overlaps
# PASS
# seed =3D 1588914030
# ipv6 defrag
# PASS
# seed =3D 1588914034
# ipv6 defrag with overlaps
# PASS
# seed =3D 1588914034
# ipv6 nf_conntrack defrag
# PASS
# seed =3D 1588914039
# ipv6 nf_conntrack defrag with overlaps
# PASS
# seed =3D 1588914039
# all tests done
ok 18 selftests: net: ip_defrag.sh
# selftests: net: udpgso_bench.sh
# ipv4
# tcp
# tcp tx:  12010 MB/s   203700 calls/s 203700 msg/s
# tcp rx:  12020 MB/s   203860 calls/s
# tcp tx:  12145 MB/s   206003 calls/s 206003 msg/s
# tcp rx:  12158 MB/s   206118 calls/s
# tcp tx:  12128 MB/s   205714 calls/s 205714 msg/s
# tcp zerocopy
# tcp tx:   8027 MB/s   136150 calls/s 136150 msg/s
# tcp rx:   8033 MB/s   134525 calls/s
# tcp tx:   8008 MB/s   135827 calls/s 135827 msg/s
# tcp rx:   8014 MB/s   134983 calls/s
# tcp tx:   7993 MB/s   135567 calls/s 135567 msg/s
# udp
# udp rx:   1071 MB/s   763167 calls/s
# udp tx:   1071 MB/s   763182 calls/s  18171 msg/s
# udp tx:   1078 MB/s   768138 calls/s  18289 msg/s
# udp rx:   1079 MB/s   768841 calls/s
# udp tx:   1095 MB/s   780024 calls/s  18572 msg/s
# udp gso
# udp rx:   2395 MB/s  1706752 calls/s
# udp tx:   2782 MB/s    47186 calls/s  47186 msg/s
# udp tx:   2782 MB/s    47188 calls/s  47188 msg/s
# udp rx:   2387 MB/s  1700778 calls/s
# udp tx:   2806 MB/s    47605 calls/s  47605 msg/s
# udp gso zerocopy
# udp rx:   2098 MB/s  1495190 calls/s
# udp tx:   2120 MB/s    35969 calls/s  35969 msg/s
# udp tx:   2147 MB/s    36427 calls/s  36427 msg/s
# udp rx:   2106 MB/s  1500672 calls/s
# udp tx:   2147 MB/s    36425 calls/s  36425 msg/s
# udp gso timestamp
# udp tx:   2533 MB/s    42966 calls/s  42966 msg/s
# udp rx:   2380 MB/s  1695488 calls/s
# udp tx:   2549 MB/s    43236 calls/s  43236 msg/s
# udp rx:   2397 MB/s  1707730 calls/s
# udp tx:   2546 MB/s    43196 calls/s  43196 msg/s
# udp gso zerocopy audit
# udp rx:   2082 MB/s  1483776 calls/s
# udp tx:   2084 MB/s    35356 calls/s  35356 msg/s
# udp tx:   2109 MB/s    35778 calls/s  35778 msg/s
# udp rx:   2110 MB/s  1503754 calls/s
# udp tx:   2111 MB/s    35814 calls/s  35814 msg/s
# Summary over 3.000 seconds...
# sum udp tx:   2152 MB/s     106948 calls (35649/s)     106948 msgs (35649=
/s)
# Zerocopy acks:              106948
# udp gso timestamp audit
# udp tx:   2583 MB/s    43824 calls/s  43824 msg/s
# udp rx:   2377 MB/s  1693696 calls/s
# udp tx:   2613 MB/s    44323 calls/s  44323 msg/s
# udp rx:   2409 MB/s  1716480 calls/s
# udp tx:   2615 MB/s    44358 calls/s  44358 msg/s
# Summary over 3.000 seconds...
# sum udp tx:   2666 MB/s     132505 calls (44168/s)     132505 msgs (44168=
/s)
# Tx Timestamps:              132505 received                 0 errors
# udp gso zerocopy timestamp audit
# udp tx:   1951 MB/s    33096 calls/s  33096 msg/s
# udp rx:   1951 MB/s  1390032 calls/s
# udp tx:   2016 MB/s    34195 calls/s  34195 msg/s
# udp rx:   2017 MB/s  1437466 calls/s
# udp tx:   2020 MB/s    34273 calls/s  34273 msg/s
# Summary over 3.000 seconds...
# sum udp tx:   2043 MB/s     101564 calls (33854/s)     101564 msgs (33854=
/s)
# Tx Timestamps:              101564 received                 0 errors
# Zerocopy acks:              101564
# ipv6
# tcp
# tcp tx:  11604 MB/s   196816 calls/s 196816 msg/s
# tcp rx:  11614 MB/s   196951 calls/s
# tcp tx:  11896 MB/s   201776 calls/s 201776 msg/s
# tcp rx:  11908 MB/s   201963 calls/s
# tcp tx:  11823 MB/s   200528 calls/s 200528 msg/s
# tcp zerocopy
# tcp tx:   8003 MB/s   135747 calls/s 135747 msg/s
# tcp rx:   8010 MB/s   134607 calls/s
# tcp tx:   7961 MB/s   135038 calls/s 135038 msg/s
# tcp rx:   7970 MB/s   133391 calls/s
# tcp tx:   7979 MB/s   135336 calls/s 135336 msg/s
# udp
# udp rx:    991 MB/s   722900 calls/s
# udp tx:    992 MB/s   723561 calls/s  16827 msg/s
# udp rx:    996 MB/s   727101 calls/s
# udp tx:    996 MB/s   726442 calls/s  16894 msg/s
# udp tx:   1001 MB/s   730484 calls/s  16988 msg/s
# udp gso
# udp tx:   2677 MB/s    45417 calls/s  45417 msg/s
# udp rx:   2326 MB/s  1695459 calls/s
# udp tx:   2731 MB/s    46320 calls/s  46320 msg/s
# udp rx:   2375 MB/s  1731328 calls/s
# udp tx:   2725 MB/s    46227 calls/s  46227 msg/s
# udp gso zerocopy
# udp tx:   2063 MB/s    34993 calls/s  34993 msg/s
# udp rx:   2063 MB/s  1504643 calls/s
# udp tx:   2063 MB/s    34993 calls/s  34993 msg/s
# udp rx:   2062 MB/s  1504198 calls/s
# udp tx:   2046 MB/s    34708 calls/s  34708 msg/s
# udp gso timestamp
# udp tx:   2526 MB/s    42847 calls/s  42847 msg/s
# udp rx:   2371 MB/s  1728512 calls/s
# udp tx:   2556 MB/s    43359 calls/s  43359 msg/s
# udp rx:   2403 MB/s  1751552 calls/s
# udp tx:   2557 MB/s    43378 calls/s  43378 msg/s
# udp gso zerocopy audit
# udp tx:   2039 MB/s    34586 calls/s  34586 msg/s
# udp rx:   2039 MB/s  1487280 calls/s
# udp tx:   2068 MB/s    35090 calls/s  35090 msg/s
# udp rx:   2050 MB/s  1495552 calls/s
# udp tx:   2085 MB/s    35372 calls/s  35372 msg/s
# Summary over 3.000 seconds...
# sum udp tx:   2114 MB/s     105048 calls (35016/s)     105048 msgs (35016=
/s)
# Zerocopy acks:              105048
# udp gso timestamp audit
# udp rx:   2297 MB/s  1674338 calls/s
# udp tx:   2478 MB/s    42034 calls/s  42034 msg/s
# udp rx:   2341 MB/s  1706297 calls/s
# udp tx:   2519 MB/s    42729 calls/s  42729 msg/s
# udp tx:   2515 MB/s    42664 calls/s  42664 msg/s
# udp rx:   2336 MB/s  1702772 calls/s
# Summary over 3.000 seconds...
# sum udp tx:   2564 MB/s     127427 calls (42475/s)     127427 msgs (42475=
/s)
# Tx Timestamps:              127427 received                 0 errors
# udp gso zerocopy timestamp audit
# udp rx:   1891 MB/s  1379767 calls/s
# udp tx:   1892 MB/s    32106 calls/s  32106 msg/s
# udp tx:   1924 MB/s    32640 calls/s  32640 msg/s
# udp rx:   1925 MB/s  1404379 calls/s
# udp tx:   1924 MB/s    32638 calls/s  32638 msg/s
# Summary over 3.000 seconds...
# sum udp tx:   1959 MB/s      97384 calls (32461/s)      97384 msgs (32461=
/s)
# Tx Timestamps:               97384 received                 0 errors
# Zerocopy acks:               97384
# udpgso_bench.sh: PASS=3D18 SKIP=3D0 FAIL=3D0
# udpgso_bench.sh: =1B[0;92mPASS=1B[0m
ok 19 selftests: net: udpgso_bench.sh
# selftests: net: fib_rule_tests.sh
#=20
# ######################################################################
# TEST SECTION: IPv4 fib rule
# ######################################################################
#=20
#     TEST: rule4 check: oif dummy0                             [ OK ]
#=20
#     TEST: rule4 del by pref: oif dummy0                       [ OK ]
# net.ipv4.ip_forward =3D 1
# net.ipv4.conf.dummy0.rp_filter =3D 0
#=20
#     TEST: rule4 check: from 192.51.100.3 iif dummy0           [ OK ]
#=20
#     TEST: rule4 del by pref: from 192.51.100.3 iif dummy0     [ OK ]
# net.ipv4.ip_forward =3D 0
#=20
#     TEST: rule4 check: tos 0x10                               [ OK ]
#=20
#     TEST: rule4 del by pref: tos 0x10                         [ OK ]
#=20
#     TEST: rule4 check: fwmark 0x64                            [ OK ]
#=20
#     TEST: rule4 del by pref: fwmark 0x64                      [ OK ]
#=20
#     TEST: rule4 check: uidrange 100-100                       [ OK ]
#=20
#     TEST: rule4 del by pref: uidrange 100-100                 [ OK ]
#=20
#     TEST: rule4 check: sport 666 dport 777                    [ OK ]
#=20
#     TEST: rule4 del by pref: sport 666 dport 777              [ OK ]
#=20
#     TEST: rule4 check: ipproto tcp                            [ OK ]
#=20
#     TEST: rule4 del by pref: ipproto tcp                      [ OK ]
#=20
#     TEST: rule4 check: ipproto icmp                           [ OK ]
#=20
#     TEST: rule4 del by pref: ipproto icmp                     [ OK ]
#=20
# ######################################################################
# TEST SECTION: IPv6 fib rule
# ######################################################################
#=20
#     TEST: rule6 check: oif dummy0                             [ OK ]
#=20
#     TEST: rule6 del by pref: oif dummy0                       [ OK ]
#=20
#     TEST: rule6 check: from 2001:db8:1::3 iif dummy0          [ OK ]
#=20
#     TEST: rule6 del by pref: from 2001:db8:1::3 iif dummy0    [ OK ]
#=20
#     TEST: rule6 check: tos 0x10                               [ OK ]
#=20
#     TEST: rule6 del by pref: tos 0x10                         [ OK ]
#=20
#     TEST: rule6 check: fwmark 0x64                            [ OK ]
#=20
#     TEST: rule6 del by pref: fwmark 0x64                      [ OK ]
#=20
#     TEST: rule6 check: uidrange 100-100                       [ OK ]
#=20
#     TEST: rule6 del by pref: uidrange 100-100                 [ OK ]
#=20
#     TEST: rule6 check: sport 666 dport 777                    [ OK ]
#=20
#     TEST: rule6 del by pref: sport 666 dport 777              [ OK ]
#=20
#     TEST: rule6 check: ipproto tcp                            [ OK ]
#=20
#     TEST: rule6 del by pref: ipproto tcp                      [ OK ]
#=20
#     TEST: rule6 check: ipproto ipv6-icmp                      [ OK ]
#=20
#     TEST: rule6 del by pref: ipproto ipv6-icmp                [ OK ]
#=20
# Tests passed:  32
# Tests failed:   0
ok 20 selftests: net: fib_rule_tests.sh
# selftests: net: msg_zerocopy.sh
# ipv4 tcp -t 1
# tx=3D222689 (13896 MB) txc=3D0 zc=3Dn
# rx=3D111345 (13896 MB)
# ipv4 tcp -z -t 1
# tx=3D179958 (11230 MB) txc=3D179958 zc=3Dn
# rx=3D89980 (11230 MB)
# ok
# ipv6 tcp -t 1
# tx=3D218987 (13665 MB) txc=3D0 zc=3Dn
# rx=3D109494 (13665 MB)
# ipv6 tcp -z -t 1
# tx=3D175284 (10938 MB) txc=3D175284 zc=3Dn
# rx=3D87643 (10938 MB)
# ok
# ipv4 udp -t 1
# tx=3D247585 (15450 MB) txc=3D0 zc=3Dn
# rx=3D247569 (15449 MB)
# ipv4 udp -z -t 1
# tx=3D157362 (9819 MB) txc=3D157362 zc=3Dn
# rx=3D157362 (9819 MB)
# ok
# ipv6 udp -t 1
# tx=3D232468 (14506 MB) txc=3D0 zc=3Dn
# rx=3D230806 (14403 MB)
# ipv6 udp -z -t 1
# tx=3D161914 (10104 MB) txc=3D161914 zc=3Dn
# rx=3D161914 (10104 MB)
# ok
# OK. All tests passed
ok 21 selftests: net: msg_zerocopy.sh
# selftests: net: psock_snd.sh
# dgram
# tx: 128
# rx: 142
# rx: 100
# OK
#=20
# dgram bind
# tx: 128
# rx: 142
# rx: 100
# OK
#=20
# raw
# tx: 142
# rx: 142
# rx: 100
# OK
#=20
# raw bind
# tx: 142
# rx: 142
# rx: 100
# OK
#=20
# raw qdisc bypass
# tx: 142
# rx: 142
# rx: 100
# OK
#=20
# raw vlan
# tx: 146
# rx: 100
# OK
#=20
# raw vnet hdr
# tx: 152
# rx: 142
# rx: 100
# OK
#=20
# raw csum_off
# tx: 152
# rx: 142
# rx: 100
# OK
#=20
# raw csum_off with bad offset (fails)
# ./psock_snd: write: Invalid argument
# raw min size
# tx: 42
# rx: 0
# OK
#=20
# raw mtu size
# tx: 1514
# rx: 1472
# OK
#=20
# raw mtu size + 1 (fails)
# ./psock_snd: write: Message too long
# raw vlan mtu size + 1 (fails)
# ./psock_snd: write: Message too long
# dgram mtu size
# tx: 1500
# rx: 1472
# OK
#=20
# dgram mtu size + 1 (fails)
# ./psock_snd: write: Message too long
# raw truncate hlen (fails: does not arrive)
# tx: 14
# ./psock_snd: recv: Resource temporarily unavailable
# raw truncate hlen - 1 (fails: EINVAL)
# ./psock_snd: write: Invalid argument
# raw gso min size
# tx: 1525
# rx: 1473
# OK
#=20
# raw gso min size - 1 (fails)
# tx: 1524
# ./psock_snd: recv: Resource temporarily unavailable
# raw gso max size
# tx: 65559
# rx: 65507
# OK
#=20
# raw gso max size + 1 (fails)
# tx: 65560
# ./psock_snd: recv: Resource temporarily unavailable
# OK. All tests passed
ok 22 selftests: net: psock_snd.sh
# selftests: net: udpgro_bench.sh
# Missing xdp_dummy helper. Build bpf selftest first
not ok 23 selftests: net: udpgro_bench.sh # exit=3D255
# selftests: net: udpgro.sh
# Missing xdp_dummy helper. Build bpf selftest first
not ok 24 selftests: net: udpgro.sh # exit=3D255
# selftests: net: test_vxlan_under_vrf.sh
# Checking HV connectivity                                           [ OK ]
# Check VM connectivity through VXLAN (underlay in the default VRF)  [ OK ]
# Check VM connectivity through VXLAN (underlay in a VRF)            [FAIL]
not ok 25 selftests: net: test_vxlan_under_vrf.sh # exit=3D1
# selftests: net: reuseport_addr_any.sh
# UDP IPv4 ... pass
# UDP IPv6 ... pass
# UDP IPv4 mapped to IPv6 ... pass
# TCP IPv4 ... pass
# TCP IPv6 ... pass
# TCP IPv4 mapped to IPv6 ... pass
# DCCP IPv4 ... pass
# DCCP IPv6 ... pass
# DCCP IPv4 mapped to IPv6 ... pass
# SUCCESS
ok 26 selftests: net: reuseport_addr_any.sh
# selftests: net: test_vxlan_fdb_changelink.sh
# expected two remotes after fdb append	[ OK ]
# expected two remotes after link set	[ OK ]
ok 27 selftests: net: test_vxlan_fdb_changelink.sh
# selftests: net: so_txtime.sh
#=20
# SO_TXTIME ipv6 clock monotonic
# payload:a delay:14 expected:0 (us)
#=20
# SO_TXTIME ipv4 clock monotonic
# payload:a delay:43 expected:0 (us)
#=20
# SO_TXTIME ipv6 clock monotonic
# payload:a delay:30 expected:0 (us)
#=20
# SO_TXTIME ipv4 clock monotonic
# payload:a delay:19 expected:0 (us)
#=20
# SO_TXTIME ipv6 clock monotonic
# payload:a delay:10021 expected:10000 (us)
#=20
# SO_TXTIME ipv4 clock monotonic
# payload:a delay:10023 expected:10000 (us)
#=20
# SO_TXTIME ipv6 clock monotonic
# payload:a delay:10086 expected:10000 (us)
# payload:b delay:20071 expected:20000 (us)
#=20
# SO_TXTIME ipv4 clock monotonic
# payload:a delay:10075 expected:10000 (us)
# payload:b delay:20072 expected:20000 (us)
#=20
# SO_TXTIME ipv6 clock monotonic
# payload:b delay:20108 expected:20000 (us)
# payload:a delay:20128 expected:20000 (us)
#=20
# SO_TXTIME ipv4 clock monotonic
# payload:b delay:20196 expected:20000 (us)
# payload:a delay:20225 expected:20000 (us)
# Error: Specified qdisc not found.
# tc (tc utility, iproute2-ss200330) does not support qdisc etf. skipping
# OK. All tests passed
ok 28 selftests: net: so_txtime.sh
# selftests: net: ipv6_flowlabel.sh
# TEST management
# [OK]   !(flowlabel_get(fd, 1, 255, 0))
# [OK]   !(flowlabel_put(fd, 1))
# [OK]   !(flowlabel_get(fd, 0x1FFFFF, 255, 1))
# [OK]   flowlabel_get(fd, 1, 255, 1)
# [OK]   flowlabel_get(fd, 1, 255, 0)
# [OK]   flowlabel_get(fd, 1, 255, 1)
# [OK]   !(flowlabel_get(fd, 1, 255, 1 | 2))
# [OK]   flowlabel_put(fd, 1)
# [OK]   flowlabel_put(fd, 1)
# [OK]   flowlabel_put(fd, 1)
# [OK]   !(flowlabel_put(fd, 1))
# [OK]   flowlabel_get(fd, 2, 1, 1)
# [OK]   !(flowlabel_get(fd, 2, 255, 1))
# [OK]   !(flowlabel_get(fd, 2, 1, 1))
# [OK]   flowlabel_put(fd, 2)
# [OK]   flowlabel_get(fd, 3, 3, 1)
# [OK]   !(flowlabel_get(fd, 3, 255, 0))
# [OK]   !(flowlabel_get(fd, 3, 1, 0))
# [OK]   flowlabel_get(fd, 3, 3, 0)
# [OK]   flowlabel_get(fd, 3, 3, 0)
# [OK]   !(flowlabel_get(fd, 3, 3, 0))
# [OK]   flowlabel_get(fd, 4, 2, 1)
# [OK]   flowlabel_get(fd, 4, 2, 0)
# [OK]   !(flowlabel_get(fd, 4, 2, 0))
# TEST datapath
# send no label: recv no label (auto off)
# sent without label
# recv without label
# send label
# sent with label 1
# recv with label 1
# TEST datapath (with auto-flowlabels)
# send no label: recv auto flowlabel
# sent without label
# recv with label 88540
# send label
# sent with label 1
# recv with label 1
# OK. All tests passed
ok 29 selftests: net: ipv6_flowlabel.sh
# selftests: net: tcp_fastopen_backup_key.sh
# PASS
# PASS
# PASS
# PASS
# PASS
# PASS
# PASS
# PASS
# PASS
# PASS
# PASS
# PASS
# PASS
# PASS
# PASS
# PASS
# all tests done
ok 30 selftests: net: tcp_fastopen_backup_key.sh
# selftests: net: fcnal-test.sh
# 'nettest' command not found; skipping tests
ok 31 selftests: net: fcnal-test.sh
make: Leaving directory '/usr/src/perf_selftests-x86_64-rhel-7.6-kselftests=
-da43712a7262891317883d4b3a909fb18dac4b1d/tools/testing/selftests/net'


#
# Automatically generated file; DO NOT EDIT.
# Linux/x86_64 5.4.18 Kernel Configuration
#

#
# Compiler: gcc-7 (Ubuntu 7.5.0-6ubuntu2) 7.5.0
#
CONFIG_CC_IS_GCC=3Dy
CONFIG_GCC_VERSION=3D70500
CONFIG_CLANG_VERSION=3D0
CONFIG_CC_CAN_LINK=3Dy
CONFIG_CC_HAS_ASM_GOTO=3Dy
CONFIG_CC_HAS_ASM_INLINE=3Dy
CONFIG_CC_HAS_WARN_MAYBE_UNINITIALIZED=3Dy
CONFIG_IRQ_WORK=3Dy
CONFIG_BUILDTIME_EXTABLE_SORT=3Dy
CONFIG_THREAD_INFO_IN_TASK=3Dy

#
# General setup
#
CONFIG_INIT_ENV_ARG_LIMIT=3D32
# CONFIG_COMPILE_TEST is not set
# CONFIG_HEADER_TEST is not set
CONFIG_LOCALVERSION=3D""
CONFIG_LOCALVERSION_AUTO=3Dy
CONFIG_BUILD_SALT=3D""
CONFIG_HAVE_KERNEL_GZIP=3Dy
CONFIG_HAVE_KERNEL_BZIP2=3Dy
CONFIG_HAVE_KERNEL_LZMA=3Dy
CONFIG_HAVE_KERNEL_XZ=3Dy
CONFIG_HAVE_KERNEL_LZO=3Dy
CONFIG_HAVE_KERNEL_LZ4=3Dy
CONFIG_KERNEL_GZIP=3Dy
# CONFIG_KERNEL_BZIP2 is not set
# CONFIG_KERNEL_LZMA is not set
# CONFIG_KERNEL_XZ is not set
# CONFIG_KERNEL_LZO is not set
# CONFIG_KERNEL_LZ4 is not set
CONFIG_DEFAULT_HOSTNAME=3D"(none)"
CONFIG_SWAP=3Dy
CONFIG_SYSVIPC=3Dy
CONFIG_SYSVIPC_SYSCTL=3Dy
CONFIG_POSIX_MQUEUE=3Dy
CONFIG_POSIX_MQUEUE_SYSCTL=3Dy
CONFIG_CROSS_MEMORY_ATTACH=3Dy
CONFIG_USELIB=3Dy
CONFIG_AUDIT=3Dy
CONFIG_HAVE_ARCH_AUDITSYSCALL=3Dy
CONFIG_AUDITSYSCALL=3Dy

#
# IRQ subsystem
#
CONFIG_GENERIC_IRQ_PROBE=3Dy
CONFIG_GENERIC_IRQ_SHOW=3Dy
CONFIG_GENERIC_IRQ_EFFECTIVE_AFF_MASK=3Dy
CONFIG_GENERIC_PENDING_IRQ=3Dy
CONFIG_GENERIC_IRQ_MIGRATION=3Dy
CONFIG_IRQ_DOMAIN=3Dy
CONFIG_IRQ_SIM=3Dy
CONFIG_IRQ_DOMAIN_HIERARCHY=3Dy
CONFIG_GENERIC_MSI_IRQ=3Dy
CONFIG_GENERIC_MSI_IRQ_DOMAIN=3Dy
CONFIG_GENERIC_IRQ_MATRIX_ALLOCATOR=3Dy
CONFIG_GENERIC_IRQ_RESERVATION_MODE=3Dy
CONFIG_IRQ_FORCED_THREADING=3Dy
CONFIG_SPARSE_IRQ=3Dy
# CONFIG_GENERIC_IRQ_DEBUGFS is not set
# end of IRQ subsystem

CONFIG_CLOCKSOURCE_WATCHDOG=3Dy
CONFIG_ARCH_CLOCKSOURCE_DATA=3Dy
CONFIG_ARCH_CLOCKSOURCE_INIT=3Dy
CONFIG_CLOCKSOURCE_VALIDATE_LAST_CYCLE=3Dy
CONFIG_GENERIC_TIME_VSYSCALL=3Dy
CONFIG_GENERIC_CLOCKEVENTS=3Dy
CONFIG_GENERIC_CLOCKEVENTS_BROADCAST=3Dy
CONFIG_GENERIC_CLOCKEVENTS_MIN_ADJUST=3Dy
CONFIG_GENERIC_CMOS_UPDATE=3Dy

#
# Timers subsystem
#
CONFIG_TICK_ONESHOT=3Dy
CONFIG_NO_HZ_COMMON=3Dy
# CONFIG_HZ_PERIODIC is not set
# CONFIG_NO_HZ_IDLE is not set
CONFIG_NO_HZ_FULL=3Dy
CONFIG_CONTEXT_TRACKING=3Dy
# CONFIG_CONTEXT_TRACKING_FORCE is not set
CONFIG_NO_HZ=3Dy
CONFIG_HIGH_RES_TIMERS=3Dy
# end of Timers subsystem

# CONFIG_PREEMPT_NONE is not set
CONFIG_PREEMPT_VOLUNTARY=3Dy
# CONFIG_PREEMPT is not set
CONFIG_PREEMPT_COUNT=3Dy

#
# CPU/Task time and stats accounting
#
CONFIG_VIRT_CPU_ACCOUNTING=3Dy
CONFIG_VIRT_CPU_ACCOUNTING_GEN=3Dy
# CONFIG_IRQ_TIME_ACCOUNTING is not set
CONFIG_HAVE_SCHED_AVG_IRQ=3Dy
CONFIG_BSD_PROCESS_ACCT=3Dy
CONFIG_BSD_PROCESS_ACCT_V3=3Dy
CONFIG_TASKSTATS=3Dy
CONFIG_TASK_DELAY_ACCT=3Dy
CONFIG_TASK_XACCT=3Dy
CONFIG_TASK_IO_ACCOUNTING=3Dy
# CONFIG_PSI is not set
# end of CPU/Task time and stats accounting

CONFIG_CPU_ISOLATION=3Dy

#
# RCU Subsystem
#
CONFIG_TREE_RCU=3Dy
# CONFIG_RCU_EXPERT is not set
CONFIG_SRCU=3Dy
CONFIG_TREE_SRCU=3Dy
CONFIG_TASKS_RCU=3Dy
CONFIG_RCU_STALL_COMMON=3Dy
CONFIG_RCU_NEED_SEGCBLIST=3Dy
CONFIG_RCU_NOCB_CPU=3Dy
# end of RCU Subsystem

CONFIG_BUILD_BIN2C=3Dy
CONFIG_IKCONFIG=3Dy
CONFIG_IKCONFIG_PROC=3Dy
# CONFIG_IKHEADERS is not set
CONFIG_LOG_BUF_SHIFT=3D20
CONFIG_LOG_CPU_MAX_BUF_SHIFT=3D12
CONFIG_PRINTK_SAFE_LOG_BUF_SHIFT=3D13
CONFIG_HAVE_UNSTABLE_SCHED_CLOCK=3Dy

#
# Scheduler features
#
# end of Scheduler features

CONFIG_ARCH_SUPPORTS_NUMA_BALANCING=3Dy
CONFIG_ARCH_WANT_BATCHED_UNMAP_TLB_FLUSH=3Dy
CONFIG_ARCH_SUPPORTS_INT128=3Dy
CONFIG_NUMA_BALANCING=3Dy
CONFIG_NUMA_BALANCING_DEFAULT_ENABLED=3Dy
CONFIG_CGROUPS=3Dy
CONFIG_PAGE_COUNTER=3Dy
CONFIG_MEMCG=3Dy
CONFIG_MEMCG_SWAP=3Dy
CONFIG_MEMCG_SWAP_ENABLED=3Dy
CONFIG_MEMCG_KMEM=3Dy
CONFIG_BLK_CGROUP=3Dy
CONFIG_CGROUP_WRITEBACK=3Dy
CONFIG_CGROUP_SCHED=3Dy
CONFIG_FAIR_GROUP_SCHED=3Dy
CONFIG_CFS_BANDWIDTH=3Dy
CONFIG_RT_GROUP_SCHED=3Dy
CONFIG_CGROUP_PIDS=3Dy
# CONFIG_CGROUP_RDMA is not set
CONFIG_CGROUP_FREEZER=3Dy
CONFIG_CGROUP_HUGETLB=3Dy
CONFIG_CPUSETS=3Dy
CONFIG_PROC_PID_CPUSET=3Dy
CONFIG_CGROUP_DEVICE=3Dy
CONFIG_CGROUP_CPUACCT=3Dy
CONFIG_CGROUP_PERF=3Dy
CONFIG_CGROUP_BPF=3Dy
# CONFIG_CGROUP_DEBUG is not set
CONFIG_SOCK_CGROUP_DATA=3Dy
CONFIG_NAMESPACES=3Dy
CONFIG_UTS_NS=3Dy
CONFIG_IPC_NS=3Dy
CONFIG_USER_NS=3Dy
CONFIG_PID_NS=3Dy
CONFIG_NET_NS=3Dy
CONFIG_CHECKPOINT_RESTORE=3Dy
CONFIG_SCHED_AUTOGROUP=3Dy
# CONFIG_SYSFS_DEPRECATED is not set
CONFIG_RELAY=3Dy
CONFIG_BLK_DEV_INITRD=3Dy
CONFIG_INITRAMFS_SOURCE=3D""
CONFIG_RD_GZIP=3Dy
CONFIG_RD_BZIP2=3Dy
CONFIG_RD_LZMA=3Dy
CONFIG_RD_XZ=3Dy
CONFIG_RD_LZO=3Dy
CONFIG_RD_LZ4=3Dy
CONFIG_CC_OPTIMIZE_FOR_PERFORMANCE=3Dy
# CONFIG_CC_OPTIMIZE_FOR_SIZE is not set
CONFIG_SYSCTL=3Dy
CONFIG_HAVE_UID16=3Dy
CONFIG_SYSCTL_EXCEPTION_TRACE=3Dy
CONFIG_HAVE_PCSPKR_PLATFORM=3Dy
CONFIG_BPF=3Dy
CONFIG_EXPERT=3Dy
CONFIG_UID16=3Dy
CONFIG_MULTIUSER=3Dy
CONFIG_SGETMASK_SYSCALL=3Dy
CONFIG_SYSFS_SYSCALL=3Dy
# CONFIG_SYSCTL_SYSCALL is not set
CONFIG_FHANDLE=3Dy
CONFIG_POSIX_TIMERS=3Dy
CONFIG_PRINTK=3Dy
CONFIG_PRINTK_NMI=3Dy
CONFIG_BUG=3Dy
CONFIG_ELF_CORE=3Dy
CONFIG_PCSPKR_PLATFORM=3Dy
CONFIG_BASE_FULL=3Dy
CONFIG_FUTEX=3Dy
CONFIG_FUTEX_PI=3Dy
CONFIG_EPOLL=3Dy
CONFIG_SIGNALFD=3Dy
CONFIG_TIMERFD=3Dy
CONFIG_EVENTFD=3Dy
CONFIG_SHMEM=3Dy
CONFIG_AIO=3Dy
CONFIG_IO_URING=3Dy
CONFIG_ADVISE_SYSCALLS=3Dy
CONFIG_MEMBARRIER=3Dy
CONFIG_KALLSYMS=3Dy
CONFIG_KALLSYMS_ALL=3Dy
CONFIG_KALLSYMS_ABSOLUTE_PERCPU=3Dy
CONFIG_KALLSYMS_BASE_RELATIVE=3Dy
CONFIG_BPF_SYSCALL=3Dy
CONFIG_BPF_JIT_ALWAYS_ON=3Dy
CONFIG_USERFAULTFD=3Dy
CONFIG_ARCH_HAS_MEMBARRIER_SYNC_CORE=3Dy
CONFIG_RSEQ=3Dy
# CONFIG_DEBUG_RSEQ is not set
CONFIG_EMBEDDED=3Dy
CONFIG_HAVE_PERF_EVENTS=3Dy
# CONFIG_PC104 is not set

#
# Kernel Performance Events And Counters
#
CONFIG_PERF_EVENTS=3Dy
# CONFIG_DEBUG_PERF_USE_VMALLOC is not set
# end of Kernel Performance Events And Counters

CONFIG_VM_EVENT_COUNTERS=3Dy
CONFIG_SLUB_DEBUG=3Dy
# CONFIG_SLUB_MEMCG_SYSFS_ON is not set
# CONFIG_COMPAT_BRK is not set
# CONFIG_SLAB is not set
CONFIG_SLUB=3Dy
# CONFIG_SLOB is not set
CONFIG_SLAB_MERGE_DEFAULT=3Dy
# CONFIG_SLAB_FREELIST_RANDOM is not set
# CONFIG_SLAB_FREELIST_HARDENED is not set
# CONFIG_SHUFFLE_PAGE_ALLOCATOR is not set
CONFIG_SLUB_CPU_PARTIAL=3Dy
CONFIG_SYSTEM_DATA_VERIFICATION=3Dy
CONFIG_PROFILING=3Dy
CONFIG_TRACEPOINTS=3Dy
# end of General setup

CONFIG_64BIT=3Dy
CONFIG_X86_64=3Dy
CONFIG_X86=3Dy
CONFIG_INSTRUCTION_DECODER=3Dy
CONFIG_OUTPUT_FORMAT=3D"elf64-x86-64"
CONFIG_ARCH_DEFCONFIG=3D"arch/x86/configs/x86_64_defconfig"
CONFIG_LOCKDEP_SUPPORT=3Dy
CONFIG_STACKTRACE_SUPPORT=3Dy
CONFIG_MMU=3Dy
CONFIG_ARCH_MMAP_RND_BITS_MIN=3D28
CONFIG_ARCH_MMAP_RND_BITS_MAX=3D32
CONFIG_ARCH_MMAP_RND_COMPAT_BITS_MIN=3D8
CONFIG_ARCH_MMAP_RND_COMPAT_BITS_MAX=3D16
CONFIG_GENERIC_ISA_DMA=3Dy
CONFIG_GENERIC_BUG=3Dy
CONFIG_GENERIC_BUG_RELATIVE_POINTERS=3Dy
CONFIG_ARCH_MAY_HAVE_PC_FDC=3Dy
CONFIG_GENERIC_CALIBRATE_DELAY=3Dy
CONFIG_ARCH_HAS_CPU_RELAX=3Dy
CONFIG_ARCH_HAS_CACHE_LINE_SIZE=3Dy
CONFIG_ARCH_HAS_FILTER_PGPROT=3Dy
CONFIG_HAVE_SETUP_PER_CPU_AREA=3Dy
CONFIG_NEED_PER_CPU_EMBED_FIRST_CHUNK=3Dy
CONFIG_NEED_PER_CPU_PAGE_FIRST_CHUNK=3Dy
CONFIG_ARCH_HIBERNATION_POSSIBLE=3Dy
CONFIG_ARCH_SUSPEND_POSSIBLE=3Dy
CONFIG_ARCH_WANT_GENERAL_HUGETLB=3Dy
CONFIG_ZONE_DMA32=3Dy
CONFIG_AUDIT_ARCH=3Dy
CONFIG_ARCH_SUPPORTS_DEBUG_PAGEALLOC=3Dy
CONFIG_HAVE_INTEL_TXT=3Dy
CONFIG_X86_64_SMP=3Dy
CONFIG_ARCH_SUPPORTS_UPROBES=3Dy
CONFIG_FIX_EARLYCON_MEM=3Dy
CONFIG_DYNAMIC_PHYSICAL_MASK=3Dy
CONFIG_PGTABLE_LEVELS=3D5
CONFIG_CC_HAS_SANE_STACKPROTECTOR=3Dy

#
# Processor type and features
#
CONFIG_ZONE_DMA=3Dy
CONFIG_SMP=3Dy
CONFIG_X86_FEATURE_NAMES=3Dy
CONFIG_X86_X2APIC=3Dy
CONFIG_X86_MPPARSE=3Dy
# CONFIG_GOLDFISH is not set
CONFIG_RETPOLINE=3Dy
CONFIG_X86_CPU_RESCTRL=3Dy
CONFIG_X86_EXTENDED_PLATFORM=3Dy
# CONFIG_X86_NUMACHIP is not set
# CONFIG_X86_VSMP is not set
CONFIG_X86_UV=3Dy
# CONFIG_X86_GOLDFISH is not set
# CONFIG_X86_INTEL_MID is not set
CONFIG_X86_INTEL_LPSS=3Dy
CONFIG_X86_AMD_PLATFORM_DEVICE=3Dy
CONFIG_IOSF_MBI=3Dy
# CONFIG_IOSF_MBI_DEBUG is not set
CONFIG_X86_SUPPORTS_MEMORY_FAILURE=3Dy
# CONFIG_SCHED_OMIT_FRAME_POINTER is not set
CONFIG_HYPERVISOR_GUEST=3Dy
CONFIG_PARAVIRT=3Dy
CONFIG_PARAVIRT_XXL=3Dy
# CONFIG_PARAVIRT_DEBUG is not set
CONFIG_PARAVIRT_SPINLOCKS=3Dy
CONFIG_X86_HV_CALLBACK_VECTOR=3Dy
CONFIG_XEN=3Dy
CONFIG_XEN_PV=3Dy
CONFIG_XEN_PV_SMP=3Dy
# CONFIG_XEN_DOM0 is not set
CONFIG_XEN_PVHVM=3Dy
CONFIG_XEN_PVHVM_SMP=3Dy
CONFIG_XEN_512GB=3Dy
CONFIG_XEN_SAVE_RESTORE=3Dy
# CONFIG_XEN_DEBUG_FS is not set
# CONFIG_XEN_PVH is not set
CONFIG_KVM_GUEST=3Dy
CONFIG_ARCH_CPUIDLE_HALTPOLL=3Dy
# CONFIG_PVH is not set
# CONFIG_KVM_DEBUG_FS is not set
CONFIG_PARAVIRT_TIME_ACCOUNTING=3Dy
CONFIG_PARAVIRT_CLOCK=3Dy
# CONFIG_JAILHOUSE_GUEST is not set
# CONFIG_ACRN_GUEST is not set
# CONFIG_MK8 is not set
# CONFIG_MPSC is not set
# CONFIG_MCORE2 is not set
# CONFIG_MATOM is not set
CONFIG_GENERIC_CPU=3Dy
CONFIG_X86_INTERNODE_CACHE_SHIFT=3D6
CONFIG_X86_L1_CACHE_SHIFT=3D6
CONFIG_X86_TSC=3Dy
CONFIG_X86_CMPXCHG64=3Dy
CONFIG_X86_CMOV=3Dy
CONFIG_X86_MINIMUM_CPU_FAMILY=3D64
CONFIG_X86_DEBUGCTLMSR=3Dy
# CONFIG_PROCESSOR_SELECT is not set
CONFIG_CPU_SUP_INTEL=3Dy
CONFIG_CPU_SUP_AMD=3Dy
CONFIG_CPU_SUP_HYGON=3Dy
CONFIG_CPU_SUP_CENTAUR=3Dy
CONFIG_CPU_SUP_ZHAOXIN=3Dy
CONFIG_HPET_TIMER=3Dy
CONFIG_HPET_EMULATE_RTC=3Dy
CONFIG_DMI=3Dy
CONFIG_GART_IOMMU=3Dy
# CONFIG_CALGARY_IOMMU is not set
CONFIG_MAXSMP=3Dy
CONFIG_NR_CPUS_RANGE_BEGIN=3D8192
CONFIG_NR_CPUS_RANGE_END=3D8192
CONFIG_NR_CPUS_DEFAULT=3D8192
CONFIG_NR_CPUS=3D8192
CONFIG_SCHED_SMT=3Dy
CONFIG_SCHED_MC=3Dy
CONFIG_SCHED_MC_PRIO=3Dy
CONFIG_X86_LOCAL_APIC=3Dy
CONFIG_X86_IO_APIC=3Dy
CONFIG_X86_REROUTE_FOR_BROKEN_BOOT_IRQS=3Dy
CONFIG_X86_MCE=3Dy
# CONFIG_X86_MCELOG_LEGACY is not set
CONFIG_X86_MCE_INTEL=3Dy
CONFIG_X86_MCE_AMD=3Dy
CONFIG_X86_MCE_THRESHOLD=3Dy
CONFIG_X86_MCE_INJECT=3Dm
CONFIG_X86_THERMAL_VECTOR=3Dy

#
# Performance monitoring
#
CONFIG_PERF_EVENTS_INTEL_UNCORE=3Dy
CONFIG_PERF_EVENTS_INTEL_RAPL=3Dy
CONFIG_PERF_EVENTS_INTEL_CSTATE=3Dy
# CONFIG_PERF_EVENTS_AMD_POWER is not set
# end of Performance monitoring

CONFIG_X86_16BIT=3Dy
CONFIG_X86_ESPFIX64=3Dy
CONFIG_X86_VSYSCALL_EMULATION=3Dy
CONFIG_I8K=3Dm
CONFIG_MICROCODE=3Dy
CONFIG_MICROCODE_INTEL=3Dy
CONFIG_MICROCODE_AMD=3Dy
CONFIG_MICROCODE_OLD_INTERFACE=3Dy
CONFIG_X86_MSR=3Dy
CONFIG_X86_CPUID=3Dy
CONFIG_X86_5LEVEL=3Dy
CONFIG_X86_DIRECT_GBPAGES=3Dy
# CONFIG_X86_CPA_STATISTICS is not set
CONFIG_AMD_MEM_ENCRYPT=3Dy
# CONFIG_AMD_MEM_ENCRYPT_ACTIVE_BY_DEFAULT is not set
CONFIG_NUMA=3Dy
CONFIG_AMD_NUMA=3Dy
CONFIG_X86_64_ACPI_NUMA=3Dy
CONFIG_NODES_SPAN_OTHER_NODES=3Dy
# CONFIG_NUMA_EMU is not set
CONFIG_NODES_SHIFT=3D10
CONFIG_ARCH_SPARSEMEM_ENABLE=3Dy
CONFIG_ARCH_SPARSEMEM_DEFAULT=3Dy
CONFIG_ARCH_SELECT_MEMORY_MODEL=3Dy
CONFIG_ARCH_MEMORY_PROBE=3Dy
CONFIG_ARCH_PROC_KCORE_TEXT=3Dy
CONFIG_ILLEGAL_POINTER_VALUE=3D0xdead000000000000
CONFIG_X86_PMEM_LEGACY_DEVICE=3Dy
CONFIG_X86_PMEM_LEGACY=3Dm
CONFIG_X86_CHECK_BIOS_CORRUPTION=3Dy
# CONFIG_X86_BOOTPARAM_MEMORY_CORRUPTION_CHECK is not set
CONFIG_X86_RESERVE_LOW=3D64
CONFIG_MTRR=3Dy
CONFIG_MTRR_SANITIZER=3Dy
CONFIG_MTRR_SANITIZER_ENABLE_DEFAULT=3D1
CONFIG_MTRR_SANITIZER_SPARE_REG_NR_DEFAULT=3D1
CONFIG_X86_PAT=3Dy
CONFIG_ARCH_USES_PG_UNCACHED=3Dy
CONFIG_ARCH_RANDOM=3Dy
CONFIG_X86_SMAP=3Dy
CONFIG_X86_INTEL_UMIP=3Dy
CONFIG_X86_INTEL_MPX=3Dy
CONFIG_X86_INTEL_MEMORY_PROTECTION_KEYS=3Dy
CONFIG_X86_INTEL_TSX_MODE_OFF=3Dy
# CONFIG_X86_INTEL_TSX_MODE_ON is not set
# CONFIG_X86_INTEL_TSX_MODE_AUTO is not set
CONFIG_EFI=3Dy
CONFIG_EFI_STUB=3Dy
CONFIG_EFI_MIXED=3Dy
CONFIG_SECCOMP=3Dy
# CONFIG_HZ_100 is not set
# CONFIG_HZ_250 is not set
# CONFIG_HZ_300 is not set
CONFIG_HZ_1000=3Dy
CONFIG_HZ=3D1000
CONFIG_SCHED_HRTICK=3Dy
CONFIG_KEXEC=3Dy
CONFIG_KEXEC_FILE=3Dy
CONFIG_ARCH_HAS_KEXEC_PURGATORY=3Dy
# CONFIG_KEXEC_SIG is not set
CONFIG_CRASH_DUMP=3Dy
CONFIG_KEXEC_JUMP=3Dy
CONFIG_PHYSICAL_START=3D0x1000000
CONFIG_RELOCATABLE=3Dy
CONFIG_RANDOMIZE_BASE=3Dy
CONFIG_X86_NEED_RELOCS=3Dy
CONFIG_PHYSICAL_ALIGN=3D0x200000
CONFIG_DYNAMIC_MEMORY_LAYOUT=3Dy
CONFIG_RANDOMIZE_MEMORY=3Dy
CONFIG_RANDOMIZE_MEMORY_PHYSICAL_PADDING=3D0xa
CONFIG_HOTPLUG_CPU=3Dy
CONFIG_BOOTPARAM_HOTPLUG_CPU0=3Dy
# CONFIG_DEBUG_HOTPLUG_CPU0 is not set
# CONFIG_COMPAT_VDSO is not set
CONFIG_LEGACY_VSYSCALL_EMULATE=3Dy
# CONFIG_LEGACY_VSYSCALL_XONLY is not set
# CONFIG_LEGACY_VSYSCALL_NONE is not set
# CONFIG_CMDLINE_BOOL is not set
CONFIG_MODIFY_LDT_SYSCALL=3Dy
CONFIG_HAVE_LIVEPATCH=3Dy
CONFIG_LIVEPATCH=3Dy
# end of Processor type and features

CONFIG_ARCH_HAS_ADD_PAGES=3Dy
CONFIG_ARCH_ENABLE_MEMORY_HOTPLUG=3Dy
CONFIG_ARCH_ENABLE_MEMORY_HOTREMOVE=3Dy
CONFIG_USE_PERCPU_NUMA_NODE_ID=3Dy
CONFIG_ARCH_ENABLE_SPLIT_PMD_PTLOCK=3Dy
CONFIG_ARCH_ENABLE_HUGEPAGE_MIGRATION=3Dy
CONFIG_ARCH_ENABLE_THP_MIGRATION=3Dy

#
# Power management and ACPI options
#
CONFIG_ARCH_HIBERNATION_HEADER=3Dy
CONFIG_SUSPEND=3Dy
CONFIG_SUSPEND_FREEZER=3Dy
# CONFIG_SUSPEND_SKIP_SYNC is not set
CONFIG_HIBERNATE_CALLBACKS=3Dy
CONFIG_HIBERNATION=3Dy
CONFIG_PM_STD_PARTITION=3D""
CONFIG_PM_SLEEP=3Dy
CONFIG_PM_SLEEP_SMP=3Dy
# CONFIG_PM_AUTOSLEEP is not set
# CONFIG_PM_WAKELOCKS is not set
CONFIG_PM=3Dy
CONFIG_PM_DEBUG=3Dy
CONFIG_PM_ADVANCED_DEBUG=3Dy
# CONFIG_PM_TEST_SUSPEND is not set
CONFIG_PM_SLEEP_DEBUG=3Dy
# CONFIG_DPM_WATCHDOG is not set
CONFIG_PM_TRACE=3Dy
CONFIG_PM_TRACE_RTC=3Dy
CONFIG_PM_CLK=3Dy
# CONFIG_WQ_POWER_EFFICIENT_DEFAULT is not set
# CONFIG_ENERGY_MODEL is not set
CONFIG_ARCH_SUPPORTS_ACPI=3Dy
CONFIG_ACPI=3Dy
CONFIG_ACPI_LEGACY_TABLES_LOOKUP=3Dy
CONFIG_ARCH_MIGHT_HAVE_ACPI_PDC=3Dy
CONFIG_ACPI_SYSTEM_POWER_STATES_SUPPORT=3Dy
# CONFIG_ACPI_DEBUGGER is not set
CONFIG_ACPI_SPCR_TABLE=3Dy
CONFIG_ACPI_LPIT=3Dy
CONFIG_ACPI_SLEEP=3Dy
# CONFIG_ACPI_PROCFS_POWER is not set
CONFIG_ACPI_REV_OVERRIDE_POSSIBLE=3Dy
CONFIG_ACPI_EC_DEBUGFS=3Dm
CONFIG_ACPI_AC=3Dy
CONFIG_ACPI_BATTERY=3Dy
CONFIG_ACPI_BUTTON=3Dy
CONFIG_ACPI_VIDEO=3Dm
CONFIG_ACPI_FAN=3Dy
# CONFIG_ACPI_TAD is not set
CONFIG_ACPI_DOCK=3Dy
CONFIG_ACPI_CPU_FREQ_PSS=3Dy
CONFIG_ACPI_PROCESSOR_CSTATE=3Dy
CONFIG_ACPI_PROCESSOR_IDLE=3Dy
CONFIG_ACPI_CPPC_LIB=3Dy
CONFIG_ACPI_PROCESSOR=3Dy
CONFIG_ACPI_IPMI=3Dm
CONFIG_ACPI_HOTPLUG_CPU=3Dy
CONFIG_ACPI_PROCESSOR_AGGREGATOR=3Dm
CONFIG_ACPI_THERMAL=3Dy
CONFIG_ACPI_NUMA=3Dy
CONFIG_ARCH_HAS_ACPI_TABLE_UPGRADE=3Dy
CONFIG_ACPI_TABLE_UPGRADE=3Dy
# CONFIG_ACPI_DEBUG is not set
CONFIG_ACPI_PCI_SLOT=3Dy
CONFIG_ACPI_CONTAINER=3Dy
CONFIG_ACPI_HOTPLUG_MEMORY=3Dy
CONFIG_ACPI_HOTPLUG_IOAPIC=3Dy
CONFIG_ACPI_SBS=3Dm
CONFIG_ACPI_HED=3Dy
CONFIG_ACPI_CUSTOM_METHOD=3Dm
CONFIG_ACPI_BGRT=3Dy
# CONFIG_ACPI_REDUCED_HARDWARE_ONLY is not set
CONFIG_ACPI_NFIT=3Dm
# CONFIG_NFIT_SECURITY_DEBUG is not set
# CONFIG_ACPI_HMAT is not set
CONFIG_HAVE_ACPI_APEI=3Dy
CONFIG_HAVE_ACPI_APEI_NMI=3Dy
CONFIG_ACPI_APEI=3Dy
CONFIG_ACPI_APEI_GHES=3Dy
CONFIG_ACPI_APEI_PCIEAER=3Dy
CONFIG_ACPI_APEI_MEMORY_FAILURE=3Dy
CONFIG_ACPI_APEI_EINJ=3Dm
# CONFIG_ACPI_APEI_ERST_DEBUG is not set
# CONFIG_DPTF_POWER is not set
CONFIG_ACPI_WATCHDOG=3Dy
CONFIG_ACPI_EXTLOG=3Dm
CONFIG_ACPI_ADXL=3Dy
# CONFIG_PMIC_OPREGION is not set
# CONFIG_ACPI_CONFIGFS is not set
CONFIG_X86_PM_TIMER=3Dy
CONFIG_SFI=3Dy

#
# CPU Frequency scaling
#
CONFIG_CPU_FREQ=3Dy
CONFIG_CPU_FREQ_GOV_ATTR_SET=3Dy
CONFIG_CPU_FREQ_GOV_COMMON=3Dy
# CONFIG_CPU_FREQ_STAT is not set
# CONFIG_CPU_FREQ_DEFAULT_GOV_PERFORMANCE is not set
# CONFIG_CPU_FREQ_DEFAULT_GOV_POWERSAVE is not set
# CONFIG_CPU_FREQ_DEFAULT_GOV_USERSPACE is not set
CONFIG_CPU_FREQ_DEFAULT_GOV_ONDEMAND=3Dy
# CONFIG_CPU_FREQ_DEFAULT_GOV_CONSERVATIVE is not set
# CONFIG_CPU_FREQ_DEFAULT_GOV_SCHEDUTIL is not set
CONFIG_CPU_FREQ_GOV_PERFORMANCE=3Dy
CONFIG_CPU_FREQ_GOV_POWERSAVE=3Dy
CONFIG_CPU_FREQ_GOV_USERSPACE=3Dy
CONFIG_CPU_FREQ_GOV_ONDEMAND=3Dy
CONFIG_CPU_FREQ_GOV_CONSERVATIVE=3Dy
# CONFIG_CPU_FREQ_GOV_SCHEDUTIL is not set

#
# CPU frequency scaling drivers
#
CONFIG_X86_INTEL_PSTATE=3Dy
CONFIG_X86_PCC_CPUFREQ=3Dm
CONFIG_X86_ACPI_CPUFREQ=3Dm
CONFIG_X86_ACPI_CPUFREQ_CPB=3Dy
CONFIG_X86_POWERNOW_K8=3Dm
CONFIG_X86_AMD_FREQ_SENSITIVITY=3Dm
# CONFIG_X86_SPEEDSTEP_CENTRINO is not set
CONFIG_X86_P4_CLOCKMOD=3Dm

#
# shared options
#
CONFIG_X86_SPEEDSTEP_LIB=3Dm
# end of CPU Frequency scaling

#
# CPU Idle
#
CONFIG_CPU_IDLE=3Dy
# CONFIG_CPU_IDLE_GOV_LADDER is not set
CONFIG_CPU_IDLE_GOV_MENU=3Dy
# CONFIG_CPU_IDLE_GOV_TEO is not set
# CONFIG_CPU_IDLE_GOV_HALTPOLL is not set
CONFIG_HALTPOLL_CPUIDLE=3Dy
# end of CPU Idle

CONFIG_INTEL_IDLE=3Dy
# end of Power management and ACPI options

#
# Bus options (PCI etc.)
#
CONFIG_PCI_DIRECT=3Dy
CONFIG_PCI_MMCONFIG=3Dy
CONFIG_PCI_XEN=3Dy
CONFIG_MMCONF_FAM10H=3Dy
# CONFIG_PCI_CNB20LE_QUIRK is not set
# CONFIG_ISA_BUS is not set
CONFIG_ISA_DMA_API=3Dy
CONFIG_AMD_NB=3Dy
# CONFIG_X86_SYSFB is not set
# end of Bus options (PCI etc.)

#
# Binary Emulations
#
CONFIG_IA32_EMULATION=3Dy
# CONFIG_X86_X32 is not set
CONFIG_COMPAT_32=3Dy
CONFIG_COMPAT=3Dy
CONFIG_COMPAT_FOR_U64_ALIGNMENT=3Dy
CONFIG_SYSVIPC_COMPAT=3Dy
# end of Binary Emulations

CONFIG_X86_DEV_DMA_OPS=3Dy

#
# Firmware Drivers
#
CONFIG_EDD=3Dm
# CONFIG_EDD_OFF is not set
CONFIG_FIRMWARE_MEMMAP=3Dy
CONFIG_DMIID=3Dy
CONFIG_DMI_SYSFS=3Dy
CONFIG_DMI_SCAN_MACHINE_NON_EFI_FALLBACK=3Dy
CONFIG_ISCSI_IBFT_FIND=3Dy
CONFIG_ISCSI_IBFT=3Dm
CONFIG_FW_CFG_SYSFS=3Dy
# CONFIG_FW_CFG_SYSFS_CMDLINE is not set
# CONFIG_GOOGLE_FIRMWARE is not set

#
# EFI (Extensible Firmware Interface) Support
#
CONFIG_EFI_VARS=3Dy
CONFIG_EFI_ESRT=3Dy
CONFIG_EFI_VARS_PSTORE=3Dy
CONFIG_EFI_VARS_PSTORE_DEFAULT_DISABLE=3Dy
CONFIG_EFI_RUNTIME_MAP=3Dy
# CONFIG_EFI_FAKE_MEMMAP is not set
CONFIG_EFI_RUNTIME_WRAPPERS=3Dy
# CONFIG_EFI_BOOTLOADER_CONTROL is not set
# CONFIG_EFI_CAPSULE_LOADER is not set
# CONFIG_EFI_TEST is not set
CONFIG_APPLE_PROPERTIES=3Dy
# CONFIG_RESET_ATTACK_MITIGATION is not set
# CONFIG_EFI_RCI2_TABLE is not set
# end of EFI (Extensible Firmware Interface) Support

CONFIG_UEFI_CPER=3Dy
CONFIG_UEFI_CPER_X86=3Dy
CONFIG_EFI_DEV_PATH_PARSER=3Dy
CONFIG_EFI_EARLYCON=3Dy

#
# Tegra firmware driver
#
# end of Tegra firmware driver
# end of Firmware Drivers

CONFIG_HAVE_KVM=3Dy
CONFIG_HAVE_KVM_IRQCHIP=3Dy
CONFIG_HAVE_KVM_IRQFD=3Dy
CONFIG_HAVE_KVM_IRQ_ROUTING=3Dy
CONFIG_HAVE_KVM_EVENTFD=3Dy
CONFIG_KVM_MMIO=3Dy
CONFIG_KVM_ASYNC_PF=3Dy
CONFIG_HAVE_KVM_MSI=3Dy
CONFIG_HAVE_KVM_CPU_RELAX_INTERCEPT=3Dy
CONFIG_KVM_VFIO=3Dy
CONFIG_KVM_GENERIC_DIRTYLOG_READ_PROTECT=3Dy
CONFIG_KVM_COMPAT=3Dy
CONFIG_HAVE_KVM_IRQ_BYPASS=3Dy
CONFIG_HAVE_KVM_NO_POLL=3Dy
CONFIG_VIRTUALIZATION=3Dy
CONFIG_KVM=3Dm
CONFIG_KVM_INTEL=3Dm
CONFIG_KVM_AMD=3Dm
CONFIG_KVM_AMD_SEV=3Dy
CONFIG_KVM_MMU_AUDIT=3Dy
CONFIG_VHOST_NET=3Dm
# CONFIG_VHOST_SCSI is not set
CONFIG_VHOST_VSOCK=3Dm
CONFIG_VHOST=3Dm
# CONFIG_VHOST_CROSS_ENDIAN_LEGACY is not set

#
# General architecture-dependent options
#
CONFIG_CRASH_CORE=3Dy
CONFIG_KEXEC_CORE=3Dy
CONFIG_HOTPLUG_SMT=3Dy
CONFIG_OPROFILE=3Dm
CONFIG_OPROFILE_EVENT_MULTIPLEX=3Dy
CONFIG_HAVE_OPROFILE=3Dy
CONFIG_OPROFILE_NMI_TIMER=3Dy
CONFIG_KPROBES=3Dy
CONFIG_JUMP_LABEL=3Dy
# CONFIG_STATIC_KEYS_SELFTEST is not set
CONFIG_OPTPROBES=3Dy
CONFIG_KPROBES_ON_FTRACE=3Dy
CONFIG_UPROBES=3Dy
CONFIG_HAVE_EFFICIENT_UNALIGNED_ACCESS=3Dy
CONFIG_ARCH_USE_BUILTIN_BSWAP=3Dy
CONFIG_KRETPROBES=3Dy
CONFIG_USER_RETURN_NOTIFIER=3Dy
CONFIG_HAVE_IOREMAP_PROT=3Dy
CONFIG_HAVE_KPROBES=3Dy
CONFIG_HAVE_KRETPROBES=3Dy
CONFIG_HAVE_OPTPROBES=3Dy
CONFIG_HAVE_KPROBES_ON_FTRACE=3Dy
CONFIG_HAVE_FUNCTION_ERROR_INJECTION=3Dy
CONFIG_HAVE_NMI=3Dy
CONFIG_HAVE_ARCH_TRACEHOOK=3Dy
CONFIG_HAVE_DMA_CONTIGUOUS=3Dy
CONFIG_GENERIC_SMP_IDLE_THREAD=3Dy
CONFIG_ARCH_HAS_FORTIFY_SOURCE=3Dy
CONFIG_ARCH_HAS_SET_MEMORY=3Dy
CONFIG_ARCH_HAS_SET_DIRECT_MAP=3Dy
CONFIG_HAVE_ARCH_THREAD_STRUCT_WHITELIST=3Dy
CONFIG_ARCH_WANTS_DYNAMIC_TASK_STRUCT=3Dy
CONFIG_HAVE_ASM_MODVERSIONS=3Dy
CONFIG_HAVE_REGS_AND_STACK_ACCESS_API=3Dy
CONFIG_HAVE_RSEQ=3Dy
CONFIG_HAVE_FUNCTION_ARG_ACCESS_API=3Dy
CONFIG_HAVE_CLK=3Dy
CONFIG_HAVE_HW_BREAKPOINT=3Dy
CONFIG_HAVE_MIXED_BREAKPOINTS_REGS=3Dy
CONFIG_HAVE_USER_RETURN_NOTIFIER=3Dy
CONFIG_HAVE_PERF_EVENTS_NMI=3Dy
CONFIG_HAVE_HARDLOCKUP_DETECTOR_PERF=3Dy
CONFIG_HAVE_PERF_REGS=3Dy
CONFIG_HAVE_PERF_USER_STACK_DUMP=3Dy
CONFIG_HAVE_ARCH_JUMP_LABEL=3Dy
CONFIG_HAVE_ARCH_JUMP_LABEL_RELATIVE=3Dy
CONFIG_HAVE_RCU_TABLE_FREE=3Dy
CONFIG_ARCH_HAVE_NMI_SAFE_CMPXCHG=3Dy
CONFIG_HAVE_ALIGNED_STRUCT_PAGE=3Dy
CONFIG_HAVE_CMPXCHG_LOCAL=3Dy
CONFIG_HAVE_CMPXCHG_DOUBLE=3Dy
CONFIG_ARCH_WANT_COMPAT_IPC_PARSE_VERSION=3Dy
CONFIG_ARCH_WANT_OLD_COMPAT_IPC=3Dy
CONFIG_HAVE_ARCH_SECCOMP_FILTER=3Dy
CONFIG_SECCOMP_FILTER=3Dy
CONFIG_HAVE_ARCH_STACKLEAK=3Dy
CONFIG_HAVE_STACKPROTECTOR=3Dy
CONFIG_CC_HAS_STACKPROTECTOR_NONE=3Dy
CONFIG_STACKPROTECTOR=3Dy
CONFIG_STACKPROTECTOR_STRONG=3Dy
CONFIG_HAVE_ARCH_WITHIN_STACK_FRAMES=3Dy
CONFIG_HAVE_CONTEXT_TRACKING=3Dy
CONFIG_HAVE_VIRT_CPU_ACCOUNTING_GEN=3Dy
CONFIG_HAVE_IRQ_TIME_ACCOUNTING=3Dy
CONFIG_HAVE_MOVE_PMD=3Dy
CONFIG_HAVE_ARCH_TRANSPARENT_HUGEPAGE=3Dy
CONFIG_HAVE_ARCH_TRANSPARENT_HUGEPAGE_PUD=3Dy
CONFIG_HAVE_ARCH_HUGE_VMAP=3Dy
CONFIG_ARCH_WANT_HUGE_PMD_SHARE=3Dy
CONFIG_HAVE_ARCH_SOFT_DIRTY=3Dy
CONFIG_HAVE_MOD_ARCH_SPECIFIC=3Dy
CONFIG_MODULES_USE_ELF_RELA=3Dy
CONFIG_HAVE_IRQ_EXIT_ON_IRQ_STACK=3Dy
CONFIG_ARCH_HAS_ELF_RANDOMIZE=3Dy
CONFIG_HAVE_ARCH_MMAP_RND_BITS=3Dy
CONFIG_HAVE_EXIT_THREAD=3Dy
CONFIG_ARCH_MMAP_RND_BITS=3D28
CONFIG_HAVE_ARCH_MMAP_RND_COMPAT_BITS=3Dy
CONFIG_ARCH_MMAP_RND_COMPAT_BITS=3D8
CONFIG_HAVE_ARCH_COMPAT_MMAP_BASES=3Dy
CONFIG_HAVE_COPY_THREAD_TLS=3Dy
CONFIG_HAVE_STACK_VALIDATION=3Dy
CONFIG_HAVE_RELIABLE_STACKTRACE=3Dy
CONFIG_OLD_SIGSUSPEND3=3Dy
CONFIG_COMPAT_OLD_SIGACTION=3Dy
CONFIG_64BIT_TIME=3Dy
CONFIG_COMPAT_32BIT_TIME=3Dy
CONFIG_HAVE_ARCH_VMAP_STACK=3Dy
CONFIG_VMAP_STACK=3Dy
CONFIG_ARCH_HAS_STRICT_KERNEL_RWX=3Dy
CONFIG_STRICT_KERNEL_RWX=3Dy
CONFIG_ARCH_HAS_STRICT_MODULE_RWX=3Dy
CONFIG_STRICT_MODULE_RWX=3Dy
CONFIG_ARCH_HAS_REFCOUNT=3Dy
# CONFIG_REFCOUNT_FULL is not set
CONFIG_HAVE_ARCH_PREL32_RELOCATIONS=3Dy
CONFIG_ARCH_USE_MEMREMAP_PROT=3Dy
# CONFIG_LOCK_EVENT_COUNTS is not set
CONFIG_ARCH_HAS_MEM_ENCRYPT=3Dy

#
# GCOV-based kernel profiling
#
# CONFIG_GCOV_KERNEL is not set
CONFIG_ARCH_HAS_GCOV_PROFILE_ALL=3Dy
# end of GCOV-based kernel profiling

CONFIG_PLUGIN_HOSTCC=3D"g++"
CONFIG_HAVE_GCC_PLUGINS=3Dy
CONFIG_GCC_PLUGINS=3Dy
# CONFIG_GCC_PLUGIN_CYC_COMPLEXITY is not set
# CONFIG_GCC_PLUGIN_LATENT_ENTROPY is not set
# CONFIG_GCC_PLUGIN_RANDSTRUCT is not set
# end of General architecture-dependent options

CONFIG_RT_MUTEXES=3Dy
CONFIG_BASE_SMALL=3D0
CONFIG_MODULE_SIG_FORMAT=3Dy
CONFIG_MODULES=3Dy
CONFIG_MODULE_FORCE_LOAD=3Dy
CONFIG_MODULE_UNLOAD=3Dy
# CONFIG_MODULE_FORCE_UNLOAD is not set
# CONFIG_MODVERSIONS is not set
# CONFIG_MODULE_SRCVERSION_ALL is not set
CONFIG_MODULE_SIG=3Dy
# CONFIG_MODULE_SIG_FORCE is not set
CONFIG_MODULE_SIG_ALL=3Dy
# CONFIG_MODULE_SIG_SHA1 is not set
# CONFIG_MODULE_SIG_SHA224 is not set
CONFIG_MODULE_SIG_SHA256=3Dy
# CONFIG_MODULE_SIG_SHA384 is not set
# CONFIG_MODULE_SIG_SHA512 is not set
CONFIG_MODULE_SIG_HASH=3D"sha256"
# CONFIG_MODULE_COMPRESS is not set
# CONFIG_MODULE_ALLOW_MISSING_NAMESPACE_IMPORTS is not set
# CONFIG_UNUSED_SYMBOLS is not set
# CONFIG_TRIM_UNUSED_KSYMS is not set
CONFIG_MODULES_TREE_LOOKUP=3Dy
CONFIG_BLOCK=3Dy
CONFIG_BLK_SCSI_REQUEST=3Dy
CONFIG_BLK_DEV_BSG=3Dy
CONFIG_BLK_DEV_BSGLIB=3Dy
CONFIG_BLK_DEV_INTEGRITY=3Dy
# CONFIG_BLK_DEV_ZONED is not set
CONFIG_BLK_DEV_THROTTLING=3Dy
# CONFIG_BLK_DEV_THROTTLING_LOW is not set
# CONFIG_BLK_CMDLINE_PARSER is not set
# CONFIG_BLK_WBT is not set
# CONFIG_BLK_CGROUP_IOLATENCY is not set
# CONFIG_BLK_CGROUP_IOCOST is not set
CONFIG_BLK_DEBUG_FS=3Dy
# CONFIG_BLK_SED_OPAL is not set

#
# Partition Types
#
CONFIG_PARTITION_ADVANCED=3Dy
# CONFIG_ACORN_PARTITION is not set
# CONFIG_AIX_PARTITION is not set
CONFIG_OSF_PARTITION=3Dy
CONFIG_AMIGA_PARTITION=3Dy
# CONFIG_ATARI_PARTITION is not set
CONFIG_MAC_PARTITION=3Dy
CONFIG_MSDOS_PARTITION=3Dy
CONFIG_BSD_DISKLABEL=3Dy
CONFIG_MINIX_SUBPARTITION=3Dy
CONFIG_SOLARIS_X86_PARTITION=3Dy
CONFIG_UNIXWARE_DISKLABEL=3Dy
# CONFIG_LDM_PARTITION is not set
CONFIG_SGI_PARTITION=3Dy
# CONFIG_ULTRIX_PARTITION is not set
CONFIG_SUN_PARTITION=3Dy
CONFIG_KARMA_PARTITION=3Dy
CONFIG_EFI_PARTITION=3Dy
# CONFIG_SYSV68_PARTITION is not set
# CONFIG_CMDLINE_PARTITION is not set
# end of Partition Types

CONFIG_BLOCK_COMPAT=3Dy
CONFIG_BLK_MQ_PCI=3Dy
CONFIG_BLK_MQ_VIRTIO=3Dy
CONFIG_BLK_PM=3Dy

#
# IO Schedulers
#
CONFIG_MQ_IOSCHED_DEADLINE=3Dy
CONFIG_MQ_IOSCHED_KYBER=3Dy
# CONFIG_IOSCHED_BFQ is not set
# end of IO Schedulers

CONFIG_PREEMPT_NOTIFIERS=3Dy
CONFIG_PADATA=3Dy
CONFIG_ASN1=3Dy
CONFIG_INLINE_SPIN_UNLOCK_IRQ=3Dy
CONFIG_INLINE_READ_UNLOCK=3Dy
CONFIG_INLINE_READ_UNLOCK_IRQ=3Dy
CONFIG_INLINE_WRITE_UNLOCK=3Dy
CONFIG_INLINE_WRITE_UNLOCK_IRQ=3Dy
CONFIG_ARCH_SUPPORTS_ATOMIC_RMW=3Dy
CONFIG_MUTEX_SPIN_ON_OWNER=3Dy
CONFIG_RWSEM_SPIN_ON_OWNER=3Dy
CONFIG_LOCK_SPIN_ON_OWNER=3Dy
CONFIG_ARCH_USE_QUEUED_SPINLOCKS=3Dy
CONFIG_QUEUED_SPINLOCKS=3Dy
CONFIG_ARCH_USE_QUEUED_RWLOCKS=3Dy
CONFIG_QUEUED_RWLOCKS=3Dy
CONFIG_ARCH_HAS_SYNC_CORE_BEFORE_USERMODE=3Dy
CONFIG_ARCH_HAS_SYSCALL_WRAPPER=3Dy
CONFIG_FREEZER=3Dy

#
# Executable file formats
#
CONFIG_BINFMT_ELF=3Dy
CONFIG_COMPAT_BINFMT_ELF=3Dy
CONFIG_ELFCORE=3Dy
CONFIG_CORE_DUMP_DEFAULT_ELF_HEADERS=3Dy
CONFIG_BINFMT_SCRIPT=3Dy
CONFIG_BINFMT_MISC=3Dm
CONFIG_COREDUMP=3Dy
# end of Executable file formats

#
# Memory Management options
#
CONFIG_SELECT_MEMORY_MODEL=3Dy
CONFIG_SPARSEMEM_MANUAL=3Dy
CONFIG_SPARSEMEM=3Dy
CONFIG_NEED_MULTIPLE_NODES=3Dy
CONFIG_HAVE_MEMORY_PRESENT=3Dy
CONFIG_SPARSEMEM_EXTREME=3Dy
CONFIG_SPARSEMEM_VMEMMAP_ENABLE=3Dy
CONFIG_SPARSEMEM_VMEMMAP=3Dy
CONFIG_HAVE_MEMBLOCK_NODE_MAP=3Dy
CONFIG_HAVE_FAST_GUP=3Dy
CONFIG_MEMORY_ISOLATION=3Dy
CONFIG_HAVE_BOOTMEM_INFO_NODE=3Dy
CONFIG_MEMORY_HOTPLUG=3Dy
CONFIG_MEMORY_HOTPLUG_SPARSE=3Dy
# CONFIG_MEMORY_HOTPLUG_DEFAULT_ONLINE is not set
CONFIG_MEMORY_HOTREMOVE=3Dy
CONFIG_SPLIT_PTLOCK_CPUS=3D4
CONFIG_MEMORY_BALLOON=3Dy
CONFIG_BALLOON_COMPACTION=3Dy
CONFIG_COMPACTION=3Dy
CONFIG_MIGRATION=3Dy
CONFIG_CONTIG_ALLOC=3Dy
CONFIG_PHYS_ADDR_T_64BIT=3Dy
CONFIG_BOUNCE=3Dy
CONFIG_VIRT_TO_BUS=3Dy
CONFIG_MMU_NOTIFIER=3Dy
CONFIG_KSM=3Dy
CONFIG_DEFAULT_MMAP_MIN_ADDR=3D4096
CONFIG_ARCH_SUPPORTS_MEMORY_FAILURE=3Dy
CONFIG_MEMORY_FAILURE=3Dy
CONFIG_HWPOISON_INJECT=3Dm
CONFIG_TRANSPARENT_HUGEPAGE=3Dy
CONFIG_TRANSPARENT_HUGEPAGE_ALWAYS=3Dy
# CONFIG_TRANSPARENT_HUGEPAGE_MADVISE is not set
CONFIG_ARCH_WANTS_THP_SWAP=3Dy
CONFIG_THP_SWAP=3Dy
CONFIG_TRANSPARENT_HUGE_PAGECACHE=3Dy
CONFIG_CLEANCACHE=3Dy
CONFIG_FRONTSWAP=3Dy
CONFIG_CMA=3Dy
# CONFIG_CMA_DEBUG is not set
# CONFIG_CMA_DEBUGFS is not set
CONFIG_CMA_AREAS=3D7
CONFIG_MEM_SOFT_DIRTY=3Dy
CONFIG_ZSWAP=3Dy
CONFIG_ZPOOL=3Dy
CONFIG_ZBUD=3Dy
# CONFIG_Z3FOLD is not set
CONFIG_ZSMALLOC=3Dy
# CONFIG_PGTABLE_MAPPING is not set
# CONFIG_ZSMALLOC_STAT is not set
CONFIG_GENERIC_EARLY_IOREMAP=3Dy
CONFIG_DEFERRED_STRUCT_PAGE_INIT=3Dy
CONFIG_IDLE_PAGE_TRACKING=3Dy
CONFIG_ARCH_HAS_PTE_DEVMAP=3Dy
CONFIG_ZONE_DEVICE=3Dy
CONFIG_DEV_PAGEMAP_OPS=3Dy
# CONFIG_DEVICE_PRIVATE is not set
CONFIG_FRAME_VECTOR=3Dy
CONFIG_ARCH_USES_HIGH_VMA_FLAGS=3Dy
CONFIG_ARCH_HAS_PKEYS=3Dy
# CONFIG_PERCPU_STATS is not set
CONFIG_GUP_BENCHMARK=3Dy
# CONFIG_READ_ONLY_THP_FOR_FS is not set
CONFIG_ARCH_HAS_PTE_SPECIAL=3Dy
# end of Memory Management options

CONFIG_NET=3Dy
CONFIG_COMPAT_NETLINK_MESSAGES=3Dy
CONFIG_NET_INGRESS=3Dy
CONFIG_NET_EGRESS=3Dy
CONFIG_SKB_EXTENSIONS=3Dy

#
# Networking options
#
CONFIG_PACKET=3Dy
CONFIG_PACKET_DIAG=3Dm
CONFIG_UNIX=3Dy
CONFIG_UNIX_SCM=3Dy
CONFIG_UNIX_DIAG=3Dm
# CONFIG_TLS is not set
CONFIG_XFRM=3Dy
CONFIG_XFRM_ALGO=3Dy
CONFIG_XFRM_USER=3Dy
# CONFIG_XFRM_INTERFACE is not set
CONFIG_XFRM_SUB_POLICY=3Dy
CONFIG_XFRM_MIGRATE=3Dy
CONFIG_XFRM_STATISTICS=3Dy
CONFIG_XFRM_IPCOMP=3Dm
CONFIG_NET_KEY=3Dm
CONFIG_NET_KEY_MIGRATE=3Dy
# CONFIG_XDP_SOCKETS is not set
CONFIG_INET=3Dy
CONFIG_IP_MULTICAST=3Dy
CONFIG_IP_ADVANCED_ROUTER=3Dy
CONFIG_IP_FIB_TRIE_STATS=3Dy
CONFIG_IP_MULTIPLE_TABLES=3Dy
CONFIG_IP_ROUTE_MULTIPATH=3Dy
CONFIG_IP_ROUTE_VERBOSE=3Dy
CONFIG_IP_ROUTE_CLASSID=3Dy
CONFIG_IP_PNP=3Dy
CONFIG_IP_PNP_DHCP=3Dy
# CONFIG_IP_PNP_BOOTP is not set
# CONFIG_IP_PNP_RARP is not set
CONFIG_NET_IPIP=3Dm
CONFIG_NET_IPGRE_DEMUX=3Dm
CONFIG_NET_IP_TUNNEL=3Dm
CONFIG_NET_IPGRE=3Dm
CONFIG_NET_IPGRE_BROADCAST=3Dy
CONFIG_IP_MROUTE_COMMON=3Dy
CONFIG_IP_MROUTE=3Dy
CONFIG_IP_MROUTE_MULTIPLE_TABLES=3Dy
CONFIG_IP_PIMSM_V1=3Dy
CONFIG_IP_PIMSM_V2=3Dy
CONFIG_SYN_COOKIES=3Dy
CONFIG_NET_IPVTI=3Dm
CONFIG_NET_UDP_TUNNEL=3Dm
CONFIG_NET_FOU=3Dm
CONFIG_NET_FOU_IP_TUNNELS=3Dy
CONFIG_INET_AH=3Dm
CONFIG_INET_ESP=3Dm
# CONFIG_INET_ESP_OFFLOAD is not set
CONFIG_INET_IPCOMP=3Dm
CONFIG_INET_XFRM_TUNNEL=3Dm
CONFIG_INET_TUNNEL=3Dm
CONFIG_INET_DIAG=3Dm
CONFIG_INET_TCP_DIAG=3Dm
CONFIG_INET_UDP_DIAG=3Dm
# CONFIG_INET_RAW_DIAG is not set
# CONFIG_INET_DIAG_DESTROY is not set
CONFIG_TCP_CONG_ADVANCED=3Dy
CONFIG_TCP_CONG_BIC=3Dm
CONFIG_TCP_CONG_CUBIC=3Dy
CONFIG_TCP_CONG_WESTWOOD=3Dm
CONFIG_TCP_CONG_HTCP=3Dm
CONFIG_TCP_CONG_HSTCP=3Dm
CONFIG_TCP_CONG_HYBLA=3Dm
CONFIG_TCP_CONG_VEGAS=3Dm
# CONFIG_TCP_CONG_NV is not set
CONFIG_TCP_CONG_SCALABLE=3Dm
CONFIG_TCP_CONG_LP=3Dm
CONFIG_TCP_CONG_VENO=3Dm
CONFIG_TCP_CONG_YEAH=3Dm
CONFIG_TCP_CONG_ILLINOIS=3Dm
CONFIG_TCP_CONG_DCTCP=3Dm
# CONFIG_TCP_CONG_CDG is not set
# CONFIG_TCP_CONG_BBR is not set
CONFIG_DEFAULT_CUBIC=3Dy
# CONFIG_DEFAULT_RENO is not set
CONFIG_DEFAULT_TCP_CONG=3D"cubic"
CONFIG_TCP_MD5SIG=3Dy
CONFIG_IPV6=3Dy
CONFIG_IPV6_ROUTER_PREF=3Dy
CONFIG_IPV6_ROUTE_INFO=3Dy
CONFIG_IPV6_OPTIMISTIC_DAD=3Dy
CONFIG_INET6_AH=3Dm
CONFIG_INET6_ESP=3Dm
# CONFIG_INET6_ESP_OFFLOAD is not set
CONFIG_INET6_IPCOMP=3Dm
CONFIG_IPV6_MIP6=3Dm
# CONFIG_IPV6_ILA is not set
CONFIG_INET6_XFRM_TUNNEL=3Dm
CONFIG_INET6_TUNNEL=3Dm
CONFIG_IPV6_VTI=3Dm
CONFIG_IPV6_SIT=3Dm
CONFIG_IPV6_SIT_6RD=3Dy
CONFIG_IPV6_NDISC_NODETYPE=3Dy
CONFIG_IPV6_TUNNEL=3Dm
CONFIG_IPV6_GRE=3Dm
CONFIG_IPV6_FOU=3Dm
CONFIG_IPV6_FOU_TUNNEL=3Dm
CONFIG_IPV6_MULTIPLE_TABLES=3Dy
# CONFIG_IPV6_SUBTREES is not set
CONFIG_IPV6_MROUTE=3Dy
CONFIG_IPV6_MROUTE_MULTIPLE_TABLES=3Dy
CONFIG_IPV6_PIMSM_V2=3Dy
CONFIG_IPV6_SEG6_LWTUNNEL=3Dy
# CONFIG_IPV6_SEG6_HMAC is not set
CONFIG_IPV6_SEG6_BPF=3Dy
CONFIG_NETLABEL=3Dy
CONFIG_NETWORK_SECMARK=3Dy
CONFIG_NET_PTP_CLASSIFY=3Dy
CONFIG_NETWORK_PHY_TIMESTAMPING=3Dy
CONFIG_NETFILTER=3Dy
CONFIG_NETFILTER_ADVANCED=3Dy
CONFIG_BRIDGE_NETFILTER=3Dm

#
# Core Netfilter Configuration
#
CONFIG_NETFILTER_INGRESS=3Dy
CONFIG_NETFILTER_NETLINK=3Dm
CONFIG_NETFILTER_FAMILY_BRIDGE=3Dy
CONFIG_NETFILTER_FAMILY_ARP=3Dy
CONFIG_NETFILTER_NETLINK_ACCT=3Dm
CONFIG_NETFILTER_NETLINK_QUEUE=3Dm
CONFIG_NETFILTER_NETLINK_LOG=3Dm
CONFIG_NETFILTER_NETLINK_OSF=3Dm
CONFIG_NF_CONNTRACK=3Dm
CONFIG_NF_LOG_COMMON=3Dm
# CONFIG_NF_LOG_NETDEV is not set
CONFIG_NETFILTER_CONNCOUNT=3Dm
CONFIG_NF_CONNTRACK_MARK=3Dy
CONFIG_NF_CONNTRACK_SECMARK=3Dy
CONFIG_NF_CONNTRACK_ZONES=3Dy
CONFIG_NF_CONNTRACK_PROCFS=3Dy
CONFIG_NF_CONNTRACK_EVENTS=3Dy
CONFIG_NF_CONNTRACK_TIMEOUT=3Dy
CONFIG_NF_CONNTRACK_TIMESTAMP=3Dy
CONFIG_NF_CONNTRACK_LABELS=3Dy
CONFIG_NF_CT_PROTO_DCCP=3Dy
CONFIG_NF_CT_PROTO_GRE=3Dy
CONFIG_NF_CT_PROTO_SCTP=3Dy
CONFIG_NF_CT_PROTO_UDPLITE=3Dy
CONFIG_NF_CONNTRACK_AMANDA=3Dm
CONFIG_NF_CONNTRACK_FTP=3Dm
CONFIG_NF_CONNTRACK_H323=3Dm
CONFIG_NF_CONNTRACK_IRC=3Dm
CONFIG_NF_CONNTRACK_BROADCAST=3Dm
CONFIG_NF_CONNTRACK_NETBIOS_NS=3Dm
CONFIG_NF_CONNTRACK_SNMP=3Dm
CONFIG_NF_CONNTRACK_PPTP=3Dm
CONFIG_NF_CONNTRACK_SANE=3Dm
CONFIG_NF_CONNTRACK_SIP=3Dm
CONFIG_NF_CONNTRACK_TFTP=3Dm
CONFIG_NF_CT_NETLINK=3Dm
CONFIG_NF_CT_NETLINK_TIMEOUT=3Dm
# CONFIG_NETFILTER_NETLINK_GLUE_CT is not set
CONFIG_NF_NAT=3Dm
CONFIG_NF_NAT_AMANDA=3Dm
CONFIG_NF_NAT_FTP=3Dm
CONFIG_NF_NAT_IRC=3Dm
CONFIG_NF_NAT_SIP=3Dm
CONFIG_NF_NAT_TFTP=3Dm
CONFIG_NF_NAT_REDIRECT=3Dy
CONFIG_NF_NAT_MASQUERADE=3Dy
CONFIG_NETFILTER_SYNPROXY=3Dm
CONFIG_NF_TABLES=3Dm
# CONFIG_NF_TABLES_SET is not set
CONFIG_NF_TABLES_INET=3Dy
CONFIG_NF_TABLES_NETDEV=3Dy
# CONFIG_NFT_NUMGEN is not set
CONFIG_NFT_CT=3Dm
CONFIG_NFT_FLOW_OFFLOAD=3Dm
CONFIG_NFT_COUNTER=3Dm
# CONFIG_NFT_CONNLIMIT is not set
CONFIG_NFT_LOG=3Dm
CONFIG_NFT_LIMIT=3Dm
CONFIG_NFT_MASQ=3Dm
CONFIG_NFT_REDIR=3Dm
CONFIG_NFT_NAT=3Dm
# CONFIG_NFT_TUNNEL is not set
CONFIG_NFT_OBJREF=3Dm
CONFIG_NFT_QUEUE=3Dm
# CONFIG_NFT_QUOTA is not set
CONFIG_NFT_REJECT=3Dm
CONFIG_NFT_REJECT_INET=3Dm
CONFIG_NFT_COMPAT=3Dm
CONFIG_NFT_HASH=3Dm
# CONFIG_NFT_XFRM is not set
# CONFIG_NFT_SOCKET is not set
# CONFIG_NFT_OSF is not set
# CONFIG_NFT_TPROXY is not set
# CONFIG_NFT_SYNPROXY is not set
# CONFIG_NF_DUP_NETDEV is not set
# CONFIG_NFT_DUP_NETDEV is not set
# CONFIG_NFT_FWD_NETDEV is not set
CONFIG_NF_FLOW_TABLE_INET=3Dm
CONFIG_NF_FLOW_TABLE=3Dm
CONFIG_NETFILTER_XTABLES=3Dy

#
# Xtables combined modules
#
CONFIG_NETFILTER_XT_MARK=3Dm
CONFIG_NETFILTER_XT_CONNMARK=3Dm
CONFIG_NETFILTER_XT_SET=3Dm

#
# Xtables targets
#
CONFIG_NETFILTER_XT_TARGET_AUDIT=3Dm
CONFIG_NETFILTER_XT_TARGET_CHECKSUM=3Dm
CONFIG_NETFILTER_XT_TARGET_CLASSIFY=3Dm
CONFIG_NETFILTER_XT_TARGET_CONNMARK=3Dm
CONFIG_NETFILTER_XT_TARGET_CONNSECMARK=3Dm
CONFIG_NETFILTER_XT_TARGET_CT=3Dm
CONFIG_NETFILTER_XT_TARGET_DSCP=3Dm
CONFIG_NETFILTER_XT_TARGET_HL=3Dm
CONFIG_NETFILTER_XT_TARGET_HMARK=3Dm
CONFIG_NETFILTER_XT_TARGET_IDLETIMER=3Dm
CONFIG_NETFILTER_XT_TARGET_LED=3Dm
CONFIG_NETFILTER_XT_TARGET_LOG=3Dm
CONFIG_NETFILTER_XT_TARGET_MARK=3Dm
CONFIG_NETFILTER_XT_NAT=3Dm
CONFIG_NETFILTER_XT_TARGET_NETMAP=3Dm
CONFIG_NETFILTER_XT_TARGET_NFLOG=3Dm
CONFIG_NETFILTER_XT_TARGET_NFQUEUE=3Dm
CONFIG_NETFILTER_XT_TARGET_NOTRACK=3Dm
CONFIG_NETFILTER_XT_TARGET_RATEEST=3Dm
CONFIG_NETFILTER_XT_TARGET_REDIRECT=3Dm
CONFIG_NETFILTER_XT_TARGET_MASQUERADE=3Dm
CONFIG_NETFILTER_XT_TARGET_TEE=3Dm
CONFIG_NETFILTER_XT_TARGET_TPROXY=3Dm
CONFIG_NETFILTER_XT_TARGET_TRACE=3Dm
CONFIG_NETFILTER_XT_TARGET_SECMARK=3Dm
CONFIG_NETFILTER_XT_TARGET_TCPMSS=3Dm
CONFIG_NETFILTER_XT_TARGET_TCPOPTSTRIP=3Dm

#
# Xtables matches
#
CONFIG_NETFILTER_XT_MATCH_ADDRTYPE=3Dm
CONFIG_NETFILTER_XT_MATCH_BPF=3Dm
CONFIG_NETFILTER_XT_MATCH_CGROUP=3Dm
CONFIG_NETFILTER_XT_MATCH_CLUSTER=3Dm
CONFIG_NETFILTER_XT_MATCH_COMMENT=3Dm
CONFIG_NETFILTER_XT_MATCH_CONNBYTES=3Dm
CONFIG_NETFILTER_XT_MATCH_CONNLABEL=3Dm
CONFIG_NETFILTER_XT_MATCH_CONNLIMIT=3Dm
CONFIG_NETFILTER_XT_MATCH_CONNMARK=3Dm
CONFIG_NETFILTER_XT_MATCH_CONNTRACK=3Dm
CONFIG_NETFILTER_XT_MATCH_CPU=3Dm
CONFIG_NETFILTER_XT_MATCH_DCCP=3Dm
CONFIG_NETFILTER_XT_MATCH_DEVGROUP=3Dm
CONFIG_NETFILTER_XT_MATCH_DSCP=3Dm
CONFIG_NETFILTER_XT_MATCH_ECN=3Dm
CONFIG_NETFILTER_XT_MATCH_ESP=3Dm
CONFIG_NETFILTER_XT_MATCH_HASHLIMIT=3Dm
CONFIG_NETFILTER_XT_MATCH_HELPER=3Dm
CONFIG_NETFILTER_XT_MATCH_HL=3Dm
# CONFIG_NETFILTER_XT_MATCH_IPCOMP is not set
CONFIG_NETFILTER_XT_MATCH_IPRANGE=3Dm
CONFIG_NETFILTER_XT_MATCH_IPVS=3Dm
CONFIG_NETFILTER_XT_MATCH_L2TP=3Dm
CONFIG_NETFILTER_XT_MATCH_LENGTH=3Dm
CONFIG_NETFILTER_XT_MATCH_LIMIT=3Dm
CONFIG_NETFILTER_XT_MATCH_MAC=3Dm
CONFIG_NETFILTER_XT_MATCH_MARK=3Dm
CONFIG_NETFILTER_XT_MATCH_MULTIPORT=3Dm
CONFIG_NETFILTER_XT_MATCH_NFACCT=3Dm
CONFIG_NETFILTER_XT_MATCH_OSF=3Dm
CONFIG_NETFILTER_XT_MATCH_OWNER=3Dm
CONFIG_NETFILTER_XT_MATCH_POLICY=3Dm
CONFIG_NETFILTER_XT_MATCH_PHYSDEV=3Dm
CONFIG_NETFILTER_XT_MATCH_PKTTYPE=3Dm
CONFIG_NETFILTER_XT_MATCH_QUOTA=3Dm
CONFIG_NETFILTER_XT_MATCH_RATEEST=3Dm
CONFIG_NETFILTER_XT_MATCH_REALM=3Dm
CONFIG_NETFILTER_XT_MATCH_RECENT=3Dm
CONFIG_NETFILTER_XT_MATCH_SCTP=3Dm
CONFIG_NETFILTER_XT_MATCH_SOCKET=3Dm
CONFIG_NETFILTER_XT_MATCH_STATE=3Dm
CONFIG_NETFILTER_XT_MATCH_STATISTIC=3Dm
CONFIG_NETFILTER_XT_MATCH_STRING=3Dm
CONFIG_NETFILTER_XT_MATCH_TCPMSS=3Dm
CONFIG_NETFILTER_XT_MATCH_TIME=3Dm
CONFIG_NETFILTER_XT_MATCH_U32=3Dm
# end of Core Netfilter Configuration

CONFIG_IP_SET=3Dm
CONFIG_IP_SET_MAX=3D256
CONFIG_IP_SET_BITMAP_IP=3Dm
CONFIG_IP_SET_BITMAP_IPMAC=3Dm
CONFIG_IP_SET_BITMAP_PORT=3Dm
CONFIG_IP_SET_HASH_IP=3Dm
CONFIG_IP_SET_HASH_IPMARK=3Dm
CONFIG_IP_SET_HASH_IPPORT=3Dm
CONFIG_IP_SET_HASH_IPPORTIP=3Dm
CONFIG_IP_SET_HASH_IPPORTNET=3Dm
CONFIG_IP_SET_HASH_IPMAC=3Dm
CONFIG_IP_SET_HASH_MAC=3Dm
CONFIG_IP_SET_HASH_NETPORTNET=3Dm
CONFIG_IP_SET_HASH_NET=3Dm
CONFIG_IP_SET_HASH_NETNET=3Dm
CONFIG_IP_SET_HASH_NETPORT=3Dm
CONFIG_IP_SET_HASH_NETIFACE=3Dm
CONFIG_IP_SET_LIST_SET=3Dm
CONFIG_IP_VS=3Dm
CONFIG_IP_VS_IPV6=3Dy
# CONFIG_IP_VS_DEBUG is not set
CONFIG_IP_VS_TAB_BITS=3D12

#
# IPVS transport protocol load balancing support
#
CONFIG_IP_VS_PROTO_TCP=3Dy
CONFIG_IP_VS_PROTO_UDP=3Dy
CONFIG_IP_VS_PROTO_AH_ESP=3Dy
CONFIG_IP_VS_PROTO_ESP=3Dy
CONFIG_IP_VS_PROTO_AH=3Dy
CONFIG_IP_VS_PROTO_SCTP=3Dy

#
# IPVS scheduler
#
CONFIG_IP_VS_RR=3Dm
CONFIG_IP_VS_WRR=3Dm
CONFIG_IP_VS_LC=3Dm
CONFIG_IP_VS_WLC=3Dm
# CONFIG_IP_VS_FO is not set
# CONFIG_IP_VS_OVF is not set
CONFIG_IP_VS_LBLC=3Dm
CONFIG_IP_VS_LBLCR=3Dm
CONFIG_IP_VS_DH=3Dm
CONFIG_IP_VS_SH=3Dm
# CONFIG_IP_VS_MH is not set
CONFIG_IP_VS_SED=3Dm
CONFIG_IP_VS_NQ=3Dm

#
# IPVS SH scheduler
#
CONFIG_IP_VS_SH_TAB_BITS=3D8

#
# IPVS MH scheduler
#
CONFIG_IP_VS_MH_TAB_INDEX=3D12

#
# IPVS application helper
#
CONFIG_IP_VS_FTP=3Dm
CONFIG_IP_VS_NFCT=3Dy
CONFIG_IP_VS_PE_SIP=3Dm

#
# IP: Netfilter Configuration
#
CONFIG_NF_DEFRAG_IPV4=3Dm
CONFIG_NF_SOCKET_IPV4=3Dm
CONFIG_NF_TPROXY_IPV4=3Dm
CONFIG_NF_TABLES_IPV4=3Dy
CONFIG_NFT_REJECT_IPV4=3Dm
# CONFIG_NFT_DUP_IPV4 is not set
# CONFIG_NFT_FIB_IPV4 is not set
# CONFIG_NF_TABLES_ARP is not set
CONFIG_NF_FLOW_TABLE_IPV4=3Dm
CONFIG_NF_DUP_IPV4=3Dm
# CONFIG_NF_LOG_ARP is not set
CONFIG_NF_LOG_IPV4=3Dm
CONFIG_NF_REJECT_IPV4=3Dm
CONFIG_NF_NAT_SNMP_BASIC=3Dm
CONFIG_NF_NAT_PPTP=3Dm
CONFIG_NF_NAT_H323=3Dm
CONFIG_IP_NF_IPTABLES=3Dm
CONFIG_IP_NF_MATCH_AH=3Dm
CONFIG_IP_NF_MATCH_ECN=3Dm
CONFIG_IP_NF_MATCH_RPFILTER=3Dm
CONFIG_IP_NF_MATCH_TTL=3Dm
CONFIG_IP_NF_FILTER=3Dm
CONFIG_IP_NF_TARGET_REJECT=3Dm
CONFIG_IP_NF_TARGET_SYNPROXY=3Dm
CONFIG_IP_NF_NAT=3Dm
CONFIG_IP_NF_TARGET_MASQUERADE=3Dm
CONFIG_IP_NF_TARGET_NETMAP=3Dm
CONFIG_IP_NF_TARGET_REDIRECT=3Dm
CONFIG_IP_NF_MANGLE=3Dm
CONFIG_IP_NF_TARGET_CLUSTERIP=3Dm
CONFIG_IP_NF_TARGET_ECN=3Dm
CONFIG_IP_NF_TARGET_TTL=3Dm
CONFIG_IP_NF_RAW=3Dm
CONFIG_IP_NF_SECURITY=3Dm
CONFIG_IP_NF_ARPTABLES=3Dm
CONFIG_IP_NF_ARPFILTER=3Dm
CONFIG_IP_NF_ARP_MANGLE=3Dm
# end of IP: Netfilter Configuration

#
# IPv6: Netfilter Configuration
#
CONFIG_NF_SOCKET_IPV6=3Dm
CONFIG_NF_TPROXY_IPV6=3Dm
CONFIG_NF_TABLES_IPV6=3Dy
CONFIG_NFT_REJECT_IPV6=3Dm
# CONFIG_NFT_DUP_IPV6 is not set
# CONFIG_NFT_FIB_IPV6 is not set
CONFIG_NF_FLOW_TABLE_IPV6=3Dm
CONFIG_NF_DUP_IPV6=3Dm
CONFIG_NF_REJECT_IPV6=3Dm
CONFIG_NF_LOG_IPV6=3Dm
CONFIG_IP6_NF_IPTABLES=3Dm
CONFIG_IP6_NF_MATCH_AH=3Dm
CONFIG_IP6_NF_MATCH_EUI64=3Dm
CONFIG_IP6_NF_MATCH_FRAG=3Dm
CONFIG_IP6_NF_MATCH_OPTS=3Dm
CONFIG_IP6_NF_MATCH_HL=3Dm
CONFIG_IP6_NF_MATCH_IPV6HEADER=3Dm
CONFIG_IP6_NF_MATCH_MH=3Dm
CONFIG_IP6_NF_MATCH_RPFILTER=3Dm
CONFIG_IP6_NF_MATCH_RT=3Dm
# CONFIG_IP6_NF_MATCH_SRH is not set
CONFIG_IP6_NF_TARGET_HL=3Dm
CONFIG_IP6_NF_FILTER=3Dm
CONFIG_IP6_NF_TARGET_REJECT=3Dm
CONFIG_IP6_NF_TARGET_SYNPROXY=3Dm
CONFIG_IP6_NF_MANGLE=3Dm
CONFIG_IP6_NF_RAW=3Dm
CONFIG_IP6_NF_SECURITY=3Dm
CONFIG_IP6_NF_NAT=3Dm
CONFIG_IP6_NF_TARGET_MASQUERADE=3Dm
CONFIG_IP6_NF_TARGET_NPT=3Dm
# end of IPv6: Netfilter Configuration

CONFIG_NF_DEFRAG_IPV6=3Dm
# CONFIG_NF_TABLES_BRIDGE is not set
# CONFIG_NF_CONNTRACK_BRIDGE is not set
CONFIG_BRIDGE_NF_EBTABLES=3Dm
CONFIG_BRIDGE_EBT_BROUTE=3Dm
CONFIG_BRIDGE_EBT_T_FILTER=3Dm
CONFIG_BRIDGE_EBT_T_NAT=3Dm
CONFIG_BRIDGE_EBT_802_3=3Dm
CONFIG_BRIDGE_EBT_AMONG=3Dm
CONFIG_BRIDGE_EBT_ARP=3Dm
CONFIG_BRIDGE_EBT_IP=3Dm
CONFIG_BRIDGE_EBT_IP6=3Dm
CONFIG_BRIDGE_EBT_LIMIT=3Dm
CONFIG_BRIDGE_EBT_MARK=3Dm
CONFIG_BRIDGE_EBT_PKTTYPE=3Dm
CONFIG_BRIDGE_EBT_STP=3Dm
CONFIG_BRIDGE_EBT_VLAN=3Dm
CONFIG_BRIDGE_EBT_ARPREPLY=3Dm
CONFIG_BRIDGE_EBT_DNAT=3Dm
CONFIG_BRIDGE_EBT_MARK_T=3Dm
CONFIG_BRIDGE_EBT_REDIRECT=3Dm
CONFIG_BRIDGE_EBT_SNAT=3Dm
CONFIG_BRIDGE_EBT_LOG=3Dm
CONFIG_BRIDGE_EBT_NFLOG=3Dm
# CONFIG_BPFILTER is not set
CONFIG_IP_DCCP=3Dm
CONFIG_INET_DCCP_DIAG=3Dm

#
# DCCP CCIDs Configuration
#
# CONFIG_IP_DCCP_CCID2_DEBUG is not set
CONFIG_IP_DCCP_CCID3=3Dy
# CONFIG_IP_DCCP_CCID3_DEBUG is not set
CONFIG_IP_DCCP_TFRC_LIB=3Dy
# end of DCCP CCIDs Configuration

#
# DCCP Kernel Hacking
#
# CONFIG_IP_DCCP_DEBUG is not set
# end of DCCP Kernel Hacking

CONFIG_IP_SCTP=3Dm
# CONFIG_SCTP_DBG_OBJCNT is not set
# CONFIG_SCTP_DEFAULT_COOKIE_HMAC_MD5 is not set
CONFIG_SCTP_DEFAULT_COOKIE_HMAC_SHA1=3Dy
# CONFIG_SCTP_DEFAULT_COOKIE_HMAC_NONE is not set
CONFIG_SCTP_COOKIE_HMAC_MD5=3Dy
CONFIG_SCTP_COOKIE_HMAC_SHA1=3Dy
CONFIG_INET_SCTP_DIAG=3Dm
# CONFIG_RDS is not set
# CONFIG_TIPC is not set
CONFIG_ATM=3Dm
CONFIG_ATM_CLIP=3Dm
# CONFIG_ATM_CLIP_NO_ICMP is not set
CONFIG_ATM_LANE=3Dm
# CONFIG_ATM_MPOA is not set
CONFIG_ATM_BR2684=3Dm
# CONFIG_ATM_BR2684_IPFILTER is not set
CONFIG_L2TP=3Dm
CONFIG_L2TP_DEBUGFS=3Dm
CONFIG_L2TP_V3=3Dy
CONFIG_L2TP_IP=3Dm
CONFIG_L2TP_ETH=3Dm
CONFIG_STP=3Dm
CONFIG_GARP=3Dm
CONFIG_MRP=3Dm
CONFIG_BRIDGE=3Dm
CONFIG_BRIDGE_IGMP_SNOOPING=3Dy
CONFIG_BRIDGE_VLAN_FILTERING=3Dy
CONFIG_HAVE_NET_DSA=3Dy
# CONFIG_NET_DSA is not set
CONFIG_VLAN_8021Q=3Dm
CONFIG_VLAN_8021Q_GVRP=3Dy
CONFIG_VLAN_8021Q_MVRP=3Dy
# CONFIG_DECNET is not set
CONFIG_LLC=3Dm
# CONFIG_LLC2 is not set
# CONFIG_ATALK is not set
# CONFIG_X25 is not set
# CONFIG_LAPB is not set
# CONFIG_PHONET is not set
CONFIG_6LOWPAN=3Dm
# CONFIG_6LOWPAN_DEBUGFS is not set
CONFIG_6LOWPAN_NHC=3Dm
CONFIG_6LOWPAN_NHC_DEST=3Dm
CONFIG_6LOWPAN_NHC_FRAGMENT=3Dm
CONFIG_6LOWPAN_NHC_HOP=3Dm
CONFIG_6LOWPAN_NHC_IPV6=3Dm
CONFIG_6LOWPAN_NHC_MOBILITY=3Dm
CONFIG_6LOWPAN_NHC_ROUTING=3Dm
CONFIG_6LOWPAN_NHC_UDP=3Dm
# CONFIG_6LOWPAN_GHC_EXT_HDR_HOP is not set
# CONFIG_6LOWPAN_GHC_UDP is not set
# CONFIG_6LOWPAN_GHC_ICMPV6 is not set
# CONFIG_6LOWPAN_GHC_EXT_HDR_DEST is not set
# CONFIG_6LOWPAN_GHC_EXT_HDR_FRAG is not set
# CONFIG_6LOWPAN_GHC_EXT_HDR_ROUTE is not set
CONFIG_IEEE802154=3Dm
# CONFIG_IEEE802154_NL802154_EXPERIMENTAL is not set
CONFIG_IEEE802154_SOCKET=3Dm
CONFIG_IEEE802154_6LOWPAN=3Dm
CONFIG_MAC802154=3Dm
CONFIG_NET_SCHED=3Dy

#
# Queueing/Scheduling
#
CONFIG_NET_SCH_CBQ=3Dm
CONFIG_NET_SCH_HTB=3Dm
CONFIG_NET_SCH_HFSC=3Dm
CONFIG_NET_SCH_ATM=3Dm
CONFIG_NET_SCH_PRIO=3Dm
CONFIG_NET_SCH_MULTIQ=3Dm
CONFIG_NET_SCH_RED=3Dm
CONFIG_NET_SCH_SFB=3Dm
CONFIG_NET_SCH_SFQ=3Dm
CONFIG_NET_SCH_TEQL=3Dm
CONFIG_NET_SCH_TBF=3Dm
# CONFIG_NET_SCH_CBS is not set
# CONFIG_NET_SCH_ETF is not set
# CONFIG_NET_SCH_TAPRIO is not set
CONFIG_NET_SCH_GRED=3Dm
CONFIG_NET_SCH_DSMARK=3Dm
CONFIG_NET_SCH_NETEM=3Dm
CONFIG_NET_SCH_DRR=3Dm
CONFIG_NET_SCH_MQPRIO=3Dm
# CONFIG_NET_SCH_SKBPRIO is not set
CONFIG_NET_SCH_CHOKE=3Dm
CONFIG_NET_SCH_QFQ=3Dm
CONFIG_NET_SCH_CODEL=3Dm
CONFIG_NET_SCH_FQ_CODEL=3Dm
# CONFIG_NET_SCH_CAKE is not set
CONFIG_NET_SCH_FQ=3Dm
# CONFIG_NET_SCH_HHF is not set
# CONFIG_NET_SCH_PIE is not set
CONFIG_NET_SCH_INGRESS=3Dm
CONFIG_NET_SCH_PLUG=3Dm
# CONFIG_NET_SCH_DEFAULT is not set

#
# Classification
#
CONFIG_NET_CLS=3Dy
CONFIG_NET_CLS_BASIC=3Dm
CONFIG_NET_CLS_TCINDEX=3Dm
CONFIG_NET_CLS_ROUTE4=3Dm
CONFIG_NET_CLS_FW=3Dm
CONFIG_NET_CLS_U32=3Dm
CONFIG_CLS_U32_PERF=3Dy
CONFIG_CLS_U32_MARK=3Dy
CONFIG_NET_CLS_RSVP=3Dm
CONFIG_NET_CLS_RSVP6=3Dm
CONFIG_NET_CLS_FLOW=3Dm
CONFIG_NET_CLS_CGROUP=3Dy
CONFIG_NET_CLS_BPF=3Dm
CONFIG_NET_CLS_FLOWER=3Dm
CONFIG_NET_CLS_MATCHALL=3Dm
CONFIG_NET_EMATCH=3Dy
CONFIG_NET_EMATCH_STACK=3D32
CONFIG_NET_EMATCH_CMP=3Dm
CONFIG_NET_EMATCH_NBYTE=3Dm
CONFIG_NET_EMATCH_U32=3Dm
CONFIG_NET_EMATCH_META=3Dm
CONFIG_NET_EMATCH_TEXT=3Dm
# CONFIG_NET_EMATCH_CANID is not set
CONFIG_NET_EMATCH_IPSET=3Dm
# CONFIG_NET_EMATCH_IPT is not set
CONFIG_NET_CLS_ACT=3Dy
CONFIG_NET_ACT_POLICE=3Dm
CONFIG_NET_ACT_GACT=3Dm
CONFIG_GACT_PROB=3Dy
CONFIG_NET_ACT_MIRRED=3Dm
CONFIG_NET_ACT_SAMPLE=3Dm
CONFIG_NET_ACT_IPT=3Dm
CONFIG_NET_ACT_NAT=3Dm
CONFIG_NET_ACT_PEDIT=3Dm
CONFIG_NET_ACT_SIMP=3Dm
CONFIG_NET_ACT_SKBEDIT=3Dm
CONFIG_NET_ACT_CSUM=3Dm
# CONFIG_NET_ACT_MPLS is not set
CONFIG_NET_ACT_VLAN=3Dm
# CONFIG_NET_ACT_BPF is not set
CONFIG_NET_ACT_CONNMARK=3Dm
# CONFIG_NET_ACT_CTINFO is not set
CONFIG_NET_ACT_SKBMOD=3Dm
# CONFIG_NET_ACT_IFE is not set
CONFIG_NET_ACT_TUNNEL_KEY=3Dm
# CONFIG_NET_ACT_CT is not set
# CONFIG_NET_TC_SKB_EXT is not set
CONFIG_NET_SCH_FIFO=3Dy
CONFIG_DCB=3Dy
CONFIG_DNS_RESOLVER=3Dm
# CONFIG_BATMAN_ADV is not set
CONFIG_OPENVSWITCH=3Dm
CONFIG_OPENVSWITCH_GRE=3Dm
CONFIG_OPENVSWITCH_VXLAN=3Dm
CONFIG_OPENVSWITCH_GENEVE=3Dm
CONFIG_VSOCKETS=3Dm
CONFIG_VSOCKETS_DIAG=3Dm
CONFIG_VMWARE_VMCI_VSOCKETS=3Dm
CONFIG_VIRTIO_VSOCKETS=3Dm
CONFIG_VIRTIO_VSOCKETS_COMMON=3Dm
CONFIG_HYPERV_VSOCKETS=3Dm
CONFIG_NETLINK_DIAG=3Dm
CONFIG_MPLS=3Dy
CONFIG_NET_MPLS_GSO=3Dy
CONFIG_MPLS_ROUTING=3Dm
CONFIG_MPLS_IPTUNNEL=3Dm
CONFIG_NET_NSH=3Dm
# CONFIG_HSR is not set
CONFIG_NET_SWITCHDEV=3Dy
CONFIG_NET_L3_MASTER_DEV=3Dy
# CONFIG_NET_NCSI is not set
CONFIG_RPS=3Dy
CONFIG_RFS_ACCEL=3Dy
CONFIG_XPS=3Dy
# CONFIG_CGROUP_NET_PRIO is not set
CONFIG_CGROUP_NET_CLASSID=3Dy
CONFIG_NET_RX_BUSY_POLL=3Dy
CONFIG_BQL=3Dy
CONFIG_BPF_JIT=3Dy
CONFIG_BPF_STREAM_PARSER=3Dy
CONFIG_NET_FLOW_LIMIT=3Dy

#
# Network testing
#
CONFIG_NET_PKTGEN=3Dm
CONFIG_NET_DROP_MONITOR=3Dy
# end of Network testing
# end of Networking options

# CONFIG_HAMRADIO is not set
CONFIG_CAN=3Dm
CONFIG_CAN_RAW=3Dm
CONFIG_CAN_BCM=3Dm
CONFIG_CAN_GW=3Dm
# CONFIG_CAN_J1939 is not set

#
# CAN Device Drivers
#
CONFIG_CAN_VCAN=3Dm
# CONFIG_CAN_VXCAN is not set
CONFIG_CAN_SLCAN=3Dm
CONFIG_CAN_DEV=3Dm
CONFIG_CAN_CALC_BITTIMING=3Dy
# CONFIG_CAN_KVASER_PCIEFD is not set
CONFIG_CAN_C_CAN=3Dm
CONFIG_CAN_C_CAN_PLATFORM=3Dm
CONFIG_CAN_C_CAN_PCI=3Dm
CONFIG_CAN_CC770=3Dm
# CONFIG_CAN_CC770_ISA is not set
CONFIG_CAN_CC770_PLATFORM=3Dm
# CONFIG_CAN_IFI_CANFD is not set
# CONFIG_CAN_M_CAN is not set
# CONFIG_CAN_PEAK_PCIEFD is not set
CONFIG_CAN_SJA1000=3Dm
CONFIG_CAN_EMS_PCI=3Dm
# CONFIG_CAN_F81601 is not set
CONFIG_CAN_KVASER_PCI=3Dm
CONFIG_CAN_PEAK_PCI=3Dm
CONFIG_CAN_PEAK_PCIEC=3Dy
CONFIG_CAN_PLX_PCI=3Dm
# CONFIG_CAN_SJA1000_ISA is not set
CONFIG_CAN_SJA1000_PLATFORM=3Dm
CONFIG_CAN_SOFTING=3Dm

#
# CAN SPI interfaces
#
# CONFIG_CAN_HI311X is not set
# CONFIG_CAN_MCP251X is not set
# end of CAN SPI interfaces

#
# CAN USB interfaces
#
CONFIG_CAN_8DEV_USB=3Dm
CONFIG_CAN_EMS_USB=3Dm
CONFIG_CAN_ESD_USB2=3Dm
# CONFIG_CAN_GS_USB is not set
CONFIG_CAN_KVASER_USB=3Dm
# CONFIG_CAN_MCBA_USB is not set
CONFIG_CAN_PEAK_USB=3Dm
# CONFIG_CAN_UCAN is not set
# end of CAN USB interfaces

# CONFIG_CAN_DEBUG_DEVICES is not set
# end of CAN Device Drivers

CONFIG_BT=3Dm
CONFIG_BT_BREDR=3Dy
CONFIG_BT_RFCOMM=3Dm
CONFIG_BT_RFCOMM_TTY=3Dy
CONFIG_BT_BNEP=3Dm
CONFIG_BT_BNEP_MC_FILTER=3Dy
CONFIG_BT_BNEP_PROTO_FILTER=3Dy
CONFIG_BT_CMTP=3Dm
CONFIG_BT_HIDP=3Dm
CONFIG_BT_HS=3Dy
CONFIG_BT_LE=3Dy
# CONFIG_BT_6LOWPAN is not set
# CONFIG_BT_LEDS is not set
# CONFIG_BT_SELFTEST is not set
CONFIG_BT_DEBUGFS=3Dy

#
# Bluetooth device drivers
#
CONFIG_BT_INTEL=3Dm
CONFIG_BT_BCM=3Dm
CONFIG_BT_RTL=3Dm
CONFIG_BT_HCIBTUSB=3Dm
# CONFIG_BT_HCIBTUSB_AUTOSUSPEND is not set
CONFIG_BT_HCIBTUSB_BCM=3Dy
# CONFIG_BT_HCIBTUSB_MTK is not set
CONFIG_BT_HCIBTUSB_RTL=3Dy
CONFIG_BT_HCIBTSDIO=3Dm
CONFIG_BT_HCIUART=3Dm
CONFIG_BT_HCIUART_H4=3Dy
CONFIG_BT_HCIUART_BCSP=3Dy
CONFIG_BT_HCIUART_ATH3K=3Dy
# CONFIG_BT_HCIUART_INTEL is not set
# CONFIG_BT_HCIUART_AG6XX is not set
CONFIG_BT_HCIBCM203X=3Dm
CONFIG_BT_HCIBPA10X=3Dm
CONFIG_BT_HCIBFUSB=3Dm
CONFIG_BT_HCIVHCI=3Dm
CONFIG_BT_MRVL=3Dm
CONFIG_BT_MRVL_SDIO=3Dm
CONFIG_BT_ATH3K=3Dm
# CONFIG_BT_MTKSDIO is not set
# end of Bluetooth device drivers

# CONFIG_AF_RXRPC is not set
# CONFIG_AF_KCM is not set
CONFIG_STREAM_PARSER=3Dy
CONFIG_FIB_RULES=3Dy
CONFIG_WIRELESS=3Dy
CONFIG_WIRELESS_EXT=3Dy
CONFIG_WEXT_CORE=3Dy
CONFIG_WEXT_PROC=3Dy
CONFIG_WEXT_PRIV=3Dy
CONFIG_CFG80211=3Dm
# CONFIG_NL80211_TESTMODE is not set
# CONFIG_CFG80211_DEVELOPER_WARNINGS is not set
# CONFIG_CFG80211_CERTIFICATION_ONUS is not set
CONFIG_CFG80211_REQUIRE_SIGNED_REGDB=3Dy
CONFIG_CFG80211_USE_KERNEL_REGDB_KEYS=3Dy
CONFIG_CFG80211_DEFAULT_PS=3Dy
# CONFIG_CFG80211_DEBUGFS is not set
CONFIG_CFG80211_CRDA_SUPPORT=3Dy
CONFIG_CFG80211_WEXT=3Dy
CONFIG_LIB80211=3Dm
# CONFIG_LIB80211_DEBUG is not set
CONFIG_MAC80211=3Dm
CONFIG_MAC80211_HAS_RC=3Dy
CONFIG_MAC80211_RC_MINSTREL=3Dy
CONFIG_MAC80211_RC_DEFAULT_MINSTREL=3Dy
CONFIG_MAC80211_RC_DEFAULT=3D"minstrel_ht"
# CONFIG_MAC80211_MESH is not set
CONFIG_MAC80211_LEDS=3Dy
CONFIG_MAC80211_DEBUGFS=3Dy
# CONFIG_MAC80211_MESSAGE_TRACING is not set
# CONFIG_MAC80211_DEBUG_MENU is not set
CONFIG_MAC80211_STA_HASH_MAX_SIZE=3D0
# CONFIG_WIMAX is not set
CONFIG_RFKILL=3Dm
CONFIG_RFKILL_LEDS=3Dy
CONFIG_RFKILL_INPUT=3Dy
# CONFIG_RFKILL_GPIO is not set
CONFIG_NET_9P=3Dy
CONFIG_NET_9P_VIRTIO=3Dy
# CONFIG_NET_9P_XEN is not set
# CONFIG_NET_9P_DEBUG is not set
# CONFIG_CAIF is not set
CONFIG_CEPH_LIB=3Dm
# CONFIG_CEPH_LIB_PRETTYDEBUG is not set
CONFIG_CEPH_LIB_USE_DNS_RESOLVER=3Dy
# CONFIG_NFC is not set
CONFIG_PSAMPLE=3Dm
# CONFIG_NET_IFE is not set
CONFIG_LWTUNNEL=3Dy
CONFIG_LWTUNNEL_BPF=3Dy
CONFIG_DST_CACHE=3Dy
CONFIG_GRO_CELLS=3Dy
CONFIG_NET_SOCK_MSG=3Dy
CONFIG_NET_DEVLINK=3Dy
CONFIG_PAGE_POOL=3Dy
CONFIG_FAILOVER=3Dm
CONFIG_HAVE_EBPF_JIT=3Dy

#
# Device Drivers
#
CONFIG_HAVE_EISA=3Dy
# CONFIG_EISA is not set
CONFIG_HAVE_PCI=3Dy
CONFIG_PCI=3Dy
CONFIG_PCI_DOMAINS=3Dy
CONFIG_PCIEPORTBUS=3Dy
CONFIG_HOTPLUG_PCI_PCIE=3Dy
CONFIG_PCIEAER=3Dy
CONFIG_PCIEAER_INJECT=3Dm
CONFIG_PCIE_ECRC=3Dy
CONFIG_PCIEASPM=3Dy
# CONFIG_PCIEASPM_DEBUG is not set
CONFIG_PCIEASPM_DEFAULT=3Dy
# CONFIG_PCIEASPM_POWERSAVE is not set
# CONFIG_PCIEASPM_POWER_SUPERSAVE is not set
# CONFIG_PCIEASPM_PERFORMANCE is not set
CONFIG_PCIE_PME=3Dy
# CONFIG_PCIE_DPC is not set
# CONFIG_PCIE_PTM is not set
# CONFIG_PCIE_BW is not set
CONFIG_PCI_MSI=3Dy
CONFIG_PCI_MSI_IRQ_DOMAIN=3Dy
CONFIG_PCI_QUIRKS=3Dy
# CONFIG_PCI_DEBUG is not set
# CONFIG_PCI_REALLOC_ENABLE_AUTO is not set
CONFIG_PCI_STUB=3Dy
# CONFIG_PCI_PF_STUB is not set
# CONFIG_XEN_PCIDEV_FRONTEND is not set
CONFIG_PCI_ATS=3Dy
CONFIG_PCI_LOCKLESS_CONFIG=3Dy
CONFIG_PCI_IOV=3Dy
CONFIG_PCI_PRI=3Dy
CONFIG_PCI_PASID=3Dy
# CONFIG_PCI_P2PDMA is not set
CONFIG_PCI_LABEL=3Dy
CONFIG_PCI_HYPERV=3Dm
CONFIG_HOTPLUG_PCI=3Dy
CONFIG_HOTPLUG_PCI_ACPI=3Dy
CONFIG_HOTPLUG_PCI_ACPI_IBM=3Dm
# CONFIG_HOTPLUG_PCI_CPCI is not set
CONFIG_HOTPLUG_PCI_SHPC=3Dy

#
# PCI controller drivers
#

#
# Cadence PCIe controllers support
#
# end of Cadence PCIe controllers support

CONFIG_VMD=3Dy
CONFIG_PCI_HYPERV_INTERFACE=3Dm

#
# DesignWare PCI Core Support
#
# CONFIG_PCIE_DW_PLAT_HOST is not set
# CONFIG_PCI_MESON is not set
# end of DesignWare PCI Core Support
# end of PCI controller drivers

#
# PCI Endpoint
#
# CONFIG_PCI_ENDPOINT is not set
# end of PCI Endpoint

#
# PCI switch controller drivers
#
# CONFIG_PCI_SW_SWITCHTEC is not set
# end of PCI switch controller drivers

CONFIG_PCCARD=3Dy
# CONFIG_PCMCIA is not set
CONFIG_CARDBUS=3Dy

#
# PC-card bridges
#
CONFIG_YENTA=3Dm
CONFIG_YENTA_O2=3Dy
CONFIG_YENTA_RICOH=3Dy
CONFIG_YENTA_TI=3Dy
CONFIG_YENTA_ENE_TUNE=3Dy
CONFIG_YENTA_TOSHIBA=3Dy
# CONFIG_RAPIDIO is not set

#
# Generic Driver Options
#
CONFIG_UEVENT_HELPER=3Dy
CONFIG_UEVENT_HELPER_PATH=3D""
CONFIG_DEVTMPFS=3Dy
CONFIG_DEVTMPFS_MOUNT=3Dy
CONFIG_STANDALONE=3Dy
CONFIG_PREVENT_FIRMWARE_BUILD=3Dy

#
# Firmware loader
#
CONFIG_FW_LOADER=3Dy
CONFIG_FW_LOADER_PAGED_BUF=3Dy
CONFIG_EXTRA_FIRMWARE=3D""
CONFIG_FW_LOADER_USER_HELPER=3Dy
# CONFIG_FW_LOADER_USER_HELPER_FALLBACK is not set
# CONFIG_FW_LOADER_COMPRESS is not set
# end of Firmware loader

CONFIG_WANT_DEV_COREDUMP=3Dy
CONFIG_ALLOW_DEV_COREDUMP=3Dy
CONFIG_DEV_COREDUMP=3Dy
# CONFIG_DEBUG_DRIVER is not set
# CONFIG_DEBUG_DEVRES is not set
# CONFIG_DEBUG_TEST_DRIVER_REMOVE is not set
# CONFIG_TEST_ASYNC_DRIVER_PROBE is not set
CONFIG_SYS_HYPERVISOR=3Dy
CONFIG_GENERIC_CPU_AUTOPROBE=3Dy
CONFIG_GENERIC_CPU_VULNERABILITIES=3Dy
CONFIG_REGMAP=3Dy
CONFIG_REGMAP_I2C=3Dy
CONFIG_REGMAP_SPI=3Dy
CONFIG_REGMAP_IRQ=3Dy
CONFIG_DMA_SHARED_BUFFER=3Dy
# CONFIG_DMA_FENCE_TRACE is not set
# end of Generic Driver Options

#
# Bus devices
#
# end of Bus devices

CONFIG_CONNECTOR=3Dy
CONFIG_PROC_EVENTS=3Dy
# CONFIG_GNSS is not set
CONFIG_MTD=3Dm
# CONFIG_MTD_TESTS is not set

#
# Partition parsers
#
# CONFIG_MTD_AR7_PARTS is not set
# CONFIG_MTD_CMDLINE_PARTS is not set
# CONFIG_MTD_REDBOOT_PARTS is not set
# end of Partition parsers

#
# User Modules And Translation Layers
#
CONFIG_MTD_BLKDEVS=3Dm
CONFIG_MTD_BLOCK=3Dm
# CONFIG_MTD_BLOCK_RO is not set
# CONFIG_FTL is not set
# CONFIG_NFTL is not set
# CONFIG_INFTL is not set
# CONFIG_RFD_FTL is not set
# CONFIG_SSFDC is not set
# CONFIG_SM_FTL is not set
# CONFIG_MTD_OOPS is not set
# CONFIG_MTD_SWAP is not set
# CONFIG_MTD_PARTITIONED_MASTER is not set

#
# RAM/ROM/Flash chip drivers
#
# CONFIG_MTD_CFI is not set
# CONFIG_MTD_JEDECPROBE is not set
CONFIG_MTD_MAP_BANK_WIDTH_1=3Dy
CONFIG_MTD_MAP_BANK_WIDTH_2=3Dy
CONFIG_MTD_MAP_BANK_WIDTH_4=3Dy
CONFIG_MTD_CFI_I1=3Dy
CONFIG_MTD_CFI_I2=3Dy
# CONFIG_MTD_RAM is not set
# CONFIG_MTD_ROM is not set
# CONFIG_MTD_ABSENT is not set
# end of RAM/ROM/Flash chip drivers

#
# Mapping drivers for chip access
#
# CONFIG_MTD_COMPLEX_MAPPINGS is not set
# CONFIG_MTD_INTEL_VR_NOR is not set
# CONFIG_MTD_PLATRAM is not set
# end of Mapping drivers for chip access

#
# Self-contained MTD device drivers
#
# CONFIG_MTD_PMC551 is not set
# CONFIG_MTD_DATAFLASH is not set
# CONFIG_MTD_MCHP23K256 is not set
# CONFIG_MTD_SST25L is not set
# CONFIG_MTD_SLRAM is not set
# CONFIG_MTD_PHRAM is not set
# CONFIG_MTD_MTDRAM is not set
# CONFIG_MTD_BLOCK2MTD is not set

#
# Disk-On-Chip Device Drivers
#
# CONFIG_MTD_DOCG3 is not set
# end of Self-contained MTD device drivers

# CONFIG_MTD_ONENAND is not set
# CONFIG_MTD_RAW_NAND is not set
# CONFIG_MTD_SPI_NAND is not set

#
# LPDDR & LPDDR2 PCM memory drivers
#
# CONFIG_MTD_LPDDR is not set
# end of LPDDR & LPDDR2 PCM memory drivers

# CONFIG_MTD_SPI_NOR is not set
CONFIG_MTD_UBI=3Dm
CONFIG_MTD_UBI_WL_THRESHOLD=3D4096
CONFIG_MTD_UBI_BEB_LIMIT=3D20
# CONFIG_MTD_UBI_FASTMAP is not set
# CONFIG_MTD_UBI_GLUEBI is not set
# CONFIG_MTD_UBI_BLOCK is not set
# CONFIG_MTD_HYPERBUS is not set
# CONFIG_OF is not set
CONFIG_ARCH_MIGHT_HAVE_PC_PARPORT=3Dy
CONFIG_PARPORT=3Dm
CONFIG_PARPORT_PC=3Dm
CONFIG_PARPORT_SERIAL=3Dm
# CONFIG_PARPORT_PC_FIFO is not set
# CONFIG_PARPORT_PC_SUPERIO is not set
# CONFIG_PARPORT_AX88796 is not set
CONFIG_PARPORT_1284=3Dy
CONFIG_PARPORT_NOT_PC=3Dy
CONFIG_PNP=3Dy
# CONFIG_PNP_DEBUG_MESSAGES is not set

#
# Protocols
#
CONFIG_PNPACPI=3Dy
CONFIG_BLK_DEV=3Dy
CONFIG_BLK_DEV_NULL_BLK=3Dm
CONFIG_BLK_DEV_FD=3Dm
CONFIG_CDROM=3Dm
# CONFIG_PARIDE is not set
CONFIG_BLK_DEV_PCIESSD_MTIP32XX=3Dm
# CONFIG_ZRAM is not set
# CONFIG_BLK_DEV_UMEM is not set
CONFIG_BLK_DEV_LOOP=3Dm
CONFIG_BLK_DEV_LOOP_MIN_COUNT=3D0
# CONFIG_BLK_DEV_CRYPTOLOOP is not set
# CONFIG_BLK_DEV_DRBD is not set
# CONFIG_BLK_DEV_NBD is not set
# CONFIG_BLK_DEV_SKD is not set
CONFIG_BLK_DEV_SX8=3Dm
CONFIG_BLK_DEV_RAM=3Dm
CONFIG_BLK_DEV_RAM_COUNT=3D16
CONFIG_BLK_DEV_RAM_SIZE=3D16384
CONFIG_CDROM_PKTCDVD=3Dm
CONFIG_CDROM_PKTCDVD_BUFFERS=3D8
# CONFIG_CDROM_PKTCDVD_WCACHE is not set
CONFIG_ATA_OVER_ETH=3Dm
CONFIG_XEN_BLKDEV_FRONTEND=3Dm
CONFIG_VIRTIO_BLK=3Dy
# CONFIG_VIRTIO_BLK_SCSI is not set
CONFIG_BLK_DEV_RBD=3Dm
# CONFIG_BLK_DEV_RSXX is not set

#
# NVME Support
#
CONFIG_NVME_CORE=3Dm
CONFIG_BLK_DEV_NVME=3Dm
# CONFIG_NVME_MULTIPATH is not set
CONFIG_NVME_FABRICS=3Dm
CONFIG_NVME_FC=3Dm
# CONFIG_NVME_TCP is not set
CONFIG_NVME_TARGET=3Dm
CONFIG_NVME_TARGET_LOOP=3Dm
CONFIG_NVME_TARGET_FC=3Dm
CONFIG_NVME_TARGET_FCLOOP=3Dm
# CONFIG_NVME_TARGET_TCP is not set
# end of NVME Support

#
# Misc devices
#
CONFIG_SENSORS_LIS3LV02D=3Dm
# CONFIG_AD525X_DPOT is not set
# CONFIG_DUMMY_IRQ is not set
# CONFIG_IBM_ASM is not set
# CONFIG_PHANTOM is not set
CONFIG_TIFM_CORE=3Dm
CONFIG_TIFM_7XX1=3Dm
# CONFIG_ICS932S401 is not set
CONFIG_ENCLOSURE_SERVICES=3Dm
CONFIG_SGI_XP=3Dm
CONFIG_HP_ILO=3Dm
CONFIG_SGI_GRU=3Dm
# CONFIG_SGI_GRU_DEBUG is not set
CONFIG_APDS9802ALS=3Dm
CONFIG_ISL29003=3Dm
CONFIG_ISL29020=3Dm
CONFIG_SENSORS_TSL2550=3Dm
CONFIG_SENSORS_BH1770=3Dm
CONFIG_SENSORS_APDS990X=3Dm
# CONFIG_HMC6352 is not set
# CONFIG_DS1682 is not set
CONFIG_VMWARE_BALLOON=3Dm
# CONFIG_LATTICE_ECP3_CONFIG is not set
# CONFIG_SRAM is not set
# CONFIG_PCI_ENDPOINT_TEST is not set
# CONFIG_XILINX_SDFEC is not set
CONFIG_PVPANIC=3Dy
# CONFIG_C2PORT is not set

#
# EEPROM support
#
CONFIG_EEPROM_AT24=3Dm
# CONFIG_EEPROM_AT25 is not set
CONFIG_EEPROM_LEGACY=3Dm
CONFIG_EEPROM_MAX6875=3Dm
CONFIG_EEPROM_93CX6=3Dm
# CONFIG_EEPROM_93XX46 is not set
# CONFIG_EEPROM_IDT_89HPESX is not set
# CONFIG_EEPROM_EE1004 is not set
# end of EEPROM support

CONFIG_CB710_CORE=3Dm
# CONFIG_CB710_DEBUG is not set
CONFIG_CB710_DEBUG_ASSUMPTIONS=3Dy

#
# Texas Instruments shared transport line discipline
#
# CONFIG_TI_ST is not set
# end of Texas Instruments shared transport line discipline

CONFIG_SENSORS_LIS3_I2C=3Dm
CONFIG_ALTERA_STAPL=3Dm
CONFIG_INTEL_MEI=3Dm
CONFIG_INTEL_MEI_ME=3Dm
# CONFIG_INTEL_MEI_TXE is not set
# CONFIG_INTEL_MEI_HDCP is not set
CONFIG_VMWARE_VMCI=3Dm

#
# Intel MIC & related support
#

#
# Intel MIC Bus Driver
#
# CONFIG_INTEL_MIC_BUS is not set

#
# SCIF Bus Driver
#
# CONFIG_SCIF_BUS is not set

#
# VOP Bus Driver
#
# CONFIG_VOP_BUS is not set

#
# Intel MIC Host Driver
#

#
# Intel MIC Card Driver
#

#
# SCIF Driver
#

#
# Intel MIC Coprocessor State Management (COSM) Drivers
#

#
# VOP Driver
#
# end of Intel MIC & related support

# CONFIG_GENWQE is not set
# CONFIG_ECHO is not set
# CONFIG_MISC_ALCOR_PCI is not set
# CONFIG_MISC_RTSX_PCI is not set
# CONFIG_MISC_RTSX_USB is not set
# CONFIG_HABANA_AI is not set
# end of Misc devices

CONFIG_HAVE_IDE=3Dy
# CONFIG_IDE is not set

#
# SCSI device support
#
CONFIG_SCSI_MOD=3Dy
CONFIG_RAID_ATTRS=3Dm
CONFIG_SCSI=3Dy
CONFIG_SCSI_DMA=3Dy
CONFIG_SCSI_NETLINK=3Dy
CONFIG_SCSI_PROC_FS=3Dy

#
# SCSI support type (disk, tape, CD-ROM)
#
CONFIG_BLK_DEV_SD=3Dm
CONFIG_CHR_DEV_ST=3Dm
CONFIG_BLK_DEV_SR=3Dm
CONFIG_BLK_DEV_SR_VENDOR=3Dy
CONFIG_CHR_DEV_SG=3Dm
CONFIG_CHR_DEV_SCH=3Dm
CONFIG_SCSI_ENCLOSURE=3Dm
CONFIG_SCSI_CONSTANTS=3Dy
CONFIG_SCSI_LOGGING=3Dy
CONFIG_SCSI_SCAN_ASYNC=3Dy

#
# SCSI Transports
#
CONFIG_SCSI_SPI_ATTRS=3Dm
CONFIG_SCSI_FC_ATTRS=3Dm
CONFIG_SCSI_ISCSI_ATTRS=3Dm
CONFIG_SCSI_SAS_ATTRS=3Dm
CONFIG_SCSI_SAS_LIBSAS=3Dm
CONFIG_SCSI_SAS_ATA=3Dy
CONFIG_SCSI_SAS_HOST_SMP=3Dy
CONFIG_SCSI_SRP_ATTRS=3Dm
# end of SCSI Transports

CONFIG_SCSI_LOWLEVEL=3Dy
CONFIG_ISCSI_TCP=3Dm
CONFIG_ISCSI_BOOT_SYSFS=3Dm
CONFIG_SCSI_CXGB3_ISCSI=3Dm
CONFIG_SCSI_CXGB4_ISCSI=3Dm
CONFIG_SCSI_BNX2_ISCSI=3Dm
CONFIG_SCSI_BNX2X_FCOE=3Dm
CONFIG_BE2ISCSI=3Dm
# CONFIG_BLK_DEV_3W_XXXX_RAID is not set
CONFIG_SCSI_HPSA=3Dm
CONFIG_SCSI_3W_9XXX=3Dm
CONFIG_SCSI_3W_SAS=3Dm
# CONFIG_SCSI_ACARD is not set
CONFIG_SCSI_AACRAID=3Dm
# CONFIG_SCSI_AIC7XXX is not set
CONFIG_SCSI_AIC79XX=3Dm
CONFIG_AIC79XX_CMDS_PER_DEVICE=3D4
CONFIG_AIC79XX_RESET_DELAY_MS=3D15000
# CONFIG_AIC79XX_DEBUG_ENABLE is not set
CONFIG_AIC79XX_DEBUG_MASK=3D0
# CONFIG_AIC79XX_REG_PRETTY_PRINT is not set
# CONFIG_SCSI_AIC94XX is not set
CONFIG_SCSI_MVSAS=3Dm
# CONFIG_SCSI_MVSAS_DEBUG is not set
CONFIG_SCSI_MVSAS_TASKLET=3Dy
CONFIG_SCSI_MVUMI=3Dm
# CONFIG_SCSI_DPT_I2O is not set
# CONFIG_SCSI_ADVANSYS is not set
CONFIG_SCSI_ARCMSR=3Dm
# CONFIG_SCSI_ESAS2R is not set
# CONFIG_MEGARAID_NEWGEN is not set
# CONFIG_MEGARAID_LEGACY is not set
CONFIG_MEGARAID_SAS=3Dm
CONFIG_SCSI_MPT3SAS=3Dm
CONFIG_SCSI_MPT2SAS_MAX_SGE=3D128
CONFIG_SCSI_MPT3SAS_MAX_SGE=3D128
CONFIG_SCSI_MPT2SAS=3Dm
# CONFIG_SCSI_SMARTPQI is not set
CONFIG_SCSI_UFSHCD=3Dm
CONFIG_SCSI_UFSHCD_PCI=3Dm
# CONFIG_SCSI_UFS_DWC_TC_PCI is not set
# CONFIG_SCSI_UFSHCD_PLATFORM is not set
# CONFIG_SCSI_UFS_BSG is not set
CONFIG_SCSI_HPTIOP=3Dm
# CONFIG_SCSI_BUSLOGIC is not set
# CONFIG_SCSI_MYRB is not set
# CONFIG_SCSI_MYRS is not set
CONFIG_VMWARE_PVSCSI=3Dm
# CONFIG_XEN_SCSI_FRONTEND is not set
CONFIG_HYPERV_STORAGE=3Dm
CONFIG_LIBFC=3Dm
CONFIG_LIBFCOE=3Dm
CONFIG_FCOE=3Dm
CONFIG_FCOE_FNIC=3Dm
# CONFIG_SCSI_SNIC is not set
# CONFIG_SCSI_DMX3191D is not set
# CONFIG_SCSI_FDOMAIN_PCI is not set
# CONFIG_SCSI_GDTH is not set
CONFIG_SCSI_ISCI=3Dm
# CONFIG_SCSI_IPS is not set
CONFIG_SCSI_INITIO=3Dm
# CONFIG_SCSI_INIA100 is not set
# CONFIG_SCSI_PPA is not set
# CONFIG_SCSI_IMM is not set
CONFIG_SCSI_STEX=3Dm
# CONFIG_SCSI_SYM53C8XX_2 is not set
# CONFIG_SCSI_IPR is not set
# CONFIG_SCSI_QLOGIC_1280 is not set
CONFIG_SCSI_QLA_FC=3Dm
CONFIG_TCM_QLA2XXX=3Dm
# CONFIG_TCM_QLA2XXX_DEBUG is not set
CONFIG_SCSI_QLA_ISCSI=3Dm
# CONFIG_QEDI is not set
# CONFIG_QEDF is not set
# CONFIG_SCSI_LPFC is not set
# CONFIG_SCSI_DC395x is not set
# CONFIG_SCSI_AM53C974 is not set
# CONFIG_SCSI_WD719X is not set
CONFIG_SCSI_DEBUG=3Dm
CONFIG_SCSI_PMCRAID=3Dm
CONFIG_SCSI_PM8001=3Dm
# CONFIG_SCSI_BFA_FC is not set
CONFIG_SCSI_VIRTIO=3Dm
# CONFIG_SCSI_CHELSIO_FCOE is not set
CONFIG_SCSI_DH=3Dy
CONFIG_SCSI_DH_RDAC=3Dy
CONFIG_SCSI_DH_HP_SW=3Dy
CONFIG_SCSI_DH_EMC=3Dy
CONFIG_SCSI_DH_ALUA=3Dy
# end of SCSI device support

CONFIG_ATA=3Dm
CONFIG_ATA_VERBOSE_ERROR=3Dy
CONFIG_ATA_ACPI=3Dy
# CONFIG_SATA_ZPODD is not set
CONFIG_SATA_PMP=3Dy

#
# Controllers with non-SFF native interface
#
CONFIG_SATA_AHCI=3Dm
CONFIG_SATA_MOBILE_LPM_POLICY=3D0
CONFIG_SATA_AHCI_PLATFORM=3Dm
# CONFIG_SATA_INIC162X is not set
CONFIG_SATA_ACARD_AHCI=3Dm
CONFIG_SATA_SIL24=3Dm
CONFIG_ATA_SFF=3Dy

#
# SFF controllers with custom DMA interface
#
CONFIG_PDC_ADMA=3Dm
CONFIG_SATA_QSTOR=3Dm
CONFIG_SATA_SX4=3Dm
CONFIG_ATA_BMDMA=3Dy

#
# SATA SFF controllers with BMDMA
#
CONFIG_ATA_PIIX=3Dm
# CONFIG_SATA_DWC is not set
CONFIG_SATA_MV=3Dm
CONFIG_SATA_NV=3Dm
CONFIG_SATA_PROMISE=3Dm
CONFIG_SATA_SIL=3Dm
CONFIG_SATA_SIS=3Dm
CONFIG_SATA_SVW=3Dm
CONFIG_SATA_ULI=3Dm
CONFIG_SATA_VIA=3Dm
CONFIG_SATA_VITESSE=3Dm

#
# PATA SFF controllers with BMDMA
#
CONFIG_PATA_ALI=3Dm
CONFIG_PATA_AMD=3Dm
CONFIG_PATA_ARTOP=3Dm
CONFIG_PATA_ATIIXP=3Dm
CONFIG_PATA_ATP867X=3Dm
CONFIG_PATA_CMD64X=3Dm
# CONFIG_PATA_CYPRESS is not set
# CONFIG_PATA_EFAR is not set
CONFIG_PATA_HPT366=3Dm
CONFIG_PATA_HPT37X=3Dm
CONFIG_PATA_HPT3X2N=3Dm
CONFIG_PATA_HPT3X3=3Dm
# CONFIG_PATA_HPT3X3_DMA is not set
CONFIG_PATA_IT8213=3Dm
CONFIG_PATA_IT821X=3Dm
CONFIG_PATA_JMICRON=3Dm
CONFIG_PATA_MARVELL=3Dm
CONFIG_PATA_NETCELL=3Dm
CONFIG_PATA_NINJA32=3Dm
# CONFIG_PATA_NS87415 is not set
CONFIG_PATA_OLDPIIX=3Dm
# CONFIG_PATA_OPTIDMA is not set
CONFIG_PATA_PDC2027X=3Dm
CONFIG_PATA_PDC_OLD=3Dm
# CONFIG_PATA_RADISYS is not set
CONFIG_PATA_RDC=3Dm
CONFIG_PATA_SCH=3Dm
CONFIG_PATA_SERVERWORKS=3Dm
CONFIG_PATA_SIL680=3Dm
CONFIG_PATA_SIS=3Dm
CONFIG_PATA_TOSHIBA=3Dm
# CONFIG_PATA_TRIFLEX is not set
CONFIG_PATA_VIA=3Dm
# CONFIG_PATA_WINBOND is not set

#
# PIO-only SFF controllers
#
# CONFIG_PATA_CMD640_PCI is not set
# CONFIG_PATA_MPIIX is not set
# CONFIG_PATA_NS87410 is not set
# CONFIG_PATA_OPTI is not set
# CONFIG_PATA_PLATFORM is not set
# CONFIG_PATA_RZ1000 is not set

#
# Generic fallback / legacy drivers
#
CONFIG_PATA_ACPI=3Dm
CONFIG_ATA_GENERIC=3Dm
# CONFIG_PATA_LEGACY is not set
CONFIG_MD=3Dy
CONFIG_BLK_DEV_MD=3Dy
CONFIG_MD_AUTODETECT=3Dy
CONFIG_MD_LINEAR=3Dm
CONFIG_MD_RAID0=3Dm
CONFIG_MD_RAID1=3Dm
CONFIG_MD_RAID10=3Dm
CONFIG_MD_RAID456=3Dm
# CONFIG_MD_MULTIPATH is not set
CONFIG_MD_FAULTY=3Dm
# CONFIG_MD_CLUSTER is not set
# CONFIG_BCACHE is not set
CONFIG_BLK_DEV_DM_BUILTIN=3Dy
CONFIG_BLK_DEV_DM=3Dm
CONFIG_DM_DEBUG=3Dy
CONFIG_DM_BUFIO=3Dm
# CONFIG_DM_DEBUG_BLOCK_MANAGER_LOCKING is not set
CONFIG_DM_BIO_PRISON=3Dm
CONFIG_DM_PERSISTENT_DATA=3Dm
# CONFIG_DM_UNSTRIPED is not set
CONFIG_DM_CRYPT=3Dm
CONFIG_DM_SNAPSHOT=3Dm
CONFIG_DM_THIN_PROVISIONING=3Dm
CONFIG_DM_CACHE=3Dm
CONFIG_DM_CACHE_SMQ=3Dm
# CONFIG_DM_WRITECACHE is not set
CONFIG_DM_ERA=3Dm
# CONFIG_DM_CLONE is not set
CONFIG_DM_MIRROR=3Dm
CONFIG_DM_LOG_USERSPACE=3Dm
CONFIG_DM_RAID=3Dm
CONFIG_DM_ZERO=3Dm
CONFIG_DM_MULTIPATH=3Dm
CONFIG_DM_MULTIPATH_QL=3Dm
CONFIG_DM_MULTIPATH_ST=3Dm
CONFIG_DM_DELAY=3Dm
# CONFIG_DM_DUST is not set
CONFIG_DM_UEVENT=3Dy
CONFIG_DM_FLAKEY=3Dm
CONFIG_DM_VERITY=3Dm
# CONFIG_DM_VERITY_VERIFY_ROOTHASH_SIG is not set
# CONFIG_DM_VERITY_FEC is not set
CONFIG_DM_SWITCH=3Dm
CONFIG_DM_LOG_WRITES=3Dm
# CONFIG_DM_INTEGRITY is not set
CONFIG_TARGET_CORE=3Dm
CONFIG_TCM_IBLOCK=3Dm
CONFIG_TCM_FILEIO=3Dm
CONFIG_TCM_PSCSI=3Dm
CONFIG_TCM_USER2=3Dm
CONFIG_LOOPBACK_TARGET=3Dm
CONFIG_TCM_FC=3Dm
CONFIG_ISCSI_TARGET=3Dm
CONFIG_ISCSI_TARGET_CXGB4=3Dm
# CONFIG_SBP_TARGET is not set
CONFIG_FUSION=3Dy
CONFIG_FUSION_SPI=3Dm
# CONFIG_FUSION_FC is not set
CONFIG_FUSION_SAS=3Dm
CONFIG_FUSION_MAX_SGE=3D128
CONFIG_FUSION_CTL=3Dm
CONFIG_FUSION_LOGGING=3Dy

#
# IEEE 1394 (FireWire) support
#
CONFIG_FIREWIRE=3Dm
CONFIG_FIREWIRE_OHCI=3Dm
CONFIG_FIREWIRE_SBP2=3Dm
CONFIG_FIREWIRE_NET=3Dm
# CONFIG_FIREWIRE_NOSY is not set
# end of IEEE 1394 (FireWire) support

CONFIG_MACINTOSH_DRIVERS=3Dy
CONFIG_MAC_EMUMOUSEBTN=3Dy
CONFIG_NETDEVICES=3Dy
CONFIG_MII=3Dy
CONFIG_NET_CORE=3Dy
CONFIG_BONDING=3Dm
CONFIG_DUMMY=3Dm
# CONFIG_EQUALIZER is not set
CONFIG_NET_FC=3Dy
CONFIG_IFB=3Dm
CONFIG_NET_TEAM=3Dm
CONFIG_NET_TEAM_MODE_BROADCAST=3Dm
CONFIG_NET_TEAM_MODE_ROUNDROBIN=3Dm
CONFIG_NET_TEAM_MODE_RANDOM=3Dm
CONFIG_NET_TEAM_MODE_ACTIVEBACKUP=3Dm
CONFIG_NET_TEAM_MODE_LOADBALANCE=3Dm
CONFIG_MACVLAN=3Dm
CONFIG_MACVTAP=3Dm
# CONFIG_IPVLAN is not set
CONFIG_VXLAN=3Dm
CONFIG_GENEVE=3Dm
# CONFIG_GTP is not set
CONFIG_MACSEC=3Dy
CONFIG_NETCONSOLE=3Dm
CONFIG_NETCONSOLE_DYNAMIC=3Dy
CONFIG_NETPOLL=3Dy
CONFIG_NET_POLL_CONTROLLER=3Dy
CONFIG_NTB_NETDEV=3Dm
CONFIG_TUN=3Dm
CONFIG_TAP=3Dm
# CONFIG_TUN_VNET_CROSS_LE is not set
CONFIG_VETH=3Dm
CONFIG_VIRTIO_NET=3Dm
CONFIG_NLMON=3Dm
CONFIG_NET_VRF=3Dy
CONFIG_VSOCKMON=3Dm
# CONFIG_ARCNET is not set
# CONFIG_ATM_DRIVERS is not set

#
# CAIF transport drivers
#

#
# Distributed Switch Architecture drivers
#
# end of Distributed Switch Architecture drivers

CONFIG_ETHERNET=3Dy
CONFIG_MDIO=3Dy
# CONFIG_NET_VENDOR_3COM is not set
# CONFIG_NET_VENDOR_ADAPTEC is not set
CONFIG_NET_VENDOR_AGERE=3Dy
# CONFIG_ET131X is not set
CONFIG_NET_VENDOR_ALACRITECH=3Dy
# CONFIG_SLICOSS is not set
# CONFIG_NET_VENDOR_ALTEON is not set
# CONFIG_ALTERA_TSE is not set
CONFIG_NET_VENDOR_AMAZON=3Dy
CONFIG_ENA_ETHERNET=3Dm
CONFIG_NET_VENDOR_AMD=3Dy
CONFIG_AMD8111_ETH=3Dm
CONFIG_PCNET32=3Dm
CONFIG_AMD_XGBE=3Dm
# CONFIG_AMD_XGBE_DCB is not set
CONFIG_AMD_XGBE_HAVE_ECC=3Dy
CONFIG_NET_VENDOR_AQUANTIA=3Dy
CONFIG_AQTION=3Dm
CONFIG_NET_VENDOR_ARC=3Dy
CONFIG_NET_VENDOR_ATHEROS=3Dy
CONFIG_ATL2=3Dm
CONFIG_ATL1=3Dm
CONFIG_ATL1E=3Dm
CONFIG_ATL1C=3Dm
CONFIG_ALX=3Dm
CONFIG_NET_VENDOR_AURORA=3Dy
# CONFIG_AURORA_NB8800 is not set
CONFIG_NET_VENDOR_BROADCOM=3Dy
CONFIG_B44=3Dm
CONFIG_B44_PCI_AUTOSELECT=3Dy
CONFIG_B44_PCICORE_AUTOSELECT=3Dy
CONFIG_B44_PCI=3Dy
# CONFIG_BCMGENET is not set
CONFIG_BNX2=3Dm
CONFIG_CNIC=3Dm
CONFIG_TIGON3=3Dy
CONFIG_TIGON3_HWMON=3Dy
CONFIG_BNX2X=3Dm
CONFIG_BNX2X_SRIOV=3Dy
# CONFIG_SYSTEMPORT is not set
CONFIG_BNXT=3Dm
CONFIG_BNXT_SRIOV=3Dy
CONFIG_BNXT_FLOWER_OFFLOAD=3Dy
CONFIG_BNXT_DCB=3Dy
CONFIG_BNXT_HWMON=3Dy
CONFIG_NET_VENDOR_BROCADE=3Dy
CONFIG_BNA=3Dm
CONFIG_NET_VENDOR_CADENCE=3Dy
CONFIG_MACB=3Dm
CONFIG_MACB_USE_HWSTAMP=3Dy
# CONFIG_MACB_PCI is not set
CONFIG_NET_VENDOR_CAVIUM=3Dy
# CONFIG_THUNDER_NIC_PF is not set
# CONFIG_THUNDER_NIC_VF is not set
# CONFIG_THUNDER_NIC_BGX is not set
# CONFIG_THUNDER_NIC_RGX is not set
CONFIG_CAVIUM_PTP=3Dy
CONFIG_LIQUIDIO=3Dm
CONFIG_LIQUIDIO_VF=3Dm
CONFIG_NET_VENDOR_CHELSIO=3Dy
# CONFIG_CHELSIO_T1 is not set
CONFIG_CHELSIO_T3=3Dm
CONFIG_CHELSIO_T4=3Dm
# CONFIG_CHELSIO_T4_DCB is not set
CONFIG_CHELSIO_T4VF=3Dm
CONFIG_CHELSIO_LIB=3Dm
CONFIG_NET_VENDOR_CISCO=3Dy
CONFIG_ENIC=3Dm
CONFIG_NET_VENDOR_CORTINA=3Dy
# CONFIG_CX_ECAT is not set
CONFIG_DNET=3Dm
CONFIG_NET_VENDOR_DEC=3Dy
CONFIG_NET_TULIP=3Dy
CONFIG_DE2104X=3Dm
CONFIG_DE2104X_DSL=3D0
CONFIG_TULIP=3Dy
# CONFIG_TULIP_MWI is not set
CONFIG_TULIP_MMIO=3Dy
# CONFIG_TULIP_NAPI is not set
CONFIG_DE4X5=3Dm
CONFIG_WINBOND_840=3Dm
CONFIG_DM9102=3Dm
CONFIG_ULI526X=3Dm
CONFIG_PCMCIA_XIRCOM=3Dm
# CONFIG_NET_VENDOR_DLINK is not set
CONFIG_NET_VENDOR_EMULEX=3Dy
CONFIG_BE2NET=3Dm
CONFIG_BE2NET_HWMON=3Dy
CONFIG_BE2NET_BE2=3Dy
CONFIG_BE2NET_BE3=3Dy
CONFIG_BE2NET_LANCER=3Dy
CONFIG_BE2NET_SKYHAWK=3Dy
CONFIG_NET_VENDOR_EZCHIP=3Dy
CONFIG_NET_VENDOR_GOOGLE=3Dy
# CONFIG_GVE is not set
# CONFIG_NET_VENDOR_HP is not set
CONFIG_NET_VENDOR_HUAWEI=3Dy
# CONFIG_HINIC is not set
# CONFIG_NET_VENDOR_I825XX is not set
CONFIG_NET_VENDOR_INTEL=3Dy
# CONFIG_E100 is not set
CONFIG_E1000=3Dy
CONFIG_E1000E=3Dy
CONFIG_E1000E_HWTS=3Dy
CONFIG_IGB=3Dy
CONFIG_IGB_HWMON=3Dy
CONFIG_IGBVF=3Dm
# CONFIG_IXGB is not set
CONFIG_IXGBE=3Dy
CONFIG_IXGBE_HWMON=3Dy
CONFIG_IXGBE_DCB=3Dy
CONFIG_IXGBEVF=3Dm
CONFIG_I40E=3Dy
CONFIG_I40E_DCB=3Dy
CONFIG_IAVF=3Dm
CONFIG_I40EVF=3Dm
# CONFIG_ICE is not set
CONFIG_FM10K=3Dm
# CONFIG_IGC is not set
CONFIG_JME=3Dm
CONFIG_NET_VENDOR_MARVELL=3Dy
CONFIG_MVMDIO=3Dm
CONFIG_SKGE=3Dy
# CONFIG_SKGE_DEBUG is not set
CONFIG_SKGE_GENESIS=3Dy
CONFIG_SKY2=3Dm
# CONFIG_SKY2_DEBUG is not set
CONFIG_NET_VENDOR_MELLANOX=3Dy
CONFIG_MLX4_EN=3Dm
CONFIG_MLX4_EN_DCB=3Dy
CONFIG_MLX4_CORE=3Dm
CONFIG_MLX4_DEBUG=3Dy
CONFIG_MLX4_CORE_GEN2=3Dy
# CONFIG_MLX5_CORE is not set
# CONFIG_MLXSW_CORE is not set
# CONFIG_MLXFW is not set
# CONFIG_NET_VENDOR_MICREL is not set
# CONFIG_NET_VENDOR_MICROCHIP is not set
CONFIG_NET_VENDOR_MICROSEMI=3Dy
# CONFIG_MSCC_OCELOT_SWITCH is not set
CONFIG_NET_VENDOR_MYRI=3Dy
CONFIG_MYRI10GE=3Dm
CONFIG_MYRI10GE_DCA=3Dy
# CONFIG_FEALNX is not set
# CONFIG_NET_VENDOR_NATSEMI is not set
CONFIG_NET_VENDOR_NETERION=3Dy
# CONFIG_S2IO is not set
# CONFIG_VXGE is not set
CONFIG_NET_VENDOR_NETRONOME=3Dy
CONFIG_NFP=3Dm
CONFIG_NFP_APP_FLOWER=3Dy
CONFIG_NFP_APP_ABM_NIC=3Dy
# CONFIG_NFP_DEBUG is not set
CONFIG_NET_VENDOR_NI=3Dy
# CONFIG_NI_XGE_MANAGEMENT_ENET is not set
# CONFIG_NET_VENDOR_NVIDIA is not set
CONFIG_NET_VENDOR_OKI=3Dy
CONFIG_ETHOC=3Dm
CONFIG_NET_VENDOR_PACKET_ENGINES=3Dy
# CONFIG_HAMACHI is not set
CONFIG_YELLOWFIN=3Dm
CONFIG_NET_VENDOR_PENSANDO=3Dy
# CONFIG_IONIC is not set
CONFIG_NET_VENDOR_QLOGIC=3Dy
CONFIG_QLA3XXX=3Dm
CONFIG_QLCNIC=3Dm
CONFIG_QLCNIC_SRIOV=3Dy
CONFIG_QLCNIC_DCB=3Dy
CONFIG_QLCNIC_HWMON=3Dy
CONFIG_NETXEN_NIC=3Dm
CONFIG_QED=3Dm
CONFIG_QED_SRIOV=3Dy
CONFIG_QEDE=3Dm
CONFIG_NET_VENDOR_QUALCOMM=3Dy
# CONFIG_QCOM_EMAC is not set
# CONFIG_RMNET is not set
# CONFIG_NET_VENDOR_RDC is not set
CONFIG_NET_VENDOR_REALTEK=3Dy
# CONFIG_ATP is not set
CONFIG_8139CP=3Dy
CONFIG_8139TOO=3Dy
# CONFIG_8139TOO_PIO is not set
# CONFIG_8139TOO_TUNE_TWISTER is not set
CONFIG_8139TOO_8129=3Dy
# CONFIG_8139_OLD_RX_RESET is not set
CONFIG_R8169=3Dy
CONFIG_NET_VENDOR_RENESAS=3Dy
CONFIG_NET_VENDOR_ROCKER=3Dy
CONFIG_ROCKER=3Dm
CONFIG_NET_VENDOR_SAMSUNG=3Dy
# CONFIG_SXGBE_ETH is not set
# CONFIG_NET_VENDOR_SEEQ is not set
CONFIG_NET_VENDOR_SOLARFLARE=3Dy
CONFIG_SFC=3Dm
CONFIG_SFC_MTD=3Dy
CONFIG_SFC_MCDI_MON=3Dy
CONFIG_SFC_SRIOV=3Dy
CONFIG_SFC_MCDI_LOGGING=3Dy
CONFIG_SFC_FALCON=3Dm
CONFIG_SFC_FALCON_MTD=3Dy
# CONFIG_NET_VENDOR_SILAN is not set
# CONFIG_NET_VENDOR_SIS is not set
CONFIG_NET_VENDOR_SMSC=3Dy
CONFIG_EPIC100=3Dm
# CONFIG_SMSC911X is not set
CONFIG_SMSC9420=3Dm
CONFIG_NET_VENDOR_SOCIONEXT=3Dy
# CONFIG_NET_VENDOR_STMICRO is not set
# CONFIG_NET_VENDOR_SUN is not set
CONFIG_NET_VENDOR_SYNOPSYS=3Dy
# CONFIG_DWC_XLGMAC is not set
# CONFIG_NET_VENDOR_TEHUTI is not set
CONFIG_NET_VENDOR_TI=3Dy
# CONFIG_TI_CPSW_PHY_SEL is not set
CONFIG_TLAN=3Dm
# CONFIG_NET_VENDOR_VIA is not set
# CONFIG_NET_VENDOR_WIZNET is not set
CONFIG_NET_VENDOR_XILINX=3Dy
# CONFIG_XILINX_AXI_EMAC is not set
# CONFIG_XILINX_LL_TEMAC is not set
# CONFIG_FDDI is not set
# CONFIG_HIPPI is not set
# CONFIG_NET_SB1000 is not set
CONFIG_MDIO_DEVICE=3Dy
CONFIG_MDIO_BUS=3Dy
# CONFIG_MDIO_BCM_UNIMAC is not set
CONFIG_MDIO_BITBANG=3Dm
# CONFIG_MDIO_GPIO is not set
# CONFIG_MDIO_MSCC_MIIM is not set
# CONFIG_MDIO_THUNDER is not set
CONFIG_PHYLIB=3Dy
CONFIG_SWPHY=3Dy
# CONFIG_LED_TRIGGER_PHY is not set

#
# MII PHY device drivers
#
# CONFIG_ADIN_PHY is not set
CONFIG_AMD_PHY=3Dm
# CONFIG_AQUANTIA_PHY is not set
# CONFIG_AX88796B_PHY is not set
CONFIG_AT803X_PHY=3Dm
# CONFIG_BCM7XXX_PHY is not set
CONFIG_BCM87XX_PHY=3Dm
CONFIG_BCM_NET_PHYLIB=3Dm
CONFIG_BROADCOM_PHY=3Dm
CONFIG_CICADA_PHY=3Dm
# CONFIG_CORTINA_PHY is not set
CONFIG_DAVICOM_PHY=3Dm
# CONFIG_DP83822_PHY is not set
# CONFIG_DP83TC811_PHY is not set
# CONFIG_DP83848_PHY is not set
# CONFIG_DP83867_PHY is not set
CONFIG_FIXED_PHY=3Dy
CONFIG_ICPLUS_PHY=3Dm
# CONFIG_INTEL_XWAY_PHY is not set
CONFIG_LSI_ET1011C_PHY=3Dm
CONFIG_LXT_PHY=3Dm
CONFIG_MARVELL_PHY=3Dm
# CONFIG_MARVELL_10G_PHY is not set
CONFIG_MICREL_PHY=3Dm
# CONFIG_MICROCHIP_PHY is not set
# CONFIG_MICROCHIP_T1_PHY is not set
# CONFIG_MICROSEMI_PHY is not set
CONFIG_NATIONAL_PHY=3Dm
# CONFIG_NXP_TJA11XX_PHY is not set
CONFIG_QSEMI_PHY=3Dm
CONFIG_REALTEK_PHY=3Dy
# CONFIG_RENESAS_PHY is not set
# CONFIG_ROCKCHIP_PHY is not set
CONFIG_SMSC_PHY=3Dm
CONFIG_STE10XP=3Dm
# CONFIG_TERANETICS_PHY is not set
CONFIG_VITESSE_PHY=3Dm
# CONFIG_XILINX_GMII2RGMII is not set
# CONFIG_MICREL_KS8995MA is not set
# CONFIG_PLIP is not set
CONFIG_PPP=3Dm
CONFIG_PPP_BSDCOMP=3Dm
CONFIG_PPP_DEFLATE=3Dm
CONFIG_PPP_FILTER=3Dy
CONFIG_PPP_MPPE=3Dm
CONFIG_PPP_MULTILINK=3Dy
CONFIG_PPPOATM=3Dm
CONFIG_PPPOE=3Dm
CONFIG_PPTP=3Dm
CONFIG_PPPOL2TP=3Dm
CONFIG_PPP_ASYNC=3Dm
CONFIG_PPP_SYNC_TTY=3Dm
CONFIG_SLIP=3Dm
CONFIG_SLHC=3Dm
CONFIG_SLIP_COMPRESSED=3Dy
CONFIG_SLIP_SMART=3Dy
# CONFIG_SLIP_MODE_SLIP6 is not set
CONFIG_USB_NET_DRIVERS=3Dy
CONFIG_USB_CATC=3Dy
CONFIG_USB_KAWETH=3Dy
CONFIG_USB_PEGASUS=3Dy
CONFIG_USB_RTL8150=3Dy
CONFIG_USB_RTL8152=3Dm
# CONFIG_USB_LAN78XX is not set
CONFIG_USB_USBNET=3Dy
CONFIG_USB_NET_AX8817X=3Dy
CONFIG_USB_NET_AX88179_178A=3Dm
CONFIG_USB_NET_CDCETHER=3Dy
CONFIG_USB_NET_CDC_EEM=3Dy
CONFIG_USB_NET_CDC_NCM=3Dm
CONFIG_USB_NET_HUAWEI_CDC_NCM=3Dm
CONFIG_USB_NET_CDC_MBIM=3Dm
CONFIG_USB_NET_DM9601=3Dy
# CONFIG_USB_NET_SR9700 is not set
# CONFIG_USB_NET_SR9800 is not set
CONFIG_USB_NET_SMSC75XX=3Dy
CONFIG_USB_NET_SMSC95XX=3Dy
CONFIG_USB_NET_GL620A=3Dy
CONFIG_USB_NET_NET1080=3Dy
CONFIG_USB_NET_PLUSB=3Dy
CONFIG_USB_NET_MCS7830=3Dy
CONFIG_USB_NET_RNDIS_HOST=3Dy
CONFIG_USB_NET_CDC_SUBSET_ENABLE=3Dy
CONFIG_USB_NET_CDC_SUBSET=3Dy
CONFIG_USB_ALI_M5632=3Dy
CONFIG_USB_AN2720=3Dy
CONFIG_USB_BELKIN=3Dy
CONFIG_USB_ARMLINUX=3Dy
CONFIG_USB_EPSON2888=3Dy
CONFIG_USB_KC2190=3Dy
CONFIG_USB_NET_ZAURUS=3Dy
CONFIG_USB_NET_CX82310_ETH=3Dm
CONFIG_USB_NET_KALMIA=3Dm
CONFIG_USB_NET_QMI_WWAN=3Dm
CONFIG_USB_HSO=3Dm
CONFIG_USB_NET_INT51X1=3Dy
CONFIG_USB_IPHETH=3Dy
CONFIG_USB_SIERRA_NET=3Dy
CONFIG_USB_VL600=3Dm
# CONFIG_USB_NET_CH9200 is not set
# CONFIG_USB_NET_AQC111 is not set
CONFIG_WLAN=3Dy
# CONFIG_WIRELESS_WDS is not set
CONFIG_WLAN_VENDOR_ADMTEK=3Dy
# CONFIG_ADM8211 is not set
CONFIG_ATH_COMMON=3Dm
CONFIG_WLAN_VENDOR_ATH=3Dy
# CONFIG_ATH_DEBUG is not set
# CONFIG_ATH5K is not set
# CONFIG_ATH5K_PCI is not set
CONFIG_ATH9K_HW=3Dm
CONFIG_ATH9K_COMMON=3Dm
CONFIG_ATH9K_BTCOEX_SUPPORT=3Dy
# CONFIG_ATH9K is not set
CONFIG_ATH9K_HTC=3Dm
# CONFIG_ATH9K_HTC_DEBUGFS is not set
# CONFIG_CARL9170 is not set
# CONFIG_ATH6KL is not set
# CONFIG_AR5523 is not set
# CONFIG_WIL6210 is not set
# CONFIG_ATH10K is not set
# CONFIG_WCN36XX is not set
CONFIG_WLAN_VENDOR_ATMEL=3Dy
# CONFIG_ATMEL is not set
# CONFIG_AT76C50X_USB is not set
CONFIG_WLAN_VENDOR_BROADCOM=3Dy
# CONFIG_B43 is not set
# CONFIG_B43LEGACY is not set
# CONFIG_BRCMSMAC is not set
# CONFIG_BRCMFMAC is not set
CONFIG_WLAN_VENDOR_CISCO=3Dy
# CONFIG_AIRO is not set
CONFIG_WLAN_VENDOR_INTEL=3Dy
# CONFIG_IPW2100 is not set
# CONFIG_IPW2200 is not set
CONFIG_IWLEGACY=3Dm
CONFIG_IWL4965=3Dm
CONFIG_IWL3945=3Dm

#
# iwl3945 / iwl4965 Debugging Options
#
CONFIG_IWLEGACY_DEBUG=3Dy
CONFIG_IWLEGACY_DEBUGFS=3Dy
# end of iwl3945 / iwl4965 Debugging Options

CONFIG_IWLWIFI=3Dm
CONFIG_IWLWIFI_LEDS=3Dy
CONFIG_IWLDVM=3Dm
CONFIG_IWLMVM=3Dm
CONFIG_IWLWIFI_OPMODE_MODULAR=3Dy
# CONFIG_IWLWIFI_BCAST_FILTERING is not set

#
# Debugging Options
#
# CONFIG_IWLWIFI_DEBUG is not set
CONFIG_IWLWIFI_DEBUGFS=3Dy
# CONFIG_IWLWIFI_DEVICE_TRACING is not set
# end of Debugging Options

CONFIG_WLAN_VENDOR_INTERSIL=3Dy
# CONFIG_HOSTAP is not set
# CONFIG_HERMES is not set
# CONFIG_P54_COMMON is not set
# CONFIG_PRISM54 is not set
CONFIG_WLAN_VENDOR_MARVELL=3Dy
# CONFIG_LIBERTAS is not set
# CONFIG_LIBERTAS_THINFIRM is not set
# CONFIG_MWIFIEX is not set
# CONFIG_MWL8K is not set
CONFIG_WLAN_VENDOR_MEDIATEK=3Dy
# CONFIG_MT7601U is not set
# CONFIG_MT76x0U is not set
# CONFIG_MT76x0E is not set
# CONFIG_MT76x2E is not set
# CONFIG_MT76x2U is not set
# CONFIG_MT7603E is not set
# CONFIG_MT7615E is not set
CONFIG_WLAN_VENDOR_RALINK=3Dy
# CONFIG_RT2X00 is not set
CONFIG_WLAN_VENDOR_REALTEK=3Dy
# CONFIG_RTL8180 is not set
# CONFIG_RTL8187 is not set
# CONFIG_RTL_CARDS is not set
# CONFIG_RTL8XXXU is not set
# CONFIG_RTW88 is not set
CONFIG_WLAN_VENDOR_RSI=3Dy
# CONFIG_RSI_91X is not set
CONFIG_WLAN_VENDOR_ST=3Dy
# CONFIG_CW1200 is not set
CONFIG_WLAN_VENDOR_TI=3Dy
# CONFIG_WL1251 is not set
# CONFIG_WL12XX is not set
# CONFIG_WL18XX is not set
# CONFIG_WLCORE is not set
CONFIG_WLAN_VENDOR_ZYDAS=3Dy
# CONFIG_USB_ZD1201 is not set
# CONFIG_ZD1211RW is not set
CONFIG_WLAN_VENDOR_QUANTENNA=3Dy
# CONFIG_QTNFMAC_PCIE is not set
CONFIG_MAC80211_HWSIM=3Dm
# CONFIG_USB_NET_RNDIS_WLAN is not set
# CONFIG_VIRT_WIFI is not set

#
# Enable WiMAX (Networking options) to see the WiMAX drivers
#
CONFIG_WAN=3Dy
# CONFIG_LANMEDIA is not set
CONFIG_HDLC=3Dm
CONFIG_HDLC_RAW=3Dm
# CONFIG_HDLC_RAW_ETH is not set
CONFIG_HDLC_CISCO=3Dm
CONFIG_HDLC_FR=3Dm
CONFIG_HDLC_PPP=3Dm

#
# X.25/LAPB support is disabled
#
# CONFIG_PCI200SYN is not set
# CONFIG_WANXL is not set
# CONFIG_PC300TOO is not set
# CONFIG_FARSYNC is not set
CONFIG_DLCI=3Dm
CONFIG_DLCI_MAX=3D8
# CONFIG_SBNI is not set
CONFIG_IEEE802154_DRIVERS=3Dm
CONFIG_IEEE802154_FAKELB=3Dm
# CONFIG_IEEE802154_AT86RF230 is not set
# CONFIG_IEEE802154_MRF24J40 is not set
# CONFIG_IEEE802154_CC2520 is not set
# CONFIG_IEEE802154_ATUSB is not set
# CONFIG_IEEE802154_ADF7242 is not set
# CONFIG_IEEE802154_CA8210 is not set
# CONFIG_IEEE802154_MCR20A is not set
# CONFIG_IEEE802154_HWSIM is not set
CONFIG_XEN_NETDEV_FRONTEND=3Dm
CONFIG_VMXNET3=3Dm
CONFIG_FUJITSU_ES=3Dm
CONFIG_THUNDERBOLT_NET=3Dm
CONFIG_HYPERV_NET=3Dm
# CONFIG_NETDEVSIM is not set
CONFIG_NET_FAILOVER=3Dm
CONFIG_ISDN=3Dy
CONFIG_ISDN_CAPI=3Dm
# CONFIG_CAPI_TRACE is not set
CONFIG_ISDN_CAPI_CAPI20=3Dm
CONFIG_ISDN_CAPI_MIDDLEWARE=3Dy
CONFIG_MISDN=3Dm
CONFIG_MISDN_DSP=3Dm
CONFIG_MISDN_L1OIP=3Dm

#
# mISDN hardware drivers
#
CONFIG_MISDN_HFCPCI=3Dm
CONFIG_MISDN_HFCMULTI=3Dm
CONFIG_MISDN_HFCUSB=3Dm
CONFIG_MISDN_AVMFRITZ=3Dm
CONFIG_MISDN_SPEEDFAX=3Dm
CONFIG_MISDN_INFINEON=3Dm
CONFIG_MISDN_W6692=3Dm
CONFIG_MISDN_NETJET=3Dm
CONFIG_MISDN_HDLC=3Dm
CONFIG_MISDN_IPAC=3Dm
CONFIG_MISDN_ISAR=3Dm
CONFIG_NVM=3Dy
# CONFIG_NVM_PBLK is not set

#
# Input device support
#
CONFIG_INPUT=3Dy
CONFIG_INPUT_LEDS=3Dy
CONFIG_INPUT_FF_MEMLESS=3Dy
CONFIG_INPUT_POLLDEV=3Dm
CONFIG_INPUT_SPARSEKMAP=3Dm
# CONFIG_INPUT_MATRIXKMAP is not set

#
# Userland interfaces
#
CONFIG_INPUT_MOUSEDEV=3Dy
# CONFIG_INPUT_MOUSEDEV_PSAUX is not set
CONFIG_INPUT_MOUSEDEV_SCREEN_X=3D1024
CONFIG_INPUT_MOUSEDEV_SCREEN_Y=3D768
CONFIG_INPUT_JOYDEV=3Dm
CONFIG_INPUT_EVDEV=3Dy
# CONFIG_INPUT_EVBUG is not set

#
# Input Device Drivers
#
CONFIG_INPUT_KEYBOARD=3Dy
# CONFIG_KEYBOARD_ADC is not set
# CONFIG_KEYBOARD_ADP5588 is not set
# CONFIG_KEYBOARD_ADP5589 is not set
# CONFIG_KEYBOARD_APPLESPI is not set
CONFIG_KEYBOARD_ATKBD=3Dy
# CONFIG_KEYBOARD_QT1050 is not set
# CONFIG_KEYBOARD_QT1070 is not set
# CONFIG_KEYBOARD_QT2160 is not set
# CONFIG_KEYBOARD_DLINK_DIR685 is not set
# CONFIG_KEYBOARD_LKKBD is not set
# CONFIG_KEYBOARD_GPIO is not set
# CONFIG_KEYBOARD_GPIO_POLLED is not set
# CONFIG_KEYBOARD_TCA6416 is not set
# CONFIG_KEYBOARD_TCA8418 is not set
# CONFIG_KEYBOARD_MATRIX is not set
# CONFIG_KEYBOARD_LM8323 is not set
# CONFIG_KEYBOARD_LM8333 is not set
# CONFIG_KEYBOARD_MAX7359 is not set
# CONFIG_KEYBOARD_MCS is not set
# CONFIG_KEYBOARD_MPR121 is not set
# CONFIG_KEYBOARD_NEWTON is not set
# CONFIG_KEYBOARD_OPENCORES is not set
# CONFIG_KEYBOARD_SAMSUNG is not set
# CONFIG_KEYBOARD_STOWAWAY is not set
# CONFIG_KEYBOARD_SUNKBD is not set
# CONFIG_KEYBOARD_TM2_TOUCHKEY is not set
# CONFIG_KEYBOARD_XTKBD is not set
CONFIG_INPUT_MOUSE=3Dy
CONFIG_MOUSE_PS2=3Dy
CONFIG_MOUSE_PS2_ALPS=3Dy
CONFIG_MOUSE_PS2_BYD=3Dy
CONFIG_MOUSE_PS2_LOGIPS2PP=3Dy
CONFIG_MOUSE_PS2_SYNAPTICS=3Dy
CONFIG_MOUSE_PS2_SYNAPTICS_SMBUS=3Dy
CONFIG_MOUSE_PS2_CYPRESS=3Dy
CONFIG_MOUSE_PS2_LIFEBOOK=3Dy
CONFIG_MOUSE_PS2_TRACKPOINT=3Dy
CONFIG_MOUSE_PS2_ELANTECH=3Dy
CONFIG_MOUSE_PS2_ELANTECH_SMBUS=3Dy
CONFIG_MOUSE_PS2_SENTELIC=3Dy
# CONFIG_MOUSE_PS2_TOUCHKIT is not set
CONFIG_MOUSE_PS2_FOCALTECH=3Dy
CONFIG_MOUSE_PS2_VMMOUSE=3Dy
CONFIG_MOUSE_PS2_SMBUS=3Dy
CONFIG_MOUSE_SERIAL=3Dm
CONFIG_MOUSE_APPLETOUCH=3Dm
CONFIG_MOUSE_BCM5974=3Dm
CONFIG_MOUSE_CYAPA=3Dm
# CONFIG_MOUSE_ELAN_I2C is not set
CONFIG_MOUSE_VSXXXAA=3Dm
# CONFIG_MOUSE_GPIO is not set
CONFIG_MOUSE_SYNAPTICS_I2C=3Dm
CONFIG_MOUSE_SYNAPTICS_USB=3Dm
# CONFIG_INPUT_JOYSTICK is not set
CONFIG_INPUT_TABLET=3Dy
CONFIG_TABLET_USB_ACECAD=3Dm
CONFIG_TABLET_USB_AIPTEK=3Dm
CONFIG_TABLET_USB_GTCO=3Dm
# CONFIG_TABLET_USB_HANWANG is not set
CONFIG_TABLET_USB_KBTAB=3Dm
# CONFIG_TABLET_USB_PEGASUS is not set
# CONFIG_TABLET_SERIAL_WACOM4 is not set
CONFIG_INPUT_TOUCHSCREEN=3Dy
CONFIG_TOUCHSCREEN_PROPERTIES=3Dy
# CONFIG_TOUCHSCREEN_ADS7846 is not set
# CONFIG_TOUCHSCREEN_AD7877 is not set
# CONFIG_TOUCHSCREEN_AD7879 is not set
# CONFIG_TOUCHSCREEN_ADC is not set
# CONFIG_TOUCHSCREEN_ATMEL_MXT is not set
# CONFIG_TOUCHSCREEN_AUO_PIXCIR is not set
# CONFIG_TOUCHSCREEN_BU21013 is not set
# CONFIG_TOUCHSCREEN_BU21029 is not set
# CONFIG_TOUCHSCREEN_CHIPONE_ICN8505 is not set
# CONFIG_TOUCHSCREEN_CY8CTMG110 is not set
# CONFIG_TOUCHSCREEN_CYTTSP_CORE is not set
# CONFIG_TOUCHSCREEN_CYTTSP4_CORE is not set
# CONFIG_TOUCHSCREEN_DYNAPRO is not set
# CONFIG_TOUCHSCREEN_HAMPSHIRE is not set
# CONFIG_TOUCHSCREEN_EETI is not set
# CONFIG_TOUCHSCREEN_EGALAX_SERIAL is not set
# CONFIG_TOUCHSCREEN_EXC3000 is not set
# CONFIG_TOUCHSCREEN_FUJITSU is not set
# CONFIG_TOUCHSCREEN_GOODIX is not set
# CONFIG_TOUCHSCREEN_HIDEEP is not set
# CONFIG_TOUCHSCREEN_ILI210X is not set
# CONFIG_TOUCHSCREEN_S6SY761 is not set
# CONFIG_TOUCHSCREEN_GUNZE is not set
# CONFIG_TOUCHSCREEN_EKTF2127 is not set
# CONFIG_TOUCHSCREEN_ELAN is not set
CONFIG_TOUCHSCREEN_ELO=3Dm
CONFIG_TOUCHSCREEN_WACOM_W8001=3Dm
CONFIG_TOUCHSCREEN_WACOM_I2C=3Dm
# CONFIG_TOUCHSCREEN_MAX11801 is not set
# CONFIG_TOUCHSCREEN_MCS5000 is not set
# CONFIG_TOUCHSCREEN_MMS114 is not set
# CONFIG_TOUCHSCREEN_MELFAS_MIP4 is not set
# CONFIG_TOUCHSCREEN_MTOUCH is not set
# CONFIG_TOUCHSCREEN_INEXIO is not set
# CONFIG_TOUCHSCREEN_MK712 is not set
# CONFIG_TOUCHSCREEN_PENMOUNT is not set
# CONFIG_TOUCHSCREEN_EDT_FT5X06 is not set
# CONFIG_TOUCHSCREEN_TOUCHRIGHT is not set
# CONFIG_TOUCHSCREEN_TOUCHWIN is not set
# CONFIG_TOUCHSCREEN_PIXCIR is not set
# CONFIG_TOUCHSCREEN_WDT87XX_I2C is not set
# CONFIG_TOUCHSCREEN_WM97XX is not set
# CONFIG_TOUCHSCREEN_USB_COMPOSITE is not set
# CONFIG_TOUCHSCREEN_TOUCHIT213 is not set
# CONFIG_TOUCHSCREEN_TSC_SERIO is not set
# CONFIG_TOUCHSCREEN_TSC2004 is not set
# CONFIG_TOUCHSCREEN_TSC2005 is not set
# CONFIG_TOUCHSCREEN_TSC2007 is not set
# CONFIG_TOUCHSCREEN_RM_TS is not set
# CONFIG_TOUCHSCREEN_SILEAD is not set
# CONFIG_TOUCHSCREEN_SIS_I2C is not set
# CONFIG_TOUCHSCREEN_ST1232 is not set
# CONFIG_TOUCHSCREEN_STMFTS is not set
# CONFIG_TOUCHSCREEN_SUR40 is not set
# CONFIG_TOUCHSCREEN_SURFACE3_SPI is not set
# CONFIG_TOUCHSCREEN_SX8654 is not set
# CONFIG_TOUCHSCREEN_TPS6507X is not set
# CONFIG_TOUCHSCREEN_ZET6223 is not set
# CONFIG_TOUCHSCREEN_ZFORCE is not set
# CONFIG_TOUCHSCREEN_ROHM_BU21023 is not set
# CONFIG_TOUCHSCREEN_IQS5XX is not set
CONFIG_INPUT_MISC=3Dy
# CONFIG_INPUT_AD714X is not set
# CONFIG_INPUT_BMA150 is not set
# CONFIG_INPUT_E3X0_BUTTON is not set
# CONFIG_INPUT_MSM_VIBRATOR is not set
CONFIG_INPUT_PCSPKR=3Dm
# CONFIG_INPUT_MMA8450 is not set
CONFIG_INPUT_APANEL=3Dm
CONFIG_INPUT_GP2A=3Dm
# CONFIG_INPUT_GPIO_BEEPER is not set
# CONFIG_INPUT_GPIO_DECODER is not set
# CONFIG_INPUT_GPIO_VIBRA is not set
CONFIG_INPUT_ATLAS_BTNS=3Dm
CONFIG_INPUT_ATI_REMOTE2=3Dm
CONFIG_INPUT_KEYSPAN_REMOTE=3Dm
# CONFIG_INPUT_KXTJ9 is not set
CONFIG_INPUT_POWERMATE=3Dm
CONFIG_INPUT_YEALINK=3Dm
CONFIG_INPUT_CM109=3Dm
CONFIG_INPUT_UINPUT=3Dm
# CONFIG_INPUT_PCF8574 is not set
# CONFIG_INPUT_PWM_BEEPER is not set
# CONFIG_INPUT_PWM_VIBRA is not set
CONFIG_INPUT_GPIO_ROTARY_ENCODER=3Dm
# CONFIG_INPUT_ADXL34X is not set
# CONFIG_INPUT_IMS_PCU is not set
# CONFIG_INPUT_CMA3000 is not set
CONFIG_INPUT_XEN_KBDDEV_FRONTEND=3Dm
# CONFIG_INPUT_IDEAPAD_SLIDEBAR is not set
# CONFIG_INPUT_DRV260X_HAPTICS is not set
# CONFIG_INPUT_DRV2665_HAPTICS is not set
# CONFIG_INPUT_DRV2667_HAPTICS is not set
CONFIG_RMI4_CORE=3Dm
# CONFIG_RMI4_I2C is not set
# CONFIG_RMI4_SPI is not set
CONFIG_RMI4_SMB=3Dm
CONFIG_RMI4_F03=3Dy
CONFIG_RMI4_F03_SERIO=3Dm
CONFIG_RMI4_2D_SENSOR=3Dy
CONFIG_RMI4_F11=3Dy
CONFIG_RMI4_F12=3Dy
CONFIG_RMI4_F30=3Dy
# CONFIG_RMI4_F34 is not set
# CONFIG_RMI4_F54 is not set
# CONFIG_RMI4_F55 is not set

#
# Hardware I/O ports
#
CONFIG_SERIO=3Dy
CONFIG_ARCH_MIGHT_HAVE_PC_SERIO=3Dy
CONFIG_SERIO_I8042=3Dy
CONFIG_SERIO_SERPORT=3Dy
# CONFIG_SERIO_CT82C710 is not set
# CONFIG_SERIO_PARKBD is not set
# CONFIG_SERIO_PCIPS2 is not set
CONFIG_SERIO_LIBPS2=3Dy
CONFIG_SERIO_RAW=3Dm
CONFIG_SERIO_ALTERA_PS2=3Dm
# CONFIG_SERIO_PS2MULT is not set
CONFIG_SERIO_ARC_PS2=3Dm
CONFIG_HYPERV_KEYBOARD=3Dm
# CONFIG_SERIO_GPIO_PS2 is not set
# CONFIG_USERIO is not set
# CONFIG_GAMEPORT is not set
# end of Hardware I/O ports
# end of Input device support

#
# Character devices
#
CONFIG_TTY=3Dy
CONFIG_VT=3Dy
CONFIG_CONSOLE_TRANSLATIONS=3Dy
CONFIG_VT_CONSOLE=3Dy
CONFIG_VT_CONSOLE_SLEEP=3Dy
CONFIG_HW_CONSOLE=3Dy
CONFIG_VT_HW_CONSOLE_BINDING=3Dy
CONFIG_UNIX98_PTYS=3Dy
# CONFIG_LEGACY_PTYS is not set
CONFIG_SERIAL_NONSTANDARD=3Dy
# CONFIG_ROCKETPORT is not set
CONFIG_CYCLADES=3Dm
# CONFIG_CYZ_INTR is not set
# CONFIG_MOXA_INTELLIO is not set
# CONFIG_MOXA_SMARTIO is not set
CONFIG_SYNCLINK=3Dm
CONFIG_SYNCLINKMP=3Dm
CONFIG_SYNCLINK_GT=3Dm
CONFIG_NOZOMI=3Dm
# CONFIG_ISI is not set
CONFIG_N_HDLC=3Dm
CONFIG_N_GSM=3Dm
# CONFIG_TRACE_SINK is not set
# CONFIG_NULL_TTY is not set
CONFIG_LDISC_AUTOLOAD=3Dy
CONFIG_DEVMEM=3Dy
# CONFIG_DEVKMEM is not set

#
# Serial drivers
#
CONFIG_SERIAL_EARLYCON=3Dy
CONFIG_SERIAL_8250=3Dy
# CONFIG_SERIAL_8250_DEPRECATED_OPTIONS is not set
CONFIG_SERIAL_8250_PNP=3Dy
# CONFIG_SERIAL_8250_FINTEK is not set
CONFIG_SERIAL_8250_CONSOLE=3Dy
CONFIG_SERIAL_8250_DMA=3Dy
CONFIG_SERIAL_8250_PCI=3Dy
CONFIG_SERIAL_8250_EXAR=3Dy
CONFIG_SERIAL_8250_NR_UARTS=3D32
CONFIG_SERIAL_8250_RUNTIME_UARTS=3D4
CONFIG_SERIAL_8250_EXTENDED=3Dy
CONFIG_SERIAL_8250_MANY_PORTS=3Dy
CONFIG_SERIAL_8250_SHARE_IRQ=3Dy
# CONFIG_SERIAL_8250_DETECT_IRQ is not set
CONFIG_SERIAL_8250_RSA=3Dy
CONFIG_SERIAL_8250_DWLIB=3Dy
CONFIG_SERIAL_8250_DW=3Dy
# CONFIG_SERIAL_8250_RT288X is not set
CONFIG_SERIAL_8250_LPSS=3Dy
CONFIG_SERIAL_8250_MID=3Dy

#
# Non-8250 serial port support
#
# CONFIG_SERIAL_MAX3100 is not set
# CONFIG_SERIAL_MAX310X is not set
# CONFIG_SERIAL_UARTLITE is not set
CONFIG_SERIAL_CORE=3Dy
CONFIG_SERIAL_CORE_CONSOLE=3Dy
CONFIG_SERIAL_JSM=3Dm
# CONFIG_SERIAL_SCCNXP is not set
# CONFIG_SERIAL_SC16IS7XX is not set
# CONFIG_SERIAL_ALTERA_JTAGUART is not set
# CONFIG_SERIAL_ALTERA_UART is not set
# CONFIG_SERIAL_IFX6X60 is not set
CONFIG_SERIAL_ARC=3Dm
CONFIG_SERIAL_ARC_NR_PORTS=3D1
# CONFIG_SERIAL_RP2 is not set
# CONFIG_SERIAL_FSL_LPUART is not set
# CONFIG_SERIAL_FSL_LINFLEXUART is not set
# end of Serial drivers

CONFIG_SERIAL_MCTRL_GPIO=3Dy
# CONFIG_SERIAL_DEV_BUS is not set
# CONFIG_TTY_PRINTK is not set
CONFIG_PRINTER=3Dm
# CONFIG_LP_CONSOLE is not set
CONFIG_PPDEV=3Dm
CONFIG_HVC_DRIVER=3Dy
CONFIG_HVC_IRQ=3Dy
CONFIG_HVC_XEN=3Dy
CONFIG_HVC_XEN_FRONTEND=3Dy
CONFIG_VIRTIO_CONSOLE=3Dy
CONFIG_IPMI_HANDLER=3Dm
CONFIG_IPMI_DMI_DECODE=3Dy
CONFIG_IPMI_PLAT_DATA=3Dy
# CONFIG_IPMI_PANIC_EVENT is not set
CONFIG_IPMI_DEVICE_INTERFACE=3Dm
CONFIG_IPMI_SI=3Dm
CONFIG_IPMI_SSIF=3Dm
CONFIG_IPMI_WATCHDOG=3Dm
CONFIG_IPMI_POWEROFF=3Dm
CONFIG_HW_RANDOM=3Dy
CONFIG_HW_RANDOM_TIMERIOMEM=3Dm
CONFIG_HW_RANDOM_INTEL=3Dm
CONFIG_HW_RANDOM_AMD=3Dm
CONFIG_HW_RANDOM_VIA=3Dm
CONFIG_HW_RANDOM_VIRTIO=3Dy
CONFIG_NVRAM=3Dy
# CONFIG_APPLICOM is not set
# CONFIG_MWAVE is not set
CONFIG_RAW_DRIVER=3Dy
CONFIG_MAX_RAW_DEVS=3D8192
CONFIG_HPET=3Dy
CONFIG_HPET_MMAP=3Dy
# CONFIG_HPET_MMAP_DEFAULT is not set
CONFIG_HANGCHECK_TIMER=3Dm
CONFIG_UV_MMTIMER=3Dm
CONFIG_TCG_TPM=3Dy
CONFIG_HW_RANDOM_TPM=3Dy
CONFIG_TCG_TIS_CORE=3Dy
CONFIG_TCG_TIS=3Dy
# CONFIG_TCG_TIS_SPI is not set
CONFIG_TCG_TIS_I2C_ATMEL=3Dm
CONFIG_TCG_TIS_I2C_INFINEON=3Dm
CONFIG_TCG_TIS_I2C_NUVOTON=3Dm
CONFIG_TCG_NSC=3Dm
CONFIG_TCG_ATMEL=3Dm
CONFIG_TCG_INFINEON=3Dm
# CONFIG_TCG_XEN is not set
CONFIG_TCG_CRB=3Dy
# CONFIG_TCG_VTPM_PROXY is not set
CONFIG_TCG_TIS_ST33ZP24=3Dm
CONFIG_TCG_TIS_ST33ZP24_I2C=3Dm
# CONFIG_TCG_TIS_ST33ZP24_SPI is not set
CONFIG_TELCLOCK=3Dm
CONFIG_DEVPORT=3Dy
# CONFIG_XILLYBUS is not set
# end of Character devices

# CONFIG_RANDOM_TRUST_CPU is not set
# CONFIG_RANDOM_TRUST_BOOTLOADER is not set

#
# I2C support
#
CONFIG_I2C=3Dy
CONFIG_ACPI_I2C_OPREGION=3Dy
CONFIG_I2C_BOARDINFO=3Dy
CONFIG_I2C_COMPAT=3Dy
CONFIG_I2C_CHARDEV=3Dm
CONFIG_I2C_MUX=3Dm

#
# Multiplexer I2C Chip support
#
# CONFIG_I2C_MUX_GPIO is not set
# CONFIG_I2C_MUX_LTC4306 is not set
# CONFIG_I2C_MUX_PCA9541 is not set
# CONFIG_I2C_MUX_PCA954x is not set
# CONFIG_I2C_MUX_REG is not set
# CONFIG_I2C_MUX_MLXCPLD is not set
# end of Multiplexer I2C Chip support

CONFIG_I2C_HELPER_AUTO=3Dy
CONFIG_I2C_SMBUS=3Dm
CONFIG_I2C_ALGOBIT=3Dy
CONFIG_I2C_ALGOPCA=3Dm

#
# I2C Hardware Bus support
#

#
# PC SMBus host controller drivers
#
# CONFIG_I2C_ALI1535 is not set
# CONFIG_I2C_ALI1563 is not set
# CONFIG_I2C_ALI15X3 is not set
CONFIG_I2C_AMD756=3Dm
CONFIG_I2C_AMD756_S4882=3Dm
CONFIG_I2C_AMD8111=3Dm
# CONFIG_I2C_AMD_MP2 is not set
CONFIG_I2C_I801=3Dm
CONFIG_I2C_ISCH=3Dm
CONFIG_I2C_ISMT=3Dm
CONFIG_I2C_PIIX4=3Dm
CONFIG_I2C_NFORCE2=3Dm
CONFIG_I2C_NFORCE2_S4985=3Dm
# CONFIG_I2C_NVIDIA_GPU is not set
# CONFIG_I2C_SIS5595 is not set
# CONFIG_I2C_SIS630 is not set
CONFIG_I2C_SIS96X=3Dm
CONFIG_I2C_VIA=3Dm
CONFIG_I2C_VIAPRO=3Dm

#
# ACPI drivers
#
CONFIG_I2C_SCMI=3Dm

#
# I2C system bus drivers (mostly embedded / system-on-chip)
#
# CONFIG_I2C_CBUS_GPIO is not set
CONFIG_I2C_DESIGNWARE_CORE=3Dm
CONFIG_I2C_DESIGNWARE_PLATFORM=3Dm
# CONFIG_I2C_DESIGNWARE_SLAVE is not set
# CONFIG_I2C_DESIGNWARE_PCI is not set
# CONFIG_I2C_DESIGNWARE_BAYTRAIL is not set
# CONFIG_I2C_EMEV2 is not set
# CONFIG_I2C_GPIO is not set
# CONFIG_I2C_OCORES is not set
CONFIG_I2C_PCA_PLATFORM=3Dm
CONFIG_I2C_SIMTEC=3Dm
# CONFIG_I2C_XILINX is not set

#
# External I2C/SMBus adapter drivers
#
CONFIG_I2C_DIOLAN_U2C=3Dm
CONFIG_I2C_PARPORT=3Dm
CONFIG_I2C_PARPORT_LIGHT=3Dm
# CONFIG_I2C_ROBOTFUZZ_OSIF is not set
# CONFIG_I2C_TAOS_EVM is not set
CONFIG_I2C_TINY_USB=3Dm
CONFIG_I2C_VIPERBOARD=3Dm

#
# Other I2C/SMBus bus drivers
#
# CONFIG_I2C_MLXCPLD is not set
# end of I2C Hardware Bus support

CONFIG_I2C_STUB=3Dm
# CONFIG_I2C_SLAVE is not set
# CONFIG_I2C_DEBUG_CORE is not set
# CONFIG_I2C_DEBUG_ALGO is not set
# CONFIG_I2C_DEBUG_BUS is not set
# end of I2C support

# CONFIG_I3C is not set
CONFIG_SPI=3Dy
# CONFIG_SPI_DEBUG is not set
CONFIG_SPI_MASTER=3Dy
# CONFIG_SPI_MEM is not set

#
# SPI Master Controller Drivers
#
# CONFIG_SPI_ALTERA is not set
# CONFIG_SPI_AXI_SPI_ENGINE is not set
# CONFIG_SPI_BITBANG is not set
# CONFIG_SPI_BUTTERFLY is not set
# CONFIG_SPI_CADENCE is not set
# CONFIG_SPI_DESIGNWARE is not set
# CONFIG_SPI_NXP_FLEXSPI is not set
# CONFIG_SPI_GPIO is not set
# CONFIG_SPI_LM70_LLP is not set
# CONFIG_SPI_OC_TINY is not set
# CONFIG_SPI_PXA2XX is not set
# CONFIG_SPI_ROCKCHIP is not set
# CONFIG_SPI_SC18IS602 is not set
# CONFIG_SPI_SIFIVE is not set
# CONFIG_SPI_MXIC is not set
# CONFIG_SPI_XCOMM is not set
# CONFIG_SPI_XILINX is not set
# CONFIG_SPI_ZYNQMP_GQSPI is not set

#
# SPI Protocol Masters
#
# CONFIG_SPI_SPIDEV is not set
# CONFIG_SPI_LOOPBACK_TEST is not set
# CONFIG_SPI_TLE62X0 is not set
# CONFIG_SPI_SLAVE is not set
# CONFIG_SPMI is not set
# CONFIG_HSI is not set
CONFIG_PPS=3Dy
# CONFIG_PPS_DEBUG is not set

#
# PPS clients support
#
# CONFIG_PPS_CLIENT_KTIMER is not set
CONFIG_PPS_CLIENT_LDISC=3Dm
CONFIG_PPS_CLIENT_PARPORT=3Dm
CONFIG_PPS_CLIENT_GPIO=3Dm

#
# PPS generators support
#

#
# PTP clock support
#
CONFIG_PTP_1588_CLOCK=3Dy
CONFIG_DP83640_PHY=3Dm
CONFIG_PTP_1588_CLOCK_KVM=3Dm
# end of PTP clock support

CONFIG_PINCTRL=3Dy
CONFIG_PINMUX=3Dy
CONFIG_PINCONF=3Dy
CONFIG_GENERIC_PINCONF=3Dy
# CONFIG_DEBUG_PINCTRL is not set
CONFIG_PINCTRL_AMD=3Dm
# CONFIG_PINCTRL_MCP23S08 is not set
# CONFIG_PINCTRL_SX150X is not set
CONFIG_PINCTRL_BAYTRAIL=3Dy
# CONFIG_PINCTRL_CHERRYVIEW is not set
CONFIG_PINCTRL_INTEL=3Dm
# CONFIG_PINCTRL_BROXTON is not set
CONFIG_PINCTRL_CANNONLAKE=3Dm
# CONFIG_PINCTRL_CEDARFORK is not set
CONFIG_PINCTRL_DENVERTON=3Dm
CONFIG_PINCTRL_GEMINILAKE=3Dm
# CONFIG_PINCTRL_ICELAKE is not set
CONFIG_PINCTRL_LEWISBURG=3Dm
CONFIG_PINCTRL_SUNRISEPOINT=3Dm
CONFIG_GPIOLIB=3Dy
CONFIG_GPIOLIB_FASTPATH_LIMIT=3D512
CONFIG_GPIO_ACPI=3Dy
CONFIG_GPIOLIB_IRQCHIP=3Dy
# CONFIG_DEBUG_GPIO is not set
CONFIG_GPIO_SYSFS=3Dy
CONFIG_GPIO_GENERIC=3Dm

#
# Memory mapped GPIO drivers
#
CONFIG_GPIO_AMDPT=3Dm
# CONFIG_GPIO_DWAPB is not set
# CONFIG_GPIO_EXAR is not set
# CONFIG_GPIO_GENERIC_PLATFORM is not set
CONFIG_GPIO_ICH=3Dm
# CONFIG_GPIO_LYNXPOINT is not set
# CONFIG_GPIO_MB86S7X is not set
# CONFIG_GPIO_VX855 is not set
# CONFIG_GPIO_XILINX is not set
# CONFIG_GPIO_AMD_FCH is not set
# end of Memory mapped GPIO drivers

#
# Port-mapped I/O GPIO drivers
#
# CONFIG_GPIO_F7188X is not set
# CONFIG_GPIO_IT87 is not set
# CONFIG_GPIO_SCH is not set
# CONFIG_GPIO_SCH311X is not set
# CONFIG_GPIO_WINBOND is not set
# CONFIG_GPIO_WS16C48 is not set
# end of Port-mapped I/O GPIO drivers

#
# I2C GPIO expanders
#
# CONFIG_GPIO_ADP5588 is not set
# CONFIG_GPIO_MAX7300 is not set
# CONFIG_GPIO_MAX732X is not set
# CONFIG_GPIO_PCA953X is not set
# CONFIG_GPIO_PCF857X is not set
# CONFIG_GPIO_TPIC2810 is not set
# end of I2C GPIO expanders

#
# MFD GPIO expanders
#
# end of MFD GPIO expanders

#
# PCI GPIO expanders
#
# CONFIG_GPIO_AMD8111 is not set
# CONFIG_GPIO_ML_IOH is not set
# CONFIG_GPIO_PCI_IDIO_16 is not set
# CONFIG_GPIO_PCIE_IDIO_24 is not set
# CONFIG_GPIO_RDC321X is not set
# end of PCI GPIO expanders

#
# SPI GPIO expanders
#
# CONFIG_GPIO_MAX3191X is not set
# CONFIG_GPIO_MAX7301 is not set
# CONFIG_GPIO_MC33880 is not set
# CONFIG_GPIO_PISOSR is not set
# CONFIG_GPIO_XRA1403 is not set
# end of SPI GPIO expanders

#
# USB GPIO expanders
#
CONFIG_GPIO_VIPERBOARD=3Dm
# end of USB GPIO expanders

CONFIG_GPIO_MOCKUP=3Dy
# CONFIG_W1 is not set
# CONFIG_POWER_AVS is not set
CONFIG_POWER_RESET=3Dy
# CONFIG_POWER_RESET_RESTART is not set
CONFIG_POWER_SUPPLY=3Dy
# CONFIG_POWER_SUPPLY_DEBUG is not set
CONFIG_POWER_SUPPLY_HWMON=3Dy
# CONFIG_PDA_POWER is not set
# CONFIG_GENERIC_ADC_BATTERY is not set
# CONFIG_TEST_POWER is not set
# CONFIG_CHARGER_ADP5061 is not set
# CONFIG_BATTERY_DS2780 is not set
# CONFIG_BATTERY_DS2781 is not set
# CONFIG_BATTERY_DS2782 is not set
# CONFIG_BATTERY_SBS is not set
# CONFIG_CHARGER_SBS is not set
# CONFIG_MANAGER_SBS is not set
# CONFIG_BATTERY_BQ27XXX is not set
# CONFIG_BATTERY_MAX17040 is not set
# CONFIG_BATTERY_MAX17042 is not set
# CONFIG_CHARGER_MAX8903 is not set
# CONFIG_CHARGER_LP8727 is not set
# CONFIG_CHARGER_GPIO is not set
# CONFIG_CHARGER_LT3651 is not set
# CONFIG_CHARGER_BQ2415X is not set
# CONFIG_CHARGER_BQ24257 is not set
# CONFIG_CHARGER_BQ24735 is not set
# CONFIG_CHARGER_BQ25890 is not set
CONFIG_CHARGER_SMB347=3Dm
# CONFIG_BATTERY_GAUGE_LTC2941 is not set
# CONFIG_CHARGER_RT9455 is not set
CONFIG_HWMON=3Dy
CONFIG_HWMON_VID=3Dm
# CONFIG_HWMON_DEBUG_CHIP is not set

#
# Native drivers
#
CONFIG_SENSORS_ABITUGURU=3Dm
CONFIG_SENSORS_ABITUGURU3=3Dm
# CONFIG_SENSORS_AD7314 is not set
CONFIG_SENSORS_AD7414=3Dm
CONFIG_SENSORS_AD7418=3Dm
CONFIG_SENSORS_ADM1021=3Dm
CONFIG_SENSORS_ADM1025=3Dm
CONFIG_SENSORS_ADM1026=3Dm
CONFIG_SENSORS_ADM1029=3Dm
CONFIG_SENSORS_ADM1031=3Dm
CONFIG_SENSORS_ADM9240=3Dm
CONFIG_SENSORS_ADT7X10=3Dm
# CONFIG_SENSORS_ADT7310 is not set
CONFIG_SENSORS_ADT7410=3Dm
CONFIG_SENSORS_ADT7411=3Dm
CONFIG_SENSORS_ADT7462=3Dm
CONFIG_SENSORS_ADT7470=3Dm
CONFIG_SENSORS_ADT7475=3Dm
# CONFIG_SENSORS_AS370 is not set
CONFIG_SENSORS_ASC7621=3Dm
CONFIG_SENSORS_K8TEMP=3Dm
CONFIG_SENSORS_K10TEMP=3Dm
CONFIG_SENSORS_FAM15H_POWER=3Dm
CONFIG_SENSORS_APPLESMC=3Dm
CONFIG_SENSORS_ASB100=3Dm
# CONFIG_SENSORS_ASPEED is not set
CONFIG_SENSORS_ATXP1=3Dm
CONFIG_SENSORS_DS620=3Dm
CONFIG_SENSORS_DS1621=3Dm
CONFIG_SENSORS_DELL_SMM=3Dm
CONFIG_SENSORS_I5K_AMB=3Dm
CONFIG_SENSORS_F71805F=3Dm
CONFIG_SENSORS_F71882FG=3Dm
CONFIG_SENSORS_F75375S=3Dm
CONFIG_SENSORS_FSCHMD=3Dm
# CONFIG_SENSORS_FTSTEUTATES is not set
CONFIG_SENSORS_GL518SM=3Dm
CONFIG_SENSORS_GL520SM=3Dm
CONFIG_SENSORS_G760A=3Dm
# CONFIG_SENSORS_G762 is not set
# CONFIG_SENSORS_HIH6130 is not set
CONFIG_SENSORS_IBMAEM=3Dm
CONFIG_SENSORS_IBMPEX=3Dm
# CONFIG_SENSORS_IIO_HWMON is not set
# CONFIG_SENSORS_I5500 is not set
CONFIG_SENSORS_CORETEMP=3Dm
CONFIG_SENSORS_IT87=3Dm
CONFIG_SENSORS_JC42=3Dm
# CONFIG_SENSORS_POWR1220 is not set
CONFIG_SENSORS_LINEAGE=3Dm
# CONFIG_SENSORS_LTC2945 is not set
# CONFIG_SENSORS_LTC2990 is not set
CONFIG_SENSORS_LTC4151=3Dm
CONFIG_SENSORS_LTC4215=3Dm
# CONFIG_SENSORS_LTC4222 is not set
CONFIG_SENSORS_LTC4245=3Dm
# CONFIG_SENSORS_LTC4260 is not set
CONFIG_SENSORS_LTC4261=3Dm
# CONFIG_SENSORS_MAX1111 is not set
CONFIG_SENSORS_MAX16065=3Dm
CONFIG_SENSORS_MAX1619=3Dm
CONFIG_SENSORS_MAX1668=3Dm
CONFIG_SENSORS_MAX197=3Dm
# CONFIG_SENSORS_MAX31722 is not set
# CONFIG_SENSORS_MAX6621 is not set
CONFIG_SENSORS_MAX6639=3Dm
CONFIG_SENSORS_MAX6642=3Dm
CONFIG_SENSORS_MAX6650=3Dm
CONFIG_SENSORS_MAX6697=3Dm
# CONFIG_SENSORS_MAX31790 is not set
CONFIG_SENSORS_MCP3021=3Dm
# CONFIG_SENSORS_TC654 is not set
# CONFIG_SENSORS_ADCXX is not set
CONFIG_SENSORS_LM63=3Dm
# CONFIG_SENSORS_LM70 is not set
CONFIG_SENSORS_LM73=3Dm
CONFIG_SENSORS_LM75=3Dm
CONFIG_SENSORS_LM77=3Dm
CONFIG_SENSORS_LM78=3Dm
CONFIG_SENSORS_LM80=3Dm
CONFIG_SENSORS_LM83=3Dm
CONFIG_SENSORS_LM85=3Dm
CONFIG_SENSORS_LM87=3Dm
CONFIG_SENSORS_LM90=3Dm
CONFIG_SENSORS_LM92=3Dm
CONFIG_SENSORS_LM93=3Dm
CONFIG_SENSORS_LM95234=3Dm
CONFIG_SENSORS_LM95241=3Dm
CONFIG_SENSORS_LM95245=3Dm
CONFIG_SENSORS_PC87360=3Dm
CONFIG_SENSORS_PC87427=3Dm
CONFIG_SENSORS_NTC_THERMISTOR=3Dm
# CONFIG_SENSORS_NCT6683 is not set
CONFIG_SENSORS_NCT6775=3Dm
# CONFIG_SENSORS_NCT7802 is not set
# CONFIG_SENSORS_NCT7904 is not set
# CONFIG_SENSORS_NPCM7XX is not set
CONFIG_SENSORS_PCF8591=3Dm
CONFIG_PMBUS=3Dm
CONFIG_SENSORS_PMBUS=3Dm
CONFIG_SENSORS_ADM1275=3Dm
# CONFIG_SENSORS_IBM_CFFPS is not set
# CONFIG_SENSORS_INSPUR_IPSPS is not set
# CONFIG_SENSORS_IR35221 is not set
# CONFIG_SENSORS_IR38064 is not set
# CONFIG_SENSORS_IRPS5401 is not set
# CONFIG_SENSORS_ISL68137 is not set
CONFIG_SENSORS_LM25066=3Dm
CONFIG_SENSORS_LTC2978=3Dm
# CONFIG_SENSORS_LTC3815 is not set
CONFIG_SENSORS_MAX16064=3Dm
# CONFIG_SENSORS_MAX20751 is not set
# CONFIG_SENSORS_MAX31785 is not set
CONFIG_SENSORS_MAX34440=3Dm
CONFIG_SENSORS_MAX8688=3Dm
# CONFIG_SENSORS_PXE1610 is not set
# CONFIG_SENSORS_TPS40422 is not set
# CONFIG_SENSORS_TPS53679 is not set
CONFIG_SENSORS_UCD9000=3Dm
CONFIG_SENSORS_UCD9200=3Dm
CONFIG_SENSORS_ZL6100=3Dm
CONFIG_SENSORS_SHT15=3Dm
CONFIG_SENSORS_SHT21=3Dm
# CONFIG_SENSORS_SHT3x is not set
# CONFIG_SENSORS_SHTC1 is not set
CONFIG_SENSORS_SIS5595=3Dm
CONFIG_SENSORS_DME1737=3Dm
CONFIG_SENSORS_EMC1403=3Dm
# CONFIG_SENSORS_EMC2103 is not set
CONFIG_SENSORS_EMC6W201=3Dm
CONFIG_SENSORS_SMSC47M1=3Dm
CONFIG_SENSORS_SMSC47M192=3Dm
CONFIG_SENSORS_SMSC47B397=3Dm
CONFIG_SENSORS_SCH56XX_COMMON=3Dm
CONFIG_SENSORS_SCH5627=3Dm
CONFIG_SENSORS_SCH5636=3Dm
# CONFIG_SENSORS_STTS751 is not set
# CONFIG_SENSORS_SMM665 is not set
# CONFIG_SENSORS_ADC128D818 is not set
CONFIG_SENSORS_ADS7828=3Dm
# CONFIG_SENSORS_ADS7871 is not set
CONFIG_SENSORS_AMC6821=3Dm
CONFIG_SENSORS_INA209=3Dm
CONFIG_SENSORS_INA2XX=3Dm
# CONFIG_SENSORS_INA3221 is not set
# CONFIG_SENSORS_TC74 is not set
CONFIG_SENSORS_THMC50=3Dm
CONFIG_SENSORS_TMP102=3Dm
# CONFIG_SENSORS_TMP103 is not set
# CONFIG_SENSORS_TMP108 is not set
CONFIG_SENSORS_TMP401=3Dm
CONFIG_SENSORS_TMP421=3Dm
CONFIG_SENSORS_VIA_CPUTEMP=3Dm
CONFIG_SENSORS_VIA686A=3Dm
CONFIG_SENSORS_VT1211=3Dm
CONFIG_SENSORS_VT8231=3Dm
# CONFIG_SENSORS_W83773G is not set
CONFIG_SENSORS_W83781D=3Dm
CONFIG_SENSORS_W83791D=3Dm
CONFIG_SENSORS_W83792D=3Dm
CONFIG_SENSORS_W83793=3Dm
CONFIG_SENSORS_W83795=3Dm
# CONFIG_SENSORS_W83795_FANCTRL is not set
CONFIG_SENSORS_W83L785TS=3Dm
CONFIG_SENSORS_W83L786NG=3Dm
CONFIG_SENSORS_W83627HF=3Dm
CONFIG_SENSORS_W83627EHF=3Dm
# CONFIG_SENSORS_XGENE is not set

#
# ACPI drivers
#
CONFIG_SENSORS_ACPI_POWER=3Dm
CONFIG_SENSORS_ATK0110=3Dm
CONFIG_THERMAL=3Dy
# CONFIG_THERMAL_STATISTICS is not set
CONFIG_THERMAL_EMERGENCY_POWEROFF_DELAY_MS=3D0
CONFIG_THERMAL_HWMON=3Dy
CONFIG_THERMAL_WRITABLE_TRIPS=3Dy
CONFIG_THERMAL_DEFAULT_GOV_STEP_WISE=3Dy
# CONFIG_THERMAL_DEFAULT_GOV_FAIR_SHARE is not set
# CONFIG_THERMAL_DEFAULT_GOV_USER_SPACE is not set
# CONFIG_THERMAL_DEFAULT_GOV_POWER_ALLOCATOR is not set
CONFIG_THERMAL_GOV_FAIR_SHARE=3Dy
CONFIG_THERMAL_GOV_STEP_WISE=3Dy
CONFIG_THERMAL_GOV_BANG_BANG=3Dy
CONFIG_THERMAL_GOV_USER_SPACE=3Dy
# CONFIG_THERMAL_GOV_POWER_ALLOCATOR is not set
# CONFIG_CLOCK_THERMAL is not set
# CONFIG_DEVFREQ_THERMAL is not set
# CONFIG_THERMAL_EMULATION is not set

#
# Intel thermal drivers
#
CONFIG_INTEL_POWERCLAMP=3Dm
CONFIG_X86_PKG_TEMP_THERMAL=3Dm
CONFIG_INTEL_SOC_DTS_IOSF_CORE=3Dm
# CONFIG_INTEL_SOC_DTS_THERMAL is not set

#
# ACPI INT340X thermal drivers
#
CONFIG_INT340X_THERMAL=3Dm
CONFIG_ACPI_THERMAL_REL=3Dm
# CONFIG_INT3406_THERMAL is not set
CONFIG_PROC_THERMAL_MMIO_RAPL=3Dy
# end of ACPI INT340X thermal drivers

# CONFIG_INTEL_PCH_THERMAL is not set
# end of Intel thermal drivers

# CONFIG_GENERIC_ADC_THERMAL is not set
CONFIG_WATCHDOG=3Dy
CONFIG_WATCHDOG_CORE=3Dy
# CONFIG_WATCHDOG_NOWAYOUT is not set
CONFIG_WATCHDOG_HANDLE_BOOT_ENABLED=3Dy
CONFIG_WATCHDOG_OPEN_TIMEOUT=3D0
CONFIG_WATCHDOG_SYSFS=3Dy

#
# Watchdog Pretimeout Governors
#
# CONFIG_WATCHDOG_PRETIMEOUT_GOV is not set

#
# Watchdog Device Drivers
#
CONFIG_SOFT_WATCHDOG=3Dm
CONFIG_WDAT_WDT=3Dm
# CONFIG_XILINX_WATCHDOG is not set
# CONFIG_ZIIRAVE_WATCHDOG is not set
# CONFIG_CADENCE_WATCHDOG is not set
# CONFIG_DW_WATCHDOG is not set
# CONFIG_MAX63XX_WATCHDOG is not set
# CONFIG_ACQUIRE_WDT is not set
# CONFIG_ADVANTECH_WDT is not set
CONFIG_ALIM1535_WDT=3Dm
CONFIG_ALIM7101_WDT=3Dm
# CONFIG_EBC_C384_WDT is not set
CONFIG_F71808E_WDT=3Dm
CONFIG_SP5100_TCO=3Dm
CONFIG_SBC_FITPC2_WATCHDOG=3Dm
# CONFIG_EUROTECH_WDT is not set
CONFIG_IB700_WDT=3Dm
CONFIG_IBMASR=3Dm
# CONFIG_WAFER_WDT is not set
CONFIG_I6300ESB_WDT=3Dy
CONFIG_IE6XX_WDT=3Dm
CONFIG_ITCO_WDT=3Dy
CONFIG_ITCO_VENDOR_SUPPORT=3Dy
CONFIG_IT8712F_WDT=3Dm
CONFIG_IT87_WDT=3Dm
CONFIG_HP_WATCHDOG=3Dm
CONFIG_HPWDT_NMI_DECODING=3Dy
# CONFIG_SC1200_WDT is not set
# CONFIG_PC87413_WDT is not set
CONFIG_NV_TCO=3Dm
# CONFIG_60XX_WDT is not set
# CONFIG_CPU5_WDT is not set
CONFIG_SMSC_SCH311X_WDT=3Dm
# CONFIG_SMSC37B787_WDT is not set
# CONFIG_TQMX86_WDT is not set
CONFIG_VIA_WDT=3Dm
CONFIG_W83627HF_WDT=3Dm
CONFIG_W83877F_WDT=3Dm
CONFIG_W83977F_WDT=3Dm
CONFIG_MACHZ_WDT=3Dm
# CONFIG_SBC_EPX_C3_WATCHDOG is not set
CONFIG_INTEL_MEI_WDT=3Dm
# CONFIG_NI903X_WDT is not set
# CONFIG_NIC7018_WDT is not set
# CONFIG_MEN_A21_WDT is not set
CONFIG_XEN_WDT=3Dm

#
# PCI-based Watchdog Cards
#
CONFIG_PCIPCWATCHDOG=3Dm
CONFIG_WDTPCI=3Dm

#
# USB-based Watchdog Cards
#
CONFIG_USBPCWATCHDOG=3Dm
CONFIG_SSB_POSSIBLE=3Dy
CONFIG_SSB=3Dm
CONFIG_SSB_SPROM=3Dy
CONFIG_SSB_PCIHOST_POSSIBLE=3Dy
CONFIG_SSB_PCIHOST=3Dy
CONFIG_SSB_SDIOHOST_POSSIBLE=3Dy
CONFIG_SSB_SDIOHOST=3Dy
CONFIG_SSB_DRIVER_PCICORE_POSSIBLE=3Dy
CONFIG_SSB_DRIVER_PCICORE=3Dy
CONFIG_SSB_DRIVER_GPIO=3Dy
CONFIG_BCMA_POSSIBLE=3Dy
CONFIG_BCMA=3Dm
CONFIG_BCMA_HOST_PCI_POSSIBLE=3Dy
CONFIG_BCMA_HOST_PCI=3Dy
# CONFIG_BCMA_HOST_SOC is not set
CONFIG_BCMA_DRIVER_PCI=3Dy
CONFIG_BCMA_DRIVER_GMAC_CMN=3Dy
CONFIG_BCMA_DRIVER_GPIO=3Dy
# CONFIG_BCMA_DEBUG is not set

#
# Multifunction device drivers
#
CONFIG_MFD_CORE=3Dy
# CONFIG_MFD_AS3711 is not set
# CONFIG_PMIC_ADP5520 is not set
# CONFIG_MFD_AAT2870_CORE is not set
# CONFIG_MFD_BCM590XX is not set
# CONFIG_MFD_BD9571MWV is not set
# CONFIG_MFD_AXP20X_I2C is not set
# CONFIG_MFD_MADERA is not set
# CONFIG_PMIC_DA903X is not set
# CONFIG_MFD_DA9052_SPI is not set
# CONFIG_MFD_DA9052_I2C is not set
# CONFIG_MFD_DA9055 is not set
# CONFIG_MFD_DA9062 is not set
# CONFIG_MFD_DA9063 is not set
# CONFIG_MFD_DA9150 is not set
# CONFIG_MFD_DLN2 is not set
# CONFIG_MFD_MC13XXX_SPI is not set
# CONFIG_MFD_MC13XXX_I2C is not set
# CONFIG_HTC_PASIC3 is not set
# CONFIG_HTC_I2CPLD is not set
# CONFIG_MFD_INTEL_QUARK_I2C_GPIO is not set
CONFIG_LPC_ICH=3Dm
CONFIG_LPC_SCH=3Dm
# CONFIG_INTEL_SOC_PMIC_CHTDC_TI is not set
CONFIG_MFD_INTEL_LPSS=3Dy
CONFIG_MFD_INTEL_LPSS_ACPI=3Dy
CONFIG_MFD_INTEL_LPSS_PCI=3Dy
# CONFIG_MFD_JANZ_CMODIO is not set
# CONFIG_MFD_KEMPLD is not set
# CONFIG_MFD_88PM800 is not set
# CONFIG_MFD_88PM805 is not set
# CONFIG_MFD_88PM860X is not set
# CONFIG_MFD_MAX14577 is not set
# CONFIG_MFD_MAX77693 is not set
# CONFIG_MFD_MAX77843 is not set
# CONFIG_MFD_MAX8907 is not set
# CONFIG_MFD_MAX8925 is not set
# CONFIG_MFD_MAX8997 is not set
# CONFIG_MFD_MAX8998 is not set
# CONFIG_MFD_MT6397 is not set
# CONFIG_MFD_MENF21BMC is not set
# CONFIG_EZX_PCAP is not set
CONFIG_MFD_VIPERBOARD=3Dm
# CONFIG_MFD_RETU is not set
# CONFIG_MFD_PCF50633 is not set
# CONFIG_UCB1400_CORE is not set
# CONFIG_MFD_RDC321X is not set
# CONFIG_MFD_RT5033 is not set
# CONFIG_MFD_RC5T583 is not set
# CONFIG_MFD_SEC_CORE is not set
# CONFIG_MFD_SI476X_CORE is not set
CONFIG_MFD_SM501=3Dm
CONFIG_MFD_SM501_GPIO=3Dy
# CONFIG_MFD_SKY81452 is not set
# CONFIG_MFD_SMSC is not set
# CONFIG_ABX500_CORE is not set
# CONFIG_MFD_SYSCON is not set
# CONFIG_MFD_TI_AM335X_TSCADC is not set
# CONFIG_MFD_LP3943 is not set
# CONFIG_MFD_LP8788 is not set
# CONFIG_MFD_TI_LMU is not set
# CONFIG_MFD_PALMAS is not set
# CONFIG_TPS6105X is not set
# CONFIG_TPS65010 is not set
# CONFIG_TPS6507X is not set
# CONFIG_MFD_TPS65086 is not set
# CONFIG_MFD_TPS65090 is not set
# CONFIG_MFD_TI_LP873X is not set
# CONFIG_MFD_TPS6586X is not set
# CONFIG_MFD_TPS65910 is not set
# CONFIG_MFD_TPS65912_I2C is not set
# CONFIG_MFD_TPS65912_SPI is not set
# CONFIG_MFD_TPS80031 is not set
# CONFIG_TWL4030_CORE is not set
# CONFIG_TWL6040_CORE is not set
# CONFIG_MFD_WL1273_CORE is not set
# CONFIG_MFD_LM3533 is not set
# CONFIG_MFD_TQMX86 is not set
CONFIG_MFD_VX855=3Dm
# CONFIG_MFD_ARIZONA_I2C is not set
# CONFIG_MFD_ARIZONA_SPI is not set
# CONFIG_MFD_WM8400 is not set
# CONFIG_MFD_WM831X_I2C is not set
# CONFIG_MFD_WM831X_SPI is not set
# CONFIG_MFD_WM8350_I2C is not set
# CONFIG_MFD_WM8994 is not set
# end of Multifunction device drivers

# CONFIG_REGULATOR is not set
CONFIG_RC_CORE=3Dm
CONFIG_RC_MAP=3Dm
CONFIG_LIRC=3Dy
CONFIG_RC_DECODERS=3Dy
CONFIG_IR_NEC_DECODER=3Dm
CONFIG_IR_RC5_DECODER=3Dm
CONFIG_IR_RC6_DECODER=3Dm
CONFIG_IR_JVC_DECODER=3Dm
CONFIG_IR_SONY_DECODER=3Dm
CONFIG_IR_SANYO_DECODER=3Dm
CONFIG_IR_SHARP_DECODER=3Dm
CONFIG_IR_MCE_KBD_DECODER=3Dm
# CONFIG_IR_XMP_DECODER is not set
CONFIG_IR_IMON_DECODER=3Dm
# CONFIG_IR_RCMM_DECODER is not set
CONFIG_RC_DEVICES=3Dy
CONFIG_RC_ATI_REMOTE=3Dm
CONFIG_IR_ENE=3Dm
CONFIG_IR_IMON=3Dm
# CONFIG_IR_IMON_RAW is not set
CONFIG_IR_MCEUSB=3Dm
CONFIG_IR_ITE_CIR=3Dm
CONFIG_IR_FINTEK=3Dm
CONFIG_IR_NUVOTON=3Dm
CONFIG_IR_REDRAT3=3Dm
CONFIG_IR_STREAMZAP=3Dm
CONFIG_IR_WINBOND_CIR=3Dm
# CONFIG_IR_IGORPLUGUSB is not set
CONFIG_IR_IGUANA=3Dm
CONFIG_IR_TTUSBIR=3Dm
CONFIG_RC_LOOPBACK=3Dm
# CONFIG_IR_SERIAL is not set
# CONFIG_IR_SIR is not set
# CONFIG_RC_XBOX_DVD is not set
CONFIG_MEDIA_SUPPORT=3Dm

#
# Multimedia core support
#
CONFIG_MEDIA_CAMERA_SUPPORT=3Dy
CONFIG_MEDIA_ANALOG_TV_SUPPORT=3Dy
CONFIG_MEDIA_DIGITAL_TV_SUPPORT=3Dy
CONFIG_MEDIA_RADIO_SUPPORT=3Dy
# CONFIG_MEDIA_SDR_SUPPORT is not set
# CONFIG_MEDIA_CEC_SUPPORT is not set
CONFIG_MEDIA_CONTROLLER=3Dy
CONFIG_MEDIA_CONTROLLER_DVB=3Dy
CONFIG_VIDEO_DEV=3Dm
# CONFIG_VIDEO_V4L2_SUBDEV_API is not set
CONFIG_VIDEO_V4L2=3Dm
CONFIG_VIDEO_V4L2_I2C=3Dy
# CONFIG_VIDEO_ADV_DEBUG is not set
# CONFIG_VIDEO_FIXED_MINOR_RANGES is not set
CONFIG_VIDEO_TUNER=3Dm
CONFIG_VIDEOBUF_GEN=3Dm
CONFIG_VIDEOBUF_DMA_SG=3Dm
CONFIG_VIDEOBUF_VMALLOC=3Dm
CONFIG_DVB_CORE=3Dm
# CONFIG_DVB_MMAP is not set
CONFIG_DVB_NET=3Dy
CONFIG_TTPCI_EEPROM=3Dm
CONFIG_DVB_MAX_ADAPTERS=3D8
CONFIG_DVB_DYNAMIC_MINORS=3Dy
# CONFIG_DVB_DEMUX_SECTION_LOSS_LOG is not set
# CONFIG_DVB_ULE_DEBUG is not set

#
# Media drivers
#
CONFIG_MEDIA_USB_SUPPORT=3Dy

#
# Webcam devices
#
CONFIG_USB_VIDEO_CLASS=3Dm
CONFIG_USB_VIDEO_CLASS_INPUT_EVDEV=3Dy
CONFIG_USB_GSPCA=3Dm
CONFIG_USB_M5602=3Dm
CONFIG_USB_STV06XX=3Dm
CONFIG_USB_GL860=3Dm
CONFIG_USB_GSPCA_BENQ=3Dm
CONFIG_USB_GSPCA_CONEX=3Dm
CONFIG_USB_GSPCA_CPIA1=3Dm
# CONFIG_USB_GSPCA_DTCS033 is not set
CONFIG_USB_GSPCA_ETOMS=3Dm
CONFIG_USB_GSPCA_FINEPIX=3Dm
CONFIG_USB_GSPCA_JEILINJ=3Dm
CONFIG_USB_GSPCA_JL2005BCD=3Dm
# CONFIG_USB_GSPCA_KINECT is not set
CONFIG_USB_GSPCA_KONICA=3Dm
CONFIG_USB_GSPCA_MARS=3Dm
CONFIG_USB_GSPCA_MR97310A=3Dm
CONFIG_USB_GSPCA_NW80X=3Dm
CONFIG_USB_GSPCA_OV519=3Dm
CONFIG_USB_GSPCA_OV534=3Dm
CONFIG_USB_GSPCA_OV534_9=3Dm
CONFIG_USB_GSPCA_PAC207=3Dm
CONFIG_USB_GSPCA_PAC7302=3Dm
CONFIG_USB_GSPCA_PAC7311=3Dm
CONFIG_USB_GSPCA_SE401=3Dm
CONFIG_USB_GSPCA_SN9C2028=3Dm
CONFIG_USB_GSPCA_SN9C20X=3Dm
CONFIG_USB_GSPCA_SONIXB=3Dm
CONFIG_USB_GSPCA_SONIXJ=3Dm
CONFIG_USB_GSPCA_SPCA500=3Dm
CONFIG_USB_GSPCA_SPCA501=3Dm
CONFIG_USB_GSPCA_SPCA505=3Dm
CONFIG_USB_GSPCA_SPCA506=3Dm
CONFIG_USB_GSPCA_SPCA508=3Dm
CONFIG_USB_GSPCA_SPCA561=3Dm
CONFIG_USB_GSPCA_SPCA1528=3Dm
CONFIG_USB_GSPCA_SQ905=3Dm
CONFIG_USB_GSPCA_SQ905C=3Dm
CONFIG_USB_GSPCA_SQ930X=3Dm
CONFIG_USB_GSPCA_STK014=3Dm
# CONFIG_USB_GSPCA_STK1135 is not set
CONFIG_USB_GSPCA_STV0680=3Dm
CONFIG_USB_GSPCA_SUNPLUS=3Dm
CONFIG_USB_GSPCA_T613=3Dm
CONFIG_USB_GSPCA_TOPRO=3Dm
# CONFIG_USB_GSPCA_TOUPTEK is not set
CONFIG_USB_GSPCA_TV8532=3Dm
CONFIG_USB_GSPCA_VC032X=3Dm
CONFIG_USB_GSPCA_VICAM=3Dm
CONFIG_USB_GSPCA_XIRLINK_CIT=3Dm
CONFIG_USB_GSPCA_ZC3XX=3Dm
CONFIG_USB_PWC=3Dm
# CONFIG_USB_PWC_DEBUG is not set
CONFIG_USB_PWC_INPUT_EVDEV=3Dy
# CONFIG_VIDEO_CPIA2 is not set
CONFIG_USB_ZR364XX=3Dm
CONFIG_USB_STKWEBCAM=3Dm
CONFIG_USB_S2255=3Dm
# CONFIG_VIDEO_USBTV is not set

#
# Analog TV USB devices
#
CONFIG_VIDEO_PVRUSB2=3Dm
CONFIG_VIDEO_PVRUSB2_SYSFS=3Dy
CONFIG_VIDEO_PVRUSB2_DVB=3Dy
# CONFIG_VIDEO_PVRUSB2_DEBUGIFC is not set
CONFIG_VIDEO_HDPVR=3Dm
CONFIG_VIDEO_USBVISION=3Dm
# CONFIG_VIDEO_STK1160_COMMON is not set
# CONFIG_VIDEO_GO7007 is not set

#
# Analog/digital TV USB devices
#
CONFIG_VIDEO_AU0828=3Dm
CONFIG_VIDEO_AU0828_V4L2=3Dy
# CONFIG_VIDEO_AU0828_RC is not set
CONFIG_VIDEO_CX231XX=3Dm
CONFIG_VIDEO_CX231XX_RC=3Dy
CONFIG_VIDEO_CX231XX_ALSA=3Dm
CONFIG_VIDEO_CX231XX_DVB=3Dm
CONFIG_VIDEO_TM6000=3Dm
CONFIG_VIDEO_TM6000_ALSA=3Dm
CONFIG_VIDEO_TM6000_DVB=3Dm

#
# Digital TV USB devices
#
CONFIG_DVB_USB=3Dm
# CONFIG_DVB_USB_DEBUG is not set
CONFIG_DVB_USB_DIB3000MC=3Dm
CONFIG_DVB_USB_A800=3Dm
CONFIG_DVB_USB_DIBUSB_MB=3Dm
# CONFIG_DVB_USB_DIBUSB_MB_FAULTY is not set
CONFIG_DVB_USB_DIBUSB_MC=3Dm
CONFIG_DVB_USB_DIB0700=3Dm
CONFIG_DVB_USB_UMT_010=3Dm
CONFIG_DVB_USB_CXUSB=3Dm
# CONFIG_DVB_USB_CXUSB_ANALOG is not set
CONFIG_DVB_USB_M920X=3Dm
CONFIG_DVB_USB_DIGITV=3Dm
CONFIG_DVB_USB_VP7045=3Dm
CONFIG_DVB_USB_VP702X=3Dm
CONFIG_DVB_USB_GP8PSK=3Dm
CONFIG_DVB_USB_NOVA_T_USB2=3Dm
CONFIG_DVB_USB_TTUSB2=3Dm
CONFIG_DVB_USB_DTT200U=3Dm
CONFIG_DVB_USB_OPERA1=3Dm
CONFIG_DVB_USB_AF9005=3Dm
CONFIG_DVB_USB_AF9005_REMOTE=3Dm
CONFIG_DVB_USB_PCTV452E=3Dm
CONFIG_DVB_USB_DW2102=3Dm
CONFIG_DVB_USB_CINERGY_T2=3Dm
CONFIG_DVB_USB_DTV5100=3Dm
CONFIG_DVB_USB_AZ6027=3Dm
CONFIG_DVB_USB_TECHNISAT_USB2=3Dm
CONFIG_DVB_USB_V2=3Dm
CONFIG_DVB_USB_AF9015=3Dm
CONFIG_DVB_USB_AF9035=3Dm
CONFIG_DVB_USB_ANYSEE=3Dm
CONFIG_DVB_USB_AU6610=3Dm
CONFIG_DVB_USB_AZ6007=3Dm
CONFIG_DVB_USB_CE6230=3Dm
CONFIG_DVB_USB_EC168=3Dm
CONFIG_DVB_USB_GL861=3Dm
CONFIG_DVB_USB_LME2510=3Dm
CONFIG_DVB_USB_MXL111SF=3Dm
CONFIG_DVB_USB_RTL28XXU=3Dm
# CONFIG_DVB_USB_DVBSKY is not set
# CONFIG_DVB_USB_ZD1301 is not set
CONFIG_DVB_TTUSB_BUDGET=3Dm
CONFIG_DVB_TTUSB_DEC=3Dm
CONFIG_SMS_USB_DRV=3Dm
CONFIG_DVB_B2C2_FLEXCOP_USB=3Dm
# CONFIG_DVB_B2C2_FLEXCOP_USB_DEBUG is not set
# CONFIG_DVB_AS102 is not set

#
# Webcam, TV (analog/digital) USB devices
#
CONFIG_VIDEO_EM28XX=3Dm
# CONFIG_VIDEO_EM28XX_V4L2 is not set
CONFIG_VIDEO_EM28XX_ALSA=3Dm
CONFIG_VIDEO_EM28XX_DVB=3Dm
CONFIG_VIDEO_EM28XX_RC=3Dm
CONFIG_MEDIA_PCI_SUPPORT=3Dy

#
# Media capture support
#
# CONFIG_VIDEO_MEYE is not set
# CONFIG_VIDEO_SOLO6X10 is not set
# CONFIG_VIDEO_TW5864 is not set
# CONFIG_VIDEO_TW68 is not set
# CONFIG_VIDEO_TW686X is not set

#
# Media capture/analog TV support
#
CONFIG_VIDEO_IVTV=3Dm
# CONFIG_VIDEO_IVTV_DEPRECATED_IOCTLS is not set
# CONFIG_VIDEO_IVTV_ALSA is not set
CONFIG_VIDEO_FB_IVTV=3Dm
# CONFIG_VIDEO_FB_IVTV_FORCE_PAT is not set
# CONFIG_VIDEO_HEXIUM_GEMINI is not set
# CONFIG_VIDEO_HEXIUM_ORION is not set
# CONFIG_VIDEO_MXB is not set
# CONFIG_VIDEO_DT3155 is not set

#
# Media capture/analog/hybrid TV support
#
CONFIG_VIDEO_CX18=3Dm
CONFIG_VIDEO_CX18_ALSA=3Dm
CONFIG_VIDEO_CX23885=3Dm
CONFIG_MEDIA_ALTERA_CI=3Dm
# CONFIG_VIDEO_CX25821 is not set
CONFIG_VIDEO_CX88=3Dm
CONFIG_VIDEO_CX88_ALSA=3Dm
CONFIG_VIDEO_CX88_BLACKBIRD=3Dm
CONFIG_VIDEO_CX88_DVB=3Dm
CONFIG_VIDEO_CX88_ENABLE_VP3054=3Dy
CONFIG_VIDEO_CX88_VP3054=3Dm
CONFIG_VIDEO_CX88_MPEG=3Dm
CONFIG_VIDEO_BT848=3Dm
CONFIG_DVB_BT8XX=3Dm
CONFIG_VIDEO_SAA7134=3Dm
CONFIG_VIDEO_SAA7134_ALSA=3Dm
CONFIG_VIDEO_SAA7134_RC=3Dy
CONFIG_VIDEO_SAA7134_DVB=3Dm
CONFIG_VIDEO_SAA7164=3Dm

#
# Media digital TV PCI Adapters
#
CONFIG_DVB_AV7110_IR=3Dy
CONFIG_DVB_AV7110=3Dm
CONFIG_DVB_AV7110_OSD=3Dy
CONFIG_DVB_BUDGET_CORE=3Dm
CONFIG_DVB_BUDGET=3Dm
CONFIG_DVB_BUDGET_CI=3Dm
CONFIG_DVB_BUDGET_AV=3Dm
CONFIG_DVB_BUDGET_PATCH=3Dm
CONFIG_DVB_B2C2_FLEXCOP_PCI=3Dm
# CONFIG_DVB_B2C2_FLEXCOP_PCI_DEBUG is not set
CONFIG_DVB_PLUTO2=3Dm
CONFIG_DVB_DM1105=3Dm
CONFIG_DVB_PT1=3Dm
# CONFIG_DVB_PT3 is not set
CONFIG_MANTIS_CORE=3Dm
CONFIG_DVB_MANTIS=3Dm
CONFIG_DVB_HOPPER=3Dm
CONFIG_DVB_NGENE=3Dm
CONFIG_DVB_DDBRIDGE=3Dm
# CONFIG_DVB_DDBRIDGE_MSIENABLE is not set
# CONFIG_DVB_SMIPCIE is not set
# CONFIG_DVB_NETUP_UNIDVB is not set
# CONFIG_V4L_PLATFORM_DRIVERS is not set
# CONFIG_V4L_MEM2MEM_DRIVERS is not set
# CONFIG_V4L_TEST_DRIVERS is not set
# CONFIG_DVB_PLATFORM_DRIVERS is not set

#
# Supported MMC/SDIO adapters
#
CONFIG_SMS_SDIO_DRV=3Dm
CONFIG_RADIO_ADAPTERS=3Dy
CONFIG_RADIO_TEA575X=3Dm
# CONFIG_RADIO_SI470X is not set
# CONFIG_RADIO_SI4713 is not set
# CONFIG_USB_MR800 is not set
# CONFIG_USB_DSBR is not set
# CONFIG_RADIO_MAXIRADIO is not set
# CONFIG_RADIO_SHARK is not set
# CONFIG_RADIO_SHARK2 is not set
# CONFIG_USB_KEENE is not set
# CONFIG_USB_RAREMONO is not set
# CONFIG_USB_MA901 is not set
# CONFIG_RADIO_TEA5764 is not set
# CONFIG_RADIO_SAA7706H is not set
# CONFIG_RADIO_TEF6862 is not set
# CONFIG_RADIO_WL1273 is not set

#
# Texas Instruments WL128x FM driver (ST based)
#
# end of Texas Instruments WL128x FM driver (ST based)

#
# Supported FireWire (IEEE 1394) Adapters
#
CONFIG_DVB_FIREDTV=3Dm
CONFIG_DVB_FIREDTV_INPUT=3Dy
CONFIG_MEDIA_COMMON_OPTIONS=3Dy

#
# common driver options
#
CONFIG_VIDEO_CX2341X=3Dm
CONFIG_VIDEO_TVEEPROM=3Dm
CONFIG_CYPRESS_FIRMWARE=3Dm
CONFIG_VIDEOBUF2_CORE=3Dm
CONFIG_VIDEOBUF2_V4L2=3Dm
CONFIG_VIDEOBUF2_MEMOPS=3Dm
CONFIG_VIDEOBUF2_VMALLOC=3Dm
CONFIG_VIDEOBUF2_DMA_SG=3Dm
CONFIG_VIDEOBUF2_DVB=3Dm
CONFIG_DVB_B2C2_FLEXCOP=3Dm
CONFIG_VIDEO_SAA7146=3Dm
CONFIG_VIDEO_SAA7146_VV=3Dm
CONFIG_SMS_SIANO_MDTV=3Dm
CONFIG_SMS_SIANO_RC=3Dy
# CONFIG_SMS_SIANO_DEBUGFS is not set

#
# Media ancillary drivers (tuners, sensors, i2c, spi, frontends)
#
CONFIG_MEDIA_SUBDRV_AUTOSELECT=3Dy
CONFIG_MEDIA_ATTACH=3Dy
CONFIG_VIDEO_IR_I2C=3Dm

#
# I2C Encoders, decoders, sensors and other helper chips
#

#
# Audio decoders, processors and mixers
#
CONFIG_VIDEO_TVAUDIO=3Dm
CONFIG_VIDEO_TDA7432=3Dm
# CONFIG_VIDEO_TDA9840 is not set
# CONFIG_VIDEO_TEA6415C is not set
# CONFIG_VIDEO_TEA6420 is not set
CONFIG_VIDEO_MSP3400=3Dm
CONFIG_VIDEO_CS3308=3Dm
CONFIG_VIDEO_CS5345=3Dm
CONFIG_VIDEO_CS53L32A=3Dm
# CONFIG_VIDEO_TLV320AIC23B is not set
# CONFIG_VIDEO_UDA1342 is not set
CONFIG_VIDEO_WM8775=3Dm
CONFIG_VIDEO_WM8739=3Dm
CONFIG_VIDEO_VP27SMPX=3Dm
# CONFIG_VIDEO_SONY_BTF_MPX is not set

#
# RDS decoders
#
CONFIG_VIDEO_SAA6588=3Dm

#
# Video decoders
#
# CONFIG_VIDEO_ADV7183 is not set
# CONFIG_VIDEO_BT819 is not set
# CONFIG_VIDEO_BT856 is not set
# CONFIG_VIDEO_BT866 is not set
# CONFIG_VIDEO_KS0127 is not set
# CONFIG_VIDEO_ML86V7667 is not set
# CONFIG_VIDEO_SAA7110 is not set
CONFIG_VIDEO_SAA711X=3Dm
# CONFIG_VIDEO_TVP514X is not set
# CONFIG_VIDEO_TVP5150 is not set
# CONFIG_VIDEO_TVP7002 is not set
# CONFIG_VIDEO_TW2804 is not set
# CONFIG_VIDEO_TW9903 is not set
# CONFIG_VIDEO_TW9906 is not set
# CONFIG_VIDEO_TW9910 is not set
# CONFIG_VIDEO_VPX3220 is not set

#
# Video and audio decoders
#
CONFIG_VIDEO_SAA717X=3Dm
CONFIG_VIDEO_CX25840=3Dm

#
# Video encoders
#
CONFIG_VIDEO_SAA7127=3Dm
# CONFIG_VIDEO_SAA7185 is not set
# CONFIG_VIDEO_ADV7170 is not set
# CONFIG_VIDEO_ADV7175 is not set
# CONFIG_VIDEO_ADV7343 is not set
# CONFIG_VIDEO_ADV7393 is not set
# CONFIG_VIDEO_AK881X is not set
# CONFIG_VIDEO_THS8200 is not set

#
# Camera sensor devices
#
# CONFIG_VIDEO_OV2640 is not set
# CONFIG_VIDEO_OV2659 is not set
# CONFIG_VIDEO_OV2680 is not set
# CONFIG_VIDEO_OV2685 is not set
# CONFIG_VIDEO_OV6650 is not set
# CONFIG_VIDEO_OV5695 is not set
# CONFIG_VIDEO_OV772X is not set
# CONFIG_VIDEO_OV7640 is not set
# CONFIG_VIDEO_OV7670 is not set
# CONFIG_VIDEO_OV7740 is not set
# CONFIG_VIDEO_OV9640 is not set
# CONFIG_VIDEO_VS6624 is not set
# CONFIG_VIDEO_MT9M111 is not set
# CONFIG_VIDEO_MT9T112 is not set
# CONFIG_VIDEO_MT9V011 is not set
# CONFIG_VIDEO_MT9V111 is not set
# CONFIG_VIDEO_SR030PC30 is not set
# CONFIG_VIDEO_RJ54N1 is not set

#
# Lens drivers
#
# CONFIG_VIDEO_AD5820 is not set

#
# Flash devices
#
# CONFIG_VIDEO_ADP1653 is not set
# CONFIG_VIDEO_LM3560 is not set
# CONFIG_VIDEO_LM3646 is not set

#
# Video improvement chips
#
CONFIG_VIDEO_UPD64031A=3Dm
CONFIG_VIDEO_UPD64083=3Dm

#
# Audio/Video compression chips
#
CONFIG_VIDEO_SAA6752HS=3Dm

#
# SDR tuner chips
#

#
# Miscellaneous helper chips
#
# CONFIG_VIDEO_THS7303 is not set
CONFIG_VIDEO_M52790=3Dm
# CONFIG_VIDEO_I2C is not set
# end of I2C Encoders, decoders, sensors and other helper chips

#
# SPI helper chips
#
# end of SPI helper chips

#
# Media SPI Adapters
#
# CONFIG_CXD2880_SPI_DRV is not set
# end of Media SPI Adapters

CONFIG_MEDIA_TUNER=3Dm

#
# Customize TV tuners
#
CONFIG_MEDIA_TUNER_SIMPLE=3Dm
CONFIG_MEDIA_TUNER_TDA18250=3Dm
CONFIG_MEDIA_TUNER_TDA8290=3Dm
CONFIG_MEDIA_TUNER_TDA827X=3Dm
CONFIG_MEDIA_TUNER_TDA18271=3Dm
CONFIG_MEDIA_TUNER_TDA9887=3Dm
CONFIG_MEDIA_TUNER_TEA5761=3Dm
CONFIG_MEDIA_TUNER_TEA5767=3Dm
# CONFIG_MEDIA_TUNER_MSI001 is not set
CONFIG_MEDIA_TUNER_MT20XX=3Dm
CONFIG_MEDIA_TUNER_MT2060=3Dm
CONFIG_MEDIA_TUNER_MT2063=3Dm
CONFIG_MEDIA_TUNER_MT2266=3Dm
CONFIG_MEDIA_TUNER_MT2131=3Dm
CONFIG_MEDIA_TUNER_QT1010=3Dm
CONFIG_MEDIA_TUNER_XC2028=3Dm
CONFIG_MEDIA_TUNER_XC5000=3Dm
CONFIG_MEDIA_TUNER_XC4000=3Dm
CONFIG_MEDIA_TUNER_MXL5005S=3Dm
CONFIG_MEDIA_TUNER_MXL5007T=3Dm
CONFIG_MEDIA_TUNER_MC44S803=3Dm
CONFIG_MEDIA_TUNER_MAX2165=3Dm
CONFIG_MEDIA_TUNER_TDA18218=3Dm
CONFIG_MEDIA_TUNER_FC0011=3Dm
CONFIG_MEDIA_TUNER_FC0012=3Dm
CONFIG_MEDIA_TUNER_FC0013=3Dm
CONFIG_MEDIA_TUNER_TDA18212=3Dm
CONFIG_MEDIA_TUNER_E4000=3Dm
CONFIG_MEDIA_TUNER_FC2580=3Dm
CONFIG_MEDIA_TUNER_M88RS6000T=3Dm
CONFIG_MEDIA_TUNER_TUA9001=3Dm
CONFIG_MEDIA_TUNER_SI2157=3Dm
CONFIG_MEDIA_TUNER_IT913X=3Dm
CONFIG_MEDIA_TUNER_R820T=3Dm
# CONFIG_MEDIA_TUNER_MXL301RF is not set
CONFIG_MEDIA_TUNER_QM1D1C0042=3Dm
CONFIG_MEDIA_TUNER_QM1D1B0004=3Dm
# end of Customize TV tuners

#
# Customise DVB Frontends
#

#
# Multistandard (satellite) frontends
#
CONFIG_DVB_STB0899=3Dm
CONFIG_DVB_STB6100=3Dm
CONFIG_DVB_STV090x=3Dm
CONFIG_DVB_STV0910=3Dm
CONFIG_DVB_STV6110x=3Dm
CONFIG_DVB_STV6111=3Dm
CONFIG_DVB_MXL5XX=3Dm
CONFIG_DVB_M88DS3103=3Dm

#
# Multistandard (cable + terrestrial) frontends
#
CONFIG_DVB_DRXK=3Dm
CONFIG_DVB_TDA18271C2DD=3Dm
CONFIG_DVB_SI2165=3Dm
CONFIG_DVB_MN88472=3Dm
CONFIG_DVB_MN88473=3Dm

#
# DVB-S (satellite) frontends
#
CONFIG_DVB_CX24110=3Dm
CONFIG_DVB_CX24123=3Dm
CONFIG_DVB_MT312=3Dm
CONFIG_DVB_ZL10036=3Dm
CONFIG_DVB_ZL10039=3Dm
CONFIG_DVB_S5H1420=3Dm
CONFIG_DVB_STV0288=3Dm
CONFIG_DVB_STB6000=3Dm
CONFIG_DVB_STV0299=3Dm
CONFIG_DVB_STV6110=3Dm
CONFIG_DVB_STV0900=3Dm
CONFIG_DVB_TDA8083=3Dm
CONFIG_DVB_TDA10086=3Dm
CONFIG_DVB_TDA8261=3Dm
CONFIG_DVB_VES1X93=3Dm
CONFIG_DVB_TUNER_ITD1000=3Dm
CONFIG_DVB_TUNER_CX24113=3Dm
CONFIG_DVB_TDA826X=3Dm
CONFIG_DVB_TUA6100=3Dm
CONFIG_DVB_CX24116=3Dm
CONFIG_DVB_CX24117=3Dm
CONFIG_DVB_CX24120=3Dm
CONFIG_DVB_SI21XX=3Dm
CONFIG_DVB_TS2020=3Dm
CONFIG_DVB_DS3000=3Dm
CONFIG_DVB_MB86A16=3Dm
CONFIG_DVB_TDA10071=3Dm

#
# DVB-T (terrestrial) frontends
#
CONFIG_DVB_SP8870=3Dm
CONFIG_DVB_SP887X=3Dm
CONFIG_DVB_CX22700=3Dm
CONFIG_DVB_CX22702=3Dm
# CONFIG_DVB_S5H1432 is not set
CONFIG_DVB_DRXD=3Dm
CONFIG_DVB_L64781=3Dm
CONFIG_DVB_TDA1004X=3Dm
CONFIG_DVB_NXT6000=3Dm
CONFIG_DVB_MT352=3Dm
CONFIG_DVB_ZL10353=3Dm
CONFIG_DVB_DIB3000MB=3Dm
CONFIG_DVB_DIB3000MC=3Dm
CONFIG_DVB_DIB7000M=3Dm
CONFIG_DVB_DIB7000P=3Dm
# CONFIG_DVB_DIB9000 is not set
CONFIG_DVB_TDA10048=3Dm
CONFIG_DVB_AF9013=3Dm
CONFIG_DVB_EC100=3Dm
CONFIG_DVB_STV0367=3Dm
CONFIG_DVB_CXD2820R=3Dm
CONFIG_DVB_CXD2841ER=3Dm
CONFIG_DVB_RTL2830=3Dm
CONFIG_DVB_RTL2832=3Dm
CONFIG_DVB_SI2168=3Dm
# CONFIG_DVB_ZD1301_DEMOD is not set
CONFIG_DVB_GP8PSK_FE=3Dm
# CONFIG_DVB_CXD2880 is not set

#
# DVB-C (cable) frontends
#
CONFIG_DVB_VES1820=3Dm
CONFIG_DVB_TDA10021=3Dm
CONFIG_DVB_TDA10023=3Dm
CONFIG_DVB_STV0297=3Dm

#
# ATSC (North American/Korean Terrestrial/Cable DTV) frontends
#
CONFIG_DVB_NXT200X=3Dm
CONFIG_DVB_OR51211=3Dm
CONFIG_DVB_OR51132=3Dm
CONFIG_DVB_BCM3510=3Dm
CONFIG_DVB_LGDT330X=3Dm
CONFIG_DVB_LGDT3305=3Dm
CONFIG_DVB_LGDT3306A=3Dm
CONFIG_DVB_LG2160=3Dm
CONFIG_DVB_S5H1409=3Dm
CONFIG_DVB_AU8522=3Dm
CONFIG_DVB_AU8522_DTV=3Dm
CONFIG_DVB_AU8522_V4L=3Dm
CONFIG_DVB_S5H1411=3Dm

#
# ISDB-T (terrestrial) frontends
#
CONFIG_DVB_S921=3Dm
CONFIG_DVB_DIB8000=3Dm
CONFIG_DVB_MB86A20S=3Dm

#
# ISDB-S (satellite) & ISDB-T (terrestrial) frontends
#
CONFIG_DVB_TC90522=3Dm
# CONFIG_DVB_MN88443X is not set

#
# Digital terrestrial only tuners/PLL
#
CONFIG_DVB_PLL=3Dm
CONFIG_DVB_TUNER_DIB0070=3Dm
CONFIG_DVB_TUNER_DIB0090=3Dm

#
# SEC control devices for DVB-S
#
CONFIG_DVB_DRX39XYJ=3Dm
CONFIG_DVB_LNBH25=3Dm
# CONFIG_DVB_LNBH29 is not set
CONFIG_DVB_LNBP21=3Dm
CONFIG_DVB_LNBP22=3Dm
CONFIG_DVB_ISL6405=3Dm
CONFIG_DVB_ISL6421=3Dm
CONFIG_DVB_ISL6423=3Dm
CONFIG_DVB_A8293=3Dm
# CONFIG_DVB_LGS8GL5 is not set
CONFIG_DVB_LGS8GXX=3Dm
CONFIG_DVB_ATBM8830=3Dm
CONFIG_DVB_TDA665x=3Dm
CONFIG_DVB_IX2505V=3Dm
CONFIG_DVB_M88RS2000=3Dm
CONFIG_DVB_AF9033=3Dm
# CONFIG_DVB_HORUS3A is not set
# CONFIG_DVB_ASCOT2E is not set
# CONFIG_DVB_HELENE is not set

#
# Common Interface (EN50221) controller drivers
#
CONFIG_DVB_CXD2099=3Dm
# CONFIG_DVB_SP2 is not set

#
# Tools to develop new frontends
#
CONFIG_DVB_DUMMY_FE=3Dm
# end of Customise DVB Frontends

#
# Graphics support
#
CONFIG_AGP=3Dy
CONFIG_AGP_AMD64=3Dy
CONFIG_AGP_INTEL=3Dy
CONFIG_AGP_SIS=3Dy
CONFIG_AGP_VIA=3Dy
CONFIG_INTEL_GTT=3Dy
CONFIG_VGA_ARB=3Dy
CONFIG_VGA_ARB_MAX_GPUS=3D64
CONFIG_VGA_SWITCHEROO=3Dy
CONFIG_DRM=3Dm
CONFIG_DRM_MIPI_DSI=3Dy
CONFIG_DRM_DP_AUX_CHARDEV=3Dy
CONFIG_DRM_DEBUG_SELFTEST=3Dm
CONFIG_DRM_KMS_HELPER=3Dm
CONFIG_DRM_KMS_FB_HELPER=3Dy
CONFIG_DRM_FBDEV_EMULATION=3Dy
CONFIG_DRM_FBDEV_OVERALLOC=3D100
# CONFIG_DRM_FBDEV_LEAK_PHYS_SMEM is not set
CONFIG_DRM_LOAD_EDID_FIRMWARE=3Dy
# CONFIG_DRM_DP_CEC is not set
CONFIG_DRM_TTM=3Dm
CONFIG_DRM_VRAM_HELPER=3Dm
CONFIG_DRM_GEM_SHMEM_HELPER=3Dy

#
# I2C encoder or helper chips
#
CONFIG_DRM_I2C_CH7006=3Dm
CONFIG_DRM_I2C_SIL164=3Dm
# CONFIG_DRM_I2C_NXP_TDA998X is not set
# CONFIG_DRM_I2C_NXP_TDA9950 is not set
# end of I2C encoder or helper chips

#
# ARM devices
#
# end of ARM devices

# CONFIG_DRM_RADEON is not set
# CONFIG_DRM_AMDGPU is not set

#
# ACP (Audio CoProcessor) Configuration
#
# end of ACP (Audio CoProcessor) Configuration

# CONFIG_DRM_NOUVEAU is not set
CONFIG_DRM_I915=3Dm
# CONFIG_DRM_I915_ALPHA_SUPPORT is not set
CONFIG_DRM_I915_FORCE_PROBE=3D""
CONFIG_DRM_I915_CAPTURE_ERROR=3Dy
CONFIG_DRM_I915_COMPRESS_ERROR=3Dy
CONFIG_DRM_I915_USERPTR=3Dy
CONFIG_DRM_I915_GVT=3Dy
CONFIG_DRM_I915_GVT_KVMGT=3Dm

#
# drm/i915 Debugging
#
# CONFIG_DRM_I915_WERROR is not set
# CONFIG_DRM_I915_DEBUG is not set
# CONFIG_DRM_I915_DEBUG_MMIO is not set
# CONFIG_DRM_I915_SW_FENCE_DEBUG_OBJECTS is not set
# CONFIG_DRM_I915_SW_FENCE_CHECK_DAG is not set
# CONFIG_DRM_I915_DEBUG_GUC is not set
# CONFIG_DRM_I915_SELFTEST is not set
# CONFIG_DRM_I915_LOW_LEVEL_TRACEPOINTS is not set
# CONFIG_DRM_I915_DEBUG_VBLANK_EVADE is not set
# CONFIG_DRM_I915_DEBUG_RUNTIME_PM is not set
# end of drm/i915 Debugging

#
# drm/i915 Profile Guided Optimisation
#
CONFIG_DRM_I915_USERFAULT_AUTOSUSPEND=3D250
CONFIG_DRM_I915_SPIN_REQUEST=3D5
# end of drm/i915 Profile Guided Optimisation

# CONFIG_DRM_VGEM is not set
# CONFIG_DRM_VKMS is not set
CONFIG_DRM_VMWGFX=3Dm
CONFIG_DRM_VMWGFX_FBCON=3Dy
CONFIG_DRM_GMA500=3Dm
CONFIG_DRM_GMA600=3Dy
CONFIG_DRM_GMA3600=3Dy
CONFIG_DRM_UDL=3Dm
CONFIG_DRM_AST=3Dm
CONFIG_DRM_MGAG200=3Dm
CONFIG_DRM_CIRRUS_QEMU=3Dm
CONFIG_DRM_QXL=3Dm
CONFIG_DRM_BOCHS=3Dm
CONFIG_DRM_VIRTIO_GPU=3Dm
CONFIG_DRM_PANEL=3Dy

#
# Display Panels
#
# CONFIG_DRM_PANEL_RASPBERRYPI_TOUCHSCREEN is not set
# end of Display Panels

CONFIG_DRM_BRIDGE=3Dy
CONFIG_DRM_PANEL_BRIDGE=3Dy

#
# Display Interface Bridges
#
# CONFIG_DRM_ANALOGIX_ANX78XX is not set
# end of Display Interface Bridges

# CONFIG_DRM_ETNAVIV is not set
# CONFIG_DRM_GM12U320 is not set
# CONFIG_TINYDRM_HX8357D is not set
# CONFIG_TINYDRM_ILI9225 is not set
# CONFIG_TINYDRM_ILI9341 is not set
# CONFIG_TINYDRM_MI0283QT is not set
# CONFIG_TINYDRM_REPAPER is not set
# CONFIG_TINYDRM_ST7586 is not set
# CONFIG_TINYDRM_ST7735R is not set
# CONFIG_DRM_XEN is not set
# CONFIG_DRM_VBOXVIDEO is not set
# CONFIG_DRM_LEGACY is not set
CONFIG_DRM_PANEL_ORIENTATION_QUIRKS=3Dy
CONFIG_DRM_LIB_RANDOM=3Dy

#
# Frame buffer Devices
#
CONFIG_FB_CMDLINE=3Dy
CONFIG_FB_NOTIFY=3Dy
CONFIG_FB=3Dy
# CONFIG_FIRMWARE_EDID is not set
CONFIG_FB_BOOT_VESA_SUPPORT=3Dy
CONFIG_FB_CFB_FILLRECT=3Dy
CONFIG_FB_CFB_COPYAREA=3Dy
CONFIG_FB_CFB_IMAGEBLIT=3Dy
CONFIG_FB_SYS_FILLRECT=3Dm
CONFIG_FB_SYS_COPYAREA=3Dm
CONFIG_FB_SYS_IMAGEBLIT=3Dm
# CONFIG_FB_FOREIGN_ENDIAN is not set
CONFIG_FB_SYS_FOPS=3Dm
CONFIG_FB_DEFERRED_IO=3Dy
# CONFIG_FB_MODE_HELPERS is not set
CONFIG_FB_TILEBLITTING=3Dy

#
# Frame buffer hardware drivers
#
# CONFIG_FB_CIRRUS is not set
# CONFIG_FB_PM2 is not set
# CONFIG_FB_CYBER2000 is not set
# CONFIG_FB_ARC is not set
# CONFIG_FB_ASILIANT is not set
# CONFIG_FB_IMSTT is not set
# CONFIG_FB_VGA16 is not set
# CONFIG_FB_UVESA is not set
CONFIG_FB_VESA=3Dy
CONFIG_FB_EFI=3Dy
# CONFIG_FB_N411 is not set
# CONFIG_FB_HGA is not set
# CONFIG_FB_OPENCORES is not set
# CONFIG_FB_S1D13XXX is not set
# CONFIG_FB_NVIDIA is not set
# CONFIG_FB_RIVA is not set
# CONFIG_FB_I740 is not set
# CONFIG_FB_LE80578 is not set
# CONFIG_FB_INTEL is not set
# CONFIG_FB_MATROX is not set
# CONFIG_FB_RADEON is not set
# CONFIG_FB_ATY128 is not set
# CONFIG_FB_ATY is not set
# CONFIG_FB_S3 is not set
# CONFIG_FB_SAVAGE is not set
# CONFIG_FB_SIS is not set
# CONFIG_FB_VIA is not set
# CONFIG_FB_NEOMAGIC is not set
# CONFIG_FB_KYRO is not set
# CONFIG_FB_3DFX is not set
# CONFIG_FB_VOODOO1 is not set
# CONFIG_FB_VT8623 is not set
# CONFIG_FB_TRIDENT is not set
# CONFIG_FB_ARK is not set
# CONFIG_FB_PM3 is not set
# CONFIG_FB_CARMINE is not set
# CONFIG_FB_SM501 is not set
# CONFIG_FB_SMSCUFX is not set
# CONFIG_FB_UDL is not set
# CONFIG_FB_IBM_GXT4500 is not set
# CONFIG_FB_VIRTUAL is not set
# CONFIG_XEN_FBDEV_FRONTEND is not set
# CONFIG_FB_METRONOME is not set
# CONFIG_FB_MB862XX is not set
CONFIG_FB_HYPERV=3Dm
# CONFIG_FB_SIMPLE is not set
# CONFIG_FB_SM712 is not set
# end of Frame buffer Devices

#
# Backlight & LCD device support
#
CONFIG_LCD_CLASS_DEVICE=3Dm
# CONFIG_LCD_L4F00242T03 is not set
# CONFIG_LCD_LMS283GF05 is not set
# CONFIG_LCD_LTV350QV is not set
# CONFIG_LCD_ILI922X is not set
# CONFIG_LCD_ILI9320 is not set
# CONFIG_LCD_TDO24M is not set
# CONFIG_LCD_VGG2432A4 is not set
CONFIG_LCD_PLATFORM=3Dm
# CONFIG_LCD_AMS369FG06 is not set
# CONFIG_LCD_LMS501KF03 is not set
# CONFIG_LCD_HX8357 is not set
# CONFIG_LCD_OTM3225A is not set
CONFIG_BACKLIGHT_CLASS_DEVICE=3Dy
# CONFIG_BACKLIGHT_GENERIC is not set
# CONFIG_BACKLIGHT_PWM is not set
CONFIG_BACKLIGHT_APPLE=3Dm
# CONFIG_BACKLIGHT_PM8941_WLED is not set
# CONFIG_BACKLIGHT_SAHARA is not set
# CONFIG_BACKLIGHT_ADP8860 is not set
# CONFIG_BACKLIGHT_ADP8870 is not set
# CONFIG_BACKLIGHT_LM3630A is not set
# CONFIG_BACKLIGHT_LM3639 is not set
CONFIG_BACKLIGHT_LP855X=3Dm
# CONFIG_BACKLIGHT_GPIO is not set
# CONFIG_BACKLIGHT_LV5207LP is not set
# CONFIG_BACKLIGHT_BD6107 is not set
# CONFIG_BACKLIGHT_ARCXCNN is not set
# end of Backlight & LCD device support

CONFIG_HDMI=3Dy

#
# Console display driver support
#
CONFIG_VGA_CONSOLE=3Dy
CONFIG_VGACON_SOFT_SCROLLBACK=3Dy
CONFIG_VGACON_SOFT_SCROLLBACK_SIZE=3D64
# CONFIG_VGACON_SOFT_SCROLLBACK_PERSISTENT_ENABLE_BY_DEFAULT is not set
CONFIG_DUMMY_CONSOLE=3Dy
CONFIG_DUMMY_CONSOLE_COLUMNS=3D80
CONFIG_DUMMY_CONSOLE_ROWS=3D25
CONFIG_FRAMEBUFFER_CONSOLE=3Dy
CONFIG_FRAMEBUFFER_CONSOLE_DETECT_PRIMARY=3Dy
CONFIG_FRAMEBUFFER_CONSOLE_ROTATION=3Dy
# CONFIG_FRAMEBUFFER_CONSOLE_DEFERRED_TAKEOVER is not set
# end of Console display driver support

CONFIG_LOGO=3Dy
# CONFIG_LOGO_LINUX_MONO is not set
# CONFIG_LOGO_LINUX_VGA16 is not set
CONFIG_LOGO_LINUX_CLUT224=3Dy
# end of Graphics support

CONFIG_SOUND=3Dm
CONFIG_SOUND_OSS_CORE=3Dy
CONFIG_SOUND_OSS_CORE_PRECLAIM=3Dy
CONFIG_SND=3Dm
CONFIG_SND_TIMER=3Dm
CONFIG_SND_PCM=3Dm
CONFIG_SND_PCM_ELD=3Dy
CONFIG_SND_HWDEP=3Dm
CONFIG_SND_SEQ_DEVICE=3Dm
CONFIG_SND_RAWMIDI=3Dm
CONFIG_SND_COMPRESS_OFFLOAD=3Dm
CONFIG_SND_JACK=3Dy
CONFIG_SND_JACK_INPUT_DEV=3Dy
CONFIG_SND_OSSEMUL=3Dy
# CONFIG_SND_MIXER_OSS is not set
# CONFIG_SND_PCM_OSS is not set
CONFIG_SND_PCM_TIMER=3Dy
CONFIG_SND_HRTIMER=3Dm
CONFIG_SND_DYNAMIC_MINORS=3Dy
CONFIG_SND_MAX_CARDS=3D32
# CONFIG_SND_SUPPORT_OLD_API is not set
CONFIG_SND_PROC_FS=3Dy
CONFIG_SND_VERBOSE_PROCFS=3Dy
# CONFIG_SND_VERBOSE_PRINTK is not set
# CONFIG_SND_DEBUG is not set
CONFIG_SND_VMASTER=3Dy
CONFIG_SND_DMA_SGBUF=3Dy
CONFIG_SND_SEQUENCER=3Dm
CONFIG_SND_SEQ_DUMMY=3Dm
CONFIG_SND_SEQUENCER_OSS=3Dm
CONFIG_SND_SEQ_HRTIMER_DEFAULT=3Dy
CONFIG_SND_SEQ_MIDI_EVENT=3Dm
CONFIG_SND_SEQ_MIDI=3Dm
CONFIG_SND_SEQ_MIDI_EMUL=3Dm
CONFIG_SND_SEQ_VIRMIDI=3Dm
CONFIG_SND_MPU401_UART=3Dm
CONFIG_SND_OPL3_LIB=3Dm
CONFIG_SND_OPL3_LIB_SEQ=3Dm
CONFIG_SND_VX_LIB=3Dm
CONFIG_SND_AC97_CODEC=3Dm
CONFIG_SND_DRIVERS=3Dy
CONFIG_SND_PCSP=3Dm
CONFIG_SND_DUMMY=3Dm
CONFIG_SND_ALOOP=3Dm
CONFIG_SND_VIRMIDI=3Dm
CONFIG_SND_MTPAV=3Dm
# CONFIG_SND_MTS64 is not set
# CONFIG_SND_SERIAL_U16550 is not set
CONFIG_SND_MPU401=3Dm
# CONFIG_SND_PORTMAN2X4 is not set
CONFIG_SND_AC97_POWER_SAVE=3Dy
CONFIG_SND_AC97_POWER_SAVE_DEFAULT=3D5
CONFIG_SND_PCI=3Dy
CONFIG_SND_AD1889=3Dm
# CONFIG_SND_ALS300 is not set
# CONFIG_SND_ALS4000 is not set
CONFIG_SND_ALI5451=3Dm
CONFIG_SND_ASIHPI=3Dm
CONFIG_SND_ATIIXP=3Dm
CONFIG_SND_ATIIXP_MODEM=3Dm
CONFIG_SND_AU8810=3Dm
CONFIG_SND_AU8820=3Dm
CONFIG_SND_AU8830=3Dm
# CONFIG_SND_AW2 is not set
# CONFIG_SND_AZT3328 is not set
CONFIG_SND_BT87X=3Dm
# CONFIG_SND_BT87X_OVERCLOCK is not set
CONFIG_SND_CA0106=3Dm
CONFIG_SND_CMIPCI=3Dm
CONFIG_SND_OXYGEN_LIB=3Dm
CONFIG_SND_OXYGEN=3Dm
# CONFIG_SND_CS4281 is not set
CONFIG_SND_CS46XX=3Dm
CONFIG_SND_CS46XX_NEW_DSP=3Dy
CONFIG_SND_CTXFI=3Dm
CONFIG_SND_DARLA20=3Dm
CONFIG_SND_GINA20=3Dm
CONFIG_SND_LAYLA20=3Dm
CONFIG_SND_DARLA24=3Dm
CONFIG_SND_GINA24=3Dm
CONFIG_SND_LAYLA24=3Dm
CONFIG_SND_MONA=3Dm
CONFIG_SND_MIA=3Dm
CONFIG_SND_ECHO3G=3Dm
CONFIG_SND_INDIGO=3Dm
CONFIG_SND_INDIGOIO=3Dm
CONFIG_SND_INDIGODJ=3Dm
CONFIG_SND_INDIGOIOX=3Dm
CONFIG_SND_INDIGODJX=3Dm
CONFIG_SND_EMU10K1=3Dm
CONFIG_SND_EMU10K1_SEQ=3Dm
CONFIG_SND_EMU10K1X=3Dm
CONFIG_SND_ENS1370=3Dm
CONFIG_SND_ENS1371=3Dm
# CONFIG_SND_ES1938 is not set
CONFIG_SND_ES1968=3Dm
CONFIG_SND_ES1968_INPUT=3Dy
CONFIG_SND_ES1968_RADIO=3Dy
# CONFIG_SND_FM801 is not set
CONFIG_SND_HDSP=3Dm
CONFIG_SND_HDSPM=3Dm
CONFIG_SND_ICE1712=3Dm
CONFIG_SND_ICE1724=3Dm
CONFIG_SND_INTEL8X0=3Dm
CONFIG_SND_INTEL8X0M=3Dm
CONFIG_SND_KORG1212=3Dm
CONFIG_SND_LOLA=3Dm
CONFIG_SND_LX6464ES=3Dm
CONFIG_SND_MAESTRO3=3Dm
CONFIG_SND_MAESTRO3_INPUT=3Dy
CONFIG_SND_MIXART=3Dm
# CONFIG_SND_NM256 is not set
CONFIG_SND_PCXHR=3Dm
# CONFIG_SND_RIPTIDE is not set
CONFIG_SND_RME32=3Dm
CONFIG_SND_RME96=3Dm
CONFIG_SND_RME9652=3Dm
# CONFIG_SND_SONICVIBES is not set
CONFIG_SND_TRIDENT=3Dm
CONFIG_SND_VIA82XX=3Dm
CONFIG_SND_VIA82XX_MODEM=3Dm
CONFIG_SND_VIRTUOSO=3Dm
CONFIG_SND_VX222=3Dm
# CONFIG_SND_YMFPCI is not set

#
# HD-Audio
#
CONFIG_SND_HDA=3Dm
CONFIG_SND_HDA_INTEL=3Dm
# CONFIG_SND_HDA_INTEL_DETECT_DMIC is not set
CONFIG_SND_HDA_HWDEP=3Dy
CONFIG_SND_HDA_RECONFIG=3Dy
CONFIG_SND_HDA_INPUT_BEEP=3Dy
CONFIG_SND_HDA_INPUT_BEEP_MODE=3D0
CONFIG_SND_HDA_PATCH_LOADER=3Dy
CONFIG_SND_HDA_CODEC_REALTEK=3Dm
CONFIG_SND_HDA_CODEC_ANALOG=3Dm
CONFIG_SND_HDA_CODEC_SIGMATEL=3Dm
CONFIG_SND_HDA_CODEC_VIA=3Dm
CONFIG_SND_HDA_CODEC_HDMI=3Dm
CONFIG_SND_HDA_CODEC_CIRRUS=3Dm
CONFIG_SND_HDA_CODEC_CONEXANT=3Dm
CONFIG_SND_HDA_CODEC_CA0110=3Dm
CONFIG_SND_HDA_CODEC_CA0132=3Dm
CONFIG_SND_HDA_CODEC_CA0132_DSP=3Dy
CONFIG_SND_HDA_CODEC_CMEDIA=3Dm
CONFIG_SND_HDA_CODEC_SI3054=3Dm
CONFIG_SND_HDA_GENERIC=3Dm
CONFIG_SND_HDA_POWER_SAVE_DEFAULT=3D0
# end of HD-Audio

CONFIG_SND_HDA_CORE=3Dm
CONFIG_SND_HDA_DSP_LOADER=3Dy
CONFIG_SND_HDA_COMPONENT=3Dy
CONFIG_SND_HDA_I915=3Dy
CONFIG_SND_HDA_EXT_CORE=3Dm
CONFIG_SND_HDA_PREALLOC_SIZE=3D512
CONFIG_SND_INTEL_NHLT=3Dm
# CONFIG_SND_SPI is not set
CONFIG_SND_USB=3Dy
CONFIG_SND_USB_AUDIO=3Dm
CONFIG_SND_USB_AUDIO_USE_MEDIA_CONTROLLER=3Dy
CONFIG_SND_USB_UA101=3Dm
CONFIG_SND_USB_USX2Y=3Dm
CONFIG_SND_USB_CAIAQ=3Dm
CONFIG_SND_USB_CAIAQ_INPUT=3Dy
CONFIG_SND_USB_US122L=3Dm
CONFIG_SND_USB_6FIRE=3Dm
CONFIG_SND_USB_HIFACE=3Dm
CONFIG_SND_BCD2000=3Dm
CONFIG_SND_USB_LINE6=3Dm
CONFIG_SND_USB_POD=3Dm
CONFIG_SND_USB_PODHD=3Dm
CONFIG_SND_USB_TONEPORT=3Dm
CONFIG_SND_USB_VARIAX=3Dm
CONFIG_SND_FIREWIRE=3Dy
CONFIG_SND_FIREWIRE_LIB=3Dm
# CONFIG_SND_DICE is not set
# CONFIG_SND_OXFW is not set
CONFIG_SND_ISIGHT=3Dm
# CONFIG_SND_FIREWORKS is not set
# CONFIG_SND_BEBOB is not set
# CONFIG_SND_FIREWIRE_DIGI00X is not set
# CONFIG_SND_FIREWIRE_TASCAM is not set
# CONFIG_SND_FIREWIRE_MOTU is not set
# CONFIG_SND_FIREFACE is not set
CONFIG_SND_SOC=3Dm
CONFIG_SND_SOC_COMPRESS=3Dy
CONFIG_SND_SOC_TOPOLOGY=3Dy
CONFIG_SND_SOC_ACPI=3Dm
# CONFIG_SND_SOC_AMD_ACP is not set
# CONFIG_SND_SOC_AMD_ACP3x is not set
# CONFIG_SND_ATMEL_SOC is not set
# CONFIG_SND_DESIGNWARE_I2S is not set

#
# SoC Audio for Freescale CPUs
#

#
# Common SoC Audio options for Freescale CPUs:
#
# CONFIG_SND_SOC_FSL_ASRC is not set
# CONFIG_SND_SOC_FSL_SAI is not set
# CONFIG_SND_SOC_FSL_AUDMIX is not set
# CONFIG_SND_SOC_FSL_SSI is not set
# CONFIG_SND_SOC_FSL_SPDIF is not set
# CONFIG_SND_SOC_FSL_ESAI is not set
# CONFIG_SND_SOC_FSL_MICFIL is not set
# CONFIG_SND_SOC_IMX_AUDMUX is not set
# end of SoC Audio for Freescale CPUs

# CONFIG_SND_I2S_HI6210_I2S is not set
# CONFIG_SND_SOC_IMG is not set
CONFIG_SND_SOC_INTEL_SST_TOPLEVEL=3Dy
CONFIG_SND_SST_IPC=3Dm
CONFIG_SND_SST_IPC_ACPI=3Dm
CONFIG_SND_SOC_INTEL_SST_ACPI=3Dm
CONFIG_SND_SOC_INTEL_SST=3Dm
CONFIG_SND_SOC_INTEL_SST_FIRMWARE=3Dm
CONFIG_SND_SOC_INTEL_HASWELL=3Dm
CONFIG_SND_SST_ATOM_HIFI2_PLATFORM=3Dm
# CONFIG_SND_SST_ATOM_HIFI2_PLATFORM_PCI is not set
CONFIG_SND_SST_ATOM_HIFI2_PLATFORM_ACPI=3Dm
CONFIG_SND_SOC_INTEL_SKYLAKE=3Dm
CONFIG_SND_SOC_INTEL_SKL=3Dm
CONFIG_SND_SOC_INTEL_APL=3Dm
CONFIG_SND_SOC_INTEL_KBL=3Dm
CONFIG_SND_SOC_INTEL_GLK=3Dm
CONFIG_SND_SOC_INTEL_CNL=3Dm
CONFIG_SND_SOC_INTEL_CFL=3Dm
# CONFIG_SND_SOC_INTEL_CML_H is not set
# CONFIG_SND_SOC_INTEL_CML_LP is not set
CONFIG_SND_SOC_INTEL_SKYLAKE_FAMILY=3Dm
CONFIG_SND_SOC_INTEL_SKYLAKE_SSP_CLK=3Dm
# CONFIG_SND_SOC_INTEL_SKYLAKE_HDAUDIO_CODEC is not set
CONFIG_SND_SOC_INTEL_SKYLAKE_COMMON=3Dm
CONFIG_SND_SOC_ACPI_INTEL_MATCH=3Dm
CONFIG_SND_SOC_INTEL_MACH=3Dy
CONFIG_SND_SOC_INTEL_HASWELL_MACH=3Dm
CONFIG_SND_SOC_INTEL_BDW_RT5677_MACH=3Dm
CONFIG_SND_SOC_INTEL_BROADWELL_MACH=3Dm
CONFIG_SND_SOC_INTEL_BYTCR_RT5640_MACH=3Dm
CONFIG_SND_SOC_INTEL_BYTCR_RT5651_MACH=3Dm
CONFIG_SND_SOC_INTEL_CHT_BSW_RT5672_MACH=3Dm
CONFIG_SND_SOC_INTEL_CHT_BSW_RT5645_MACH=3Dm
CONFIG_SND_SOC_INTEL_CHT_BSW_MAX98090_TI_MACH=3Dm
# CONFIG_SND_SOC_INTEL_CHT_BSW_NAU8824_MACH is not set
# CONFIG_SND_SOC_INTEL_BYT_CHT_CX2072X_MACH is not set
CONFIG_SND_SOC_INTEL_BYT_CHT_DA7213_MACH=3Dm
CONFIG_SND_SOC_INTEL_BYT_CHT_ES8316_MACH=3Dm
CONFIG_SND_SOC_INTEL_BYT_CHT_NOCODEC_MACH=3Dm
CONFIG_SND_SOC_INTEL_SKL_RT286_MACH=3Dm
CONFIG_SND_SOC_INTEL_SKL_NAU88L25_SSM4567_MACH=3Dm
CONFIG_SND_SOC_INTEL_SKL_NAU88L25_MAX98357A_MACH=3Dm
CONFIG_SND_SOC_INTEL_DA7219_MAX98357A_GENERIC=3Dm
CONFIG_SND_SOC_INTEL_BXT_DA7219_MAX98357A_MACH=3Dm
CONFIG_SND_SOC_INTEL_BXT_RT298_MACH=3Dm
CONFIG_SND_SOC_INTEL_KBL_RT5663_MAX98927_MACH=3Dm
CONFIG_SND_SOC_INTEL_KBL_RT5663_RT5514_MAX98927_MACH=3Dm
# CONFIG_SND_SOC_INTEL_KBL_DA7219_MAX98357A_MACH is not set
# CONFIG_SND_SOC_INTEL_KBL_DA7219_MAX98927_MACH is not set
# CONFIG_SND_SOC_INTEL_KBL_RT5660_MACH is not set
# CONFIG_SND_SOC_INTEL_GLK_RT5682_MAX98357A_MACH is not set
# CONFIG_SND_SOC_MTK_BTCVSD is not set
# CONFIG_SND_SOC_SOF_TOPLEVEL is not set

#
# STMicroelectronics STM32 SOC audio support
#
# end of STMicroelectronics STM32 SOC audio support

# CONFIG_SND_SOC_XILINX_I2S is not set
# CONFIG_SND_SOC_XILINX_AUDIO_FORMATTER is not set
# CONFIG_SND_SOC_XILINX_SPDIF is not set
# CONFIG_SND_SOC_XTFPGA_I2S is not set
# CONFIG_ZX_TDM is not set
CONFIG_SND_SOC_I2C_AND_SPI=3Dm

#
# CODEC drivers
#
# CONFIG_SND_SOC_AC97_CODEC is not set
# CONFIG_SND_SOC_ADAU1701 is not set
# CONFIG_SND_SOC_ADAU1761_I2C is not set
# CONFIG_SND_SOC_ADAU1761_SPI is not set
# CONFIG_SND_SOC_ADAU7002 is not set
# CONFIG_SND_SOC_AK4104 is not set
# CONFIG_SND_SOC_AK4118 is not set
# CONFIG_SND_SOC_AK4458 is not set
# CONFIG_SND_SOC_AK4554 is not set
# CONFIG_SND_SOC_AK4613 is not set
# CONFIG_SND_SOC_AK4642 is not set
# CONFIG_SND_SOC_AK5386 is not set
# CONFIG_SND_SOC_AK5558 is not set
# CONFIG_SND_SOC_ALC5623 is not set
# CONFIG_SND_SOC_BD28623 is not set
# CONFIG_SND_SOC_BT_SCO is not set
# CONFIG_SND_SOC_CS35L32 is not set
# CONFIG_SND_SOC_CS35L33 is not set
# CONFIG_SND_SOC_CS35L34 is not set
# CONFIG_SND_SOC_CS35L35 is not set
# CONFIG_SND_SOC_CS35L36 is not set
# CONFIG_SND_SOC_CS42L42 is not set
# CONFIG_SND_SOC_CS42L51_I2C is not set
# CONFIG_SND_SOC_CS42L52 is not set
# CONFIG_SND_SOC_CS42L56 is not set
# CONFIG_SND_SOC_CS42L73 is not set
# CONFIG_SND_SOC_CS4265 is not set
# CONFIG_SND_SOC_CS4270 is not set
# CONFIG_SND_SOC_CS4271_I2C is not set
# CONFIG_SND_SOC_CS4271_SPI is not set
# CONFIG_SND_SOC_CS42XX8_I2C is not set
# CONFIG_SND_SOC_CS43130 is not set
# CONFIG_SND_SOC_CS4341 is not set
# CONFIG_SND_SOC_CS4349 is not set
# CONFIG_SND_SOC_CS53L30 is not set
# CONFIG_SND_SOC_CX2072X is not set
CONFIG_SND_SOC_DA7213=3Dm
CONFIG_SND_SOC_DA7219=3Dm
CONFIG_SND_SOC_DMIC=3Dm
# CONFIG_SND_SOC_ES7134 is not set
# CONFIG_SND_SOC_ES7241 is not set
CONFIG_SND_SOC_ES8316=3Dm
# CONFIG_SND_SOC_ES8328_I2C is not set
# CONFIG_SND_SOC_ES8328_SPI is not set
# CONFIG_SND_SOC_GTM601 is not set
CONFIG_SND_SOC_HDAC_HDMI=3Dm
# CONFIG_SND_SOC_INNO_RK3036 is not set
# CONFIG_SND_SOC_MAX98088 is not set
CONFIG_SND_SOC_MAX98090=3Dm
CONFIG_SND_SOC_MAX98357A=3Dm
# CONFIG_SND_SOC_MAX98504 is not set
# CONFIG_SND_SOC_MAX9867 is not set
CONFIG_SND_SOC_MAX98927=3Dm
# CONFIG_SND_SOC_MAX98373 is not set
# CONFIG_SND_SOC_MAX9860 is not set
# CONFIG_SND_SOC_MSM8916_WCD_DIGITAL is not set
# CONFIG_SND_SOC_PCM1681 is not set
# CONFIG_SND_SOC_PCM1789_I2C is not set
# CONFIG_SND_SOC_PCM179X_I2C is not set
# CONFIG_SND_SOC_PCM179X_SPI is not set
# CONFIG_SND_SOC_PCM186X_I2C is not set
# CONFIG_SND_SOC_PCM186X_SPI is not set
# CONFIG_SND_SOC_PCM3060_I2C is not set
# CONFIG_SND_SOC_PCM3060_SPI is not set
# CONFIG_SND_SOC_PCM3168A_I2C is not set
# CONFIG_SND_SOC_PCM3168A_SPI is not set
# CONFIG_SND_SOC_PCM512x_I2C is not set
# CONFIG_SND_SOC_PCM512x_SPI is not set
# CONFIG_SND_SOC_RK3328 is not set
CONFIG_SND_SOC_RL6231=3Dm
CONFIG_SND_SOC_RL6347A=3Dm
CONFIG_SND_SOC_RT286=3Dm
CONFIG_SND_SOC_RT298=3Dm
CONFIG_SND_SOC_RT5514=3Dm
CONFIG_SND_SOC_RT5514_SPI=3Dm
# CONFIG_SND_SOC_RT5616 is not set
# CONFIG_SND_SOC_RT5631 is not set
CONFIG_SND_SOC_RT5640=3Dm
CONFIG_SND_SOC_RT5645=3Dm
CONFIG_SND_SOC_RT5651=3Dm
CONFIG_SND_SOC_RT5663=3Dm
CONFIG_SND_SOC_RT5670=3Dm
CONFIG_SND_SOC_RT5677=3Dm
CONFIG_SND_SOC_RT5677_SPI=3Dm
# CONFIG_SND_SOC_SGTL5000 is not set
# CONFIG_SND_SOC_SIMPLE_AMPLIFIER is not set
# CONFIG_SND_SOC_SIRF_AUDIO_CODEC is not set
# CONFIG_SND_SOC_SPDIF is not set
# CONFIG_SND_SOC_SSM2305 is not set
# CONFIG_SND_SOC_SSM2602_SPI is not set
# CONFIG_SND_SOC_SSM2602_I2C is not set
CONFIG_SND_SOC_SSM4567=3Dm
# CONFIG_SND_SOC_STA32X is not set
# CONFIG_SND_SOC_STA350 is not set
# CONFIG_SND_SOC_STI_SAS is not set
# CONFIG_SND_SOC_TAS2552 is not set
# CONFIG_SND_SOC_TAS5086 is not set
# CONFIG_SND_SOC_TAS571X is not set
# CONFIG_SND_SOC_TAS5720 is not set
# CONFIG_SND_SOC_TAS6424 is not set
# CONFIG_SND_SOC_TDA7419 is not set
# CONFIG_SND_SOC_TFA9879 is not set
# CONFIG_SND_SOC_TLV320AIC23_I2C is not set
# CONFIG_SND_SOC_TLV320AIC23_SPI is not set
# CONFIG_SND_SOC_TLV320AIC31XX is not set
# CONFIG_SND_SOC_TLV320AIC32X4_I2C is not set
# CONFIG_SND_SOC_TLV320AIC32X4_SPI is not set
# CONFIG_SND_SOC_TLV320AIC3X is not set
CONFIG_SND_SOC_TS3A227E=3Dm
# CONFIG_SND_SOC_TSCS42XX is not set
# CONFIG_SND_SOC_TSCS454 is not set
# CONFIG_SND_SOC_UDA1334 is not set
# CONFIG_SND_SOC_WM8510 is not set
# CONFIG_SND_SOC_WM8523 is not set
# CONFIG_SND_SOC_WM8524 is not set
# CONFIG_SND_SOC_WM8580 is not set
# CONFIG_SND_SOC_WM8711 is not set
# CONFIG_SND_SOC_WM8728 is not set
# CONFIG_SND_SOC_WM8731 is not set
# CONFIG_SND_SOC_WM8737 is not set
# CONFIG_SND_SOC_WM8741 is not set
# CONFIG_SND_SOC_WM8750 is not set
# CONFIG_SND_SOC_WM8753 is not set
# CONFIG_SND_SOC_WM8770 is not set
# CONFIG_SND_SOC_WM8776 is not set
# CONFIG_SND_SOC_WM8782 is not set
# CONFIG_SND_SOC_WM8804_I2C is not set
# CONFIG_SND_SOC_WM8804_SPI is not set
# CONFIG_SND_SOC_WM8903 is not set
# CONFIG_SND_SOC_WM8904 is not set
# CONFIG_SND_SOC_WM8960 is not set
# CONFIG_SND_SOC_WM8962 is not set
# CONFIG_SND_SOC_WM8974 is not set
# CONFIG_SND_SOC_WM8978 is not set
# CONFIG_SND_SOC_WM8985 is not set
# CONFIG_SND_SOC_ZX_AUD96P22 is not set
# CONFIG_SND_SOC_MAX9759 is not set
# CONFIG_SND_SOC_MT6351 is not set
# CONFIG_SND_SOC_MT6358 is not set
# CONFIG_SND_SOC_NAU8540 is not set
# CONFIG_SND_SOC_NAU8810 is not set
# CONFIG_SND_SOC_NAU8822 is not set
CONFIG_SND_SOC_NAU8824=3Dm
CONFIG_SND_SOC_NAU8825=3Dm
# CONFIG_SND_SOC_TPA6130A2 is not set
# end of CODEC drivers

# CONFIG_SND_SIMPLE_CARD is not set
CONFIG_SND_X86=3Dy
CONFIG_HDMI_LPE_AUDIO=3Dm
CONFIG_SND_SYNTH_EMUX=3Dm
# CONFIG_SND_XEN_FRONTEND is not set
CONFIG_AC97_BUS=3Dm

#
# HID support
#
CONFIG_HID=3Dy
CONFIG_HID_BATTERY_STRENGTH=3Dy
CONFIG_HIDRAW=3Dy
CONFIG_UHID=3Dm
CONFIG_HID_GENERIC=3Dy

#
# Special HID drivers
#
CONFIG_HID_A4TECH=3Dy
# CONFIG_HID_ACCUTOUCH is not set
CONFIG_HID_ACRUX=3Dm
# CONFIG_HID_ACRUX_FF is not set
CONFIG_HID_APPLE=3Dy
CONFIG_HID_APPLEIR=3Dm
# CONFIG_HID_ASUS is not set
CONFIG_HID_AUREAL=3Dm
CONFIG_HID_BELKIN=3Dy
# CONFIG_HID_BETOP_FF is not set
# CONFIG_HID_BIGBEN_FF is not set
CONFIG_HID_CHERRY=3Dy
CONFIG_HID_CHICONY=3Dy
# CONFIG_HID_CORSAIR is not set
# CONFIG_HID_COUGAR is not set
# CONFIG_HID_MACALLY is not set
CONFIG_HID_PRODIKEYS=3Dm
# CONFIG_HID_CMEDIA is not set
# CONFIG_HID_CP2112 is not set
# CONFIG_HID_CREATIVE_SB0540 is not set
CONFIG_HID_CYPRESS=3Dy
CONFIG_HID_DRAGONRISE=3Dm
# CONFIG_DRAGONRISE_FF is not set
# CONFIG_HID_EMS_FF is not set
# CONFIG_HID_ELAN is not set
CONFIG_HID_ELECOM=3Dm
# CONFIG_HID_ELO is not set
CONFIG_HID_EZKEY=3Dy
# CONFIG_HID_GEMBIRD is not set
# CONFIG_HID_GFRM is not set
CONFIG_HID_HOLTEK=3Dm
# CONFIG_HOLTEK_FF is not set
# CONFIG_HID_GT683R is not set
CONFIG_HID_KEYTOUCH=3Dm
CONFIG_HID_KYE=3Dm
CONFIG_HID_UCLOGIC=3Dm
CONFIG_HID_WALTOP=3Dm
# CONFIG_HID_VIEWSONIC is not set
CONFIG_HID_GYRATION=3Dm
CONFIG_HID_ICADE=3Dm
CONFIG_HID_ITE=3Dy
# CONFIG_HID_JABRA is not set
CONFIG_HID_TWINHAN=3Dm
CONFIG_HID_KENSINGTON=3Dy
CONFIG_HID_LCPOWER=3Dm
CONFIG_HID_LED=3Dm
# CONFIG_HID_LENOVO is not set
CONFIG_HID_LOGITECH=3Dy
CONFIG_HID_LOGITECH_DJ=3Dm
CONFIG_HID_LOGITECH_HIDPP=3Dm
# CONFIG_LOGITECH_FF is not set
# CONFIG_LOGIRUMBLEPAD2_FF is not set
# CONFIG_LOGIG940_FF is not set
# CONFIG_LOGIWHEELS_FF is not set
CONFIG_HID_MAGICMOUSE=3Dy
# CONFIG_HID_MALTRON is not set
# CONFIG_HID_MAYFLASH is not set
CONFIG_HID_REDRAGON=3Dy
CONFIG_HID_MICROSOFT=3Dy
CONFIG_HID_MONTEREY=3Dy
CONFIG_HID_MULTITOUCH=3Dm
# CONFIG_HID_NTI is not set
CONFIG_HID_NTRIG=3Dy
CONFIG_HID_ORTEK=3Dm
CONFIG_HID_PANTHERLORD=3Dm
# CONFIG_PANTHERLORD_FF is not set
# CONFIG_HID_PENMOUNT is not set
CONFIG_HID_PETALYNX=3Dm
CONFIG_HID_PICOLCD=3Dm
CONFIG_HID_PICOLCD_FB=3Dy
CONFIG_HID_PICOLCD_BACKLIGHT=3Dy
CONFIG_HID_PICOLCD_LCD=3Dy
CONFIG_HID_PICOLCD_LEDS=3Dy
CONFIG_HID_PICOLCD_CIR=3Dy
CONFIG_HID_PLANTRONICS=3Dy
CONFIG_HID_PRIMAX=3Dm
# CONFIG_HID_RETRODE is not set
CONFIG_HID_ROCCAT=3Dm
CONFIG_HID_SAITEK=3Dm
CONFIG_HID_SAMSUNG=3Dm
CONFIG_HID_SONY=3Dm
# CONFIG_SONY_FF is not set
CONFIG_HID_SPEEDLINK=3Dm
# CONFIG_HID_STEAM is not set
CONFIG_HID_STEELSERIES=3Dm
CONFIG_HID_SUNPLUS=3Dm
CONFIG_HID_RMI=3Dm
CONFIG_HID_GREENASIA=3Dm
# CONFIG_GREENASIA_FF is not set
CONFIG_HID_HYPERV_MOUSE=3Dm
CONFIG_HID_SMARTJOYPLUS=3Dm
# CONFIG_SMARTJOYPLUS_FF is not set
CONFIG_HID_TIVO=3Dm
CONFIG_HID_TOPSEED=3Dm
CONFIG_HID_THINGM=3Dm
CONFIG_HID_THRUSTMASTER=3Dm
# CONFIG_THRUSTMASTER_FF is not set
# CONFIG_HID_UDRAW_PS3 is not set
# CONFIG_HID_U2FZERO is not set
CONFIG_HID_WACOM=3Dm
CONFIG_HID_WIIMOTE=3Dm
# CONFIG_HID_XINMO is not set
CONFIG_HID_ZEROPLUS=3Dm
# CONFIG_ZEROPLUS_FF is not set
CONFIG_HID_ZYDACRON=3Dm
CONFIG_HID_SENSOR_HUB=3Dm
CONFIG_HID_SENSOR_CUSTOM_SENSOR=3Dm
CONFIG_HID_ALPS=3Dm
# end of Special HID drivers

#
# USB HID support
#
CONFIG_USB_HID=3Dy
CONFIG_HID_PID=3Dy
CONFIG_USB_HIDDEV=3Dy
# end of USB HID support

#
# I2C HID support
#
CONFIG_I2C_HID=3Dm
# end of I2C HID support

#
# Intel ISH HID support
#
CONFIG_INTEL_ISH_HID=3Dy
# CONFIG_INTEL_ISH_FIRMWARE_DOWNLOADER is not set
# end of Intel ISH HID support
# end of HID support

CONFIG_USB_OHCI_LITTLE_ENDIAN=3Dy
CONFIG_USB_SUPPORT=3Dy
CONFIG_USB_COMMON=3Dy
# CONFIG_USB_LED_TRIG is not set
# CONFIG_USB_ULPI_BUS is not set
# CONFIG_USB_CONN_GPIO is not set
CONFIG_USB_ARCH_HAS_HCD=3Dy
CONFIG_USB=3Dy
CONFIG_USB_PCI=3Dy
CONFIG_USB_ANNOUNCE_NEW_DEVICES=3Dy

#
# Miscellaneous USB options
#
CONFIG_USB_DEFAULT_PERSIST=3Dy
# CONFIG_USB_DYNAMIC_MINORS is not set
# CONFIG_USB_OTG is not set
# CONFIG_USB_OTG_WHITELIST is not set
# CONFIG_USB_OTG_BLACKLIST_HUB is not set
CONFIG_USB_LEDS_TRIGGER_USBPORT=3Dm
CONFIG_USB_AUTOSUSPEND_DELAY=3D2
CONFIG_USB_MON=3Dy

#
# USB Host Controller Drivers
#
# CONFIG_USB_C67X00_HCD is not set
CONFIG_USB_XHCI_HCD=3Dy
# CONFIG_USB_XHCI_DBGCAP is not set
CONFIG_USB_XHCI_PCI=3Dy
# CONFIG_USB_XHCI_PLATFORM is not set
CONFIG_USB_EHCI_HCD=3Dy
CONFIG_USB_EHCI_ROOT_HUB_TT=3Dy
CONFIG_USB_EHCI_TT_NEWSCHED=3Dy
CONFIG_USB_EHCI_PCI=3Dy
# CONFIG_USB_EHCI_FSL is not set
# CONFIG_USB_EHCI_HCD_PLATFORM is not set
# CONFIG_USB_OXU210HP_HCD is not set
# CONFIG_USB_ISP116X_HCD is not set
# CONFIG_USB_FOTG210_HCD is not set
# CONFIG_USB_MAX3421_HCD is not set
CONFIG_USB_OHCI_HCD=3Dy
CONFIG_USB_OHCI_HCD_PCI=3Dy
# CONFIG_USB_OHCI_HCD_PLATFORM is not set
CONFIG_USB_UHCI_HCD=3Dy
# CONFIG_USB_U132_HCD is not set
# CONFIG_USB_SL811_HCD is not set
# CONFIG_USB_R8A66597_HCD is not set
# CONFIG_USB_HCD_BCMA is not set
# CONFIG_USB_HCD_SSB is not set
# CONFIG_USB_HCD_TEST_MODE is not set

#
# USB Device Class drivers
#
CONFIG_USB_ACM=3Dm
CONFIG_USB_PRINTER=3Dm
CONFIG_USB_WDM=3Dm
CONFIG_USB_TMC=3Dm

#
# NOTE: USB_STORAGE depends on SCSI but BLK_DEV_SD may
#

#
# also be needed; see USB_STORAGE Help for more info
#
CONFIG_USB_STORAGE=3Dm
# CONFIG_USB_STORAGE_DEBUG is not set
CONFIG_USB_STORAGE_REALTEK=3Dm
CONFIG_REALTEK_AUTOPM=3Dy
CONFIG_USB_STORAGE_DATAFAB=3Dm
CONFIG_USB_STORAGE_FREECOM=3Dm
CONFIG_USB_STORAGE_ISD200=3Dm
CONFIG_USB_STORAGE_USBAT=3Dm
CONFIG_USB_STORAGE_SDDR09=3Dm
CONFIG_USB_STORAGE_SDDR55=3Dm
CONFIG_USB_STORAGE_JUMPSHOT=3Dm
CONFIG_USB_STORAGE_ALAUDA=3Dm
CONFIG_USB_STORAGE_ONETOUCH=3Dm
CONFIG_USB_STORAGE_KARMA=3Dm
CONFIG_USB_STORAGE_CYPRESS_ATACB=3Dm
CONFIG_USB_STORAGE_ENE_UB6250=3Dm
CONFIG_USB_UAS=3Dm

#
# USB Imaging devices
#
CONFIG_USB_MDC800=3Dm
CONFIG_USB_MICROTEK=3Dm
CONFIG_USBIP_CORE=3Dm
# CONFIG_USBIP_VHCI_HCD is not set
# CONFIG_USBIP_HOST is not set
# CONFIG_USBIP_DEBUG is not set
# CONFIG_USB_CDNS3 is not set
# CONFIG_USB_MUSB_HDRC is not set
# CONFIG_USB_DWC3 is not set
# CONFIG_USB_DWC2 is not set
# CONFIG_USB_CHIPIDEA is not set
# CONFIG_USB_ISP1760 is not set

#
# USB port drivers
#
CONFIG_USB_USS720=3Dm
CONFIG_USB_SERIAL=3Dy
CONFIG_USB_SERIAL_CONSOLE=3Dy
CONFIG_USB_SERIAL_GENERIC=3Dy
# CONFIG_USB_SERIAL_SIMPLE is not set
CONFIG_USB_SERIAL_AIRCABLE=3Dm
CONFIG_USB_SERIAL_ARK3116=3Dm
CONFIG_USB_SERIAL_BELKIN=3Dm
CONFIG_USB_SERIAL_CH341=3Dm
CONFIG_USB_SERIAL_WHITEHEAT=3Dm
CONFIG_USB_SERIAL_DIGI_ACCELEPORT=3Dm
CONFIG_USB_SERIAL_CP210X=3Dm
CONFIG_USB_SERIAL_CYPRESS_M8=3Dm
CONFIG_USB_SERIAL_EMPEG=3Dm
CONFIG_USB_SERIAL_FTDI_SIO=3Dm
CONFIG_USB_SERIAL_VISOR=3Dm
CONFIG_USB_SERIAL_IPAQ=3Dm
CONFIG_USB_SERIAL_IR=3Dm
CONFIG_USB_SERIAL_EDGEPORT=3Dm
CONFIG_USB_SERIAL_EDGEPORT_TI=3Dm
# CONFIG_USB_SERIAL_F81232 is not set
# CONFIG_USB_SERIAL_F8153X is not set
CONFIG_USB_SERIAL_GARMIN=3Dm
CONFIG_USB_SERIAL_IPW=3Dm
CONFIG_USB_SERIAL_IUU=3Dm
CONFIG_USB_SERIAL_KEYSPAN_PDA=3Dm
CONFIG_USB_SERIAL_KEYSPAN=3Dm
CONFIG_USB_SERIAL_KLSI=3Dm
CONFIG_USB_SERIAL_KOBIL_SCT=3Dm
CONFIG_USB_SERIAL_MCT_U232=3Dm
# CONFIG_USB_SERIAL_METRO is not set
CONFIG_USB_SERIAL_MOS7720=3Dm
CONFIG_USB_SERIAL_MOS7715_PARPORT=3Dy
CONFIG_USB_SERIAL_MOS7840=3Dm
# CONFIG_USB_SERIAL_MXUPORT is not set
CONFIG_USB_SERIAL_NAVMAN=3Dm
CONFIG_USB_SERIAL_PL2303=3Dm
CONFIG_USB_SERIAL_OTI6858=3Dm
CONFIG_USB_SERIAL_QCAUX=3Dm
CONFIG_USB_SERIAL_QUALCOMM=3Dm
CONFIG_USB_SERIAL_SPCP8X5=3Dm
CONFIG_USB_SERIAL_SAFE=3Dm
CONFIG_USB_SERIAL_SAFE_PADDED=3Dy
CONFIG_USB_SERIAL_SIERRAWIRELESS=3Dm
CONFIG_USB_SERIAL_SYMBOL=3Dm
# CONFIG_USB_SERIAL_TI is not set
CONFIG_USB_SERIAL_CYBERJACK=3Dm
CONFIG_USB_SERIAL_XIRCOM=3Dm
CONFIG_USB_SERIAL_WWAN=3Dm
CONFIG_USB_SERIAL_OPTION=3Dm
CONFIG_USB_SERIAL_OMNINET=3Dm
CONFIG_USB_SERIAL_OPTICON=3Dm
CONFIG_USB_SERIAL_XSENS_MT=3Dm
# CONFIG_USB_SERIAL_WISHBONE is not set
CONFIG_USB_SERIAL_SSU100=3Dm
CONFIG_USB_SERIAL_QT2=3Dm
# CONFIG_USB_SERIAL_UPD78F0730 is not set
CONFIG_USB_SERIAL_DEBUG=3Dm

#
# USB Miscellaneous drivers
#
CONFIG_USB_EMI62=3Dm
CONFIG_USB_EMI26=3Dm
CONFIG_USB_ADUTUX=3Dm
CONFIG_USB_SEVSEG=3Dm
CONFIG_USB_LEGOTOWER=3Dm
CONFIG_USB_LCD=3Dm
# CONFIG_USB_CYPRESS_CY7C63 is not set
# CONFIG_USB_CYTHERM is not set
CONFIG_USB_IDMOUSE=3Dm
CONFIG_USB_FTDI_ELAN=3Dm
CONFIG_USB_APPLEDISPLAY=3Dm
CONFIG_USB_SISUSBVGA=3Dm
CONFIG_USB_SISUSBVGA_CON=3Dy
CONFIG_USB_LD=3Dm
# CONFIG_USB_TRANCEVIBRATOR is not set
CONFIG_USB_IOWARRIOR=3Dm
# CONFIG_USB_TEST is not set
# CONFIG_USB_EHSET_TEST_FIXTURE is not set
CONFIG_USB_ISIGHTFW=3Dm
# CONFIG_USB_YUREX is not set
CONFIG_USB_EZUSB_FX2=3Dm
# CONFIG_USB_HUB_USB251XB is not set
CONFIG_USB_HSIC_USB3503=3Dm
# CONFIG_USB_HSIC_USB4604 is not set
# CONFIG_USB_LINK_LAYER_TEST is not set
# CONFIG_USB_CHAOSKEY is not set
CONFIG_USB_ATM=3Dm
CONFIG_USB_SPEEDTOUCH=3Dm
CONFIG_USB_CXACRU=3Dm
CONFIG_USB_UEAGLEATM=3Dm
CONFIG_USB_XUSBATM=3Dm

#
# USB Physical Layer drivers
#
# CONFIG_NOP_USB_XCEIV is not set
# CONFIG_USB_GPIO_VBUS is not set
# CONFIG_USB_ISP1301 is not set
# end of USB Physical Layer drivers

# CONFIG_USB_GADGET is not set
CONFIG_TYPEC=3Dy
# CONFIG_TYPEC_TCPM is not set
CONFIG_TYPEC_UCSI=3Dy
# CONFIG_UCSI_CCG is not set
CONFIG_UCSI_ACPI=3Dy
# CONFIG_TYPEC_TPS6598X is not set

#
# USB Type-C Multiplexer/DeMultiplexer Switch support
#
# CONFIG_TYPEC_MUX_PI3USB30532 is not set
# end of USB Type-C Multiplexer/DeMultiplexer Switch support

#
# USB Type-C Alternate Mode drivers
#
# CONFIG_TYPEC_DP_ALTMODE is not set
# end of USB Type-C Alternate Mode drivers

# CONFIG_USB_ROLE_SWITCH is not set
CONFIG_MMC=3Dm
CONFIG_MMC_BLOCK=3Dm
CONFIG_MMC_BLOCK_MINORS=3D8
CONFIG_SDIO_UART=3Dm
# CONFIG_MMC_TEST is not set

#
# MMC/SD/SDIO Host Controller Drivers
#
# CONFIG_MMC_DEBUG is not set
CONFIG_MMC_SDHCI=3Dm
CONFIG_MMC_SDHCI_IO_ACCESSORS=3Dy
CONFIG_MMC_SDHCI_PCI=3Dm
CONFIG_MMC_RICOH_MMC=3Dy
CONFIG_MMC_SDHCI_ACPI=3Dm
CONFIG_MMC_SDHCI_PLTFM=3Dm
# CONFIG_MMC_SDHCI_F_SDH30 is not set
# CONFIG_MMC_WBSD is not set
CONFIG_MMC_TIFM_SD=3Dm
# CONFIG_MMC_SPI is not set
CONFIG_MMC_CB710=3Dm
CONFIG_MMC_VIA_SDMMC=3Dm
CONFIG_MMC_VUB300=3Dm
CONFIG_MMC_USHC=3Dm
# CONFIG_MMC_USDHI6ROL0 is not set
CONFIG_MMC_CQHCI=3Dm
# CONFIG_MMC_TOSHIBA_PCI is not set
# CONFIG_MMC_MTK is not set
# CONFIG_MMC_SDHCI_XENON is not set
CONFIG_MEMSTICK=3Dm
# CONFIG_MEMSTICK_DEBUG is not set

#
# MemoryStick drivers
#
# CONFIG_MEMSTICK_UNSAFE_RESUME is not set
CONFIG_MSPRO_BLOCK=3Dm
# CONFIG_MS_BLOCK is not set

#
# MemoryStick Host Controller Drivers
#
CONFIG_MEMSTICK_TIFM_MS=3Dm
CONFIG_MEMSTICK_JMICRON_38X=3Dm
CONFIG_MEMSTICK_R592=3Dm
CONFIG_NEW_LEDS=3Dy
CONFIG_LEDS_CLASS=3Dy
# CONFIG_LEDS_CLASS_FLASH is not set
# CONFIG_LEDS_BRIGHTNESS_HW_CHANGED is not set

#
# LED drivers
#
# CONFIG_LEDS_APU is not set
CONFIG_LEDS_LM3530=3Dm
# CONFIG_LEDS_LM3532 is not set
# CONFIG_LEDS_LM3642 is not set
# CONFIG_LEDS_PCA9532 is not set
# CONFIG_LEDS_GPIO is not set
CONFIG_LEDS_LP3944=3Dm
# CONFIG_LEDS_LP3952 is not set
CONFIG_LEDS_LP55XX_COMMON=3Dm
CONFIG_LEDS_LP5521=3Dm
CONFIG_LEDS_LP5523=3Dm
CONFIG_LEDS_LP5562=3Dm
# CONFIG_LEDS_LP8501 is not set
CONFIG_LEDS_CLEVO_MAIL=3Dm
# CONFIG_LEDS_PCA955X is not set
# CONFIG_LEDS_PCA963X is not set
# CONFIG_LEDS_DAC124S085 is not set
# CONFIG_LEDS_PWM is not set
# CONFIG_LEDS_BD2802 is not set
CONFIG_LEDS_INTEL_SS4200=3Dm
# CONFIG_LEDS_TCA6507 is not set
# CONFIG_LEDS_TLC591XX is not set
# CONFIG_LEDS_LM355x is not set

#
# LED driver for blink(1) USB RGB LED is under Special HID drivers (HID_THI=
NGM)
#
CONFIG_LEDS_BLINKM=3Dm
# CONFIG_LEDS_MLXCPLD is not set
# CONFIG_LEDS_MLXREG is not set
# CONFIG_LEDS_USER is not set
# CONFIG_LEDS_NIC78BX is not set
# CONFIG_LEDS_TI_LMU_COMMON is not set

#
# LED Triggers
#
CONFIG_LEDS_TRIGGERS=3Dy
CONFIG_LEDS_TRIGGER_TIMER=3Dm
CONFIG_LEDS_TRIGGER_ONESHOT=3Dm
# CONFIG_LEDS_TRIGGER_DISK is not set
# CONFIG_LEDS_TRIGGER_MTD is not set
CONFIG_LEDS_TRIGGER_HEARTBEAT=3Dm
CONFIG_LEDS_TRIGGER_BACKLIGHT=3Dm
# CONFIG_LEDS_TRIGGER_CPU is not set
# CONFIG_LEDS_TRIGGER_ACTIVITY is not set
CONFIG_LEDS_TRIGGER_GPIO=3Dm
CONFIG_LEDS_TRIGGER_DEFAULT_ON=3Dm

#
# iptables trigger is under Netfilter config (LED target)
#
CONFIG_LEDS_TRIGGER_TRANSIENT=3Dm
CONFIG_LEDS_TRIGGER_CAMERA=3Dm
# CONFIG_LEDS_TRIGGER_PANIC is not set
# CONFIG_LEDS_TRIGGER_NETDEV is not set
# CONFIG_LEDS_TRIGGER_PATTERN is not set
CONFIG_LEDS_TRIGGER_AUDIO=3Dm
# CONFIG_ACCESSIBILITY is not set
# CONFIG_INFINIBAND is not set
CONFIG_EDAC_ATOMIC_SCRUB=3Dy
CONFIG_EDAC_SUPPORT=3Dy
CONFIG_EDAC=3Dy
CONFIG_EDAC_LEGACY_SYSFS=3Dy
# CONFIG_EDAC_DEBUG is not set
CONFIG_EDAC_DECODE_MCE=3Dm
CONFIG_EDAC_GHES=3Dy
CONFIG_EDAC_AMD64=3Dm
# CONFIG_EDAC_AMD64_ERROR_INJECTION is not set
CONFIG_EDAC_E752X=3Dm
CONFIG_EDAC_I82975X=3Dm
CONFIG_EDAC_I3000=3Dm
CONFIG_EDAC_I3200=3Dm
CONFIG_EDAC_IE31200=3Dm
CONFIG_EDAC_X38=3Dm
CONFIG_EDAC_I5400=3Dm
CONFIG_EDAC_I7CORE=3Dm
CONFIG_EDAC_I5000=3Dm
CONFIG_EDAC_I5100=3Dm
CONFIG_EDAC_I7300=3Dm
CONFIG_EDAC_SBRIDGE=3Dm
CONFIG_EDAC_SKX=3Dm
# CONFIG_EDAC_I10NM is not set
CONFIG_EDAC_PND2=3Dm
CONFIG_RTC_LIB=3Dy
CONFIG_RTC_MC146818_LIB=3Dy
CONFIG_RTC_CLASS=3Dy
CONFIG_RTC_HCTOSYS=3Dy
CONFIG_RTC_HCTOSYS_DEVICE=3D"rtc0"
# CONFIG_RTC_SYSTOHC is not set
# CONFIG_RTC_DEBUG is not set
CONFIG_RTC_NVMEM=3Dy

#
# RTC interfaces
#
CONFIG_RTC_INTF_SYSFS=3Dy
CONFIG_RTC_INTF_PROC=3Dy
CONFIG_RTC_INTF_DEV=3Dy
# CONFIG_RTC_INTF_DEV_UIE_EMUL is not set
# CONFIG_RTC_DRV_TEST is not set

#
# I2C RTC drivers
#
# CONFIG_RTC_DRV_ABB5ZES3 is not set
# CONFIG_RTC_DRV_ABEOZ9 is not set
# CONFIG_RTC_DRV_ABX80X is not set
CONFIG_RTC_DRV_DS1307=3Dm
# CONFIG_RTC_DRV_DS1307_CENTURY is not set
CONFIG_RTC_DRV_DS1374=3Dm
# CONFIG_RTC_DRV_DS1374_WDT is not set
CONFIG_RTC_DRV_DS1672=3Dm
CONFIG_RTC_DRV_MAX6900=3Dm
CONFIG_RTC_DRV_RS5C372=3Dm
CONFIG_RTC_DRV_ISL1208=3Dm
CONFIG_RTC_DRV_ISL12022=3Dm
CONFIG_RTC_DRV_X1205=3Dm
CONFIG_RTC_DRV_PCF8523=3Dm
# CONFIG_RTC_DRV_PCF85063 is not set
# CONFIG_RTC_DRV_PCF85363 is not set
CONFIG_RTC_DRV_PCF8563=3Dm
CONFIG_RTC_DRV_PCF8583=3Dm
CONFIG_RTC_DRV_M41T80=3Dm
CONFIG_RTC_DRV_M41T80_WDT=3Dy
CONFIG_RTC_DRV_BQ32K=3Dm
# CONFIG_RTC_DRV_S35390A is not set
CONFIG_RTC_DRV_FM3130=3Dm
# CONFIG_RTC_DRV_RX8010 is not set
CONFIG_RTC_DRV_RX8581=3Dm
CONFIG_RTC_DRV_RX8025=3Dm
CONFIG_RTC_DRV_EM3027=3Dm
# CONFIG_RTC_DRV_RV3028 is not set
# CONFIG_RTC_DRV_RV8803 is not set
# CONFIG_RTC_DRV_SD3078 is not set

#
# SPI RTC drivers
#
# CONFIG_RTC_DRV_M41T93 is not set
# CONFIG_RTC_DRV_M41T94 is not set
# CONFIG_RTC_DRV_DS1302 is not set
# CONFIG_RTC_DRV_DS1305 is not set
# CONFIG_RTC_DRV_DS1343 is not set
# CONFIG_RTC_DRV_DS1347 is not set
# CONFIG_RTC_DRV_DS1390 is not set
# CONFIG_RTC_DRV_MAX6916 is not set
# CONFIG_RTC_DRV_R9701 is not set
CONFIG_RTC_DRV_RX4581=3Dm
# CONFIG_RTC_DRV_RX6110 is not set
# CONFIG_RTC_DRV_RS5C348 is not set
# CONFIG_RTC_DRV_MAX6902 is not set
# CONFIG_RTC_DRV_PCF2123 is not set
# CONFIG_RTC_DRV_MCP795 is not set
CONFIG_RTC_I2C_AND_SPI=3Dy

#
# SPI and I2C RTC drivers
#
CONFIG_RTC_DRV_DS3232=3Dm
CONFIG_RTC_DRV_DS3232_HWMON=3Dy
# CONFIG_RTC_DRV_PCF2127 is not set
CONFIG_RTC_DRV_RV3029C2=3Dm
CONFIG_RTC_DRV_RV3029_HWMON=3Dy

#
# Platform RTC drivers
#
CONFIG_RTC_DRV_CMOS=3Dy
CONFIG_RTC_DRV_DS1286=3Dm
CONFIG_RTC_DRV_DS1511=3Dm
CONFIG_RTC_DRV_DS1553=3Dm
# CONFIG_RTC_DRV_DS1685_FAMILY is not set
CONFIG_RTC_DRV_DS1742=3Dm
CONFIG_RTC_DRV_DS2404=3Dm
CONFIG_RTC_DRV_STK17TA8=3Dm
# CONFIG_RTC_DRV_M48T86 is not set
CONFIG_RTC_DRV_M48T35=3Dm
CONFIG_RTC_DRV_M48T59=3Dm
CONFIG_RTC_DRV_MSM6242=3Dm
CONFIG_RTC_DRV_BQ4802=3Dm
CONFIG_RTC_DRV_RP5C01=3Dm
CONFIG_RTC_DRV_V3020=3Dm

#
# on-CPU RTC drivers
#
# CONFIG_RTC_DRV_FTRTC010 is not set

#
# HID Sensor RTC drivers
#
# CONFIG_RTC_DRV_HID_SENSOR_TIME is not set
CONFIG_DMADEVICES=3Dy
# CONFIG_DMADEVICES_DEBUG is not set

#
# DMA Devices
#
CONFIG_DMA_ENGINE=3Dy
CONFIG_DMA_VIRTUAL_CHANNELS=3Dy
CONFIG_DMA_ACPI=3Dy
# CONFIG_ALTERA_MSGDMA is not set
# CONFIG_INTEL_IDMA64 is not set
CONFIG_INTEL_IOATDMA=3Dm
# CONFIG_QCOM_HIDMA_MGMT is not set
# CONFIG_QCOM_HIDMA is not set
CONFIG_DW_DMAC_CORE=3Dy
CONFIG_DW_DMAC=3Dm
CONFIG_DW_DMAC_PCI=3Dy
# CONFIG_DW_EDMA is not set
# CONFIG_DW_EDMA_PCIE is not set
CONFIG_HSU_DMA=3Dy

#
# DMA Clients
#
CONFIG_ASYNC_TX_DMA=3Dy
# CONFIG_DMATEST is not set
CONFIG_DMA_ENGINE_RAID=3Dy

#
# DMABUF options
#
CONFIG_SYNC_FILE=3Dy
CONFIG_SW_SYNC=3Dy
# CONFIG_UDMABUF is not set
# CONFIG_DMABUF_SELFTESTS is not set
# end of DMABUF options

CONFIG_DCA=3Dm
CONFIG_AUXDISPLAY=3Dy
# CONFIG_HD44780 is not set
CONFIG_KS0108=3Dm
CONFIG_KS0108_PORT=3D0x378
CONFIG_KS0108_DELAY=3D2
CONFIG_CFAG12864B=3Dm
CONFIG_CFAG12864B_RATE=3D20
# CONFIG_IMG_ASCII_LCD is not set
# CONFIG_PARPORT_PANEL is not set
# CONFIG_CHARLCD_BL_OFF is not set
# CONFIG_CHARLCD_BL_ON is not set
CONFIG_CHARLCD_BL_FLASH=3Dy
# CONFIG_PANEL is not set
CONFIG_UIO=3Dm
CONFIG_UIO_CIF=3Dm
CONFIG_UIO_PDRV_GENIRQ=3Dm
# CONFIG_UIO_DMEM_GENIRQ is not set
CONFIG_UIO_AEC=3Dm
CONFIG_UIO_SERCOS3=3Dm
CONFIG_UIO_PCI_GENERIC=3Dm
# CONFIG_UIO_NETX is not set
# CONFIG_UIO_PRUSS is not set
# CONFIG_UIO_MF624 is not set
CONFIG_UIO_HV_GENERIC=3Dm
CONFIG_VFIO_IOMMU_TYPE1=3Dm
CONFIG_VFIO_VIRQFD=3Dm
CONFIG_VFIO=3Dm
CONFIG_VFIO_NOIOMMU=3Dy
CONFIG_VFIO_PCI=3Dm
# CONFIG_VFIO_PCI_VGA is not set
CONFIG_VFIO_PCI_MMAP=3Dy
CONFIG_VFIO_PCI_INTX=3Dy
# CONFIG_VFIO_PCI_IGD is not set
CONFIG_VFIO_MDEV=3Dm
CONFIG_VFIO_MDEV_DEVICE=3Dm
CONFIG_IRQ_BYPASS_MANAGER=3Dm
# CONFIG_VIRT_DRIVERS is not set
CONFIG_VIRTIO=3Dy
CONFIG_VIRTIO_MENU=3Dy
CONFIG_VIRTIO_PCI=3Dy
CONFIG_VIRTIO_PCI_LEGACY=3Dy
# CONFIG_VIRTIO_PMEM is not set
CONFIG_VIRTIO_BALLOON=3Dy
CONFIG_VIRTIO_INPUT=3Dm
# CONFIG_VIRTIO_MMIO is not set

#
# Microsoft Hyper-V guest support
#
CONFIG_HYPERV=3Dm
CONFIG_HYPERV_TIMER=3Dy
CONFIG_HYPERV_UTILS=3Dm
CONFIG_HYPERV_BALLOON=3Dm
# end of Microsoft Hyper-V guest support

#
# Xen driver support
#
CONFIG_XEN_BALLOON=3Dy
# CONFIG_XEN_BALLOON_MEMORY_HOTPLUG is not set
CONFIG_XEN_SCRUB_PAGES_DEFAULT=3Dy
CONFIG_XEN_DEV_EVTCHN=3Dm
# CONFIG_XEN_BACKEND is not set
CONFIG_XENFS=3Dm
CONFIG_XEN_COMPAT_XENFS=3Dy
CONFIG_XEN_SYS_HYPERVISOR=3Dy
CONFIG_XEN_XENBUS_FRONTEND=3Dy
# CONFIG_XEN_GNTDEV is not set
# CONFIG_XEN_GRANT_DEV_ALLOC is not set
# CONFIG_XEN_GRANT_DMA_ALLOC is not set
CONFIG_SWIOTLB_XEN=3Dy
# CONFIG_XEN_PVCALLS_FRONTEND is not set
CONFIG_XEN_PRIVCMD=3Dm
CONFIG_XEN_HAVE_PVMMU=3Dy
CONFIG_XEN_EFI=3Dy
CONFIG_XEN_AUTO_XLATE=3Dy
CONFIG_XEN_ACPI=3Dy
CONFIG_XEN_HAVE_VPMU=3Dy
# end of Xen driver support

# CONFIG_GREYBUS is not set
CONFIG_STAGING=3Dy
# CONFIG_PRISM2_USB is not set
# CONFIG_COMEDI is not set
# CONFIG_RTL8192U is not set
CONFIG_RTLLIB=3Dm
CONFIG_RTLLIB_CRYPTO_CCMP=3Dm
CONFIG_RTLLIB_CRYPTO_TKIP=3Dm
CONFIG_RTLLIB_CRYPTO_WEP=3Dm
CONFIG_RTL8192E=3Dm
# CONFIG_RTL8723BS is not set
CONFIG_R8712U=3Dm
# CONFIG_R8188EU is not set
# CONFIG_RTS5208 is not set
# CONFIG_VT6655 is not set
# CONFIG_VT6656 is not set

#
# IIO staging drivers
#

#
# Accelerometers
#
# CONFIG_ADIS16203 is not set
# CONFIG_ADIS16240 is not set
# end of Accelerometers

#
# Analog to digital converters
#
# CONFIG_AD7816 is not set
# CONFIG_AD7192 is not set
# CONFIG_AD7280 is not set
# end of Analog to digital converters

#
# Analog digital bi-direction converters
#
# CONFIG_ADT7316 is not set
# end of Analog digital bi-direction converters

#
# Capacitance to digital converters
#
# CONFIG_AD7150 is not set
# CONFIG_AD7746 is not set
# end of Capacitance to digital converters

#
# Direct Digital Synthesis
#
# CONFIG_AD9832 is not set
# CONFIG_AD9834 is not set
# end of Direct Digital Synthesis

#
# Network Analyzer, Impedance Converters
#
# CONFIG_AD5933 is not set
# end of Network Analyzer, Impedance Converters

#
# Active energy metering IC
#
# CONFIG_ADE7854 is not set
# end of Active energy metering IC

#
# Resolver to digital converters
#
# CONFIG_AD2S1210 is not set
# end of Resolver to digital converters
# end of IIO staging drivers

# CONFIG_FB_SM750 is not set

#
# Speakup console speech
#
# CONFIG_SPEAKUP is not set
# end of Speakup console speech

# CONFIG_STAGING_MEDIA is not set

#
# Android
#
# CONFIG_ASHMEM is not set
# CONFIG_ANDROID_VSOC is not set
CONFIG_ION=3Dy
CONFIG_ION_SYSTEM_HEAP=3Dy
# end of Android

# CONFIG_LTE_GDM724X is not set
CONFIG_FIREWIRE_SERIAL=3Dm
CONFIG_FWTTY_MAX_TOTAL_PORTS=3D64
CONFIG_FWTTY_MAX_CARD_PORTS=3D32
# CONFIG_GS_FPGABOOT is not set
# CONFIG_UNISYSSPAR is not set
# CONFIG_WILC1000_SDIO is not set
# CONFIG_WILC1000_SPI is not set
# CONFIG_MOST is not set
# CONFIG_KS7010 is not set
# CONFIG_PI433 is not set

#
# Gasket devices
#
# CONFIG_STAGING_GASKET_FRAMEWORK is not set
# end of Gasket devices

# CONFIG_FIELDBUS_DEV is not set
# CONFIG_KPC2000 is not set

#
# ISDN CAPI drivers
#
CONFIG_CAPI_AVM=3Dy
CONFIG_ISDN_DRV_AVMB1_B1PCI=3Dm
CONFIG_ISDN_DRV_AVMB1_B1PCIV4=3Dy
CONFIG_ISDN_DRV_AVMB1_T1PCI=3Dm
CONFIG_ISDN_DRV_AVMB1_C4=3Dm
CONFIG_ISDN_DRV_GIGASET=3Dm
CONFIG_GIGASET_CAPI=3Dy
CONFIG_GIGASET_BASE=3Dm
CONFIG_GIGASET_M105=3Dm
CONFIG_GIGASET_M101=3Dm
# CONFIG_GIGASET_DEBUG is not set
CONFIG_HYSDN=3Dm
CONFIG_HYSDN_CAPI=3Dy
# end of ISDN CAPI drivers

CONFIG_USB_WUSB=3Dm
CONFIG_USB_WUSB_CBAF=3Dm
# CONFIG_USB_WUSB_CBAF_DEBUG is not set
# CONFIG_USB_WHCI_HCD is not set
CONFIG_USB_HWA_HCD=3Dm
CONFIG_UWB=3Dm
CONFIG_UWB_HWA=3Dm
CONFIG_UWB_WHCI=3Dm
CONFIG_UWB_I1480U=3Dm
# CONFIG_EXFAT_FS is not set
CONFIG_QLGE=3Dm
CONFIG_X86_PLATFORM_DEVICES=3Dy
CONFIG_ACER_WMI=3Dm
# CONFIG_ACER_WIRELESS is not set
CONFIG_ACERHDF=3Dm
# CONFIG_ALIENWARE_WMI is not set
CONFIG_ASUS_LAPTOP=3Dm
CONFIG_DCDBAS=3Dm
CONFIG_DELL_SMBIOS=3Dm
CONFIG_DELL_SMBIOS_WMI=3Dy
CONFIG_DELL_SMBIOS_SMM=3Dy
CONFIG_DELL_LAPTOP=3Dm
CONFIG_DELL_WMI=3Dm
CONFIG_DELL_WMI_DESCRIPTOR=3Dm
CONFIG_DELL_WMI_AIO=3Dm
# CONFIG_DELL_WMI_LED is not set
CONFIG_DELL_SMO8800=3Dm
CONFIG_DELL_RBTN=3Dm
CONFIG_DELL_RBU=3Dm
CONFIG_FUJITSU_LAPTOP=3Dm
CONFIG_FUJITSU_TABLET=3Dm
CONFIG_AMILO_RFKILL=3Dm
# CONFIG_GPD_POCKET_FAN is not set
CONFIG_HP_ACCEL=3Dm
CONFIG_HP_WIRELESS=3Dm
CONFIG_HP_WMI=3Dm
# CONFIG_LG_LAPTOP is not set
CONFIG_MSI_LAPTOP=3Dm
CONFIG_PANASONIC_LAPTOP=3Dm
CONFIG_COMPAL_LAPTOP=3Dm
CONFIG_SONY_LAPTOP=3Dm
CONFIG_SONYPI_COMPAT=3Dy
CONFIG_IDEAPAD_LAPTOP=3Dm
# CONFIG_SURFACE3_WMI is not set
CONFIG_THINKPAD_ACPI=3Dm
CONFIG_THINKPAD_ACPI_ALSA_SUPPORT=3Dy
# CONFIG_THINKPAD_ACPI_DEBUGFACILITIES is not set
# CONFIG_THINKPAD_ACPI_DEBUG is not set
# CONFIG_THINKPAD_ACPI_UNSAFE_LEDS is not set
CONFIG_THINKPAD_ACPI_VIDEO=3Dy
CONFIG_THINKPAD_ACPI_HOTKEY_POLL=3Dy
CONFIG_SENSORS_HDAPS=3Dm
# CONFIG_INTEL_MENLOW is not set
CONFIG_EEEPC_LAPTOP=3Dm
CONFIG_ASUS_WMI=3Dm
CONFIG_ASUS_NB_WMI=3Dm
CONFIG_EEEPC_WMI=3Dm
# CONFIG_ASUS_WIRELESS is not set
CONFIG_ACPI_WMI=3Dm
CONFIG_WMI_BMOF=3Dm
CONFIG_INTEL_WMI_THUNDERBOLT=3Dm
# CONFIG_XIAOMI_WMI is not set
CONFIG_MSI_WMI=3Dm
# CONFIG_PEAQ_WMI is not set
CONFIG_TOPSTAR_LAPTOP=3Dm
CONFIG_ACPI_TOSHIBA=3Dm
CONFIG_TOSHIBA_BT_RFKILL=3Dm
# CONFIG_TOSHIBA_HAPS is not set
# CONFIG_TOSHIBA_WMI is not set
CONFIG_ACPI_CMPC=3Dm
# CONFIG_INTEL_INT0002_VGPIO is not set
CONFIG_INTEL_HID_EVENT=3Dm
CONFIG_INTEL_VBTN=3Dm
CONFIG_INTEL_IPS=3Dm
CONFIG_INTEL_PMC_CORE=3Dm
# CONFIG_IBM_RTL is not set
CONFIG_SAMSUNG_LAPTOP=3Dm
CONFIG_MXM_WMI=3Dm
CONFIG_INTEL_OAKTRAIL=3Dm
CONFIG_SAMSUNG_Q10=3Dm
CONFIG_APPLE_GMUX=3Dm
# CONFIG_INTEL_RST is not set
# CONFIG_INTEL_SMARTCONNECT is not set
# CONFIG_INTEL_PMC_IPC is not set
# CONFIG_SURFACE_PRO3_BUTTON is not set
# CONFIG_INTEL_PUNIT_IPC is not set
# CONFIG_MLX_PLATFORM is not set
# CONFIG_INTEL_TURBO_MAX_3 is not set
# CONFIG_I2C_MULTI_INSTANTIATE is not set
# CONFIG_INTEL_ATOMISP2_PM is not set
# CONFIG_HUAWEI_WMI is not set
# CONFIG_PCENGINES_APU2 is not set

#
# Intel Speed Select Technology interface support
#
# CONFIG_INTEL_SPEED_SELECT_INTERFACE is not set
# end of Intel Speed Select Technology interface support

CONFIG_PMC_ATOM=3Dy
# CONFIG_MFD_CROS_EC is not set
# CONFIG_CHROME_PLATFORMS is not set
# CONFIG_MELLANOX_PLATFORM is not set
CONFIG_CLKDEV_LOOKUP=3Dy
CONFIG_HAVE_CLK_PREPARE=3Dy
CONFIG_COMMON_CLK=3Dy

#
# Common Clock Framework
#
# CONFIG_COMMON_CLK_MAX9485 is not set
# CONFIG_COMMON_CLK_SI5341 is not set
# CONFIG_COMMON_CLK_SI5351 is not set
# CONFIG_COMMON_CLK_SI544 is not set
# CONFIG_COMMON_CLK_CDCE706 is not set
# CONFIG_COMMON_CLK_CS2000_CP is not set
# CONFIG_COMMON_CLK_PWM is not set
# end of Common Clock Framework

# CONFIG_HWSPINLOCK is not set

#
# Clock Source drivers
#
CONFIG_CLKEVT_I8253=3Dy
CONFIG_I8253_LOCK=3Dy
CONFIG_CLKBLD_I8253=3Dy
# end of Clock Source drivers

CONFIG_MAILBOX=3Dy
CONFIG_PCC=3Dy
# CONFIG_ALTERA_MBOX is not set
CONFIG_IOMMU_IOVA=3Dy
CONFIG_IOMMU_API=3Dy
CONFIG_IOMMU_SUPPORT=3Dy

#
# Generic IOMMU Pagetable Support
#
# end of Generic IOMMU Pagetable Support

# CONFIG_IOMMU_DEBUGFS is not set
# CONFIG_IOMMU_DEFAULT_PASSTHROUGH is not set
CONFIG_AMD_IOMMU=3Dy
CONFIG_AMD_IOMMU_V2=3Dm
CONFIG_DMAR_TABLE=3Dy
CONFIG_INTEL_IOMMU=3Dy
# CONFIG_INTEL_IOMMU_SVM is not set
# CONFIG_INTEL_IOMMU_DEFAULT_ON is not set
CONFIG_INTEL_IOMMU_FLOPPY_WA=3Dy
CONFIG_IRQ_REMAP=3Dy
CONFIG_HYPERV_IOMMU=3Dy

#
# Remoteproc drivers
#
# CONFIG_REMOTEPROC is not set
# end of Remoteproc drivers

#
# Rpmsg drivers
#
# CONFIG_RPMSG_QCOM_GLINK_RPM is not set
# CONFIG_RPMSG_VIRTIO is not set
# end of Rpmsg drivers

# CONFIG_SOUNDWIRE is not set

#
# SOC (System On Chip) specific Drivers
#

#
# Amlogic SoC drivers
#
# end of Amlogic SoC drivers

#
# Aspeed SoC drivers
#
# end of Aspeed SoC drivers

#
# Broadcom SoC drivers
#
# end of Broadcom SoC drivers

#
# NXP/Freescale QorIQ SoC drivers
#
# end of NXP/Freescale QorIQ SoC drivers

#
# i.MX SoC drivers
#
# end of i.MX SoC drivers

#
# Qualcomm SoC drivers
#
# end of Qualcomm SoC drivers

# CONFIG_SOC_TI is not set

#
# Xilinx SoC drivers
#
# CONFIG_XILINX_VCU is not set
# end of Xilinx SoC drivers
# end of SOC (System On Chip) specific Drivers

CONFIG_PM_DEVFREQ=3Dy

#
# DEVFREQ Governors
#
CONFIG_DEVFREQ_GOV_SIMPLE_ONDEMAND=3Dm
# CONFIG_DEVFREQ_GOV_PERFORMANCE is not set
# CONFIG_DEVFREQ_GOV_POWERSAVE is not set
# CONFIG_DEVFREQ_GOV_USERSPACE is not set
# CONFIG_DEVFREQ_GOV_PASSIVE is not set

#
# DEVFREQ Drivers
#
# CONFIG_PM_DEVFREQ_EVENT is not set
# CONFIG_EXTCON is not set
# CONFIG_MEMORY is not set
CONFIG_IIO=3Dy
CONFIG_IIO_BUFFER=3Dy
CONFIG_IIO_BUFFER_CB=3Dy
# CONFIG_IIO_BUFFER_HW_CONSUMER is not set
CONFIG_IIO_KFIFO_BUF=3Dy
CONFIG_IIO_TRIGGERED_BUFFER=3Dm
# CONFIG_IIO_CONFIGFS is not set
CONFIG_IIO_TRIGGER=3Dy
CONFIG_IIO_CONSUMERS_PER_TRIGGER=3D2
# CONFIG_IIO_SW_DEVICE is not set
# CONFIG_IIO_SW_TRIGGER is not set

#
# Accelerometers
#
# CONFIG_ADIS16201 is not set
# CONFIG_ADIS16209 is not set
# CONFIG_ADXL345_I2C is not set
# CONFIG_ADXL345_SPI is not set
# CONFIG_ADXL372_SPI is not set
# CONFIG_ADXL372_I2C is not set
# CONFIG_BMA180 is not set
# CONFIG_BMA220 is not set
# CONFIG_BMC150_ACCEL is not set
# CONFIG_DA280 is not set
# CONFIG_DA311 is not set
# CONFIG_DMARD09 is not set
# CONFIG_DMARD10 is not set
CONFIG_HID_SENSOR_ACCEL_3D=3Dm
# CONFIG_IIO_ST_ACCEL_3AXIS is not set
# CONFIG_KXSD9 is not set
# CONFIG_KXCJK1013 is not set
# CONFIG_MC3230 is not set
# CONFIG_MMA7455_I2C is not set
# CONFIG_MMA7455_SPI is not set
# CONFIG_MMA7660 is not set
# CONFIG_MMA8452 is not set
# CONFIG_MMA9551 is not set
# CONFIG_MMA9553 is not set
# CONFIG_MXC4005 is not set
# CONFIG_MXC6255 is not set
# CONFIG_SCA3000 is not set
# CONFIG_STK8312 is not set
# CONFIG_STK8BA50 is not set
# end of Accelerometers

#
# Analog to digital converters
#
# CONFIG_AD7124 is not set
# CONFIG_AD7266 is not set
# CONFIG_AD7291 is not set
# CONFIG_AD7298 is not set
# CONFIG_AD7476 is not set
# CONFIG_AD7606_IFACE_PARALLEL is not set
# CONFIG_AD7606_IFACE_SPI is not set
# CONFIG_AD7766 is not set
# CONFIG_AD7768_1 is not set
# CONFIG_AD7780 is not set
# CONFIG_AD7791 is not set
# CONFIG_AD7793 is not set
# CONFIG_AD7887 is not set
# CONFIG_AD7923 is not set
# CONFIG_AD7949 is not set
# CONFIG_AD799X is not set
# CONFIG_HI8435 is not set
# CONFIG_HX711 is not set
# CONFIG_INA2XX_ADC is not set
# CONFIG_LTC2471 is not set
# CONFIG_LTC2485 is not set
# CONFIG_LTC2497 is not set
# CONFIG_MAX1027 is not set
# CONFIG_MAX11100 is not set
# CONFIG_MAX1118 is not set
# CONFIG_MAX1363 is not set
# CONFIG_MAX9611 is not set
# CONFIG_MCP320X is not set
# CONFIG_MCP3422 is not set
# CONFIG_MCP3911 is not set
# CONFIG_NAU7802 is not set
# CONFIG_TI_ADC081C is not set
# CONFIG_TI_ADC0832 is not set
# CONFIG_TI_ADC084S021 is not set
# CONFIG_TI_ADC12138 is not set
# CONFIG_TI_ADC108S102 is not set
# CONFIG_TI_ADC128S052 is not set
# CONFIG_TI_ADC161S626 is not set
# CONFIG_TI_ADS1015 is not set
# CONFIG_TI_ADS7950 is not set
# CONFIG_TI_TLC4541 is not set
# CONFIG_VIPERBOARD_ADC is not set
# CONFIG_XILINX_XADC is not set
# end of Analog to digital converters

#
# Analog Front Ends
#
# end of Analog Front Ends

#
# Amplifiers
#
# CONFIG_AD8366 is not set
# end of Amplifiers

#
# Chemical Sensors
#
# CONFIG_ATLAS_PH_SENSOR is not set
# CONFIG_BME680 is not set
# CONFIG_CCS811 is not set
# CONFIG_IAQCORE is not set
# CONFIG_SENSIRION_SGP30 is not set
# CONFIG_SPS30 is not set
# CONFIG_VZ89X is not set
# end of Chemical Sensors

#
# Hid Sensor IIO Common
#
CONFIG_HID_SENSOR_IIO_COMMON=3Dm
CONFIG_HID_SENSOR_IIO_TRIGGER=3Dm
# end of Hid Sensor IIO Common

#
# SSP Sensor Common
#
# CONFIG_IIO_SSP_SENSORHUB is not set
# end of SSP Sensor Common

#
# Digital to analog converters
#
# CONFIG_AD5064 is not set
# CONFIG_AD5360 is not set
# CONFIG_AD5380 is not set
# CONFIG_AD5421 is not set
# CONFIG_AD5446 is not set
# CONFIG_AD5449 is not set
# CONFIG_AD5592R is not set
# CONFIG_AD5593R is not set
# CONFIG_AD5504 is not set
# CONFIG_AD5624R_SPI is not set
# CONFIG_LTC1660 is not set
# CONFIG_LTC2632 is not set
# CONFIG_AD5686_SPI is not set
# CONFIG_AD5696_I2C is not set
# CONFIG_AD5755 is not set
# CONFIG_AD5758 is not set
# CONFIG_AD5761 is not set
# CONFIG_AD5764 is not set
# CONFIG_AD5791 is not set
# CONFIG_AD7303 is not set
# CONFIG_AD8801 is not set
# CONFIG_DS4424 is not set
# CONFIG_M62332 is not set
# CONFIG_MAX517 is not set
# CONFIG_MCP4725 is not set
# CONFIG_MCP4922 is not set
# CONFIG_TI_DAC082S085 is not set
# CONFIG_TI_DAC5571 is not set
# CONFIG_TI_DAC7311 is not set
# CONFIG_TI_DAC7612 is not set
# end of Digital to analog converters

#
# IIO dummy driver
#
# end of IIO dummy driver

#
# Frequency Synthesizers DDS/PLL
#

#
# Clock Generator/Distribution
#
# CONFIG_AD9523 is not set
# end of Clock Generator/Distribution

#
# Phase-Locked Loop (PLL) frequency synthesizers
#
# CONFIG_ADF4350 is not set
# CONFIG_ADF4371 is not set
# end of Phase-Locked Loop (PLL) frequency synthesizers
# end of Frequency Synthesizers DDS/PLL

#
# Digital gyroscope sensors
#
# CONFIG_ADIS16080 is not set
# CONFIG_ADIS16130 is not set
# CONFIG_ADIS16136 is not set
# CONFIG_ADIS16260 is not set
# CONFIG_ADXRS450 is not set
# CONFIG_BMG160 is not set
# CONFIG_FXAS21002C is not set
CONFIG_HID_SENSOR_GYRO_3D=3Dm
# CONFIG_MPU3050_I2C is not set
# CONFIG_IIO_ST_GYRO_3AXIS is not set
# CONFIG_ITG3200 is not set
# end of Digital gyroscope sensors

#
# Health Sensors
#

#
# Heart Rate Monitors
#
# CONFIG_AFE4403 is not set
# CONFIG_AFE4404 is not set
# CONFIG_MAX30100 is not set
# CONFIG_MAX30102 is not set
# end of Heart Rate Monitors
# end of Health Sensors

#
# Humidity sensors
#
# CONFIG_AM2315 is not set
# CONFIG_DHT11 is not set
# CONFIG_HDC100X is not set
# CONFIG_HID_SENSOR_HUMIDITY is not set
# CONFIG_HTS221 is not set
# CONFIG_HTU21 is not set
# CONFIG_SI7005 is not set
# CONFIG_SI7020 is not set
# end of Humidity sensors

#
# Inertial measurement units
#
# CONFIG_ADIS16400 is not set
# CONFIG_ADIS16460 is not set
# CONFIG_ADIS16480 is not set
# CONFIG_BMI160_I2C is not set
# CONFIG_BMI160_SPI is not set
# CONFIG_KMX61 is not set
# CONFIG_INV_MPU6050_I2C is not set
# CONFIG_INV_MPU6050_SPI is not set
# CONFIG_IIO_ST_LSM6DSX is not set
# end of Inertial measurement units

#
# Light sensors
#
# CONFIG_ACPI_ALS is not set
# CONFIG_ADJD_S311 is not set
# CONFIG_AL3320A is not set
# CONFIG_APDS9300 is not set
# CONFIG_APDS9960 is not set
# CONFIG_BH1750 is not set
# CONFIG_BH1780 is not set
# CONFIG_CM32181 is not set
# CONFIG_CM3232 is not set
# CONFIG_CM3323 is not set
# CONFIG_CM36651 is not set
# CONFIG_GP2AP020A00F is not set
# CONFIG_SENSORS_ISL29018 is not set
# CONFIG_SENSORS_ISL29028 is not set
# CONFIG_ISL29125 is not set
CONFIG_HID_SENSOR_ALS=3Dm
CONFIG_HID_SENSOR_PROX=3Dm
# CONFIG_JSA1212 is not set
# CONFIG_RPR0521 is not set
# CONFIG_LTR501 is not set
# CONFIG_LV0104CS is not set
# CONFIG_MAX44000 is not set
# CONFIG_MAX44009 is not set
# CONFIG_NOA1305 is not set
# CONFIG_OPT3001 is not set
# CONFIG_PA12203001 is not set
# CONFIG_SI1133 is not set
# CONFIG_SI1145 is not set
# CONFIG_STK3310 is not set
# CONFIG_ST_UVIS25 is not set
# CONFIG_TCS3414 is not set
# CONFIG_TCS3472 is not set
# CONFIG_SENSORS_TSL2563 is not set
# CONFIG_TSL2583 is not set
# CONFIG_TSL2772 is not set
# CONFIG_TSL4531 is not set
# CONFIG_US5182D is not set
# CONFIG_VCNL4000 is not set
# CONFIG_VCNL4035 is not set
# CONFIG_VEML6070 is not set
# CONFIG_VL6180 is not set
# CONFIG_ZOPT2201 is not set
# end of Light sensors

#
# Magnetometer sensors
#
# CONFIG_AK8975 is not set
# CONFIG_AK09911 is not set
# CONFIG_BMC150_MAGN_I2C is not set
# CONFIG_BMC150_MAGN_SPI is not set
# CONFIG_MAG3110 is not set
CONFIG_HID_SENSOR_MAGNETOMETER_3D=3Dm
# CONFIG_MMC35240 is not set
# CONFIG_IIO_ST_MAGN_3AXIS is not set
# CONFIG_SENSORS_HMC5843_I2C is not set
# CONFIG_SENSORS_HMC5843_SPI is not set
# CONFIG_SENSORS_RM3100_I2C is not set
# CONFIG_SENSORS_RM3100_SPI is not set
# end of Magnetometer sensors

#
# Multiplexers
#
# end of Multiplexers

#
# Inclinometer sensors
#
CONFIG_HID_SENSOR_INCLINOMETER_3D=3Dm
CONFIG_HID_SENSOR_DEVICE_ROTATION=3Dm
# end of Inclinometer sensors

#
# Triggers - standalone
#
# CONFIG_IIO_INTERRUPT_TRIGGER is not set
# CONFIG_IIO_SYSFS_TRIGGER is not set
# end of Triggers - standalone

#
# Digital potentiometers
#
# CONFIG_AD5272 is not set
# CONFIG_DS1803 is not set
# CONFIG_MAX5432 is not set
# CONFIG_MAX5481 is not set
# CONFIG_MAX5487 is not set
# CONFIG_MCP4018 is not set
# CONFIG_MCP4131 is not set
# CONFIG_MCP4531 is not set
# CONFIG_MCP41010 is not set
# CONFIG_TPL0102 is not set
# end of Digital potentiometers

#
# Digital potentiostats
#
# CONFIG_LMP91000 is not set
# end of Digital potentiostats

#
# Pressure sensors
#
# CONFIG_ABP060MG is not set
# CONFIG_BMP280 is not set
# CONFIG_DPS310 is not set
CONFIG_HID_SENSOR_PRESS=3Dm
# CONFIG_HP03 is not set
# CONFIG_MPL115_I2C is not set
# CONFIG_MPL115_SPI is not set
# CONFIG_MPL3115 is not set
# CONFIG_MS5611 is not set
# CONFIG_MS5637 is not set
# CONFIG_IIO_ST_PRESS is not set
# CONFIG_T5403 is not set
# CONFIG_HP206C is not set
# CONFIG_ZPA2326 is not set
# end of Pressure sensors

#
# Lightning sensors
#
# CONFIG_AS3935 is not set
# end of Lightning sensors

#
# Proximity and distance sensors
#
# CONFIG_ISL29501 is not set
# CONFIG_LIDAR_LITE_V2 is not set
# CONFIG_MB1232 is not set
# CONFIG_RFD77402 is not set
# CONFIG_SRF04 is not set
# CONFIG_SX9500 is not set
# CONFIG_SRF08 is not set
# CONFIG_VL53L0X_I2C is not set
# end of Proximity and distance sensors

#
# Resolver to digital converters
#
# CONFIG_AD2S90 is not set
# CONFIG_AD2S1200 is not set
# end of Resolver to digital converters

#
# Temperature sensors
#
# CONFIG_MAXIM_THERMOCOUPLE is not set
# CONFIG_HID_SENSOR_TEMP is not set
# CONFIG_MLX90614 is not set
# CONFIG_MLX90632 is not set
# CONFIG_TMP006 is not set
# CONFIG_TMP007 is not set
# CONFIG_TSYS01 is not set
# CONFIG_TSYS02D is not set
# CONFIG_MAX31856 is not set
# end of Temperature sensors

CONFIG_NTB=3Dm
# CONFIG_NTB_MSI is not set
CONFIG_NTB_AMD=3Dm
# CONFIG_NTB_IDT is not set
# CONFIG_NTB_INTEL is not set
# CONFIG_NTB_SWITCHTEC is not set
# CONFIG_NTB_PINGPONG is not set
# CONFIG_NTB_TOOL is not set
CONFIG_NTB_PERF=3Dm
CONFIG_NTB_TRANSPORT=3Dm
# CONFIG_VME_BUS is not set
CONFIG_PWM=3Dy
CONFIG_PWM_SYSFS=3Dy
# CONFIG_PWM_LPSS_PCI is not set
# CONFIG_PWM_LPSS_PLATFORM is not set
# CONFIG_PWM_PCA9685 is not set

#
# IRQ chip support
#
# end of IRQ chip support

# CONFIG_IPACK_BUS is not set
# CONFIG_RESET_CONTROLLER is not set

#
# PHY Subsystem
#
CONFIG_GENERIC_PHY=3Dy
# CONFIG_BCM_KONA_USB2_PHY is not set
# CONFIG_PHY_PXA_28NM_HSIC is not set
# CONFIG_PHY_PXA_28NM_USB2 is not set
# CONFIG_PHY_CPCAP_USB is not set
# end of PHY Subsystem

CONFIG_POWERCAP=3Dy
CONFIG_INTEL_RAPL_CORE=3Dm
CONFIG_INTEL_RAPL=3Dm
# CONFIG_IDLE_INJECT is not set
# CONFIG_MCB is not set

#
# Performance monitor support
#
# end of Performance monitor support

CONFIG_RAS=3Dy
# CONFIG_RAS_CEC is not set
CONFIG_THUNDERBOLT=3Dy

#
# Android
#
CONFIG_ANDROID=3Dy
# CONFIG_ANDROID_BINDER_IPC is not set
# end of Android

CONFIG_LIBNVDIMM=3Dm
CONFIG_BLK_DEV_PMEM=3Dm
CONFIG_ND_BLK=3Dm
CONFIG_ND_CLAIM=3Dy
CONFIG_ND_BTT=3Dm
CONFIG_BTT=3Dy
CONFIG_ND_PFN=3Dm
CONFIG_NVDIMM_PFN=3Dy
CONFIG_NVDIMM_DAX=3Dy
CONFIG_NVDIMM_KEYS=3Dy
CONFIG_DAX_DRIVER=3Dy
CONFIG_DAX=3Dy
CONFIG_DEV_DAX=3Dm
CONFIG_DEV_DAX_PMEM=3Dm
CONFIG_DEV_DAX_KMEM=3Dm
CONFIG_DEV_DAX_PMEM_COMPAT=3Dm
CONFIG_NVMEM=3Dy
CONFIG_NVMEM_SYSFS=3Dy

#
# HW tracing support
#
# CONFIG_STM is not set
# CONFIG_INTEL_TH is not set
# end of HW tracing support

# CONFIG_FPGA is not set
CONFIG_PM_OPP=3Dy
# CONFIG_UNISYS_VISORBUS is not set
# CONFIG_SIOX is not set
# CONFIG_SLIMBUS is not set
# CONFIG_INTERCONNECT is not set
# CONFIG_COUNTER is not set
# end of Device Drivers

#
# File systems
#
CONFIG_DCACHE_WORD_ACCESS=3Dy
# CONFIG_VALIDATE_FS_PARSER is not set
CONFIG_FS_IOMAP=3Dy
# CONFIG_EXT2_FS is not set
# CONFIG_EXT3_FS is not set
CONFIG_EXT4_FS=3Dm
CONFIG_EXT4_USE_FOR_EXT2=3Dy
CONFIG_EXT4_FS_POSIX_ACL=3Dy
CONFIG_EXT4_FS_SECURITY=3Dy
# CONFIG_EXT4_DEBUG is not set
CONFIG_JBD2=3Dm
# CONFIG_JBD2_DEBUG is not set
CONFIG_FS_MBCACHE=3Dm
# CONFIG_REISERFS_FS is not set
# CONFIG_JFS_FS is not set
CONFIG_XFS_FS=3Dm
CONFIG_XFS_QUOTA=3Dy
CONFIG_XFS_POSIX_ACL=3Dy
# CONFIG_XFS_RT is not set
# CONFIG_XFS_ONLINE_SCRUB is not set
# CONFIG_XFS_WARN is not set
# CONFIG_XFS_DEBUG is not set
CONFIG_GFS2_FS=3Dm
CONFIG_GFS2_FS_LOCKING_DLM=3Dy
# CONFIG_OCFS2_FS is not set
CONFIG_BTRFS_FS=3Dm
CONFIG_BTRFS_FS_POSIX_ACL=3Dy
# CONFIG_BTRFS_FS_CHECK_INTEGRITY is not set
# CONFIG_BTRFS_FS_RUN_SANITY_TESTS is not set
# CONFIG_BTRFS_DEBUG is not set
# CONFIG_BTRFS_ASSERT is not set
# CONFIG_BTRFS_FS_REF_VERIFY is not set
# CONFIG_NILFS2_FS is not set
# CONFIG_F2FS_FS is not set
CONFIG_FS_DAX=3Dy
CONFIG_FS_DAX_PMD=3Dy
CONFIG_FS_POSIX_ACL=3Dy
CONFIG_EXPORTFS=3Dy
CONFIG_EXPORTFS_BLOCK_OPS=3Dy
CONFIG_FILE_LOCKING=3Dy
CONFIG_MANDATORY_FILE_LOCKING=3Dy
# CONFIG_FS_ENCRYPTION is not set
# CONFIG_FS_VERITY is not set
CONFIG_FSNOTIFY=3Dy
CONFIG_DNOTIFY=3Dy
CONFIG_INOTIFY_USER=3Dy
CONFIG_FANOTIFY=3Dy
CONFIG_FANOTIFY_ACCESS_PERMISSIONS=3Dy
CONFIG_QUOTA=3Dy
CONFIG_QUOTA_NETLINK_INTERFACE=3Dy
CONFIG_PRINT_QUOTA_WARNING=3Dy
# CONFIG_QUOTA_DEBUG is not set
CONFIG_QUOTA_TREE=3Dy
# CONFIG_QFMT_V1 is not set
CONFIG_QFMT_V2=3Dy
CONFIG_QUOTACTL=3Dy
CONFIG_QUOTACTL_COMPAT=3Dy
CONFIG_AUTOFS4_FS=3Dy
CONFIG_AUTOFS_FS=3Dy
CONFIG_FUSE_FS=3Dm
CONFIG_CUSE=3Dm
# CONFIG_VIRTIO_FS is not set
CONFIG_OVERLAY_FS=3Dm
# CONFIG_OVERLAY_FS_REDIRECT_DIR is not set
# CONFIG_OVERLAY_FS_REDIRECT_ALWAYS_FOLLOW is not set
# CONFIG_OVERLAY_FS_INDEX is not set
# CONFIG_OVERLAY_FS_XINO_AUTO is not set
# CONFIG_OVERLAY_FS_METACOPY is not set

#
# Caches
#
CONFIG_FSCACHE=3Dm
CONFIG_FSCACHE_STATS=3Dy
# CONFIG_FSCACHE_HISTOGRAM is not set
# CONFIG_FSCACHE_DEBUG is not set
# CONFIG_FSCACHE_OBJECT_LIST is not set
CONFIG_CACHEFILES=3Dm
# CONFIG_CACHEFILES_DEBUG is not set
# CONFIG_CACHEFILES_HISTOGRAM is not set
# end of Caches

#
# CD-ROM/DVD Filesystems
#
CONFIG_ISO9660_FS=3Dm
CONFIG_JOLIET=3Dy
CONFIG_ZISOFS=3Dy
CONFIG_UDF_FS=3Dm
# end of CD-ROM/DVD Filesystems

#
# DOS/FAT/NT Filesystems
#
CONFIG_FAT_FS=3Dm
CONFIG_MSDOS_FS=3Dm
CONFIG_VFAT_FS=3Dm
CONFIG_FAT_DEFAULT_CODEPAGE=3D437
CONFIG_FAT_DEFAULT_IOCHARSET=3D"ascii"
# CONFIG_FAT_DEFAULT_UTF8 is not set
# CONFIG_NTFS_FS is not set
# end of DOS/FAT/NT Filesystems

#
# Pseudo filesystems
#
CONFIG_PROC_FS=3Dy
CONFIG_PROC_KCORE=3Dy
CONFIG_PROC_VMCORE=3Dy
# CONFIG_PROC_VMCORE_DEVICE_DUMP is not set
CONFIG_PROC_SYSCTL=3Dy
CONFIG_PROC_PAGE_MONITOR=3Dy
CONFIG_PROC_CHILDREN=3Dy
CONFIG_PROC_PID_ARCH_STATUS=3Dy
CONFIG_KERNFS=3Dy
CONFIG_SYSFS=3Dy
CONFIG_TMPFS=3Dy
CONFIG_TMPFS_POSIX_ACL=3Dy
CONFIG_TMPFS_XATTR=3Dy
CONFIG_HUGETLBFS=3Dy
CONFIG_HUGETLB_PAGE=3Dy
CONFIG_MEMFD_CREATE=3Dy
CONFIG_ARCH_HAS_GIGANTIC_PAGE=3Dy
CONFIG_CONFIGFS_FS=3Dy
CONFIG_EFIVAR_FS=3Dy
# end of Pseudo filesystems

CONFIG_MISC_FILESYSTEMS=3Dy
# CONFIG_ORANGEFS_FS is not set
# CONFIG_ADFS_FS is not set
# CONFIG_AFFS_FS is not set
# CONFIG_ECRYPT_FS is not set
# CONFIG_HFS_FS is not set
# CONFIG_HFSPLUS_FS is not set
# CONFIG_BEFS_FS is not set
# CONFIG_BFS_FS is not set
# CONFIG_EFS_FS is not set
# CONFIG_JFFS2_FS is not set
# CONFIG_UBIFS_FS is not set
CONFIG_CRAMFS=3Dm
CONFIG_CRAMFS_BLOCKDEV=3Dy
# CONFIG_CRAMFS_MTD is not set
CONFIG_SQUASHFS=3Dm
CONFIG_SQUASHFS_FILE_CACHE=3Dy
# CONFIG_SQUASHFS_FILE_DIRECT is not set
CONFIG_SQUASHFS_DECOMP_SINGLE=3Dy
# CONFIG_SQUASHFS_DECOMP_MULTI is not set
# CONFIG_SQUASHFS_DECOMP_MULTI_PERCPU is not set
CONFIG_SQUASHFS_XATTR=3Dy
CONFIG_SQUASHFS_ZLIB=3Dy
# CONFIG_SQUASHFS_LZ4 is not set
CONFIG_SQUASHFS_LZO=3Dy
CONFIG_SQUASHFS_XZ=3Dy
# CONFIG_SQUASHFS_ZSTD is not set
# CONFIG_SQUASHFS_4K_DEVBLK_SIZE is not set
# CONFIG_SQUASHFS_EMBEDDED is not set
CONFIG_SQUASHFS_FRAGMENT_CACHE_SIZE=3D3
# CONFIG_VXFS_FS is not set
# CONFIG_MINIX_FS is not set
# CONFIG_OMFS_FS is not set
# CONFIG_HPFS_FS is not set
# CONFIG_QNX4FS_FS is not set
# CONFIG_QNX6FS_FS is not set
# CONFIG_ROMFS_FS is not set
CONFIG_PSTORE=3Dy
CONFIG_PSTORE_DEFLATE_COMPRESS=3Dy
# CONFIG_PSTORE_LZO_COMPRESS is not set
# CONFIG_PSTORE_LZ4_COMPRESS is not set
# CONFIG_PSTORE_LZ4HC_COMPRESS is not set
# CONFIG_PSTORE_842_COMPRESS is not set
# CONFIG_PSTORE_ZSTD_COMPRESS is not set
CONFIG_PSTORE_COMPRESS=3Dy
CONFIG_PSTORE_DEFLATE_COMPRESS_DEFAULT=3Dy
CONFIG_PSTORE_COMPRESS_DEFAULT=3D"deflate"
CONFIG_PSTORE_CONSOLE=3Dy
CONFIG_PSTORE_PMSG=3Dy
# CONFIG_PSTORE_FTRACE is not set
CONFIG_PSTORE_RAM=3Dm
# CONFIG_SYSV_FS is not set
# CONFIG_UFS_FS is not set
# CONFIG_EROFS_FS is not set
CONFIG_NETWORK_FILESYSTEMS=3Dy
CONFIG_NFS_FS=3Dy
# CONFIG_NFS_V2 is not set
CONFIG_NFS_V3=3Dy
CONFIG_NFS_V3_ACL=3Dy
CONFIG_NFS_V4=3Dm
# CONFIG_NFS_SWAP is not set
CONFIG_NFS_V4_1=3Dy
CONFIG_NFS_V4_2=3Dy
CONFIG_PNFS_FILE_LAYOUT=3Dm
CONFIG_PNFS_BLOCK=3Dm
CONFIG_PNFS_FLEXFILE_LAYOUT=3Dm
CONFIG_NFS_V4_1_IMPLEMENTATION_ID_DOMAIN=3D"kernel.org"
# CONFIG_NFS_V4_1_MIGRATION is not set
CONFIG_NFS_V4_SECURITY_LABEL=3Dy
CONFIG_ROOT_NFS=3Dy
# CONFIG_NFS_USE_LEGACY_DNS is not set
CONFIG_NFS_USE_KERNEL_DNS=3Dy
CONFIG_NFS_DEBUG=3Dy
CONFIG_NFSD=3Dm
CONFIG_NFSD_V2_ACL=3Dy
CONFIG_NFSD_V3=3Dy
CONFIG_NFSD_V3_ACL=3Dy
CONFIG_NFSD_V4=3Dy
CONFIG_NFSD_PNFS=3Dy
# CONFIG_NFSD_BLOCKLAYOUT is not set
CONFIG_NFSD_SCSILAYOUT=3Dy
# CONFIG_NFSD_FLEXFILELAYOUT is not set
CONFIG_NFSD_V4_SECURITY_LABEL=3Dy
CONFIG_GRACE_PERIOD=3Dy
CONFIG_LOCKD=3Dy
CONFIG_LOCKD_V4=3Dy
CONFIG_NFS_ACL_SUPPORT=3Dy
CONFIG_NFS_COMMON=3Dy
CONFIG_SUNRPC=3Dy
CONFIG_SUNRPC_GSS=3Dm
CONFIG_SUNRPC_BACKCHANNEL=3Dy
CONFIG_RPCSEC_GSS_KRB5=3Dm
# CONFIG_SUNRPC_DISABLE_INSECURE_ENCTYPES is not set
CONFIG_SUNRPC_DEBUG=3Dy
CONFIG_CEPH_FS=3Dm
# CONFIG_CEPH_FSCACHE is not set
CONFIG_CEPH_FS_POSIX_ACL=3Dy
# CONFIG_CEPH_FS_SECURITY_LABEL is not set
CONFIG_CIFS=3Dm
# CONFIG_CIFS_STATS2 is not set
CONFIG_CIFS_ALLOW_INSECURE_LEGACY=3Dy
CONFIG_CIFS_WEAK_PW_HASH=3Dy
CONFIG_CIFS_UPCALL=3Dy
CONFIG_CIFS_XATTR=3Dy
CONFIG_CIFS_POSIX=3Dy
CONFIG_CIFS_DEBUG=3Dy
# CONFIG_CIFS_DEBUG2 is not set
# CONFIG_CIFS_DEBUG_DUMP_KEYS is not set
CONFIG_CIFS_DFS_UPCALL=3Dy
# CONFIG_CIFS_FSCACHE is not set
# CONFIG_CODA_FS is not set
# CONFIG_AFS_FS is not set
CONFIG_9P_FS=3Dy
CONFIG_9P_FS_POSIX_ACL=3Dy
# CONFIG_9P_FS_SECURITY is not set
CONFIG_NLS=3Dy
CONFIG_NLS_DEFAULT=3D"utf8"
CONFIG_NLS_CODEPAGE_437=3Dy
CONFIG_NLS_CODEPAGE_737=3Dm
CONFIG_NLS_CODEPAGE_775=3Dm
CONFIG_NLS_CODEPAGE_850=3Dm
CONFIG_NLS_CODEPAGE_852=3Dm
CONFIG_NLS_CODEPAGE_855=3Dm
CONFIG_NLS_CODEPAGE_857=3Dm
CONFIG_NLS_CODEPAGE_860=3Dm
CONFIG_NLS_CODEPAGE_861=3Dm
CONFIG_NLS_CODEPAGE_862=3Dm
CONFIG_NLS_CODEPAGE_863=3Dm
CONFIG_NLS_CODEPAGE_864=3Dm
CONFIG_NLS_CODEPAGE_865=3Dm
CONFIG_NLS_CODEPAGE_866=3Dm
CONFIG_NLS_CODEPAGE_869=3Dm
CONFIG_NLS_CODEPAGE_936=3Dm
CONFIG_NLS_CODEPAGE_950=3Dm
CONFIG_NLS_CODEPAGE_932=3Dm
CONFIG_NLS_CODEPAGE_949=3Dm
CONFIG_NLS_CODEPAGE_874=3Dm
CONFIG_NLS_ISO8859_8=3Dm
CONFIG_NLS_CODEPAGE_1250=3Dm
CONFIG_NLS_CODEPAGE_1251=3Dm
CONFIG_NLS_ASCII=3Dy
CONFIG_NLS_ISO8859_1=3Dm
CONFIG_NLS_ISO8859_2=3Dm
CONFIG_NLS_ISO8859_3=3Dm
CONFIG_NLS_ISO8859_4=3Dm
CONFIG_NLS_ISO8859_5=3Dm
CONFIG_NLS_ISO8859_6=3Dm
CONFIG_NLS_ISO8859_7=3Dm
CONFIG_NLS_ISO8859_9=3Dm
CONFIG_NLS_ISO8859_13=3Dm
CONFIG_NLS_ISO8859_14=3Dm
CONFIG_NLS_ISO8859_15=3Dm
CONFIG_NLS_KOI8_R=3Dm
CONFIG_NLS_KOI8_U=3Dm
CONFIG_NLS_MAC_ROMAN=3Dm
CONFIG_NLS_MAC_CELTIC=3Dm
CONFIG_NLS_MAC_CENTEURO=3Dm
CONFIG_NLS_MAC_CROATIAN=3Dm
CONFIG_NLS_MAC_CYRILLIC=3Dm
CONFIG_NLS_MAC_GAELIC=3Dm
CONFIG_NLS_MAC_GREEK=3Dm
CONFIG_NLS_MAC_ICELAND=3Dm
CONFIG_NLS_MAC_INUIT=3Dm
CONFIG_NLS_MAC_ROMANIAN=3Dm
CONFIG_NLS_MAC_TURKISH=3Dm
CONFIG_NLS_UTF8=3Dm
CONFIG_DLM=3Dm
CONFIG_DLM_DEBUG=3Dy
# CONFIG_UNICODE is not set
# end of File systems

#
# Security options
#
CONFIG_KEYS=3Dy
CONFIG_KEYS_COMPAT=3Dy
# CONFIG_KEYS_REQUEST_CACHE is not set
CONFIG_PERSISTENT_KEYRINGS=3Dy
CONFIG_BIG_KEYS=3Dy
CONFIG_TRUSTED_KEYS=3Dy
CONFIG_ENCRYPTED_KEYS=3Dy
# CONFIG_KEY_DH_OPERATIONS is not set
# CONFIG_SECURITY_DMESG_RESTRICT is not set
CONFIG_SECURITY=3Dy
CONFIG_SECURITY_WRITABLE_HOOKS=3Dy
CONFIG_SECURITYFS=3Dy
CONFIG_SECURITY_NETWORK=3Dy
CONFIG_PAGE_TABLE_ISOLATION=3Dy
CONFIG_SECURITY_NETWORK_XFRM=3Dy
CONFIG_SECURITY_PATH=3Dy
CONFIG_INTEL_TXT=3Dy
CONFIG_LSM_MMAP_MIN_ADDR=3D65535
CONFIG_HAVE_HARDENED_USERCOPY_ALLOCATOR=3Dy
CONFIG_HARDENED_USERCOPY=3Dy
CONFIG_HARDENED_USERCOPY_FALLBACK=3Dy
# CONFIG_HARDENED_USERCOPY_PAGESPAN is not set
# CONFIG_FORTIFY_SOURCE is not set
# CONFIG_STATIC_USERMODEHELPER is not set
CONFIG_SECURITY_SELINUX=3Dy
CONFIG_SECURITY_SELINUX_BOOTPARAM=3Dy
CONFIG_SECURITY_SELINUX_DISABLE=3Dy
CONFIG_SECURITY_SELINUX_DEVELOP=3Dy
CONFIG_SECURITY_SELINUX_AVC_STATS=3Dy
CONFIG_SECURITY_SELINUX_CHECKREQPROT_VALUE=3D1
# CONFIG_SECURITY_SMACK is not set
# CONFIG_SECURITY_TOMOYO is not set
# CONFIG_SECURITY_APPARMOR is not set
# CONFIG_SECURITY_LOADPIN is not set
CONFIG_SECURITY_YAMA=3Dy
# CONFIG_SECURITY_SAFESETID is not set
# CONFIG_SECURITY_LOCKDOWN_LSM is not set
CONFIG_INTEGRITY=3Dy
CONFIG_INTEGRITY_SIGNATURE=3Dy
CONFIG_INTEGRITY_ASYMMETRIC_KEYS=3Dy
CONFIG_INTEGRITY_TRUSTED_KEYRING=3Dy
# CONFIG_INTEGRITY_PLATFORM_KEYRING is not set
CONFIG_INTEGRITY_AUDIT=3Dy
CONFIG_IMA=3Dy
CONFIG_IMA_MEASURE_PCR_IDX=3D10
CONFIG_IMA_LSM_RULES=3Dy
# CONFIG_IMA_TEMPLATE is not set
CONFIG_IMA_NG_TEMPLATE=3Dy
# CONFIG_IMA_SIG_TEMPLATE is not set
CONFIG_IMA_DEFAULT_TEMPLATE=3D"ima-ng"
CONFIG_IMA_DEFAULT_HASH_SHA1=3Dy
# CONFIG_IMA_DEFAULT_HASH_SHA256 is not set
CONFIG_IMA_DEFAULT_HASH=3D"sha1"
# CONFIG_IMA_WRITE_POLICY is not set
# CONFIG_IMA_READ_POLICY is not set
CONFIG_IMA_APPRAISE=3Dy
# CONFIG_IMA_ARCH_POLICY is not set
# CONFIG_IMA_APPRAISE_BUILD_POLICY is not set
CONFIG_IMA_APPRAISE_BOOTPARAM=3Dy
# CONFIG_IMA_APPRAISE_MODSIG is not set
CONFIG_IMA_TRUSTED_KEYRING=3Dy
# CONFIG_IMA_BLACKLIST_KEYRING is not set
# CONFIG_IMA_LOAD_X509 is not set
CONFIG_EVM=3Dy
CONFIG_EVM_ATTR_FSUUID=3Dy
# CONFIG_EVM_ADD_XATTRS is not set
# CONFIG_EVM_LOAD_X509 is not set
CONFIG_DEFAULT_SECURITY_SELINUX=3Dy
# CONFIG_DEFAULT_SECURITY_DAC is not set
CONFIG_LSM=3D"lockdown,yama,loadpin,safesetid,integrity,selinux,smack,tomoy=
o,apparmor"

#
# Kernel hardening options
#

#
# Memory initialization
#
CONFIG_INIT_STACK_NONE=3Dy
# CONFIG_GCC_PLUGIN_STRUCTLEAK_USER is not set
# CONFIG_GCC_PLUGIN_STRUCTLEAK_BYREF is not set
# CONFIG_GCC_PLUGIN_STRUCTLEAK_BYREF_ALL is not set
# CONFIG_GCC_PLUGIN_STACKLEAK is not set
# CONFIG_INIT_ON_ALLOC_DEFAULT_ON is not set
# CONFIG_INIT_ON_FREE_DEFAULT_ON is not set
# end of Memory initialization
# end of Kernel hardening options
# end of Security options

CONFIG_XOR_BLOCKS=3Dm
CONFIG_ASYNC_CORE=3Dm
CONFIG_ASYNC_MEMCPY=3Dm
CONFIG_ASYNC_XOR=3Dm
CONFIG_ASYNC_PQ=3Dm
CONFIG_ASYNC_RAID6_RECOV=3Dm
CONFIG_CRYPTO=3Dy

#
# Crypto core or helper
#
CONFIG_CRYPTO_ALGAPI=3Dy
CONFIG_CRYPTO_ALGAPI2=3Dy
CONFIG_CRYPTO_AEAD=3Dy
CONFIG_CRYPTO_AEAD2=3Dy
CONFIG_CRYPTO_BLKCIPHER=3Dy
CONFIG_CRYPTO_BLKCIPHER2=3Dy
CONFIG_CRYPTO_HASH=3Dy
CONFIG_CRYPTO_HASH2=3Dy
CONFIG_CRYPTO_RNG=3Dy
CONFIG_CRYPTO_RNG2=3Dy
CONFIG_CRYPTO_RNG_DEFAULT=3Dy
CONFIG_CRYPTO_AKCIPHER2=3Dy
CONFIG_CRYPTO_AKCIPHER=3Dy
CONFIG_CRYPTO_KPP2=3Dy
CONFIG_CRYPTO_KPP=3Dm
CONFIG_CRYPTO_ACOMP2=3Dy
CONFIG_CRYPTO_MANAGER=3Dy
CONFIG_CRYPTO_MANAGER2=3Dy
CONFIG_CRYPTO_USER=3Dm
CONFIG_CRYPTO_MANAGER_DISABLE_TESTS=3Dy
CONFIG_CRYPTO_GF128MUL=3Dy
CONFIG_CRYPTO_NULL=3Dy
CONFIG_CRYPTO_NULL2=3Dy
CONFIG_CRYPTO_PCRYPT=3Dm
CONFIG_CRYPTO_CRYPTD=3Dm
CONFIG_CRYPTO_AUTHENC=3Dm
CONFIG_CRYPTO_TEST=3Dm
CONFIG_CRYPTO_SIMD=3Dm
CONFIG_CRYPTO_GLUE_HELPER_X86=3Dm
CONFIG_CRYPTO_ENGINE=3Dm

#
# Public-key cryptography
#
CONFIG_CRYPTO_RSA=3Dy
CONFIG_CRYPTO_DH=3Dm
CONFIG_CRYPTO_ECC=3Dm
CONFIG_CRYPTO_ECDH=3Dm
# CONFIG_CRYPTO_ECRDSA is not set

#
# Authenticated Encryption with Associated Data
#
CONFIG_CRYPTO_CCM=3Dm
CONFIG_CRYPTO_GCM=3Dy
# CONFIG_CRYPTO_CHACHA20POLY1305 is not set
# CONFIG_CRYPTO_AEGIS128 is not set
# CONFIG_CRYPTO_AEGIS128_AESNI_SSE2 is not set
CONFIG_CRYPTO_SEQIV=3Dy
CONFIG_CRYPTO_ECHAINIV=3Dm

#
# Block modes
#
CONFIG_CRYPTO_CBC=3Dy
# CONFIG_CRYPTO_CFB is not set
CONFIG_CRYPTO_CTR=3Dy
CONFIG_CRYPTO_CTS=3Dm
CONFIG_CRYPTO_ECB=3Dy
CONFIG_CRYPTO_LRW=3Dm
# CONFIG_CRYPTO_OFB is not set
CONFIG_CRYPTO_PCBC=3Dm
CONFIG_CRYPTO_XTS=3Dm
# CONFIG_CRYPTO_KEYWRAP is not set
# CONFIG_CRYPTO_NHPOLY1305_SSE2 is not set
# CONFIG_CRYPTO_NHPOLY1305_AVX2 is not set
# CONFIG_CRYPTO_ADIANTUM is not set
CONFIG_CRYPTO_ESSIV=3Dm

#
# Hash modes
#
CONFIG_CRYPTO_CMAC=3Dm
CONFIG_CRYPTO_HMAC=3Dy
CONFIG_CRYPTO_XCBC=3Dm
CONFIG_CRYPTO_VMAC=3Dm

#
# Digest
#
CONFIG_CRYPTO_CRC32C=3Dy
CONFIG_CRYPTO_CRC32C_INTEL=3Dm
CONFIG_CRYPTO_CRC32=3Dm
CONFIG_CRYPTO_CRC32_PCLMUL=3Dm
# CONFIG_CRYPTO_XXHASH is not set
CONFIG_CRYPTO_CRCT10DIF=3Dy
CONFIG_CRYPTO_CRCT10DIF_PCLMUL=3Dm
CONFIG_CRYPTO_GHASH=3Dy
# CONFIG_CRYPTO_POLY1305 is not set
# CONFIG_CRYPTO_POLY1305_X86_64 is not set
CONFIG_CRYPTO_MD4=3Dm
CONFIG_CRYPTO_MD5=3Dy
CONFIG_CRYPTO_MICHAEL_MIC=3Dm
CONFIG_CRYPTO_RMD128=3Dm
CONFIG_CRYPTO_RMD160=3Dm
CONFIG_CRYPTO_RMD256=3Dm
CONFIG_CRYPTO_RMD320=3Dm
CONFIG_CRYPTO_SHA1=3Dy
CONFIG_CRYPTO_SHA1_SSSE3=3Dy
CONFIG_CRYPTO_SHA256_SSSE3=3Dy
CONFIG_CRYPTO_SHA512_SSSE3=3Dm
CONFIG_CRYPTO_LIB_SHA256=3Dy
CONFIG_CRYPTO_SHA256=3Dy
CONFIG_CRYPTO_SHA512=3Dm
# CONFIG_CRYPTO_SHA3 is not set
# CONFIG_CRYPTO_SM3 is not set
# CONFIG_CRYPTO_STREEBOG is not set
CONFIG_CRYPTO_TGR192=3Dm
CONFIG_CRYPTO_WP512=3Dm
CONFIG_CRYPTO_GHASH_CLMUL_NI_INTEL=3Dm

#
# Ciphers
#
CONFIG_CRYPTO_LIB_AES=3Dy
CONFIG_CRYPTO_AES=3Dy
# CONFIG_CRYPTO_AES_TI is not set
CONFIG_CRYPTO_AES_NI_INTEL=3Dm
CONFIG_CRYPTO_ANUBIS=3Dm
CONFIG_CRYPTO_LIB_ARC4=3Dm
CONFIG_CRYPTO_ARC4=3Dm
CONFIG_CRYPTO_BLOWFISH=3Dm
CONFIG_CRYPTO_BLOWFISH_COMMON=3Dm
CONFIG_CRYPTO_BLOWFISH_X86_64=3Dm
CONFIG_CRYPTO_CAMELLIA=3Dm
CONFIG_CRYPTO_CAMELLIA_X86_64=3Dm
CONFIG_CRYPTO_CAMELLIA_AESNI_AVX_X86_64=3Dm
CONFIG_CRYPTO_CAMELLIA_AESNI_AVX2_X86_64=3Dm
CONFIG_CRYPTO_CAST_COMMON=3Dm
CONFIG_CRYPTO_CAST5=3Dm
CONFIG_CRYPTO_CAST5_AVX_X86_64=3Dm
CONFIG_CRYPTO_CAST6=3Dm
CONFIG_CRYPTO_CAST6_AVX_X86_64=3Dm
CONFIG_CRYPTO_LIB_DES=3Dm
CONFIG_CRYPTO_DES=3Dm
# CONFIG_CRYPTO_DES3_EDE_X86_64 is not set
CONFIG_CRYPTO_FCRYPT=3Dm
CONFIG_CRYPTO_KHAZAD=3Dm
CONFIG_CRYPTO_SALSA20=3Dm
# CONFIG_CRYPTO_CHACHA20 is not set
# CONFIG_CRYPTO_CHACHA20_X86_64 is not set
CONFIG_CRYPTO_SEED=3Dm
CONFIG_CRYPTO_SERPENT=3Dm
CONFIG_CRYPTO_SERPENT_SSE2_X86_64=3Dm
CONFIG_CRYPTO_SERPENT_AVX_X86_64=3Dm
CONFIG_CRYPTO_SERPENT_AVX2_X86_64=3Dm
# CONFIG_CRYPTO_SM4 is not set
CONFIG_CRYPTO_TEA=3Dm
CONFIG_CRYPTO_TWOFISH=3Dm
CONFIG_CRYPTO_TWOFISH_COMMON=3Dm
CONFIG_CRYPTO_TWOFISH_X86_64=3Dm
CONFIG_CRYPTO_TWOFISH_X86_64_3WAY=3Dm
CONFIG_CRYPTO_TWOFISH_AVX_X86_64=3Dm

#
# Compression
#
CONFIG_CRYPTO_DEFLATE=3Dy
CONFIG_CRYPTO_LZO=3Dy
# CONFIG_CRYPTO_842 is not set
# CONFIG_CRYPTO_LZ4 is not set
# CONFIG_CRYPTO_LZ4HC is not set
# CONFIG_CRYPTO_ZSTD is not set

#
# Random Number Generation
#
CONFIG_CRYPTO_ANSI_CPRNG=3Dm
CONFIG_CRYPTO_DRBG_MENU=3Dy
CONFIG_CRYPTO_DRBG_HMAC=3Dy
CONFIG_CRYPTO_DRBG_HASH=3Dy
CONFIG_CRYPTO_DRBG_CTR=3Dy
CONFIG_CRYPTO_DRBG=3Dy
CONFIG_CRYPTO_JITTERENTROPY=3Dy
CONFIG_CRYPTO_USER_API=3Dy
CONFIG_CRYPTO_USER_API_HASH=3Dy
CONFIG_CRYPTO_USER_API_SKCIPHER=3Dy
CONFIG_CRYPTO_USER_API_RNG=3Dm
# CONFIG_CRYPTO_USER_API_AEAD is not set
# CONFIG_CRYPTO_STATS is not set
CONFIG_CRYPTO_HASH_INFO=3Dy
CONFIG_CRYPTO_HW=3Dy
CONFIG_CRYPTO_DEV_PADLOCK=3Dm
CONFIG_CRYPTO_DEV_PADLOCK_AES=3Dm
CONFIG_CRYPTO_DEV_PADLOCK_SHA=3Dm
# CONFIG_CRYPTO_DEV_ATMEL_ECC is not set
# CONFIG_CRYPTO_DEV_ATMEL_SHA204A is not set
CONFIG_CRYPTO_DEV_CCP=3Dy
CONFIG_CRYPTO_DEV_CCP_DD=3Dm
CONFIG_CRYPTO_DEV_SP_CCP=3Dy
CONFIG_CRYPTO_DEV_CCP_CRYPTO=3Dm
CONFIG_CRYPTO_DEV_SP_PSP=3Dy
# CONFIG_CRYPTO_DEV_CCP_DEBUGFS is not set
CONFIG_CRYPTO_DEV_QAT=3Dm
CONFIG_CRYPTO_DEV_QAT_DH895xCC=3Dm
CONFIG_CRYPTO_DEV_QAT_C3XXX=3Dm
CONFIG_CRYPTO_DEV_QAT_C62X=3Dm
CONFIG_CRYPTO_DEV_QAT_DH895xCCVF=3Dm
CONFIG_CRYPTO_DEV_QAT_C3XXXVF=3Dm
CONFIG_CRYPTO_DEV_QAT_C62XVF=3Dm
# CONFIG_CRYPTO_DEV_NITROX_CNN55XX is not set
CONFIG_CRYPTO_DEV_CHELSIO=3Dm
CONFIG_CRYPTO_DEV_VIRTIO=3Dm
# CONFIG_CRYPTO_DEV_SAFEXCEL is not set
CONFIG_ASYMMETRIC_KEY_TYPE=3Dy
CONFIG_ASYMMETRIC_PUBLIC_KEY_SUBTYPE=3Dy
# CONFIG_ASYMMETRIC_TPM_KEY_SUBTYPE is not set
CONFIG_X509_CERTIFICATE_PARSER=3Dy
# CONFIG_PKCS8_PRIVATE_KEY_PARSER is not set
CONFIG_PKCS7_MESSAGE_PARSER=3Dy
# CONFIG_PKCS7_TEST_KEY is not set
CONFIG_SIGNED_PE_FILE_VERIFICATION=3Dy

#
# Certificates for signature checking
#
CONFIG_MODULE_SIG_KEY=3D"certs/signing_key.pem"
CONFIG_SYSTEM_TRUSTED_KEYRING=3Dy
CONFIG_SYSTEM_TRUSTED_KEYS=3D""
# CONFIG_SYSTEM_EXTRA_CERTIFICATE is not set
# CONFIG_SECONDARY_TRUSTED_KEYRING is not set
CONFIG_SYSTEM_BLACKLIST_KEYRING=3Dy
CONFIG_SYSTEM_BLACKLIST_HASH_LIST=3D""
# end of Certificates for signature checking

CONFIG_BINARY_PRINTF=3Dy

#
# Library routines
#
CONFIG_RAID6_PQ=3Dm
CONFIG_RAID6_PQ_BENCHMARK=3Dy
# CONFIG_PACKING is not set
CONFIG_BITREVERSE=3Dy
CONFIG_GENERIC_STRNCPY_FROM_USER=3Dy
CONFIG_GENERIC_STRNLEN_USER=3Dy
CONFIG_GENERIC_NET_UTILS=3Dy
CONFIG_GENERIC_FIND_FIRST_BIT=3Dy
CONFIG_CORDIC=3Dm
CONFIG_PRIME_NUMBERS=3Dm
CONFIG_RATIONAL=3Dy
CONFIG_GENERIC_PCI_IOMAP=3Dy
CONFIG_GENERIC_IOMAP=3Dy
CONFIG_ARCH_USE_CMPXCHG_LOCKREF=3Dy
CONFIG_ARCH_HAS_FAST_MULTIPLIER=3Dy
CONFIG_CRC_CCITT=3Dy
CONFIG_CRC16=3Dy
CONFIG_CRC_T10DIF=3Dy
CONFIG_CRC_ITU_T=3Dm
CONFIG_CRC32=3Dy
# CONFIG_CRC32_SELFTEST is not set
CONFIG_CRC32_SLICEBY8=3Dy
# CONFIG_CRC32_SLICEBY4 is not set
# CONFIG_CRC32_SARWATE is not set
# CONFIG_CRC32_BIT is not set
# CONFIG_CRC64 is not set
# CONFIG_CRC4 is not set
# CONFIG_CRC7 is not set
CONFIG_LIBCRC32C=3Dm
CONFIG_CRC8=3Dm
CONFIG_XXHASH=3Dy
# CONFIG_RANDOM32_SELFTEST is not set
CONFIG_ZLIB_INFLATE=3Dy
CONFIG_ZLIB_DEFLATE=3Dy
CONFIG_LZO_COMPRESS=3Dy
CONFIG_LZO_DECOMPRESS=3Dy
CONFIG_LZ4_DECOMPRESS=3Dy
CONFIG_ZSTD_COMPRESS=3Dm
CONFIG_ZSTD_DECOMPRESS=3Dm
CONFIG_XZ_DEC=3Dy
CONFIG_XZ_DEC_X86=3Dy
CONFIG_XZ_DEC_POWERPC=3Dy
CONFIG_XZ_DEC_IA64=3Dy
CONFIG_XZ_DEC_ARM=3Dy
CONFIG_XZ_DEC_ARMTHUMB=3Dy
CONFIG_XZ_DEC_SPARC=3Dy
CONFIG_XZ_DEC_BCJ=3Dy
# CONFIG_XZ_DEC_TEST is not set
CONFIG_DECOMPRESS_GZIP=3Dy
CONFIG_DECOMPRESS_BZIP2=3Dy
CONFIG_DECOMPRESS_LZMA=3Dy
CONFIG_DECOMPRESS_XZ=3Dy
CONFIG_DECOMPRESS_LZO=3Dy
CONFIG_DECOMPRESS_LZ4=3Dy
CONFIG_GENERIC_ALLOCATOR=3Dy
CONFIG_REED_SOLOMON=3Dm
CONFIG_REED_SOLOMON_ENC8=3Dy
CONFIG_REED_SOLOMON_DEC8=3Dy
CONFIG_TEXTSEARCH=3Dy
CONFIG_TEXTSEARCH_KMP=3Dm
CONFIG_TEXTSEARCH_BM=3Dm
CONFIG_TEXTSEARCH_FSM=3Dm
CONFIG_BTREE=3Dy
CONFIG_INTERVAL_TREE=3Dy
CONFIG_XARRAY_MULTI=3Dy
CONFIG_ASSOCIATIVE_ARRAY=3Dy
CONFIG_HAS_IOMEM=3Dy
CONFIG_HAS_IOPORT_MAP=3Dy
CONFIG_HAS_DMA=3Dy
CONFIG_NEED_SG_DMA_LENGTH=3Dy
CONFIG_NEED_DMA_MAP_STATE=3Dy
CONFIG_ARCH_DMA_ADDR_T_64BIT=3Dy
CONFIG_ARCH_HAS_FORCE_DMA_UNENCRYPTED=3Dy
CONFIG_SWIOTLB=3Dy
# CONFIG_DMA_CMA is not set
# CONFIG_DMA_API_DEBUG is not set
CONFIG_SGL_ALLOC=3Dy
CONFIG_IOMMU_HELPER=3Dy
CONFIG_CHECK_SIGNATURE=3Dy
CONFIG_CPUMASK_OFFSTACK=3Dy
CONFIG_CPU_RMAP=3Dy
CONFIG_DQL=3Dy
CONFIG_GLOB=3Dy
# CONFIG_GLOB_SELFTEST is not set
CONFIG_NLATTR=3Dy
CONFIG_CLZ_TAB=3Dy
CONFIG_IRQ_POLL=3Dy
CONFIG_MPILIB=3Dy
CONFIG_SIGNATURE=3Dy
CONFIG_DIMLIB=3Dy
CONFIG_OID_REGISTRY=3Dy
CONFIG_UCS2_STRING=3Dy
CONFIG_HAVE_GENERIC_VDSO=3Dy
CONFIG_GENERIC_GETTIMEOFDAY=3Dy
CONFIG_FONT_SUPPORT=3Dy
# CONFIG_FONTS is not set
CONFIG_FONT_8x8=3Dy
CONFIG_FONT_8x16=3Dy
CONFIG_SG_POOL=3Dy
CONFIG_ARCH_HAS_PMEM_API=3Dy
CONFIG_ARCH_HAS_UACCESS_FLUSHCACHE=3Dy
CONFIG_ARCH_HAS_UACCESS_MCSAFE=3Dy
CONFIG_ARCH_STACKWALK=3Dy
CONFIG_SBITMAP=3Dy
# CONFIG_STRING_SELFTEST is not set
# end of Library routines

#
# Kernel hacking
#

#
# printk and dmesg options
#
CONFIG_PRINTK_TIME=3Dy
# CONFIG_PRINTK_CALLER is not set
CONFIG_CONSOLE_LOGLEVEL_DEFAULT=3D7
CONFIG_CONSOLE_LOGLEVEL_QUIET=3D4
CONFIG_MESSAGE_LOGLEVEL_DEFAULT=3D4
CONFIG_BOOT_PRINTK_DELAY=3Dy
CONFIG_DYNAMIC_DEBUG=3Dy
# end of printk and dmesg options

#
# Compile-time checks and compiler options
#
CONFIG_DEBUG_INFO=3Dy
# CONFIG_DEBUG_INFO_REDUCED is not set
# CONFIG_DEBUG_INFO_SPLIT is not set
# CONFIG_DEBUG_INFO_DWARF4 is not set
CONFIG_DEBUG_INFO_BTF=3Dy
# CONFIG_GDB_SCRIPTS is not set
CONFIG_ENABLE_MUST_CHECK=3Dy
CONFIG_FRAME_WARN=3D2048
CONFIG_STRIP_ASM_SYMS=3Dy
# CONFIG_READABLE_ASM is not set
CONFIG_DEBUG_FS=3Dy
# CONFIG_HEADERS_INSTALL is not set
CONFIG_OPTIMIZE_INLINING=3Dy
CONFIG_DEBUG_SECTION_MISMATCH=3Dy
CONFIG_SECTION_MISMATCH_WARN_ONLY=3Dy
CONFIG_STACK_VALIDATION=3Dy
# CONFIG_DEBUG_FORCE_WEAK_PER_CPU is not set
# end of Compile-time checks and compiler options

CONFIG_MAGIC_SYSRQ=3Dy
CONFIG_MAGIC_SYSRQ_DEFAULT_ENABLE=3D0x1
CONFIG_MAGIC_SYSRQ_SERIAL=3Dy
CONFIG_DEBUG_KERNEL=3Dy
CONFIG_DEBUG_MISC=3Dy

#
# Memory Debugging
#
# CONFIG_PAGE_EXTENSION is not set
# CONFIG_DEBUG_PAGEALLOC is not set
# CONFIG_PAGE_OWNER is not set
# CONFIG_PAGE_POISONING is not set
# CONFIG_DEBUG_PAGE_REF is not set
CONFIG_DEBUG_RODATA_TEST=3Dy
# CONFIG_DEBUG_OBJECTS is not set
# CONFIG_SLUB_DEBUG_ON is not set
# CONFIG_SLUB_STATS is not set
CONFIG_HAVE_DEBUG_KMEMLEAK=3Dy
# CONFIG_DEBUG_KMEMLEAK is not set
# CONFIG_DEBUG_STACK_USAGE is not set
# CONFIG_DEBUG_VM is not set
CONFIG_ARCH_HAS_DEBUG_VIRTUAL=3Dy
# CONFIG_DEBUG_VIRTUAL is not set
CONFIG_DEBUG_MEMORY_INIT=3Dy
CONFIG_MEMORY_NOTIFIER_ERROR_INJECT=3Dm
# CONFIG_DEBUG_PER_CPU_MAPS is not set
CONFIG_HAVE_ARCH_KASAN=3Dy
CONFIG_CC_HAS_KASAN_GENERIC=3Dy
# CONFIG_KASAN is not set
CONFIG_KASAN_STACK=3D1
# end of Memory Debugging

CONFIG_ARCH_HAS_KCOV=3Dy
CONFIG_CC_HAS_SANCOV_TRACE_PC=3Dy
# CONFIG_KCOV is not set
CONFIG_DEBUG_SHIRQ=3Dy

#
# Debug Lockups and Hangs
#
CONFIG_LOCKUP_DETECTOR=3Dy
CONFIG_SOFTLOCKUP_DETECTOR=3Dy
# CONFIG_BOOTPARAM_SOFTLOCKUP_PANIC is not set
CONFIG_BOOTPARAM_SOFTLOCKUP_PANIC_VALUE=3D0
CONFIG_HARDLOCKUP_DETECTOR_PERF=3Dy
CONFIG_HARDLOCKUP_CHECK_TIMESTAMP=3Dy
CONFIG_HARDLOCKUP_DETECTOR=3Dy
CONFIG_BOOTPARAM_HARDLOCKUP_PANIC=3Dy
CONFIG_BOOTPARAM_HARDLOCKUP_PANIC_VALUE=3D1
# CONFIG_DETECT_HUNG_TASK is not set
# CONFIG_WQ_WATCHDOG is not set
# end of Debug Lockups and Hangs

CONFIG_PANIC_ON_OOPS=3Dy
CONFIG_PANIC_ON_OOPS_VALUE=3D1
CONFIG_PANIC_TIMEOUT=3D0
CONFIG_SCHED_DEBUG=3Dy
CONFIG_SCHED_INFO=3Dy
CONFIG_SCHEDSTATS=3Dy
# CONFIG_SCHED_STACK_END_CHECK is not set
# CONFIG_DEBUG_TIMEKEEPING is not set

#
# Lock Debugging (spinlocks, mutexes, etc...)
#
CONFIG_LOCK_DEBUGGING_SUPPORT=3Dy
# CONFIG_PROVE_LOCKING is not set
# CONFIG_LOCK_STAT is not set
# CONFIG_DEBUG_RT_MUTEXES is not set
# CONFIG_DEBUG_SPINLOCK is not set
# CONFIG_DEBUG_MUTEXES is not set
# CONFIG_DEBUG_WW_MUTEX_SLOWPATH is not set
# CONFIG_DEBUG_RWSEMS is not set
# CONFIG_DEBUG_LOCK_ALLOC is not set
CONFIG_DEBUG_ATOMIC_SLEEP=3Dy
# CONFIG_DEBUG_LOCKING_API_SELFTESTS is not set
CONFIG_LOCK_TORTURE_TEST=3Dm
CONFIG_WW_MUTEX_SELFTEST=3Dm
# end of Lock Debugging (spinlocks, mutexes, etc...)

CONFIG_STACKTRACE=3Dy
# CONFIG_WARN_ALL_UNSEEDED_RANDOM is not set
# CONFIG_DEBUG_KOBJECT is not set
CONFIG_DEBUG_BUGVERBOSE=3Dy
CONFIG_DEBUG_LIST=3Dy
# CONFIG_DEBUG_PLIST is not set
# CONFIG_DEBUG_SG is not set
# CONFIG_DEBUG_NOTIFIERS is not set
# CONFIG_DEBUG_CREDENTIALS is not set

#
# RCU Debugging
#
CONFIG_TORTURE_TEST=3Dm
# CONFIG_RCU_PERF_TEST is not set
CONFIG_RCU_TORTURE_TEST=3Dm
CONFIG_RCU_CPU_STALL_TIMEOUT=3D60
# CONFIG_RCU_TRACE is not set
# CONFIG_RCU_EQS_DEBUG is not set
# end of RCU Debugging

# CONFIG_DEBUG_WQ_FORCE_RR_CPU is not set
# CONFIG_DEBUG_BLOCK_EXT_DEVT is not set
# CONFIG_CPU_HOTPLUG_STATE_CONTROL is not set
CONFIG_NOTIFIER_ERROR_INJECTION=3Dm
CONFIG_PM_NOTIFIER_ERROR_INJECT=3Dm
# CONFIG_NETDEV_NOTIFIER_ERROR_INJECT is not set
CONFIG_FUNCTION_ERROR_INJECTION=3Dy
# CONFIG_FAULT_INJECTION is not set
CONFIG_LATENCYTOP=3Dy
CONFIG_USER_STACKTRACE_SUPPORT=3Dy
CONFIG_NOP_TRACER=3Dy
CONFIG_HAVE_FUNCTION_TRACER=3Dy
CONFIG_HAVE_FUNCTION_GRAPH_TRACER=3Dy
CONFIG_HAVE_DYNAMIC_FTRACE=3Dy
CONFIG_HAVE_DYNAMIC_FTRACE_WITH_REGS=3Dy
CONFIG_HAVE_FTRACE_MCOUNT_RECORD=3Dy
CONFIG_HAVE_SYSCALL_TRACEPOINTS=3Dy
CONFIG_HAVE_FENTRY=3Dy
CONFIG_HAVE_C_RECORDMCOUNT=3Dy
CONFIG_TRACER_MAX_TRACE=3Dy
CONFIG_TRACE_CLOCK=3Dy
CONFIG_RING_BUFFER=3Dy
CONFIG_EVENT_TRACING=3Dy
CONFIG_CONTEXT_SWITCH_TRACER=3Dy
CONFIG_RING_BUFFER_ALLOW_SWAP=3Dy
CONFIG_TRACING=3Dy
CONFIG_GENERIC_TRACER=3Dy
CONFIG_TRACING_SUPPORT=3Dy
CONFIG_FTRACE=3Dy
CONFIG_FUNCTION_TRACER=3Dy
CONFIG_FUNCTION_GRAPH_TRACER=3Dy
# CONFIG_PREEMPTIRQ_EVENTS is not set
# CONFIG_IRQSOFF_TRACER is not set
CONFIG_SCHED_TRACER=3Dy
CONFIG_HWLAT_TRACER=3Dy
CONFIG_FTRACE_SYSCALLS=3Dy
CONFIG_TRACER_SNAPSHOT=3Dy
# CONFIG_TRACER_SNAPSHOT_PER_CPU_SWAP is not set
CONFIG_BRANCH_PROFILE_NONE=3Dy
# CONFIG_PROFILE_ANNOTATED_BRANCHES is not set
# CONFIG_PROFILE_ALL_BRANCHES is not set
CONFIG_STACK_TRACER=3Dy
CONFIG_BLK_DEV_IO_TRACE=3Dy
CONFIG_KPROBE_EVENTS=3Dy
# CONFIG_KPROBE_EVENTS_ON_NOTRACE is not set
CONFIG_UPROBE_EVENTS=3Dy
CONFIG_BPF_EVENTS=3Dy
CONFIG_DYNAMIC_EVENTS=3Dy
CONFIG_PROBE_EVENTS=3Dy
CONFIG_DYNAMIC_FTRACE=3Dy
CONFIG_DYNAMIC_FTRACE_WITH_REGS=3Dy
CONFIG_FUNCTION_PROFILER=3Dy
# CONFIG_BPF_KPROBE_OVERRIDE is not set
CONFIG_FTRACE_MCOUNT_RECORD=3Dy
# CONFIG_FTRACE_STARTUP_TEST is not set
# CONFIG_MMIOTRACE is not set
CONFIG_TRACING_MAP=3Dy
CONFIG_HIST_TRIGGERS=3Dy
# CONFIG_TRACEPOINT_BENCHMARK is not set
CONFIG_RING_BUFFER_BENCHMARK=3Dm
# CONFIG_RING_BUFFER_STARTUP_TEST is not set
# CONFIG_PREEMPTIRQ_DELAY_TEST is not set
# CONFIG_TRACE_EVAL_MAP_FILE is not set
CONFIG_PROVIDE_OHCI1394_DMA_INIT=3Dy
CONFIG_RUNTIME_TESTING_MENU=3Dy
# CONFIG_LKDTM is not set
# CONFIG_TEST_LIST_SORT is not set
# CONFIG_TEST_SORT is not set
# CONFIG_KPROBES_SANITY_TEST is not set
# CONFIG_BACKTRACE_SELF_TEST is not set
# CONFIG_RBTREE_TEST is not set
# CONFIG_REED_SOLOMON_TEST is not set
# CONFIG_INTERVAL_TREE_TEST is not set
# CONFIG_PERCPU_TEST is not set
CONFIG_ATOMIC64_SELFTEST=3Dy
# CONFIG_ASYNC_RAID6_TEST is not set
# CONFIG_TEST_HEXDUMP is not set
# CONFIG_TEST_STRING_HELPERS is not set
CONFIG_TEST_STRSCPY=3Dm
# CONFIG_TEST_KSTRTOX is not set
CONFIG_TEST_PRINTF=3Dm
CONFIG_TEST_BITMAP=3Dm
# CONFIG_TEST_BITFIELD is not set
# CONFIG_TEST_UUID is not set
# CONFIG_TEST_XARRAY is not set
# CONFIG_TEST_OVERFLOW is not set
# CONFIG_TEST_RHASHTABLE is not set
# CONFIG_TEST_HASH is not set
# CONFIG_TEST_IDA is not set
CONFIG_TEST_LKM=3Dm
CONFIG_TEST_VMALLOC=3Dm
CONFIG_TEST_USER_COPY=3Dm
CONFIG_TEST_BPF=3Dm
CONFIG_TEST_BLACKHOLE_DEV=3Dm
# CONFIG_FIND_BIT_BENCHMARK is not set
CONFIG_TEST_FIRMWARE=3Dm
CONFIG_TEST_SYSCTL=3Dm
# CONFIG_TEST_UDELAY is not set
CONFIG_TEST_STATIC_KEYS=3Dm
CONFIG_TEST_KMOD=3Dm
# CONFIG_TEST_MEMCAT_P is not set
CONFIG_TEST_LIVEPATCH=3Dm
# CONFIG_TEST_STACKINIT is not set
# CONFIG_TEST_MEMINIT is not set
# CONFIG_MEMTEST is not set
# CONFIG_BUG_ON_DATA_CORRUPTION is not set
# CONFIG_SAMPLES is not set
CONFIG_HAVE_ARCH_KGDB=3Dy
# CONFIG_KGDB is not set
CONFIG_ARCH_HAS_UBSAN_SANITIZE_ALL=3Dy
# CONFIG_UBSAN is not set
CONFIG_UBSAN_ALIGNMENT=3Dy
CONFIG_ARCH_HAS_DEVMEM_IS_ALLOWED=3Dy
CONFIG_STRICT_DEVMEM=3Dy
# CONFIG_IO_STRICT_DEVMEM is not set
CONFIG_TRACE_IRQFLAGS_SUPPORT=3Dy
CONFIG_EARLY_PRINTK_USB=3Dy
CONFIG_X86_VERBOSE_BOOTUP=3Dy
CONFIG_EARLY_PRINTK=3Dy
CONFIG_EARLY_PRINTK_DBGP=3Dy
# CONFIG_EARLY_PRINTK_USB_XDBC is not set
# CONFIG_X86_PTDUMP is not set
# CONFIG_EFI_PGT_DUMP is not set
# CONFIG_DEBUG_WX is not set
CONFIG_DOUBLEFAULT=3Dy
# CONFIG_DEBUG_TLBFLUSH is not set
# CONFIG_IOMMU_DEBUG is not set
CONFIG_HAVE_MMIOTRACE_SUPPORT=3Dy
CONFIG_X86_DECODER_SELFTEST=3Dy
CONFIG_IO_DELAY_0X80=3Dy
# CONFIG_IO_DELAY_0XED is not set
# CONFIG_IO_DELAY_UDELAY is not set
# CONFIG_IO_DELAY_NONE is not set
CONFIG_DEBUG_BOOT_PARAMS=3Dy
# CONFIG_CPA_DEBUG is not set
# CONFIG_DEBUG_ENTRY is not set
# CONFIG_DEBUG_NMI_SELFTEST is not set
CONFIG_X86_DEBUG_FPU=3Dy
# CONFIG_PUNIT_ATOM_DEBUG is not set
CONFIG_UNWINDER_ORC=3Dy
# CONFIG_UNWINDER_FRAME_POINTER is not set
# CONFIG_UNWINDER_GUESS is not set
# end of Kernel hacking


----- End forwarded message -----
