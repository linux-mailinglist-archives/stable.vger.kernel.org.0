Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DE75B31101C
	for <lists+stable@lfdr.de>; Fri,  5 Feb 2021 19:40:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232793AbhBEQ5g (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 5 Feb 2021 11:57:36 -0500
Received: from mail-co1nam11on2078.outbound.protection.outlook.com ([40.107.220.78]:35585
        "EHLO NAM11-CO1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S233041AbhBEQr6 (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 5 Feb 2021 11:47:58 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=D+4UmyiwHQAZaNcYSU63P0AmplcJWsqUFTvr9S1zVe1ieWq8hBKIJMsGGZLjOvVG6hyba+cThuaZMZYauNBo/NMxPFQli/QQzwtDMhcRYgD3hs+Mctr4MtLBBGEfCM5CndoTt94/nNab3Zwc3yhLA9M2v7MPDHzROkRlYUIE2DN21YRkqLG8EntT4tAc1A4BObCwJHFr92AzjojQy99dpLugVpYAEJ9xkl++fQk2AHgc0AE+Nzsvi7sdfFzJzWL1C+5QET8mxq1y+B1+mbM9iSurbbqO+7uMe0gR8B7YhkZBqu9H/HLTPx+WuHb1ErmBZr0g2fgOd1H2nUU8xPcAmw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=55+9YvNgJG4L4Hwk7+uRE3ysXsba7Vv0Em23PXlVcIA=;
 b=Tan5jWHWpPJlKKqGimV9OJoSJKd90aJSU/hrjEcW8WYum8M2UxAGxwkzU8XKj49qKcJt1j5KRtj8sp19A7PQl/dcavin/4hhUGBRANq0ObpmEVHB/c0kpqsCKXC9h/vdbBioBkbiJ0l0D2+dAXS2OA3v0uYdzAVCi43aK97PUrf/MjB6kIVBZ8BnEgSX4GenquwPvCi73grtYwWMljGI/WZWR6l3NQzKkGYemW22ICRgL2hRv0KqAC7q9xPCsY+iNMe1OoIwC3w4uoLtV/n0BXMy6WdAPk8RM0lrHj2ErYowpnN1tGp9NU+hqrz4zf668sbM6jaTa8CKUxwdgJAOPg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=vmware.com; dmarc=pass action=none header.from=vmware.com;
 dkim=pass header.d=vmware.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=vmware.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=55+9YvNgJG4L4Hwk7+uRE3ysXsba7Vv0Em23PXlVcIA=;
 b=KCx7HIxMHTtQBcUtzvBbNsEQOGLxVdjxLPLUN/HrrRewrGVczZfdlCZbyuFtwPla7pyeNrHCt4zZ7SXtroeFqaf4igsvhwyE5TSBW1DEElfeZDFWBfWBK/e0dhNyCfiDHqJ7K5KyW8bEQ6SFH0nFUA8fldqIWg2wzSIfv+lcI8g=
Received: from (2603:10b6:a03:4a::18) by
 BY3PR05MB8034.namprd05.prod.outlook.com (2603:10b6:a03:361::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3846.11; Fri, 5 Feb
 2021 18:29:28 +0000
Received: from BYAPR05MB4776.namprd05.prod.outlook.com
 ([fe80::ddba:e1e9:fde7:3b31]) by BYAPR05MB4776.namprd05.prod.outlook.com
 ([fe80::ddba:e1e9:fde7:3b31%3]) with mapi id 15.20.3825.013; Fri, 5 Feb 2021
 18:29:28 +0000
From:   Nadav Amit <namit@vmware.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC:     Lu Baolu <baolu.lu@linux.intel.com>,
        David Woodhouse <dwmw2@infradead.org>,
        Joerg Roedel <joro@8bytes.org>,
        "jroedel@suse.de" <jroedel@suse.de>, Will Deacon <will@kernel.org>,
        stable <stable@vger.kernel.org>
Subject: Re: FAILED: patch "[PATCH] iommu/vt-d: Do not use flush-queue when
 caching-mode is on" failed to apply to 5.10-stable tree
Thread-Topic: FAILED: patch "[PATCH] iommu/vt-d: Do not use flush-queue when
 caching-mode is on" failed to apply to 5.10-stable tree
Thread-Index: AQHW998tl2EKVogfqEyhoSsoFQXdzKpIUIoAgAD4o4CAAKDAgA==
Date:   Fri, 5 Feb 2021 18:29:27 +0000
Message-ID: <803F8779-E4A5-43D9-9AAB-A64C763731B7@vmware.com>
References: <1612104088214157@kroah.com>
 <52C9C14F-D496-4E11-9E63-CC9677DA4889@vmware.com>
 <YB0HrznvibyfVBpu@kroah.com>
In-Reply-To: <YB0HrznvibyfVBpu@kroah.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: linuxfoundation.org; dkim=none (message not signed)
 header.d=none;linuxfoundation.org; dmarc=none action=none
 header.from=vmware.com;
x-originating-ip: [24.6.216.183]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 988ea82d-a26a-4caa-4c75-08d8ca03f8cb
x-ms-traffictypediagnostic: BY3PR05MB8034:
x-microsoft-antispam-prvs: <BY3PR05MB80344F7AD40B8BB393C7B0D5D0B29@BY3PR05MB8034.namprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: QNMiuQQZKbzXG7TookWDZTpk9bS2DAQpj9Ufwn8eATfPJ0su2e8w2wfueb5T/LpIX0ZfDF9NHtdqxa8h42H2i71D9gsl20A0uxR9eX1vkb3UXzCgT/IwX7CQ99l2W5t0QWchLlKv18stAFUSJPDasGW8z61eROE8qz67LEb0rGGkj1so6jpHICNltT9dj/hL8fXI5g84UFWVpJ4rcfHAZuyRkwO0E0fiENHsZII8ixWa7kg444hg6Ln9TvkuwtrN5ZR5wrBg1YXIu/nacXZMo3dxkTaheRsiToztow+b9Jlk+dMevKAJzAM9PHmUN8xdpeqCcyytXAiJdnyWgOpzuv0M5OVVw91Cmw0sXgiIHZcAxr4Ph3YInW5XZK3CFhuuL0gWuZAc8BpijvbgB7NuiQdTR8arZ/Z94NY3AWknJlI+05GdkhT1QGyJq8/qIbxxr0F8o28EzLCAqAf9Wk/fPIWcy7zn0cBcbXq3Uz5BG2+ROd3mBdFUa8HtXdO+VbwbMAFmV+sSfkwEdxXPnNizKP9VX3I4eIGRBEEQ+4lEbLRV5DZMvB/9RWAgU8mCU0ShhJjIWBC2zbJU7DKgKmTaQg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR05MB4776.namprd05.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(346002)(136003)(396003)(376002)(366004)(39860400002)(5660300002)(26005)(186003)(316002)(76116006)(66556008)(36756003)(83380400001)(53546011)(6916009)(6506007)(66446008)(64756008)(66476007)(66946007)(478600001)(6486002)(71200400001)(8676002)(4326008)(2616005)(54906003)(2906002)(33656002)(86362001)(8936002)(6512007)(45980500001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: =?us-ascii?Q?Hu+1+dCM/4Tms6euKXSJziTs6DRjk80OYStjGYkjPBxw9M/kKuFPc0+LtDZJ?=
 =?us-ascii?Q?C8y6t79Q0YgrcX+A+S9TCYIQfd5NDa34jyVE47mFr07i1SvZkXQ8oHA7MWG1?=
 =?us-ascii?Q?wGJdup1mIIesncQ3iRhnAfLi0pQthlQSYJ3ZaCZwE9MikZ7VxdcKbVH49But?=
 =?us-ascii?Q?nCLuRvgRk+Mo37bYMlU5kf6mpncU+jV56lTZd5vLMFocRhTgcWBebCbYOH4S?=
 =?us-ascii?Q?Tx3eNYJsV/iGttx92MjkAvt/+wTIk7z8xh4JNDqgaAhjiOwpPJns1RU4MeCh?=
 =?us-ascii?Q?RRva5PiEh0yuxZ6X6UkfC1/zImu7n8aapSgDMf3RKjOOSwgbS/GVzZHypD+d?=
 =?us-ascii?Q?dxnrnnGwl7tJhrVa4TOqcIuhqjuzDahIZOo1MmhcUix+Fme2/GLh4R5OoJ3b?=
 =?us-ascii?Q?fhErAdBDV48po2zhWs6OvrMdrpoiB22Jz6ClLcZ02qjQOrUDWIOVtvL86xIX?=
 =?us-ascii?Q?186ZGtnhsK2k8BjrFUDkz74SBeKHfju7FbmsqRz+88TexToVf1ZEX2XGc10W?=
 =?us-ascii?Q?UpVv9SHrJrmv4Nck07vW/8a0HV80B/Ia1e2h8h8iJzGPS1J4CZ7TAmk0n7/i?=
 =?us-ascii?Q?qh698J5HoB8oiJVpM5xRUCRrq3VY6En6sSCodGhbVQr3WdRScIAGFZtMfcar?=
 =?us-ascii?Q?6+o/Uuxul2OTm7QO1FOrWflKvCoGrWG66ouqBrj0NAsnujB8Jwk3zDEq03q2?=
 =?us-ascii?Q?ZTMuDy0ZT96Adr4CYKROHzI2Xmhcw+owgNDHJDAFG9H4ImDBTs9Ps4mnae3S?=
 =?us-ascii?Q?xfF9w4mpFmk6uNPdDccUvftL+zqZr9Y7g87qv7fS7PmKMKEcdBCgYDPQc7Lm?=
 =?us-ascii?Q?lSrnPoPvPeGQI0L6U6AHjW9TuuZPKitmbWKayGDB84/rcHuFWKyfnq3mZlBT?=
 =?us-ascii?Q?VNgiVPcvAsSeFwKhFbk3p3BW0yFUTU4HGvo/ShS0gLUHmaJ+SiZas+T8UkqL?=
 =?us-ascii?Q?QCBBcKtJixYjqTGMKTqCqz+m7wNyVZV1uYBe6nnEWQFn5thEKPiDu3kXs9BJ?=
 =?us-ascii?Q?shd7wwzaMB4mAnHSpDrdvT3xkaaG9uZlIzZOSb/HFFVnbbLb2Ud8Kbhh2gQZ?=
 =?us-ascii?Q?3FC2oti/TeMfNeRVulbEqpunTWcFDkKDrii//Kzhpdwu1cMNlvniXbuMDU/3?=
 =?us-ascii?Q?88NMoQHanLbYoUDVp24MTiZPU6oXdfQsudQKRE4DFk4XqnQ6xKhpzXwrhdHL?=
 =?us-ascii?Q?fno0imUVcoXzr468Aez8LWgn6L7RRzyg//xl4HgproCPrRQXhFf23oZiJqiG?=
 =?us-ascii?Q?3F2D4VGA8h3k+jcvOV7vrB1qM62LxJc2Y3D6aBxmyf8isSMtbsa+Pu6W3BxN?=
 =?us-ascii?Q?vf42OsDSX0Hn0RssKAQ9oSLV?=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-ID: <5D8F7E5973088B40B776143445BF103F@namprd05.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: vmware.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BYAPR05MB4776.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 988ea82d-a26a-4caa-4c75-08d8ca03f8cb
X-MS-Exchange-CrossTenant-originalarrivaltime: 05 Feb 2021 18:29:27.9181
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b39138ca-3cee-4b4a-a4d6-cd83d9dd62f0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: CxjqqjNtbYCHWx8VXN85G7i/kIRE8rdxeMrI6P4zo+nXbl/9HO3Qzb0sPRYSuMAMLMqdSHdGbe4JiZcfATlNpw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY3PR05MB8034
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

> On Feb 5, 2021, at 12:54 AM, Greg Kroah-Hartman <gregkh@linuxfoundation.o=
rg> wrote:
>=20
> On Thu, Feb 04, 2021 at 06:04:13PM +0000, Nadav Amit wrote:
>> Backporting requires to disable strict during initialization. Lu, can
>> you ack this patch?
>>=20
> This works for 5.10, thanks!  But what about 4.9, 4.14, 4.19, and 5.4?
> Those also need this change, right?

Thanks for taking the patch.

Yes, older kernels need to be patched too. I wanted Lu to ack the 5.10 patc=
h
first.

For 5.4 and older kernels, the patch is fundamentally the same as the one
for 5.10. Yet the patch that I sent for 5.10 does not apply cleanly, so
please use the following patch.

Please let me know if there is any problem.=20

-- >8 --

From 4abd08d6c3c997160257606a6c4057601d32dd7b Mon Sep 17 00:00:00 2001
From: Nadav Amit <namit@vmware.com>
Date: Mon, 1 Feb 2021 10:45:35 -0800
Subject: [PATCH] iommu/vt-d: do not use flush-queue when caching-mode is on

When an Intel IOMMU is virtualized, and a physical device is
passed-through to the VM, changes of the virtual IOMMU need to be
propagated to the physical IOMMU. The hypervisor therefore needs to
monitor PTE mappings in the IOMMU page-tables. Intel specifications
provide "caching-mode" capability that a virtual IOMMU uses to report
that the IOMMU is virtualized and a TLB flush is needed after mapping to
allow the hypervisor to propagate virtual IOMMU mappings to the physical
IOMMU. To the best of my knowledge no real physical IOMMU reports
"caching-mode" as turned on.

Synchronizing the virtual and the physical IOMMU tables is expensive if
the hypervisor is unaware which PTEs have changed, as the hypervisor is
required to walk all the virtualized tables and look for changes.
Consequently, domain flushes are much more expensive than page-specific
flushes on virtualized IOMMUs with passthrough devices. The kernel
therefore exploited the "caching-mode" indication to avoid domain
flushing and use page-specific flushing in virtualized environments. See
commit 78d5f0f500e6 ("intel-iommu: Avoid global flushes with caching
mode.")

This behavior changed after commit 13cf01744608 ("iommu/vt-d: Make use
of iova deferred flushing"). Now, when batched TLB flushing is used (the
default), full TLB domain flushes are performed frequently, requiring
the hypervisor to perform expensive synchronization between the virtual
TLB and the physical one.

Getting batched TLB flushes to use page-specific invalidations again in
such circumstances is not easy, since the TLB invalidation scheme
assumes that "full" domain TLB flushes are performed for scalability.

Disable batched TLB flushes when caching-mode is on, as the performance
benefit from using batched TLB invalidations is likely to be much
smaller than the overhead of the virtual-to-physical IOMMU page-tables
synchronization.

The backported patch checks upon init_dmars() whether any IOMMU has
caching-mode turned on, and if it is turns off strict-mode.

Fixes: 13cf01744608 ("iommu/vt-d: Make use of iova deferred flushing")
Signed-off-by: Nadav Amit <namit@vmware.com>
Cc: David Woodhouse <dwmw2@infradead.org>
Cc: Lu Baolu <baolu.lu@linux.intel.com>
Cc: Joerg Roedel <joro@8bytes.org>
Cc: Will Deacon <will@kernel.org>
Cc: stable@vger.kernel.org

Signed-off-by: Nadav Amit <namit@vmware.com>
---
 drivers/iommu/intel-iommu.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/iommu/intel-iommu.c b/drivers/iommu/intel-iommu.c
index 984c7a6ea4fe..953d86ca6d2b 100644
--- a/drivers/iommu/intel-iommu.c
+++ b/drivers/iommu/intel-iommu.c
@@ -3285,6 +3285,12 @@ static int __init init_dmars(void)
=20
 		if (!ecap_pass_through(iommu->ecap))
 			hw_pass_through =3D 0;
+
+		if (!intel_iommu_strict && cap_caching_mode(iommu->cap)) {
+			pr_info("Disable batched IOTLB flush due to virtualization");
+			intel_iommu_strict =3D 1;
+		}
+
 #ifdef CONFIG_INTEL_IOMMU_SVM
 		if (pasid_supported(iommu))
 			intel_svm_init(iommu);
--=20
2.25.1

