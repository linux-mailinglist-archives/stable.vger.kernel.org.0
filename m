Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A5CE153AFE9
	for <lists+stable@lfdr.de>; Thu,  2 Jun 2022 00:51:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231339AbiFAVTZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 1 Jun 2022 17:19:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53982 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231448AbiFAVTW (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 1 Jun 2022 17:19:22 -0400
Received: from mga17.intel.com (mga17.intel.com [192.55.52.151])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 315A4A7742
        for <stable@vger.kernel.org>; Wed,  1 Jun 2022 14:19:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1654118359; x=1685654359;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=YQAEBUnYI74sQRndLeDNWzmlCiT++aGKosiGya+YB4E=;
  b=DUQ3fxa/KeeveJFPkCG4MsnWlIvikSTJlu1q2rDKCt53Uux2iaJVbZoW
   TRIMwr2DZLhGj/feMJ+9iu9lNDltQRh/TcjqL5nFMVE8pdmYCpUGCaySo
   AciO0CcOjEtSB0HsS+FZiKP6kD6RUryg3HCh2ty+higQm/9BuDb/nHWJD
   iGzltpnv2fCcAJb6YVyfBr6Nm/2e2dxGIz9Ub6jBsda+tWTTG/EKhAX7G
   S4tfI9Sst7GcOfA0kQxn4UbWUrEIm2Q/lNcp1c3itIvaVv/BPOn/UoG/X
   rBHH2EE59RDRgwjKouQHdFKVVDY+G4Ez9V+e0HDcswwsR03ahNPODljYE
   A==;
X-IronPort-AV: E=McAfee;i="6400,9594,10365"; a="256194096"
X-IronPort-AV: E=Sophos;i="5.91,269,1647327600"; 
   d="scan'208";a="256194096"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Jun 2022 13:13:50 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.91,269,1647327600"; 
   d="scan'208";a="552480352"
Received: from orsmsx606.amr.corp.intel.com ([10.22.229.19])
  by orsmga006.jf.intel.com with ESMTP; 01 Jun 2022 13:13:49 -0700
Received: from orsmsx608.amr.corp.intel.com (10.22.229.21) by
 ORSMSX606.amr.corp.intel.com (10.22.229.19) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.27; Wed, 1 Jun 2022 13:13:49 -0700
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx608.amr.corp.intel.com (10.22.229.21) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.27 via Frontend Transport; Wed, 1 Jun 2022 13:13:49 -0700
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (104.47.55.172)
 by edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2308.27; Wed, 1 Jun 2022 13:13:48 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=JPnZYbVpbicxcbBAwHjHSndIEDqnTz9TM4E1r3EeeuUj3DXAE0v2CiUX2L5oAaHLpoZCD+sECTIAX74KJ40eHrGIcWz4cZM5hRyxkfOgqgJmnf5yscq4udzf+cgxBpt72EH+dqishL2ew9beyvegs3BA1QjW+3VZdBR8RB5ayP9b9d1IXM3ciMlqidCFwpnCXWfFQraK529crAheJFBORU9f7pgIX7Of8YCvMruthCYxy/dVBSdVj2e1m5E8WfqwdVhmw2K3GPrBqLWC7P2A1Ca5muXaBm2mVnxa5uKLbwsNM8W8jYhgtfGvGCuvgNMFyRBS0ZGOsvPo9hqQztKBdg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=YQAEBUnYI74sQRndLeDNWzmlCiT++aGKosiGya+YB4E=;
 b=ihSi1Po4Z02gnLvr39M81w6pWtQvL+h+N9UP+v+uI+Wxii4BYo15kV20jTFcTSCqB0M6GftBCk8LrgnKZmAps0UXCMtxUOXf96/OHddqZrWtpfncrnctCe7sjaY6FOHt3c538UQ7oWhXUKp3t9J+hWWBzrDAUhNEOS088c64DM6vSbeYKNY3yLmdrS6tP9kThQPKY7lmONCokqPp7VG7XxHfukv9xZTWozH9jiCgF5g+sC/59/pQ/g+WawkN1CRKSHhR9+XY/NYMgz2phzGEo2tuvzs3IRtqZxhaLbBJGaCLxMx/Wt4G2rTrOz8XYWlVpGTnet3hH6eh9JR00xURfw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from MN2PR11MB3999.namprd11.prod.outlook.com (2603:10b6:208:154::32)
 by DM4PR11MB5391.namprd11.prod.outlook.com (2603:10b6:5:396::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5314.12; Wed, 1 Jun
 2022 20:13:46 +0000
Received: from MN2PR11MB3999.namprd11.prod.outlook.com
 ([fe80::40ef:2d29:7d1a:21be]) by MN2PR11MB3999.namprd11.prod.outlook.com
 ([fe80::40ef:2d29:7d1a:21be%7]) with mapi id 15.20.5293.019; Wed, 1 Jun 2022
 20:13:46 +0000
From:   "Verma, Vishal L" <vishal.l.verma@intel.com>
To:     "Williams, Dan J" <dan.j.williams@intel.com>,
        "nvdimm@lists.linux.dev" <nvdimm@lists.linux.dev>
CC:     "stable@vger.kernel.org" <stable@vger.kernel.org>,
        "Ye, Chris" <chris.ye@intel.com>
Subject: Re: [PATCH] nvdimm: Fix badblocks clear off-by-one error
Thread-Topic: [PATCH] nvdimm: Fix badblocks clear off-by-one error
Thread-Index: AQHYdUv1QEXs47kzcEy7LW1ka73Dvq06/ZiA
Date:   Wed, 1 Jun 2022 20:13:46 +0000
Message-ID: <13af10d75e81206b2d70d9669685c373014ffaa9.camel@intel.com>
References: <165404219489.2445897.9792886413715690399.stgit@dwillia2-xfh>
In-Reply-To: <165404219489.2445897.9792886413715690399.stgit@dwillia2-xfh>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.44.1 (3.44.1-1.fc36) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: bd301a53-1105-46cd-03b7-08da440b3bdd
x-ms-traffictypediagnostic: DM4PR11MB5391:EE_
x-microsoft-antispam-prvs: <DM4PR11MB53913C611B2ECA1A57D7B075C7DF9@DM4PR11MB5391.namprd11.prod.outlook.com>
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 6ddYrj7iUi5gLNvmdAM8Jli/0GPkZmI8ft6UqEK0zLAeSY3XcWQRC7k8ShayZ5q5iuOi90y/kNeap2PFT9sk/lu8qu3qL7zdTUCDTmznN5b7Mno8kiol0GhLZ3CuQNqi3RMpcu1g9KH/5Ssd8+J6g58YR6XO6HuZCZeBjGrpFsLFzOKFvzkP/FB1kesv2Pm5HzbdOUGZ4qj9awcimQPcGaAQeeG+v0V9do+zNGcpJZ//9y3boJ6PUBWaHHdE7dWjhsW9JGEUKNBU4F0Qy7BDw9uwuIIhbptXwiruO5j82795WIGCa2nTo+pzQFE8+BFUy9lcL76/oxwgDSfmmAJVOH7h/Ht6lIDJuXPsnzNfVWmBLEfHIlHYDVse4N3TFDIdhnKdMViVzXLa3OPAY85yDLjGCfW7B2k0anrKBKG52CAGCPhmMAzlJi8E6SL8lgF7xgdirXByV21AIGsZnJNoWmjpDvXkChRfjBw6MTeB1PgsHBHoc75ErIeVZt75xr37hQbY1WPdCllhZUIuEGOjaKMOVcHSRn0bqfdpdwb/udqGULQvZ7lO1r+iyatX8+xXRWdY8UZnYitx10G/JsXH8ESwxZIfibuoP0xLkARcXCmggTcjawibS+KOtUaJ3YBd2bDtH8wig0o5Yv2dwo5UBF60Jotlcsw1hal9hlDGgdrrAGtYIqhNUus2H4lCy947Tgx1ZKejEZpcHy6iduYI0Q==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR11MB3999.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(86362001)(38070700005)(36756003)(2616005)(83380400001)(508600001)(2906002)(54906003)(110136005)(8936002)(316002)(38100700002)(82960400001)(5660300002)(6486002)(66476007)(66446008)(64756008)(6512007)(66556008)(6506007)(66946007)(26005)(71200400001)(122000001)(4326008)(8676002)(107886003)(76116006)(91956017)(186003);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?L3k2YzV3UkdzVVQ2RTBpUXJBdTBqTHBLOFlrbDhRemxHSkZmSDFGVk1McVFI?=
 =?utf-8?B?bXk2U1ZFSFkwc1FTVHIzQ1RjRFNHMTJCVUtaaStQcHJPZ0RnR2I1ZytzSkFr?=
 =?utf-8?B?MzBPYU94RVNGR3lOQzdOWDhYMkNpNmtOd0ltb2NZelpSb2pOamQzcjFzMlhV?=
 =?utf-8?B?TCtzQ1VEMVROLzRZSkdGK2JXNWs2OCtPNEJzTVd4eTdIeWFYZmZ6b09GNzFr?=
 =?utf-8?B?VUlBdndFZ2pCRnNueWo0QkdkbEdONzF3eVhSeGhoSEsvZHRXU2FQdndKL2ZJ?=
 =?utf-8?B?WkpNV1BrZjZNVnRHS09obCtPOVBzY1BlRWs1NTZGQWw3K2ZwL0ZxaXpPRnQx?=
 =?utf-8?B?NFkvQ2hEUFh4TERKb2lQS01CTkYzTEplRmUwdGNKeUtLV3J5NDh6VWVjOFFl?=
 =?utf-8?B?Zmo1ZE1pRWZiUEZjMmtXMzltbGErSWdnOWtGNjh1ZStjc2RLdHdvTzdFMkg0?=
 =?utf-8?B?bUFIQmphaWRDVUdOeGlHZ3VOb1BhOXFJK2tvM21HL2hNRE40bzFlTWo1K25T?=
 =?utf-8?B?UVJnd2lvLzViMTBFSzBxdGdidDJjQlRHMXY5eHUxTWNiRTl0VlVyWjFmcFVv?=
 =?utf-8?B?enRRM0c2akVtQXdCNStyb3dDOGZvRkwyMVJlWWprWlRKTFF6K3U1OVlJNDgv?=
 =?utf-8?B?U1NnM3EzV05nbnJnblhIT2FmeVFHdVZweHoxL2NYdG5OWmVSQ0xxYktmM0Fh?=
 =?utf-8?B?aTBuQnVMVlpueStPRnBuMk1PTzRRSDR6bCs1b2ZyYk5jck83MmdtdEJhOFMx?=
 =?utf-8?B?bm1wMnRwZnhic1RrWWJSdDNuVWs1YlkvVFFmU2pSZjF4Q3BnajJGcFlUVkJQ?=
 =?utf-8?B?VGZoRGZodWlCQllHRDlnMjJCSDd5WkI2b2RYWjZTMkdNVHBXajladFIwTXN6?=
 =?utf-8?B?OFo4UE9nVkFqQWpJaWNtMjJRcGJwcFJha1k0QjluVmZXTXVORDVoRCt3bDdQ?=
 =?utf-8?B?c3AzOHhmRXB0eFhUQ3hWV3E4Qm00bWtMNXNmQlJIdDIrL0VZeEJWOTBUMUNm?=
 =?utf-8?B?WTRhdWFaS3JUeFhvanM3bGtQZTg5eGVjYnJGNEJ1aTNLYVE3NmZ4ZGF2eWdQ?=
 =?utf-8?B?N2haKzBzOW1EL21xZzNDaWdySVNHeDRLNmhlWVY1SVRYcTFIaEY5blk5bjBr?=
 =?utf-8?B?bVYvWko4NVpzTmM3QUt1dHdGdVJlVnZKNGw2NFdqcmxOUm9nOWdGbitDcFFN?=
 =?utf-8?B?ZksweG9VNlFrbjlMZnl0RFhxRHQ5STBacmU0VmJyQW9scG94cE15OXBnYmxq?=
 =?utf-8?B?a1l4YldSTGV2RGRzRVVzc0NRa1RzUEV5SDdIZ2ZOamRDTnlOOTBQQ0J6RXdW?=
 =?utf-8?B?aWg3cWtWYTNieVVRU0tFSm5TSXRKMEJZQlo4NU5MREFxOHB4bmhvR1NLWDhY?=
 =?utf-8?B?Tm8ra3F0S0RVQUtRN2UxbXRvVFczcnJpRHV2anNMVmwxR0NpTTA3Y3hUU2po?=
 =?utf-8?B?VVBUeUgxclJOeWdjQnFCOFBFdXVhUFdueE81UnJaRGROaTMvd1VXUUQxd09t?=
 =?utf-8?B?S3RqNE5xcWs0NUk0YXIyWnk0LyszT3NKSGxLbm9mQkpKQVRQNmJvemg5UE15?=
 =?utf-8?B?a012TFJvL2QybHR6MTVwTmRpRE5JSk1QRmFOQXhJYTFxRG93QlY2eC8yUUVr?=
 =?utf-8?B?OFk5ZGpPVVZnd3dZY2YrVjVoQTB4VzlDcFhJV2dKeklUTEkvb05hdDRxTEtq?=
 =?utf-8?B?K0V5Tm5GQzRqMTVPSnRrSmIzSVUzSFhFd0NaVFFvazRTMjRUYjdmMmd3U0JF?=
 =?utf-8?B?S0xQQSs3U1NUM1VoUnFCbm52M0g3NllrUXVvRjlHRzFTbmpoZmtaRHRkZWVD?=
 =?utf-8?B?Y3I2Sm4rTnpyNFJpaDRWVUp6bkEweFJhZnVidlJDemduT2VKUDBWa1FKd2Ns?=
 =?utf-8?B?aGVOckh0Sit0Umw5ZlFjbFJGQkRRSEVRaGR6K0lXb2FvbmI4RVFiVEF4UXd6?=
 =?utf-8?B?VzNxalJ0NksvcDRVeHozbzFITFBVV3d6THc2ZzdjUVUyN0QzRHdyQnA5Ynho?=
 =?utf-8?B?K1JTVzA2ZzJyNlluSWRCenBrSGFQdG9RcjZwV0hOMVFYNGx5ckNkL05KMU9N?=
 =?utf-8?B?Kzg3SEFiM2V3OUN5TDZvaXJXT1ZrV3lZak5WT2lvOGZZQ0hVR29lU2dObWph?=
 =?utf-8?B?TVlVSjA5dnBQcDlNb3J3UzNoVHJzR3k0ZEgvQkxWZGF2a0YraFFCT2J0N0g1?=
 =?utf-8?B?UmVWNlZhY3ZXY0FITUN5YkptTXIwQmI1a0REY1FkQjJHOFJnNmlMcmJkU0VK?=
 =?utf-8?B?WEVvbWZSM0VvZTd0Y3UyNEZJcVFMMUJUdU1CWVArQkovQ1lKcWZ0M2dZTkNv?=
 =?utf-8?B?dkpRMVlYcVVjS3FXQWhaaHh1NmZPdDFlWHYzWUV0NU9TUTd3aUVqdzlrQXBq?=
 =?utf-8?Q?borAjCmvROGF/YgQ=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <3F462BE6E41A124793B8DA2E192A5851@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MN2PR11MB3999.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: bd301a53-1105-46cd-03b7-08da440b3bdd
X-MS-Exchange-CrossTenant-originalarrivaltime: 01 Jun 2022 20:13:46.5703
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: y6HvFh/VBrTJc6Lik9W4HlXn0376rbSbmycNNzfKL0GUm3+J5N04tzovhoNORNKg7ftvOE570IlrIZrSRSNeXN1w+0FoawOh/tNgAnPYG7A=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR11MB5391
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

T24gVHVlLCAyMDIyLTA1LTMxIGF0IDE3OjA5IC0wNzAwLCBEYW4gV2lsbGlhbXMgd3JvdGU6DQo+
IEZyb206IENocmlzIFllIDxjaHJpcy55ZUBpbnRlbC5jb20+DQo+IA0KPiBudmRpbW1fY2xlYXJf
YmFkYmxvY2tzX3JlZ2lvbigpIHZhbGlkYXRlcyBiYWRibG9jayBjbGVhcmluZyByZXF1ZXN0cw0K
PiBhZ2FpbnN0IHRoZSBzcGFuIG9mIHRoZSByZWdpb24sIGhvd2V2ZXIgaXQgY29tcGFyZXMgdGhl
IGluY2x1c2l2ZQ0KPiBiYWRibG9jayByZXF1ZXN0IHJhbmdlIHRvIHRoZSBleGNsdXNpdmUgcmVn
aW9uIHJhbmdlLiBGaXggdXAgdGhlDQo+IG9mZi1ieS1vbmUgZXJyb3IuDQo+IA0KPiBGaXhlczog
MjNmNDk4NDQ4MzYyICgibGlibnZkaW1tOiByZXdvcmsgcmVnaW9uIGJhZGJsb2NrcyBjbGVhcmlu
ZyIpDQo+IENjOiA8c3RhYmxlQHZnZXIua2VybmVsLm9yZz4NCj4gU2lnbmVkLW9mZi1ieTogQ2hy
aXMgWWUgPGNocmlzLnllQGludGVsLmNvbT4NCj4gU2lnbmVkLW9mZi1ieTogRGFuIFdpbGxpYW1z
IDxkYW4uai53aWxsaWFtc0BpbnRlbC5jb20+DQo+IC0tLQ0KPiDCoGRyaXZlcnMvbnZkaW1tL2J1
cy5jIHzCoMKgwqAgNCArKy0tDQo+IMKgMSBmaWxlIGNoYW5nZWQsIDIgaW5zZXJ0aW9ucygrKSwg
MiBkZWxldGlvbnMoLSkNCg0KR29vZCBmaW5kISBMb29rcyBnb29kIHRvIG1lLA0KDQpSZXZpZXdl
ZC1ieTogVmlzaGFsIFZlcm1hIDx2aXNoYWwubC52ZXJtYUBpbnRlbC5jb20+DQoNCj4gDQo+IGRp
ZmYgLS1naXQgYS9kcml2ZXJzL252ZGltbS9idXMuYyBiL2RyaXZlcnMvbnZkaW1tL2J1cy5jDQo+
IGluZGV4IDdiMGQxNDQzMjE3YS4uNWRiMTY4NTdiODBlIDEwMDY0NA0KPiAtLS0gYS9kcml2ZXJz
L252ZGltbS9idXMuYw0KPiArKysgYi9kcml2ZXJzL252ZGltbS9idXMuYw0KPiBAQCAtMTgyLDgg
KzE4Miw4IEBAIHN0YXRpYyBpbnQgbnZkaW1tX2NsZWFyX2JhZGJsb2Nrc19yZWdpb24oc3RydWN0
DQo+IGRldmljZSAqZGV2LCB2b2lkICpkYXRhKQ0KPiDCoMKgwqDCoMKgwqDCoMKgbmRyX2VuZCA9
IG5kX3JlZ2lvbi0+bmRyX3N0YXJ0ICsgbmRfcmVnaW9uLT5uZHJfc2l6ZSAtIDE7DQo+IMKgDQo+
IMKgwqDCoMKgwqDCoMKgwqAvKiBtYWtlIHN1cmUgd2UgYXJlIGluIHRoZSByZWdpb24gKi8NCj4g
LcKgwqDCoMKgwqDCoMKgaWYgKGN0eC0+cGh5cyA8IG5kX3JlZ2lvbi0+bmRyX3N0YXJ0DQo+IC3C
oMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgfHwgKGN0eC0+cGh5
cyArIGN0eC0+Y2xlYXJlZCkgPiBuZHJfZW5kKQ0KPiArwqDCoMKgwqDCoMKgwqBpZiAoY3R4LT5w
aHlzIDwgbmRfcmVnaW9uLT5uZHJfc3RhcnQgfHwNCj4gK8KgwqDCoMKgwqDCoMKgwqDCoMKgIChj
dHgtPnBoeXMgKyBjdHgtPmNsZWFyZWQgLSAxKSA+IG5kcl9lbmQpDQo+IMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgcmV0dXJuIDA7DQo+IMKgDQo+IMKgwqDCoMKgwqDCoMKgwqBzZWN0
b3IgPSAoY3R4LT5waHlzIC0gbmRfcmVnaW9uLT5uZHJfc3RhcnQpIC8gNTEyOw0KPiANCj4gDQoN
Cg==
