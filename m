Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 65BAB15C8FB
	for <lists+stable@lfdr.de>; Thu, 13 Feb 2020 17:57:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728130AbgBMQ5i (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 13 Feb 2020 11:57:38 -0500
Received: from mail-os2jpn01hn2035.outbound.protection.outlook.com ([52.103.203.35]:53613
        "EHLO JPN01-OS2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727873AbgBMQ5i (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 13 Feb 2020 11:57:38 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=YBPBq+jSfGHNKQ+0aWoAo2O3M+dAN/ioW0Ak7Ll+fLno/MBHVst+Eh1uQ0GLpbcQyWqQk4LO6Bdd1xZzi3x8Ds4sWgBufsmtLjtoXTdeTFmKY/YfUkOXriXJyrWkDxD8b0oXN+tAfxfQkNk2D84ENRR+BQT5hr58zzzOMiU7R3Yq5C24DkxCNH41fjxrCQl7sJTeTtmrokTFoxn6uk5zkwSCBllbmKR5/AqX6IWtp6nOxb5WwdNZQEGDbBNVegEcXbp2CCEnbjpQGQQmYLZFQNJZ5vX7dKnQcrpzgBC+41weRU5GgbOyq+1KQUkvvzJSLcJYJ8uBBxN0Ryn8piXPaw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=TvYbBL1SuRN78l7GjFgi6lZ/IIbjrQd35B2QlmKxvOA=;
 b=Bx0nFbO12KiEQebuF+nBm/SYO/sljKhVVs+bDBXKqkhCVmZrzRuuagN0JfdgiAApMM89l+8Rh38YICfrER32OMIJIoRJApx8RYEMkgx/qrUzH4zCxi+GqGQ9CRevIRyKEEO07LsACycYwWGf3tJWCBou3IgkibGHtvvaAlpfJIE7/LB4tRk+GTAfPbt7/LPZwogoGt7ZQiinY6CzSUwZOFY7VUGEmL1pneuob5NyLZQD727471V1pnQIhNUJxp44d+k23zdmwyLOsrr2EkLEfOy7vu2vGRwjlPEh0UVPomuOID1NMBmwVwhT4DmnbsCRkmf+l+Mr/ftOaQ7ekuP6RQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=renesas.com; dmarc=pass action=none header.from=renesas.com;
 dkim=pass header.d=renesas.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=renesasgroup.onmicrosoft.com; s=selector2-renesasgroup-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=TvYbBL1SuRN78l7GjFgi6lZ/IIbjrQd35B2QlmKxvOA=;
 b=jhY0W9eKR4lBcyb2hcWsEH/xSeA3roILCQxkm/gp+1fwMa3w0j+ris5nok6V/m7pVTOTAG1nUMpJ+DfSAl8rpiuJEjgpTyTXULoCKFRSzp4C02dxBG9VGaw6tiYuD7Uu+j81n8rYt+od5FDYMZ3GUwDSTth3xCRAc5+TFdUM6bo=
Received: from TYAPR01MB2285.jpnprd01.prod.outlook.com (52.133.177.145) by
 TYAPR01MB2976.jpnprd01.prod.outlook.com (20.177.103.17) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2729.23; Thu, 13 Feb 2020 16:57:33 +0000
Received: from TYAPR01MB2285.jpnprd01.prod.outlook.com
 ([fe80::1045:4879:77ed:8a70]) by TYAPR01MB2285.jpnprd01.prod.outlook.com
 ([fe80::1045:4879:77ed:8a70%7]) with mapi id 15.20.2729.021; Thu, 13 Feb 2020
 16:57:33 +0000
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
Subject: RE: [PATCH 4.4 00/91] 4.4.214-stable review
Thread-Topic: [PATCH 4.4 00/91] 4.4.214-stable review
Thread-Index: AQHV4ogwZzs8g2+mlUuAafuGYpXfQagZVzBw
Date:   Thu, 13 Feb 2020 16:57:32 +0000
Message-ID: <TYAPR01MB2285DD1197799842E72C26B1B71A0@TYAPR01MB2285.jpnprd01.prod.outlook.com>
References: <20200213151821.384445454@linuxfoundation.org>
In-Reply-To: <20200213151821.384445454@linuxfoundation.org>
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
x-ms-office365-filtering-correlation-id: d1764c8a-e0b9-46c3-f32e-08d7b0a5d1ae
x-ms-traffictypediagnostic: TYAPR01MB2976:
x-microsoft-antispam-prvs: <TYAPR01MB2976A3FA6139C204E1AE2F4BB71A0@TYAPR01MB2976.jpnprd01.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8882;
x-forefront-prvs: 031257FE13
x-forefront-antispam-report: SFV:SPM;SFS:(10001);DIR:OUT;SFP:1501;SCL:5;SRVR:TYAPR01MB2976;H:TYAPR01MB2285.jpnprd01.prod.outlook.com;FPR:;SPF:None;LANG:en;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: =?Windows-1252?Q?J/x28Omf66uj/q2jZ8n60cfWZPl/AiPc/j35SubNdNDL8P7KmCfaYrC5?=
 =?Windows-1252?Q?cOlGvithE1mydjAsmRlBRTa6434fRY7KiwLsnTCqCt697N1yuf2wcwae?=
 =?Windows-1252?Q?9jZmcCufjmnpmL8MPxQfgOiZk7+YdDAxEX5EWdH3sQ2D8Hb9GnW62ueT?=
 =?Windows-1252?Q?XAIr9WMvctx+ySfYmOQQVWrWAjdOWoLsHAx24wqO9sLrBvoJ1mYaeN3u?=
 =?Windows-1252?Q?MyQr4nuM9/Z7s25Ev3VP5I7lJEtise28Y3Kr0oa2KJz3JCO8F2soaS0t?=
 =?Windows-1252?Q?eEQ1nG3Q9cR+XW9kVKrUlrssUpglZPvGdZDPRbbN8OfDisfvsXaVOAMo?=
 =?Windows-1252?Q?IKOZl+r78HuqjyLYcFzxL5zrIgup3Dk9+Cl9SgJ5R8PdLcE/OAP0Qu3V?=
 =?Windows-1252?Q?N3nbzN90VSdmTFLUUYNFgSvFckzEZQNQjUkAxfi9ZsCU9OLDsw4YzCUB?=
 =?Windows-1252?Q?D4BxsOr+iO3Y2OiEJg4ZeMGSD9KE1azoWCHHadrU7SDkJZsYSFCb4ex2?=
 =?Windows-1252?Q?zVJ90/cVScMfomg1RpKXZSI6xoIrkUKm26ktDw5B1DVFDZCWweVv8KV7?=
 =?Windows-1252?Q?HMSdVWVEh7lL7N1aYtXDwyyKTKbjG9RXoG2aCwKI14OdrnWw6LGuyf6s?=
 =?Windows-1252?Q?WY8t1GA24JasDc0MRqp1E9pkOX3z4Be4T+SbcX/W5HGd8FeyU35/RbXU?=
 =?Windows-1252?Q?e3/ftmN66RbsuNpWSOEhKPyiGSlMrQucCIVbSNP1+lhcbA1eYJeEiPce?=
 =?Windows-1252?Q?GR7kwWZdqZW6ZhJZjAEgwZC93fMB5GUCyjKYl9jFHfiTe5isnkLo3GUF?=
 =?Windows-1252?Q?9NPRBk0riOEwah/Y3MeqVUL2jxSYVXyL2+q2nYF5Z85xzvhCiBOcMH7I?=
 =?Windows-1252?Q?Uck4Ah80t1M4P6O5ELU2iAV/zc70YYtOdSDOlWa8FSxvRrUm6pWguo9H?=
 =?Windows-1252?Q?8kNpqKSJ1Bx565DiqTXSlHEV6q8i/OEdUcVt2WcIJ5hMI1CA2UXSlxdh?=
 =?Windows-1252?Q?9OnGLucT9oIvDm1rQP8RZrCfbguByNGJqNEX/8S3f4qBw/1gYuM=3D?=
x-ms-exchange-antispam-messagedata: +Bqdrwn1HrXrP440HTRCb5vxdDfOj/kjDZnvwudxD73LrlLPu1mtBZId84P82Q/IUCxR3YSkDb3Iz9AF9sLwWrfWmfqL5W0Po4zaAcxYRMw1XitKRuV5jk9jAwLHRPKLzOiIECp/UObCw3e2ozVWeA==
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="Windows-1252"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: renesas.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d1764c8a-e0b9-46c3-f32e-08d7b0a5d1ae
X-MS-Exchange-CrossTenant-originalarrivaltime: 13 Feb 2020 16:57:32.8301
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 53d82571-da19-47e4-9cb4-625a166a4a2a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: jkWQR4TJHD2YSqEzt96Bv/V9sCBY4NasJMtU9Ob7Ji889kV+XJlpjbbWINzuW8B+kuJR9BFnmxl3bedo23LbOexC12T2ZGsUNG1yC1TKeg4=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: TYAPR01MB2976
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Greg,

> From: stable-owner@vger.kernel.org <stable-owner@vger.kernel.org> On
> Behalf Of Greg Kroah-Hartman
> Sent: 13 February 2020 15:19
>=20
> This is the start of the stable review cycle for the 4.4.214 release.
> There are 91 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

No issues seen for CIP configs.

Build logs: https://gitlab.com/cip-project/cip-testing/linux-stable-rc-ci/p=
ipelines/117668767
Pipeline: https://gitlab.com/cip-project/cip-testing/linux-cip-pipelines/-/=
blob/ba32334b/trees/linux-4.4.y.yml

Kind regards, Chris

>=20
> Responses should be made by Sat, 15 Feb 2020 15:16:40 +0000.
> Anything received after that time might be too late.
>=20
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v4.x/stable-
> review/patch-4.4.214-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-
> rc.git linux-4.4.y
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
>     Linux 4.4.214-rc1
>=20
> Mike Snitzer <snitzer@redhat.com>
>     dm: fix potential for q->make_request_fn NULL pointer
>=20
> Nicolai Stange <nstange@suse.de>
>     libertas: make lbs_ibss_join_existing() return error code on rates ov=
erflow
>=20
> Nicolai Stange <nstange@suse.de>
>     libertas: don't exit from lbs_ibss_join_existing() with RCU read lock=
 held
>=20
> Qing Xu <m1s5p6688@gmail.com>
>     mwifiex: Fix possible buffer overflows in mwifiex_cmd_append_vsie_tlv=
()
>=20
> Qing Xu <m1s5p6688@gmail.com>
>     mwifiex: Fix possible buffer overflows in mwifiex_ret_wmm_get_status(=
)
>=20
> Geert Uytterhoeven <geert+renesas@glider.be>
>     pinctrl: sh-pfc: r8a7778: Fix duplicate SDSELF_B and SD1_CLK_B
>=20
> Alexey Kardashevskiy <aik@ozlabs.ru>
>     powerpc/pseries: Allow not having ibm, hypertas-functions::hcall-mult=
i-tce
> for DDW
>=20
> Alexandre Belloni <alexandre.belloni@bootlin.com>
>     ARM: dts: at91: sama5d3: define clock rate range for tcb1
>=20
> Alexandre Belloni <alexandre.belloni@bootlin.com>
>     ARM: dts: at91: sama5d3: fix maximum peripheral clock rates
>=20
> Jose Abreu <Jose.Abreu@synopsys.com>
>     ARC: [plat-axs10x]: Add missing multicast filter number to GMAC node
>=20
> Paul Kocialkowski <paul.kocialkowski@bootlin.com>
>     rtc: hym8563: Return -EINVAL if the time is known to be invalid
>=20
> Bean Huo <beanhuo@micron.com>
>     scsi: ufs: Fix ufshcd_probe_hba() reture value in case
> ufshcd_scsi_add_wlus() fails
>=20
> Ranjani Sridharan <ranjani.sridharan@linux.intel.com>
>     ASoC: pcm: update FE/BE trigger order based on the command
>=20
> Song Liu <songliubraving@fb.com>
>     perf/core: Fix mlock accounting in perf_mmap()
>=20
> Konstantin Khlebnikov <khlebnikov@yandex-team.ru>
>     clocksource: Prevent double add_timer_on() for watchdog_timer
>=20
> Ronnie Sahlberg <lsahlber@redhat.com>
>     cifs: fail i/o on soft mounts if sessionsetup errors out
>=20
> Miaohe Lin <linmiaohe@huawei.com>
>     KVM: nVMX: vmread should not set rflags to specify success in case of=
 #PF
>=20
> Sean Christopherson <sean.j.christopherson@intel.com>
>     KVM: VMX: Add non-canonical check on writes to RTIT address MSRs
>=20
> Sean Christopherson <sean.j.christopherson@intel.com>
>     KVM: x86/mmu: Apply max PA check for MMIO sptes to 32-bit KVM
>=20
> Josef Bacik <josef@toxicpanda.com>
>     btrfs: flush write bio if we loop in extent_write_cache_pages
>=20
> Marios Pomonis <pomonis@google.com>
>     KVM: x86: Protect kvm_lapic_reg_write() from Spectre-v1/L1TF attacks
>=20
> Marios Pomonis <pomonis@google.com>
>     KVM: x86: Protect pmu_intel.c from Spectre-v1/L1TF attacks
>=20
> Marios Pomonis <pomonis@google.com>
>     KVM: x86: Refactor picdev_write() to prevent Spectre-v1/L1TF attacks
>=20
> David Hildenbrand <david@redhat.com>
>     KVM: x86: drop picdev_in_range()
>=20
> Wayne Lin <Wayne.Lin@amd.com>
>     drm/dp_mst: Remove VCPI while disabling topology mgr
>=20
> Claudiu Beznea <claudiu.beznea@microchip.com>
>     drm: atmel-hlcdc: enable clock before configuring timing engine
>=20
> Filipe Manana <fdmanana@suse.com>
>     Btrfs: fix race between adding and putting tree mod seq elements and
> nodes
>=20
> David Sterba <dsterba@suse.com>
>     btrfs: remove trivial locking wrappers of tree mod log
>=20
> Filipe Manana <fdmanana@suse.com>
>     Btrfs: fix assertion failure on fsync with NO_HOLES enabled
>=20
> Trond Myklebust <trondmy@gmail.com>
>     NFS: Directory page cache pages need to be locked when read
>=20
> Thomas Meyer <thomas@m3y3r.de>
>     NFS: Fix bool initialization/comparison
>=20
> Trond Myklebust <trondmy@gmail.com>
>     NFS: Fix memory leaks and corruption in readdir
>=20
> Eric Dumazet <edumazet@google.com>
>     bonding/alb: properly access headers in bond_alb_xmit()
>=20
> Florian Fainelli <f.fainelli@gmail.com>
>     net: systemport: Avoid RBUF stuck in Wake-on-LAN mode
>=20
> Andreas Kemnade <andreas@kemnade.info>
>     mfd: rn5t618: Mark ADC control register volatile
>=20
> Marco Felsch <m.felsch@pengutronix.de>
>     mfd: da9062: Fix watchdog compatible string
>=20
> Nathan Chancellor <natechancellor@gmail.com>
>     net: tulip: Adjust indentation in {dmfe, uli526x}_init_module
>=20
> Nathan Chancellor <natechancellor@gmail.com>
>     net: smc911x: Adjust indentation in smc911x_phy_configure
>=20
> Nathan Chancellor <natechancellor@gmail.com>
>     ppp: Adjust indentation into ppp_async_input
>=20
> Nathan Chancellor <natechancellor@gmail.com>
>     NFC: pn544: Adjust indentation in pn544_hci_check_presence
>=20
> Nathan Chancellor <natechancellor@gmail.com>
>     powerpc/44x: Adjust indentation in ibm4xx_denali_fixup_memsize
>=20
> Nathan Chancellor <natechancellor@gmail.com>
>     ext2: Adjust indentation in ext2_fill_super
>=20
> Nathan Chancellor <natechancellor@gmail.com>
>     scsi: qla4xxx: Adjust indentation in qla4xxx_mem_free
>=20
> Nathan Chancellor <natechancellor@gmail.com>
>     scsi: csiostor: Adjust indentation in csio_device_reset
>=20
> Bart Van Assche <bvanassche@acm.org>
>     scsi: qla2xxx: Fix the endianness of the qla82xx_get_fw_size() return=
 type
>=20
> Sean Christopherson <sean.j.christopherson@intel.com>
>     KVM: x86: Free wbinvd_dirty_mask if vCPU creation fails
>=20
> Sean Christopherson <sean.j.christopherson@intel.com>
>     KVM: PPC: Book3S PR: Free shared page if mmu initialization fails
>=20
> Sean Christopherson <sean.j.christopherson@intel.com>
>     KVM: PPC: Book3S HV: Uninit vCPU if vcore creation fails
>=20
> Marios Pomonis <pomonis@google.com>
>     KVM: x86: Protect MSR-based index computations in
> fixed_msr_to_seg_unit() from Spectre-v1/L1TF attacks
>=20
> Marios Pomonis <pomonis@google.com>
>     KVM: x86: Protect x86_decode_insn from Spectre-v1/L1TF attacks
>=20
> Marios Pomonis <pomonis@google.com>
>     KVM: x86: Protect MSR-based index computations from Spectre-v1/L1TF
> attacks in x86.c
>=20
> Marios Pomonis <pomonis@google.com>
>     KVM: x86: Protect ioapic_read_indirect() from Spectre-v1/L1TF attacks
>=20
> Marios Pomonis <pomonis@google.com>
>     KVM: x86: Protect MSR-based index computations in pmu.h from Spectre-
> v1/L1TF attacks
>=20
> Marios Pomonis <pomonis@google.com>
>     KVM: x86: Protect ioapic_write_indirect() from Spectre-v1/L1TF attack=
s
>=20
> Marios Pomonis <pomonis@google.com>
>     KVM: x86: Protect kvm_hv_msr_[get|set]_crash_data() from Spectre-
> v1/L1TF attacks
>=20
> Marios Pomonis <pomonis@google.com>
>     KVM: x86: Protect DR-based index computations from Spectre-v1/L1TF
> attacks
>=20
> Marios Pomonis <pomonis@google.com>
>     KVM: x86: Refactor prefix decoding to prevent Spectre-v1/L1TF attacks
>=20
> Roberto Bergantinos Corpas <rbergant@redhat.com>
>     sunrpc: expiry_time should be seconds not timeval
>=20
> Brian Norris <briannorris@chromium.org>
>     mwifiex: fix unbalanced locking in mwifiex_process_country_ie()
>=20
> Stephen Warren <swarren@nvidia.com>
>     ARM: tegra: Enable PLLP bypass during Tegra124 LP1
>=20
> Josef Bacik <josef@toxicpanda.com>
>     btrfs: set trans->drity in btrfs_commit_transaction
>=20
> Chuhong Yuan <hslester96@gmail.com>
>     crypto: picoxcell - adjust the position of tasklet_init and fix misse=
d
> tasklet_kill
>=20
> Herbert Xu <herbert@gondor.apana.org.au>
>     crypto: api - Fix race condition in crypto_spawn_alg
>=20
> Herbert Xu <herbert@gondor.apana.org.au>
>     crypto: pcrypt - Do not clear MAY_SLEEP flag in original request
>=20
> Herbert Xu <herbert@gondor.apana.org.au>
>     padata: Remove broken queue flushing
>=20
> Joe Thornber <ejt@redhat.com>
>     dm space map common: fix to ensure new block isn't already in use
>=20
> Michael Ellerman <mpe@ellerman.id.au>
>     of: Add OF_DMA_DEFAULT_COHERENT & select it on powerpc
>=20
> Ioanna Alifieraki <ioanna-maria.alifieraki@canonical.com>
>     Revert "ovl: modify ovl_permission() to do checks on two inodes"
>=20
> Sven Van Asbroeck <thesven73@gmail.com>
>     power: supply: ltc2941-battery-gauge: fix use-after-free
>=20
> Quinn Tran <qutran@marvell.com>
>     scsi: qla2xxx: Fix mtcp dump collection failure
>=20
> Herbert Xu <herbert@gondor.apana.org.au>
>     crypto: api - Check spawn->alg under lock in crypto_drop_spawn
>=20
> Yurii Monakov <monakov.y@gmail.com>
>     PCI: keystone: Fix link training retries initiation
>=20
> Linus Walleij <linus.walleij@linaro.org>
>     mmc: spi: Toggle SPI polarity, do not hardcode it
>=20
> Pingfan Liu <kernelfans@gmail.com>
>     powerpc/pseries: Advance pfn if section is not present in
> lmb_is_removable()
>=20
> Gustavo A. R. Silva <gustavo@embeddedor.com>
>     lib/test_kasan.c: fix memory leak in kmalloc_oob_krealloc_more()
>=20
> Takashi Iwai <tiwai@suse.de>
>     ALSA: dummy: Fix PCM format loop in proc output
>=20
> Bryan O'Donoghue <bryan.odonoghue@linaro.org>
>     usb: gadget: f_ecm: Use atomic_t to track in-flight request
>=20
> Bryan O'Donoghue <bryan.odonoghue@linaro.org>
>     usb: gadget: f_ncm: Use atomic_t to track in-flight request
>=20
> Roger Quadros <rogerq@ti.com>
>     usb: gadget: legacy: set max_speed to super-speed
>=20
> Navid Emamdoost <navid.emamdoost@gmail.com>
>     brcmfmac: Fix memory leak in brcmf_usbdev_qinit
>=20
> Oliver Neukum <oneukum@suse.com>
>     mfd: dln2: More sanity checking for endpoints
>=20
> Will Deacon <will@kernel.org>
>     media: uvcvideo: Avoid cyclic entity chains due to malformed USB
> descriptors
>=20
> Eric Dumazet <edumazet@google.com>
>     tcp: clear tp->segs_{in|out} in tcp_disconnect()
>=20
> Eric Dumazet <edumazet@google.com>
>     tcp: clear tp->total_retrans in tcp_disconnect()
>=20
> Cong Wang <xiyou.wangcong@gmail.com>
>     net_sched: fix an OOB access in cls_tcindex
>=20
> Eric Dumazet <edumazet@google.com>
>     net: hsr: fix possible NULL deref in hsr_handle_frame()
>=20
> Eric Dumazet <edumazet@google.com>
>     cls_rsvp: fix rsvp_policy
>=20
> Nobuhiro Iwamatsu <nobuhiro1.iwamatsu@toshiba.co.jp>
>     ASoC: qcom: Fix of-node refcount unbalance to link->codec_of_node
>=20
> Arnd Bergmann <arnd@arndb.de>
>     sparc32: fix struct ipc64_perm type definition
>=20
> Pawan Gupta <pawan.kumar.gupta@linux.intel.com>
>     x86/cpu: Update cached HLE state on write to TSX_CTRL_CPUID_CLEAR
>=20
> Johan Hovold <johan@kernel.org>
>     media: iguanair: fix endpoint sanity check
>=20
>=20
> -------------
>=20
> Diffstat:
>=20
>  Makefile                                           |    4 +-
>  arch/arc/boot/dts/axs10x_mb.dtsi                   |    1 +
>  arch/arm/boot/dts/sama5d3.dtsi                     |   28 +-
>  arch/arm/boot/dts/sama5d3_can.dtsi                 |    4 +-
>  arch/arm/boot/dts/sama5d3_tcb1.dtsi                |    1 +
>  arch/arm/boot/dts/sama5d3_uart.dtsi                |    4 +-
>  arch/arm/mach-tegra/sleep-tegra30.S                |   11 +
>  arch/powerpc/Kconfig                               |    1 +
>  arch/powerpc/boot/4xx.c                            |    2 +-
>  arch/powerpc/kvm/book3s_hv.c                       |    4 +-
>  arch/powerpc/kvm/book3s_pr.c                       |    4 +-
>  arch/powerpc/platforms/pseries/hotplug-memory.c    |    4 +-
>  arch/powerpc/platforms/pseries/iommu.c             |   43 +-
>  arch/sparc/include/uapi/asm/ipcbuf.h               |   22 +-
>  arch/x86/kernel/cpu/tsx.c                          |   13 +-
>  arch/x86/kvm/emulate.c                             |   28 +-
>  arch/x86/kvm/hyperv.c                              |   11 +-
>  arch/x86/kvm/i8259.c                               |   41 +-
>  arch/x86/kvm/ioapic.c                              |   15 +-
>  arch/x86/kvm/lapic.c                               |   13 +-
>  arch/x86/kvm/mtrr.c                                |    9 +-
>  arch/x86/kvm/pmu.h                                 |   18 +-
>  arch/x86/kvm/pmu_intel.c                           |   24 +-
>  arch/x86/kvm/vmx.c                                 |    4 +-
>  arch/x86/kvm/vmx/vmx.c                             | 8033 ++++++++++++++=
++++++
>  arch/x86/kvm/x86.c                                 |   23 +-
>  crypto/algapi.c                                    |   22 +-
>  crypto/api.c                                       |    3 +-
>  crypto/internal.h                                  |    1 -
>  crypto/pcrypt.c                                    |    1 -
>  drivers/crypto/picoxcell_crypto.c                  |   15 +-
>  drivers/gpu/drm/atmel-hlcdc/atmel_hlcdc_crtc.c     |    8 +-
>  drivers/gpu/drm/drm_dp_mst_topology.c              |   12 +
>  drivers/md/dm.c                                    |    9 +-
>  drivers/md/persistent-data/dm-space-map-common.c   |   27 +
>  drivers/md/persistent-data/dm-space-map-common.h   |    2 +
>  drivers/md/persistent-data/dm-space-map-disk.c     |    6 +-
>  drivers/md/persistent-data/dm-space-map-metadata.c |    5 +-
>  drivers/media/rc/iguanair.c                        |    2 +-
>  drivers/media/usb/uvc/uvc_driver.c                 |   12 +
>  drivers/mfd/da9062-core.c                          |    2 +-
>  drivers/mfd/dln2.c                                 |   13 +-
>  drivers/mfd/rn5t618.c                              |    1 +
>  drivers/mmc/host/mmc_spi.c                         |   11 +-
>  drivers/net/bonding/bond_alb.c                     |   44 +-
>  drivers/net/ethernet/broadcom/bcmsysport.c         |    3 +
>  drivers/net/ethernet/dec/tulip/dmfe.c              |    7 +-
>  drivers/net/ethernet/dec/tulip/uli526x.c           |    4 +-
>  drivers/net/ethernet/smsc/smc911x.c                |    2 +-
>  drivers/net/ppp/ppp_async.c                        |   18 +-
>  drivers/net/wireless/brcm80211/brcmfmac/usb.c      |    1 +
>  drivers/net/wireless/libertas/cfg.c                |    2 +
>  drivers/net/wireless/mwifiex/scan.c                |    7 +
>  drivers/net/wireless/mwifiex/sta_ioctl.c           |    1 +
>  drivers/net/wireless/mwifiex/wmm.c                 |    4 +
>  drivers/nfc/pn544/pn544.c                          |    2 +-
>  drivers/of/Kconfig                                 |    4 +
>  drivers/of/address.c                               |    6 +-
>  drivers/pci/host/pci-keystone-dw.c                 |    2 +-
>  drivers/pinctrl/sh-pfc/pfc-r8a7778.c               |    4 +-
>  drivers/power/ltc2941-battery-gauge.c              |    2 +-
>  drivers/rtc/rtc-hym8563.c                          |    2 +-
>  drivers/scsi/csiostor/csio_scsi.c                  |    2 +-
>  drivers/scsi/qla2xxx/qla_mbx.c                     |    3 +-
>  drivers/scsi/qla2xxx/qla_nx.c                      |    8 +-
>  drivers/scsi/qla4xxx/ql4_os.c                      |    2 +-
>  drivers/scsi/ufs/ufshcd.c                          |    3 +-
>  drivers/usb/gadget/function/f_ecm.c                |   16 +-
>  drivers/usb/gadget/function/f_ncm.c                |   17 +-
>  drivers/usb/gadget/legacy/cdc2.c                   |    2 +-
>  drivers/usb/gadget/legacy/g_ffs.c                  |    2 +-
>  drivers/usb/gadget/legacy/multi.c                  |    2 +-
>  drivers/usb/gadget/legacy/ncm.c                    |    2 +-
>  fs/btrfs/ctree.c                                   |   64 +-
>  fs/btrfs/ctree.h                                   |    6 +-
>  fs/btrfs/delayed-ref.c                             |    8 +-
>  fs/btrfs/disk-io.c                                 |    1 -
>  fs/btrfs/extent_io.c                               |    8 +
>  fs/btrfs/tests/btrfs-tests.c                       |    1 -
>  fs/btrfs/transaction.c                             |    8 +
>  fs/btrfs/tree-log.c                                |    7 +-
>  fs/cifs/smb2pdu.c                                  |   10 +-
>  fs/ext2/super.c                                    |    6 +-
>  fs/nfs/callback_proc.c                             |    2 +-
>  fs/nfs/dir.c                                       |   59 +-
>  fs/nfs/nfs4client.c                                |    2 +-
>  fs/overlayfs/inode.c                               |   13 -
>  kernel/events/core.c                               |   10 +-
>  kernel/padata.c                                    |   46 +-
>  kernel/time/clocksource.c                          |   11 +-
>  lib/test_kasan.c                                   |    1 +
>  net/hsr/hsr_slave.c                                |    2 +
>  net/ipv4/tcp.c                                     |    3 +
>  net/sched/cls_rsvp.h                               |    6 +-
>  net/sched/cls_tcindex.c                            |   40 +-
>  net/sunrpc/auth_gss/svcauth_gss.c                  |    4 +
>  sound/drivers/dummy.c                              |    2 +-
>  sound/soc/qcom/apq8016_sbc.c                       |    3 +-
>  sound/soc/soc-pcm.c                                |   95 +-
>  99 files changed, 8713 insertions(+), 396 deletions(-)
>=20

