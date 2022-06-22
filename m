Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 83D1E5540BF
	for <lists+stable@lfdr.de>; Wed, 22 Jun 2022 05:07:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1356346AbiFVDHE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 21 Jun 2022 23:07:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36774 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232810AbiFVDHD (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 21 Jun 2022 23:07:03 -0400
Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7974E2E095;
        Tue, 21 Jun 2022 20:07:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1655867220; x=1687403220;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=/WHDFLIaFqzEmbv/ZPtEu9Cd5UZoPTpQNawql8EkYuA=;
  b=LYYDcxziborC7/1TmEBNwelCRrMw66ZJUfL3O/5QpI7P+PAeke0quuRu
   MwWVjmC3FcZgF0N1mF/68/85ZpIZMOGsyo84Yz/TL2KUAu1LfnC8+IxAV
   E3ajAlQN7u8iX+OQ0uO4QkpRfX7NgL2NTMDbOAaSXUitmP46Tu24u45dJ
   EChTk2xtKWb0N68a6Upt/vPnytScsGKNib4B02ptsPRQiiNPRRlSEYN1n
   aLvZZCDjquC1MFLx/BHn100MG11q7Lw0ivi/UwtBpZ75xmhZIjNvkODEY
   NW0l7gUSDu6HAEW40BdOQBDlm21po9Sc7YVJonb8iTr0dlwDeOzgaWwCY
   A==;
X-IronPort-AV: E=McAfee;i="6400,9594,10385"; a="279066692"
X-IronPort-AV: E=Sophos;i="5.92,211,1650956400"; 
   d="scan'208";a="279066692"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Jun 2022 20:07:00 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.92,211,1650956400"; 
   d="scan'208";a="677309083"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by FMSMGA003.fm.intel.com with ESMTP; 21 Jun 2022 20:06:59 -0700
Received: from orsmsx611.amr.corp.intel.com (10.22.229.24) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.27; Tue, 21 Jun 2022 20:06:59 -0700
Received: from orsmsx601.amr.corp.intel.com (10.22.229.14) by
 ORSMSX611.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.27; Tue, 21 Jun 2022 20:06:58 -0700
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.27 via Frontend Transport; Tue, 21 Jun 2022 20:06:58 -0700
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (104.47.59.174)
 by edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2308.27; Tue, 21 Jun 2022 20:06:58 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=cqUazKbm4fabxMMjKNTcI0LzXavURAYEgpeV4DIGFLjQH15G9giut4q3EVuOpFpcyAeJs13qnXMkt4WHe59bS+NYwYv5uISpcZ+FX5FquCAd97fJeVYTfu+ePUhE1xdgZqm8mKYNfUZ0/B1bATaFDpmsdm8hehSZ0OchOrsi0JtiiKIrzLQSzXKcnX7FQTd/Zds0a8lSVNfe8/gwhn6uUeuUGFs8wbOQxfwAcLiAT1TYnr5Yy6CXSSeFdfnEVyLVNo84RdPI/aQw40ZYTCMWtSOHghDiKy5ATfFuHVMJGxArCnL/KlFt5Bm9c51XChDkozYTggH/DxlNg8Ks0xhxuw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=/WHDFLIaFqzEmbv/ZPtEu9Cd5UZoPTpQNawql8EkYuA=;
 b=W/wcXU++YR71H4b6hrNp6Y2pLxD6Sx5LGiw631ZH/v9PNc6WV8XAGkVfuu7DtuHNwTlJ4a7MRu++1IJXCe5FtDxqLzNmGwoddUWgmNWIHyTeL26VCeS17jCWg+vRjcvCGUaDqZ/gJhxLCKD/IN7ZvVNuQ7NrR/AtEwLUDqYC9/PfjocdutcJGy4KtV1ZCCBgOJQBs7VPZXd45tSu0QrZvVILuApCbAUyobTaCuHzSEdxdvEd4z0Hhy8CS8G+Rfor3kSZGZbNSQrgPbUfuCwtaTEBk2uOYwd2/WCHu2RerPDNSMCaVuO9xhRFohA+BI/JpWrS2Dclo5oONS+ouEAxqw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BN9PR11MB5276.namprd11.prod.outlook.com (2603:10b6:408:135::18)
 by BL0PR11MB3233.namprd11.prod.outlook.com (2603:10b6:208:68::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5353.20; Wed, 22 Jun
 2022 03:06:57 +0000
Received: from BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::8435:5a99:1e28:b38c]) by BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::8435:5a99:1e28:b38c%2]) with mapi id 15.20.5353.022; Wed, 22 Jun 2022
 03:06:57 +0000
