Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DE3591F61EB
	for <lists+stable@lfdr.de>; Thu, 11 Jun 2020 08:50:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726526AbgFKGuD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 11 Jun 2020 02:50:03 -0400
Received: from mail-eopbgr1410122.outbound.protection.outlook.com ([40.107.141.122]:32847
        "EHLO JPN01-OS2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726511AbgFKGuD (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 11 Jun 2020 02:50:03 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=eYUS0y7otZxOwR/qngP8e9kxK7bW7O7jk2l9jLk6xQLPYHnC5j7sDo6+E6wkc1eVmaM3+C6Pug91xBNPjzLz5N+Vo7uQyGhWSGFsnzFy72FJqjKszkflrfyMKpzOTD+vHW7qpCJu8DPamIMcPTSnG0tPLkW1l79sGYt6zanIha0l5VxSAEUn8l+Dr0Ffnj63cvIskkVgh+h6dfDU1IY7d79yyoZFRt7eemMX0/1imJQcUfGfr5ESZ4cHcaUq4nkIGLUBcgGw7TplmOgyttMy/NF0131zblFyJEDBH07zQREcJA561C9YkMnFGbjYwLcdZ+q71sxjPvRQz4+hTX8SfA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=oofSYXvNcHlIXpR61mBWTRujWAzYNO3PjvpLsayw7Yc=;
 b=ejkNkUiDsS6PzXprcXiilpRcxyt009o669MoeNDfo0loBvmquvz/4z7mWfnwqb25awSpOZgHfL9cdHcfiKjIPqqswcdpE841dYL2QLZsqh4S1dKmLcXWrLCqDZXpS3YCCphhsgbcbRc52PgvN7UmcVjaUzYlbdZ5zeekhRsa3YXxT7mllEr2Z2MlhoqO3N1xNFtUS5Hv5OFOeZZ7pnmtBFT21sjMnhC2TfRDw3LxDBmvileboPOpMscB7g0kfFszG6GeU/rvIPrSnFRwFhtaS7Lw5zpcAoWuOXmT6/wjh6tw7JaSjiOAsnqNwKy2cyu6vH9q0xaKt9bnqP4orb+Nng==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=renesas.com; dmarc=pass action=none header.from=renesas.com;
 dkim=pass header.d=renesas.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=renesasgroup.onmicrosoft.com; s=selector2-renesasgroup-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=oofSYXvNcHlIXpR61mBWTRujWAzYNO3PjvpLsayw7Yc=;
 b=EZdk7eFI9iyZ3z/HN2tWeDkYp3HnKPj556DJgn6FQUBDpZpsXcXMwAJl/FD3u8d8F2FhNP65z/7sYF13mMZuLaL6Zrv6grR8kufFfdlIJZSekwVF7x/WTnzVPi8aBC+8yht9n2vfGa9BjUn3cM6og0iizCDDSsdJn/QXIkxrYEw=
Received: from OSAPR01MB2385.jpnprd01.prod.outlook.com (2603:1096:603:37::20)
 by OSAPR01MB1521.jpnprd01.prod.outlook.com (2603:1096:603:2d::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3088.21; Thu, 11 Jun
 2020 06:49:57 +0000
Received: from OSAPR01MB2385.jpnprd01.prod.outlook.com
 ([fe80::c44c:5473:6b95:d9fd]) by OSAPR01MB2385.jpnprd01.prod.outlook.com
 ([fe80::c44c:5473:6b95:d9fd%6]) with mapi id 15.20.3066.023; Thu, 11 Jun 2020
 06:49:57 +0000
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
Subject: RE: [PATCH 4.19 00/25] 4.19.128-rc2 review
Thread-Topic: [PATCH 4.19 00/25] 4.19.128-rc2 review
Thread-Index: AQHWPpLRzFc0OFNakUaLHC3wTpIwXajS+p2w
Date:   Thu, 11 Jun 2020 06:49:57 +0000
Message-ID: <OSAPR01MB2385C75DB74ABBA85FC0ED8BB7800@OSAPR01MB2385.jpnprd01.prod.outlook.com>
References: <20200609185946.866927360@linuxfoundation.org>
In-Reply-To: <20200609185946.866927360@linuxfoundation.org>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: linuxfoundation.org; dkim=none (message not signed)
 header.d=none;linuxfoundation.org; dmarc=none action=none
 header.from=renesas.com;
x-originating-ip: [193.141.220.21]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: bd7c73e8-f0b9-4b96-2791-08d80dd3a7c7
x-ms-traffictypediagnostic: OSAPR01MB1521:
x-microsoft-antispam-prvs: <OSAPR01MB1521F4EE52561288BB18D38AB7800@OSAPR01MB1521.jpnprd01.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8273;
x-forefront-prvs: 0431F981D8
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: HyAdtJ/LgQ1DLwjHgu4JQ8npUaxGcSJ5Nka5cVyxHyM0ZtSU9i+n+rWHkd/FrkzQhuMCLPAyueqaEgr6mYWtBv8b2Mxxyjy/M4CV+bJjmv6GcWtokrybhy/1SIQCvMvjPBAMAwCYfgTgYxtW7GdGnhCdSWRyvs6czdVQz2aJkVGZkro5gxYUhBdR7R4ruBOpJT2xIAG4mBu0X3u0UCs0MU6G2MoQ2VWx33EqeXehmQdJuSQEjYDGTmeAhQPkkqoaMkxmcfBqFW4ijT/FNgV8ki83lC2BoCWkEIrHnS47WLd6147GVkNtxtkfKP+/kIIm8ybwRcqffSRLaykggnYPrRQVX32h0HEFmwbAApK8g9lABxDQPrJUpXrPlt7G2Pm7B1mDvWcc6slMEh2YjglamA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:OSAPR01MB2385.jpnprd01.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(39860400002)(366004)(376002)(346002)(136003)(396003)(186003)(26005)(8676002)(7416002)(4326008)(6506007)(7696005)(478600001)(966005)(2906002)(64756008)(5660300002)(52536014)(76116006)(316002)(83380400001)(110136005)(8936002)(71200400001)(55016002)(54906003)(66556008)(86362001)(66446008)(33656002)(66946007)(9686003)(66476007);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: zjhHjA04r6X93X8R++DNPJqCuy4onLAZTcCFJ9vv5maJs44TyQvvoGHMnFVu4a+OuFVna3dYVbp7kGlLWhof7zJbghOdlqE4xJhKPlTnK2P8T8e9yMbu6fEq3kl+mgyLyrLDF1xJVoaX91z7dFlSU97LG6Pknx3q5hOtKxRKkwF7kOGPR3PsJb8Zf3N3sqwpj/ugkyBzJ4vfoZO/LAEhkaEDw05V4fEK+FYGmaXZ/u7KAlK7DjxgYW4cEKt3tpCdEATxOKFMNQ8QZsi/d2GdTHbtfv/ZgvN2zSccLS/UIPtkFHvTuF1ZG2dZrYm7A9autWKdaDNaZlQ9vIEXVayVgs1uOI5QFMOn4GsQNw5ZsNUO3zmSZPbHQdnus4Ibb7Z2FNOx+eR5smVnbILe8cvjzAnWEI2V6Ht/HKE5LIhB4pINbmtFynUC32TayBLmgTxMEEw/9DCsH/2SH+T+DXJZoUAeE3OmbzmJyBEKS2aiCELEg+ZfHC36lR/kPNRGAgsK
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="Windows-1252"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: renesas.com
X-MS-Exchange-CrossTenant-Network-Message-Id: bd7c73e8-f0b9-4b96-2791-08d80dd3a7c7
X-MS-Exchange-CrossTenant-originalarrivaltime: 11 Jun 2020 06:49:57.5733
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 53d82571-da19-47e4-9cb4-625a166a4a2a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: WUJfbTjuXYjaH3vK7Y9xaxaOpD7iBEU+rrIH2W2MRnXK/nt7HoaeYo5sy5sPue4W0t3eOsWRuQB+JZnVkg7f0zjqmrXTiqThXqvCUmN80Ss=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: OSAPR01MB1521
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hello Greg,

> From: stable-owner@vger.kernel.org <stable-owner@vger.kernel.org> On
> Behalf Of Greg Kroah-Hartman
> Sent: 09 June 2020 20:19
>=20
> This is the start of the stable review cycle for the 4.19.128 release.
> There are 25 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

No build/boot issues seen for CIP configs Linux 4.19.128-rc2 (f6c346f2d42d)=
.

Build/test pipeline/logs: https://gitlab.com/cip-project/cip-testing/linux-=
stable-rc-ci/-/pipelines/154549879
GitLab CI pipeline: https://gitlab.com/cip-project/cip-testing/linux-cip-pi=
pelines/-/blob/master/trees/linux-4.19.y.yml
Relevant LAVA jobs: https://lava.ciplatform.org/scheduler/alljobs?length=3D=
25&search=3Df6c346#table

Kind regards, Chris

>=20
> Responses should be made by Thu, 11 Jun 2020 18:59:34 +0000.
> Anything received after that time might be too late.
>=20
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v4.x/stable-
> review/patch-4.19.128-rc2.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-
> rc.git linux-4.19.y
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
>     Linux 4.19.128-rc2
>=20
> Greg Kroah-Hartman <gregkh@linuxfoundation.org>
>     Revert "net/mlx5: Annotate mutex destroy for root ns"
>=20
> Oleg Nesterov <oleg@redhat.com>
>     uprobes: ensure that uprobe->offset and ->ref_ctr_offset are properly
> aligned
>=20
> Josh Poimboeuf <jpoimboe@redhat.com>
>     x86/speculation: Add Ivy Bridge to affected list
>=20
> Mark Gross <mgross@linux.intel.com>
>     x86/speculation: Add SRBDS vulnerability and mitigation documentation
>=20
> Mark Gross <mgross@linux.intel.com>
>     x86/speculation: Add Special Register Buffer Data Sampling (SRBDS)
> mitigation
>=20
> Mark Gross <mgross@linux.intel.com>
>     x86/cpu: Add 'table' argument to cpu_matches()
>=20
> Mark Gross <mgross@linux.intel.com>
>     x86/cpu: Add a steppings field to struct x86_cpu_id
>=20
> Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
>     nvmem: qfprom: remove incorrect write support
>=20
> Oliver Neukum <oneukum@suse.com>
>     CDC-ACM: heed quirk also in error handling
>=20
> Pascal Terjan <pterjan@google.com>
>     staging: rtl8712: Fix IEEE80211_ADDBA_PARAM_BUF_SIZE_MASK
>=20
> Jiri Slaby <jslaby@suse.cz>
>     tty: hvc_console, fix crashes on parallel open/close
>=20
> Dmitry Torokhov <dmitry.torokhov@gmail.com>
>     vt: keyboard: avoid signed integer overflow in k_ascii
>=20
> Dinghao Liu <dinghao.liu@zju.edu.cn>
>     usb: musb: Fix runtime PM imbalance on error
>=20
> Bin Liu <b-liu@ti.com>
>     usb: musb: start session in resume for host port
>=20
> Mathieu Othacehe <m.othacehe@gmail.com>
>     iio: vcnl4000: Fix i2c swapped word reading.
>=20
> Daniele Palmas <dnlplm@gmail.com>
>     USB: serial: option: add Telit LE910C1-EUX compositions
>=20
> Bin Liu <b-liu@ti.com>
>     USB: serial: usb_wwan: do not resubmit rx urb on fatal errors
>=20
> Matt Jolly <Kangie@footclan.ninja>
>     USB: serial: qcserial: add DW5816e QDL support
>=20
> Willem de Bruijn <willemb@google.com>
>     net: check untrusted gso_size at kernel entry
>=20
> Stefano Garzarella <sgarzare@redhat.com>
>     vsock: fix timeout in vsock_accept()
>=20
> Chuhong Yuan <hslester96@gmail.com>
>     NFC: st21nfca: add missed kfree_skb() in an error path
>=20
> Daniele Palmas <dnlplm@gmail.com>
>     net: usb: qmi_wwan: add Telit LE910C1-EUX composition
>=20
> Eric Dumazet <edumazet@google.com>
>     l2tp: do not use inet_hash()/inet_unhash()
>=20
> Eric Dumazet <edumazet@google.com>
>     l2tp: add sk_family checks to l2tp_validate_socket
>=20
> Yang Yingliang <yangyingliang@huawei.com>
>     devinet: fix memleak in inetdev_init()
>=20
>=20
> -------------
>=20
> Diffstat:
>=20
>  Documentation/ABI/testing/sysfs-devices-system-cpu |   1 +
>  Documentation/admin-guide/hw-vuln/index.rst        |   1 +
>  .../special-register-buffer-data-sampling.rst      | 149
> +++++++++++++++++++++
>  Documentation/admin-guide/kernel-parameters.txt    |  20 +++
>  Makefile                                           |   4 +-
>  arch/x86/include/asm/cpu_device_id.h               |  27 ++++
>  arch/x86/include/asm/cpufeatures.h                 |   2 +
>  arch/x86/include/asm/msr-index.h                   |   4 +
>  arch/x86/kernel/cpu/bugs.c                         | 106 +++++++++++++++
>  arch/x86/kernel/cpu/common.c                       |  54 ++++++--
>  arch/x86/kernel/cpu/cpu.h                          |   1 +
>  arch/x86/kernel/cpu/match.c                        |   7 +-
>  drivers/base/cpu.c                                 |   8 ++
>  drivers/iio/light/vcnl4000.c                       |   6 +-
>  drivers/net/ethernet/mellanox/mlx5/core/fs_core.c  |   6 -
>  drivers/net/usb/qmi_wwan.c                         |   1 +
>  drivers/nfc/st21nfca/dep.c                         |   4 +-
>  drivers/nvmem/qfprom.c                             |  14 --
>  drivers/staging/rtl8712/wifi.h                     |   9 +-
>  drivers/tty/hvc/hvc_console.c                      |  23 ++--
>  drivers/tty/vt/keyboard.c                          |  26 ++--
>  drivers/usb/class/cdc-acm.c                        |   2 +-
>  drivers/usb/musb/musb_core.c                       |   7 +
>  drivers/usb/musb/musb_debugfs.c                    |  10 +-
>  drivers/usb/serial/option.c                        |   4 +
>  drivers/usb/serial/qcserial.c                      |   1 +
>  drivers/usb/serial/usb_wwan.c                      |   4 +
>  include/linux/mod_devicetable.h                    |   6 +
>  include/linux/virtio_net.h                         |  14 +-
>  kernel/events/uprobes.c                            |  14 +-
>  net/ipv4/devinet.c                                 |   1 +
>  net/l2tp/l2tp_core.c                               |   3 +
>  net/l2tp/l2tp_ip.c                                 |  29 +++-
>  net/l2tp/l2tp_ip6.c                                |  30 +++--
>  net/vmw_vsock/af_vsock.c                           |   2 +-
>  35 files changed, 501 insertions(+), 99 deletions(-)
>=20

