Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 08C1A172288
	for <lists+stable@lfdr.de>; Thu, 27 Feb 2020 16:52:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729577AbgB0Pvg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 27 Feb 2020 10:51:36 -0500
Received: from mail-eopbgr1410100.outbound.protection.outlook.com ([40.107.141.100]:18848
        "EHLO JPN01-OS2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1729110AbgB0Pvg (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 27 Feb 2020 10:51:36 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=AMm2WoRMSQwiD9msGHnDuQ/dSwo2C02dR1BrgwLkfPV5NEAFgg4gYR570UCWlEK1GkAeaNvVLSjYiNoKQJKkxKOQrz5m5Uq71FdGZblx8k4o3tW3chsOIax6p535MFlLEXXOffVVM1QxM212c8wGajgNmnqTYzUqFs0nRfguy43Pqc9rtNzF52C+Z2y3Ge9HWsrFwOLBLR9+Mz2+mJlahoAZlShnBkdcIRau6Wk+Bo0xSl/hYIsyK7eRPG3oGJxuIGZcDpn3HzeLMTnfOeiJj88PzIiQa80xBUcR+m/GpBkx32j8nEFJaXgeeFHtlfb2gnCtzbslTc25bWsIzpfjwg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=bDUfWjVZkFnqX94nAZfFGfv4VApB7OsTKSpbblYR1RE=;
 b=Yf9FhDDzHvjmdSWGit+PmRZY+JZXVsTN4jSy6AJY/fcaZEW6OsC5akYhQ05SQI3jTEu4ZbtUwJmuEc5csu0nr3jRcL4s2NwbyHWzHBxm6NXw9OqNii4lUw2/x2M7fTzhqUW2hiL9qAU7LuxqSAbB9IE4c5oQdRxyiH244CDD9ruDwaMlVNpTfbZizEAyiTq6jDZk881dMozjQIFkOYlfpQoDD1A3buF8k3+gnlKL0D4AvLe7Xy8hAZpHCXslYFLTibjXaBEXX8KPrxI+I0dRYhXdR7HcgBLSry0iM+y4N54G1RWnxXWbzb3PPUEc2dK3enEZAZV2272UybCVvT9sYQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=renesas.com; dmarc=pass action=none header.from=renesas.com;
 dkim=pass header.d=renesas.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=renesasgroup.onmicrosoft.com; s=selector2-renesasgroup-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=bDUfWjVZkFnqX94nAZfFGfv4VApB7OsTKSpbblYR1RE=;
 b=CPxG4Lic6XG6k49jwuQaG6Z0qMrOrIgAiPZ2+2/BkcoDz4n3Ic5Qdqn9xMUVUX9UolHGgVh08IDNe0DAksgCMpzZjKD3wW4Pdl5/Owc/uIlMX+k0k8tdjGk1hie3g2UN2nAT1cPonypzZ5AajiUq/TclbeKy4Qe5Q/RPoBNxS8w=
Received: from TYAPR01MB2285.jpnprd01.prod.outlook.com (52.133.177.145) by
 TYAPR01MB3231.jpnprd01.prod.outlook.com (20.177.104.149) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2772.15; Thu, 27 Feb 2020 15:51:30 +0000
Received: from TYAPR01MB2285.jpnprd01.prod.outlook.com
 ([fe80::1045:4879:77ed:8a70]) by TYAPR01MB2285.jpnprd01.prod.outlook.com
 ([fe80::1045:4879:77ed:8a70%7]) with mapi id 15.20.2772.012; Thu, 27 Feb 2020
 15:51:30 +0000
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
Subject: RE: [PATCH 4.19 00/97] 4.19.107-stable review
Thread-Topic: [PATCH 4.19 00/97] 4.19.107-stable review
Thread-Index: AQHV7XrbD0DHMbmBzkuVBaNW/cR3QKgvL80A
Date:   Thu, 27 Feb 2020 15:51:30 +0000
Message-ID: <TYAPR01MB22855734042EC30DAB547F58B7EB0@TYAPR01MB2285.jpnprd01.prod.outlook.com>
References: <20200227132214.553656188@linuxfoundation.org>
In-Reply-To: <20200227132214.553656188@linuxfoundation.org>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=Chris.Paterson2@renesas.com; 
x-originating-ip: [176.27.142.199]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 6215cf67-e979-4600-8352-08d7bb9ce9d7
x-ms-traffictypediagnostic: TYAPR01MB3231:
x-microsoft-antispam-prvs: <TYAPR01MB3231359F51DEC01BFFF0B463B7EB0@TYAPR01MB3231.jpnprd01.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:421;
x-forefront-prvs: 03264AEA72
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(4636009)(39860400002)(396003)(366004)(346002)(376002)(136003)(199004)(189003)(7416002)(5660300002)(2906002)(81166006)(4326008)(478600001)(81156014)(52536014)(8936002)(30864003)(55016002)(8676002)(9686003)(966005)(26005)(186003)(66946007)(66446008)(6506007)(54906003)(110136005)(316002)(33656002)(71200400001)(7696005)(64756008)(86362001)(76116006)(66556008)(66476007);DIR:OUT;SFP:1102;SCL:1;SRVR:TYAPR01MB3231;H:TYAPR01MB2285.jpnprd01.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: renesas.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: zux7KMH3PpucxUkYuqAHgQyBg2m63BLl8YUvPiQh+H/Hzg2ziGobVMAbwoM5+KwJ7DdJgYIx+ORp6tR2BRuP3D2vbK/nXAZSsEF2doNOxydCzjpylLcO+j7sIRwTrNRsbuCH/Ug+yZzQzrJGixbrHEp5KfDAbKs/1cQgEBw/ssJyUpWUlxUbWpFCxPedaPyM23fN87JFaTOWvUW5Z0nsHy80ImBm+/AdpAiOyIu2LzIQJda/+xp2VqTfhGtOltJ4C6hEEYeqUHPPpXMlKkPJEPfqlNU8+8Uv4zni59m3//sTqa0P9aXulcj2TABUnDEhlBbnNTLhF6BhQYsEOXnoiYGp0BIkTyIaNCQvabsa2ubNWNMkHqsl+VJOrEpwFiut+59khVo8T14yqHqk8y4sDTXw4HxgVCRS7F1Xru5LSmmh80etetgIOoyWAjaV5A5xGNeJHpDa7/4ufbm0hzyTCGlZn94nbo1bVMlzgnnM0TWaNRKuDnL9NWiD3zAJZ5Epo92PXI76cFpB4k0sGuqZJQ==
x-ms-exchange-antispam-messagedata: IRnr5mfJqqeAjsVjL9YmpWhbM50t9wPdnDvwXlpugJ+g9JALmZ6ZJptkd0P7CUJ2e5j+qH4AMejDoUsgl8pKt1ZtStebt8K0QEdn+804AYhq53eGZVBW4Rrv3f4W5AWMGgqY/mFFn0XGhuo5g29Pow==
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="Windows-1252"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: renesas.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6215cf67-e979-4600-8352-08d7bb9ce9d7
X-MS-Exchange-CrossTenant-originalarrivaltime: 27 Feb 2020 15:51:30.6873
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 53d82571-da19-47e4-9cb4-625a166a4a2a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: hjBKCtu0dr7xiLteQf1ljX5yQ7GeLhEwmznxN7g90mg+27DNOBaYDqJmiQCn6ov8VORmGGh753x35w5ZrYVlodSe/Waj8CjOGXsQcSN4CHw=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: TYAPR01MB3231
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hello Greg,

> From: stable-owner@vger.kernel.org <stable-owner@vger.kernel.org> On
> Behalf Of Greg Kroah-Hartman
> Sent: 27 February 2020 13:36
>=20
> This is the start of the stable review cycle for the 4.19.107 release.
> There are 97 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

No issues seen for CIP configs for Linux Linux 4.19.107-rc1 (6ed3dd5c1f76).

Build/test logs: https://gitlab.com/cip-project/cip-testing/linux-stable-rc=
-ci/pipelines/121568317
Pipeline: https://gitlab.com/cip-project/cip-testing/linux-cip-pipelines/-/=
blob/ba32334b/trees/linux-4.19.y.yml

Kind regards, Chris

>=20
> Responses should be made by Sat, 29 Feb 2020 13:21:24 +0000.
> Anything received after that time might be too late.
>=20
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v4.x/stable-
> review/patch-4.19.107-rc1.gz
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
>     Linux 4.19.107-rc1
>=20
> Nathan Chancellor <natechancellor@gmail.com>
>     s390/mm: Explicitly compare PAGE_DEFAULT_KEY against zero in
> storage_key_init_range
>=20
> Thomas Gleixner <tglx@linutronix.de>
>     xen: Enable interrupts when calling _cond_resched()
>=20
> Prabhakar Kushwaha <pkushwaha@marvell.com>
>     ata: ahci: Add shutdown to freeze hardware resources of ahci
>=20
> David Howells <dhowells@redhat.com>
>     rxrpc: Fix call RCU cleanup using non-bh-safe locks
>=20
> Cong Wang <xiyou.wangcong@gmail.com>
>     netfilter: xt_hashlimit: limit the max size of hashtable
>=20
> Takashi Iwai <tiwai@suse.de>
>     ALSA: seq: Fix concurrent access to queue current tick/time
>=20
> Takashi Iwai <tiwai@suse.de>
>     ALSA: seq: Avoid concurrent access to queue flags
>=20
> Takashi Iwai <tiwai@suse.de>
>     ALSA: rawmidi: Avoid bit fields for state flags
>=20
> Johannes Krude <johannes@krude.de>
>     bpf, offload: Replace bitwise AND by logical AND in
> bpf_prog_offload_info_fill
>=20
> Thomas Gleixner <tglx@linutronix.de>
>     genirq/proc: Reject invalid affinity masks (again)
>=20
> Joerg Roedel <jroedel@suse.de>
>     iommu/vt-d: Fix compile warning from intel-svm.h
>=20
> Aditya Pakki <pakki001@umn.edu>
>     ecryptfs: replace BUG_ON with error handling code
>=20
> Dan Carpenter <dan.carpenter@oracle.com>
>     staging: greybus: use after free in gb_audio_manager_remove_all()
>=20
> Colin Ian King <colin.king@canonical.com>
>     staging: rtl8723bs: fix copy of overlapping memory
>=20
> Minas Harutyunyan <Minas.Harutyunyan@synopsys.com>
>     usb: dwc2: Fix in ISOC request length checking
>=20
> Jack Pham <jackp@codeaurora.org>
>     usb: gadget: composite: Fix bMaxPower for SuperSpeedPlus
>=20
> Bart Van Assche <bvanassche@acm.org>
>     scsi: Revert "target: iscsi: Wait for all commands to finish before f=
reeing a
> session"
>=20
> Bart Van Assche <bvanassche@acm.org>
>     scsi: Revert "RDMA/isert: Fix a recently introduced regression relate=
d to
> logout"
>=20
> Greg Kroah-Hartman <gregkh@linuxfoundation.org>
>     Revert "dmaengine: imx-sdma: Fix memory leak"
>=20
> Filipe Manana <fdmanana@suse.com>
>     Btrfs: fix btrfs_wait_ordered_range() so that it waits for all ordere=
d
> extents
>=20
> Josef Bacik <josef@toxicpanda.com>
>     btrfs: do not check delayed items are empty for single transaction cl=
eanup
>=20
> Josef Bacik <josef@toxicpanda.com>
>     btrfs: reset fs_root to NULL on error in open_ctree
>=20
> Josef Bacik <josef@toxicpanda.com>
>     btrfs: fix bytes_may_use underflow in prealloc error condtition
>=20
> Miaohe Lin <linmiaohe@huawei.com>
>     KVM: apic: avoid calculating pending eoi from an uninitialized val
>=20
> Vitaly Kuznetsov <vkuznets@redhat.com>
>     KVM: nVMX: handle nested posted interrupts when apicv is disabled for=
 L1
>=20
> Oliver Upton <oupton@google.com>
>     KVM: nVMX: Check IO instruction VM-exit conditions
>=20
> Oliver Upton <oupton@google.com>
>     KVM: nVMX: Refactor IO bitmap checks into helper function
>=20
> Eric Biggers <ebiggers@google.com>
>     ext4: fix race between writepages and enabling EXT4_EXTENTS_FL
>=20
> Eric Biggers <ebiggers@google.com>
>     ext4: rename s_journal_flag_rwsem to s_writepages_rwsem
>=20
> Jan Kara <jack@suse.cz>
>     ext4: fix mount failure with quota configured as module
>=20
> Suraj Jitindar Singh <surajjs@amazon.com>
>     ext4: fix potential race between s_flex_groups online resizing and ac=
cess
>=20
> Suraj Jitindar Singh <surajjs@amazon.com>
>     ext4: fix potential race between s_group_info online resizing and acc=
ess
>=20
> Theodore Ts'o <tytso@mit.edu>
>     ext4: fix potential race between online resizing and write operations
>=20
> Shijie Luo <luoshijie1@huawei.com>
>     ext4: add cond_resched() to __ext4_find_entry()
>=20
> Qian Cai <cai@lca.pw>
>     ext4: fix a data race in EXT4_I(inode)->i_disksize
>=20
> Lyude Paul <lyude@redhat.com>
>     drm/nouveau/kms/gv100-: Re-set LUT after clearing for modesets
>=20
> Alexander Potapenko <glider@google.com>
>     lib/stackdepot.c: fix global out-of-bounds in stack_slabs
>=20
> Miles Chen <miles.chen@mediatek.com>
>     lib/stackdepot: Fix outdated comments
>=20
> satya priya <skakit@codeaurora.org>
>     tty: serial: qcom_geni_serial: Fix RX cancel command failure
>=20
> Ryan Case <ryandcase@chromium.org>
>     tty: serial: qcom_geni_serial: Remove xfer_mode variable
>=20
> Ryan Case <ryandcase@chromium.org>
>     tty: serial: qcom_geni_serial: Remove set_rfr_wm() and related variab=
les
>=20
> Ryan Case <ryandcase@chromium.org>
>     tty: serial: qcom_geni_serial: Remove use of *_relaxed() and mb()
>=20
> Ryan Case <ryandcase@chromium.org>
>     tty: serial: qcom_geni_serial: Remove interrupt storm
>=20
> Ryan Case <ryandcase@chromium.org>
>     tty: serial: qcom_geni_serial: Fix UART hang
>=20
> Miaohe Lin <linmiaohe@huawei.com>
>     KVM: x86: don't notify userspace IOAPIC on edge-triggered interrupt E=
OI
>=20
> Paolo Bonzini <pbonzini@redhat.com>
>     KVM: nVMX: Don't emulate instructions in guest mode
>=20
> Mathias Nyman <mathias.nyman@linux.intel.com>
>     xhci: apply XHCI_PME_STUCK_QUIRK to Intel Comet Lake platforms
>=20
> Alex Deucher <alexander.deucher@amd.com>
>     drm/amdgpu/soc15: fix xclk for raven
>=20
> Gavin Shan <gshan@redhat.com>
>     mm/vmscan.c: don't round up scan size for online memory cgroup
>=20
> Zenghui Yu <yuzenghui@huawei.com>
>     genirq/irqdomain: Make sure all irq domain flags are distinct
>=20
> Logan Gunthorpe <logang@deltatee.com>
>     nvme-multipath: Fix memory leak with ana_log_buf
>=20
> Vasily Averin <vvs@virtuozzo.com>
>     mm/memcontrol.c: lost css_put in memcg_expand_shrinker_maps()
>=20
> Ioanna Alifieraki <ioanna-maria.alifieraki@canonical.com>
>     Revert "ipc,sem: remove uneeded sem_undo_list lock usage in
> exit_sem()"
>=20
> Jani Nikula <jani.nikula@intel.com>
>     MAINTAINERS: Update drm/i915 bug filing URL
>=20
> Johan Hovold <johan@kernel.org>
>     serdev: ttyport: restore client ops on deregistration
>=20
> Fugang Duan <fugang.duan@nxp.com>
>     tty: serial: imx: setup the correct sg entry for tx dma
>=20
> Nicolas Ferre <nicolas.ferre@microchip.com>
>     tty/serial: atmel: manage shutdown in case of RS485 or ISO7816 mode
>=20
> Andy Shevchenko <andriy.shevchenko@linux.intel.com>
>     serial: 8250: Check UPF_IRQ_SHARED in advance
>=20
> Kim Phillips <kim.phillips@amd.com>
>     x86/cpu/amd: Enable the fixed Instructions Retired counter IRPERF
>=20
> Thomas Gleixner <tglx@linutronix.de>
>     x86/mce/amd: Fix kobject lifetime
>=20
> Borislav Petkov <bp@suse.de>
>     x86/mce/amd: Publish the bank pointer only after setup has succeeded
>=20
> wangyan <wangyan122@huawei.com>
>     jbd2: fix ocfs2 corrupt when clearing block group bits
>=20
> Gustavo Luiz Duarte <gustavold@linux.ibm.com>
>     powerpc/tm: Fix clearing MSR[TS] in current when reclaiming on signal
> delivery
>=20
> Larry Finger <Larry.Finger@lwfinger.net>
>     staging: rtl8723bs: Fix potential overuse of kernel memory
>=20
> Larry Finger <Larry.Finger@lwfinger.net>
>     staging: rtl8723bs: Fix potential security hole
>=20
> Larry Finger <Larry.Finger@lwfinger.net>
>     staging: rtl8188eu: Fix potential overuse of kernel memory
>=20
> Larry Finger <Larry.Finger@lwfinger.net>
>     staging: rtl8188eu: Fix potential security hole
>=20
> Anurag Kumar Vulisha <anurag.kumar.vulisha@xilinx.com>
>     usb: dwc3: gadget: Check for IOC/LST bit in TRB->ctrl fields
>=20
> Minas Harutyunyan <Minas.Harutyunyan@synopsys.com>
>     usb: dwc2: Fix SET/CLEAR_FEATURE and GET_STATUS flows
>=20
> Hardik Gajjar <hgajjar@de.adit-jv.com>
>     USB: hub: Fix the broken detection of USB3 device in SMSC hub
>=20
> Alan Stern <stern@rowland.harvard.edu>
>     USB: hub: Don't record a connect-change event during reset-resume
>=20
> Richard Dodd <richard.o.dodd@gmail.com>
>     USB: Fix novation SourceControl XL after suspend
>=20
> EJ Hsu <ejh@nvidia.com>
>     usb: uas: fix a plug & unplug racing
>=20
> Johan Hovold <johan@kernel.org>
>     USB: quirks: blacklist duplicate ep on Sound Devices USBPre2
>=20
> Johan Hovold <johan@kernel.org>
>     USB: core: add endpoint-blacklist quirk
>=20
> Peter Chen <peter.chen@nxp.com>
>     usb: host: xhci: update event ring dequeue pointer on purpose
>=20
> Mathias Nyman <mathias.nyman@linux.intel.com>
>     xhci: Fix memory leak when caching protocol extended capability PSI t=
ables
> - take 2
>=20
> Mathias Nyman <mathias.nyman@linux.intel.com>
>     xhci: fix runtime pm enabling for quirky Intel hosts
>=20
> Mathias Nyman <mathias.nyman@linux.intel.com>
>     xhci: Force Maximum Packet size for Full-speed bulk devices to valid =
range.
>=20
> Malcolm Priestley <tvboxspy@gmail.com>
>     staging: vt6656: fix sign of rx_dbm to bb_pre_ed_rssi.
>=20
> Suren Baghdasaryan <surenb@google.com>
>     staging: android: ashmem: Disallow ashmem memory from being
> remapped
>=20
> Eric Dumazet <edumazet@google.com>
>     vt: vt_ioctl: fix race in VT_RESIZEX
>=20
> Jiri Slaby <jslaby@suse.cz>
>     vt: selection, close sel_buffer race
>=20
> Jiri Slaby <jslaby@suse.cz>
>     vt: selection, handle pending signals in paste_selection
>=20
> Nicolas Pitre <nico@fluxnic.net>
>     vt: fix scrollback flushing on background consoles
>=20
> Linus Torvalds <torvalds@linux-foundation.org>
>     floppy: check FDC index for errors before assigning it
>=20
> Greg Kroah-Hartman <gregkh@linuxfoundation.org>
>     USB: misc: iowarrior: add support for the 100 device
>=20
> Greg Kroah-Hartman <gregkh@linuxfoundation.org>
>     USB: misc: iowarrior: add support for the 28 and 28L devices
>=20
> Greg Kroah-Hartman <gregkh@linuxfoundation.org>
>     USB: misc: iowarrior: add support for 2 OEMed devices
>=20
> Mika Westerberg <mika.westerberg@linux.intel.com>
>     thunderbolt: Prevent crash if non-active NVMem file is read
>=20
> Wenwen Wang <wenwen@cs.uga.edu>
>     ecryptfs: fix a memory leak bug in ecryptfs_init_messaging()
>=20
> Wenwen Wang <wenwen@cs.uga.edu>
>     ecryptfs: fix a memory leak bug in parse_tag_1_packet()
>=20
> Samuel Holland <samuel@sholland.org>
>     ASoC: sun8i-codec: Fix setting DAI data format
>=20
> Takashi Iwai <tiwai@suse.de>
>     ALSA: hda/realtek - Apply quirk for yet another MSI laptop
>=20
> Takashi Iwai <tiwai@suse.de>
>     ALSA: hda/realtek - Apply quirk for MSI GP63, too
>=20
> Takashi Iwai <tiwai@suse.de>
>     ALSA: hda: Use scnprintf() for printing texts for sysfs/procfs
>=20
> Robin Murphy <robin.murphy@arm.com>
>     iommu/qcom: Fix bogus detach logic
>=20
>=20
> -------------
>=20
> Diffstat:
>=20
>  MAINTAINERS                                    |   2 +-
>  Makefile                                       |   4 +-
>  arch/powerpc/kernel/signal.c                   |  17 +-
>  arch/powerpc/kernel/signal_32.c                |  28 +--
>  arch/powerpc/kernel/signal_64.c                |  22 +-
>  arch/s390/include/asm/page.h                   |   2 +-
>  arch/x86/include/asm/kvm_host.h                |   2 +-
>  arch/x86/include/asm/msr-index.h               |   2 +
>  arch/x86/kernel/cpu/amd.c                      |  14 ++
>  arch/x86/kernel/cpu/mcheck/mce_amd.c           |  50 +++--
>  arch/x86/kvm/irq_comm.c                        |   2 +-
>  arch/x86/kvm/lapic.c                           |   9 +-
>  arch/x86/kvm/svm.c                             |   7 +-
>  arch/x86/kvm/vmx.c                             | 112 +++++++---
>  drivers/ata/ahci.c                             |   7 +
>  drivers/ata/libata-core.c                      |  21 ++
>  drivers/block/floppy.c                         |   7 +-
>  drivers/dma/imx-sdma.c                         |  19 +-
>  drivers/gpu/drm/amd/amdgpu/soc15.c             |   7 +-
>  drivers/gpu/drm/nouveau/dispnv50/wndw.c        |   2 +
>  drivers/infiniband/ulp/isert/ib_isert.c        |  12 ++
>  drivers/iommu/qcom_iommu.c                     |  28 ++-
>  drivers/nvme/host/multipath.c                  |   1 +
>  drivers/staging/android/ashmem.c               |  28 +++
>  drivers/staging/greybus/audio_manager.c        |   2 +-
>  drivers/staging/rtl8188eu/os_dep/ioctl_linux.c |   4 +-
>  drivers/staging/rtl8723bs/hal/rtl8723bs_xmit.c |   5 +-
>  drivers/staging/rtl8723bs/os_dep/ioctl_linux.c |   4 +-
>  drivers/staging/vt6656/dpc.c                   |   2 +-
>  drivers/target/iscsi/iscsi_target.c            |  16 +-
>  drivers/thunderbolt/switch.c                   |   7 +
>  drivers/tty/serdev/serdev-ttyport.c            |   6 +-
>  drivers/tty/serial/8250/8250_aspeed_vuart.c    |   1 -
>  drivers/tty/serial/8250/8250_core.c            |   5 +-
>  drivers/tty/serial/8250/8250_of.c              |   1 -
>  drivers/tty/serial/8250/8250_port.c            |   4 +
>  drivers/tty/serial/atmel_serial.c              |   3 +-
>  drivers/tty/serial/imx.c                       |   2 +-
>  drivers/tty/serial/qcom_geni_serial.c          | 284 +++++++++++--------=
------
>  drivers/tty/tty_port.c                         |   5 +-
>  drivers/tty/vt/selection.c                     |  32 ++-
>  drivers/tty/vt/vt.c                            |  15 +-
>  drivers/tty/vt/vt_ioctl.c                      |  17 +-
>  drivers/usb/core/config.c                      |  11 +
>  drivers/usb/core/hub.c                         |  20 +-
>  drivers/usb/core/hub.h                         |   1 +
>  drivers/usb/core/quirks.c                      |  40 ++++
>  drivers/usb/core/usb.h                         |   3 +
>  drivers/usb/dwc2/gadget.c                      |  40 ++--
>  drivers/usb/dwc3/gadget.c                      |   3 +-
>  drivers/usb/gadget/composite.c                 |   8 +-
>  drivers/usb/host/xhci-hub.c                    |  25 ++-
>  drivers/usb/host/xhci-mem.c                    |  71 ++++---
>  drivers/usb/host/xhci-pci.c                    |  10 +-
>  drivers/usb/host/xhci-ring.c                   |  60 ++++--
>  drivers/usb/host/xhci.h                        |  16 +-
>  drivers/usb/misc/iowarrior.c                   |  31 ++-
>  drivers/usb/storage/uas.c                      |  23 +-
>  drivers/xen/preempt.c                          |   4 +-
>  fs/btrfs/disk-io.c                             |   2 +-
>  fs/btrfs/inode.c                               |  16 +-
>  fs/btrfs/ordered-data.c                        |   7 +-
>  fs/ecryptfs/crypto.c                           |   6 +-
>  fs/ecryptfs/keystore.c                         |   2 +-
>  fs/ecryptfs/messaging.c                        |   1 +
>  fs/ext4/balloc.c                               |  14 +-
>  fs/ext4/ext4.h                                 |  39 +++-
>  fs/ext4/ialloc.c                               |  23 +-
>  fs/ext4/inode.c                                |  16 +-
>  fs/ext4/mballoc.c                              |  61 ++++--
>  fs/ext4/migrate.c                              |  27 ++-
>  fs/ext4/namei.c                                |   1 +
>  fs/ext4/resize.c                               |  62 ++++--
>  fs/ext4/super.c                                | 113 ++++++----
>  fs/jbd2/transaction.c                          |   8 +-
>  include/linux/intel-svm.h                      |   2 +-
>  include/linux/irqdomain.h                      |   2 +-
>  include/linux/libata.h                         |   1 +
>  include/linux/tty.h                            |   2 +
>  include/linux/usb/quirks.h                     |   3 +
>  include/scsi/iscsi_proto.h                     |   1 -
>  include/sound/rawmidi.h                        |   6 +-
>  ipc/sem.c                                      |   6 +-
>  kernel/bpf/offload.c                           |   2 +-
>  kernel/irq/internals.h                         |   2 -
>  kernel/irq/manage.c                            |  18 +-
>  kernel/irq/proc.c                              |  22 ++
>  lib/stackdepot.c                               |  12 +-
>  mm/memcontrol.c                                |   4 +-
>  mm/vmscan.c                                    |   9 +-
>  net/netfilter/xt_hashlimit.c                   |  10 +
>  net/rxrpc/call_object.c                        |  22 +-
>  sound/core/seq/seq_clientmgr.c                 |   4 +-
>  sound/core/seq/seq_queue.c                     |  29 ++-
>  sound/core/seq/seq_timer.c                     |  13 +-
>  sound/core/seq/seq_timer.h                     |   3 +-
>  sound/hda/hdmi_chmap.c                         |   2 +-
>  sound/pci/hda/hda_codec.c                      |   2 +-
>  sound/pci/hda/hda_eld.c                        |   2 +-
>  sound/pci/hda/hda_sysfs.c                      |   4 +-
>  sound/pci/hda/patch_realtek.c                  |   2 +
>  sound/soc/sunxi/sun8i-codec.c                  |   3 +-
>  102 files changed, 1187 insertions(+), 585 deletions(-)
>=20

