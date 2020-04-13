Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DAAC11A6CC0
	for <lists+stable@lfdr.de>; Mon, 13 Apr 2020 21:45:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388066AbgDMTo7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Apr 2020 15:44:59 -0400
Received: from mail-eopbgr1400125.outbound.protection.outlook.com ([40.107.140.125]:44615
        "EHLO JPN01-TY1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2387774AbgDMTo6 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 13 Apr 2020 15:44:58 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=JnlUtzquAY0kgERaysYWTKFIbVCSRpk3A5ZzMS5avWY20XlfEe1ubHd9FNSbufkYdvvFc+/8tV9hk/Bc3v2uZDC9kNyqgV3FW/QN6E0rwMVo8yPfVtvGvH08Qk1O9gQme3BdfHWwIsXSguZ/H4v4rRTWZoVnKkEHI48sx86C+tvZo8WYXbOSkpnpT0f1RL6/tlxvB/TQbUGD9kXj1uqgtd2rGPJbV/SGMLp7utNl+xOhSZf0+j780GTW+X0FBUmUKJ5J44psrU/zv+2y7JSHieoiVHq+2HiZmfA4A1vVr7zz8g+H/M2FtbOScFk/BuMUR7V567998lD6/LAhhDm/zw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=a6LDW7/H+EBBNuHRfTr6Et9UL/3C4OV/6wNgllUIdBU=;
 b=Ucer6T9RzCmWnYXCPV0fpop9DunoPGBlNsnn+5+TjCUDwSSoMsZT03+CrW95hwOFvpb/7jjhRUgfTaj8W7x/bcpUstmew0wcYxNsA3f0WB5VQVYDwY88+lBlrSIwt715gAGWK+LNoj0hA7DRG97uHUSNV5RDN+IbtxqkCh1vcpqYDypELlgRNuBgeM8YtWrG/2AhLSLGEIrRggfCZQ7zMf/6MX6mxXN/t1mTzAm3RPWWpSmPlhJ+62exoRIHagFKvRseH8WTepD7+PR9iHMTMVfHV475BY9cT0xUaZF7X/zen0f/PNpKQ863hKmOLKsaD3wglCc3LgQQnVriJxJA7A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=renesas.com; dmarc=pass action=none header.from=renesas.com;
 dkim=pass header.d=renesas.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=renesasgroup.onmicrosoft.com; s=selector2-renesasgroup-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=a6LDW7/H+EBBNuHRfTr6Et9UL/3C4OV/6wNgllUIdBU=;
 b=J3+2cCBOC6UYjSIRd2FGf0WD1AxufwPrdr+OSB+CV7RBdMJxMXqh5turKHMLNzKYC90Kw0ZBmQobTUW9M6tOvUFU1PwTf8/DwT2/OL8qmErJIZKsxhdV0BAFV1B6ADh9cl1FfxBWiR2+hqLrZbgL3T+tvw6ZdTiTmncAZ7bWb+s=
Received: from OSBPR01MB2280.jpnprd01.prod.outlook.com (52.134.243.13) by
 OSBPR01MB3736.jpnprd01.prod.outlook.com (20.178.97.141) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2900.15; Mon, 13 Apr 2020 19:44:52 +0000
Received: from OSBPR01MB2280.jpnprd01.prod.outlook.com
 ([fe80::c9a6:9735:12fc:ae04]) by OSBPR01MB2280.jpnprd01.prod.outlook.com
 ([fe80::c9a6:9735:12fc:ae04%2]) with mapi id 15.20.2878.027; Mon, 13 Apr 2020
 19:44:52 +0000
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
Subject: RE: [PATCH 4.4 00/29] 4.4.219-rc1 review
Thread-Topic: [PATCH 4.4 00/29] 4.4.219-rc1 review
Thread-Index: AQHWD/zYd0C9JJjJbUG7z8o3o8hv7qh3d4bg
Date:   Mon, 13 Apr 2020 19:44:52 +0000
Message-ID: <OSBPR01MB2280119F9A67A6194747545EB7DD0@OSBPR01MB2280.jpnprd01.prod.outlook.com>
References: <20200411115407.651296755@linuxfoundation.org>
In-Reply-To: <20200411115407.651296755@linuxfoundation.org>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=Chris.Paterson2@renesas.com; 
x-originating-ip: [151.224.220.27]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 6385deaf-f117-4d3e-728a-08d7dfe32293
x-ms-traffictypediagnostic: OSBPR01MB3736:
x-microsoft-antispam-prvs: <OSBPR01MB3736ABF1347211E2F739D6C4B7DD0@OSBPR01MB3736.jpnprd01.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8882;
x-forefront-prvs: 037291602B
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:OSBPR01MB2280.jpnprd01.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(10019020)(4636009)(366004)(346002)(396003)(39860400002)(136003)(376002)(26005)(7696005)(52536014)(8676002)(81156014)(86362001)(9686003)(2906002)(186003)(55016002)(4326008)(6506007)(8936002)(478600001)(66556008)(966005)(64756008)(316002)(66446008)(33656002)(66476007)(110136005)(5660300002)(71200400001)(76116006)(54906003)(66946007)(7416002);DIR:OUT;SFP:1102;
received-spf: None (protection.outlook.com: renesas.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: Cio/k186JmHo+xWSkx34oWqZ/rpxooiW8chc9bA3B3MbTC5qct8BcY14Oe/LqHBSXw8zTNliAVLW+tk349gmFICWhBa3ZENXJyiGDiFCH2LXgZcsMYa5WfnrVpj6DkdKyZIZPR5IMiBtZ9T4w68LlvgOa0DZFmssC5VaLiF+i1hKSlPukXhua9Hla28wjwxwHA6ITlkZuLcZqKJ2JIBzYlBdWVx1GsqKiAtiO500vZDyEpjDb7/5q4pLl0pFdpWzx/HB8yA22gH2taBFpXlT8heVQMmd5V3lVKa95ce0GOPtmim89Do0/2U0XrpNWyb1YJsGG8y6vkF9WXcTrshl1tRnjTal/hJa9EeR0nRQmMD+F46MTvqtc7hG8xebzripYH2HdnH7qcOmVYhnY1AzadTFFQFe8PgEnpBnjlgLoD+CyX6J0hPXbt/9903tBRTWBfuPrcBDjp60rPKEBoj6FW4lcgstQC8ODS83GG/0gjff8//gDUVOXDmP2x6DrLMoHNpIRBk8+U+mgVDahFNguw==
x-ms-exchange-antispam-messagedata: gbA3+TbiB4QcgRSFuGMv5dzrob5ok6EjJl+Hd4huxVsN6rfm3R0fDJzvKFhztY6u+lsDRLUrTMIuQWV606GD36aQ87dhxlsEDl+0bpU85KYb/5s2/Zh3WLkf/BIgU5uM/ecz+1m+Blh4MWHMRn2G+g==
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="Windows-1252"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: renesas.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6385deaf-f117-4d3e-728a-08d7dfe32293
X-MS-Exchange-CrossTenant-originalarrivaltime: 13 Apr 2020 19:44:52.5553
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 53d82571-da19-47e4-9cb4-625a166a4a2a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: rdO9n1F/ZW3H62tmKRArzaBxXPYTPAwtqIR77Zq9Eqlzk+UsqeGWpn/sTDTe1gYUa3JjktfvJ9avjBf2hbCxo5Jkdk34XTwqGhsUHxNYgIE=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: OSBPR01MB3736
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hello Greg,

> From: stable-owner@vger.kernel.org <stable-owner@vger.kernel.org> On
> Behalf Of Greg Kroah-Hartman
> Sent: 11 April 2020 13:09
>=20
> This is the start of the stable review cycle for the 4.4.219 release.
> There are 29 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>=20
> Responses should be made by Mon, 13 Apr 2020 11:51:28 +0000.
> Anything received after that time might be too late.

No build issues seen for CIP configs for Linux 4.4.219-rc1 (8cd74c57ff4a).

Build logs: https://gitlab.com/cip-project/cip-testing/linux-stable-rc-ci/p=
ipelines/134988008
GitLab CI Pipeline: https://gitlab.com/cip-project/cip-testing/linux-cip-pi=
pelines/-/blob/master/trees/linux-4.4.y.yml

Kind regards, Chris

>=20
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-
> 4.4.219-rc1.gz
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
>     Linux 4.4.219-rc1
>=20
> Hans Verkuil <hans.verkuil@cisco.com>
>     drm_dp_mst_topology: fix broken
> drm_dp_sideband_parse_remote_dpcd_read()
>=20
> Taniya Das <tdas@codeaurora.org>
>     clk: qcom: rcg: Return failure for RCG update
>=20
> Avihai Horon <avihaih@mellanox.com>
>     RDMA/cm: Update num_paths in cma_resolve_iboe_route error flow
>=20
> Qiujun Huang <hqjagain@gmail.com>
>     Bluetooth: RFCOMM: fix ODEBUG bug in rfcomm_dev_ioctl
>=20
> Kaike Wan <kaike.wan@intel.com>
>     IB/hfi1: Call kobject_put() when kobject_init_and_add() fails
>=20
> Paul Cercueil <paul@crapouillou.net>
>     ASoC: jz4740-i2s: Fix divider written at incorrect offset in register
>=20
> Ross Lagerwall <ross.lagerwall@citrix.com>
>     xen-netfront: Update features after registering netdev
>=20
> Ross Lagerwall <ross.lagerwall@citrix.com>
>     xen-netfront: Fix mismatched rtnl_unlock
>=20
> Gustavo A. R. Silva <gustavo@embeddedor.com>
>     power: supply: axp288_charger: Fix unchecked return value
>=20
> David Ahern <dsahern@kernel.org>
>     tools/accounting/getdelays.c: fix netlink attribute length
>=20
> Jason A. Donenfeld <Jason@zx2c4.com>
>     random: always use batched entropy for get_random_u{32,64}
>=20
> Richard Palethorpe <rpalethorpe@suse.com>
>     slcan: Don't transmit uninitialized stack data in padding
>=20
> Jisheng Zhang <Jisheng.Zhang@synaptics.com>
>     net: stmmac: dwmac1000: fix out-of-bounds mac address reg setting
>=20
> Randy Dunlap <rdunlap@infradead.org>
>     mm: mempolicy: require at least one nodeid for MPOL_PREFERRED
>=20
> Daniel Jordan <daniel.m.jordan@oracle.com>
>     padata: always acquire cpu_hotplug_lock before pinst->lock
>=20
> Krzysztof Opasiak <k.opasiak@samsung.com>
>     usb: gadget: printer: Drop unused device qualifier descriptor
>=20
> Krzysztof Opasiak <k.opasiak@samsung.com>
>     usb: gadget: uac2: Drop unused device qualifier descriptor
>=20
> Guillaume Nault <g.nault@alphalink.fr>
>     l2tp: fix race between l2tp_session_delete() and l2tp_tunnel_closeall=
()
>=20
> Guillaume Nault <g.nault@alphalink.fr>
>     l2tp: ensure sessions are freed after their PPPOL2TP socket
>=20
> Gao Feng <fgao@ikuai8.com>
>     l2tp: Refactor the codes with existing macros instead of literal numb=
er
>=20
> Guillaume Nault <g.nault@alphalink.fr>
>     l2tp: fix duplicate session creation
>=20
> Guillaume Nault <g.nault@alphalink.fr>
>     l2tp: ensure session can't get removed during pppol2tp_session_ioctl(=
)
>=20
> Guillaume Nault <g.nault@alphalink.fr>
>     l2tp: fix race in l2tp_recv_common()
>=20
> Shmulik Ladkani <shmulik.ladkani@gmail.com>
>     net: l2tp: Make l2tp_ip6 namespace aware
>=20
> phil.turnbull@oracle.com <phil.turnbull@oracle.com>
>     l2tp: Correctly return -EBADF from pppol2tp_getname.
>=20
> Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
>     sctp: fix possibly using a bad saddr with a given dst
>=20
> William Dauchy <w.dauchy@criteo.com>
>     net, ip_tunnel: fix interface lookup with no key
>=20
> Qian Cai <cai@lca.pw>
>     ipv4: fix a RCU-list lock in fib_triestat_seq_show
>=20
> Gerd Hoffmann <kraxel@redhat.com>
>     drm/bochs: downgrade pci_request_region failure from error to warning
>=20
>=20
> -------------
>=20
> Diffstat:
>=20
>  Documentation/accounting/getdelays.c               |   2 +-
>  Makefile                                           |   4 +-
>  drivers/char/random.c                              |   6 -
>  drivers/clk/qcom/clk-rcg2.c                        |   2 +-
>  drivers/gpu/drm/bochs/bochs_hw.c                   |   6 +-
>  drivers/gpu/drm/drm_dp_mst_topology.c              |   1 +
>  drivers/infiniband/core/cma.c                      |   1 +
>  drivers/net/can/slcan.c                            |   4 +-
>  .../net/ethernet/stmicro/stmmac/dwmac1000_core.c   |   2 +-
>  drivers/net/xen-netfront.c                         |  11 +-
>  drivers/power/axp288_charger.c                     |   4 +
>  drivers/staging/rdma/hfi1/sysfs.c                  |  13 +-
>  drivers/usb/gadget/function/f_printer.c            |   8 --
>  drivers/usb/gadget/function/f_uac2.c               |  12 --
>  kernel/padata.c                                    |   4 +-
>  mm/mempolicy.c                                     |   6 +-
>  net/bluetooth/rfcomm/tty.c                         |   4 +-
>  net/ipv4/fib_trie.c                                |   3 +
>  net/ipv4/ip_tunnel.c                               |   6 +-
>  net/l2tp/l2tp_core.c                               | 149 +++++++++++++++=
+-----
>  net/l2tp/l2tp_core.h                               |   4 +
>  net/l2tp/l2tp_eth.c                                |  10 +-
>  net/l2tp/l2tp_ip.c                                 |  17 ++-
>  net/l2tp/l2tp_ip6.c                                |  28 ++--
>  net/l2tp/l2tp_ppp.c                                | 110 +++++++--------
>  net/sctp/ipv6.c                                    |  20 ++-
>  net/sctp/protocol.c                                |  28 ++--
>  sound/soc/jz4740/jz4740-i2s.c                      |   2 +-
>  28 files changed, 285 insertions(+), 182 deletions(-)
>=20

