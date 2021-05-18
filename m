Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0999D386E0C
	for <lists+stable@lfdr.de>; Tue, 18 May 2021 02:05:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234331AbhERAHJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 May 2021 20:07:09 -0400
Received: from mout.gmx.net ([212.227.17.20]:51055 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237491AbhERAHJ (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 17 May 2021 20:07:09 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gmx.net;
        s=badeba3b8450; t=1621296350;
        bh=ncmY9WlTSOBllGZzGjI/PA7GwtYLDjjZXmNiJT+27iw=;
        h=X-UI-Sender-Class:From:Subject:To:Cc:Date;
        b=VFUG11M3B3t5x0J5GTtW3YscgnUKdXjH+2dKdQXxuvSJPvFqsrzZ/SNJV71OBCsvH
         1yqkAEhKRn5N/L+9hr4duArc13kMeFY+ASB5NuzeRe3N9VMrNmReYV1m1NdVx9XMkP
         +mJ3qZhBzBIm/2RJiZgUoMiTVH+b1uRMLGwnHQ+c=
X-UI-Sender-Class: 01bb95c1-4bf8-414a-932a-4f6e2808ef9c
Received: from obelix.fritz.box ([46.142.14.239]) by mail.gmx.net (mrgmx105
 [212.227.17.168]) with ESMTPSA (Nemesis) id 1MStCY-1luS4u2S4M-00UKuK; Tue, 18
 May 2021 02:05:50 +0200
From:   Ronald Warsow <rwarsow@gmx.de>
Subject: Re: [PATCH 5.12 000/363] 5.12.5-rc1 review
To:     stable@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org
Message-ID: <bd76b7e4-c004-0794-68d0-6dc41a836a1f@gmx.de>
Date:   Tue, 18 May 2021 02:05:50 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: de-DE
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:W/L02XmocqXoACbZaWMp4cCWECkWDgd6c5364x/BUisTqEoLWtl
 PNzY3ZbNxuNvkzYlvLBtsJQnK2JGyKqJUOJGMQbuyK7isq06REeE6NBxGHwCTUnhetkm8FL
 U6z2tkhY/ysvxFOE7y2sdt3xw/ym2x5zgJ66hbdQDREBb0zWPo1l517IKipgtev5FFOgdm6
 UR/qk2zi+WId37OSi2JGQ==
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:EXYQZJs3ggg=:ZQHIVKXtYYWhqEj3pzRoDX
 5VnXTZfGxg+hyVA14W7rUiaJ9fnpI/XiIeWcfb12zIwhXe3GmpK/hRkutOo6JFKzdxWsHqG/9
 n8gOWSj12iDjLIG9ov9t14KaGkD5XSRwZa2l5mpxr82L2hP8MFVVllT5pldPBiIt9XH94lgWt
 BFclCUH/niOaK4TeVGUQezmX7Q73YPk6wvP2dohzGtqLmOnRAReOidVa2ZC/M9GNOg0awuJU9
 jCJe1E93bMs5jxf0N5G4csUUjBdh+XKysFgCxWRNzKhSrBOvvayq/expHMuaXQzx69dZR/a4z
 lIYId1/3RPqPh3DDkSdYxzhOB9nN3vEA1I+8ZeaL8j9Mv8Cwd150750WM2ZOlmxfUh5fI9cmh
 uZLSIktRoKQA/iGNDU+C7Ll6vxiwTMY2k+xRvDDqNZUugED7IrB1sIxRguaquUqlbkWWcIdXS
 3gRdKzdPb9TDMnH4748VVzoUox5u/1IfcTclx/yFfuS2tzcPvvl2T88G+g/EuyFG+hCLdnOX4
 yku7lLvhmegnjezn9Y8pyN1aGmnemhqAcje+pbXvtxyc1CwVEfvAItIb13UuSJ0W9GduLqIA3
 ha1YZxdrXshC2BTG0SZ1q/vZc978c+BMV3GButXsbJI9i4yP69s/iSrGmWLkDL2aBP0W5D3Vs
 xbM5lFqeZTccoxP8OHcwaN5Kvmw+pHfX90jWZh47tAj3eKZVHI97TmTeTFoGOTV3vMkHW4m54
 A+Tv4HReDVop6ecDzva2VzphlugwdhyuTjk8VBstgYPbE4C8hZZRcP+0uD96w56p9Z9ycmUgg
 gVukoKDZYmU7HlcKt7TfGXSxxfEJpgqxcQhFofk/Gw+s7Cna5zDgP11x4fRF3PcVMRGJTlczS
 xcBPGERYY4qhzixvipbDBPKLgqMUMGE2c4QMH4/nf++5dBWQsKBgyWS8w+jLtBYcVuF3P/cXq
 +4cHkqC8Vq7AcPDll8dczfudO5+t7wYf+5GRIqG43NWLz2p/NMIqKEGURG5KwM1aZ2sqyDn7B
 bvszrQntTyDtgYzXDSpYZCYV0gHIO0R1wSrLGtESxYAVUULsB/o+elRZYx+9SY6yI+YeI00lA
 6LZ9dPavl2lelr28UygJB5ZoedLjYoMW6hvU6JLSguSAkcFoY3l5SONEqHE2aeR/DKjHedM1U
 IhwczkuQ6CrMgIa1cyWjSvRtdhSkjagoIf1WYKSJ5QWUedRszJinpPBooZrQWVN91n2+E=
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 5/17/21 7:57 AM, Greg Kroah-Hartman wrote:
 > This is the start of the stable review cycle for the 5.12.5 release.
 > There are 363 patches in this series, all will be posted as a response
 > to this one.  If anyone has any issues with these being applied, please
 > let me know.
 >
 > Responses should be made by Wed, 19 May 2021 14:02:12 +0000.
 > Anything received after that time might be too late.
 >
 > The whole patch series can be found in one patch at:
 >
https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.12.5-rc=
1.gz
 > or in the git tree and branch at:
 >
git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
linux-5.12.y
 > and the diffstat can be found below.
 >
 > thanks,
 >
 > greg k-h
 >

Thanks

apart from some warnings all is fine here.

Fedora 34,
gcc (GCC) 11.1.1 20210428 (Red Hat 11.1.1-1)



..
CC      arch/x86/platform/efi/efi_64.o
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
   CC      crypto/cmac.o
...



CC      net/netfilter/nft_osf.o
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
   CC      net/bridge/netfilter/nf_conntrack_bridge.o
...



In function =E2=80=98intel_dp_check_mst_status=E2=80=99,
     inlined from =E2=80=98intel_dp_hpd_pulse=E2=80=99 at
drivers/gpu/drm/i915/display/intel_dp.c:5852:8:
drivers/gpu/drm/i915/display/intel_dp.c:4505:22: warning:
=E2=80=98drm_dp_channel_eq_ok=E2=80=99 reading 6 bytes from a region of si=
ze 4
[-Wstringop-overread]
  4505 |                     !drm_dp_channel_eq_ok(&esi[10],
intel_dp->lane_count)) {
       |
^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
drivers/gpu/drm/i915/display/intel_dp.c: In function =E2=80=98intel_dp_hpd=
_pulse=E2=80=99:
drivers/gpu/drm/i915/display/intel_dp.c:4505:22: note: referencing
argument 1 of type =E2=80=98const u8 *=E2=80=99 {aka =E2=80=98const unsign=
ed char *=E2=80=99}
In file included from drivers/gpu/drm/i915/display/intel_dp.c:38:
./include/drm/drm_dp_helper.h:1459:6: note: in a call to function
=E2=80=98drm_dp_channel_eq_ok=E2=80=99
  1459 | bool drm_dp_channel_eq_ok(const u8
link_status[DP_LINK_STATUS_SIZE],
       |      ^~~~~~~~~~~~~~~~~~~~
   CC      drivers/gpu/drm/drm_blend.o




=2D-
regards

Ronald
