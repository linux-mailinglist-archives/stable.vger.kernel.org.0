Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8C68D4B22F2
	for <lists+stable@lfdr.de>; Fri, 11 Feb 2022 11:19:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235318AbiBKKTK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 11 Feb 2022 05:19:10 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:49058 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229671AbiBKKTK (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 11 Feb 2022 05:19:10 -0500
Received: from mga11.intel.com (mga11.intel.com [192.55.52.93])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0CB3E2A5
        for <stable@vger.kernel.org>; Fri, 11 Feb 2022 02:19:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1644574749; x=1676110749;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=4f5tW6dPHvXXhMdALxMRwQXq2xtgNTJ45vFO2T0qaXs=;
  b=BGoCDifW4McDKyaIjaI4/S6z/OTVH/Bswn7wQnCP4oe2dj+zwqld0kyV
   Fm2PpJ6mL2fsazXFtpYwiMYCyii2IQKfiL67/3NPpqwF0GWxx9SdQAfwd
   4tEF2TM0hlexGqqm5wg3Tlq1TzNLuJz9hwLx4QcRak2RhGLfgutRzujRo
   e1wg9q27PnNt+lXtUmnQDK81bImM2ovnkEVnaxGsNPldoUcFT3F+Hof8i
   bqASGt2ultLNkR7PkqchPSIAQ5olC75Tr0AZbh6fgCcIjg7BG4W4nacH3
   RbzkrATEMQ2Jtnpjv+76f+JnWVZanS4dqeba7uFd1LjQBcK9l8lirDJeR
   g==;
X-IronPort-AV: E=McAfee;i="6200,9189,10254"; a="247298638"
X-IronPort-AV: E=Sophos;i="5.88,360,1635231600"; 
   d="scan'208";a="247298638"
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Feb 2022 02:19:08 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.88,360,1635231600"; 
   d="scan'208";a="500735234"
Received: from orsmsx605.amr.corp.intel.com ([10.22.229.18])
  by orsmga002.jf.intel.com with ESMTP; 11 Feb 2022 02:19:08 -0800
Received: from orsmsx611.amr.corp.intel.com (10.22.229.24) by
 ORSMSX605.amr.corp.intel.com (10.22.229.18) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.20; Fri, 11 Feb 2022 02:19:07 -0800
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx611.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.20 via Frontend Transport; Fri, 11 Feb 2022 02:19:07 -0800
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (104.47.58.109)
 by edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2308.20; Fri, 11 Feb 2022 02:19:07 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ZZEhpBYjisd90pPa87STJ29iAOpYflL4JeXirJJItj0ggbh97B7P/KK0dPxmo4V1z8650sGdBPEATsU8h+y79YIVXEQauVv4C+2ZJbJr9vmJVZ7ayNQngSshUwsSadjxrIwumAiPAKXrF3gde+nPsqR8xfryYstza6plAXp+uFLM+g/L5TKGmBNxkB5y16vj+9O0kyKv8Ly4prRs8V2NOXqjKSmisQ7hVSt7pl6TZmq8re4E+cB3UPDE3rZbXDZxk+Md0pVF9KnUFvSvvII7MD4IUQ0HisIitzfpb4O9/VuwP2vTwZ/ipidyK/95PYhVwfb9ve+fBv54F3RK3iD0ug==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=4f5tW6dPHvXXhMdALxMRwQXq2xtgNTJ45vFO2T0qaXs=;
 b=kDS9Njigpp588vLArhWxNQIMamjAOHCCLohdxQE91iCGtFhiNL53vglDlLtoo9zRq7EoOgD0EsVt8JPsKjlxqNOgpmo865LOLMLK0UMHjobsdI4fbcID2rij+zhf4G3yvmJ5c2bP88KzXU8nOQtWsthE4OXNmwbeWNO3HcWnxQI6seIDopoiJ9JPcfrYh7Q5QIZV++gL5wJU8RT0r7+RC1FxQEnouLmgkjZNKcY5m6bjiuzEbm3zxOK8w2zuNe4uoqpF1lhLeanlP+sgmJUe6RWeoSD5Nf/Ssc2E0QMmNpI2NSojUxAwSUMIpdY7wQpLf/6hl7C7riNlYpXKxgfw9g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
Received: from CY4PR1101MB2184.namprd11.prod.outlook.com
 (2603:10b6:910:24::20) by CH2PR11MB4422.namprd11.prod.outlook.com
 (2603:10b6:610:4a::16) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4975.11; Fri, 11 Feb
 2022 10:19:05 +0000
Received: from CY4PR1101MB2184.namprd11.prod.outlook.com
 ([fe80::5572:7316:96ef:1839]) by CY4PR1101MB2184.namprd11.prod.outlook.com
 ([fe80::5572:7316:96ef:1839%4]) with mapi id 15.20.4951.021; Fri, 11 Feb 2022
 10:19:05 +0000
From:   "Pawnikar, Sumeet R" <sumeet.r.pawnikar@intel.com>
To:     Greg KH <gregkh@linuxfoundation.org>
CC:     "stable@vger.kernel.org" <stable@vger.kernel.org>,
        "Wysocki, Rafael J" <rafael.j.wysocki@intel.com>,
        "srinivas.pandruvada@linux.intel.com" 
        <srinivas.pandruvada@linux.intel.com>,
        Antoine Tenart <atenart@kernel.org>
Subject: RE: [PATCH  1/4] thermal/drivers/int340x: Improve the tcc offset
 saving for suspend/resume
Thread-Topic: [PATCH  1/4] thermal/drivers/int340x: Improve the tcc offset
 saving for suspend/resume
Thread-Index: AQHYHyfo2ZV39O0b2Ei4LPzlS7yKBKyOE26AgAAPSjA=
Date:   Fri, 11 Feb 2022 10:19:05 +0000
Message-ID: <CY4PR1101MB218442CB01AD8813C0343C38BB309@CY4PR1101MB2184.namprd11.prod.outlook.com>
References: <20220211093437.8713-1-sumeet.r.pawnikar@intel.com>
 <20220211093437.8713-2-sumeet.r.pawnikar@intel.com>
 <YgYqzaJhJ5sQDy/Y@kroah.com>
In-Reply-To: <YgYqzaJhJ5sQDy/Y@kroah.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
dlp-product: dlpe-windows
dlp-reaction: no-action
dlp-version: 11.6.200.16
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 487220ec-e7e0-48d1-f3f1-08d9ed47ee96
x-ms-traffictypediagnostic: CH2PR11MB4422:EE_
x-microsoft-antispam-prvs: <CH2PR11MB4422078DFCDD5F6A66A6F3B8BB309@CH2PR11MB4422.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 24yIFSRsPZVtFQwKO++cFFxFuoux81TwgXvCefWFvUBoJlUU9vtx87KhlY8z0Z/KpuJSFB81fk2w+EhBgAjr8e2PYkX3J0fEwmI6FHwgjo+j7+8J6IN+ltzp9i58zl+jyR6NjAI0HpzLeKrS/drL/Ur89UQB0PEgHTboEtodFqdB/Bu76F/HQWWCVIXsJ2idC15vl1fOp/2khnFFUC6fZEgKFfTFlnsRNYIRHGXwWSM8t3Zfj0Ya4UxxB5ISIrXYdjCRSFUviaF5MmfUKtH9Yp9FI4iD8N+7DM2k15XAfELp69AU369j5vhBceJSlXXOSetD2++rvf++HSK38m4OzHVmNQo2xc9XTMYcksYPzZkPNIIpdx+nFwb+HKE9CarWvGpQWazDXyKUMU8CZfTn4KldKTkigfH9JiLQGow8OnbZmI2Oci/1lbpVcYxcxV8sg+7dhwjNGqNFQCPlo6GfwjGvCJg7M8UaGi0BP1V/OGYDjY4CoQlNRfyh1WPnlt5FWuID/MisYe4V1j9eWku31W664/Q8An9HR+Ic5Vojexi4Ei0ZAjtMD49QY5KFI/L70vGa/VGDowL/sVINGqe3COaU2qCcnKKpUcUYDkBY3SuNQfFSBIxxaMO0P0SII9YVSqW722Q25saUndC0zb8H1fn3NHRb79jWO7gp+JiK0fTKeHb5rLh8ey942iNU7K/gJdjMgYCUVTYz8rdvVj4jGpfXXji3fdrM6Bx/W+vu/K58rsJjDmQ5DPscVDwaHwnZZlwDnzPA+CoZwvs4z+xBSGohkbGFrawF+QN8a+VlG4w=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY4PR1101MB2184.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(66946007)(53546011)(64756008)(7696005)(66446008)(6506007)(86362001)(8936002)(76116006)(8676002)(966005)(66556008)(66476007)(4326008)(83380400001)(71200400001)(33656002)(9686003)(508600001)(2906002)(6916009)(316002)(15650500001)(26005)(52536014)(186003)(38070700005)(55016003)(122000001)(82960400001)(38100700002)(54906003)(5660300002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?6TPKRGH+9i+HtWbIrRqS0H1OrsrgNt+2f1uJ2Ji2CgP2xKzfiJq+ih5L7OHY?=
 =?us-ascii?Q?E+Xr3LOwlLUhMTaX9xHCy+hHPsnA+dld8OQLBY56zudkW4q1ml77vFgcMQDN?=
 =?us-ascii?Q?4+l25KnLe4L7WiFektC89/Vip7UE4viMSd/NlWnj9pBY0vrf/urOApTKQmAO?=
 =?us-ascii?Q?pm5VLeIzYW1aGHvKTvAlW/UePWA28u4mcZggggC9abEqtU5M2L8QzQUwdiOy?=
 =?us-ascii?Q?q0IxtklX1HvKdaKwNpFN2UkKwmyekJ5f/knd4aBfktuZ5O9x/l9lbK6MQkvY?=
 =?us-ascii?Q?9cnY8B542MsFaSwxlYbOj5jdaC5zxfVdiE9sifYdruiXaCiMEnuObszLrx7c?=
 =?us-ascii?Q?NshIR8WkYiHsNXkVHb5HJiHff5W6aFF9wbV+Xn22PACcUAOl25ydpEoYyx5e?=
 =?us-ascii?Q?7ukSmuRN1fHA2riA8SHr1IewZ01ja0SAW+KFlX6JySV7PrA1iPUXsk8yliqq?=
 =?us-ascii?Q?So8R9yp2rWJYeGdRU8ubn98J87bFbHK5p0BSx87kPp+FJtE366W/iXUBsB7S?=
 =?us-ascii?Q?aURrMeBhgDnYXbuipROkjuz8IgkyGMZsjRJorEB2TtfhhfdknhZdIz0gXajD?=
 =?us-ascii?Q?2z9d+m71Of2mdz+IVDdHV4AFKzcKd/rs0ASjopS8oYqKvUNkG/TQ7p6Dmf42?=
 =?us-ascii?Q?x5J5dVMJzCP1uqnK5KKhZgropKFLqWg43o/Dkbxqj2wsAT8/V3dSdiCIgCyn?=
 =?us-ascii?Q?Gc81Y2/IYGv+G+zrT7Vk/GCs2F7toNu0x7EHwzsXvbllyjCOOq0Q4X8+X5U0?=
 =?us-ascii?Q?cGthVlgiFLWLAyGWGOFnoYwPmWaF+jgy0WKlsCTefQkjWuQkLPkQte8QyOv/?=
 =?us-ascii?Q?dmHgknmHy2Ck94NP/II2nOEBNfCrrcu+D9xP/65yim3iFT9AE9fJKyl3Ruks?=
 =?us-ascii?Q?3bLqlXe2hT+nuJwchZ1jpraR3Z76s+4+zO6p67cTorkIFn15KbBHz610TbBL?=
 =?us-ascii?Q?+W8Jz65oHEZqllzzvjGMK5/9xYPqPKBVFFqMizQluKfyDE0BDqScNmMlX9q2?=
 =?us-ascii?Q?XsgEJ5yyAN4Oc3D1BdDSkunSP1MxL3k56+wDrcJ6yZdRu7lgiphz+3ZpgvNS?=
 =?us-ascii?Q?7YLCGelB5U6hkfKNrPK0kz3f/6GDPTiP32CCnjzNZWCmNmOHqBZLmEIpU1Cs?=
 =?us-ascii?Q?eJRmuM6VzPQixf0FnkquGeKueaL2xWFtBpFLqQ2zf3f+1Mq0xBb+pfuVdW2Y?=
 =?us-ascii?Q?e02CjRbbaKLNR0xEDpy02up2rIxI3ENcDmEDi9eOzGpIlIARIH89enLtU3y8?=
 =?us-ascii?Q?TFFDc3Frkyc8R2yc6OV/qJMnsmcbhCbYPu9LJdbCYijMAnXnX5YowPgWXPM7?=
 =?us-ascii?Q?9xMLJoDbgf6n86tSXDpB0QBe/40hvuKAVxueGXewPDOMxCvH5Sx024ocLvRL?=
 =?us-ascii?Q?SWjgK2o0gfVieVBCq8U+TRlnoROLn1ZMYKdL4J250dnMwXM5uE0HpSDE4BYW?=
 =?us-ascii?Q?JSROGejQiOvntjpCArNxv/As5toyweDRm3qHL303kaNVNSz3yaMqAEg+KhuT?=
 =?us-ascii?Q?2Kvt4T8mfhAfuB+3I7WbIDY0nl5RovV6g/0sdh23aajG1UWLoDYzXEAhFeB+?=
 =?us-ascii?Q?kaD0ExfcqFlC1MEnBgBInszfk8OxRIvSztJfvgaefUB5a1hM2JUlnygN2ac3?=
 =?us-ascii?Q?WToT8GEMgl+yS6m4x6CTiJFLcYMT05ibESzwMw5dygBkyH9FKhlJrUnxMPCW?=
 =?us-ascii?Q?gzzFow=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: CY4PR1101MB2184.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 487220ec-e7e0-48d1-f3f1-08d9ed47ee96
X-MS-Exchange-CrossTenant-originalarrivaltime: 11 Feb 2022 10:19:05.0498
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: n+ypGOvJlyh6eR6RYOfUCuikz+dmCqTNVQFg1lVHAO+CgIgJ0GC3VXx+EBc6JHtSGJzMvm1GLs6f7TfnByuqfGQwd57aZa/9LmBKTW8+HfE=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR11MB4422
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



> -----Original Message-----
> From: Greg KH <gregkh@linuxfoundation.org>
> Sent: Friday, February 11, 2022 2:52 PM
> To: Pawnikar, Sumeet R <sumeet.r.pawnikar@intel.com>
> Cc: stable@vger.kernel.org; Wysocki, Rafael J <rafael.j.wysocki@intel.com=
>;
> srinivas.pandruvada@linux.intel.com; Antoine Tenart <atenart@kernel.org>
> Subject: Re: [PATCH 1/4] thermal/drivers/int340x: Improve the tcc offset
> saving for suspend/resume
>=20
> On Fri, Feb 11, 2022 at 03:04:34PM +0530, Sumeet Pawnikar wrote:
> > From: Antoine Tenart <atenart@kernel.org>
> >
> > When the driver resumes, the tcc offset is set back to its previous
> > value. But this only works if the value was user defined as otherwise
> > the offset isn't saved. This asymmetric logic is harder to maintain
> > and introduced some issues.
> >
> > Improve the logic by saving the tcc offset in a suspend op, so the
> > right value is always restored after a resume.
> >
> > Signed-off-by: Antoine Tenart <atenart@kernel.org>
> > Reviewed-by: Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>
> > Tested-by: Srinivas Pandruvada <srinivas.pI andruvada@linux.intel.com>
> > Link:
> > https://lore.kernel.org/r/20210909085613.5577-3-atenart@kernel.org
> > Signed-off-by: Daniel Lezcano <daniel.lezcano@linaro.org>
> > Signed-off-by: Sumeet Pawnikar <sumeet.r.pawnikar@intel.com>
> > ---
>=20
> What is the git commit id of this commit in Linus's tree?
>=20
> Same for the other 3, I need a hint here please...
>=20
Yes, let me add git commit id information here from Linus's tree=20
for all four patches and submit those as V2.=20

Thanks,
Sumeet.=20

> thanks,
>=20
> greg k-h
