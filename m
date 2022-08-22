Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3201759B881
	for <lists+stable@lfdr.de>; Mon, 22 Aug 2022 06:42:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230027AbiHVEmy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 22 Aug 2022 00:42:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58276 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229562AbiHVEmx (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 22 Aug 2022 00:42:53 -0400
Received: from mga12.intel.com (mga12.intel.com [192.55.52.136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7B0081D0E0;
        Sun, 21 Aug 2022 21:42:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1661143371; x=1692679371;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=WAKfkVUSHq48Per9phkAjMzaLvAbxpRtn2BYdk74ClE=;
  b=fI4MaCbkXZzN96QvsgvOtqQJ9t9WplZsLC4Sk1Yjj26YGnK1YBQFk9dd
   99FHfcQuTZYQw8leA4I5HrqpRht5oj5k9aGLyeVqdeYnUp7AA4Swngfiz
   +h/9mWog0n1UIjnZ3WVpNkYtjBBNjtzBAdLjC6ibkPdXm4FMmdkRHCfY4
   ABT3O9zwCMT5+UobDclNsdya3CWOtU0StGfPpVoz+s2iHu/kECtqNpK7F
   sSsIYjM0v5VE5Co5YDeT6cdcZe4cCIwoc3On6lgMZGpbFFugYKazrw/h9
   2m3NFFMhLuu+SqRcvtReKfR0CrIYS+THBGh8uGzSxSzrPm2bvqluc+nzh
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10446"; a="273074667"
X-IronPort-AV: E=Sophos;i="5.93,254,1654585200"; 
   d="scan'208";a="273074667"
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Aug 2022 21:42:51 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.93,254,1654585200"; 
   d="scan'208";a="677071641"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by fmsmga004.fm.intel.com with ESMTP; 21 Aug 2022 21:42:50 -0700
Received: from orsmsx607.amr.corp.intel.com (10.22.229.20) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Sun, 21 Aug 2022 21:42:49 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx607.amr.corp.intel.com (10.22.229.20) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31 via Frontend Transport; Sun, 21 Aug 2022 21:42:49 -0700
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (104.47.58.107)
 by edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2375.28; Sun, 21 Aug 2022 21:42:49 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Qu6Q8s95vX76a3vq6v5QRuuJYwt3t9ZYkolkVsCWBmNpXaQoBj8Zral6rhpC3PiK4KDvxrARCOP/5aIrP0VgURttOMt3juzQKXnEquhDy9CKtiFKMIvRF0H6T/QBSBa0bgqp+q3gk+oCfrpMG8uKzeUiJPiMqNEfradRbe/Nfap2WGLPdYyHPzWuihP26LuZWPtZw8+UhJqWyJExN/p/1cbMyN4/z/qHXnJBTlKL3Iu52vViBwYJsjTvoiHX7H/NY907tT0/akCg467/+kE00h0uq0F3LOcB7wGoORj8KZ8w5XQ8Tiqnw98gRsAopUjZEBHIMnExy+OEyxmBAXypZQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=WAKfkVUSHq48Per9phkAjMzaLvAbxpRtn2BYdk74ClE=;
 b=WFK8rb4+XW3Poz+WCnJSldUTJIju7LVZpfk/+74VZU9MSVMlsEPbNyIV4f48jvUBJbsfHrrUmFj0ojca5N/zbsq2RyvRbPP7ymmUpiaVx0UfHCoEtQWU22wyoPYMECgDqWKohto9ZZh7vTS1AdyCXLNYFtAZC1Wf8qZbz3LmwoovP+8KBtP7YMQAlNx0oRXYUAEb3jgtN3qqVVu75vCvtJjGQ1yrqhxeQnYeTlAzrRwq8BX3UWtnm8+zDIEMpr8WaYH1iJ0KURxqtN5q3jkAlJhEe8AkQZ2Hzqs7SPxAOU2jT0BhT6ukq3S58+ZfdlveZ27ija05yMyE86xVEs9/0A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BN9PR11MB5276.namprd11.prod.outlook.com (2603:10b6:408:135::18)
 by SJ1PR11MB6201.namprd11.prod.outlook.com (2603:10b6:a03:45c::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5546.22; Mon, 22 Aug
 2022 04:42:47 +0000
Received: from BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::301a:151:bce8:29ac]) by BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::301a:151:bce8:29ac%3]) with mapi id 15.20.5546.022; Mon, 22 Aug 2022
 04:42:47 +0000
