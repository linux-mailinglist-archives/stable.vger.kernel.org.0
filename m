Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2818318D9EA
	for <lists+stable@lfdr.de>; Fri, 20 Mar 2020 22:01:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726783AbgCTVB3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 20 Mar 2020 17:01:29 -0400
Received: from mail-eopbgr1410128.outbound.protection.outlook.com ([40.107.141.128]:16359
        "EHLO JPN01-OS2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726738AbgCTVB3 (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 20 Mar 2020 17:01:29 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=oBVNS8cC5QpMuClB4gL3uyq2bnN7cJ8aWdi14CaDPUtzR9CBqkMvAg1Ag9EzW8MUxqw6ZoUJ4iynyLTnI9hIyIAKjLUi6cSBkEWUECGiXFBcsdP3GE2SL2O/KhIkFEARWbidvTquM3iXh6JzfoQGzSiMbwByr9A3+ofmmDXPHypXiCS+zyyWMBJL0KZj7KC4XuzlCSWBHMzCZeWrUPSc9t4+1G+HiHzDdf89+WnI+bKLtWzwdCAXddgn7Lrq/LF8xKvg95Nx5Ov6zVHEnIImNmYK1cpFDAhSczY1KiBPHd4Gp8hLcAqck5O1RafFta62qXYfZBHU40vzYbNhMQBSKQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=teEXvQgf9bDGDz/Ngt8Py0zu2R0J7PToHEFltfbU7wA=;
 b=ZgV0mvy/jmo7W3bEf1pmZyOG6CljKwCQuZjPNWJ3eldhlN2iGRB+ckrdmV/qmsfmsKF2vQjEnXjDsrWja0vI/DV/jq7z/K1NbYozx7CNGo3pucIztWBQ4t3HhI3AlYOJb9arX0tDQ4ASF/KyvzEynDFoKPYtmk5ZPqYnV5RYdHOgXeuTjQSKSL+EYqQE/4F/dg/l6xt24znl5w0dU9AeDnsucRrFm1ieTxOcRE497NlEDPX7YDfYnG1TQrsxjPg2behGawdEshfr4O4LQM4DfC8keQSi4vB9A8Kgw+6/qE+s34gb6beul/+HxmKLoZwHG7Y5wkDCpWFSTHGtF8QmAg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=renesas.com; dmarc=pass action=none header.from=renesas.com;
 dkim=pass header.d=renesas.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=renesasgroup.onmicrosoft.com; s=selector2-renesasgroup-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=teEXvQgf9bDGDz/Ngt8Py0zu2R0J7PToHEFltfbU7wA=;
 b=e9BF+GSZj51w8U5ze3/wMrG+YYXwbMdiHQnAtMiXcbvjhVtY3EoUbqhFnsPoQJDHakS+vNj4bfZxkvTje0ClAatMbHDxbZYsdvrHsrpe+J7lPNPonltcjBDIWl/QQu+XFO216lJhr44B9FJ+OuPwiSS8kNSrEju2x6gCRh85wq8=
Received: from TYAPR01MB2285.jpnprd01.prod.outlook.com (52.133.177.145) by
 TYAPR01MB3470.jpnprd01.prod.outlook.com (20.178.136.215) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2814.23; Fri, 20 Mar 2020 21:01:22 +0000
Received: from TYAPR01MB2285.jpnprd01.prod.outlook.com
 ([fe80::a882:860e:5745:25e1]) by TYAPR01MB2285.jpnprd01.prod.outlook.com
 ([fe80::a882:860e:5745:25e1%6]) with mapi id 15.20.2814.025; Fri, 20 Mar 2020
 21:01:22 +0000
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
Subject: RE: [PATCH 4.19 00/48] 4.19.112-rc1 review
Thread-Topic: [PATCH 4.19 00/48] 4.19.112-rc1 review
Thread-Index: AQHV/fE98ds7jeqOIEC2x2bRRplLk6hR+GbA
Date:   Fri, 20 Mar 2020 21:01:22 +0000
Message-ID: <TYAPR01MB22854A4356027767654C9723B7F50@TYAPR01MB2285.jpnprd01.prod.outlook.com>
References: <20200319123902.941451241@linuxfoundation.org>
In-Reply-To: <20200319123902.941451241@linuxfoundation.org>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=Chris.Paterson2@renesas.com; 
x-originating-ip: [193.141.220.21]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: af36bb87-9ee1-4016-cd66-08d7cd11d862
x-ms-traffictypediagnostic: TYAPR01MB3470:
x-microsoft-antispam-prvs: <TYAPR01MB3470D9E00EAE9F30DE6C7311B7F50@TYAPR01MB3470.jpnprd01.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-forefront-prvs: 03484C0ABF
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(4636009)(136003)(39860400002)(396003)(366004)(346002)(376002)(199004)(76116006)(8936002)(478600001)(8676002)(7696005)(55016002)(6506007)(9686003)(81156014)(71200400001)(81166006)(4326008)(52536014)(33656002)(86362001)(5660300002)(7416002)(66446008)(186003)(2906002)(966005)(26005)(64756008)(66556008)(66946007)(66476007)(316002)(110136005)(54906003);DIR:OUT;SFP:1102;SCL:1;SRVR:TYAPR01MB3470;H:TYAPR01MB2285.jpnprd01.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;
received-spf: None (protection.outlook.com: renesas.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: fEMIlEyTZhEOIVbiM/Zj2h8BBx6P+wiXXE2UV7OXfS4Kcqxi4Q5qbNEEiLwSj4LIlyojhew4tWWh9e6BgixJvx2ZpwB0aYnvB5sLWWaWypP5LYmCWE8/WHoe1DoSe1wEMvs56dGvdfuf/OsuQ9bALopdkhPp4K+C+z60DzuIyuDwg8PM4ZIEGDKrqmtfnFCwrytmcHH1zQ15SDXO8jWZTSTiyMJxpoll9I0h/t5MWaG1890E2kxDXOE4yjMnGIX5dFR97qcPnlW/N3VURf+jhzMA8/f6fHJNnkJFa/ro5ZCGZrnrmeorDJXFJIPxhqI3vRnGh8g69DeN0C4EDz7aW21cpcVRmGqJuvExwRACWtPLbMctp6rRj+jzQkTKo63Umo6pajGINXZSx4ZLg9lryK2qCRZomWgEv9zjxrE/JHWPqMqVjlWdtYVrycWeWhOvWlXzxi0iZTZVxxBjZW5Y8Xu5GB8lLxoZr3/kM8Ga2OJ/+EV+6pyZrdHAGYIAeClUQNL8ENIXsjPXsKPSLEY+CQ==
x-ms-exchange-antispam-messagedata: wmmD053+Rc77E06tzxVxQMf43q8evQYSedvVsZZtHJoZXbUYogp8/xQZgywrYMP8EyXQEUysQa++6h/kYOdpItL1AM/J2PFHTNGO9lhYKzRDBi+gU60XQxdA105xdKjFkxBACj33DpnIyXIZMky3KA==
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="Windows-1252"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: renesas.com
X-MS-Exchange-CrossTenant-Network-Message-Id: af36bb87-9ee1-4016-cd66-08d7cd11d862
X-MS-Exchange-CrossTenant-originalarrivaltime: 20 Mar 2020 21:01:22.3027
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 53d82571-da19-47e4-9cb4-625a166a4a2a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: pZ1u9qJIl9a72PPSjXyz3SMIPfNY+P+0IunJfBDTw5Zm7ng3yLYFDTEQswejUyzXiMYaSO60Kh9RZ9znqdnVy/3P6UoWdB8rYkMBh9V4pfs=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: TYAPR01MB3470
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hello Greg,

> From: stable-owner@vger.kernel.org <stable-owner@vger.kernel.org> On
> Behalf Of Greg Kroah-Hartman
> Sent: 19 March 2020 13:04
>=20
> This is the start of the stable review cycle for the 4.19.112 release.
> There are 48 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

No build/test issues seen for CIP configs for Linux 4.19.112-rc1 (d078cac7a=
422).

Build/test pipeline/logs: https://gitlab.com/cip-project/cip-testing/linux-=
stable-rc-ci/pipelines/128111695
GitLab CI pipeline: https://gitlab.com/cip-project/cip-testing/linux-cip-pi=
pelines/-/blob/master/trees/linux-4.19.y.yml

Kind regards, Chris

>=20
> Responses should be made by Sat, 21 Mar 2020 12:37:04 +0000.
> Anything received after that time might be too late.
>=20
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-
> 4.19.112-rc1.gz
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
>     Linux 4.19.112-rc1
>=20
> Matteo Croce <mcroce@redhat.com>
>     ipv4: ensure rcu_read_lock() in cipso_v4_error()
>=20
> Waiman Long <longman@redhat.com>
>     efi: Fix debugobjects warning on 'efi_rts_work'
>=20
> Chen-Tsung Hsieh <chentsung@chromium.org>
>     HID: google: add moonball USB id
>=20
> Jann Horn <jannh@google.com>
>     mm: slub: add missing TID bump in kmem_cache_alloc_bulk()
>=20
> Kees Cook <keescook@chromium.org>
>     ARM: 8958/1: rename missed uaccess .fixup section
>=20
> Florian Fainelli <f.fainelli@gmail.com>
>     ARM: 8957/1: VDSO: Match ARMv8 timer in cntvct_functional()
>=20
> Carl Huang <cjhuang@codeaurora.org>
>     net: qrtr: fix len of skb_put_padto in qrtr_node_enqueue
>=20
> Rafael J. Wysocki <rafael.j.wysocki@intel.com>
>     driver core: Fix creation of device links with PM-runtime flags
>=20
> Rafael J. Wysocki <rafael.j.wysocki@intel.com>
>     driver core: Remove device link creation limitation
>=20
> Rafael J. Wysocki <rafael.j.wysocki@intel.com>
>     driver core: Add device link flag DL_FLAG_AUTOPROBE_CONSUMER
>=20
> Rafael J. Wysocki <rafael.j.wysocki@intel.com>
>     driver core: Make driver core own stateful device links
>=20
> Rafael J. Wysocki <rafael.j.wysocki@intel.com>
>     driver core: Fix adding device links to probing suppliers
>=20
> Yong Wu <yong.wu@mediatek.com>
>     driver core: Remove the link if there is no driver with AUTO flag
>=20
> Faiz Abbas <faiz_abbas@ti.com>
>     mmc: sdhci-omap: Fix Tuning procedure for temperatures < -20C
>=20
> Faiz Abbas <faiz_abbas@ti.com>
>     mmc: sdhci-omap: Don't finish_mrq() on a command error during tuning
>=20
> Navid Emamdoost <navid.emamdoost@gmail.com>
>     wimax: i2400: Fix memory leak in i2400m_op_rfkill_sw_toggle
>=20
> Navid Emamdoost <navid.emamdoost@gmail.com>
>     wimax: i2400: fix memory leak
>=20
> Qian Cai <cai@lca.pw>
>     jbd2: fix data races at struct journal_head
>=20
> Alex Maftei (amaftei) <amaftei@solarflare.com>
>     sfc: fix timestamp reconstruction at 16-bit rollover points
>=20
> Taehee Yoo <ap420073@gmail.com>
>     net: rmnet: fix packet forwarding in rmnet bridge mode
>=20
> Taehee Yoo <ap420073@gmail.com>
>     net: rmnet: fix bridge mode bugs
>=20
> Taehee Yoo <ap420073@gmail.com>
>     net: rmnet: use upper/lower device infrastructure
>=20
> Taehee Yoo <ap420073@gmail.com>
>     net: rmnet: do not allow to change mux id if mux id is duplicated
>=20
> Taehee Yoo <ap420073@gmail.com>
>     net: rmnet: remove rcu_read_lock in rmnet_force_unassociate_device()
>=20
> Taehee Yoo <ap420073@gmail.com>
>     net: rmnet: fix suspicious RCU usage
>=20
> Taehee Yoo <ap420073@gmail.com>
>     net: rmnet: fix NULL pointer dereference in rmnet_changelink()
>=20
> Taehee Yoo <ap420073@gmail.com>
>     net: rmnet: fix NULL pointer dereference in rmnet_newlink()
>=20
> Luo bin <luobin9@huawei.com>
>     hinic: fix a bug of setting hw_ioctxt
>=20
> Luo bin <luobin9@huawei.com>
>     hinic: fix a irq affinity bug
>=20
> yangerkun <yangerkun@huawei.com>
>     slip: not call free_netdev before rtnl_unlock in slip_open
>=20
> Linus Torvalds <torvalds@linux-foundation.org>
>     signal: avoid double atomic counter increments for user accounting
>=20
> Madhuparna Bhowmik <madhuparnabhowmik10@gmail.com>
>     mac80211: rx: avoid RCU list traversal under mutex
>=20
> Marek Vasut <marex@denx.de>
>     net: ks8851-ml: Fix IRQ handling and locking
>=20
> Daniele Palmas <dnlplm@gmail.com>
>     net: usb: qmi_wwan: restore mtu min/max values after raw_ip switch
>=20
> Igor Druzhinin <igor.druzhinin@citrix.com>
>     scsi: libfc: free response frame from GPN_ID
>=20
> Johannes Berg <johannes.berg@intel.com>
>     cfg80211: check reg_rule for NULL in handle_channel_custom()
>=20
> Kai-Heng Feng <kai.heng.feng@canonical.com>
>     HID: i2c-hid: add Trekstor Surfbook E11B to descriptor override
>=20
> Mansour Behabadi <mansour@oxplot.com>
>     HID: apple: Add support for recent firmware on Magic Keyboards
>=20
> Jean Delvare <jdelvare@suse.de>
>     ACPI: watchdog: Allow disabling WDAT at boot
>=20
> Ulf Hansson <ulf.hansson@linaro.org>
>     mmc: core: Allow host controllers to require R1B for CMD6
>=20
> Ulf Hansson <ulf.hansson@linaro.org>
>     mmc: core: Respect MMC_CAP_NEED_RSP_BUSY for erase/trim/discard
>=20
> Ulf Hansson <ulf.hansson@linaro.org>
>     mmc: core: Respect MMC_CAP_NEED_RSP_BUSY for eMMC sleep command
>=20
> Ulf Hansson <ulf.hansson@linaro.org>
>     mmc: sdhci-omap: Fix busy detection by enabling
> MMC_CAP_NEED_RSP_BUSY
>=20
> Faiz Abbas <faiz_abbas@ti.com>
>     mmc: host: Fix Kconfig warnings on keystone_defconfig
>=20
> Faiz Abbas <faiz_abbas@ti.com>
>     mmc: sdhci-omap: Workaround errata regarding SDR104/HS200 tuning
> failures (i929)
>=20
> Faiz Abbas <faiz_abbas@ti.com>
>     mmc: sdhci-omap: Add platform specific reset callback
>=20
> Ulf Hansson <ulf.hansson@linaro.org>
>     mmc: core: Default to generic_cmd6_time as timeout in __mmc_switch()
>=20
> Kim Phillips <kim.phillips@amd.com>
>     perf/amd/uncore: Replace manual sampling check with CAP_NO_INTERRUPT
> flag
>=20
>=20
> -------------
>=20
> Diffstat:
>=20
>  Documentation/admin-guide/kernel-parameters.txt    |   4 +
>  Documentation/driver-api/device_link.rst           |  63 +++--
>  Makefile                                           |   4 +-
>  arch/arm/kernel/vdso.c                             |   2 +
>  arch/arm/lib/copy_from_user.S                      |   2 +-
>  arch/x86/events/amd/uncore.c                       |  14 +-
>  drivers/acpi/acpi_watchdog.c                       |  12 +-
>  drivers/base/core.c                                | 293 +++++++++++++++=
------
>  drivers/base/dd.c                                  |   2 +-
>  drivers/base/power/runtime.c                       |   4 +-
>  drivers/firmware/efi/runtime-wrappers.c            |   2 +-
>  drivers/hid/hid-apple.c                            |   3 +-
>  drivers/hid/hid-google-hammer.c                    |   2 +
>  drivers/hid/hid-ids.h                              |   1 +
>  drivers/hid/i2c-hid/i2c-hid-dmi-quirks.c           |   8 +
>  drivers/mmc/core/core.c                            |   5 +-
>  drivers/mmc/core/mmc.c                             |   7 +-
>  drivers/mmc/core/mmc_ops.c                         |  27 +-
>  drivers/mmc/host/Kconfig                           |   2 +
>  drivers/mmc/host/sdhci-omap.c                      | 151 ++++++++++-
>  drivers/net/ethernet/huawei/hinic/hinic_hw_dev.c   |   1 +
>  drivers/net/ethernet/huawei/hinic/hinic_hw_dev.h   |   2 +-
>  drivers/net/ethernet/huawei/hinic/hinic_hw_if.h    |   1 +
>  drivers/net/ethernet/huawei/hinic/hinic_hw_qp.h    |   1 +
>  drivers/net/ethernet/huawei/hinic/hinic_rx.c       |   5 +-
>  drivers/net/ethernet/micrel/ks8851_mll.c           |  14 +-
>  drivers/net/ethernet/qualcomm/rmnet/rmnet_config.c | 186 +++++++------
>  drivers/net/ethernet/qualcomm/rmnet/rmnet_config.h |   3 +-
>  .../net/ethernet/qualcomm/rmnet/rmnet_handlers.c   |   7 +-
>  drivers/net/ethernet/qualcomm/rmnet/rmnet_vnd.c    |   8 -
>  drivers/net/ethernet/qualcomm/rmnet/rmnet_vnd.h    |   1 -
>  drivers/net/ethernet/sfc/ptp.c                     |  38 ++-
>  drivers/net/slip/slip.c                            |   3 +
>  drivers/net/usb/qmi_wwan.c                         |   3 +
>  drivers/net/wimax/i2400m/op-rfkill.c               |   1 +
>  drivers/scsi/libfc/fc_disc.c                       |   2 +
>  fs/jbd2/transaction.c                              |   8 +-
>  include/linux/device.h                             |   7 +-
>  include/linux/mmc/host.h                           |   1 +
>  kernel/signal.c                                    |  23 +-
>  mm/slub.c                                          |   9 +
>  net/ipv4/cipso_ipv4.c                              |   7 +-
>  net/mac80211/rx.c                                  |   2 +-
>  net/qrtr/qrtr.c                                    |   2 +-
>  net/wireless/reg.c                                 |   2 +-
>  45 files changed, 672 insertions(+), 273 deletions(-)
>=20

