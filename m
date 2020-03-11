Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BDEED1815BF
	for <lists+stable@lfdr.de>; Wed, 11 Mar 2020 11:27:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726044AbgCKK1y (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 11 Mar 2020 06:27:54 -0400
Received: from mail-eopbgr1400138.outbound.protection.outlook.com ([40.107.140.138]:51680
        "EHLO JPN01-TY1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726000AbgCKK1y (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 11 Mar 2020 06:27:54 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=NrBhbPT4AaiY2ttbPVKGaNxbQh6FDyuznN6dlhuSP0HNyBf65F2fWcCSuBiwTGrJzMZAAw5BtzurmTcNSq/nDI9X11tZ6QUilcLE4El3WMKZfK4438nGBDbwJYHF7KmtLuzItTE0SVoSRxoJgjYHPm4xmxwLKor3bPXCOtSjWtzbXG1PKMpNy+KQqEP0U1X5H1yKUWPmonVooqUS6mqZwSiN43cxtDaKZutEQ7gQCjptj9yHNR4uO4twPamvI3kPYrAfBIwBEM85FBdRtTGfXX6dw7Z+2EH9OavjAMXxMJF5E6vV5zGzahcW3AhX/wWSVDBOTG5IZlUb+8nEnTxJ3g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=kTAz6baoxFkKBeRmlFr6R0j3CeP/sDfm3uvG2ASrPbY=;
 b=hUtA8MFTnFRabsqeUlWDGyp68b/hHq7vncq7l+wVrbb7xgOauvj4kP6yJPdTZgh3ZtYRNdycPQfpNkPFUoB3XP3sFX2E/1XKGKfsLUcjaJPpIXi2jogA94oDRa+5Qy1BWWxJL1RNXsXKwTSkVJduUZ+b8bDScQRcS0zPwlGilbpKkw2rZtlSFSE2LHAD+5bU6F/rk2B+e4I1cgR/lFor/9Q7ruQC1FksVWvdqp2dQ1q37iqSzDB2zzy94yvf3EotDLuYowvS1+Fz50w490hmAjcUZz9ivG/gdcMShQyDXrptMVkBjFGs5npGFhGXtnRAQMp9UFhTXpBuMpgg1KvjOA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=renesas.com; dmarc=pass action=none header.from=renesas.com;
 dkim=pass header.d=renesas.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=renesasgroup.onmicrosoft.com; s=selector2-renesasgroup-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=kTAz6baoxFkKBeRmlFr6R0j3CeP/sDfm3uvG2ASrPbY=;
 b=rKM4qEsD8n56Br2xFBRqliJzADa2MTrfxRDZtOm0ZDJQX+QX+39RYdZJJ1IWrfjBpCPe8Cxnkme6S2Muw14p2KJ8erIx0E6QKkO6wZ2pqgQ0LYBY/z5rLrR0Z2yN/4X1YexwAn38Rqbv3nIZ+VaoLXipuvhrYVrjIWoGTbsgXMY=
Received: from OSBPR01MB2280.jpnprd01.prod.outlook.com (52.134.243.13) by
 OSBPR01MB4327.jpnprd01.prod.outlook.com (20.179.183.86) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2793.17; Wed, 11 Mar 2020 10:27:46 +0000
Received: from OSBPR01MB2280.jpnprd01.prod.outlook.com
 ([fe80::bca1:a941:6c29:d8f8]) by OSBPR01MB2280.jpnprd01.prod.outlook.com
 ([fe80::bca1:a941:6c29:d8f8%6]) with mapi id 15.20.2793.013; Wed, 11 Mar 2020
 10:27:46 +0000
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
Subject: RE: [PATCH 4.4 00/72] 4.4.216-stable review
Thread-Topic: [PATCH 4.4 00/72] 4.4.216-stable review
Thread-Index: AQHV9uEO+P8v78dJh0ObyB1rhRni8ahDMFQg
Date:   Wed, 11 Mar 2020 10:27:46 +0000
Message-ID: <OSBPR01MB2280B94983BB3197936CE7FEB7FC0@OSBPR01MB2280.jpnprd01.prod.outlook.com>
References: <20200310123601.053680753@linuxfoundation.org>
In-Reply-To: <20200310123601.053680753@linuxfoundation.org>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=Chris.Paterson2@renesas.com; 
x-originating-ip: [176.27.142.199]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 87c67e03-2489-45d2-c48f-08d7c5a6d749
x-ms-traffictypediagnostic: OSBPR01MB4327:
x-microsoft-antispam-prvs: <OSBPR01MB43279F67E35F47C244934B49B7FC0@OSBPR01MB4327.jpnprd01.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:229;
x-forefront-prvs: 0339F89554
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(4636009)(136003)(366004)(376002)(396003)(39860400002)(346002)(199004)(66446008)(6506007)(64756008)(66556008)(4326008)(186003)(966005)(54906003)(55016002)(5660300002)(66946007)(110136005)(81166006)(8676002)(76116006)(316002)(81156014)(7696005)(478600001)(66476007)(86362001)(71200400001)(52536014)(9686003)(7416002)(8936002)(26005)(2906002)(33656002);DIR:OUT;SFP:1102;SCL:1;SRVR:OSBPR01MB4327;H:OSBPR01MB2280.jpnprd01.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;
received-spf: None (protection.outlook.com: renesas.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: g9QloWGqBndZvjnXUiwA5QJM/WiNdbIn14GUaEAtqwMLGhpCFkrj6t6p1IRA0t/66lry90TYZiNPu1sfg69s+zY08TOLD7hfZrYQO7n5t1tvLNxXJd8XM2jNOG975IL5MFD9i/46xH4tRWRuNO6CwYYSfpQ1DGW/+D6uBe1cqLjyFjNrUcAMUZVEvSbusgJ3h/g+nFq0FcpcNHsWYirV/ePjKIJkzUFmr/0pXzUSYwrIP0Fuv9fzHPA3TKnv0DlAYUQ5wjM9HkWGcnbQOnCzwMq8k+xQEuw3DRrSlGb4oOivkzlZgVMzbuqTuqOoOE+ouOIe75h/mO221bHznKkkmzSAnRcsxJHGQE7x3F38zDFAHx0VoS6D5pgcmRC4zWLmCCdxHh1xbjONxcWa5+9PaQfLDZGv+spYN6+Kc79NRHrWRzFKHBgEkCpmY7SF9jyEWy+Fg9+A+tZp8hpt9Op5jmUsb7hp5YKXfvClQMC9Zn+uz8w4abzJBfDznGxGKVhZ24o0li2YrbHPvrG3Q/hj2Q==
x-ms-exchange-antispam-messagedata: faSnXbpr5hz0R46FFRNUtuePuDxxAE1qMV+qi62FJMfWPJfdDMApLvlQuuTVPf3IYrYVEmYZQ4mD6DxIDk3+Fscis26zdCAfki9pbCaNmz2DQPuMrlfMPN5thx5GX5F+gCRFPiCAaXByBU5w3pJ/4w==
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="Windows-1252"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: renesas.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 87c67e03-2489-45d2-c48f-08d7c5a6d749
X-MS-Exchange-CrossTenant-originalarrivaltime: 11 Mar 2020 10:27:46.1214
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 53d82571-da19-47e4-9cb4-625a166a4a2a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: NIUTCL6dY32/O0P34jHbY8TwvifudGOnVjtLwC67ySn8GsTUXQrkQgcBX6W/tVXcGN3SMEU9jk9RirMXXigvOcr5cAK+b2/cYINTsrhFW3U=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: OSBPR01MB4327
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hello Greg,

> From: stable-owner@vger.kernel.org <stable-owner@vger.kernel.org> On
> Behalf Of Greg Kroah-Hartman
> Sent: 10 March 2020 12:38
>=20
> This is the start of the stable review cycle for the 4.4.216 release.
> There are 72 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

No build issues seen for CIP configs for Linux 4.4.216-rc1 (836f82655232).

Build logs: https://gitlab.com/cip-project/cip-testing/linux-stable-rc-ci/p=
ipelines/124878979
Pipeline: https://gitlab.com/cip-project/cip-testing/linux-cip-pipelines/-/=
blob/master/trees/linux-4.4.y.yml

Kind regards, Chris

>=20
> Responses should be made by Thu, 12 Mar 2020 12:34:10 +0000.
> Anything received after that time might be too late.
>=20
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-
> 4.4.216-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
> linux-4.4.y
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
>     Linux 4.4.216-rc1
>=20
> yangerkun <yangerkun@huawei.com>
>     crypto: algif_skcipher - use ZERO_OR_NULL_PTR in skcipher_recvmsg_asy=
nc
>=20
> Mikulas Patocka <mpatocka@redhat.com>
>     dm cache: fix a crash due to incorrect work item cancelling
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
> Ahmad Fatoum <a.fatoum@pengutronix.de>
>     ARM: imx: build v7_cpu_resume() unconditionally
>=20
> Jason Gunthorpe <jgg@mellanox.com>
>     RMDA/cm: Fix missing ib_cm_destroy_id() in ib_cm_insert_listen()
>=20
> Bernard Metzler <bmt@zurich.ibm.com>
>     RDMA/iwcm: Fix iwcm work deallocation
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
> Dmitry Osipenko <digetx@gmail.com>
>     dmaengine: tegra-apb: Prevent race conditions of tasklet vs free list
>=20
> Dmitry Osipenko <digetx@gmail.com>
>     dmaengine: tegra-apb: Fix use-after-free
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
> OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
>     fat: fix uninit-memory access for partial initialized inode
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
> Dan Lazewatsky <dlaz@chromium.org>
>     usb: quirks: add NO_LPM quirk for Logitech Screen Share
>=20
> Jim Lin <jilin@nvidia.com>
>     usb: storage: Add quirk for Samsung Fit flash
>=20
> Ronnie Sahlberg <lsahlber@redhat.com>
>     cifs: don't leak -EAGAIN for stat() during reconnect
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
> Harigovindan P <harigovi@codeaurora.org>
>     drm/msm/dsi: save pll state before dsi host is powered off
>=20
> John Stultz <john.stultz@linaro.org>
>     drm: msm: Fix return type of dsi_mgr_connector_mode_valid for kCFI
>=20
> Sergey Organov <sorganov@gmail.com>
>     usb: gadget: serial: fix Tx stall after buffer overflow
>=20
> Lars-Peter Clausen <lars@metafoo.de>
>     usb: gadget: ffs: ffs_aio_cancel(): Save/restore IRQ flags
>=20
> Daniel Golle <daniel@makrotopia.org>
>     serial: ar933x_uart: set UART_CS_{RX,TX}_READY_ORIDE
>=20
> Paul Moore <paul@paul-moore.com>
>     audit: always check the netlink payload length in audit_receive_msg()
>=20
> Matthew Wilcox <willy@infradead.org>
>     fs: prevent page refcount overflow in pipe_buf_get
>=20
> Miklos Szeredi <mszeredi@redhat.com>
>     pipe: add pipe_buf_get() helper
>=20
> Linus Torvalds <torvalds@linux-foundation.org>
>     mm: prevent get_user_pages() from overflowing page refcount
>=20
> Punit Agrawal <punit.agrawal@arm.com>
>     mm, gup: ensure real head page is ref-counted when using hugepages
>=20
> Will Deacon <will.deacon@arm.com>
>     mm, gup: remove broken VM_BUG_ON_PAGE compound check for
> hugepages
>=20
> Linus Torvalds <torvalds@linux-foundation.org>
>     mm: add 'try_get_page()' helper function
>=20
> Linus Torvalds <torvalds@linux-foundation.org>
>     mm: make page ref count overflow check tighter and more explicit
>=20
> yangerkun <yangerkun@huawei.com>
>     slip: stop double free sl->dev in slip_open
>=20
> Sean Christopherson <sean.j.christopherson@intel.com>
>     KVM: Check for a bad hva before dropping into the ghc slow path
>=20
> Aleksa Sarai <cyphar@cyphar.com>
>     namei: only return -ECHILD from follow_dotdot_rcu()
>=20
> Nikolay Aleksandrov <nikolay@cumulusnetworks.com>
>     net: netlink: cap max groups which will be considered in netlink_bind=
()
>=20
> Chris Wilson <chris@chris-wilson.co.uk>
>     include/linux/bitops.h: introduce BITS_PER_TYPE
>=20
> Nathan Chancellor <natechancellor@gmail.com>
>     ecryptfs: Fix up bad backport of
> fe2e082f5da5b4a0a92ae32978f81507ef37ec66
>=20
> Wolfram Sang <wsa@the-dreams.de>
>     i2c: jz4780: silence log flood on txabrt
>=20
> Christophe JAILLET <christophe.jaillet@wanadoo.fr>
>     MIPS: VPE: Fix a double free and a memory leak in 'release_vpe()'
>=20
> dan.carpenter@oracle.com <dan.carpenter@oracle.com>
>     HID: hiddev: Fix race in in hiddev_disconnect()
>=20
> Johan Korsnes <jkorsnes@cisco.com>
>     HID: core: increase HID report buffer size to 8KiB
>=20
> Johan Korsnes <jkorsnes@cisco.com>
>     HID: core: fix off-by-one memset in hid_report_raw_event()
>=20
> Paul Moore <paul@paul-moore.com>
>     audit: fix error handling in audit_data_to_entry()
>=20
> Dan Carpenter <dan.carpenter@oracle.com>
>     ext4: potential crash on allocation error in ext4_alloc_flex_bg_array=
()
>=20
> Jason Baron <jbaron@akamai.com>
>     net: sched: correct flower port blocking
>=20
> Dmitry Osipenko <digetx@gmail.com>
>     nfc: pn544: Fix occasional HW initialization failure
>=20
> Xin Long <lucien.xin@gmail.com>
>     sctp: move the format error check out of __sctp_sf_do_9_1_abort
>=20
> Benjamin Poirier <bpoirier@cumulusnetworks.com>
>     ipv6: Fix route replacement with dev-only route
>=20
> Benjamin Poirier <bpoirier@cumulusnetworks.com>
>     ipv6: Fix nlmsg_flags when splitting a multipath route
>=20
> Arun Parameswaran <arun.parameswaran@broadcom.com>
>     net: phy: restore mdio regs in the iproc mdio driver
>=20
> Jethro Beekman <jethro@fortanix.com>
>     net: fib_rules: Correctly set table field when table number exceeds 8=
 bits
>=20
> Petr Mladek <pmladek@suse.com>
>     sysrq: Remove duplicated sysrq message
>=20
> Petr Mladek <pmladek@suse.com>
>     sysrq: Restore original console_loglevel when sysrq disabled
>=20
> Sergey Matyukevich <sergey.matyukevich.os@quantenna.com>
>     cfg80211: add missing policy for NL80211_ATTR_STATUS_CODE
>=20
> Frank Sorenson <sorenson@redhat.com>
>     cifs: Fix mode output in debugging statements
>=20
> Sergey Matyukevich <sergey.matyukevich.os@quantenna.com>
>     cfg80211: check wiphy driver existence for drvinfo report
>=20
> Johannes Berg <johannes.berg@intel.com>
>     mac80211: consider more elements in parsing CRC
>=20
> Corey Minyard <cminyard@mvista.com>
>     ipmi:ssif: Handle a possible NULL pointer reference
>=20
> Suraj Jitindar Singh <surajjs@amazon.com>
>     ext4: fix potential race between s_group_info online resizing and acc=
ess
>=20
> Suraj Jitindar Singh <surajjs@amazon.com>
>     ext4: fix potential race between s_flex_groups online resizing and ac=
cess
>=20
> Theodore Ts'o <tytso@mit.edu>
>     ext4: fix potential race between online resizing and write operations
>=20
> Johannes Berg <johannes.berg@intel.com>
>     iwlwifi: pcie: fix rb_allocator workqueue allocation
>=20
>=20
> -------------
>=20
> Diffstat:
>=20
>  Makefile                                 |   4 +-
>  arch/arm/mach-imx/Makefile               |   2 +
>  arch/arm/mach-imx/common.h               |   4 +-
>  arch/arm/mach-imx/resume-imx6.S          |  24 +++++++
>  arch/arm/mach-imx/suspend-imx6.S         |  14 -----
>  arch/mips/kernel/vpe.c                   |   2 +-
>  arch/powerpc/kernel/cputable.c           |   4 +-
>  arch/s390/mm/gup.c                       |   6 +-
>  arch/x86/mm/gup.c                        |   9 ++-
>  crypto/algif_skcipher.c                  |   2 +-
>  drivers/char/ipmi/ipmi_ssif.c            |  10 ++-
>  drivers/dma/coh901318.c                  |   4 --
>  drivers/dma/tegra20-apb-dma.c            |   6 +-
>  drivers/gpu/drm/msm/dsi/dsi_manager.c    |   7 ++-
>  drivers/hid/hid-core.c                   |   4 +-
>  drivers/hid/usbhid/hiddev.c              |   2 +-
>  drivers/hwmon/adt7462.c                  |   2 +-
>  drivers/i2c/busses/i2c-jz4780.c          |  36 +----------
>  drivers/infiniband/core/cm.c             |   1 +
>  drivers/infiniband/core/iwcm.c           |   4 +-
>  drivers/md/dm-cache-target.c             |   4 +-
>  drivers/net/ethernet/micrel/ks8851_mll.c |  53 +++-------------
>  drivers/net/phy/mdio-bcm-iproc.c         |  20 ++++++
>  drivers/net/slip/slip.c                  |   1 -
>  drivers/net/wireless/iwlwifi/pcie/rx.c   |   6 +-
>  drivers/nfc/pn544/i2c.c                  |   1 +
>  drivers/s390/cio/blacklist.c             |   5 +-
>  drivers/tty/serial/ar933x_uart.c         |   8 +++
>  drivers/tty/sysrq.c                      |   8 +--
>  drivers/tty/vt/selection.c               |  24 ++++++-
>  drivers/tty/vt/vt.c                      |   2 -
>  drivers/usb/core/hub.c                   |   6 +-
>  drivers/usb/core/port.c                  |  10 ++-
>  drivers/usb/core/quirks.c                |   3 +
>  drivers/usb/gadget/function/f_fs.c       |   5 +-
>  drivers/usb/gadget/function/u_serial.c   |   4 +-
>  drivers/usb/storage/unusual_devs.h       |   6 ++
>  drivers/video/console/vgacon.c           |   3 +
>  drivers/watchdog/da9062_wdt.c            |   7 ---
>  fs/cifs/cifsacl.c                        |   4 +-
>  fs/cifs/connect.c                        |   2 +-
>  fs/cifs/inode.c                          |   8 ++-
>  fs/ecryptfs/keystore.c                   |   4 +-
>  fs/ext4/balloc.c                         |  14 ++++-
>  fs/ext4/ext4.h                           |  30 +++++++--
>  fs/ext4/ialloc.c                         |  23 ++++---
>  fs/ext4/mballoc.c                        |  61 ++++++++++++------
>  fs/ext4/resize.c                         |  62 +++++++++++++++----
>  fs/ext4/super.c                          | 103 +++++++++++++++++++++----=
------
>  fs/fat/inode.c                           |  19 +++---
>  fs/fuse/dev.c                            |  12 ++--
>  fs/namei.c                               |   2 +-
>  fs/pipe.c                                |   4 +-
>  fs/splice.c                              |  12 +++-
>  include/linux/bitops.h                   |   3 +-
>  include/linux/hid.h                      |   2 +-
>  include/linux/mm.h                       |  23 ++++++-
>  include/linux/pipe_fs_i.h                |  17 ++++-
>  include/net/flow_dissector.h             |   9 +++
>  kernel/audit.c                           |  40 ++++++------
>  kernel/auditfilter.c                     |  71 +++++++++++----------
>  kernel/trace/trace.c                     |   6 +-
>  mm/gup.c                                 |  51 ++++++++++-----
>  mm/hugetlb.c                             |  16 ++++-
>  mm/internal.h                            |  28 ++++++++-
>  net/core/fib_rules.c                     |   2 +-
>  net/ipv6/ip6_fib.c                       |   7 ++-
>  net/ipv6/route.c                         |   1 +
>  net/mac80211/util.c                      |  18 ++++--
>  net/netlink/af_netlink.c                 |   5 +-
>  net/sched/cls_flower.c                   |   1 +
>  net/sctp/sm_statefuns.c                  |  27 +++++---
>  net/wireless/ethtool.c                   |   8 ++-
>  net/wireless/nl80211.c                   |   1 +
>  sound/soc/codecs/pcm512x.c               |   8 ++-
>  sound/soc/soc-dapm.c                     |   2 +-
>  sound/soc/soc-pcm.c                      |  16 ++---
>  virt/kvm/kvm_main.c                      |  12 ++--
>  78 files changed, 684 insertions(+), 373 deletions(-)
>=20