From:   "Tian, Kevin" <kevin.tian@intel.com>
To:     Baolu Lu <baolu.lu@linux.intel.com>,
        "iommu@lists.linux.dev" <iommu@lists.linux.dev>
CC:     Joerg Roedel <joro@8bytes.org>, Will Deacon <will@kernel.org>,
        "Robin Murphy" <robin.murphy@arm.com>,
        Jerry Snitselaar <jsnitsel@redhat.com>,
        "Jin, Wen" <wen.jin@intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: RE: [PATCH v2 1/1] iommu/vt-d: Fix kdump kernels boot failure with
 scalable mode
Thread-Topic: [PATCH v2 1/1] iommu/vt-d: Fix kdump kernels boot failure with
 scalable mode
Thread-Index: AQHYsdbqBbnHsu3lH0ihB+4y7/1Txa20VRHggAAuRICABdt7gA==
Date:   Mon, 22 Aug 2022 04:42:47 +0000
Message-ID: <BN9PR11MB52763F4F7641AEA6D942E88A8C719@BN9PR11MB5276.namprd11.prod.outlook.com>
References: <20220817011035.3250131-1-baolu.lu@linux.intel.com>
 <BN9PR11MB5276364739832848F15932B68C6D9@BN9PR11MB5276.namprd11.prod.outlook.com>
 <11e8ceac-97a5-c8ea-73c3-760929bca263@linux.intel.com>
