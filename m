Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3A8851B0E1D
	for <lists+stable@lfdr.de>; Mon, 20 Apr 2020 16:17:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728314AbgDTORH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Apr 2020 10:17:07 -0400
Received: from mail-eopbgr1410123.outbound.protection.outlook.com ([40.107.141.123]:3944
        "EHLO JPN01-OS2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1729043AbgDTORG (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 20 Apr 2020 10:17:06 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=LFsSc6coJRivItGVgO0fQUqsWam/KMBUnaRb7odI99EdDXAHE/NdQtZPsRNYkZJh+zh9evhEtLcTtVlY8degsOt5wlL6lQMN9N+TnnAnAM6kBeFSL8UFpiu2z6eHxaIBSJW8lGZ9bllTDc7gPX476W/ltS9lHXohez4LI98lnNS+1jBiHFT594xg2SHijkGU8A6D80DmkdHn93Dj3sMHiWE0/W80DHKVedZ1F4UmZRjifScARVMy9s+Amtayqa26Y2GFzrYWjIxC8L+iea5yOBSfHHGQXZiIy/g7qVqEyw3bnPgStYFlxkbw8UkaxmIO1HwqmTLZ3xcHwJaLDps1uA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=euCuqbyfBq0gEOg0iFYe3LtTw8SkUf4Pd2dG07T7Zy8=;
 b=Wm2k4C41wlucM52n0QzJJLbJI4fLbgVGEicRFODtg/DwvFMwoDuZcfPeHUGY8zNpZpOuBs4b2V5Lb2LmQ4rgNGQ6+mLXhAWjFmI+lZxo+05xuuHtY3H8CyCjbOJS28qR/Ot7YPZw8BR/JpjWqIM+Kp8CbZFTV/j1NAm0Di62JliwYO/9Ya4LmGjwsZNkDS0wzD85loUECzeFWKlV71oa+2a2BYJEGsR3XmxfyJkhJVwmQ3hHmLG0OfuN187VSAfw48eh6+s9Q3ZK3LEibhWiOxWxIZBHjd/T3V1xIR71AdwHf1elJqMaun0j1pmfP5MJSRP8BczFcM6E8bEol82FmA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=renesas.com; dmarc=pass action=none header.from=renesas.com;
 dkim=pass header.d=renesas.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=renesasgroup.onmicrosoft.com; s=selector2-renesasgroup-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=euCuqbyfBq0gEOg0iFYe3LtTw8SkUf4Pd2dG07T7Zy8=;
 b=Id0+YliDMBFym+EhMXMriZaioVCw5fVJTnO0lMm5GGdhEn9uvfZCvsbUUIHLPWRI8Pnk0g5P2ZMO4yUS15ZFZ8llfNe4ugHYDYuiXuqkN+XoOIgd4EqziZoyw1M3j+M5d5CaOJOgRFHry+9LfDXQE8xKKywPNqlt4AVykC5Jxc0=
Received: from TYAPR01MB2285.jpnprd01.prod.outlook.com (52.133.177.145) by
 TYAPR01MB2974.jpnprd01.prod.outlook.com (20.177.102.21) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2921.29; Mon, 20 Apr 2020 14:17:02 +0000
Received: from TYAPR01MB2285.jpnprd01.prod.outlook.com
 ([fe80::3801:2fbc:7bd3:fc24]) by TYAPR01MB2285.jpnprd01.prod.outlook.com
 ([fe80::3801:2fbc:7bd3:fc24%6]) with mapi id 15.20.2921.027; Mon, 20 Apr 2020
 14:17:02 +0000
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
Subject: RE: [PATCH 4.19 00/40] 4.19.117-rc1 review
Thread-Topic: [PATCH 4.19 00/40] 4.19.117-rc1 review
Thread-Index: AQHWFxJmifFZWqjWskKyPlNFl9HWgaiCDVsA
Date:   Mon, 20 Apr 2020 14:17:02 +0000
Message-ID: <TYAPR01MB22857D9B69F610097596174FB7D40@TYAPR01MB2285.jpnprd01.prod.outlook.com>
References: <20200420121444.178150063@linuxfoundation.org>
In-Reply-To: <20200420121444.178150063@linuxfoundation.org>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=Chris.Paterson2@renesas.com; 
x-originating-ip: [193.141.220.21]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 6f6c5c17-ad6c-455e-e0e6-08d7e5357ef7
x-ms-traffictypediagnostic: TYAPR01MB2974:
x-microsoft-antispam-prvs: <TYAPR01MB2974B8ED4D837C97341EC2C5B7D40@TYAPR01MB2974.jpnprd01.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:2887;
x-forefront-prvs: 03793408BA
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:TYAPR01MB2285.jpnprd01.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(10019020)(4636009)(39860400002)(346002)(396003)(376002)(366004)(136003)(7416002)(8676002)(4326008)(110136005)(316002)(54906003)(9686003)(2906002)(5660300002)(186003)(7696005)(6506007)(66946007)(86362001)(71200400001)(8936002)(81156014)(966005)(76116006)(26005)(478600001)(33656002)(52536014)(55016002)(66556008)(66476007)(64756008)(66446008);DIR:OUT;SFP:1102;
received-spf: None (protection.outlook.com: renesas.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: /zhYvN2Pu9Q1nthTfTTr+jku51gUFVfnrsDhmkx/Kt3ewKUJGv2/VMyBxBXlNVpS92mSZnnXBCfNI9zOf/p+h4vWiTyA4G/1R2LEHCWm6N58Tm2yfsZ9ZOcjeIw+7rclSeW83hz/jMzzkmDK4fureJVd/4hcfefZve2vdYBP0ExvdLLiBn+GqVR6cZjE3FbKJj8dQcltoOqdvReslYiD4KRR7s9heMNzet89+AdftINtSviH87dLSvttLdgVTGzA2ISAqoizWsxy+mGlCcLCCwlmCCGJZAzyiEHb+27Isq3Ipq8r3tFbqAiDiNxjp89YQI4zwQldaF3oeaH8TLBbEWjwJtekEPT9A8SJPLQG+Di33RNUx5LSxWU7jwjxml0rnCKkI6XPkj2FhO+DKoDcujXlPcwRHLptP64DQ7MMf8aXH+VvNu5vJsogoeymqSLafrmdTArQYEqXchbNErNiDqix0SjPyKb39JoM8AXs6obKtseGQRBCEh+GlRULRCIS2hw2BI3gjF6w9OtE5tuY3w==
x-ms-exchange-antispam-messagedata: D8Sjto3uFMnRyMjcI5aiTbsYY8y6egWFq/9FL7B2xH3qw12TknjoNdTt71gzxqGFj16IcO08pjqDyalDa/0IYRfpjQn27vEw+jc2Vkp3X/GCOo2VaevuNivo+sPVpUX/6ABcSN60mR+sNDvcbKIHhg==
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="Windows-1252"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: renesas.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6f6c5c17-ad6c-455e-e0e6-08d7e5357ef7
X-MS-Exchange-CrossTenant-originalarrivaltime: 20 Apr 2020 14:17:02.1116
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 53d82571-da19-47e4-9cb4-625a166a4a2a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: THFgXSt0ozzlN/TxuigaIdW2fLmY8tjmdNiSICzgYjHgcjnczEfCV2al4aX6JB+j9kOxjOugn0KcRrCyaOCsjxcp9rtT/XYxkt1Cbn9byY0=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: TYAPR01MB2974
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hello Greg,

> From: stable-owner@vger.kernel.org <stable-owner@vger.kernel.org> On
> Behalf Of Greg Kroah-Hartman
> Sent: 20 April 2020 13:39
>=20
> This is the start of the stable review cycle for the 4.19.117 release.
> There are 40 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

No build/boot issues seen for CIP configs for Linux 4.19.117-rc1 (df86600ce=
713).

Build/test pipeline/logs: https://gitlab.com/cip-project/cip-testing/linux-=
stable-rc-ci/pipelines/137867597
GitLab CI pipeline: https://gitlab.com/cip-project/cip-testing/linux-cip-pi=
pelines/-/blob/master/trees/linux-4.19.y.yml
Relevant LAVA jobs: https://lava.ciplatform.org/scheduler/alljobs?length=3D=
25&search=3Ddf86600ce#table

Kind regards, Chris

>=20
> Responses should be made by Wed, 22 Apr 2020 12:10:36 +0000.
> Anything received after that time might be too late.
>=20
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-
> 4.19.117-rc1.gz
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
>     Linux 4.19.117-rc1
>=20
> Austin Kim <austindh.kim@gmail.com>
>     mm/vmalloc.c: move 'area->pages' after if statement
>=20
> Karthick Gopalasubramanian <kargop@codeaurora.org>
>     wil6210: remove reset file from debugfs
>=20
> Dedy Lansky <dlansky@codeaurora.org>
>     wil6210: make sure Rx ring sizes are correlated
>=20
> Alexei Avshalom Lazar <ailizaro@codeaurora.org>
>     wil6210: add general initialization/size checks
>=20
> Maya Erez <merez@codeaurora.org>
>     wil6210: ignore HALP ICR if already handled
>=20
> Dedy Lansky <dlansky@codeaurora.org>
>     wil6210: check rx_buff_mgmt before accessing it
>=20
> Reinette Chatre <reinette.chatre@intel.com>
>     x86/resctrl: Fix invalid attempt at removing the default resource gro=
up
>=20
> James Morse <james.morse@arm.com>
>     x86/resctrl: Preserve CDP enable over CPU hotplug
>=20
> John Allen <john.allen@amd.com>
>     x86/microcode/AMD: Increase microcode PATCH_MAX_SIZE
>=20
> Maurizio Lombardi <mlombard@redhat.com>
>     scsi: target: fix hang when multiple threads try to destroy the same =
iscsi
> session
>=20
> Maurizio Lombardi <mlombard@redhat.com>
>     scsi: target: remove boilerplate code
>=20
> Jim Mattson <jmattson@google.com>
>     kvm: x86: Host feature SSBD doesn't imply guest feature SPEC_CTRL_SSB=
D
>=20
> Jan Kara <jack@suse.cz>
>     ext4: do not zeroout extents beyond i_disksize
>=20
> Sergei Lopatin <magist3r@gmail.com>
>     drm/amd/powerplay: force the trim of the mclk dpm_levels if OD is ena=
bled
>=20
> Thinh Nguyen <Thinh.Nguyen@synopsys.com>
>     usb: dwc3: gadget: Don't clear flags before transfer ended
>=20
> Sasha Levin <sashal@kernel.org>
>     usb: dwc3: gadget: don't enable interrupt when disabling endpoint
>=20
> Tuomas Tynkkynen <tuomas.tynkkynen@iki.fi>
>     mac80211_hwsim: Use kstrndup() in place of kasprintf()
>=20
> Josef Bacik <josef@toxicpanda.com>
>     btrfs: check commit root generation in should_ignore_root
>=20
> Xiao Yang <yangx.jy@cn.fujitsu.com>
>     tracing: Fix the race between registering 'snapshot' event trigger an=
d
> triggering 'snapshot' operation
>=20
> Vasily Averin <vvs@virtuozzo.com>
>     keys: Fix proc_keys_next to increase position index
>=20
> Takashi Iwai <tiwai@suse.de>
>     ALSA: usb-audio: Check mapping at creating connector controls, too
>=20
> Takashi Iwai <tiwai@suse.de>
>     ALSA: usb-audio: Don't create jack controls for PCM terminals
>=20
> Takashi Iwai <tiwai@suse.de>
>     ALSA: usb-audio: Don't override ignore_ctl_error value from the map
>=20
> Takashi Iwai <tiwai@suse.de>
>     ALSA: usb-audio: Filter error from connector kctl ops, too
>=20
> Colin Ian King <colin.king@canonical.com>
>     ASoC: Intel: mrfld: return error codes when an error occurs
>=20
> Colin Ian King <colin.king@canonical.com>
>     ASoC: Intel: mrfld: fix incorrect check on p->sink
>=20
> Josh Triplett <josh@joshtriplett.org>
>     ext4: fix incorrect inodes per group in error message
>=20
> Josh Triplett <josh@joshtriplett.org>
>     ext4: fix incorrect group count in ext4_fill_super error message
>=20
> Sven Van Asbroeck <TheSven73@gmail.com>
>     pwm: pca9685: Fix PWM/GPIO inter-operation
>=20
> zhangyi (F) <yi.zhang@huawei.com>
>     jbd2: improve comments about freeing data buffers whose page mapping =
is
> NULL
>=20
> Can Guo <cang@codeaurora.org>
>     scsi: ufs: Fix ufshcd_hold() caused scheduling while atomic
>=20
> Amir Goldstein <amir73il@gmail.com>
>     ovl: fix value of i_ino for lower hardlink corner case
>=20
> DENG Qingfang <dqfext@gmail.com>
>     net: dsa: mt7530: fix tagged frames pass-through in VLAN-unaware mode
>=20
> Florian Fainelli <f.fainelli@gmail.com>
>     net: stmmac: dwmac-sunxi: Provide TX and RX fifo sizes
>=20
> Konstantin Khlebnikov <khlebnikov@yandex-team.ru>
>     net: revert default NAPI poll timeout to 2 jiffies
>=20
> Wang Wenhu <wenhu.wang@vivo.com>
>     net: qrtr: send msgs from local of same id as broadcast
>=20
> Tim Stallard <code@timstallard.me.uk>
>     net: ipv6: do not consider routes via gateways for anycast address ch=
eck
>=20
> Taras Chornyi <taras.chornyi@plvision.eu>
>     net: ipv4: devinet: Fix crash when add/del multicast IP with autojoin
>=20
> Taehee Yoo <ap420073@gmail.com>
>     hsr: check protocol version in hsr_newlink()
>=20
> Sebastian Andrzej Siewior <bigeasy@linutronix.de>
>     amd-xgbe: Use __napi_schedule() in BH context
>=20
>=20
> -------------
>=20
> Diffstat:
>=20
>  Makefile                                          |  4 +-
>  arch/x86/include/asm/microcode_amd.h              |  2 +-
>  arch/x86/kernel/cpu/intel_rdt.c                   |  2 +
>  arch/x86/kernel/cpu/intel_rdt.h                   |  1 +
>  arch/x86/kernel/cpu/intel_rdt_rdtgroup.c          | 16 ++++-
>  arch/x86/kvm/cpuid.c                              |  3 +-
>  drivers/gpu/drm/amd/powerplay/hwmgr/smu7_hwmgr.c  |  5 +-
>  drivers/net/dsa/mt7530.c                          | 18 +++--
>  drivers/net/dsa/mt7530.h                          |  7 ++
>  drivers/net/ethernet/amd/xgbe/xgbe-drv.c          |  2 +-
>  drivers/net/ethernet/stmicro/stmmac/dwmac-sunxi.c |  2 +
>  drivers/net/wireless/ath/wil6210/debugfs.c        | 29 +-------
>  drivers/net/wireless/ath/wil6210/interrupt.c      | 12 ++--
>  drivers/net/wireless/ath/wil6210/main.c           |  5 +-
>  drivers/net/wireless/ath/wil6210/txrx.c           |  4 +-
>  drivers/net/wireless/ath/wil6210/txrx_edma.c      | 14 +++-
>  drivers/net/wireless/ath/wil6210/wil6210.h        |  3 +-
>  drivers/net/wireless/ath/wil6210/wmi.c            |  2 +-
>  drivers/net/wireless/mac80211_hwsim.c             | 12 ++--
>  drivers/pwm/pwm-pca9685.c                         | 85 +++++++++++++----=
------
>  drivers/scsi/ufs/ufshcd.c                         |  5 ++
>  drivers/target/iscsi/iscsi_target.c               | 79 ++++++-----------=
----
>  drivers/target/iscsi/iscsi_target.h               |  1 -
>  drivers/target/iscsi/iscsi_target_configfs.c      |  5 +-
>  drivers/target/iscsi/iscsi_target_login.c         |  5 +-
>  drivers/usb/dwc3/gadget.c                         | 18 ++---
>  fs/btrfs/relocation.c                             |  4 +-
>  fs/ext4/extents.c                                 |  8 +--
>  fs/ext4/super.c                                   |  6 +-
>  fs/jbd2/commit.c                                  |  7 +-
>  fs/overlayfs/inode.c                              |  4 +-
>  include/net/ip6_route.h                           |  1 +
>  include/target/iscsi/iscsi_target_core.h          |  2 +-
>  kernel/trace/trace_events_trigger.c               | 10 +--
>  mm/vmalloc.c                                      |  8 ++-
>  net/core/dev.c                                    |  3 +-
>  net/hsr/hsr_netlink.c                             | 10 ++-
>  net/ipv4/devinet.c                                | 13 ++--
>  net/qrtr/qrtr.c                                   |  7 +-
>  security/keys/proc.c                              |  2 +
>  sound/soc/intel/atom/sst-atom-controls.c          |  2 +-
>  sound/soc/intel/atom/sst/sst_pci.c                |  2 +-
>  sound/usb/mixer.c                                 | 31 +++++----
>  sound/usb/mixer_maps.c                            |  4 +-
>  44 files changed, 252 insertions(+), 213 deletions(-)
>=20

