Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2A7B43C4134
	for <lists+stable@lfdr.de>; Mon, 12 Jul 2021 04:27:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232307AbhGLCaU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 11 Jul 2021 22:30:20 -0400
Received: from mga17.intel.com ([192.55.52.151]:50054 "EHLO mga17.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229818AbhGLCaT (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 11 Jul 2021 22:30:19 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10042"; a="190294649"
X-IronPort-AV: E=Sophos;i="5.84,232,1620716400"; 
   d="scan'208";a="190294649"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Jul 2021 19:27:28 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.84,232,1620716400"; 
   d="scan'208";a="493246176"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by orsmga001.jf.intel.com with ESMTP; 11 Jul 2021 19:27:28 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2242.10; Sun, 11 Jul 2021 19:27:27 -0700
Received: from orsmsx602.amr.corp.intel.com (10.22.229.15) by
 ORSMSX610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2242.10; Sun, 11 Jul 2021 19:27:27 -0700
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2242.10 via Frontend Transport; Sun, 11 Jul 2021 19:27:27 -0700
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (104.47.70.100)
 by edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2242.4; Sun, 11 Jul 2021 19:27:27 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=oZpbckCSj/8+rHnQ9bslF9FUMp2y8zGNebKg2fBDSC/O7ZXkqKtNhn2qyFpWan5FKGpg3Pf9PkgZwfnBQhCLY9BaWfU9bhSpMVSsOtnShORHsnMjdOGN1tr+EQ5XUiva519GORDw7br2ed+x6mtaWcGl5ZZSzbcIcRlLc8AYG+OYJJRxiZhvAt2UiqZ3pJbu0sbcRCjmohIaL0u9HHDO0yBvUjjmrjC1ReRgtOkrEjMIiCZd6xPldG/AG1GiP3epaNPqWQQtaysldRpYitS1Ipjr7EUeVjhUtX4IXI7xS1WKRhOW762zd7M6jBpATLd6ko0XA45KMAy62ICpd8hQ4Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=PYanOiqs41ZLoh4DhzSiNeXoeMkYOipSchrssqNjEHQ=;
 b=V+WDiBlyCYllU1rg8GeLd4MTXxNqmmdUsGHuZi6sS9fqgnWqSyBCBxNKyo4fkENk43SWOWkVq/PMDVhmLH1LSIKu2piiV8L/iKsS68pVWrUzszUM5hoR8JuUGrzI8DvhoO1juk9Foq+qzhefgJPV+2Y1wsYERpkX+O3k2QrVQUzIoy/x/i8djwDGSFdXPreAgBYZl4HlDiPCKijAvZlHCkQs2PBPH+oPie+f3L/d8b/rMxAnfmiIGjbtPlDDdD7Gh8rfNfEgc22jn9X4mza2Z3OxajjsWpIk20r6DNZ3wpY7PlNSisNY207FJvkGUEGVg3zQHEKBenvqGYWHVFdUNQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=intel.onmicrosoft.com;
 s=selector2-intel-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=PYanOiqs41ZLoh4DhzSiNeXoeMkYOipSchrssqNjEHQ=;
 b=SRH0BxqsiXJw693iOZTB8V3wHJn1IrrSO2dept3ab2ES4p1Mj7tq7hr0IV8QebSP0/8+w+UupSA9BLXXWil5gQT7fpkZv6l9z0YY8NnaoF3OSaGIIFNbm99426lbyfkOjmQ4/U1SWtxYMoDvRDZfXZkkO/OJGyEzEwwhZ18bq80=
Received: from DM6PR11MB3819.namprd11.prod.outlook.com (2603:10b6:5:13f::31)
 by DM4PR11MB5421.namprd11.prod.outlook.com (2603:10b6:5:398::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4242.22; Mon, 12 Jul
 2021 02:27:24 +0000
Received: from DM6PR11MB3819.namprd11.prod.outlook.com
 ([fe80::3dc3:868b:cec3:513b]) by DM6PR11MB3819.namprd11.prod.outlook.com
 ([fe80::3dc3:868b:cec3:513b%6]) with mapi id 15.20.4308.026; Mon, 12 Jul 2021
 02:27:24 +0000
From:   "Wu, Hao" <hao.wu@intel.com>
To:     Kajol Jain <kjain@linux.ibm.com>,
        "will@kernel.org" <will@kernel.org>,
        "mark.rutland@arm.com" <mark.rutland@arm.com>,
        "Xu, Yilun" <yilun.xu@intel.com>
CC:     "trix@redhat.com" <trix@redhat.com>,
        "mdf@kernel.org" <mdf@kernel.org>,
        "linux-fpga@vger.kernel.org" <linux-fpga@vger.kernel.org>,
        "maddy@linux.ibm.com" <maddy@linux.ibm.com>,
        "atrajeev@linux.vnet.ibm.com" <atrajeev@linux.vnet.ibm.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linuxppc-dev@lists.ozlabs.org" <linuxppc-dev@lists.ozlabs.org>,
        "rnsastry@linux.ibm.com" <rnsastry@linux.ibm.com>,
        "linux-perf-users@vger.kernel.org" <linux-perf-users@vger.kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: RE: [PATCH v2] fpga: dfl: fme: Fix cpu hotplug issue in performance
 reporting
Thread-Topic: [PATCH v2] fpga: dfl: fme: Fix cpu hotplug issue in performance
 reporting
Thread-Index: AQHXdJ6Olv3FhDOpC0+B/jPwvOSEk6s+nwpQ
Date:   Mon, 12 Jul 2021 02:27:24 +0000
Message-ID: <DM6PR11MB38197304C3BC02672304201A85159@DM6PR11MB3819.namprd11.prod.outlook.com>
References: <20210709084319.33776-1-kjain@linux.ibm.com>
In-Reply-To: <20210709084319.33776-1-kjain@linux.ibm.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
dlp-product: dlpe-windows
dlp-reaction: no-action
dlp-version: 11.5.1.3
authentication-results: linux.ibm.com; dkim=none (message not signed)
 header.d=none;linux.ibm.com; dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 2035c0bc-912a-418c-ec0b-08d944dc95c6
x-ms-traffictypediagnostic: DM4PR11MB5421:
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <DM4PR11MB5421358E4E61549C22E2CA1C85159@DM4PR11MB5421.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:4303;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: EfJ74BvqUQwxKb5rkukTCxDwHDQ9YqyCJc6hgE7hcL0KlEgvPq94eqH17tfv7upu/tSu2PY13xTnYgP8nGEnr3ALQNRrI+sQNztprK3ih+6Um68eAmB5GE1j/dyFrGz56gjrgS++ec6dSad8R2qLQSJCEf6Rkg/IYR2xmC4RNoBcJEuNDFzfag1MtGJQ/sAnP1VJ2Z/lIDF/5+JZBxsS594WKbVA6o87N1lyabqmILU3I7hgPDFYTU5olj3aVmI7/Xufc+sevyxHko0Wu61lCZiKheDtFC8WvYvVLx2IMwhb2tbnoFLinwD1nQWT/fgsrFOOdcxuVoK3HRAJf2vruH8RHYxoRt3CbO8H0jpOwoaY30jgcw09Eb3cM12o2LPquDRMQQBv/TFapfDKLJATuh9Gaxd0MFDG2uYj4UWH0YfkIrBmFD3KFAJKmawgpF8zyVLqZ+0osfvcNh6ka+sPBEI7ApQy3yNNrOX9zLO0sytRJFQFYsqA+x0MDtNt9xGPCwTp/farAYiQ6PEzZu/mX2M5VYCyx/z45KBVz7m8wMiXJzPeRyG58fp88EL6ENDgJvn5S/lHzC/3raPJ4pSJzYXdOP/1x2m/Z0oyzcYPwqz2dKlGDFf8dIBG2apJXVS0Q5QQu7QLr96eKWBDWyUKYpkKlJthbbI42GiIwhou04TROnGz5/vKXApijz+47hzFSHfdMRVUI5tes8iIAK1nAi5u2FTsAWbc3ReEuylBHMg=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR11MB3819.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(136003)(346002)(366004)(396003)(376002)(39860400002)(86362001)(9686003)(7416002)(186003)(6636002)(26005)(64756008)(83380400001)(6506007)(5660300002)(33656002)(76116006)(8936002)(52536014)(478600001)(966005)(2906002)(110136005)(122000001)(66556008)(71200400001)(55016002)(8676002)(38100700002)(66446008)(66946007)(66476007)(4326008)(54906003)(7696005)(316002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?4ugT/pDLy5EV6tDElHTJkUbmxnq5I55BCDt1yYNF7H4uEkqeGrx5iFIrOE2s?=
 =?us-ascii?Q?803yNQ48bgjDn+gj0hHNJM9DyYk9s6JnCWcBN+WeGznGuBN4/kxt45WRq8fc?=
 =?us-ascii?Q?XdtXuhAkzuVcxLhg2spVQtIa9teby7To8ire/K29OJNM/pVvhlsLMOvwpmDA?=
 =?us-ascii?Q?0TaO54CKpJapuKENAik1pyO8IB7mqJpEODcSNQwPEnSaVlpzXXS+pud5xFnC?=
 =?us-ascii?Q?188kfY5iHyG2BjOVxZndrR3LH/tDw1jkR9OjRokCdLfd+1m4Tfw6hcGqCaya?=
 =?us-ascii?Q?FN6fSPQEODpIxXahdL75cId3SyVmd0Fs9OxJ0ujEEFU4jcAeQNH7z19MsTf4?=
 =?us-ascii?Q?nV63iNuKrzWtgjpYcQe6zLL+sGubC36gFZf6p3IwVt+J5JB61RYko571FYG8?=
 =?us-ascii?Q?zv5aj+iFSpERN1lwu7EMdApBIMEfzJtnjNx5DiQgz9I1wRlk0B4HXhZnI0MT?=
 =?us-ascii?Q?Q3f+9eZxP1LLab6rnMo+tDJGhqYA0JQANbGGrUNoLienChYutzpPUA0vnT6O?=
 =?us-ascii?Q?qbHMyiti0uNUnXm8+Y2pXsDL4IbQY3Eb6ZLlBH+X8P98j/c6SV+TSPhxYaBf?=
 =?us-ascii?Q?YAzM0qnWOhD8XpLac52Ud8DVaFhqOn4SCdMxKw9CCP+aTesy8IJMlVz+egi6?=
 =?us-ascii?Q?bgfqW5WEx3PJgi/0HJo7B/Vc2L3sCjNOzce0G0fA3tSYQWIbvRHVqzOq1ibP?=
 =?us-ascii?Q?ZCcuEZaGRn5Ejatx1HuYTbwvS2dlHk+YtLnRCFhQVwAk5SyAwcCiNpN6Jqbb?=
 =?us-ascii?Q?LmIRw5lExZGEofvBmniVLFopvmHIW8qH4h5VRG9bnloHTedRZTgnNcFpVhfs?=
 =?us-ascii?Q?k28d43RNajRKEe796wlQCX7kLS1cRLBkSfubGNcBcQr/RKTepdesJkJb9rx7?=
 =?us-ascii?Q?Xw8tj4wls4zLYB3yXR8njmd1KAcvk5mLNtPZb8cqqGfGfdHDL2owBVZliuU6?=
 =?us-ascii?Q?uZk/y6TGyGoCqo+4Xn+zrCTR16O/+Durgk5+T1YtS525/PUQdGFz0IkSNT08?=
 =?us-ascii?Q?dztjtG+UOOp0RX7tKJI9WIFu3LpuJB5SU9U2RULSan+T2wI2sh4YbjzgRrWO?=
 =?us-ascii?Q?XyVULntuUeMiNAIveP2NrZOrWUyDObxp4+riUIRwoHWiysSJSD1RFfeLBKmg?=
 =?us-ascii?Q?USTPGMxDOnXiqRX4GyZu3uY/0TAcIpb1zdbgB1rKuqZqCLwLimAwI17U+aC1?=
 =?us-ascii?Q?IwJdygB4YswILzSPOkNm4nt4dridffg7oHRgXpJX3JphaTTlqVnemky9MFo0?=
 =?us-ascii?Q?DNOTud2n3PNKH1r+a6LPvECNzww9b5/PpGAITSom9os4nSNwHM4tw4Yi3HTJ?=
 =?us-ascii?Q?rGibxLJ+ZhJeIHXWF84qQWUj?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM6PR11MB3819.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2035c0bc-912a-418c-ec0b-08d944dc95c6
X-MS-Exchange-CrossTenant-originalarrivaltime: 12 Jul 2021 02:27:24.5221
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: rtPEcShbylyS4W+xJs4OlJcmTG7iw/+Df/JFHZo1LkUVGaVXsmUCHAllGOT7Uocl8K426C72NBT9Wt/wUtIv2w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR11MB5421
X-OriginatorOrg: intel.com
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

> Subject: [PATCH v2] fpga: dfl: fme: Fix cpu hotplug issue in performance
> reporting
>=20
> The performance reporting driver added cpu hotplug
> feature but it didn't add pmu migration call in cpu
> offline function.
> This can create an issue incase the current designated
> cpu being used to collect fme pmu data got offline,
> as based on current code we are not migrating fme pmu to
> new target cpu. Because of that perf will still try to
> fetch data from that offline cpu and hence we will not
> get counter data.
>=20
> Patch fixed this issue by adding pmu_migrate_context call
> in fme_perf_offline_cpu function.
>=20
> Fixes: 724142f8c42a ("fpga: dfl: fme: add performance reporting support")
> Tested-by: Xu Yilun <yilun.xu@intel.com>
> Signed-off-by: Kajol Jain <kjain@linux.ibm.com>

Thanks for this fixing! And thanks Yilun for the verification too. : )

> Cc: stable@vger.kernel.org
> ---
>  drivers/fpga/dfl-fme-perf.c | 4 ++++
>  1 file changed, 4 insertions(+)
>=20
> ---
> Changelog:
> v1 -> v2:
> - Add stable@vger.kernel.org in cc list
>=20
> RFC -> PATCH v1
> - Remove RFC tag
> - Did nits changes on subject and commit message as suggested by Xu Yilun
> - Added Tested-by tag
> - Link to rfc patch: https://lkml.org/lkml/2021/6/28/112
> ---
> diff --git a/drivers/fpga/dfl-fme-perf.c b/drivers/fpga/dfl-fme-perf.c
> index 4299145ef347..b9a54583e505 100644
> --- a/drivers/fpga/dfl-fme-perf.c
> +++ b/drivers/fpga/dfl-fme-perf.c
> @@ -953,6 +953,10 @@ static int fme_perf_offline_cpu(unsigned int cpu, st=
ruct
> hlist_node *node)
>  		return 0;
>=20
>  	priv->cpu =3D target;
> +
> +	/* Migrate fme_perf pmu events to the new target cpu */

Only one minor item, this line is not needed. : )

After remove it,=20
Acked-by: Wu Hao <hao.wu@intel.com>

Thanks
Hao

> +	perf_pmu_migrate_context(&priv->pmu, cpu, target);
> +
>  	return 0;
>  }
>=20
> --
> 2.31.1

