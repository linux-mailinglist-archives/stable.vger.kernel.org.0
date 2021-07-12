Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F0A193C59FC
	for <lists+stable@lfdr.de>; Mon, 12 Jul 2021 13:03:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345957AbhGLJVo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Jul 2021 05:21:44 -0400
Received: from mail-dm6nam08on2080.outbound.protection.outlook.com ([40.107.102.80]:55264
        "EHLO NAM04-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1347166AbhGLJVk (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Jul 2021 05:21:40 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=DEby92AyFo0WJT1LiCw6x0Bo2jgXh+nWY6ne/nAIPyVEf34Bn6/wRgD7T96JdowpLHW909zMjEb2zFJbMG6nWfJFuxRrBQRwXL0+cyfsGstgOiyxMWRUj5GnI9VZQuDXYbVd2omocwqw6yyrosoxSJXnc4DC+zs4ht9EmsxoeSLTdYD8MWXKvR4tx+fRTU10ZfQrFV64Wu+nGHZQkCRtRRxXep/xC5AHe7u3GONkZk+QOrLYY17g/dwGpFi8NgFMUNYkQ5Vum4IugRvkpiMwSqsDhWsJGbWMYLTu9pBk0+bxWgBm0SfYnJyD/vgtJ5jyq/hk64eG8I986D5OHzI6DA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=iDM+v36KZ2WWprfC8yUYEUr4OrYOkWWzzx0cHVoW7P8=;
 b=B240YrfwvV3+jpmInajIEmunfjfCPR6RbbWpHwQH2d4TOxsg27F3M+1KOSq9Artxbnp4KNoaYAUmwpWvCtoR+MSdFVKdlCjX5y4VtdwlaMtHbkGH/EZTBVg+cKpk8HB1z9aLbHuG/o4Pb1lfkQwhT8VvA1QiEGCJMjunSjdDFgf+bFntXccVrVSdDnAEcomZ9Gdn1XK+E5OS1PSyyBXl8xFf+DBD2lfehLpYhWHpMzEvlyZvLfpud8WbzhFSzrGb/xIC1XR+rCaW73Oshr4miCA1IgTMugR0g9iUS51/xM+qWt2zF3yHLJELC+zUTaX8CxtgwioYRonjF8KBfMRoCA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.36) smtp.rcpttodomain=denx.de smtp.mailfrom=nvidia.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=iDM+v36KZ2WWprfC8yUYEUr4OrYOkWWzzx0cHVoW7P8=;
 b=FXZdaURbgKSlJgkeW4OHvb15a16DVIAWZ1/bF+v3Qv3x3m+SicGuhkuf8V04Q0rVobEReOcpg62vtFVbVm9FFPeiN0fP9X/ZmdFR81g8cnXe8UnNMLzXQcP5tYyyqZF6iB0bvhm7+pPdKJn1iA5+TOGa47hDtERV0fFq1EQdO6akwSTx2Dqbj8TOP+jyGXwM96W4ZZGpfXBNkYEpGmcUzOQhAGWIEOizHxaBQEFODUmUtte/eICDDvrgUN5Jn4JlZfDcx4YNoT24isOToA1nINtW5RGznAE05iJvGr1oLrCw6HEfqeoBLcZWzbco2ZTG9MDcBa30q0jhsRLpDUqG7Q==
Received: from DM5PR13CA0070.namprd13.prod.outlook.com (2603:10b6:3:117::32)
 by DM6PR12MB2874.namprd12.prod.outlook.com (2603:10b6:5:15e::29) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4308.22; Mon, 12 Jul
 2021 09:18:45 +0000
Received: from DM6NAM11FT060.eop-nam11.prod.protection.outlook.com
 (2603:10b6:3:117:cafe::e6) by DM5PR13CA0070.outlook.office365.com
 (2603:10b6:3:117::32) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4331.12 via Frontend
 Transport; Mon, 12 Jul 2021 09:18:45 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.36)
 smtp.mailfrom=nvidia.com; denx.de; dkim=none (message not signed)
 header.d=none;denx.de; dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.36 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.36; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.36) by
 DM6NAM11FT060.mail.protection.outlook.com (10.13.173.63) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4308.20 via Frontend Transport; Mon, 12 Jul 2021 09:18:45 +0000
Received: from HQMAIL111.nvidia.com (172.20.187.18) by HQMAIL101.nvidia.com
 (172.20.187.10) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Mon, 12 Jul
 2021 09:18:44 +0000
Received: from jonathanh-vm-01.nvidia.com (172.20.187.5) by mail.nvidia.com
 (172.20.187.18) with Microsoft SMTP Server (TLS) id 15.0.1497.2 via Frontend
 Transport; Mon, 12 Jul 2021 09:18:45 +0000
From:   Jon Hunter <jonathanh@nvidia.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <torvalds@linux-foundation.org>, <akpm@linux-foundation.org>,
        <linux@roeck-us.net>, <shuah@kernel.org>, <patches@kernelci.org>,
        <lkft-triage@lists.linaro.org>, <pavel@denx.de>,
        <jonathanh@nvidia.com>, <f.fainelli@gmail.com>,
        <stable@vger.kernel.org>, <linux-tegra@vger.kernel.org>
Subject: Re: [PATCH 5.12 000/700] 5.12.17-rc1 review
In-Reply-To: <20210712060924.797321836@linuxfoundation.org>
References: <20210712060924.797321836@linuxfoundation.org>
X-NVConfidentiality: public
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
Message-ID: <ebb91838ca88453c905d117901b76951@HQMAIL111.nvidia.com>
Date:   Mon, 12 Jul 2021 09:18:45 +0000
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 9c582020-be13-4644-9a21-08d945160cdd
X-MS-TrafficTypeDiagnostic: DM6PR12MB2874:
X-Microsoft-Antispam-PRVS: <DM6PR12MB28741075B2DD9B1A9117D570D9159@DM6PR12MB2874.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8273;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: u7jcqV2XrNyLX+kzAO9kf+i5svrVX9wXapeCGt8tzcy2fWgwoCBKJwh3rgPv+ZPL0vyq45y0BTRZ74hhn1GYbCkiZng7a6Iva/Ji5BtCYMeOhN8GcZpvBkZhfWnfZFP8rhi9uQw1DQTcFZt/402ITkJySFMmRYvXM6hKrMB2Uwjg13JrYT0HXB8nul8U2CIGlmg3HfZdc9Mw48Fha+KZQCWs04qKLyScKWrIwR6LMjUp+wam4J7oKzLA7owhKVLloJSzitG+v09npQ24yaT3429MNAXc9fPqDAfdWr1WZnmnPw7uZPKLzK+oFgINxgCDUB8e7QW30F3Ab0Kcp4Fzcz0PSG5CBNAU5AJ9oaDUyBKofpTuC4lKedzaIniSM1fXMgiFTi2UFJVzlc9oJLwOqBVJfMQKcSKWyC2KJ/M2nFEtLd2yW8QaudRQ+dBaHoNCIahWQyircIJxuwnvYoTSarJaQ17rgG6rYZR88qKBwym2O3rBG7PBFaAfk+rN0/S8Q2LV4hdMxwY9Ms9xOWarPsZBYXx6TMgs7SQZSGyD31Tml6FwnSzT1bEh9RSx/LcREvHvBdWRXwxFXN/nlyw/wd00tv4ABv4fKCuZ1+wfiOWURS1EGUxoslLjCPbWE88sNyDgpkUSBfTKfr2bveX1stFPLFbITs7FjW5V88zd4q3D+Q7DqZPFmxaIoepcTeRgpPRzpTwYPb31xmA6Byfz7aydFzlAYaMwCGV0c+Bf5s2rxJkmcFTFGm7aEaZnsvDxkSdjEXzU7WQEwHWFeVRGC1ip13eiivWoFNUQtYr4izWPZlno9/0/CLY5wYXM+h61Q/eB0uqVDtsmSpUQLVTsqXk+/ZuSeuvdLS/F4XJAURA=
X-Forefront-Antispam-Report: CIP:216.228.112.36;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid05.nvidia.com;CAT:NONE;SFS:(4636009)(39860400002)(376002)(346002)(136003)(396003)(36840700001)(46966006)(7416002)(86362001)(36860700001)(70586007)(478600001)(70206006)(4326008)(6916009)(19627235002)(8676002)(36906005)(24736004)(336012)(54906003)(30864003)(108616005)(2906002)(316002)(8936002)(45080400002)(426003)(356005)(5660300002)(66574015)(83380400001)(82310400003)(186003)(7636003)(34020700004)(82740400003)(47076005)(26005)(966005)(525324003)(579004)(559001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Jul 2021 09:18:45.5933
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 9c582020-be13-4644-9a21-08d945160cdd
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.36];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT060.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB2874
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, 12 Jul 2021 08:01:23 +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.12.17 release.
> There are 700 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>=20
> Responses should be made by Wed, 14 Jul 2021 06:02:46 +0000.
> Anything received after that time might be too late.
>=20
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.12.17-r=
c1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git l=
inux-5.12.y
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
>     Linux 5.12.17-rc1
>=20
> Quat Le <quat.le@oracle.com>
>     scsi: core: Retry I/O for Notify (Enable Spinup) Required error
>=20
> Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
>     media: exynos4-is: remove a now unused integer
>=20
> Johan Hovold <johan@kernel.org>
>     mmc: vub3000: fix control-request direction
>=20
> Bean Huo <beanhuo@micron.com>
>     mmc: block: Disable CMDQ on the ioctl path
>=20
> Jens Axboe <axboe@kernel.dk>
>     io_uring: add IOPOLL and reserved field checks to IORING_OP_UNLINKAT
>=20
> Jens Axboe <axboe@kernel.dk>
>     io_uring: add IOPOLL and reserved field checks to IORING_OP_RENAMEAT
>=20
> Pavel Begunkov <asml.silence@gmail.com>
>     io_uring: fix blocking inline submission
>=20
> Long Li <longli@microsoft.com>
>     block: return the correct bvec when checking for gaps
>=20
> Wei Yongjun <weiyongjun1@huawei.com>
>     erofs: fix error return code in erofs_read_superblock()
>=20
> Jarkko Sakkinen <jarkko@kernel.org>
>     tpm: Replace WARN_ONCE() with dev_err_once() in tpm_tis_status()
>=20
> Eric Biggers <ebiggers@google.com>
>     fscrypt: fix derivation of SipHash keys on big endian CPUs
>=20
> Eric Biggers <ebiggers@google.com>
>     fscrypt: don't ignore minor_hash when hash is 0
>=20
> Sibi Sankar <sibis@codeaurora.org>
>     mailbox: qcom-ipcc: Fix IPCC mbox channel exhaustion
>=20
> Javed Hasan <jhasan@marvell.com>
>     scsi: libfc: Correct the condition check and invalid argument passed
>=20
> James Smart <jsmart2021@gmail.com>
>     scsi: lpfc: Fix Node recovery when driver is handling simultaneous PLOG=
Is
>=20
> James Smart <jsmart2021@gmail.com>
>     scsi: lpfc: Fix unreleased RPIs when NPIV ports are created
>=20
> Varun Prakash <varun@chelsio.com>
>     scsi: target: cxgbit: Unmap DMA buffer before calling target_execute_cm=
d()
>=20
> Javed Hasan <jhasan@marvell.com>
>     scsi: fc: Correct RHBA attributes length
>=20
> Chandrakanth Patil <chandrakanth.patil@broadcom.com>
>     scsi: megaraid_sas: Send all non-RW I/Os for TYPE_ENCLOSURE device thro=
ugh firmware
>=20
> Namjae Jeon <namjae.jeon@samsung.com>
>     exfat: handle wrong stream entry size in exfat_readdir()
>=20
> Guo Ren <guoren@linux.alibaba.com>
>     csky: syscache: Fixup duplicate cache flush
>=20
> Randy Dunlap <rdunlap@infradead.org>
>     csky: fix syscache.c fallthrough warning
>=20
> Arnaldo Carvalho de Melo <acme@redhat.com>
>     perf llvm: Return -ENOMEM when asprintf() fails
>=20
> Dave Hansen <dave.hansen@linux.intel.com>
>     selftests/vm/pkeys: refill shadow register after implicit kernel write
>=20
> Dave Hansen <dave.hansen@linux.intel.com>
>     selftests/vm/pkeys: handle negative sys_pkey_alloc() return code
>=20
> Dave Hansen <dave.hansen@linux.intel.com>
>     selftests/vm/pkeys: fix alloc_random_pkey() to make it really, really r=
andom
>=20
> Trent Piepho <tpiepho@gmail.com>
>     lib/math/rational.c: fix divide by zero
>=20
> Miaohe Lin <linmiaohe@huawei.com>
>     mm/zswap.c: fix two bugs in zswap_writeback_entry()
>=20
> Muchun Song <songmuchun@bytedance.com>
>     mm: migrate: fix missing update page_private to hugetlb_page_subpool
>=20
> Miaohe Lin <linmiaohe@huawei.com>
>     mm/z3fold: use release_z3fold_page_locked() to release locked z3fold pa=
ge
>=20
> Miaohe Lin <linmiaohe@huawei.com>
>     mm/z3fold: fix potential memory leak in z3fold_destroy_pool()
>=20
> Mike Kravetz <mike.kravetz@oracle.com>
>     hugetlb: address ref count racing in prep_compound_gigantic_page
>=20
> Mike Kravetz <mike.kravetz@oracle.com>
>     hugetlb: remove prep_compound_huge_page cleanup
>=20
> Miaohe Lin <linmiaohe@huawei.com>
>     mm/huge_memory.c: don't discard hugepage if other processes are mapping=
 it
>=20
> Miaohe Lin <linmiaohe@huawei.com>
>     mm/huge_memory.c: add missing read-only THP checking in transparent_hug=
epage_enabled()
>=20
> Miaohe Lin <linmiaohe@huawei.com>
>     mm/huge_memory.c: remove dedicated macro HPAGE_CACHE_INDEX_MASK
>=20
> Alex Williamson <alex.williamson@redhat.com>
>     vfio/pci: Handle concurrent vma faults
>=20
> Nicholas Piggin <npiggin@gmail.com>
>     powerpc/64s/interrupt: preserve regs->softe for NMI interrupts
>=20
> Pali Roh=C3=A1r <pali@kernel.org>
>     arm64: dts: marvell: armada-37xx: Fix reg for standard variant of UART
>=20
> Pali Roh=C3=A1r <pali@kernel.org>
>     serial: mvebu-uart: correctly calculate minimal possible baudrate
>=20
> Pali Roh=C3=A1r <pali@kernel.org>
>     serial: mvebu-uart: do not allow changing baudrate when uartclk is not =
available
>=20
> Christophe JAILLET <christophe.jaillet@wanadoo.fr>
>     ALSA: firewire-lib: Fix 'amdtp_domain_start()' when no AMDTP_OUT_STREAM=
 stream is found
>=20
> Michael Ellerman <mpe@ellerman.id.au>
>     powerpc: Fix is_kvm_guest() / kvm_para_available()
>=20
> Vaibhav Jain <vaibhav@linux.ibm.com>
>     powerpc/papr_scm: Make 'perf_stats' invisible if perf-stats unavailable
>=20
> Nicholas Piggin <npiggin@gmail.com>
>     powerpc/64s: Fix copy-paste data exposure into newly created tasks
>=20
> Andy Shevchenko <andriy.shevchenko@linux.intel.com>
>     powerpc/papr_scm: Properly handle UUID types and API
>=20
> Nicholas Piggin <npiggin@gmail.com>
>     powerpc: Offline CPU in stop_this_cpu()
>=20
> Vignesh Raghavendra <vigneshr@ti.com>
>     serial: 8250: 8250_omap: Fix possible interrupt storm on K3 SoCs
>=20
> Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>
>     selftests/ftrace: fix event-no-pid on 1-core machine
>=20
> Christophe JAILLET <christophe.jaillet@wanadoo.fr>
>     leds: ktd2692: Fix an error handling path
>=20
> Zhen Lei <thunder.leizhen@huawei.com>
>     leds: as3645a: Fix error return code in as3645a_parse_node()
>=20
> Shengjiu Wang <shengjiu.wang@nxp.com>
>     ASoC: fsl_spdif: Fix unexpected interrupt after suspend
>=20
> Kai Vehmanen <kai.vehmanen@linux.intel.com>
>     ASoC: Intel: sof_sdw: use mach data for ADL RVP DMIC count
>=20
> Vamshi Krishna Gopal <vamshi.krishna.gopal@intel.com>
>     ASoC: Intel: sof_sdw: add quirk support for Brya and BT-offload
>=20
> Libin Yang <libin.yang@intel.com>
>     ASoC: Intel: sof_sdw: add SOF_RT715_DAI_ID_FIX for AlderLake
>=20
> Chung-Chiang Cheng <shepjeng@gmail.com>
>     configfs: fix memleak in configfs_release_bin_file
>=20
> Shengjiu Wang <shengjiu.wang@nxp.com>
>     ASoC: fsl_xcvr: disable all interrupts when suspend happens
>=20
> Codrin Ciubotariu <codrin.ciubotariu@microchip.com>
>     ASoC: atmel-i2s: Fix usage of capture and playback at the same time
>=20
> Codrin Ciubotariu <codrin.ciubotariu@microchip.com>
>     ASoC: atmel-i2s: Set symmetric sample bits
>=20
> Nicholas Piggin <npiggin@gmail.com>
>     powerpc/powernv: Fix machine check reporting of async store errors
>=20
> Marek Szyprowski <m.szyprowski@samsung.com>
>     extcon: max8997: Add missing modalias string
>=20
> Stephan Gerhold <stephan@gerhold.net>
>     extcon: sm5502: Drop invalid register write in sm5502_reg_data
>=20
> Christophe JAILLET <christophe.jaillet@wanadoo.fr>
>     phy: ti: dm816x: Fix the error handling path in 'dm816x_usb_phy_probe()
>=20
> Kunihiko Hayashi <hayashi.kunihiko@socionext.com>
>     phy: uniphier-pcie: Fix updating phy parameters
>=20
> Richard Fitzgerald <rf@opensource.cirrus.com>
>     soundwire: stream: Fix test for DP prepare complete
>=20
> Zhen Lei <thunder.leizhen@huawei.com>
>     scsi: mpt3sas: Fix error return value in _scsih_expander_add()
>=20
> Christophe JAILLET <christophe.jaillet@wanadoo.fr>
>     habanalabs: Fix an error handling path in 'hl_pci_probe()'
>=20
> Yang Yingliang <yangyingliang@huawei.com>
>     mtd: rawnand: marvell: add missing clk_disable_unprepare() on error in =
marvell_nfc_resume()
>=20
> Geert Uytterhoeven <geert+renesas@glider.be>
>     of: Fix truncation of memory sizes on 32-bit platforms
>=20
> Richard Fitzgerald <rf@opensource.cirrus.com>
>     ASoC: cs42l42: Correct definition of CS42L42_ADC_PDN_MASK
>=20
> Jonathan Cameron <Jonathan.Cameron@huawei.com>
>     iio: prox: isl29501: Fix buffer alignment in iio_push_to_buffers_with_t=
imestamp()
>=20
> Jonathan Cameron <Jonathan.Cameron@huawei.com>
>     iio: light: vcnl4035: Fix buffer alignment in iio_push_to_buffers_with_=
timestamp()
>=20
> Maciej W. Rozycki <macro@orcam.me.uk>
>     serial: 8250: Actually allow UPF_MAGIC_MULTIPLIER baud rates
>=20
> Dmitry Osipenko <digetx@gmail.com>
>     usb: phy: tegra: Correct definition of B_SESS_VLD_WAKEUP_EN bit
>=20
> Dmitry Osipenko <digetx@gmail.com>
>     usb: phy: tegra: Wait for VBUS wakeup status deassertion on suspend
>=20
> Sergio Paracuellos <sergio.paracuellos@gmail.com>
>     staging: mt7621-dts: fix pci address for PCI memory range
>=20
> Junhao He <hejunhao2@hisilicon.com>
>     coresight: core: Fix use of uninitialized pointer
>=20
> Pavel Skripkin <paskripkin@gmail.com>
>     staging: rtl8712: fix memory leak in rtl871x_load_fw_cb
>=20
> Pavel Skripkin <paskripkin@gmail.com>
>     staging: rtl8712: fix error handling in r871xu_drv_init
>=20
> Dan Carpenter <dan.carpenter@oracle.com>
>     staging: gdm724x: check for overflow in gdm_lte_netif_rx()
>=20
> Dan Carpenter <dan.carpenter@oracle.com>
>     staging: gdm724x: check for buffer overflow in gdm_lte_multi_sdu_pkt()
>=20
> Shengjiu Wang <shengjiu.wang@nxp.com>
>     ASoC: fsl_spdif: Fix error handler with pm_runtime_enable
>=20
> Jonathan Cameron <Jonathan.Cameron@huawei.com>
>     iio: light: vcnl4000: Fix buffer alignment in iio_push_to_buffers_with_=
timestamp()
>=20
> Jonathan Cameron <Jonathan.Cameron@huawei.com>
>     iio: magn: rm3100: Fix alignment of buffer in iio_push_to_buffers_with_=
timestamp()
>=20
> Jonathan Cameron <Jonathan.Cameron@huawei.com>
>     iio: adc: ti-ads8688: Fix alignment of buffer in iio_push_to_buffers_wi=
th_timestamp()
>=20
> Jonathan Cameron <Jonathan.Cameron@huawei.com>
>     iio: adc: mxs-lradc: Fix buffer alignment in iio_push_to_buffers_with_t=
imestamp()
>=20
> Jonathan Cameron <Jonathan.Cameron@huawei.com>
>     iio: adc: hx711: Fix buffer alignment in iio_push_to_buffers_with_times=
tamp()
>=20
> Jonathan Cameron <Jonathan.Cameron@huawei.com>
>     iio: adc: at91-sama5d2: Fix buffer alignment in iio_push_to_buffers_wit=
h_timestamp()
>=20
> David Gow <davidgow@google.com>
>     kunit: Fix result propagation for parameterised tests
>=20
> Miquel Raynal <miquel.raynal@bootlin.com>
>     mtd: spinand: Fix double counting of ECC stats
>=20
> Mika Westerberg <mika.westerberg@linux.intel.com>
>     thunderbolt: Bond lanes only when dual_link_port !=3D NULL in alloc_dev=
_default()
>=20
> Andy Shevchenko <andy.shevchenko@gmail.com>
>     eeprom: idt_89hpesx: Restore printing the unsupported fwnode name
>=20
> Andy Shevchenko <andy.shevchenko@gmail.com>
>     eeprom: idt_89hpesx: Put fwnode in matching case during ->probe()
>=20
> Cl=C3=A9ment Lassieur <clement@lassieur.org>
>     usb: dwc2: Don't reset the core after setting turnaround time
>=20
> Andrew Gabbasov <andrew_gabbasov@mentor.com>
>     usb: gadget: f_fs: Fix setting of device and driver data cross-referenc=
es
>=20
> Christophe JAILLET <christophe.jaillet@wanadoo.fr>
>     ASoC: mediatek: mtk-btcvsd: Fix an error handling path in 'mtk_btcvsd_s=
nd_probe()'
>=20
> Bard Liao <yung-chuan.liao@linux.intel.com>
>     ASoC: rt5682-sdw: set regcache_cache_only false before reading RT5682_D=
EVICE_ID
>=20
> Oder Chiou <oder_chiou@realtek.com>
>     ASoC: rt5682: Fix a problem with error handling in the io init function=
 of the soundwire
