Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EFBB930FAA5
	for <lists+stable@lfdr.de>; Thu,  4 Feb 2021 19:06:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238882AbhBDSFd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 4 Feb 2021 13:05:33 -0500
Received: from mail-eopbgr680075.outbound.protection.outlook.com ([40.107.68.75]:9263
        "EHLO NAM04-BN3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S238872AbhBDSFE (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 4 Feb 2021 13:05:04 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=KNDsRfmOt8i2ldqpYH+QZjbXEDQ2iBwf/PbDIGLexZ9qAu/0OwSe3tz6+5soPJGg4WpwR6os4qCLtg4ZAIZMOEr4LUDU7WWMDGb64sgIvomLizLZ6ze1nmly0gv1m1N2VChwiY8SuLddLkI5fAJbd+D/Mcf/IhXEjBLckozb9ZhRYS+ezDqUHSmMugInL2kLbDIwzniycADwkHRrZjrF5XQ2aVxxQkaaRqWNVM1sgbIPQns0UBWpkAhzw5vZumnViv9pJkQMtAr15msijSvV9R5EDcKGQIoYb0GU9Z4uIB/GKDtIrHEpeQu4v1kVYLw31U5n5VOY44ca6CAmolEr+Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=EvzJ/xT/WzP9syn6IeVt1xDUJjhrdw9TjyUsPIe8X6c=;
 b=cRjBECzzLXK8hsmtMpXDNdMjROI7FhEA89nV7o5g5Dsl1b/Uo7tper1dB77P8GCV1RAGD3ANEh7MR1tXOI6ZbH4k9Q3Xegq8dGihx3MIhtp+XxBeTTRTG2APs5ucFzWTPUxDl4QqHelBW6Me3OVzdiooCx1qSn/e6UssCDz+s8SXgXq9r9h+k6CxuNYV7/e9l5xg3v1v8v0XzqgmKBVzMaLPKQLHz6Ok/BF0CsUyqdyJcEVqiwQxwz43+fgk/+WrxdT05TdBbfY79PU3dPH6vbobjDIrQenBlB7F2x2Q+B+7h1IY5UK2XokMfqRlFYSax9aPD9qhJlFVM0F7JveTjg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=vmware.com; dmarc=pass action=none header.from=vmware.com;
 dkim=pass header.d=vmware.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=vmware.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=EvzJ/xT/WzP9syn6IeVt1xDUJjhrdw9TjyUsPIe8X6c=;
 b=Q2vI8ejCNIviq0figibes7073IYzmoXZ8eAovM1K4MHxXXGbBelcQpYA4eOOxJZ5+ik3NoSEDECN6SbFbfOzLTcb/xBEFcGdL886VhZ8OrK6QzygR9RvPiNoAXrz/EfaCBKYOI3xzmJ5RbEENNI8xKKC07QruIlXNewFxljJnCU=
Received: from (2603:10b6:a03:4a::18) by
 BYAPR05MB4584.namprd05.prod.outlook.com (2603:10b6:a02:f6::21) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3825.8; Thu, 4 Feb 2021 18:04:13 +0000
Received: from BYAPR05MB4776.namprd05.prod.outlook.com
 ([fe80::ddba:e1e9:fde7:3b31]) by BYAPR05MB4776.namprd05.prod.outlook.com
 ([fe80::ddba:e1e9:fde7:3b31%3]) with mapi id 15.20.3825.013; Thu, 4 Feb 2021
 18:04:13 +0000
From:   Nadav Amit <namit@vmware.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Lu Baolu <baolu.lu@linux.intel.com>
CC:     David Woodhouse <dwmw2@infradead.org>,
        Joerg Roedel <joro@8bytes.org>,
        "jroedel@suse.de" <jroedel@suse.de>, Will Deacon <will@kernel.org>,
        stable <stable@vger.kernel.org>
Subject: Re: FAILED: patch "[PATCH] iommu/vt-d: Do not use flush-queue when
 caching-mode is on" failed to apply to 5.10-stable tree
Thread-Topic: FAILED: patch "[PATCH] iommu/vt-d: Do not use flush-queue when
 caching-mode is on" failed to apply to 5.10-stable tree
Thread-Index: AQHW998tl2EKVogfqEyhoSsoFQXdzKpIUIoA
Date:   Thu, 4 Feb 2021 18:04:13 +0000
Message-ID: <52C9C14F-D496-4E11-9E63-CC9677DA4889@vmware.com>
References: <1612104088214157@kroah.com>
In-Reply-To: <1612104088214157@kroah.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: linuxfoundation.org; dkim=none (message not signed)
 header.d=none;linuxfoundation.org; dmarc=none action=none
 header.from=vmware.com;
x-originating-ip: [24.6.216.183]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 640b4a8f-c19c-4fee-eb12-08d8c93747bd
x-ms-traffictypediagnostic: BYAPR05MB4584:
x-microsoft-antispam-prvs: <BYAPR05MB4584821678D5E05BDBE87F61D0B39@BYAPR05MB4584.namprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8882;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: rDxL91bclGQg6dQp4cWoOL/cXeB7Y9QULOcluxOCYkFo7RDulyHVF9VZmRXhMrTqhf7cZiolgn96AcdG2cFyVy6syoegV69T4oY7I5jKHmXpVWIFpzZpr2LsbtnklrOw2EgieKGU3SqXvePouW58g56WH+4uYZiC3q6TXFJDGVO07doYRtLsJreVZM20TSBxbmMpd7hvuJTTbu7HfZ+8iaTBskAwjvVrdi+hlJHLuXYSyIPCxGWs/7D5KS3L4jKoedYf+JxxkRkpXT2doUgYdu6KMZon4onWPkBPtltM9pCPHYL+BQ7Zpjy0VB1NF39rnwk/CpaYhXiMxdVcwCSw7CS0JPlBlXv59MT4ukBO+A6a5UoKcpfQMQCFDR3rAD5aGq10JRl+gMJl8nxXpIiihoesMbBdwwynCSqOY/0+A3rCoQL9riZmyaM5fkLs/D8SwxWoKhYJEo9SazpTTt3nnPKWy7eM+2vBwj/4jFtVHXHi0kiH7uKoKz0AhwWJIri8MxVBE7aPzSXfV0rg040H4AhovXqC26sVWFXcUeigOQoZ6g49g+sYhCvJevaWTcQxVXl8CRdFYtoKAu4zNNzXTz98hH/OcBT/5YoKdDCB9lTO9OI0F9/PPs/5Zn0wcXLks4wazGtT9YEi+EWglkyyb2hFqZ0x1IDvak0RD6Co6so=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR05MB4776.namprd05.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(346002)(396003)(376002)(39860400002)(136003)(8936002)(53546011)(966005)(6506007)(54906003)(4326008)(66946007)(2616005)(186003)(110136005)(6486002)(36756003)(316002)(6512007)(86362001)(66476007)(33656002)(8676002)(66556008)(45080400002)(71200400001)(478600001)(83380400001)(5660300002)(2906002)(26005)(66446008)(76116006)(64756008)(45980500001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: =?us-ascii?Q?MxKHSFIaiHcqhjOIyKpAGKKefP/9lt1Q6BUF3hft0ZmMS3UEWXwUbBFtLUbP?=
 =?us-ascii?Q?q5woISWW/eX3UXTMpuKbVV2c2aZ0JKPkjSyHRuO3VgoTRfYfBRFnG01aPooy?=
 =?us-ascii?Q?9uBaT2Zm1xDyn8Dy5dOuXIGbTly+CNlOjSzmwZO/x10lDmiA4tnN2Bao6UJm?=
 =?us-ascii?Q?UjnsDz+IlhQ5G1iSV3otHohEkA/viqih9Es9ElLd8Zt4Gse4lS/y4xT37DPn?=
 =?us-ascii?Q?EreBhEAd49GbdAxfw0eIOjB7YNMq8iB3xfYqSYeskGQ0kAP48y8Fz3XTVb+X?=
 =?us-ascii?Q?Jn2vymlJ87yKiSRHWqqQglTRE+0Icpu1RktG7sCE56qDGuI/lh2yGJ2SgBqa?=
 =?us-ascii?Q?VnUFclSrQ86m8/BSQGHrqg0WW1UDlF3gZy0xQcQaAaBuVGjvBex77RDODyC2?=
 =?us-ascii?Q?27sdeTsDMku6o/moOywXaqi3v7B3mkt3aU3rp/wcJ4La5Do2wDJ3efglkkSk?=
 =?us-ascii?Q?tVa7Ta5K9393bE3+3rIPzjg3130HlUH1a8AbTjmzRpVRQoY+4m4vA0qLAVXr?=
 =?us-ascii?Q?g0gvZ+HsdaiRtOE6IZdHYxjAHMmZr3UYVIwfeVM62eRAM51J0WqgAhr51ZTz?=
 =?us-ascii?Q?ZEEsvcxgBRntRfqldZO9smQkNpYk8rlmuCT6Ngw9/6cA3BaCgmIpyV+r52jt?=
 =?us-ascii?Q?ygRM8hBIOD3jQ1W2eP2dnKYh5bgLffhESsp0zI1DLCT7DtUg2tcB0vmPwCU0?=
 =?us-ascii?Q?Vqax5ZO0lvcfB+nSnjv4ouz4EfQj3dnVnh05qwtdItLzr57vj5qX4YVxIK8L?=
 =?us-ascii?Q?pzuM5oH399ghg85H8IlCE86DiDq2O4RX0rjE7+RgAE/QY37dC+JTYEq2cHE7?=
 =?us-ascii?Q?xb4rN1w+FHSylkAFiWXc/OJxrNQHUfyYsvWtyy6sa9bOWzxFtItthhZVXZQx?=
 =?us-ascii?Q?0Zvh4vLboWZtKn3DyBEPucrwDStgj7CJU0EyzKkY8iZ7HszD/vJSlU4Htitv?=
 =?us-ascii?Q?byqqC9mU+PiDI/ijM4YyPPEcCNLlYZF9e5kvEsOVvTI4uKKAadRvoeKz6yh/?=
 =?us-ascii?Q?z70J8XU3MtpqYbASblijJgCIvnjB0CG9NJWsS70OjQ1nG7TxHas0GxlAVQcY?=
 =?us-ascii?Q?Cy70akB8FkbrUmTQbjnAq1lRkAyhGxzkX22oHymNSeEqpsqFQj2adY+l6y7C?=
 =?us-ascii?Q?RmyY691pBqSfNWxfsvcPkNX2hy+NGNnKADNZksRBB0nAFHAsz8fWaRkW8ROm?=
 =?us-ascii?Q?wi8WZkqIzkVs4dK8Gje/Jbp8I/n+7P7FsoR976FPqq6XI4WKAV23kjVbY1jS?=
 =?us-ascii?Q?cRSVZjrHbLa/cerdF/U7l2/FFJAzlBbuneLYibRwzEMRRKvCcwKdeNZBA0XO?=
 =?us-ascii?Q?rczPMjEI8SNB4YRYDGsHh2a/?=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-ID: <F58D1001EE4C2745A198A176BA90DA4D@namprd05.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: vmware.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BYAPR05MB4776.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 640b4a8f-c19c-4fee-eb12-08d8c93747bd
X-MS-Exchange-CrossTenant-originalarrivaltime: 04 Feb 2021 18:04:13.5179
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b39138ca-3cee-4b4a-a4d6-cd83d9dd62f0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: K0892/etvirGBt4Y062nQSUUNz4InDv4CHhiQz33HV3/dOgRRMHGEonXLsenjvEudFsOG64Gn56q5KpZ5EDHKQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR05MB4584
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Backporting requires to disable strict during initialization. Lu, can
you ack this patch?


-- >8 --

From d5ce982ce6f6f869c53cc0ed496a6dd4c1309657 Mon Sep 17 00:00:00 2001
From: Nadav Amit <namit@vmware.com>
Date: Tue, 26 Jan 2021 12:03:11 -0800
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

Fixes: 13cf01744608 ("iommu/vt-d: Make use of iova deferred flushing")
Signed-off-by: Nadav Amit <namit@vmware.com>
Cc: David Woodhouse <dwmw2@infradead.org>
Cc: Lu Baolu <baolu.lu@linux.intel.com>
Cc: Joerg Roedel <joro@8bytes.org>
Cc: Will Deacon <will@kernel.org>
Cc: stable@vger.kernel.org
---
 drivers/iommu/intel/iommu.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/iommu/intel/iommu.c b/drivers/iommu/intel/iommu.c
index 151243fa01ba..7e3db4c0324d 100644
--- a/drivers/iommu/intel/iommu.c
+++ b/drivers/iommu/intel/iommu.c
@@ -3350,6 +3350,11 @@ static int __init init_dmars(void)
=20
 		if (!ecap_pass_through(iommu->ecap))
 			hw_pass_through =3D 0;
+
+		if (!intel_iommu_strict && cap_caching_mode(iommu->cap)) {
+			pr_warn("Disable batched IOTLB flush due to virtualization");
+			intel_iommu_strict =3D 1;
+		}
 		intel_svm_check(iommu);
 	}
=20
--=20
2.25.1

> On Jan 31, 2021, at 6:41 AM, gregkh@linuxfoundation.org wrote:
>=20
>=20
> The patch below does not apply to the 5.10-stable tree.
> If someone wants it applied there, or to any other stable or longterm
> tree, then please email the backport, including the original git commit
> id to <stable@vger.kernel.org>.
>=20
> thanks,
>=20
> greg k-h
>=20
> ------------------ original commit in Linus's tree ------------------
>=20
> From 29b32839725f8c89a41cb6ee054c85f3116ea8b5 Mon Sep 17 00:00:00 2001
> From: Nadav Amit <namit@vmware.com>
> Date: Wed, 27 Jan 2021 09:53:17 -0800
> Subject: [PATCH] iommu/vt-d: Do not use flush-queue when caching-mode is =
on
>=20
> When an Intel IOMMU is virtualized, and a physical device is
> passed-through to the VM, changes of the virtual IOMMU need to be
> propagated to the physical IOMMU. The hypervisor therefore needs to
> monitor PTE mappings in the IOMMU page-tables. Intel specifications
> provide "caching-mode" capability that a virtual IOMMU uses to report
> that the IOMMU is virtualized and a TLB flush is needed after mapping to
> allow the hypervisor to propagate virtual IOMMU mappings to the physical
> IOMMU. To the best of my knowledge no real physical IOMMU reports
> "caching-mode" as turned on.
>=20
> Synchronizing the virtual and the physical IOMMU tables is expensive if
> the hypervisor is unaware which PTEs have changed, as the hypervisor is
> required to walk all the virtualized tables and look for changes.
> Consequently, domain flushes are much more expensive than page-specific
> flushes on virtualized IOMMUs with passthrough devices. The kernel
> therefore exploited the "caching-mode" indication to avoid domain
> flushing and use page-specific flushing in virtualized environments. See
> commit 78d5f0f500e6 ("intel-iommu: Avoid global flushes with caching
> mode.")
>=20
> This behavior changed after commit 13cf01744608 ("iommu/vt-d: Make use
> of iova deferred flushing"). Now, when batched TLB flushing is used (the
> default), full TLB domain flushes are performed frequently, requiring
> the hypervisor to perform expensive synchronization between the virtual
> TLB and the physical one.
>=20
> Getting batched TLB flushes to use page-specific invalidations again in
> such circumstances is not easy, since the TLB invalidation scheme
> assumes that "full" domain TLB flushes are performed for scalability.
>=20
> Disable batched TLB flushes when caching-mode is on, as the performance
> benefit from using batched TLB invalidations is likely to be much
> smaller than the overhead of the virtual-to-physical IOMMU page-tables
> synchronization.
>=20
> Fixes: 13cf01744608 ("iommu/vt-d: Make use of iova deferred flushing")
> Signed-off-by: Nadav Amit <namit@vmware.com>
> Cc: David Woodhouse <dwmw2@infradead.org>
> Cc: Lu Baolu <baolu.lu@linux.intel.com>
> Cc: Joerg Roedel <joro@8bytes.org>
> Cc: Will Deacon <will@kernel.org>
> Cc: stable@vger.kernel.org
>=20
> Acked-by: Lu Baolu <baolu.lu@linux.intel.com>
> Link: https://nam04.safelinks.protection.outlook.com/?url=3Dhttps%3A%2F%2=
Flore.kernel.org%2Fr%2F20210127175317.1600473-1-namit%40vmware.com&amp;data=
=3D04%7C01%7Cnamit%40vmware.com%7C8e7fe7007b4d4babe70b08d8c5f64c3f%7Cb39138=
ca3cee4b4aa4d6cd83d9dd62f0%7C0%7C0%7C637477008971904320%7CUnknown%7CTWFpbGZ=
sb3d8eyJWIjoiMC4wLjAwMDAiLCJQIjoiV2luMzIiLCJBTiI6Ik1haWwiLCJXVCI6Mn0%3D%7C1=
000&amp;sdata=3DBcaoGGKRC2k7fG5fHIjIdSp1H%2BHO%2FKLT0LCicI6PgKs%3D&amp;rese=
rved=3D0
> Signed-off-by: Joerg Roedel <jroedel@suse.de>
>=20
> diff --git a/drivers/iommu/intel/iommu.c b/drivers/iommu/intel/iommu.c
> index f665322a0991..06b00b5363d8 100644
> --- a/drivers/iommu/intel/iommu.c
> +++ b/drivers/iommu/intel/iommu.c
> @@ -5440,6 +5440,36 @@ intel_iommu_domain_set_attr(struct iommu_domain *d=
omain,
> 	return ret;
> }
>=20
> +static bool domain_use_flush_queue(void)
> +{
> +	struct dmar_drhd_unit *drhd;
> +	struct intel_iommu *iommu;
> +	bool r =3D true;
> +
> +	if (intel_iommu_strict)
> +		return false;
> +
> +	/*
> +	 * The flush queue implementation does not perform page-selective
> +	 * invalidations that are required for efficient TLB flushes in virtual
> +	 * environments. The benefit of batching is likely to be much lower tha=
n
> +	 * the overhead of synchronizing the virtual and physical IOMMU
> +	 * page-tables.
> +	 */
> +	rcu_read_lock();
> +	for_each_active_iommu(iommu, drhd) {
> +		if (!cap_caching_mode(iommu->cap))
> +			continue;
> +
> +		pr_warn_once("IOMMU batching is disabled due to virtualization");
> +		r =3D false;
> +		break;
> +	}
> +	rcu_read_unlock();
> +
> +	return r;
> +}
> +
> static int
> intel_iommu_domain_get_attr(struct iommu_domain *domain,
> 			    enum iommu_attr attr, void *data)
> @@ -5450,7 +5480,7 @@ intel_iommu_domain_get_attr(struct iommu_domain *do=
main,
> 	case IOMMU_DOMAIN_DMA:
> 		switch (attr) {
> 		case DOMAIN_ATTR_DMA_USE_FLUSH_QUEUE:
> -			*(int *)data =3D !intel_iommu_strict;
> +			*(int *)data =3D domain_use_flush_queue();
> 			return 0;
> 		default:
> 			return -ENODEV;