From:   "Tian, Kevin" <kevin.tian@intel.com>
To:     Baolu Lu <baolu.lu@linux.intel.com>,
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
Thread-Index: AQHYhH7LXPufoGLZlE+CLUNrmpMHyq1ZKuMwgAANHACAAADskIAADMMAgAAVB6CAADfkAIABLcrQ
Date:   Wed, 22 Jun 2022 03:06:56 +0000
Message-ID: <BN9PR11MB52763B34313DD178B44BA2578CB29@BN9PR11MB5276.namprd11.prod.outlook.com>
References: <20220620081729.4610-1-baolu.lu@linux.intel.com>
 <BN9PR11MB52764F60972DF52EEF945D408CB39@BN9PR11MB5276.namprd11.prod.outlook.com>
 <5d13cab5-1f0a-51c7-78a3-fb5d3d793ab1@linux.intel.com>
 <BN9PR11MB527671B3B4C1F786E40D67408CB39@BN9PR11MB5276.namprd11.prod.outlook.com>
 <80457871-a760-69ba-70be-5e95344182ea@linux.intel.com>
 <BN9PR11MB5276A8B4E2466BE080CA9E9B8CB39@BN9PR11MB5276.namprd11.prod.outlook.com>
 <ff4d8dab-e409-1e5d-74c5-ddbb65c2ba03@linux.intel.com>
