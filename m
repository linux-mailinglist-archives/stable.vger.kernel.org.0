Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E8F4B356CBA
	for <lists+stable@lfdr.de>; Wed,  7 Apr 2021 14:54:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352493AbhDGMye (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 7 Apr 2021 08:54:34 -0400
Received: from mo4-p01-ob.smtp.rzone.de ([85.215.255.54]:21702 "EHLO
        mo4-p01-ob.smtp.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352497AbhDGMyd (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 7 Apr 2021 08:54:33 -0400
ARC-Seal: i=1; a=rsa-sha256; t=1617800043; cv=none;
    d=strato.com; s=strato-dkim-0002;
    b=NQsjsrzH9Lp1AhlUCunEnBa51pzFDAdFAJ37ZffU3gBweO6kjfeiujrNqDbaMPpfml
    DT6b8Y0TnUmjdI4RMcd8h+rnuOw0cmmQNz4wLpNBtVgT7A7cxJI5X6zaLGLaL9tIummY
    TGIwOBshGtngi/lt0mXfOPNDywlAIlFuLyhhy3uxzBgxjv7vcNNaiWHTNaqUhr3swSRz
    LPLpGifgaHl0D5eK/+lJorwux0HVdFkEg6yFXqoPXbba88du+D4fPcqM6L37LCAc8+g7
    sYI7Qc75X7gHyO39sScYAay/PY0xTpgsRuoju7FQIwX7nLd4Vo1D9KFvR1md+denZ/Cs
    7vxQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; t=1617800043;
    s=strato-dkim-0002; d=strato.com;
    h=To:References:Message-Id:Cc:Date:In-Reply-To:From:Subject:Cc:Date:
    From:Subject:Sender;
    bh=yzrt+jLUyp6sMiFDNyxwa88/HLhtYFWUeUnyg77wn0s=;
    b=XLc51xuiJetx8Ajk/uY23cH96PqRFT17WOsJKvBEBOSkGHMpVd+WMD1gBAyKmZpoNb
    LVk6VkrUogQ3LVeXuxHDfqP2aRsPIzBFJ5qfctMzPuc1+eJ4gqzJufasSftfOovk+t1K
    oum33BFXOb6eD+ZBS/kaR+81ZzwEEucKw1P3YpeTzW8zqN2LyjiD1D1ViXUQBgj/9bv8
    ovEmssfEsx5GgXjsHUDkurwqbRh/p1iSVh2UjT0LpTT631rhqJ7ENF6DmtGjM9wRFkcP
    +Gc+tl6zvvxTTpf26oMRL1ylyyBNUBwZeL4XMTuaHJEgRF9p5GmmNpwKjJzjKF1IZ0X1
    yUjA==
ARC-Authentication-Results: i=1; strato.com;
    dkim=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; t=1617800043;
    s=strato-dkim-0002; d=goldelico.com;
    h=To:References:Message-Id:Cc:Date:In-Reply-To:From:Subject:Cc:Date:
    From:Subject:Sender;
    bh=yzrt+jLUyp6sMiFDNyxwa88/HLhtYFWUeUnyg77wn0s=;
    b=IMRVbpCsWWF17n4fW9Fxc6F+5rfsqCguEK+VtXMi+SWqIX+fOyur8gvQ9am6MjVuey
    FA0TIf6q3QkF6IhTbS7ViYEVvYLDt2ShYj5KWEIoW0IJ6g5TV+IRqKyBo7D6fsfFkB3n
    0otUNMFbXyAhZGfLTjjCYpWPYpFD/RG+bMLEl/VhzU2D89YIx2MZLkD46Mz9FZykyhdP
    uCOC2fHBEHspBLDSIrSdkZFtOWUYTohW50NW7Dx6o/5Cpf3E2MFjB6AbvIFFgGbEgajP
    8WhbR4yxZ0hYKHlXDGj5pN56PUQvrUm9tvV5Pvhyb9PBmfKuXAE1G01rmY8SIMJPT2Zg
    VIEQ==
Authentication-Results: strato.com;
    dkim=none
X-RZG-AUTH: ":JGIXVUS7cutRB/49FwqZ7WcJeFKiMgPgp8VKxflSZ1P34KBj4Qpw9iZeHmMmw43sSFQ="
X-RZG-CLASS-ID: mo00
Received: from imac.fritz.box
    by smtp.strato.de (RZmta 47.23.1 DYNA|AUTH)
    with ESMTPSA id h03350x37Cs3myW
        (using TLSv1 with cipher ECDHE-RSA-AES256-SHA (curve X9_62_prime256v1 with 256 ECDH bits, eq. 3072 bits RSA))
        (Client did not present a certificate);
    Wed, 7 Apr 2021 14:54:03 +0200 (CEST)
Subject: Re: [PATCH V3] MIPS: Fix longstanding errors in div64.h
Mime-Version: 1.0 (Mac OS X Mail 9.3 \(3124\))
Content-Type: text/plain; charset=us-ascii
From:   "H. Nikolaus Schaller" <hns@goldelico.com>
In-Reply-To: <20210407092307.3920801-1-chenhuacai@loongson.cn>
Date:   Wed, 7 Apr 2021 14:54:02 +0200
Cc:     Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
        linux-mips@vger.kernel.org, Jiaxun Yang <jiaxun.yang@flygoat.com>,
        Huacai Chen <chenhuacai@loongson.cn>, stable@vger.kernel.org
Content-Transfer-Encoding: quoted-printable
Message-Id: <7788A4F6-8471-4A22-8B35-118B91299E34@goldelico.com>
References: <20210407092307.3920801-1-chenhuacai@loongson.cn>
To:     Huacai Chen <chenhuacai@kernel.org>
X-Mailer: Apple Mail (2.3124)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi,

> Am 07.04.2021 um 11:23 schrieb Huacai Chen <chenhuacai@kernel.org>:
>=20
> There are four errors in div64.h caused by commit =
c21004cd5b4cb7d479514
> ("MIPS: Rewrite <asm/div64.h> to work with gcc 4.4.0."):
>=20
> 1, Only 32bit kernel need __div64_32(), but the above commit makes it
>   depend on 64bit kernel by mistake.
>=20
> 2, asm-generic/div64.h should be included after __div64_32() =
definition.
>=20
> 3, __n should be initialized as *n before use (and "*__n >> 32" should
>   be "__n >> 32") in __div64_32() definition.
>=20
> 4, linux/types.h should be included at the first place, otherwise =
BITS_
>   PER_LONG is not defined.

Ok, this explains the bug.

>=20
> Fixes: c21004cd5b4cb7d479514 ("MIPS: Rewrite <asm/div64.h> to work =
with gcc 4.4.0.")
> Cc: stable@vger.kernel.org
> Signed-off-by: Huacai Chen <chenhuacai@loongson.cn>
> ---
> arch/mips/include/asm/div64.h | 14 +++++++-------
> 1 file changed, 7 insertions(+), 7 deletions(-)
>=20
> diff --git a/arch/mips/include/asm/div64.h =
b/arch/mips/include/asm/div64.h
> index dc5ea5736440..d827c13c3bc5 100644
> --- a/arch/mips/include/asm/div64.h
> +++ b/arch/mips/include/asm/div64.h
> @@ -9,12 +9,10 @@
> #ifndef __ASM_DIV64_H
> #define __ASM_DIV64_H
>=20
> -#include <asm-generic/div64.h>
> -
> -#if BITS_PER_LONG =3D=3D 64
> -
> #include <linux/types.h>
>=20
> +#if BITS_PER_LONG =3D=3D 32
> +
> /*
>  * No traps on overflows for any of these...
>  */
> @@ -24,9 +22,9 @@
> 	unsigned long __cf, __tmp, __tmp2, __i;				=
\
> 	unsigned long __quot32, __mod32;				=
\
> 	unsigned long __high, __low;					=
\
> -	unsigned long long __n;						=
\
> +	unsigned long long __n =3D *n;					=
\
> 									=
\
> -	__high =3D *__n >> 32;						=
\
> +	__high =3D __n >> 32;						=
\
> 	__low =3D __n;							=
\
> 	__asm__(							=
\
> 	"	.set	push					\n"	=
\
> @@ -63,6 +61,8 @@
> 	__mod32;							=
\
> })
>=20
> -#endif /* BITS_PER_LONG =3D=3D 64 */
> +#endif /* BITS_PER_LONG =3D=3D 32 */
> +
> +#include <asm-generic/div64.h>
>=20
> #endif /* __ASM_DIV64_H */
> --=20
> 2.27.0
>=20

Now it compiles and links fine.

Here is the test result on real hardware.

CI20 (jz4780) hangs during boot:

Starting kernel ...

[    0.000000] printk: debug: ignoring loglevel setting.
[    0.000000] User-defined physical RAM map overwrite
[    0.000000] Initrd not found or empty - disabling initrd
[    0.000000] cma: Reserved 32 MiB at 0x01000000
[    0.000000] Primary instruction cache 32kB, VIPT, 8-way, linesize 32 =
bytes.
[    0.000000] Primary data cache 32kB, 8-way, VIPT, no aliases, =
linesize 32 bytes
[    0.000000] MIPS secondary cache 256kB, 8-way, linesize 128 bytes.
[    0.000000] Zone ranges:
[    0.000000]   Normal   [mem 0x0000000000000000-0x000000000fffffff]
[    0.000000]   HighMem  [mem 0x0000000010000000-0x000000005fffffff]
[    0.000000] Movable zone start for each node
[    0.000000] Early memory node ranges
[    0.000000]   node   0: [mem 0x0000000000000000-0x000000000fffffff]
[    0.000000]   node   0: [mem 0x0000000030000000-0x000000005fffffff]
[    0.000000] Initmem setup node 0 [mem =
0x0000000000000000-0x000000005fffffff]
[    0.000000] On node 0 totalpages: 262144
[    0.000000]   Normal zone: 576 pages used for memmap
[    0.000000]   Normal zone: 0 pages reserved
[    0.000000]   Normal zone: 65536 pages, LIFO batch:15
[    0.000000]   HighMem zone: 196608 pages, LIFO batch:63
[    0.000000] pcpu-alloc: s0 r0 d32768 u32768 alloc=3D1*32768
[    0.000000] pcpu-alloc: [0] 0=20
[    0.000000] Built 1 zonelists, mobility grouping on.  Total pages: =
261568
[    0.000000] Kernel command line: console=3DttyS4,115200 console=3Dtty0 =
mem=3D256M@0x0 mem=3D768M@0x30000000 rootwait quiet rw =
root=3D/dev/mmcblk0p1 dm9000.mac_addr=3Dd0:31:10:ff:6e:86 earlycon =
console=3DttyS4,115200 clk_ignore_unused ignore_loglevel
[    0.000000] Dentry cache hash table entries: 32768 (order: 5, 131072 =
bytes, linear)
[    0.000000] Inode-cache hash table entries: 16384 (order: 4, 65536 =
bytes, linear)
[    0.000000] mem auto-init: stack:off, heap alloc:off, heap free:off
[    0.000000] Memory: 989600K/1048576K available (7980K kernel code, =
803K rwdata, 2752K rodata, 356K init, 159K bss, 26208K reserved, 32768K =
cma-reserved, 786432K highmem)
[    0.000000] rcu: Preemptible hierarchical RCU implementation.
[    0.000000]  Trampoline variant of Tasks RCU enabled.
[    0.000000] rcu: RCU calculated value of scheduler-enlistment delay =
is 10 jiffies.
[    0.000000] NR_IRQS: 256
[    0.000000] random: get_random_bytes called from =
start_kernel+0x730/0x96c with crng_init=3D0
[    0.000000] ingenic_tcu_clocksource_init: 65535 vs. 65535
[    0.000000] ingenic_tcu_clocksource_init: 65535 vs. 65535
[    0.000000] clocksource: ingenic-timer: mask: 0xffff max_cycles: =
0xffff, max_idle_ns: 38886830 ns
[    0.000000] ingenic_tcu_setup_cevt: 65535 vs. 65535
[    0.000000] ingenic_tcu_init: 16 vs. 16
[    0.000002] sched_clock: 16 bits at 750kHz, resolution 1333ns, wraps =
every 43687269ns
[    0.008587] Console: colour dummy device 80x25
[    0.014519] printk: console [tty0] enabled
[    0.018674] Calibrating delay loop... 1168.17 BogoMIPS (lpj=3D5840896)
[    0.064170] pid_max: default: 32768 minimum: 301
[    0.068981] LSM: Security Framework initializing
[    0.073695] Mount-cache hash table entries: 1024 (order: 0, 4096 =
bytes, linear)
[    0.081130] Mountpoint-cache hash table entries: 1024 (order: 0, 4096 =
bytes, linear)
[    0.090621] Performance counters: No available PMU.
[    0.095691] rcu: Hierarchical SRCU implementation.
[    0.101059] devtmpfs: initialized
[    0.110407] clocksource: jiffies: mask: 0xffffffff max_cycles: =
0xffffffff, max_idle_ns: 19112604462750000 ns
[    0.121000] futex hash table entries: 256 (order: -1, 3072 bytes, =
linear)
[    0.129361] pinctrl core: initialized pinctrl subsystem
[    0.135554] regulator-dummy: no parameters, enabled
[    0.141947] NET: Registered protocol family 16
[    0.149141] thermal_sys: Registered thermal governor 'fair_share'
[    0.149158] thermal_sys: Registered thermal governor 'step_wise'
-- hangs ---
-- next log steps would have been ---
[    0.156225] thermal_sys: Registered thermal governor 'user_space'
[    0.280761] jz4780_dma_probe
[    0.301402] jz4780-dma 13420000.dma: JZ4780 DMA controller =
initialised
[    0.309861] fixedregulator@0 GPIO handle specifies active low - =
ignored
[    0.316601] eth0_power: 3300 mV, disabled
[    0.321627] reg-fixed-voltage fixedregulator@0: eth0_power supplying =
3300000uV
[    0.329498] fixedregulator@2 GPIO handle specifies active low - =
ignored
[    0.336422] otg_power: 5000 mV, enabled
[    0.340541] reg-fixed-voltage fixedregulator@2: otg_power supplying =
5000000uV
[    0.348401] usb_power: 5000 mV, enabled
[    0.352813] reg-fixed-voltage fixedregulator@3: usb_power supplying =
5000000uV
[    0.360343] fixedregulator@1 GPIO handle specifies active low - =
ignored
[    0.367062] wlan0_power: no parameters, disabled
...

Alpha400/jz4730 (work-in-progress for future upstreaming) as well:

[    0.000000] Linux version 5.12.0-rc6-letux-l400+ (hns@iMac.fritz.box) =
(mipsel-linux-gnu-gcc (GCC) 4.9.2, GNU ld (GNU Binutils) 2.25) #5548 =
PREEMPT Wed Apr 7 12:21:49 CEST 2021
[    0.000000] CPU0 revision is: 02d0024f (Ingenic XBurst)
[    0.000000] MIPS: machine is Skytone Alpha 400
[    0.000000] earlycon: jz4740_uart0 at MMIO32 0x10030000 (options =
'115200n8')
[    0.000000] printk: bootconsole [jz4740_uart0] enabled
[    0.000000] printk: debug: ignoring loglevel setting.
[    0.000000] User-defined physical RAM map overwrite
[    0.000000] Initrd not found or empty - disabling initrd
[    0.000000] cma: Reserved 32 MiB at 0x01800000
[    0.000000] Primary instruction cache 16kB, VIPT, 4-way, linesize 32 =
bytes.
[    0.000000] Primary data cache 16kB, 4-way, VIPT, no aliases, =
linesize 32 bytes
[    0.000000] Zone ranges:
[    0.000000]   Normal   [mem 0x0000000000000000-0x0000000007ffffff]
[    0.000000] Movable zone start for each node
[    0.000000] Early memory node ranges
[    0.000000]   node   0: [mem 0x0000000000000000-0x0000000007ffffff]
[    0.000000] Initmem setup node 0 [mem =
0x0000000000000000-0x0000000007ffffff]
[    0.000000] On node 0 totalpages: 32768
[    0.000000]   Normal zone: 288 pages used for memmap
[    0.000000]   Normal zone: 0 pages reserved
[    0.000000]   Normal zone: 32768 pages, LIFO batch:7
[    0.000000] pcpu-alloc: s0 r0 d32768 u32768 alloc=3D1*32768
[    0.000000] pcpu-alloc: [0] 0=20
[    0.000000] Built 1 zonelists, mobility grouping on.  Total pages: =
32480
[    0.000000] Kernel command line: mem=3D128M =
earlycon=3Djz4740_uart,mmio32,0x10030000,115200n8 ignore_loglevel =
console=3Dtty0 console=3DttyS0,115200n8 root=3D/dev/mmcblk0p2 rw =
rootfstype=3Dext4,ext3 rootwait ethaddr=3D00:21:4D:01:00:EF
[    0.000000] Dentry cache hash table entries: 16384 (order: 4, 65536 =
bytes, linear)
[    0.000000] Inode-cache hash table entries: 8192 (order: 3, 32768 =
bytes, linear)
[    0.000000] mem auto-init: stack:off, heap alloc:off, heap free:off
[    0.000000] Memory: 84904K/131072K available (8031K kernel code, 799K =
rwdata, 2736K rodata, 328K init, 137K bss, 13400K reserved, 32768K =
cma-reserved)
[    0.000000] rcu: Preemptible hierarchical RCU implementation.
[    0.000000]  Trampoline variant of Tasks RCU enabled.
[    0.000000] rcu: RCU calculated value of scheduler-enlistment delay =
is 10 jiffies.
[    0.000000] NR_IRQS: 256
[    0.000000] random: get_random_bytes called from =
start_kernel+0x720/0x960 with crng_init=3D0
[    0.000000] ingenic_tcu_clocksource_init: 67108863 vs. 65535
[    0.000000] clocksource: ingenic-timer: mask: 0x3ffffff max_cycles: =
0x3ffffff, max_idle_ns: 8103395207 ns
[    0.000000] ingenic_tcu_setup_cevt: 67108863 vs. 65535
[    0.000000] ingenic_tcu_init: 26 vs. 16
[    0.000008] sched_clock: 26 bits at 3686kHz, resolution 271ns, wraps =
every 9101639544ns
[    0.010312] Console: colour dummy device 80x25
[    0.019604] printk: console [tty0] enabled
[    0.024130] Calibrating delay loop... 353.89 BogoMIPS (lpj=3D1769472)
[    0.094511] pid_max: default: 32768 minimum: 301
[    0.100152] LSM: Security Framework initializing
[    0.105392] Mount-cache hash table entries: 1024 (order: 0, 4096 =
bytes, linear)
[    0.113288] Mountpoint-cache hash table entries: 1024 (order: 0, 4096 =
bytes, linear)
[    0.131113] Performance counters: No available PMU.
[    0.137166] rcu: Hierarchical SRCU implementation.
[    0.144948] devtmpfs: initialized
[    0.172953] clocksource: jiffies: mask: 0xffffffff max_cycles: =
0xffffffff, max_idle_ns: 19112604462750000 ns
[    0.185274] futex hash table entries: 256 (order: -1, 3072 bytes, =
linear)
[    0.200624] pinctrl core: initialized pinctrl subsystem
[    0.211784] regulator-dummy: no parameters, enabled
[    0.225250] NET: Registered protocol family 16
[    0.254800] thermal_sys: Registered thermal governor 'fair_share'
[    0.254872] thermal_sys: Registered thermal governor 'step_wise'
[    0.261216] thermal_sys: Registered thermal governor 'user_space'
[    0.609902] Kernel bug detected[#1]:
[    0.619939] CPU: 0 PID: 167 Comm: kworker/u2:2 Not tainted =
5.12.0-rc6-letux-l400+ #5548
[    0.628314] $ 0   : 00000000 10000400 81ac4dbb 81ac4dbb
[    0.633876] $ 4   : 00000001 80acb8b0 10000400 ffff00fe
[    0.639433] $ 8   : 83967fe0 00000400 00000000 8091fcc0
[    0.644990] $12   : 00000068 0000004c 00000033 00000019
[    0.650544] $16   : 10000401 00000000 8388d980 00000001
[    0.656099] $20   : 83967ed4 83936894 8388d980 fffffffe
[    0.661659] $24   : 80b8b23c 81ac4dbb                 =20
[    0.667212] $28   : 83966000 83967ea8 80bb0000 80151d6c
[    0.672773] Hi    : 00000000
[    0.675780] Lo    : 00000000
[    0.678787] epc   : 80151d6c do_task_dead+0x78/0x7c
[    0.683900] ra    : 80151d6c do_task_dead+0x78/0x7c
[    0.688996] Status: 10000403 KERNEL EXL IE=20
[    0.693440] Cause : 00800024 (ExcCode 09)
[    0.697608] PrId  : 02d0024f (Ingenic XBurst)
[    0.702137] Modules linked in:
[    0.705349] Process kworker/u2:2 (pid: 167, threadinfo=3D(ptrval), =
task=3D(ptrval), tls=3D00000000)
[    0.714254] Stack : 83967ed4 81ac4dbb 8388d980 83936660 83936660 =
8012833c 839bde80 fffffffe
[    0.723225]         10000401 8055ca0c 8398700c 83967ed4 83967ed4 =
81ac4dbb 839bec80 839bde80
[    0.732194]         fffffffe 80b8b260 80b90000 00000001 8394dc4c =
fffffffe 80bb0000 8013b4c8
[    0.741161]         8013b320 80131cac 00000000 00000000 8013b320 =
839bde80 80b94520 80102cec
[    0.750126]         00000000 00000000 00000000 00000000 00000000 =
00000000 00000000 00000000
[    0.759079]         ...
[    0.761695] Call Trace:
[    0.764260] [<80151d6c>] do_task_dead+0x78/0x7c
[    0.769018] [<8012833c>] do_exit+0x98c/0x9ac
[    0.773524] [<8013b4c8>] call_usermodehelper_exec_async+0x1a8/0x1c0
[    0.780079] [<80102cec>] ret_from_kernel_thread+0x14/0x1c
[    0.785739]=20
[    0.787330] Code: 34428000  0c2348dc  ac62000c <000c000d> 27bdffb8  =
afb7003c  3c1780b9  8ee2b23c  afb3002c=20
[    0.797776]=20
-- hangs ---
-- next log steps would have been ---
[    0.872949] jz4780_dma_probe
[    0.896933] jz4780-dma 13020000.dma: JZ4780 DMA controller =
initialised
[    0.908432] vcc: 3300 mV, enabled
[    0.916920] reg-fixed-voltage regulator@0: vcc supplying 3300000uV
[    0.925474] vmmc: 3300 mV, disabled
[    0.932535] reg-fixed-voltage regulator@1: vmmc supplying 3300000uV
[    0.950092] SCSI subsystem initialized
[    0.958813] libata version 3.00 loaded.
...

Any ideas where to look deeper?

Is it possible to enable some unit-test early during boot?

printk is working, so it could be possible to run some div64_32
test cases if they exist. Or someone can provide a hack for e.g.
pinctrl or clocksource driver to run such tests during probe.

Well, hacking that into such drivers is something I can do, but
what I would need is some series of

	if (div64_32(...) !=3D ...) printk("div64_32(...) !=3D ...\n");

statements.

BR and thanks,
Nikolaus Schaller

