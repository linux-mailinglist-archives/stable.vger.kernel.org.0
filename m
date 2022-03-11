Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 69A424D5B71
	for <lists+stable@lfdr.de>; Fri, 11 Mar 2022 07:15:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234389AbiCKGQH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 11 Mar 2022 01:16:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58984 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237589AbiCKGP6 (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 11 Mar 2022 01:15:58 -0500
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9E66A141E27;
        Thu, 10 Mar 2022 22:14:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1646979293; x=1678515293;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=VgZcOcG/Fc2vhHfrW4iv0v7+QQ6vM6fHA6AKRfk0dfM=;
  b=ZKJe7GYrdFQh8fTGlghyjPht/YNipT3scOUkuXQchAJqk5zFQnAUbZdz
   aM9T9zd4Oliqa6Bxzc8m/9GYkfRm7ZAOnEoseoC4j2BtzNweBGGCTUa2s
   jOC5vitgVLSy0FgwRzZtNlMk/KIaHFotzODX8iOj2D22YmcuYQEFRc+U8
   udHGIXOIdJbuoj6ftxH3WUKpEZll2zIL0+wXCh6bgMfSh902kOraJ+++U
   MqDwfP/OPyAX8SerKmdyx0Sk+73Ab2LX+YTfCbsSrfO0c2Px85Ypv6NZL
   NBk9CqXywJakPZmsgNPi49npA5ADF2TCafDSdO8uOFkat4s6gIIBVkFRb
   A==;
X-IronPort-AV: E=McAfee;i="6200,9189,10282"; a="255699727"
X-IronPort-AV: E=Sophos;i="5.90,173,1643702400"; 
   d="scan'208";a="255699727"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Mar 2022 22:14:38 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.90,173,1643702400"; 
   d="scan'208";a="514395608"
Received: from orsmsx601.amr.corp.intel.com ([10.22.229.14])
  by orsmga006.jf.intel.com with ESMTP; 10 Mar 2022 22:14:38 -0800
Received: from orsmsx602.amr.corp.intel.com (10.22.229.15) by
 ORSMSX601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.21; Thu, 10 Mar 2022 22:14:37 -0800
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.21 via Frontend Transport; Thu, 10 Mar 2022 22:14:37 -0800
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (104.47.57.174)
 by edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2308.21; Thu, 10 Mar 2022 22:14:37 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=b/2Uy/bcira4ZZZDjqTROCoAf66si/Z0f1HXKw44AUR2YlrQgM1th78nHOoTR/EvULCeWUFodpWsRGlAr+nvRAnkeqYxZo3Tfq0cKCoOfAfm1r+JQcC/ABnZpMdRXS3Y85uJT4+NpeNX+3Vq+FSiQyT+OobOthzHu5wVdCbyxUfD/ukSCZBiTb2eufiHDD8/sAn2U2VOhJzlk1ivghI6TFpxN5rrpUNaqg33xKq2OkX4EoNHk37w7lbMPfnSy9JUH0q1Zow+euMKwM7im8u2YkNpHRsQQaNCOpV3dJZZACrxql0O5IEAOfVkBlYXxdDvo3Y6on3q8t10mAxvC8cK5w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=VgZcOcG/Fc2vhHfrW4iv0v7+QQ6vM6fHA6AKRfk0dfM=;
 b=RHwp/L/22dL2PW+7i/rZmzyR+QgOJ7TCYXGkR7LiQjYUy29QjNo6YHhTHeKI3FazNjd0APjnM/OZe9N/IcJv9mNjC5GAlxb+tV9119i1KtLku6JNe6fiHbrLru0S2ow7ugHlf0eijXT95cLhsUCK2IS0j8oduNYgS8uQKIhrATQK+1a8+2RGjKA1Nu3azco6OlHbbGr5SVciCZe1EPMkmf0aWend7EQRu61UUwMgilEqUrmUelsVpA4JX67CMgxfkblLPTgAyC3GiGBEq2ekdt0t+JxQqwwtBef/TAwdHOE1Lax3+ZT393g2UMlS1QKrH+sLPjWAeMK18NWjd0Sbgg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BYAPR11MB3544.namprd11.prod.outlook.com (2603:10b6:a03:b5::29)
 by DM6PR11MB2617.namprd11.prod.outlook.com (2603:10b6:5:ce::31) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5038.17; Fri, 11 Mar
 2022 06:14:27 +0000
Received: from BYAPR11MB3544.namprd11.prod.outlook.com
 ([fe80::bdb7:b2dc:389c:3e7e]) by BYAPR11MB3544.namprd11.prod.outlook.com
 ([fe80::bdb7:b2dc:389c:3e7e%7]) with mapi id 15.20.5038.027; Fri, 11 Mar 2022
 06:14:26 +0000
From:   "Huang, Yonghua" <yonghua.huang@intel.com>
To:     "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>
CC:     "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        "Chatre, Reinette" <reinette.chatre@intel.com>,
        "Wang, Zhi A" <zhi.a.wang@intel.com>,
        "Wang, Yu1" <yu1.wang@intel.com>, "Li, Fei1" <fei1.li@intel.com>,
        "Huang, Yonghua" <yonghua.huang@intel.com>
Subject: RE: [PATCH] virt: acrn: obtain pa from VMA with PFNMAP flag
Thread-Topic: [PATCH] virt: acrn: obtain pa from VMA with PFNMAP flag
Thread-Index: AQHYLEfg4LGJm4nTXkWIyXm40QwGzKy5xa1w
Date:   Fri, 11 Mar 2022 06:14:26 +0000
Message-ID: <BYAPR11MB354489435A1AE48DB753B2B0F70C9@BYAPR11MB3544.namprd11.prod.outlook.com>
References: <20220228022212.419406-1-yonghua.huang@intel.com>
In-Reply-To: <20220228022212.419406-1-yonghua.huang@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
dlp-reaction: no-action
dlp-version: 11.6.401.20
dlp-product: dlpe-windows
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 83db8966-bca8-4c9f-de4e-08da032664f5
x-ms-traffictypediagnostic: DM6PR11MB2617:EE_
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-microsoft-antispam-prvs: <DM6PR11MB2617F64BFC302C2A2CA2AC7FF70C9@DM6PR11MB2617.namprd11.prod.outlook.com>
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: AeYCoJIGiGL7fkNP2glOOustnusfrfM1seaJohfkvK8IW3hfprcPCjCrT9T7INNyOvsgA4+oiuVkBjP2nvTbLSnhnvqn7hUhkVDaveUN6QrNVPeuIqgoMOX3cofJnebxDNLxj/rxX5uPIOCF9EfuMw855QNXHFcATQVmPfOAthnDcbEhPpIfVSeXiBiSxd7GKSX5DunkDSUFATq2L7vmSiIaiL2WEJ5+MmIwX6LRRaGcmU51HnddEWWoIZOyj33B85dBNlhnFfK0OMic4ZXfXfg8FT9sm1ogqmNnETMSNph77nMiiikhf+WZ/aMEZVJuDQsT4Ls/310U3ihiWxYjyH/jGowlB1lGwnelsuQMWyjx7jjJxQ1Hotv1V/vF2CwkhXQ8i6srKImv4/EnvpOkO6VDD2cXREKkH09nikCddywSMTTp//xQ/07aU4sC/mR1jXURZJH/prvUWsrT13mxunvQHn914tPnKJ2JtMHqlqm6xluTwOSx6wJsB1xwjtgjbnkqx8HYtUWph15fFe6++AlOK3sEi4B85HLhbKmSch+BDc+3ZyIGtkShs12g2SLuobIVfGsc1OVnrt4DtGatg6APVyNOnZ4KENGzyVSU+6QQDjy+ByVAMHSJ9C+Gr0Sa6yJAHPe0YQcZ1V9wk+E9AcLgNrz0WKec6HR/9/neIq8D9dlwACIH1ggPmsqDBvD6d/EXV2AUY4HtTVgj/4F0iQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR11MB3544.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(53546011)(66946007)(7696005)(33656002)(26005)(38100700002)(122000001)(9686003)(83380400001)(6506007)(5660300002)(508600001)(2906002)(71200400001)(316002)(52536014)(8936002)(66556008)(66446008)(66476007)(8676002)(186003)(64756008)(76116006)(38070700005)(55016003)(82960400001)(107886003)(4326008)(54906003)(6916009)(86362001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?dWpVYzFiMUdCWklBMk1OcVRrSEIrdTliWkt1aE5aOVVoRTE4ZUp2Sm13S1Mr?=
 =?utf-8?B?TU1uaCtLNzRDVERLdEZ5NVhSa2tSd3BlcW9MZ21Zb1puNXlQbnZPMDFnKzlx?=
 =?utf-8?B?REhTTnlDUkpEMTlCYklFRTNRNzQ1SVFrZlN4N2NEcStxWFFaY1VxQ1pndXA1?=
 =?utf-8?B?WUk5b2ZoWjRKWEdkaU5hSHgrUzlXbUxRbHRKeC9QMnU3R0U0aDFNMGU4eHRQ?=
 =?utf-8?B?VEFqQ2NDQ0ptMXFhT3R6Q3BaYk5vTTZKUW1lZlRTUjRBT1Y3QXNCZXJ6U3Js?=
 =?utf-8?B?YUNHeUJqdnUwQWc5ZXhlbXR2dVMzQmRaS2pjdk9kZ2xxK0hIb0Iwc3MreTVU?=
 =?utf-8?B?YlcwTVlnN3dvL0dvcUIvemJyZkZvR3F2enk4Qno3Qm95NktDaitFUjVmMXNO?=
 =?utf-8?B?cGxVYUtYTmlmT0dMUFFnWDMrd1Q4Q2pKU2xBQ0tiZUdFQUl5V1dZUFhwazFG?=
 =?utf-8?B?YTNJU1J0SU5zZlhybUViYXk5Y0s4ZFBlWnptcFBkMXUxTGxwTGMrbkk4V1pr?=
 =?utf-8?B?MG52cUp4MVdIYXJBVVBaR1Vvd05ISDQ1UXJJT25tM2o1N2xreWE1dUpYOWNv?=
 =?utf-8?B?NXRQUGtXUldxaXhvdmJncHdwT0tMUWVtMGp5MXd1QXVyNXFOSUdONzVRZzU1?=
 =?utf-8?B?ajBUOVZWdHVLMDNjdDJ4bm04MDJHczFXbW1TNjBnUHU3UzhUUlBMNkdRaG00?=
 =?utf-8?B?eU1uWW5iRWlzOGJUeUhvL1BOcllSMll0Y21CS3M4amtyY3lVOGlac0JNbDVH?=
 =?utf-8?B?Q3MzaXlMYnlyZTdTZ2Q1MWZtZE4xQ1AvcXc2ZW1YRnk4ZVVHdGZaMmVoNWIv?=
 =?utf-8?B?cHNDaXpFWWt2RElLcDZzOVlmZ2xqTElFRTd6aHRQQklxMmt0d0p5bzhHbjR4?=
 =?utf-8?B?VUl3dHZpNTRSVjBiZkhUVmI4RkdLQVVQNkgxSmU2ZUdieUxLekMyOWY2U0E5?=
 =?utf-8?B?M2VndUhTOEVNc2hYei9OcTNqUy9TSUJFWEt3WmZkM0NaVkFOK3Nvd3hmaUhv?=
 =?utf-8?B?YmtkM3ZoVVpxVDBIMXRqNUxWSkJDc09sZ1R2WTR0Sks2YlljR1crMEtqVExz?=
 =?utf-8?B?ZVpOQVVvd04xZ05ySWdzK29uZlF6ak9EL0hvRTVUQm9iTmhtNzZ3WEluZFdS?=
 =?utf-8?B?Y3JXY3VDMWk4SEVPK2p2L2k2UkxIVmxGTWtaci9INFAzUG9DRFc4TDdkSU5R?=
 =?utf-8?B?bHVGdnpVTC9qQ0xRUWVEUG5hMWQ0VkRHRzh1NktiZEZzNnRpREw3TEgxVTZZ?=
 =?utf-8?B?R29nWElTK283dTM0NmtMcUFxSzJaOFVBZUNRTEdtVW9TblpzYUE3cTZoTm41?=
 =?utf-8?B?OTRUeVYzV25wWGNSL2d2VWNsaFBKU01JR0NnaDhYc0tzeGFGUzNFTmw0Vk1W?=
 =?utf-8?B?MlQ3S09PblRqMC8vMHhMdVkySjROalZON3gySHhUVDlWUDRaTkJ1NC9lMmdU?=
 =?utf-8?B?Sm1ycUplSGVtQTdkY0x1YWdCTkg1Wi84aURrTmJTcVNQNGRKUGYzNktpVVRo?=
 =?utf-8?B?VHptU3BtT0NNdW9yZmVsSE1RejBTTlVBNGxTbHBTUGtsTHhSY1VYc1BBcVRF?=
 =?utf-8?B?ZGlkSFNyWFdMVGdVcE1KR2xvV0wvK3l2aDhXdTlRTXhQZVp2Kzg4WndSbDNC?=
 =?utf-8?B?MVU2QTE5ck1yeDRjdFZZRjFLYkFYOW5abTV2SDUycHkxRndLb3V5MVBTRHpC?=
 =?utf-8?B?NTJ2U3lpa0FKOFRUTXYyN2Q1SVZSUWZDVHJhR0lKdnBkK0dUTjNjMzQ0V0Ux?=
 =?utf-8?B?ZkdNd2JtazMreGk1TTdFTmFSRk1mckRrRGh5Wk5wQUYxZWFsUlZHQkUzM0oz?=
 =?utf-8?B?WGM2NGtXOEpoM0g1QVFDMTJNYi9hVjRiM0ttS1o2Kys3WHRVVWtmMENWeDJQ?=
 =?utf-8?B?QkRKVnJyZTBqV3AraG56ZjZyWkRIaDRWaTJvOWFIcVorRUQ5dWZ3MXU5NGp6?=
 =?utf-8?B?S1hjakxyQmRIQmZyMXV6SWJMT0pvcThPQks5d3EyTWlLWEhMY0k2R3BGWEZv?=
 =?utf-8?B?YWJoRWY3bmxydkpac0JOU2o0MHRHb1B0QThFS0lsTGV0YUZqRFRqQUpyMmVG?=
 =?utf-8?B?MkNKYVpVU1lsUVhrV3paUEk5a0RZWHNMb2JZdjd2bW9MZHlBWFlvcklIQUZp?=
 =?utf-8?B?MExyY2JWK1g3VDkvOVFKNG9EU2NJT1F5WUdHMU5ZMmFzWWVpQkdCanBKcVBD?=
 =?utf-8?B?R0E9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BYAPR11MB3544.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 83db8966-bca8-4c9f-de4e-08da032664f5
X-MS-Exchange-CrossTenant-originalarrivaltime: 11 Mar 2022 06:14:26.2415
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: kQsOje9Lb17tcEkaVQLZA35AiR3mYv6sNXdcZcJZ9uhM1+5NoTg78+u+vVvydbvYZs6nIHv5LCkjhH/rmOsl4g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR11MB2617
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

SGVsbG8gR3JlZywNCg0KICAgQ2FuIHlvdSBraW5kbHkgaGVscCByZXZpZXcgdGhpcyBwYXRjaD8g
VGhhbmsgeW918J+Yig0KDQoNCi1Zb25naHVhDQoNCj4gLS0tLS1PcmlnaW5hbCBNZXNzYWdlLS0t
LS0NCj4gRnJvbTogSHVhbmcsIFlvbmdodWEgPHlvbmdodWEuaHVhbmdAaW50ZWwuY29tPg0KPiBT
ZW50OiBNb25kYXksIEZlYnJ1YXJ5IDI4LCAyMDIyIDEwOjIyDQo+IFRvOiBncmVna2hAbGludXhm
b3VuZGF0aW9uLm9yZw0KPiBDYzogbGludXgta2VybmVsQHZnZXIua2VybmVsLm9yZzsgc3RhYmxl
QHZnZXIua2VybmVsLm9yZzsgQ2hhdHJlLCBSZWluZXR0ZQ0KPiA8cmVpbmV0dGUuY2hhdHJlQGlu
dGVsLmNvbT47IFdhbmcsIFpoaSBBIDx6aGkuYS53YW5nQGludGVsLmNvbT47IFdhbmcsDQo+IFl1
MSA8eXUxLndhbmdAaW50ZWwuY29tPjsgTGksIEZlaTEgPGZlaTEubGlAaW50ZWwuY29tPjsgSHVh
bmcsIFlvbmdodWENCj4gPHlvbmdodWEuaHVhbmdAaW50ZWwuY29tPjsgTGksIEZlaTEgPGZlaTEu
bGlAaW50ZWwuY29tPg0KPiBTdWJqZWN0OiBbUEFUQ0hdIHZpcnQ6IGFjcm46IG9idGFpbiBwYSBm
cm9tIFZNQSB3aXRoIFBGTk1BUCBmbGFnDQo+IA0KPiAgYWNybl92bV9yYW1fbWFwIGNhbid0IHBp
biB0aGUgdXNlciBwYWdlcyB3aXRoIFZNX1BGTk1BUCBmbGFnICBieQ0KPiBjYWxsaW5nIGdldF91
c2VyX3BhZ2VzX2Zhc3QoKSwgdGhlIFBBKHBoeXNpY2FsIHBhZ2VzKSAgbWF5IGJlIG1hcHBlZCBi
eQ0KPiBrZXJuZWwgZHJpdmVyIGFuZCBzZXQgUEZOTUFQIGZsYWcuDQo+IA0KPiAgVGhpcyBwYXRj
aCBmaXhlcyBsb2dpYyB0byBzZXR1cCBFUFQgbWFwcGluZyBmb3IgUEZOIG1hcHBlZCBSQU0gcmVn
aW9uICBieQ0KPiBjaGVja2luZyB0aGUgbWVtb3J5IGF0dHJpYnV0ZSBiZWZvcmUgYWRkaW5nIEVQ
VCBtYXBwaW5nIGZvciB0aGVtLg0KPiANCj4gRml4ZXM6IDg4ZjUzN2Q1ZThkZCAoInZpcnQ6IGFj
cm46IEludHJvZHVjZSBFUFQgbWFwcGluZyBtYW5hZ2VtZW50IikNCj4gU2lnbmVkLW9mZi1ieTog
WW9uZ2h1YSBIdWFuZyA8eW9uZ2h1YS5odWFuZ0BpbnRlbC5jb20+DQo+IFNpZ25lZC1vZmYtYnk6
IEZlaSBMaSA8ZmVpMS5saUBpbnRlbC5jb20+DQo+IC0tLQ0KPiAgZHJpdmVycy92aXJ0L2Fjcm4v
bW0uYyB8IDI0ICsrKysrKysrKysrKysrKysrKysrKysrKw0KPiAgMSBmaWxlIGNoYW5nZWQsIDI0
IGluc2VydGlvbnMoKykNCj4gDQo+IGRpZmYgLS1naXQgYS9kcml2ZXJzL3ZpcnQvYWNybi9tbS5j
IGIvZHJpdmVycy92aXJ0L2Fjcm4vbW0uYyBpbmRleA0KPiBjNGYyZTE1YzhhMmIuLjNiMWIxZTdh
ODQ0YiAxMDA2NDQNCj4gLS0tIGEvZHJpdmVycy92aXJ0L2Fjcm4vbW0uYw0KPiArKysgYi9kcml2
ZXJzL3ZpcnQvYWNybi9tbS5jDQo+IEBAIC0xNjIsMTAgKzE2MiwzNCBAQCBpbnQgYWNybl92bV9y
YW1fbWFwKHN0cnVjdCBhY3JuX3ZtICp2bSwgc3RydWN0DQo+IGFjcm5fdm1fbWVtbWFwICptZW1t
YXApDQo+ICAJdm9pZCAqcmVtYXBfdmFkZHI7DQo+ICAJaW50IHJldCwgcGlubmVkOw0KPiAgCXU2
NCB1c2VyX3ZtX3BhOw0KPiArCXVuc2lnbmVkIGxvbmcgcGZuOw0KPiArCXN0cnVjdCB2bV9hcmVh
X3N0cnVjdCAqdm1hOw0KPiANCj4gIAlpZiAoIXZtIHx8ICFtZW1tYXApDQo+ICAJCXJldHVybiAt
RUlOVkFMOw0KPiANCj4gKwltbWFwX3JlYWRfbG9jayhjdXJyZW50LT5tbSk7DQo+ICsJdm1hID0g
dm1hX2xvb2t1cChjdXJyZW50LT5tbSwgbWVtbWFwLT52bWFfYmFzZSk7DQo+ICsJaWYgKHZtYSAm
JiAoKHZtYS0+dm1fZmxhZ3MgJiBWTV9QRk5NQVApICE9IDApKSB7DQo+ICsJCWlmICgobWVtbWFw
LT52bWFfYmFzZSArIG1lbW1hcC0+bGVuKSA+IHZtYS0+dm1fZW5kKQ0KPiB7DQo+ICsJCQltbWFw
X3JlYWRfdW5sb2NrKGN1cnJlbnQtPm1tKTsNCj4gKwkJCXJldHVybiAtRUlOVkFMOw0KPiArCQl9
DQo+ICsNCj4gKwkJcmV0ID0gZm9sbG93X3Bmbih2bWEsIG1lbW1hcC0+dm1hX2Jhc2UsICZwZm4p
Ow0KPiArCQltbWFwX3JlYWRfdW5sb2NrKGN1cnJlbnQtPm1tKTsNCj4gKwkJaWYgKHJldCA8IDAp
IHsNCj4gKwkJCWRldl9kYmcoYWNybl9kZXYudGhpc19kZXZpY2UsDQo+ICsJCQkJIkZhaWxlZCB0
byBsb29rdXAgUEZOIGF0IFZNQTolcEsuXG4iLCAodm9pZA0KPiAqKW1lbW1hcC0+dm1hX2Jhc2Up
Ow0KPiArCQkJcmV0dXJuIHJldDsNCj4gKwkJfQ0KPiArDQo+ICsJCXJldHVybiBhY3JuX21tX3Jl
Z2lvbl9hZGQodm0sIG1lbW1hcC0+dXNlcl92bV9wYSwNCj4gKwkJCSBQRk5fUEhZUyhwZm4pLCBt
ZW1tYXAtPmxlbiwNCj4gKwkJCSBBQ1JOX01FTV9UWVBFX1dCLCBtZW1tYXAtPmF0dHIpOw0KPiAr
CX0NCj4gKwltbWFwX3JlYWRfdW5sb2NrKGN1cnJlbnQtPm1tKTsNCj4gKw0KPiAgCS8qIEdldCB0
aGUgcGFnZSBudW1iZXIgb2YgdGhlIG1hcCByZWdpb24gKi8NCj4gIAlucl9wYWdlcyA9IG1lbW1h
cC0+bGVuID4+IFBBR0VfU0hJRlQ7DQo+ICAJcGFnZXMgPSB2emFsbG9jKG5yX3BhZ2VzICogc2l6
ZW9mKHN0cnVjdCBwYWdlICopKTsNCj4gDQo+IGJhc2UtY29tbWl0OiA3Mzg3OGU1ZWIxYmQzYzk2
NTY2ODVjYTYwYmMzYTQ5ZDE3MzExZTBjDQo+IC0tDQo+IDIuMjUuMQ0KDQo=