In-Reply-To: <ff4d8dab-e409-1e5d-74c5-ddbb65c2ba03@linux.intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 3bcaee62-13fd-4455-2a30-08da53fc4445
x-ms-traffictypediagnostic: BL0PR11MB3233:EE_
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-microsoft-antispam-prvs: <BL0PR11MB323361F24F08D43881B5F61A8CB29@BL0PR11MB3233.namprd11.prod.outlook.com>
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: YcuAU+0/XdtTedtQp/NIkcM3BSk6JEFlGQV21vbF01lb8fdbPhymis7M4Ab1wR12IUG9OPF+4dvkRY0J55f7SLMsEPZclsHVFRv3TOT/SXP/9yiEpH6V0yVhQStCutVNZPEOaJFXpo/akUSF3TDkegHbB6ii4iFgKSxnsC2h9yWkSrGDnHBAn2ikv+t7n2B54IKi+U5HfJWx5yN/DH66rdyiyasokg7Lwb8WDuFLbBB7I8UereMwZb7ivwTsJoUeFrZYH+O3LURdcO8iKmHsF5eLWZJp0P336CjD16mdXBmH7YUh/HkriyAdOHfgazgDZdOv4lm12uCeghdrf6gvKmcopVfkiaef2ipW4ih1mN+3CQaCdy18rTHfjx9JF0hCQnCLU+XwIv72u+NSiDo1R8ltmLfg+uoWJQfC3jyakWnYNYELt8e58O4StNVI9Gxl9j5ZQ3Q0vFutUUyJyT8l8qpGgmHXEqwwO8sxzYRjhq5iOFchcwIabNtvBRuid9MNx+Qrer/yXHNWIvkVPxJGnBL4Bc5iqf8+qdLx/j/Q3fFBOLvNiQsf8vQeU3L1+Tnux/UOin5zOk/Rr+xYi2j6UNlDmDLxb/T5HRkFIM1RIV2Dfr9pQEJHo62Mmj0N4SWiDJLjP7LgXOO0Ayspp/cV+Quu56oEUqqdABzxu0lZSHDXlIQ0jihF/7JlnTZLP0GweaRTDHM4Fds9WBJe5hXAzQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN9PR11MB5276.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(396003)(39860400002)(376002)(346002)(136003)(366004)(38100700002)(76116006)(316002)(8936002)(66556008)(55016003)(66946007)(64756008)(52536014)(54906003)(110136005)(66476007)(5660300002)(66446008)(71200400001)(6636002)(33656002)(478600001)(86362001)(4326008)(7696005)(6506007)(38070700005)(41300700001)(9686003)(82960400001)(122000001)(2906002)(8676002)(26005)(186003)(53546011)(83380400001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?MlZvTXQ3OEtJa05QeGltU0t3bzlwb0liL1lvaEVqbXZ4N2p4Z0JPYlhIS0Ry?=
 =?utf-8?B?NWdxWng4ckdFSmtLMkpLbVhITGllZExPS0xDN3lIV0JqaHE0eTh5eStwQkFq?=
 =?utf-8?B?c3IySFRob3FFVVNqc2xkTFBrQnVMRFRVM2NFODQrRjMrTVJ4cFFzRUlOQXo4?=
 =?utf-8?B?b1Y0Qm5lTWd2VHdLVG5adVEyamtFbkFrajN2Y0swcVZjOGNSWERRdXY1ZmRq?=
 =?utf-8?B?WWRDbjZic2MzT0hQMExFMGtGczQzUXVMajdHN2h0QUlnOEd3R1YzSmZ2YXNl?=
 =?utf-8?B?SXlYVHVBa3VGNHN5TDI1QlBTRVlwdXNnOXF0L09xTXgvTEJTMEpEWmJwVnZs?=
 =?utf-8?B?U2Uvd1hkV2ZwK0RRQmFlemJNV1BibkJTZnBvUGlaZVhCRnBDUkd0Q01pOUFY?=
 =?utf-8?B?c3I1TkVrbU5NWVh2SG9hT1BrTEtNM0NRTDVNcDVHWnFldXNkSmZNaFRtejAw?=
 =?utf-8?B?NDZtWjg5VXQ5dWhsL2tSbnd4SWl6YnFMWTJzSzd1M0M5bzl6MGhJZ2Vad21u?=
 =?utf-8?B?eE13VHUzM1c5ajEraWQ0Qi9ZYTFrUFJkNENNU0FOQjdqNXlIK3BUZjY0UlBp?=
 =?utf-8?B?Rk9Wa2xVNUpFZHh1SUw5N0hJNUhuMXFJa012blljMTBYQzVlaXlkUlNIdXha?=
 =?utf-8?B?QTd6dXYwYUozZjhjeWFyR205azZpdWVnRFo4UWpFQXVtNmlQbjByNXI3ZTIw?=
 =?utf-8?B?N29XR2o1NlNNN2pXLzlYYU1TckV0WlcrK2V5aTRFYWpKeitibE1CLzJtaGd2?=
 =?utf-8?B?UVlLbTdEN0tHY3ZLYlZ6ZzNiYVRmMWc1eWhvNEREMTRvMkZCTHN0bW10L0Vx?=
 =?utf-8?B?cThCdUdKWUFJNFEyWFcrWW9kSktsRHB3WU4xMDdvdSt1KzY5eTdzNFJpRnFs?=
 =?utf-8?B?T1A0cjdobnNVTnd6RXFPdTRoTVFTcGRTQkJLWFNqQjVoUG5ETXdUS2k1cS9o?=
 =?utf-8?B?ano2UUErcGhxeDlMRHBYRE9oMWJwejRLL1BsdUVBVkdWTHZ4Z1VROG5ZbThR?=
 =?utf-8?B?TkZmK0JGR2tXcFU3Uk1MdHd2dW1Xa0RjUjNpZVdKRXRuNCt1aWgyRDVMSldJ?=
 =?utf-8?B?Z3lMWmJmT1hZZVcycW5JKzFGbHZQUUp6NEY0U2JCcXF0NjYyUFpjT2trVW1z?=
 =?utf-8?B?MzBHN25nWWt1Rmtjcis5ODhSc2R1Rm5mUnlqZWtsWVlPRlRwTGVGZGtqL3pG?=
 =?utf-8?B?QnF4YktUbUtrVzhRQ2NIM3d0Ly9DZTBwYVJaTTlvMlU2Q3VjeUYzSlY3a3pD?=
 =?utf-8?B?aHJzQXl6bGJwci93K21FTGNqa0laSS8rN3JvbG51dzVWZlk2UitXaXNEeUFD?=
 =?utf-8?B?bmdwOCtHZ1RCVkZPMFFOandVT1JvOUdiN25UbndnZk5tbGdMd0VSZDRaVFdm?=
 =?utf-8?B?ZjdXQUhRSVFJU0NqV0lEcmRBZHFIMXpQaFpwSHZ0MDQ0cVRFMU51VlhQdjhy?=
 =?utf-8?B?S0VsS2VYSkVGcC92ajFyRmR6a1E4RTlhcWwxVXB0YVFqby85UFk1ckIrZkZq?=
 =?utf-8?B?QmxJM01DWGtJUjUvL0RzODdkSVFjaTJEbnlER3o4bmgzdnkxbUtySXAxVkdJ?=
 =?utf-8?B?bzM3M0FtZG45cXhKQmNWLzd0ZWp4ZU1VVzA4V285eEQrZkdkUkg4dFpDMXNZ?=
 =?utf-8?B?bFpkMTczRXRxSTVXd3pqTlFnY2F3YzJpemhQaUI3VUdUekVwTmhPZXliQlNQ?=
 =?utf-8?B?YTBHR01xTXhIYVhrWUFxVzN5U3J0bWEyY2tJN2EzYzhBampOU0RaOVZRaEdq?=
 =?utf-8?B?MUNzMEpBVzE0clhPZkVQVmhOcUZBOEZmMFltYkxDa3Bod2hDVFY0eTJaL2tW?=
 =?utf-8?B?M05haHEveWlSUnhRdWV3TEdVTnBtOU4rVEFyUWc4akFKZDFOSTVGZGxpd3VE?=
 =?utf-8?B?WGtBYkc4ZTZZUTBiZ2NQNng5K3loVEs0dVRCVytpa3V0d3hJZFRLWjc4YkZo?=
 =?utf-8?B?UFhzcUVKL2tFUmdLQ3VWQzRNQklUR1F1K203L1dOWUlINXpORlE2c0R1K2NW?=
 =?utf-8?B?RS8veVVkVkNRMjhCcHhnb015dEVjVXRETVBFS3VOYzBOdGR1THRmOEcydS9v?=
 =?utf-8?B?TmNnSFNzRXJLem1JRnk1L3dPeXhsdXVLY0NmZndFQ05qcEo3a0xNSmJzREdu?=
 =?utf-8?B?ZUFnbzRqbE85bnR6b25tRHdHa2VZUXFhS3RCaENJQk85SG1sNWpwU055cVA0?=
 =?utf-8?B?MjR0ZUJaTlpaaGk5U3oyLzFPTURTZzY1RTFlbnJ4OHRFSDd5REQ1bWhpall2?=
 =?utf-8?B?d1pCOE43azUweDZXUkg1T0dlSncvMmxGa0J2MVVhS3dNcjkzcm9YVkRja3J3?=
 =?utf-8?B?NFZqajRSVjBGTVZLaE96VWZ5anFqZHhxTEh1MTF0ZFB3b25TQnV2QT09?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN9PR11MB5276.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3bcaee62-13fd-4455-2a30-08da53fc4445
X-MS-Exchange-CrossTenant-originalarrivaltime: 22 Jun 2022 03:06:56.8437
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: LmGiXO8o/vXJSrJR/efP4eUQOsl+iCKCr7NgaoTT0K7+6wzUykKg2+hhn0Z1ljcwWZ9OcoqlBmGgUjbsGUTZMQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL0PR11MB3233
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

PiBGcm9tOiBCYW9sdSBMdSA8YmFvbHUubHVAbGludXguaW50ZWwuY29tPg0KPiBTZW50OiBUdWVz
ZGF5LCBKdW5lIDIxLCAyMDIyIDU6MDQgUE0NCj4gDQo+IE9uIDIwMjIvNi8yMSAxMzo0OCwgVGlh
biwgS2V2aW4gd3JvdGU6DQo+ID4+IEZyb206IEJhb2x1IEx1IDxiYW9sdS5sdUBsaW51eC5pbnRl
bC5jb20+DQo+ID4+IFNlbnQ6IFR1ZXNkYXksIEp1bmUgMjEsIDIwMjIgMTI6MjggUE0NCj4gPj4N
Cj4gPj4gT24gMjAyMi82LzIxIDExOjQ2LCBUaWFuLCBLZXZpbiB3cm90ZToNCj4gPj4+PiBGcm9t
OiBCYW9sdSBMdSA8YmFvbHUubHVAbGludXguaW50ZWwuY29tPg0KPiA+Pj4+IFNlbnQ6IFR1ZXNk
YXksIEp1bmUgMjEsIDIwMjIgMTE6MzkgQU0NCj4gPj4+Pg0KPiA+Pj4+IE9uIDIwMjIvNi8yMSAx
MDo1NCwgVGlhbiwgS2V2aW4gd3JvdGU6DQo+ID4+Pj4+PiBGcm9tOiBMdSBCYW9sdSA8YmFvbHUu
bHVAbGludXguaW50ZWwuY29tPg0KPiA+Pj4+Pj4gU2VudDogTW9uZGF5LCBKdW5lIDIwLCAyMDIy
IDQ6MTcgUE0NCj4gPj4+Pj4+IEBAIC0yNTY0LDcgKzI1NjQsNyBAQCBzdGF0aWMgaW50IGRvbWFp
bl9hZGRfZGV2X2luZm8oc3RydWN0DQo+ID4+Pj4+PiBkbWFyX2RvbWFpbiAqZG9tYWluLCBzdHJ1
Y3QgZGV2aWNlICpkZXYpDQo+ID4+Pj4+PiAgICAgCQkJcmV0ID0gaW50ZWxfcGFzaWRfc2V0dXBf
c2Vjb25kX2xldmVsKGlvbW11LA0KPiA+Pj4+Pj4gZG9tYWluLA0KPiA+Pj4+Pj4gICAgIAkJCQkJ
ZGV2LCBQQVNJRF9SSUQyUEFTSUQpOw0KPiA+Pj4+Pj4gICAgIAkJc3Bpbl91bmxvY2tfaXJxcmVz
dG9yZSgmaW9tbXUtPmxvY2ssIGZsYWdzKTsNCj4gPj4+Pj4+IC0JCWlmIChyZXQpIHsNCj4gPj4+
Pj4+ICsJCWlmIChyZXQgJiYgcmV0ICE9IC1FQlVTWSkgew0KPiA+Pj4+Pj4gICAgIAkJCWRldl9l
cnIoZGV2LCAiU2V0dXAgUklEMlBBU0lEIGZhaWxlZFxuIik7DQo+ID4+Pj4+PiAgICAgCQkJZG1h
cl9yZW1vdmVfb25lX2Rldl9pbmZvKGRldik7DQo+ID4+Pj4+PiAgICAgCQkJcmV0dXJuIHJldDsN
Cj4gPj4+Pj4+IC0tDQo+ID4+Pj4+PiAyLjI1LjENCj4gPj4+Pj4NCj4gPj4+Pj4gSXQncyBjbGVh
bmVyIHRvIGF2b2lkIHRoaXMgZXJyb3IgYXQgdGhlIGZpcnN0IHBsYWNlLCBpLmUuIG9ubHkgZG8g
dGhlDQo+ID4+Pj4+IHNldHVwIHdoZW4gdGhlIGZpcnN0IGRldmljZSBpcyBhdHRhY2hlZCB0byB0
aGUgcGFzaWQgdGFibGUuDQo+ID4+Pj4NCj4gPj4+PiBUaGUgbG9naWMgdGhhdCBpZGVudGlmaWVz
IHRoZSBmaXJzdCBkZXZpY2UgbWlnaHQgaW50cm9kdWNlIGFkZGl0aW9uYWwNCj4gPj4+PiB1bm5l
Y2Vzc2FyeSBjb21wbGV4aXR5LiBEZXZpY2VzIHRoYXQgc2hhcmUgYSBwYXNpZCB0YWJsZSBhcmUg
cmFyZS4gSQ0KPiA+Pj4+IGV2ZW4gcHJlZmVyIHRvIGdpdmUgdXAgc2hhcmluZyB0YWJsZXMgc28g
dGhhdCB0aGUgY29kZSBjYW4gYmUNCj4gPj4+PiBzaW1wbGVyLjotKQ0KPiA+Pj4+DQo+ID4+Pg0K
PiA+Pj4gSXQncyBub3QgdGhhdCBjb21wbGV4IGlmIHlvdSBzaW1wbHkgbW92ZSBkZXZpY2VfYXR0
YWNoX3Bhc2lkX3RhYmxlKCkNCj4gPj4+IG91dCBvZiBpbnRlbF9wYXNpZF9hbGxvY190YWJsZSgp
LiBUaGVuIGRvIHRoZSBzZXR1cCBpZg0KPiA+Pj4gbGlzdF9lbXB0eSgmcGFzaWRfdGFibGUtPmRl
dikgYW5kIHRoZW4gYXR0YWNoIGRldmljZSB0byB0aGUNCj4gPj4+IHBhc2lkIHRhYmxlIGluIGRv
bWFpbl9hZGRfZGV2X2luZm8oKS4NCj4gPj4NCj4gPj4gVGhlIHBhc2lkIHRhYmxlIGlzIHBhcnQg
b2YgdGhlIGRldmljZSwgaGVuY2UgYSBiZXR0ZXIgcGxhY2UgdG8NCj4gPj4gYWxsb2NhdGUvZnJl
ZSB0aGUgcGFzaWQgdGFibGUgaXMgaW4gdGhlIGRldmljZSBwcm9iZS9yZWxlYXNlIHBhdGhzLg0K
PiA+PiBUaGluZ3Mgd2lsbCBiZWNvbWUgbW9yZSBjb21wbGljYXRlZCBpZiB3ZSBjaGFuZ2UgcmVs
YXRpb25zaGlwIGJldHdlZW4NCj4gPj4gZGV2aWNlIGFuZCBpdCdzIHBhc2lkIHRhYmxlIHdoZW4g
YXR0YWNoaW5nL2RldGFjaGluZyBhIGRvbWFpbi4gVGhhdCdzDQo+ID4+IHRoZSByZWFzb24gd2h5
IEkgdGhvdWdodCBpdCB3YXMgYWRkaXRpb25hbCBjb21wbGV4aXR5Lg0KPiA+Pg0KPiA+DQo+ID4g
SWYgeW91IGRvIHdhbnQgdG8gZm9sbG93IGN1cnJlbnQgcm91dGUgaXTigJlzIHN0aWxsIGNsZWFu
ZXIgdG8gY2hlY2sNCj4gPiB3aGV0aGVyIHRoZSBwYXNpZCBlbnRyeSBoYXMgcG9pbnRlZCB0byB0
aGUgZG9tYWluIGluIHRoZSBpbmRpdmlkdWFsDQo+ID4gc2V0dXAgZnVuY3Rpb24gaW5zdGVhZCBv
ZiBibGluZGx5IHJldHVybmluZyAtRUJVU1kgYW5kIHRoZW4gaWdub3JpbmcNCj4gPiBpdCBldmVu
IGlmIGEgcmVhbCBidXN5IGNvbmRpdGlvbiBvY2N1cnMuIFRoZSBzZXR1cCBmdW5jdGlvbnMgY2Fu
DQo+ID4ganVzdCByZXR1cm4gemVybyBmb3IgdGhpcyBiZW5pZ24gYWxpYXMgY2FzZS4NCj4gDQo+
IEtldmluLCBob3cgZG8geW91IGxpa2UgdGhpcyBvbmU/DQo+IA0KPiBkaWZmIC0tZ2l0IGEvZHJp
dmVycy9pb21tdS9pbnRlbC9wYXNpZC5jIGIvZHJpdmVycy9pb21tdS9pbnRlbC9wYXNpZC5jDQo+
IGluZGV4IGNiNGMxZDBjZjI1Yy4uZWNmZmQwMTI5YjJiIDEwMDY0NA0KPiAtLS0gYS9kcml2ZXJz
L2lvbW11L2ludGVsL3Bhc2lkLmMNCj4gKysrIGIvZHJpdmVycy9pb21tdS9pbnRlbC9wYXNpZC5j
DQo+IEBAIC01NzUsNiArNTc1LDE2IEBAIHN0YXRpYyBpbmxpbmUgaW50IHBhc2lkX2VuYWJsZV93
cGUoc3RydWN0DQo+IHBhc2lkX2VudHJ5ICpwdGUpDQo+ICAgCXJldHVybiAwOw0KPiAgIH07DQo+
IA0KPiArLyoNCj4gKyAqIFJldHVybiB0cnVlIGlmIEBwYXNpZCBpcyBSSUQyUEFTSUQgYW5kIHRo
ZSBkb21haW4gQGRpZCBoYXMgYWxyZWFkeQ0KPiArICogYmVlbiBzZXR1cCB0byB0aGUgQHB0ZS4g
T3RoZXJ3aXNlLCByZXR1cm4gZmFsc2UuDQo+ICsgKi8NCj4gK3N0YXRpYyBpbmxpbmUgYm9vbA0K
PiArcmlkMnBhc2lkX2RvbWFpbl92YWxpZChzdHJ1Y3QgcGFzaWRfZW50cnkgKnB0ZSwgdTMyIHBh
c2lkLCB1MTYgZGlkKQ0KPiArew0KPiArCXJldHVybiBwYXNpZCA9PSBQQVNJRF9SSUQyUEFTSUQg
JiYgcGFzaWRfZ2V0X2RvbWFpbl9pZChwdGUpID09DQo+IGRpZDsNCj4gK30NCg0KYmV0dGVyIHRo
aXMgaXMgbm90IHJlc3RyaWN0ZWQgdG8gUklEMlBBU0lEIG9ubHksIGUuZy4gcGFzaWRfcHRlX21h
dGNoX2RvbWFpbigpDQphbmQgdGhlbiByZWFkIHBhc2lkIGZyb20gdGhlIHB0ZSB0byBjb21wYXJl
IHdpdGggdGhlIHBhc2lkIGFyZ3VtZW50Lg0KDQo+ICsNCj4gICAvKg0KPiAgICAqIFNldCB1cCB0
aGUgc2NhbGFibGUgbW9kZSBwYXNpZCB0YWJsZSBlbnRyeSBmb3IgZmlyc3Qgb25seQ0KPiAgICAq
IHRyYW5zbGF0aW9uIHR5cGUuDQo+IEBAIC01OTUsOSArNjA1LDggQEAgaW50IGludGVsX3Bhc2lk
X3NldHVwX2ZpcnN0X2xldmVsKHN0cnVjdCBpbnRlbF9pb21tdQ0KPiAqaW9tbXUsDQo+ICAgCWlm
IChXQVJOX09OKCFwdGUpKQ0KPiAgIAkJcmV0dXJuIC1FSU5WQUw7DQo+IA0KPiAtCS8qIENhbGxl
ciBtdXN0IGVuc3VyZSBQQVNJRCBlbnRyeSBpcyBub3QgaW4gdXNlLiAqLw0KPiAgIAlpZiAocGFz
aWRfcHRlX2lzX3ByZXNlbnQocHRlKSkNCj4gLQkJcmV0dXJuIC1FQlVTWTsNCj4gKwkJcmV0dXJu
IHJpZDJwYXNpZF9kb21haW5fdmFsaWQocHRlLCBwYXNpZCwgZGlkKSA/IDA6IC1FQlVTWTsNCj4g
DQo+ICAgCXBhc2lkX2NsZWFyX2VudHJ5KHB0ZSk7DQo+IA0KPiBAQCAtNjk4LDkgKzcwNyw4IEBA
IGludCBpbnRlbF9wYXNpZF9zZXR1cF9zZWNvbmRfbGV2ZWwoc3RydWN0DQo+IGludGVsX2lvbW11
ICppb21tdSwNCj4gICAJCXJldHVybiAtRU5PREVWOw0KPiAgIAl9DQo+IA0KPiAtCS8qIENhbGxl
ciBtdXN0IGVuc3VyZSBQQVNJRCBlbnRyeSBpcyBub3QgaW4gdXNlLiAqLw0KPiAgIAlpZiAocGFz
aWRfcHRlX2lzX3ByZXNlbnQocHRlKSkNCj4gLQkJcmV0dXJuIC1FQlVTWTsNCj4gKwkJcmV0dXJu
IHJpZDJwYXNpZF9kb21haW5fdmFsaWQocHRlLCBwYXNpZCwgZGlkKSA/IDA6IC1FQlVTWTsNCj4g
DQo+ICAgCXBhc2lkX2NsZWFyX2VudHJ5KHB0ZSk7DQo+ICAgCXBhc2lkX3NldF9kb21haW5faWQo
cHRlLCBkaWQpOw0KPiBAQCAtNzM4LDkgKzc0Niw4IEBAIGludCBpbnRlbF9wYXNpZF9zZXR1cF9w
YXNzX3Rocm91Z2goc3RydWN0DQo+IGludGVsX2lvbW11ICppb21tdSwNCj4gICAJCXJldHVybiAt
RU5PREVWOw0KPiAgIAl9DQo+IA0KPiAtCS8qIENhbGxlciBtdXN0IGVuc3VyZSBQQVNJRCBlbnRy
eSBpcyBub3QgaW4gdXNlLiAqLw0KPiAgIAlpZiAocGFzaWRfcHRlX2lzX3ByZXNlbnQocHRlKSkN
Cj4gLQkJcmV0dXJuIC1FQlVTWTsNCj4gKwkJcmV0dXJuIHJpZDJwYXNpZF9kb21haW5fdmFsaWQo
cHRlLCBwYXNpZCwgZGlkKSA/IDA6IC1FQlVTWTsNCj4gDQo+ICAgCXBhc2lkX2NsZWFyX2VudHJ5
KHB0ZSk7DQo+ICAgCXBhc2lkX3NldF9kb21haW5faWQocHRlLCBkaWQpOw0KPiANCj4gLS0NCj4g
QmVzdCByZWdhcmRzLA0KPiBiYW9sdQ0K
