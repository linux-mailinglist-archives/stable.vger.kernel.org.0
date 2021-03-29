Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 695B334D3F5
	for <lists+stable@lfdr.de>; Mon, 29 Mar 2021 17:32:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230362AbhC2Pb3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Mar 2021 11:31:29 -0400
Received: from mout.gmx.net ([212.227.17.22]:51667 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231268AbhC2PbA (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 29 Mar 2021 11:31:00 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gmx.net;
        s=badeba3b8450; t=1617031854;
        bh=VoP9RTF11SoM5DBpXOfrGRNv/vnDdcjIfNZp+d2/YhU=;
        h=X-UI-Sender-Class:Subject:To:Cc:References:From:Date:In-Reply-To;
        b=YpvPXKxcumN3WpNM6g7AeBg2HVe+MJPO2YgR+IVD39bQf3ScyX1y2BSGvKqbaLs6i
         AzmBcuZPc3VrFzeiHvUC2FgA/8juiXfiT6ieNWEu4aMOVMHvXxLeRgwNzKVe1hvcSY
         1pddMBFHYPcBSriiMwqCrS9ptLJcXh35JJnmrmd8=
X-UI-Sender-Class: 01bb95c1-4bf8-414a-932a-4f6e2808ef9c
Received: from obelix.fritz.box ([46.142.5.45]) by mail.gmx.net (mrgmx105
 [212.227.17.168]) with ESMTPSA (Nemesis) id 1MoO6C-1lxiUg2GQy-00oqBL; Mon, 29
 Mar 2021 17:30:54 +0200
Subject: Re: [PATCH 5.11 000/252] 5.11.11-rc2 review
To:     Greg KH <greg@kroah.com>
Cc:     stable@vger.kernel.org, linux-kernel@vger.kernel.org
References: <d11fe153-b3a3-94f0-a425-ad4881a82412@gmx.de>
 <YGHoPbwu3D9DXnCB@kroah.com>
From:   Ronald Warsow <rwarsow@gmx.de>
Message-ID: <27a03651-9312-44c2-7179-61c1ed4919c7@gmx.de>
Date:   Mon, 29 Mar 2021 17:30:54 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.0
MIME-Version: 1.0
In-Reply-To: <YGHoPbwu3D9DXnCB@kroah.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: de-DE
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:F0JNTLJhC9jUMNVKMMH+TsUow+IrhaQ7L/tyLxrkcgs7DngielK
 1VZ/i+xcQfJwJG8Se5hJZ55RpS8ptdOyFQmBIa3Bl/nGAml2LDbHjvm3hP0iimsLd6kahI8
 b+tRRxdi+jzhvSGvsdsdQbWWG7PAnbDYqACxvBZYNCHqOSIXccpXNq0y2INPZ83kbgxMGIH
 G0yx3bpcBqQVCNtlMMR4w==
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:XUkMTPMCKJA=:IwU1FcbrGZdzDlbzeOiHEY
 JhUEwzDUj7eHuONqabjzjfuqcRu07fItDWiGs0GNMUReSGitCq0Sb/uRNutAzqJ85P89wBEMK
 0pi7DzFPvRkejI8QZH9cOuWtYcYhF8E2HRHpWHUsmCQXasov1LNsQ4eVfjVeEUAC/GNatwKJF
 vb7zRkU9GU4uv33NBBpCl5lJ6+nTqn17yFUCKCqOWkZWKv327Kjz2XzotyND5RNUe2rVf0avH
 3qOIB8g91xaSd0h20vj7zgu7ShNCEDIO8tg408lCS5dKYgMRh9jKPQFE6M9MCvD2Kv9mnDCjJ
 XSIJbbJZbfk90nZJg9JRIsmzfj0hK5aKakYeNw/1ESbKgG2RdeRkvF4JGN/yZI3+MWY3wpblg
 5IJ9S7SvZNvF3JDHj7skFTw8jSgAa3jSEwj34DPgbjx41gDUgnCMnEHeE7mdtR/FtBftPmjtn
 XBsmHbcEtbXjixBKaNB1rHq2tGgJxzdFZxVu7ysy25gU2NeF++ZScAAFRvDNsga0Zy/7e9IMI
 WkVfNQVxWVhyWX2k27pFtN66ILqXE98kuZuf0udQ5IImdD3vn1a1aiAoEhe5NGZ89ehqXUU4q
 O7SO4cXlORMfHtj92cTGJF/9pAiUurbnazdBeO0WahQKk0TlBvW54QYi+lRtlkz6RuPPq4Z18
 pdLanUmRgWM+i0WmkwadgffcYlahIxv+0/Ld6B7MWQKJTctHwCFyl2Za5VveKuPOrMt8jUFhG
 F8p0bQ/2zoRe3dsqp6Zy0qw/0jnXYqgDQKtGzk4W/WBZk9sIXYyr6t4HC0aQ2mMJlTSNTQVBi
 nrAJrz/Ff3BpsPc7h/59T2zJdfm6YGhtcos4Rb53m7/NIKd01AzXTvnN3nl6ENFAm+Z+iX5Kk
 bSwwOxj2L0AjD7Vl67Cvu/TUPRpNdaiT8nbYo/FAnR0oz/BGErRCeLdaiCfYuXZ7zjjAeRe+6
 GA+LrgdlHn+IKER0MjAT5QvEdEg6shz56gN2nKZ2pKKZuttRwdT4oA1vY9Xhpk1/voG8tI5Xo
 c9dK54xBzMm4hO+0mGwHO9zJ1ojAc80mpByzqHpWFYbGs4mkpnlRYn/3W0S8uL2nWxUceSGoa
 U2+SCK4jWz81Th3iJPbmdFMrrKpgfBwtqZny5zXGXry/XRo9WQAPam0zW0lYBSIrQYsBWX6Y1
 qakWJ09KArjXbbDyi479ryt+tSq7zfgHUxa8u2KmBnhOJzhBPRBQj/73LNa5gqbXC/+qKzAHp
 Mad56tbG5n3i2sww1t6hJcDIMTfS7WP8dfc4FFn4Vb2mQtNvdFvxfQtlcfHf3e3Hya+dGVpEo
 Qelr/0AI
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 29.03.21 16:46, Greg KH wrote:
> On Mon, Mar 29, 2021 at 04:40:00PM +0200, Ronald Warsow wrote:
>> hello
>>
>> 5.11.11-rc2 compiles, boots and run fine here (on an i7-6700 with Fedor=
a
>> 34 Beta)
>>
>> Thanks.
>>
>> but I see some error's/warning's with the new gcc-11.0.1 compared to th=
e
>> elder gcc-10.2.1-11
>
> Do you also see those gcc-11 warnings on Linus's tree?  I don't think
> I've started to backport any gcc-11 fixes like this to older kernels
> just yet.
>
> thanks,
>
> greg k-h
>

it seems so (I'm not an developer, just a home user compiling kernels).

AFAIK, there is a new gcc 11.x.y release with fixes for Fedora 34 in the
pipe, but not yet released, so no need to invest time.
just an report what I see here.


with linux-5.12-rc5 from https://www.kernel.org/

I see:

...

   CC      mm/gup.o
   AR      arch/x86/kernel/acpi/built-in.a
   CC      fs/proc/inode.o
In function =E2=80=98poly1305_simd_init=E2=80=99,
     inlined from =E2=80=98crypto_poly1305_setdctxkey=E2=80=99 at
arch/x86/crypto/poly1305_glue.c:150:4,
     inlined from =E2=80=98crypto_poly1305_setdctxkey=E2=80=99 at
arch/x86/crypto/poly1305_glue.c:144:21,
     inlined from =E2=80=98poly1305_update_arch=E2=80=99 at
arch/x86/crypto/poly1305_glue.c:181:8:
arch/x86/crypto/poly1305_glue.c:86:9: warning: =E2=80=98poly1305_init_x86_=
64=E2=80=99
reading 32 bytes from a region of size 16 [-Wstringop-overread]
    86 |         poly1305_init_x86_64(ctx, key);
       |         ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
arch/x86/crypto/poly1305_glue.c: In function =E2=80=98poly1305_update_arch=
=E2=80=99:
arch/x86/crypto/poly1305_glue.c:86:9: note: referencing argument 2 of
type =E2=80=98const u8 *=E2=80=99 {aka =E2=80=98const unsigned char *=E2=
=80=99}
arch/x86/crypto/poly1305_glue.c:18:17: note: in a call to function
=E2=80=98poly1305_init_x86_64=E2=80=99
    18 | asmlinkage void poly1305_init_x86_64(void *ctx,
       |                 ^~~~~~~~~~~~~~~~~~~~
   AS      arch/x86/crypto/nh-sse2-x86_64.o
...

   CC      kernel/cgroup/cpuset.o
In file included from ./include/linux/string.h:269,
                  from ./include/linux/bitmap.h:9,
                  from ./include/linux/cpumask.h:12,
                  from ./arch/x86/include/asm/cpumask.h:5,
                  from ./arch/x86/include/asm/msr.h:11,
                  from ./arch/x86/include/asm/processor.h:22,
                  from ./arch/x86/include/asm/cpufeature.h:5,
                  from ./arch/x86/include/asm/thread_info.h:53,
                  from ./include/linux/thread_info.h:59,
                  from ./arch/x86/include/asm/preempt.h:7,
                  from ./include/linux/preempt.h:78,
                  from ./include/linux/rcupdate.h:27,
                  from ./include/linux/rbtree.h:22,
                  from ./include/linux/iova.h:14,
                  from ./include/linux/intel-iommu.h:14,
                  from arch/x86/kernel/tboot.c:9:
In function =E2=80=98memcmp=E2=80=99,
     inlined from =E2=80=98tboot_probe=E2=80=99 at arch/x86/kernel/tboot.c=
:70:6:
./include/linux/fortify-string.h:19:33: warning: =E2=80=98__builtin_memcmp=
_eq=E2=80=99
specified bound 16 exceeds source size 0 [-Wstringop-overread]
    19 | #define __underlying_memcmp     __builtin_memcmp
       |                                 ^
./include/linux/fortify-string.h:235:16: note: in expansion of macro
=E2=80=98__underlying_memcmp=E2=80=99
   235 |         return __underlying_memcmp(p, q, size);
       |                ^~~~~~~~~~~~~~~~~~~
   CC      kernel/time/tick-common.o
...

   CC      drivers/acpi/acpica/utglobal.o
lib/crypto/poly1305-donna64.c:15:67: warning: argument 2 of type =E2=80=98=
const
u8[16]=E2=80=99 {aka =E2=80=98const unsigned char[16]=E2=80=99} with misma=
tched bound
[-Warray-parameter=3D]
    15 | void poly1305_core_setkey(struct poly1305_core_key *key, const
u8 raw_key[16])
       |
~~~~~~~~~^~~~~~~~~~~
In file included from lib/crypto/poly1305-donna64.c:11:
./include/crypto/internal/poly1305.h:21:68: note: previously declared as
=E2=80=98const u8 *=E2=80=99 {aka =E2=80=98const unsigned char *=E2=80=99}
    21 | void poly1305_core_setkey(struct poly1305_core_key *key, const
u8 *raw_key);
       |
~~~~~~~~~~^~~~~~~
   CC      fs/btrfs/raid56.o
..

   CC      lib/decompress_unlzma.o
arch/x86/lib/msr-smp.c:255:51: warning: argument 2 of type =E2=80=98u32 *=
=E2=80=99 {aka
=E2=80=98unsigned int *=E2=80=99} declared as a pointer [-Warray-parameter=
=3D]
   255 | int rdmsr_safe_regs_on_cpu(unsigned int cpu, u32 *regs)
       |                                              ~~~~~^~~~
In file included from ./arch/x86/include/asm/processor.h:22,
                  from ./arch/x86/include/asm/cpufeature.h:5,
                  from ./arch/x86/include/asm/thread_info.h:53,
                  from ./include/linux/thread_info.h:59,
                  from ./arch/x86/include/asm/preempt.h:7,
                  from ./include/linux/preempt.h:78,
                  from arch/x86/lib/msr-smp.c:3:
./arch/x86/include/asm/msr.h:347:50: note: previously declared as an
array =E2=80=98u32[8]=E2=80=99 {aka =E2=80=98unsigned int[8]=E2=80=99}
   347 | int rdmsr_safe_regs_on_cpu(unsigned int cpu, u32 regs[8]);
       |                                              ~~~~^~~~~~~
arch/x86/lib/msr-smp.c:268:51: warning: argument 2 of type =E2=80=98u32 *=
=E2=80=99 {aka
=E2=80=98unsigned int *=E2=80=99} declared as a pointer [-Warray-parameter=
=3D]
   268 | int wrmsr_safe_regs_on_cpu(unsigned int cpu, u32 *regs)
       |                                              ~~~~~^~~~
In file included from ./arch/x86/include/asm/processor.h:22,
                  from ./arch/x86/include/asm/cpufeature.h:5,
                  from ./arch/x86/include/asm/thread_info.h:53,
                  from ./include/linux/thread_info.h:59,
                  from ./arch/x86/include/asm/preempt.h:7,
                  from ./include/linux/preempt.h:78,
                  from arch/x86/lib/msr-smp.c:3:
./arch/x86/include/asm/msr.h:348:50: note: previously declared as an
array =E2=80=98u32[8]=E2=80=99 {aka =E2=80=98unsigned int[8]=E2=80=99}
   348 | int wrmsr_safe_regs_on_cpu(unsigned int cpu, u32 regs[8]);
       |                                              ~~~~^~~~~~~
   CC      arch/x86/lib/cache-smp.o
...


   CC      drivers/base/core.o
In function =E2=80=98snb_wm_latency_quirk=E2=80=99,
     inlined from =E2=80=98ilk_setup_wm_latency=E2=80=99 at
drivers/gpu/drm/i915/intel_pm.c:3108:3,
     inlined from =E2=80=98intel_init_pm=E2=80=99 at drivers/gpu/drm/i915/=
intel_pm.c:7628:3:
drivers/gpu/drm/i915/intel_pm.c:3057:9: warning:
=E2=80=98intel_print_wm_latency=E2=80=99 reading 16 bytes from a region of=
 size 10
[-Wstringop-overread]
  3057 |         intel_print_wm_latency(dev_priv, "Primary",
dev_priv->wm.pri_latency);
       |
^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
drivers/gpu/drm/i915/intel_pm.c: In function =E2=80=98intel_init_pm=E2=80=
=99:
drivers/gpu/drm/i915/intel_pm.c:3057:9: note: referencing argument 3 of
type =E2=80=98const u16 *=E2=80=99 {aka =E2=80=98const short unsigned int =
*=E2=80=99}
drivers/gpu/drm/i915/intel_pm.c:2994:13: note: in a call to function
=E2=80=98intel_print_wm_latency=E2=80=99
  2994 | static void intel_print_wm_latency(struct drm_i915_private
*dev_priv,
       |             ^~~~~~~~~~~~~~~~~~~~~~
In function =E2=80=98snb_wm_latency_quirk=E2=80=99,
     inlined from =E2=80=98ilk_setup_wm_latency=E2=80=99 at
drivers/gpu/drm/i915/intel_pm.c:3108:3,
     inlined from =E2=80=98intel_init_pm=E2=80=99 at drivers/gpu/drm/i915/=
intel_pm.c:7628:3:
drivers/gpu/drm/i915/intel_pm.c:3058:9: warning:
=E2=80=98intel_print_wm_latency=E2=80=99 reading 16 bytes from a region of=
 size 10
[-Wstringop-overread]
  3058 |         intel_print_wm_latency(dev_priv, "Sprite",
dev_priv->wm.spr_latency);
       |
^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
drivers/gpu/drm/i915/intel_pm.c: In function =E2=80=98intel_init_pm=E2=80=
=99:
drivers/gpu/drm/i915/intel_pm.c:3058:9: note: referencing argument 3 of
type =E2=80=98const u16 *=E2=80=99 {aka =E2=80=98const short unsigned int =
*=E2=80=99}
drivers/gpu/drm/i915/intel_pm.c:2994:13: note: in a call to function
=E2=80=98intel_print_wm_latency=E2=80=99
  2994 | static void intel_print_wm_latency(struct drm_i915_private
*dev_priv,
       |             ^~~~~~~~~~~~~~~~~~~~~~
In function =E2=80=98snb_wm_latency_quirk=E2=80=99,
     inlined from =E2=80=98ilk_setup_wm_latency=E2=80=99 at
drivers/gpu/drm/i915/intel_pm.c:3108:3,
     inlined from =E2=80=98intel_init_pm=E2=80=99 at drivers/gpu/drm/i915/=
intel_pm.c:7628:3:
drivers/gpu/drm/i915/intel_pm.c:3059:9: warning:
=E2=80=98intel_print_wm_latency=E2=80=99 reading 16 bytes from a region of=
 size 10
[-Wstringop-overread]
  3059 |         intel_print_wm_latency(dev_priv, "Cursor",
dev_priv->wm.cur_latency);
       |
^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
drivers/gpu/drm/i915/intel_pm.c: In function =E2=80=98intel_init_pm=E2=80=
=99:
drivers/gpu/drm/i915/intel_pm.c:3059:9: note: referencing argument 3 of
type =E2=80=98const u16 *=E2=80=99 {aka =E2=80=98const short unsigned int =
*=E2=80=99}
drivers/gpu/drm/i915/intel_pm.c:2994:13: note: in a call to function
=E2=80=98intel_print_wm_latency=E2=80=99
  2994 | static void intel_print_wm_latency(struct drm_i915_private
*dev_priv,
       |             ^~~~~~~~~~~~~~~~~~~~~~
In function =E2=80=98snb_wm_lp3_irq_quirk=E2=80=99,
     inlined from =E2=80=98ilk_setup_wm_latency=E2=80=99 at
drivers/gpu/drm/i915/intel_pm.c:3109:3,
     inlined from =E2=80=98intel_init_pm=E2=80=99 at drivers/gpu/drm/i915/=
intel_pm.c:7628:3:
drivers/gpu/drm/i915/intel_pm.c:3086:9: warning:
=E2=80=98intel_print_wm_latency=E2=80=99 reading 16 bytes from a region of=
 size 10
[-Wstringop-overread]
  3086 |         intel_print_wm_latency(dev_priv, "Primary",
dev_priv->wm.pri_latency);
       |
^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
drivers/gpu/drm/i915/intel_pm.c: In function =E2=80=98intel_init_pm=E2=80=
=99:
drivers/gpu/drm/i915/intel_pm.c:3086:9: note: referencing argument 3 of
type =E2=80=98const u16 *=E2=80=99 {aka =E2=80=98const short unsigned int =
*=E2=80=99}
drivers/gpu/drm/i915/intel_pm.c:2994:13: note: in a call to function
=E2=80=98intel_print_wm_latency=E2=80=99
  2994 | static void intel_print_wm_latency(struct drm_i915_private
*dev_priv,
       |             ^~~~~~~~~~~~~~~~~~~~~~
In function =E2=80=98snb_wm_lp3_irq_quirk=E2=80=99,
     inlined from =E2=80=98ilk_setup_wm_latency=E2=80=99 at
drivers/gpu/drm/i915/intel_pm.c:3109:3,
     inlined from =E2=80=98intel_init_pm=E2=80=99 at drivers/gpu/drm/i915/=
intel_pm.c:7628:3:
drivers/gpu/drm/i915/intel_pm.c:3087:9: warning:
=E2=80=98intel_print_wm_latency=E2=80=99 reading 16 bytes from a region of=
 size 10
[-Wstringop-overread]
  3087 |         intel_print_wm_latency(dev_priv, "Sprite",
dev_priv->wm.spr_latency);
       |
^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
drivers/gpu/drm/i915/intel_pm.c: In function =E2=80=98intel_init_pm=E2=80=
=99:
drivers/gpu/drm/i915/intel_pm.c:3087:9: note: referencing argument 3 of
type =E2=80=98const u16 *=E2=80=99 {aka =E2=80=98const short unsigned int =
*=E2=80=99}
drivers/gpu/drm/i915/intel_pm.c:2994:13: note: in a call to function
=E2=80=98intel_print_wm_latency=E2=80=99
  2994 | static void intel_print_wm_latency(struct drm_i915_private
*dev_priv,
       |             ^~~~~~~~~~~~~~~~~~~~~~
In function =E2=80=98snb_wm_lp3_irq_quirk=E2=80=99,
     inlined from =E2=80=98ilk_setup_wm_latency=E2=80=99 at
drivers/gpu/drm/i915/intel_pm.c:3109:3,
     inlined from =E2=80=98intel_init_pm=E2=80=99 at drivers/gpu/drm/i915/=
intel_pm.c:7628:3:
drivers/gpu/drm/i915/intel_pm.c:3088:9: warning:
=E2=80=98intel_print_wm_latency=E2=80=99 reading 16 bytes from a region of=
 size 10
[-Wstringop-overread]
  3088 |         intel_print_wm_latency(dev_priv, "Cursor",
dev_priv->wm.cur_latency);
       |
^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
drivers/gpu/drm/i915/intel_pm.c: In function =E2=80=98intel_init_pm=E2=80=
=99:
drivers/gpu/drm/i915/intel_pm.c:3088:9: note: referencing argument 3 of
type =E2=80=98const u16 *=E2=80=99 {aka =E2=80=98const short unsigned int =
*=E2=80=99}
drivers/gpu/drm/i915/intel_pm.c:2994:13: note: in a call to function
=E2=80=98intel_print_wm_latency=E2=80=99
  2994 | static void intel_print_wm_latency(struct drm_i915_private
*dev_priv,
       |             ^~~~~~~~~~~~~~~~~~~~~~
In function =E2=80=98ilk_setup_wm_latency=E2=80=99,
     inlined from =E2=80=98intel_init_pm=E2=80=99 at drivers/gpu/drm/i915/=
intel_pm.c:7628:3:
drivers/gpu/drm/i915/intel_pm.c:3103:9: warning:
=E2=80=98intel_print_wm_latency=E2=80=99 reading 16 bytes from a region of=
 size 10
[-Wstringop-overread]
  3103 |         intel_print_wm_latency(dev_priv, "Primary",
dev_priv->wm.pri_latency);
       |
^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
drivers/gpu/drm/i915/intel_pm.c: In function =E2=80=98intel_init_pm=E2=80=
=99:
drivers/gpu/drm/i915/intel_pm.c:3103:9: note: referencing argument 3 of
type =E2=80=98const u16 *=E2=80=99 {aka =E2=80=98const short unsigned int =
*=E2=80=99}
drivers/gpu/drm/i915/intel_pm.c:2994:13: note: in a call to function
=E2=80=98intel_print_wm_latency=E2=80=99
  2994 | static void intel_print_wm_latency(struct drm_i915_private
*dev_priv,
       |             ^~~~~~~~~~~~~~~~~~~~~~
In function =E2=80=98ilk_setup_wm_latency=E2=80=99,
     inlined from =E2=80=98intel_init_pm=E2=80=99 at drivers/gpu/drm/i915/=
intel_pm.c:7628:3:
drivers/gpu/drm/i915/intel_pm.c:3104:9: warning:
=E2=80=98intel_print_wm_latency=E2=80=99 reading 16 bytes from a region of=
 size 10
[-Wstringop-overread]
  3104 |         intel_print_wm_latency(dev_priv, "Sprite",
dev_priv->wm.spr_latency);
       |
^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
drivers/gpu/drm/i915/intel_pm.c: In function =E2=80=98intel_init_pm=E2=80=
=99:
drivers/gpu/drm/i915/intel_pm.c:3104:9: note: referencing argument 3 of
type =E2=80=98const u16 *=E2=80=99 {aka =E2=80=98const short unsigned int =
*=E2=80=99}
drivers/gpu/drm/i915/intel_pm.c:2994:13: note: in a call to function
=E2=80=98intel_print_wm_latency=E2=80=99
  2994 | static void intel_print_wm_latency(struct drm_i915_private
*dev_priv,
       |             ^~~~~~~~~~~~~~~~~~~~~~
In function =E2=80=98ilk_setup_wm_latency=E2=80=99,
     inlined from =E2=80=98intel_init_pm=E2=80=99 at drivers/gpu/drm/i915/=
intel_pm.c:7628:3:
drivers/gpu/drm/i915/intel_pm.c:3105:9: warning:
=E2=80=98intel_print_wm_latency=E2=80=99 reading 16 bytes from a region of=
 size 10
[-Wstringop-overread]
  3105 |         intel_print_wm_latency(dev_priv, "Cursor",
dev_priv->wm.cur_latency);
       |
^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
drivers/gpu/drm/i915/intel_pm.c: In function =E2=80=98intel_init_pm=E2=80=
=99:
drivers/gpu/drm/i915/intel_pm.c:3105:9: note: referencing argument 3 of
type =E2=80=98const u16 *=E2=80=99 {aka =E2=80=98const short unsigned int =
*=E2=80=99}
drivers/gpu/drm/i915/intel_pm.c:2994:13: note: in a call to function
=E2=80=98intel_print_wm_latency=E2=80=99
  2994 | static void intel_print_wm_latency(struct drm_i915_private
*dev_priv,
       |             ^~~~~~~~~~~~~~~~~~~~~~
   CC [M]  drivers/gpu/drm/i915/intel_runtime_pm.o
..

   CC      net/openvswitch/vport-gre.o
In function =E2=80=98intel_dp_check_mst_status=E2=80=99,
     inlined from =E2=80=98intel_dp_hpd_pulse=E2=80=99 at
drivers/gpu/drm/i915/display/intel_dp.c:5901:8:
drivers/gpu/drm/i915/display/intel_dp.c:4554:22: warning:
=E2=80=98drm_dp_channel_eq_ok=E2=80=99 reading 6 bytes from a region of si=
ze 4
[-Wstringop-overread]
  4554 |                     !drm_dp_channel_eq_ok(&esi[10],
intel_dp->lane_count)) {
       |
^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
drivers/gpu/drm/i915/display/intel_dp.c: In function =E2=80=98intel_dp_hpd=
_pulse=E2=80=99:
drivers/gpu/drm/i915/display/intel_dp.c:4554:22: note: referencing
argument 1 of type =E2=80=98const u8 *=E2=80=99 {aka =E2=80=98const unsign=
ed char *=E2=80=99}
In file included from drivers/gpu/drm/i915/display/intel_dp.c:38:
./include/drm/drm_dp_helper.h:1459:6: note: in a call to function
=E2=80=98drm_dp_channel_eq_ok=E2=80=99
  1459 | bool drm_dp_channel_eq_ok(const u8
link_status[DP_LINK_STATUS_SIZE],
       |      ^~~~~~~~~~~~~~~~~~~~
   AR      net/xdp/built-in.a

...



=2D-
regards

Ronald
