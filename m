Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 50E29552988
	for <lists+stable@lfdr.de>; Tue, 21 Jun 2022 04:54:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343580AbiFUCyk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Jun 2022 22:54:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33268 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232725AbiFUCyj (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Jun 2022 22:54:39 -0400
Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2DB8D19001;
        Mon, 20 Jun 2022 19:54:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1655780079; x=1687316079;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=cIdbqVOoinVjvOcXxY/0Va9u5W2NDCBirOOnbB4XMrg=;
  b=RO95D31cJlDkeNDj8RClWHfO7vIzXlqhmazOHR0ibVqNEAsMcwLcSdxx
   QdH8xAyD69Ye7G9Gy3JOQxdUhr/hiwyjezjrZaQZ9TWK9kX8Jjzhd7Ay9
   n5C9YysG1QFPLza95kEVkgTqzih045/EOIa4baebDF4P0hlq7e2PuFF2t
   KiihyX0220mVKHbD9ARSYDQRONX1lNG7H0pn7ZBR1lyp+c1K2cpowWLQs
   lwAiO6btl4aFLRuqgJh5KGTgvONdpfHN3VVv2PJ2E19v5Ce0HorQ9Zbaj
   vlsrGrB287WeJWLwgQKEBmyRftsHV3hrlbMzrtKAIafyAO8FfDcTx//1r
   Q==;
X-IronPort-AV: E=McAfee;i="6400,9594,10384"; a="278782314"
X-IronPort-AV: E=Sophos;i="5.92,207,1650956400"; 
   d="scan'208";a="278782314"
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Jun 2022 19:54:38 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.92,207,1650956400"; 
   d="scan'208";a="654939441"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by fmsmga004.fm.intel.com with ESMTP; 20 Jun 2022 19:54:38 -0700
Received: from orsmsx605.amr.corp.intel.com (10.22.229.18) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.27; Mon, 20 Jun 2022 19:54:38 -0700
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx605.amr.corp.intel.com (10.22.229.18) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.27 via Frontend Transport; Mon, 20 Jun 2022 19:54:38 -0700
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (104.47.58.177)
 by edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2308.27; Mon, 20 Jun 2022 19:54:38 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=nBIa2Y/1qS6EtvzIx2sVHlq71u9k5gesgfbAetWILLJbtYylnfgyxacu7F8KUAfRheIJEL5fC6FgmJXJ/nVFxYHLcQ6Qcls77gbMv8n/bdxbudNYHk2+Vp3A2Ywx+5CYEPr//YGOUXH+m9X+OlNWORYFuCRW/7LBb+GtZK5hd8vNAtq0scIOBhbpCSRQkPjyoBohgqqFb091TuL3/DUrRPfkdSToMz0dr0RAPJL3gSltYwctXidMcvdTTOdvw9QIldk4UhbKUglQeDE0EOEZ16sOrkYeRU38ooaUSLbqMPQX54k6nOhxmzSBLa3r3Ah2rqf4U7wrUOd8DQCPwY9MSw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=teXZi6bUPyQvtinPwFLZkftKbqeAmL4xxfMpvfNLjlo=;
 b=CgvtLyl2ghkGrAoxJsWeuKtxHEI8LwtP/KgC1fV7sS3hl1r22snly4qGo3vYpPF3wGLrwM0mY0BiEvrXPBAFHl5x4r4jxqNzcmqgUTVjNQa1hyT6HnLcctFA3vzYXYqYOtUcGPQAT+IKwWMcqSdiki3T+Jj0cCE47wGx3w+XztlbsiGZS8tIpfhtok+dQp0OEl2ff9nHZ7gioRpWNcfDE3IH5p7f3+jmqMBbBGqUQvvYmAuuTPzPnDQAJGtDmB+Flx5oeFSdpdLQp+YmhZrLUMF5BNliRD/C7GvUJOauaYK1wxsF6HJeJjzgT038rf6BOifl6kJ1YFDC3XwLP/u7jA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BN9PR11MB5276.namprd11.prod.outlook.com (2603:10b6:408:135::18)
 by BN6PR11MB3988.namprd11.prod.outlook.com (2603:10b6:405:7c::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5353.15; Tue, 21 Jun
 2022 02:54:36 +0000
Received: from BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::8435:5a99:1e28:b38c]) by BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::8435:5a99:1e28:b38c%2]) with mapi id 15.20.5353.022; Tue, 21 Jun 2022
 02:54:36 +0000
From:   "Tian, Kevin" <kevin.tian@intel.com>
To:     Lu Baolu <baolu.lu@linux.intel.com>,
        Joerg Roedel <joro@8bytes.org>,
        "Raj, Ashok" <ashok.raj@intel.com>
CC:     "Qiang, Chenyi" <chenyi.qiang@intel.com>,
        "Liu, Yi L" <yi.l.liu@intel.com>,
        "Pan, Jacob jun" <jacob.jun.pan@intel.com>,
        "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: RE: [PATCH 1/1] iommu/vt-d: Fix RID2PASID setup failure