>=20
> Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>
>     ASoC: rt715-sdw: use first_hw_init flag on resume
>=20
> Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>
>     ASoC: rt711-sdw: use first_hw_init flag on resume
>=20
> Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>
>     ASoC: rt700-sdw: use first_hw_init flag on resume
>=20
> Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>
>     ASoC: rt5682-sdw: use first_hw_init flag on resume
>=20
> Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>
>     ASoC: rt1308-sdw: use first_hw_init flag on resume
>=20
> Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>
>     ASoC: max98373-sdw: use first_hw_init flag on resume
>=20
> Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>
>     ASoC: max98373-sdw: add missing memory allocation check
>=20
> Srinath Mannam <srinath.mannam@broadcom.com>
>     iommu/dma: Fix IOVA reserve dma ranges
>=20
> Kees Cook <keescook@chromium.org>
>     selftests: splice: Adjust for handler fallback removal
>=20
> Randy Dunlap <rdunlap@infradead.org>
>     s390: appldata depends on PROC_SYSCTL
>=20
> Niklas Schnelle <schnelle@linux.ibm.com>
>     s390: enable HAVE_IOREMAP_PROT
>=20
> Alexander Monakov <amonakov@ispras.ru>
>     iommu/amd: Fix extended features logging
>=20
> Zhen Lei <thunder.leizhen@huawei.com>
>     visorbus: fix error return code in visorchipset_init()
>=20
> Joachim Fenkes <FENKES@de.ibm.com>
>     fsi/sbefifo: Fix reset timeout
>=20
> Joachim Fenkes <FENKES@de.ibm.com>
>     fsi/sbefifo: Clean up correct FIFO when receiving reset request from SBE
>=20
> Eddie James <eajames@linux.ibm.com>
>     fsi: occ: Don't accept response from un-initialized OCC
>=20
> Eddie James <eajames@linux.ibm.com>
>     fsi: scom: Reset the FSI2PIB engine for any error
>=20
> Colin Ian King <colin.king@canonical.com>
>     fsi: core: Fix return of error values on failures
>=20
> Andreas Kemnade <andreas@kemnade.info>
>     mfd: rn5t618: Fix IRQ trigger by changing it to level mode
>=20
> Randy Dunlap <rdunlap@infradead.org>
>     mfd: mp2629: Select MFD_CORE to fix build error
>=20
> Mike Christie <michael.christie@oracle.com>
>     scsi: iscsi: Flush block work before unblock
>=20
> Mike Christie <michael.christie@oracle.com>
>     scsi: iscsi: Fix in-kernel conn failure handling
>=20
> Mike Christie <michael.christie@oracle.com>
>     scsi: iscsi: Rel ref after iscsi_lookup_endpoint()
>=20
> Mike Christie <michael.christie@oracle.com>
>     scsi: iscsi: Use system_unbound_wq for destroy_work
>=20
> Mike Christie <michael.christie@oracle.com>
>     scsi: iscsi: Force immediate failure during shutdown
>=20
> Mike Christie <michael.christie@oracle.com>
>     scsi: iscsi: Stop queueing during ep_disconnect
>=20
> Randy Dunlap <rdunlap@infradead.org>
>     scsi: FlashPoint: Rename si_flags field
>=20
> Andy Shevchenko <andy.shevchenko@gmail.com>
>     leds: lp50xx: Put fwnode in error case during ->probe()
>=20
> Andy Shevchenko <andriy.shevchenko@linux.intel.com>
>     leds: lm3697: Don't spam logs when probe is deferred
>=20
> Andy Shevchenko <andy.shevchenko@gmail.com>
>     leds: lm3692x: Put fwnode in any case during ->probe()
>=20
> Andy Shevchenko <andy.shevchenko@gmail.com>
>     leds: lm36274: Put fwnode in error case during ->probe()
>=20
> Andy Shevchenko <andy.shevchenko@gmail.com>
>     leds: lm3532: select regmap I2C API
>=20
> Andy Shevchenko <andy.shevchenko@gmail.com>
>     leds: lgm-sso: Fix clock handling
>=20
> Colin Ian King <colin.king@canonical.com>
>     leds: lgm: Fix spelling mistake "prepate" -> "prepare"
>=20
> Andy Shevchenko <andy.shevchenko@gmail.com>
>     leds: class: The -ENOTSUPP should never be seen by user space
>=20
> Christophe JAILLET <christophe.jaillet@wanadoo.fr>
>     tty: nozomi: Fix the error handling path of 'nozomi_card_init()'
>=20
> Christophe JAILLET <christophe.jaillet@wanadoo.fr>
>     firmware: stratix10-svc: Fix a resource leak in an error handling path
>=20
> Yu Kuai <yukuai3@huawei.com>
>     char: pcmcia: error out if 'num_bytes_read' is greater than 4 in set_pr=
otocol()
>=20
> Dave Stevenson <dave.stevenson@raspberrypi.com>
>     staging: mmal-vchiq: Fix incorrect static vchiq_instance.
>=20
> Miquel Raynal <miquel.raynal@bootlin.com>
>     mtd: rawnand: arasan: Ensure proper configuration for the asserted targ=
et
>=20
> Ansuel Smith <ansuelsmth@gmail.com>
>     mtd: parsers: qcom: Fix leaking of partition name
>=20
> Corentin Labbe <clabbe@baylibre.com>
>     mtd: partitions: redboot: seek fis-index-block in the right node
>=20
> Adrian Hunter <adrian.hunter@intel.com>
>     perf scripting python: Fix tuple_set_u64()
>=20
> Zhen Lei <thunder.leizhen@huawei.com>
>     Input: hil_kbd - fix error return code in hil_dev_connect()
>=20
> Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>
>     ASoC: rsnd: tidyup loop on rsnd_adg_clk_query()
>=20
> Badhri Jagan Sridharan <badhri@google.com>
>     usb: typec: tcpm: Fix up PR_SWAP when vsafe0v is signalled
>=20
> Andy Shevchenko <andy.shevchenko@gmail.com>
>     backlight: lm3630a_bl: Put fwnode in error case during ->probe()
>=20
> Yang Yingliang <yangyingliang@huawei.com>
>     ASoC: hisilicon: fix missing clk_disable_unprepare() on error in hi6210=
_i2s_startup()
>=20
> Yang Yingliang <yangyingliang@huawei.com>
>     ASoC: rk3328: fix missing clk_disable_unprepare() on error in rk3328_pl=
atform_probe()
>=20
> Jonathan Cameron <Jonathan.Cameron@huawei.com>
>     iio: potentiostat: lmp91000: Fix alignment of buffer in iio_push_to_buf=
fers_with_timestamp()
>=20
> Jonathan Cameron <Jonathan.Cameron@huawei.com>
>     iio: cros_ec_sensors: Fix alignment of buffer in iio_push_to_buffers_wi=
th_timestamp()
>=20
> Jonathan Cameron <Jonathan.Cameron@huawei.com>
>     iio: chemical: atlas: Fix buffer alignment in iio_push_to_buffers_with_=
timestamp()
>=20
> Jonathan Cameron <Jonathan.Cameron@huawei.com>
>     iio: light: tcs3472: Fix buffer alignment in iio_push_to_buffers_with_t=
imestamp()
>=20
> Jonathan Cameron <Jonathan.Cameron@huawei.com>
>     iio: light: tcs3414: Fix buffer alignment in iio_push_to_buffers_with_t=
imestamp()
>=20
> Jonathan Cameron <Jonathan.Cameron@huawei.com>
>     iio: light: isl29125: Fix buffer alignment in iio_push_to_buffers_with_=
timestamp()
>=20
> Jonathan Cameron <Jonathan.Cameron@huawei.com>
>     iio: magn: bmc150: Fix buffer alignment in iio_push_to_buffers_with_tim=
estamp()
>=20
> Jonathan Cameron <Jonathan.Cameron@huawei.com>
>     iio: magn: hmc5843: Fix buffer alignment in iio_push_to_buffers_with_ti=
mestamp()
>=20
> Jonathan Cameron <Jonathan.Cameron@huawei.com>
>     iio: prox: as3935: Fix buffer alignment in iio_push_to_buffers_with_tim=
estamp()
>=20
> Jonathan Cameron <Jonathan.Cameron@huawei.com>
>     iio: prox: pulsed-light: Fix buffer alignment in iio_push_to_buffers_wi=
th_timestamp()
>=20
> Jonathan Cameron <Jonathan.Cameron@huawei.com>
>     iio: prox: srf08: Fix buffer alignment in iio_push_to_buffers_with_time=
stamp()
>=20
> Jonathan Cameron <Jonathan.Cameron@huawei.com>
>     iio: humidity: am2315: Fix buffer alignment in iio_push_to_buffers_with=
_timestamp()
>=20
> Jonathan Cameron <Jonathan.Cameron@huawei.com>
>     iio: gyro: bmg160: Fix buffer alignment in iio_push_to_buffers_with_tim=
estamp()
>=20
> Jonathan Cameron <Jonathan.Cameron@huawei.com>
>     iio: adc: vf610: Fix buffer alignment in iio_push_to_buffers_with_times=
tamp()
>=20
> Jonathan Cameron <Jonathan.Cameron@huawei.com>
>     iio: adc: ti-ads1015: Fix buffer alignment in iio_push_to_buffers_with_=
timestamp()
>=20
> Jonathan Cameron <Jonathan.Cameron@huawei.com>
>     iio: accel: stk8ba50: Fix buffer alignment in iio_push_to_buffers_with_=
timestamp()
>=20
> Jonathan Cameron <Jonathan.Cameron@huawei.com>
>     iio: accel: stk8312: Fix buffer alignment in iio_push_to_buffers_with_t=
imestamp()
>=20
> Jonathan Cameron <Jonathan.Cameron@huawei.com>
>     iio: accel: mxc4005: Fix overread of data and alignment issue.
>=20
> Jonathan Cameron <Jonathan.Cameron@huawei.com>
>     iio: accel: kxcjk-1013: Fix buffer alignment in iio_push_to_buffers_wit=
h_timestamp()
>=20
> Jonathan Cameron <Jonathan.Cameron@huawei.com>
>     iio: accel: hid: Fix buffer alignment in iio_push_to_buffers_with_times=
tamp()
>=20
> Jonathan Cameron <Jonathan.Cameron@huawei.com>
>     iio: accel: bma220: Fix buffer alignment in iio_push_to_buffers_with_ti=
mestamp()
>=20
> Jonathan Cameron <Jonathan.Cameron@huawei.com>
>     iio: accel: bma180: Fix buffer alignment in iio_push_to_buffers_with_ti=
mestamp()
>=20
> Nuno Sa <nuno.sa@analog.com>
>     iio: adis16475: do not return ints in irq handlers
>=20
> Nuno Sa <nuno.sa@analog.com>
>     iio: adis16400: do not return ints in irq handlers
>=20
> Nuno Sa <nuno.sa@analog.com>
>     iio: adis_buffer: do not return ints in irq handlers
>=20
> Arnd Bergmann <arnd@arndb.de>
>     mwifiex: re-fix for unaligned accesses
>=20
> Sergio Paracuellos <sergio.paracuellos@gmail.com>
>     phy: ralink: phy-mt7621-pci: properly print pointer address
>=20
> Christophe JAILLET <christophe.jaillet@wanadoo.fr>
>     tty: nozomi: Fix a resource leak in an error handling function
>=20
> Dan Carpenter <dan.carpenter@oracle.com>
>     serial: 8250_omap: fix a timeout loop condition
>=20
> Michael Walle <michael@walle.cc>
>     serial: fsl_lpuart: remove RTSCTS handling from get_mctrl()
>=20
> Michael Walle <michael@walle.cc>
>     serial: fsl_lpuart: don't modify arbitrary data on lpuart32
>=20
> Paul E. McKenney <paulmck@kernel.org>
>     rcu: Invoke rcu_spawn_core_kthreads() from rcu_spawn_gp_kthread()
>=20
> Stephen Boyd <swboyd@chromium.org>
>     ASoC: rt5682: Disable irq on shutdown
>=20
> Andy Shevchenko <andriy.shevchenko@linux.intel.com>
>     staging: fbtft: Don't spam logs when probe is deferred
>=20
> Andy Shevchenko <andriy.shevchenko@linux.intel.com>
>     staging: fbtft: Rectify GPIO handling
>=20
> Wei Li <liwei391@huawei.com>
>     MIPS: Fix PKMAP with 32-bit MIPS huge page support
>=20
> Leon Romanovsky <leon@kernel.org>
>     RDMA/core: Always release restrack object
>=20
> Leon Romanovsky <leon@kernel.org>
>     RDMA/mlx5: Don't access NULL-cleared mpi pointer
>=20
> Menglong Dong <dong.menglong@zte.com.cn>
>     net: tipc: fix FB_MTU eat two pages
>=20
> Pavel Skripkin <paskripkin@gmail.com>
>     net: sched: fix warning in tcindex_alloc_perfect_hash
>=20
> Vadim Fedorenko <vfedorenko@novek.ru>
>     net: lwtunnel: handle MTU calculation in forwading
>=20
> Muchun Song <songmuchun@bytedance.com>
>     writeback: fix obtain a reference to a freeing memcg css
>=20
> Ravi Bangoria <ravi.bangoria@linux.ibm.com>
>     bpf, x86: Fix extable offset calculation
>=20
> Robert Hancock <robert.hancock@calian.com>
>     clk: si5341: Update initialization magic
>=20
> Robert Hancock <robert.hancock@calian.com>
>     clk: si5341: Check for input clock presence and PLL lock on startup
>=20
> Robert Hancock <robert.hancock@calian.com>
>     clk: si5341: Avoid divide errors due to bogus register contents
>=20
> Robert Hancock <robert.hancock@calian.com>
>     clk: si5341: Wait for DEVICE_READY on startup
>=20
> Jonathan Marek <jonathan@marek.ca>
>     clk: qcom: clk-alpha-pll: fix CAL_L write in alpha_pll_fabia_prepare
>=20
> Cristian Ciocaltea <cristian.ciocaltea@gmail.com>
>     clk: actions: Fix AHPPREDIV-H-AHB clock chain on Owl S500 SoC
>=20
> Cristian Ciocaltea <cristian.ciocaltea@gmail.com>
>     clk: actions: Fix bisp_factor_table based clocks on Owl S500 SoC
>=20
> Cristian Ciocaltea <cristian.ciocaltea@gmail.com>
>     clk: actions: Fix SD clocks factor table on Owl S500 SoC
>=20
> Cristian Ciocaltea <cristian.ciocaltea@gmail.com>
>     clk: actions: Fix UART clock dividers on Owl S500 SoC
>=20
> Taniya Das <tdas@codeaurora.org>
>     clk: qcom: gcc: Add support for a new frequency for SC7280
>=20
> Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
>     Bluetooth: Fix handling of HCI_LE_Advertising_Set_Terminated event
>=20
> Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
>     Bluetooth: Fix Set Extended (Scan Response) Data
>=20
> Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
>     Bluetooth: mgmt: Fix slab-out-of-bounds in tlv_data_is_valid
>=20
> Petr Oros <poros@redhat.com>
>     Revert "be2net: disable bh with spin_lock in be_process_mcc"
>=20
> Bailey Forrest <bcf@google.com>
>     gve: Fix swapped vars when fetching max queues
>=20
> H=C3=A5kon Bugge <haakon.bugge@oracle.com>
>     RDMA/cma: Fix incorrect Packet Lifetime calculation
>=20
> Gary Lin <glin@suse.com>
>     bpfilter: Specify the log level for the kmsg message
>=20
> Vladimir Oltean <vladimir.oltean@nxp.com>
>     net: dsa: sja1105: fix NULL pointer dereference in sja1105_reload_cbs()
>=20
> Sasha Neftin <sasha.neftin@intel.com>
>     e1000e: Check the PCIm state
>=20
> Eric Dumazet <edumazet@google.com>
>     ipv6: fix out-of-bound access in ip6_parse_tlv()
>=20
> Antoine Tenart <atenart@kernel.org>
>     net: atlantic: fix the macsec key length
>=20
> Antoine Tenart <atenart@kernel.org>
>     net: phy: mscc: fix macsec key length
>=20
> Antoine Tenart <atenart@kernel.org>
>     net: macsec: fix the length used to copy the key for offloading
>=20
> H=C3=A5kon Bugge <haakon.bugge@oracle.com>
>     RDMA/cma: Protect RMW with qp_mutex
>=20
> Sukadev Bhattiprolu <sukadev@linux.ibm.com>
>     ibmvnic: free tx_pool if tso_pool alloc fails
>=20
> Sukadev Bhattiprolu <sukadev@linux.ibm.com>
>     ibmvnic: set ltb->buff to NULL after freeing
>=20
> Sukadev Bhattiprolu <sukadev@linux.ibm.com>
>     ibmvnic: account for bufs already saved in indir_buf
>=20
> Sukadev Bhattiprolu <sukadev@linux.ibm.com>
>     ibmvnic: clean pending indirect buffs during reset
>=20
> Dany Madden <drt@linux.ibm.com>
>     Revert "ibmvnic: remove duplicate napi_schedule call in open function"
>=20
> Sukadev Bhattiprolu <sukadev@linux.ibm.com>
>     Revert "ibmvnic: simplify reset_long_term_buff function"
>=20
> Jan Sokolowski <jan.sokolowski@intel.com>
>     i40e: Fix missing rtnl locking when setting up pf switch
>=20
> Mateusz Palczewski <mateusz.palczewski@intel.com>
>     i40e: Fix autoneg disabling for non-10GBaseT links
>=20
> Dinghao Liu <dinghao.liu@zju.edu.cn>
>     i40e: Fix error handling in i40e_vsi_open
>=20
> Maciej =C5=BBenczykowski <maze@google.com>
>     bpf: Do not change gso_size during bpf_skb_change_proto()
>=20
> Norbert Slusarek <nslusarek@gmx.net>
>     can: j1939: j1939_sk_setsockopt(): prevent allocation of j1939 filter f=
or optlen =3D=3D 0
>=20
> Eric Dumazet <edumazet@google.com>
>     ipv6: exthdrs: do not blindly use init_net
>=20
> Jian-Hong Pan <jhp@endlessos.org>
>     net: bcmgenet: Fix attaching to PYH failed on RPi 4B
>=20
> Ping-Ke Shih <pkshih@realtek.com>
>     mac80211: remove iwlwifi specific workaround NDPs of null_response
>=20
> Zhen Lei <thunder.leizhen@huawei.com>
>     drm/msm/dpu: Fix error return code in dpu_mdss_init()
>=20
> Zhen Lei <thunder.leizhen@huawei.com>
>     drm/msm: Fix error return code in msm_drm_init()
>=20
> Kuogee Hsieh <khsieh@codeaurora.org>
>     drm/msm/dp: handle irq_hpd with sink_count =3D 0 correctly
>=20
> John Fastabend <john.fastabend@gmail.com>
>     bpf: Fix null ptr deref with mixed tail calls and subprogs
>=20
> Eric Dumazet <edumazet@google.com>
>     ieee802154: hwsim: avoid possible crash in hwsim_del_edge_nl()
>=20
> Dongliang Mu <mudongliangabcd@gmail.com>
>     ieee802154: hwsim: Fix memory leak in hwsim_add_one
>=20
> Yixing Liu <liuyixing1@huawei.com>
>     RDMA/hns: Fix uninitialized variable
>=20
> Lang Cheng <chenglang@huawei.com>
>     RDMA/hns: Force rewrite inline flag of WQE
>=20
> Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
>     tc-testing: fix list handling
>=20
> Vignesh Raghavendra <vigneshr@ti.com>
>     net: ti: am65-cpsw-nuss: Fix crash when changing number of TX queues
>=20
> Rafa=C5=82 Mi=C5=82ecki <rafal@milecki.pl>
>     net: broadcom: bcm4908_enet: reset DMA rings sw indexes properly
>=20
> Miao Wang <shankerwangmiao@gmail.com>
>     net/ipv4: swap flow ports when validating source
>=20
> Jakub Kicinski <kuba@kernel.org>
>     ip6_tunnel: fix GRE6 segmentation
>=20
> Bui Quang Minh <minhquangbui99@gmail.com>
>     bpf: Fix integer overflow in argument calculation for bpf_map_area_alloc
>=20
> Eric Dumazet <edumazet@google.com>
>     vxlan: add missing rcu_read_lock() in neigh_reduce()
>=20
> Po-Hao Huang <phhuang@realtek.com>
>     rtw88: 8822c: fix lc calibration timing
>=20
> Maciej =C5=BBenczykowski <maze@google.com>
>     bpf: Fix regression on BPF_OBJ_GET with non-O_RDWR flags
>=20
> Luca Coelho <luciano.coelho@intel.com>
>     iwlwifi: increase PNVM load timeout
>=20
> Pablo Neira Ayuso <pablo@netfilter.org>
>     netfilter: nf_tables: do not allow to delete table with owner by handle
>=20
> Pablo Neira Ayuso <pablo@netfilter.org>
>     netfilter: nf_tables: skip netlink portID validation if zero
>=20
> Ayush Sawal <ayush.sawal@chelsio.com>
>     xfrm: Fix xfrm offload fallback fail case
>=20
> Eric Dumazet <edumazet@google.com>
>     pkt_sched: sch_qfq: fix qfq_change_class() error path
>=20
> Eldar Gasanov <eldargasanov2@gmail.com>
>     net: dsa: mv88e6xxx: Fix adding vlan 0
>=20
> Pablo Neira Ayuso <pablo@netfilter.org>
>     netfilter: nf_tables_offload: check FLOW_DISSECTOR_KEY_BASIC in VLAN tr=
ansfer logic
>=20
> Jakub Kicinski <kuba@kernel.org>
>     tls: prevent oversized sendfile() hangs by ignoring MSG_MORE
>=20
> Jakub Kicinski <kuba@kernel.org>
>     selftests: tls: fix chacha+bidir tests
>=20
> Jakub Kicinski <kuba@kernel.org>
>     selftests: tls: clean up uninitialized warnings
>=20
> Yunsheng Lin <linyunsheng@huawei.com>
>     net: sched: add barrier to ensure correct ordering for lockless qdisc
>=20
> Antoine Tenart <atenart@kernel.org>
>     vrf: do not push non-ND strict packets with a source LLA through packet=
 taps again
