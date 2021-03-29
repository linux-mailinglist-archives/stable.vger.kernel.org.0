Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0EC4D34D285
	for <lists+stable@lfdr.de>; Mon, 29 Mar 2021 16:40:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231132AbhC2OkN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Mar 2021 10:40:13 -0400
Received: from mout.gmx.net ([212.227.15.19]:57589 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230424AbhC2OkC (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 29 Mar 2021 10:40:02 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gmx.net;
        s=badeba3b8450; t=1617028800;
        bh=XoL7g5PJzOJzvlYcsYRRxgZapka3PV8gpak0PiczSgc=;
        h=X-UI-Sender-Class:From:Subject:To:Cc:Date;
        b=YKnWr8Hoo7GC1ssNRQxbDTeSKzxOJXrB3zk5jOqcRVv73JKTkceLpSJxv3hxN2UWB
         fb5OcGTAEVmG6XUuizF+xZmTCcBL32Hfo8yesZ93dI5IVP622B1TRFYnYCoumCbKJY
         ql9hdQYn/W+jE8nu7DvTLfs2YAEZPzajEZPeDfz8=
X-UI-Sender-Class: 01bb95c1-4bf8-414a-932a-4f6e2808ef9c
Received: from obelix.fritz.box ([46.142.5.45]) by mail.gmx.net (mrgmx004
 [212.227.17.190]) with ESMTPSA (Nemesis) id 1MEFzr-1lIsJp2zDR-00ABHk; Mon, 29
 Mar 2021 16:40:00 +0200
From:   Ronald Warsow <rwarsow@gmx.de>
Subject: RE: [PATCH 5.11 000/252] 5.11.11-rc2 review
To:     stable@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org
Message-ID: <d11fe153-b3a3-94f0-a425-ad4881a82412@gmx.de>
Date:   Mon, 29 Mar 2021 16:40:00 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.0
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:87u+ntg25jqRXfbDp2IQMxnRNL1hVDIjysoVhGnMQrGD9qfqyb3
 7JJEXAwmdqAWYM3Eq6SKKyVcRhprnw2G53rVcURlv4utZrag8UOlb5jWDE20ONtmu6OB+o+
 dt0UfEHYZ4lhq7QtTe30N6N45oQGJ8vjgPx0R8YgQG3G7Sxh5Uqim+9Y4nlvkT/63KfAqx1
 +eT+j5VKB/5VzztYYwXEw==
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:PzgFQ4ts+Yg=:ms6PvC909jsaGQM6NZ/vva
 g3zYDgAt24VLOABgZH+3BIg+B2V1QNUjHYxA+9ql1S8YLRJPRWmMIKcTPE7GSJkwoYuFalO9n
 p+4PtZIJi7VPTg6Rx5QflQ7GWGk9WbvHcCa2pD6najaw6+n/r/g/2F/x1xTRQz6WEIv+BglRx
 KYBK2dOXtFmWPKUSQD6Ze4WtCh6OsAYZRwKJnECJye1b/kXG9est37ds6HHQoWQ0neYNxWErK
 Pt54br2kJt6pBuTz9BqU+io+PzTPcofRcQCQDHkqKsEpthqxfTf4IX9EpL+RGIYnLZELGI/d1
 PcGlUfRgLzgrR14loNRnlaIRwe1oYpAtcTsrvW5Y3AuxxBXZgktsTQtBTM9IaWAzUKgkQT7ZI
 jVY+EqYbNh1c9T2O2HXjZPrlkx+ZrbL1uju5aGtMvvhBSiUlxHHb1KtulVqg8lkCVZkcSA1Wt
 BKVF2rLdtTp/YiqiDK02GpBHAVGr7pEFNZblGwSvEKeapV8d2K52KwuhbDpVsV0XnhXRFH0bR
 r1uEthhxeGEbpOYdD17nxogrtgx/mYDZrf66qkPdVDyuNT+oVPn6H8EdwZtPcIkVo1XpL1led
 Cm176iq8zYI7NY61UhCOmaX5NHcD6xAg0hYmrvZTREjCYYPg8PdyWGaQCyelsOzaeyR945edt
 xmMH+KGpauluub8ooLwLBpsU+wGwdSsWBaJKojy1SydiE5FlDt0peo0q/fhCrSWYqrN48hDZ1
 svS8XWisFYkGWwBWo0GuZbBpEmfcsY9DoxsMaZ14poDAeb4XTeqD8+bSTi5+i6SsetF0niH7m
 uFYU4Bl9N9bbZOqXna+lsbiXIMqRcsLuRy2ztzYPpQAbtSTBk0llmrktQFdVjggorw9IJFJoh
 2cv3xgXUdt5NZXQcX1xN51D735Ue3UuJzX+5xmGv3NH0AGNUvEj4CJ72viBa44ozJMXLEaEYh
 X9LilXcj0uG+tePh9UrBUrMOw7fqSlivKQ1gftgYisgDyqDDY/4cYDwhBhutq8gfslQXvU/4E
 U+u3oaEfm9vZwTJOdu2+cCdxcLJOq0R84VKkTsLOwDI8KY4hhLMKa7XgqfCmKYmTkjaPGZqJz
 p7Mk7yBI1Ig6qclMvFxytt6QZtz5CB9ORISmLlwnGUQ9jYj++Uuznex2S9DwU6wpiGa5GOA88
 t+GI0dLsys1XKCDJCLt196rURRADJw2faDzLXj6nKGhUulDcmZqY2xQ+SMHLhivazFKzI=
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

hello

5.11.11-rc2 compiles, boots and run fine here (on an i7-6700 with Fedora
34 Beta)

Thanks.

but I see some error's/warning's with the new gcc-11.0.1 compared to the
elder gcc-10.2.1-11


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
In file included from ./include/linux/bitmap.h:9,
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
./include/linux/string.h:283:33: warning: =E2=80=98__builtin_memcmp_eq=E2=
=80=99
specified bound 16 exceeds source size 0 [-Wstringop-overread]
   283 | #define __underlying_memcmp     __builtin_memcmp
       |                                 ^
./include/linux/string.h:488:16: note: in expansion of macro
=E2=80=98__underlying_memcmp=E2=80=99
   488 |         return __underlying_memcmp(p, q, size);
       |                ^~~~~~~~~~~~~~~~~~~
lib/crypto/poly1305-donna64.c:15:67: warning: argument 2 of type =E2=80=98=
const
u8[16]=E2=80=99 {aka =E2=80=98const unsigned char[16]=E2=80=99} with misma=
tched bound
[-Warray-parameter=3D]
    15 | void poly1305_core_setkey(struct poly1305_core_key *key, const
u8 raw_key[16])
       | ~~~~~~~~~^~~~~~~~~~~
In file included from lib/crypto/poly1305-donna64.c:11:
./include/crypto/internal/poly1305.h:21:68: note: previously declared as
=E2=80=98const u8 *=E2=80=99 {aka =E2=80=98const unsigned char *=E2=80=99}
    21 | void poly1305_core_setkey(struct poly1305_core_key *key, const
u8 *raw_key);
       | ~~~~~~~~~~^~~~~~~
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
In function =E2=80=98snb_wm_latency_quirk=E2=80=99,
     inlined from =E2=80=98ilk_setup_wm_latency=E2=80=99 at
drivers/gpu/drm/i915/intel_pm.c:3108:3,
     inlined from =E2=80=98intel_init_pm=E2=80=99 at drivers/gpu/drm/i915/=
intel_pm.c:7650:3:
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
intel_pm.c:7650:3:
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
intel_pm.c:7650:3:
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
intel_pm.c:7650:3:
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
intel_pm.c:7650:3:
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
intel_pm.c:7650:3:
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
intel_pm.c:7650:3:
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
intel_pm.c:7650:3:
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
intel_pm.c:7650:3:
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
In function =E2=80=98intel_dp_check_mst_status=E2=80=99,
     inlined from =E2=80=98intel_dp_hpd_pulse=E2=80=99 at
drivers/gpu/drm/i915/display/intel_dp.c:7122:8:
drivers/gpu/drm/i915/display/intel_dp.c:5797:22: warning:
=E2=80=98drm_dp_channel_eq_ok=E2=80=99 reading 6 bytes from a region of si=
ze 4
[-Wstringop-overread]
  5797 |                     !drm_dp_channel_eq_ok(&esi[10],
intel_dp->lane_count)) {
       | ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
drivers/gpu/drm/i915/display/intel_dp.c: In function =E2=80=98intel_dp_hpd=
_pulse=E2=80=99:
drivers/gpu/drm/i915/display/intel_dp.c:5797:22: note: referencing
argument 1 of type =E2=80=98const u8 *=E2=80=99 {aka =E2=80=98const unsign=
ed char *=E2=80=99}
In file included from drivers/gpu/drm/i915/display/intel_dp.c:38:
./include/drm/drm_dp_helper.h:1267:6: note: in a call to function
=E2=80=98drm_dp_channel_eq_ok=E2=80=99
  1267 | bool drm_dp_channel_eq_ok(const u8
link_status[DP_LINK_STATUS_SIZE],
       |      ^~~~~~~~~~~~~~~~~~~~



=2D-
regards

Ronald

