Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CA84114C9DC
	for <lists+stable@lfdr.de>; Wed, 29 Jan 2020 12:43:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726067AbgA2LnS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 29 Jan 2020 06:43:18 -0500
Received: from mail-pl1-f178.google.com ([209.85.214.178]:42238 "EHLO
        mail-pl1-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726068AbgA2LnS (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 29 Jan 2020 06:43:18 -0500
Received: by mail-pl1-f178.google.com with SMTP id p9so6358390plk.9;
        Wed, 29 Jan 2020 03:43:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=M2UtlNqffzVUa5LURTt3UwKtQ4jyPZE8r8yYFMMgt30=;
        b=J1y+GJ/1zjyuaXe8yAHSURFox6sqsWx8p5goCQYDN0Nr46u0/DNeeoibloe4W/FHD0
         EYU30+7XYGG+gtH7k7gvnDBBt49Kgz2Owo33CICDitSIeYAeD8G2GTOKL0W9ko8L8um4
         0Ph8AvVHCFrERCdVFS7Ds9qp2hxffHUXU6RvZIDg0VUIfpcbxUrN4FzMBK7849EG5KzX
         T7hRVSpwbTH2Mzsw2sZ4B+DmS8fpdFb5xVEs+aHC6ZX/Oa1jNYJiLhkCUCqwI7xEq2pz
         DJTQSzLUnqTjaPR8BY8i0/uYKUYD9o2kSFm+55nMKdgfUHl/Nktvq34eL4r5jfbGYCLR
         FVCQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=M2UtlNqffzVUa5LURTt3UwKtQ4jyPZE8r8yYFMMgt30=;
        b=Tkj9bxRU9ZJeCvomZnGBWTfZmdEuysbwQQFFV5tFvx4HL/1aSdlkXkPoMjC3Ap5z12
         P8MncljiZmO5id5teWEz6ikrDYG9uwBwAqOpzA46djrqoRfyaUUXAjA/Pk5S9StIsh78
         +kkutmTPHvv4kt8fT0/Xit1Wx416ygEMnd3r8GjUaPV//DPZiX+EaSN+0Acle/HHNwFd
         Y64uOENFxNv3Xbbw7T3qY/GPFX5diTJmqbQQV6cgsgKnzohT7KulQz4Jn9YyGGsg1ArT
         EhPpb8u7onDQlf4XwafR4y5otIjeNChNpBFndQANG4yRsfc3NfO6YTW7BNVlCTMQyQN6
         Gc6g==
X-Gm-Message-State: APjAAAXH5akcWwKOD92sxDHv7K3atdMqAKDu6Cv+B4rrcz10UlyoSRTt
        BkGZYksZeOlo8l/DXE8qDYJRGDXoJ0qtrpVoGcCggHDLl6PZ3A==
X-Google-Smtp-Source: APXvYqxHblHql8OOVa71GKKRzuaFk+ZS+fuZ38URk03w57AjP2TYPsxZpo5L4t95b3uZw5A0L4Z2TLncDlVrSgL97xw=
X-Received: by 2002:a17:902:bcc8:: with SMTP id o8mr4757016pls.74.1580298192824;
 Wed, 29 Jan 2020 03:43:12 -0800 (PST)
MIME-Version: 1.0
References: <1579617717-4098-1-git-send-email-vipulk0511@gmail.com>
 <87eevs7lfd.fsf@nanos.tec.linutronix.de> <CADdC98RJpsvu_zWehNGDDN=W11rD11NSPaodg-zuaXsHuOJYTQ@mail.gmail.com>
 <878slzeeim.fsf@nanos.tec.linutronix.de> <CADdC98TE4oNWZyEsqXzr+zJtfdTTOyeeuHqu1u04X_ktLHo-Hg@mail.gmail.com>
 <20200123144108.GU32742@smile.fi.intel.com> <df04f43d-8c6d-7602-cb50-535b85cf2aaa@redhat.com>
In-Reply-To: <df04f43d-8c6d-7602-cb50-535b85cf2aaa@redhat.com>
From:   vipul kumar <vipulk0511@gmail.com>
Date:   Wed, 29 Jan 2020 17:13:01 +0530
Message-ID: <CADdC98TW_i27M0_nMNNjtdiwvJcLMsxrEPtGhDvoRQ3Wt30-cw@mail.gmail.com>
Subject: Re: [v3] x86/tsc: Unset TSC_KNOWN_FREQ and TSC_RELIABLE flags on
 Intel Bay Trail SoC
To:     Hans de Goede <hdegoede@redhat.com>
Cc:     Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        linux-kernel@vger.kernel.org, Stable <stable@vger.kernel.org>,
        Srikanth Krishnakar <Srikanth_Krishnakar@mentor.com>,
        Cedric Hombourger <Cedric_Hombourger@mentor.com>,
        x86@kernel.org, Bin Gao <bin.gao@linux.intel.com>,
        Len Brown <len.brown@intel.com>,
        Vipul Kumar <vipul_kumar@mentor.com>
Content-Type: multipart/mixed; boundary="0000000000006c7a13059d45d816"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

--0000000000006c7a13059d45d816
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi Hans,

On Fri, Jan 24, 2020 at 2:48 AM Hans de Goede <hdegoede@redhat.com> wrote:
>
> Hi,
>
> Sorry for top posting, but this is a long and almost unreadable thread ..=
.
>
> So it seems to me that a better fix would be to change the freq_desc_byt =
struct from:
>
> static const struct freq_desc freq_desc_byt =3D {
>          1, { 83300, 100000, 133300, 116700, 80000, 0, 0, 0 }
> };
>
> to:
>
> static const struct freq_desc freq_desc_byt =3D {
>          1, { 83333, 100000, 133300, 116700, 80000, 0, 0, 0 }
> };
>
> That should give us the right TSC frequency without needing to mess with
> the TSC_KNOWN_FREQ and TSC_RELIABLE flags.

Tried with your suggested changes. With these changes, time drift
issue didn't observe.
root@debian:# echo -n "SystemTime: " ; TZ=3DUTC date -Iseconds ; echo -n
"RTC Time:   " ; TZ=3DUTC hwclock -r ; echo -n "Uptime: " ; uptime -p
SystemTime: 2020-01-29T04:48:44+00:00
RTC Time:   2020-01-29 04:48:44.538724+0000
Uptime: up 19 hours, 19 minutes

root@debian:# dmesg | grep tsc
[    0.000000] tsc: Detected 1833.326 MHz processor
[    0.427795] clocksource: tsc-early: mask: 0xffffffffffffffff
max_cycles: 0x34da46d1768, max_idle_ns: 881590610985 ns
[    1.777662] clocksource: Switched to clocksource tsc-early
[    4.731126] clocksource: tsc: mask: 0xffffffffffffffff max_cycles:
0x34da46d1768, max_idle_ns: 881590610985 ns
[    4.731168] clocksource: Switched to clocksource tsc
root@debian:#

Complete logs with these changes along with Thomas debug patch attached.

patch:

--- a/arch/x86/kernel/tsc_msr.c
+++ b/arch/x86/kernel/tsc_msr.c
@@ -43,7 +43,7 @@ static const struct freq_desc freq_desc_clv =3D {
 };

 static const struct freq_desc freq_desc_byt =3D {
-       1, { 83300, 100000, 133300, 116700, 80000, 0, 0, 0 }
+       1, { 83333, 100000, 133300, 116700, 80000, 0, 0, 0 }
 };

 static const struct freq_desc freq_desc_cht =3D {
@@ -94,16 +94,22 @@ unsigned long cpu_khz_from_msr(void)
        if (freq_desc->msr_plat) {
                rdmsr(MSR_PLATFORM_INFO, lo, hi);
                ratio =3D (lo >> 8) & 0xff;
+               pr_info("MSR_PINFO: %08x%08x -> %u\n", hi, lo, ratio);
        } else {
                rdmsr(MSR_IA32_PERF_STATUS, lo, hi);
                ratio =3D (hi >> 8) & 0x1f;
+               pr_info("MSR_PSTAT: %08x%08x -> %u\n", hi, lo, ratio);
        }

        /* Get FSB FREQ ID */
+       pr_err("tsc msr id match %ld lo 0x%02x\n",  id - tsc_msr_cpu_ids, l=
o);
        rdmsr(MSR_FSB_FREQ, lo, hi);
+       pr_info("MSR_FSBF: %08x%08x\n", hi, lo);
+       pr_err("tsc msr id match %ld lo 0x%02x\n",  id - tsc_msr_cpu_ids, l=
o);

        /* Map CPU reference clock freq ID(0-7) to CPU reference clock
freq(KHz) */
        freq =3D freq_desc->freqs[lo & 0x7];
+       pr_info("REF_CLOCK: %08x\n", freq);

        /* TSC frequency =3D maximum resolved freq * maximum resolved bus r=
atio */
        res =3D freq * ratio;

Regards,
Vipul

>
> Regards,
>
> Hans
>
>
> On 23-01-2020 15:41, Andy Shevchenko wrote:
> > +Cc: Hans, since he possesses a lot of BYT devices and may be intereste=
d in this
> >
> > On Thu, Jan 23, 2020 at 06:00:28PM +0530, vipul kumar wrote:
> >> Hi Thomas,
> >>
> >> On Wed, Jan 22, 2020 at 8:15 PM Thomas Gleixner <tglx@linutronix.de> w=
rote:
> >>
> >>> Vipul,
> >>>
> >>> vipul kumar <vipulk0511@gmail.com> writes:
> >>>> On Tue, Jan 21, 2020 at 11:15 PM Thomas Gleixner <tglx@linutronix.de=
>
> >>> wrote:
> >>>
> >>>>     Measurement with the existing code:
> >>>>     $ echo -n "SystemTime: " ; TZ=3DUTC date -Iseconds ; echo -n "RT=
C Time:
> >>>> " ; TZ=3DUTC hwclock -r ; echo -n "Uptime: " ; uptime -p
> >>>>     SystemTime: 2019-12-05T17:18:37+00:00
> >>>>     RTC Time:   2019-12-05 17:18:07.255341+0000
> >>>>     Uptime: up 1 day, 7 minutes
> >>>>
> >>>>     This sample shows a difference of 30 seconds after 1 day.
> >>>>
> >>>>     Measurement with this patch:
> >>>>     SystemTime: 2019-12-11T12:06:19+00:00
> >>>>     RTC Time:   2019-12-11 12:06:19.083127+0000
> >>>>     Uptime: up 1 day, 3 minutes
> >>>>
> >>>>     With this patch, no time drift issue is observed. and tsc clocks=
ource
> >>>> get calibration (tsc: Refined TSC clocksource calibration: 1833.333 =
MHz)
> >>>> which is missing
> >>>>     with the existing implementation.
> >>>
> >>> What's the frequency which is determined from the MSR? Something like
> >>> this in dmesg:
> >>>
> >>>         tsc: Detected NNN MHz processor
> >>> or
> >>>         tsc: Detected NNN MHz TSC
> >>>
> >>
> >>     tsc: Detected 1832.600 MHz processor
> >>
> >>     # dmesg | grep tsc
> >>     [    0.000000] tsc: Detected 1832.600 MHz processor
> >>     [    4.895129] tsc: Refined TSC clocksource calibration: 1833.332 =
MHz
> >>     [    4.895201] clocksource: tsc: mask: 0xffffffffffffffff max_cycl=
es:
> >> 0x34da5269766, max_idle_ns: 881590747508 ns
> >>     [    5.903264] clocksource: Switched to clocksource tsc
> >>
> >>     Attached full logs with patch and without patch.
> >>
> >>>
> >>> Also please apply the debug patch below and provide a _full_ dmesg af=
ter
> >>> boot.
> >>>
> >>>>>> +config X86_FEATURE_TSC_UNKNOWN_FREQ
> >>>>>> +     bool "Support to skip tsc known frequency flag"
> >>>>>> +     help
> >>>>>> +       Include support to skip X86_FEATURE_TSC_KNOWN_FREQ flag
> >>>>>> +
> >>>>>> +       X86_FEATURE_TSC_KNOWN_FREQ flag is causing time-drift on
> >>>>> Valleyview/
> >>>>>> +       Baytrail SoC.
> >>>>>> +       By selecting this option, user can skip
> >>>>> X86_FEATURE_TSC_KNOWN_FREQ
> >>>>>> +       flag to use refine tsc freq calibration.
> >>>>>
> >>>>> This is exactly the same problem as before. How does anyone aside o=
f you
> >>>>> know whether to enable this or not?
> >>>>>
> >>>>      Go through the Documentation/kbuild/kconfig-language.rst but di=
dn't
> >>>> find related to make
> >>>>      config known to everyone. Could you please point to documentati=
on?
> >>>
> >>> Right. And there is no proper answer to this, which makes it clear th=
at
> >>> a config option is not the right tool to use.
> >>>
> >>>>> And if someone enables this option then _ALL_ platforms which utili=
ze
> >>>>> cpu_khz_from_msr() are affected. How is that any different from you=
r
> >>>>> previous approach? This works on local kernels where you build for =
a
> >>>>> specific platform and you know exactly what you're doing, but not f=
or
> >>>>> general consumption. What should a distro do with this option?
> >>>>>
> >>>>>
> >>>>      TSC frequency is already calculated in cpu_khz_from_msr() funct=
ion
> >>>> before setting these flags.
> >>>
> >>> Your mail client does some horrible formatting this zig-zag is
> >>> unreadable. I'm reformatting the paragraphs below.
> >>>
> >>
> >>    Sorry for that. Need to set formatting for reply.
> >>
> >>>
> >>>> This patch return the same calculated TSC frequency but skipping
> >>>> those two flags. On the basis of these flags, we decide whether we
> >>>> skip the refined calibration and directly register it as a clocksour=
ce
> >>>> or use refine tsc freq calibration in init_tsc_clocksource()
> >>>> function. By default this config is disabled and if user wants to us=
e
> >>>> refine tsc freq calibration() then only user will enable it otherwis=
e
> >>>> it will go with existing implementations. So, I don't think so it wi=
ll
> >>>> break for other ATOM SoC.
> >>>
> >>> It does. I explained most of the following to you in an earlier mail
> >>> already. Let me try again.
> >>>
> >>> If X86_FEATURE_TSC_RELIABLE is not set, then the TSC requires a watch=
dog
> >>> clocksource. But some of those SoCs do not have anything else than TS=
C,
> >>> so there is no watchdog available. As a consequence the TSC is not
> >>> usable for high resolution timers and NOHZ. That breaks existing syst=
ems
> >>> whether you like it or not.
> >>>
> >>> If X86_FEATURE_TSC_KNOWN_FREQUENCY is not set, then this delays the
> >>> usability of the TSC for high res and NOHZ until the refined calibrat=
ion
> >>> figured out that it can't calibrate. And no, we can't know that it do=
es
> >>> not work upfront when the early TSC init happens. Clearing this flag
> >>> will not break functionality, but it changes the behaviour on boot-ti=
me
> >>> optimized systems which can obviously be considered breakage.
> >>>
> >>> So no, having a config knob which might be turned on and turning work=
ing
> >>> systems into trainwrecks is simply not the way to go.
> >>>
> >>
> >>     Thanks Thomas for clarifying about reliable and known frequency fl=
ags.
> >>
> >>>
> >>> What can be done is to have a command line option which enforces refi=
ned
> >>> calibration and that option can turn off X86_FEATURE_TSC_KNOWN_FREQUE=
NCY,
> >>> but nothing else.
> >>>
> >>
> >>      Sure Thomas, will make implementation as per your suggestion.
> >>
> >>      Regards,
> >>      Vipul
> >>
> >>>
> >>>> Check the cpu_khz_from_msr() function.
> >>>
> >>> I know that code.
> >>>
> >>>> In cpu_khz_from_msr() function we are setting
> >>>> X86_FEATURE_TSC_KNOWN_FREQ and X86_FEATURE_TSC_RELIABLE for all the
> >>>> SoC's but in native_calibrate_tsc(), we check for vendor =3D=3D INTE=
L and
> >>>> CPUID > 0x15 and then at the end of function, will enable
> >>>> X86_FEATURE_TSC_RELIABLE for INTEL_FAM6_ATOM_GOLDMONT SoC.
> >>>>
> >>>> Do we need to set the same flag in two different functions as it wil=
l be
> >>>> set in cpu_khz_from_msr() for all SoCs ?
> >>>
> >>> cpu_khz_from_msr() does not handle INTEL_FAM6_ATOM_GOLDMONT or can yo=
u
> >>> find that in tsc_msr_cpu_ids[]? Making half informed claims is not
> >>> solving anything.
> >>>
> >>> Thanks,
> >>>
> >>>          tglx
> >>>
> >>> 8<------------------
> >>>
> >>> --- a/arch/x86/kernel/tsc_msr.c
> >>> +++ b/arch/x86/kernel/tsc_msr.c
> >>> @@ -94,16 +94,20 @@ unsigned long cpu_khz_from_msr(void)
> >>>          if (freq_desc->msr_plat) {
> >>>                  rdmsr(MSR_PLATFORM_INFO, lo, hi);
> >>>                  ratio =3D (lo >> 8) & 0xff;
> >>> +               pr_info("MSR_PINFO: %08x%08x -> %u\n", hi, lo, ratio)=
;
> >>>          } else {
> >>>                  rdmsr(MSR_IA32_PERF_STATUS, lo, hi);
> >>>                  ratio =3D (hi >> 8) & 0x1f;
> >>> +               pr_info("MSR_PSTAT: %08x%08x -> %u\n", hi, lo, ratio)=
;
> >>>          }
> >>>
> >>>          /* Get FSB FREQ ID */
> >>>          rdmsr(MSR_FSB_FREQ, lo, hi);
> >>> +       pr_info("MSR_FSBF: %08x%08x\n", hi, lo);
> >>>
> >>>          /* Map CPU reference clock freq ID(0-7) to CPU reference clo=
ck
> >>> freq(KHz) */
> >>>          freq =3D freq_desc->freqs[lo & 0x7];
> >>> +       pr_info("REF_CLOCK: %08x\n", freq);
> >>>
> >>>          /* TSC frequency =3D maximum resolved freq * maximum resolve=
d bus
> >>> ratio */
> >>>          res =3D freq * ratio;
> >>>
> >
> >> root@localhost:# dmesg
> >> [    0.000000] microcode: microcode updated early to revision 0x838, d=
ate =3D 2019-04-22
> >> [    0.000000] Linux version 4.14.139-rt66 (builder@vipul) (gcc versio=
n 6.3.0 20170516 (Debian 6.3.0-18+deb9u1)) #1 SMP PREEMPT RT Thu Jan 23 11:=
04:55 UTC 2020
> >> [    0.000000] Command line: rootwait quiet     rootflags=3Di_version =
ima_tcb ima_appraise=3Denforce ima_appraise_tcb  nohz=3Doff        splash p=
lymouth.ignore-serial-consoles quiet        root=3D/dev/mapper/system-syste=
ma
> >>
> >> [    0.000000] x86/fpu: x87 FPU will use FXSAVE
> >> [    0.000000] e820: BIOS-provided physical RAM map:
> >> [    0.000000] BIOS-e820: [mem 0x0000000000000000-0x000000000006efff] =
usable
> >> [    0.000000] BIOS-e820: [mem 0x000000000006f000-0x000000000006ffff] =
ACPI NVS
> >> [    0.000000] BIOS-e820: [mem 0x0000000000070000-0x000000000008ffff] =
usable
> >> [    0.000000] BIOS-e820: [mem 0x0000000000090000-0x000000000009ffff] =
reserved
> >> [    0.000000] BIOS-e820: [mem 0x0000000000100000-0x00000000b7af2fff] =
usable
> >> [    0.000000] BIOS-e820: [mem 0x00000000b7af3000-0x00000000b8402fff] =
reserved
> >> [    0.000000] BIOS-e820: [mem 0x00000000b8403000-0x00000000b8502fff] =
ACPI NVS
> >> [    0.000000] BIOS-e820: [mem 0x00000000b8503000-0x00000000b8542fff] =
ACPI data
> >> [    0.000000] BIOS-e820: [mem 0x00000000b8543000-0x00000000b93c2fff] =
usable
> >> [    0.000000] BIOS-e820: [mem 0x00000000b93c3000-0x00000000b9cc2fff] =
reserved
> >> [    0.000000] BIOS-e820: [mem 0x00000000b9cc3000-0x00000000b9ffffff] =
usable
> >> [    0.000000] BIOS-e820: [mem 0x00000000e00f8000-0x00000000e00f8fff] =
reserved
> >> [    0.000000] BIOS-e820: [mem 0x00000000fed01000-0x00000000fed01fff] =
reserved
> >> [    0.000000] BIOS-e820: [mem 0x00000000ffb00000-0x00000000ffffffff] =
reserved
> >> [    0.000000] BIOS-e820: [mem 0x0000000100000000-0x000000023fffffff] =
usable
> >> [    0.000000] NX (Execute Disable) protection: active
> >> [    0.000000] e820: update [mem 0xb43d3018-0xb43e3057] usable =3D=3D>=
 usable
> >> [    0.000000] e820: update [mem 0xb43d3018-0xb43e3057] usable =3D=3D>=
 usable
> >> [    0.000000] extended physical RAM map:
> >> [    0.000000] reserve setup_data: [mem 0x0000000000000000-0x000000000=
006efff] usable
> >> [    0.000000] reserve setup_data: [mem 0x000000000006f000-0x000000000=
006ffff] ACPI NVS
> >> [    0.000000] reserve setup_data: [mem 0x0000000000070000-0x000000000=
008ffff] usable
> >> [    0.000000] reserve setup_data: [mem 0x0000000000090000-0x000000000=
009ffff] reserved
> >> [    0.000000] reserve setup_data: [mem 0x0000000000100000-0x00000000b=
43d3017] usable
> >> [    0.000000] reserve setup_data: [mem 0x00000000b43d3018-0x00000000b=
43e3057] usable
> >> [    0.000000] reserve setup_data: [mem 0x00000000b43e3058-0x00000000b=
7af2fff] usable
> >> [    0.000000] reserve setup_data: [mem 0x00000000b7af3000-0x00000000b=
8402fff] reserved
> >> [    0.000000] reserve setup_data: [mem 0x00000000b8403000-0x00000000b=
8502fff] ACPI NVS
> >> [    0.000000] reserve setup_data: [mem 0x00000000b8503000-0x00000000b=
8542fff] ACPI data
> >> [    0.000000] reserve setup_data: [mem 0x00000000b8543000-0x00000000b=
93c2fff] usable
> >> [    0.000000] reserve setup_data: [mem 0x00000000b93c3000-0x00000000b=
9cc2fff] reserved
> >> [    0.000000] reserve setup_data: [mem 0x00000000b9cc3000-0x00000000b=
9ffffff] usable
> >> [    0.000000] reserve setup_data: [mem 0x00000000e00f8000-0x00000000e=
00f8fff] reserved
> >> [    0.000000] reserve setup_data: [mem 0x00000000fed01000-0x00000000f=
ed01fff] reserved
> >> [    0.000000] reserve setup_data: [mem 0x00000000ffb00000-0x00000000f=
fffffff] reserved
> >> [    0.000000] reserve setup_data: [mem 0x0000000100000000-0x000000023=
fffffff] usable
> >> [    0.000000] efi: EFI v2.40 by INSYDE Corp.
> >> [    0.000000] efi:  ACPI 2.0=3D0xb8542014  ESRT=3D0xb7be2d18  SMBIOS=
=3D0xb7dfa000
> >> [    0.000000] SMBIOS 2.7 present.
> >> [    0.000000] DMI: SIEMENS AG SIMATIC IPC227E/A5E38155677, BIOS V20.0=
1.12 04/05/2019
> >> [    0.000000] e820: update [mem 0x00000000-0x00000fff] usable =3D=3D>=
 reserved
> >> [    0.000000] e820: remove [mem 0x000a0000-0x000fffff] usable
> >> [    0.000000] e820: last_pfn =3D 0x240000 max_arch_pfn =3D 0x40000000=
0
> >> [    0.000000] MTRR default type: uncachable
> >> [    0.000000] MTRR fixed ranges enabled:
> >> [    0.000000]   00000-9FFFF write-back
> >> [    0.000000]   A0000-BFFFF uncachable
> >> [    0.000000]   C0000-FFFFF write-protect
> >> [    0.000000] MTRR variable ranges enabled:
> >> [    0.000000]   0 base 0FF800000 mask FFF800000 write-protect
> >> [    0.000000]   1 base 000000000 mask F80000000 write-back
> >> [    0.000000]   2 base 080000000 mask FC0000000 write-back
> >> [    0.000000]   3 base 0BC000000 mask FFC000000 uncachable
> >> [    0.000000]   4 base 0BB000000 mask FFF000000 uncachable
> >> [    0.000000]   5 base 0BAE00000 mask FFFE00000 uncachable
> >> [    0.000000]   6 base 100000000 mask F00000000 write-back
> >> [    0.000000]   7 base 200000000 mask FC0000000 write-back
> >> [    0.000000] x86/PAT: Configuration [0-7]: WB  WC  UC- UC  WB  WP  U=
C- WT
> >> [    0.000000] e820: last_pfn =3D 0xba000 max_arch_pfn =3D 0x400000000
> >> [    0.000000] Base memory trampoline at [ffff9b900008a000] 8a000 size=
 24576
> >> [    0.000000] BRK [0x1ced18000, 0x1ced18fff] PGTABLE
> >> [    0.000000] BRK [0x1ced19000, 0x1ced19fff] PGTABLE
> >> [    0.000000] BRK [0x1ced1a000, 0x1ced1afff] PGTABLE
> >> [    0.000000] BRK [0x1ced1b000, 0x1ced1bfff] PGTABLE
> >> [    0.000000] BRK [0x1ced1c000, 0x1ced1cfff] PGTABLE
> >> [    0.000000] BRK [0x1ced1d000, 0x1ced1dfff] PGTABLE
> >> [    0.000000] BRK [0x1ced1e000, 0x1ced1efff] PGTABLE
> >> [    0.000000] BRK [0x1ced1f000, 0x1ced1ffff] PGTABLE
> >> [    0.000000] BRK [0x1ced20000, 0x1ced20fff] PGTABLE
> >> [    0.000000] BRK [0x1ced21000, 0x1ced21fff] PGTABLE
> >> [    0.000000] BRK [0x1ced22000, 0x1ced22fff] PGTABLE
> >> [    0.000000] Secure boot could not be determined
> >> [    0.000000] RAMDISK: [mem 0xadc31000-0xafffffff]
> >> [    0.000000] ACPI: Early table checksum verification disabled
> >> [    0.000000] ACPI: RSDP 0x00000000B8542014 000024 (v02 SIEMEN)
> >> [    0.000000] ACPI: XSDT 0x00000000B8542120 00009C (v01 SIEMEN SIMATI=
C  11112222      01000013)
> >> [    0.000000] ACPI: FACP 0x00000000B853B000 00010C (v05 SIEMEN SIMATI=
C  11112222 WAS_ 00010001)
> >> [    0.000000] ACPI: DSDT 0x00000000B8530000 006A5B (v02 SIEMEN SIMATI=
C  11112222 WAS_ 00010001)
> >> [    0.000000] ACPI: FACS 0x00000000B84AA000 000040
> >> [    0.000000] ACPI: UEFI 0x00000000B8541000 000236 (v01 SIEMEN SIMATI=
C  00000001 WAS_ 12345678)
> >> [    0.000000] ACPI: TCPA 0x00000000B8540000 000032 (v02 SIEMEN SIMATI=
C  00000000 WAS_ 00000000)
> >> [    0.000000] ACPI: UEFI 0x00000000B853E000 000042 (v01 SIEMEN SIMATI=
C  00000000 WAS_ 00000000)
> >> [    0.000000] ACPI: SSDT 0x00000000B853D000 0004FD (v01 SIEMEN TPMACP=
I  00001000 WAS_ 20121114)
> >> [    0.000000] ACPI: TPM2 0x00000000B853C000 000034 (v03 SIEMEN SIMATI=
C  00000000 WAS_ 00000000)
> >> [    0.000000] ACPI: HPET 0x00000000B853A000 000038 (v01 SIEMEN SIMATI=
C  11112222 WAS_ 00010001)
> >> [    0.000000] ACPI: LPIT 0x00000000B8539000 000104 (v01 SIEMEN SIMATI=
C  11112222 WAS_ 00010001)
> >> [    0.000000] ACPI: APIC 0x00000000B8538000 000084 (v03 SIEMEN SIMATI=
C  11112222 WAS_ 00010001)
> >> [    0.000000] ACPI: MCFG 0x00000000B8537000 00003C (v01 SIEMEN SIMATI=
C  11112222 WAS_ 00010001)
> >> [    0.000000] ACPI: SSDT 0x00000000B852E000 000763 (v01 SIEMEN CpuPm =
   00003000 WAS_ 20121114)
> >> [    0.000000] ACPI: SSDT 0x00000000B852D000 000290 (v01 SIEMEN Cpu0Ts=
t  00003000 WAS_ 20121114)
> >> [    0.000000] ACPI: SSDT 0x00000000B852C000 00017A (v01 SIEMEN ApTst =
   00003000 WAS_ 20121114)
> >> [    0.000000] ACPI: FPDT 0x00000000B852B000 000044 (v01 SIEMEN SIMATI=
C  00000002 WAS_ 01000013)
> >> [    0.000000] ACPI: BGRT 0x00000000B852F000 000038 (v01 SIEMEN SIMATI=
C  00000001 WAS_ 12345678)
> >> [    0.000000] ACPI: Local APIC address 0xfee00000
> >> [    0.000000] No NUMA configuration found
> >> [    0.000000] Faking a node at [mem 0x0000000000000000-0x000000023fff=
ffff]
> >> [    0.000000] NODE_DATA(0) allocated [mem 0x23fff7000-0x23fffbfff]
> >> [    0.000000] Zone ranges:
> >> [    0.000000]   DMA      [mem 0x0000000000001000-0x0000000000ffffff]
> >> [    0.000000]   DMA32    [mem 0x0000000001000000-0x00000000ffffffff]
> >> [    0.000000]   Normal   [mem 0x0000000100000000-0x000000023fffffff]
> >> [    0.000000]   Device   empty
> >> [    0.000000] Movable zone start for each node
> >> [    0.000000] Early memory node ranges
> >> [    0.000000]   node   0: [mem 0x0000000000001000-0x000000000006efff]
> >> [    0.000000]   node   0: [mem 0x0000000000070000-0x000000000008ffff]
> >> [    0.000000]   node   0: [mem 0x0000000000100000-0x00000000b7af2fff]
> >> [    0.000000]   node   0: [mem 0x00000000b8543000-0x00000000b93c2fff]
> >> [    0.000000]   node   0: [mem 0x00000000b9cc3000-0x00000000b9ffffff]
> >> [    0.000000]   node   0: [mem 0x0000000100000000-0x000000023fffffff]
> >> [    0.000000] Initmem setup node 0 [mem 0x0000000000001000-0x00000002=
3fffffff]
> >> [    0.000000] On node 0 totalpages: 2067518
> >> [    0.000000]   DMA zone: 64 pages used for memmap
> >> [    0.000000]   DMA zone: 21 pages reserved
> >> [    0.000000]   DMA zone: 3982 pages, LIFO batch:0
> >> [    0.000000]   DMA32 zone: 11763 pages used for memmap
> >> [    0.000000]   DMA32 zone: 752816 pages, LIFO batch:31
> >> [    0.000000]   Normal zone: 20480 pages used for memmap
> >> [    0.000000]   Normal zone: 1310720 pages, LIFO batch:31
> >> [    0.000000] x86/hpet: Will disable the HPET for this platform becau=
se it's not reliable
> >> [    0.000000] Reserving Intel graphics memory at 0x00000000bb000000-0=
x00000000beffffff
> >> [    0.000000] ACPI: PM-Timer IO Port: 0x408
> >> [    0.000000] ACPI: Local APIC address 0xfee00000
> >> [    0.000000] ACPI: LAPIC_NMI (acpi_id[0x01] high level lint[0x1])
> >> [    0.000000] ACPI: LAPIC_NMI (acpi_id[0x02] high level lint[0x1])
> >> [    0.000000] ACPI: LAPIC_NMI (acpi_id[0x03] high level lint[0x1])
> >> [    0.000000] ACPI: LAPIC_NMI (acpi_id[0x04] high level lint[0x1])
> >> [    0.000000] IOAPIC[0]: apic_id 2, version 32, address 0xfec00000, G=
SI 0-86
> >> [    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl=
)
> >> [    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 high le=
vel)
> >> [    0.000000] ACPI: IRQ0 used by override.
> >> [    0.000000] ACPI: IRQ9 used by override.
> >> [    0.000000] Using ACPI (MADT) for SMP configuration information
> >> [    0.000000] ACPI: HPET id: 0x8086a201 base: 0xfed00000
> >> [    0.000000] smpboot: Allowing 4 CPUs, 0 hotplug CPUs
> >> [    0.000000] PM: Registered nosave memory: [mem 0x00000000-0x00000ff=
f]
> >> [    0.000000] PM: Registered nosave memory: [mem 0x0006f000-0x0006fff=
f]
> >> [    0.000000] PM: Registered nosave memory: [mem 0x00090000-0x0009fff=
f]
> >> [    0.000000] PM: Registered nosave memory: [mem 0x000a0000-0x000ffff=
f]
> >> [    0.000000] PM: Registered nosave memory: [mem 0xb43d3000-0xb43d3ff=
f]
> >> [    0.000000] PM: Registered nosave memory: [mem 0xb43e3000-0xb43e3ff=
f]
> >> [    0.000000] PM: Registered nosave memory: [mem 0xb7af3000-0xb8402ff=
f]
> >> [    0.000000] PM: Registered nosave memory: [mem 0xb8403000-0xb8502ff=
f]
> >> [    0.000000] PM: Registered nosave memory: [mem 0xb8503000-0xb8542ff=
f]
> >> [    0.000000] PM: Registered nosave memory: [mem 0xb93c3000-0xb9cc2ff=
f]
> >> [    0.000000] PM: Registered nosave memory: [mem 0xba000000-0xbafffff=
f]
> >> [    0.000000] PM: Registered nosave memory: [mem 0xbb000000-0xbefffff=
f]
> >> [    0.000000] PM: Registered nosave memory: [mem 0xbf000000-0xe00f7ff=
f]
> >> [    0.000000] PM: Registered nosave memory: [mem 0xe00f8000-0xe00f8ff=
f]
> >> [    0.000000] PM: Registered nosave memory: [mem 0xe00f9000-0xfed00ff=
f]
> >> [    0.000000] PM: Registered nosave memory: [mem 0xfed01000-0xfed01ff=
f]
> >> [    0.000000] PM: Registered nosave memory: [mem 0xfed02000-0xffaffff=
f]
> >> [    0.000000] PM: Registered nosave memory: [mem 0xffb00000-0xfffffff=
f]
> >> [    0.000000] e820: [mem 0xbf000000-0xe00f7fff] available for PCI dev=
ices
> >> [    0.000000] Booting paravirtualized kernel on bare hardware
> >> [    0.000000] clocksource: refined-jiffies: mask: 0xffffffff max_cycl=
es: 0xffffffff, max_idle_ns: 1910969940391419 ns
> >> [    0.000000] setup_percpu: NR_CPUS:512 nr_cpumask_bits:512 nr_cpu_id=
s:4 nr_node_ids:1
> >> [    0.000000] percpu: Embedded 226 pages/cpu s886080 r8192 d31424 u10=
48576
> >> [    0.000000] pcpu-alloc: s886080 r8192 d31424 u1048576 alloc=3D1*209=
7152
> >> [    0.000000] pcpu-alloc: [0] 0 1 [0] 2 3
> >> [    0.000000] Built 1 zonelists, mobility grouping on.  Total pages: =
2035190
> >> [    0.000000] Policy zone: Normal
> >> [    0.000000] Kernel command line: rootwait quiet     rootflags=3Di_v=
ersion ima_tcb ima_appraise=3Denforce ima_appraise_tcb  nohz=3Doff        s=
plash plymouth.ignore-serial-consoles quiet        root=3D/dev/mapper/syste=
m-systema
> >>
> >> [    0.000000] PID hash table entries: 4096 (order: 3, 32768 bytes)
> >> [    0.000000] Calgary: detecting Calgary via BIOS EBDA area
> >> [    0.000000] Calgary: Unable to locate Rio Grande table in EBDA - ba=
iling!
> >> [    0.000000] Memory: 8008768K/8270072K available (10252K kernel code=
, 1185K rwdata, 3080K rodata, 2228K init, 856K bss, 261304K reserved, 0K cm=
a-reserved)
> >> [    0.000000] SLUB: HWalign=3D64, Order=3D0-3, MinObjects=3D0, CPUs=
=3D4, Nodes=3D1
> >> [    0.000000] Kernel/User page tables isolation: enabled
> >> [    0.000000] ftrace: allocating 30370 entries in 119 pages
> >> [    0.000000] Preemptible hierarchical RCU implementation.
> >> [    0.000000]       RCU restricting CPUs from NR_CPUS=3D512 to nr_cpu=
_ids=3D4.
> >> [    0.000000]       RCU priority boosting: priority 1 delay 500 ms.
> >> [    0.000000]       No expedited grace period (rcu_normal_after_boot)=
.
> >> [    0.000000]       Tasks RCU enabled.
> >> [    0.000000] RCU: Adjusting geometry for rcu_fanout_leaf=3D16, nr_cp=
u_ids=3D4
> >> [    0.000000] NR_IRQS: 33024, nr_irqs: 1024, preallocated irqs: 16
> >> [    0.000000] Console: colour dummy device 80x25
> >> [    0.000000] console [tty0] enabled
> >> [    0.001000] tsc: Detected 1832.600 MHz processor
> >> [    0.001000] Calibrating delay loop (skipped), value calculated usin=
g timer frequency.. 3665.20 BogoMIPS (lpj=3D1832600)
> >> [    0.001000] pid_max: default: 32768 minimum: 301
> >> [    0.001000] ACPI: Core revision 20170728
> >> [    0.012153] ACPI: 5 ACPI AML tables successfully acquired and loade=
d
> >> [    0.012232] Security Framework initialized
> >> [    0.012234] Yama: becoming mindful.
> >> [    0.012268] AppArmor: AppArmor initialized
> >> [    0.019782] Dentry cache hash table entries: 1048576 (order: 12, 16=
777216 bytes)
> >> [    0.027419] Inode-cache hash table entries: 524288 (order: 10, 4194=
304 bytes)
> >> [    0.027539] Mount-cache hash table entries: 16384 (order: 5, 131072=
 bytes)
> >> [    0.027601] Mountpoint-cache hash table entries: 16384 (order: 5, 1=
31072 bytes)
> >> [    0.028129] ENERGY_PERF_BIAS: Set to 'normal', was 'performance'
> >> [    0.028131] ENERGY_PERF_BIAS: View and update with x86_energy_perf_=
policy(8)
> >> [    0.028143] mce: CPU supports 6 MCE banks
> >> [    0.028155] process: using mwait in idle threads
> >> [    0.028161] Last level iTLB entries: 4KB 48, 2MB 0, 4MB 0
> >> [    0.028163] Last level dTLB entries: 4KB 128, 2MB 16, 4MB 16, 1GB 0
> >> [    0.028165] Spectre V1 : Mitigation: usercopy/swapgs barriers and _=
_user pointer sanitization
> >> [    0.028168] Spectre V2 : Mitigation: Full generic retpoline
> >> [    0.028169] Spectre V2 : Spectre v2 / SpectreRSB mitigation: Fillin=
g RSB on context switch
> >> [    0.028170] Spectre V2 : Enabling Restricted Speculation for firmwa=
re calls
> >> [    0.028172] Spectre V2 : mitigation: Enabling conditional Indirect =
Branch Prediction Barrier
> >> [    0.028174] MDS: Mitigation: Clear CPU buffers
> >> [    0.028454] Freeing SMP alternatives memory: 20K
> >> [    0.029967] smpboot: Max logical packages: 1
> >> [    0.031000] ..TIMER: vector=3D0x30 apic1=3D0 pin1=3D2 apic2=3D-1 pi=
n2=3D-1
> >> [    0.040079] TSC deadline timer enabled
> >> [    0.040083] smpboot: CPU0: Intel(R) Celeron(R) CPU  N2930  @ 1.83GH=
z (family: 0x6, model: 0x37, stepping: 0x8)
> >> [    0.044040] Performance Events: PEBS fmt2+, 8-deep LBR, Silvermont =
events, 8-deep LBR, full-width counters, Intel PMU driver.
> >> [    0.044073] ... version:                3
> >> [    0.044076] ... bit width:              40
> >> [    0.044079] ... generic registers:      2
> >> [    0.044082] ... value mask:             000000ffffffffff
> >> [    0.044085] ... max period:             0000007fffffffff
> >> [    0.044088] ... fixed-purpose events:   3
> >> [    0.044090] ... event mask:             0000000700000003
> >> [    0.048058] Hierarchical SRCU implementation.
> >> [    0.057462] NMI watchdog: Enabled. Permanently consumes one hw-PMU =
counter.
> >> [    0.059020] smp: Bringing up secondary CPUs ...
> >> [    0.070078] x86: Booting SMP configuration:
> >> [    0.070084] .... node  #0, CPUs:      #1 #2 #3
> >> [    0.096219] smp: Brought up 1 node, 4 CPUs
> >> [    0.096219] smpboot: Total of 4 processors activated (14660.80 Bogo=
MIPS)
> >> [    0.098400] devtmpfs: initialized
> >> [    0.099089] x86/mm: Memory block size: 128MB
> >> [    0.104222] random: get_random_bytes called from setup_net+0x4c/0x1=
90 with crng_init=3D0
> >> [    0.104222] PM: Registering ACPI NVS region [mem 0x0006f000-0x0006f=
fff] (4096 bytes)
> >> [    0.104222] PM: Registering ACPI NVS region [mem 0xb8403000-0xb8502=
fff] (1048576 bytes)
> >> [    0.104380] clocksource: jiffies: mask: 0xffffffff max_cycles: 0xff=
ffffff, max_idle_ns: 1911260446275000 ns
> >> [    0.104436] futex hash table entries: 1024 (order: 4, 65536 bytes)
> >> [    0.104640] pinctrl core: initialized pinctrl subsystem
> >> [    0.105685] NET: Registered protocol family 16
> >> [    0.106519] cpuidle: using governor ladder
> >> [    0.106519] ACPI: bus type PCI registered
> >> [    0.106519] acpiphp: ACPI Hot Plug PCI Controller Driver version: 0=
.5
> >> [    0.106519] PCI: MMCONFIG for domain 0000 [bus 00-3f] at [mem 0xe00=
00000-0xe3ffffff] (base 0xe0000000)
> >> [    0.107068] PCI: not using MMCONFIG
> >> [    0.107068] PCI: Using configuration type 1 for base access
> >> [    0.112224] HugeTLB registered 2.00 MiB page size, pre-allocated 0 =
pages
> >> [    0.113360] ACPI: Added _OSI(Module Device)
> >> [    0.113365] ACPI: Added _OSI(Processor Device)
> >> [    0.113369] ACPI: Added _OSI(3.0 _SCP Extensions)
> >> [    0.113372] ACPI: Added _OSI(Processor Aggregator Device)
> >> [    0.128124] ACPI: Dynamic OEM Table Load:
> >> [    0.128144] ACPI: SSDT 0xFFFF9B9235135400 0003BC (v01 PmRef  Cpu0Is=
t  00003000 INTL 20121114)
> >> [    0.129424] ACPI: Dynamic OEM Table Load:
> >> [    0.129440] ACPI: SSDT 0xFFFF9B92351D1E00 00015F (v01 PmRef  ApIst =
   00003000 INTL 20121114)
> >> [    0.132388] ACPI: Interpreter enabled
> >> [    0.132448] ACPI: (supports S0 S4 S5)
> >> [    0.132453] ACPI: Using IOAPIC for interrupt routing
> >> [    0.132555] PCI: MMCONFIG for domain 0000 [bus 00-3f] at [mem 0xe00=
00000-0xe3ffffff] (base 0xe0000000)
> >> [    0.133369] PCI: MMCONFIG at [mem 0xe0000000-0xe3ffffff] reserved i=
n ACPI motherboard resources
> >> [    0.133399] PCI: Using host bridge windows from ACPI; if necessary,=
 use "pci=3Dnocrs" and report a bug
> >> [    0.133992] ACPI: Enabled 4 GPEs in block 00 to 3F
> >> [    0.555626] ACPI: Power Resource [USBC] (on)
> >> [    0.570268] ACPI: PCI Root Bridge [PCI0] (domain 0000 [bus 00-ff])
> >> [    0.570281] acpi PNP0A08:00: _OSC: OS supports [ExtendedConfig ASPM=
 ClockPM Segments MSI]
> >> [    0.570710] acpi PNP0A08:00: _OSC failed (AE_ERROR); disabling ASPM
> >> [    0.570739] acpi PNP0A08:00: [Firmware Info]: MMCONFIG for domain 0=
000 [bus 00-3f] only partially covers this bridge
> >> [    0.571767] PCI host bridge to bus 0000:00
> >> [    0.571774] pci_bus 0000:00: root bus resource [io  0x0000-0x006f w=
indow]
> >> [    0.571779] pci_bus 0000:00: root bus resource [io  0x0078-0x0cf7 w=
indow]
> >> [    0.571784] pci_bus 0000:00: root bus resource [io  0x0d00-0xffff w=
indow]
> >> [    0.571789] pci_bus 0000:00: root bus resource [mem 0x000a0000-0x00=
0bffff window]
> >> [    0.571794] pci_bus 0000:00: root bus resource [mem 0x000c0000-0x00=
0dffff window]
> >> [    0.571798] pci_bus 0000:00: root bus resource [mem 0x000e0000-0x00=
0fffff window]
> >> [    0.571803] pci_bus 0000:00: root bus resource [mem 0xc0000000-0xd0=
9ffffe window]
> >> [    0.571810] pci_bus 0000:00: root bus resource [bus 00-ff]
> >> [    0.571827] pci 0000:00:00.0: [8086:0f00] type 00 class 0x060000
> >> [    0.572176] pci 0000:00:02.0: [8086:0f31] type 00 class 0x030000
> >> [    0.572197] pci 0000:00:02.0: reg 0x10: [mem 0xd0000000-0xd03fffff]
> >> [    0.572212] pci 0000:00:02.0: reg 0x18: [mem 0xc0000000-0xcfffffff =
pref]
> >> [    0.572226] pci 0000:00:02.0: reg 0x20: [io  0x7050-0x7057]
> >> [    0.572251] pci 0000:00:02.0: BAR 2: assigned to efifb
> >> [    0.572568] pci 0000:00:13.0: [8086:0f23] type 00 class 0x010601
> >> [    0.572595] pci 0000:00:13.0: reg 0x10: [io  0x7048-0x704f]
> >> [    0.572608] pci 0000:00:13.0: reg 0x14: [io  0x705c-0x705f]
> >> [    0.572620] pci 0000:00:13.0: reg 0x18: [io  0x7040-0x7047]
> >> [    0.572632] pci 0000:00:13.0: reg 0x1c: [io  0x7058-0x705b]
> >> [    0.572644] pci 0000:00:13.0: reg 0x20: [io  0x7020-0x703f]
> >> [    0.572657] pci 0000:00:13.0: reg 0x24: [mem 0xd0904000-0xd09047ff]
> >> [    0.572717] pci 0000:00:13.0: PME# supported from D3hot
> >> [    0.573042] pci 0000:00:1a.0: [8086:0f18] type 00 class 0x108000
> >> [    0.573077] pci 0000:00:1a.0: reg 0x10: [mem 0xd0800000-0xd08fffff]
> >> [    0.573094] pci 0000:00:1a.0: reg 0x14: [mem 0xd0700000-0xd07fffff]
> >> [    0.573212] pci 0000:00:1a.0: PME# supported from D0 D3hot
> >> [    0.573512] pci 0000:00:1b.0: [8086:0f04] type 00 class 0x040300
> >> [    0.573544] pci 0000:00:1b.0: reg 0x10: [mem 0xd0900000-0xd0903fff =
64bit]
> >> [    0.573631] pci 0000:00:1b.0: PME# supported from D0 D3hot D3cold
> >> [    0.573920] pci 0000:00:1c.0: [8086:0f48] type 01 class 0x060400
> >> [    0.574000] pci 0000:00:1c.0: PME# supported from D0 D3hot D3cold
> >> [    0.574339] pci 0000:00:1c.1: [8086:0f4a] type 01 class 0x060400
> >> [    0.574422] pci 0000:00:1c.1: PME# supported from D0 D3hot D3cold
> >> [    0.574735] pci 0000:00:1c.2: [8086:0f4c] type 01 class 0x060400
> >> [    0.574818] pci 0000:00:1c.2: PME# supported from D0 D3hot D3cold
> >> [    0.575155] pci 0000:00:1c.3: [8086:0f4e] type 01 class 0x060400
> >> [    0.575237] pci 0000:00:1c.3: PME# supported from D0 D3hot D3cold
> >> [    0.575557] pci 0000:00:1d.0: [8086:0f34] type 00 class 0x0c0320
> >> [    0.575593] pci 0000:00:1d.0: reg 0x10: [mem 0xd0905000-0xd09053ff]
> >> [    0.575722] pci 0000:00:1d.0: PME# supported from D0 D3hot D3cold
> >> [    0.576051] pci 0000:00:1f.0: [8086:0f1c] type 00 class 0x060100
> >> [    0.576416] pci 0000:00:1f.3: [8086:0f12] type 00 class 0x0c0500
> >> [    0.576464] pci 0000:00:1f.3: reg 0x10: [mem 0xd0906000-0xd090601f]
> >> [    0.576539] pci 0000:00:1f.3: reg 0x20: [io  0x7000-0x701f]
> >> [    0.577084] pci 0000:01:00.0: [110a:4078] type 00 class 0x050000
> >> [    0.577125] pci 0000:01:00.0: reg 0x10: [mem 0xd0600000-0xd067ffff]
> >> [    0.577146] pci 0000:01:00.0: reg 0x14: [mem 0xd0680000-0xd0687fff]
> >> [    0.580025] pci 0000:00:1c.0: PCI bridge to [bus 01]
> >> [    0.580036] pci 0000:00:1c.0:   bridge window [mem 0xd0600000-0xd06=
fffff]
> >> [    0.580224] pci 0000:02:00.0: [8086:1533] type 00 class 0x020000
> >> [    0.580266] pci 0000:02:00.0: reg 0x10: [mem 0xd0500000-0xd057ffff]
> >> [    0.580298] pci 0000:02:00.0: reg 0x18: [io  0x6000-0x601f]
> >> [    0.580316] pci 0000:02:00.0: reg 0x1c: [mem 0xd0580000-0xd0583fff]
> >> [    0.580463] pci 0000:02:00.0: PME# supported from D0 D3hot D3cold
> >> [    0.584024] pci 0000:00:1c.1: PCI bridge to [bus 02]
> >> [    0.584032] pci 0000:00:1c.1:   bridge window [io  0x6000-0x6fff]
> >> [    0.584039] pci 0000:00:1c.1:   bridge window [mem 0xd0500000-0xd05=
fffff]
> >> [    0.584220] pci 0000:03:00.0: [8086:1533] type 00 class 0x020000
> >> [    0.584260] pci 0000:03:00.0: reg 0x10: [mem 0xd0400000-0xd047ffff]
> >> [    0.584292] pci 0000:03:00.0: reg 0x18: [io  0x5000-0x501f]
> >> [    0.584310] pci 0000:03:00.0: reg 0x1c: [mem 0xd0480000-0xd0483fff]
> >> [    0.584310] pci 0000:03:00.0: PME# supported from D0 D3hot D3cold
> >> [    0.587028] pci 0000:00:1c.2: PCI bridge to [bus 03]
> >> [    0.587032] pci 0000:00:1c.2:   bridge window [io  0x5000-0x5fff]
> >> [    0.587038] pci 0000:00:1c.2:   bridge window [mem 0xd0400000-0xd04=
fffff]
> >> [    0.587188] pci 0000:00:1c.3: PCI bridge to [bus 04]
> >> [    0.792690] ACPI: PCI Interrupt Link [LNKA] (IRQs 3 4 5 6 10 11 12 =
14 15) *7
> >> [    0.792941] ACPI: PCI Interrupt Link [LNKB] (IRQs 3 4 5 6 10 11 12 =
14 15) *7
> >> [    0.793184] ACPI: PCI Interrupt Link [LNKC] (IRQs 3 4 5 6 10 11 12 =
14 15) *7
> >> [    0.793406] ACPI: PCI Interrupt Link [LNKD] (IRQs 3 4 5 6 10 11 12 =
14 15) *7
> >> [    0.793627] ACPI: PCI Interrupt Link [LNKE] (IRQs 3 4 5 6 10 11 12 =
14 15) *7
> >> [    0.793849] ACPI: PCI Interrupt Link [LNKF] (IRQs 3 4 5 6 10 *11 12=
 14 15)
> >> [    0.794099] ACPI: PCI Interrupt Link [LNKG] (IRQs 3 4 5 6 *10 11 12=
 14 15)
> >> [    0.794320] ACPI: PCI Interrupt Link [LNKH] (IRQs 3 4 5 6 10 *11 12=
 14 15)
> >> [    0.795333] pci 0000:00:02.0: vgaarb: setting as boot VGA device
> >> [    0.795333] pci 0000:00:02.0: vgaarb: VGA device added: decodes=3Di=
o+mem,owns=3Dio+mem,locks=3Dnone
> >> [    0.795333] pci 0000:00:02.0: vgaarb: bridge control possible
> >> [    0.795333] vgaarb: loaded
> >> [    0.795333] pps_core: LinuxPPS API ver. 1 registered
> >> [    0.795333] pps_core: Software ver. 5.3.6 - Copyright 2005-2007 Rod=
olfo Giometti <giometti@linux.it>
> >> [    0.795333] PTP clock support registered
> >> [    0.795333] EDAC MC: Ver: 3.0.0
> >> [    0.796089] Registered efivars operations
> >> [    0.796204] PCI: Using ACPI for IRQ routing
> >> [    0.797938] PCI: pci_cache_line_size set to 64 bytes
> >> [    0.798064] e820: reserve RAM buffer [mem 0x0006f000-0x0006ffff]
> >> [    0.798072] e820: reserve RAM buffer [mem 0xb43d3018-0xb7ffffff]
> >> [    0.798077] e820: reserve RAM buffer [mem 0xb7af3000-0xb7ffffff]
> >> [    0.798082] e820: reserve RAM buffer [mem 0xb93c3000-0xbbffffff]
> >> [    0.798088] e820: reserve RAM buffer [mem 0xba000000-0xbbffffff]
> >> [    0.800595] clocksource: Switched to clocksource refined-jiffies
> >> [    0.858946] VFS: Disk quotas dquot_6.6.0
> >> [    0.858991] VFS: Dquot-cache hash table entries: 512 (order 0, 4096=
 bytes)
> >> [    0.859709] AppArmor: AppArmor Filesystem Enabled
> >> [    0.859779] pnp: PnP ACPI init
> >> [    0.859979] pnp 00:00: Plug and Play ACPI device, IDs PNP0b00 (acti=
ve)
> >> [    0.860373] system 00:01: [io  0x0680-0x069f] has been reserved
> >> [    0.860382] system 00:01: [io  0x0400-0x047f] has been reserved
> >> [    0.860389] system 00:01: [io  0x0500-0x05fe] has been reserved
> >> [    0.860407] system 00:01: Plug and Play ACPI device, IDs PNP0c02 (a=
ctive)
> >> [    0.860881] pnp 00:02: Plug and Play ACPI device, IDs PNP0501 (acti=
ve)
> >> [    0.861333] pnp 00:03: Plug and Play ACPI device, IDs PNP0501 (acti=
ve)
> >> [    1.064797] system 00:04: [mem 0xe0000000-0xefffffff] could not be =
reserved
> >> [    1.064806] system 00:04: [mem 0xfed01000-0xfed01fff] has been rese=
rved
> >> [    1.064814] system 00:04: [mem 0xfed03000-0xfed03fff] has been rese=
rved
> >> [    1.064821] system 00:04: [mem 0xfed04000-0xfed04fff] has been rese=
rved
> >> [    1.064828] system 00:04: [mem 0xfed0c000-0xfed0ffff] has been rese=
rved
> >> [    1.064835] system 00:04: [mem 0xfed08000-0xfed08fff] has been rese=
rved
> >> [    1.064835] system 00:04: [mem 0xfed1c000-0xfed1cfff] has been rese=
rved
> >> [    1.064835] system 00:04: [mem 0xfed40000-0xfed44fff] has been rese=
rved
> >> [    1.064835] system 00:04: [mem 0xfee00000-0xfeefffff] has been rese=
rved
> >> [    1.064835] system 00:04: [mem 0xfef00000-0xfeffffff] has been rese=
rved
> >> [    1.064835] system 00:04: Plug and Play ACPI device, IDs PNP0c02 (a=
ctive)
> >> [    1.064835] pnp: PnP ACPI: found 5 devices
> >> [    1.076608] clocksource: acpi_pm: mask: 0xffffff max_cycles: 0xffff=
ff, max_idle_ns: 2085701024 ns
> >> [    1.076986] clocksource: Switched to clocksource acpi_pm
> >> [    1.076986] pci 0000:00:1c.0: bridge window [io  0x1000-0x0fff] to =
[bus 01] add_size 1000
> >> [    1.076986] pci 0000:00:1c.0: bridge window [mem 0x00100000-0x000ff=
fff 64bit pref] to [bus 01] add_size 200000 add_align 100000
> >> [    1.076986] pci 0000:00:1c.1: bridge window [mem 0x00100000-0x000ff=
fff 64bit pref] to [bus 02] add_size 200000 add_align 100000
> >> [    1.076986] pci 0000:00:1c.2: bridge window [mem 0x00100000-0x000ff=
fff 64bit pref] to [bus 03] add_size 200000 add_align 100000
> >> [    1.076986] pci 0000:00:1c.3: bridge window [io  0x1000-0x0fff] to =
[bus 04] add_size 1000
> >> [    1.076986] pci 0000:00:1c.3: bridge window [mem 0x00100000-0x000ff=
fff 64bit pref] to [bus 04] add_size 200000 add_align 100000
> >> [    1.076986] pci 0000:00:1c.3: bridge window [mem 0x00100000-0x000ff=
fff] to [bus 04] add_size 200000 add_align 100000
> >> [    1.076986] pci 0000:00:1c.0: BAR 15: no space for [mem size 0x0020=
0000 64bit pref]
> >> [    1.076986] pci 0000:00:1c.0: BAR 15: failed to assign [mem size 0x=
00200000 64bit pref]
> >> [    1.076986] pci 0000:00:1c.1: BAR 15: no space for [mem size 0x0020=
0000 64bit pref]
> >> [    1.076986] pci 0000:00:1c.1: BAR 15: failed to assign [mem size 0x=
00200000 64bit pref]
> >> [    1.076986] pci 0000:00:1c.2: BAR 15: no space for [mem size 0x0020=
0000 64bit pref]
> >> [    1.076986] pci 0000:00:1c.2: BAR 15: failed to assign [mem size 0x=
00200000 64bit pref]
> >> [    1.076986] pci 0000:00:1c.3: BAR 14: no space for [mem size 0x0020=
0000]
> >> [    1.076986] pci 0000:00:1c.3: BAR 14: failed to assign [mem size 0x=
00200000]
> >> [    1.076986] pci 0000:00:1c.3: BAR 15: no space for [mem size 0x0020=
0000 64bit pref]
> >> [    1.076986] pci 0000:00:1c.3: BAR 15: failed to assign [mem size 0x=
00200000 64bit pref]
> >> [    1.076986] pci 0000:00:1c.0: BAR 13: assigned [io  0x1000-0x1fff]
> >> [    1.076986] pci 0000:00:1c.3: BAR 13: assigned [io  0x2000-0x2fff]
> >> [    1.076986] pci 0000:00:1c.3: BAR 14: no space for [mem size 0x0020=
0000]
> >> [    1.076986] pci 0000:00:1c.3: BAR 14: failed to assign [mem size 0x=
00200000]
> >> [    1.076986] pci 0000:00:1c.3: BAR 15: no space for [mem size 0x0020=
0000 64bit pref]
> >> [    1.076986] pci 0000:00:1c.3: BAR 15: failed to assign [mem size 0x=
00200000 64bit pref]
> >> [    1.076986] pci 0000:00:1c.2: BAR 15: no space for [mem size 0x0020=
0000 64bit pref]
> >> [    1.076986] pci 0000:00:1c.2: BAR 15: failed to assign [mem size 0x=
00200000 64bit pref]
> >> [    1.076986] pci 0000:00:1c.1: BAR 15: no space for [mem size 0x0020=
0000 64bit pref]
> >> [    1.076986] pci 0000:00:1c.1: BAR 15: failed to assign [mem size 0x=
00200000 64bit pref]
> >> [    1.077409] pci 0000:00:1c.0: BAR 15: no space for [mem size 0x0020=
0000 64bit pref]
> >> [    1.077415] pci 0000:00:1c.0: BAR 15: failed to assign [mem size 0x=
00200000 64bit pref]
> >> [    1.077423] pci 0000:00:1c.0: PCI bridge to [bus 01]
> >> [    1.077429] pci 0000:00:1c.0:   bridge window [io  0x1000-0x1fff]
> >> [    1.077437] pci 0000:00:1c.0:   bridge window [mem 0xd0600000-0xd06=
fffff]
> >> [    1.077447] pci 0000:00:1c.1: PCI bridge to [bus 02]
> >> [    1.077452] pci 0000:00:1c.1:   bridge window [io  0x6000-0x6fff]
> >> [    1.077459] pci 0000:00:1c.1:   bridge window [mem 0xd0500000-0xd05=
fffff]
> >> [    1.077469] pci 0000:00:1c.2: PCI bridge to [bus 03]
> >> [    1.077474] pci 0000:00:1c.2:   bridge window [io  0x5000-0x5fff]
> >> [    1.077484] pci 0000:00:1c.2:   bridge window [mem 0xd0400000-0xd04=
fffff]
> >> [    1.077505] pci 0000:00:1c.3: PCI bridge to [bus 04]
> >> [    1.077514] pci 0000:00:1c.3:   bridge window [io  0x2000-0x2fff]
> >> [    1.077528] pci_bus 0000:00: resource 4 [io  0x0000-0x006f window]
> >> [    1.077533] pci_bus 0000:00: resource 5 [io  0x0078-0x0cf7 window]
> >> [    1.077537] pci_bus 0000:00: resource 6 [io  0x0d00-0xffff window]
> >> [    1.077542] pci_bus 0000:00: resource 7 [mem 0x000a0000-0x000bffff =
window]
> >> [    1.077547] pci_bus 0000:00: resource 8 [mem 0x000c0000-0x000dffff =
window]
> >> [    1.077551] pci_bus 0000:00: resource 9 [mem 0x000e0000-0x000fffff =
window]
> >> [    1.077556] pci_bus 0000:00: resource 10 [mem 0xc0000000-0xd09ffffe=
 window]
> >> [    1.077560] pci_bus 0000:01: resource 0 [io  0x1000-0x1fff]
> >> [    1.077565] pci_bus 0000:01: resource 1 [mem 0xd0600000-0xd06fffff]
> >> [    1.077570] pci_bus 0000:02: resource 0 [io  0x6000-0x6fff]
> >> [    1.077575] pci_bus 0000:02: resource 1 [mem 0xd0500000-0xd05fffff]
> >> [    1.077579] pci_bus 0000:03: resource 0 [io  0x5000-0x5fff]
> >> [    1.077584] pci_bus 0000:03: resource 1 [mem 0xd0400000-0xd04fffff]
> >> [    1.077588] pci_bus 0000:04: resource 0 [io  0x2000-0x2fff]
> >> [    1.077841] NET: Registered protocol family 2
> >> [    1.078642] TCP established hash table entries: 65536 (order: 7, 52=
4288 bytes)
> >> [    1.081159] TCP bind hash table entries: 65536 (order: 9, 3670016 b=
ytes)
> >> [    1.082450] TCP: Hash tables configured (established 65536 bind 655=
36)
> >> [    1.082942] UDP hash table entries: 4096 (order: 7, 524288 bytes)
> >> [    1.083526] UDP-Lite hash table entries: 4096 (order: 7, 524288 byt=
es)
> >> [    1.083907] NET: Registered protocol family 1
> >> [    1.083953] pci 0000:00:02.0: Video device with shadowed ROM at [me=
m 0x000c0000-0x000dffff]
> >> [    2.307105] pci 0000:00:1d.0: EHCI: BIOS handoff failed (BIOS bug?)=
 01010001
> >> [    2.307499] PCI: CLS 64 bytes, default 64
> >> [    2.307698] Unpacking initramfs...
> >> [    3.863476] Freeing initrd memory: 36668K
> >> [    3.863485] PCI-DMA: Using software bounce buffering for IO (SWIOTL=
B)
> >> [    3.863491] software IO TLB: mapped [mem 0xb03d3000-0xb43d3000] (64=
MB)
> >> [    3.863609] clocksource: tsc: mask: 0xffffffffffffffff max_cycles: =
0x34d4ebe4b98, max_idle_ns: 881590735674 ns
> >> [    3.863665] clocksource: Switched to clocksource tsc
> >> [    3.864915] audit: initializing netlink subsys (disabled)
> >> [    3.865083] audit: type=3D2000 audit(1579782171.864:1): state=3Dini=
tialized audit_enabled=3D0 res=3D1
> >> [    3.866736] workingset: timestamp_bits=3D40 max_order=3D21 bucket_o=
rder=3D0
> >> [    3.874245] zbud: loaded
> >> [    4.765970] Key type asymmetric registered
> >> [    4.765976] Asymmetric key parser 'x509' registered
> >> [    4.766187] Block layer SCSI generic (bsg) driver version 0.4 loade=
d (major 247)
> >> [    4.766311] io scheduler noop registered
> >> [    4.766316] io scheduler deadline registered
> >> [    4.766340] io scheduler cfq registered (default)
> >> [    4.766345] io scheduler mq-deadline registered
> >> [    4.768175] efifb: probing for efifb
> >> [    4.768215] efifb: framebuffer at 0xc0000000, using 3072k, total 30=
72k
> >> [    4.768219] efifb: mode is 1024x768x32, linelength=3D4096, pages=3D=
1
> >> [    4.768222] efifb: scrolling: redraw
> >> [    4.768226] efifb: Truecolor: size=3D8:8:8:8, shift=3D24:16:8:0
> >> [    4.773901] Console: switching to colour frame buffer device 128x48
> >> [    4.779263] fb0: EFI VGA frame buffer device
> >> [    4.779297] intel_idle: MWAIT substates: 0x33000020
> >> [    4.779302] intel_idle: v0.4.1 model 0x37
> >> [    4.779310] intel_idle: intel_idle_state_table_update BYT 0x37 reac=
hed
> >> [    4.779313] intel_idle: byt_idle_state_table_update reached
> >> [    4.779317] intel_idle: state C6N is disabled
> >> [    4.779320] intel_idle: state C6S is disabled
> >> [    4.779323] intel_idle: state C7 is disabled
> >> [    4.779326] intel_idle: state C7S is disabled
> >> [    4.779674] intel_idle: lapic_timer_reliable_states 0xffffffff
> >> [    4.789625] Serial: 8250/16550 driver, 4 ports, IRQ sharing enabled
> >> [    4.789809] 00:02: ttyS0 at I/O 0x3f8 (irq =3D 4, base_baud =3D 115=
200) is a TI16750
> >> [    4.790140] 00:03: ttyS1 at I/O 0x2f8 (irq =3D 3, base_baud =3D 115=
200) is a TI16750
> >> [    4.791434] Linux agpgart interface v0.103
> >> [    4.807830] tpm_tis MSFT0101:00: 2.0 TPM (device-id 0x1A, rev-id 16=
)
> >> [    5.225802] AMD IOMMUv2 driver by Joerg Roedel <jroedel@suse.de>
> >> [    5.225807] AMD IOMMUv2 functionality not available on this system
> >> [    5.235438] loop: module loaded
> >> [    5.235637] i8042: PNP: No PS/2 controller found.
> >> [    5.235641] i8042: Probing ports directly.
> >> [    5.236512] serio: i8042 KBD port at 0x60,0x64 irq 1
> >> [    5.236656] serio: i8042 AUX port at 0x60,0x64 irq 12
> >> [    5.237091] mousedev: PS/2 mouse device common for all mice
> >> [    5.237433] rtc_cmos 00:00: RTC can wake from S4
> >> [    5.237785] rtc_cmos 00:00: rtc core: registered rtc_cmos as rtc0
> >> [    5.237911] rtc_cmos 00:00: alarms up to one month, y3k, 242 bytes =
nvram
> >> [    5.237948] intel_pstate: Intel P-state driver initializing
> >> [    5.240962] pmc_atom: SIMATIC IPC227E critclks quirk enabled
> >> [    5.244166] NET: Registered protocol family 10
> >> [    5.267172] Segment Routing with IPv6
> >> [    5.267238] mip6: Mobile IPv6
> >> [    5.267248] NET: Registered protocol family 17
> >> [    5.267266] mpls_gso: MPLS GSO support
> >> [    5.268247] microcode: sig=3D0x30678, pf=3D0x8, revision=3D0x838
> >> [    5.268482] microcode: Microcode Update Driver: v2.2.
> >> [    5.268526] sched_clock: Marking stable (5268463229, 0)->(528477236=
2, -16309133)
> >> [    5.269207] registered taskstats version 1
> >> [    5.269326] zswap: loaded using pool lzo/zbud
> >> [    5.269465] AppArmor: AppArmor sha1 policy hashing enabled
> >> [    5.290880] ima: Allocated hash algorithm: sha256
> >> [    5.483333] rtc_cmos 00:00: setting system clock to 2020-01-23 12:2=
2:54 UTC (1579782174)
> >> [    5.497555] Freeing unused kernel memory: 2228K
> >> [    5.497566] Write protecting the kernel read-only data: 16384k
> >> [    5.501268] Freeing unused kernel memory: 2024K
> >> [    5.506952] Freeing unused kernel memory: 1016K
> >> [    5.517886] x86/mm: Checked W+X mappings: passed, no W+X pages foun=
d.
> >> [    5.517890] x86/mm: Checking user space page tables
> >> [    5.528533] x86/mm: Checked W+X mappings: passed, no W+X pages foun=
d.
> >> [    7.264890] input: Sleep Button as /devices/LNXSYSTM:00/LNXSYBUS:00=
/PNP0C0E:00/input/input2
> >> [    7.280245] ACPI: Sleep Button [SLPB]
> >> [    7.313607] SCSI subsystem initialized
> >> [    7.333157] ACPI: bus type USB registered
> >> [    7.342823] i801_smbus 0000:00:1f.3: SMBus using PCI interrupt
> >> [    7.347944] usbcore: registered new interface driver usbfs
> >> [    7.352374] input: Power Button as /devices/LNXSYSTM:00/LNXPWRBN:00=
/input/input3
> >> [    7.353696] usbcore: registered new interface driver hub
> >> [    7.354498] usbcore: registered new device driver usb
> >> [    7.356061] ACPI: Power Button [PWRF]
> >> [    7.377690] libata version 3.00 loaded.
> >> [    7.414682] dca service started, version 1.12.1
> >> [    7.438308] ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Dri=
ver
> >> [    7.571896] ehci-pci: EHCI PCI platform driver
> >> [    7.572361] ehci-pci 0000:00:1d.0: EHCI Host Controller
> >> [    7.572379] ehci-pci 0000:00:1d.0: new USB bus registered, assigned=
 bus number 1
> >> [    7.572400] ehci-pci 0000:00:1d.0: debug port 2
> >> [    7.573535] igb: Intel(R) Gigabit Ethernet Network Driver - version=
 5.4.0-k
> >> [    7.573539] igb: Copyright (c) 2007-2014 Intel Corporation.
> >> [    7.576346] ehci-pci 0000:00:1d.0: cache line size of 64 is not sup=
ported
> >> [    7.576523] ehci-pci 0000:00:1d.0: irq 20, io mem 0xd0905000
> >> [    7.584162] ehci-pci 0000:00:1d.0: USB 2.0 started, EHCI 1.00
> >> [    7.584413] usb usb1: New USB device found, idVendor=3D1d6b, idProd=
uct=3D0002
> >> [    7.584420] usb usb1: New USB device strings: Mfr=3D3, Product=3D2,=
 SerialNumber=3D1
> >> [    7.584426] usb usb1: Product: EHCI Host Controller
> >> [    7.584432] usb usb1: Manufacturer: Linux 4.14.139-rt66 ehci_hcd
> >> [    7.584437] usb usb1: SerialNumber: 0000:00:1d.0
> >> [    7.585192] hub 1-0:1.0: USB hub found
> >> [    7.585226] hub 1-0:1.0: 8 ports detected
> >> [    7.590495] [drm] Memory usable by graphics device =3D 2048M
> >> [    7.590511] checking generic (c0000000 300000) vs hw (c0000000 1000=
0000)
> >> [    7.590521] fb: switching to inteldrmfb from EFI VGA
> >> [    7.590631] Console: switching to colour dummy device 80x25
> >> [    7.591813] [drm] Replacing VGA console driver
> >> [    7.592829] [drm] Supports vblank timestamp caching Rev 2 (21.10.20=
13).
> >> [    7.592838] [drm] Driver supports precise vblank timestamp query.
> >> [    7.596552] i915 0000:00:02.0: vgaarb: changed VGA decodes: olddeco=
des=3Dio+mem,decodes=3Dio+mem:owns=3Dio+mem
> >> [    7.603431] [drm] Initialized i915 1.6.0 20170818 for 0000:00:02.0 =
on minor 0
> >> [    7.606166] ACPI: Video Device [GFX0] (multi-head: yes  rom: no  po=
st: no)
> >> [    7.606919] input: Video Bus as /devices/LNXSYSTM:00/LNXSYBUS:00/PN=
P0A08:00/LNXVIDEO:00/input/input5
> >> [    7.607395] ahci 0000:00:13.0: version 3.0
> >> [    7.607857] ahci 0000:00:13.0: controller can't do DEVSLP, turning =
off
> >> [    7.618697] ahci 0000:00:13.0: AHCI 0001.0300 32 slots 2 ports 3 Gb=
ps 0x1 impl SATA mode
> >> [    7.618708] ahci 0000:00:13.0: flags: 64bit ncq led clo pio slum pa=
rt deso
> >> [    7.620442] scsi host0: ahci
> >> [    7.621120] scsi host1: ahci
> >> [    7.621433] ata1: SATA max UDMA/133 abar m2048@0xd0904000 port 0xd0=
904100 irq 88
> >> [    7.621439] ata2: DUMMY
> >> [    7.728937] fbcon: inteldrmfb (fb0) is primary device
> >> [    7.784490] Console: switching to colour frame buffer device 240x67
> >> [    7.809697] pps pps0: new PPS source ptp0
> >> [    7.809705] igb 0000:02:00.0: added PHC on eth0
> >> [    7.809709] igb 0000:02:00.0: Intel(R) Gigabit Ethernet Network Con=
nection
> >> [    7.809714] igb 0000:02:00.0: eth0: (PCIe:2.5Gb/s:Width x1) 20:87:5=
6:31:c5:0c
> >> [    7.809758] igb 0000:02:00.0: eth0: PBA No: 000300-000
> >> [    7.809762] igb 0000:02:00.0: Using MSI-X interrupts. 4 rx queue(s)=
, 4 tx queue(s)
> >> [    7.826702] i915 0000:00:02.0: fb0: inteldrmfb frame buffer device
> >> [    7.905112] usb 1-1: new high-speed USB device number 2 using ehci-=
pci
> >> [    7.934247] ata1: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
> >> [    7.935785] ata1.00: ATA-10: Micron_5100_MTFDDAK240TCB,  D0MU037, m=
ax UDMA/133
> >> [    7.935791] ata1.00: 468862128 sectors, multi 16: LBA48 NCQ (depth =
31/32), AA
> >> [    7.937914] ata1.00: configured for UDMA/133
> >> [    7.938270] scsi 0:0:0:0: Direct-Access     ATA      Micron_5100_MT=
FD U037 PQ: 0 ANSI: 5
> >> [    7.974092] ata1.00: Enabling discard_zeroes_data
> >> [    7.974560] sd 0:0:0:0: [sda] 468862128 512-byte logical blocks: (2=
40 GB/224 GiB)
> >> [    7.974564] sd 0:0:0:0: [sda] 4096-byte physical blocks
> >> [    7.974605] sd 0:0:0:0: [sda] Write Protect is off
> >> [    7.974608] sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
> >> [    7.974680] sd 0:0:0:0: [sda] Write cache: enabled, read cache: ena=
bled, doesn't support DPO or FUA
> >> [    7.975140] ata1.00: Enabling discard_zeroes_data
> >> [    7.977983]  sda: sda1 sda2 sda3 sda4
> >> [    7.978984] ata1.00: Enabling discard_zeroes_data
> >> [    7.979510] sd 0:0:0:0: [sda] Attached SCSI disk
> >> [    8.033403] usb 1-1: New USB device found, idVendor=3D8087, idProdu=
ct=3D07e6
> >> [    8.033411] usb 1-1: New USB device strings: Mfr=3D0, Product=3D0, =
SerialNumber=3D0
> >> [    8.038203] hub 1-1:1.0: USB hub found
> >> [    8.038280] hub 1-1:1.0: 4 ports detected
> >> [    8.050401] pps pps1: new PPS source ptp1
> >> [    8.050408] igb 0000:03:00.0: added PHC on eth1
> >> [    8.050412] igb 0000:03:00.0: Intel(R) Gigabit Ethernet Network Con=
nection
> >> [    8.050416] igb 0000:03:00.0: eth1: (PCIe:2.5Gb/s:Width x1) 20:87:5=
6:31:c5:06
> >> [    8.050460] igb 0000:03:00.0: eth1: PBA No: 000300-000
> >> [    8.050464] igb 0000:03:00.0: Using MSI-X interrupts. 4 rx queue(s)=
, 4 tx queue(s)
> >> [    8.067473] igb 0000:02:00.0 enp2s0: renamed from eth0
> >> [    8.074248] igb 0000:03:00.0 enp3s0: renamed from eth1
> >> [    8.311138] usb 1-1.2: new high-speed USB device number 3 using ehc=
i-pci
> >> [    8.345283] random: lvm: uninitialized urandom read (4 bytes read)
> >> [    8.390544] usb 1-1.2: New USB device found, idVendor=3D0424, idPro=
duct=3D2514
> >> [    8.390552] usb 1-1.2: New USB device strings: Mfr=3D0, Product=3D0=
, SerialNumber=3D0
> >> [    8.391047] hub 1-1.2:1.0: USB hub found
> >> [    8.391166] hub 1-1.2:1.0: 4 ports detected
> >> [    8.421224] device-mapper: uevent: version 1.0.3
> >> [    8.421963] device-mapper: ioctl: 4.37.0-ioctl (2017-09-20) initial=
ised: dm-devel@redhat.com
> >> [    8.456089] usb 1-1.3: new low-speed USB device number 4 using ehci=
-pci
> >> [    8.471697] random: lvm: uninitialized urandom read (2 bytes read)
> >> [    8.539867] usb 1-1.3: New USB device found, idVendor=3D413c, idPro=
duct=3D301a
> >> [    8.539873] usb 1-1.3: New USB device strings: Mfr=3D1, Product=3D2=
, SerialNumber=3D0
> >> [    8.539878] usb 1-1.3: Product: Dell MS116 USB Optical Mouse
> >> [    8.539881] usb 1-1.3: Manufacturer: PixArt
> >> [    8.567534] hidraw: raw HID events driver (C) Jiri Kosina
> >> [    8.591691] usbcore: registered new interface driver usbhid
> >> [    8.591698] usbhid: USB HID core driver
> >> [    8.606085] usb 1-1.4: new low-speed USB device number 5 using ehci=
-pci
> >> [    8.625980] input: PixArt Dell MS116 USB Optical Mouse as /devices/=
pci0000:00/0000:00:1d.0/usb1/1-1/1-1.3/1-1.3:1.0/0003:413C:301A.0001/input/=
input6
> >> [    8.626720] hid-generic 0003:413C:301A.0001: input,hidraw0: USB HID=
 v1.11 Mouse [PixArt Dell MS116 USB Optical Mouse] on usb-0000:00:1d.0-1.3/=
input0
> >> [    8.692570] usb 1-1.4: New USB device found, idVendor=3D413c, idPro=
duct=3D2113
> >> [    8.692585] usb 1-1.4: New USB device strings: Mfr=3D0, Product=3D2=
, SerialNumber=3D0
> >> [    8.692594] usb 1-1.4: Product: Dell KB216 Wired Keyboard
> >> [    8.699556] input: Dell KB216 Wired Keyboard as /devices/pci0000:00=
/0000:00:1d.0/usb1/1-1/1-1.4/1-1.4:1.0/0003:413C:2113.0002/input/input7
> >> [    8.752456] hid-generic 0003:413C:2113.0002: input,hidraw1: USB HID=
 v1.11 Keyboard [Dell KB216 Wired Keyboard] on usb-0000:00:1d.0-1.4/input0
> >> [    8.760277] input: Dell KB216 Wired Keyboard as /devices/pci0000:00=
/0000:00:1d.0/usb1/1-1/1-1.4/1-1.4:1.1/0003:413C:2113.0003/input/input8
> >> [    8.763063] usb 1-1.2.4: new high-speed USB device number 6 using e=
hci-pci
> >> [    8.812510] hid-generic 0003:413C:2113.0003: input,hidraw2: USB HID=
 v1.11 Device [Dell KB216 Wired Keyboard] on usb-0000:00:1d.0-1.4/input1
> >> [    8.857158] usb 1-1.2.4: New USB device found, idVendor=3D0781, idP=
roduct=3D5581
> >> [    8.857177] usb 1-1.2.4: New USB device strings: Mfr=3D1, Product=
=3D2, SerialNumber=3D3
> >> [    8.857190] usb 1-1.2.4: Product: Ultra
> >> [    8.857201] usb 1-1.2.4: Manufacturer: SanDisk
> >> [    8.857213] usb 1-1.2.4: SerialNumber: 04018812802fe8c3affb6e4ff14c=
9072616e7bdcf156e4641ccc688d0ccd13340aa400000000000000000000c1ca173b001a081=
8815581079d275241
> >> [    8.904607] usb-storage 1-1.2.4:1.0: USB Mass Storage device detect=
ed
> >> [    8.905482] scsi host2: usb-storage 1-1.2.4:1.0
> >> [    8.906380] usbcore: registered new interface driver usb-storage
> >> [    8.937344] usbcore: registered new interface driver uas
> >> [    9.953369] scsi 2:0:0:0: Direct-Access     SanDisk  Ultra         =
   1.00 PQ: 0 ANSI: 6
> >> [    9.957618] sd 2:0:0:0: [sdb] 120176640 512-byte logical blocks: (6=
1.5 GB/57.3 GiB)
> >> [    9.959602] sd 2:0:0:0: [sdb] Write Protect is off
> >> [    9.959607] sd 2:0:0:0: [sdb] Mode Sense: 43 00 00 00
> >> [    9.960718] sd 2:0:0:0: [sdb] Write cache: disabled, read cache: en=
abled, doesn't support DPO or FUA
> >> [    9.977778] GPT:Primary header thinks Alt. header is not at the end=
 of the disk.
> >> [    9.977789] GPT:14877681 !=3D 120176639
> >> [    9.977794] GPT:Alternate GPT header not at the end of the disk.
> >> [    9.977800] GPT:14877681 !=3D 120176639
> >> [    9.977804] GPT: Use GNU Parted to correct GPT errors.
> >> [    9.977852]  sdb: sdb1 sdb2
> >> [    9.983397] sd 2:0:0:0: [sdb] Attached SCSI removable disk
> >> [   14.708900] NET: Registered protocol family 38
> >> [   17.482198] random: cryptsetup: uninitialized urandom read (2 bytes=
 read)
> >> [   25.648558] random: cryptsetup: uninitialized urandom read (2 bytes=
 read)
> >> [   33.739683] random: cryptsetup: uninitialized urandom read (2 bytes=
 read)
> >> [   41.853499] random: cryptsetup: uninitialized urandom read (2 bytes=
 read)
> >> [   44.892110] random: lvm: uninitialized urandom read (4 bytes read)
> >> [   45.636922] EXT4-fs (dm-5): mounted filesystem with ordered data mo=
de. Opts: i_version
> >> [   46.119594] EXT4-fs: Warning: mounting with data=3Djournal disables=
 delayed allocation and O_DIRECT support!
> >> [   46.122171] EXT4-fs (dm-7): mounted filesystem with journalled data=
 mode. Opts: data=3Djournal
> >> [   47.457269] audit: type=3D1805 audit(1579782216.472:2): action=3D"d=
ont_appraise" fsmagic=3D"0x9fa0" res=3D1
> >> [   47.457285] audit: type=3D1805 audit(1579782216.472:3): action=3D"d=
ont_appraise" fsmagic=3D"0x62656572" res=3D1
> >> [   47.457296] audit: type=3D1805 audit(1579782216.472:4): action=3D"d=
ont_appraise" fsmagic=3D"0x64626720" res=3D1
> >> [   47.457305] audit: type=3D1805 audit(1579782216.472:5): action=3D"d=
ont_appraise" fsmagic=3D"0x1021994" res=3D1
> >> [   47.457317] audit: type=3D1805 audit(1579782216.472:6): action=3D"d=
ont_appraise" fsmagic=3D"0x858458f6" res=3D1
> >> [   47.457329] audit: type=3D1805 audit(1579782216.472:7): action=3D"d=
ont_appraise" fsmagic=3D"0x1cd1" res=3D1
> >> [   47.457367] audit: type=3D1805 audit(1579782216.472:8): action=3D"d=
ont_appraise" fsmagic=3D"0x42494e4d" res=3D1
> >> [   47.457378] audit: type=3D1805 audit(1579782216.472:9): action=3D"d=
ont_appraise" fsmagic=3D"0x73636673" res=3D1
> >> [   47.457388] audit: type=3D1805 audit(1579782216.472:10): action=3D"=
dont_appraise" fsmagic=3D"0xf97cff8c" res=3D1
> >> [   47.457424] audit: type=3D1805 audit(1579782216.472:11): action=3D"=
dont_appraise" fsmagic=3D"0x43415d53" res=3D1
> >> [   47.457580] systemd[1]: Successfully loaded the IMA custom policy /=
etc/ima/ima-policy.
> >> [   47.457603] IMA: policy update completed
> >> [   47.534320] ip_tables: (C) 2000-2006 Netfilter Core Team
> >> [   47.595810] systemd[1]: systemd 241 running in system mode. (+PAM +=
AUDIT +SELINUX +IMA +APPARMOR +SMACK +SYSVINIT +UTMP +LIBCRYPTSETUP +GCRYPT=
 +GNUTLS +ACL +XZ +LZ4 +SECCOMP +BLKID +ELFUTILS +KMOD -IDN2 +IDN -PCRE2 de=
fault-hierarchy=3Dhybrid)
> >> [   47.609184] systemd[1]: Detected architecture x86-64.
> >> [   47.617495] systemd[1]: Set hostname to <localhost.localdomain>.
> >> [   47.619885] systemd[1]: Failed to bump fs.file-max, ignoring: Inval=
id argument
> >> [   47.954124] systemd[1]: /run/systemd/generator.late/squid.service:2=
1: PIDFile=3D references path below legacy directory /var/run/, updating /v=
ar/run/squid.pid =E2=86=92 /run/squid.pid; please update the unit file acco=
rdingly.
> >> [   47.959208] systemd[1]: Listening on fsck to fsckd communication So=
cket.
> >> [   47.960291] systemd[1]: Set up automount Arbitrary Executable File =
Formats File System Automount Point.
> >> [   47.962620] systemd[1]: Created slice User and Session Slice.
> >> [   47.962666] systemd[1]: Reached target Slices.
> >> [   47.962735] systemd[1]: Reached target Swap.
> >> [   48.105328] random: lvm: uninitialized urandom read (4 bytes read)
> >> [   48.163805] Non-volatile memory driver v1.3
> >> [   48.295496] random: systemd-random-: uninitialized urandom read (51=
2 bytes read)
> >> [   49.042161] systemd-journald[501]: Received request to flush runtim=
e journal from PID 1
> >> [   49.449539] shpchp: Standard Hot Plug PCI Controller Driver version=
: 0.4
> >> [   49.750708] iTCO_vendor_support: vendor-support=3D0
> >> [   49.792209] iTCO_wdt: Intel TCO WatchDog Timer Driver v1.11
> >> [   49.795400] iTCO_wdt: Found a Bay Trail SoC TCO device (Version=3D3=
, TCOBASE=3D0x0460)
> >> [   49.800408] input: PC Speaker as /devices/platform/pcspkr/input/inp=
ut9
> >> [   49.831550] sd 0:0:0:0: Attached scsi generic sg0 type 0
> >> [   49.838335] iTCO_wdt: initialized. heartbeat=3D30 sec (nowayout=3D0=
)
> >> [   49.854453] sd 2:0:0:0: Attached scsi generic sg1 type 0
> >> [   49.992642] snd_hda_intel 0000:00:1b.0: bound 0000:00:02.0 (ops i91=
5_audio_component_bind_ops [i915])
> >> [   50.000803] igb 0000:02:00.0 factorylan0: renamed from enp2s0
> >> [   50.010276] igb 0000:03:00.0 machinelan0: renamed from enp3s0
> >> [   50.362232] input: HDA Intel PCH HDMI/DP,pcm=3D3 as /devices/pci000=
0:00/0000:00:1b.0/sound/card0/input10
> >> [   50.425199] input: HDA Intel PCH HDMI/DP,pcm=3D7 as /devices/pci000=
0:00/0000:00:1b.0/sound/card0/input11
> >> [   50.538093] (NULL device *): hwmon_device_register() is deprecated.=
 Please convert the driver to use hwmon_device_register_with_info().
> >> [   50.581117] (NULL device *): hwmon_device_register() is deprecated.=
 Please convert the driver to use hwmon_device_register_with_info().
> >> [   50.646200] random: lvm: uninitialized urandom read (4 bytes read)
> >> [   50.721210] intel_rapl: Found RAPL domain package
> >> [   50.721217] intel_rapl: Found RAPL domain core
> >> [   52.216273] EXT4-fs (dm-6): mounted filesystem with journalled data=
 mode. Opts: data=3Djournal
> >> [   52.294842] EXT4-fs (dm-8): mounted filesystem with journalled data=
 mode. Opts: data=3Djournal
> >> [   56.369802] IPv6: ADDRCONF(NETDEV_UP): factorylan0: link is not rea=
dy
> >> [   56.425587] IPv6: ADDRCONF(NETDEV_UP): factorylan0: link is not rea=
dy
> >> [   56.438514] IPv6: ADDRCONF(NETDEV_UP): machinelan0: link is not rea=
dy
> >> [   56.491600] IPv6: ADDRCONF(NETDEV_UP): machinelan0: link is not rea=
dy
> >> [   56.932663] [drm:intel_cpu_fifo_underrun_irq_handler [i915]] *ERROR=
* CPU pipe A FIFO underrun
> >> [   59.569636] igb 0000:03:00.0 machinelan0: igb: machinelan0 NIC Link=
 is Up 1000 Mbps Full Duplex, Flow Control: RX/TX
> >> [   59.671360] IPv6: ADDRCONF(NETDEV_CHANGE): machinelan0: link become=
s ready
> >> [   67.803769] bridge: filtering via arp/ip/ip6tables is no longer ava=
ilable by default. Update your scripts to load br_netfilter if you need thi=
s.
> >> [   67.808889] Bridge firewalling registered
> >> [   67.836843] nf_conntrack version 0.5.0 (65536 buckets, 262144 max)
> >> [   68.088408] Initializing XFRM netlink socket
> >> [   68.103161] Netfilter messages via NETLINK v0.30.
> >> [   68.109737] ctnetlink v0.93: registering with nfnetlink.
> >> [   68.353599] IPv6: ADDRCONF(NETDEV_UP): docker0: link is not ready
> >> root@localhost:#
> >> root@localhost:# dmesg | grep tsc
> >> [    0.001000] tsc: Detected 1832.600 MHz processor
> >> [    3.863609] clocksource: tsc: mask: 0xffffffffffffffff max_cycles: =
0x34d4ebe4b98, max_idle_ns: 881590735674 ns
> >> [    3.863665] clocksource: Switched to clocksource tsc
> >>
> >
> >> root@localhost# dmesg
> >> [    0.000000] microcode: microcode updated early to revision 0x838, d=
ate =3D 2019-04-22
> >> [    0.000000] Linux version 4.14.139-rt66 (builder@vipul) (gcc versio=
n 6.3.0 20170516 (Debian 6.3.0-18+deb9u1)) #1 SMP PREEMPT RT Mon Jan 20 07:=
36:20 UTC 2020
> >> [    0.000000] Command line: rootwait quiet     rootflags=3Di_version =
ima_tcb ima_appraise=3Denforce ima_appraise_tcb  nohz=3Doff        splash p=
lymouth.ignore-serial-consoles quiet        root=3D/dev/mapper/system-syste=
ma
> >>
> >> [    0.000000] x86/fpu: x87 FPU will use FXSAVE
> >> [    0.000000] e820: BIOS-provided physical RAM map:
> >> [    0.000000] BIOS-e820: [mem 0x0000000000000000-0x000000000006efff] =
usable
> >> [    0.000000] BIOS-e820: [mem 0x000000000006f000-0x000000000006ffff] =
ACPI NVS
> >> [    0.000000] BIOS-e820: [mem 0x0000000000070000-0x000000000008ffff] =
usable
> >> [    0.000000] BIOS-e820: [mem 0x0000000000090000-0x000000000009ffff] =
reserved
> >> [    0.000000] BIOS-e820: [mem 0x0000000000100000-0x00000000b7af2fff] =
usable
> >> [    0.000000] BIOS-e820: [mem 0x00000000b7af3000-0x00000000b8402fff] =
reserved
> >> [    0.000000] BIOS-e820: [mem 0x00000000b8403000-0x00000000b8502fff] =
ACPI NVS
> >> [    0.000000] BIOS-e820: [mem 0x00000000b8503000-0x00000000b8542fff] =
ACPI data
> >> [    0.000000] BIOS-e820: [mem 0x00000000b8543000-0x00000000b93c2fff] =
usable
> >> [    0.000000] BIOS-e820: [mem 0x00000000b93c3000-0x00000000b9cc2fff] =
reserved
> >> [    0.000000] BIOS-e820: [mem 0x00000000b9cc3000-0x00000000b9ffffff] =
usable
> >> [    0.000000] BIOS-e820: [mem 0x00000000e00f8000-0x00000000e00f8fff] =
reserved
> >> [    0.000000] BIOS-e820: [mem 0x00000000fed01000-0x00000000fed01fff] =
reserved
> >> [    0.000000] BIOS-e820: [mem 0x00000000ffb00000-0x00000000ffffffff] =
reserved
> >> [    0.000000] BIOS-e820: [mem 0x0000000100000000-0x000000023fffffff] =
usable
> >> [    0.000000] NX (Execute Disable) protection: active
> >> [    0.000000] e820: update [mem 0xb43d3018-0xb43e3057] usable =3D=3D>=
 usable
> >> [    0.000000] e820: update [mem 0xb43d3018-0xb43e3057] usable =3D=3D>=
 usable
> >> [    0.000000] extended physical RAM map:
> >> [    0.000000] reserve setup_data: [mem 0x0000000000000000-0x000000000=
006efff] usable
> >> [    0.000000] reserve setup_data: [mem 0x000000000006f000-0x000000000=
006ffff] ACPI NVS
> >> [    0.000000] reserve setup_data: [mem 0x0000000000070000-0x000000000=
008ffff] usable
> >> [    0.000000] reserve setup_data: [mem 0x0000000000090000-0x000000000=
009ffff] reserved
> >> [    0.000000] reserve setup_data: [mem 0x0000000000100000-0x00000000b=
43d3017] usable
> >> [    0.000000] reserve setup_data: [mem 0x00000000b43d3018-0x00000000b=
43e3057] usable
> >> [    0.000000] reserve setup_data: [mem 0x00000000b43e3058-0x00000000b=
7af2fff] usable
> >> [    0.000000] reserve setup_data: [mem 0x00000000b7af3000-0x00000000b=
8402fff] reserved
> >> [    0.000000] reserve setup_data: [mem 0x00000000b8403000-0x00000000b=
8502fff] ACPI NVS
> >> [    0.000000] reserve setup_data: [mem 0x00000000b8503000-0x00000000b=
8542fff] ACPI data
> >> [    0.000000] reserve setup_data: [mem 0x00000000b8543000-0x00000000b=
93c2fff] usable
> >> [    0.000000] reserve setup_data: [mem 0x00000000b93c3000-0x00000000b=
9cc2fff] reserved
> >> [    0.000000] reserve setup_data: [mem 0x00000000b9cc3000-0x00000000b=
9ffffff] usable
> >> [    0.000000] reserve setup_data: [mem 0x00000000e00f8000-0x00000000e=
00f8fff] reserved
> >> [    0.000000] reserve setup_data: [mem 0x00000000fed01000-0x00000000f=
ed01fff] reserved
> >> [    0.000000] reserve setup_data: [mem 0x00000000ffb00000-0x00000000f=
fffffff] reserved
> >> [    0.000000] reserve setup_data: [mem 0x0000000100000000-0x000000023=
fffffff] usable
> >> [    0.000000] efi: EFI v2.40 by INSYDE Corp.
> >> [    0.000000] efi:  ACPI 2.0=3D0xb8542014  ESRT=3D0xb7be2d18  SMBIOS=
=3D0xb7dfa000
> >> [    0.000000] SMBIOS 2.7 present.
> >> [    0.000000] DMI: SIEMENS AG SIMATIC IPC227E/A5E38155677, BIOS V20.0=
1.12 04/05/2019
> >> [    0.000000] e820: update [mem 0x00000000-0x00000fff] usable =3D=3D>=
 reserved
> >> [    0.000000] e820: remove [mem 0x000a0000-0x000fffff] usable
> >> [    0.000000] e820: last_pfn =3D 0x240000 max_arch_pfn =3D 0x40000000=
0
> >> [    0.000000] MTRR default type: uncachable
> >> [    0.000000] MTRR fixed ranges enabled:
> >> [    0.000000]   00000-9FFFF write-back
> >> [    0.000000]   A0000-BFFFF uncachable
> >> [    0.000000]   C0000-FFFFF write-protect
> >> [    0.000000] MTRR variable ranges enabled:
> >> [    0.000000]   0 base 0FF800000 mask FFF800000 write-protect
> >> [    0.000000]   1 base 000000000 mask F80000000 write-back
> >> [    0.000000]   2 base 080000000 mask FC0000000 write-back
> >> [    0.000000]   3 base 0BC000000 mask FFC000000 uncachable
> >> [    0.000000]   4 base 0BB000000 mask FFF000000 uncachable
> >> [    0.000000]   5 base 0BAE00000 mask FFFE00000 uncachable
> >> [    0.000000]   6 base 100000000 mask F00000000 write-back
> >> [    0.000000]   7 base 200000000 mask FC0000000 write-back
> >> [    0.000000] x86/PAT: Configuration [0-7]: WB  WC  UC- UC  WB  WP  U=
C- WT
> >> [    0.000000] e820: last_pfn =3D 0xba000 max_arch_pfn =3D 0x400000000
> >> [    0.000000] Base memory trampoline at [ffff9a110008a000] 8a000 size=
 24576
> >> [    0.000000] BRK [0xa4118000, 0xa4118fff] PGTABLE
> >> [    0.000000] BRK [0xa4119000, 0xa4119fff] PGTABLE
> >> [    0.000000] BRK [0xa411a000, 0xa411afff] PGTABLE
> >> [    0.000000] BRK [0xa411b000, 0xa411bfff] PGTABLE
> >> [    0.000000] BRK [0xa411c000, 0xa411cfff] PGTABLE
> >> [    0.000000] BRK [0xa411d000, 0xa411dfff] PGTABLE
> >> [    0.000000] BRK [0xa411e000, 0xa411efff] PGTABLE
> >> [    0.000000] BRK [0xa411f000, 0xa411ffff] PGTABLE
> >> [    0.000000] BRK [0xa4120000, 0xa4120fff] PGTABLE
> >> [    0.000000] BRK [0xa4121000, 0xa4121fff] PGTABLE
> >> [    0.000000] BRK [0xa4122000, 0xa4122fff] PGTABLE
> >> [    0.000000] BRK [0xa4123000, 0xa4123fff] PGTABLE
> >> [    0.000000] Secure boot could not be determined
> >> [    0.000000] RAMDISK: [mem 0xadc30000-0xafffffff]
> >> [    0.000000] ACPI: Early table checksum verification disabled
> >> [    0.000000] ACPI: RSDP 0x00000000B8542014 000024 (v02 SIEMEN)
> >> [    0.000000] ACPI: XSDT 0x00000000B8542120 00009C (v01 SIEMEN SIMATI=
C  11112222      01000013)
> >> [    0.000000] ACPI: FACP 0x00000000B853B000 00010C (v05 SIEMEN SIMATI=
C  11112222 WAS_ 00010001)
> >> [    0.000000] ACPI: DSDT 0x00000000B8530000 006A5B (v02 SIEMEN SIMATI=
C  11112222 WAS_ 00010001)
> >> [    0.000000] ACPI: FACS 0x00000000B84AA000 000040
> >> [    0.000000] ACPI: UEFI 0x00000000B8541000 000236 (v01 SIEMEN SIMATI=
C  00000001 WAS_ 12345678)
> >> [    0.000000] ACPI: TCPA 0x00000000B8540000 000032 (v02 SIEMEN SIMATI=
C  00000000 WAS_ 00000000)
> >> [    0.000000] ACPI: UEFI 0x00000000B853E000 000042 (v01 SIEMEN SIMATI=
C  00000000 WAS_ 00000000)
> >> [    0.000000] ACPI: SSDT 0x00000000B853D000 0004FD (v01 SIEMEN TPMACP=
I  00001000 WAS_ 20121114)
> >> [    0.000000] ACPI: TPM2 0x00000000B853C000 000034 (v03 SIEMEN SIMATI=
C  00000000 WAS_ 00000000)
> >> [    0.000000] ACPI: HPET 0x00000000B853A000 000038 (v01 SIEMEN SIMATI=
C  11112222 WAS_ 00010001)
> >> [    0.000000] ACPI: LPIT 0x00000000B8539000 000104 (v01 SIEMEN SIMATI=
C  11112222 WAS_ 00010001)
> >> [    0.000000] ACPI: APIC 0x00000000B8538000 000084 (v03 SIEMEN SIMATI=
C  11112222 WAS_ 00010001)
> >> [    0.000000] ACPI: MCFG 0x00000000B8537000 00003C (v01 SIEMEN SIMATI=
C  11112222 WAS_ 00010001)
> >> [    0.000000] ACPI: SSDT 0x00000000B852E000 000763 (v01 SIEMEN CpuPm =
   00003000 WAS_ 20121114)
> >> [    0.000000] ACPI: SSDT 0x00000000B852D000 000290 (v01 SIEMEN Cpu0Ts=
t  00003000 WAS_ 20121114)
> >> [    0.000000] ACPI: SSDT 0x00000000B852C000 00017A (v01 SIEMEN ApTst =
   00003000 WAS_ 20121114)
> >> [    0.000000] ACPI: FPDT 0x00000000B852B000 000044 (v01 SIEMEN SIMATI=
C  00000002 WAS_ 01000013)
> >> [    0.000000] ACPI: BGRT 0x00000000B852F000 000038 (v01 SIEMEN SIMATI=
C  00000001 WAS_ 12345678)
> >> [    0.000000] ACPI: Local APIC address 0xfee00000
> >> [    0.000000] No NUMA configuration found
> >> [    0.000000] Faking a node at [mem 0x0000000000000000-0x000000023fff=
ffff]
> >> [    0.000000] NODE_DATA(0) allocated [mem 0x23fff8000-0x23fffcfff]
> >> [    0.000000] Zone ranges:
> >> [    0.000000]   DMA      [mem 0x0000000000001000-0x0000000000ffffff]
> >> [    0.000000]   DMA32    [mem 0x0000000001000000-0x00000000ffffffff]
> >> [    0.000000]   Normal   [mem 0x0000000100000000-0x000000023fffffff]
> >> [    0.000000]   Device   empty
> >> [    0.000000] Movable zone start for each node
> >> [    0.000000] Early memory node ranges
> >> [    0.000000]   node   0: [mem 0x0000000000001000-0x000000000006efff]
> >> [    0.000000]   node   0: [mem 0x0000000000070000-0x000000000008ffff]
> >> [    0.000000]   node   0: [mem 0x0000000000100000-0x00000000b7af2fff]
> >> [    0.000000]   node   0: [mem 0x00000000b8543000-0x00000000b93c2fff]
> >> [    0.000000]   node   0: [mem 0x00000000b9cc3000-0x00000000b9ffffff]
> >> [    0.000000]   node   0: [mem 0x0000000100000000-0x000000023fffffff]
> >> [    0.000000] Initmem setup node 0 [mem 0x0000000000001000-0x00000002=
3fffffff]
> >> [    0.000000] On node 0 totalpages: 2067518
> >> [    0.000000]   DMA zone: 64 pages used for memmap
> >> [    0.000000]   DMA zone: 21 pages reserved
> >> [    0.000000]   DMA zone: 3982 pages, LIFO batch:0
> >> [    0.000000]   DMA32 zone: 11763 pages used for memmap
> >> [    0.000000]   DMA32 zone: 752816 pages, LIFO batch:31
> >> [    0.000000]   Normal zone: 20480 pages used for memmap
> >> [    0.000000]   Normal zone: 1310720 pages, LIFO batch:31
> >> [    0.000000] x86/hpet: Will disable the HPET for this platform becau=
se it's not reliable
> >> [    0.000000] Reserving Intel graphics memory at 0x00000000bb000000-0=
x00000000beffffff
> >> [    0.000000] ACPI: PM-Timer IO Port: 0x408
> >> [    0.000000] ACPI: Local APIC address 0xfee00000
> >> [    0.000000] ACPI: LAPIC_NMI (acpi_id[0x01] high level lint[0x1])
> >> [    0.000000] ACPI: LAPIC_NMI (acpi_id[0x02] high level lint[0x1])
> >> [    0.000000] ACPI: LAPIC_NMI (acpi_id[0x03] high level lint[0x1])
> >> [    0.000000] ACPI: LAPIC_NMI (acpi_id[0x04] high level lint[0x1])
> >> [    0.000000] IOAPIC[0]: apic_id 2, version 32, address 0xfec00000, G=
SI 0-86
> >> [    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl=
)
> >> [    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 high le=
vel)
> >> [    0.000000] ACPI: IRQ0 used by override.
> >> [    0.000000] ACPI: IRQ9 used by override.
> >> [    0.000000] Using ACPI (MADT) for SMP configuration information
> >> [    0.000000] ACPI: HPET id: 0x8086a201 base: 0xfed00000
> >> [    0.000000] smpboot: Allowing 4 CPUs, 0 hotplug CPUs
> >> [    0.000000] PM: Registered nosave memory: [mem 0x00000000-0x00000ff=
f]
> >> [    0.000000] PM: Registered nosave memory: [mem 0x0006f000-0x0006fff=
f]
> >> [    0.000000] PM: Registered nosave memory: [mem 0x00090000-0x0009fff=
f]
> >> [    0.000000] PM: Registered nosave memory: [mem 0x000a0000-0x000ffff=
f]
> >> [    0.000000] PM: Registered nosave memory: [mem 0xb43d3000-0xb43d3ff=
f]
> >> [    0.000000] PM: Registered nosave memory: [mem 0xb43e3000-0xb43e3ff=
f]
> >> [    0.000000] PM: Registered nosave memory: [mem 0xb7af3000-0xb8402ff=
f]
> >> [    0.000000] PM: Registered nosave memory: [mem 0xb8403000-0xb8502ff=
f]
> >> [    0.000000] PM: Registered nosave memory: [mem 0xb8503000-0xb8542ff=
f]
> >> [    0.000000] PM: Registered nosave memory: [mem 0xb93c3000-0xb9cc2ff=
f]
> >> [    0.000000] PM: Registered nosave memory: [mem 0xba000000-0xbafffff=
f]
> >> [    0.000000] PM: Registered nosave memory: [mem 0xbb000000-0xbefffff=
f]
> >> [    0.000000] PM: Registered nosave memory: [mem 0xbf000000-0xe00f7ff=
f]
> >> [    0.000000] PM: Registered nosave memory: [mem 0xe00f8000-0xe00f8ff=
f]
> >> [    0.000000] PM: Registered nosave memory: [mem 0xe00f9000-0xfed00ff=
f]
> >> [    0.000000] PM: Registered nosave memory: [mem 0xfed01000-0xfed01ff=
f]
> >> [    0.000000] PM: Registered nosave memory: [mem 0xfed02000-0xffaffff=
f]
> >> [    0.000000] PM: Registered nosave memory: [mem 0xffb00000-0xfffffff=
f]
> >> [    0.000000] e820: [mem 0xbf000000-0xe00f7fff] available for PCI dev=
ices
> >> [    0.000000] Booting paravirtualized kernel on bare hardware
> >> [    0.000000] clocksource: refined-jiffies: mask: 0xffffffff max_cycl=
es: 0xffffffff, max_idle_ns: 1910969940391419 ns
> >> [    0.000000] setup_percpu: NR_CPUS:512 nr_cpumask_bits:512 nr_cpu_id=
s:4 nr_node_ids:1
> >> [    0.000000] percpu: Embedded 226 pages/cpu s886080 r8192 d31424 u10=
48576
> >> [    0.000000] pcpu-alloc: s886080 r8192 d31424 u1048576 alloc=3D1*209=
7152
> >> [    0.000000] pcpu-alloc: [0] 0 1 [0] 2 3
> >> [    0.000000] Built 1 zonelists, mobility grouping on.  Total pages: =
2035190
> >> [    0.000000] Policy zone: Normal
> >> [    0.000000] Kernel command line: rootwait quiet     rootflags=3Di_v=
ersion ima_tcb ima_appraise=3Denforce ima_appraise_tcb  nohz=3Doff        s=
plash plymouth.ignore-serial-consoles quiet        root=3D/dev/mapper/syste=
m-systema
> >>
> >> [    0.000000] PID hash table entries: 4096 (order: 3, 32768 bytes)
> >> [    0.000000] Calgary: detecting Calgary via BIOS EBDA area
> >> [    0.000000] Calgary: Unable to locate Rio Grande table in EBDA - ba=
iling!
> >> [    0.000000] Memory: 8008768K/8270072K available (10252K kernel code=
, 1185K rwdata, 3080K rodata, 2228K init, 856K bss, 261304K reserved, 0K cm=
a-reserved)
> >> [    0.000000] SLUB: HWalign=3D64, Order=3D0-3, MinObjects=3D0, CPUs=
=3D4, Nodes=3D1
> >> [    0.000000] Kernel/User page tables isolation: enabled
> >> [    0.000000] ftrace: allocating 30370 entries in 119 pages
> >> [    0.000000] Preemptible hierarchical RCU implementation.
> >> [    0.000000]       RCU restricting CPUs from NR_CPUS=3D512 to nr_cpu=
_ids=3D4.
> >> [    0.000000]       RCU priority boosting: priority 1 delay 500 ms.
> >> [    0.000000]       No expedited grace period (rcu_normal_after_boot)=
.
> >> [    0.000000]       Tasks RCU enabled.
> >> [    0.000000] RCU: Adjusting geometry for rcu_fanout_leaf=3D16, nr_cp=
u_ids=3D4
> >> [    0.000000] NR_IRQS: 33024, nr_irqs: 1024, preallocated irqs: 16
> >> [    0.000000] Console: colour dummy device 80x25
> >> [    0.000000] console [tty0] enabled
> >> [    0.001000] tsc: Detected 1832.600 MHz processor
> >> [    0.001000] Calibrating delay loop (skipped), value calculated usin=
g timer frequency.. 3665.20 BogoMIPS (lpj=3D1832600)
> >> [    0.001000] pid_max: default: 32768 minimum: 301
> >> [    0.001000] ACPI: Core revision 20170728
> >> [    0.012101] ACPI: 5 ACPI AML tables successfully acquired and loade=
d
> >> [    0.012179] Security Framework initialized
> >> [    0.012182] Yama: becoming mindful.
> >> [    0.012215] AppArmor: AppArmor initialized
> >> [    0.019713] Dentry cache hash table entries: 1048576 (order: 12, 16=
777216 bytes)
> >> [    0.027394] Inode-cache hash table entries: 524288 (order: 10, 4194=
304 bytes)
> >> [    0.027516] Mount-cache hash table entries: 16384 (order: 5, 131072=
 bytes)
> >> [    0.027579] Mountpoint-cache hash table entries: 16384 (order: 5, 1=
31072 bytes)
> >> [    0.028104] ENERGY_PERF_BIAS: Set to 'normal', was 'performance'
> >> [    0.028105] ENERGY_PERF_BIAS: View and update with x86_energy_perf_=
policy(8)
> >> [    0.028117] mce: CPU supports 6 MCE banks
> >> [    0.028129] process: using mwait in idle threads
> >> [    0.028135] Last level iTLB entries: 4KB 48, 2MB 0, 4MB 0
> >> [    0.028136] Last level dTLB entries: 4KB 128, 2MB 16, 4MB 16, 1GB 0
> >> [    0.028139] Spectre V1 : Mitigation: usercopy/swapgs barriers and _=
_user pointer sanitization
> >> [    0.028143] Spectre V2 : Mitigation: Full generic retpoline
> >> [    0.028143] Spectre V2 : Spectre v2 / SpectreRSB mitigation: Fillin=
g RSB on context switch
> >> [    0.028145] Spectre V2 : Enabling Restricted Speculation for firmwa=
re calls
> >> [    0.028147] Spectre V2 : mitigation: Enabling conditional Indirect =
Branch Prediction Barrier
> >> [    0.028148] MDS: Mitigation: Clear CPU buffers
> >> [    0.028427] Freeing SMP alternatives memory: 20K
> >> [    0.029965] smpboot: Max logical packages: 1
> >> [    0.031000] ..TIMER: vector=3D0x30 apic1=3D0 pin1=3D2 apic2=3D-1 pi=
n2=3D-1
> >> [    0.040077] TSC deadline timer enabled
> >> [    0.040082] smpboot: CPU0: Intel(R) Celeron(R) CPU  N2930  @ 1.83GH=
z (family: 0x6, model: 0x37, stepping: 0x8)
> >> [    0.044041] Performance Events: PEBS fmt2+, 8-deep LBR, Silvermont =
events, 8-deep LBR, full-width counters, Intel PMU driver.
> >> [    0.044073] ... version:                3
> >> [    0.044076] ... bit width:              40
> >> [    0.044078] ... generic registers:      2
> >> [    0.044081] ... value mask:             000000ffffffffff
> >> [    0.044084] ... max period:             0000007fffffffff
> >> [    0.044087] ... fixed-purpose events:   3
> >> [    0.044090] ... event mask:             0000000700000003
> >> [    0.048058] Hierarchical SRCU implementation.
> >> [    0.057463] NMI watchdog: Enabled. Permanently consumes one hw-PMU =
counter.
> >> [    0.059020] smp: Bringing up secondary CPUs ...
> >> [    0.070076] x86: Booting SMP configuration:
> >> [    0.070082] .... node  #0, CPUs:      #1 #2 #3
> >> [    0.096219] smp: Brought up 1 node, 4 CPUs
> >> [    0.096219] smpboot: Total of 4 processors activated (14660.80 Bogo=
MIPS)
> >> [    0.098407] devtmpfs: initialized
> >> [    0.099095] x86/mm: Memory block size: 128MB
> >> [    0.104223] random: get_random_bytes called from setup_net+0x4c/0x1=
90 with crng_init=3D0
> >> [    0.104223] PM: Registering ACPI NVS region [mem 0x0006f000-0x0006f=
fff] (4096 bytes)
> >> [    0.104223] PM: Registering ACPI NVS region [mem 0xb8403000-0xb8502=
fff] (1048576 bytes)
> >> [    0.104380] clocksource: jiffies: mask: 0xffffffff max_cycles: 0xff=
ffffff, max_idle_ns: 1911260446275000 ns
> >> [    0.104437] futex hash table entries: 1024 (order: 4, 65536 bytes)
> >> [    0.104641] pinctrl core: initialized pinctrl subsystem
> >> [    0.105691] NET: Registered protocol family 16
> >> [    0.106528] cpuidle: using governor ladder
> >> [    0.106528] ACPI: bus type PCI registered
> >> [    0.106528] acpiphp: ACPI Hot Plug PCI Controller Driver version: 0=
.5
> >> [    0.106528] PCI: MMCONFIG for domain 0000 [bus 00-3f] at [mem 0xe00=
00000-0xe3ffffff] (base 0xe0000000)
> >> [    0.107068] PCI: not using MMCONFIG
> >> [    0.107068] PCI: Using configuration type 1 for base access
> >> [    0.112226] HugeTLB registered 2.00 MiB page size, pre-allocated 0 =
pages
> >> [    0.114359] ACPI: Added _OSI(Module Device)
> >> [    0.114364] ACPI: Added _OSI(Processor Device)
> >> [    0.114368] ACPI: Added _OSI(3.0 _SCP Extensions)
> >> [    0.114372] ACPI: Added _OSI(Processor Aggregator Device)
> >> [    0.129992] ACPI: Dynamic OEM Table Load:
> >> [    0.130029] ACPI: SSDT 0xFFFF9A13351A7800 0003BC (v01 PmRef  Cpu0Is=
t  00003000 INTL 20121114)
> >> [    0.131292] ACPI: Dynamic OEM Table Load:
> >> [    0.131308] ACPI: SSDT 0xFFFF9A1335158400 00015F (v01 PmRef  ApIst =
   00003000 INTL 20121114)
> >> [    0.134265] ACPI: Interpreter enabled
> >> [    0.134325] ACPI: (supports S0 S4 S5)
> >> [    0.134331] ACPI: Using IOAPIC for interrupt routing
> >> [    0.134432] PCI: MMCONFIG for domain 0000 [bus 00-3f] at [mem 0xe00=
00000-0xe3ffffff] (base 0xe0000000)
> >> [    0.135239] PCI: MMCONFIG at [mem 0xe0000000-0xe3ffffff] reserved i=
n ACPI motherboard resources
> >> [    0.135270] PCI: Using host bridge windows from ACPI; if necessary,=
 use "pci=3Dnocrs" and report a bug
> >> [    0.135864] ACPI: Enabled 4 GPEs in block 00 to 3F
> >> [    0.556549] ACPI: Power Resource [USBC] (on)
> >> [    0.571159] ACPI: PCI Root Bridge [PCI0] (domain 0000 [bus 00-ff])
> >> [    0.571172] acpi PNP0A08:00: _OSC: OS supports [ExtendedConfig ASPM=
 ClockPM Segments MSI]
> >> [    0.571603] acpi PNP0A08:00: _OSC failed (AE_ERROR); disabling ASPM
> >> [    0.571632] acpi PNP0A08:00: [Firmware Info]: MMCONFIG for domain 0=
000 [bus 00-3f] only partially covers this bridge
> >> [    0.572665] PCI host bridge to bus 0000:00
> >> [    0.572672] pci_bus 0000:00: root bus resource [io  0x0000-0x006f w=
indow]
> >> [    0.572677] pci_bus 0000:00: root bus resource [io  0x0078-0x0cf7 w=
indow]
> >> [    0.572682] pci_bus 0000:00: root bus resource [io  0x0d00-0xffff w=
indow]
> >> [    0.572687] pci_bus 0000:00: root bus resource [mem 0x000a0000-0x00=
0bffff window]
> >> [    0.572691] pci_bus 0000:00: root bus resource [mem 0x000c0000-0x00=
0dffff window]
> >> [    0.572696] pci_bus 0000:00: root bus resource [mem 0x000e0000-0x00=
0fffff window]
> >> [    0.572700] pci_bus 0000:00: root bus resource [mem 0xc0000000-0xd0=
9ffffe window]
> >> [    0.572707] pci_bus 0000:00: root bus resource [bus 00-ff]
> >> [    0.572724] pci 0000:00:00.0: [8086:0f00] type 00 class 0x060000
> >> [    0.573073] pci 0000:00:02.0: [8086:0f31] type 00 class 0x030000
> >> [    0.573093] pci 0000:00:02.0: reg 0x10: [mem 0xd0000000-0xd03fffff]
> >> [    0.573108] pci 0000:00:02.0: reg 0x18: [mem 0xc0000000-0xcfffffff =
pref]
> >> [    0.573122] pci 0000:00:02.0: reg 0x20: [io  0x7050-0x7057]
> >> [    0.573147] pci 0000:00:02.0: BAR 2: assigned to efifb
> >> [    0.573468] pci 0000:00:13.0: [8086:0f23] type 00 class 0x010601
> >> [    0.573495] pci 0000:00:13.0: reg 0x10: [io  0x7048-0x704f]
> >> [    0.573507] pci 0000:00:13.0: reg 0x14: [io  0x705c-0x705f]
> >> [    0.573520] pci 0000:00:13.0: reg 0x18: [io  0x7040-0x7047]
> >> [    0.573532] pci 0000:00:13.0: reg 0x1c: [io  0x7058-0x705b]
> >> [    0.573544] pci 0000:00:13.0: reg 0x20: [io  0x7020-0x703f]
> >> [    0.573556] pci 0000:00:13.0: reg 0x24: [mem 0xd0904000-0xd09047ff]
> >> [    0.573616] pci 0000:00:13.0: PME# supported from D3hot
> >> [    0.573918] pci 0000:00:1a.0: [8086:0f18] type 00 class 0x108000
> >> [    0.573953] pci 0000:00:1a.0: reg 0x10: [mem 0xd0800000-0xd08fffff]
> >> [    0.573969] pci 0000:00:1a.0: reg 0x14: [mem 0xd0700000-0xd07fffff]
> >> [    0.574104] pci 0000:00:1a.0: PME# supported from D0 D3hot
> >> [    0.574412] pci 0000:00:1b.0: [8086:0f04] type 00 class 0x040300
> >> [    0.574444] pci 0000:00:1b.0: reg 0x10: [mem 0xd0900000-0xd0903fff =
64bit]
> >> [    0.574531] pci 0000:00:1b.0: PME# supported from D0 D3hot D3cold
> >> [    0.574821] pci 0000:00:1c.0: [8086:0f48] type 01 class 0x060400
> >> [    0.574905] pci 0000:00:1c.0: PME# supported from D0 D3hot D3cold
> >> [    0.575237] pci 0000:00:1c.1: [8086:0f4a] type 01 class 0x060400
> >> [    0.575320] pci 0000:00:1c.1: PME# supported from D0 D3hot D3cold
> >> [    0.575633] pci 0000:00:1c.2: [8086:0f4c] type 01 class 0x060400
> >> [    0.575716] pci 0000:00:1c.2: PME# supported from D0 D3hot D3cold
> >> [    0.576044] pci 0000:00:1c.3: [8086:0f4e] type 01 class 0x060400
> >> [    0.576127] pci 0000:00:1c.3: PME# supported from D0 D3hot D3cold
> >> [    0.576444] pci 0000:00:1d.0: [8086:0f34] type 00 class 0x0c0320
> >> [    0.576480] pci 0000:00:1d.0: reg 0x10: [mem 0xd0905000-0xd09053ff]
> >> [    0.576609] pci 0000:00:1d.0: PME# supported from D0 D3hot D3cold
> >> [    0.576917] pci 0000:00:1f.0: [8086:0f1c] type 00 class 0x060100
> >> [    0.577295] pci 0000:00:1f.3: [8086:0f12] type 00 class 0x0c0500
> >> [    0.577343] pci 0000:00:1f.3: reg 0x10: [mem 0xd0906000-0xd090601f]
> >> [    0.577419] pci 0000:00:1f.3: reg 0x20: [io  0x7000-0x701f]
> >> [    0.577949] pci 0000:01:00.0: [110a:4078] type 00 class 0x050000
> >> [    0.577991] pci 0000:01:00.0: reg 0x10: [mem 0xd0600000-0xd067ffff]
> >> [    0.578027] pci 0000:01:00.0: reg 0x14: [mem 0xd0680000-0xd0687fff]
> >> [    0.581024] pci 0000:00:1c.0: PCI bridge to [bus 01]
> >> [    0.581035] pci 0000:00:1c.0:   bridge window [mem 0xd0600000-0xd06=
fffff]
> >> [    0.581217] pci 0000:02:00.0: [8086:1533] type 00 class 0x020000
> >> [    0.581258] pci 0000:02:00.0: reg 0x10: [mem 0xd0500000-0xd057ffff]
> >> [    0.581290] pci 0000:02:00.0: reg 0x18: [io  0x6000-0x601f]
> >> [    0.581309] pci 0000:02:00.0: reg 0x1c: [mem 0xd0580000-0xd0583fff]
> >> [    0.581309] pci 0000:02:00.0: PME# supported from D0 D3hot D3cold
> >> [    0.584024] pci 0000:00:1c.1: PCI bridge to [bus 02]
> >> [    0.584032] pci 0000:00:1c.1:   bridge window [io  0x6000-0x6fff]
> >> [    0.584038] pci 0000:00:1c.1:   bridge window [mem 0xd0500000-0xd05=
fffff]
> >> [    0.584211] pci 0000:03:00.0: [8086:1533] type 00 class 0x020000
> >> [    0.584252] pci 0000:03:00.0: reg 0x10: [mem 0xd0400000-0xd047ffff]
> >> [    0.584283] pci 0000:03:00.0: reg 0x18: [io  0x5000-0x501f]
> >> [    0.584302] pci 0000:03:00.0: reg 0x1c: [mem 0xd0480000-0xd0483fff]
> >> [    0.584447] pci 0000:03:00.0: PME# supported from D0 D3hot D3cold
> >> [    0.588023] pci 0000:00:1c.2: PCI bridge to [bus 03]
> >> [    0.588031] pci 0000:00:1c.2:   bridge window [io  0x5000-0x5fff]
> >> [    0.588038] pci 0000:00:1c.2:   bridge window [mem 0xd0400000-0xd04=
fffff]
> >> [    0.588187] pci 0000:00:1c.3: PCI bridge to [bus 04]
> >> [    0.793195] ACPI: PCI Interrupt Link [LNKA] (IRQs 3 4 5 6 10 11 12 =
14 15) *7
> >> [    0.793443] ACPI: PCI Interrupt Link [LNKB] (IRQs 3 4 5 6 10 11 12 =
14 15) *7
> >> [    0.793665] ACPI: PCI Interrupt Link [LNKC] (IRQs 3 4 5 6 10 11 12 =
14 15) *7
> >> [    0.793887] ACPI: PCI Interrupt Link [LNKD] (IRQs 3 4 5 6 10 11 12 =
14 15) *7
> >> [    0.794134] ACPI: PCI Interrupt Link [LNKE] (IRQs 3 4 5 6 10 11 12 =
14 15) *7
> >> [    0.794357] ACPI: PCI Interrupt Link [LNKF] (IRQs 3 4 5 6 10 *11 12=
 14 15)
> >> [    0.794577] ACPI: PCI Interrupt Link [LNKG] (IRQs 3 4 5 6 *10 11 12=
 14 15)
> >> [    0.794797] ACPI: PCI Interrupt Link [LNKH] (IRQs 3 4 5 6 10 *11 12=
 14 15)
> >> [    0.795820] pci 0000:00:02.0: vgaarb: setting as boot VGA device
> >> [    0.795820] pci 0000:00:02.0: vgaarb: VGA device added: decodes=3Di=
o+mem,owns=3Dio+mem,locks=3Dnone
> >> [    0.795820] pci 0000:00:02.0: vgaarb: bridge control possible
> >> [    0.795820] vgaarb: loaded
> >> [    0.796141] pps_core: LinuxPPS API ver. 1 registered
> >> [    0.796145] pps_core: Software ver. 5.3.6 - Copyright 2005-2007 Rod=
olfo Giometti <giometti@linux.it>
> >> [    0.796156] PTP clock support registered
> >> [    0.796202] EDAC MC: Ver: 3.0.0
> >> [    0.796414] Registered efivars operations
> >> [    0.796414] PCI: Using ACPI for IRQ routing
> >> [    0.798406] PCI: pci_cache_line_size set to 64 bytes
> >> [    0.798515] e820: reserve RAM buffer [mem 0x0006f000-0x0006ffff]
> >> [    0.798522] e820: reserve RAM buffer [mem 0xb43d3018-0xb7ffffff]
> >> [    0.798527] e820: reserve RAM buffer [mem 0xb7af3000-0xb7ffffff]
> >> [    0.798532] e820: reserve RAM buffer [mem 0xb93c3000-0xbbffffff]
> >> [    0.798538] e820: reserve RAM buffer [mem 0xba000000-0xbbffffff]
> >> [    0.800732] clocksource: Switched to clocksource refined-jiffies
> >> [    0.859223] VFS: Disk quotas dquot_6.6.0
> >> [    0.859280] VFS: Dquot-cache hash table entries: 512 (order 0, 4096=
 bytes)
> >> [    0.859949] AppArmor: AppArmor Filesystem Enabled
> >> [    0.860037] pnp: PnP ACPI init
> >> [    0.860239] pnp 00:00: Plug and Play ACPI device, IDs PNP0b00 (acti=
ve)
> >> [    0.860633] system 00:01: [io  0x0680-0x069f] has been reserved
> >> [    0.860641] system 00:01: [io  0x0400-0x047f] has been reserved
> >> [    0.860649] system 00:01: [io  0x0500-0x05fe] has been reserved
> >> [    0.860667] system 00:01: Plug and Play ACPI device, IDs PNP0c02 (a=
ctive)
> >> [    0.861148] pnp 00:02: Plug and Play ACPI device, IDs PNP0501 (acti=
ve)
> >> [    0.861570] pnp 00:03: Plug and Play ACPI device, IDs PNP0501 (acti=
ve)
> >> [    1.063984] system 00:04: [mem 0xe0000000-0xefffffff] could not be =
reserved
> >> [    1.063994] system 00:04: [mem 0xfed01000-0xfed01fff] has been rese=
rved
> >> [    1.064001] system 00:04: [mem 0xfed03000-0xfed03fff] has been rese=
rved
> >> [    1.064008] system 00:04: [mem 0xfed04000-0xfed04fff] has been rese=
rved
> >> [    1.064015] system 00:04: [mem 0xfed0c000-0xfed0ffff] has been rese=
rved
> >> [    1.064022] system 00:04: [mem 0xfed08000-0xfed08fff] has been rese=
rved
> >> [    1.064030] system 00:04: [mem 0xfed1c000-0xfed1cfff] has been rese=
rved
> >> [    1.064037] system 00:04: [mem 0xfed40000-0xfed44fff] has been rese=
rved
> >> [    1.064044] system 00:04: [mem 0xfee00000-0xfeefffff] has been rese=
rved
> >> [    1.064051] system 00:04: [mem 0xfef00000-0xfeffffff] has been rese=
rved
> >> [    1.064070] system 00:04: Plug and Play ACPI device, IDs PNP0c02 (a=
ctive)
> >> [    1.064612] pnp: PnP ACPI: found 5 devices
> >> [    1.076790] clocksource: acpi_pm: mask: 0xffffff max_cycles: 0xffff=
ff, max_idle_ns: 2085701024 ns
> >> [    1.076977] clocksource: Switched to clocksource acpi_pm
> >> [    1.076977] pci 0000:00:1c.0: bridge window [io  0x1000-0x0fff] to =
[bus 01] add_size 1000
> >> [    1.076977] pci 0000:00:1c.0: bridge window [mem 0x00100000-0x000ff=
fff 64bit pref] to [bus 01] add_size 200000 add_align 100000
> >> [    1.076977] pci 0000:00:1c.1: bridge window [mem 0x00100000-0x000ff=
fff 64bit pref] to [bus 02] add_size 200000 add_align 100000
> >> [    1.076977] pci 0000:00:1c.2: bridge window [mem 0x00100000-0x000ff=
fff 64bit pref] to [bus 03] add_size 200000 add_align 100000
> >> [    1.076977] pci 0000:00:1c.3: bridge window [io  0x1000-0x0fff] to =
[bus 04] add_size 1000
> >> [    1.076977] pci 0000:00:1c.3: bridge window [mem 0x00100000-0x000ff=
fff 64bit pref] to [bus 04] add_size 200000 add_align 100000
> >> [    1.076977] pci 0000:00:1c.3: bridge window [mem 0x00100000-0x000ff=
fff] to [bus 04] add_size 200000 add_align 100000
> >> [    1.076977] pci 0000:00:1c.0: BAR 15: no space for [mem size 0x0020=
0000 64bit pref]
> >> [    1.076977] pci 0000:00:1c.0: BAR 15: failed to assign [mem size 0x=
00200000 64bit pref]
> >> [    1.076977] pci 0000:00:1c.1: BAR 15: no space for [mem size 0x0020=
0000 64bit pref]
> >> [    1.076977] pci 0000:00:1c.1: BAR 15: failed to assign [mem size 0x=
00200000 64bit pref]
> >> [    1.077208] pci 0000:00:1c.2: BAR 15: no space for [mem size 0x0020=
0000 64bit pref]
> >> [    1.077215] pci 0000:00:1c.2: BAR 15: failed to assign [mem size 0x=
00200000 64bit pref]
> >> [    1.077229] pci 0000:00:1c.3: BAR 14: no space for [mem size 0x0020=
0000]
> >> [    1.077234] pci 0000:00:1c.3: BAR 14: failed to assign [mem size 0x=
00200000]
> >> [    1.077256] pci 0000:00:1c.3: BAR 15: no space for [mem size 0x0020=
0000 64bit pref]
> >> [    1.077262] pci 0000:00:1c.3: BAR 15: failed to assign [mem size 0x=
00200000 64bit pref]
> >> [    1.077274] pci 0000:00:1c.0: BAR 13: assigned [io  0x1000-0x1fff]
> >> [    1.077285] pci 0000:00:1c.3: BAR 13: assigned [io  0x2000-0x2fff]
> >> [    1.077302] pci 0000:00:1c.3: BAR 14: no space for [mem size 0x0020=
0000]
> >> [    1.077308] pci 0000:00:1c.3: BAR 14: failed to assign [mem size 0x=
00200000]
> >> [    1.077330] pci 0000:00:1c.3: BAR 15: no space for [mem size 0x0020=
0000 64bit pref]
> >> [    1.077335] pci 0000:00:1c.3: BAR 15: failed to assign [mem size 0x=
00200000 64bit pref]
> >> [    1.077357] pci 0000:00:1c.2: BAR 15: no space for [mem size 0x0020=
0000 64bit pref]
> >> [    1.077362] pci 0000:00:1c.2: BAR 15: failed to assign [mem size 0x=
00200000 64bit pref]
> >> [    1.077384] pci 0000:00:1c.1: BAR 15: no space for [mem size 0x0020=
0000 64bit pref]
> >> [    1.077390] pci 0000:00:1c.1: BAR 15: failed to assign [mem size 0x=
00200000 64bit pref]
> >> [    1.077411] pci 0000:00:1c.0: BAR 15: no space for [mem size 0x0020=
0000 64bit pref]
> >> [    1.077417] pci 0000:00:1c.0: BAR 15: failed to assign [mem size 0x=
00200000 64bit pref]
> >> [    1.077424] pci 0000:00:1c.0: PCI bridge to [bus 01]
> >> [    1.077430] pci 0000:00:1c.0:   bridge window [io  0x1000-0x1fff]
> >> [    1.077437] pci 0000:00:1c.0:   bridge window [mem 0xd0600000-0xd06=
fffff]
> >> [    1.077448] pci 0000:00:1c.1: PCI bridge to [bus 02]
> >> [    1.077453] pci 0000:00:1c.1:   bridge window [io  0x6000-0x6fff]
> >> [    1.077460] pci 0000:00:1c.1:   bridge window [mem 0xd0500000-0xd05=
fffff]
> >> [    1.077470] pci 0000:00:1c.2: PCI bridge to [bus 03]
> >> [    1.077475] pci 0000:00:1c.2:   bridge window [io  0x5000-0x5fff]
> >> [    1.077482] pci 0000:00:1c.2:   bridge window [mem 0xd0400000-0xd04=
fffff]
> >> [    1.077492] pci 0000:00:1c.3: PCI bridge to [bus 04]
> >> [    1.077497] pci 0000:00:1c.3:   bridge window [io  0x2000-0x2fff]
> >> [    1.077511] pci_bus 0000:00: resource 4 [io  0x0000-0x006f window]
> >> [    1.077516] pci_bus 0000:00: resource 5 [io  0x0078-0x0cf7 window]
> >> [    1.077520] pci_bus 0000:00: resource 6 [io  0x0d00-0xffff window]
> >> [    1.077525] pci_bus 0000:00: resource 7 [mem 0x000a0000-0x000bffff =
window]
> >> [    1.077530] pci_bus 0000:00: resource 8 [mem 0x000c0000-0x000dffff =
window]
> >> [    1.077534] pci_bus 0000:00: resource 9 [mem 0x000e0000-0x000fffff =
window]
> >> [    1.077539] pci_bus 0000:00: resource 10 [mem 0xc0000000-0xd09ffffe=
 window]
> >> [    1.077544] pci_bus 0000:01: resource 0 [io  0x1000-0x1fff]
> >> [    1.077548] pci_bus 0000:01: resource 1 [mem 0xd0600000-0xd06fffff]
> >> [    1.077553] pci_bus 0000:02: resource 0 [io  0x6000-0x6fff]
> >> [    1.077558] pci_bus 0000:02: resource 1 [mem 0xd0500000-0xd05fffff]
> >> [    1.077562] pci_bus 0000:03: resource 0 [io  0x5000-0x5fff]
> >> [    1.077567] pci_bus 0000:03: resource 1 [mem 0xd0400000-0xd04fffff]
> >> [    1.077572] pci_bus 0000:04: resource 0 [io  0x2000-0x2fff]
> >> [    1.077819] NET: Registered protocol family 2
> >> [    1.078615] TCP established hash table entries: 65536 (order: 7, 52=
4288 bytes)
> >> [    1.081158] TCP bind hash table entries: 65536 (order: 9, 3670016 b=
ytes)
> >> [    1.082455] TCP: Hash tables configured (established 65536 bind 655=
36)
> >> [    1.082955] UDP hash table entries: 4096 (order: 7, 524288 bytes)
> >> [    1.083530] UDP-Lite hash table entries: 4096 (order: 7, 524288 byt=
es)
> >> [    1.083926] NET: Registered protocol family 1
> >> [    1.083973] pci 0000:00:02.0: Video device with shadowed ROM at [me=
m 0x000c0000-0x000dffff]
> >> [    2.293104] pci 0000:00:1d.0: EHCI: BIOS handoff failed (BIOS bug?)=
 01010001
> >> [    2.293507] PCI: CLS 64 bytes, default 64
> >> [    2.293720] Unpacking initramfs...
> >> [    3.849375] Freeing initrd memory: 36672K
> >> [    3.849384] PCI-DMA: Using software bounce buffering for IO (SWIOTL=
B)
> >> [    3.849389] software IO TLB: mapped [mem 0xb03d3000-0xb43d3000] (64=
MB)
> >> [    3.850852] audit: initializing netlink subsys (disabled)
> >> [    3.851124] audit: type=3D2000 audit(1579779453.850:1): state=3Dini=
tialized audit_enabled=3D0 res=3D1
> >> [    3.852811] workingset: timestamp_bits=3D40 max_order=3D21 bucket_o=
rder=3D0
> >> [    3.860637] zbud: loaded
> >> [    4.781454] Key type asymmetric registered
> >> [    4.781461] Asymmetric key parser 'x509' registered
> >> [    4.781625] Block layer SCSI generic (bsg) driver version 0.4 loade=
d (major 247)
> >> [    4.781777] io scheduler noop registered
> >> [    4.781782] io scheduler deadline registered
> >> [    4.781807] io scheduler cfq registered (default)
> >> [    4.781812] io scheduler mq-deadline registered
> >> [    4.783771] efifb: probing for efifb
> >> [    4.783810] efifb: framebuffer at 0xc0000000, using 3072k, total 30=
72k
> >> [    4.783815] efifb: mode is 1024x768x32, linelength=3D4096, pages=3D=
1
> >> [    4.783817] efifb: scrolling: redraw
> >> [    4.783821] efifb: Truecolor: size=3D8:8:8:8, shift=3D24:16:8:0
> >> [    4.789833] Console: switching to colour frame buffer device 128x48
> >> [    4.795515] fb0: EFI VGA frame buffer device
> >> [    4.795551] intel_idle: MWAIT substates: 0x33000020
> >> [    4.795555] intel_idle: v0.4.1 model 0x37
> >> [    4.795563] intel_idle: intel_idle_state_table_update BYT 0x37 reac=
hed
> >> [    4.795566] intel_idle: byt_idle_state_table_update reached
> >> [    4.795570] intel_idle: state C6N is disabled
> >> [    4.795573] intel_idle: state C6S is disabled
> >> [    4.795577] intel_idle: state C7 is disabled
> >> [    4.795579] intel_idle: state C7S is disabled
> >> [    4.795975] intel_idle: lapic_timer_reliable_states 0xffffffff
> >> [    4.806494] Serial: 8250/16550 driver, 4 ports, IRQ sharing enabled
> >> [    4.806692] 00:02: ttyS0 at I/O 0x3f8 (irq =3D 4, base_baud =3D 115=
200) is a TI16750
> >> [    4.807130] 00:03: ttyS1 at I/O 0x2f8 (irq =3D 3, base_baud =3D 115=
200) is a TI16750
> >> [    4.808544] Linux agpgart interface v0.103
> >> [    4.825212] tpm_tis MSFT0101:00: 2.0 TPM (device-id 0x1A, rev-id 16=
)
> >> [    4.895129] tsc: Refined TSC clocksource calibration: 1833.333 MHz
> >> [    4.895196] clocksource: tsc: mask: 0xffffffffffffffff max_cycles: =
0x34da54753aa, max_idle_ns: 881590618787 ns
> >> [    5.242969] AMD IOMMUv2 driver by Joerg Roedel <jroedel@suse.de>
> >> [    5.242974] AMD IOMMUv2 functionality not available on this system
> >> [    5.253443] loop: module loaded
> >> [    5.253643] i8042: PNP: No PS/2 controller found.
> >> [    5.253647] i8042: Probing ports directly.
> >> [    5.254696] serio: i8042 KBD port at 0x60,0x64 irq 1
> >> [    5.254835] serio: i8042 AUX port at 0x60,0x64 irq 12
> >> [    5.255359] mousedev: PS/2 mouse device common for all mice
> >> [    5.255647] rtc_cmos 00:00: RTC can wake from S4
> >> [    5.256165] rtc_cmos 00:00: rtc core: registered rtc_cmos as rtc0
> >> [    5.256325] rtc_cmos 00:00: alarms up to one month, y3k, 242 bytes =
nvram
> >> [    5.256361] intel_pstate: Intel P-state driver initializing
> >> [    5.259552] pmc_atom: SIMATIC IPC227E critclks quirk enabled
> >> [    5.262904] NET: Registered protocol family 10
> >> [    5.288902] Segment Routing with IPv6
> >> [    5.288959] mip6: Mobile IPv6
> >> [    5.288968] NET: Registered protocol family 17
> >> [    5.288983] mpls_gso: MPLS GSO support
> >> [    5.290144] microcode: sig=3D0x30678, pf=3D0x8, revision=3D0x838
> >> [    5.290400] microcode: Microcode Update Driver: v2.2.
> >> [    5.290440] sched_clock: Marking stable (5290383624, 0)->(530726742=
6, -16883802)
> >> [    5.291113] registered taskstats version 1
> >> [    5.291208] zswap: loaded using pool lzo/zbud
> >> [    5.291321] AppArmor: AppArmor sha1 policy hashing enabled
> >> [    5.307572] ima: Allocated hash algorithm: sha256
> >> [    5.496426] rtc_cmos 00:00: setting system clock to 2020-01-23 11:3=
7:35 UTC (1579779455)
> >> [    5.511262] Freeing unused kernel memory: 2228K
> >> [    5.511270] Write protecting the kernel read-only data: 16384k
> >> [    5.514988] Freeing unused kernel memory: 2024K
> >> [    5.520939] Freeing unused kernel memory: 1016K
> >> [    5.532218] x86/mm: Checked W+X mappings: passed, no W+X pages foun=
d.
> >> [    5.532222] x86/mm: Checking user space page tables
> >> [    5.543163] x86/mm: Checked W+X mappings: passed, no W+X pages foun=
d.
> >> [    5.904409] clocksource: Switched to clocksource tsc
> >> [    7.067537] input: Sleep Button as /devices/LNXSYSTM:00/LNXSYBUS:00=
/PNP0C0E:00/input/input2
> >> [    7.067577] ACPI: Sleep Button [SLPB]
> >> [    7.068184] input: Power Button as /devices/LNXSYSTM:00/LNXPWRBN:00=
/input/input3
> >> [    7.072102] ACPI: Power Button [PWRF]
> >> [    7.278653] i801_smbus 0000:00:1f.3: SMBus using PCI interrupt
> >> [    7.278922] ACPI: bus type USB registered
> >> [    7.284861] usbcore: registered new interface driver usbfs
> >> [    7.292620] usbcore: registered new interface driver hub
> >> [    7.295421] SCSI subsystem initialized
> >> [    7.295876] usbcore: registered new device driver usb
> >> [    7.298236] dca service started, version 1.12.1
> >> [    7.362661] libata version 3.00 loaded.
> >> [    7.385579] igb: Intel(R) Gigabit Ethernet Network Driver - version=
 5.4.0-k
> >> [    7.385584] igb: Copyright (c) 2007-2014 Intel Corporation.
> >> [    7.401118] ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Dri=
ver
> >> [    7.510462] ehci-pci: EHCI PCI platform driver
> >> [    7.510946] ehci-pci 0000:00:1d.0: EHCI Host Controller
> >> [    7.510961] ehci-pci 0000:00:1d.0: new USB bus registered, assigned=
 bus number 1
> >> [    7.510982] ehci-pci 0000:00:1d.0: debug port 2
> >> [    7.514993] ehci-pci 0000:00:1d.0: cache line size of 64 is not sup=
ported
> >> [    7.515453] ehci-pci 0000:00:1d.0: irq 20, io mem 0xd0905000
> >> [    7.522131] ehci-pci 0000:00:1d.0: USB 2.0 started, EHCI 1.00
> >> [    7.522512] usb usb1: New USB device found, idVendor=3D1d6b, idProd=
uct=3D0002
> >> [    7.522522] usb usb1: New USB device strings: Mfr=3D3, Product=3D2,=
 SerialNumber=3D1
> >> [    7.522529] usb usb1: Product: EHCI Host Controller
> >> [    7.522535] usb usb1: Manufacturer: Linux 4.14.139-rt66 ehci_hcd
> >> [    7.522541] usb usb1: SerialNumber: 0000:00:1d.0
> >> [    7.523380] hub 1-0:1.0: USB hub found
> >> [    7.523422] hub 1-0:1.0: 8 ports detected
> >> [    7.527906] [drm] Memory usable by graphics device =3D 2048M
> >> [    7.527913] checking generic (c0000000 300000) vs hw (c0000000 1000=
0000)
> >> [    7.527917] fb: switching to inteldrmfb from EFI VGA
> >> [    7.527970] Console: switching to colour dummy device 80x25
> >> [    7.528620] [drm] Replacing VGA console driver
> >> [    7.529224] [drm] Supports vblank timestamp caching Rev 2 (21.10.20=
13).
> >> [    7.529227] [drm] Driver supports precise vblank timestamp query.
> >> [    7.530713] i915 0000:00:02.0: vgaarb: changed VGA decodes: olddeco=
des=3Dio+mem,decodes=3Dio+mem:owns=3Dio+mem
> >> [    7.539108] [drm] Initialized i915 1.6.0 20170818 for 0000:00:02.0 =
on minor 0
> >> [    7.542442] ACPI: Video Device [GFX0] (multi-head: yes  rom: no  po=
st: no)
> >> [    7.543159] input: Video Bus as /devices/LNXSYSTM:00/LNXSYBUS:00/PN=
P0A08:00/LNXVIDEO:00/input/input5
> >> [    7.543504] ahci 0000:00:13.0: version 3.0
> >> [    7.544866] ahci 0000:00:13.0: controller can't do DEVSLP, turning =
off
> >> [    7.555182] ahci 0000:00:13.0: AHCI 0001.0300 32 slots 2 ports 3 Gb=
ps 0x1 impl SATA mode
> >> [    7.555193] ahci 0000:00:13.0: flags: 64bit ncq led clo pio slum pa=
rt deso
> >> [    7.556960] scsi host0: ahci
> >> [    7.557620] scsi host1: ahci
> >> [    7.557929] ata1: SATA max UDMA/133 abar m2048@0xd0904000 port 0xd0=
904100 irq 88
> >> [    7.557935] ata2: DUMMY
> >> [    7.624548] pps pps0: new PPS source ptp0
> >> [    7.624563] igb 0000:02:00.0: added PHC on eth0
> >> [    7.624572] igb 0000:02:00.0: Intel(R) Gigabit Ethernet Network Con=
nection
> >> [    7.624582] igb 0000:02:00.0: eth0: (PCIe:2.5Gb/s:Width x1) 20:87:5=
6:31:c5:0c
> >> [    7.624634] igb 0000:02:00.0: eth0: PBA No: 000300-000
> >> [    7.624643] igb 0000:02:00.0: Using MSI-X interrupts. 4 rx queue(s)=
, 4 tx queue(s)
> >> [    7.663725] fbcon: inteldrmfb (fb0) is primary device
> >> [    7.715912] Console: switching to colour frame buffer device 240x67
> >> [    7.752821] i915 0000:00:02.0: fb0: inteldrmfb frame buffer device
> >> [    7.849108] usb 1-1: new high-speed USB device number 2 using ehci-=
pci
> >> [    7.862245] pps pps1: new PPS source ptp1
> >> [    7.862252] igb 0000:03:00.0: added PHC on eth1
> >> [    7.862256] igb 0000:03:00.0: Intel(R) Gigabit Ethernet Network Con=
nection
> >> [    7.862260] igb 0000:03:00.0: eth1: (PCIe:2.5Gb/s:Width x1) 20:87:5=
6:31:c5:06
> >> [    7.862303] igb 0000:03:00.0: eth1: PBA No: 000300-000
> >> [    7.862308] igb 0000:03:00.0: Using MSI-X interrupts. 4 rx queue(s)=
, 4 tx queue(s)
> >> [    7.869343] ata1: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
> >> [    7.870113] igb 0000:02:00.0 enp2s0: renamed from eth0
> >> [    7.870864] ata1.00: ATA-10: Micron_5100_MTFDDAK240TCB,  D0MU037, m=
ax UDMA/133
> >> [    7.870869] ata1.00: 468862128 sectors, multi 16: LBA48 NCQ (depth =
31/32), AA
> >> [    7.872982] ata1.00: configured for UDMA/133
> >> [    7.873448] scsi 0:0:0:0: Direct-Access     ATA      Micron_5100_MT=
FD U037 PQ: 0 ANSI: 5
> >> [    7.876337] igb 0000:03:00.0 enp3s0: renamed from eth1
> >> [    7.927678] ata1.00: Enabling discard_zeroes_data
> >> [    7.927918] sd 0:0:0:0: [sda] 468862128 512-byte logical blocks: (2=
40 GB/224 GiB)
> >> [    7.927921] sd 0:0:0:0: [sda] 4096-byte physical blocks
> >> [    7.927962] sd 0:0:0:0: [sda] Write Protect is off
> >> [    7.927965] sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
> >> [    7.928086] sd 0:0:0:0: [sda] Write cache: enabled, read cache: ena=
bled, doesn't support DPO or FUA
> >> [    7.928580] ata1.00: Enabling discard_zeroes_data
> >> [    7.932119]  sda: sda1 sda2 sda3 sda4
> >> [    7.933294] ata1.00: Enabling discard_zeroes_data
> >> [    7.933745] sd 0:0:0:0: [sda] Attached SCSI disk
> >> [    7.977410] usb 1-1: New USB device found, idVendor=3D8087, idProdu=
ct=3D07e6
> >> [    7.977418] usb 1-1: New USB device strings: Mfr=3D0, Product=3D0, =
SerialNumber=3D0
> >> [    7.977925] hub 1-1:1.0: USB hub found
> >> [    7.978055] hub 1-1:1.0: 4 ports detected
> >> [    8.255098] usb 1-1.2: new high-speed USB device number 3 using ehc=
i-pci
> >> [    8.287909] random: lvm: uninitialized urandom read (4 bytes read)
> >> [    8.333412] usb 1-1.2: New USB device found, idVendor=3D0424, idPro=
duct=3D2514
> >> [    8.333421] usb 1-1.2: New USB device strings: Mfr=3D0, Product=3D0=
, SerialNumber=3D0
> >> [    8.334095] hub 1-1.2:1.0: USB hub found
> >> [    8.334287] hub 1-1.2:1.0: 4 ports detected
> >> [    8.360743] device-mapper: uevent: version 1.0.3
> >> [    8.361140] device-mapper: ioctl: 4.37.0-ioctl (2017-09-20) initial=
ised: dm-devel@redhat.com
> >> [    8.400062] usb 1-1.3: new low-speed USB device number 4 using ehci=
-pci
> >> [    8.414458] random: lvm: uninitialized urandom read (2 bytes read)
> >> [    8.483918] usb 1-1.3: New USB device found, idVendor=3D413c, idPro=
duct=3D301a
> >> [    8.483926] usb 1-1.3: New USB device strings: Mfr=3D1, Product=3D2=
, SerialNumber=3D0
> >> [    8.483931] usb 1-1.3: Product: Dell MS116 USB Optical Mouse
> >> [    8.483936] usb 1-1.3: Manufacturer: PixArt
> >> [    8.512842] hidraw: raw HID events driver (C) Jiri Kosina
> >> [    8.536324] usbcore: registered new interface driver usbhid
> >> [    8.536329] usbhid: USB HID core driver
> >> [    8.549051] usb 1-1.4: new low-speed USB device number 5 using ehci=
-pci
> >> [    8.564722] input: PixArt Dell MS116 USB Optical Mouse as /devices/=
pci0000:00/0000:00:1d.0/usb1/1-1/1-1.3/1-1.3:1.0/0003:413C:301A.0001/input/=
input6
> >> [    8.565486] hid-generic 0003:413C:301A.0001: input,hidraw0: USB HID=
 v1.11 Mouse [PixArt Dell MS116 USB Optical Mouse] on usb-0000:00:1d.0-1.3/=
input0
> >> [    8.635160] usb 1-1.4: New USB device found, idVendor=3D413c, idPro=
duct=3D2113
> >> [    8.635167] usb 1-1.4: New USB device strings: Mfr=3D0, Product=3D2=
, SerialNumber=3D0
> >> [    8.635171] usb 1-1.4: Product: Dell KB216 Wired Keyboard
> >> [    8.640453] input: Dell KB216 Wired Keyboard as /devices/pci0000:00=
/0000:00:1d.0/usb1/1-1/1-1.4/1-1.4:1.0/0003:413C:2113.0002/input/input7
> >> [    8.693432] hid-generic 0003:413C:2113.0002: input,hidraw1: USB HID=
 v1.11 Keyboard [Dell KB216 Wired Keyboard] on usb-0000:00:1d.0-1.4/input0
> >> [    8.700294] input: Dell KB216 Wired Keyboard as /devices/pci0000:00=
/0000:00:1d.0/usb1/1-1/1-1.4/1-1.4:1.1/0003:413C:2113.0003/input/input8
> >> [    8.705097] usb 1-1.2.4: new high-speed USB device number 6 using e=
hci-pci
> >> [    8.752218] hid-generic 0003:413C:2113.0003: input,hidraw2: USB HID=
 v1.11 Device [Dell KB216 Wired Keyboard] on usb-0000:00:1d.0-1.4/input1
> >> [    8.797190] usb 1-1.2.4: New USB device found, idVendor=3D0781, idP=
roduct=3D5581
> >> [    8.797206] usb 1-1.2.4: New USB device strings: Mfr=3D1, Product=
=3D2, SerialNumber=3D3
> >> [    8.797216] usb 1-1.2.4: Product: Ultra
> >> [    8.797225] usb 1-1.2.4: Manufacturer: SanDisk
> >> [    8.797235] usb 1-1.2.4: SerialNumber: 04018812802fe8c3affb6e4ff14c=
9072616e7bdcf156e4641ccc688d0ccd13340aa400000000000000000000c1ca173b001a081=
8815581079d275241
> >> [    8.839864] usb-storage 1-1.2.4:1.0: USB Mass Storage device detect=
ed
> >> [    8.840644] scsi host2: usb-storage 1-1.2.4:1.0
> >> [    8.841311] usbcore: registered new interface driver usb-storage
> >> [    8.880219] usbcore: registered new interface driver uas
> >> [    9.889263] scsi 2:0:0:0: Direct-Access     SanDisk  Ultra         =
   1.00 PQ: 0 ANSI: 6
> >> [    9.892272] sd 2:0:0:0: [sdb] 120176640 512-byte logical blocks: (6=
1.5 GB/57.3 GiB)
> >> [    9.893800] sd 2:0:0:0: [sdb] Write Protect is off
> >> [    9.893813] sd 2:0:0:0: [sdb] Mode Sense: 43 00 00 00
> >> [    9.895222] sd 2:0:0:0: [sdb] Write cache: disabled, read cache: en=
abled, doesn't support DPO or FUA
> >> [    9.916779] GPT:Primary header thinks Alt. header is not at the end=
 of the disk.
> >> [    9.916791] GPT:14877691 !=3D 120176639
> >> [    9.916798] GPT:Alternate GPT header not at the end of the disk.
> >> [    9.916804] GPT:14877691 !=3D 120176639
> >> [    9.916809] GPT: Use GNU Parted to correct GPT errors.
> >> [    9.916867]  sdb: sdb1 sdb2
> >> [    9.922154] sd 2:0:0:0: [sdb] Attached SCSI removable disk
> >> [   14.715297] NET: Registered protocol family 38
> >> [   17.437791] random: cryptsetup: uninitialized urandom read (2 bytes=
 read)
> >> [   25.557261] random: cryptsetup: uninitialized urandom read (2 bytes=
 read)
> >> [   33.658071] random: cryptsetup: uninitialized urandom read (2 bytes=
 read)
> >> [   41.752577] random: cryptsetup: uninitialized urandom read (2 bytes=
 read)
> >> [   44.817298] random: lvm: uninitialized urandom read (4 bytes read)
> >> [   45.573555] EXT4-fs (dm-5): mounted filesystem with ordered data mo=
de. Opts: i_version
> >> [   46.013797] EXT4-fs: Warning: mounting with data=3Djournal disables=
 delayed allocation and O_DIRECT support!
> >> [   46.016488] EXT4-fs (dm-7): mounted filesystem with journalled data=
 mode. Opts: data=3Djournal
> >> [   47.319423] audit: type=3D1805 audit(1579779497.322:2): action=3D"d=
ont_appraise" fsmagic=3D"0x9fa0" res=3D1
> >> [   47.319439] audit: type=3D1805 audit(1579779497.322:3): action=3D"d=
ont_appraise" fsmagic=3D"0x62656572" res=3D1
> >> [   47.319450] audit: type=3D1805 audit(1579779497.322:4): action=3D"d=
ont_appraise" fsmagic=3D"0x64626720" res=3D1
> >> [   47.319460] audit: type=3D1805 audit(1579779497.322:5): action=3D"d=
ont_appraise" fsmagic=3D"0x1021994" res=3D1
> >> [   47.319474] audit: type=3D1805 audit(1579779497.322:6): action=3D"d=
ont_appraise" fsmagic=3D"0x858458f6" res=3D1
> >> [   47.319490] audit: type=3D1805 audit(1579779497.322:7): action=3D"d=
ont_appraise" fsmagic=3D"0x1cd1" res=3D1
> >> [   47.319531] audit: type=3D1805 audit(1579779497.322:8): action=3D"d=
ont_appraise" fsmagic=3D"0x42494e4d" res=3D1
> >> [   47.319544] audit: type=3D1805 audit(1579779497.322:9): action=3D"d=
ont_appraise" fsmagic=3D"0x73636673" res=3D1
> >> [   47.319558] audit: type=3D1805 audit(1579779497.322:10): action=3D"=
dont_appraise" fsmagic=3D"0xf97cff8c" res=3D1
> >> [   47.319586] audit: type=3D1805 audit(1579779497.322:11): action=3D"=
dont_appraise" fsmagic=3D"0x43415d53" res=3D1
> >> [   47.319735] systemd[1]: Successfully loaded the IMA custom policy /=
etc/ima/ima-policy.
> >> [   47.319758] IMA: policy update completed
> >> [   47.366386] ip_tables: (C) 2000-2006 Netfilter Core Team
> >> [   47.437980] systemd[1]: systemd 241 running in system mode. (+PAM +=
AUDIT +SELINUX +IMA +APPARMOR +SMACK +SYSVINIT +UTMP +LIBCRYPTSETUP +GCRYPT=
 +GNUTLS +ACL +XZ +LZ4 +SECCOMP +BLKID +ELFUTILS +KMOD -IDN2 +IDN -PCRE2 de=
fault-hierarchy=3Dhybrid)
> >> [   47.451240] systemd[1]: Detected architecture x86-64.
> >> [   47.457586] systemd[1]: Set hostname to <localhost.localdomain>.
> >> [   47.459459] systemd[1]: Failed to bump fs.file-max, ignoring: Inval=
id argument
> >> [   47.818194] systemd[1]: /run/systemd/generator.late/squid.service:2=
1: PIDFile=3D references path below legacy directory /var/run/, updating /v=
ar/run/squid.pid =E2=86=92 /run/squid.pid; please update the unit file acco=
rdingly.
> >> [   47.827355] systemd[1]: Created slice system-getty.slice.
> >> [   47.828000] systemd[1]: Listening on udev Kernel Socket.
> >> [   47.828420] systemd[1]: Listening on fsck to fsckd communication So=
cket.
> >> [   47.828862] systemd[1]: Listening on Journal Socket (/dev/log).
> >> [   47.829710] systemd[1]: Set up automount Arbitrary Executable File =
Formats File System Automount Point.
> >> [   47.996814] random: lvm: uninitialized urandom read (4 bytes read)
> >> [   48.050142] Non-volatile memory driver v1.3
> >> [   48.316925] random: systemd-random-: uninitialized urandom read (51=
2 bytes read)
> >> [   48.494669] random: mktemp: uninitialized urandom read (6 bytes rea=
d)
> >> [   49.056503] systemd-journald[503]: Received request to flush runtim=
e journal from PID 1
> >> [   49.337143] shpchp: Standard Hot Plug PCI Controller Driver version=
: 0.4
> >> [   49.847951] input: PC Speaker as /devices/platform/pcspkr/input/inp=
ut9
> >> [   49.946847] sd 0:0:0:0: Attached scsi generic sg0 type 0
> >> [   50.014119] sd 2:0:0:0: Attached scsi generic sg1 type 0
> >> [   50.168891] snd_hda_intel 0000:00:1b.0: bound 0000:00:02.0 (ops i91=
5_audio_component_bind_ops [i915])
> >> [   50.215517] igb 0000:02:00.0 factorylan0: renamed from enp2s0
> >> [   50.254803] igb 0000:03:00.0 machinelan0: renamed from enp3s0
> >> [   50.318608] iTCO_vendor_support: vendor-support=3D0
> >> [   50.377676] iTCO_wdt: Intel TCO WatchDog Timer Driver v1.11
> >> [   50.380349] iTCO_wdt: Found a Bay Trail SoC TCO device (Version=3D3=
, TCOBASE=3D0x0460)
> >> [   50.455705] iTCO_wdt: initialized. heartbeat=3D30 sec (nowayout=3D0=
)
> >> [   50.705168] input: HDA Intel PCH HDMI/DP,pcm=3D3 as /devices/pci000=
0:00/0000:00:1b.0/sound/card0/input10
> >> [   50.753973] input: HDA Intel PCH HDMI/DP,pcm=3D7 as /devices/pci000=
0:00/0000:00:1b.0/sound/card0/input11
> >> [   50.833744] (NULL device *): hwmon_device_register() is deprecated.=
 Please convert the driver to use hwmon_device_register_with_info().
> >> [   50.866327] (NULL device *): hwmon_device_register() is deprecated.=
 Please convert the driver to use hwmon_device_register_with_info().
> >> [   50.955750] intel_rapl: Found RAPL domain package
> >> [   50.955757] intel_rapl: Found RAPL domain core
> >> [   52.482335] EXT4-fs (dm-6): mounted filesystem with journalled data=
 mode. Opts: data=3Djournal
> >> [   52.557641] EXT4-fs (dm-8): mounted filesystem with journalled data=
 mode. Opts: data=3Djournal
> >> [   55.920244] IPv6: ADDRCONF(NETDEV_UP): factorylan0: link is not rea=
dy
> >> [   55.978874] IPv6: ADDRCONF(NETDEV_UP): factorylan0: link is not rea=
dy
> >> [   55.995905] IPv6: ADDRCONF(NETDEV_UP): machinelan0: link is not rea=
dy
> >> [   56.049581] IPv6: ADDRCONF(NETDEV_UP): machinelan0: link is not rea=
dy
> >> [   58.981633] igb 0000:03:00.0 machinelan0: igb: machinelan0 NIC Link=
 is Up 1000 Mbps Full Duplex, Flow Control: RX/TX
> >> [   59.087351] IPv6: ADDRCONF(NETDEV_CHANGE): machinelan0: link become=
s ready
> >> [   66.389565] bridge: filtering via arp/ip/ip6tables is no longer ava=
ilable by default. Update your scripts to load br_netfilter if you need thi=
s.
> >> [   66.395634] Bridge firewalling registered
> >> [   66.431249] nf_conntrack version 0.5.0 (65536 buckets, 262144 max)
> >> [   66.671647] Initializing XFRM netlink socket
> >> [   66.684553] Netfilter messages via NETLINK v0.30.
> >> [   66.689312] ctnetlink v0.93: registering with nfnetlink.
> >> [   66.963230] IPv6: ADDRCONF(NETDEV_UP): docker0: link is not ready
> >> root@localhost:/home/mentor#
> >> root@localhost:# dmesg | grep tsc
> >> [    0.001000] tsc: Detected 1832.600 MHz processor
> >> [    4.895129] tsc: Refined TSC clocksource calibration: 1833.333 MHz
> >> [    4.895196] clocksource: tsc: mask: 0xffffffffffffffff max_cycles: =
0x34da54753aa, max_idle_ns: 881590618787 ns
> >> [    5.904409] clocksource: Switched to clocksource tsc
> >>
> >
> >
>

--0000000000006c7a13059d45d816
Content-Type: text/plain; charset="US-ASCII"; name="kernel_logs_with_hans_patch.txt"
Content-Disposition: attachment; filename="kernel_logs_with_hans_patch.txt"
Content-Transfer-Encoding: base64
Content-ID: <f_k5z8nu1l0>
X-Attachment-Id: f_k5z8nu1l0

cm9vdEBkZWJpYW46IyB1bmFtZSAtYQpMaW51eCBkZWJpYW4gNS40LjE1KyAjMSBTTVAgV2VkIEph
biAyOSAxMTozNzoyNSBJU1QgMjAyMCB4ODZfNjQgR05VL0xpbnV4CnJvb3RAZGViaWFuOiMgCnJv
b3RAZGViaWFuOiMgY2F0IC9wcm9jL2NtZGxpbmUgCkJPT1RfSU1BR0U9L2Jvb3Qvdm1saW51ei01
LjQuMTUrIHJvb3Q9VVVJRD1lY2U0NGY2Mi1kMjJmLTQyZGUtOTJiOS0wZjg0NTg4MTNjMTkgcm8g
ZGVidWcKcm9vdEBkZWJpYW46IyAKcm9vdEBkZWJpYW46IyBkbWVzZyB8IGdyZXAgdHNjClsgICAg
MC4wMDAwMDBdIHRzYyBtc3IgaWQgbWF0Y2ggMiBsbyAweDE2MDAKWyAgICAwLjAwMDAwMF0gdHNj
IG1zciBpZCBtYXRjaCAyIGxvIDB4MDAKWyAgICAwLjAwMDAwMF0gdHNjOiBEZXRlY3RlZCAxODMz
LjMyNiBNSHogcHJvY2Vzc29yClsgICAgMC40MjA4NDFdIGNsb2Nrc291cmNlOiB0c2MtZWFybHk6
IG1hc2s6IDB4ZmZmZmZmZmZmZmZmZmZmZiBtYXhfY3ljbGVzOiAweDM0ZGE0NmQxNzY4LCBtYXhf
aWRsZV9uczogODgxNTkwNjEwOTg1IG5zClsgICAgMS42NzY5NjBdIGNsb2Nrc291cmNlOiBTd2l0
Y2hlZCB0byBjbG9ja3NvdXJjZSB0c2MtZWFybHkKWyAgICA0LjY1NjAwNl0gY2xvY2tzb3VyY2U6
IHRzYzogbWFzazogMHhmZmZmZmZmZmZmZmZmZmZmIG1heF9jeWNsZXM6IDB4MzRkYTQ2ZDE3Njgs
IG1heF9pZGxlX25zOiA4ODE1OTA2MTA5ODUgbnMKWyAgICA0LjY1NjA0OF0gY2xvY2tzb3VyY2U6
IFN3aXRjaGVkIHRvIGNsb2Nrc291cmNlIHRzYwpyb290QGRlYmlhbjojIApyb290QGRlYmlhbjoj
IGRtZXNnIHwgZ3JlcCBNU1IKWyAgICAwLjAwMDAwMF0gTVNSX1BJTkZPOiAwMDAwMDYwMDAwMDAx
NjAwIC0+IDIyClsgICAgMC4wMDAwMDBdIE1TUl9GU0JGOiAwMDAwMDAwMDAwMDAwMDAwCnJvb3RA
ZGViaWFuOiMgZG1lc2cgfCBncmVwIFJFRgpbICAgIDAuMDAwMDAwXSBSRUZfQ0xPQ0s6IDAwMDE0
NTg1CnJvb3RAZGViaWFuOiMgCnJvb3RAZGViaWFuOiMgZG1lc2cgClsgICAgMC4wMDAwMDBdIExp
bnV4IHZlcnNpb24gNS40LjE1KyAodmlwdWxAdmlwdWwpIChnY2MgdmVyc2lvbiA4LjMuMCAoRGVi
aWFuIDguMy4wLTYpKSAjMSBTTVAgV2VkIEphbiAyOSAxMTozNzoyNSBJU1QgMjAyMApbICAgIDAu
MDAwMDAwXSBDb21tYW5kIGxpbmU6IEJPT1RfSU1BR0U9L2Jvb3Qvdm1saW51ei01LjQuMTUrIHJv
b3Q9VVVJRD1lY2U0NGY2Mi1kMjJmLTQyZGUtOTJiOS0wZjg0NTg4MTNjMTkgcm8gZGVidWcKWyAg
ICAwLjAwMDAwMF0geDg2L2ZwdTogeDg3IEZQVSB3aWxsIHVzZSBGWFNBVkUKWyAgICAwLjAwMDAw
MF0gQklPUy1wcm92aWRlZCBwaHlzaWNhbCBSQU0gbWFwOgpbICAgIDAuMDAwMDAwXSBCSU9TLWU4
MjA6IFttZW0gMHgwMDAwMDAwMDAwMDAwMDAwLTB4MDAwMDAwMDAwMDA2ZWZmZl0gdXNhYmxlClsg
ICAgMC4wMDAwMDBdIEJJT1MtZTgyMDogW21lbSAweDAwMDAwMDAwMDAwNmYwMDAtMHgwMDAwMDAw
MDAwMDZmZmZmXSBBQ1BJIE5WUwpbICAgIDAuMDAwMDAwXSBCSU9TLWU4MjA6IFttZW0gMHgwMDAw
MDAwMDAwMDcwMDAwLTB4MDAwMDAwMDAwMDA4ZmZmZl0gdXNhYmxlClsgICAgMC4wMDAwMDBdIEJJ
T1MtZTgyMDogW21lbSAweDAwMDAwMDAwMDAwOTAwMDAtMHgwMDAwMDAwMDAwMDlmZmZmXSByZXNl
cnZlZApbICAgIDAuMDAwMDAwXSBCSU9TLWU4MjA6IFttZW0gMHgwMDAwMDAwMDAwMTAwMDAwLTB4
MDAwMDAwMDBiN2FmMmZmZl0gdXNhYmxlClsgICAgMC4wMDAwMDBdIEJJT1MtZTgyMDogW21lbSAw
eDAwMDAwMDAwYjdhZjMwMDAtMHgwMDAwMDAwMGI3YjgyZmZmXSB0eXBlIDIwClsgICAgMC4wMDAw
MDBdIEJJT1MtZTgyMDogW21lbSAweDAwMDAwMDAwYjdiODMwMDAtMHgwMDAwMDAwMGI4NDAyZmZm
XSByZXNlcnZlZApbICAgIDAuMDAwMDAwXSBCSU9TLWU4MjA6IFttZW0gMHgwMDAwMDAwMGI4NDAz
MDAwLTB4MDAwMDAwMDBiODUwMmZmZl0gQUNQSSBOVlMKWyAgICAwLjAwMDAwMF0gQklPUy1lODIw
OiBbbWVtIDB4MDAwMDAwMDBiODUwMzAwMC0weDAwMDAwMDAwYjg1NDJmZmZdIEFDUEkgZGF0YQpb
ICAgIDAuMDAwMDAwXSBCSU9TLWU4MjA6IFttZW0gMHgwMDAwMDAwMGI4NTQzMDAwLTB4MDAwMDAw
MDBiOTNjMmZmZl0gdXNhYmxlClsgICAgMC4wMDAwMDBdIEJJT1MtZTgyMDogW21lbSAweDAwMDAw
MDAwYjkzYzMwMDAtMHgwMDAwMDAwMGI5Y2MyZmZmXSByZXNlcnZlZApbICAgIDAuMDAwMDAwXSBC
SU9TLWU4MjA6IFttZW0gMHgwMDAwMDAwMGI5Y2MzMDAwLTB4MDAwMDAwMDBiOWZmZmZmZl0gdXNh
YmxlClsgICAgMC4wMDAwMDBdIEJJT1MtZTgyMDogW21lbSAweDAwMDAwMDAwZTAwZjgwMDAtMHgw
MDAwMDAwMGUwMGY4ZmZmXSByZXNlcnZlZApbICAgIDAuMDAwMDAwXSBCSU9TLWU4MjA6IFttZW0g
MHgwMDAwMDAwMGZlZDAxMDAwLTB4MDAwMDAwMDBmZWQwMWZmZl0gcmVzZXJ2ZWQKWyAgICAwLjAw
MDAwMF0gQklPUy1lODIwOiBbbWVtIDB4MDAwMDAwMDBmZmIwMDAwMC0weDAwMDAwMDAwZmZmZmZm
ZmZdIHJlc2VydmVkClsgICAgMC4wMDAwMDBdIEJJT1MtZTgyMDogW21lbSAweDAwMDAwMDAxMDAw
MDAwMDAtMHgwMDAwMDAwMjNmZmZmZmZmXSB1c2FibGUKWyAgICAwLjAwMDAwMF0gTlggKEV4ZWN1
dGUgRGlzYWJsZSkgcHJvdGVjdGlvbjogYWN0aXZlClsgICAgMC4wMDAwMDBdIGVmaTogRUZJIHYy
LjQwIGJ5IElOU1lERSBDb3JwLgpbICAgIDAuMDAwMDAwXSBlZmk6ICBBQ1BJIDIuMD0weGI4NTQy
MDE0ICBFU1JUPTB4YjdiZTJkMTggIFNNQklPUz0weGI3ZGZhMDAwIApbICAgIDAuMDAwMDAwXSBT
TUJJT1MgMi43IHByZXNlbnQuClsgICAgMC4wMDAwMDBdIERNSTogU0lFTUVOUyBBRyBTSU1BVElD
IElQQzIyN0UvQTVFMzgxNTU2NzcsIEJJT1MgVjIwLjAxLjEyIDA0LzA1LzIwMTkKWyAgICAwLjAw
MDAwMF0gTVNSX1BJTkZPOiAwMDAwMDYwMDAwMDAxNjAwIC0+IDIyClsgICAgMC4wMDAwMDBdIHRz
YyBtc3IgaWQgbWF0Y2ggMiBsbyAweDE2MDAKWyAgICAwLjAwMDAwMF0gTVNSX0ZTQkY6IDAwMDAw
MDAwMDAwMDAwMDAKWyAgICAwLjAwMDAwMF0gdHNjIG1zciBpZCBtYXRjaCAyIGxvIDB4MDAKWyAg
ICAwLjAwMDAwMF0gUkVGX0NMT0NLOiAwMDAxNDU4NQpbICAgIDAuMDAwMDAwXSB0c2M6IERldGVj
dGVkIDE4MzMuMzI2IE1IeiBwcm9jZXNzb3IKWyAgICAwLjAwMjg3Ml0gZTgyMDogdXBkYXRlIFtt
ZW0gMHgwMDAwMDAwMC0weDAwMDAwZmZmXSB1c2FibGUgPT0+IHJlc2VydmVkClsgICAgMC4wMDI4
NzhdIGU4MjA6IHJlbW92ZSBbbWVtIDB4MDAwYTAwMDAtMHgwMDBmZmZmZl0gdXNhYmxlClsgICAg
MC4wMDI4OTFdIGxhc3RfcGZuID0gMHgyNDAwMDAgbWF4X2FyY2hfcGZuID0gMHg0MDAwMDAwMDAK
WyAgICAwLjAwMjg5OF0gTVRSUiBkZWZhdWx0IHR5cGU6IHVuY2FjaGFibGUKWyAgICAwLjAwMjkw
MV0gTVRSUiBmaXhlZCByYW5nZXMgZW5hYmxlZDoKWyAgICAwLjAwMjkwNV0gICAwMDAwMC05RkZG
RiB3cml0ZS1iYWNrClsgICAgMC4wMDI5MDhdICAgQTAwMDAtQkZGRkYgdW5jYWNoYWJsZQpbICAg
IDAuMDAyOTEyXSAgIEMwMDAwLUZGRkZGIHdyaXRlLXByb3RlY3QKWyAgICAwLjAwMjkxNV0gTVRS
UiB2YXJpYWJsZSByYW5nZXMgZW5hYmxlZDoKWyAgICAwLjAwMjkxOV0gICAwIGJhc2UgMEZGODAw
MDAwIG1hc2sgRkZGODAwMDAwIHdyaXRlLXByb3RlY3QKWyAgICAwLjAwMjkyM10gICAxIGJhc2Ug
MDAwMDAwMDAwIG1hc2sgRjgwMDAwMDAwIHdyaXRlLWJhY2sKWyAgICAwLjAwMjkyN10gICAyIGJh
c2UgMDgwMDAwMDAwIG1hc2sgRkMwMDAwMDAwIHdyaXRlLWJhY2sKWyAgICAwLjAwMjkzMV0gICAz
IGJhc2UgMEJDMDAwMDAwIG1hc2sgRkZDMDAwMDAwIHVuY2FjaGFibGUKWyAgICAwLjAwMjkzNV0g
ICA0IGJhc2UgMEJCMDAwMDAwIG1hc2sgRkZGMDAwMDAwIHVuY2FjaGFibGUKWyAgICAwLjAwMjkz
OV0gICA1IGJhc2UgMEJBRTAwMDAwIG1hc2sgRkZGRTAwMDAwIHVuY2FjaGFibGUKWyAgICAwLjAw
Mjk0Ml0gICA2IGJhc2UgMTAwMDAwMDAwIG1hc2sgRjAwMDAwMDAwIHdyaXRlLWJhY2sKWyAgICAw
LjAwMjk0Nl0gICA3IGJhc2UgMjAwMDAwMDAwIG1hc2sgRkMwMDAwMDAwIHdyaXRlLWJhY2sKWyAg
ICAwLjAwMzA0Nl0geDg2L1BBVDogQ29uZmlndXJhdGlvbiBbMC03XTogV0IgIFdDICBVQy0gVUMg
IFdCICBXUCAgVUMtIFdUICAKWyAgICAwLjAwMzI3N10gbGFzdF9wZm4gPSAweGJhMDAwIG1heF9h
cmNoX3BmbiA9IDB4NDAwMDAwMDAwClsgICAgMC4wMTAzMTBdIGVzcnQ6IFJlc2VydmluZyBFU1JU
IHNwYWNlIGZyb20gMHgwMDAwMDAwMGI3YmUyZDE4IHRvIDB4MDAwMDAwMDBiN2JlMmQ1MC4KWyAg
ICAwLjAxMDMzNl0gQlJLIFsweDFmYzYwMTAwMCwgMHgxZmM2MDFmZmZdIFBHVEFCTEUKWyAgICAw
LjAxMDM0M10gQlJLIFsweDFmYzYwMjAwMCwgMHgxZmM2MDJmZmZdIFBHVEFCTEUKWyAgICAwLjAx
MDM0N10gQlJLIFsweDFmYzYwMzAwMCwgMHgxZmM2MDNmZmZdIFBHVEFCTEUKWyAgICAwLjAxMDQz
N10gQlJLIFsweDFmYzYwNDAwMCwgMHgxZmM2MDRmZmZdIFBHVEFCTEUKWyAgICAwLjAxMDQ0Ml0g
QlJLIFsweDFmYzYwNTAwMCwgMHgxZmM2MDVmZmZdIFBHVEFCTEUKWyAgICAwLjAxMDU4Ml0gQlJL
IFsweDFmYzYwNjAwMCwgMHgxZmM2MDZmZmZdIFBHVEFCTEUKWyAgICAwLjAxMDYxMF0gQlJLIFsw
eDFmYzYwNzAwMCwgMHgxZmM2MDdmZmZdIFBHVEFCTEUKWyAgICAwLjAxMDY2OF0gQlJLIFsweDFm
YzYwODAwMCwgMHgxZmM2MDhmZmZdIFBHVEFCTEUKWyAgICAwLjAxMDc2OV0gQlJLIFsweDFmYzYw
OTAwMCwgMHgxZmM2MDlmZmZdIFBHVEFCTEUKWyAgICAwLjAxMDg0M10gQlJLIFsweDFmYzYwYTAw
MCwgMHgxZmM2MGFmZmZdIFBHVEFCTEUKWyAgICAwLjAxMDkwM10gQlJLIFsweDFmYzYwYjAwMCwg
MHgxZmM2MGJmZmZdIFBHVEFCTEUKWyAgICAwLjAxMTE0OV0gU2VjdXJlIGJvb3QgY291bGQgbm90
IGJlIGRldGVybWluZWQKWyAgICAwLjAxMTE1M10gUkFNRElTSzogW21lbSAweDM1NWFkMDAwLTB4
MzZhY2RmZmZdClsgICAgMC4wMTExNjJdIEFDUEk6IEVhcmx5IHRhYmxlIGNoZWNrc3VtIHZlcmlm
aWNhdGlvbiBkaXNhYmxlZApbICAgIDAuMDExMTcwXSBBQ1BJOiBSU0RQIDB4MDAwMDAwMDBCODU0
MjAxNCAwMDAwMjQgKHYwMiBTSUVNRU4pClsgICAgMC4wMTExNzhdIEFDUEk6IFhTRFQgMHgwMDAw
MDAwMEI4NTQyMTIwIDAwMDA5QyAodjAxIFNJRU1FTiBTSU1BVElDICAxMTExMjIyMiAgICAgIDAx
MDAwMDEzKQpbICAgIDAuMDExMTkwXSBBQ1BJOiBGQUNQIDB4MDAwMDAwMDBCODUzQjAwMCAwMDAx
MEMgKHYwNSBTSUVNRU4gU0lNQVRJQyAgMTExMTIyMjIgV0FTXyAwMDAxMDAwMSkKWyAgICAwLjAx
MTIwM10gQUNQSTogRFNEVCAweDAwMDAwMDAwQjg1MzAwMDAgMDA2QTVCICh2MDIgU0lFTUVOIFNJ
TUFUSUMgIDExMTEyMjIyIFdBU18gMDAwMTAwMDEpClsgICAgMC4wMTEyMTFdIEFDUEk6IEZBQ1Mg
MHgwMDAwMDAwMEI4NEFBMDAwIDAwMDA0MApbICAgIDAuMDExMjE4XSBBQ1BJOiBVRUZJIDB4MDAw
MDAwMDBCODU0MTAwMCAwMDAyMzYgKHYwMSBTSUVNRU4gU0lNQVRJQyAgMDAwMDAwMDEgV0FTXyAx
MjM0NTY3OCkKWyAgICAwLjAxMTIyN10gQUNQSTogVENQQSAweDAwMDAwMDAwQjg1NDAwMDAgMDAw
MDMyICh2MDIgU0lFTUVOIFNJTUFUSUMgIDAwMDAwMDAwIFdBU18gMDAwMDAwMDApClsgICAgMC4w
MTEyMzVdIEFDUEk6IFVFRkkgMHgwMDAwMDAwMEI4NTNFMDAwIDAwMDA0MiAodjAxIFNJRU1FTiBT
SU1BVElDICAwMDAwMDAwMCBXQVNfIDAwMDAwMDAwKQpbICAgIDAuMDExMjQzXSBBQ1BJOiBTU0RU
IDB4MDAwMDAwMDBCODUzRDAwMCAwMDA0RkQgKHYwMSBTSUVNRU4gVFBNQUNQSSAgMDAwMDEwMDAg
V0FTXyAyMDEyMTExNCkKWyAgICAwLjAxMTI1Ml0gQUNQSTogVFBNMiAweDAwMDAwMDAwQjg1M0Mw
MDAgMDAwMDM0ICh2MDMgU0lFTUVOIFNJTUFUSUMgIDAwMDAwMDAwIFdBU18gMDAwMDAwMDApClsg
ICAgMC4wMTEyNjBdIEFDUEk6IEhQRVQgMHgwMDAwMDAwMEI4NTNBMDAwIDAwMDAzOCAodjAxIFNJ
RU1FTiBTSU1BVElDICAxMTExMjIyMiBXQVNfIDAwMDEwMDAxKQpbICAgIDAuMDExMjY4XSBBQ1BJ
OiBMUElUIDB4MDAwMDAwMDBCODUzOTAwMCAwMDAxMDQgKHYwMSBTSUVNRU4gU0lNQVRJQyAgMTEx
MTIyMjIgV0FTXyAwMDAxMDAwMSkKWyAgICAwLjAxMTI3Nl0gQUNQSTogQVBJQyAweDAwMDAwMDAw
Qjg1MzgwMDAgMDAwMDg0ICh2MDMgU0lFTUVOIFNJTUFUSUMgIDExMTEyMjIyIFdBU18gMDAwMTAw
MDEpClsgICAgMC4wMTEyODRdIEFDUEk6IE1DRkcgMHgwMDAwMDAwMEI4NTM3MDAwIDAwMDAzQyAo
djAxIFNJRU1FTiBTSU1BVElDICAxMTExMjIyMiBXQVNfIDAwMDEwMDAxKQpbICAgIDAuMDExMjkz
XSBBQ1BJOiBTU0RUIDB4MDAwMDAwMDBCODUyRTAwMCAwMDA3NjMgKHYwMSBTSUVNRU4gQ3B1UG0g
ICAgMDAwMDMwMDAgV0FTXyAyMDEyMTExNCkKWyAgICAwLjAxMTMwMV0gQUNQSTogU1NEVCAweDAw
MDAwMDAwQjg1MkQwMDAgMDAwMjkwICh2MDEgU0lFTUVOIENwdTBUc3QgIDAwMDAzMDAwIFdBU18g
MjAxMjExMTQpClsgICAgMC4wMTEzMDldIEFDUEk6IFNTRFQgMHgwMDAwMDAwMEI4NTJDMDAwIDAw
MDE3QSAodjAxIFNJRU1FTiBBcFRzdCAgICAwMDAwMzAwMCBXQVNfIDIwMTIxMTE0KQpbICAgIDAu
MDExMzE4XSBBQ1BJOiBGUERUIDB4MDAwMDAwMDBCODUyQjAwMCAwMDAwNDQgKHYwMSBTSUVNRU4g
U0lNQVRJQyAgMDAwMDAwMDIgV0FTXyAwMTAwMDAxMykKWyAgICAwLjAxMTMyNl0gQUNQSTogQkdS
VCAweDAwMDAwMDAwQjg1MkYwMDAgMDAwMDM4ICh2MDEgU0lFTUVOIFNJTUFUSUMgIDAwMDAwMDAx
IFdBU18gMTIzNDU2NzgpClsgICAgMC4wMTEzNDJdIEFDUEk6IExvY2FsIEFQSUMgYWRkcmVzcyAw
eGZlZTAwMDAwClsgICAgMC4wMTE1NDNdIE5vIE5VTUEgY29uZmlndXJhdGlvbiBmb3VuZApbICAg
IDAuMDExNTQ3XSBGYWtpbmcgYSBub2RlIGF0IFttZW0gMHgwMDAwMDAwMDAwMDAwMDAwLTB4MDAw
MDAwMDIzZmZmZmZmZl0KWyAgICAwLjAxMTU1N10gTk9ERV9EQVRBKDApIGFsbG9jYXRlZCBbbWVt
IDB4MjNmZmY3MDAwLTB4MjNmZmZiZmZmXQpbICAgIDAuMDExNjMzXSBab25lIHJhbmdlczoKWyAg
ICAwLjAxMTYzN10gICBETUEgICAgICBbbWVtIDB4MDAwMDAwMDAwMDAwMTAwMC0weDAwMDAwMDAw
MDBmZmZmZmZdClsgICAgMC4wMTE2NDFdICAgRE1BMzIgICAgW21lbSAweDAwMDAwMDAwMDEwMDAw
MDAtMHgwMDAwMDAwMGZmZmZmZmZmXQpbICAgIDAuMDExNjQ0XSAgIE5vcm1hbCAgIFttZW0gMHgw
MDAwMDAwMTAwMDAwMDAwLTB4MDAwMDAwMDIzZmZmZmZmZl0KWyAgICAwLjAxMTY0OF0gICBEZXZp
Y2UgICBlbXB0eQpbICAgIDAuMDExNjUxXSBNb3ZhYmxlIHpvbmUgc3RhcnQgZm9yIGVhY2ggbm9k
ZQpbICAgIDAuMDExNjU0XSBFYXJseSBtZW1vcnkgbm9kZSByYW5nZXMKWyAgICAwLjAxMTY1N10g
ICBub2RlICAgMDogW21lbSAweDAwMDAwMDAwMDAwMDEwMDAtMHgwMDAwMDAwMDAwMDZlZmZmXQpb
ICAgIDAuMDExNjYwXSAgIG5vZGUgICAwOiBbbWVtIDB4MDAwMDAwMDAwMDA3MDAwMC0weDAwMDAw
MDAwMDAwOGZmZmZdClsgICAgMC4wMTE2NjRdICAgbm9kZSAgIDA6IFttZW0gMHgwMDAwMDAwMDAw
MTAwMDAwLTB4MDAwMDAwMDBiN2FmMmZmZl0KWyAgICAwLjAxMTY2N10gICBub2RlICAgMDogW21l
bSAweDAwMDAwMDAwYjg1NDMwMDAtMHgwMDAwMDAwMGI5M2MyZmZmXQpbICAgIDAuMDExNjcwXSAg
IG5vZGUgICAwOiBbbWVtIDB4MDAwMDAwMDBiOWNjMzAwMC0weDAwMDAwMDAwYjlmZmZmZmZdClsg
ICAgMC4wMTE2NzNdICAgbm9kZSAgIDA6IFttZW0gMHgwMDAwMDAwMTAwMDAwMDAwLTB4MDAwMDAw
MDIzZmZmZmZmZl0KWyAgICAwLjAxMjMxNV0gWmVyb2VkIHN0cnVjdCBwYWdlIGluIHVuYXZhaWxh
YmxlIHJhbmdlczogMjk2MzQgcGFnZXMKWyAgICAwLjAxMjMxOF0gSW5pdG1lbSBzZXR1cCBub2Rl
IDAgW21lbSAweDAwMDAwMDAwMDAwMDEwMDAtMHgwMDAwMDAwMjNmZmZmZmZmXQpbICAgIDAuMDEy
MzI0XSBPbiBub2RlIDAgdG90YWxwYWdlczogMjA2NzUxOApbICAgIDAuMDEyMzI4XSAgIERNQSB6
b25lOiA2NCBwYWdlcyB1c2VkIGZvciBtZW1tYXAKWyAgICAwLjAxMjMzMV0gICBETUEgem9uZTog
MTE0MyBwYWdlcyByZXNlcnZlZApbICAgIDAuMDEyMzM0XSAgIERNQSB6b25lOiAzOTgyIHBhZ2Vz
LCBMSUZPIGJhdGNoOjAKWyAgICAwLjAxMjQ3Nl0gICBETUEzMiB6b25lOiAxMTc2MyBwYWdlcyB1
c2VkIGZvciBtZW1tYXAKWyAgICAwLjAxMjQ3OV0gICBETUEzMiB6b25lOiA3NTI4MTYgcGFnZXMs
IExJRk8gYmF0Y2g6NjMKWyAgICAwLjA0MTI0OF0gICBOb3JtYWwgem9uZTogMjA0ODAgcGFnZXMg
dXNlZCBmb3IgbWVtbWFwClsgICAgMC4wNDEyNTJdICAgTm9ybWFsIHpvbmU6IDEzMTA3MjAgcGFn
ZXMsIExJRk8gYmF0Y2g6NjMKWyAgICAwLjA4Mzg3OV0geDg2L2hwZXQ6IFdpbGwgZGlzYWJsZSB0
aGUgSFBFVCBmb3IgdGhpcyBwbGF0Zm9ybSBiZWNhdXNlIGl0J3Mgbm90IHJlbGlhYmxlClsgICAg
MC4wODM4OTBdIFJlc2VydmluZyBJbnRlbCBncmFwaGljcyBtZW1vcnkgYXQgW21lbSAweGJiMDAw
MDAwLTB4YmVmZmZmZmZdClsgICAgMC4wODQwNTNdIEFDUEk6IFBNLVRpbWVyIElPIFBvcnQ6IDB4
NDA4ClsgICAgMC4wODQwNTldIEFDUEk6IExvY2FsIEFQSUMgYWRkcmVzcyAweGZlZTAwMDAwClsg
ICAgMC4wODQwNzRdIEFDUEk6IExBUElDX05NSSAoYWNwaV9pZFsweDAxXSBoaWdoIGxldmVsIGxp
bnRbMHgxXSkKWyAgICAwLjA4NDA3OF0gQUNQSTogTEFQSUNfTk1JIChhY3BpX2lkWzB4MDJdIGhp
Z2ggbGV2ZWwgbGludFsweDFdKQpbICAgIDAuMDg0MDgxXSBBQ1BJOiBMQVBJQ19OTUkgKGFjcGlf
aWRbMHgwM10gaGlnaCBsZXZlbCBsaW50WzB4MV0pClsgICAgMC4wODQwODRdIEFDUEk6IExBUElD
X05NSSAoYWNwaV9pZFsweDA0XSBoaWdoIGxldmVsIGxpbnRbMHgxXSkKWyAgICAwLjA4NDA5OV0g
SU9BUElDWzBdOiBhcGljX2lkIDIsIHZlcnNpb24gMzIsIGFkZHJlc3MgMHhmZWMwMDAwMCwgR1NJ
IDAtODYKWyAgICAwLjA4NDEwNV0gQUNQSTogSU5UX1NSQ19PVlIgKGJ1cyAwIGJ1c19pcnEgMCBn
bG9iYWxfaXJxIDIgZGZsIGRmbCkKWyAgICAwLjA4NDExMF0gQUNQSTogSU5UX1NSQ19PVlIgKGJ1
cyAwIGJ1c19pcnEgOSBnbG9iYWxfaXJxIDkgaGlnaCBsZXZlbCkKWyAgICAwLjA4NDExNF0gQUNQ
STogSVJRMCB1c2VkIGJ5IG92ZXJyaWRlLgpbICAgIDAuMDg0MTE4XSBBQ1BJOiBJUlE5IHVzZWQg
Ynkgb3ZlcnJpZGUuClsgICAgMC4wODQxMjNdIFVzaW5nIEFDUEkgKE1BRFQpIGZvciBTTVAgY29u
ZmlndXJhdGlvbiBpbmZvcm1hdGlvbgpbICAgIDAuMDg0MTI3XSBBQ1BJOiBIUEVUIGlkOiAweDgw
ODZhMjAxIGJhc2U6IDB4ZmVkMDAwMDAKWyAgICAwLjA4NDE0OV0gZTgyMDogdXBkYXRlIFttZW0g
MHhiNTk0ZjAwMC0weGI1OTZmZmZmXSB1c2FibGUgPT0+IHJlc2VydmVkClsgICAgMC4wODQxNjdd
IHNtcGJvb3Q6IEFsbG93aW5nIDQgQ1BVcywgMCBob3RwbHVnIENQVXMKWyAgICAwLjA4NDIxMF0g
UE06IFJlZ2lzdGVyZWQgbm9zYXZlIG1lbW9yeTogW21lbSAweDAwMDAwMDAwLTB4MDAwMDBmZmZd
ClsgICAgMC4wODQyMTZdIFBNOiBSZWdpc3RlcmVkIG5vc2F2ZSBtZW1vcnk6IFttZW0gMHgwMDA2
ZjAwMC0weDAwMDZmZmZmXQpbICAgIDAuMDg0MjIyXSBQTTogUmVnaXN0ZXJlZCBub3NhdmUgbWVt
b3J5OiBbbWVtIDB4MDAwOTAwMDAtMHgwMDA5ZmZmZl0KWyAgICAwLjA4NDIyNV0gUE06IFJlZ2lz
dGVyZWQgbm9zYXZlIG1lbW9yeTogW21lbSAweDAwMGEwMDAwLTB4MDAwZmZmZmZdClsgICAgMC4w
ODQyMzBdIFBNOiBSZWdpc3RlcmVkIG5vc2F2ZSBtZW1vcnk6IFttZW0gMHhiNTk0ZjAwMC0weGI1
OTZmZmZmXQpbICAgIDAuMDg0MjM1XSBQTTogUmVnaXN0ZXJlZCBub3NhdmUgbWVtb3J5OiBbbWVt
IDB4YjdhZjMwMDAtMHhiN2I4MmZmZl0KWyAgICAwLjA4NDIzOF0gUE06IFJlZ2lzdGVyZWQgbm9z
YXZlIG1lbW9yeTogW21lbSAweGI3YjgzMDAwLTB4Yjg0MDJmZmZdClsgICAgMC4wODQyNDFdIFBN
OiBSZWdpc3RlcmVkIG5vc2F2ZSBtZW1vcnk6IFttZW0gMHhiODQwMzAwMC0weGI4NTAyZmZmXQpb
ICAgIDAuMDg0MjQzXSBQTTogUmVnaXN0ZXJlZCBub3NhdmUgbWVtb3J5OiBbbWVtIDB4Yjg1MDMw
MDAtMHhiODU0MmZmZl0KWyAgICAwLjA4NDI0OV0gUE06IFJlZ2lzdGVyZWQgbm9zYXZlIG1lbW9y
eTogW21lbSAweGI5M2MzMDAwLTB4YjljYzJmZmZdClsgICAgMC4wODQyNTRdIFBNOiBSZWdpc3Rl
cmVkIG5vc2F2ZSBtZW1vcnk6IFttZW0gMHhiYTAwMDAwMC0weGJhZmZmZmZmXQpbICAgIDAuMDg0
MjU3XSBQTTogUmVnaXN0ZXJlZCBub3NhdmUgbWVtb3J5OiBbbWVtIDB4YmIwMDAwMDAtMHhiZWZm
ZmZmZl0KWyAgICAwLjA4NDI2MF0gUE06IFJlZ2lzdGVyZWQgbm9zYXZlIG1lbW9yeTogW21lbSAw
eGJmMDAwMDAwLTB4ZTAwZjdmZmZdClsgICAgMC4wODQyNjNdIFBNOiBSZWdpc3RlcmVkIG5vc2F2
ZSBtZW1vcnk6IFttZW0gMHhlMDBmODAwMC0weGUwMGY4ZmZmXQpbICAgIDAuMDg0MjY1XSBQTTog
UmVnaXN0ZXJlZCBub3NhdmUgbWVtb3J5OiBbbWVtIDB4ZTAwZjkwMDAtMHhmZWQwMGZmZl0KWyAg
ICAwLjA4NDI2OF0gUE06IFJlZ2lzdGVyZWQgbm9zYXZlIG1lbW9yeTogW21lbSAweGZlZDAxMDAw
LTB4ZmVkMDFmZmZdClsgICAgMC4wODQyNzFdIFBNOiBSZWdpc3RlcmVkIG5vc2F2ZSBtZW1vcnk6
IFttZW0gMHhmZWQwMjAwMC0weGZmYWZmZmZmXQpbICAgIDAuMDg0MjczXSBQTTogUmVnaXN0ZXJl
ZCBub3NhdmUgbWVtb3J5OiBbbWVtIDB4ZmZiMDAwMDAtMHhmZmZmZmZmZl0KWyAgICAwLjA4NDI3
OV0gW21lbSAweGJmMDAwMDAwLTB4ZTAwZjdmZmZdIGF2YWlsYWJsZSBmb3IgUENJIGRldmljZXMK
WyAgICAwLjA4NDI4Ml0gQm9vdGluZyBwYXJhdmlydHVhbGl6ZWQga2VybmVsIG9uIGJhcmUgaGFy
ZHdhcmUKWyAgICAwLjA4NDI5MF0gY2xvY2tzb3VyY2U6IHJlZmluZWQtamlmZmllczogbWFzazog
MHhmZmZmZmZmZiBtYXhfY3ljbGVzOiAweGZmZmZmZmZmLCBtYXhfaWRsZV9uczogNzY0NTUxOTYw
MDIxMTU2OCBucwpbICAgIDAuMjk5MjMyXSBzZXR1cF9wZXJjcHU6IE5SX0NQVVM6NTEyIG5yX2Nw
dW1hc2tfYml0czo1MTIgbnJfY3B1X2lkczo0IG5yX25vZGVfaWRzOjEKWyAgICAwLjMwMDA5MF0g
cGVyY3B1OiBFbWJlZGRlZCA1MyBwYWdlcy9jcHUgczE3ODI2NCByODE5MiBkMzA2MzIgdTUyNDI4
OApbICAgIDAuMzAwMTA5XSBwY3B1LWFsbG9jOiBzMTc4MjY0IHI4MTkyIGQzMDYzMiB1NTI0Mjg4
IGFsbG9jPTEqMjA5NzE1MgpbICAgIDAuMzAwMTEzXSBwY3B1LWFsbG9jOiBbMF0gMCAxIDIgMyAK
WyAgICAwLjMwMDE3M10gQnVpbHQgMSB6b25lbGlzdHMsIG1vYmlsaXR5IGdyb3VwaW5nIG9uLiAg
VG90YWwgcGFnZXM6IDIwMzQwNjgKWyAgICAwLjMwMDE3N10gUG9saWN5IHpvbmU6IE5vcm1hbApb
ICAgIDAuMzAwMTgyXSBLZXJuZWwgY29tbWFuZCBsaW5lOiBCT09UX0lNQUdFPS9ib290L3ZtbGlu
dXotNS40LjE1KyByb290PVVVSUQ9ZWNlNDRmNjItZDIyZi00MmRlLTkyYjktMGY4NDU4ODEzYzE5
IHJvIGRlYnVnClsgICAgMC4zMDI4OTNdIERlbnRyeSBjYWNoZSBoYXNoIHRhYmxlIGVudHJpZXM6
IDEwNDg1NzYgKG9yZGVyOiAxMSwgODM4ODYwOCBieXRlcywgbGluZWFyKQpbICAgIDAuMzA0MjMy
XSBJbm9kZS1jYWNoZSBoYXNoIHRhYmxlIGVudHJpZXM6IDUyNDI4OCAob3JkZXI6IDEwLCA0MTk0
MzA0IGJ5dGVzLCBsaW5lYXIpClsgICAgMC4zMDQzMDZdIG1lbSBhdXRvLWluaXQ6IHN0YWNrOm9m
ZiwgaGVhcCBhbGxvYzpvZmYsIGhlYXAgZnJlZTpvZmYKWyAgICAwLjMyNTgzOV0gQ2FsZ2FyeTog
ZGV0ZWN0aW5nIENhbGdhcnkgdmlhIEJJT1MgRUJEQSBhcmVhClsgICAgMC4zMjU4NDVdIENhbGdh
cnk6IFVuYWJsZSB0byBsb2NhdGUgUmlvIEdyYW5kZSB0YWJsZSBpbiBFQkRBIC0gYmFpbGluZyEK
WyAgICAwLjM4ODE1N10gTWVtb3J5OiA3OTY2ODg0Sy84MjcwMDcySyBhdmFpbGFibGUgKDEwMjQz
SyBrZXJuZWwgY29kZSwgMTE2N0sgcndkYXRhLCAzNTc2SyByb2RhdGEsIDE2NjBLIGluaXQsIDIx
NTJLIGJzcywgMzAzMTg4SyByZXNlcnZlZCwgMEsgY21hLXJlc2VydmVkKQpbICAgIDAuMzg4NDY1
XSBLZXJuZWwvVXNlciBwYWdlIHRhYmxlcyBpc29sYXRpb246IGVuYWJsZWQKWyAgICAwLjM4ODUw
NF0gZnRyYWNlOiBhbGxvY2F0aW5nIDMzMDc1IGVudHJpZXMgaW4gMTMwIHBhZ2VzClsgICAgMC40
MDk3NDhdIHJjdTogSGllcmFyY2hpY2FsIFJDVSBpbXBsZW1lbnRhdGlvbi4KWyAgICAwLjQwOTc1
NF0gcmN1OiAJUkNVIHJlc3RyaWN0aW5nIENQVXMgZnJvbSBOUl9DUFVTPTUxMiB0byBucl9jcHVf
aWRzPTQuClsgICAgMC40MDk3NThdIHJjdTogUkNVIGNhbGN1bGF0ZWQgdmFsdWUgb2Ygc2NoZWR1
bGVyLWVubGlzdG1lbnQgZGVsYXkgaXMgMjUgamlmZmllcy4KWyAgICAwLjQwOTc2MF0gcmN1OiBB
ZGp1c3RpbmcgZ2VvbWV0cnkgZm9yIHJjdV9mYW5vdXRfbGVhZj0xNiwgbnJfY3B1X2lkcz00Clsg
ICAgMC40MTgxNDNdIE5SX0lSUVM6IDMzMDI0LCBucl9pcnFzOiAxMDI0LCBwcmVhbGxvY2F0ZWQg
aXJxczogMTYKWyAgICAwLjQxODY0MV0gcmFuZG9tOiBnZXRfcmFuZG9tX2J5dGVzIGNhbGxlZCBm
cm9tIHN0YXJ0X2tlcm5lbCsweDM0MC8weDUyNCB3aXRoIGNybmdfaW5pdD0wClsgICAgMC40MTkw
NzJdIENvbnNvbGU6IGNvbG91ciBkdW1teSBkZXZpY2UgODB4MjUKWyAgICAwLjQxOTY3Nl0gcHJp
bnRrOiBjb25zb2xlIFt0dHkwXSBlbmFibGVkClsgICAgMC40MTk3MzFdIEFDUEk6IENvcmUgcmV2
aXNpb24gMjAxOTA4MTYKWyAgICAwLjQxOTk1N10gQVBJQzogU3dpdGNoIHRvIHN5bW1ldHJpYyBJ
L08gbW9kZSBzZXR1cApbICAgIDAuNDIwODQxXSBjbG9ja3NvdXJjZTogdHNjLWVhcmx5OiBtYXNr
OiAweGZmZmZmZmZmZmZmZmZmZmYgbWF4X2N5Y2xlczogMHgzNGRhNDZkMTc2OCwgbWF4X2lkbGVf
bnM6IDg4MTU5MDYxMDk4NSBucwpbICAgIDAuNDIwODU4XSBDYWxpYnJhdGluZyBkZWxheSBsb29w
IChza2lwcGVkKSwgdmFsdWUgY2FsY3VsYXRlZCB1c2luZyB0aW1lciBmcmVxdWVuY3kuLiAzNjY2
LjY1IEJvZ29NSVBTIChscGo9NzMzMzMwNCkKWyAgICAwLjQyMDg2OV0gcGlkX21heDogZGVmYXVs
dDogMzI3NjggbWluaW11bTogMzAxClsgICAgMC40MjQ4NTFdIExTTTogU2VjdXJpdHkgRnJhbWV3
b3JrIGluaXRpYWxpemluZwpbICAgIDAuNDI0ODUxXSBZYW1hOiBiZWNvbWluZyBtaW5kZnVsLgpb
ICAgIDAuNDI0ODUxXSBNb3VudC1jYWNoZSBoYXNoIHRhYmxlIGVudHJpZXM6IDE2Mzg0IChvcmRl
cjogNSwgMTMxMDcyIGJ5dGVzLCBsaW5lYXIpClsgICAgMC40MjQ4NTFdIE1vdW50cG9pbnQtY2Fj
aGUgaGFzaCB0YWJsZSBlbnRyaWVzOiAxNjM4NCAob3JkZXI6IDUsIDEzMTA3MiBieXRlcywgbGlu
ZWFyKQpbICAgIDAuNDI0ODUxXSBwcm9jZXNzOiB1c2luZyBtd2FpdCBpbiBpZGxlIHRocmVhZHMK
WyAgICAwLjQyNDg1MV0gTGFzdCBsZXZlbCBpVExCIGVudHJpZXM6IDRLQiA0OCwgMk1CIDAsIDRN
QiAwClsgICAgMC40MjQ4NTFdIExhc3QgbGV2ZWwgZFRMQiBlbnRyaWVzOiA0S0IgMTI4LCAyTUIg
MTYsIDRNQiAxNiwgMUdCIDAKWyAgICAwLjQyNDg1MV0gU3BlY3RyZSBWMSA6IE1pdGlnYXRpb246
IHVzZXJjb3B5L3N3YXBncyBiYXJyaWVycyBhbmQgX191c2VyIHBvaW50ZXIgc2FuaXRpemF0aW9u
ClsgICAgMC40MjQ4NTFdIFNwZWN0cmUgVjIgOiBNaXRpZ2F0aW9uOiBGdWxsIGdlbmVyaWMgcmV0
cG9saW5lClsgICAgMC40MjQ4NTFdIFNwZWN0cmUgVjIgOiBTcGVjdHJlIHYyIC8gU3BlY3RyZVJT
QiBtaXRpZ2F0aW9uOiBGaWxsaW5nIFJTQiBvbiBjb250ZXh0IHN3aXRjaApbICAgIDAuNDI0ODUx
XSBTcGVjdHJlIFYyIDogRW5hYmxpbmcgUmVzdHJpY3RlZCBTcGVjdWxhdGlvbiBmb3IgZmlybXdh
cmUgY2FsbHMKWyAgICAwLjQyNDg1MV0gU3BlY3RyZSBWMiA6IG1pdGlnYXRpb246IEVuYWJsaW5n
IGNvbmRpdGlvbmFsIEluZGlyZWN0IEJyYW5jaCBQcmVkaWN0aW9uIEJhcnJpZXIKWyAgICAwLjQy
NDg1MV0gTURTOiBWdWxuZXJhYmxlOiBDbGVhciBDUFUgYnVmZmVycyBhdHRlbXB0ZWQsIG5vIG1p
Y3JvY29kZQpbICAgIDAuNDI0ODUxXSBGcmVlaW5nIFNNUCBhbHRlcm5hdGl2ZXMgbWVtb3J5OiAz
MksKWyAgICAwLjQyNDg1MV0gVFNDIGRlYWRsaW5lIHRpbWVyIGVuYWJsZWQKWyAgICAwLjQyNDg1
MV0gc21wYm9vdDogQ1BVMDogSW50ZWwoUikgQ2VsZXJvbihSKSBDUFUgIE4yOTMwICBAIDEuODNH
SHogKGZhbWlseTogMHg2LCBtb2RlbDogMHgzNywgc3RlcHBpbmc6IDB4OCkKWyAgICAwLjQyNDg1
MV0gUGVyZm9ybWFuY2UgRXZlbnRzOiBQRUJTIGZtdDIrLCA4LWRlZXAgTEJSLCBTaWx2ZXJtb250
IGV2ZW50cywgOC1kZWVwIExCUiwgZnVsbC13aWR0aCBjb3VudGVycywgSW50ZWwgUE1VIGRyaXZl
ci4KWyAgICAwLjQyNDg1MV0gLi4uIHZlcnNpb246ICAgICAgICAgICAgICAgIDMKWyAgICAwLjQy
NDg1MV0gLi4uIGJpdCB3aWR0aDogICAgICAgICAgICAgIDQwClsgICAgMC40MjQ4NTFdIC4uLiBn
ZW5lcmljIHJlZ2lzdGVyczogICAgICAyClsgICAgMC40MjQ4NTFdIC4uLiB2YWx1ZSBtYXNrOiAg
ICAgICAgICAgICAwMDAwMDBmZmZmZmZmZmZmClsgICAgMC40MjQ4NTFdIC4uLiBtYXggcGVyaW9k
OiAgICAgICAgICAgICAwMDAwMDA3ZmZmZmZmZmZmClsgICAgMC40MjQ4NTFdIC4uLiBmaXhlZC1w
dXJwb3NlIGV2ZW50czogICAzClsgICAgMC40MjQ4NTFdIC4uLiBldmVudCBtYXNrOiAgICAgICAg
ICAgICAwMDAwMDAwNzAwMDAwMDAzClsgICAgMC40MjQ4NTFdIHJjdTogSGllcmFyY2hpY2FsIFNS
Q1UgaW1wbGVtZW50YXRpb24uClsgICAgMC40MjQ4NTFdIE5NSSB3YXRjaGRvZzogRW5hYmxlZC4g
UGVybWFuZW50bHkgY29uc3VtZXMgb25lIGh3LVBNVSBjb3VudGVyLgpbICAgIDAuNDI0ODUxXSBz
bXA6IEJyaW5naW5nIHVwIHNlY29uZGFyeSBDUFVzIC4uLgpbICAgIDAuNDI0ODUxXSB4ODY6IEJv
b3RpbmcgU01QIGNvbmZpZ3VyYXRpb246ClsgICAgMC40MjQ4NTFdIC4uLi4gbm9kZSAgIzAsIENQ
VXM6ICAgICAgIzEgIzIgIzMKWyAgICAwLjQyNDg1MV0gc21wOiBCcm91Z2h0IHVwIDEgbm9kZSwg
NCBDUFVzClsgICAgMC40MjQ4NTFdIHNtcGJvb3Q6IE1heCBsb2dpY2FsIHBhY2thZ2VzOiAxClsg
ICAgMC40MjQ4NTFdIHNtcGJvb3Q6IFRvdGFsIG9mIDQgcHJvY2Vzc29ycyBhY3RpdmF0ZWQgKDE0
NjY2LjYwIEJvZ29NSVBTKQpbICAgIDAuNDI1OTk2XSBkZXZ0bXBmczogaW5pdGlhbGl6ZWQKWyAg
ICAwLjQyNTk5Nl0geDg2L21tOiBNZW1vcnkgYmxvY2sgc2l6ZTogMTI4TUIKWyAgICAwLjQyODkw
OF0gUE06IFJlZ2lzdGVyaW5nIEFDUEkgTlZTIHJlZ2lvbiBbbWVtIDB4MDAwNmYwMDAtMHgwMDA2
ZmZmZl0gKDQwOTYgYnl0ZXMpClsgICAgMC40Mjg5MTldIFBNOiBSZWdpc3RlcmluZyBBQ1BJIE5W
UyByZWdpb24gW21lbSAweGI4NDAzMDAwLTB4Yjg1MDJmZmZdICgxMDQ4NTc2IGJ5dGVzKQpbICAg
IDAuNDI5MTI4XSBjbG9ja3NvdXJjZTogamlmZmllczogbWFzazogMHhmZmZmZmZmZiBtYXhfY3lj
bGVzOiAweGZmZmZmZmZmLCBtYXhfaWRsZV9uczogNzY0NTA0MTc4NTEwMDAwMCBucwpbICAgIDAu
NDI5MTQ0XSBmdXRleCBoYXNoIHRhYmxlIGVudHJpZXM6IDEwMjQgKG9yZGVyOiA0LCA2NTUzNiBi
eXRlcywgbGluZWFyKQpbICAgIDAuNDI5MzMwXSBwaW5jdHJsIGNvcmU6IGluaXRpYWxpemVkIHBp
bmN0cmwgc3Vic3lzdGVtClsgICAgMC40Mjk2NTFdIE5FVDogUmVnaXN0ZXJlZCBwcm90b2NvbCBm
YW1pbHkgMTYKWyAgICAwLjQyOTg2Ml0gYXVkaXQ6IGluaXRpYWxpemluZyBuZXRsaW5rIHN1YnN5
cyAoZGlzYWJsZWQpClsgICAgMC40Mjk4ODVdIGF1ZGl0OiB0eXBlPTIwMDAgYXVkaXQoMTU4MDI4
MjU5OS4wMDg6MSk6IHN0YXRlPWluaXRpYWxpemVkIGF1ZGl0X2VuYWJsZWQ9MCByZXM9MQpbICAg
IDAuNDI5ODg1XSBjcHVpZGxlOiB1c2luZyBnb3Zlcm5vciBsYWRkZXIKWyAgICAwLjQyOTg4NV0g
Y3B1aWRsZTogdXNpbmcgZ292ZXJub3IgbWVudQpbICAgIDAuNDI5ODg1XSBBQ1BJOiBidXMgdHlw
ZSBQQ0kgcmVnaXN0ZXJlZApbICAgIDAuNDI5ODg1XSBhY3BpcGhwOiBBQ1BJIEhvdCBQbHVnIFBD
SSBDb250cm9sbGVyIERyaXZlciB2ZXJzaW9uOiAwLjUKWyAgICAwLjQyOTg4NV0gUENJOiBNTUNP
TkZJRyBmb3IgZG9tYWluIDAwMDAgW2J1cyAwMC0zZl0gYXQgW21lbSAweGUwMDAwMDAwLTB4ZTNm
ZmZmZmZdIChiYXNlIDB4ZTAwMDAwMDApClsgICAgMC40Mjk4ODVdIFBDSTogbm90IHVzaW5nIE1N
Q09ORklHClsgICAgMC40Mjk4ODVdIFBDSTogVXNpbmcgY29uZmlndXJhdGlvbiB0eXBlIDEgZm9y
IGJhc2UgYWNjZXNzClsgICAgMC40MzAyNzFdIEVORVJHWV9QRVJGX0JJQVM6IFNldCB0byAnbm9y
bWFsJywgd2FzICdwZXJmb3JtYW5jZScKWyAgICAwLjQzMzk4Nl0gSHVnZVRMQiByZWdpc3RlcmVk
IDIuMDAgTWlCIHBhZ2Ugc2l6ZSwgcHJlLWFsbG9jYXRlZCAwIHBhZ2VzClsgICAgMS4yMTMwODdd
IEFDUEk6IEFkZGVkIF9PU0koTW9kdWxlIERldmljZSkKWyAgICAxLjIxMzA5OF0gQUNQSTogQWRk
ZWQgX09TSShQcm9jZXNzb3IgRGV2aWNlKQpbICAgIDEuMjEzMTA0XSBBQ1BJOiBBZGRlZCBfT1NJ
KDMuMCBfU0NQIEV4dGVuc2lvbnMpClsgICAgMS4yMTMxMDldIEFDUEk6IEFkZGVkIF9PU0koUHJv
Y2Vzc29yIEFnZ3JlZ2F0b3IgRGV2aWNlKQpbICAgIDEuMjEzMTE1XSBBQ1BJOiBBZGRlZCBfT1NJ
KExpbnV4LURlbGwtVmlkZW8pClsgICAgMS4yMTMxMjFdIEFDUEk6IEFkZGVkIF9PU0koTGludXgt
TGVub3ZvLU5WLUhETUktQXVkaW8pClsgICAgMS4yMTMxMjddIEFDUEk6IEFkZGVkIF9PU0koTGlu
dXgtSFBJLUh5YnJpZC1HcmFwaGljcykKWyAgICAxLjIyNTQ1NV0gQUNQSTogNSBBQ1BJIEFNTCB0
YWJsZXMgc3VjY2Vzc2Z1bGx5IGFjcXVpcmVkIGFuZCBsb2FkZWQKWyAgICAxLjIzMDE2OV0gQUNQ
STogRHluYW1pYyBPRU0gVGFibGUgTG9hZDoKWyAgICAxLjIzMDE4OF0gQUNQSTogU1NEVCAweEZG
RkY4QTY4MzYyNDUwMDAgMDAwM0JDICh2MDEgUG1SZWYgIENwdTBJc3QgIDAwMDAzMDAwIElOVEwg
MjAxMjExMTQpClsgICAgMS4yMzIwMDRdIEFDUEk6IER5bmFtaWMgT0VNIFRhYmxlIExvYWQ6Clsg
ICAgMS4yMzIwMTldIEFDUEk6IFNTRFQgMHhGRkZGOEE2ODM2MTJCODAwIDAwMDE1RiAodjAxIFBt
UmVmICBBcElzdCAgICAwMDAwMzAwMCBJTlRMIDIwMTIxMTE0KQpbICAgIDEuMjM1MDAyXSBBQ1BJ
OiBJbnRlcnByZXRlciBlbmFibGVkClsgICAgMS4yMzUwNTVdIEFDUEk6IChzdXBwb3J0cyBTMCBT
NCBTNSkKWyAgICAxLjIzNTA2Ml0gQUNQSTogVXNpbmcgSU9BUElDIGZvciBpbnRlcnJ1cHQgcm91
dGluZwpbICAgIDEuMjM1MTQ3XSBQQ0k6IE1NQ09ORklHIGZvciBkb21haW4gMDAwMCBbYnVzIDAw
LTNmXSBhdCBbbWVtIDB4ZTAwMDAwMDAtMHhlM2ZmZmZmZl0gKGJhc2UgMHhlMDAwMDAwMCkKWyAg
ICAxLjIzNTc2OV0gUENJOiBNTUNPTkZJRyBhdCBbbWVtIDB4ZTAwMDAwMDAtMHhlM2ZmZmZmZl0g
cmVzZXJ2ZWQgaW4gQUNQSSBtb3RoZXJib2FyZCByZXNvdXJjZXMKWyAgICAxLjIzNTgwMF0gUENJ
OiBVc2luZyBob3N0IGJyaWRnZSB3aW5kb3dzIGZyb20gQUNQSTsgaWYgbmVjZXNzYXJ5LCB1c2Ug
InBjaT1ub2NycyIgYW5kIHJlcG9ydCBhIGJ1ZwpbICAgIDEuMjM2MjUxXSBBQ1BJOiBFbmFibGVk
IDQgR1BFcyBpbiBibG9jayAwMCB0byAzRgpbICAgIDEuNDQ3NzMyXSBBQ1BJOiBQb3dlciBSZXNv
dXJjZSBbVVNCQ10gKG9uKQpbICAgIDEuNDU3NTYxXSBBQ1BJOiBQQ0kgUm9vdCBCcmlkZ2UgW1BD
STBdIChkb21haW4gMDAwMCBbYnVzIDAwLWZmXSkKWyAgICAxLjQ1NzU4MV0gYWNwaSBQTlAwQTA4
OjAwOiBfT1NDOiBPUyBzdXBwb3J0cyBbRXh0ZW5kZWRDb25maWcgQVNQTSBDbG9ja1BNIFNlZ21l
bnRzIE1TSSBIUFgtVHlwZTNdClsgICAgMS40NTc5MjFdIGFjcGkgUE5QMEEwODowMDogX09TQyBm
YWlsZWQgKEFFX0VSUk9SKTsgZGlzYWJsaW5nIEFTUE0KWyAgICAxLjQ1Nzk1NF0gYWNwaSBQTlAw
QTA4OjAwOiBbRmlybXdhcmUgSW5mb106IE1NQ09ORklHIGZvciBkb21haW4gMDAwMCBbYnVzIDAw
LTNmXSBvbmx5IHBhcnRpYWxseSBjb3ZlcnMgdGhpcyBicmlkZ2UKWyAgICAxLjQ1ODcyNV0gUENJ
IGhvc3QgYnJpZGdlIHRvIGJ1cyAwMDAwOjAwClsgICAgMS40NTg3MzZdIHBjaV9idXMgMDAwMDow
MDogcm9vdCBidXMgcmVzb3VyY2UgW2lvICAweDAwMDAtMHgwMDZmIHdpbmRvd10KWyAgICAxLjQ1
ODc0NF0gcGNpX2J1cyAwMDAwOjAwOiByb290IGJ1cyByZXNvdXJjZSBbaW8gIDB4MDA3OC0weDBj
Zjcgd2luZG93XQpbICAgIDEuNDU4NzUxXSBwY2lfYnVzIDAwMDA6MDA6IHJvb3QgYnVzIHJlc291
cmNlIFtpbyAgMHgwZDAwLTB4ZmZmZiB3aW5kb3ddClsgICAgMS40NTg3NTldIHBjaV9idXMgMDAw
MDowMDogcm9vdCBidXMgcmVzb3VyY2UgW21lbSAweDAwMGEwMDAwLTB4MDAwYmZmZmYgd2luZG93
XQpbICAgIDEuNDU4NzY3XSBwY2lfYnVzIDAwMDA6MDA6IHJvb3QgYnVzIHJlc291cmNlIFttZW0g
MHgwMDBjMDAwMC0weDAwMGRmZmZmIHdpbmRvd10KWyAgICAxLjQ1ODc3NV0gcGNpX2J1cyAwMDAw
OjAwOiByb290IGJ1cyByZXNvdXJjZSBbbWVtIDB4MDAwZTAwMDAtMHgwMDBmZmZmZiB3aW5kb3dd
ClsgICAgMS40NTg3ODNdIHBjaV9idXMgMDAwMDowMDogcm9vdCBidXMgcmVzb3VyY2UgW21lbSAw
eGMwMDAwMDAwLTB4ZDA5ZmZmZmUgd2luZG93XQpbICAgIDEuNDU4NzkxXSBwY2lfYnVzIDAwMDA6
MDA6IHJvb3QgYnVzIHJlc291cmNlIFtidXMgMDAtZmZdClsgICAgMS40NTg4MTldIHBjaSAwMDAw
OjAwOjAwLjA6IFs4MDg2OjBmMDBdIHR5cGUgMDAgY2xhc3MgMHgwNjAwMDAKWyAgICAxLjQ1OTA3
Nl0gcGNpIDAwMDA6MDA6MDIuMDogWzgwODY6MGYzMV0gdHlwZSAwMCBjbGFzcyAweDAzMDAwMApb
ICAgIDEuNDU5MDk3XSBwY2kgMDAwMDowMDowMi4wOiByZWcgMHgxMDogW21lbSAweGQwMDAwMDAw
LTB4ZDAzZmZmZmZdClsgICAgMS40NTkxMTNdIHBjaSAwMDAwOjAwOjAyLjA6IHJlZyAweDE4OiBb
bWVtIDB4YzAwMDAwMDAtMHhjZmZmZmZmZiBwcmVmXQpbICAgIDEuNDU5MTI4XSBwY2kgMDAwMDow
MDowMi4wOiByZWcgMHgyMDogW2lvICAweDcwNTAtMHg3MDU3XQpbICAgIDEuNDU5MTU0XSBwY2kg
MDAwMDowMDowMi4wOiBCQVIgMjogYXNzaWduZWQgdG8gZWZpZmIKWyAgICAxLjQ1OTM4OV0gcGNp
IDAwMDA6MDA6MTMuMDogWzgwODY6MGYyM10gdHlwZSAwMCBjbGFzcyAweDAxMDYwMQpbICAgIDEu
NDU5NDE3XSBwY2kgMDAwMDowMDoxMy4wOiByZWcgMHgxMDogW2lvICAweDcwNDgtMHg3MDRmXQpb
ICAgIDEuNDU5NDMyXSBwY2kgMDAwMDowMDoxMy4wOiByZWcgMHgxNDogW2lvICAweDcwNWMtMHg3
MDVmXQpbICAgIDEuNDU5NDQ1XSBwY2kgMDAwMDowMDoxMy4wOiByZWcgMHgxODogW2lvICAweDcw
NDAtMHg3MDQ3XQpbICAgIDEuNDU5NDU4XSBwY2kgMDAwMDowMDoxMy4wOiByZWcgMHgxYzogW2lv
ICAweDcwNTgtMHg3MDViXQpbICAgIDEuNDU5NDcxXSBwY2kgMDAwMDowMDoxMy4wOiByZWcgMHgy
MDogW2lvICAweDcwMjAtMHg3MDNmXQpbICAgIDEuNDU5NDg1XSBwY2kgMDAwMDowMDoxMy4wOiBy
ZWcgMHgyNDogW21lbSAweGQwOTA0MDAwLTB4ZDA5MDQ3ZmZdClsgICAgMS40NTk1NDBdIHBjaSAw
MDAwOjAwOjEzLjA6IFBNRSMgc3VwcG9ydGVkIGZyb20gRDNob3QKWyAgICAxLjQ1OTc2NV0gcGNp
IDAwMDA6MDA6MWEuMDogWzgwODY6MGYxOF0gdHlwZSAwMCBjbGFzcyAweDEwODAwMApbICAgIDEu
NDU5ODAxXSBwY2kgMDAwMDowMDoxYS4wOiByZWcgMHgxMDogW21lbSAweGQwODAwMDAwLTB4ZDA4
ZmZmZmZdClsgICAgMS40NTk4MjBdIHBjaSAwMDAwOjAwOjFhLjA6IHJlZyAweDE0OiBbbWVtIDB4
ZDA3MDAwMDAtMHhkMDdmZmZmZl0KWyAgICAxLjQ1OTkzMV0gcGNpIDAwMDA6MDA6MWEuMDogUE1F
IyBzdXBwb3J0ZWQgZnJvbSBEMCBEM2hvdApbICAgIDEuNDYwMTUyXSBwY2kgMDAwMDowMDoxYi4w
OiBbODA4NjowZjA0XSB0eXBlIDAwIGNsYXNzIDB4MDQwMzAwClsgICAgMS40NjAxODRdIHBjaSAw
MDAwOjAwOjFiLjA6IHJlZyAweDEwOiBbbWVtIDB4ZDA5MDAwMDAtMHhkMDkwM2ZmZiA2NGJpdF0K
WyAgICAxLjQ2MDI2NV0gcGNpIDAwMDA6MDA6MWIuMDogUE1FIyBzdXBwb3J0ZWQgZnJvbSBEMCBE
M2hvdCBEM2NvbGQKWyAgICAxLjQ2MDQ3OF0gcGNpIDAwMDA6MDA6MWMuMDogWzgwODY6MGY0OF0g
dHlwZSAwMSBjbGFzcyAweDA2MDQwMApbICAgIDEuNDYwNTY1XSBwY2kgMDAwMDowMDoxYy4wOiBQ
TUUjIHN1cHBvcnRlZCBmcm9tIEQwIEQzaG90IEQzY29sZApbICAgIDEuNDYwNzg2XSBwY2kgMDAw
MDowMDoxYy4xOiBbODA4NjowZjRhXSB0eXBlIDAxIGNsYXNzIDB4MDYwNDAwClsgICAgMS40NjA4
NzVdIHBjaSAwMDAwOjAwOjFjLjE6IFBNRSMgc3VwcG9ydGVkIGZyb20gRDAgRDNob3QgRDNjb2xk
ClsgICAgMS40NjEwOThdIHBjaSAwMDAwOjAwOjFjLjI6IFs4MDg2OjBmNGNdIHR5cGUgMDEgY2xh
c3MgMHgwNjA0MDAKWyAgICAxLjQ2MTE4M10gcGNpIDAwMDA6MDA6MWMuMjogUE1FIyBzdXBwb3J0
ZWQgZnJvbSBEMCBEM2hvdCBEM2NvbGQKWyAgICAxLjQ2MTQxOV0gcGNpIDAwMDA6MDA6MWMuMzog
WzgwODY6MGY0ZV0gdHlwZSAwMSBjbGFzcyAweDA2MDQwMApbICAgIDEuNDYxNTA1XSBwY2kgMDAw
MDowMDoxYy4zOiBQTUUjIHN1cHBvcnRlZCBmcm9tIEQwIEQzaG90IEQzY29sZApbICAgIDEuNDYx
NzM5XSBwY2kgMDAwMDowMDoxZC4wOiBbODA4NjowZjM0XSB0eXBlIDAwIGNsYXNzIDB4MGMwMzIw
ClsgICAgMS40NjE3NzZdIHBjaSAwMDAwOjAwOjFkLjA6IHJlZyAweDEwOiBbbWVtIDB4ZDA5MDUw
MDAtMHhkMDkwNTNmZl0KWyAgICAxLjQ2MTg5OF0gcGNpIDAwMDA6MDA6MWQuMDogUE1FIyBzdXBw
b3J0ZWQgZnJvbSBEMCBEM2hvdCBEM2NvbGQKWyAgICAxLjQ2MjExOF0gcGNpIDAwMDA6MDA6MWYu
MDogWzgwODY6MGYxY10gdHlwZSAwMCBjbGFzcyAweDA2MDEwMApbICAgIDEuNDYyNDAwXSBwY2kg
MDAwMDowMDoxZi4zOiBbODA4NjowZjEyXSB0eXBlIDAwIGNsYXNzIDB4MGMwNTAwClsgICAgMS40
NjI0NDldIHBjaSAwMDAwOjAwOjFmLjM6IHJlZyAweDEwOiBbbWVtIDB4ZDA5MDYwMDAtMHhkMDkw
NjAxZl0KWyAgICAxLjQ2MjUyNV0gcGNpIDAwMDA6MDA6MWYuMzogcmVnIDB4MjA6IFtpbyAgMHg3
MDAwLTB4NzAxZl0KWyAgICAxLjQ2MjkzOV0gcGNpIDAwMDA6MDE6MDAuMDogWzExMGE6NDA3OF0g
dHlwZSAwMCBjbGFzcyAweDA1MDAwMApbICAgIDEuNDYyOTgyXSBwY2kgMDAwMDowMTowMC4wOiBy
ZWcgMHgxMDogW21lbSAweGQwNjAwMDAwLTB4ZDA2N2ZmZmZdClsgICAgMS40NjMwMDRdIHBjaSAw
MDAwOjAxOjAwLjA6IHJlZyAweDE0OiBbbWVtIDB4ZDA2ODAwMDAtMHhkMDY4N2ZmZl0KWyAgICAx
LjQ2MzM1NV0gcGNpIDAwMDA6MDA6MWMuMDogUENJIGJyaWRnZSB0byBbYnVzIDAxXQpbICAgIDEu
NDYzMzY3XSBwY2kgMDAwMDowMDoxYy4wOiAgIGJyaWRnZSB3aW5kb3cgW21lbSAweGQwNjAwMDAw
LTB4ZDA2ZmZmZmZdClsgICAgMS40NjM0OTJdIHBjaSAwMDAwOjAyOjAwLjA6IFs4MDg2OjE1MzNd
IHR5cGUgMDAgY2xhc3MgMHgwMjAwMDAKWyAgICAxLjQ2MzUzNF0gcGNpIDAwMDA6MDI6MDAuMDog
cmVnIDB4MTA6IFttZW0gMHhkMDUwMDAwMC0weGQwNTdmZmZmXQpbICAgIDEuNDYzNTY3XSBwY2kg
MDAwMDowMjowMC4wOiByZWcgMHgxODogW2lvICAweDYwMDAtMHg2MDFmXQpbICAgIDEuNDYzNTg2
XSBwY2kgMDAwMDowMjowMC4wOiByZWcgMHgxYzogW21lbSAweGQwNTgwMDAwLTB4ZDA1ODNmZmZd
ClsgICAgMS40NjM3MzNdIHBjaSAwMDAwOjAyOjAwLjA6IFBNRSMgc3VwcG9ydGVkIGZyb20gRDAg
RDNob3QgRDNjb2xkClsgICAgMS40NjM5NDBdIHBjaSAwMDAwOjAwOjFjLjE6IFBDSSBicmlkZ2Ug
dG8gW2J1cyAwMl0KWyAgICAxLjQ2Mzk1MF0gcGNpIDAwMDA6MDA6MWMuMTogICBicmlkZ2Ugd2lu
ZG93IFtpbyAgMHg2MDAwLTB4NmZmZl0KWyAgICAxLjQ2Mzk1OF0gcGNpIDAwMDA6MDA6MWMuMTog
ICBicmlkZ2Ugd2luZG93IFttZW0gMHhkMDUwMDAwMC0weGQwNWZmZmZmXQpbICAgIDEuNDY0MDgw
XSBwY2kgMDAwMDowMzowMC4wOiBbODA4NjoxNTMzXSB0eXBlIDAwIGNsYXNzIDB4MDIwMDAwClsg
ICAgMS40NjQxMjNdIHBjaSAwMDAwOjAzOjAwLjA6IHJlZyAweDEwOiBbbWVtIDB4ZDA0MDAwMDAt
MHhkMDQ3ZmZmZl0KWyAgICAxLjQ2NDE1NV0gcGNpIDAwMDA6MDM6MDAuMDogcmVnIDB4MTg6IFtp
byAgMHg1MDAwLTB4NTAxZl0KWyAgICAxLjQ2NDE3NV0gcGNpIDAwMDA6MDM6MDAuMDogcmVnIDB4
MWM6IFttZW0gMHhkMDQ4MDAwMC0weGQwNDgzZmZmXQpbICAgIDEuNDY0MzIxXSBwY2kgMDAwMDow
MzowMC4wOiBQTUUjIHN1cHBvcnRlZCBmcm9tIEQwIEQzaG90IEQzY29sZApbICAgIDEuNDY0NTMy
XSBwY2kgMDAwMDowMDoxYy4yOiBQQ0kgYnJpZGdlIHRvIFtidXMgMDNdClsgICAgMS40NjQ1NDJd
IHBjaSAwMDAwOjAwOjFjLjI6ICAgYnJpZGdlIHdpbmRvdyBbaW8gIDB4NTAwMC0weDVmZmZdClsg
ICAgMS40NjQ1NTBdIHBjaSAwMDAwOjAwOjFjLjI6ICAgYnJpZGdlIHdpbmRvdyBbbWVtIDB4ZDA0
MDAwMDAtMHhkMDRmZmZmZl0KWyAgICAxLjQ2NDY1MV0gcGNpIDAwMDA6MDA6MWMuMzogUENJIGJy
aWRnZSB0byBbYnVzIDA0XQpbICAgIDEuNjczNTk1XSBBQ1BJOiBQQ0kgSW50ZXJydXB0IExpbmsg
W0xOS0FdIChJUlFzIDMgNCA1IDYgMTAgMTEgMTIgMTQgMTUpICo3ClsgICAgMS42NzM3NzVdIEFD
UEk6IFBDSSBJbnRlcnJ1cHQgTGluayBbTE5LQl0gKElSUXMgMyA0IDUgNiAxMCAxMSAxMiAxNCAx
NSkgKjcKWyAgICAxLjY3Mzk1M10gQUNQSTogUENJIEludGVycnVwdCBMaW5rIFtMTktDXSAoSVJR
cyAzIDQgNSA2IDEwIDExIDEyIDE0IDE1KSAqNwpbICAgIDEuNjc0MTMxXSBBQ1BJOiBQQ0kgSW50
ZXJydXB0IExpbmsgW0xOS0RdIChJUlFzIDMgNCA1IDYgMTAgMTEgMTIgMTQgMTUpICo3ClsgICAg
MS42NzQzMDldIEFDUEk6IFBDSSBJbnRlcnJ1cHQgTGluayBbTE5LRV0gKElSUXMgMyA0IDUgNiAx
MCAxMSAxMiAxNCAxNSkgKjcKWyAgICAxLjY3NDQ5MV0gQUNQSTogUENJIEludGVycnVwdCBMaW5r
IFtMTktGXSAoSVJRcyAzIDQgNSA2IDEwICoxMSAxMiAxNCAxNSkKWyAgICAxLjY3NDY2OF0gQUNQ
STogUENJIEludGVycnVwdCBMaW5rIFtMTktHXSAoSVJRcyAzIDQgNSA2ICoxMCAxMSAxMiAxNCAx
NSkKWyAgICAxLjY3NDg0NF0gQUNQSTogUENJIEludGVycnVwdCBMaW5rIFtMTktIXSAoSVJRcyAz
IDQgNSA2IDEwICoxMSAxMiAxNCAxNSkKWyAgICAxLjY3NTUxNV0gaW9tbXU6IERlZmF1bHQgZG9t
YWluIHR5cGU6IFRyYW5zbGF0ZWQgClsgICAgMS42NzU1MTVdIHBjaSAwMDAwOjAwOjAyLjA6IHZn
YWFyYjogc2V0dGluZyBhcyBib290IFZHQSBkZXZpY2UKWyAgICAxLjY3NTUxNV0gcGNpIDAwMDA6
MDA6MDIuMDogdmdhYXJiOiBWR0EgZGV2aWNlIGFkZGVkOiBkZWNvZGVzPWlvK21lbSxvd25zPWlv
K21lbSxsb2Nrcz1ub25lClsgICAgMS42NzU1MTVdIHBjaSAwMDAwOjAwOjAyLjA6IHZnYWFyYjog
YnJpZGdlIGNvbnRyb2wgcG9zc2libGUKWyAgICAxLjY3NTUxNV0gdmdhYXJiOiBsb2FkZWQKWyAg
ICAxLjY3NTUxNV0gRURBQyBNQzogVmVyOiAzLjAuMApbICAgIDEuNjc1NTE1XSBSZWdpc3RlcmVk
IGVmaXZhcnMgb3BlcmF0aW9ucwpbICAgIDEuNjc1NTE1XSBQQ0k6IFVzaW5nIEFDUEkgZm9yIElS
USByb3V0aW5nClsgICAgMS42NzU1MTVdIFBDSTogcGNpX2NhY2hlX2xpbmVfc2l6ZSBzZXQgdG8g
NjQgYnl0ZXMKWyAgICAxLjY3NTUxNV0gZTgyMDogcmVzZXJ2ZSBSQU0gYnVmZmVyIFttZW0gMHgw
MDA2ZjAwMC0weDAwMDZmZmZmXQpbICAgIDEuNjc1NTE1XSBlODIwOiByZXNlcnZlIFJBTSBidWZm
ZXIgW21lbSAweGI1OTRmMDAwLTB4YjdmZmZmZmZdClsgICAgMS42NzU1MTVdIGU4MjA6IHJlc2Vy
dmUgUkFNIGJ1ZmZlciBbbWVtIDB4YjdhZjMwMDAtMHhiN2ZmZmZmZl0KWyAgICAxLjY3NTUxNV0g
ZTgyMDogcmVzZXJ2ZSBSQU0gYnVmZmVyIFttZW0gMHhiOTNjMzAwMC0weGJiZmZmZmZmXQpbICAg
IDEuNjc1NTE1XSBlODIwOiByZXNlcnZlIFJBTSBidWZmZXIgW21lbSAweGJhMDAwMDAwLTB4YmJm
ZmZmZmZdClsgICAgMS42NzY5NjBdIGNsb2Nrc291cmNlOiBTd2l0Y2hlZCB0byBjbG9ja3NvdXJj
ZSB0c2MtZWFybHkKWyAgICAxLjcwNjA5NF0gVkZTOiBEaXNrIHF1b3RhcyBkcXVvdF82LjYuMApb
ICAgIDEuNzA2MTQ2XSBWRlM6IERxdW90LWNhY2hlIGhhc2ggdGFibGUgZW50cmllczogNTEyIChv
cmRlciAwLCA0MDk2IGJ5dGVzKQpbICAgIDEuNzA2MjkyXSBwbnA6IFBuUCBBQ1BJIGluaXQKWyAg
ICAxLjcwNjQzM10gcG5wIDAwOjAwOiBQbHVnIGFuZCBQbGF5IEFDUEkgZGV2aWNlLCBJRHMgUE5Q
MGIwMCAoYWN0aXZlKQpbICAgIDEuNzA2NjkzXSBzeXN0ZW0gMDA6MDE6IFtpbyAgMHgwNjgwLTB4
MDY5Zl0gaGFzIGJlZW4gcmVzZXJ2ZWQKWyAgICAxLjcwNjcwNF0gc3lzdGVtIDAwOjAxOiBbaW8g
IDB4MDQwMC0weDA0N2ZdIGhhcyBiZWVuIHJlc2VydmVkClsgICAgMS43MDY3MTFdIHN5c3RlbSAw
MDowMTogW2lvICAweDA1MDAtMHgwNWZlXSBoYXMgYmVlbiByZXNlcnZlZApbICAgIDEuNzA2NzI3
XSBzeXN0ZW0gMDA6MDE6IFBsdWcgYW5kIFBsYXkgQUNQSSBkZXZpY2UsIElEcyBQTlAwYzAyIChh
Y3RpdmUpClsgICAgMS43MDcxMTldIHBucCAwMDowMjogUGx1ZyBhbmQgUGxheSBBQ1BJIGRldmlj
ZSwgSURzIFBOUDA1MDEgKGFjdGl2ZSkKWyAgICAxLjcwNzQ3NV0gcG5wIDAwOjAzOiBQbHVnIGFu
ZCBQbGF5IEFDUEkgZGV2aWNlLCBJRHMgUE5QMDUwMSAoYWN0aXZlKQpbICAgIDEuOTEzNTE4XSBz
eXN0ZW0gMDA6MDQ6IFttZW0gMHhlMDAwMDAwMC0weGVmZmZmZmZmXSBjb3VsZCBub3QgYmUgcmVz
ZXJ2ZWQKWyAgICAxLjkxMzUyOF0gc3lzdGVtIDAwOjA0OiBbbWVtIDB4ZmVkMDEwMDAtMHhmZWQw
MWZmZl0gaGFzIGJlZW4gcmVzZXJ2ZWQKWyAgICAxLjkxMzUzN10gc3lzdGVtIDAwOjA0OiBbbWVt
IDB4ZmVkMDMwMDAtMHhmZWQwM2ZmZl0gaGFzIGJlZW4gcmVzZXJ2ZWQKWyAgICAxLjkxMzU0NV0g
c3lzdGVtIDAwOjA0OiBbbWVtIDB4ZmVkMDQwMDAtMHhmZWQwNGZmZl0gaGFzIGJlZW4gcmVzZXJ2
ZWQKWyAgICAxLjkxMzU1Ml0gc3lzdGVtIDAwOjA0OiBbbWVtIDB4ZmVkMGMwMDAtMHhmZWQwZmZm
Zl0gaGFzIGJlZW4gcmVzZXJ2ZWQKWyAgICAxLjkxMzU2MF0gc3lzdGVtIDAwOjA0OiBbbWVtIDB4
ZmVkMDgwMDAtMHhmZWQwOGZmZl0gaGFzIGJlZW4gcmVzZXJ2ZWQKWyAgICAxLjkxMzU2OF0gc3lz
dGVtIDAwOjA0OiBbbWVtIDB4ZmVkMWMwMDAtMHhmZWQxY2ZmZl0gaGFzIGJlZW4gcmVzZXJ2ZWQK
WyAgICAxLjkxMzU3Nl0gc3lzdGVtIDAwOjA0OiBbbWVtIDB4ZmVkNDAwMDAtMHhmZWQ0NGZmZl0g
aGFzIGJlZW4gcmVzZXJ2ZWQKWyAgICAxLjkxMzU4NF0gc3lzdGVtIDAwOjA0OiBbbWVtIDB4ZmVl
MDAwMDAtMHhmZWVmZmZmZl0gaGFzIGJlZW4gcmVzZXJ2ZWQKWyAgICAxLjkxMzU5Ml0gc3lzdGVt
IDAwOjA0OiBbbWVtIDB4ZmVmMDAwMDAtMHhmZWZmZmZmZl0gaGFzIGJlZW4gcmVzZXJ2ZWQKWyAg
ICAxLjkxMzYwN10gc3lzdGVtIDAwOjA0OiBQbHVnIGFuZCBQbGF5IEFDUEkgZGV2aWNlLCBJRHMg
UE5QMGMwMiAoYWN0aXZlKQpbICAgIDEuOTE0MDc3XSBwbnA6IFBuUCBBQ1BJOiBmb3VuZCA1IGRl
dmljZXMKWyAgICAxLjkxODgxOF0gdGhlcm1hbF9zeXM6IFJlZ2lzdGVyZWQgdGhlcm1hbCBnb3Zl
cm5vciAnZmFpcl9zaGFyZScKWyAgICAxLjkxODgyMF0gdGhlcm1hbF9zeXM6IFJlZ2lzdGVyZWQg
dGhlcm1hbCBnb3Zlcm5vciAnYmFuZ19iYW5nJwpbICAgIDEuOTE4ODI5XSB0aGVybWFsX3N5czog
UmVnaXN0ZXJlZCB0aGVybWFsIGdvdmVybm9yICdzdGVwX3dpc2UnClsgICAgMS45MTg4MzRdIHRo
ZXJtYWxfc3lzOiBSZWdpc3RlcmVkIHRoZXJtYWwgZ292ZXJub3IgJ3VzZXJfc3BhY2UnClsgICAg
MS45MjMzOTFdIGNsb2Nrc291cmNlOiBhY3BpX3BtOiBtYXNrOiAweGZmZmZmZiBtYXhfY3ljbGVz
OiAweGZmZmZmZiwgbWF4X2lkbGVfbnM6IDIwODU3MDEwMjQgbnMKWyAgICAxLjkyMzUwNV0gcGNp
IDAwMDA6MDA6MWMuMDogYnJpZGdlIHdpbmRvdyBbaW8gIDB4MTAwMC0weDBmZmZdIHRvIFtidXMg
MDFdIGFkZF9zaXplIDEwMDAKWyAgICAxLjkyMzUxOF0gcGNpIDAwMDA6MDA6MWMuMDogYnJpZGdl
IHdpbmRvdyBbbWVtIDB4MDAxMDAwMDAtMHgwMDBmZmZmZiA2NGJpdCBwcmVmXSB0byBbYnVzIDAx
XSBhZGRfc2l6ZSAyMDAwMDAgYWRkX2FsaWduIDEwMDAwMApbICAgIDEuOTIzNTMwXSBwY2kgMDAw
MDowMDoxYy4xOiBicmlkZ2Ugd2luZG93IFttZW0gMHgwMDEwMDAwMC0weDAwMGZmZmZmIDY0Yml0
IHByZWZdIHRvIFtidXMgMDJdIGFkZF9zaXplIDIwMDAwMCBhZGRfYWxpZ24gMTAwMDAwClsgICAg
MS45MjM1NDJdIHBjaSAwMDAwOjAwOjFjLjI6IGJyaWRnZSB3aW5kb3cgW21lbSAweDAwMTAwMDAw
LTB4MDAwZmZmZmYgNjRiaXQgcHJlZl0gdG8gW2J1cyAwM10gYWRkX3NpemUgMjAwMDAwIGFkZF9h
bGlnbiAxMDAwMDAKWyAgICAxLjkyMzU1Ml0gcGNpIDAwMDA6MDA6MWMuMzogYnJpZGdlIHdpbmRv
dyBbaW8gIDB4MTAwMC0weDBmZmZdIHRvIFtidXMgMDRdIGFkZF9zaXplIDEwMDAKWyAgICAxLjky
MzU2MV0gcGNpIDAwMDA6MDA6MWMuMzogYnJpZGdlIHdpbmRvdyBbbWVtIDB4MDAxMDAwMDAtMHgw
MDBmZmZmZiA2NGJpdCBwcmVmXSB0byBbYnVzIDA0XSBhZGRfc2l6ZSAyMDAwMDAgYWRkX2FsaWdu
IDEwMDAwMApbICAgIDEuOTIzNTcyXSBwY2kgMDAwMDowMDoxYy4zOiBicmlkZ2Ugd2luZG93IFtt
ZW0gMHgwMDEwMDAwMC0weDAwMGZmZmZmXSB0byBbYnVzIDA0XSBhZGRfc2l6ZSAyMDAwMDAgYWRk
X2FsaWduIDEwMDAwMApbICAgIDEuOTIzNjA0XSBwY2kgMDAwMDowMDoxYy4wOiBCQVIgMTU6IG5v
IHNwYWNlIGZvciBbbWVtIHNpemUgMHgwMDIwMDAwMCA2NGJpdCBwcmVmXQpbICAgIDEuOTIzNjE0
XSBwY2kgMDAwMDowMDoxYy4wOiBCQVIgMTU6IGZhaWxlZCB0byBhc3NpZ24gW21lbSBzaXplIDB4
MDAyMDAwMDAgNjRiaXQgcHJlZl0KWyAgICAxLjkyMzYyOV0gcGNpIDAwMDA6MDA6MWMuMTogQkFS
IDE1OiBubyBzcGFjZSBmb3IgW21lbSBzaXplIDB4MDAyMDAwMDAgNjRiaXQgcHJlZl0KWyAgICAx
LjkyMzYzN10gcGNpIDAwMDA6MDA6MWMuMTogQkFSIDE1OiBmYWlsZWQgdG8gYXNzaWduIFttZW0g
c2l6ZSAweDAwMjAwMDAwIDY0Yml0IHByZWZdClsgICAgMS45MjM2NTFdIHBjaSAwMDAwOjAwOjFj
LjI6IEJBUiAxNTogbm8gc3BhY2UgZm9yIFttZW0gc2l6ZSAweDAwMjAwMDAwIDY0Yml0IHByZWZd
ClsgICAgMS45MjM2NTldIHBjaSAwMDAwOjAwOjFjLjI6IEJBUiAxNTogZmFpbGVkIHRvIGFzc2ln
biBbbWVtIHNpemUgMHgwMDIwMDAwMCA2NGJpdCBwcmVmXQpbICAgIDEuOTIzNjY5XSBwY2kgMDAw
MDowMDoxYy4zOiBCQVIgMTQ6IG5vIHNwYWNlIGZvciBbbWVtIHNpemUgMHgwMDIwMDAwMF0KWyAg
ICAxLjkyMzY3N10gcGNpIDAwMDA6MDA6MWMuMzogQkFSIDE0OiBmYWlsZWQgdG8gYXNzaWduIFtt
ZW0gc2l6ZSAweDAwMjAwMDAwXQpbICAgIDEuOTIzNjg5XSBwY2kgMDAwMDowMDoxYy4zOiBCQVIg
MTU6IG5vIHNwYWNlIGZvciBbbWVtIHNpemUgMHgwMDIwMDAwMCA2NGJpdCBwcmVmXQpbICAgIDEu
OTIzNjk4XSBwY2kgMDAwMDowMDoxYy4zOiBCQVIgMTU6IGZhaWxlZCB0byBhc3NpZ24gW21lbSBz
aXplIDB4MDAyMDAwMDAgNjRiaXQgcHJlZl0KWyAgICAxLjkyMzcwOF0gcGNpIDAwMDA6MDA6MWMu
MDogQkFSIDEzOiBhc3NpZ25lZCBbaW8gIDB4MTAwMC0weDFmZmZdClsgICAgMS45MjM3MTddIHBj
aSAwMDAwOjAwOjFjLjM6IEJBUiAxMzogYXNzaWduZWQgW2lvICAweDIwMDAtMHgyZmZmXQpbICAg
IDEuOTIzNzMwXSBwY2kgMDAwMDowMDoxYy4zOiBCQVIgMTQ6IG5vIHNwYWNlIGZvciBbbWVtIHNp
emUgMHgwMDIwMDAwMF0KWyAgICAxLjkyMzczN10gcGNpIDAwMDA6MDA6MWMuMzogQkFSIDE0OiBm
YWlsZWQgdG8gYXNzaWduIFttZW0gc2l6ZSAweDAwMjAwMDAwXQpbICAgIDEuOTIzNzUwXSBwY2kg
MDAwMDowMDoxYy4zOiBCQVIgMTU6IG5vIHNwYWNlIGZvciBbbWVtIHNpemUgMHgwMDIwMDAwMCA2
NGJpdCBwcmVmXQpbICAgIDEuOTIzNzU4XSBwY2kgMDAwMDowMDoxYy4zOiBCQVIgMTU6IGZhaWxl
ZCB0byBhc3NpZ24gW21lbSBzaXplIDB4MDAyMDAwMDAgNjRiaXQgcHJlZl0KWyAgICAxLjkyMzc3
MV0gcGNpIDAwMDA6MDA6MWMuMjogQkFSIDE1OiBubyBzcGFjZSBmb3IgW21lbSBzaXplIDB4MDAy
MDAwMDAgNjRiaXQgcHJlZl0KWyAgICAxLjkyMzc3OV0gcGNpIDAwMDA6MDA6MWMuMjogQkFSIDE1
OiBmYWlsZWQgdG8gYXNzaWduIFttZW0gc2l6ZSAweDAwMjAwMDAwIDY0Yml0IHByZWZdClsgICAg
MS45MjM3OTNdIHBjaSAwMDAwOjAwOjFjLjE6IEJBUiAxNTogbm8gc3BhY2UgZm9yIFttZW0gc2l6
ZSAweDAwMjAwMDAwIDY0Yml0IHByZWZdClsgICAgMS45MjM4MDFdIHBjaSAwMDAwOjAwOjFjLjE6
IEJBUiAxNTogZmFpbGVkIHRvIGFzc2lnbiBbbWVtIHNpemUgMHgwMDIwMDAwMCA2NGJpdCBwcmVm
XQpbICAgIDEuOTIzODE0XSBwY2kgMDAwMDowMDoxYy4wOiBCQVIgMTU6IG5vIHNwYWNlIGZvciBb
bWVtIHNpemUgMHgwMDIwMDAwMCA2NGJpdCBwcmVmXQpbICAgIDEuOTIzODIyXSBwY2kgMDAwMDow
MDoxYy4wOiBCQVIgMTU6IGZhaWxlZCB0byBhc3NpZ24gW21lbSBzaXplIDB4MDAyMDAwMDAgNjRi
aXQgcHJlZl0KWyAgICAxLjkyMzgzMl0gcGNpIDAwMDA6MDA6MWMuMDogUENJIGJyaWRnZSB0byBb
YnVzIDAxXQpbICAgIDEuOTIzODQwXSBwY2kgMDAwMDowMDoxYy4wOiAgIGJyaWRnZSB3aW5kb3cg
W2lvICAweDEwMDAtMHgxZmZmXQpbICAgIDEuOTIzODUwXSBwY2kgMDAwMDowMDoxYy4wOiAgIGJy
aWRnZSB3aW5kb3cgW21lbSAweGQwNjAwMDAwLTB4ZDA2ZmZmZmZdClsgICAgMS45MjM4NjJdIHBj
aSAwMDAwOjAwOjFjLjE6IFBDSSBicmlkZ2UgdG8gW2J1cyAwMl0KWyAgICAxLjkyMzg2OV0gcGNp
IDAwMDA6MDA6MWMuMTogICBicmlkZ2Ugd2luZG93IFtpbyAgMHg2MDAwLTB4NmZmZl0KWyAgICAx
LjkyMzg3N10gcGNpIDAwMDA6MDA6MWMuMTogICBicmlkZ2Ugd2luZG93IFttZW0gMHhkMDUwMDAw
MC0weGQwNWZmZmZmXQpbICAgIDEuOTIzODg5XSBwY2kgMDAwMDowMDoxYy4yOiBQQ0kgYnJpZGdl
IHRvIFtidXMgMDNdClsgICAgMS45MjM4OTZdIHBjaSAwMDAwOjAwOjFjLjI6ICAgYnJpZGdlIHdp
bmRvdyBbaW8gIDB4NTAwMC0weDVmZmZdClsgICAgMS45MjM5MDRdIHBjaSAwMDAwOjAwOjFjLjI6
ICAgYnJpZGdlIHdpbmRvdyBbbWVtIDB4ZDA0MDAwMDAtMHhkMDRmZmZmZl0KWyAgICAxLjkyMzkx
NV0gcGNpIDAwMDA6MDA6MWMuMzogUENJIGJyaWRnZSB0byBbYnVzIDA0XQpbICAgIDEuOTIzOTIy
XSBwY2kgMDAwMDowMDoxYy4zOiAgIGJyaWRnZSB3aW5kb3cgW2lvICAweDIwMDAtMHgyZmZmXQpb
ICAgIDEuOTIzOTM3XSBwY2lfYnVzIDAwMDA6MDA6IHJlc291cmNlIDQgW2lvICAweDAwMDAtMHgw
MDZmIHdpbmRvd10KWyAgICAxLjkyMzk0M10gcGNpX2J1cyAwMDAwOjAwOiByZXNvdXJjZSA1IFtp
byAgMHgwMDc4LTB4MGNmNyB3aW5kb3ddClsgICAgMS45MjM5NTBdIHBjaV9idXMgMDAwMDowMDog
cmVzb3VyY2UgNiBbaW8gIDB4MGQwMC0weGZmZmYgd2luZG93XQpbICAgIDEuOTIzOTU3XSBwY2lf
YnVzIDAwMDA6MDA6IHJlc291cmNlIDcgW21lbSAweDAwMGEwMDAwLTB4MDAwYmZmZmYgd2luZG93
XQpbICAgIDEuOTIzOTYzXSBwY2lfYnVzIDAwMDA6MDA6IHJlc291cmNlIDggW21lbSAweDAwMGMw
MDAwLTB4MDAwZGZmZmYgd2luZG93XQpbICAgIDEuOTIzOTcwXSBwY2lfYnVzIDAwMDA6MDA6IHJl
c291cmNlIDkgW21lbSAweDAwMGUwMDAwLTB4MDAwZmZmZmYgd2luZG93XQpbICAgIDEuOTIzOTc3
XSBwY2lfYnVzIDAwMDA6MDA6IHJlc291cmNlIDEwIFttZW0gMHhjMDAwMDAwMC0weGQwOWZmZmZl
IHdpbmRvd10KWyAgICAxLjkyMzk4NF0gcGNpX2J1cyAwMDAwOjAxOiByZXNvdXJjZSAwIFtpbyAg
MHgxMDAwLTB4MWZmZl0KWyAgICAxLjkyMzk5MV0gcGNpX2J1cyAwMDAwOjAxOiByZXNvdXJjZSAx
IFttZW0gMHhkMDYwMDAwMC0weGQwNmZmZmZmXQpbICAgIDEuOTIzOTk4XSBwY2lfYnVzIDAwMDA6
MDI6IHJlc291cmNlIDAgW2lvICAweDYwMDAtMHg2ZmZmXQpbICAgIDEuOTI0MDA0XSBwY2lfYnVz
IDAwMDA6MDI6IHJlc291cmNlIDEgW21lbSAweGQwNTAwMDAwLTB4ZDA1ZmZmZmZdClsgICAgMS45
MjQwMTFdIHBjaV9idXMgMDAwMDowMzogcmVzb3VyY2UgMCBbaW8gIDB4NTAwMC0weDVmZmZdClsg
ICAgMS45MjQwMTddIHBjaV9idXMgMDAwMDowMzogcmVzb3VyY2UgMSBbbWVtIDB4ZDA0MDAwMDAt
MHhkMDRmZmZmZl0KWyAgICAxLjkyNDAyNF0gcGNpX2J1cyAwMDAwOjA0OiByZXNvdXJjZSAwIFtp
byAgMHgyMDAwLTB4MmZmZl0KWyAgICAxLjkyNDIzOF0gTkVUOiBSZWdpc3RlcmVkIHByb3RvY29s
IGZhbWlseSAyClsgICAgMS45MjQ1ODBdIHRjcF9saXN0ZW5fcG9ydGFkZHJfaGFzaCBoYXNoIHRh
YmxlIGVudHJpZXM6IDQwOTYgKG9yZGVyOiA0LCA2NTUzNiBieXRlcywgbGluZWFyKQpbICAgIDEu
OTI0NjI2XSBUQ1AgZXN0YWJsaXNoZWQgaGFzaCB0YWJsZSBlbnRyaWVzOiA2NTUzNiAob3JkZXI6
IDcsIDUyNDI4OCBieXRlcywgbGluZWFyKQpbICAgIDEuOTI0ODMzXSBUQ1AgYmluZCBoYXNoIHRh
YmxlIGVudHJpZXM6IDY1NTM2IChvcmRlcjogOCwgMTA0ODU3NiBieXRlcywgbGluZWFyKQpbICAg
IDEuOTI1MjE2XSBUQ1A6IEhhc2ggdGFibGVzIGNvbmZpZ3VyZWQgKGVzdGFibGlzaGVkIDY1NTM2
IGJpbmQgNjU1MzYpClsgICAgMS45MjUzNDNdIFVEUCBoYXNoIHRhYmxlIGVudHJpZXM6IDQwOTYg
KG9yZGVyOiA1LCAxMzEwNzIgYnl0ZXMsIGxpbmVhcikKWyAgICAxLjkyNTQxNl0gVURQLUxpdGUg
aGFzaCB0YWJsZSBlbnRyaWVzOiA0MDk2IChvcmRlcjogNSwgMTMxMDcyIGJ5dGVzLCBsaW5lYXIp
ClsgICAgMS45MjU2MzNdIE5FVDogUmVnaXN0ZXJlZCBwcm90b2NvbCBmYW1pbHkgMQpbICAgIDEu
OTI1NjczXSBwY2kgMDAwMDowMDowMi4wOiBWaWRlbyBkZXZpY2Ugd2l0aCBzaGFkb3dlZCBST00g
YXQgW21lbSAweDAwMGMwMDAwLTB4MDAwZGZmZmZdClsgICAgMy45MjQ4NzNdIHBjaSAwMDAwOjAw
OjFkLjA6IEVIQ0k6IEJJT1MgaGFuZG9mZiBmYWlsZWQgKEJJT1MgYnVnPykgMDEwMTAwMDEKWyAg
ICAzLjkyNTEwNF0gcGNpIDAwMDA6MDA6MWQuMDogcXVpcmtfdXNiX2Vhcmx5X2hhbmRvZmYrMHgw
LzB4NjQ0IHRvb2sgMTk1MjUyNSB1c2VjcwpbICAgIDMuOTI1MTM3XSBQQ0k6IENMUyA2NCBieXRl
cywgZGVmYXVsdCA2NApbICAgIDMuOTI1MjUyXSBUcnlpbmcgdG8gdW5wYWNrIHJvb3RmcyBpbWFn
ZSBhcyBpbml0cmFtZnMuLi4KWyAgICA0LjY1NTg3MF0gRnJlZWluZyBpbml0cmQgbWVtb3J5OiAy
MTYzNksKWyAgICA0LjY1NTkyMl0gUENJLURNQTogVXNpbmcgc29mdHdhcmUgYm91bmNlIGJ1ZmZl
cmluZyBmb3IgSU8gKFNXSU9UTEIpClsgICAgNC42NTU5MzFdIHNvZnR3YXJlIElPIFRMQjogbWFw
cGVkIFttZW0gMHhiMTVhOTAwMC0weGI1NWE5MDAwXSAoNjRNQikKWyAgICA0LjY1NjAwNl0gY2xv
Y2tzb3VyY2U6IHRzYzogbWFzazogMHhmZmZmZmZmZmZmZmZmZmZmIG1heF9jeWNsZXM6IDB4MzRk
YTQ2ZDE3NjgsIG1heF9pZGxlX25zOiA4ODE1OTA2MTA5ODUgbnMKWyAgICA0LjY1NjA0OF0gY2xv
Y2tzb3VyY2U6IFN3aXRjaGVkIHRvIGNsb2Nrc291cmNlIHRzYwpbICAgIDQuNjU3MDkwXSBJbml0
aWFsaXNlIHN5c3RlbSB0cnVzdGVkIGtleXJpbmdzClsgICAgNC42NTcyMDVdIHdvcmtpbmdzZXQ6
IHRpbWVzdGFtcF9iaXRzPTQwIG1heF9vcmRlcj0yMSBidWNrZXRfb3JkZXI9MApbICAgIDQuNjU3
MzA2XSB6YnVkOiBsb2FkZWQKWyAgICA0LjY1NzYwMV0gS2V5IHR5cGUgYXN5bW1ldHJpYyByZWdp
c3RlcmVkClsgICAgNC42NTc2MDhdIEFzeW1tZXRyaWMga2V5IHBhcnNlciAneDUwOScgcmVnaXN0
ZXJlZApbICAgIDQuNjU3NjM0XSBCbG9jayBsYXllciBTQ1NJIGdlbmVyaWMgKGJzZykgZHJpdmVy
IHZlcnNpb24gMC40IGxvYWRlZCAobWFqb3IgMjQ5KQpbICAgIDQuNjU3NzQwXSBpbyBzY2hlZHVs
ZXIgbXEtZGVhZGxpbmUgcmVnaXN0ZXJlZApbICAgIDQuNjU3NzQ3XSBpbyBzY2hlZHVsZXIga3li
ZXIgcmVnaXN0ZXJlZApbICAgIDQuNjU4OTQwXSBlZmlmYjogcHJvYmluZyBmb3IgZWZpZmIKWyAg
ICA0LjY1ODk4MV0gZWZpZmI6IGZyYW1lYnVmZmVyIGF0IDB4YzAwMDAwMDAsIHVzaW5nIDMwNzJr
LCB0b3RhbCAzMDcyawpbICAgIDQuNjU4OTg4XSBlZmlmYjogbW9kZSBpcyAxMDI0eDc2OHgzMiwg
bGluZWxlbmd0aD00MDk2LCBwYWdlcz0xClsgICAgNC42NTg5OTNdIGVmaWZiOiBzY3JvbGxpbmc6
IHJlZHJhdwpbICAgIDQuNjU4OTk4XSBlZmlmYjogVHJ1ZWNvbG9yOiBzaXplPTg6ODo4OjgsIHNo
aWZ0PTI0OjE2Ojg6MApbICAgIDQuNjY0NDUwXSBDb25zb2xlOiBzd2l0Y2hpbmcgdG8gY29sb3Vy
IGZyYW1lIGJ1ZmZlciBkZXZpY2UgMTI4eDQ4ClsgICAgNC42Njk3NjFdIGZiMDogRUZJIFZHQSBm
cmFtZSBidWZmZXIgZGV2aWNlClsgICAgNC42Njk4MzldIGludGVsX2lkbGU6IE1XQUlUIHN1YnN0
YXRlczogMHgzMzAwMDAyMApbICAgIDQuNjY5ODk3XSBpbnRlbF9pZGxlOiB2MC40LjEgbW9kZWwg
MHgzNwpbICAgIDQuNjcwNDY3XSBpbnRlbF9pZGxlOiBsYXBpY190aW1lcl9yZWxpYWJsZV9zdGF0
ZXMgMHhmZmZmZmZmZgpbICAgIDQuNjc0NTU4XSBTZXJpYWw6IDgyNTAvMTY1NTAgZHJpdmVyLCA0
IHBvcnRzLCBJUlEgc2hhcmluZyBlbmFibGVkClsgICAgNC42NzQ3NjldIDAwOjAyOiB0dHlTMCBh
dCBJL08gMHgzZjggKGlycSA9IDQsIGJhc2VfYmF1ZCA9IDExNTIwMCkgaXMgYSBUSTE2NzUwClsg
ICAgNC42NzUxMjZdIDAwOjAzOiB0dHlTMSBhdCBJL08gMHgyZjggKGlycSA9IDMsIGJhc2VfYmF1
ZCA9IDExNTIwMCkgaXMgYSBUSTE2NzUwClsgICAgNC42NzYwOTZdIExpbnV4IGFncGdhcnQgaW50
ZXJmYWNlIHYwLjEwMwpbICAgIDQuNjgwODkyXSB0cG1fdGlzIE1TRlQwMTAxOjAwOiAyLjAgVFBN
IChkZXZpY2UtaWQgMHgxQSwgcmV2LWlkIDE2KQpbICAgIDQuNzAxNjAwXSBBTUQtVmk6IEFNRCBJ
T01NVXYyIGRyaXZlciBieSBKb2VyZyBSb2VkZWwgPGpyb2VkZWxAc3VzZS5kZT4KWyAgICA0Ljcw
MTY3N10gQU1ELVZpOiBBTUQgSU9NTVV2MiBmdW5jdGlvbmFsaXR5IG5vdCBhdmFpbGFibGUgb24g
dGhpcyBzeXN0ZW0KWyAgICA0LjcwMjg3OV0gaTgwNDI6IFBOUDogTm8gUFMvMiBjb250cm9sbGVy
IGZvdW5kLgpbICAgIDQuNzAyOTM0XSBpODA0MjogUHJvYmluZyBwb3J0cyBkaXJlY3RseS4KWyAg
ICA0LjcwMzU0OV0gc2VyaW86IGk4MDQyIEtCRCBwb3J0IGF0IDB4NjAsMHg2NCBpcnEgMQpbICAg
IDQuNzAzNjE2XSBzZXJpbzogaTgwNDIgQVVYIHBvcnQgYXQgMHg2MCwweDY0IGlycSAxMgpbICAg
IDQuNzA0NDAyXSBtb3VzZWRldjogUFMvMiBtb3VzZSBkZXZpY2UgY29tbW9uIGZvciBhbGwgbWlj
ZQpbICAgIDQuNzA0NTg4XSBydGNfY21vcyAwMDowMDogUlRDIGNhbiB3YWtlIGZyb20gUzQKWyAg
ICA0LjcwNTM1N10gcnRjX2Ntb3MgMDA6MDA6IHJlZ2lzdGVyZWQgYXMgcnRjMApbICAgIDQuNzA1
NDQ5XSBydGNfY21vcyAwMDowMDogYWxhcm1zIHVwIHRvIG9uZSBtb250aCwgeTNrLCAyNDIgYnl0
ZXMgbnZyYW0KWyAgICA0LjcwNTU0NV0gaW50ZWxfcHN0YXRlOiBJbnRlbCBQLXN0YXRlIGRyaXZl
ciBpbml0aWFsaXppbmcKWyAgICA0LjcwNzMwMF0gbGVkdHJpZy1jcHU6IHJlZ2lzdGVyZWQgdG8g
aW5kaWNhdGUgYWN0aXZpdHkgb24gQ1BVcwpbICAgIDQuNzA4OTA4XSBwbWNfYXRvbTogU0lNQVRJ
QyBJUEMyMjdFIGNyaXRjbGtzIHF1aXJrIGVuYWJsZWQKWyAgICA0LjcwOTYxMV0gZHJvcF9tb25p
dG9yOiBJbml0aWFsaXppbmcgbmV0d29yayBkcm9wIG1vbml0b3Igc2VydmljZQpbICAgIDQuNzE3
ODEzXSBORVQ6IFJlZ2lzdGVyZWQgcHJvdG9jb2wgZmFtaWx5IDEwClsgICAgNC43MjAxOTBdIFNl
Z21lbnQgUm91dGluZyB3aXRoIElQdjYKWyAgICA0LjcyMjAzMV0gbWlwNjogTW9iaWxlIElQdjYK
WyAgICA0LjcyMzgwMV0gTkVUOiBSZWdpc3RlcmVkIHByb3RvY29sIGZhbWlseSAxNwpbICAgIDQu
NzI1NTgzXSBtcGxzX2dzbzogTVBMUyBHU08gc3VwcG9ydApbICAgIDQuNzI4Njk4XSBtaWNyb2Nv
ZGU6IHNpZz0weDMwNjc4LCBwZj0weDgsIHJldmlzaW9uPTB4ODM2ClsgICAgNC43MzEzMTldIG1p
Y3JvY29kZTogTWljcm9jb2RlIFVwZGF0ZSBEcml2ZXI6IHYyLjIuClsgICAgNC43MzEzMjVdIElQ
SSBzaG9ydGhhbmQgYnJvYWRjYXN0OiBlbmFibGVkClsgICAgNC43MzQ3ODddIHNjaGVkX2Nsb2Nr
OiBNYXJraW5nIHN0YWJsZSAoNDczMDcxMTkzMywgMjM0ODMyNSktPig0NzQ0NzEyOTgxLCAtMTE2
NTI3MjMpClsgICAgNC43MzcxMjRdIHJlZ2lzdGVyZWQgdGFza3N0YXRzIHZlcnNpb24gMQpbICAg
IDQuNzM4ODY2XSBMb2FkaW5nIGNvbXBpbGVkLWluIFguNTA5IGNlcnRpZmljYXRlcwpbICAgIDQu
NzQwNjM5XSB6c3dhcDogbG9hZGVkIHVzaW5nIHBvb2wgbHpvL3pidWQKWyAgICA0Ljc0MzE3Ml0g
aW1hOiBBbGxvY2F0ZWQgaGFzaCBhbGdvcml0aG06IHNoYTI1NgpbICAgIDQuNzg1OTA4XSBpbWE6
IE5vIGFyY2hpdGVjdHVyZSBwb2xpY2llcyBmb3VuZApbICAgIDQuNzk1NTY1XSBydGNfY21vcyAw
MDowMDogc2V0dGluZyBzeXN0ZW0gY2xvY2sgdG8gMjAyMC0wMS0yOVQwNzoyMzoyNCBVVEMgKDE1
ODAyODI2MDQpClsgICAgNC44MTQzMjJdIEZyZWVpbmcgdW51c2VkIGtlcm5lbCBpbWFnZSBtZW1v
cnk6IDE2NjBLClsgICAgNC44MTYzOThdIFdyaXRlIHByb3RlY3RpbmcgdGhlIGtlcm5lbCByZWFk
LW9ubHkgZGF0YTogMTYzODRrClsgICAgNC44MjA1NTNdIEZyZWVpbmcgdW51c2VkIGtlcm5lbCBp
bWFnZSBtZW1vcnk6IDIwMTJLClsgICAgNC44MjM2OTZdIEZyZWVpbmcgdW51c2VkIGtlcm5lbCBp
bWFnZSBtZW1vcnk6IDUyMEsKWyAgICA0Ljg0ODM0Nl0geDg2L21tOiBDaGVja2VkIFcrWCBtYXBw
aW5nczogcGFzc2VkLCBubyBXK1ggcGFnZXMgZm91bmQuClsgICAgNC44NTA0MTZdIHg4Ni9tbTog
Q2hlY2tpbmcgdXNlciBzcGFjZSBwYWdlIHRhYmxlcwpbICAgIDQuODc0MTM1XSB4ODYvbW06IENo
ZWNrZWQgVytYIG1hcHBpbmdzOiBwYXNzZWQsIG5vIFcrWCBwYWdlcyBmb3VuZC4KWyAgICA0Ljg3
NTg5OV0gUnVuIC9pbml0IGFzIGluaXQgcHJvY2VzcwpbICAgIDQuOTQxOTM4XSBzeXN0ZW1kLXVk
ZXZkWzEwN106IHN0YXJ0aW5nIHZlcnNpb24gMjMyClsgICAgNC45NDgyODNdIHJhbmRvbTogc3lz
dGVtZC11ZGV2ZDogdW5pbml0aWFsaXplZCB1cmFuZG9tIHJlYWQgKDE2IGJ5dGVzIHJlYWQpClsg
ICAgNC45NTQ0MzRdIHJhbmRvbTogc3lzdGVtZC11ZGV2ZDogdW5pbml0aWFsaXplZCB1cmFuZG9t
IHJlYWQgKDE2IGJ5dGVzIHJlYWQpClsgICAgNC45NTU5NjBdIHJhbmRvbTogdWRldmFkbTogdW5p
bml0aWFsaXplZCB1cmFuZG9tIHJlYWQgKDE2IGJ5dGVzIHJlYWQpClsgICAgNS4wNzc5NDNdIFND
U0kgc3Vic3lzdGVtIGluaXRpYWxpemVkClsgICAgNS4wODA2MTVdIHBwc19jb3JlOiBMaW51eFBQ
UyBBUEkgdmVyLiAxIHJlZ2lzdGVyZWQKWyAgICA1LjA4MjY3NV0gcHBzX2NvcmU6IFNvZnR3YXJl
IHZlci4gNS4zLjYgLSBDb3B5cmlnaHQgMjAwNS0yMDA3IFJvZG9sZm8gR2lvbWV0dGkgPGdpb21l
dHRpQGxpbnV4Lml0PgpbICAgIDUuMDg1NjE5XSBQVFAgY2xvY2sgc3VwcG9ydCByZWdpc3RlcmVk
ClsgICAgNS4wODc5MzJdIGRjYSBzZXJ2aWNlIHN0YXJ0ZWQsIHZlcnNpb24gMS4xMi4xClsgICAg
NS4wODgyNzddIEFDUEk6IGJ1cyB0eXBlIFVTQiByZWdpc3RlcmVkClsgICAgNS4wOTE5OTZdIHVz
YmNvcmU6IHJlZ2lzdGVyZWQgbmV3IGludGVyZmFjZSBkcml2ZXIgdXNiZnMKWyAgICA1LjA5NDU4
N10gdXNiY29yZTogcmVnaXN0ZXJlZCBuZXcgaW50ZXJmYWNlIGRyaXZlciBodWIKWyAgICA1LjA5
NDg1MF0gaTgwMV9zbWJ1cyAwMDAwOjAwOjFmLjM6IFNNQnVzIHVzaW5nIFBDSSBpbnRlcnJ1cHQK
WyAgICA1LjA5NjQyMl0gdXNiY29yZTogcmVnaXN0ZXJlZCBuZXcgZGV2aWNlIGRyaXZlciB1c2IK
WyAgICA1LjA5NjQ5NF0gbGliYXRhIHZlcnNpb24gMy4wMCBsb2FkZWQuClsgICAgNS4xMjQ5NDdd
IGVoY2lfaGNkOiBVU0IgMi4wICdFbmhhbmNlZCcgSG9zdCBDb250cm9sbGVyIChFSENJKSBEcml2
ZXIKWyAgICA1LjEyODI1Nl0gaWdiOiBJbnRlbChSKSBHaWdhYml0IEV0aGVybmV0IE5ldHdvcmsg
RHJpdmVyIC0gdmVyc2lvbiA1LjYuMC1rClsgICAgNS4xMzExMTVdIGlnYjogQ29weXJpZ2h0IChj
KSAyMDA3LTIwMTQgSW50ZWwgQ29ycG9yYXRpb24uClsgICAgNS4xMzQwMDRdIGVoY2ktcGNpOiBF
SENJIFBDSSBwbGF0Zm9ybSBkcml2ZXIKWyAgICA1LjEzNDAyOF0gYWhjaSAwMDAwOjAwOjEzLjA6
IHZlcnNpb24gMy4wClsgICAgNS4xMzY1ODNdIGVoY2ktcGNpIDAwMDA6MDA6MWQuMDogRUhDSSBI
b3N0IENvbnRyb2xsZXIKWyAgICA1LjEzODc5N10gYWhjaSAwMDAwOjAwOjEzLjA6IGNvbnRyb2xs
ZXIgY2FuJ3QgZG8gREVWU0xQLCB0dXJuaW5nIG9mZgpbICAgIDUuMTQwOTcyXSBlaGNpLXBjaSAw
MDAwOjAwOjFkLjA6IG5ldyBVU0IgYnVzIHJlZ2lzdGVyZWQsIGFzc2lnbmVkIGJ1cyBudW1iZXIg
MQpbICAgIDUuMTQ1Mjk2XSBlaGNpLXBjaSAwMDAwOjAwOjFkLjA6IGRlYnVnIHBvcnQgMgpbICAg
IDUuMTUxMDQ3XSBlaGNpLXBjaSAwMDAwOjAwOjFkLjA6IGNhY2hlIGxpbmUgc2l6ZSBvZiA2NCBp
cyBub3Qgc3VwcG9ydGVkClsgICAgNS4xNTI5MTBdIGVoY2ktcGNpIDAwMDA6MDA6MWQuMDogaXJx
IDIwLCBpbyBtZW0gMHhkMDkwNTAwMApbICAgIDUuMTUzMDA3XSBhaGNpIDAwMDA6MDA6MTMuMDog
QUhDSSAwMDAxLjAzMDAgMzIgc2xvdHMgMiBwb3J0cyAzIEdicHMgMHgxIGltcGwgU0FUQSBtb2Rl
ClsgICAgNS4xNTgwOTNdIGFoY2kgMDAwMDowMDoxMy4wOiBmbGFnczogNjRiaXQgbmNxIGxlZCBj
bG8gcGlvIHNsdW0gcGFydCBkZXNvIApbICAgIDUuMTYyNDAxXSBwcHMgcHBzMDogbmV3IFBQUyBz
b3VyY2UgcHRwMApbICAgIDUuMTYyNjYzXSBzY3NpIGhvc3QwOiBhaGNpClsgICAgNS4xNjYwMTBd
IGlnYiAwMDAwOjAyOjAwLjA6IGFkZGVkIFBIQyBvbiBldGgwClsgICAgNS4xNjg0NjFdIHNjc2kg
aG9zdDE6IGFoY2kKWyAgICA1LjE2ODg5Nl0gZWhjaS1wY2kgMDAwMDowMDoxZC4wOiBVU0IgMi4w
IHN0YXJ0ZWQsIEVIQ0kgMS4wMApbICAgIDUuMTY5MDY0XSB1c2IgdXNiMTogTmV3IFVTQiBkZXZp
Y2UgZm91bmQsIGlkVmVuZG9yPTFkNmIsIGlkUHJvZHVjdD0wMDAyLCBiY2REZXZpY2U9IDUuMDQK
WyAgICA1LjE2OTA3MF0gdXNiIHVzYjE6IE5ldyBVU0IgZGV2aWNlIHN0cmluZ3M6IE1mcj0zLCBQ
cm9kdWN0PTIsIFNlcmlhbE51bWJlcj0xClsgICAgNS4xNjkwNzRdIHVzYiB1c2IxOiBQcm9kdWN0
OiBFSENJIEhvc3QgQ29udHJvbGxlcgpbICAgIDUuMTY5MDc4XSB1c2IgdXNiMTogTWFudWZhY3R1
cmVyOiBMaW51eCA1LjQuMTUrIGVoY2lfaGNkClsgICAgNS4xNjkwODJdIHVzYiB1c2IxOiBTZXJp
YWxOdW1iZXI6IDAwMDA6MDA6MWQuMApbICAgIDUuMTY5NDk3XSBodWIgMS0wOjEuMDogVVNCIGh1
YiBmb3VuZApbICAgIDUuMTY5NTI3XSBodWIgMS0wOjEuMDogOCBwb3J0cyBkZXRlY3RlZApbICAg
IDUuMTcwOTY0XSBpZ2IgMDAwMDowMjowMC4wOiBJbnRlbChSKSBHaWdhYml0IEV0aGVybmV0IE5l
dHdvcmsgQ29ubmVjdGlvbgpbICAgIDUuMTcyOTUwXSBhdGExOiBTQVRBIG1heCBVRE1BLzEzMyBh
YmFyIG0yMDQ4QDB4ZDA5MDQwMDAgcG9ydCAweGQwOTA0MTAwIGlycSA5NgpbICAgIDUuMTc0Njc2
XSBpZ2IgMDAwMDowMjowMC4wOiBldGgwOiAoUENJZToyLjVHYi9zOldpZHRoIHgxKSAyMDo4Nzo1
NjozMTpjNTowYwpbICAgIDUuMTc2NTQ0XSBhdGEyOiBEVU1NWQpbICAgIDUuMTc4NDgwXSBpZ2Ig
MDAwMDowMjowMC4wOiBldGgwOiBQQkEgTm86IDAwMDMwMC0wMDAKWyAgICA1LjE5Njg4OF0gaWdi
IDAwMDA6MDI6MDAuMDogVXNpbmcgTVNJLVggaW50ZXJydXB0cy4gNCByeCBxdWV1ZShzKSwgNCB0
eCBxdWV1ZShzKQpbICAgIDUuMjI5MDgyXSBwcHMgcHBzMTogbmV3IFBQUyBzb3VyY2UgcHRwMQpb
ICAgIDUuMjMzODM4XSBpZ2IgMDAwMDowMzowMC4wOiBhZGRlZCBQSEMgb24gZXRoMQpbICAgIDUu
MjM1ODM3XSBpZ2IgMDAwMDowMzowMC4wOiBJbnRlbChSKSBHaWdhYml0IEV0aGVybmV0IE5ldHdv
cmsgQ29ubmVjdGlvbgpbICAgIDUuMjM3ODAyXSBpZ2IgMDAwMDowMzowMC4wOiBldGgxOiAoUENJ
ZToyLjVHYi9zOldpZHRoIHgxKSAyMDo4Nzo1NjozMTpjNTowNgpbICAgIDUuMjM5ODI4XSBpZ2Ig
MDAwMDowMzowMC4wOiBldGgxOiBQQkEgTm86IDAwMDMwMC0wMDAKWyAgICA1LjI0MTc4NF0gaWdi
IDAwMDA6MDM6MDAuMDogVXNpbmcgTVNJLVggaW50ZXJydXB0cy4gNCByeCBxdWV1ZShzKSwgNCB0
eCBxdWV1ZShzKQpbICAgIDUuMjQ2MjQ1XSBpZ2IgMDAwMDowMjowMC4wIGVucDJzMDogcmVuYW1l
ZCBmcm9tIGV0aDAKWyAgICA1LjI2NjE3M10gaWdiIDAwMDA6MDM6MDAuMCBlbnAzczA6IHJlbmFt
ZWQgZnJvbSBldGgxClsgICAgNS40OTMzMDZdIGF0YTE6IFNBVEEgbGluayB1cCAzLjAgR2JwcyAo
U1N0YXR1cyAxMjMgU0NvbnRyb2wgMzAwKQpbICAgIDUuNTAzMTk4XSBhdGExLjAwOiBBVEEtMTA6
IE1pY3Jvbl81MTAwX01URkREQUsyNDBUQ0IsICBEME1VMDM3LCBtYXggVURNQS8xMzMKWyAgICA1
LjUwNTA5MV0gdXNiIDEtMTogbmV3IGhpZ2gtc3BlZWQgVVNCIGRldmljZSBudW1iZXIgMiB1c2lu
ZyBlaGNpLXBjaQpbICAgIDUuNTExMTU4XSBhdGExLjAwOiA0Njg4NjIxMjggc2VjdG9ycywgbXVs
dGkgMTY6IExCQTQ4IE5DUSAoZGVwdGggMzIpLCBBQQpbICAgIDUuNTIzODQyXSBhdGExLjAwOiBj
b25maWd1cmVkIGZvciBVRE1BLzEzMwpbICAgIDUuNTI2NzUxXSBzY3NpIDA6MDowOjA6IERpcmVj
dC1BY2Nlc3MgICAgIEFUQSAgICAgIE1pY3Jvbl81MTAwX01URkQgVTAzNyBQUTogMCBBTlNJOiA1
ClsgICAgNS41NDA2MjBdIGF0YTEuMDA6IEVuYWJsaW5nIGRpc2NhcmRfemVyb2VzX2RhdGEKWyAg
ICA1LjU0MzkzMl0gc2QgMDowOjA6MDogW3NkYV0gNDY4ODYyMTI4IDUxMi1ieXRlIGxvZ2ljYWwg
YmxvY2tzOiAoMjQwIEdCLzIyNCBHaUIpClsgICAgNS41NDcwOThdIHVzYiAxLTE6IE5ldyBVU0Ig
ZGV2aWNlIGZvdW5kLCBpZFZlbmRvcj04MDg3LCBpZFByb2R1Y3Q9MDdlNiwgYmNkRGV2aWNlPSAw
LjE0ClsgICAgNS41NDc1OTRdIHNkIDA6MDowOjA6IFtzZGFdIDQwOTYtYnl0ZSBwaHlzaWNhbCBi
bG9ja3MKWyAgICA1LjU1MTI2NF0gdXNiIDEtMTogTmV3IFVTQiBkZXZpY2Ugc3RyaW5nczogTWZy
PTAsIFByb2R1Y3Q9MCwgU2VyaWFsTnVtYmVyPTAKWyAgICA1LjU1MzI1OF0gc2QgMDowOjA6MDog
W3NkYV0gV3JpdGUgUHJvdGVjdCBpcyBvZmYKWyAgICA1LjU1NzcxMl0gaHViIDEtMToxLjA6IFVT
QiBodWIgZm91bmQKWyAgICA1LjU1ODkyN10gc2QgMDowOjA6MDogW3NkYV0gTW9kZSBTZW5zZTog
MDAgM2EgMDAgMDAKWyAgICA1LjU2MTQzMl0gaHViIDEtMToxLjA6IDQgcG9ydHMgZGV0ZWN0ZWQK
WyAgICA1LjU2Mjk3M10gc2QgMDowOjA6MDogW3NkYV0gV3JpdGUgY2FjaGU6IGVuYWJsZWQsIHJl
YWQgY2FjaGU6IGVuYWJsZWQsIGRvZXNuJ3Qgc3VwcG9ydCBEUE8gb3IgRlVBClsgICAgNS41ODE2
MzRdIGF0YTEuMDA6IEVuYWJsaW5nIGRpc2NhcmRfemVyb2VzX2RhdGEKWyAgICA1LjU5MDQxMV0g
IHNkYTogc2RhMSBzZGEyIHNkYTMKWyAgICA1LjU5NTk5M10gYXRhMS4wMDogRW5hYmxpbmcgZGlz
Y2FyZF96ZXJvZXNfZGF0YQpbICAgIDUuNTk5NjA4XSBzZCAwOjA6MDowOiBbc2RhXSBBdHRhY2hl
ZCBTQ1NJIGRpc2sKWyAgICA1LjcxMTI1MF0gUE06IEltYWdlIG5vdCBmb3VuZCAoY29kZSAtMjIp
ClsgICAgNS44NjEyOTFdIHVzYiAxLTEuMjogbmV3IGhpZ2gtc3BlZWQgVVNCIGRldmljZSBudW1i
ZXIgMyB1c2luZyBlaGNpLXBjaQpbICAgIDUuODg3NTA0XSBFWFQ0LWZzIChzZGEyKTogbW91bnRl
ZCBmaWxlc3lzdGVtIHdpdGggb3JkZXJlZCBkYXRhIG1vZGUuIE9wdHM6IChudWxsKQpbICAgIDUu
ODkwNDg4XSB1c2IgMS0xLjI6IE5ldyBVU0IgZGV2aWNlIGZvdW5kLCBpZFZlbmRvcj0wNDI0LCBp
ZFByb2R1Y3Q9MjUxNCwgYmNkRGV2aWNlPSBiLmIzClsgICAgNS44OTUwOTNdIHVzYiAxLTEuMjog
TmV3IFVTQiBkZXZpY2Ugc3RyaW5nczogTWZyPTAsIFByb2R1Y3Q9MCwgU2VyaWFsTnVtYmVyPTAK
WyAgICA1Ljg5OTUzOV0gaHViIDEtMS4yOjEuMDogVVNCIGh1YiBmb3VuZApbICAgIDUuOTAzNTQ2
XSBodWIgMS0xLjI6MS4wOiA0IHBvcnRzIGRldGVjdGVkClsgICAgNS45MzczOTddIHJhbmRvbTog
ZmFzdCBpbml0IGRvbmUKWyAgICA1Ljk5MzE3M10gdXNiIDEtMS4zOiBuZXcgbG93LXNwZWVkIFVT
QiBkZXZpY2UgbnVtYmVyIDQgdXNpbmcgZWhjaS1wY2kKWyAgICA2LjExNDQ5Ml0gdXNiIDEtMS4z
OiBOZXcgVVNCIGRldmljZSBmb3VuZCwgaWRWZW5kb3I9NDEzYywgaWRQcm9kdWN0PTMwMWEsIGJj
ZERldmljZT0gMS4wMApbICAgIDYuMTIzMjYyXSB1c2IgMS0xLjM6IE5ldyBVU0IgZGV2aWNlIHN0
cmluZ3M6IE1mcj0xLCBQcm9kdWN0PTIsIFNlcmlhbE51bWJlcj0wClsgICAgNi4xMjU2NThdIHVz
YiAxLTEuMzogUHJvZHVjdDogRGVsbCBNUzExNiBVU0IgT3B0aWNhbCBNb3VzZQpbICAgIDYuMTI4
MDA5XSB1c2IgMS0xLjM6IE1hbnVmYWN0dXJlcjogUGl4QXJ0ClsgICAgNi4xNTk1MTRdIHN5c3Rl
bWRbMV06IE1vdW50aW5nIGNncm91cCB0byAvc3lzL2ZzL2Nncm91cC9waWRzIG9mIHR5cGUgY2dy
b3VwIHdpdGggb3B0aW9ucyBwaWRzLgpbICAgIDYuMTYxODYyXSBzeXN0ZW1kWzFdOiBNb3VudGlu
ZyBjZ3JvdXAgdG8gL3N5cy9mcy9jZ3JvdXAvbWVtb3J5IG9mIHR5cGUgY2dyb3VwIHdpdGggb3B0
aW9ucyBtZW1vcnkuClsgICAgNi4xNjQ2MzZdIHN5c3RlbWRbMV06IE1vdW50aW5nIGNncm91cCB0
byAvc3lzL2ZzL2Nncm91cC9uZXRfY2xzLG5ldF9wcmlvIG9mIHR5cGUgY2dyb3VwIHdpdGggb3B0
aW9ucyBuZXRfY2xzLG5ldF9wcmlvLgpbICAgIDYuMTY2OTQxXSBzeXN0ZW1kWzFdOiBNb3VudGlu
ZyBjZ3JvdXAgdG8gL3N5cy9mcy9jZ3JvdXAvY3B1c2V0IG9mIHR5cGUgY2dyb3VwIHdpdGggb3B0
aW9ucyBjcHVzZXQuClsgICAgNi4xODUyMDFdIHN5c3RlbWRbMV06IE1vdW50aW5nIGNncm91cCB0
byAvc3lzL2ZzL2Nncm91cC9jcHUsY3B1YWNjdCBvZiB0eXBlIGNncm91cCB3aXRoIG9wdGlvbnMg
Y3B1LGNwdWFjY3QuClsgICAgNi4xODk4NDJdIHN5c3RlbWRbMV06IE1vdW50aW5nIGNncm91cCB0
byAvc3lzL2ZzL2Nncm91cC9ibGtpbyBvZiB0eXBlIGNncm91cCB3aXRoIG9wdGlvbnMgYmxraW8u
ClsgICAgNi4xOTQ1MzJdIHN5c3RlbWRbMV06IE1vdW50aW5nIGNncm91cCB0byAvc3lzL2ZzL2Nn
cm91cC9kZXZpY2VzIG9mIHR5cGUgY2dyb3VwIHdpdGggb3B0aW9ucyBkZXZpY2VzLgpbICAgIDYu
MTk3MzEyXSBzeXN0ZW1kWzFdOiBNb3VudGluZyBjZ3JvdXAgdG8gL3N5cy9mcy9jZ3JvdXAvcGVy
Zl9ldmVudCBvZiB0eXBlIGNncm91cCB3aXRoIG9wdGlvbnMgcGVyZl9ldmVudC4KWyAgICA2LjIw
MDA4NV0gc3lzdGVtZFsxXTogTW91bnRpbmcgY2dyb3VwIHRvIC9zeXMvZnMvY2dyb3VwL2ZyZWV6
ZXIgb2YgdHlwZSBjZ3JvdXAgd2l0aCBvcHRpb25zIGZyZWV6ZXIuClsgICAgNi4yMDI4ODVdIHN5
c3RlbWRbMV06IHN5c3RlbWQgMjMyIHJ1bm5pbmcgaW4gc3lzdGVtIG1vZGUuICgrUEFNICtBVURJ
VCArU0VMSU5VWCArSU1BICtBUFBBUk1PUiArU01BQ0sgK1NZU1ZJTklUICtVVE1QICtMSUJDUllQ
VFNFVFVQICtHQ1JZUFQgK0dOVVRMUyArQUNMICtYWiArTFo0ICtTRUNDT01QICtCTEtJRCArRUxG
VVRJTFMgK0tNT0QgK0lETikKWyAgICA2LjIwOTA2MF0gdXNiIDEtMS40OiBuZXcgbG93LXNwZWVk
IFVTQiBkZXZpY2UgbnVtYmVyIDUgdXNpbmcgZWhjaS1wY2kKWyAgICA2LjI1ODc5Ml0gc3lzdGVt
ZC1ncHQtYXV0by1nZW5lcmF0b3JbMTk1XTogL2Rldi9zZGEyOiByb290IGRldmljZSAvZGV2L3Nk
YS4KWyAgICA2LjI1OTU2N10gc3lzdGVtZC1zeXN2LWdlbmVyYXRvclsxODldOiBOYXRpdmUgdW5p
dCBmb3IgYWxzYS11dGlscy5zZXJ2aWNlIGFscmVhZHkgZXhpc3RzLCBza2lwcGluZy4KWyAgICA2
LjI2MzU3MF0gc3lzdGVtZC1zeXN2LWdlbmVyYXRvclsxODldOiBOYXRpdmUgdW5pdCBmb3IgY3Jv
bi5zZXJ2aWNlIGFscmVhZHkgZXhpc3RzLCBza2lwcGluZy4KWyAgICA2LjI2NTE5N10gc3lzdGVt
ZC1mc3RhYi1nZW5lcmF0b3JbMTk0XTogUGFyc2luZyAvZXRjL2ZzdGFiClsgICAgNi4yNjgyMjJd
IHN5c3RlbWQtZnN0YWItZ2VuZXJhdG9yWzE5NF06IEZvdW5kIGVudHJ5IHdoYXQ9L2Rldi9kaXNr
L2J5LXV1aWQvZWNlNDRmNjItZDIyZi00MmRlLTkyYjktMGY4NDU4ODEzYzE5IHdoZXJlPS8gdHlw
ZT1leHQ0IG5vZmFpbD1ubyBub2F1dG89bm8KWyAgICA2LjI2ODMwNl0gc3lzdGVtZC1zeXN2LWdl
bmVyYXRvclsxODldOiBOYXRpdmUgdW5pdCBmb3IgcHJvY3BzLnNlcnZpY2UgYWxyZWFkeSBleGlz
dHMsIHNraXBwaW5nLgpbICAgIDYuMjczMTE0XSBzeXN0ZW1kLWZzdGFiLWdlbmVyYXRvclsxOTRd
OiBGb3VuZCBlbnRyeSB3aGF0PS9kZXYvZGlzay9ieS11dWlkLzVGODQtOTVFMSB3aGVyZT0vYm9v
dC9lZmkgdHlwZT12ZmF0IG5vZmFpbD1ubyBub2F1dG89bm8KWyAgICA2LjI4MDI0N10gc3lzdGVt
ZC1zeXN2LWdlbmVyYXRvclsxODldOiBOYXRpdmUgdW5pdCBmb3IgY29uc29sZS1zZXR1cC5zZXJ2
aWNlIGFscmVhZHkgZXhpc3RzLCBza2lwcGluZy4KWyAgICA2LjI4MDM0NV0gc3lzdGVtZC1mc3Rh
Yi1nZW5lcmF0b3JbMTk0XTogRm91bmQgZW50cnkgd2hhdD0vZGV2L2Rpc2svYnktdXVpZC9mZTUy
NjA5Yy00YzE5LTQ4OTEtYmE5Ny1lNWU1MTZiMDY3MGYgd2hlcmU9bm9uZSB0eXBlPXN3YXAgbm9m
YWlsPW5vIG5vYXV0bz1ubwpbICAgIDYuMjg4MTI0XSBzeXN0ZW1kLXN5c3YtZ2VuZXJhdG9yWzE4
OV06IE5hdGl2ZSB1bml0IGZvciByc3luYy5zZXJ2aWNlIGFscmVhZHkgZXhpc3RzLCBza2lwcGlu
Zy4KWyAgICA2LjI5MTQ1OV0gc3lzdGVtZC1zeXN2LWdlbmVyYXRvclsxODldOiBOYXRpdmUgdW5p
dCBmb3IgdWRldi5zZXJ2aWNlIGFscmVhZHkgZXhpc3RzLCBza2lwcGluZy4KWyAgICA2LjI5MjIy
OV0gc3lzdGVtZC1ncHQtYXV0by1nZW5lcmF0b3JbMTk1XTogQWRkaW5nIHN3YXA6IC9kZXYvc2Rh
MwpbICAgIDYuMjk0ODgxXSBzeXN0ZW1kLXN5c3YtZ2VuZXJhdG9yWzE4OV06IE5hdGl2ZSB1bml0
IGZvciByc3lzbG9nLnNlcnZpY2UgYWxyZWFkeSBleGlzdHMsIHNraXBwaW5nLgpbICAgIDYuMjk5
NTcxXSBzeXN0ZW1kLWdwdC1hdXRvLWdlbmVyYXRvclsxOTVdOiAvYm9vdCBhbHJlYWR5IHBvcHVs
YXRlZCwgaWdub3JpbmcuClsgICAgNi4zMDE0NjddIHN5c3RlbWQtc3lzdi1nZW5lcmF0b3JbMTg5
XTogTmF0aXZlIHVuaXQgZm9yIGN1cHMtYnJvd3NlZC5zZXJ2aWNlIGFscmVhZHkgZXhpc3RzLCBz
a2lwcGluZy4KWyAgICA2LjMwNzA4M10gc3lzdGVtZC1zeXN2LWdlbmVyYXRvclsxODldOiBOYXRp
dmUgdW5pdCBmb3Iga21vZC5zZXJ2aWNlIGFscmVhZHkgZXhpc3RzLCBza2lwcGluZy4KWyAgICA2
LjMxMjM3Nl0gc3lzdGVtZC1zeXN2LWdlbmVyYXRvclsxODldOiBOYXRpdmUgdW5pdCBmb3IgbWlu
aXNzZHBkLnNlcnZpY2UgYWxyZWFkeSBleGlzdHMsIHNraXBwaW5nLgpbICAgIDYuMzI5NTIwXSBw
cmludGs6IHN5c3RlbWQtc3lzdi1nZTogODQgb3V0cHV0IGxpbmVzIHN1cHByZXNzZWQgZHVlIHRv
IHJhdGVsaW1pdGluZwpbICAgIDYuMzQwNjU3XSB1c2IgMS0xLjQ6IE5ldyBVU0IgZGV2aWNlIGZv
dW5kLCBpZFZlbmRvcj00MTNjLCBpZFByb2R1Y3Q9MjExMywgYmNkRGV2aWNlPSAxLjA4ClsgICAg
Ni4zNDkwNzBdIHVzYiAxLTEuNDogTmV3IFVTQiBkZXZpY2Ugc3RyaW5nczogTWZyPTAsIFByb2R1
Y3Q9MiwgU2VyaWFsTnVtYmVyPTAKWyAgICA2LjM1MjExM10gdXNiIDEtMS40OiBQcm9kdWN0OiBE
ZWxsIEtCMjE2IFdpcmVkIEtleWJvYXJkClsgICAgNi40MjMzOTJdIHN5c3RlbWRbMTk4XTogZGV2
LWh1Z2VwYWdlcy5tb3VudDogRXhlY3V0aW5nOiAvYmluL21vdW50IGh1Z2V0bGJmcyAvZGV2L2h1
Z2VwYWdlcyAtdCBodWdldGxiZnMKWyAgICA2LjQyNDQzNF0gc3lzdGVtZFsxOTldOiBzeXMta2Vy
bmVsLWRlYnVnLm1vdW50OiBFeGVjdXRpbmc6IC9iaW4vbW91bnQgZGVidWdmcyAvc3lzL2tlcm5l
bC9kZWJ1ZyAtdCBkZWJ1Z2ZzClsgICAgNi40NTEzOTBdIHN5c3RlbWRbMjAzXTogZGV2LW1xdWV1
ZS5tb3VudDogRXhlY3V0aW5nOiAvYmluL21vdW50IG1xdWV1ZSAvZGV2L21xdWV1ZSAtdCBtcXVl
dWUKWyAgICA2LjQ5ODk2OV0gbHA6IGRyaXZlciBsb2FkZWQgYnV0IG5vIGRldmljZXMgZm91bmQK
WyAgICA2LjUwOTMwMl0gcHBkZXY6IHVzZXItc3BhY2UgcGFyYWxsZWwgcG9ydCBkcml2ZXIKWyAg
ICA2LjUxNDA4NF0gc3lzdGVtZC1qb3VybmFsZFsyMTNdOiBGaXhlZCBtaW5fdXNlPTEuME0gbWF4
X3VzZT03OC41TSBtYXhfc2l6ZT05LjhNIG1pbl9zaXplPTUxMi4wSyBrZWVwX2ZyZWU9MTE3LjdN
IG5fbWF4X2ZpbGVzPTEwMApbICAgIDYuNTE3MjIzXSBzeXN0ZW1kLWpvdXJuYWxkWzIxM106IFJl
c2VydmluZyAxNzg3MCBlbnRyaWVzIGluIGhhc2ggdGFibGUuClsgICAgNi41MjIwNzRdIHN5c3Rl
bWQtam91cm5hbGRbMjEzXTogVmFjdXVtaW5nLi4uClsgICAgNi41MjIxMzZdIHN5c3RlbWQtam91
cm5hbGRbMjEzXTogVmFjdXVtaW5nIGRvbmUsIGZyZWVkIDBCIG9mIGFyY2hpdmVkIGpvdXJuYWxz
IGZyb20gL3J1bi9sb2cvam91cm5hbC85ODU4MjJjNWE1NzQ0NDFiOTJlM2RlYzIwMzM3ZDgzYS4K
WyAgICA2LjUyMjE3NV0gc3lzdGVtZC1qb3VybmFsZFsyMTNdOiBGbHVzaGluZyAvZGV2L2ttc2cu
Li4KWyAgICA2LjU1NzcyOF0gRVhUNC1mcyAoc2RhMik6IHJlLW1vdW50ZWQuIE9wdHM6IGVycm9y
cz1yZW1vdW50LXJvClsgICAgNi42MDk1NTBdIHN5c3RlbWQtam91cm5hbGRbMjEzXTogc3lzdGVt
ZC1qb3VybmFsZCBydW5uaW5nIGFzIHBpZCAyMTMKWyAgICA2LjYxMDc0M10gc3lzdGVtZC1qb3Vy
bmFsZFsyMTNdOiBTZW50IFJFQURZPTEgbm90aWZpY2F0aW9uLgpbICAgIDYuNjEwNzkxXSBzeXN0
ZW1kLWpvdXJuYWxkWzIxM106IFNlbnQgV0FUQ0hET0c9MSBub3RpZmljYXRpb24uClsgICAgNi42
MTE2MTRdIHN5c3RlbWQtam91cm5hbGRbMjEzXTogU3VjY2Vzc2Z1bGx5IHNlbnQgc3RyZWFtIGZp
bGUgZGVzY3JpcHRvciB0byBzZXJ2aWNlIG1hbmFnZXIuClsgICAgNi42MTIzMTFdIHN5c3RlbWQt
am91cm5hbGRbMjEzXTogU3VjY2Vzc2Z1bGx5IHNlbnQgc3RyZWFtIGZpbGUgZGVzY3JpcHRvciB0
byBzZXJ2aWNlIG1hbmFnZXIuClsgICAgNy4xNzg0NDFdIGlucHV0OiBTbGVlcCBCdXR0b24gYXMg
L2RldmljZXMvTE5YU1lTVE06MDAvTE5YU1lCVVM6MDAvUE5QMEMwRTowMC9pbnB1dC9pbnB1dDMK
WyAgICA3LjE4MDUxOV0gQUNQSTogU2xlZXAgQnV0dG9uIFtTTFBCXQpbICAgIDcuMTgyNjg4XSBp
bnB1dDogUG93ZXIgQnV0dG9uIGFzIC9kZXZpY2VzL0xOWFNZU1RNOjAwL0xOWFBXUkJOOjAwL2lu
cHV0L2lucHV0NApbICAgIDcuMTg0ODQ2XSBBQ1BJOiBQb3dlciBCdXR0b24gW1BXUkZdClsgICAg
Ny42Mjc4NDddIHNkIDA6MDowOjA6IEF0dGFjaGVkIHNjc2kgZ2VuZXJpYyBzZzAgdHlwZSAwClsg
ICAgNy42NjI2MjRdIGNoZWNraW5nIGdlbmVyaWMgKGMwMDAwMDAwIDMwMDAwMCkgdnMgaHcgKGMw
MDAwMDAwIDEwMDAwMDAwKQpbICAgIDcuNjY0NzA1XSBmYjA6IHN3aXRjaGluZyB0byBpbnRlbGRy
bWZiIGZyb20gRUZJIFZHQQpbICAgIDcuNjY3NzQ4XSBDb25zb2xlOiBzd2l0Y2hpbmcgdG8gY29s
b3VyIGR1bW15IGRldmljZSA4MHgyNQpbICAgIDcuNjY3ODYxXSBpOTE1IDAwMDA6MDA6MDIuMDog
dmdhYXJiOiBkZWFjdGl2YXRlIHZnYSBjb25zb2xlClsgICAgNy42NjgzMjldIFtkcm1dIFN1cHBv
cnRzIHZibGFuayB0aW1lc3RhbXAgY2FjaGluZyBSZXYgMiAoMjEuMTAuMjAxMykuClsgICAgNy42
NjgzMzhdIFtkcm1dIERyaXZlciBzdXBwb3J0cyBwcmVjaXNlIHZibGFuayB0aW1lc3RhbXAgcXVl
cnkuClsgICAgNy42Njk1MDJdIGk5MTUgMDAwMDowMDowMi4wOiB2Z2FhcmI6IGNoYW5nZWQgVkdB
IGRlY29kZXM6IG9sZGRlY29kZXM9aW8rbWVtLGRlY29kZXM9aW8rbWVtOm93bnM9aW8rbWVtClsg
ICAgNy42OTI5NDJdIFtkcm1dIEluaXRpYWxpemVkIGk5MTUgMS42LjAgMjAxOTA4MjIgZm9yIDAw
MDA6MDA6MDIuMCBvbiBtaW5vciAwClsgICAgNy42OTU5MDNdIEFDUEk6IFZpZGVvIERldmljZSBb
R0ZYMF0gKG11bHRpLWhlYWQ6IHllcyAgcm9tOiBubyAgcG9zdDogbm8pClsgICAgNy42OTY0OTFd
IGlucHV0OiBWaWRlbyBCdXMgYXMgL2RldmljZXMvTE5YU1lTVE06MDAvTE5YU1lCVVM6MDAvUE5Q
MEEwODowMC9MTlhWSURFTzowMC9pbnB1dC9pbnB1dDUKWyAgICA3LjY5Njc1Ml0gc25kX2hkYV9p
bnRlbCAwMDAwOjAwOjFiLjA6IGJvdW5kIDAwMDA6MDA6MDIuMCAob3BzIGk5MTVfYXVkaW9fY29t
cG9uZW50X2JpbmRfb3BzIFtpOTE1XSkKWyAgICA3LjcyNDQwNF0gaW5wdXQ6IEhEQSBJbnRlbCBQ
Q0ggSERNSS9EUCxwY209MyBhcyAvZGV2aWNlcy9wY2kwMDAwOjAwLzAwMDA6MDA6MWIuMC9zb3Vu
ZC9jYXJkMC9pbnB1dDYKWyAgICA3LjcyNDQ3MF0gaW5wdXQ6IEhEQSBJbnRlbCBQQ0ggSERNSS9E
UCxwY209NyBhcyAvZGV2aWNlcy9wY2kwMDAwOjAwLzAwMDA6MDA6MWIuMC9zb3VuZC9jYXJkMC9p
bnB1dDcKWyAgICA3LjgzNDc0Nl0gZmJjb246IGk5MTVkcm1mYiAoZmIwKSBpcyBwcmltYXJ5IGRl
dmljZQpbICAgIDcuODgxNDgzXSBDb25zb2xlOiBzd2l0Y2hpbmcgdG8gY29sb3VyIGZyYW1lIGJ1
ZmZlciBkZXZpY2UgMjQweDY3ClsgICAgNy45MTM2NjddIGk5MTUgMDAwMDowMDowMi4wOiBmYjA6
IGk5MTVkcm1mYiBmcmFtZSBidWZmZXIgZGV2aWNlClsgICAgNy45OTcxNDNdIGhpZHJhdzogcmF3
IEhJRCBldmVudHMgZHJpdmVyIChDKSBKaXJpIEtvc2luYQpbICAgIDguMDA5MDEzXSBFRkkgVmFy
aWFibGVzIEZhY2lsaXR5IHYwLjA4IDIwMDQtTWF5LTE3ClsgICAgOC4wMTE5MjRdIHVzYmNvcmU6
IHJlZ2lzdGVyZWQgbmV3IGludGVyZmFjZSBkcml2ZXIgdXNiaGlkClsgICAgOC4wMTE5OTRdIHVz
YmhpZDogVVNCIEhJRCBjb3JlIGRyaXZlcgpbICAgIDguMDI5MjA4XSBwc3RvcmU6IFVzaW5nIGNy
YXNoIGR1bXAgY29tcHJlc3Npb246IGRlZmxhdGUKWyAgICA4LjAyOTc5NV0gcHN0b3JlOiBSZWdp
c3RlcmVkIGVmaSBhcyBwZXJzaXN0ZW50IHN0b3JlIGJhY2tlbmQKWyAgICA4LjA2MjAwN10gaW5w
dXQ6IFBDIFNwZWFrZXIgYXMgL2RldmljZXMvcGxhdGZvcm0vcGNzcGtyL2lucHV0L2lucHV0OApb
ICAgIDguMDY5NDk3XSBFcnJvcjogRHJpdmVyICdwY3Nwa3InIGlzIGFscmVhZHkgcmVnaXN0ZXJl
ZCwgYWJvcnRpbmcuLi4KWyAgICA4LjIwOTkwM10gY3J5cHRkOiBtYXhfY3B1X3FsZW4gc2V0IHRv
IDEwMDAKWyAgICA4LjIyMTA0MF0gQWRkaW5nIDgyNjk4MjBrIHN3YXAgb24gL2Rldi9zZGEzLiAg
UHJpb3JpdHk6LTIgZXh0ZW50czoxIGFjcm9zczo4MjY5ODIwayBTU0ZTClsgICAgOC44MTY5OTBd
IGlUQ09fdmVuZG9yX3N1cHBvcnQ6IHZlbmRvci1zdXBwb3J0PTAKWyAgICA4LjgyMTYxMl0gaVRD
T193ZHQ6IEludGVsIFRDTyBXYXRjaERvZyBUaW1lciBEcml2ZXIgdjEuMTEKWyAgICA4LjgyNTIz
Nl0gaVRDT193ZHQ6IEZvdW5kIGEgQmF5IFRyYWlsIFNvQyBUQ08gZGV2aWNlIChWZXJzaW9uPTMs
IFRDT0JBU0U9MHgwNDYwKQpbICAgIDguODMwNDkzXSBpVENPX3dkdDogaW5pdGlhbGl6ZWQuIGhl
YXJ0YmVhdD0zMCBzZWMgKG5vd2F5b3V0PTApClsgICAgOC44NTA5OTRdIGlucHV0OiBQaXhBcnQg
RGVsbCBNUzExNiBVU0IgT3B0aWNhbCBNb3VzZSBhcyAvZGV2aWNlcy9wY2kwMDAwOjAwLzAwMDA6
MDA6MWQuMC91c2IxLzEtMS8xLTEuMy8xLTEuMzoxLjAvMDAwMzo0MTNDOjMwMUEuMDAwMS9pbnB1
dC9pbnB1dDkKWyAgICA4Ljg1NzkzNV0gaGlkLWdlbmVyaWMgMDAwMzo0MTNDOjMwMUEuMDAwMTog
aW5wdXQsaGlkcmF3MDogVVNCIEhJRCB2MS4xMSBNb3VzZSBbUGl4QXJ0IERlbGwgTVMxMTYgVVNC
IE9wdGljYWwgTW91c2VdIG9uIHVzYi0wMDAwOjAwOjFkLjAtMS4zL2lucHV0MApbICAgIDguODU4
MzIzXSBpbnB1dDogRGVsbCBLQjIxNiBXaXJlZCBLZXlib2FyZCBhcyAvZGV2aWNlcy9wY2kwMDAw
OjAwLzAwMDA6MDA6MWQuMC91c2IxLzEtMS8xLTEuNC8xLTEuNDoxLjAvMDAwMzo0MTNDOjIxMTMu
MDAwMi9pbnB1dC9pbnB1dDEwClsgICAgOC45MTgwNjZdIGhpZC1nZW5lcmljIDAwMDM6NDEzQzoy
MTEzLjAwMDI6IGlucHV0LGhpZHJhdzE6IFVTQiBISUQgdjEuMTEgS2V5Ym9hcmQgW0RlbGwgS0Iy
MTYgV2lyZWQgS2V5Ym9hcmRdIG9uIHVzYi0wMDAwOjAwOjFkLjAtMS40L2lucHV0MApbICAgIDgu
OTE4Mzc1XSBpbnB1dDogRGVsbCBLQjIxNiBXaXJlZCBLZXlib2FyZCBTeXN0ZW0gQ29udHJvbCBh
cyAvZGV2aWNlcy9wY2kwMDAwOjAwLzAwMDA6MDA6MWQuMC91c2IxLzEtMS8xLTEuNC8xLTEuNDox
LjEvMDAwMzo0MTNDOjIxMTMuMDAwMy9pbnB1dC9pbnB1dDExClsgICAgOC45NzkyMzZdIGlucHV0
OiBEZWxsIEtCMjE2IFdpcmVkIEtleWJvYXJkIENvbnN1bWVyIENvbnRyb2wgYXMgL2RldmljZXMv
cGNpMDAwMDowMC8wMDAwOjAwOjFkLjAvdXNiMS8xLTEvMS0xLjQvMS0xLjQ6MS4xLzAwMDM6NDEz
QzoyMTEzLjAwMDMvaW5wdXQvaW5wdXQxMgpbICAgIDguOTgwODE4XSBoaWQtZ2VuZXJpYyAwMDAz
OjQxM0M6MjExMy4wMDAzOiBpbnB1dCxoaWRyYXcyOiBVU0IgSElEIHYxLjExIERldmljZSBbRGVs
bCBLQjIxNiBXaXJlZCBLZXlib2FyZF0gb24gdXNiLTAwMDA6MDA6MWQuMC0xLjQvaW5wdXQxClsg
ICAgOS4wNzAyMTNdIGludGVsX3JhcGxfY29tbW9uOiBGb3VuZCBSQVBMIGRvbWFpbiBwYWNrYWdl
ClsgICAgOS4wNzM2MDVdIGludGVsX3JhcGxfY29tbW9uOiBGb3VuZCBSQVBMIGRvbWFpbiBjb3Jl
ClsgICAxMi4xMDQ4ODRdIHJhbmRvbTogY3JuZyBpbml0IGRvbmUKWyAgIDEyLjEwNDg4OV0gcmFu
ZG9tOiA3IHVyYW5kb20gd2FybmluZyhzKSBtaXNzZWQgZHVlIHRvIHJhdGVsaW1pdGluZwpbICAg
MTIuMTI1MzUxXSBzeXN0ZW1kLWpvdXJuYWxkWzIxM106IFN1Y2Nlc3NmdWxseSBzZW50IHN0cmVh
bSBmaWxlIGRlc2NyaXB0b3IgdG8gc2VydmljZSBtYW5hZ2VyLgpbICAgMTIuMTI1NzA3XSBzeXN0
ZW1kLWpvdXJuYWxkWzIxM106IFN1Y2Nlc3NmdWxseSBzZW50IHN0cmVhbSBmaWxlIGRlc2NyaXB0
b3IgdG8gc2VydmljZSBtYW5hZ2VyLgpbICAgMTIuMzg5MDgyXSBzeXN0ZW1kLWpvdXJuYWxkWzIx
M106IFN1Y2Nlc3NmdWxseSBzZW50IHN0cmVhbSBmaWxlIGRlc2NyaXB0b3IgdG8gc2VydmljZSBt
YW5hZ2VyLgpbICAgMTIuNDc3Mzg0XSBpZ2IgMDAwMDowMzowMC4wIGVucDNzMDogaWdiOiBlbnAz
czAgTklDIExpbmsgaXMgVXAgMTAwMCBNYnBzIEZ1bGwgRHVwbGV4LCBGbG93IENvbnRyb2w6IFJY
L1RYClsgICAxMi41ODUxMTVdIElQdjY6IEFERFJDT05GKE5FVERFVl9DSEFOR0UpOiBlbnAzczA6
IGxpbmsgYmVjb21lcyByZWFkeQpbICAgMTIuODQ3NzI1XSBzeXN0ZW1kLWpvdXJuYWxkWzIxM106
IFN1Y2Nlc3NmdWxseSBzZW50IHN0cmVhbSBmaWxlIGRlc2NyaXB0b3IgdG8gc2VydmljZSBtYW5h
Z2VyLgpbICAgMTIuODY3MDI3XSBzeXN0ZW1kLWpvdXJuYWxkWzIxM106IFN1Y2Nlc3NmdWxseSBz
ZW50IHN0cmVhbSBmaWxlIGRlc2NyaXB0b3IgdG8gc2VydmljZSBtYW5hZ2VyLgpbICAgMTIuOTc0
NTc1XSBzeXN0ZW1kLWpvdXJuYWxkWzIxM106IFN1Y2Nlc3NmdWxseSBzZW50IHN0cmVhbSBmaWxl
IGRlc2NyaXB0b3IgdG8gc2VydmljZSBtYW5hZ2VyLgpbICAgMTMuMDAyOTE3XSBzeXN0ZW1kLWpv
dXJuYWxkWzIxM106IFN1Y2Nlc3NmdWxseSBzZW50IHN0cmVhbSBmaWxlIGRlc2NyaXB0b3IgdG8g
c2VydmljZSBtYW5hZ2VyLgpbICAgMTMuNzg5MzA5XSBzeXN0ZW1kLWpvdXJuYWxkWzIxM106IFN1
Y2Nlc3NmdWxseSBzZW50IHN0cmVhbSBmaWxlIGRlc2NyaXB0b3IgdG8gc2VydmljZSBtYW5hZ2Vy
LgpbICAgMTMuODI3NjA5XSBzeXN0ZW1kLWpvdXJuYWxkWzIxM106IFN1Y2Nlc3NmdWxseSBzZW50
IHN0cmVhbSBmaWxlIGRlc2NyaXB0b3IgdG8gc2VydmljZSBtYW5hZ2VyLgpbICAgMTMuODI4MDA0
XSBzeXN0ZW1kLWpvdXJuYWxkWzIxM106IFN1Y2Nlc3NmdWxseSBzZW50IHN0cmVhbSBmaWxlIGRl
c2NyaXB0b3IgdG8gc2VydmljZSBtYW5hZ2VyLgpbICAgMTQuNTI5OTM5XSBbZHJtOmludGVsX2Nw
dV9maWZvX3VuZGVycnVuX2lycV9oYW5kbGVyIFtpOTE1XV0gKkVSUk9SKiBDUFUgcGlwZSBBIEZJ
Rk8gdW5kZXJydW4KWyAgIDE3LjQxNDM5OF0gc3lzdGVtZC1qb3VybmFsZFsyMTNdOiBTdWNjZXNz
ZnVsbHkgc2VudCBzdHJlYW0gZmlsZSBkZXNjcmlwdG9yIHRvIHNlcnZpY2UgbWFuYWdlci4KWyAg
IDE3LjQxNjA2Ml0gc3lzdGVtZC1qb3VybmFsZFsyMTNdOiBTdWNjZXNzZnVsbHkgc2VudCBzdHJl
YW0gZmlsZSBkZXNjcmlwdG9yIHRvIHNlcnZpY2UgbWFuYWdlci4KWyAgIDE3LjQyODIwNV0gc3lz
dGVtZC1qb3VybmFsZFsyMTNdOiBTdWNjZXNzZnVsbHkgc2VudCBzdHJlYW0gZmlsZSBkZXNjcmlw
dG9yIHRvIHNlcnZpY2UgbWFuYWdlci4KWyAgIDE4LjAyMzcxNV0gc3lzdGVtZC1qb3VybmFsZFsy
MTNdOiBTdWNjZXNzZnVsbHkgc2VudCBzdHJlYW0gZmlsZSBkZXNjcmlwdG9yIHRvIHNlcnZpY2Ug
bWFuYWdlci4KWyAgIDE4LjAyODA5OF0gc3lzdGVtZC1qb3VybmFsZFsyMTNdOiBTdWNjZXNzZnVs
bHkgc2VudCBzdHJlYW0gZmlsZSBkZXNjcmlwdG9yIHRvIHNlcnZpY2UgbWFuYWdlci4KWyAgIDE4
LjUzMzc4MF0gc3lzdGVtZC1qb3VybmFsZFsyMTNdOiBTdWNjZXNzZnVsbHkgc2VudCBzdHJlYW0g
ZmlsZSBkZXNjcmlwdG9yIHRvIHNlcnZpY2UgbWFuYWdlci4KWyAgIDE4LjU0NTk5Nl0gc3lzdGVt
ZC1qb3VybmFsZFsyMTNdOiBEYXRhIGhhc2ggdGFibGUgb2YgL3J1bi9sb2cvam91cm5hbC85ODU4
MjJjNWE1NzQ0NDFiOTJlM2RlYzIwMzM3ZDgzYS9zeXN0ZW0uam91cm5hbCBoYXMgYSBmaWxsIGxl
dmVsIGF0IDc1LjAgKDEzNDA0IG9mIDE3ODcwIGl0ZW1zLCA4Mzg4NjA4IGZpbGUgc2l6ZSwgNjI1
IGJ5dGVzIHBlciBoYXNoIHRhYmxlIGl0ZW0pLCBzdWdnZXN0aW5nIHJvdGF0aW9uLgpbICAgMTgu
NTQ2MDE4XSBzeXN0ZW1kLWpvdXJuYWxkWzIxM106IC9ydW4vbG9nL2pvdXJuYWwvOTg1ODIyYzVh
NTc0NDQxYjkyZTNkZWMyMDMzN2Q4M2Evc3lzdGVtLmpvdXJuYWw6IEpvdXJuYWwgaGVhZGVyIGxp
bWl0cyByZWFjaGVkIG9yIGhlYWRlciBvdXQtb2YtZGF0ZSwgcm90YXRpbmcuClsgICAxOC41NDYw
MzRdIHN5c3RlbWQtam91cm5hbGRbMjEzXTogUm90YXRpbmcuLi4KWyAgIDE4LjU0OTUwOF0gc3lz
dGVtZC1qb3VybmFsZFsyMTNdOiBSZXNlcnZpbmcgMTc4NzAgZW50cmllcyBpbiBoYXNoIHRhYmxl
LgpbICAgMjIuOTAyMzg1XSBzeXN0ZW1kLWpvdXJuYWxkWzIxM106IFN1Y2Nlc3NmdWxseSBzZW50
IHN0cmVhbSBmaWxlIGRlc2NyaXB0b3IgdG8gc2VydmljZSBtYW5hZ2VyLgpbICAgMjIuOTUwNjMy
XSBzeXN0ZW1kLWpvdXJuYWxkWzIxM106IFN1Y2Nlc3NmdWxseSBzZW50IHN0cmVhbSBmaWxlIGRl
c2NyaXB0b3IgdG8gc2VydmljZSBtYW5hZ2VyLgpbICAgMjMuMjY4MTI1XSBzeXN0ZW1kLWpvdXJu
YWxkWzIxM106IFN1Y2Nlc3NmdWxseSBzZW50IHN0cmVhbSBmaWxlIGRlc2NyaXB0b3IgdG8gc2Vy
dmljZSBtYW5hZ2VyLgpbICAgMjMuMjY5MjM2XSBzeXN0ZW1kLWpvdXJuYWxkWzIxM106IFN1Y2Nl
c3NmdWxseSBzZW50IHN0cmVhbSBmaWxlIGRlc2NyaXB0b3IgdG8gc2VydmljZSBtYW5hZ2VyLgpb
ICAgMjQuMTU3NzkzXSBzeXN0ZW1kLWpvdXJuYWxkWzIxM106IFN1Y2Nlc3NmdWxseSBzZW50IHN0
cmVhbSBmaWxlIGRlc2NyaXB0b3IgdG8gc2VydmljZSBtYW5hZ2VyLgpbICAgMjQuNTc3NDA3XSBz
eXN0ZW1kLWpvdXJuYWxkWzIxM106IFN1Y2Nlc3NmdWxseSBzZW50IHN0cmVhbSBmaWxlIGRlc2Ny
aXB0b3IgdG8gc2VydmljZSBtYW5hZ2VyLgpbICAgMjQuNjc5MjcyXSBzeXN0ZW1kLWpvdXJuYWxk
WzIxM106IFN1Y2Nlc3NmdWxseSBzZW50IHN0cmVhbSBmaWxlIGRlc2NyaXB0b3IgdG8gc2Vydmlj
ZSBtYW5hZ2VyLgpbICAgMjQuNzA4MjY4XSBzeXN0ZW1kLWpvdXJuYWxkWzIxM106IFN1Y2Nlc3Nm
dWxseSBzZW50IHN0cmVhbSBmaWxlIGRlc2NyaXB0b3IgdG8gc2VydmljZSBtYW5hZ2VyLgpbICAg
MjQuNzA4NTg1XSBzeXN0ZW1kLWpvdXJuYWxkWzIxM106IFN1Y2Nlc3NmdWxseSBzZW50IHN0cmVh
bSBmaWxlIGRlc2NyaXB0b3IgdG8gc2VydmljZSBtYW5hZ2VyLgpbICAgMjQuODMzODY2XSBzeXN0
ZW1kLWpvdXJuYWxkWzIxM106IFN1Y2Nlc3NmdWxseSBzZW50IHN0cmVhbSBmaWxlIGRlc2NyaXB0
b3IgdG8gc2VydmljZSBtYW5hZ2VyLgpbICAgMjUuMjQ1ODExXSBmdXNlOiBpbml0IChBUEkgdmVy
c2lvbiA3LjMxKQpbICAgMjguMDg0NTg5XSBzeXN0ZW1kLWpvdXJuYWxkWzIxM106IFN1Y2Nlc3Nm
dWxseSBzZW50IHN0cmVhbSBmaWxlIGRlc2NyaXB0b3IgdG8gc2VydmljZSBtYW5hZ2VyLgpbICAg
MjguMDg1MzA0XSBzeXN0ZW1kLWpvdXJuYWxkWzIxM106IFN1Y2Nlc3NmdWxseSBzZW50IHN0cmVh
bSBmaWxlIGRlc2NyaXB0b3IgdG8gc2VydmljZSBtYW5hZ2VyLgpbICAgMjguMDkxMDYwXSBzeXN0
ZW1kLWpvdXJuYWxkWzIxM106IFN1Y2Nlc3NmdWxseSBzZW50IHN0cmVhbSBmaWxlIGRlc2NyaXB0
b3IgdG8gc2VydmljZSBtYW5hZ2VyLgpbICAgMjguMDkxMzU1XSBzeXN0ZW1kLWpvdXJuYWxkWzIx
M106IFN1Y2Nlc3NmdWxseSBzZW50IHN0cmVhbSBmaWxlIGRlc2NyaXB0b3IgdG8gc2VydmljZSBt
YW5hZ2VyLgpbICAgMjguMDk2MjI5XSBzeXN0ZW1kLWpvdXJuYWxkWzIxM106IFN1Y2Nlc3NmdWxs
eSBzZW50IHN0cmVhbSBmaWxlIGRlc2NyaXB0b3IgdG8gc2VydmljZSBtYW5hZ2VyLgpbICAgMjgu
MDk2NjQ4XSBzeXN0ZW1kLWpvdXJuYWxkWzIxM106IFN1Y2Nlc3NmdWxseSBzZW50IHN0cmVhbSBm
aWxlIGRlc2NyaXB0b3IgdG8gc2VydmljZSBtYW5hZ2VyLgpbICAgMjguNTAwNTIzXSBzeXN0ZW1k
LWpvdXJuYWxkWzIxM106IFN1Y2Nlc3NmdWxseSBzZW50IHN0cmVhbSBmaWxlIGRlc2NyaXB0b3Ig
dG8gc2VydmljZSBtYW5hZ2VyLgpbICAgMjguNjY0Njg0XSBzeXN0ZW1kLWpvdXJuYWxkWzIxM106
IFN1Y2Nlc3NmdWxseSBzZW50IHN0cmVhbSBmaWxlIGRlc2NyaXB0b3IgdG8gc2VydmljZSBtYW5h
Z2VyLgpbICAgMjguNjY3NDUyXSBzeXN0ZW1kLWpvdXJuYWxkWzIxM106IFN1Y2Nlc3NmdWxseSBz
ZW50IHN0cmVhbSBmaWxlIGRlc2NyaXB0b3IgdG8gc2VydmljZSBtYW5hZ2VyLgpbICAgMjguNjc1
MTUyXSBzeXN0ZW1kLWpvdXJuYWxkWzIxM106IFN1Y2Nlc3NmdWxseSBzZW50IHN0cmVhbSBmaWxl
IGRlc2NyaXB0b3IgdG8gc2VydmljZSBtYW5hZ2VyLgpbICAgMzQuMjE5NzMwXSBzeXN0ZW1kLWpv
dXJuYWxkWzIxM106IFN1Y2Nlc3NmdWxseSBzZW50IHN0cmVhbSBmaWxlIGRlc2NyaXB0b3IgdG8g
c2VydmljZSBtYW5hZ2VyLgpbICAgMzQuMjIwMTQzXSBzeXN0ZW1kLWpvdXJuYWxkWzIxM106IFN1
Y2Nlc3NmdWxseSBzZW50IHN0cmVhbSBmaWxlIGRlc2NyaXB0b3IgdG8gc2VydmljZSBtYW5hZ2Vy
LgpbICAgMzQuMjIzODYwXSBzeXN0ZW1kLWpvdXJuYWxkWzIxM106IFN1Y2Nlc3NmdWxseSBzZW50
IHN0cmVhbSBmaWxlIGRlc2NyaXB0b3IgdG8gc2VydmljZSBtYW5hZ2VyLgpbICAgMzQuMjM2OTQ0
XSBzeXN0ZW1kLWpvdXJuYWxkWzIxM106IFN1Y2Nlc3NmdWxseSBzZW50IHN0cmVhbSBmaWxlIGRl
c2NyaXB0b3IgdG8gc2VydmljZSBtYW5hZ2VyLgpbICAgMzQuMjQxMjIyXSBzeXN0ZW1kLWpvdXJu
YWxkWzIxM106IFN1Y2Nlc3NmdWxseSBzZW50IHN0cmVhbSBmaWxlIGRlc2NyaXB0b3IgdG8gc2Vy
dmljZSBtYW5hZ2VyLgpbICAgMzQuMjQzMDIwXSBzeXN0ZW1kLWpvdXJuYWxkWzIxM106IFN1Y2Nl
c3NmdWxseSBzZW50IHN0cmVhbSBmaWxlIGRlc2NyaXB0b3IgdG8gc2VydmljZSBtYW5hZ2VyLgpb
ICAgMzQuMjQ0ODAyXSBzeXN0ZW1kLWpvdXJuYWxkWzIxM106IFN1Y2Nlc3NmdWxseSBzZW50IHN0
cmVhbSBmaWxlIGRlc2NyaXB0b3IgdG8gc2VydmljZSBtYW5hZ2VyLgpbICAgMzQuMjQ5Mjk2XSBz
eXN0ZW1kLWpvdXJuYWxkWzIxM106IFN1Y2Nlc3NmdWxseSBzZW50IHN0cmVhbSBmaWxlIGRlc2Ny
aXB0b3IgdG8gc2VydmljZSBtYW5hZ2VyLgpbICAgMzQuMjUxMDQwXSBzeXN0ZW1kLWpvdXJuYWxk
WzIxM106IFN1Y2Nlc3NmdWxseSBzZW50IHN0cmVhbSBmaWxlIGRlc2NyaXB0b3IgdG8gc2Vydmlj
ZSBtYW5hZ2VyLgpbICAgMzQuMjUyNTU2XSBzeXN0ZW1kLWpvdXJuYWxkWzIxM106IFN1Y2Nlc3Nm
dWxseSBzZW50IHN0cmVhbSBmaWxlIGRlc2NyaXB0b3IgdG8gc2VydmljZSBtYW5hZ2VyLgpbICAg
MzkuMzQ2MDY3XSBzeXN0ZW1kLWpvdXJuYWxkWzIxM106IFRpbWUganVtcGVkIGJhY2t3YXJkcywg
cm90YXRpbmcuClsgICAzOS4zNDYxNDVdIHN5c3RlbWQtam91cm5hbGRbMjEzXTogUm90YXRpbmcu
Li4KWyAgIDM5LjM1NDgyNF0gc3lzdGVtZC1qb3VybmFsZFsyMTNdOiBSZXNlcnZpbmcgMTc4NzAg
ZW50cmllcyBpbiBoYXNoIHRhYmxlLgpbICAgMzkuMzU1ODkyXSBzeXN0ZW1kLWpvdXJuYWxkWzIx
M106IFZhY3V1bWluZy4uLgpbICAgMzkuMzU2MTU4XSBzeXN0ZW1kLWpvdXJuYWxkWzIxM106IFZh
Y3V1bWluZyBkb25lLCBmcmVlZCAwQiBvZiBhcmNoaXZlZCBqb3VybmFscyBmcm9tIC9ydW4vbG9n
L2pvdXJuYWwvOTg1ODIyYzVhNTc0NDQxYjkyZTNkZWMyMDMzN2Q4M2EuClsgICAzOS4zNTc3MTRd
IHN5c3RlbWQtam91cm5hbGRbMjEzXTogU3VjY2Vzc2Z1bGx5IHNlbnQgc3RyZWFtIGZpbGUgZGVz
Y3JpcHRvciB0byBzZXJ2aWNlIG1hbmFnZXIuClsgICA0Mi45NjgyMjddIHN5c3RlbWQtam91cm5h
bGRbMjEzXTogU3VjY2Vzc2Z1bGx5IHNlbnQgc3RyZWFtIGZpbGUgZGVzY3JpcHRvciB0byBzZXJ2
aWNlIG1hbmFnZXIuClsgICA0My4wNTExOTldIHN5c3RlbWQtam91cm5hbGRbMjEzXTogU3VjY2Vz
c2Z1bGx5IHNlbnQgc3RyZWFtIGZpbGUgZGVzY3JpcHRvciB0byBzZXJ2aWNlIG1hbmFnZXIuClsg
IDEwMi44MzI0NzVdIHN5c3RlbWQtam91cm5hbGRbMjEzXTogU2VudCBXQVRDSERPRz0xIG5vdGlm
aWNhdGlvbi4KCg==
--0000000000006c7a13059d45d816--