>=20
> Pavel Skripkin <paskripkin@gmail.com>
>     net: ethernet: ezchip: fix error handling
>=20
> Pavel Skripkin <paskripkin@gmail.com>
>     net: ethernet: ezchip: fix UAF in nps_enet_remove
>=20
> Pavel Skripkin <paskripkin@gmail.com>
>     net: ethernet: aeroflex: fix UAF in greth_of_remove
>=20
> Shayne Chen <shayne.chen@mediatek.com>
>     mt76: mt7915: fix rx fcs error count in testmode
>=20
> Sean Wang <sean.wang@mediatek.com>
>     mt76: mt7921: fix OMAC idx usage
>=20
> Colin Ian King <colin.king@canonical.com>
>     mt76: mt7921: remove redundant check on type
>=20
> Lorenzo Bianconi <lorenzo@kernel.org>
>     mt76: connac: alaways wake the device before scanning
>=20
> Sean Wang <sean.wang@mediatek.com>
>     mt76: mt7921: consider the invalid value for to_rssi
>=20
> YN Chen <yn.chen@mediatek.com>
>     mt76: connac: fix WoW with disconnetion and bitmap pattern
>=20
> Sean Wang <sean.wang@mediatek.com>
>     mt76: mt7921: Don't alter Rx path classifier
>=20
> Lorenzo Bianconi <lorenzo@kernel.org>
>     mt76: mt7615: fix NULL pointer dereference in tx_prepare_skb()
>=20
> Lorenzo Bianconi <lorenzo@kernel.org>
>     mt76: fix possible NULL pointer dereference in mt76_tx
>=20
> Pavel Machek <pavel@denx.de>
>     net: pxa168_eth: Fix a potential data race in pxa168_eth_remove
>=20
> Wang Hai <wanghai38@huawei.com>
>     samples/bpf: Fix the error return code of xdp_redirect's main()
>=20
> Wang Hai <wanghai38@huawei.com>
>     samples/bpf: Fix Segmentation fault for xdp_redirect command
>=20
> Jack Wang <jinpu.wang@cloud.ionos.com>
>     RDMA/rtrs-srv: Set minimal max_send_wr and max_recv_wr
>=20
> Tony Ambardar <tony.ambardar@gmail.com>
>     bpf: Fix libelf endian handling in resolv_btfids
>=20
> Magnus Karlsson <magnus.karlsson@intel.com>
>     xsk: Fix broken Tx ring validation
>=20
> Magnus Karlsson <magnus.karlsson@intel.com>
>     xsk: Fix missing validation for skb and unaligned mode
>=20
> Daniel Xu <dxu@dxuuu.xyz>
>     selftests/bpf: Whitelist test_progs.h from .gitignore
>=20
> Bob Pearson <rpearsonhpe@gmail.com>
>     RDMA/rxe: Fix qp reference counting for atomic ops
>=20
> Pablo Neira Ayuso <pablo@netfilter.org>
>     netfilter: nft_tproxy: restrict support to TCP and UDP transport protoc=
ols
>=20
> Pablo Neira Ayuso <pablo@netfilter.org>
>     netfilter: nft_osf: check for TCP packet before further processing
>=20
> Pablo Neira Ayuso <pablo@netfilter.org>
>     netfilter: nft_exthdr: check for IPv6 packet before further processing
>=20
> Leon Romanovsky <leon@kernel.org>
>     RDMA/mlx5: Don't add slave port to unaffiliated list
>=20
> Liu Shixin <liushixin2@huawei.com>
>     netlabel: Fix memory leak in netlbl_mgmt_add_common
>=20
> Johannes Berg <johannes.berg@intel.com>
>     wil6210: remove erroneous wiphy locking
>=20
> Seevalamuthu Mariappan <seevalam@codeaurora.org>
>     ath11k: send beacon template after vdev_start/restart during csa
>=20
> Yang Li <yang.lee@linux.alibaba.com>
>     ath10k: Fix an error code in ath10k_add_interface()
>=20
> Christophe JAILLET <christophe.jaillet@wanadoo.fr>
>     ath11k: Fix an error handling path in ath11k_core_fetch_board_data_api_=
n()
>=20
> Hang Zhang <zh.nvgt@gmail.com>
>     cw1200: Revert unnecessary patches that fix unreal use-after-free bugs
>=20
> Christophe JAILLET <christophe.jaillet@wanadoo.fr>
>     brcmsmac: mac80211_if: Fix a resource leak in an error handling path
>=20
> Matthias Brugger <mbrugger@suse.com>
>     brcmfmac: Delete second brcm folder hierarchy
>=20
> Tong Tiangen <tongtiangen@huawei.com>
>     brcmfmac: Fix a double-free in brcmf_sdio_bus_reset
>=20
> Alvin =C5=A0ipraga <ALSI@bang-olufsen.dk>
>     brcmfmac: correctly report average RSSI in station info
>=20
> Alvin =C5=A0ipraga <ALSI@bang-olufsen.dk>
>     brcmfmac: fix setting of station info chains bitmask
>=20
> Zhen Lei <thunder.leizhen@huawei.com>
>     ssb: Fix error return code in ssb_bus_scan()
>=20
> Bryan O'Donoghue <bryan.odonoghue@linaro.org>
>     wcn36xx: Move hal_buf allocation to devm_kmalloc in probe
>=20
> Lucas Stach <l.stach@pengutronix.de>
>     clk: imx8mq: remove SYS PLL 1/2 clock gates
>=20
> Dongliang Mu <mudongliangabcd@gmail.com>
>     ieee802154: hwsim: Fix possible memory leak in hwsim_subscribe_all_othe=
rs
>=20
> Randy Dunlap <rdunlap@infradead.org>
>     wireless: carl9170: fix LEDS build errors & warnings
>=20
> Yang Yingliang <yangyingliang@huawei.com>
>     ath10k: add missing error return code in ath10k_pci_probe()
>=20
> Yang Yingliang <yangyingliang@huawei.com>
>     ath10k: go to path err_unsupported when chip id is not supported
>=20
> Zhihao Cheng <chengzhihao1@huawei.com>
>     tools/bpftool: Fix error return code in do_batch()
>=20
> Colin Ian King <colin.king@canonical.com>
>     drm: qxl: ensure surf.data is ininitialized
>=20
> Luca Ceresoli <luca@lucaceresoli.net>
>     clk: vc5: fix output disabling when enabling a FOD
>=20
> Maxime Ripard <maxime@cerno.tech>
>     drm/vc4: hdmi: Fix error path of hpd-gpios
>=20
> Kees Cook <keescook@chromium.org>
>     drm/pl111: Actually fix CONFIG_VEXPRESS_CONFIG depends
>=20
> Kamal Heib <kamalheib1@gmail.com>
>     RDMA/rxe: Fix failure during driver load
>=20
> Kees Cook <keescook@chromium.org>
>     drm/pl111: depend on CONFIG_VEXPRESS_CONFIG
>=20
> Leon Romanovsky <leon@kernel.org>
>     RDMA/core: Sanitize WQ state received from the userspace
>=20
> Boris Sukholitko <boris.sukholitko@broadcom.com>
>     net/sched: act_vlan: Fix modify to allow 0
>=20
> Xin Long <lucien.xin@gmail.com>
>     xfrm: remove the fragment check for ipv6 beet mode
>=20
> Dmitry Osipenko <digetx@gmail.com>
>     clk: tegra30: Use 300MHz for video decoder by default
>=20
> Zhen Lei <thunder.leizhen@huawei.com>
>     ehea: fix error return code in ehea_restart_qps()
>=20
> Gioh Kim <gi-oh.kim@cloud.ionos.com>
>     RDMA/rtrs-clt: Fix memory leak of not-freed sess->stats and stats->pcpu=
_stats
>=20
> Md Haris Iqbal <haris.iqbal@cloud.ionos.com>
>     RDMA/rtrs-clt: Check if the queue_depth has changed during a reconnecti=
on
>=20
> Jack Wang <jinpu.wang@cloud.ionos.com>
>     RDMA/rtrs-srv: Fix memory leak when having multiple sessions
>=20
> Gioh Kim <gi-oh.kim@cloud.ionos.com>
>     RDMA/rtrs-srv: Fix memory leak of unfreed rtrs_srv_stats object
>=20
> Gioh Kim <gi-oh.kim@cloud.ionos.com>
>     RDMA/rtrs: Do not reset hb_missed_max after re-connection
>=20
> Md Haris Iqbal <haris.iqbal@cloud.ionos.com>
>     RDMA/rtrs-clt: Check state of the rtrs_clt_sess before reading its stats
>=20
> Bart Van Assche <bvanassche@acm.org>
>     RDMA/srp: Fix a recently introduced memory leak
>=20
> Jianguo Wu <wujianguo@chinatelecom.cn>
>     mptcp: generate subflow hmac after mptcp_finish_join()
>=20
> Jianguo Wu <wujianguo@chinatelecom.cn>
>     mptcp: fix pr_debug in mptcp_token_new_connect
>=20
> Colin Ian King <colin.king@canonical.com>
>     drm/rockchip: cdn-dp: fix sign extension on an int multiply for a u64 r=
esult
>=20
> Christophe JAILLET <christophe.jaillet@wanadoo.fr>
>     drm/rockchip: lvds: Fix an error handling path
>=20
> Thomas Hebb <tommyhebb@gmail.com>
>     drm/rockchip: dsi: move all lane config except LCDC mux to bind()
>=20
> Yang Yingliang <yangyingliang@huawei.com>
>     drm/rockchip: cdn-dp-core: add missing clk_disable_unprepare() on error=
 in cdn_dp_grf_write()
