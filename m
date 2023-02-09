Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A1DE568FCF2
	for <lists+stable@lfdr.de>; Thu,  9 Feb 2023 03:10:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231590AbjBICKG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 8 Feb 2023 21:10:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45436 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231611AbjBICJz (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 8 Feb 2023 21:09:55 -0500
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5ECC626CDC;
        Wed,  8 Feb 2023 18:09:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1675908592; x=1707444592;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=xN5jMRabkwAiA/EKNVJu2LvhXuIP79+DZ5P57qDoWks=;
  b=jwZGaHxqeHnQSjzObpkcD5WBpqkbz8Bm8v/2I287zBgsjNzzl8qOawLZ
   XHCbTakXsgi1HvxLddplUJ2pOmcI2YQSWueVeHQBZcerOWZ1flFA5wboL
   intUR4HS4sw2qEUehJ+J197W/hd+XwJRsjaFExSMBAyUqD9PH1fmy31DJ
   pU2tgYS/QH95t4vBO2QhClSWWv3D3cEAUIuhxJxwf46k0VKUU8eB4zeQ7
   A90+FZhn24gpEFz3e1R+lL86h+vKWcY+DaUDSTvWD+KilXkvmsTb96o8U
   mU9vix3Ysov+XT3U6ztaOembCgU8fveaPi6ZpEOPc8ZabQfuBb2Hx9RIE
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10615"; a="330014998"
X-IronPort-AV: E=Sophos;i="5.97,281,1669104000"; 
   d="scan'208";a="330014998"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Feb 2023 18:09:52 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10615"; a="776282878"
X-IronPort-AV: E=Sophos;i="5.97,281,1669104000"; 
   d="scan'208";a="776282878"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by fmsmga002.fm.intel.com with ESMTP; 08 Feb 2023 18:09:51 -0800
Received: from orsmsx603.amr.corp.intel.com (10.22.229.16) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Wed, 8 Feb 2023 18:09:51 -0800
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16 via Frontend Transport; Wed, 8 Feb 2023 18:09:51 -0800
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (104.47.58.168)
 by edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.16; Wed, 8 Feb 2023 18:09:49 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Wcjx13xkLrKPgv/c+PZnwyF5LTz30g0ez8p4fMdr5aAuyeRzfaRs95/+SGWaRs76DpKUmGDOqJ6EK3XTt3xDTA+QddDFgpu6JimBGlcwXcbTh4zwYmYTjxaW1hnxLSzSeUqK+CYJsbkemM1GAvK41kSHtak2kMm8E6rjb4fzooYzi54Lb80n7yKl0CPGrYvJomGYTSzXnoq195Bs2TLRdOGruNxPsKKIqsEViIIZIWGVyCzHqLG21OxGK+7tW9h3ZOQQKK9ilQeaNdFgmrRHDstGnC5NqHb5WA4QMD7ZNpyBnGUzVfDc65HNF3AWh6u5xiDoT5Gd1uOdQZcP3CMUOw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=oPea+aHdDAkE7M7RIGoN/UaYlSoIr6fyxX+n+7cMdak=;
 b=iNJrQTOUB73Omjk+e5LMRy6CIrpf1XLcgiVykGzVSDch7ehSgIbYhEMGhk/jLCDEoiOwW/IlwheJEMZy9+9Tbdeoq+QO3MQYQmW7mSXirMkD0Ktkc+XFVAoEkIE/E5UXzeUIQvv8JtSFqKCHC8MUVJFrk+fNsSIdlLDG7DjZp65EScr6cboYJ/2QnqG3AbkGFTgljdplNPcDXN39SbpnxG7Axe83ybtlufx6kAu5WdVksPoDuWxekifY+bBmyD6M84S8blHCzafjIvblx2g6tGW0sVJz8yGAi0Y4ay2VKOuFamxVmwS1R6fnPl0pFQcxSf2hD+sID9VXc0XxuudjTw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BN9PR11MB5276.namprd11.prod.outlook.com (2603:10b6:408:135::18)
 by SA2PR11MB4857.namprd11.prod.outlook.com (2603:10b6:806:fa::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6086.17; Thu, 9 Feb
 2023 02:09:47 +0000
Received: from BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::6a8d:b95:e1b5:d79d]) by BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::6a8d:b95:e1b5:d79d%8]) with mapi id 15.20.6064.034; Thu, 9 Feb 2023
 02:09:47 +0000
From:   "Tian, Kevin" <kevin.tian@intel.com>
To:     Jacob Pan <jacob.jun.pan@linux.intel.com>,
        LKML <linux-kernel@vger.kernel.org>,
        "iommu@lists.linux.dev" <iommu@lists.linux.dev>,
        Lu Baolu <baolu.lu@linux.intel.com>,
        Joerg Roedel <joro@8bytes.org>