In-Reply-To: <11e8ceac-97a5-c8ea-73c3-760929bca263@linux.intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 7f8a951f-0576-44c9-d8ff-08da83f8c347
x-ms-traffictypediagnostic: SJ1PR11MB6201:EE_
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 7FlvXN0yGiT5ej9AZvmOYlwK3cIACX0biuF7AqT2rZU32ig295OdN9RgkR1wMnIl+QBp+IfaJz+p5eL7oKFxymq1dptI85YQj4ukhj+bOki9DR1IfKlJlJ4gU8b7CQiJThc5IQujyQmmKNJjDEUcXzLBaeFQEKCoPTKRTrA0bqTCYWcsTrJwF7CDY6WZ2l37ZpLv0WHkL0NRW/Dwp8NDe8/TEQ6cfuEEY9Rc7vI+PfVLw5lI1hH0BocpQkxRQasv2n60gDBxrjFiFOMjh6YPspu3XqEl1UIEYH6pTfas81iZjg0vY2ELpDHHKV6/8G1qxog0O3XWXmH2eIb1R+iQBa1yD2b2rqn93Fy4THZrFsdwheI8SNO+4yQJeahvvvr+sRWCfK+bnDkXknMDIihH+RLVat3DiwT61+P2kGnVJjrzaB0xZnrw/vwp+p4sWZlbQDCjLf77+OB3fPO/eum8B+rm38A0v3CxMWwft0ViVL9iAHB2VXp6PdCP7to1pm6oxo1sK0IPz6/vsGZrPo8u2opKjHOfYqQgntKp1ETruoQwk3fuODUUw6DCHui4IU6+tTgqJgq/aIbWThjFNTc8ngEqur9aPJsA2IRju+NDPAtDBXBOS24vu8ij04CFXZ5uNmkohYkIngCVd/Yu3BP9jRsj9wgHPCd21Re51l45GF9qY8zG+0rPiM4jLzkwSn1/2b+I50uxXq9clLwOcaTRFbIbAwHjPSaebrBIR2C0Gri3WQKAAZC9KKuyIbTlkVy35BihdTZlZ1bIyz4heB2so5q+RBmW9Gepw3WVesC/hNM=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN9PR11MB5276.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(39860400002)(346002)(396003)(366004)(376002)(136003)(86362001)(82960400001)(83380400001)(122000001)(38070700005)(38100700002)(110136005)(316002)(54906003)(8936002)(5660300002)(52536014)(76116006)(66946007)(66556008)(66446008)(66476007)(64756008)(8676002)(4326008)(2906002)(186003)(55016003)(41300700001)(71200400001)(478600001)(9686003)(6506007)(7696005)(26005)(33656002)(309714004);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?NjB1bk1RU3NWTkdzaDFlSG1TVDhDd3NocWlCQnRCUjc1aWl6UHU4MDNrK3pw?=
 =?utf-8?B?Z1VVMEJqaHpUWEFqMmNrRkxHL2tqR0EzaDhDVHpmOEMwYnRVcWNVbENObXhY?=
 =?utf-8?B?Rmh3bFVjUzgrSXBFaDZrNTF5Umo5VEh0WmUvb0NuWldxd2FicUJKMnhwdDJM?=
 =?utf-8?B?UldhZytKOWUrL25ULzdGaFRKMlR3NnpDdEMxanEwNXNYcmdZOUFnOHBnMVV5?=
 =?utf-8?B?VzhEbWUxYS9LcE00bU1PS2NRdTFraktiUW1HblFpRG1XcUN6YU9IVmNWazla?=
 =?utf-8?B?VlBNSnNpWGZraUtjUnRRRXFkWk9RYXhTZjIzNmpHYW1sOGFCNWM1QklBVVlP?=
 =?utf-8?B?OGZvM3pWcjlHREx2QW52SU4vSGRrN0NJeVpxeEZHN2FVRWVmUVdya0F1blZk?=
 =?utf-8?B?dU1HeGNreUh1eWRZSXlBdUJJM3loN0diZEhqZUpIYzdUQ3FuTHhQWFZhS21t?=
 =?utf-8?B?WDh2a1hqS2w4dUdVRHVSNTdYVWl3SkRzNTBsVUxLcnl0MlhYUEVSTDZvMHpP?=
 =?utf-8?B?NjJwZ0N2eWhKaUNhZVNiOGwrRk9TQlhsOURFYmhpdVhYTE05anFHZWVSZ1pP?=
 =?utf-8?B?dVJBV2hUdm5JMG1aeTB6RExpNW1FL0l1K0VzZDlyd3hsRHlFb0xMR0JKd2ZZ?=
 =?utf-8?B?cWlrTGFtL2ZkanBlWVIxOHFDNklCWFoySTFUNzJFdlQvYzY5emVaeXViZzRX?=
 =?utf-8?B?MjFLeFRRZUxXaVdSMmtlVkZuaWFNNTJaTzdGcDdHaTExUkM4L3JEcEFKTkIw?=
 =?utf-8?B?VXN5QnZUZmRrcUtDVHJsMzRUSTBLbGtFdW9jZnBUdFFZSUwyL3JZZXVlQnpx?=
 =?utf-8?B?NDBYWExmS1NmaGxjRmpEcXdpUmRuV0ZZVVFKUmV2T1hGU1pHUHlNWjNKTUx0?=
 =?utf-8?B?elhhbGdSbzhkM2RtVG1YcS84aW8wYVF3ZmhhM1I2ODNaZThTM3V6cThoZFlK?=
 =?utf-8?B?QXpEVCtZbHpDb1JGa0ZmbDhselR6T1RWbWN1VFFBUktHUnNIUTRxZGpubHRC?=
 =?utf-8?B?U09TZUJ3YWcvVjNuUnNrb082Q09mVHdBYmx2MisvL1RSTkZDdHd4WXg4Skhl?=
 =?utf-8?B?d01PcVZhamNGQUR0WW9wRkh1cXdOa2lxQnVtdi9tYnNsd2lzc3VSQlE1WTJq?=
 =?utf-8?B?M0NEQURhRU1MSWpQZTNwUTMvTmFVQk16U1o4Y2NITkFIZGZhM0h1UWR2UGln?=
 =?utf-8?B?L3hGUzlkRWw2T3ZXbjNPdmd1VXB4ZG53ZUR1MytvUklCYjhjeU82N2xvTHJK?=
 =?utf-8?B?MllIT2N0YTQ0SFNwV3VnNzlQSlF5ajJxMEJ1d1dFQWVzZVdSNGVEdmtBaHJ1?=
 =?utf-8?B?YlVpTXFWVXlGR2t3NnJUUzl3SjZVR1IrMlRlZUt5VFZwaVlXaktkbVEwSTFn?=
 =?utf-8?B?R3Y1cmhLRUhiRFRBRHpldkVSRU5iQWNlaTlpSDdwRVIxaldsanFnREd2S0tn?=
 =?utf-8?B?c2NmTHRoNWJHSEUrRHNZY1ZYVWswZG96TnNib2YraE95NUhiK2lqV1ZPbjEr?=
 =?utf-8?B?V1RFWTVUSTBRTkl3anBYN3B0SUEwM0ZmUTFXVGVDK2NJQzE5OElDT0JxM0U3?=
 =?utf-8?B?Z0Noa0pabk82cjJyeHN5ZTJCVmt0NXc2YVc0bjZqTHlKRldpUlRtSEJ0bW5Y?=
 =?utf-8?B?b1FCMlQ2eWxNQ3NjUW4rVC9zYUo0eWNIY3JRNThuVUhONVlJSkVzeFpXNi9L?=
 =?utf-8?B?bVhxVisyKyswSDJjMEhBbFk1dy92MURBZ3FleVZnRitsSGd6SDROeVIxcmZt?=
 =?utf-8?B?RE5SWHEvY2ZSU2IvWHZ0Rm01LzJjSStTQjVJVkVJTzlDSEpad01teFB5ZEQr?=
 =?utf-8?B?U2Y2OEYwaThjTnRoa1orSmF0QmF1d21rU3NGRzlIVDcxV085b1Yybk5SbERH?=
 =?utf-8?B?NjFVczA4d1dPNEhaQ1ZkZW9OT0FSTzFDSEtzMEg3Ui9wd3BWNld6djhqNXdh?=
 =?utf-8?B?ck44QU5rYlo5bUJIVkRRb1l6ZTh1a1lyV2o3OVdkNHpBb1FtUGcrN2l0RlQv?=
 =?utf-8?B?S3VjazcyYzJCbVM5VzFBNy9HeThOSmNkV0tqaXdCMnZHNy80YjlpdHNCM2Uw?=
 =?utf-8?B?SEk0aCtuMisxaWtXYWlMVHo2ZkhVbTdnT1poeCtWOFF5cnBvOGNJWFJwUytj?=
 =?utf-8?Q?Okxb+/dbfRp+/aBXx5z6iEggZ?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN9PR11MB5276.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7f8a951f-0576-44c9-d8ff-08da83f8c347
