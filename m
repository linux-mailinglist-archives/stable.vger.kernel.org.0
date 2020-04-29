Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BAD941BD575
	for <lists+stable@lfdr.de>; Wed, 29 Apr 2020 09:13:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726386AbgD2HNS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 29 Apr 2020 03:13:18 -0400
Received: from mail-eopbgr1400123.outbound.protection.outlook.com ([40.107.140.123]:11981
        "EHLO JPN01-TY1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726366AbgD2HNR (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 29 Apr 2020 03:13:17 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ee0pzuPu9cKqIcq7WzH8Oyk2E5GII6wj+BHU4PhKy7ZLa5xi00YausoXDZxqqRYOV42mGAbJ2aLYbYe4eL3Fa2CwFI9KHFPN/j8vDq0XLKwKOLGdvt+zFSvDohcpHQug5Clc1ssMlvSix8n+p5AuMEXLlTFaN6xyMubfH7INGF7hiBLyKZn6IBHlk9cjid3Sxyy7uFIL1VmEvglnkm/t9VBZ9+B8FlabVaNHAtuRHGhRhruajhUebzGeho3wVK/XiYTny3aSMUBA94w0YijFc02Bh3wz5qw5ztXaPOpzuXRPajPmFEAsonKSbsB2cbNcWMcsr7msmQy670sPRFKSig==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=DB/uagTooe7/ZdyWGZXV1pFYQTFiUGKq23PLdQS9oOk=;
 b=VpdZSt65s9iuik6DKLhWBRcYavouAuvUOEVEGReZmTn16yfBYJ/6ph9/yPtIsrm37VCeAkcr2AMwhOYJd4sWEx4W+oxDM1ePPOQqHxmzi1Vq9Oxny5hWGaA3Sb2DdZP04vAeUD1wFOMu+JJSs2VO374UXTSVBVencNQlzgJ9Z/UTHAkmBh6Oe5VjARgrV0h6WQfyuniCF7wqGerGOs4nDKiMAFoCzvylw7XgcpDGL0aYdlUZQikFeyUu24TEKG69SzARMDdFSt4F50DGBXDZew7G/An2ZGsKO3Cq9ZLrC0ImRkYh02F7s6FCCKHFYtjJFIYg15St+zZAqVye/6wxsw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=renesas.com; dmarc=pass action=none header.from=renesas.com;
 dkim=pass header.d=renesas.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=renesasgroup.onmicrosoft.com; s=selector2-renesasgroup-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=DB/uagTooe7/ZdyWGZXV1pFYQTFiUGKq23PLdQS9oOk=;
 b=nzcICnYgf2qNECYCpk2ahZN1M1jkKyCGA+hHofSqNp2EbUcKyM8YEWL0K8lYnAUJWHq/hhTHlsM7BemAIwY5N6/jwy8VVGqPEMIaScK3Jm8rXsyRkWxmWC+YP7p5GHXvGhKMB69qCHK0L/pJ1I497oT7bcd8IKM9FHOwVLW+FvU=
Received: from OSAPR01MB2385.jpnprd01.prod.outlook.com (52.134.245.84) by
 OSAPR01MB3281.jpnprd01.prod.outlook.com (52.134.249.143) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2937.13; Wed, 29 Apr 2020 07:13:09 +0000
Received: from OSAPR01MB2385.jpnprd01.prod.outlook.com
 ([fe80::2f:ca16:fa59:a37f]) by OSAPR01MB2385.jpnprd01.prod.outlook.com
 ([fe80::2f:ca16:fa59:a37f%7]) with mapi id 15.20.2958.019; Wed, 29 Apr 2020
 07:13:09 +0000
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
Subject: RE: [PATCH 4.19 000/131] 4.19.119-rc1 review
Thread-Topic: [PATCH 4.19 000/131] 4.19.119-rc1 review
Thread-Index: AQHWHY83kVqK7E71xki2x2PIUnsyYKiPr2aA
Date:   Wed, 29 Apr 2020 07:13:09 +0000
Message-ID: <OSAPR01MB2385C64F3D0FACE7C25144F9B7AD0@OSAPR01MB2385.jpnprd01.prod.outlook.com>
References: <20200428182224.822179290@linuxfoundation.org>
In-Reply-To: <20200428182224.822179290@linuxfoundation.org>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: linuxfoundation.org; dkim=none (message not signed)
 header.d=none;linuxfoundation.org; dmarc=none action=none
 header.from=renesas.com;
x-originating-ip: [151.224.220.27]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 4792f6aa-db30-48fa-5ee2-08d7ec0cc584
x-ms-traffictypediagnostic: OSAPR01MB3281:
x-microsoft-antispam-prvs: <OSAPR01MB32817C710EA4829788D90CEDB7AD0@OSAPR01MB3281.jpnprd01.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:3826;
x-forefront-prvs: 03883BD916
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:OSAPR01MB2385.jpnprd01.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(136003)(366004)(346002)(376002)(39860400002)(396003)(2906002)(966005)(66476007)(54906003)(110136005)(316002)(66946007)(6506007)(71200400001)(33656002)(478600001)(55016002)(66446008)(7696005)(5660300002)(9686003)(4326008)(86362001)(52536014)(76116006)(64756008)(7416002)(66556008)(26005)(30864003)(8676002)(186003)(8936002)(579004);DIR:OUT;SFP:1102;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: Lg/rAq762hMPXMrDFGLeutDX78DoQc+B1HzAYpFCSBOfhinZ27LawsaK3XlzGDJuFcOz1iRMM7ephrhRnopXNSk5j9Fb/Darob9Ukq2DpfMy6yS0j5MxREFgikS2DQ8SPK2iXeFWSomz+cAmlmAfUowhGpxk5FCDmc8KMb2WfmOf90CuB892SeyLQatq1nZJ1b8vggfPvymN6zucRtR717wicO21VZRgpItxCcERGpoaAkcLGWXZSNq1q4zvBM4R/Wd2RghGclYlfdhgb2XT6oal3kkM3LtE5Yz5nHdF74dJAZnSoaLiOffahgjqn4hqViLj7V3J4GDImJ4+p7ZyO51wQb4850/4wFtCP4LsCXPEcxo978/HEmtDa8DfrW+FURBkSiWiDgEfZwXE1jtqp9DMidTRyVa5e77f8rPP5HNkAQ1nd4mZ2XqBD4cOWrewLj0WdJlZAUBZRduTrhZZUESf8cPwHi6EGcFml/GSPPZupfDN0fuN7SRBom9AfxmOFpyDLS90QRQEMbGa7FFNkg==
x-ms-exchange-antispam-messagedata: /G7QGml2rBcvxUrHRnEph5ycNbwCjVHY4vYx7GZ4JFAFgS0nf5qAM9DVwSw8f+bkfodoV1Wnk6uxvFItKF9cxxjUx3mmLomSfChzzuJQ2sOAhNXa4n9XwSiSezQwJDhzs7EYiwcuU1wUGcsU8iYkkv1Usz7h3muA5wY//7Z6cyuOynoeBjoAoD8sxaroJS0cSe+x79M2RX7Fi98tbxY+4ePBRX4gq/cCEx6vwXOVMUWwidlvldVIiO3IY+2jaPa5F1lbwshzc2Ug1bPJrTAY/ezkD69rx+xox5K1ppeQmYW7XGoYBrsxkq2Qbkj3KYFWHXEfVs45WhknPGmBZRKocC7bFN0pW3FEwUVFy/ilb9uGcQz0rZtuA/cenE2QUHFP1Hu9jizABuW0pIAf4g8Nm6DvOtYf4w0Xnhs7dBo8gUp92rY6ljkaAe691+9fpApVsyBo2GpYoqty2Y/LHLyPWuopEhQ07Q9j3a2Em0trB6MGGLgLSWv8KKGJIak2KsDdWzBxCKPeQF7ejvL2ag6N05p9OdJAH2sCjR8uc/BRbdfn/l22qooOeHZKtk86nFRvHj9JeRmHeRbIc55ip/zXQXX8SENhtWFjmfW0iucb5qu9M7C4VFbAwt1vZ0/6XUb1565bi5FCMPnFy5i9B+SO4u3DINzG9VQOVpEm6ZZT8y9b3q8PZiU6e1XB1pmg3+ti9KiBLUw4icHhEwb7tFMRtXfHQ9KcTqHZpx772rfYbr/5NluCKhhrJE2o/6odgdhGxcjCoLcyI4Wg2hp04an3ZkhsN7Mq5pgqVk3g+ZiOCTA=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="Windows-1252"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: renesas.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4792f6aa-db30-48fa-5ee2-08d7ec0cc584
X-MS-Exchange-CrossTenant-originalarrivaltime: 29 Apr 2020 07:13:09.0475
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 53d82571-da19-47e4-9cb4-625a166a4a2a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: vVhgs9XZ9ow+2F3LObo5AHcf05dbQB7SOebREiHOMgc0R9mUH9mUYUPj9X6IbdLxzvNoOLD/WJ3YjMGBN18K/ZUz1PWv4M6u6BGgpD49cto=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: OSAPR01MB3281
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hello Greg,

> From: stable-owner@vger.kernel.org <stable-owner@vger.kernel.org> On
> Behalf Of Greg Kroah-Hartman
> Sent: 28 April 2020 19:24
>=20
> This is the start of the stable review cycle for the 4.19.119 release.
> There are 131 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

No build/boot issues seen for CIP configs for Linux 4.19.119-rc1 (3fc812d65=
db6).

Build/test pipeline/logs: https://gitlab.com/cip-project/cip-testing/linux-=
stable-rc-ci/pipelines/140770244
GitLab CI pipeline: https://gitlab.com/cip-project/cip-testing/linux-cip-pi=
pelines/-/blob/master/trees/linux-4.19.y.yml
Relevant LAVA jobs: https://lava.ciplatform.org/scheduler/alljobs?length=3D=
25&search=3D3fc812#table

Kind regards, Chris

>=20
> Responses should be made by Thu, 30 Apr 2020 18:20:45 +0000.
> Anything received after that time might be too late.
>=20
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-
> 4.19.119-rc1.gz
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
>     Linux 4.19.119-rc1
>=20
> Christian Borntraeger <borntraeger@de.ibm.com>
>     s390/mm: fix page table upgrade vs 2ndary address mode accesses
>=20
> kaixuxia <xiakaixu1987@gmail.com>
>     xfs: Fix deadlock between AGI and AGF with RENAME_WHITEOUT
>=20
> Kazuhiro Fujita <kazuhiro.fujita.jg@renesas.com>
>     serial: sh-sci: Make sure status register SCxSR is read in correct se=
quence
>=20
> Mathias Nyman <mathias.nyman@linux.intel.com>
>     xhci: prevent bus suspend if a roothub port detected a over-current c=
ondition
>=20
> Udipto Goswami <ugoswami@codeaurora.org>
>     usb: f_fs: Clear OS Extended descriptor counts to zero in ffs_data_re=
set()
>=20
> Thinh Nguyen <Thinh.Nguyen@synopsys.com>
>     usb: dwc3: gadget: Fix request completion check
>=20
> Oliver Neukum <oneukum@suse.com>
>     UAS: fix deadlock in error handling and PM flushing work
>=20
> Oliver Neukum <oneukum@suse.com>
>     UAS: no use logging any details in case of ENODEV
>=20
> Oliver Neukum <oneukum@suse.com>
>     cdc-acm: introduce a cool down
>=20
> Oliver Neukum <oneukum@suse.com>
>     cdc-acm: close race betrween suspend() and acm_softint
>=20
> Malcolm Priestley <tvboxspy@gmail.com>
>     staging: vt6656: Power save stop wake_up_count wrap around.
>=20
> Malcolm Priestley <tvboxspy@gmail.com>
>     staging: vt6656: Fix pairwise key entry save.
>=20
> Malcolm Priestley <tvboxspy@gmail.com>
>     staging: vt6656: Fix drivers TBTT timing counter.
>=20
> Malcolm Priestley <tvboxspy@gmail.com>
>     staging: vt6656: Fix calling conditions of vnt_set_bss_mode
>=20
> Malcolm Priestley <tvboxspy@gmail.com>
>     staging: vt6656: Don't set RCR_MULTICAST or RCR_BROADCAST by default.
>=20
> Nicolas Pitre <nico@fluxnic.net>
>     vt: don't use kmalloc() for the unicode screen buffer
>=20
> Nicolas Pitre <nico@fluxnic.net>
>     vt: don't hardcode the mem allocation upper bound
>=20
> Xiyu Yang <xiyuyang19@fudan.edu.cn>
>     staging: comedi: Fix comedi_device refcnt leak in comedi_open
>=20
> Ian Abbott <abbotti@mev.co.uk>
>     staging: comedi: dt2815: fix writing hi byte of analog output
>=20
> Chris Packham <chris.packham@alliedtelesis.co.nz>
>     powerpc/setup_64: Set cache-line-size based on cache-block-size
>=20
> Ahmad Fatoum <a.fatoum@pengutronix.de>
>     ARM: imx: provide v7_cpu_resume() only on ARM_CPU_SUSPEND=3Dy
>=20
> Mordechay Goodstein <mordechay.goodstein@intel.com>
>     iwlwifi: mvm: beacon statistics shouldn't go backwards
>=20
> Johannes Berg <johannes.berg@intel.com>
>     iwlwifi: pcie: actually release queue memory in TVQM
>=20
> Gyeongtaek Lee <gt82.lee@samsung.com>
>     ASoC: dapm: fixup dapm kcontrol widget
>=20
> Paul Moore <paul@paul-moore.com>
>     audit: check the length of userspace generated audit records
>=20
> Alan Stern <stern@rowland.harvard.edu>
>     usb-storage: Add unusual_devs entry for JMicron JMS566
>=20
> Jiri Slaby <jslaby@suse.cz>
>     tty: rocket, avoid OOB access
>=20
> Andrew Melnychenko <andrew@daynix.com>
>     tty: hvc: fix buffer overflow during hvc_alloc().
>=20
> Uros Bizjak <ubizjak@gmail.com>
>     KVM: VMX: Enable machine check support for 32bit targets
>=20
> Sean Christopherson <sean.j.christopherson@intel.com>
>     KVM: Check validity of resolved slot when searching memslots
>=20
> Sean Christopherson <sean.j.christopherson@intel.com>
>     KVM: s390: Return last valid slot if approx index is out-of-bounds
>=20
> George Wilson <gcwilson@linux.ibm.com>
>     tpm: ibmvtpm: retry on H_CLOSED in tpm_ibmvtpm_send()
>=20
> Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
>     tpm/tpm_tis: Free IRQ if probing fails
>=20
> Alexander Tsoy <alexander@tsoy.me>
>     ALSA: usb-audio: Filter out unsupported sample rates on Focusrite dev=
ices
>=20
> Xiyu Yang <xiyuyang19@fudan.edu.cn>
>     ALSA: usb-audio: Fix usb audio refcnt leak when getting spdif
>=20
> Kailang Yang <kailang@realtek.com>
>     ALSA: hda/realtek - Add new codec supported for ALC245
>=20
> Takashi Iwai <tiwai@suse.de>
>     ALSA: hda/realtek - Fix unexpected init_amp override
>=20
> Takashi Iwai <tiwai@suse.de>
>     ALSA: usx2y: Fix potential NULL dereference
>=20
> Lucas Stach <l.stach@pengutronix.de>
>     tools/vm: fix cross-compile build
>=20
> Muchun Song <songmuchun@bytedance.com>
>     mm/ksm: fix NULL pointer dereference when KSM zero page is enabled
>=20
> Longpeng <longpeng2@huawei.com>
>     mm/hugetlb: fix a addressing exception caused by huge_pte_offset
>=20
> Jann Horn <jannh@google.com>
>     vmalloc: fix remap_vmalloc_range() bounds checks
>=20
> Alan Stern <stern@rowland.harvard.edu>
>     USB: hub: Fix handling of connect changes during sleep
>=20
> Alan Stern <stern@rowland.harvard.edu>
>     USB: core: Fix free-while-in-use bug in the USB S-Glibrary
>=20
> Jann Horn <jannh@google.com>
>     USB: early: Handle AMD's spec-compliant identifiers, too
>=20
> Jonathan Cox <jonathan@jdcox.net>
>     USB: Add USB_QUIRK_DELAY_CTRL_MSG and USB_QUIRK_DELAY_INIT for
> Corsair K70 RGB RAPIDFIRE
>=20
> Changming Liu <liu.changm@northeastern.edu>
>     USB: sisusbvga: Change port variable from signed to unsigned
>=20
> Piotr Krysiuk <piotras@gmail.com>
>     fs/namespace.c: fix mountpoint reference counter race
>=20
> Lars-Peter Clausen <lars@metafoo.de>
>     iio: xilinx-xadc: Make sure not exceed maximum samplerate
>=20
> Lars-Peter Clausen <lars@metafoo.de>
>     iio: xilinx-xadc: Fix sequencer configuration for aux channels in sim=
ultaneous
> mode
>=20
> Lars-Peter Clausen <lars@metafoo.de>
>     iio: xilinx-xadc: Fix clearing interrupt when enabling trigger
>=20
> Lars-Peter Clausen <lars@metafoo.de>
>     iio: xilinx-xadc: Fix ADC-B powerdown
>=20
> Olivier Moysan <olivier.moysan@st.com>
>     iio: adc: stm32-adc: fix sleep in atomic context
>=20
> Lary Gibaud <yarl-baudig@mailoo.org>
>     iio: st_sensors: rely on odr mask to know if odr can be set
>=20
> Lars Engebretsen <lars@engebretsen.ch>
>     iio: core: remove extra semi-colon from devm_iio_device_register() ma=
cro
>=20
> Takashi Iwai <tiwai@suse.de>
>     ALSA: usb-audio: Add connector notifier delegation
>=20
> Takashi Iwai <tiwai@suse.de>
>     ALSA: usb-audio: Add static mapping table for ALC1220-VB-based mobos
>=20
> Takashi Iwai <tiwai@suse.de>
>     ALSA: hda: Remove ASUS ROG Zenith from the blacklist
>=20
> Waiman Long <longman@redhat.com>
>     KEYS: Avoid false positive ENOMEM error on key read
>=20
> Dan Carpenter <dan.carpenter@oracle.com>
>     mlxsw: Fix some IS_ERR() vs NULL bugs
>=20
> David Ahern <dsahern@gmail.com>
>     vrf: Check skb for XFRM_TRANSFORMED flag
>=20
> David Ahern <dsahern@gmail.com>
>     xfrm: Always set XFRM_TRANSFORMED in xfrm{4,6}_output_finish
>=20
> Florian Fainelli <f.fainelli@gmail.com>
>     net: dsa: b53: b53_arl_rw_op() needs to select IVL or SVL
>=20
> Florian Fainelli <f.fainelli@gmail.com>
>     net: dsa: b53: Rework ARL bin logic
>=20
> Florian Fainelli <f.fainelli@gmail.com>
>     net: dsa: b53: Fix ARL register definitions
>=20
> Florian Fainelli <f.fainelli@gmail.com>
>     net: dsa: b53: Lookup VID in ARL searches when VLAN is enabled
>=20
> David Ahern <dsahern@gmail.com>
>     vrf: Fix IPv6 with qdisc and xfrm
>=20
> Taehee Yoo <ap420073@gmail.com>
>     team: fix hang in team_mode_get()
>=20
> Eric Dumazet <edumazet@google.com>
>     tcp: cache line align MAX_TCP_HEADER
>=20
> Eric Dumazet <edumazet@google.com>
>     sched: etf: do not assume all sockets are full blown
>=20
> Xiyu Yang <xiyuyang19@fudan.edu.cn>
>     net/x25: Fix x25_neigh refcnt leak when receiving frame
>=20
> Marc Zyngier <maz@kernel.org>
>     net: stmmac: dwmac-meson8b: Add missing boundary to RGMII TX clock ar=
ray
>=20
> Xiyu Yang <xiyuyang19@fudan.edu.cn>
>     net: netrom: Fix potential nr_neigh refcnt leak in nr_add_node
>=20
> Doug Berger <opendmb@gmail.com>
>     net: bcmgenet: correct per TX/RX ring statistics
>=20
> Taehee Yoo <ap420073@gmail.com>
>     macvlan: fix null dereference in macvlan_device_event()
>=20
> Taehee Yoo <ap420073@gmail.com>
>     macsec: avoid to set wrong mtu
>=20
> John Haxby <john.haxby@oracle.com>
>     ipv6: fix restrict IPV6_ADDRFORM operation
>=20
> Rahul Lakkireddy <rahul.lakkireddy@chelsio.com>
>     cxgb4: fix large delays in PTP synchronization
>=20
> Vishal Kulkarni <vishal@chelsio.com>
>     cxgb4: fix adapter crash due to wrong MC size
>=20
> Boris Ostrovsky <boris.ostrovsky@oracle.com>
>     x86/KVM: Clean up host's steal time structure
>=20
> Boris Ostrovsky <boris.ostrovsky@oracle.com>
>     x86/KVM: Make sure KVM_VCPU_FLUSH_TLB flag is not missed
>=20
> Boris Ostrovsky <boris.ostrovsky@oracle.com>
>     x86/kvm: Cache gfn to pfn translation
>=20
> Boris Ostrovsky <boris.ostrovsky@oracle.com>
>     x86/kvm: Introduce kvm_(un)map_gfn()
>=20
> KarimAllah Ahmed <karahmed@amazon.de>
>     KVM: Properly check if "page" is valid in kvm_vcpu_unmap
>=20
> Christian Borntraeger <borntraeger@de.ibm.com>
>     kvm: fix compile on s390 part 2
>=20
> Paolo Bonzini <pbonzini@redhat.com>
>     kvm: fix compilation on s390
>=20
> Paolo Bonzini <pbonzini@redhat.com>
>     kvm: fix compilation on aarch64
>=20
> KarimAllah Ahmed <karahmed@amazon.de>
>     KVM: Introduce a new guest mapping API
>=20
> Sean Christopherson <sean.j.christopherson@intel.com>
>     KVM: nVMX: Always sync GUEST_BNDCFGS when it comes from vmcs01
>=20
> Sean Christopherson <sean.j.christopherson@intel.com>
>     KVM: VMX: Zero out *all* general purpose registers after VM-Exit
>=20
> Randall Huang <huangrandall@google.com>
>     f2fs: fix to avoid memory leakage in f2fs_listxattr
>=20
> Cengiz Can <cengiz@kernel.wtf>
>     blktrace: fix dereference after null check
>=20
> Jan Kara <jack@suse.cz>
>     blktrace: Protect q->blk_trace with RCU
>=20
> Sabrina Dubroca <sd@queasysnail.net>
>     net: ipv6_stub: use ip6_dst_lookup_flow instead of ip6_dst_lookup
>=20
> Sabrina Dubroca <sd@queasysnail.net>
>     net: ipv6: add net argument to ip6_dst_lookup_flow
>=20
> Heiner Kallweit <hkallweit1@gmail.com>
>     PCI/ASPM: Allow re-enabling Clock PM
>=20
> Murthy Bhat <Murthy.Bhat@microsemi.com>
>     scsi: smartpqi: fix call trace in device discovery
>=20
> Halil Pasic <pasic@linux.ibm.com>
>     virtio-blk: improve virtqueue error to BLK_STS
>=20
> Steven Rostedt (VMware) <rostedt@goodmis.org>
>     tracing/selftests: Turn off timeout setting
>=20
> Yongqiang Sun <yongqiang.sun@amd.com>
>     drm/amd/display: Not doing optimize bandwidth if flip pending.
>=20
> Kai-Heng Feng <kai.heng.feng@canonical.com>
>     xhci: Ensure link state is U3 after setting USB_SS_PORT_LS_U3
>=20
> Hans de Goede <hdegoede@redhat.com>
>     ASoC: Intel: bytcr_rt5640: Add quirk for MPMAN MPWIN895CL tablet
>=20
> Jiri Olsa <jolsa@kernel.org>
>     perf/core: Disable page faults when getting phys address
>=20
> Florian Fainelli <f.fainelli@gmail.com>
>     pwm: bcm2835: Dynamically allocate base
>=20
> Geert Uytterhoeven <geert+renesas@glider.be>
>     pwm: renesas-tpu: Fix late Runtime PM enablement
>=20
> Nicholas Piggin <npiggin@gmail.com>
>     Revert "powerpc/64: irq_work avoid interrupt when called with hardwar=
e irqs
> enabled"
>=20
> Evan Green <evgreen@chromium.org>
>     loop: Better discard support for block devices
>=20
> Cornelia Huck <cohuck@redhat.com>
>     s390/cio: avoid duplicated 'ADD' uevents
>=20
> Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
>     kconfig: qconf: Fix a few alignment issues
>=20
> Vasily Averin <vvs@virtuozzo.com>
>     ipc/util.c: sysvipc_find_ipc() should increase position index
>=20
> Eric Biggers <ebiggers@google.com>
>     selftests: kmod: fix handling test numbers above 9
>=20
> Vasily Averin <vvs@virtuozzo.com>
>     kernel/gcov/fs.c: gcov_seq_next() should increase position index
>=20
> Sagi Grimberg <sagi@grimberg.me>
>     nvme: fix deadlock caused by ANA update wrong locking
>=20
> Hans de Goede <hdegoede@redhat.com>
>     ASoC: Intel: atom: Take the drv->lock mutex before calling
> sst_send_slot_map()
>=20
> Wu Bo <wubo40@huawei.com>
>     scsi: iscsi: Report unbind session event when the target has been rem=
oved
>=20
> Geert Uytterhoeven <geert+renesas@glider.be>
>     pwm: rcar: Fix late Runtime PM enablement
>=20
> Yan, Zheng <zyan@redhat.com>
>     ceph: don't skip updating wanted caps when cap is stale
>=20
> Qiujun Huang <hqjagain@gmail.com>
>     ceph: return ceph_mdsc_do_request() errors from __get_parent()
>=20
> James Smart <jsmart2021@gmail.com>
>     scsi: lpfc: Fix crash in target side cable pulls hitting WAIT_FOR_UNR=
EG
>=20
> James Smart <jsmart2021@gmail.com>
>     scsi: lpfc: Fix kasan slab-out-of-bounds error in lpfc_unreg_login
>=20
> Tero Kristo <t-kristo@ti.com>
>     watchdog: reset last_hw_keepalive time at start
>=20
> Catalin Marinas <catalin.marinas@arm.com>
>     arm64: Silence clang warning on mismatched value/register sizes
>=20
> James Morse <james.morse@arm.com>
>     arm64: compat: Workaround Neoverse-N1 #1542419 for compat user-space
>=20
> James Morse <james.morse@arm.com>
>     arm64: Fake the IminLine size on systems affected by Neoverse-N1 #154=
2419
>=20
> James Morse <james.morse@arm.com>
>     arm64: errata: Hide CTR_EL0.DIC on systems affected by Neoverse-N1
> #1542419
>=20
> Marc Zyngier <marc.zyngier@arm.com>
>     arm64: Add part number for Neoverse N1
>=20
> Jeremy Sowden <jeremy@azazel.net>
>     vti4: removed duplicate log message.
>=20
> Wei Yongjun <weiyongjun1@huawei.com>
>     crypto: mxs-dcp - make symbols 'sha1_null_hash' and 'sha256_null_hash=
'
> static
>=20
> Martin KaFai Lau <kafai@fb.com>
>     bpftool: Fix printing incorrect pointer in btf_dump_ptr
>=20
> Rob Clark <robdclark@chromium.org>
>     drm/msm: Use the correct dma_sync calls harder
>=20
> Dmitry Monakhov <dmonakhov@gmail.com>
>     ext4: fix extent_status fragmentation for plain files
>=20
>=20
> -------------
>=20
> Diffstat:
>=20
>  Documentation/arm64/silicon-errata.txt             |   1 +
>  Makefile                                           |   4 +-
>  arch/arm/mach-imx/Makefile                         |   2 +
>  arch/arm64/Kconfig                                 |  16 +++
>  arch/arm64/include/asm/cache.h                     |   3 +-
>  arch/arm64/include/asm/cpucaps.h                   |   3 +-
>  arch/arm64/include/asm/cputype.h                   |   2 +
>  arch/arm64/kernel/cpu_errata.c                     |  22 +++
>  arch/arm64/kernel/sys_compat.c                     |  11 ++
>  arch/arm64/kernel/traps.c                          |   9 ++
>  arch/powerpc/kernel/setup_64.c                     |   2 +
>  arch/powerpc/kernel/time.c                         |  44 ++----
>  arch/s390/kvm/kvm-s390.c                           |   3 +
>  arch/s390/lib/uaccess.c                            |   4 +
>  arch/s390/mm/pgalloc.c                             |  16 ++-
>  arch/x86/include/asm/kvm_host.h                    |   4 +-
>  arch/x86/kvm/vmx.c                                 |  27 ++--
>  arch/x86/kvm/x86.c                                 |  66 +++++----
>  drivers/block/loop.c                               |  42 ++++--
>  drivers/block/virtio_blk.c                         |   9 +-
>  drivers/char/tpm/tpm_ibmvtpm.c                     | 136 ++++++++++-----=
----
>  drivers/char/tpm/tpm_tis_core.c                    |   8 +-
>  drivers/crypto/mxs-dcp.c                           |   4 +-
>  drivers/gpu/drm/amd/display/dc/core/dc.c           |  23 ++++
>  drivers/gpu/drm/msm/msm_gem.c                      |   4 +-
>  drivers/iio/adc/stm32-adc.c                        |  31 ++++-
>  drivers/iio/adc/xilinx-xadc-core.c                 |  95 ++++++++++---
>  drivers/iio/common/st_sensors/st_sensors_core.c    |   2 +-
>  drivers/infiniband/core/addr.c                     |   7 +-
>  drivers/infiniband/sw/rxe/rxe_net.c                |   8 +-
>  drivers/net/dsa/b53/b53_common.c                   |  37 ++++-
>  drivers/net/dsa/b53/b53_regs.h                     |   8 +-
>  drivers/net/ethernet/broadcom/genet/bcmgenet.c     |   3 +
>  drivers/net/ethernet/chelsio/cxgb4/cudbg_lib.c     |  27 +++-
>  drivers/net/ethernet/chelsio/cxgb4/cxgb4_ptp.c     |  27 +---
>  drivers/net/ethernet/chelsio/cxgb4/t4_regs.h       |   3 +
>  drivers/net/ethernet/mellanox/mlx5/core/en_tc.c    |  11 +-
>  .../mellanox/mlxsw/core_acl_flex_actions.c         |   4 +-
>  .../ethernet/mellanox/mlxsw/spectrum2_acl_tcam.c   |   4 +-
>  drivers/net/ethernet/mellanox/mlxsw/spectrum_acl.c |   3 +-
>  .../net/ethernet/mellanox/mlxsw/spectrum_mr_tcam.c |   4 +-
>  .../net/ethernet/stmicro/stmmac/dwmac-meson8b.c    |   1 +
>  drivers/net/geneve.c                               |   4 +-
>  drivers/net/macsec.c                               |  12 +-
>  drivers/net/macvlan.c                              |   2 +-
>  drivers/net/team/team.c                            |   4 +
>  drivers/net/vrf.c                                  |  10 +-
>  drivers/net/vxlan.c                                |   8 +-
>  drivers/net/wireless/intel/iwlwifi/mvm/rx.c        |   9 ++
>  drivers/net/wireless/intel/iwlwifi/pcie/tx-gen2.c  |   3 +
>  drivers/nvme/host/multipath.c                      |   4 +-
>  drivers/pci/pcie/aspm.c                            |  18 ++-
>  drivers/pwm/pwm-bcm2835.c                          |   1 +
>  drivers/pwm/pwm-rcar.c                             |  10 +-
>  drivers/pwm/pwm-renesas-tpu.c                      |   9 +-
>  drivers/s390/cio/device.c                          |  13 +-
>  drivers/scsi/lpfc/lpfc_nvme.c                      |  14 +-
>  drivers/scsi/lpfc/lpfc_sli.c                       |   2 +
>  drivers/scsi/scsi_transport_iscsi.c                |   4 +-
>  drivers/scsi/smartpqi/smartpqi_sas_transport.c     |   2 +-
>  drivers/staging/comedi/comedi_fops.c               |   4 +-
>  drivers/staging/comedi/drivers/dt2815.c            |   3 +
>  drivers/staging/vt6656/int.c                       |   3 +-
>  drivers/staging/vt6656/key.c                       |  14 +-
>  drivers/staging/vt6656/main_usb.c                  |  31 +++--
>  drivers/tty/hvc/hvc_console.c                      |  23 ++--
>  drivers/tty/rocket.c                               |  25 ++--
>  drivers/tty/serial/sh-sci.c                        |  13 +-
>  drivers/tty/vt/vt.c                                |   7 +-
>  drivers/usb/class/cdc-acm.c                        |  36 ++++-
>  drivers/usb/class/cdc-acm.h                        |   5 +-
>  drivers/usb/core/hub.c                             |  14 ++
>  drivers/usb/core/message.c                         |   9 +-
>  drivers/usb/core/quirks.c                          |   4 +
>  drivers/usb/dwc3/gadget.c                          |  12 +-
>  drivers/usb/early/xhci-dbc.c                       |   8 +-
>  drivers/usb/early/xhci-dbc.h                       |  18 ++-
>  drivers/usb/gadget/function/f_fs.c                 |   4 +
>  drivers/usb/host/xhci-hub.c                        |  20 ++-
>  drivers/usb/misc/sisusbvga/sisusb.c                |  20 +--
>  drivers/usb/misc/sisusbvga/sisusb_init.h           |  14 +-
>  drivers/usb/storage/uas.c                          |  46 ++++++-
>  drivers/usb/storage/unusual_devs.h                 |   7 +
>  drivers/watchdog/watchdog_dev.c                    |   1 +
>  fs/ceph/caps.c                                     |   8 +-
>  fs/ceph/export.c                                   |   5 +
>  fs/ext4/extents.c                                  |  47 ++++---
>  fs/f2fs/xattr.c                                    |  15 ++-
>  fs/namespace.c                                     |   2 +-
>  fs/proc/vmcore.c                                   |   5 +-
>  fs/xfs/xfs_inode.c                                 |  85 ++++++------
>  include/linux/blkdev.h                             |   2 +-
>  include/linux/blktrace_api.h                       |  18 ++-
>  include/linux/iio/iio.h                            |   2 +-
>  include/linux/kvm_host.h                           |  35 ++++-
>  include/linux/kvm_types.h                          |   9 +-
>  include/linux/vmalloc.h                            |   2 +-
>  include/net/addrconf.h                             |   6 +-
>  include/net/ipv6.h                                 |   2 +-
>  include/net/tcp.h                                  |   2 +-
>  ipc/util.c                                         |   2 +-
>  kernel/audit.c                                     |   3 +
>  kernel/events/core.c                               |   9 +-
>  kernel/gcov/fs.c                                   |   2 +-
>  kernel/trace/blktrace.c                            | 117 +++++++++++----=
-
>  mm/hugetlb.c                                       |  14 +-
>  mm/ksm.c                                           |  12 +-
>  mm/vmalloc.c                                       |  16 ++-
>  net/dccp/ipv6.c                                    |   6 +-
>  net/ipv4/ip_vti.c                                  |   4 +-
>  net/ipv4/xfrm4_output.c                            |   2 -
>  net/ipv6/addrconf_core.c                           |  11 +-
>  net/ipv6/af_inet6.c                                |   4 +-
>  net/ipv6/datagram.c                                |   2 +-
>  net/ipv6/inet6_connection_sock.c                   |   4 +-
>  net/ipv6/ip6_output.c                              |   8 +-
>  net/ipv6/ipv6_sockglue.c                           |  13 +-
>  net/ipv6/raw.c                                     |   2 +-
>  net/ipv6/syncookies.c                              |   2 +-
>  net/ipv6/tcp_ipv6.c                                |   4 +-
>  net/ipv6/xfrm6_output.c                            |   2 -
>  net/l2tp/l2tp_ip6.c                                |   2 +-
>  net/mpls/af_mpls.c                                 |   7 +-
>  net/netrom/nr_route.c                              |   1 +
>  net/sched/sch_etf.c                                |   7 +-
>  net/sctp/ipv6.c                                    |   4 +-
>  net/tipc/udp_media.c                               |   9 +-
>  net/x25/x25_dev.c                                  |   4 +-
>  samples/vfio-mdev/mdpy.c                           |   2 +-
>  scripts/kconfig/qconf.cc                           |  13 +-
>  security/keys/internal.h                           |  12 ++
>  security/keys/keyctl.c                             |  58 +++++---
>  sound/pci/hda/hda_intel.c                          |   1 -
>  sound/pci/hda/patch_realtek.c                      |  11 +-
>  sound/soc/intel/atom/sst-atom-controls.c           |   2 +
>  sound/soc/intel/boards/bytcr_rt5640.c              |  11 ++
>  sound/soc/soc-dapm.c                               |  20 ++-
>  sound/usb/format.c                                 |  52 +++++++
>  sound/usb/mixer.c                                  |  37 ++++-
>  sound/usb/mixer.h                                  |  10 ++
>  sound/usb/mixer_maps.c                             |  37 ++++-
>  sound/usb/mixer_quirks.c                           |  12 +-
>  sound/usb/quirks-table.h                           |  14 ++
>  sound/usb/usx2y/usbusx2yaudio.c                    |   2 +
>  tools/bpf/bpftool/btf_dumper.c                     |   2 +-
>  tools/testing/selftests/ftrace/settings            |   1 +
>  tools/testing/selftests/kmod/kmod.sh               |  13 +-
>  tools/vm/Makefile                                  |   2 +
>  virt/kvm/kvm_main.c                                | 149 +++++++++++++++=
+++++-
>  149 files changed, 1591 insertions(+), 598 deletions(-)
>=20