>=20
> Alex Bee <knaerzche@gmail.com>
>     drm: rockchip: set alpha_en to 0 if it is not used
>=20
> Maxime Ripard <maxime@cerno.tech>
>     drm/vc4: crtc: Lookup the encoder from the register at boot
>=20
> Maxime Ripard <maxime@cerno.tech>
>     drm/vc4: crtc: Fix vc4_get_crtc_encoder logic
>=20
> Maxime Ripard <maxime@cerno.tech>
>     drm/vc4: crtc: Pass the drm_atomic_state to config_pv
>=20
> Yang Yingliang <yangyingliang@huawei.com>
>     net: ftgmac100: add missing error return code in ftgmac100_probe()
>=20
> Aurabindo Pillai <aurabindo.pillai@amd.com>
>     drm/amd/display: take dc_lock in short pulse handler only
>=20
> Zhan Liu <zhan.liu@amd.com>
>     drm/amd/display: Avoid HPD IRQ in GPU reset state
>=20
> Roman Li <Roman.Li@amd.com>
>     drm/amd/display: fix potential gpu reset deadlock
>=20
> Jerome Brunet <jbrunet@baylibre.com>
>     clk: meson: g12a: fix gp0 and hifi ranges
>=20
> Wei Yongjun <weiyongjun1@huawei.com>
>     net: qrtr: ns: Fix error return code in qrtr_ns_init()
>=20
> Thomas Hellstrom <thellstrom@vmware.com>
>     drm/vmwgfx: Fix cpu updates of coherent multisample surfaces
>=20
> Thomas Hellstrom <thellstrom@vmware.com>
>     drm/vmwgfx: Mark a surface gpu-dirty after the SVGA3dCmdDXGenMips comma=
nd
>=20
> Yixian Liu <liuyixian@huawei.com>
>     RDMA/hns: Remove the condition of light load for posting DWQE
>=20
> Geert Uytterhoeven <geert+renesas@glider.be>
>     pinctrl: renesas: r8a77990: JTAG pins do not have pull-down capabilities
>=20
> Geert Uytterhoeven <geert+renesas@glider.be>
>     pinctrl: renesas: r8a7796: Add missing bias for PRESET# pin
>=20
> Andy Shevchenko <andriy.shevchenko@linux.intel.com>
>     net: pch_gbe: Propagate error from devm_gpio_request_one()
>=20
> Andy Shevchenko <andy.shevchenko@gmail.com>
>     net: mvpp2: Put fwnode in error case during ->probe()
>=20
> Lucas Stach <l.stach@pengutronix.de>
>     drm/imx: ipuv3-plane: fix PRG modifiers after drm managed resource conv=
ersion
>=20
> Philipp Zabel <p.zabel@pengutronix.de>
>     drm/imx: ipuv3-plane: do not advertise YUV formats on planes without CSC
>=20
> Christophe JAILLET <christophe.jaillet@wanadoo.fr>
>     video: fbdev: imxfb: Fix an error message
>=20
> Takashi Iwai <tiwai@suse.de>
>     drm/ast: Fix missing conversions to managed API
>=20
> Yingjie Wang <wangyingjie55@126.com>
>     drm/amd/dc: Fix a missing check bug in dm_dp_mst_detect()
>=20
> Douglas Anderson <dianders@chromium.org>
>     drm/bridge: Fix the stop condition of drm_bridge_chain_pre_enable()
>=20
> Robert Foss <robert.foss@linaro.org>
>     drm/bridge/sii8620: fix dependency on extcon
>=20
> Sabrina Dubroca <sd@queasysnail.net>
>     xfrm: xfrm_state_mtu should return at least 1280 for ipv6
>=20
> Liu Shixin <liushixin2@huawei.com>
>     mm/page_alloc: fix counting of managed_pages
>=20
> Waiman Long <longman@redhat.com>
>     mm: memcg/slab: properly set up gfp flags for objcg pointer array
>=20
> Miaohe Lin <linmiaohe@huawei.com>
>     mm/shmem: fix shmem_swapin() race with swapoff
>=20
> Miaohe Lin <linmiaohe@huawei.com>
>     swap: fix do_swap_page() race with swapoff
>=20
> Nicolas Saenz Julienne <nsaenzju@redhat.com>
>     mm: mmap_lock: use local locks instead of disabling preemption
>=20
> Anshuman Khandual <anshuman.khandual@arm.com>
>     mm/debug_vm_pgtable: ensure THP availability via has_transparent_hugepa=
ge()
>=20
> Jan Kara <jack@suse.cz>
>     dax: fix ENOMEM handling in grab_mapping_entry()
>=20
> Dan Carpenter <dan.carpenter@oracle.com>
>     ocfs2: fix snprintf() checking
>=20
> Ming Lei <ming.lei@redhat.com>
>     blk-mq: update hctx->dispatch_busy in case of real scheduler
>=20
> Edward Hsieh <edwardh@synology.com>
>     block: fix trace completion for chained bio
>=20
> Chanwoo Choi <cw00.choi@samsung.com>
>     PM / devfreq: passive: Fix get_target_freq when not using required-opp
>=20
> Rafael J. Wysocki <rafael.j.wysocki@intel.com>
>     cpufreq: Make cpufreq_online() call driver->offline() on errors
>=20
> Nathan Chancellor <nathan@kernel.org>
>     ACPI: bgrt: Fix CFI violation
>=20
> Zhang Yi <yi.zhang@huawei.com>
>     blk-wbt: make sure throttle is enabled properly
>=20
> Zhang Yi <yi.zhang@huawei.com>
>     blk-wbt: introduce a new disable state to prevent false positive by rwb=
_enabled()
>=20
> Randy Dunlap <rdunlap@infradead.org>
>     EDAC/igen6: fix core dependency
>=20
> Xiaofei Tan <tanxiaofei@huawei.com>
>     ACPI: APEI: fix synchronous external aborts in user-mode
>=20
> Matti Vaittinen <matti.vaittinen@fi.rohmeurope.com>
>     extcon: extcon-max8997: Fix IRQ freeing at error path
>=20
> Tony Lindgren <tony@atomide.com>
>     clocksource/drivers/timer-ti-dm: Save and restore timer TIOCP_CFG
>=20
> Guoqing Jiang <jgq516@gmail.com>
>     md: revert io stats accounting
>=20
> Christoph Hellwig <hch@lst.de>
>     mark pstore-blk as broken
>=20
> Krzysztof Wilczy=C5=84ski <kw@linux.com>
>     ACPI: sysfs: Fix a buffer overrun problem with description_show()
>=20
> Jing Xiangfeng <jingxiangfeng@huawei.com>
>     ACPI: tables: FPDT: Add missing acpi_put_table() in acpi_init_fpdt()
>=20
> Mario Limonciello <mario.limonciello@amd.com>
>     nvme-pci: look for StorageD3Enable on companion ACPI device instead
>=20
> Praveen Kumar <kumarpraveen@linux.microsoft.com>
>     x86/hyperv: fix logical processor creation
>=20
> Ming Lei <ming.lei@redhat.com>
>     block: avoid double io accounting for flush request
>=20
> Rafael J. Wysocki <rafael.j.wysocki@intel.com>
>     ACPI: PM / fan: Put fan device IDs into separate header file
>=20
> YueHaibing <yuehaibing@huawei.com>
>     PM / devfreq: Add missing error code in devfreq_add_device()
>=20
> Arnd Bergmann <arnd@arndb.de>
>     EDAC/aspeed: Use proper format string for printing resource
>=20
> Dafna Hirschfeld <dafna.hirschfeld@collabora.com>
>     media: mtk-vpu: on suspend, read/write regs only if vpu is running
>=20
> Philipp Zabel <p.zabel@pengutronix.de>
>     media: video-mux: Skip dangling endpoints
>=20
> Sean Christopherson <seanjc@google.com>
>     KVM: selftests: Remove errant asm/barrier.h include to fix arm64 build
>=20
> Hou Wenlong <houwenlong93@linux.alibaba.com>
>     KVM: selftests: fix triple fault if ept=3D0 in dirty_log_test
>=20
> Zhaoyang Huang <zhaoyang.huang@unisoc.com>
>     psi: Fix race between psi_trigger_create/destroy
>=20
> Herbert Xu <herbert@gondor.apana.org.au>
>     crypto: nx - Fix RCU warning in nx842_OF_upd_status
>=20
> Mirko Vogt <mirko-dev|linux@nanl.de>
>     spi: spi-sun6i: Fix chipselect/clock bug
>=20
> Peter Zijlstra <peterz@infradead.org>
>     lockdep/selftests: Fix selftests vs PROVE_RAW_LOCK_NESTING
>=20
> Peter Zijlstra <peterz@infradead.org>
>     lockdep: Fix wait-type for empty stack
>=20
> Qais Yousef <qais.yousef@arm.com>
>     sched/uclamp: Fix uclamp_tg_restrict()
>=20
> Vincent Donnefort <vincent.donnefort@arm.com>
>     sched/rt: Fix Deadline utilization tracking during policy change
>=20
> Vincent Donnefort <vincent.donnefort@arm.com>
>     sched/rt: Fix RT utilization tracking during policy change
>=20
> Joerg Roedel <jroedel@suse.de>
>     x86/sev: Split up runtime #VC handler for correct state tracking
>=20
> Joerg Roedel <jroedel@suse.de>
>     x86/sev: Make sure IRQs are disabled while GHCB is active
>=20
> David Sterba <dsterba@suse.com>
>     btrfs: clear log tree recovering status if starting transaction fails
>=20
> Axel Lin <axel.lin@ingics.com>
>     regulator: hi6421v600: Fix setting idle mode
>=20
> Axel Lin <axel.lin@ingics.com>
>     regulator: hi655x: Fix pass wrong pointer to config.driver_data
>=20
> Alexandru Elisei <alexandru.elisei@arm.com>
>     KVM: arm64: Don't zero the cycle count register when PMCR_EL0.P is set
>=20
> Tuan Phan <tuanphan@os.amperecomputing.com>
>     perf/arm-cmn: Fix invalid pointer when access dtc object sharing the sa=
me IRQ number
>=20
> Kai Huang <kai.huang@intel.com>
>     KVM: x86/mmu: Fix pf_fixed count in tdp_mmu_map_handle_target_level()
>=20
> Sean Christopherson <seanjc@google.com>
>     KVM: x86/mmu: Drop redundant trace_kvm_mmu_set_spte() in the TDP MMU
>=20
> Kai Huang <kai.huang@intel.com>
>     KVM: x86/mmu: Fix return value in tdp_mmu_map_handle_target_level()
>=20
> Sean Christopherson <seanjc@google.com>
>     KVM: nVMX: Don't clobber nested MMU's A/D status on EPTP switch
>=20
> Sean Christopherson <seanjc@google.com>
>     KVM: nVMX: Ensure 64-bit shift when checking VMFUNC bitmap
>=20
> Sean Christopherson <seanjc@google.com>
>     KVM: nVMX: Sync all PGDs on nested transition with shadow paging
>=20
> Guenter Roeck <linux@roeck-us.net>
>     hwmon: (max31790) Fix fan speed reporting for fan7..12
>=20
> Guenter Roeck <linux@roeck-us.net>
>     hwmon: (max31722) Remove non-standard ACPI device IDs
>=20
> Guenter Roeck <linux@roeck-us.net>
>     hwmon: (lm70) Revert "hwmon: (lm70) Add support for ACPI"
>=20
> Jacopo Mondi <jacopo+renesas@jmondi.org>
>     media: i2c: rdacm21: Power up OV10640 before OV490
>=20
> Jacopo Mondi <jacopo+renesas@jmondi.org>
>     media: i2c: rdacm21: Fix OV10640 powerup
>=20
> Dillon Min <dillon.minfei@gmail.com>
>     media: s5p-g2d: Fix a memory leak on ctx->fh.m2m_ctx
>=20
> Arnd Bergmann <arnd@arndb.de>
>     media: subdev: remove VIDIOC_DQEVENT_TIME32 handling
>=20
> Arnd Bergmann <arnd@arndb.de>
>     media: v4l2-core: ignore native time32 ioctls on 64-bit
>=20
> Anshuman Khandual <anshuman.khandual@arm.com>
>     arm64/mm: Fix ttbr0 values stored in struct thread_info for software-pan
>=20
> Zhen Lei <thunder.leizhen@huawei.com>
>     mmc: usdhi6rol0: fix error return code in usdhi6_probe()
>=20
> Hongbo Li <herberthbli@tencent.com>
>     crypto: sm2 - fix a memory leak in sm2
>=20
> Hangbin Liu <liuhangbin@gmail.com>
>     crypto: x86/curve25519 - fix cpu feature checking logic in mod_exit
>=20
> Zhang Qilong <zhangqilong3@huawei.com>
>     crypto: omap-sham - Fix PM reference leak in omap sham ops
>=20
> Tong Tiangen <tongtiangen@huawei.com>
>     crypto: nitrox - fix unchecked variable in nitrox_register_interrupts
>=20
> Axel Lin <axel.lin@ingics.com>
>     regulator: fan53880: Fix vsel_mask setting for FAN53880_BUCK
>=20
> Gustavo A. R. Silva <gustavoars@kernel.org>
>     media: siano: Fix out-of-bounds warnings in smscore_load_firmware_famil=
y2()
>=20
> Randy Dunlap <rdunlap@infradead.org>
>     m68k: atari: Fix ATARI_KBD_CORE kconfig unmet dependency warning
>=20
> Johan Hovold <johan@kernel.org>
>     media: gspca/gl860: fix zero-length control requests
>=20
> Joe Richey <joerichey@google.com>
>     media: vicodec: Use _BITUL() macro in UAPI headers
>=20
> Zhen Lei <thunder.leizhen@huawei.com>
>     media: tc358743: Fix error return code in tc358743_probe_of()
>=20
> Dan Carpenter <dan.carpenter@oracle.com>
>     media: au0828: fix a NULL vs IS_ERR() check
>=20
> Lv Yunlong <lyl2019@mail.ustc.edu.cn>
>     media: exynos4-is: Fix a use after free in isp_video_release
>=20
> Ezequiel Garcia <ezequiel@collabora.com>
>     media: rkvdec: Fix .buf_prepare
>=20
> Andy Shevchenko <andy.shevchenko@gmail.com>
>     media: ipu3-cio2: Fix reference counting when looping over ACPI devices
>=20
> Valentin Schneider <valentin.schneider@arm.com>
>     sched: Don't defer CPU pick to migration_cpu_stop()
>=20
> Randy Dunlap <rdunlap@infradead.org>
>     locking/lockdep: Reduce LOCKDEP dependency list
>=20
> Sergey Shtylyov <s.shtylyov@omprussia.ru>
>     pata_ep93xx: fix deferred probing
>=20
> Christophe JAILLET <christophe.jaillet@wanadoo.fr>
>     media: rc: i2c: Fix an error message
>=20
> Christophe JAILLET <christophe.jaillet@wanadoo.fr>
>     crypto: ccp - Fix a resource leak in an error handling path
>=20
> Suman Anna <s-anna@ti.com>
>     crypto: sa2ul - Fix pm_runtime enable in sa_ul_probe()
>=20
> Suman Anna <s-anna@ti.com>
>     crypto: sa2ul - Fix leaks on failure paths with sa_dma_init()
>=20
> Joe Richey <joerichey@google.com>
>     x86/elf: Use _BITUL() macro in UAPI headers
>=20
> Mimi Zohar <zohar@linux.ibm.com>
>     evm: fix writing <securityfs>/evm overflow
>=20
> Sergey Shtylyov <s.shtylyov@omp.ru>
>     pata_octeon_cf: avoid WARN_ON() in ata_host_activate()
>=20
> Josh Poimboeuf <jpoimboe@redhat.com>
>     kbuild: Fix objtool dependency for 'OBJECT_FILES_NON_STANDARD_<obj> :=
=3D n'
>=20
> Qais Yousef <qais.yousef@arm.com>
>     sched/uclamp: Fix locking around cpu_util_update_eff()
>=20
> Qais Yousef <qais.yousef@arm.com>
>     sched/uclamp: Fix wrong implementation of cpu.uclamp.min
>=20
> Randy Dunlap <rdunlap@infradead.org>
>     media: I2C: change 'RST' to "RSET" to fix multiple build errors
>=20
> Sergey Shtylyov <s.shtylyov@omprussia.ru>
>     pata_rb532_cf: fix deferred probing
>=20
> Sergey Shtylyov <s.shtylyov@omprussia.ru>
>     sata_highbank: fix deferred probing
>=20
> Zhen Lei <thunder.leizhen@huawei.com>
>     crypto: ux500 - Fix error return code in hash_hw_final()
>=20
> Corentin Labbe <clabbe@baylibre.com>
>     crypto: ixp4xx - update IV after requests
>=20
> Corentin Labbe <clabbe@baylibre.com>
>     crypto: ixp4xx - dma_unmap the correct address
>=20
> Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
>     media: hantro: do a PM resume earlier
>=20
> Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
>     media: i2c: ccs-core: return the right error code at suspend
>=20
> Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
>     media: s5p_cec: decrement usage count if disabled
>=20
> Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
>     media: venus: Rework error fail recover logic
>=20
> Andy Shevchenko <andriy.shevchenko@linux.intel.com>
>     spi: Avoid undefined behaviour when counting unused native CSs
>=20
> Andy Shevchenko <andriy.shevchenko@linux.intel.com>
>     spi: Allow to have all native CSs in use along with GPIOs
>=20
> Daniel Axtens <dja@axtens.net>
>     mm: define default MAX_PTRS_PER_* in include/pgtable.h
>=20
> Roman Gushchin <guro@fb.com>
>     writeback, cgroup: increment isw_nr_in_flight before grabbing an inode
>=20
> Arnd Bergmann <arnd@arndb.de>
>     ia64: mca_drv: fix incorrect array size calculation
>=20
> Petr Mladek <pmladek@suse.com>
>     kthread_worker: fix return value when kthread_mod_delayed_work() races =
with kthread_cancel_delayed_work_sync()
>=20
> Ming Lei <ming.lei@redhat.com>
>     block: fix discard request merge
>=20
> Shawn Guo <shawn.guo@linaro.org>
>     mailbox: qcom: Use PLATFORM_DEVID_AUTO to register platform device
>=20
> Jan Kara <jack@suse.cz>
>     bfq: Remove merged request already in bfq_requests_merged()
>=20
> Steve French <stfrench@microsoft.com>
>     cifs: fix missing spinlock around update to ses->status
>=20
> Jason Gerecke <killertofu@gmail.com>
>     HID: wacom: Correct base usage for capacitive ExpressKey status bits
>=20
> Steve French <stfrench@microsoft.com>
>     smb3: fix possible access to uninitialized pointer to DACL
>=20
> Richard Fitzgerald <rf@opensource.cirrus.com>
>     ACPI: tables: Add custom DSDT file as makefile prerequisite
>=20
> Javier Martinez Canillas <javierm@redhat.com>
>     tpm_tis_spi: add missing SPI device ID entries
>=20
> Paul E. McKenney <paulmck@kernel.org>
>     clocksource: Check per-CPU clock synchronization when marked unstable
>=20
> Paul E. McKenney <paulmck@kernel.org>
>     clocksource: Retry clock read if long delays detected
>=20
> Zhang Rui <rui.zhang@intel.com>
>     ACPI: EC: trust DSDT GPE for certain HP laptop
>=20
> Steve French <stfrench@microsoft.com>
>     smb3: fix uninitialized value for port in witness protocol move
>=20
> Paulo Alcantara <pc@cjr.nz>
>     cifs: fix check of dfs interlinks
>=20
> Ronnie Sahlberg <lsahlber@redhat.com>
>     cifs: improve fallocate emulation
>=20
> Haiyang Zhang <haiyangz@microsoft.com>
>     PCI: hv: Add check for hyperv_initialized in init_hv_pci_drv()
>=20
> Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>
>     tools/power/x86/intel-speed-select: Fix uncore memory frequency display
>=20
> Tony Luck <tony.luck@intel.com>
>     EDAC/Intel: Do not load EDAC driver when running as a guest
>=20
> Hannes Reinecke <hare@suse.de>
>     nvmet-fc: do not check for invalid target port in nvmet_fc_handle_fcp_r=
qst()
>=20
> JK Kim <jongkang.kim2@gmail.com>
>     nvme-pci: fix var. type for increasing cq_head
>=20
> Jiapeng Chong <jiapeng.chong@linux.alibaba.com>
>     platform/x86: toshiba_acpi: Fix missing error code in toshiba_acpi_setu=
p_keyboard()
>=20
> Luke D. Jones <luke@ljones.dev>
>     platform/x86: asus-nb-wmi: Revert "add support for ASUS ROG Zephyrus G1=
4 and G15"
>=20
> Luke D. Jones <luke@ljones.dev>
>     platform/x86: asus-nb-wmi: Revert "Drop duplicate DMI quirk structures"
>=20
> Ming Lei <ming.lei@redhat.com>
>     block: fix race between adding/removing rq qos and normal IO
>=20
> Pascal Giard <pascal.giard@etsmtl.ca>
>     HID: sony: fix freeze when inserting ghlive ps3/wii dongles
>=20
> Zoltan Tamas Vajda <zoltan.tamas.vajda@gmail.com>
>     HID: hid-input: add Surface Go battery quirk
>=20
> Hui Wang <hui.wang@canonical.com>
>     ACPI: resources: Add checks for ACPI IRQ override
>=20
> Hanjun Guo <guohanjun@huawei.com>
>     ACPI: bus: Call kobject_put() in acpi_init() error path
>=20
> Erik Kaneda <erik.kaneda@intel.com>
>     ACPICA: Fix memory leak caused by _CID repair function
>=20
> Alexander Aring <aahringo@redhat.com>
>     fs: dlm: fix memory leak when fenced
>=20
> Alexander Aring <aahringo@redhat.com>
>     fs: dlm: fix lowcomms_start error case
>=20
> Jiapeng Chong <jiapeng.chong@linux.alibaba.com>
>     drivers: hv: Fix missing error code in vmbus_connect()
>=20
> Christian Brauner <christian.brauner@ubuntu.com>
>     open: don't silently ignore unknown O-flags in openat2()
>=20
> Richard Fitzgerald <rf@opensource.cirrus.com>
>     random32: Fix implicit truncation warning in prandom_seed_state()
>=20
> Alexander Aring <aahringo@redhat.com>
>     fs: dlm: cancel work sync othercon
>=20
> Alexander Aring <aahringo@redhat.com>
>     fs: dlm: reconnect if socket error report occurs
>=20
> Ming Lei <ming.lei@redhat.com>
>     blk-mq: clear stale request in tags->rq[] before freeing one request po=
ol
>=20
> Ming Lei <ming.lei@redhat.com>
>     blk-mq: grab rq->refcount before calling ->fn in blk_mq_tagset_busy_iter
>=20
> zhangyi (F) <yi.zhang@huawei.com>
>     block_dump: remove block_dump feature in mark_inode_dirty()
>=20
> Chris Chiu <chris.chiu@canonical.com>
>     ACPI: EC: Make more Asus laptops use ECDT _GPE
>=20
> Hans de Goede <hdegoede@redhat.com>
>     platform/x86: touchscreen_dmi: Add info for the Goodix GT912 panel of T=
M800A550L tablets
>=20
> Hans de Goede <hdegoede@redhat.com>
>     platform/x86: touchscreen_dmi: Add an extra entry for the upside down G=
oodix touchscreen on Teclast X89 tablets
>=20
> Hans de Goede <hdegoede@redhat.com>
>     Input: goodix - platform/x86: touchscreen_dmi - Move upside down quirks=
 to touchscreen_dmi.c
