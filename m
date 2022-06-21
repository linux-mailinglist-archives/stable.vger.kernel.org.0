Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2B0365529FF
	for <lists+stable@lfdr.de>; Tue, 21 Jun 2022 06:03:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345131AbiFUDqo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Jun 2022 23:46:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58772 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237675AbiFUDqm (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Jun 2022 23:46:42 -0400
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F39389FFB;
        Mon, 20 Jun 2022 20:46:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1655783202; x=1687319202;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=h6rnThC1o9psJ0MOOnpyPQxJSxVics562O+rEdwkzA0=;
  b=Js0aJh4s91KG952Y/07fdVpJJvZ/FJbdZXTxjB62b6dpJEFwNT0ex3X9
   xZ5CdNQRyY3lKL9pr5vkjbBmWap1qMCI7iKzC9+5kFiDvJfRTbRqYna9o
   BT6tdHUzRP+AHfqPOpMnqYcYQRvLA0qVZeThL5+XCq2BBQkQIZmCebhB4
   HyBe3BvUyS30lthD/VHtkwJ5QM7xWPXWKtsRqWCD++oL/LULPuIjCWz5Z
   iqK9mIzUoAc1EHrDAKn8ObqXOi53MvlYnNMhfh38n6aysMruzbuFzPFXI
   H7fSzm+Jx3YHo3wKRL8YNYCegRYPECOT1OaGokjqZApHPXhe1IBfJaEcs
   g==;
X-IronPort-AV: E=McAfee;i="6400,9594,10384"; a="280749620"
X-IronPort-AV: E=Sophos;i="5.92,207,1650956400"; 
   d="scan'208";a="280749620"
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Jun 2022 20:46:41 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.92,207,1650956400"; 
   d="scan'208";a="654953799"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by fmsmga004.fm.intel.com with ESMTP; 20 Jun 2022 20:46:41 -0700
Received: from fmsmsx607.amr.corp.intel.com (10.18.126.87) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.27; Mon, 20 Jun 2022 20:46:40 -0700
Received: from fmsmsx607.amr.corp.intel.com (10.18.126.87) by
 fmsmsx607.amr.corp.intel.com (10.18.126.87) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.27; Mon, 20 Jun 2022 20:46:40 -0700
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx607.amr.corp.intel.com (10.18.126.87) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.27 via Frontend Transport; Mon, 20 Jun 2022 20:46:40 -0700
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (104.47.56.174)
 by edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2308.27; Mon, 20 Jun 2022 20:46:40 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=DrUqDZnmbf1CBnf8XvvwRSOg5+cHjIy/TbNV49meI5CEwKFuT1HDfKgF7jcPbtnuliyAoohOefc3LAiL3EQSVl6MatHzILL34JXqtVdrol+WPfBC0gxlPMx1lc4pyt9x5IWxmFGTzYbUZ42LdMKmVaSPJcBtAOzaIEeE45FWAlxjiXF8REQ6r+b3ulRDev0ts+HmVGLINycLlK2KYL77l1KshYF16LitBS/UD7U0GnNFomKm/yw937O3JMIe4iSe6oYoTc/xAEK6CsjhdYLST7Nx//OACYQ7Lw9glj073IHWtD0RQSXIFYVXW7qrT42g2ohfJGzDoS3rJNlzICIhZA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=h6rnThC1o9psJ0MOOnpyPQxJSxVics562O+rEdwkzA0=;
 b=iDoovchFiIYwOBw12Qnz2IyHUDQ30Cb5aT0unwlZY0zdHn2oto3CeagnjPqnMUpMl4BbZMArktSDWCzKU7oSE+OZFA5yFwtdLZ5ofXUhkmPetK1ohZouO4d8WjYyWPxuoQe1gxmhjRflDZN4J39q2D0ZRst/qLkfbCHjw0mO3i3M8huQg+OJcwKgtavwYh6a9s099Io8zH0vR3Lp6/S0yzuRX1cy6i3pi3r1Drw9fxx+OMV/UUTcKnnwp/1lzu6sCYsYR5Ay2ITgsha453N0lKf9A5DHyA+YOImXZKgeTRRcKbni86OP2FDxxwzoDYbCQnLYP5r1+/2mU4Gt3Yhvog==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BN9PR11MB5276.namprd11.prod.outlook.com (2603:10b6:408:135::18)
 by MN2PR11MB4477.namprd11.prod.outlook.com (2603:10b6:208:17a::29) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5353.14; Tue, 21 Jun
 2022 03:46:38 +0000
Received: from BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::8435:5a99:1e28:b38c]) by BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::8435:5a99:1e28:b38c%2]) with mapi id 15.20.5353.022; Tue, 21 Jun 2022
 03:46:38 +0000
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
Thread-Index: AQHYhH7LXPufoGLZlE+CLUNrmpMHyq1ZKuMwgAANHACAAADskA==
Date:   Tue, 21 Jun 2022 03:46:38 +0000
Message-ID: <BN9PR11MB527671B3B4C1F786E40D67408CB39@BN9PR11MB5276.namprd11.prod.outlook.com>
References: <20220620081729.4610-1-baolu.lu@linux.intel.com>
 <BN9PR11MB52764F60972DF52EEF945D408CB39@BN9PR11MB5276.namprd11.prod.outlook.com>
 <5d13cab5-1f0a-51c7-78a3-fb5d3d793ab1@linux.intel.com>
