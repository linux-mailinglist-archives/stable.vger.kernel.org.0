Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7B97C181659
	for <lists+stable@lfdr.de>; Wed, 11 Mar 2020 11:56:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726684AbgCKK4M (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 11 Mar 2020 06:56:12 -0400
Received: from mail-eopbgr1410097.outbound.protection.outlook.com ([40.107.141.97]:7723
        "EHLO JPN01-OS2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726044AbgCKK4M (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 11 Mar 2020 06:56:12 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=D2/maP34Y29RUbIJmZ3cjeuEfS7wiZRDzTyE7kO17FbKQwLjpeEntaj3v9quvOZiIO68F4yek5TZKFOuiR+ey74oc7zdWUi4FuoW48kPGX2uwuBm9k3xQWNiK7nkzssXXLlUtCQBAQIp+eKnUpbMufdteSvqB89wD7F5VwAPn8EzV9E3px69DPIKKIzzoZku4c3N3z6tS2F24bMwsWSiajprB+udZ076M9Of2WU6wd+G8zaVMkSzmDo3xcL1iwsNtQfYz0arkK++fmi92+3Yk989uVGKFWkpP9TUy1DpkfoExwJMxw5lzN5Xo/dK2a/6EXzcWqJAtQGQx0NDaQkHZg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Dn7LDMULqlWdYNt0BPrsfbtH/OcSLhjNSGx/ykwxVKI=;
 b=oV67qFMSEQwt0FMgspziNkfOTStTke3JlN7vYR9lbgd38fO04Cxhrv0z3DGrY1DacQdxvwSF04kzV+EMT2DNo1BJuu7Wjt0u8andCnfOg+TsRYWRumk3VYTah02fcdsP9p8ZlGtvXoHmmpgivWu9gZiAal2QKx8Ug9j1ccy+My0cqAbRwt8w0OZud9RWiF0EKtTf3E1e5gKkaP5PBD1Wrih/yQgyjSm291NwYJF8FLLirnGOd8ubk6UNyLYbUkScVRR/H5sdBS2iBdxHyW/k0ioFBUcgqALnSV22JyRaq/tEaYA7lVVPyGxzLNUuNiMnWik4R0a9zxnV8ej1kcO5yQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=renesas.com; dmarc=pass action=none header.from=renesas.com;
 dkim=pass header.d=renesas.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=renesasgroup.onmicrosoft.com; s=selector2-renesasgroup-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Dn7LDMULqlWdYNt0BPrsfbtH/OcSLhjNSGx/ykwxVKI=;
 b=i69Rkg4Qe+wnyyXIETcsiE8eJV91gNBcNI1byeGlTiVME2CgZrtme4vppaEqaEWyoRRiLWHpSNKHM+BBhYWx7cpBvssb36yugz02iad0vpatxvbPzgTDIBpANDGSGjUEx2Cjblu6+A+OcPbhvI/WRS64wa2fVBtDPef/JwwhiH0=
Received: from OSBPR01MB2280.jpnprd01.prod.outlook.com (52.134.243.13) by
 OSBSPR01MB6.jpnprd01.prod.outlook.com (52.134.243.23) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2814.13; Wed, 11 Mar 2020 10:56:06 +0000
Received: from OSBPR01MB2280.jpnprd01.prod.outlook.com
 ([fe80::bca1:a941:6c29:d8f8]) by OSBPR01MB2280.jpnprd01.prod.outlook.com
 ([fe80::bca1:a941:6c29:d8f8%6]) with mapi id 15.20.2793.013; Wed, 11 Mar 2020
 10:56:06 +0000
From:   Chris Paterson <Chris.Paterson2@renesas.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
CC:     "torvalds@linux-foundation.org" <torvalds@linux-foundation.org>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "linux@roeck-us.net" <linux@roeck-us.net>,
        "shuah@kernel.org" <shuah@kernel.org>,
        "patches@kernelci.org" <patches@kernelci.org>,
        "ben.hutchings@codethink.co.uk" <ben.hutchings@codethink.co.uk>,
        "lkft-triage@lists.linaro.org" <lkft-triage@lists.linaro.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: RE: [PATCH 4.19 00/86] 4.19.109-stable review
Thread-Topic: [PATCH 4.19 00/86] 4.19.109-stable review
Thread-Index: AQHV9t2MWw5vCoRaqkyWbNkUiDyKMahDMLzw
Date:   Wed, 11 Mar 2020 10:56:06 +0000
Message-ID: <OSBPR01MB228067017410645AC3A78939B7FC0@OSBPR01MB2280.jpnprd01.prod.outlook.com>
References: <20200310124530.808338541@linuxfoundation.org>
In-Reply-To: <20200310124530.808338541@linuxfoundation.org>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=Chris.Paterson2@renesas.com; 
x-originating-ip: [176.27.142.199]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: d782d280-00ef-4bd3-7448-08d7c5aaccb6
x-ms-traffictypediagnostic: OSBSPR01MB6:
x-microsoft-antispam-prvs: <OSBSPR01MB69DE486DD2AA9F08CA6F9B7FC0@OSBSPR01MB6.jpnprd01.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:4502;
x-forefront-prvs: 0339F89554
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(4636009)(396003)(366004)(136003)(346002)(376002)(39860400002)(199004)(30864003)(2906002)(4326008)(52536014)(71200400001)(478600001)(7696005)(8676002)(86362001)(26005)(186003)(81166006)(81156014)(966005)(66556008)(66446008)(66476007)(64756008)(110136005)(316002)(5660300002)(54906003)(7416002)(8936002)(6506007)(76116006)(9686003)(55016002)(66946007)(33656002);DIR:OUT;SFP:1102;SCL:1;SRVR:OSBSPR01MB6;H:OSBPR01MB2280.jpnprd01.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;
received-spf: None (protection.outlook.com: renesas.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: G2JjUhDeSqqSGQW4S8fQ1GPQKrVwA22l8J+fNwDJNSyilTDDwll0WQoLZ/iXEQ0SxsgHPCCC4GbBBQwvNHpDRnL1taXBU/seJe+WAIjCD0iiTFfpz0QXYltldrZlmc7YB0f2OUm2063lrbsHKr9j8Hia0UQioXbLtIE/n54rEwlGlnqw1SJki/rUnweXzgArFi8UI0yFIFFuVGmd6ZOrf9MRaT/d6f65i24iB00j2iCaSyxsX6gTjqP71eH7BEJ+VMD0GsCipM1lH8sMD2O+mCyi/cjUfifMBvF5c+XXszF9Uy1mMW6qyu3xZJGMc/vbjCR0E3SUF6e8ISE/evGHU8kKox/0Eo9CvxIeWyXzsxpvHfBEKLm9YvbGXLdHtALpRNgCWvIRmKWmFnjiyCKT/kVYQayjBoIoQHqMLO4lNgQsoPExfe2as3LdvVcvvComJ/CjR51JxE7Gud+wwa8V6kVtjZN5/T6h+C3+EgKwVkU4/xoBx0uHh06cpnKS8GZc9JPxAYABMN9QqydEzSKTaA==
x-ms-exchange-antispam-messagedata: /rHk0UvVk7QRwK9Pmh7cjaiqRHDY4QdY3iT01FjXg/oGv1YmbAwZ0rLHB33O4aCM5PXjtgYys/DEjizz2Wf0jVZsVYAv0IknqtPq5P60VWGCOzC9LJ0Pvj+XF56cI0P9epiERNdefHrG0Rf9dowmMw==
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="Windows-1252"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: renesas.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d782d280-00ef-4bd3-7448-08d7c5aaccb6
X-MS-Exchange-CrossTenant-originalarrivaltime: 11 Mar 2020 10:56:06.3877
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 53d82571-da19-47e4-9cb4-625a166a4a2a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: PW15/uMUDg08ygsNscTLw9bQ+Mo9Em8msqEIHYFbjm5qxp1fvEjcFJl2i+mGw9wJ4+v6moo2fnxstT8SvTeKTpd8+rdFcSy1UqgiPbg18H8=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: OSBSPR01MB6
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hello Greg,

> From: stable-owner@vger.kernel.org <stable-owner@vger.kernel.org> On
> Behalf Of Greg Kroah-Hartman
> Sent: 10 March 2020 12:44
>=20
> This is the start of the stable review cycle for the 4.19.109 release.
> There are 86 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

No build/test issues seen for CIP configs for Linux 4.19.109-rc1 (624c12496=
0e8).
(Okay, there is a boot issue with the arm multi_v7_defconfig, but I'm prett=
y sure that's an issue my end that's been around for a couple of weeks now)

Build/test pipeline/logs: https://gitlab.com/cip-project/cip-testing/linux-=
stable-rc-ci/pipelines/124879010
GitLab CI pipeline: https://gitlab.com/cip-project/cip-testing/linux-cip-pi=
pelines/-/blob/master/trees/linux-4.19.y.yml

Kind regards, Chris

>=20
> Responses should be made by Thu, 12 Mar 2020 12:45:15 +0000.
> Anything received after that time might be too late.
>=20
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-
> 4.19.109-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
> linux-4.19.y
> and the diffstat can be found below.
>=20
> thanks,
>=20
> greg k-h
>=20
> -------------
> Pseudo-Shortlog of commits:
>=20
> Greg Kroah-Hartman <gregkh@linuxfoundation.org>
>     Linux 4.19.109-rc1
>=20
> Deepak Ukey <deepak.ukey@microchip.com>
>     scsi: pm80xx: Fixed kernel panic during error recovery for SATA drive
>=20
> Mikulas Patocka <mpatocka@redhat.com>
>     dm integrity: fix a deadlock due to offloading to an incorrect workqu=
eue
>=20
> Ard Biesheuvel <ardb@kernel.org>
>     efi/x86: Handle by-ref arguments covering multiple pages in mixed mod=
e
>=20
> Ard Biesheuvel <ardb@kernel.org>
>     efi/x86: Align GUIDs to their size in the mixed mode runtime wrapper
>=20
> Desnes A. Nunes do Rosario <desnesn@linux.ibm.com>
>     powerpc: fix hardware PMU exception bug on PowerVM compatibility mode
> systems
>=20
> Dan Carpenter <dan.carpenter@oracle.com>
>     dmaengine: coh901318: Fix a double lock bug in dma_tc_handle()
>=20
> Dan Carpenter <dan.carpenter@oracle.com>
>     hwmon: (adt7462) Fix an error return in ADT7462_REG_VOLT()
>=20
> Oleksandr Suvorov <oleksandr.suvorov@toradex.com>
>     ARM: dts: imx7-colibri: Fix frequency for sd/mmc
>=20
> Johan Hovold <johan@kernel.org>
>     ARM: dts: imx6dl-colibri-eval-v3: fix sram compatible properties
>=20
> Suman Anna <s-anna@ti.com>
>     ARM: dts: am437x-idk-evm: Fix incorrect OPP node names
>=20
> Ahmad Fatoum <a.fatoum@pengutronix.de>
>     ARM: imx: build v7_cpu_resume() unconditionally
>=20
> Dennis Dalessandro <dennis.dalessandro@intel.com>
>     IB/hfi1, qib: Ensure RCU is locked when accessing list
>=20
> Jason Gunthorpe <jgg@ziepe.ca>
>     RMDA/cm: Fix missing ib_cm_destroy_id() in ib_cm_insert_listen()
>=20
> Bernard Metzler <bmt@zurich.ibm.com>
>     RDMA/iwcm: Fix iwcm work deallocation
>=20
> Marco Felsch <m.felsch@pengutronix.de>
>     ARM: dts: imx6: phycore-som: fix emmc supply
>=20
> Tony Lindgren <tony@atomide.com>
>     phy: mapphone-mdm6600: Fix write timeouts with shorter GPIO toggle
> interval
>=20
> Tony Lindgren <tony@atomide.com>
>     phy: mapphone-mdm6600: Fix timeouts by adding wake-up handling
>=20
> Jernej Skrabec <jernej.skrabec@siol.net>
>     drm/sun4i: de2/de3: Remove unsupported VI layer formats
>=20
> Jernej Skrabec <jernej.skrabec@siol.net>
>     drm/sun4i: Fix DE2 VI layer format support
>=20
> Charles Keepax <ckeepax@opensource.cirrus.com>
>     ASoC: dapm: Correct DAPM handling of active widgets during shutdown
>=20
> Matthias Reichl <hias@horus.com>
>     ASoC: pcm512x: Fix unbalanced regulator enable call in probe error pa=
th
>=20
> Takashi Iwai <tiwai@suse.de>
>     ASoC: pcm: Fix possible buffer overflow in dpcm state sysfs output
>=20
> Vinod Koul <vkoul@kernel.org>
>     dmaengine: imx-sdma: remove dma_slave_config direction usage and leav=
e
> sdma_event_enable()
>=20
> Takashi Iwai <tiwai@suse.de>
>     ASoC: intel: skl: Fix possible buffer overflow in debug outputs
>=20
> Takashi Iwai <tiwai@suse.de>
>     ASoC: intel: skl: Fix pin debug prints
>=20
> Dragos Tarcatu <dragos_tarcatu@mentor.com>
>     ASoC: topology: Fix memleak in soc_tplg_manifest_load()
>=20
> Dragos Tarcatu <dragos_tarcatu@mentor.com>
>     ASoC: topology: Fix memleak in soc_tplg_link_elems_load()
>=20
> Christophe JAILLET <christophe.jaillet@wanadoo.fr>
>     spi: bcm63xx-hsspi: Really keep pll clk enabled
>=20
> Vladimir Oltean <olteanv@gmail.com>
>     ARM: dts: ls1021a: Restore MDIO compatible to gianfar
>=20
> Mikulas Patocka <mpatocka@redhat.com>
>     dm writecache: verify watermark during resume
>=20
> Mikulas Patocka <mpatocka@redhat.com>
>     dm: report suspended device during destroy
>=20
> Mikulas Patocka <mpatocka@redhat.com>
>     dm cache: fix a crash due to incorrect work item cancelling
>=20
> Dmitry Osipenko <digetx@gmail.com>
>     dmaengine: tegra-apb: Prevent race conditions of tasklet vs free list
>=20
> Dmitry Osipenko <digetx@gmail.com>
>     dmaengine: tegra-apb: Fix use-after-free
>=20
> Sean Christopherson <sean.j.christopherson@intel.com>
>     x86/pkeys: Manually set X86_FEATURE_OSPKE to preserve existing change=
s
>=20
> Hans Verkuil <hverkuil-cisco@xs4all.nl>
>     media: v4l2-mem2mem.c: fix broken links
>=20
> Jiri Slaby <jslaby@suse.cz>
>     vt: selection, push sel_lock up
>=20
> Jiri Slaby <jslaby@suse.cz>
>     vt: selection, push console lock down
>=20
> Jiri Slaby <jslaby@suse.cz>
>     vt: selection, close sel_buffer race
>=20
> Jay Dolan <jay.dolan@accesio.com>
>     serial: 8250_exar: add support for ACCES cards
>=20
> tangbin <tangbin@cmss.chinamobile.com>
>     tty:serial:mvebu-uart:fix a wrong return
>=20
> Faiz Abbas <faiz_abbas@ti.com>
>     arm: dts: dra76x: Fix mmc3 max-frequency
>=20
> OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
>     fat: fix uninit-memory access for partial initialized inode
>=20
> Huang Ying <ying.huang@intel.com>
>     mm: fix possible PMD dirty bit lost in set_pmd_migration_entry()
>=20
> Mel Gorman <mgorman@techsingularity.net>
>     mm, numa: fix bad pmd by atomically check for pmd_trans_huge when
> marking page tables prot_numa
>=20
> Zhang Xiaoxu <zhangxiaoxu5@huawei.com>
>     vgacon: Fix a UAF in vgacon_invert_region
>=20
> Eugeniu Rosca <erosca@de.adit-jv.com>
>     usb: core: port: do error out if usb_autopm_get_interface() fails
>=20
> Eugeniu Rosca <erosca@de.adit-jv.com>
>     usb: core: hub: do error out if usb_autopm_get_interface() fails
>=20
> Eugeniu Rosca <erosca@de.adit-jv.com>
>     usb: core: hub: fix unhandled return by employing a void function
>=20
> Pratham Pratap <prathampratap@codeaurora.org>
>     usb: dwc3: gadget: Update chain bit correctly when using sg list
>=20
> Dan Lazewatsky <dlaz@chromium.org>
>     usb: quirks: add NO_LPM quirk for Logitech Screen Share
>=20
> Jim Lin <jilin@nvidia.com>
>     usb: storage: Add quirk for Samsung Fit flash
>=20
> Ronnie Sahlberg <lsahlber@redhat.com>
>     cifs: don't leak -EAGAIN for stat() during reconnect
>=20
> Christian Lachner <gladiac@gmail.com>
>     ALSA: hda/realtek - Fix silent output on Gigabyte X570 Aorus Master
>=20
> Kailang Yang <kailang@realtek.com>
>     ALSA: hda/realtek - Add Headset Mic supported
>=20
> Tim Harvey <tharvey@gateworks.com>
>     net: thunderx: workaround BGX TX Underflow issue
>=20
> Kees Cook <keescook@chromium.org>
>     x86/xen: Distribute switch variables for initialization
>=20
> Michal Swiatkowski <michal.swiatkowski@intel.com>
>     ice: Don't tell the OS that link is going down
>=20
> Keith Busch <kbusch@kernel.org>
>     nvme: Fix uninitialized-variable warning
>=20
> Julian Wiedmann <jwi@linux.ibm.com>
>     s390/qdio: fill SL with absolute addresses
>=20
> H.J. Lu <hjl.tools@gmail.com>
>     x86/boot/compressed: Don't declare __force_order in kaslr_64.c
>=20
> Masahiro Yamada <masahiroy@kernel.org>
>     s390: make 'install' not depend on vmlinux
>=20
> Vasily Averin <vvs@virtuozzo.com>
>     s390/cio: cio_ignore_proc_seq_next should increase position index
>=20
> Marco Felsch <m.felsch@pengutronix.de>
>     watchdog: da9062: do not ping the hw during stop()
>=20
> Marek Vasut <marex@denx.de>
>     net: ks8851-ml: Fix 16-bit IO operation
>=20
> Marek Vasut <marex@denx.de>
>     net: ks8851-ml: Fix 16-bit data access
>=20
> Marek Vasut <marex@denx.de>
>     net: ks8851-ml: Remove 8-bit bus accessors
>=20
> Florian Fainelli <f.fainelli@gmail.com>
>     net: dsa: b53: Ensure the default VID is untagged
>=20
> Hangbin Liu <liuhangbin@gmail.com>
>     selftests: forwarding: use proto icmp for {gretap, ip6gretap}_mac tes=
ting
>=20
> Harigovindan P <harigovi@codeaurora.org>
>     drm/msm/dsi/pll: call vco set rate explicitly
>=20
> Harigovindan P <harigovi@codeaurora.org>
>     drm/msm/dsi: save pll state before dsi host is powered off
>=20
> Tomas Henzl <thenzl@redhat.com>
>     scsi: megaraid_sas: silence a warning
>=20
> John Stultz <john.stultz@linaro.org>
>     drm: msm: Fix return type of dsi_mgr_connector_mode_valid for kCFI
>=20
> Brian Masney <masneyb@onstation.org>
>     drm/msm/mdp5: rate limit pp done timeout warnings
>=20
> Sergey Organov <sorganov@gmail.com>
>     usb: gadget: serial: fix Tx stall after buffer overflow
>=20
> Lars-Peter Clausen <lars@metafoo.de>
>     usb: gadget: ffs: ffs_aio_cancel(): Save/restore IRQ flags
>=20
> Jack Pham <jackp@codeaurora.org>
>     usb: gadget: composite: Support more than 500mA MaxPower
>=20
> Jiri Benc <jbenc@redhat.com>
>     selftests: fix too long argument
>=20
> Daniel Golle <daniel@makrotopia.org>
>     serial: ar933x_uart: set UART_CS_{RX,TX}_READY_ORIDE
>=20
> Kai Vehmanen <kai.vehmanen@linux.intel.com>
>     ALSA: hda: do not override bus codec_mask in link_get()
>=20
> Masami Hiramatsu <mhiramat@kernel.org>
>     kprobes: Fix optimize_kprobe()/unoptimize_kprobe() cancellation logic
>=20
> Nathan Chancellor <natechancellor@gmail.com>
>     RDMA/core: Fix use of logical OR in get_new_pps
>=20
> Maor Gottlieb <maorg@mellanox.com>
>     RDMA/core: Fix pkey and port assignment in get_new_pps
>=20
> Florian Fainelli <f.fainelli@gmail.com>
>     net: dsa: bcm_sf2: Forcibly configure IMP port for 1Gb/sec
>=20
> Hui Wang <hui.wang@canonical.com>
>     ALSA: hda/realtek - Fix a regression for mute led on Lenovo Carbon X1
>=20
> Yazen Ghannam <yazen.ghannam@amd.com>
>     EDAC/amd64: Set grain per DIMM
>=20
>=20
> -------------
>=20
> Diffstat:
>=20
>  Makefile                                           |  4 +-
>  arch/arm/boot/dts/am437x-idk-evm.dts               |  4 +-
>  arch/arm/boot/dts/dra76x.dtsi                      |  5 ++
>  arch/arm/boot/dts/imx6dl-colibri-eval-v3.dts       |  4 +-
>  arch/arm/boot/dts/imx6qdl-phytec-phycore-som.dtsi  |  1 -
>  arch/arm/boot/dts/imx7-colibri.dtsi                |  1 -
>  arch/arm/boot/dts/ls1021a.dtsi                     |  4 +-
>  arch/arm/mach-imx/Makefile                         |  2 +
>  arch/arm/mach-imx/common.h                         |  4 +-
>  arch/arm/mach-imx/resume-imx6.S                    | 24 ++++++++
>  arch/arm/mach-imx/suspend-imx6.S                   | 14 -----
>  arch/powerpc/kernel/cputable.c                     |  4 +-
>  arch/s390/Makefile                                 |  2 +-
>  arch/s390/boot/Makefile                            |  2 +-
>  arch/s390/include/asm/qdio.h                       |  2 +-
>  arch/x86/boot/compressed/kaslr_64.c                |  3 -
>  arch/x86/kernel/cpu/common.c                       |  2 +-
>  arch/x86/platform/efi/efi_64.c                     | 70 +++++++++++++++-=
------
>  arch/x86/xen/enlighten_pv.c                        |  7 ++-
>  drivers/dma/coh901318.c                            |  4 --
>  drivers/dma/imx-sdma.c                             | 56 +++++++++++-----=
-
>  drivers/dma/tegra20-apb-dma.c                      |  6 +-
>  drivers/edac/amd64_edac.c                          |  1 +
>  drivers/gpu/drm/msm/disp/mdp5/mdp5_crtc.c          |  4 +-
>  drivers/gpu/drm/msm/dsi/dsi_manager.c              |  7 ++-
>  drivers/gpu/drm/msm/dsi/phy/dsi_phy.c              |  4 --
>  drivers/gpu/drm/msm/dsi/pll/dsi_pll_10nm.c         |  6 ++
>  drivers/gpu/drm/sun4i/sun8i_mixer.c                | 68 ++++++++++++++++=
+----
>  drivers/gpu/drm/sun4i/sun8i_vi_layer.c             | 24 ++++----
>  drivers/hwmon/adt7462.c                            |  2 +-
>  drivers/infiniband/core/cm.c                       |  1 +
>  drivers/infiniband/core/iwcm.c                     |  4 +-
>  drivers/infiniband/core/security.c                 | 14 +++--
>  drivers/infiniband/hw/hfi1/verbs.c                 |  4 +-
>  drivers/infiniband/hw/qib/qib_verbs.c              |  2 +
>  drivers/md/dm-cache-target.c                       |  4 +-
>  drivers/md/dm-integrity.c                          | 27 ++++++---
>  drivers/md/dm-writecache.c                         | 14 ++++-
>  drivers/md/dm.c                                    |  1 +
>  drivers/media/v4l2-core/v4l2-mem2mem.c             |  4 +-
>  drivers/net/dsa/b53/b53_common.c                   |  3 +
>  drivers/net/dsa/bcm_sf2.c                          |  3 +-
>  drivers/net/ethernet/cavium/thunder/thunder_bgx.c  | 62
> ++++++++++++++++++-
>  drivers/net/ethernet/cavium/thunder/thunder_bgx.h  |  9 +++
>  drivers/net/ethernet/intel/ice/ice_ethtool.c       |  7 ---
>  drivers/net/ethernet/micrel/ks8851_mll.c           | 53 +++-------------
>  drivers/nvme/host/core.c                           |  2 +-
>  drivers/phy/motorola/phy-mapphone-mdm6600.c        | 27 ++++++++-
>  drivers/s390/cio/blacklist.c                       |  5 +-
>  drivers/s390/cio/qdio_setup.c                      |  3 +-
>  drivers/s390/net/qeth_core_main.c                  | 23 ++++---
>  drivers/scsi/megaraid/megaraid_sas_fusion.c        |  5 +-
>  drivers/scsi/pm8001/pm8001_sas.c                   |  6 +-
>  drivers/scsi/pm8001/pm80xx_hwi.c                   |  2 +-
>  drivers/scsi/pm8001/pm80xx_hwi.h                   |  2 +
>  drivers/spi/spi-bcm63xx-hsspi.c                    |  1 -
>  drivers/tty/serial/8250/8250_exar.c                | 33 ++++++++++
>  drivers/tty/serial/ar933x_uart.c                   |  8 +++
>  drivers/tty/serial/mvebu-uart.c                    |  2 +-
>  drivers/tty/vt/selection.c                         | 26 +++++++-
>  drivers/tty/vt/vt.c                                |  2 -
>  drivers/usb/core/hub.c                             |  8 ++-
>  drivers/usb/core/port.c                            | 10 +++-
>  drivers/usb/core/quirks.c                          |  3 +
>  drivers/usb/dwc3/gadget.c                          |  9 ++-
>  drivers/usb/gadget/composite.c                     | 24 ++++++--
>  drivers/usb/gadget/function/f_fs.c                 |  5 +-
>  drivers/usb/gadget/function/u_serial.c             |  4 +-
>  drivers/usb/storage/unusual_devs.h                 |  6 ++
>  drivers/video/console/vgacon.c                     |  3 +
>  drivers/watchdog/da9062_wdt.c                      |  7 ---
>  fs/cifs/inode.c                                    |  6 +-
>  fs/fat/inode.c                                     | 19 +++---
>  kernel/kprobes.c                                   | 67 +++++++++++++---=
-----
>  mm/huge_memory.c                                   |  3 +-
>  mm/mprotect.c                                      | 38 +++++++++++-
>  sound/hda/ext/hdac_ext_controller.c                |  9 ++-
>  sound/pci/hda/patch_realtek.c                      |  5 ++
>  sound/soc/codecs/pcm512x.c                         |  8 ++-
>  sound/soc/intel/skylake/skl-debug.c                | 32 +++++-----
>  sound/soc/soc-dapm.c                               |  2 +-
>  sound/soc/soc-pcm.c                                | 16 ++---
>  sound/soc/soc-topology.c                           | 17 +++---
>  tools/testing/selftests/lib.mk                     | 23 +++----
>  .../testing/selftests/net/forwarding/mirror_gre.sh | 25 ++++----
>  85 files changed, 700 insertions(+), 349 deletions(-)
>=20

