Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 737E328FC30
	for <lists+stable@lfdr.de>; Fri, 16 Oct 2020 03:08:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388837AbgJPBIh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 15 Oct 2020 21:08:37 -0400
Received: from mga02.intel.com ([134.134.136.20]:27272 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388836AbgJPBIh (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 15 Oct 2020 21:08:37 -0400
IronPort-SDR: Mgjm7FOtij+MGft67haseOEPD2IbCt5qj4AOme2A3uBI03pFarlrstoxdd2azQDS44/yFIa5v7
 yup7iz141bWw==
X-IronPort-AV: E=McAfee;i="6000,8403,9775"; a="153419729"
X-IronPort-AV: E=Sophos;i="5.77,380,1596524400"; 
   d="scan'208";a="153419729"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Oct 2020 18:08:35 -0700
IronPort-SDR: 81GzjUkca89JKIs9lzhhprZbOHQYZyu3wR9zIls1XOoQ4UwANidIgAkL975F2jChMsQVVRm8d1
 +P1yY6+1XjAA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.77,380,1596524400"; 
   d="scan'208";a="352026303"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by fmsmga002.fm.intel.com with ESMTP; 15 Oct 2020 18:08:34 -0700
Received: from orsmsx611.amr.corp.intel.com (10.22.229.24) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Thu, 15 Oct 2020 18:08:34 -0700
Received: from orsmsx609.amr.corp.intel.com (10.22.229.22) by
 ORSMSX611.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Thu, 15 Oct 2020 18:08:33 -0700
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx609.amr.corp.intel.com (10.22.229.22) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.1713.5
 via Frontend Transport; Thu, 15 Oct 2020 18:08:33 -0700
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (104.47.58.105)
 by edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.1713.5; Thu, 15 Oct 2020 18:08:26 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=eERgnikrFjSy0UcL8a8uIEM/g9pltpQcsaCoz5qjkOJwLpOq6jHUjjpHkKGIKhLTrnorK74kEOw/3njAVq7Rr+38hAMNbT1CE1QBxcBIyHqBFJwt2gOzJifb5cYTcwcySJ3JuK+SsXD9G7NXyMmJXDHCNNPIizbtR4Cc/3ZeKCwKTzLqNXVwT/bFwIe5A3OkvoaA7HDnoAc0bWDvhDRWOTY/2bivViobZjggu2UXHCjlvXSRffW6NwFTovNkR2X8TJfGf6JNFat8+jE0Z8VB6ixqZu8QRN7sTUw+TVsBAkoS4bORQBSMHXZU8K/OiwLBz2nzc4/BjmfbhdQuKuFYOg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=o0+3ve+X3i5FK8UgyCsn+N6cPLIR5OnYGF7/BCqZCjI=;
 b=hDPlehJNu4V2KtknWA4qi95HSOZQa9UZyqGxuXXSEt/FaA9xrQJlHcARfOOcZVlVdStIl7gGJ5B/X1He+uSPbNZleFucD95loHGr8vBcJyG7vdYPY611ebcngujh0O0C87HvckMsmV4CyXGsATAwUALCVCR4J7+SrJFp/kOOo5akREeAPefEyyVrH0lJKp6d/Wutkp+4ccTem5b8OrvLVMaKvy88/t9g5P8fCncecdqeKS5yJ9PfLN0V1aH3tJlgLNQUZinPwnAdJ5aeTmhM6tBjcV8Z9fXQ1Sxo1Gff1juffuZvxQNQ8g/e6uLPIp2ufn2b/u5RybcmXyuCGZqjEw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=intel.onmicrosoft.com;
 s=selector2-intel-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=o0+3ve+X3i5FK8UgyCsn+N6cPLIR5OnYGF7/BCqZCjI=;
 b=fEPSf4TE8x8bphPit6+Wu46uX55kwjc0pI0P7B9LHJwmNjshq9wPrYLdTEcUwRspVlWY6Wkn5bUIoXIxEz2swg4sqzbG5JI8X9SztVjUglUXadQGg6tW3GOuiQhZ+CRfXYqjbYmUa2ISQqvkeBtKg+RT4Ptrzo8Nujyq6jjiznA=
Received: from DM6PR11MB2956.namprd11.prod.outlook.com (2603:10b6:5:64::29) by
 DM6PR11MB2826.namprd11.prod.outlook.com (2603:10b6:5:c0::11) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3477.20; Fri, 16 Oct 2020 01:08:25 +0000
Received: from DM6PR11MB2956.namprd11.prod.outlook.com
 ([fe80::28f3:94e9:8013:8cc8]) by DM6PR11MB2956.namprd11.prod.outlook.com
 ([fe80::28f3:94e9:8013:8cc8%7]) with mapi id 15.20.3455.029; Fri, 16 Oct 2020
 01:08:25 +0000
From:   "Shi, Yang A" <yang.a.shi@intel.com>
To:     Chris Wilson <chris@chris-wilson.co.uk>,
        "intel-gfx@lists.freedesktop.org" <intel-gfx@lists.freedesktop.org>
CC:     "stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: RE: [Intel-gfx] [PATCH] drm/i915/gt: Delay execlist processing for
 tgl
Thread-Topic: [Intel-gfx] [PATCH] drm/i915/gt: Delay execlist processing for
 tgl
Thread-Index: AQHWoyyI8gjYqfQdDUm93r3746OifamZaZdQ
Date:   Fri, 16 Oct 2020 01:08:24 +0000
Message-ID: <DM6PR11MB2956DF219D9F3F46DAE1CDB3CD030@DM6PR11MB2956.namprd11.prod.outlook.com>
References: <20201015195023.32346-1-chris@chris-wilson.co.uk>
In-Reply-To: <20201015195023.32346-1-chris@chris-wilson.co.uk>
Accept-Language: zh-CN, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
dlp-product: dlpe-windows
dlp-reaction: no-action
dlp-version: 11.5.1.3
authentication-results: chris-wilson.co.uk; dkim=none (message not signed)
 header.d=none;chris-wilson.co.uk; dmarc=none action=none
 header.from=intel.com;
x-originating-ip: [192.198.147.213]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 26f0a575-929b-4e23-f166-08d8716ffbd1
x-ms-traffictypediagnostic: DM6PR11MB2826:
x-microsoft-antispam-prvs: <DM6PR11MB28260BC9A406343F0FD22795CD030@DM6PR11MB2826.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:1013;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: KIfU2fSjvwiWfNYeTY9xGc2KV3h1eNAcl5cg7kUd3/colXwqrWcc5r83IRjQlZz8jo34AlgiUs2ZCQIxpnRgA+usifQlo4TAEeFTxbZI3N1XCM4kGPnnGTRXHN2cQOcZa7HRoLl/JjlKJF8D354f+iEVXnienocYEdyBfBWRocI4cEH9qSfRsWDNSL7gy6ej9by4dGhl7k4hCaJE7JQ3dzLl/H/THby4BMCIJ+H2mHb7hTyzFBVhvtN+md3G+CvvxW9Wo4oXzRJE8K4iQIzPmGUZPQAGWM4taynB+BJ9rSMKWAomSNKyRcPgkZvju2LOK0F1HhlpQkLLP39y54wxALkOPCiUKuB3PErXDF0ctRA=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR11MB2956.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(346002)(376002)(39860400002)(366004)(136003)(396003)(316002)(83380400001)(4326008)(110136005)(71200400001)(966005)(86362001)(7696005)(52536014)(478600001)(55016002)(66946007)(2906002)(186003)(8676002)(76116006)(53546011)(6506007)(9686003)(66556008)(66446008)(33656002)(8936002)(5660300002)(26005)(66476007)(64756008);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: cQNQyk93RJcQlcymB0p9px1BzUtjuGjffaFpt6Opzw1VjXFTCbPSlXajfhn8xQX54Fap0dISq2J1EbZRbHe8ihjWiS3X5xJLW2pO6jihgHgbBnq6krQp0CJTMMv15z7mFcKfebwH5s+p8Tl/AnZCkR4Vw+EdVKN7xCRpu98cDONJsYUannsGf3aopLJUzbDuV1iRjxJotvIIOG8Jg5anOlI1KwN9bqkb/pC1tI1srvnUgcVPXLX4M8iWscy2E+UHlAK4oPBRRGU67+HGHlYx5FAtU4H80SOQwJU7R5LvB/SwYHJ8LJfx11J8FyGMZSnxLHeQ6I9Yq9cPWZlBiXo0aFxK/7ktxSqqWEYVzDhfe+mmmqVYzhxMWROA7OQBWQtznBrDTvSW22DN/sCoH99I88ViyObgLK+ectC/9AoAS6336aRcgRYJZQ6xIELm8pTiseP5qiT58M8gmZK8JryxdvzyYr8zPobnG9/NExIs85aRaKCa9v7XUdh4cqOKHzKT7enSQhlCLhYqcmBLVe43yOsYINaRm/nbLypqANqEBEM09zxBrf2CjNWID+KUuHLGSLPF5JmFSb6iqs6szacHU1MUQ+IISgssv5ECVSAlsHTLHlqLt+O+tJ/rNP6fF3vcKFTJcHakc2/vUSm5IY91IA==
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM6PR11MB2956.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 26f0a575-929b-4e23-f166-08d8716ffbd1
X-MS-Exchange-CrossTenant-originalarrivaltime: 16 Oct 2020 01:08:25.0675
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: up2SUH/Kuwca7nBs98WPx4Ny0WCBhsJuOyyxxwFF/13zinC1SMfAVmbnp4J3uFAJGfmHcrz7GmAS3LyZKGJRgA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR11MB2826
X-OriginatorOrg: intel.com
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Chris:
=09
	How to determine the length of the magic delay in here?


Best Regards.
Yang


> -----Original Message-----
> From: Intel-gfx <intel-gfx-bounces@lists.freedesktop.org> On Behalf Of Ch=
ris Wilson
> Sent: Friday, October 16, 2020 3:50 AM
> To: intel-gfx@lists.freedesktop.org
> Cc: stable@vger.kernel.org; Chris Wilson <chris@chris-wilson.co.uk>
> Subject: [Intel-gfx] [PATCH] drm/i915/gt: Delay execlist processing for t=
gl
>=20
> When running gem_exec_nop, it floods the system with many requests (with =
the goal of
> userspace submitting faster than the HW can process a single empty batch)=
. This causes
> the driver to continually resubmit new requests onto the end of an active=
 context, a flood
> of lite-restore preemptions. If we time this just right, Tigerlake hangs.
>=20
> Inserting a small delay between the processing of CS events and submittin=
g the next
> context, prevents the hang. Naturally it does not occur with debugging en=
abled. The
> suspicion then is that this is related to the issues with the CS event bu=
ffer, and inserting
> an mmio read of the CS pointer status appears to be very successful in pr=
eventing the
> hang. Other registers, or uncached reads, or plain mb, do not prevent the=
 hang, suggesting
> that register is key -- but that the hang can be prevented by a simple ud=
elay, suggests it is
> just a timing issue like that encountered by commit 233c1ae3c83f ("drm/i9=
15/gt: Wait for
> CSB entries on Tigerlake"). Also note that the hang is not prevented by a=
pplying
> CTX_DESC_FORCE_RESTORE, or by inserting a delay on the GPU between reques=
ts.
>=20
> Signed-off-by: Chris Wilson <chris@chris-wilson.co.uk>
> Cc: Mika Kuoppala <mika.kuoppala@linux.intel.com>
> Cc: Bruce Chang <yu.bruce.chang@intel.com>
> Cc: Joonas Lahtinen <joonas.lahtinen@linux.intel.com>
> Cc: stable@vger.kernel.org
> ---
>  drivers/gpu/drm/i915/gt/intel_lrc.c | 3 +++
>  1 file changed, 3 insertions(+)
>=20
> diff --git a/drivers/gpu/drm/i915/gt/intel_lrc.c b/drivers/gpu/drm/i915/g=
t/intel_lrc.c
> index 6170f6874f52..d15d561152ba 100644
> --- a/drivers/gpu/drm/i915/gt/intel_lrc.c
> +++ b/drivers/gpu/drm/i915/gt/intel_lrc.c
> @@ -2711,6 +2711,9 @@ static void process_csb(struct intel_engine_cs *eng=
ine)
>  			smp_wmb(); /* complete the seqlock */
>  			WRITE_ONCE(execlists->active, execlists->inflight);
>=20
> +			/* Magic delay for tgl */
> +			ENGINE_POSTING_READ(engine,
> RING_CONTEXT_STATUS_PTR);
> +
>  			WRITE_ONCE(execlists->pending[0], NULL);
>  		} else {
>  			if (GEM_WARN_ON(!*execlists->active)) {
> --
> 2.20.1
>=20
> _______________________________________________
> Intel-gfx mailing list
> Intel-gfx@lists.freedesktop.org
> https://lists.freedesktop.org/mailman/listinfo/intel-gfx