In-Reply-To: <5d13cab5-1f0a-51c7-78a3-fb5d3d793ab1@linux.intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 6b1a3918-478d-466a-7f1a-08da5338a530
x-ms-traffictypediagnostic: MN2PR11MB4477:EE_
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-microsoft-antispam-prvs: <MN2PR11MB44775C4A89D4B4855AF5835A8CB39@MN2PR11MB4477.namprd11.prod.outlook.com>
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: Wn5X8JPHJaxgV+eJ8J/iipFSWbQtIkqJNJBu0W1ExDS8W+rLrrs999rT5waqFI8sDUp7gVGFgbhDxnKs+sALL0QCyhS1B+tHTyswZY9RIXvg4FX3IfOwah5/xEHBHQmycpTElzNQZTuufTbtifxnZd1iLR6C+PEti2Kny+nlJO1jTLgnEOHSpiVXHr2Qv88wrDvr6u9RwqnZZoFv0fSug4ZrJXSfZr7DXfOL0rg75EJmuhV48/p/PrUsuI03RTawDSHHHk4fVV5dy/WuknN/XKzg1W83lMQLvi1vOHTfev6hlQHoxnoaQUhoiul7Ojqm7vkpLLMMxj647I0wknFJs/pH4WOVukrylHf7OAdp/8H3xC8fbnaodgoFFrPNIJQ/2PjDs8J5/uYRzrI5E9vAHOApsPQWOm6fAlmHMEzZ8Pfa/ohmWRXbUbYWQQges/tvn0Ku9UVKR5bHFOLnduKDRskL2Y6wy0WHfJghtE3cVMHd5TJ1TDBSjt/4349RFeIZDSqHvKj7/ObW80+EHDUQ/2KekFUUs0KtlcVUEOTNC8LxbnNutXgQJX3xpkjNlL2iIO4b0LKdpSPlv+N2qK6T7c8t6gHo8IfW+6np5AK2wt3dhr2UlyOqBlLf2cnO086LwoDSjMffWQNi6tNhEn9TYwREgsKhZ5axfeX/WWOXbczMmDpxGinCXzzfTZN9OQX1PAR7z2WzNrZkvt1JnDtmhw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN9PR11MB5276.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(376002)(346002)(396003)(366004)(39860400002)(136003)(83380400001)(55016003)(66946007)(66446008)(76116006)(66556008)(38070700005)(66476007)(4326008)(110136005)(82960400001)(6636002)(186003)(8936002)(8676002)(54906003)(478600001)(64756008)(71200400001)(52536014)(38100700002)(316002)(41300700001)(6506007)(33656002)(5660300002)(26005)(53546011)(122000001)(9686003)(2906002)(7696005)(86362001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?NC9iampMUlhsZ3VKd3pEQlZoMlhrUFJISGZwTSttUm1CczBnVkRQaDUxVmM3?=
 =?utf-8?B?R1lmc2dRMnM4ZnNya0NzQlhGU1FLKzRTR2tqNENTN3JLVUhjU2QzMEJFQjEw?=
 =?utf-8?B?QkVvTExIQU5icDJLSkx2Y2ExVTBsQU51S1BIUFdyclY3dWVON0RwcEFXRmE0?=
 =?utf-8?B?ZUg2aGQ5WWpOUC9sWW9xN2hVVmlRbXJGRVdEREZDRVhOeU91TnovUGxuTFRW?=
 =?utf-8?B?bHJnb0N1UlR3d3JoVE54b2RJckRVcjNza2g0TUR5RVlLVTJsWG1pejhsRis5?=
 =?utf-8?B?NHZuY0ZONFIyak4vVThSMUJoSlkzZDZERWpDRmdXTDRZYlFJaktJeVdEd0ZC?=
 =?utf-8?B?anduQlJaMC9aMWVKSWt4M1VxTzlZa24zTE5Balo4aFh6aVV1T0VUMHRMWno5?=
 =?utf-8?B?Qm01V2o1YWJHaFFPdGlDYUE3V21aSlZUSloxOUFSMGpiTzQ1a0s0bHJWb1BQ?=
 =?utf-8?B?SjlNNGJ6bnRqcVZnZVlDM0JKMitjSHhsTkc0dHhQTnpnQldoZ0ZaWHFuaXE3?=
 =?utf-8?B?bGgyYU5Xdi9zMEh6cm5PRVNBNjdteEgxSjVwWGViQU11RnRkSE90ZUVFWkxS?=
 =?utf-8?B?ajRnc1J1cXhzZnZiSmo4elBORzRQOFJLZlB1enJ0NVpROEJYQ01tb1ZjcGZR?=
 =?utf-8?B?MTErMUFVZkRPT1IrcFlsVkJJSDVxL0F0QVBzeWlEQzNKUmJLbnRwYXN6emZV?=
 =?utf-8?B?d05Wb3l3cldTNGNKNmk3N05YellIVFdDbEhhMTZEVGNsenZZQjhZTEd5aHpj?=
 =?utf-8?B?S0dENVpOSk5ETkwyU01MUjFhR09TTThmUmJ0aUpHdUs3MUhGdmIxTGRWaHMx?=
 =?utf-8?B?VEJIWGRTampQbU9qSlBVbW8xMUZWWFFLWFdCWVhOZTY4SGptQ0xzTEZORFpy?=
 =?utf-8?B?akx3eTBJNTNNL1QrZnIyaXdoVzc3bkFUNkxOeDhTWnZhWFB6WXZaMjMydkNp?=
 =?utf-8?B?QXdoQ20wQ3hrd1RDUk1rbjhXQXdzVEx6a3JKdldzSUtvdVZCdnQ3UytqdjVq?=
 =?utf-8?B?b2tvSGxqeCtxQTJNT3ppdFBrdTFiMXB4K2ZLU2NrNE9wUDRYV2p5Q2pVSFRy?=
 =?utf-8?B?WmZTTGFaTm1lMHI5VkVNdUtxZThvY3BKdmJaMUdzbFRiMEx0OEJXTWlUdFFK?=
 =?utf-8?B?YXl1cEs2eUxVNEZkdkRaZjM3RVhVMUZrdU5YUjFwZFdLVEZDSVZkV0VEcXo0?=
 =?utf-8?B?QTJGOVZxdUh3aWNFM1pIY0lBNFZUVVFhSGR0Rm1SSDB3YUIrWnNTZ3dyeGxU?=
 =?utf-8?B?L0VMU3JXdldacTlmZ3ZTVE9wbjhBYXd4RFUwYUpVdVhWYmUzRnJxUzNIZE1w?=
 =?utf-8?B?UWh0ZlhkNWh6TzNaY0thc3hKSjBQTGJoalRZcEFZOWs4STNxcVhDMlpVQ05S?=
 =?utf-8?B?cW01MnFSWHRkMjdkM2pSd3VaUUQxVzliUUE3b25xZjZxekpLNnByalRJNTRF?=
 =?utf-8?B?cFlwd21XN28ybCt5bXJNQURxZk9YRTY1RmovS3orMVVVdXdWYzFrTUJYbEVa?=
 =?utf-8?B?ZUJnK0w1bk9GM1JzNEZ2QXF0NW9HOWJTMWxVMFduU0RFdDZSMWVJWTVxWnBk?=
 =?utf-8?B?eWowNXU1VDhNejZaK3NUTC9ab29oTUtTYzBsbE1JSk1JL012UXExUXdlUElX?=
 =?utf-8?B?aXNHTyt2MUVsM2cvK3laMWpXa2szYjB3eUNDd1dVWnhBVlBkR3FCMUxHZnNx?=
 =?utf-8?B?NUpKNEVaZEZJN0REZU50UHp2ZHdXS2dqY0Z5elhQV3ovKzcrM3k0U1c5MDFZ?=
 =?utf-8?B?ZWo0eHBiQzlRdENaa2VmcmFKcFMrNjJETTZRYWJzbVg1N29IZmpMYXRFYUgy?=
 =?utf-8?B?ajBqbERvMVdacGtEWkFBVGw1RFZucmhQNW52VmdxM3VIbzgzeWtCaFFiSUI4?=
 =?utf-8?B?Ujg3YnBRNVRCMDJQNHpxR0F1WUplOFo5cXFjYnlaVFM3K095aUhQLzRQdHpi?=
 =?utf-8?B?SXRUTzAwR1J0NVdWK25ZalRQQTRHMW5YMXdLazFSMm5xc3pFUllzS1lWN20y?=
 =?utf-8?B?QlowWmd4eDh2ckhYRnE2UE1EQlpUR2VVY3E1R2l6enB2bjlRdGhnRVM3OHFP?=
 =?utf-8?B?TFByNHh1eHdTQjBIOEZoRElRQzRuODZTOXVSTjd4cG9tbmZ6cWhNZEVIMEFZ?=
 =?utf-8?B?clp0ZFd6RlczT3d5UUZuSTUyWDZsNTNqNEVqcnkxWmxkZ2lWWGllUUEyekNv?=
 =?utf-8?B?LzhzdS9RQzBMSWJLOGNiWko2RElXRFpVMUhHRHpWVzJpaEh4bHN6c1QyQnpV?=
 =?utf-8?B?MGYvcmx6TFJ0U0VwT1NodUhXaXJIWmV0R1B4bVpDNTFlQ01qMXFoUmZmUDI5?=
 =?utf-8?B?VlorejhXTUxkc0VNMWpCZTFtbFlNS0ZwdENtOXltMW9ZckRxdjIzdz09?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN9PR11MB5276.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6b1a3918-478d-466a-7f1a-08da5338a530
X-MS-Exchange-CrossTenant-originalarrivaltime: 21 Jun 2022 03:46:38.0726
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: DsKObKKdTEprQp1g0VL6sRD13DyaMm89JxwzphyvTAjoC1F51ECNTDkylmU+YGiS77gRNrMy3LgzfDUk7An80Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR11MB4477
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-5.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

PiBGcm9tOiBCYW9sdSBMdSA8YmFvbHUubHVAbGludXguaW50ZWwuY29tPg0KPiBTZW50OiBUdWVz
ZGF5LCBKdW5lIDIxLCAyMDIyIDExOjM5IEFNDQo+IA0KPiBPbiAyMDIyLzYvMjEgMTA6NTQsIFRp
YW4sIEtldmluIHdyb3RlOg0KPiA+PiBGcm9tOiBMdSBCYW9sdSA8YmFvbHUubHVAbGludXguaW50
ZWwuY29tPg0KPiA+PiBTZW50OiBNb25kYXksIEp1bmUgMjAsIDIwMjIgNDoxNyBQTQ0KPiA+PiBA
QCAtMjU2NCw3ICsyNTY0LDcgQEAgc3RhdGljIGludCBkb21haW5fYWRkX2Rldl9pbmZvKHN0cnVj
dA0KPiA+PiBkbWFyX2RvbWFpbiAqZG9tYWluLCBzdHJ1Y3QgZGV2aWNlICpkZXYpDQo+ID4+ICAg
CQkJcmV0ID0gaW50ZWxfcGFzaWRfc2V0dXBfc2Vjb25kX2xldmVsKGlvbW11LA0KPiA+PiBkb21h
aW4sDQo+ID4+ICAgCQkJCQlkZXYsIFBBU0lEX1JJRDJQQVNJRCk7DQo+ID4+ICAgCQlzcGluX3Vu
bG9ja19pcnFyZXN0b3JlKCZpb21tdS0+bG9jaywgZmxhZ3MpOw0KPiA+PiAtCQlpZiAocmV0KSB7
DQo+ID4+ICsJCWlmIChyZXQgJiYgcmV0ICE9IC1FQlVTWSkgew0KPiA+PiAgIAkJCWRldl9lcnIo
ZGV2LCAiU2V0dXAgUklEMlBBU0lEIGZhaWxlZFxuIik7DQo+ID4+ICAgCQkJZG1hcl9yZW1vdmVf
b25lX2Rldl9pbmZvKGRldik7DQo+ID4+ICAgCQkJcmV0dXJuIHJldDsNCj4gPj4gLS0NCj4gPj4g
Mi4yNS4xDQo+ID4NCj4gPiBJdCdzIGNsZWFuZXIgdG8gYXZvaWQgdGhpcyBlcnJvciBhdCB0aGUg
Zmlyc3QgcGxhY2UsIGkuZS4gb25seSBkbyB0aGUNCj4gPiBzZXR1cCB3aGVuIHRoZSBmaXJzdCBk
ZXZpY2UgaXMgYXR0YWNoZWQgdG8gdGhlIHBhc2lkIHRhYmxlLg0KPiANCj4gVGhlIGxvZ2ljIHRo
YXQgaWRlbnRpZmllcyB0aGUgZmlyc3QgZGV2aWNlIG1pZ2h0IGludHJvZHVjZSBhZGRpdGlvbmFs
DQo+IHVubmVjZXNzYXJ5IGNvbXBsZXhpdHkuIERldmljZXMgdGhhdCBzaGFyZSBhIHBhc2lkIHRh
YmxlIGFyZSByYXJlLiBJDQo+IGV2ZW4gcHJlZmVyIHRvIGdpdmUgdXAgc2hhcmluZyB0YWJsZXMg
c28gdGhhdCB0aGUgY29kZSBjYW4gYmUNCj4gc2ltcGxlci46LSkNCj4gDQoNCkl0J3Mgbm90IHRo
YXQgY29tcGxleCBpZiB5b3Ugc2ltcGx5IG1vdmUgZGV2aWNlX2F0dGFjaF9wYXNpZF90YWJsZSgp
DQpvdXQgb2YgaW50ZWxfcGFzaWRfYWxsb2NfdGFibGUoKS4gVGhlbiBkbyB0aGUgc2V0dXAgaWYN
Cmxpc3RfZW1wdHkoJnBhc2lkX3RhYmxlLT5kZXYpIGFuZCB0aGVuIGF0dGFjaCBkZXZpY2UgdG8g
dGhlDQpwYXNpZCB0YWJsZSBpbiBkb21haW5fYWRkX2Rldl9pbmZvKCkuDQo=