Thread-Topic: [PATCH 1/1] iommu/vt-d: Fix RID2PASID setup failure
Thread-Index: AQHYhH7LXPufoGLZlE+CLUNrmpMHyq1ZKuMw
Date:   Tue, 21 Jun 2022 02:54:36 +0000
Message-ID: <BN9PR11MB52764F60972DF52EEF945D408CB39@BN9PR11MB5276.namprd11.prod.outlook.com>
References: <20220620081729.4610-1-baolu.lu@linux.intel.com>
In-Reply-To: <20220620081729.4610-1-baolu.lu@linux.intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: ed095dcc-4304-4373-379c-08da53316081
x-ms-traffictypediagnostic: BN6PR11MB3988:EE_
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-microsoft-antispam-prvs: <BN6PR11MB3988BB5ADF31CEBB1ABBF11C8CB39@BN6PR11MB3988.namprd11.prod.outlook.com>
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: ThrqyN+/ygcIxm6JecP1n7z2Jr8Rpqe36O62qFJMri22oN/k3Tpheaj5GsLWW5pevIsoiXApXzv+8lnLRoxJvSqffbDNBHkWCc+nVUR0+Pst/zcvkSjLGE4L9vCiOxmUXg67N8mhHQq8IWkof1sZVGX83mvEUGxca4cSl45E6WqevufHNMWNluL+bhu7rTDjbA5H3CVr0rJgNEMR7oq/2mV7YOM9BW584XornyoPvvpw3LzoUzJZ1unqC8kZoIvpCIS3Gokae5uOoGVcT8BXMp3w9pyKM7as92sKSKGazaMMmsGAFKF0JaCTdti7VTfdkT0QMgZ7Py1llIYO9FI/Ko4pCvnI7CakbdsZGw4RxLM/4Tz/N7vEMU6Au0sSaGBphLYdnaywt+jmvbxHbSbPsCVOvPpbgnmb7D3cT/G4OVVL1rrkGXUtcd87n/0i8DnUsLC6oz35/w2PZTr0vm7hWCSqqWoiFfiRTj0uoHEopOP0YR71ZuwjKH7b46tbF+Jw1HY3esiK5DqzZMr0TXaw6OKuH6JHLKRz7aGubJ5tte23hH3bYJjeZ/hotMeT1tvHiLPa49X/E2QtWP0jxl6artCW903YN1ceN++9mewV/gSRCl4hvH7N6GJgp8lFqdJiSYLyvcLTXHjitEnXlbgdSw4n3uLrXMDjV+1cLeLg5cc3JfmhIDZDinXiXYXJ5aCV139X7XTk6qjgyWWUvu1BVQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN9PR11MB5276.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(136003)(346002)(39860400002)(366004)(376002)(396003)(9686003)(55016003)(122000001)(8676002)(38100700002)(8936002)(33656002)(6506007)(41300700001)(54906003)(110136005)(316002)(478600001)(6636002)(26005)(71200400001)(7696005)(82960400001)(186003)(66446008)(66946007)(83380400001)(76116006)(64756008)(66476007)(86362001)(2906002)(4326008)(66556008)(52536014)(38070700005)(4744005)(5660300002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?cnMMR5cSTLsn0tmk1F8gLET3VCRFCKfsx0/Ok9M08LkO4Mi02q18XRdl2BGG?=
 =?us-ascii?Q?SbAErmd5ngsGymi9L5U4S4E1IcuJ4vITrXt6bx/PZtvRyeV69z9DoYlU+0m+?=
 =?us-ascii?Q?8AnO333SIeimzWmdJzaipDto2k545PTXinWd/fnl0yjDhcvOpvn0mapcFc08?=
 =?us-ascii?Q?eBwBhVji5o6U1Q96Vwu1lDjLXMTHPioeOUeTwlS9klvpzr4CKiSPEY28TxWb?=
 =?us-ascii?Q?02tpwOiFNxdFNi/ntXcNPCsVv/T2c7RBjpWfZHJtKOrwVaPqvgFf29681HII?=
 =?us-ascii?Q?vfWKjZd6xnnN7eKdYfo5kopoh/aPwnnsyeQVcVXKzGv3ajLRqYbE71Fz8Hof?=
 =?us-ascii?Q?N1dFn8MYaz0k1Tt6uw8f8cig6y6gAbuNYVK7mat1DgYBahe+q6YK018Xrfg3?=
 =?us-ascii?Q?pQMA46k/ePaLN2u44QnokwpN6teEQb0qBUviZJeMJQWBXNTQuTwi+mBRVSZG?=
 =?us-ascii?Q?0/5omXPfR8pejmxUllxyLMt+aLQslW/bJcw3D06HCd4TSMUUu51CImmoa7DI?=
 =?us-ascii?Q?0/0pPz4Yy6fBDiiPskNXdqvdRNhV2s77itgwmFux5uJbWBsMQBtuWWKgH1ue?=
 =?us-ascii?Q?zeo2DJz8h6qUJKM0eqWeZst7jhPLFE3OCJf3ruidRRNNgFplEUxn02RdlYNy?=
 =?us-ascii?Q?giwFeBSHoL5AaiP3nkrx1TwvjCP/X71kapOezxLFAGXsUN8a1CZdbiLKJRq1?=
 =?us-ascii?Q?AckAvKwc7aDhE+XEq40ZzgUscGMjQSbDLeoPKEGUKIf1ks5kR7MvDwxKnGFP?=
 =?us-ascii?Q?Uz7vmwRELzB6PBsNpXOeiYRGaGRd0FXQSYhFjOSRcGwFE/nKdQI7AY8w05rC?=
 =?us-ascii?Q?BBC6ce18vmy+FXohWmQjgF4ovDbk7O1ee8KQwbFGHF2bf6rvEYyIF3tjGLAd?=
 =?us-ascii?Q?xC1w2k11kuswIZGushfdBwRwBOOIvLcaqWYdmqh+xyGNcocAsVrPX6jNQOFP?=
 =?us-ascii?Q?7r1jGbow1Qp3tOJuaCuvtGc/n0BzeKjJEerLUGTFAe/HXb3IVU3I0q7Ed7XW?=
 =?us-ascii?Q?w1LRar680OoJtBUyFAEwRgH0VB+OcJBVWO50rCXeCxahuRDgEloSVoR0VGQf?=
 =?us-ascii?Q?CaNqlCYFIGSKsdsbSUI6QXvqaYWsyBVBKO/cWhOghgnoVrgnvjxWJKasobrd?=
 =?us-ascii?Q?cDtI9A4/PIjw/XIMvRrtospXORXTNYLwAmi/1gunJopQR/FNWyL1Ey01a4Xr?=
 =?us-ascii?Q?JD74heHWDxmas/FpnpGPvz8xNguZhRE07Ta8YipecxfQCBVRxTJ8dZ7LZQeJ?=
 =?us-ascii?Q?kMN55UvVjs0LZdbNIt57geqn19SI6jk+Sj99fbpmZaM8UW8T1PFEWLrI604i?=
 =?us-ascii?Q?beH6dx5X+d5lsB1rsI92U05O06Jeupt0C6cNAzUu1bdn91W172pjxkuXfpMo?=
 =?us-ascii?Q?13P4uZTT82X66gcj3MVKwibhiDDQGwY9QT4AWL8fuaiqkF0vMWOwIOcLUjFs?=
 =?us-ascii?Q?twhZiyrhU6jIJDLbK9dFlc6R8T4rkZV5ZmNyvE4yUOboA6hQS/k9Q9H6+756?=
 =?us-ascii?Q?xlI5315rvoss4UXzKFd3sZKp+Fgq6z65j4fW85PVSjFn9TRW18X5FAKzo2mS?=
 =?us-ascii?Q?xvtrLH/dOetdz4gbREePoHZ88jSmlnJgh9JsTFthSxulDF2HG9EztOtAkIIU?=
 =?us-ascii?Q?LaYEaglxe3gVI7P6CgoEaBdkvA9aUiRACdbm1sAQj4py1AGQrLcu8lXpMQue?=
 =?us-ascii?Q?rzhiEIOEreeYhgAdGB65fY2/TeRJ2MWyxFGaVrbyg1rIYdTcB5iBQ36KRkuF?=
 =?us-ascii?Q?vagWSbA4dw=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN9PR11MB5276.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ed095dcc-4304-4373-379c-08da53316081
X-MS-Exchange-CrossTenant-originalarrivaltime: 21 Jun 2022 02:54:36.3768
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 1h+2JP7DKgV1jlqtTwiNpENiY7wdNRgkuCvy8IldYKMvouIKzm3ZBaJiW1pqRQr3ENTnDlb4zCFZOgRZ2Z21Jg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN6PR11MB3988
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-5.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

> From: Lu Baolu <baolu.lu@linux.intel.com>
> Sent: Monday, June 20, 2022 4:17 PM
> @@ -2564,7 +2564,7 @@ static int domain_add_dev_info(struct
> dmar_domain *domain, struct device *dev)
>  			ret =3D intel_pasid_setup_second_level(iommu,
> domain,
>  					dev, PASID_RID2PASID);
>  		spin_unlock_irqrestore(&iommu->lock, flags);
> -		if (ret) {
> +		if (ret && ret !=3D -EBUSY) {
>  			dev_err(dev, "Setup RID2PASID failed\n");
>  			dmar_remove_one_dev_info(dev);
>  			return ret;
> --
> 2.25.1

It's cleaner to avoid this error at the first place, i.e. only do the
setup when the first device is attached to the pasid table.
