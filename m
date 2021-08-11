Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1B36A3E94F8
	for <lists+stable@lfdr.de>; Wed, 11 Aug 2021 17:47:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233454AbhHKPr5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 11 Aug 2021 11:47:57 -0400
Received: from mx0a-0064b401.pphosted.com ([205.220.166.238]:33382 "EHLO
        mx0a-0064b401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233608AbhHKPrY (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 11 Aug 2021 11:47:24 -0400
Received: from pps.filterd (m0250810.ppops.net [127.0.0.1])
        by mx0a-0064b401.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 17BEV1wr023792;
        Wed, 11 Aug 2021 08:46:48 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=windriver.com; h=from : to : cc :
 subject : date : message-id : content-transfer-encoding : content-type :
 mime-version; s=PPS06212021;
 bh=V/RjxPAZ9tuQg7cZXiS00MIoVwjtvLlCidOjskWwOjo=;
 b=bszYx+zKhmkKZmcFSbsS9L656wmRHu5zvmk8whpxfFo2SCwCXbxE79TCGuOebQDzSCAq
 xrJBaK4xNwP0SFZKLMC+qC8Tw/zjD08lpXGEChNgUec1qWdG8jyZArlEtn3DzYCLqzXr
 r0vixIdf21mUHBn88Qq1pi5k4FkA2MrRxSppEh5cPUXbFSgzLRL9FUXy1K2JsWsKFhHD
 buZUQHBEV2pXii0bKFYC/IbaQI97OcWYKgRU5bGJhi+MByt57Q6j/yu7fAj/P4LHnxjP
 JOWdvLPlrIOuf0HW+sTYMRwfR34oJtAJsoRMmPMip+7fxyl6MRGpv8rsGATLUDAkWm3d Mg== 
Received: from nam10-bn7-obe.outbound.protection.outlook.com (mail-bn7nam10lp2104.outbound.protection.outlook.com [104.47.70.104])
        by mx0a-0064b401.pphosted.com with ESMTP id 3ac2xf8gy7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 11 Aug 2021 08:46:48 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=TbVAt5CvuLdcd0cYx9LXpdD+2my68meCNqegYIW5XaKF0lxpSJkNPKV7AxfhjkErC4ayWjEI8JoNcJJSFMOn6fs99XLQrXSIh9wU2qVXtfVvezFzNV5g/nqx4spuM7iEoMeRepWIlU9WhJo/QcjTFVB5INP6DVk3psVJ7MYR3ReTapjGMhIAoVgRK6/7E5sOdmnhNlkWWUEKe+QsgoLOe3Rky+FQNnyk7khlIYqhE9862Cnix3xlJy9nf1ef9A372xEgPP2E1mcRDXvhV1l8dSDCliZqtBjVx59cm5adF0qHrHdaKfyauB45A+0t61iO1xYIJ5ofeArwVuKhP+FAgg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=V/RjxPAZ9tuQg7cZXiS00MIoVwjtvLlCidOjskWwOjo=;
 b=ARz/Rg8QAWka99T2u7uhmGjsXLWu6z0MXXrR8I8mFRobvDHpvKc23MlYERO8kGR49Fs9EzEa2iPF/Tw+fu0FpwbCCRsmNSihw/jSx9K3v+qM5HQHZ4ENrTAZpa0h4NfhmUcKNYDOQZu4NoxivKrEkCBJ3A5j6Izs7DMe6+GNO00UISPOOfb28iduwmQ+VGcwmumAjaesVG+vWk7b1qBxg2piJSu/fkHi8HekhhJiR4zEivO5fUHDV9IiMOGs6L2y3jQLaBGaNVYvNDSYXFTtTHluiaKb9DkhAZe/9aiCVYvyegee86jy3un81GISvh/IgwxNqRN6M3XfgksVKZGaNw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=windriver.com; dmarc=pass action=none
 header.from=windriver.com; dkim=pass header.d=windriver.com; arc=none
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none
 header.from=windriver.com;
Received: from DM4PR11MB5327.namprd11.prod.outlook.com (2603:10b6:5:392::22)
 by DM6PR11MB3852.namprd11.prod.outlook.com (2603:10b6:5:13a::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4394.20; Wed, 11 Aug
 2021 15:46:46 +0000
Received: from DM4PR11MB5327.namprd11.prod.outlook.com
 ([fe80::ccb:2bce:6896:a0c3]) by DM4PR11MB5327.namprd11.prod.outlook.com
 ([fe80::ccb:2bce:6896:a0c3%9]) with mapi id 15.20.4415.017; Wed, 11 Aug 2021
 15:46:46 +0000
From:   Ovidiu Panait <ovidiu.panait@windriver.com>
To:     stable@vger.kernel.org
Cc:     pbonzini@redhat.com, laijs@linux.alibaba.com
Subject: [PATCH 5.4 0/1] KVM: backport fix for CVE-2021-38198
Date:   Wed, 11 Aug 2021 18:46:28 +0300
Message-Id: <20210811154629.2104425-1-ovidiu.panait@windriver.com>
X-Mailer: git-send-email 2.25.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: VI1PR07CA0278.eurprd07.prod.outlook.com
 (2603:10a6:803:b4::45) To DM4PR11MB5327.namprd11.prod.outlook.com
 (2603:10b6:5:392::22)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from otp-linux03.wrs.com (46.97.150.20) by VI1PR07CA0278.eurprd07.prod.outlook.com (2603:10a6:803:b4::45) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4436.8 via Frontend Transport; Wed, 11 Aug 2021 15:46:45 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 8aa0a1e1-d9d3-405f-5e34-08d95cdf39a4
X-MS-TrafficTypeDiagnostic: DM6PR11MB3852:
X-Microsoft-Antispam-PRVS: <DM6PR11MB38525EE1CB977574546153BDFEF89@DM6PR11MB3852.namprd11.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:785;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: lTiOO8TQzhNJ2zndF7TdCOxmKdGEQMxQXCQaaPCyW/sXyTxcxDvfN+NhEIlLqRI8d8Q1/REpH4skeiFtvDYP8vCwtT4TI+tlqRyWtXRijscJlFnsSOCBT+xS60/xUWTVwn/zY4F86DyxCwZmeDSp1U6sKSmeB4zyGtHEAIKRlfh/Gjl0hgcMmyWGmdMSA/9PC03FB/0UMoMa9bA9OW6quT7ul3E4/4r+NsKxDcfBq05hw/G5xyg+VTXq1pEIO4DcxKikd8JFVyvY6phKSxLUSqKtmicm0tLWv4m060eW7xfEihxYG+5fQ2oOiZ2LjHYFMDR9a1dHgPwgG2ZIcib25GDtlAuc3eZiwhLpUcIm+8KstefHtA12ttC0icXiDmPGslRYoRm8glHMyRSiAH+vaYZmWihoorqozgxNczHH8DsKrac2SnlbaZOEWJOQ0LXqdS2wlH+/pUa8K5pWVEZEeD1ynV6W87C23Urv9QkLfBHUwTMNpoRgInj3c0a+gfyj0DBJM+R9HosojU+rd1PiGZ4G5E1HWAZGsoxMRCslyjI7prfztm3WhVPkHweKmLGi7n6/CdYJVi7X/3vkLvoXKSJQraHyfmruGhcgUHFo8CaLoJsVY32jFCuLPBDAwpH8FbFlscHG0YsPBFUpIJv4TSLxYcEwu8BvxJtzquEUaFkg92T3yisKS9ePMZ5k/rBCw4nD1V4hwop6eJGhir8hdszCe5MdnbWRtCxoDE4xjfP5gmXGs/vryJE1kjTgIiZ/VwZr8UN/geDTJRZs6Bsj8XhFUolnHd+yXJ8dvgGlkqE=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR11MB5327.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(376002)(39850400004)(136003)(366004)(346002)(396003)(186003)(83380400001)(316002)(44832011)(6666004)(8936002)(8676002)(26005)(1076003)(38100700002)(38350700002)(86362001)(36756003)(956004)(2616005)(66556008)(478600001)(6512007)(6506007)(4326008)(66476007)(966005)(5660300002)(19627235002)(52116002)(2906002)(66946007)(6916009)(6486002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?2HAGpa2K/FrcIx10AAG3ZrxHI6aHwxgURJk2hSPCjuF4CSN7h5TsIIEh/p10?=
 =?us-ascii?Q?/6mCp3pwxGUA5bF5ro5q7s/Fh9dtdcxVSxU/f4hwNQWpMZra3DfXXEL6rJhP?=
 =?us-ascii?Q?Kk7rMKOA6VqGspRiqedi/s2ye/YzHpfDNcxJZRXSAgyJxgfoiH0hoVuJumeb?=
 =?us-ascii?Q?IFgmkT7IKtD4k9w+uGuPsJI+G869HSl6+95em00+DCIbM5SUT+NukWNAR7A9?=
 =?us-ascii?Q?oYtN/Gn4zXVlsZj5FTaKBA2aMzxxSEMz3OAKjKfhKeeOyptetNGEaXdZ5fQm?=
 =?us-ascii?Q?htBt/vlhTvO/TlG8iFPKQXRJ563l5kURXXceeQUZrO6sRP6lwjriOgoqNEyU?=
 =?us-ascii?Q?MRTipqPoi2bGackHE7h+Gc34UY7LsTcljjR82mBlm6brj5XPp2zHPKnavnw1?=
 =?us-ascii?Q?vZBbZSJXBbiJtX4hsRtaQRTPFahj8R8fnHBAjnAW/Xyeh+LUHiA0DVhS7m1g?=
 =?us-ascii?Q?E3QFocQQRKFZB9Uaj7B/kbnld1UhNHuXxqPI30+o5z+MM0Z5ewt6QRPfPOpD?=
 =?us-ascii?Q?LBfWk+dwjsF/cwCavbkuvuYuTJHmcUdAAVIElCSK5LCjYKRGLwPGiWPIqUvn?=
 =?us-ascii?Q?Iq41AUq3RNH4dzqLxnrpwy0g+F49IAN24RAaiJ72euo6UbHZ2ajeb660cFgC?=
 =?us-ascii?Q?lRIXzhGzMe2Oaz7EQ6PJCkjLCLRi0wiBzwhwTEeAUfnLXNa56GrWr37CJjYL?=
 =?us-ascii?Q?XUB/8Su7KMOJ7j0m/akWQV4oosw+GxZc0cplNBhk3YXJq8w9X/5bfV06A2Ww?=
 =?us-ascii?Q?KyMVGmbdx6Xwpz6oAPqF4rqNWWhl9UPc2edPYkZmWTJrKueDrCUx0clQUlh8?=
 =?us-ascii?Q?9tt5l1HQ1oivxpopJ1medVcmyifomMZjfytJCdFMr6CE5VywNKwWTZY/9aUS?=
 =?us-ascii?Q?0jfyjI5sXamI74Z6yRY0L4uwb8f9xH9Pd2JHnEUigEFzTehhIF9wv2J15FXg?=
 =?us-ascii?Q?TX26cYaL4RIibnLkWe0l7ynwWBa4ji9KnCWMJUFvWR7gohMWNN7TwTnYKMNh?=
 =?us-ascii?Q?v3/3O6Gul1sDA3kQiTaMKT2N+T80tVdGh/903Oxi2FB0gWMRPTYHbvGFn2La?=
 =?us-ascii?Q?l+Z0BX1ezIURyWDDr5coXL+YiA/ZqyfZXZ8TGVqm1QYRsyQ1jP6PENFGw0KF?=
 =?us-ascii?Q?hUPP/6EfcfzdFxnWJdelFxoY9V41oFy6YJ9PCVEUguC7HDvLCo7i3va8aW3E?=
 =?us-ascii?Q?ozxxlJAcuZmBtpYr1hGVtzKuXctx2/zP/e+EqmbwzbYTwQ1z/NcVXJWpCXc+?=
 =?us-ascii?Q?YUFGpzM9/s25OqhZAMN7hPHOUGcMteCgNQjr05MvTuBihLcYTNp/KGgDPj2j?=
 =?us-ascii?Q?pUqvDBalyT3mRI4NLrpYeZYy?=
X-OriginatorOrg: windriver.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8aa0a1e1-d9d3-405f-5e34-08d95cdf39a4
X-MS-Exchange-CrossTenant-AuthSource: DM4PR11MB5327.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Aug 2021 15:46:46.5615
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ddb2873-a1ad-4a18-ae4e-4644631433be
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: fG0EvzTnkFlnoVPCYDfP5eeYYmCNbu4o/dvNROc+AoYMGBGFxAZiMZwE+vkozE3uC3tHSrtZsNmONSosLeTGf2KX3Ti2NY1T4Nwy4dYUX08=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR11MB3852
X-Proofpoint-ORIG-GUID: HxUULNaUUxNqIMxyVJSV79K-5iBH2uqE
X-Proofpoint-GUID: HxUULNaUUxNqIMxyVJSV79K-5iBH2uqE
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.182.1,Aquarius:18.0.790,Hydra:6.0.391,FMLib:17.0.607.475
 definitions=2021-08-11_05,2021-08-11_01,2020-04-07_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 suspectscore=0 mlxscore=0
 adultscore=0 mlxlogscore=770 clxscore=1011 impostorscore=0 bulkscore=0
 malwarescore=0 spamscore=0 lowpriorityscore=0 priorityscore=1501
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2107140000 definitions=main-2108110106
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The backport was validated by running the kvm-unit-tests testcase [1] mentioned
in the commit message.

Before the patch
----------------
root@intel-x86-64:~# modprobe kvm_intel ept=0
root@intel-x86-64:~# cat /sys/module/kvm_intel/parameters/ept
N
root@intel-x86-64:~# ./access
BUILD_HEAD=ba3c9773
timeout -k 1s --foreground 3600 /usr/bin/qemu-system-x86_64 --no-reboot -nodefaults -device pc-testdev -device isa-debug-exit,iobase=0xf4,iosize=0x4 -vnc none -serial stdio -device pci-testdev -machine accel=kvm -kernel /tmp/tmp.V6ME9Ebamh -smp 1 -cpu max # -initrd /tmp/tmp.DycLfAySkL
enabling apic
starting test

run
CR4.PKE not available, disabling PKE tests
..........................................................................................
test pte.p pte.rw pte.user pte.a pte.d pde.p pde.rw pde.user pde.a pdpte.ro user write: FAIL: unexpected access
Dump mapping: address: 0x1234c0200000
------L4: 5d72027
------L3: 5d71025
------L2: 5d74027
------L1: 2000067
check_effective_sp_permissions: write access at4 should fail

5898246 tests, 1 failures
FAIL access

After the patch
---------------
root@intel-x86-64:~# modprobe kvm_intel ept=0
root@intel-x86-64:~# cat /sys/module/kvm_intel/parameters/ept
N
root@intel-x86-64:~# ./access
BUILD_HEAD=ba3c9773
timeout -k 1s --foreground 3600 /usr/bin/qemu-system-x86_64 --no-reboot -nodefaults -device pc-testdev -device isa-debug-exit,iobase=0xf4,iosize=0x4 -vnc none -serial stdio -device pci-testdev -machine accel=kvm -kernel /tmp/tmp.UmWsRrn6l0 -smp 1 -cpu max # -initrd /tmp/tmp.Up02J8RkHY
enabling apic
starting test

run
CR4.PKE not available, disabling PKE tests
..........................................................................................
5898246 tests, 0 failures
PASS access

[1] https://gitlab.com/kvm-unit-tests/kvm-unit-tests/-/commit/47fd6bc54674fb1d8a29c55305042689e8692522

Lai Jiangshan (1):
  KVM: X86: MMU: Use the correct inherited permissions to get shadow
    page

 Documentation/virt/kvm/mmu.txt |  4 ++--
 arch/x86/kvm/paging_tmpl.h     | 14 +++++++++-----
 2 files changed, 11 insertions(+), 7 deletions(-)

-- 
2.25.1

