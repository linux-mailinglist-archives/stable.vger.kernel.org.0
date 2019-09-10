Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 48203AE1EB
	for <lists+stable@lfdr.de>; Tue, 10 Sep 2019 03:27:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392337AbfIJB1d (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 9 Sep 2019 21:27:33 -0400
Received: from mail-ot1-f66.google.com ([209.85.210.66]:40512 "EHLO
        mail-ot1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2392098AbfIJB1c (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 9 Sep 2019 21:27:32 -0400
Received: by mail-ot1-f66.google.com with SMTP id y39so15710094ota.7;
        Mon, 09 Sep 2019 18:27:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc;
        bh=xQbuaHJmu5++lK1BRcq0TrFo/fOj+2MsUTMptVv+4CM=;
        b=EKAMFJQjaQjm6h5KX262uz9Oxk8NPDfFD2gOeYBm1p7JHjuqRY+HKbHtiTg13pd5Mx
         0KTIN5AfzI/F6wa9oHyqgtYONJSU4PMFF3cz1bgTBZ91dTCVav6++9y2NhrFuTz74fAY
         tuJd+JFQguUdn4eDes4QWxKhyGPqnCF0rVvBYriJCwtpZh3wA5gpRaD6YvWLT0e6U9P3
         rIcc9axmYPb+MZTLIOD3teQILNzkMv2ysghIpZq4M6z30TBV9uxwoRt1cftl/omlIArF
         GcHQL/7+6CPNZUA1GrxlrJhHZjyPeQMFa5T9xOqfuK/d4EwK+Hf+bFnNK4ARielT5sbC
         FgoA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:in-reply-to:references:from:date
         :message-id:subject:to:cc;
        bh=xQbuaHJmu5++lK1BRcq0TrFo/fOj+2MsUTMptVv+4CM=;
        b=OlQd8jWy0rTxMosLQqyv/yYpch3pPEV9096xczxUbnBCFvGXK5ff1uoyMCCrZNQtHi
         WgjusKLNEm9VrpeOPQQ1SZu0kv4YgZrRJ/fpHA+QFKKNAfyqPBI8ifU/fg+9NTK+Dem8
         MAqwAr5omeF5SGpWXC4R9PUtxREKUC4E7Dv09gw1knupAWYghYwZqdrWXOgYJnBH4+Lj
         3IUSt2jbkNmZMpLidtmDy8n7SZfOjsxugopKVG/b82++yzuBN3kM/AhLAkoLFhTD1n7k
         5VITmKZ1IeGxFbtNB6g4PkGfq9GmN7o0HWdgX+NphFVxsGauMTk0zwMWkET5QBrhZdYo
         8V0w==
X-Gm-Message-State: APjAAAWde7RpUqfGTORovXemb3pQFCJLXnMuzDhdvoVk2s/XTXqlezox
        fABtU2omBEMWKNcYu4dfydcB6tqVM2QlSRpj4Jo=
X-Google-Smtp-Source: APXvYqx5d2Nxw+Sl4M93+OWMaUeMI7XY4uSoWvgdIkc0EkLZVAJYie5jY8hbf9yP0DLngcdPPufP6RDRMQMlGsZLlOs=
X-Received: by 2002:a05:6830:1bd8:: with SMTP id v24mr23069715ota.63.1568078849557;
 Mon, 09 Sep 2019 18:27:29 -0700 (PDT)
MIME-Version: 1.0
Received: by 2002:a9d:2286:0:0:0:0:0 with HTTP; Mon, 9 Sep 2019 18:27:28 -0700 (PDT)
In-Reply-To: <20190907214359.1C52A21835@mail.kernel.org>
References: <20190906215423.23589-1-chunkeey@gmail.com> <20190907214359.1C52A21835@mail.kernel.org>
From:   Tom Psyborg <pozega.tomislav@gmail.com>
Date:   Tue, 10 Sep 2019 03:27:28 +0200
Message-ID: <CAKR_QVKv8kgXSSCwd8esw28hARA61Pah3usRi+ZZG6ss2CcS=g@mail.gmail.com>
Subject: Re: [PATCH] ath10k: restore QCA9880-AR1A (v1) detection
To:     Kalle Valo <kvalo@codeaurora.org>
Cc:     Christian Lamparter <chunkeey@gmail.com>,
        linux-wireless@vger.kernel.org, ath10k@lists.infradead.org,
        Sasha Levin <sashal@kernel.org>, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Kalle

According to this very old post
http://lists.infradead.org/pipermail/ath10k/2013-July/000021.html
seems like you've been misinformed on amount of these cards that were
put out in the market.

At least digipart only have >40000 units in stocks
https://www.digipart.com/part/QCA9880-AR1A and other retailers
probably few thousands more.

With that large amount of cards I think it is justified to request
firmware support for the chip. And probably a lot easier to make few
firmware modifications than go hacking a bunch of API calls so it
works with v2 firmware.

I made some modifications to driver and it differentiates properly
between v1 and v2 card, this is the current status bootlog:

[    0.000000] Linux version 4.19.57 (whtw46ww4@I5576) (gcc version
7.4.0 (OpenWrt GCC 7.4.0 r10563-db8e08a)) #0 Sun Jul 21 09:26:06 2019
[    0.000000] bootconsole [early0] enabled
[    0.000000] CPU0 revision is: 00019750 (MIPS 74Kc)
[    0.000000] MIPS: machine is TP-Link Archer C7 v1
[    0.000000] SoC: Qualcomm Atheros QCA9558 ver 1 rev 0
[    0.000000] Determined physical RAM map:
[    0.000000]  memory: 08000000 @ 00000000 (usable)
[    0.000000] debug: ignoring loglevel setting.
[    0.000000] Initrd not found or empty - disabling initrd
[    0.000000] Primary instruction cache 64kB, VIPT, 4-way, linesize 32 bytes.
[    0.000000] Primary data cache 32kB, 4-way, VIPT, cache aliases,
linesize 32 bytes
[    0.000000] Zone ranges:
[    0.000000]   Normal   [mem 0x0000000000000000-0x0000000007ffffff]
[    0.000000] Movable zone start for each node
[    0.000000] Early memory node ranges
[    0.000000]   node   0: [mem 0x0000000000000000-0x0000000007ffffff]
[    0.000000] Initmem setup node 0 [mem 0x0000000000000000-0x0000000007ffffff]
[    0.000000] On node 0 totalpages: 32768
[    0.000000]   Normal zone: 288 pages used for memmap
[    0.000000]   Normal zone: 0 pages reserved
[    0.000000]   Normal zone: 32768 pages, LIFO batch:7
[    0.000000] random: get_random_bytes called from
start_kernel+0x98/0x51c with crng_init=0
[    0.000000] pcpu-alloc: s0 r0 d32768 u32768 alloc=1*32768
[    0.000000] pcpu-alloc: [0] 0
[    0.000000] Built 1 zonelists, mobility grouping on.  Total pages: 32480
[    0.000000] Kernel command line: console=ttyS0,115200n8
rootfstype=squashfs,jffs2 ignore_loglevel
[    0.000000] Dentry cache hash table entries: 16384 (order: 4, 65536 bytes)
[    0.000000] Inode-cache hash table entries: 8192 (order: 3, 32768 bytes)
[    0.000000] Writing ErrCtl register=00000000
[    0.000000] Readback ErrCtl register=00000000
[    0.000000] Memory: 118256K/131072K available (4518K kernel code,
269K rwdata, 1104K rodata, 4980K init, 215K bss, 12816K reserved, 0K
cma-reserved)
[    0.000000] SLUB: HWalign=32, Order=0-3, MinObjects=0, CPUs=1, Nodes=1
[    0.000000] NR_IRQS: 51
[    0.000000] CPU clock: 720.000 MHz
[    0.000000] clocksource: MIPS: mask: 0xffffffff max_cycles:
0xffffffff, max_idle_ns: 5309056796 ns
[    0.000007] sched_clock: 32 bits at 360MHz, resolution 2ns, wraps
every 5965232126ns
[    0.008691] Calibrating delay loop... 358.80 BogoMIPS (lpj=1794048)
[    0.075695] pid_max: default: 32768 minimum: 301
[    0.081040] Mount-cache hash table entries: 1024 (order: 0, 4096 bytes)
[    0.088408] Mountpoint-cache hash table entries: 1024 (order: 0, 4096 bytes)
[    0.100532] clocksource: jiffies: mask: 0xffffffff max_cycles:
0xffffffff, max_idle_ns: 19112604462750000 ns
[    0.111534] futex hash table entries: 256 (order: -1, 3072 bytes)
[    0.118449] pinctrl core: initialized pinctrl subsystem
[    0.125072] NET: Registered protocol family 16
[    0.137497] PCI host bridge /ahb/pcie-controller@18250000 ranges:
[    0.144293]  MEM 0x0000000012000000..0x0000000013ffffff
[    0.150153]   IO 0x0000000000000001..0x0000000000000001
[    0.173135] PCI host bridge to bus 0000:00
[    0.177708] pci_bus 0000:00: root bus resource [mem 0x12000000-0x13ffffff]
[    0.185419] pci_bus 0000:00: root bus resource [io  0x0001]
[    0.191622] pci_bus 0000:00: root bus resource [??? 0x00000000 flags 0x0]
[    0.199195] pci_bus 0000:00: No busn resource found for root bus,
will use [bus 00-ff]
[    0.208053] pci 0000:00:00.0: [168c:003c] type 00 class 0x028000
[    0.214800] pci 0000:00:00.0: reg 0x10: [mem 0x00000000-0x001fffff 64bit]
[    0.222408] pci 0000:00:00.0: reg 0x30: [mem 0x00000000-0x0000ffff pref]
[    0.229953] pci 0000:00:00.0: supports D1 D2
[    0.235724] pci_bus 0000:00: busn_res: [bus 00-ff] end is updated to 00
[    0.243140] pci 0000:00:00.0: BAR 0: assigned [mem
0x12000000-0x121fffff 64bit]
[    0.251297] pci 0000:00:00.0: BAR 6: assigned [mem
0x12200000-0x1220ffff pref]
[    0.262142] clocksource: Switched to clocksource MIPS
[    0.304897] NET: Registered protocol family 2
[    0.310448] tcp_listen_portaddr_hash hash table entries: 512
(order: 0, 4096 bytes)
[    0.319090] TCP established hash table entries: 1024 (order: 0, 4096 bytes)
[    0.326880] TCP bind hash table entries: 1024 (order: 0, 4096 bytes)
[    0.333978] TCP: Hash tables configured (established 1024 bind 1024)
[    0.341161] UDP hash table entries: 256 (order: 0, 4096 bytes)
[    0.347721] UDP-Lite hash table entries: 256 (order: 0, 4096 bytes)
[    0.355054] NET: Registered protocol family 1
[    0.359955] PCI: CLS 0 bytes, default 32
[    2.602152] random: fast init done
[    5.128772] Crashlog allocated RAM at address 0x3f00000
[    5.135884] workingset: timestamp_bits=14 max_order=15 bucket_order=1
[    5.148697] squashfs: version 4.0 (2009/01/31) Phillip Lougher
[    5.155250] jffs2: version 2.2 (NAND) (SUMMARY) (LZMA) (RTIME)
(CMODE_PRIORITY) (c) 2001-2006 Red Hat, Inc.
[    5.232790] io scheduler noop registered
[    5.237160] io scheduler deadline registered (default)
[    5.243159] ar7200-usb-phy 18030000.usb-phy0: phy reset is missing
[    5.250094] ar7200-usb-phy 18030010.usb-phy1: phy reset is missing
[    5.258595] pinctrl-single 1804002c.pinmux: 544 pins, size 68
[    5.265572] gpio-export gpio-export: 2 gpio(s) exported
[    5.272126] Serial: 8250/16550 driver, 1 ports, IRQ sharing disabled
[    5.279862] console [ttyS0] disabled
[    5.283922] 18020000.uart: ttyS0 at MMIO 0x18020000 (irq = 9,
base_baud = 2500000) is a 16550A
[    5.293553] console [ttyS0] enabled
[    5.300959] bootconsole [early0] disabled
[    5.327081] m25p80 spi0.0: s25fl064k (8192 Kbytes)
[    5.331977] 3 fixed-partitions partitions found on MTD device spi0.0
[    5.338440] Creating 3 MTD partitions on "spi0.0":
[    5.343320] 0x000000000000-0x000000020000 : "u-boot"
[    5.349085] 0x000000020000-0x0000007f0000 : "firmware"
[    5.356806] 2 tplink-fw partitions found on MTD device firmware
[    5.362861] Creating 2 MTD partitions on "firmware":
[    5.367902] 0x000000000000-0x000000100000 : "kernel"
[    5.373680] 0x000000100000-0x0000007d0000 : "rootfs"
[    5.379320] mtd: device 3 (rootfs) set to be root filesystem
[    5.386376] mtdsplit: no squashfs found in "rootfs"
[    5.391368] 0x0000007f0000-0x000000800000 : "art"
[    5.397879] libphy: Fixed MDIO Bus: probed
[    5.753920] libphy: ag71xx_mdio: probed
[    5.778627] switch0: Atheros AR8327 rev. 4 switch registered on mdio-bus.0
[    6.431314] ag71xx 19000000.eth: connected to PHY at mdio-bus.0:00
[uid=004dd034, driver=Atheros AR8216/AR8236/AR8316]
[    6.442773] eth0: Atheros AG71xx at 0xb9000000, irq 4, mode: rgmii
[    6.801780] ag71xx 1a000000.eth: connected to PHY at fixed-0:00
[uid=00000000, driver=Generic PHY]
[    6.811442] eth1: Atheros AG71xx at 0xba000000, irq 5, mode: sgmii
[    6.820003] NET: Registered protocol family 10
[    6.829252] Segment Routing with IPv6
[    6.833117] NET: Registered protocol family 17
[    6.837701] 8021q: 802.1Q VLAN Support v1.8
[    6.862923] Freeing unused kernel memory: 4980K
[    6.867527] This architecture does not have kernel memory protection.
[    6.874085] Run /init as init process
[    6.889985] init: Console is alive
[    6.893771] init: - watchdog -
[    6.915582] kmodloader: loading kernel modules from /etc/modules-boot.d/*
[    6.931970] usbcore: registered new interface driver usbfs
[    6.937657] usbcore: registered new interface driver hub
[    6.943149] usbcore: registered new device driver usb
[    6.953795] ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Driver
[    6.961871] ehci-platform: EHCI generic platform driver
[    6.967460] ehci-platform 1b000000.usb: EHCI Host Controller
[    6.973270] ehci-platform 1b000000.usb: new USB bus registered,
assigned bus number 1
[    6.981281] ehci-platform 1b000000.usb: irq 14, io mem 0x1b000000
[    7.012216] ehci-platform 1b000000.usb: USB 2.0 started, EHCI 1.00
[    7.019257] hub 1-0:1.0: USB hub found
[    7.023457] hub 1-0:1.0: 1 port detected
[    7.027987] ehci-platform 1b400000.usb: EHCI Host Controller
[    7.033824] ehci-platform 1b400000.usb: new USB bus registered,
assigned bus number 2
[    7.041847] ehci-platform 1b400000.usb: irq 15, io mem 0x1b400000
[    7.072165] ehci-platform 1b400000.usb: USB 2.0 started, EHCI 1.00
[    7.079206] hub 2-0:1.0: USB hub found
[    7.083403] hub 2-0:1.0: 1 port detected
[    7.088430] kmodloader: done loading kernel modules from
/etc/modules-boot.d/*
[    7.106193] init: - preinit -
[    7.291223] random: jshn: uninitialized urandom read (4 bytes read)
[    7.369076] random: jshn: uninitialized urandom read (4 bytes read)
[    7.538353] random: jshn: uninitialized urandom read (4 bytes read)
[    8.515044] urandom_read: 4 callbacks suppressed
[    8.515051] random: procd: uninitialized urandom read (4 bytes read)
[    8.531594] IPv6: ADDRCONF(NETDEV_UP): eth1: link is not ready
[    8.537651] IPv6: ADDRCONF(NETDEV_UP): eth1.1: link is not ready
[    9.573291] eth1: link up (1000Mbps/Full duplex)
[    9.577999] IPv6: ADDRCONF(NETDEV_CHANGE): eth1: link becomes ready
[    9.584709] IPv6: ADDRCONF(NETDEV_CHANGE): eth1.1: link becomes ready
[   11.669504] eth1: link down
[   11.688655] procd: - early -
[   11.691672] procd: - watchdog -
[   12.239816] procd: - watchdog -
[   12.243288] procd: - ubus -
[   12.252031] random: ubusd: uninitialized urandom read (4 bytes read)
[   12.296521] random: ubusd: uninitialized urandom read (4 bytes read)
[   12.304295] procd: - init -
[   12.714303] kmodloader: loading kernel modules from /etc/modules.d/*
[   12.730578] urngd: v1.0.0 started.
[   12.756700] Loading modules backported from Linux version
v5.2-rc7-0-g6fbc7275c7a9
[   12.764427] Backport generated by backports.git v5.2-rc7-1-0-g021a6ba1
[   12.820407] xt_time: kernel timezone is -0000
[   12.982093] PPP generic driver version 2.4.2
[   12.992983] NET: Registered protocol family 24
[   13.002433] random: crng init done
[   13.038820] ath10k_pci 0000:00:00.0: pci probe 168c:003c 168c:3223
[   13.045528] ath10k_pci 0000:00:00.0: enabling device (0000 -> 0002)
[   13.051917] ath10k_pci 0000:00:00.0: boot pci_mem 0x1cb18953
[   13.060199] ath10k_pci 0000:00:00.0: pci irq legacy oper_irq_mode 1
irq_mode 0 reset_mode 0
[   13.068700] ath10k_pci 0000:00:00.0: boot qca99x0 chip reset
[   13.074453] ath10k_pci 0000:00:00.0: boot cold reset
[   13.079495] ath10k_pci 0000:00:00.0: boot target and PCIe out of reset
[   13.086124] ath10k_pci 0000:00:00.0: boot cold reset complete
[   13.091955] ath10k_pci 0000:00:00.0: boot waiting target to initialise
[   13.098589] ath10k_pci 0000:00:00.0: boot target indicator 0
[   13.114327] ath10k_pci 0000:00:00.0: boot target indicator 0
[   13.130053] ath10k_pci 0000:00:00.0: boot target indicator 0
[   13.145790] ath10k_pci 0000:00:00.0: boot target indicator 0
[   13.161521] ath10k_pci 0000:00:00.0: boot target indicator 0
[   13.177252] ath10k_pci 0000:00:00.0: boot target indicator 0
[   13.192988] ath10k_pci 0000:00:00.0: boot target indicator 0
[   13.208717] ath10k_pci 0000:00:00.0: boot target indicator 0
[   13.224458] ath10k_pci 0000:00:00.0: boot target indicator 0
[   13.240183] ath10k_pci 0000:00:00.0: boot target indicator 0
[   13.255914] ath10k_pci 0000:00:00.0: boot target indicator 0
[   13.271643] ath10k_pci 0000:00:00.0: boot target indicator 0
[   13.287376] ath10k_pci 0000:00:00.0: boot target indicator 0
[   13.303112] ath10k_pci 0000:00:00.0: boot target indicator 0
[   13.318842] ath10k_pci 0000:00:00.0: boot target indicator 2
[   13.324613] ath10k_pci 0000:00:00.0: boot target initialised
[   13.330355] ath10k_pci 0000:00:00.0: boot qca99x0 chip reset complete (cold)
[   13.337552] ath10k_pci 0000:00:00.0: boot hif power up
[   13.342788] ath10k_pci 0000:00:00.0: boot qca99x0 chip reset
[   13.348528] ath10k_pci 0000:00:00.0: boot cold reset
[   13.353584] ath10k_pci 0000:00:00.0: boot target and PCIe out of reset
[   13.360205] ath10k_pci 0000:00:00.0: boot cold reset complete
[   13.366043] ath10k_pci 0000:00:00.0: boot waiting target to initialise
[   13.372678] ath10k_pci 0000:00:00.0: boot target indicator 2
[   13.378428] ath10k_pci 0000:00:00.0: boot target initialised
[   13.384181] ath10k_pci 0000:00:00.0: boot qca99x0 chip reset complete (cold)
[   13.391374] ath10k_pci 0000:00:00.0: boot init ce src ring id 0
entries 16 base_addr 2ceb9a7e
[   13.400070] ath10k_pci 0000:00:00.0: boot ce dest ring id 1 entries
128 base_addr 289c278c
[   13.408497] ath10k_pci 0000:00:00.0: boot ce dest ring id 2 entries
64 base_addr c0e40e4c
[   13.416844] ath10k_pci 0000:00:00.0: boot init ce src ring id 3
entries 32 base_addr 139e13fb
[   13.425772] ath10k_pci 0000:00:00.0: boot init ce src ring id 4
entries 8192 base_addr 42800924
[   13.434638] ath10k_pci 0000:00:00.0: boot ce dest ring id 5 entries
128 base_addr 230402d2
[   13.443068] ath10k_pci 0000:00:00.0: boot init ce src ring id 7
entries 2 base_addr 11334358
[   13.451652] ath10k_pci 0000:00:00.0: boot ce dest ring id 7 entries
2 base_addr 70d67374
[   13.460652] ath10k_pci 0000:00:00.0: bmi get target info
[   13.466143] ath10k_pci 0000:00:00.0: Hardware name qca988x hw1.0
version 0x4000002c
[   13.563795] firmware ath10k!pre-cal-pci-0000:00:00.0.bin:
firmware_loading_store: map pages failed
[   13.573090] ath10k_pci 0000:00:00.0: boot fw request
'ath10k/pre-cal-pci-0000:00:00.0.bin': -11
[   13.761310] firmware ath10k!cal-pci-0000:00:00.0.bin:
firmware_loading_store: map pages failed
[   13.770242] ath10k_pci 0000:00:00.0: boot fw request
'ath10k/cal-pci-0000:00:00.0.bin': -11
[   13.778749] ath10k_pci 0000:00:00.0: trying fw api 6
[   13.962772] firmware ath10k!QCA988X!hw2.0!firmware-6.bin:
firmware_loading_store: map pages failed
[   13.972018] ath10k_pci 0000:00:00.0: boot fw request
'ath10k/QCA988X/hw2.0/firmware-6.bin': -11
[   13.980888] ath10k_pci 0000:00:00.0: trying fw api 5
[   14.004273] ath10k_pci 0000:00:00.0: boot fw request
'ath10k/QCA988X/hw2.0/firmware-5.bin': 0
[   14.012975] ath10k_pci 0000:00:00.0: found fw version 10.2.4-1.0-00043
[   14.019600] ath10k_pci 0000:00:00.0: found fw timestamp 1541656652
[   14.025891] ath10k_pci 0000:00:00.0: found otp image ie (7221 B)
[   14.031981] ath10k_pci 0000:00:00.0: found fw image ie (241515 B)
[   14.038172] ath10k_pci 0000:00:00.0: found firmware features ie (3 B)
[   14.044715] ath10k_pci 0000:00:00.0: Enabling feature bit: 3
[   14.050452] ath10k_pci 0000:00:00.0: Enabling feature bit: 10
[   14.056292] ath10k_pci 0000:00:00.0: Enabling feature bit: 12
[   14.062121] ath10k_pci 0000:00:00.0: Enabling feature bit: 16
[   14.067957] ath10k_pci 0000:00:00.0: features
[   14.072396] ath10k_pci 0000:00:00.0: 00000000: 00 01 14 08
                            ....
[   14.081658] ath10k_pci 0000:00:00.0: found fw ie wmi op version 5
[   14.087848] ath10k_pci 0000:00:00.0: found fw ie htt op version 2
[   14.094046] ath10k_pci 0000:00:00.0: using fw api 5
[   14.099004] ath10k_pci 0000:00:00.0: qca988x hw1.0 target
0x4000002c chip_id 0x043200ff sub 168c:3223
[   14.108373] ath10k_pci 0000:00:00.0: kconfig debug 1 debugfs 1
tracing 1 dfs 1 testmode 1
[   14.121519] ath10k_pci 0000:00:00.0: firmware ver 10.2.4-1.0-00043
api 5 features no-p2p,raw-mode,mfp,allows-mesh-bcast crc32 ed0aafd8
[   14.133799] ath10k_pci 0000:00:00.0: boot did not find a pre
calibration file, try DT next: -11
[   14.142638] ath10k_pci 0000:00:00.0: unable to load pre cal data from DT: -2
[   14.149787] ath10k_pci 0000:00:00.0: could not load pre cal data: -2
[   14.156243] ath10k_pci 0000:00:00.0: boot upload otp to 0x1234 len
7221 for board id
[   14.164111] ath10k_pci 0000:00:00.0: bmi fast download address
0x1234 buffer 0x3ca910fe length 7221
[   14.173297] ath10k_pci 0000:00:00.0: bmi lz stream start address 0x1234
[   14.253843] ath10k_pci 0000:00:00.0: bmi lz data buffer 0x3ca910fe
length 7220
[   14.285961] ath10k_pci 0000:00:00.0: bmi lz data buffer 0x9fc59964 length 4
[   14.293057] ath10k_pci 0000:00:00.0: bmi lz stream start address 0x0
[   14.299517] ath10k_pci 0000:00:00.0: bmi execute address 0x1234 param 0x10
[   14.306655] ath10k_pci 0000:00:00.0: bmi execute result 0x10
[   14.312413] ath10k_pci 0000:00:00.0: boot get otp board id result
0x00000010 board_id 0 chip_id 0 ext_bid_support 0
[   14.323010] ath10k_pci 0000:00:00.0: board id does not exist in
otp, ignore it
[   14.330335] ath10k_pci 0000:00:00.0: SMBIOS bdf variant name not set.
[   14.336877] ath10k_pci 0000:00:00.0: DT bdf variant name not set.
[   14.343077] ath10k_pci 0000:00:00.0: boot using board name
'bus=pci,vendor=168c,device=003c,subsystem-vendor=168c,subsystem-device=3223'
[   14.355522] ath10k_pci 0000:00:00.0: boot using board name
'bus=pci,vendor=168c,device=003c,subsystem-vendor=168c,subsystem-device=3223'
[   14.458077] firmware ath10k!QCA988X!hw2.0!board-2.bin:
firmware_loading_store: map pages failed
[   14.467099] ath10k_pci 0000:00:00.0: boot fw request
'ath10k/QCA988X/hw2.0/board-2.bin': -11
[   14.482333] ath10k_pci 0000:00:00.0: boot fw request
'ath10k/QCA988X/hw2.0/board.bin': 0
[   14.490551] ath10k_pci 0000:00:00.0: using board api 1
[   14.495851] ath10k_pci 0000:00:00.0: board_file api 1 bmi_id N/A
crc32 bebc7c08
[   14.503280] ath10k_pci 0000:00:00.0: bmi start
[   14.507790] ath10k_pci 0000:00:00.0: bmi write address 0x400800 length 4
[   14.546287] ath10k_pci 0000:00:00.0: bmi read address 0x400810 length 4
[   14.557471] ath10k_pci 0000:00:00.0: bmi write address 0x400810 length 4
[   14.572212] ath10k_pci 0000:00:00.0: bmi write address 0x400844 length 4
[   14.592214] ath10k_pci 0000:00:00.0: bmi write address 0x400904 length 4
[   14.602208] ath10k_pci 0000:00:00.0: bmi write address 0x4008bc length 4
[   14.622213] ath10k_pci 0000:00:00.0: boot did not find a pre
calibration file, try DT next: -11
[   14.631043] ath10k_pci 0000:00:00.0: unable to load pre cal data from DT: -2
[   14.638205] ath10k_pci 0000:00:00.0: failed to load pre cal data: -2
[   14.644657] ath10k_pci 0000:00:00.0: pre cal download procedure
failed, try cal file: -2
[   14.652880] ath10k_pci 0000:00:00.0: boot did not find a
calibration file, try DT next: -11
[   14.661349] ath10k_pci 0000:00:00.0: boot did not find DT entry,
try target EEPROM next: -2
[   14.669830] ath10k_pci 0000:00:00.0: boot did not find target
EEPROM entry, try OTP next: -122
[   14.678578] ath10k_pci 0000:00:00.0: bmi read address 0x4008ac length 4
[   14.695286] ath10k_pci 0000:00:00.0: boot push board extended data addr 0x0
[   14.702401] ath10k_pci 0000:00:00.0: bmi read address 0x400854 length 4
[   14.709186] ath10k_pci 0000:00:00.0: bmi write address 0x401cb0 length 2116
[   14.719947] ath10k_pci 0000:00:00.0: bmi write address 0x400858 length 4
[   14.726782] ath10k_pci 0000:00:00.0: boot upload otp to 0x1234 len 7221
[   14.733509] ath10k_pci 0000:00:00.0: bmi fast download address
0x1234 buffer 0x3ca910fe length 7221
[   14.742691] ath10k_pci 0000:00:00.0: bmi lz stream start address 0x1234
[   14.749419] ath10k_pci 0000:00:00.0: bmi lz data buffer 0x3ca910fe
length 7220
[   14.781532] ath10k_pci 0000:00:00.0: bmi lz data buffer 0x51c0dfb6 length 4
[   14.788635] ath10k_pci 0000:00:00.0: bmi lz stream start address 0x0
[   14.795111] ath10k_pci 0000:00:00.0: bmi execute address 0x1234 param 0x0
[   14.802126] ath10k_pci 0000:00:00.0: bmi execute result 0x0
[   14.807791] ath10k_pci 0000:00:00.0: boot otp execute result 0
[   14.813716] ath10k_pci 0000:00:00.0: boot using calibration mode otp
[   14.820166] ath10k_pci 0000:00:00.0: boot uploading firmware image
c21dc34c len 241515
[   14.828219] ath10k_pci 0000:00:00.0: bmi fast download address
0x1234 buffer 0xc21dc34c length 241515
[   14.837583] ath10k_pci 0000:00:00.0: bmi lz stream start address 0x1234
[   14.844343] ath10k_pci 0000:00:00.0: bmi lz data buffer 0xc21dc34c
length 241512
[   15.865780] ath10k_pci 0000:00:00.0: bmi lz data buffer 0x9fc59964 length 4
[   15.872878] ath10k_pci 0000:00:00.0: bmi lz stream start address 0x0
[   15.879337] ath10k_pci 0000:00:00.0: bmi write address 0x400814 length 4
[   15.886185] ath10k_pci 0000:00:00.0: pci hif map service
[   15.891585] ath10k_pci 0000:00:00.0: boot htc service 'Control' ul
pipe 0 dl pipe 1 eid 0 ready
[   15.900428] ath10k_pci 0000:00:00.0: boot htc service 'Control' eid
0 TX flow control disabled
[   15.909175] ath10k_pci 0000:00:00.0: bmi done
[   15.913627] ath10k_pci 0000:00:00.0: htt tx max num pending tx 1424
[   15.920206] ath10k_pci 0000:00:00.0: htt rx ring size 512 fill_level 255
[   15.927035] ath10k_pci 0000:00:00.0: boot hif start
[   17.012155] ath10k_pci 0000:00:00.0: failed to receive control
response completion, polling..
[   17.020805] ath10k_pci 0000:00:00.0: pci hif send complete check
[   17.026909] ath10k_pci 0000:00:00.0: Copy Engine register dump:
[   17.032936] ath10k_pci 0000:00:00.0: [00]: 0x00057400  10  10  11  10
[   17.039476] ath10k_pci 0000:00:00.0: [01]: 0x00057800   6   6   5   6
[   17.046029] ath10k_pci 0000:00:00.0: [02]: 0x00057c00   0   0  63   0
[   17.052581] ath10k_pci 0000:00:00.0: [03]: 0x00058000   0   0   0   0
[   17.059117] ath10k_pci 0000:00:00.0: [04]: 0x00058400   0   0   0   0
[   17.065671] ath10k_pci 0000:00:00.0: [05]: 0x00058800   0   0   0   0
[   17.072224] ath10k_pci 0000:00:00.0: [06]: 0x00058c00   0   0   0   0
[   17.078760] ath10k_pci 0000:00:00.0: [07]: 0x00059000   1   1   1   1
[   17.085320] ath10k_pci 0000:00:00.0: pci hif send complete check
[   17.091414] ath10k_pci 0000:00:00.0: Copy Engine register dump:
[   17.097440] ath10k_pci 0000:00:00.0: [00]: 0x00057400  10  10  11  10
[   17.103994] ath10k_pci 0000:00:00.0: [01]: 0x00057800   6   6   5   6
[   17.110538] ath10k_pci 0000:00:00.0: [02]: 0x00057c00   0   0  63   0
[   17.117087] ath10k_pci 0000:00:00.0: [03]: 0x00058000   0   0   0   0
[   17.123640] ath10k_pci 0000:00:00.0: [04]: 0x00058400   0   0   0   0
[   17.130178] ath10k_pci 0000:00:00.0: [05]: 0x00058800   0   0   0   0
[   17.136730] ath10k_pci 0000:00:00.0: [06]: 0x00058c00   0   0   0   0
[   17.143284] ath10k_pci 0000:00:00.0: [07]: 0x00059000   1   1   1   1
[   17.149842] ath10k_pci 0000:00:00.0: pci hif send complete check
[   17.155950] ath10k_pci 0000:00:00.0: Copy Engine register dump:
[   17.161967] ath10k_pci 0000:00:00.0: [00]: 0x00057400  10  10  11  10
[   17.168516] ath10k_pci 0000:00:00.0: [01]: 0x00057800   6   6   5   6
[   17.175068] ath10k_pci 0000:00:00.0: [02]: 0x00057c00   0   0  63   0
[   17.181606] ath10k_pci 0000:00:00.0: [03]: 0x00058000   0   0   0   0
[   17.188157] ath10k_pci 0000:00:00.0: [04]: 0x00058400   0   0   0   0
[   17.194711] ath10k_pci 0000:00:00.0: [05]: 0x00058800   0   0   0   0
[   17.201246] ath10k_pci 0000:00:00.0: [06]: 0x00058c00   0   0   0   0
[   17.207802] ath10k_pci 0000:00:00.0: [07]: 0x00059000   1   1   1   1
[   17.214355] ath10k_pci 0000:00:00.0: pci hif send complete check
[   17.220448] ath10k_pci 0000:00:00.0: Copy Engine register dump:
[   17.226478] ath10k_pci 0000:00:00.0: [00]: 0x00057400  10  10  11  10
[   17.233029] ath10k_pci 0000:00:00.0: [01]: 0x00057800   6   6   5   6
[   17.239570] ath10k_pci 0000:00:00.0: [02]: 0x00057c00   0   0  63   0
[   17.246128] ath10k_pci 0000:00:00.0: [03]: 0x00058000   0   0   0   0
[   17.252675] ath10k_pci 0000:00:00.0: [04]: 0x00058400   0   0   0   0
[   17.259212] ath10k_pci 0000:00:00.0: [05]: 0x00058800   0   0   0   0
[   17.265764] ath10k_pci 0000:00:00.0: [06]: 0x00058c00   0   0   0   0
[   17.272319] ath10k_pci 0000:00:00.0: [07]: 0x00059000   1   1   1   1
[   17.278861] ath10k_pci 0000:00:00.0: pci hif send complete check
[   17.284967] ath10k_pci 0000:00:00.0: Copy Engine register dump:
[   17.290980] ath10k_pci 0000:00:00.0: [00]: 0x00057400  10  10  11  10
[   17.297533] ath10k_pci 0000:00:00.0: [01]: 0x00057800   6   6   5   6
[   17.304084] ath10k_pci 0000:00:00.0: [02]: 0x00057c00   0   0  63   0
[   17.310620] ath10k_pci 0000:00:00.0: [03]: 0x00058000   0   0   0   0
[   17.317176] ath10k_pci 0000:00:00.0: [04]: 0x00058400   0   0   0   0
[   17.323729] ath10k_pci 0000:00:00.0: [05]: 0x00058800   0   0   0   0
[   17.330274] ath10k_pci 0000:00:00.0: [06]: 0x00058c00   0   0   0   0
[   17.336824] ath10k_pci 0000:00:00.0: [07]: 0x00059000   1   1   1   1
[   17.343380] ath10k_pci 0000:00:00.0: pci hif send complete check
[   17.349474] ath10k_pci 0000:00:00.0: Copy Engine register dump:
[   17.355501] ath10k_pci 0000:00:00.0: [00]: 0x00057400  10  10  11  10
[   17.362044] ath10k_pci 0000:00:00.0: [01]: 0x00057800   6   6   5   6
[   17.368594] ath10k_pci 0000:00:00.0: [02]: 0x00057c00   0   0  63   0
[   17.375144] ath10k_pci 0000:00:00.0: [03]: 0x00058000   0   0   0   0
[   17.381682] ath10k_pci 0000:00:00.0: [04]: 0x00058400   0   0   0   0
[   17.388235] ath10k_pci 0000:00:00.0: [05]: 0x00058800   0   0   0   0
[   17.394790] ath10k_pci 0000:00:00.0: [06]: 0x00058c00   0   0   0   0
[   17.401331] ath10k_pci 0000:00:00.0: [07]: 0x00059000   1   1   1   1
[   17.407900] ath10k_pci 0000:00:00.0: pci hif send complete check
[   17.414006] ath10k_pci 0000:00:00.0: Copy Engine register dump:
[   17.420018] ath10k_pci 0000:00:00.0: [00]: 0x00057400  10  10  11  10
[   17.426570] ath10k_pci 0000:00:00.0: [01]: 0x00057800   6   6   5   6
[   17.433119] ath10k_pci 0000:00:00.0: [02]: 0x00057c00   0   0  63   0
[   17.439659] ath10k_pci 0000:00:00.0: [03]: 0x00058000   0   0   0   0
[   17.446207] ath10k_pci 0000:00:00.0: [04]: 0x00058400   0   0   0   0
[   17.452753] ath10k_pci 0000:00:00.0: [05]: 0x00058800   0   0 127   0
[   17.459288] ath10k_pci 0000:00:00.0: [06]: 0x00058c00   0   0   0   0
[   17.465844] ath10k_pci 0000:00:00.0: [07]: 0x00059000   1   1   1   1
[   17.472393] ath10k_pci 0000:00:00.0: pci hif send complete check
[   17.478482] ath10k_pci 0000:00:00.0: Copy Engine register dump:
[   17.484509] ath10k_pci 0000:00:00.0: [00]: 0x00057400  10  10  11  10
[   17.491052] ath10k_pci 0000:00:00.0: [01]: 0x00057800   6   6   5   6
[   17.497600] ath10k_pci 0000:00:00.0: [02]: 0x00057c00   0   0  63   0
[   17.504152] ath10k_pci 0000:00:00.0: [03]: 0x00058000   0   0   0   0
[   17.510689] ath10k_pci 0000:00:00.0: [04]: 0x00058400   0   0   0   0
[   17.517242] ath10k_pci 0000:00:00.0: [05]: 0x00058800   0   0 127   0
[   17.523797] ath10k_pci 0000:00:00.0: [06]: 0x00058c00   0   0   0   0
[   17.530341] ath10k_pci 0000:00:00.0: [07]: 0x00059000   1   1   1   1
[   18.612158] ath10k_pci 0000:00:00.0: ctl_resp never came in (-145)
[   18.618427] ath10k_pci 0000:00:00.0: failed to connect to HTC: -145
[   18.624797] ath10k_pci 0000:00:00.0: boot hif stop
[   18.630758] ath10k_pci 0000:00:00.0: could not init core (-145)
[   18.636893] ath10k_pci 0000:00:00.0: boot hif power down
[   18.642304] ath10k_pci 0000:00:00.0: could not probe fw (-145)
[   18.694782] ath: EEPROM regdomain: 0x0
[   18.698591] ath: EEPROM indicates default country code should be used
[   18.705152] ath: doing EEPROM country->regdmn map search
[   18.710550] ath: country maps to regdmn code: 0x3a
[   18.715420] ath: Country alpha2 being used: US
[   18.719921] ath: Regpair used: 0x3a
[   18.741147] ieee80211 phy1: Selected rate control algorithm 'minstrel_ht'
[   18.749490] ieee80211 phy1: Atheros AR9550 Rev:0 mem=0xb8100000, irq=12
[   18.812526] kmodloader: done loading kernel modules from /etc/modules.d/*
[   47.429359] IPv6: ADDRCONF(NETDEV_UP): eth1: link is not ready
[   47.436481] eth1: link up (1000Mbps/Full duplex)
[   47.441181] IPv6: ADDRCONF(NETDEV_CHANGE): eth1: link becomes ready
[   47.475602] br-lan: port 1(eth1.1) entered blocking state
[   47.481087] br-lan: port 1(eth1.1) entered disabled state
[   47.486905] device eth1.1 entered promiscuous mode
[   47.491769] device eth1 entered promiscuous mode
[   47.546852] br-lan: port 1(eth1.1) entered blocking state
[   47.552373] br-lan: port 1(eth1.1) entered forwarding state
[   47.558177] IPv6: ADDRCONF(NETDEV_UP): br-lan: link is not ready
[   47.646842] IPv6: ADDRCONF(NETDEV_UP): eth0: link is not ready
[   47.674813] IPv6: ADDRCONF(NETDEV_UP): eth0.2: link is not ready
[   48.452468] IPv6: ADDRCONF(NETDEV_CHANGE): br-lan: link becomes ready
[   48.693435] eth0: link up (1000Mbps/Full duplex)
[   48.698191] IPv6: ADDRCONF(NETDEV_CHANGE): eth0: link becomes ready
[   48.722234] IPv6: ADDRCONF(NETDEV_CHANGE): eth0.2: link becomes ready

Regards, Tom