>=20
> Richard Fitzgerald <rf@opensource.cirrus.com>
>     lib: vsprintf: Fix handling of number field widths in vsscanf
>=20
> YueHaibing <yuehaibing@huawei.com>
>     hv_utils: Fix passing zero to 'PTR_ERR' warning
>=20
> Mario Limonciello <mario.limonciello@amd.com>
>     ACPI: processor idle: Fix up C-state latency if not ordered
>=20
> Alex Deucher <alexander.deucher@amd.com>
>     ACPI: PM: s2idle: Add missing LPS0 functions for AMD
>=20
> Bixuan Cui <cuibixuan@huawei.com>
>     EDAC/ti: Add missing MODULE_DEVICE_TABLE
>=20
> Dmitry Torokhov <dmitry.torokhov@gmail.com>
>     HID: do not use down_interruptible() when unbinding devices
>=20
> Luke D Jones <luke@ljones.dev>
>     ACPI: video: use native backlight for GA401/GA502/GA503
>=20
> Shuah Khan <skhan@linuxfoundation.org>
>     media: Fix Media Controller API config checks
>=20
> Axel Lin <axel.lin@ingics.com>
>     regulator: da9052: Ensure enough delay time for .set_voltage_time_sel
>=20
> Hsin-Hsiung Wang <hsin-hsiung.wang@mediatek.com>
>     regulator: mt6358: Fix vdram2 .vsel_mask
>=20
> Heiko Carstens <hca@linux.ibm.com>
>     KVM: s390: get rid of register asm usage
>=20
> Boqun Feng <boqun.feng@gmail.com>
>     lockding/lockdep: Avoid to find wrong lock dep path in check_irq_usage()
>=20
> Boqun Feng <boqun.feng@gmail.com>
>     locking/lockdep: Fix the dep path printing for backwards BFS
>=20
> Christophe Leroy <christophe.leroy@csgroup.eu>
>     btrfs: disable build on platforms having page size 256K
>=20
> Qu Wenruo <wqu@suse.com>
>     btrfs: don't clear page extent mapped if we're not invalidating the ful=
l page
>=20
> David Sterba <dsterba@suse.com>
>     btrfs: sysfs: fix format string for some discard stats
>=20
> Josef Bacik <josef@toxicpanda.com>
>     btrfs: always abort the transaction if we abort a trans handle
>=20
> Josef Bacik <josef@toxicpanda.com>
>     btrfs: abort transaction if we fail to update the delayed inode
>=20
> Josef Bacik <josef@toxicpanda.com>
>     btrfs: fix error handling in __btrfs_update_delayed_inode
>=20
> Suraj Jitindar Singh <sjitindarsingh@gmail.com>
>     KVM: PPC: Book3S HV: Fix TLB management on SMT8 POWER9 and POWER10 proc=
essors
>=20
> Marc Zyngier <maz@kernel.org>
>     KVM: arm64: Restore PMU configuration on first run
>=20
> Jing Xiangfeng <jingxiangfeng@huawei.com>
>     drivers/perf: fix the missed ida_simple_remove() in ddr_perf_probe()
>=20
> Lukasz Luba <lukasz.luba@arm.com>
>     sched/fair: Take thermal pressure into account while estimating energy
>=20
> Guenter Roeck <linux@roeck-us.net>
>     hwmon: (max31790) Fix pwmX_enable attributes
>=20
> Guenter Roeck <linux@roeck-us.net>
>     hwmon: (max31790) Report correct current pwm duty cycles
>=20
> Steve Longerbeam <slongerbeam@gmail.com>
>     media: imx-csi: Skip first few frames from a BT.656 source
>=20
> Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
>     media: siano: fix device register error path
>=20
> Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
>     media: dvbdev: fix error logic at dvb_register_device()
>=20
> Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
>     media: dvb_net: avoid speculation from net slot
>=20
> Ard Biesheuvel <ardb@kernel.org>
>     crypto: shash - avoid comparing pointers to exported functions under CFI
>=20
> Axel Lin <axel.lin@ingics.com>
>     regulator: mt6315: Fix checking return value of devm_regmap_init_spmi_e=
xt
>=20
> zpershuai <zpershuai@gmail.com>
>     spi: meson-spicc: fix memory leak in meson_spicc_probe
>=20
> zpershuai <zpershuai@gmail.com>
>     spi: meson-spicc: fix a wrong goto jump for avoiding memory leak.
>=20
> Andrew Jeffery <andrew@aj.id.au>
>     mmc: sdhci-of-aspeed: Turn down a phase correction warning
>=20
> Zheyu Ma <zheyuma97@gmail.com>
>     mmc: via-sdmmc: add a check against NULL pointer dereference
>=20
> Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>
>     mmc: sdhci-sprd: use sdhci_sprd_writew
>=20
> Tong Zhang <ztong0001@gmail.com>
>     memstick: rtsx_usb_ms: fix UAF
>=20
> Dongliang Mu <mudongliangabcd@gmail.com>
>     media: dvd_usb: memory leak in cinergyt2_fe_attach
>=20
> Nick Desaulniers <ndesaulniers@google.com>
>     Makefile: fix GDB warning with CONFIG_RELR
>=20
> Kai Ye <yekai13@huawei.com>
>     crypto: hisilicon/sec - fixup 3des minimum key size declaration
>=20
> Evgeny Novikov <novikov@ispras.ru>
>     media: st-hva: Fix potential NULL pointer dereferences
>=20
> Zheyu Ma <zheyuma97@gmail.com>
>     media: bt8xx: Fix a missing check bug in bt878_probe
>=20
> Lv Yunlong <lyl2019@mail.ustc.edu.cn>
>     media: v4l2-core: Avoid the dangling pointer in v4l2_fh_release
>=20
> Andrzej Pietrasiewicz <andrzej.p@collabora.com>
>     media: cedrus: Fix .buf_prepare
>=20
> Andrzej Pietrasiewicz <andrzej.p@collabora.com>
>     media: hantro: Fix .buf_prepare
>=20
> Igor Matheus Andrade Torrente <igormtorrente@gmail.com>
>     media: em28xx: Fix possible memory leak of em28xx struct
>=20
> Tong Zhang <ztong0001@gmail.com>
>     media: bt878: do not schedule tasklet when it is not setup
>=20
> Dillon Min <dillon.minfei@gmail.com>
>     media: i2c: ov2659: Use clk_{prepare_enable,disable_unprepare}() to set=
 xvclk on/off
>=20
> Roberto Sassu <roberto.sassu@huawei.com>
>     ima: Don't remove security.ima if file must not be appraised
>=20
> Odin Ugedal <odin@uged.al>
>     sched/fair: Fix ascii art by relpacing tabs
>=20
> Tian Tao <tiantao6@hisilicon.com>
>     arm64: perf: Convert snprintf to sysfs_emit
>=20
> Thara Gopinath <thara.gopinath@linaro.org>
>     crypto: qce: skcipher: Fix incorrect sg count for dma transfers
>=20
> Jack Xu <jack.xu@intel.com>
>     crypto: qat - remove unused macro in FW loader
>=20
> Jack Xu <jack.xu@intel.com>
>     crypto: qat - check return code of qat_hal_rd_rel_reg()
>=20
> Laurent Pinchart <laurent.pinchart@ideasonboard.com>
>     media: imx: imx7_mipi_csis: Fix logging of only error event counters
>=20
> Anirudh Rayabharam <mail@anirudhrb.com>
>     media: pvrusb2: fix warning in pvr2_i2c_core_done
>=20
> Jernej Skrabec <jernej.skrabec@siol.net>
>     media: hevc: Fix dependent slice segment flags
>=20
> Hans Verkuil <hverkuil-cisco@xs4all.nl>
>     media: cobalt: fix race condition in setting HPD
>=20
> Pavel Skripkin <paskripkin@gmail.com>
>     media: cpia2: fix memory leak in cpia2_usb_probe
>=20
> Valentin Schneider <valentin.schneider@arm.com>
>     sched: Make the idle task quack like a per-CPU kthread
>=20
> Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
>     media: sti: fix obj-$(config) targets
>=20
> Bixuan Cui <cuibixuan@huawei.com>
>     crypto: nx - add missing MODULE_DEVICE_TABLE
>=20
> =C5=81ukasz Stelmach <l.stelmach@samsung.com>
>     hwrng: exynos - Fix runtime PM imbalance on error
>=20
> Valentin Schneider <valentin.schneider@arm.com>
>     sched/core: Initialize the idle task with preemption disabled
>=20
> Zou Wei <zou_wei@huawei.com>
>     regulator: uniphier: Add missing MODULE_DEVICE_TABLE
>=20
> Tian Tao <tiantao6@hisilicon.com>
>     spi: omap-100k: Fix the length judgment problem
>=20
> Jay Fang <f.fangjian@huawei.com>
>     spi: spi-topcliff-pch: Fix potential double free in pch_spi_process_mes=
sages()
>=20
> Jay Fang <f.fangjian@huawei.com>
>     spi: spi-loopback-test: Fix 'tx_buf' might be 'rx_buf'
>=20
> Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
>     media: exynos-gsc: fix pm_runtime_get_sync() usage count
>=20
> Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
>     media: exynos4-is: fix pm_runtime_get_sync() usage count
>=20
> Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
>     media: sti/bdisp: fix pm_runtime_get_sync() usage count
>=20
> Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
>     media: sunxi: fix pm_runtime_get_sync() usage count
>=20
> Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
>     media: s5p-jpeg: fix pm_runtime_get_sync() usage count
>=20
> Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
>     media: mtk-vcodec: fix PM runtime get logic
>=20
> Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
>     media: sh_vou: fix pm_runtime_get_sync() usage count
>=20
> Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
>     media: am437x: fix pm_runtime_get_sync() usage count
>=20
> Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
>     media: s5p: fix pm_runtime_get_sync() usage count
>=20
> Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
>     media: mdk-mdp: fix pm_runtime_get_sync() usage count
>=20
> Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
>     media: marvel-ccic: fix some issues when getting pm_runtime
>=20
> Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
>     media: i2c: imx334: fix the pm runtime get logic
>=20
> Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
>     staging: media: rkvdec: fix pm_runtime_get_sync() usage count
>=20
> Alexey Gladkov <legion@kernel.org>
>     Add a reference to ucounts for each cred
>=20
> Charles Keepax <ckeepax@opensource.cirrus.com>
>     spi: Make of_register_spi_device also set the fwnode
>=20
> Lukasz Luba <lukasz.luba@arm.com>
>     thermal/cpufreq_cooling: Update offline CPUs per-cpu thermal_pressure
>=20
> Miklos Szeredi <mszeredi@redhat.com>
>     fuse: reject internal errno
>=20
> Miklos Szeredi <mszeredi@redhat.com>
>     fuse: check connected before queueing on fpq->io
>=20
> Miklos Szeredi <mszeredi@redhat.com>
>     fuse: ignore PG_workingset after stealing
>=20
> Greg Kurz <groug@kaod.org>
>     fuse: Fix infinite loop in sget_fc()
>=20
> Greg Kurz <groug@kaod.org>
>     fuse: Fix crash if superblock of submount gets killed early
>=20
> Greg Kurz <groug@kaod.org>
>     fuse: Fix crash in fuse_dentry_automount() error path
>=20
> Roberto Sassu <roberto.sassu@huawei.com>
>     evm: Refuse EVM_ALLOW_METADATA_WRITES only if an HMAC key is loaded
>=20
> Roberto Sassu <roberto.sassu@huawei.com>
>     evm: Execute evm_inode_init_security() only when an HMAC key is loaded
>=20
> Kristian Klausen <kristian@klausen.dk>
>     loop: Fix missing discard support when using LOOP_CONFIGURE
>=20
> Kan Liang <kan.liang@linux.intel.com>
>     perf/x86/intel: Fix instructions:ppp support in Sapphire Rapids
>=20
> Kan Liang <kan.liang@linux.intel.com>
>     perf/x86/intel: Add more events requires FRONTEND MSR on Sapphire Rapids
>=20
> Tejas Upadhyay <tejaskumarx.surendrakumar.upadhyay@intel.com>
>     x86/gpu: add JasperLake to gen11 early quirks
>=20
> Michael Ellerman <mpe@ellerman.id.au>
>     powerpc/stacktrace: Fix spurious "stale" traces in raise_backtrace_ipi()
>=20
> Yun Zhou <yun.zhou@windriver.com>
>     seq_buf: Make trace_seq_putmem_hex() support data longer than 8
>=20
> Steven Rostedt (VMware) <rostedt@goodmis.org>
>     tracepoint: Add tracepoint_probe_register_may_exist() for BPF tracing
>=20
> Steven Rostedt (VMware) <rostedt@goodmis.org>
>     tracing/histograms: Fix parsing of "sym-offset" modifier
>=20
> Martin Fuzzey <martin.fuzzey@flowbird.group>
>     rsi: fix AP mode with WPA failure due to encrypted EAPOL
>=20
> Marek Vasut <marex@denx.de>
>     rsi: Assign beacon rate settings to the correct rate_info descriptor fi=
eld
>=20
> Michael Buesch <m@bues.ch>
>     ssb: sdio: Don't overwrite const buffer if block_write fails
>=20
> Pali Roh=C3=A1r <pali@kernel.org>
>     ath9k: Fix kernel NULL pointer dereference during ath_reset_internal()
>=20
> Ondrej Zary <linux@zary.sk>
>     serial_cs: remove wrong GLOBETROTTER.cis entry
>=20
> Ondrej Zary <linux@zary.sk>
>     serial_cs: Add Option International GSM-Ready 56K/ISDN modem
>=20
> Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>
>     serial: sh-sci: Stop dmaengine transfer in sci_stop_tx()
>=20
> Pali Roh=C3=A1r <pali@kernel.org>
>     serial: mvebu-uart: fix calculation of clock divisor
>=20
> Hans de Goede <hdegoede@redhat.com>
>     iio: accel: bmc150: Don't make the remove function of the second accele=
rometer unregister itself
>=20
> Hans de Goede <hdegoede@redhat.com>
>     iio: accel: bmc150: Fix dereferencing the wrong pointer in bmc150_get/s=
et_second_device
>=20
> Stephan Gerhold <stephan@gerhold.net>
>     iio: accel: bmc150: Fix bma222 scale unit
>=20
> Stephan Gerhold <stephan@gerhold.net>
>     iio: accel: bma180: Fix BMA25x bandwidth register values
>=20
> Oliver Lang <Oliver.Lang@gossenmetrawatt.com>
>     iio: ltr501: ltr501_read_ps(): add missing endianness conversion
>=20
> Oliver Lang <Oliver.Lang@gossenmetrawatt.com>
>     iio: ltr501: ltr559: fix initialization of LTR501_ALS_CONTR
>=20
> Marc Kleine-Budde <mkl@pengutronix.de>
>     iio: ltr501: mark register holding upper 8 bits of ALS_DATA{0,1} and PS=
_DATA as volatile, too
>=20
> frank zago <frank@zago.net>
>     iio: light: tcs3472: do not free unallocated IRQ
>=20
> Yang Yingliang <yangyingliang@huawei.com>
>     iio: frequency: adf4350: disable reg and clk on error in adf4350_probe()
>=20
> Martin Fuzzey <martin.fuzzey@flowbird.group>
>     rtc: stm32: Fix unbalanced clk_disable_unprepare() on probe error path
>=20
> Dinh Nguyen <dinguyen@kernel.org>
>     clk: agilex/stratix10: fix bypass representation
>=20
> Dinh Nguyen <dinguyen@kernel.org>
>     clk: agilex/stratix10: remove noc_clk
>=20
> Dinh Nguyen <dinguyen@kernel.org>
>     clk: agilex/stratix10/n5x: fix how the bypass_reg is handled
>=20
> Damien Le Moal <damien.lemoal@wdc.com>
>     clk: k210: Fix k210_clk_set_parent()
>=20
> Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
>     f2fs: Prevent swap file in LFS mode
>=20
> Daniel Rosenberg <drosen@google.com>
>     f2fs: Advertise encrypted casefolding in sysfs
>=20
> Janosch Frank <frankja@linux.ibm.com>
>     s390: mm: Fix secure storage access exception handling
>=20
> Vineeth Vijayan <vneethv@linux.ibm.com>
>     s390/cio: dont call css_wait_for_slow_path() inside a lock
>=20
> Sean Christopherson <seanjc@google.com>
>     KVM: x86: Force all MMUs to reinitialize if guest CPUID is modified
>=20
> Sean Christopherson <seanjc@google.com>
>     KVM: x86: Properly reset MMU context at vCPU RESET/INIT
>=20
> Sean Christopherson <seanjc@google.com>
>     KVM: x86/mmu: Use MMU's role to detect CR4.SMEP value in nested NPT walk
>=20
> Sean Christopherson <seanjc@google.com>
>     KVM: x86/mmu: Treat NX as used (not reserved) for all !TDP shadow MMUs
>=20
> Nathan Chancellor <nathan@kernel.org>
>     KVM: PPC: Book3S HV: Workaround high stack usage with clang
>=20
> Sean Christopherson <seanjc@google.com>
>     KVM: nVMX: Handle split-lock #AC exceptions that happen in L2
>=20
> Robin Murphy <robin.murphy@arm.com>
>     perf/smmuv3: Don't trample existing events with global filter
>=20
> Jann Horn <jannh@google.com>
>     mm/gup: fix try_grab_compound_head() race with split_huge_page()
>=20
> Christophe JAILLET <christophe.jaillet@wanadoo.fr>
>     bus: mhi: pci-generic: Add missing 'pci_disable_pcie_error_reporting()'=
 calls