X-MS-Exchange-CrossTenant-originalarrivaltime: 22 Aug 2022 04:42:47.7115
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: OLkLJAGUvufKBxhdzTM2uvIgb/JWvZco0IRUGwxFYoNABpDiHZXc2v590sQgEKA9QInPO5WdUnxOP5dMQtUUEA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ1PR11MB6201
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

PiBGcm9tOiBCYW9sdSBMdSA8YmFvbHUubHVAbGludXguaW50ZWwuY29tPg0KPiBTZW50OiBUaHVy
c2RheSwgQXVndXN0IDE4LCAyMDIyIDc6MTMgUE0NCj4gPj4gICAJcnRhZGRyX3JlZyA9IGRtYXJf
cmVhZHEoaW9tbXUtPnJlZyArIERNQVJfUlRBRERSX1JFRyk7DQo+ID4+IC0JZXh0ICAgICAgICA9
ICEhKHJ0YWRkcl9yZWcgJiBETUFfUlRBRERSX1JUVCk7DQo+ID4+IC0JbmV3X2V4dCAgICA9ICEh
ZWNhcF9lY3MoaW9tbXUtPmVjYXApOw0KPiA+PiArCWV4dCAgICAgICAgPSAhIShydGFkZHJfcmVn
ICYgRE1BX1JUQUREUl9TTVQpOw0KPiA+PiArCW5ld19leHQgICAgPSAhIWVjYXBfc210cyhpb21t
dS0+ZWNhcCk7DQo+ID4NCj4gPiBzaG91bGQgYmUgISFzbV9zdXBwb3J0ZWQoKQ0KPiANCj4gTm90
IHJlYWxseS4gVGhlIElPTU1VIHdhcyBzZXR1cCBieSB0aGUgcHJldmlvdXMga2VybmVsLiBIZXJl
IHdlIGp1c3QNCj4gY2hlY2sgd2hldGhlciB0aGUgc2NhbGFibGUgbW9kZSB3YXMgZW5hYmxlZCB0
aGVyZS4NCg0KWW91IHdhbnQgdG8gY29tcGFyZSB3aGV0aGVyIG9sZCBrZXJuZWwgYW5kIG5ldyBr
ZXJuZWwgZW5hYmxlDQp0aGUgc2FtZSBtb2RlLiBlY2FwX3NtdHMgaXMgb25seSBhYm91dCB0aGUg
Y2FwYWJpbGl0eS4gb25seSANCnNtX3N1cHBvcnRlZCgpIGNhbiB0ZWxsIHRoZSBtb2RlIHdoaWNo
IGlzIGFjdHVhbGx5IHVzZWQgYnkgdGhlDQpuZXcga2VybmVsLg0KDQo+IA0KPiA+DQo+ID4+DQo+
ID4+ICAgCS8qDQo+ID4+ICAgCSAqIFRoZSBSVFQgYml0IGNhbiBvbmx5IGJlIGNoYW5nZWQgd2hl
biB0cmFuc2xhdGlvbiBpcyBkaXNhYmxlZCwNCj4gPj4gQEAgLTI3NDcsNiArMjcwNSwxMCBAQCBz
dGF0aWMgaW50IGNvcHlfdHJhbnNsYXRpb25fdGFibGVzKHN0cnVjdA0KPiA+PiBpbnRlbF9pb21t
dSAqaW9tbXUpDQo+ID4+ICAgCWlmIChuZXdfZXh0ICE9IGV4dCkNCj4gPj4gICAJCXJldHVybiAt
RUlOVkFMOw0KPiA+Pg0KPiA+PiArCWlvbW11LT5jb3BpZWRfdGFibGVzID0gYml0bWFwX3phbGxv
YyhCSVRfVUxMKDE2KSwgR0ZQX0tFUk5FTCk7DQo+ID4+ICsJaWYgKCFpb21tdS0+Y29waWVkX3Rh
YmxlcykNCj4gPj4gKwkJcmV0dXJuIC1FTk9NRU07DQo+ID4+ICsNCj4gPj4gICAJb2xkX3J0X3Bo
eXMgPSBydGFkZHJfcmVnICYgVlREX1BBR0VfTUFTSzsNCj4gPj4gICAJaWYgKCFvbGRfcnRfcGh5
cykNCj4gPj4gICAJCXJldHVybiAtRUlOVkFMOw0KPiA+DQo+ID4gT3V0IG9mIGN1cmlvc2l0eS4g
V2hhdCBpcyB0aGUgcmF0aW9uYWxlIHRoYXQgd2UgY29weSByb290IHRhYmxlIGFuZA0KPiA+IGNv
bnRleHQgdGFibGVzIGJ1dCBub3QgcGFzaWQgdGFibGVzPw0KPiANCj4gV2Ugb25seSBjb3B5IHRo
ZSBjb250ZXh0IHRhYmxlIGFuZCByZWNvbnN0cnVjdCBpdCB3aGVuIHRoZSBkZWZhdWx0DQo+IGRv
bWFpbiBpcyBhdHRhY2hlZC4gQmVmb3JlIHRoYXQsIHRoZXJlJ3Mgbm8gbmVlZCB0byByZWNvbnN0
cnVjdCB0aGUNCj4gcGFzaWQgdGFibGUsIGhlbmNlIGl0J3Mgc2FmZSB0byB1c2UgdGhlIHByZXZp
b3VzIHBhc2lkIHRhYmxlcy4NCj4gDQoNCkkgc3RpbGwgZGlkbid0IGdldCB3aHkgY29udGV4dCB0
YWJsZSBtdXN0IGJlIHJlY29uc3RydWN0ZWQgYnV0IG5vdA0KcGFzaWQgdGFibGUuLi4NCg==