CC:     David Woodhouse <dwmw2@infradead.org>,
        "Raj, Ashok" <ashok.raj@intel.com>,
        "Liu, Yi L" <yi.l.liu@intel.com>,
        "Ghorai, Sukumar" <sukumar.ghorai@intel.com>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        Robin Murphy <robin.murphy@arm.com>,
        "Kumar, Sanjay K" <sanjay.k.kumar@intel.com>
Subject: RE: [PATCH v2] iommu/vt-d: Avoid superfluous IOTLB tracking in lazy
 mode
Thread-Topic: [PATCH v2] iommu/vt-d: Avoid superfluous IOTLB tracking in lazy
 mode
Thread-Index: AQHZO+lH5ZZrDUEsvkGH4tqtsa1bVq7F3wnQ
Date:   Thu, 9 Feb 2023 02:09:47 +0000
Message-ID: <BN9PR11MB5276A911FAAE4C2F6B670E638CD99@BN9PR11MB5276.namprd11.prod.outlook.com>
References: <20230208181834.1601211-1-jacob.jun.pan@linux.intel.com>
In-Reply-To: <20230208181834.1601211-1-jacob.jun.pan@linux.intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BN9PR11MB5276:EE_|SA2PR11MB4857:EE_
x-ms-office365-filtering-correlation-id: dc9f3159-c18e-405f-acc9-08db0a42b7f3
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 0R6p2WJap7B3Wf6Oz8WNh9gTmrpck2dXUJLL7mnN8h6ylf+tel3epERvHoblFvQrLQRpKnKhrbi+xmk5dqLwL9rVgn85SkFBJZuQClzWfajmzUPVXMM4AllJlEA98K6U9F8j2eA3XMcrVV3ZCiugA4giy58EYWU3QCFFKM+cF5N9/2VlZvzOvXHYlLGA+B4wnJLcew26Q1kCy8l8O3QbD4xHduYhnZcldsphpVSU8Xn1Hma57it4Ze6jkW4KCUnptamAx58VjQ3TpZ1CqEZ8AhtGHD3VVeK5R6/79zgECCjJf02GPWamP+jG+rMuoV7WoazhPYn4PfBTG569DIN1zFnqb4DP7CklOVZNppbeRE8fpAhEluh1yvGgMoEs3UWlQfW+rOpXktqoyFfuW1wkT/zBRftzKTkwBKiJ8VhSeMSvv7egQ6RUBAeJRugKK+hZFCz4KQInt3HlpkZJ5EAmqjpwnFkmr92OT44E6olN21Hv9qc3ZVZjucj8IHS3A3rNnT66gvJ7bfW0pLNiAAXPz5dinRkS44aui+M2dz3dE/PY/GnqcFBXvlbXNf/kMvrF8pP4dw1lovTMxhCa936e9Kn8/wUGHcWzk79xqZopcoOVbiTDzYcuHScu9utS6mh/uCRnJAiVtJpsPVAy9NyBpx/k8B4XrCFkifjzSa3+sidMJlBmP0ekBK5XQWhmilcV1ku03zG7ZZD9X1tERC82uw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN9PR11MB5276.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(346002)(366004)(136003)(396003)(39860400002)(376002)(451199018)(55016003)(110136005)(76116006)(38070700005)(54906003)(316002)(2906002)(478600001)(5660300002)(8936002)(86362001)(52536014)(4744005)(8676002)(66556008)(66946007)(4326008)(41300700001)(6506007)(64756008)(66476007)(9686003)(186003)(33656002)(66446008)(7696005)(26005)(82960400001)(38100700002)(71200400001)(122000001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?Vb19odRDDe8+Axr7RLyeqZfp3FIGVL7vRNTKp/M20CQqipazNmpodi8q745E?=
 =?us-ascii?Q?EA0QO455/4dZgTnIQSEdHI133g4V7qn1zUVXdF8LfdmG7Ix4Y4eA/GJhPAIe?=
 =?us-ascii?Q?J2RTW2llIbJlhuFLHjweeB77YNFJ4L3l8G7m/Bhp9i3Ngpj2j0LwocdsiquK?=
 =?us-ascii?Q?UpWA0+WsADKu9muWU3UPqkIZef104thl5tMF3mmWRYajgJZmULi2T2TZ1e+Q?=
 =?us-ascii?Q?5W6fO4dBcH9Ns3cYYHyXFoC944UAFetPB3KziJW1lAtmNJRoLNypmc5Jk2BN?=
 =?us-ascii?Q?H+modUTM0b4xkiKTGTNqexkMtEa652JaancuD8ZKQbcOiThaBQcH3JYaECw7?=
 =?us-ascii?Q?poMToBWvSCfnjUGpbSiOJiFKRnpnAPmMbI5SnIJmiMj+yDwN4vU9T4Ylg1eM?=
 =?us-ascii?Q?SfednY6MfUTVZLdsxohB00qBL3krc1re5ep88IBiT6P/tRCQFWw+EytimAhU?=
 =?us-ascii?Q?f5wlZZwsxEquvZwW0npdlGKY4gf4M58j7DQlHPozgAqsZTR3sXZ3DSGCDFdX?=
 =?us-ascii?Q?4RRDxkz9/kjUua1a1k27tNg5UxSalLD1FuGxC6XYPQpw7py/8TLFGvNVoFFj?=
 =?us-ascii?Q?rdJvegnseIxeNcYpfZ9y7HeNiOPV35HEkEViLSTeFJnbUNfZBTpR6DgWblXt?=
 =?us-ascii?Q?SuFi59Mf2/BAneAYW3pxFKCmAcGmcGKWd5GxxLesjaWk1PrCdhQEQo3QZV+c?=
 =?us-ascii?Q?1G5BcU1g/5N3+cQ8Prsucs1Fh0v9VYGPP06EQzoCf9bAhY9L1scwMI6mce2P?=
 =?us-ascii?Q?bMdgNY8ssX1UHEqshREobAQ+UH3iBIWoWxzbocsFedqkEd/ZSs28K5Wk/It5?=
 =?us-ascii?Q?ZH9FCyQ4908TyS0QavDShJnwvJw9b1EaF6+P+6geW+p5rRetv1/GlckRhsG6?=
 =?us-ascii?Q?16wnmNiAlUr0pqxXIRNTo8qrezD3BBBmwTIg16WXMegEn/qJk2gJLuDkl5iu?=
 =?us-ascii?Q?52DFgVP3knJU6QdJpIkzu/+uY0Z4wMm7/K2lEZGBn4g4GZwy+7B6JdMR5BX9?=
 =?us-ascii?Q?DLQmDlV6aIAwWV9Ft+TjBlp15OAJd47+WaoS9gPyHoED19qUuCBIhGTzU9Iw?=
 =?us-ascii?Q?ID2YXuokxJOi1PuZl0qcsOZ7NUBJUgEPsoapJaUglxtEo2S1eRRFu4MS0Jqr?=
 =?us-ascii?Q?w4HRRqu5NOddCV/63F6LbXoJ9ZnwJEhTCbOQm8CmuNe5ByjGOCmv0zXhsdMs?=
 =?us-ascii?Q?IiYr+o8EL3e8VXnCKwoO3PePjUrX+R0U4E2nzTGR68KWl6sq/yCzBz+h4q9n?=
 =?us-ascii?Q?yfFRNuTCpISzci78Tju/ZQ96RvUiq1IPDRP32M5CQqT+DgW+TNyEgwfhO3MT?=
 =?us-ascii?Q?zS946EaUf3auIOZgjC/8D2ZQuWsnbI/J5cniujVakXyH9tMeYtOJ7OrtA6OS?=
 =?us-ascii?Q?GGvI0NICSnqxH5+k2injPVmZQybFHs1XkR5keHOcVdpFVO0wBIVK+Ux7Yomc?=
 =?us-ascii?Q?SI3zWtSAB9BqwGWR0ufktho3imZWmoO1WwIeIpsUj8lGqCSMMpj4ySnUSsZh?=
 =?us-ascii?Q?u2wh6LeRdYLuk/XVfvQusYr70WXPT+OHWYbpmI4JG0ue+tdK0tSujYQZIMXV?=
 =?us-ascii?Q?3qDrUJYUFkpIk8SfWikoiVywpU6kMFhXvs9RLY6m?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN9PR11MB5276.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: dc9f3159-c18e-405f-acc9-08db0a42b7f3
X-MS-Exchange-CrossTenant-originalarrivaltime: 09 Feb 2023 02:09:47.2907
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: mZcPvv1Ox95rXuf0Y5zrms4kTjbhXWpE/anaMcqqgvkJuqZy5u/cw8Jm2TbY/pgHPuAr7V1LqkkOKsL+RICObA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA2PR11MB4857
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

> From: Jacob Pan <jacob.jun.pan@linux.intel.com>
> Sent: Thursday, February 9, 2023 2:19 AM
>=20
> -	iommu_iotlb_gather_add_page(domain, gather, iova, size);
> +	/*
> +	 * We do not use page-selective IOTLB invalidation in flush queue,
> +	 * There is no need to track page and sync iotlb. Domain-selective or

"in flush queue, so there is ..."

> +	 * PASID-selective validation are used in the flush queue.

the last sentence can be removed. same meaning as the first one.

> +	 */
> +	if (!iommu_iotlb_gather_queued(gather))
> +		iommu_iotlb_gather_add_page(domain, gather, iova, size);
>=20

Reviewed-by: Kevin Tian <kevin.tian@intel.com>