>=20
> Baochen Qiang <bqiang@codeaurora.org>
>     bus: mhi: Wait for M2 state during system resume
>=20
> Zhang Xiaoxu <zhangxiaoxu5@huawei.com>
>     SUNRPC: Should wake up the privileged task firstly.
>=20
> Zhang Xiaoxu <zhangxiaoxu5@huawei.com>
>     SUNRPC: Fix the batch tasks count wraparound.
>=20
> Abinaya Kalaiselvan <akalaise@codeaurora.org>
>     mac80211: fix NULL ptr dereference during mesh peer connection for non =
HE devices
>=20
> Felix Fietkau <nbd@nbd.name>
>     mac80211: remove iwlwifi specific workaround that broke sta NDP tx
>=20
> Stephane Grosjean <s.grosjean@peak-system.com>
>     can: peak_pciefd: pucan_handle_status(): fix a potential starvation iss=
ue in TX path
>=20
> Oleksij Rempel <linux@rempel-privat.de>
>     can: j1939: j1939_sk_init(): set SOCK_RCU_FREE to call sk_destruct() af=
ter RCU is done
>=20
> Oliver Hartkopp <socketcan@hartkopp.net>
>     can: isotp: isotp_release(): omit unintended hrtimer restart on socket =
release
>=20
> Oliver Hartkopp <socketcan@hartkopp.net>
>     can: gw: synchronize rcu operations before removing gw job entry
>=20
> Thadeu Lima de Souza Cascardo <cascardo@canonical.com>
>     can: bcm: delay release of struct bcm_op after synchronize_rcu()
>=20
> Stephen Brennan <stephen.s.brennan@oracle.com>
>     ext4: use ext4_grp_locked_error in mb_find_extent
>=20
> Pan Dong <pandong.peter@bytedance.com>
>     ext4: fix avefreec in find_group_orlov
>=20
> Zhang Yi <yi.zhang@huawei.com>
>     ext4: remove check for zero nr_to_scan in ext4_es_scan()
>=20
> Zhang Yi <yi.zhang@huawei.com>
>     ext4: correct the cache_nr in tracepoint ext4_es_shrink_exit
>=20
> Yang Yingliang <yangyingliang@huawei.com>
>     ext4: return error code when ext4_fill_flex_info() fails
>=20
> Jan Kara <jack@suse.cz>
>     ext4: fix overflow in ext4_iomap_alloc()
>=20
> Anirudh Rayabharam <mail@anirudhrb.com>
>     ext4: fix kernel infoleak via ext4_extent_header
>=20
> Zhang Yi <yi.zhang@huawei.com>
>     ext4: cleanup in-core orphan list if ext4_truncate() failed to get a tr=
ansaction handle
>=20
> David Sterba <dsterba@suse.com>
>     btrfs: clear defrag status of a root if starting transaction fails
>=20
> Naohiro Aota <naohiro.aota@wdc.com>
>     btrfs: fix unbalanced unlock in qgroup_account_snapshot()
>=20
> David Sterba <dsterba@suse.com>
>     btrfs: compression: don't try to compress if we don't have enough pages
>=20
> Filipe Manana <fdmanana@suse.com>
>     btrfs: send: fix invalid path for unlink operations after parent orphan=
ization
>=20
> Johannes Thumshirn <johannes.thumshirn@wdc.com>
>     btrfs: zoned: bail out if we can't read a reliable write pointer
>=20
> Naohiro Aota <naohiro.aota@wdc.com>
>     btrfs: zoned: print message when zone sanity check type fails
>=20
> Ludovic Desroches <ludovic.desroches@microchip.com>
>     ARM: dts: at91: sama5d4: fix pinctrl muxing
>=20
> Linus Walleij <linus.walleij@linaro.org>
>     ARM: dts: ux500: Fix LED probing
>=20
> Yang Jihong <yangjihong1@huawei.com>
>     arm_pmu: Fix write counter incorrect in ARMv7 big-endian mode
>=20
> Joerg Roedel <jroedel@suse.de>
>     crypto: ccp - Annotate SEV Firmware file names
>=20
> Kees Cook <keescook@chromium.org>
>     crypto: nx - Fix memcpy() over-reading in nonce
>=20
> Alexander Larkin <avlarkin82@gmail.com>
>     Input: joydev - prevent use of not validated data in JSIOCSBTNMAP ioctl
>=20
> Takashi Iwai <tiwai@suse.de>
>     Input: elants_i2c - fix NULL dereference at probing
>=20
> Al Viro <viro@zeniv.linux.org.uk>
>     iov_iter_fault_in_readable() should do nothing in xarray case
>=20
> Al Viro <viro@zeniv.linux.org.uk>
>     copy_page_to_iter(): fix ITER_DISCARD case
>=20
> Kees Cook <keescook@chromium.org>
>     selftests/lkdtm: Avoid needing explicit sub-shell
>=20
> Desmond Cheong Zhi Xi <desmondcheongzx@gmail.com>
>     ntfs: fix validity check for file name attribute
>=20
> Andreas Gruenbacher <agruenba@redhat.com>
>     gfs2: Fix error handling in init_statfs
>=20
> Andreas Gruenbacher <agruenba@redhat.com>
>     gfs2: Fix underflow in gfs2_page_mkwrite
>=20
> Mike Rapoport <rppt@kernel.org>
>     mm/page_alloc: fix memory map initialization for descending nodes
>=20
> Zhangjiantao (Kirin, nanjing) <water.zhangjiantao@huawei.com>
>     xhci: solve a double free problem while doing s4
>=20
> Jing Xiangfeng <jingxiangfeng@huawei.com>
>     usb: typec: Add the missed altmode_id_remove() in typec_register_altmod=
e()
>=20
> Kyle Tso <kyletso@google.com>
>     usb: typec: tcpm: Relax disconnect threshold during power negotiation
>=20
> Badhri Jagan Sridharan <badhri@google.com>
>     usb: typec: tcpci: Fix up sink disconnect thresholds for PD
>=20
> Minas Harutyunyan <Minas.Harutyunyan@synopsys.com>
>     usb: dwc3: Fix debugfs creation flow
>=20
> Hannu Hartikainen <hannu@hrtk.in>
>     USB: cdc-acm: blacklist Heimann USB Appset device
>=20
> Moritz Fischer <mdf@kernel.org>
>     usb: renesas-xhci: Fix handling of unknown ROM state
>=20
> Linyu Yuan <linyyuan@codeaurora.com>
>     usb: gadget: eem: fix echo command packet response issue
>=20
> Pavel Skripkin <paskripkin@gmail.com>
>     net: can: ems_usb: fix use-after-free in ems_usb_disconnect()
>=20
> Johan Hovold <johan@kernel.org>
>     Input: usbtouchscreen - fix control-request directions
>=20
> Pavel Skripkin <paskripkin@gmail.com>
>     media: dvb-usb: fix wrong definition
>=20
> Jeremy Szu <jeremy.szu@canonical.com>
>     ALSA: hda/realtek: fix mute/micmute LEDs for HP EliteBook 830 G8 Notebo=
ok PC
>=20
> Takashi Iwai <tiwai@suse.de>
>     ALSA: hda/realtek: Apply LED fixup for HP Dragonfly G1, too
>=20
> Takashi Iwai <tiwai@suse.de>
>     ALSA: hda/realtek: Fix bass speaker DAC mapping for Asus UM431D
>=20
> Elia Devito <eliadevito@gmail.com>
>     ALSA: hda/realtek: Improve fixup for HP Spectre x360 15-df0xxx
>=20
> Jeremy Szu <jeremy.szu@canonical.com>
>     ALSA: hda/realtek: fix mute/micmute LEDs for HP EliteBook x360 830 G8
>=20
> Takashi Iwai <tiwai@suse.de>
>     ALSA: hda/realtek: Add another ALC236 variant support
>=20
> Andy Chi <andy.chi@canonical.com>
>     ALSA: hda/realtek: fix mute/micmute LEDs for HP ProBook 630 G8
>=20
> Andy Chi <andy.chi@canonical.com>
>     ALSA: hda/realtek: fix mute/micmute LEDs for HP ProBook 445 G8
>=20
> Andy Chi <andy.chi@canonical.com>
>     ALSA: hda/realtek: fix mute/micmute LEDs for HP ProBook 450 G8
>=20
> Takashi Iwai <tiwai@suse.de>
>     ALSA: intel8x0: Fix breakage at ac97 clock measurement
>=20
> Takashi Iwai <tiwai@suse.de>
>     ALSA: usb-audio: scarlett2: Fix wrong resume call
>=20
> Takashi Sakamoto <o-takashi@sakamocchi.jp>
>     ALSA: firewire-motu: fix stream format for MOTU 8pre FireWire
>=20
> Takashi Iwai <tiwai@suse.de>
>     ALSA: usb-audio: Fix OOB access at proc output
>=20
> Daehwan Jung <dh10.jung@samsung.com>
>     ALSA: usb-audio: fix rate on Ozone Z90 USB headset
>=20
> Szymon Janc <szymon.janc@codecoup.pl>
>     Bluetooth: Remove spurious error message
>=20
> Connor Abbott <cwabbott0@gmail.com>
>     Bluetooth: btqca: Don't modify firmware contents in-place
>=20
> Pavel Skripkin <paskripkin@gmail.com>
>     Bluetooth: hci_qca: fix potential GPF
>=20
>=20
> -------------
>=20
> Diffstat:
>=20
>  Documentation/ABI/testing/evm                      |  26 +-
>  Documentation/ABI/testing/sysfs-bus-papr-pmem      |   8 +-
>  Documentation/admin-guide/kernel-parameters.txt    |   6 +
>  Documentation/hwmon/max31790.rst                   |   5 +-
>  .../userspace-api/media/v4l/ext-ctrls-codec.rst    |   5 +-
>  Makefile                                           |   6 +-
>  arch/alpha/kernel/smp.c                            |   1 -
>  arch/arc/kernel/smp.c                              |   1 -
>  arch/arm/boot/dts/sama5d4.dtsi                     |   2 +-
>  arch/arm/boot/dts/ste-href.dtsi                    |   7 +
>  arch/arm/kernel/perf_event_v7.c                    |   4 +-
>  arch/arm/kernel/smp.c                              |   1 -
>  arch/arm64/boot/dts/marvell/armada-37xx.dtsi       |   2 +-
>  arch/arm64/include/asm/kvm_host.h                  |   1 +
>  arch/arm64/include/asm/mmu_context.h               |   4 +-
>  arch/arm64/include/asm/preempt.h                   |   2 +-
>  arch/arm64/kernel/perf_event.c                     |   2 +-
>  arch/arm64/kernel/setup.c                          |   2 +-
>  arch/arm64/kernel/smp.c                            |   1 -
>  arch/arm64/kvm/arm.c                               |   4 +
>  arch/arm64/kvm/pmu-emul.c                          |   4 +
>  arch/csky/kernel/smp.c                             |   1 -
>  arch/csky/mm/syscache.c                            |  11 +-
>  arch/ia64/kernel/mca_drv.c                         |   2 +-
>  arch/ia64/kernel/smpboot.c                         |   1 -
>  arch/m68k/Kconfig.machine                          |   3 +
>  arch/mips/include/asm/highmem.h                    |   2 +-
>  arch/mips/kernel/smp.c                             |   1 -
>  arch/openrisc/kernel/smp.c                         |   2 -
>  arch/parisc/kernel/smp.c                           |   1 -
>  arch/powerpc/include/asm/cputhreads.h              |  30 ++
>  arch/powerpc/include/asm/interrupt.h               |   3 +
>  arch/powerpc/include/asm/kvm_guest.h               |   4 +-
>  arch/powerpc/kernel/firmware.c                     |  10 +-
>  arch/powerpc/kernel/mce_power.c                    |  48 +-
>  arch/powerpc/kernel/process.c                      |  48 +-
>  arch/powerpc/kernel/smp.c                          |  12 +-
>  arch/powerpc/kernel/stacktrace.c                   |  26 +-
>  arch/powerpc/kvm/book3s_hv.c                       |  13 +-
>  arch/powerpc/kvm/book3s_hv_builtin.c               |   2 +-
>  arch/powerpc/kvm/book3s_hv_nested.c                |   3 +-
>  arch/powerpc/kvm/book3s_hv_rm_mmu.c                |   2 +-
>  arch/powerpc/platforms/pseries/papr_scm.c          |  62 ++-
>  arch/powerpc/platforms/pseries/smp.c               |   4 +-
>  arch/riscv/kernel/smpboot.c                        |   1 -
>  arch/s390/Kconfig                                  |   3 +-
>  arch/s390/boot/uv.c                                |   1 +
>  arch/s390/include/asm/pgtable.h                    |  21 +-
>  arch/s390/include/asm/preempt.h                    |   4 +-
>  arch/s390/include/asm/uv.h                         |   8 +-
>  arch/s390/kernel/smp.c                             |   1 -
>  arch/s390/kernel/uv.c                              |  10 +
>  arch/s390/kvm/kvm-s390.c                           |  18 +-
>  arch/s390/mm/fault.c                               |  26 ++
>  arch/sh/kernel/smp.c                               |   2 -
>  arch/sparc/kernel/smp_32.c                         |   1 -
>  arch/sparc/kernel/smp_64.c                         |   3 -
>  arch/x86/crypto/curve25519-x86_64.c                |   2 +-
>  arch/x86/entry/entry_64.S                          |   4 +-
>  arch/x86/events/intel/core.c                       |   6 +-
>  arch/x86/include/asm/idtentry.h                    |  29 +-
>  arch/x86/include/asm/kvm_host.h                    |   3 +-
>  arch/x86/include/asm/preempt.h                     |   2 +-
>  arch/x86/include/uapi/asm/hwcap2.h                 |   6 +-
>  arch/x86/kernel/cpu/mshyperv.c                     |   2 +-
>  arch/x86/kernel/early-quirks.c                     |   1 +
>  arch/x86/kernel/sev-es.c                           | 182 ++++----
>  arch/x86/kernel/smpboot.c                          |   1 -
>  arch/x86/kernel/tsc.c                              |   3 +-
>  arch/x86/kvm/cpuid.c                               |   6 +-
>  arch/x86/kvm/hyperv.c                              |   2 +-
>  arch/x86/kvm/mmu/mmu.c                             |  22 +-
>  arch/x86/kvm/mmu/paging_tmpl.h                     |   3 +-
>  arch/x86/kvm/mmu/tdp_mmu.c                         |  13 +-
>  arch/x86/kvm/vmx/nested.c                          |  29 +-
>  arch/x86/kvm/vmx/vmcs.h                            |   5 +
>  arch/x86/kvm/vmx/vmx.c                             |   4 +-
>  arch/x86/kvm/vmx/vmx.h                             |   1 +
>  arch/x86/kvm/x86.c                                 |  15 +-
>  arch/x86/net/bpf_jit_comp.c                        |   2 +-
>  arch/xtensa/kernel/smp.c                           |   1 -
>  block/bfq-iosched.c                                |  41 +-
>  block/bio.c                                        |  13 +-
>  block/blk-flush.c                                  |   3 +-
>  block/blk-merge.c                                  |   8 +-
>  block/blk-mq-tag.c                                 |  49 ++-
>  block/blk-mq-tag.h                                 |   6 +
>  block/blk-mq.c                                     |  63 ++-
>  block/blk-mq.h                                     |   1 +
>  block/blk-rq-qos.h                                 |  24 +
>  block/blk-wbt.c                                    |  11 +-
>  block/blk-wbt.h                                    |   1 +
>  crypto/shash.c                                     |  18 +-
>  crypto/sm2.c                                       |  24 +-
>  drivers/acpi/Makefile                              |   5 +
>  drivers/acpi/acpi_fpdt.c                           |   4 +-
>  drivers/acpi/acpica/nsrepair2.c                    |   7 +
>  drivers/acpi/apei/ghes.c                           |  81 +++-
>  drivers/acpi/bgrt.c                                |  57 +--
>  drivers/acpi/bus.c                                 |   1 +
>  drivers/acpi/device_pm.c                           |   6 +-
>  drivers/acpi/device_sysfs.c                        |   2 +-
>  drivers/acpi/ec.c                                  |  37 +-
>  drivers/acpi/fan.c                                 |   7 +-
>  drivers/acpi/fan.h                                 |  13 +
>  drivers/acpi/processor_idle.c                      |  40 ++
>  drivers/acpi/resource.c                            |   9 +-
>  drivers/acpi/video_detect.c                        |  24 +
>  drivers/acpi/x86/s2idle.c                          |   4 +
>  drivers/ata/pata_ep93xx.c                          |   2 +-
>  drivers/ata/pata_octeon_cf.c                       |   5 +-
>  drivers/ata/pata_rb532_cf.c                        |   6 +-
>  drivers/ata/sata_highbank.c                        |   6 +-
>  drivers/block/loop.c                               |   1 +
>  drivers/bluetooth/btqca.c                          |  27 +-
>  drivers/bluetooth/hci_qca.c                        |   4 +-
>  drivers/bus/mhi/core/pm.c                          |   1 +
>  drivers/bus/mhi/pci_generic.c                      |   5 +-
>  drivers/char/hw_random/exynos-trng.c               |   4 +-
>  drivers/char/pcmcia/cm4000_cs.c                    |   4 +
>  drivers/char/tpm/tpm_tis_core.c                    |  25 +-
>  drivers/char/tpm/tpm_tis_core.h                    |   3 +-
>  drivers/char/tpm/tpm_tis_spi_main.c                |   2 +
>  drivers/clk/actions/owl-s500.c                     |  75 ++--
>  drivers/clk/clk-k210.c                             |   1 +
>  drivers/clk/clk-si5341.c                           |  77 +++-
>  drivers/clk/clk-versaclock5.c                      |  27 +-
>  drivers/clk/imx/clk-imx8mq.c                       |  56 +--
>  drivers/clk/meson/g12a.c                           |   2 +-
>  drivers/clk/qcom/clk-alpha-pll.c                   |   2 +-
>  drivers/clk/qcom/gcc-sc7280.c                      |   1 +
>  drivers/clk/socfpga/clk-agilex.c                   |  89 ++--
>  drivers/clk/socfpga/clk-periph-s10.c               |  11 +-
>  drivers/clk/socfpga/clk-s10.c                      |  87 ++--
>  drivers/clk/tegra/clk-tegra30.c                    |   2 +-
>  drivers/clocksource/timer-ti-dm.c                  |   6 +
>  drivers/cpufreq/cpufreq.c                          |  11 +-
>  drivers/crypto/cavium/nitrox/nitrox_isr.c          |   4 +
>  drivers/crypto/ccp/sev-dev.c                       |   4 +
>  drivers/crypto/ccp/sp-pci.c                        |   6 +-
>  drivers/crypto/hisilicon/sec2/sec_crypto.c         |   4 +-
>  drivers/crypto/ixp4xx_crypto.c                     |  24 +-
>  drivers/crypto/nx/nx-842-pseries.c                 |   9 +-
>  drivers/crypto/nx/nx-aes-ctr.c                     |   2 +-
>  drivers/crypto/omap-sham.c                         |   4 +-
>  drivers/crypto/qat/qat_common/qat_hal.c            |   6 +-
>  drivers/crypto/qat/qat_common/qat_uclo.c           |   1 -
>  drivers/crypto/qce/skcipher.c                      |  15 +-
>  drivers/crypto/sa2ul.c                             |  22 +-
>  drivers/crypto/ux500/hash/hash_core.c              |   1 +
>  drivers/devfreq/devfreq.c                          |   1 +
>  drivers/devfreq/governor_passive.c                 |   3 +-
>  drivers/edac/Kconfig                               |   3 +-
>  drivers/edac/aspeed_edac.c                         |   4 +-
>  drivers/edac/i10nm_base.c                          |   3 +
>  drivers/edac/pnd2_edac.c                           |   3 +
>  drivers/edac/sb_edac.c                             |   3 +
>  drivers/edac/skx_base.c                            |   3 +
>  drivers/edac/ti_edac.c                             |   1 +
>  drivers/extcon/extcon-max8997.c                    |   3 +-
>  drivers/extcon/extcon-sm5502.c                     |   1 -
>  drivers/firmware/stratix10-svc.c                   |  22 +-
>  drivers/fsi/fsi-core.c                             |   4 +-
>  drivers/fsi/fsi-occ.c                              |   1 +
>  drivers/fsi/fsi-sbefifo.c                          |  10 +-
>  drivers/fsi/fsi-scom.c                             |  16 +-
>  drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c  |  21 +-
>  .../amd/display/amdgpu_dm/amdgpu_dm_mst_types.c    |   3 +
>  drivers/gpu/drm/amd/display/dc/core/dc_link_dp.c   |   2 +-
>  drivers/gpu/drm/amd/display/dc/inc/dc_link_dp.h    |   4 +
>  drivers/gpu/drm/ast/ast_main.c                     |   4 +-
>  drivers/gpu/drm/bridge/Kconfig                     |   2 +-
>  drivers/gpu/drm/drm_bridge.c                       |   3 +
>  drivers/gpu/drm/imx/ipuv3-plane.c                  |  57 ++-
>  drivers/gpu/drm/msm/disp/dpu1/dpu_mdss.c           |   8 +-
>  drivers/gpu/drm/msm/dp/dp_catalog.c                |   5 +-
>  drivers/gpu/drm/msm/dp/dp_ctrl.c                   |  55 +++
>  drivers/gpu/drm/msm/dp/dp_ctrl.h                   |   2 +
>  drivers/gpu/drm/msm/dp/dp_display.c                |  57 ++-
>  drivers/gpu/drm/msm/msm_drv.c                      |   1 +
>  drivers/gpu/drm/pl111/Kconfig                      |   1 +
>  drivers/gpu/drm/qxl/qxl_dumb.c                     |   2 +
>  drivers/gpu/drm/rockchip/cdn-dp-core.c             |   1 +
>  drivers/gpu/drm/rockchip/cdn-dp-reg.c              |   2 +-
>  drivers/gpu/drm/rockchip/dw-mipi-dsi-rockchip.c    |  36 +-
>  drivers/gpu/drm/rockchip/rockchip_drm_vop.c        |   1 +
>  drivers/gpu/drm/rockchip/rockchip_lvds.c           |   4 +-
>  drivers/gpu/drm/vc4/vc4_crtc.c                     |  63 ++-
>  drivers/gpu/drm/vc4/vc4_hdmi.c                     |   4 +-
>  .../drm/vmwgfx/device_include/svga3d_surfacedefs.h |   8 +-
>  drivers/gpu/drm/vmwgfx/vmwgfx_execbuf.c            |  20 +-
>  drivers/gpu/drm/vmwgfx/vmwgfx_surface.c            |  13 +
>  drivers/hid/hid-core.c                             |  10 +-
>  drivers/hid/hid-ids.h                              |   1 +
>  drivers/hid/hid-input.c                            |   2 +
>  drivers/hid/hid-sony.c                             |  98 ++---
>  drivers/hid/wacom_wac.h                            |   2 +-
>  drivers/hv/connection.c                            |   4 +-
>  drivers/hv/hv_util.c                               |   4 +-
>  drivers/hwmon/lm70.c                               |  26 +-
>  drivers/hwmon/max31722.c                           |   9 -
>  drivers/hwmon/max31790.c                           |  49 ++-
>  drivers/hwtracing/coresight/coresight-core.c       |   2 +-
>  drivers/iio/accel/bma180.c                         |  19 +-
>  drivers/iio/accel/bma220_spi.c                     |  10 +-
>  drivers/iio/accel/bmc150-accel-core.c              |  21 +-
>  drivers/iio/accel/bmc150-accel-i2c.c               |   2 +-
>  drivers/iio/accel/bmc150-accel.h                   |   2 +-
>  drivers/iio/accel/hid-sensor-accel-3d.c            |  13 +-
>  drivers/iio/accel/kxcjk-1013.c                     |  24 +-
>  drivers/iio/accel/mxc4005.c                        |  10 +-
>  drivers/iio/accel/stk8312.c                        |  12 +-
>  drivers/iio/accel/stk8ba50.c                       |  17 +-
>  drivers/iio/adc/at91-sama5d2_adc.c                 |   3 +-
>  drivers/iio/adc/hx711.c                            |   4 +-
>  drivers/iio/adc/mxs-lradc-adc.c                    |   3 +-
>  drivers/iio/adc/ti-ads1015.c                       |  12 +-
>  drivers/iio/adc/ti-ads8688.c                       |   3 +-
>  drivers/iio/adc/vf610_adc.c                        |  10 +-
>  drivers/iio/chemical/atlas-sensor.c                |   4 +-
>  drivers/iio/frequency/adf4350.c                    |   6 +-
>  drivers/iio/gyro/bmg160_core.c                     |  10 +-
>  drivers/iio/humidity/am2315.c                      |  16 +-
>  drivers/iio/imu/adis16400.c                        |   3 -
>  drivers/iio/imu/adis16475.c                        |   2 +-
>  drivers/iio/imu/adis_buffer.c                      |   3 -
>  drivers/iio/light/isl29125.c                       |  10 +-
>  drivers/iio/light/ltr501.c                         |  15 +-
>  drivers/iio/light/tcs3414.c                        |  10 +-
>  drivers/iio/light/tcs3472.c                        |  16 +-
>  drivers/iio/light/vcnl4000.c                       |   2 +-
>  drivers/iio/light/vcnl4035.c                       |   3 +-
>  drivers/iio/magnetometer/bmc150_magn.c             |  11 +-
>  drivers/iio/magnetometer/hmc5843.h                 |   8 +-
>  drivers/iio/magnetometer/hmc5843_core.c            |   4 +-
>  drivers/iio/magnetometer/rm3100-core.c             |   3 +-
>  drivers/iio/potentiostat/lmp91000.c                |   4 +-
>  drivers/iio/proximity/as3935.c                     |  10 +-
>  drivers/iio/proximity/isl29501.c                   |   2 +-
>  drivers/iio/proximity/pulsedlight-lidar-lite-v2.c  |  10 +-
>  drivers/iio/proximity/srf08.c                      |  14 +-
>  drivers/infiniband/core/cma.c                      |  26 +-
>  drivers/infiniband/core/uverbs_cmd.c               |  21 +-
>  drivers/infiniband/hw/hns/hns_roce_hw_v2.c         |   7 +-
>  drivers/infiniband/hw/hns/hns_roce_mr.c            |   2 +-
>  drivers/infiniband/hw/mlx4/qp.c                    |   9 +-
>  drivers/infiniband/hw/mlx5/main.c                  |   4 +-
>  drivers/infiniband/hw/mlx5/qp.c                    |   6 +-
>  drivers/infiniband/sw/rxe/rxe_net.c                |  10 +-
>  drivers/infiniband/sw/rxe/rxe_qp.c                 |   1 -
>  drivers/infiniband/sw/rxe/rxe_resp.c               |   2 -
>  drivers/infiniband/ulp/iser/iscsi_iser.c           |   2 +
>  drivers/infiniband/ulp/rtrs/rtrs-clt.c             |  28 +-
>  drivers/infiniband/ulp/rtrs/rtrs-srv-sysfs.c       |   1 +
>  drivers/infiniband/ulp/rtrs/rtrs-srv.c             |  39 +-
>  drivers/infiniband/ulp/rtrs/rtrs.c                 |   1 -
>  drivers/infiniband/ulp/srp/ib_srp.c                |  13 +-
>  drivers/input/joydev.c                             |   2 +-
>  drivers/input/keyboard/Kconfig                     |   3 -
>  drivers/input/keyboard/hil_kbd.c                   |   1 +
>  drivers/input/touchscreen/elants_i2c.c             |   6 +-
>  drivers/input/touchscreen/goodix.c                 |  52 ---
>  drivers/input/touchscreen/usbtouchscreen.c         |   8 +-
>  drivers/iommu/amd/init.c                           |   4 +-
>  drivers/iommu/dma-iommu.c                          |   6 +-
>  drivers/leds/Kconfig                               |   1 +
>  drivers/leds/blink/leds-lgm-sso.c                  |  44 +-
>  drivers/leds/led-class.c                           |   4 -
>  drivers/leds/leds-as3645a.c                        |   1 +
>  drivers/leds/leds-ktd2692.c                        |  27 +-
>  drivers/leds/leds-lm36274.c                        |   1 +
>  drivers/leds/leds-lm3692x.c                        |   8 +-
>  drivers/leds/leds-lm3697.c                         |   8 +-
>  drivers/leds/leds-lp50xx.c                         |   2 +-
>  drivers/mailbox/qcom-apcs-ipc-mailbox.c            |   2 +-
>  drivers/mailbox/qcom-ipcc.c                        |   6 +
>  drivers/md/md.c                                    |  45 --
>  drivers/md/md.h                                    |   1 -
>  drivers/media/cec/platform/s5p/s5p_cec.c           |   7 +-
>  drivers/media/common/siano/smscoreapi.c            |  22 +-
>  drivers/media/common/siano/smscoreapi.h            |   4 +-
>  drivers/media/common/siano/smsdvb-main.c           |   4 +
>  drivers/media/dvb-core/dvb_net.c                   |  25 +-
>  drivers/media/dvb-core/dvbdev.c                    |   3 +
>  drivers/media/i2c/ccs/ccs-core.c                   |   2 +-
>  drivers/media/i2c/imx334.c                         |   7 +-
>  drivers/media/i2c/ir-kbd-i2c.c                     |   4 +-
>  drivers/media/i2c/ov2659.c                         |  24 +-
>  drivers/media/i2c/rdacm21.c                        |  56 ++-
>  drivers/media/i2c/s5c73m3/s5c73m3-core.c           |   6 +-
>  drivers/media/i2c/s5c73m3/s5c73m3.h                |   2 +-
>  drivers/media/i2c/s5k4ecgx.c                       |  10 +-
>  drivers/media/i2c/s5k5baf.c                        |   6 +-
>  drivers/media/i2c/s5k6aa.c                         |  10 +-
>  drivers/media/i2c/tc358743.c                       |   1 +
>  drivers/media/mc/Makefile                          |   2 +-
>  drivers/media/pci/bt8xx/bt878.c                    |   6 +-
>  drivers/media/pci/cobalt/cobalt-driver.c           |   1 +
>  drivers/media/pci/cobalt/cobalt-driver.h           |   7 +-
>  drivers/media/pci/intel/ipu3/cio2-bridge.c         |  10 +-
>  drivers/media/platform/am437x/am437x-vpfe.c        |  15 +-
>  drivers/media/platform/exynos-gsc/gsc-m2m.c        |   4 +-
>  drivers/media/platform/exynos4-is/fimc-capture.c   |   6 +-
>  drivers/media/platform/exynos4-is/fimc-is.c        |   4 +-
>  drivers/media/platform/exynos4-is/fimc-isp-video.c |  10 +-
>  drivers/media/platform/exynos4-is/fimc-isp.c       |   7 +-
>  drivers/media/platform/exynos4-is/fimc-lite.c      |   5 +-
>  drivers/media/platform/exynos4-is/fimc-m2m.c       |   5 +-
>  drivers/media/platform/exynos4-is/media-dev.c      |  10 +-
>  drivers/media/platform/exynos4-is/mipi-csis.c      |  10 +-
>  drivers/media/platform/marvell-ccic/mcam-core.c    |   9 +-
>  drivers/media/platform/mtk-mdp/mtk_mdp_m2m.c       |   6 +-
>  .../media/platform/mtk-vcodec/mtk_vcodec_dec_drv.c |   4 +-
>  .../media/platform/mtk-vcodec/mtk_vcodec_dec_pm.c  |   8 +-
>  .../media/platform/mtk-vcodec/mtk_vcodec_dec_pm.h  |   2 +-
>  drivers/media/platform/mtk-vpu/mtk_vpu.c           |   6 +
>  drivers/media/platform/qcom/venus/core.c           |  60 ++-
>  drivers/media/platform/s5p-g2d/g2d.c               |   3 +
>  drivers/media/platform/s5p-jpeg/jpeg-core.c        |   5 +-
>  drivers/media/platform/sh_vou.c                    |   6 +-
>  drivers/media/platform/sti/bdisp/Makefile          |   2 +-
>  drivers/media/platform/sti/bdisp/bdisp-v4l2.c      |   7 +-
>  drivers/media/platform/sti/delta/Makefile          |   2 +-
>  drivers/media/platform/sti/hva/Makefile            |   2 +-
>  drivers/media/platform/sti/hva/hva-hw.c            |   3 +-
>  .../platform/sunxi/sun8i-rotate/sun8i_rotate.c     |   2 +-
>  drivers/media/platform/video-mux.c                 |  10 +-
>  drivers/media/usb/au0828/au0828-core.c             |   4 +-
>  drivers/media/usb/cpia2/cpia2.h                    |   1 +
>  drivers/media/usb/cpia2/cpia2_core.c               |  12 +
>  drivers/media/usb/cpia2/cpia2_usb.c                |  13 +-
>  drivers/media/usb/dvb-usb/cinergyT2-core.c         |   2 +
>  drivers/media/usb/dvb-usb/cxusb.c                  |   2 +-
>  drivers/media/usb/em28xx/em28xx-input.c            |   8 +-
>  drivers/media/usb/gspca/gl860/gl860.c              |   4 +-
>  drivers/media/usb/pvrusb2/pvrusb2-hdw.c            |   4 +-
>  drivers/media/v4l2-core/v4l2-fh.c                  |   1 +
>  drivers/media/v4l2-core/v4l2-ioctl.c               |  12 +-
>  drivers/media/v4l2-core/v4l2-subdev.c              |  24 -
>  drivers/memstick/host/rtsx_usb_ms.c                |  10 +-
>  drivers/mfd/Kconfig                                |   1 +
>  drivers/mfd/rn5t618.c                              |   2 +-
>  drivers/misc/eeprom/idt_89hpesx.c                  |   8 +-
>  drivers/misc/habanalabs/common/habanalabs_drv.c    |   1 +
>  drivers/mmc/core/block.c                           |   8 +
>  drivers/mmc/host/sdhci-of-aspeed.c                 |   2 +-
>  drivers/mmc/host/sdhci-sprd.c                      |   1 +
>  drivers/mmc/host/usdhi6rol0.c                      |   1 +
>  drivers/mmc/host/via-sdmmc.c                       |   3 +
>  drivers/mmc/host/vub300.c                          |   2 +-
>  drivers/mtd/nand/raw/arasan-nand-controller.c      |  90 ++--
>  drivers/mtd/nand/raw/marvell_nand.c                |   4 +-
>  drivers/mtd/nand/spi/core.c                        |  17 +-
>  drivers/mtd/parsers/qcomsmempart.c                 |  10 +
>  drivers/mtd/parsers/redboot.c                      |   7 +-
>  drivers/net/can/peak_canfd/peak_canfd.c            |   4 +-
>  drivers/net/can/usb/ems_usb.c                      |   3 +-
>  drivers/net/dsa/mv88e6xxx/chip.c                   |   6 +-
>  drivers/net/dsa/sja1105/sja1105_main.c             |   6 +
>  drivers/net/ethernet/aeroflex/greth.c              |   3 +-
>  drivers/net/ethernet/aquantia/atlantic/aq_macsec.h |   4 +-
>  drivers/net/ethernet/broadcom/bcm4908_enet.c       |   6 +-
>  drivers/net/ethernet/broadcom/genet/bcmgenet.c     |   1 +
>  drivers/net/ethernet/emulex/benet/be_cmds.c        |   6 +-
>  drivers/net/ethernet/emulex/benet/be_main.c        |   2 +
>  drivers/net/ethernet/ezchip/nps_enet.c             |   4 +-
>  drivers/net/ethernet/faraday/ftgmac100.c           |   6 +-
>  drivers/net/ethernet/google/gve/gve_main.c         |   4 +-
>  drivers/net/ethernet/ibm/ehea/ehea_main.c          |   9 +-
>  drivers/net/ethernet/ibm/ibmvnic.c                 |  99 ++++-
>  drivers/net/ethernet/intel/e1000e/netdev.c         |  24 +-
>  drivers/net/ethernet/intel/i40e/i40e_ethtool.c     |   3 +-
>  drivers/net/ethernet/intel/i40e/i40e_main.c        |  17 +-
>  drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c    |   2 +
>  drivers/net/ethernet/marvell/pxa168_eth.c          |   2 +-
>  .../net/ethernet/oki-semi/pch_gbe/pch_gbe_main.c   |  10 +-
>  drivers/net/ethernet/ti/am65-cpsw-nuss.c           |  18 +-
>  drivers/net/ieee802154/mac802154_hwsim.c           |  11 +-
>  drivers/net/macsec.c                               |   4 +-
>  drivers/net/phy/mscc/mscc_macsec.c                 |   2 +-
>  drivers/net/phy/mscc/mscc_macsec.h                 |   2 +-
>  drivers/net/vrf.c                                  |  14 +-
>  drivers/net/vxlan.c                                |   2 +
>  drivers/net/wireless/ath/ath10k/mac.c              |   1 +
>  drivers/net/wireless/ath/ath10k/pci.c              |  14 +-
>  drivers/net/wireless/ath/ath11k/core.c             |   3 +-
>  drivers/net/wireless/ath/ath11k/mac.c              |  10 +-
>  drivers/net/wireless/ath/ath9k/main.c              |   5 +
>  drivers/net/wireless/ath/carl9170/Kconfig          |   8 +-
>  drivers/net/wireless/ath/wcn36xx/main.c            |  21 +-
>  drivers/net/wireless/ath/wil6210/cfg80211.c        |   2 -
>  .../broadcom/brcm80211/brcmfmac/cfg80211.c         |  37 +-
>  .../wireless/broadcom/brcm80211/brcmfmac/sdio.c    |   5 +-
>  .../broadcom/brcm80211/brcmsmac/mac80211_if.c      |   8 +-
>  drivers/net/wireless/intel/iwlwifi/fw/pnvm.h       |   4 +-
>  drivers/net/wireless/intel/iwlwifi/mvm/tx.c        |   3 +
>  drivers/net/wireless/marvell/mwifiex/pcie.c        |  10 +-
>  drivers/net/wireless/mediatek/mt76/mt7615/mac.c    |   4 +
>  .../net/wireless/mediatek/mt76/mt7615/pci_mac.c    |   5 +-
>  .../net/wireless/mediatek/mt76/mt7615/usb_sdio.c   |   5 +-
>  .../net/wireless/mediatek/mt76/mt76_connac_mac.c   |   8 -
>  .../net/wireless/mediatek/mt76/mt76_connac_mcu.c   |  11 +-
>  .../net/wireless/mediatek/mt76/mt76_connac_mcu.h   |   8 +
>  .../net/wireless/mediatek/mt76/mt7915/testmode.c   |  21 +-
>  drivers/net/wireless/mediatek/mt76/mt7921/init.c   |  18 -
>  drivers/net/wireless/mediatek/mt76/mt7921/mac.c    |  15 +-
>  drivers/net/wireless/mediatek/mt76/mt7921/main.c   |  58 +--
>  drivers/net/wireless/mediatek/mt76/tx.c            |   2 +-
>  drivers/net/wireless/realtek/rtw88/rtw8822c.c      |  22 +-
>  drivers/net/wireless/rsi/rsi_91x_hal.c             |   6 +-
>  drivers/net/wireless/rsi/rsi_91x_mac80211.c        |   3 -
>  drivers/net/wireless/rsi/rsi_91x_mgmt.c            |   3 +-
>  drivers/net/wireless/rsi/rsi_main.h                |   1 -
>  drivers/net/wireless/st/cw1200/scan.c              |  17 +-
>  drivers/nvme/host/pci.c                            |  26 +-
>  drivers/nvme/target/fc.c                           |  10 +-
>  drivers/of/fdt.c                                   |   8 +-
>  drivers/of/of_reserved_mem.c                       |   8 +-
>  drivers/pci/controller/pci-hyperv.c                |   3 +
>  drivers/perf/arm-cmn.c                             |   2 +-
>  drivers/perf/arm_smmuv3_pmu.c                      |  18 +-
>  drivers/perf/fsl_imx8_ddr_perf.c                   |   6 +-
>  drivers/phy/ralink/phy-mt7621-pci.c                |   4 +-
>  drivers/phy/socionext/phy-uniphier-pcie.c          |  11 +-
>  drivers/phy/ti/phy-dm816x-usb.c                    |  17 +-
>  drivers/pinctrl/renesas/pfc-r8a7796.c              |   3 +-
>  drivers/pinctrl/renesas/pfc-r8a77990.c             |   8 +-
>  drivers/platform/x86/asus-nb-wmi.c                 |  77 ----
>  drivers/platform/x86/toshiba_acpi.c                |   1 +
>  drivers/platform/x86/touchscreen_dmi.c             |  85 ++++
>  drivers/regulator/da9052-regulator.c               |   3 +-
>  drivers/regulator/fan53880.c                       |   2 +-
>  drivers/regulator/hi655x-regulator.c               |  16 +-
>  drivers/regulator/mt6315-regulator.c               |   4 +-
>  drivers/regulator/mt6358-regulator.c               |   2 +-
>  drivers/regulator/uniphier-regulator.c             |   1 +
>  drivers/rtc/rtc-stm32.c                            |   6 +-
>  drivers/s390/cio/chp.c                             |   3 +
>  drivers/s390/cio/chsc.c                            |   2 -
>  drivers/scsi/FlashPoint.c                          |  32 +-
>  drivers/scsi/be2iscsi/be_iscsi.c                   |  19 +-
>  drivers/scsi/be2iscsi/be_main.c                    |   1 +
>  drivers/scsi/bnx2i/bnx2i_iscsi.c                   |  24 +-
>  drivers/scsi/cxgbi/cxgb3i/cxgb3i.c                 |   1 +
>  drivers/scsi/cxgbi/cxgb4i/cxgb4i.c                 |   1 +
>  drivers/scsi/cxgbi/libcxgbi.c                      |  12 +-
>  drivers/scsi/libfc/fc_encode.h                     |   8 +-
>  drivers/scsi/libiscsi.c                            |  70 ++-
>  drivers/scsi/lpfc/lpfc_debugfs.c                   |   7 +-
>  drivers/scsi/lpfc/lpfc_els.c                       | 100 ++++-
>  drivers/scsi/lpfc/lpfc_hbadisc.c                   |  27 +-
>  drivers/scsi/lpfc/lpfc_init.c                      |   7 -
>  drivers/scsi/lpfc/lpfc_nportdisc.c                 |  25 +-
>  drivers/scsi/lpfc/lpfc_sli.c                       |  10 +-
>  drivers/scsi/megaraid/megaraid_sas_fusion.c        |  10 +-
>  drivers/scsi/mpt3sas/mpt3sas_scsih.c               |   4 +-
>  drivers/scsi/qedi/qedi_iscsi.c                     |  26 +-
>  drivers/scsi/qla4xxx/ql4_os.c                      |   2 +
>  drivers/scsi/scsi_lib.c                            |   1 +
>  drivers/scsi/scsi_transport_iscsi.c                | 487 ++++++++++++-----=
----
>  drivers/soundwire/stream.c                         |  13 +-
>  drivers/spi/spi-loopback-test.c                    |   2 +-
>  drivers/spi/spi-meson-spicc.c                      |   8 +-
>  drivers/spi/spi-omap-100k.c                        |   2 +-
>  drivers/spi/spi-sun6i.c                            |   6 +-
>  drivers/spi/spi-topcliff-pch.c                     |   4 +-
>  drivers/spi/spi.c                                  |   8 +-
>  drivers/ssb/scan.c                                 |   1 +
>  drivers/ssb/sdio.c                                 |   1 -
>  drivers/staging/fbtft/fb_agm1264k-fl.c             |  20 +-
>  drivers/staging/fbtft/fb_bd663474.c                |   4 -
>  drivers/staging/fbtft/fb_ili9163.c                 |   4 -
>  drivers/staging/fbtft/fb_ili9320.c                 |   1 -
>  drivers/staging/fbtft/fb_ili9325.c                 |   4 -
>  drivers/staging/fbtft/fb_ili9340.c                 |   1 -
>  drivers/staging/fbtft/fb_s6d1121.c                 |   4 -
>  drivers/staging/fbtft/fb_sh1106.c                  |   1 -
>  drivers/staging/fbtft/fb_ssd1289.c                 |   4 -
>  drivers/staging/fbtft/fb_ssd1325.c                 |   2 -
>  drivers/staging/fbtft/fb_ssd1331.c                 |   6 +-
>  drivers/staging/fbtft/fb_ssd1351.c                 |   1 -
>  drivers/staging/fbtft/fb_upd161704.c               |   4 -
>  drivers/staging/fbtft/fb_watterott.c               |   1 -
>  drivers/staging/fbtft/fbtft-bus.c                  |   3 +-
>  drivers/staging/fbtft/fbtft-core.c                 |  25 +-
>  drivers/staging/fbtft/fbtft-io.c                   |  12 +-
>  drivers/staging/gdm724x/gdm_lte.c                  |  20 +-
>  drivers/staging/hikey9xx/hi6421v600-regulator.c    |   9 +-
>  drivers/staging/media/hantro/hantro_drv.c          |  33 +-
>  drivers/staging/media/hantro/hantro_v4l2.c         |   9 +-
>  drivers/staging/media/imx/imx-media-csi.c          |  14 +-
>  drivers/staging/media/imx/imx7-mipi-csis.c         |   6 +-
>  drivers/staging/media/rkvdec/rkvdec.c              |  12 +-
>  drivers/staging/media/sunxi/cedrus/cedrus_h265.c   |   4 +-
>  drivers/staging/media/sunxi/cedrus/cedrus_video.c  |   8 +-
>  drivers/staging/mt7621-dts/mt7621.dtsi             |   2 +-
>  drivers/staging/rtl8712/hal_init.c                 |   3 +
>  drivers/staging/rtl8712/os_intfs.c                 |   4 -
>  drivers/staging/rtl8712/usb_intf.c                 |  24 +-
>  .../staging/vc04_services/vchiq-mmal/mmal-vchiq.c  |   2 +-
>  drivers/target/iscsi/cxgbit/cxgbit_ddp.c           |  19 +-
>  drivers/target/iscsi/cxgbit/cxgbit_target.c        |  21 +-
>  drivers/thermal/cpufreq_cooling.c                  |   2 +-
>  drivers/thunderbolt/test.c                         |  14 +-
>  drivers/tty/nozomi.c                               |   9 +-
>  drivers/tty/serial/8250/8250_omap.c                |  22 +-
>  drivers/tty/serial/8250/8250_port.c                |  19 +-
>  drivers/tty/serial/8250/serial_cs.c                |   2 +-
>  drivers/tty/serial/fsl_lpuart.c                    |  14 +-
>  drivers/tty/serial/mvebu-uart.c                    |  18 +-
>  drivers/tty/serial/sh-sci.c                        |   8 +
>  drivers/usb/class/cdc-acm.c                        |   5 +
>  drivers/usb/dwc2/core.c                            |  30 +-
>  drivers/usb/dwc3/core.c                            |   3 +-
>  drivers/usb/gadget/function/f_eem.c                |  43 +-
>  drivers/usb/gadget/function/f_fs.c                 |  65 ++-
>  drivers/usb/host/xhci-mem.c                        |   1 +
>  drivers/usb/host/xhci-pci-renesas.c                |  16 +-
>  drivers/usb/phy/phy-tegra-usb.c                    |  15 +-
>  drivers/usb/typec/class.c                          |   4 +-
>  drivers/usb/typec/tcpm/tcpci.c                     |  18 +-
>  drivers/usb/typec/tcpm/tcpm.c                      |  30 ++
>  drivers/vfio/pci/vfio_pci.c                        |  29 +-
>  drivers/video/backlight/lm3630a_bl.c               |   4 +-
>  drivers/video/fbdev/imxfb.c                        |   2 +-
>  drivers/visorbus/visorchipset.c                    |   6 +-
>  fs/btrfs/Kconfig                                   |   2 +
>  fs/btrfs/ctree.c                                   |   5 +-
>  fs/btrfs/delayed-inode.c                           |  18 +-
>  fs/btrfs/extent-tree.c                             |   1 -
>  fs/btrfs/inode.c                                   |  16 +-
>  fs/btrfs/send.c                                    |  11 +
>  fs/btrfs/super.c                                   |  11 -
>  fs/btrfs/sysfs.c                                   |   4 +-
>  fs/btrfs/transaction.c                             |  16 +-
>  fs/btrfs/transaction.h                             |   1 -
>  fs/btrfs/tree-log.c                                |   1 +
>  fs/btrfs/zoned.c                                   |  18 +
>  fs/cifs/cifs_swn.c                                 |  10 +-
>  fs/cifs/cifsacl.c                                  |   2 +-
>  fs/cifs/cifsglob.h                                 |   3 +-
>  fs/cifs/connect.c                                  |   5 +-
>  fs/cifs/dfs_cache.c                                |   7 +-
>  fs/cifs/smb2ops.c                                  | 133 ++++++
>  fs/configfs/file.c                                 |  10 +-
>  fs/crypto/fname.c                                  |  10 +-
>  fs/crypto/keysetup.c                               |  40 +-
>  fs/dax.c                                           |   3 +-
>  fs/dlm/config.c                                    |   9 +
>  fs/dlm/lowcomms.c                                  |  77 ++--
>  fs/erofs/super.c                                   |   1 +
>  fs/exec.c                                          |   4 +
>  fs/exfat/dir.c                                     |   8 +-
>  fs/ext4/extents.c                                  |   3 +
>  fs/ext4/extents_status.c                           |   4 +-
>  fs/ext4/ialloc.c                                   |  11 +-
>  fs/ext4/inode.c                                    |   2 +-
>  fs/ext4/mballoc.c                                  |   9 +-
>  fs/ext4/super.c                                    |  10 +-
>  fs/f2fs/data.c                                     |   6 +
>  fs/f2fs/sysfs.c                                    |   8 +
>  fs/fs-writeback.c                                  |  39 +-
>  fs/fuse/dev.c                                      |  12 +-
>  fs/fuse/dir.c                                      |  25 +-
>  fs/gfs2/file.c                                     |   4 +-
>  fs/gfs2/ops_fstype.c                               |   1 +
>  fs/io_uring.c                                      |  10 +-
>  fs/ntfs/inode.c                                    |   2 +-
>  fs/ocfs2/filecheck.c                               |   6 +-
>  fs/ocfs2/stackglue.c                               |   8 +-
>  fs/open.c                                          |  14 +-
>  fs/proc/task_mmu.c                                 |   2 +-
>  fs/pstore/Kconfig                                  |   1 +
>  include/asm-generic/pgtable-nop4d.h                |   1 -
>  include/asm-generic/preempt.h                      |   2 +-
>  include/clocksource/timer-ti-dm.h                  |   1 +
>  include/crypto/internal/hash.h                     |   8 +-
>  include/dt-bindings/clock/imx8mq-clock.h           |  19 -
>  include/linux/bio.h                                |  12 +-
>  include/linux/clocksource.h                        |   2 +-
>  include/linux/cred.h                               |   2 +
>  include/linux/huge_mm.h                            |  59 ++-
>  include/linux/hugetlb.h                            |   5 +
>  include/linux/iio/common/cros_ec_sensors_core.h    |   2 +-
>  include/linux/kthread.h                            |   2 +
>  include/linux/mm.h                                 |   1 -
>  include/linux/pgtable.h                            |  22 +
>  include/linux/prandom.h                            |   2 +-
>  include/linux/swap.h                               |   9 +
>  include/linux/tracepoint.h                         |  10 +
>  include/linux/user_namespace.h                     |   4 +
>  include/media/hevc-ctrls.h                         |   3 +-
>  include/media/media-dev-allocator.h                |   2 +-
>  include/net/bluetooth/hci.h                        |   6 +-
>  include/net/bluetooth/hci_core.h                   |   8 +-
>  include/net/ip.h                                   |  12 +-
>  include/net/ip6_route.h                            |  16 +-
>  include/net/macsec.h                               |   2 +-
>  include/net/sch_generic.h                          |  12 +
>  include/net/tc_act/tc_vlan.h                       |   1 +
>  include/net/xfrm.h                                 |   1 +
>  include/net/xsk_buff_pool.h                        |   9 +-
>  include/scsi/fc/fc_ms.h                            |   4 +-
>  include/scsi/libiscsi.h                            |   1 +
>  include/scsi/scsi_transport_iscsi.h                |  12 +-
>  include/uapi/linux/v4l2-controls.h                 |  23 +-
>  init/main.c                                        |   6 +-
>  kernel/bpf/devmap.c                                |   4 +-
>  kernel/bpf/inode.c                                 |   2 +-
>  kernel/bpf/verifier.c                              |   6 +-
>  kernel/cred.c                                      |  40 ++
>  kernel/fork.c                                      |   8 +-
>  kernel/kthread.c                                   |  49 ++-
>  kernel/locking/lockdep.c                           | 122 +++++-
>  kernel/rcu/tree.c                                  |   2 +-
>  kernel/sched/core.c                                |  86 ++--
>  kernel/sched/deadline.c                            |   2 +
>  kernel/sched/fair.c                                |  19 +-
>  kernel/sched/psi.c                                 |  12 +-
>  kernel/sched/rt.c                                  |  17 +-
>  kernel/smpboot.c                                   |   1 -
>  kernel/sys.c                                       |  12 +
>  kernel/time/clocksource.c                          | 113 ++++-
>  kernel/trace/bpf_trace.c                           |   3 +-
>  kernel/trace/trace_events_hist.c                   |   7 +
>  kernel/tracepoint.c                                |  33 +-
>  kernel/ucount.c                                    |  40 +-
>  kernel/user_namespace.c                            |   3 +
>  lib/Kconfig.debug                                  |   1 -
>  lib/iov_iter.c                                     |   9 +-
>  lib/kstrtox.c                                      |  13 +-
>  lib/kstrtox.h                                      |   2 +
>  lib/kunit/test.c                                   |   7 +-
>  lib/locking-selftest.c                             |   1 +
>  lib/math/rational.c                                |  16 +-
>  lib/seq_buf.c                                      |   4 +-
>  lib/vsprintf.c                                     |  82 ++--
>  mm/debug_vm_pgtable.c                              |  63 ++-
>  mm/gup.c                                           |  58 ++-
>  mm/huge_memory.c                                   |  13 +-
>  mm/hugetlb.c                                       |  99 +++--
>  mm/khugepaged.c                                    |   4 +-
>  mm/memcontrol.c                                    |   8 +
>  mm/memory.c                                        |  11 +-
>  mm/migrate.c                                       |   2 +-
>  mm/mmap_lock.c                                     |  33 +-
>  mm/page_alloc.c                                    | 107 +++--
>  mm/shmem.c                                         |  17 +-
>  mm/slab.h                                          |   1 -
>  mm/z3fold.c                                        |   3 +-
>  mm/zswap.c                                         |  17 +-
>  net/bluetooth/hci_event.c                          |  27 +-
>  net/bluetooth/hci_request.c                        |  51 ++-
>  net/bluetooth/mgmt.c                               |   3 +
>  net/bpfilter/main.c                                |   2 +-
>  net/can/bcm.c                                      |   7 +-
>  net/can/gw.c                                       |   3 +
>  net/can/isotp.c                                    |   7 +-
>  net/can/j1939/main.c                               |   4 +
>  net/can/j1939/socket.c                             |   5 +-
>  net/core/filter.c                                  |   4 -
>  net/core/sock_map.c                                |   2 +-
>  net/ipv4/esp4.c                                    |   2 +-
>  net/ipv4/fib_frontend.c                            |   2 +
>  net/ipv4/route.c                                   |   3 +-
>  net/ipv6/esp6.c                                    |   2 +-
>  net/ipv6/exthdrs.c                                 |  31 +-
>  net/ipv6/ip6_tunnel.c                              |   4 +-
>  net/mac80211/he.c                                  |   4 +-
>  net/mac80211/mlme.c                                |   9 -
>  net/mac80211/sta_info.c                            |   5 -
>  net/mptcp/subflow.c                                |   6 +-
>  net/mptcp/token.c                                  |   6 +-
>  net/netfilter/nf_tables_api.c                      |  14 +-
>  net/netfilter/nf_tables_offload.c                  |  17 +-
>  net/netfilter/nft_exthdr.c                         |   3 +
>  net/netfilter/nft_osf.c                            |   5 +
>  net/netfilter/nft_tproxy.c                         |   9 +-
>  net/netlabel/netlabel_mgmt.c                       |  19 +-
>  net/qrtr/ns.c                                      |   4 +-
>  net/sched/act_vlan.c                               |   7 +-
>  net/sched/cls_tcindex.c                            |   2 +-
>  net/sched/sch_qfq.c                                |   8 +-
>  net/sunrpc/sched.c                                 |  12 +-
>  net/tipc/bcast.c                                   |   2 +-
>  net/tipc/msg.c                                     |  17 +-
>  net/tipc/msg.h                                     |   3 +-
>  net/tls/tls_sw.c                                   |   2 +-
>  net/xdp/xsk_queue.h                                |  11 +-
>  net/xfrm/xfrm_device.c                             |   1 +
>  net/xfrm/xfrm_output.c                             |   7 -
>  net/xfrm/xfrm_state.c                              |  14 +-
>  samples/bpf/xdp_redirect_user.c                    |   4 +-
>  scripts/Makefile.build                             |   5 +-
>  scripts/tools-support-relr.sh                      |   3 +-
>  security/integrity/evm/evm_main.c                  |   5 +-
>  security/integrity/evm/evm_secfs.c                 |  13 +-
>  security/integrity/ima/ima_appraise.c              |   2 -
>  sound/firewire/amdtp-stream.c                      |   7 +-
>  sound/firewire/motu/motu-protocol-v2.c             |   5 +-
>  sound/pci/hda/patch_realtek.c                      |  49 ++-
>  sound/pci/intel8x0.c                               |   2 +-
>  sound/soc/atmel/atmel-i2s.c                        |  35 +-
>  sound/soc/codecs/cs42l42.h                         |   2 +-
>  sound/soc/codecs/max98373-sdw.c                    |  14 +-
>  sound/soc/codecs/max98373.h                        |   2 +-
>  sound/soc/codecs/rk3328_codec.c                    |  28 +-
>  sound/soc/codecs/rt1308-sdw.c                      |   2 +-
>  sound/soc/codecs/rt5682-i2c.c                      |   1 +
>  sound/soc/codecs/rt5682-sdw.c                      |  19 +-
>  sound/soc/codecs/rt700-sdw.c                       |   2 +-
>  sound/soc/codecs/rt711-sdw.c                       |   2 +-
>  sound/soc/codecs/rt715-sdw.c                       |   2 +-
>  sound/soc/fsl/fsl_spdif.c                          |  23 +-
>  sound/soc/fsl/fsl_xcvr.c                           |  10 +
>  sound/soc/hisilicon/hi6210-i2s.c                   |  14 +-
>  sound/soc/intel/boards/sof_sdw.c                   |  16 +-
>  sound/soc/mediatek/common/mtk-btcvsd.c             |  24 +-
>  sound/soc/sh/rcar/adg.c                            |   4 +-
>  sound/usb/format.c                                 |   2 +
>  sound/usb/mixer.c                                  |   8 +-
>  sound/usb/mixer.h                                  |   1 +
>  sound/usb/mixer_scarlett_gen2.c                    |   7 +-
>  tools/bpf/bpftool/main.c                           |   4 +-
>  tools/bpf/resolve_btfids/main.c                    |   3 +
>  tools/perf/util/llvm-utils.c                       |   2 +
>  .../util/scripting-engines/trace-event-python.c    | 146 +++---
>  tools/power/x86/intel-speed-select/isst-config.c   |  16 +
>  tools/power/x86/intel-speed-select/isst-core.c     |  15 +
>  tools/power/x86/intel-speed-select/isst-display.c  |   2 +-
>  tools/power/x86/intel-speed-select/isst.h          |   2 +
>  tools/testing/selftests/bpf/.gitignore             |   1 +
>  .../selftests/ftrace/test.d/event/event-no-pid.tc  |   7 +
>  tools/testing/selftests/kvm/dirty_log_test.c       |   1 -
>  tools/testing/selftests/kvm/lib/kvm_util.c         |   4 -
>  tools/testing/selftests/kvm/lib/x86_64/processor.c |   3 +
>  tools/testing/selftests/kvm/steal_time.c           |   2 -
>  .../testing/selftests/kvm/x86_64/set_boot_cpu_id.c |   2 -
>  tools/testing/selftests/lkdtm/run.sh               |  12 +-
>  tools/testing/selftests/net/tls.c                  |  87 ++--
>  .../testing/selftests/splice/short_splice_read.sh  | 119 ++++-
>  .../selftests/tc-testing/plugin-lib/scapyPlugin.py |   2 +-
>  tools/testing/selftests/vm/protection_keys.c       |  12 +-
>  743 files changed, 6465 insertions(+), 3314 deletions(-)
>=20
>=20
>=20

All tests passing for Tegra ...

Test results for stable-v5.12:
    10 builds:	10 pass, 0 fail
    28 boots:	28 pass, 0 fail
    104 tests:	104 pass, 0 fail

Linux version:	5.12.17-rc1-g09f2f41ef84e
Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
                tegra194-p2972-0000, tegra194-p3509-0000+p3668-0000,
                tegra20-ventana, tegra210-p2371-2180,
                tegra210-p3450-0000, tegra30-cardhu-a04

Tested-by: Jon Hunter <jonathanh@nvidia.com>

Jon
