Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2686D61193F
	for <lists+stable@lfdr.de>; Fri, 28 Oct 2022 19:25:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229661AbiJ1RZh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 28 Oct 2022 13:25:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50820 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229501AbiJ1RZg (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 28 Oct 2022 13:25:36 -0400
Received: from mga07.intel.com (mga07.intel.com [134.134.136.100])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 862D9DCAF4;
        Fri, 28 Oct 2022 10:25:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1666977935; x=1698513935;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=zEr/pbJh6trTBpTugLid4DwGimmg1DO8WspiwhHe0WQ=;
  b=BTk7M6iD+d11D29PC6GhWrzpnh1walMNclX/tb7E6VQ8F/dcBmJ65MvX
   kpPa5KtngxuNo6ZqzxTjaszbDsFmSIqqu4wLVbVfvgt7W2vRdW9j/swa0
   8cQJwOrY4a1R1EHTD7k+n4L18KTLc9sdUUgoOuQlcbyN6rsberTqqlI+8
   cpH5MHcopSfEJBYMuCG+GSkFil8I39/qt7pnc8BwsbENTw4fE4UjgAwku
   AkcZmsaXUZ35TJeeN1iJNk2b4aKuCUIe9Ha/Fi4e5VmqyTcRFqDlpA6Fw
   A2uQO6sWh2F2lfdXMjSXEfHvqNw7lwg95ahFYcWjhygNaVQeSF8E785wm
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10514"; a="372756846"
X-IronPort-AV: E=Sophos;i="5.95,221,1661842800"; 
   d="scan'208";a="372756846"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Oct 2022 10:25:34 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10514"; a="775442242"
X-IronPort-AV: E=Sophos;i="5.95,221,1661842800"; 
   d="scan'208";a="775442242"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by fmsmga001.fm.intel.com with ESMTP; 28 Oct 2022 10:25:33 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Fri, 28 Oct 2022 10:25:33 -0700
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31 via Frontend Transport; Fri, 28 Oct 2022 10:25:32 -0700
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (104.47.55.101)
 by edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2375.31; Fri, 28 Oct 2022 10:25:32 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=OwHSvCi08gqaBIB7EMNGYGaecM4dmyJD3iFz8Tm9exS/o4Ucd8kT6BouOicpcT4Q6YNx0S39CEoF6QlT/NZ4UxPk71S2Ad8Yx0pBT8ARvd9kSx2EB3x0mnH/H7Ti3mjkL7L+BagPQBo7E9UsuLp6kpX3rSv8D3vv7SIZhuQkNJ0sB+TMmNief9/snJaEo8pZvnmdKSk1bBxaIdrZy0udN984LOhbOhcwxTzj7KghAOBMnN1FEco5mNCYnpTQ/b6kQVFFaZ0UeKRGFhubHT2pecb4t5fOHw22krTw06LQEvnfMb6Hkj/clhRtCHtNrWHkf3AdaxN+aDQMWT1v7/XESg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=zEr/pbJh6trTBpTugLid4DwGimmg1DO8WspiwhHe0WQ=;
 b=CKl7kS5Sn1+r8emGHxyPg8eHmtnhOovL4lntfQ0xS5IJsbqf0fZqiXOSNNgF1crh7bxFJpLLqYIZY5GeI8HH+g2LtaZDdVJydnKhk2/QhFEu3nEo2QFM5alFGjueAvShxev0EfiM9ZcCs/4knKzZgc7KCdpozv1WtrLVS1uUI03ZK99tGL/SGx6qLCrWNw7oHPqgjI3FSaJjFcdSZq8WwaJ3K7ThyVJkYjLatuiDL3W8qf7one4Pim8NXQ9AqmhKDzWUgR3ihcLk2XXxzEB4TRHP1+yLd1RLFsUk3eZZbUB0jKVqpouQxcKrPwWgTlhAjwrmePCw8MRH+1ntgeSkAg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from SJ1PR11MB6083.namprd11.prod.outlook.com (2603:10b6:a03:48a::9)
 by PH7PR11MB7570.namprd11.prod.outlook.com (2603:10b6:510:27a::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5769.15; Fri, 28 Oct
 2022 17:25:31 +0000
Received: from SJ1PR11MB6083.namprd11.prod.outlook.com
 ([fe80::51de:f739:3681:b16f]) by SJ1PR11MB6083.namprd11.prod.outlook.com
 ([fe80::51de:f739:3681:b16f%7]) with mapi id 15.20.5769.015; Fri, 28 Oct 2022
 17:25:31 +0000
From:   "Luck, Tony" <tony.luck@intel.com>
To:     "Rafael J. Wysocki" <rafael@kernel.org>,
        Shuai Xue <xueshuai@linux.alibaba.com>
CC:     "lenb@kernel.org" <lenb@kernel.org>,
        "james.morse@arm.com" <james.morse@arm.com>,
        "bp@alien8.de" <bp@alien8.de>,
        "dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>,
        "jarkko@kernel.org" <jarkko@kernel.org>,
        "naoya.horiguchi@nec.com" <naoya.horiguchi@nec.com>,
        "linmiaohe@huawei.com" <linmiaohe@huawei.com>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "cuibixuan@linux.alibaba.com" <cuibixuan@linux.alibaba.com>,
        "baolin.wang@linux.alibaba.com" <baolin.wang@linux.alibaba.com>,
        "zhuo.song@linux.alibaba.com" <zhuo.song@linux.alibaba.com>
Subject: RE: [PATCH] ACPI: APEI: set memory failure flags as
 MF_ACTION_REQUIRED on action required events
Thread-Topic: [PATCH] ACPI: APEI: set memory failure flags as
 MF_ACTION_REQUIRED on action required events
Thread-Index: AQHY6bwqT42VcZsAL0OmMP/aRwI1Ja4kDEGAgAAC6gA=
Date:   Fri, 28 Oct 2022 17:25:30 +0000
Message-ID: <SJ1PR11MB60839264AEF656759C8C56D1FC329@SJ1PR11MB6083.namprd11.prod.outlook.com>
References: <20221027042445.60108-1-xueshuai@linux.alibaba.com>
 <CAJZ5v0hdgxsDiXqOmeqBQoZUQJ1RssM=3jpYpWt3qzy0n2eyaA@mail.gmail.com>
In-Reply-To: <CAJZ5v0hdgxsDiXqOmeqBQoZUQJ1RssM=3jpYpWt3qzy0n2eyaA@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
dlp-product: dlpe-windows
dlp-reaction: no-action
dlp-version: 11.6.500.17
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SJ1PR11MB6083:EE_|PH7PR11MB7570:EE_
x-ms-office365-filtering-correlation-id: 5c837891-81fe-4787-7a35-08dab90969fb
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: dxP17cpUzNbpXjywiR5y7t9Kqk7wuQmoe/mU+Abh+CQ0elonIMgxhUptMZMq/FVTxKOGdBBGHPHMcQ2GazIeuTgN/g2rVJJTEVGgrs2bKQ0CqsZPYy3qxNj2FycUtbt37Rv8Wn+smZBxUX1V044zS3g5XtYBqFnHQLd6fG60joXF+TPjHsrNYbDfug8wNg641dfG4Ty6me9ouDvnAcmM6lqMKZ2BLk3r8dc3I6L7BYzLHuhsfrkdod3/B8VO0VediGHL2fMH7Pus3qMR6JRDGe6em7TN1DxvRWYqM78bwmJd35En6a8cG9i7v4KLgbK5YaMucANNLSyrvJiE7H6N5MUb54sf5fos/8XhAKVIe6iWiAXiqkJ8Am2mpUlZhun48bLYq8DYDoSeFK883kVzrC9ogfw77zom3WL5Dh9ewhb0zUE3sASfM3SU9VaqK4wb7PcHQtq4OxnXwOVMuZxx2DeuAp1eE248jvsEfidYfAq1+53Y8FMvhfXBkcHq4lExzrEk9fb2Uu26ejaMJTBZE2XHeCN00TUwAZeC2kjD78O3SH2z4MA865Nw11CJcIhUA1UuPH36JzHDoAZr71J3PoRy4jDmrz30Ky6j5O1Sr84f7PFusTPd7ZbFpx7JxtP5nVw0p9hgCVoPHo3tZDr4aeaSlNeWh7HYLNSmgVXd3gfjleQCKl5DI6XNgFrnryWOLMfki09uJsNPpSzPuymQqrTIDY9Rtmt8wXvZ3K1feJv6hGP38KCeGa7RfOkHmIUkOelqpSnUVwKVh8GP/ZahFA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ1PR11MB6083.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(346002)(136003)(376002)(396003)(39860400002)(366004)(451199015)(9686003)(478600001)(6506007)(26005)(7696005)(186003)(83380400001)(2906002)(55016003)(316002)(54906003)(110136005)(52536014)(8936002)(5660300002)(7416002)(4326008)(8676002)(64756008)(66446008)(66476007)(66556008)(66946007)(76116006)(41300700001)(71200400001)(4744005)(86362001)(33656002)(38100700002)(122000001)(82960400001)(38070700005);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?K3ZnQW9DRmVzTTJQd21lbUtpRlBTcUFNb3l4WkJxL0I1WE1aZDhPeXVQczJj?=
 =?utf-8?B?UHBnZWJMTVBhQjF1a3lzc2Y3aHg2aGMyVDNlc1hMTTloWS9tY1dGcDB0bGVy?=
 =?utf-8?B?cWR1cWhEYmY0QkZwRitXbjlIemZyVDdMM0pJaCtyVWdsVk1qd3o4OWVlUWQw?=
 =?utf-8?B?cTRxV003KzFrVVdCcE5heE1XMlcvbEN1RlNwR2JqeVVYcFFhdUQzNzBlcVgr?=
 =?utf-8?B?TWtIQW9kZ0pvdEZJQkFZWkVGU1BDOXBuc1lmQWFLYWV4dGZPY2hDYURIQ1hL?=
 =?utf-8?B?UENGbTBPeWlKbzBXZ2J5QVhUWkg1UW9HdzkyUXVMbmlIUHVHclNuYTR3NkJP?=
 =?utf-8?B?aExwRjdIK0NtTlkzWUZuTU9LT05CVjdyNjdHaThTQnhoQWorNWticWMwTzFB?=
 =?utf-8?B?ckkySmllZUd5b0lhWTgxT2I2YUYrTjlmRnBHdVo4cCt5YkN3TE1LSzJwVzZj?=
 =?utf-8?B?cHhtQkJaMkMxVktrSW9NbHZRMWVrdEZ3YmdpaTJiVThoM3J3OG1KdDAwRXla?=
 =?utf-8?B?Q20zRWo5WlR0eUZGL3JmR2VJMHFLQUdnQ1lhTkc4MmpEaVZOOStVak5CMjlL?=
 =?utf-8?B?Y3E0TXF2LzhjLyszbkhBcFlKczJnQVVZNGJ1ZEl2SnlBMlIvUzdOeWtDUEsr?=
 =?utf-8?B?c3BlUVpHSDIxVzZkNWhMUStsUVUrelNieHJPQldPWkRYSm5aWW90M1ZSdTdD?=
 =?utf-8?B?NDBKL3FvWnRmZEQ5MHNtVjIrSGloM3cwQmdGekQ2OWpicHdiMlpubnRCL1VN?=
 =?utf-8?B?b2tGV2VEWnlpZlpseHZiRjExcWc4RXJJYXR6MWlFT0hXWU12djMxL3dPanZH?=
 =?utf-8?B?azhaTXlvZW43djVncmQwUjJqSVV1WWtEY3gzV1VNM1oyM0pYME9aQ1VhWTF5?=
 =?utf-8?B?SWpWdW9JdU1Oc3NyamdUcFo1S1BRUXpnNTZsSExGeW9zTUl4aFA5Z2hwVU5Z?=
 =?utf-8?B?aEh1djU4ZzhqQzNDWFQrMVd4bHhiOWZFNGlzRlIxVFh1ZUlQV2lmclJOdGFR?=
 =?utf-8?B?RUxTaHZGeHdvTFVxTmM3WmwzbWJRRUtFT1Z5Tm9TTWsxTlZYKzBBem5SSEY4?=
 =?utf-8?B?c3hqak5OZmFram1zQjN0SnlzdE1NVnJRWTQ2NnB1cDEzUTNtUWZkejFwWnF2?=
 =?utf-8?B?ZTI5clphWGlTa0VFVzVDQkY5QlpVekpGa2lpc2tOTE1WT1BvbVpobXM3Y0tM?=
 =?utf-8?B?WE5qVDkwZEdJYjluSHRHUDJYSmpyaWdNVktlYmpQZEVBNXIrc2tJTFZQcmhT?=
 =?utf-8?B?c0JvVkRIKzRqTVdVN1pPd3p4VXNnN2xTSVhCNHNOejNmYVJISHJZNEcyTEZT?=
 =?utf-8?B?UEFhVjdDdUcxdXJoL2tsV2ZCT2dIQ2htcG5nWkliUC9IanEycEFxRTllN3hN?=
 =?utf-8?B?clRMeWVSczRUQy82OVFMRDdLOFlGQ2hobW14Uk15aVIzcEtOeWQ2SjY0ZjRC?=
 =?utf-8?B?U01tcFN0MDRkRTZ5LzdBZUdQVGFqdk8xZm4welpIVWxva0VkRC9ZazFkR2d6?=
 =?utf-8?B?U3A4bk52T3ViVmJtbzdSUVBCZEc3RjFMZ1ZLU29ZRzdHWEU3bXo0ZTBULzBw?=
 =?utf-8?B?b0lickN1SkFOWHFGWHcwdDI4aEtrZko2QUhCTm91UTVNNG9Denh6M3NYWldR?=
 =?utf-8?B?aG1OZTd3dkthYUhyTUJ0Ky94em11OEs1a1FkaFJFUjNhTG04dUFxWTBYY0Zv?=
 =?utf-8?B?UVZkS0FHQ0tFc2dUY0h5WnFDYk9BdHdmYzhvdk5aSmFHbHNIOXJnMUg2cTF6?=
 =?utf-8?B?VTBRQ045eGVOK05USkFxbWVtNm84WDRWVjBaNWM3ZklmWWNxdDg4MHkyWjVS?=
 =?utf-8?B?eDlraUlDb3dodXR1U3lVVU9qcjI4dDZWV3h5UGZPQjVTL3ZVWW9RZWlOdWIv?=
 =?utf-8?B?bThWVFNBdm5ZYjYyb2VQK0lsOFA0alJ6aXJZaXlvY3h4SXZJc2tGb3BLeHNh?=
 =?utf-8?B?RXVKZEVkWmVvNGxFR2t6cVlKSTZjcFYvWVlYclMxK3VzVEFTQTBGNCttWWs5?=
 =?utf-8?B?RTZvT1g1WDdIZWlEOElJcXVaY0tIMG1GSUdHWjNDdGIvelBUK3ZUNkNkeVMw?=
 =?utf-8?B?U1h6VmVidjJYd3FyaTViUGZkaGJ0YWV5T3hYNmUvWU96RmJxQnBWWnQ0WlpY?=
 =?utf-8?Q?hih4PvcC35A4Xj8thyygI3Bsa?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SJ1PR11MB6083.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5c837891-81fe-4787-7a35-08dab90969fb
X-MS-Exchange-CrossTenant-originalarrivaltime: 28 Oct 2022 17:25:30.9966
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: j0N9JSxftVe4WFuWWKwnQbLIRVK9tsRHBAiXIhakEBETP+MWd3J/bjwaCiteyCXIy05YedJUsn2PcYrF7TlR1A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR11MB7570
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Pj4gY3Blcl9zZWNfbWVtX2Vycjo6ZXJyb3JfdHlwZSBpZGVudGlmaWVzIHRoZSB0eXBlIG9mIGVy
cm9yIHRoYXQgb2NjdXJyZWQNCj4+IGlmIENQRVJfTUVNX1ZBTElEX0VSUk9SX1RZUEUgaXMgc2V0
LiBTbywgc2V0IG1lbW9yeSBmYWlsdXJlIGZsYWdzIGFzIDANCj4+IGZvciBTY3J1YiBVbmNvcnJl
Y3RlZCBFcnJvciAodHlwZSAxNCkuIE90aGVyd2lzZSwgc2V0IG1lbW9yeSBmYWlsdXJlDQo+PiBm
bGFncyBhcyBNRl9BQ1RJT05fUkVRVUlSRUQuDQoNCk9uIHg4NiB0aGUgImFjdGlvbiByZXF1aXJl
ZCIgY2FzZXMgYXJlIHNpZ25hbGVkIGJ5IGEgc3luY2hyb25vdXMgbWFjaGluZSBjaGVjaw0KdGhh
dCBpcyBkZWxpdmVyZWQgYmVmb3JlIHRoZSBpbnN0cnVjdGlvbiB0aGF0IGlzIGF0dGVtcHRpbmcg
dG8gY29uc3VtZSB0aGUgdW5jb3JyZWN0ZWQNCmRhdGEgcmV0aXJlcy4gSS5lLiwgaXQgaXMgZ3Vh
cmFudGVlZCB0aGF0IHRoZSB1bmNvcnJlY3RlZCBlcnJvciBoYXMgbm90IGJlZW4gcHJvcGFnYXRl
ZA0KYmVjYXVzZSBpdCBpcyBub3QgdmlzaWJsZSBpbiBhbnkgYXJjaGl0ZWN0dXJhbCBzdGF0ZS4N
Cg0KQVBFSSBzaWduYWxlZCBlcnJvcnMgZG9uJ3QgZmFsbCBpbnRvIHRoYXQgY2F0ZWdvcnkgb24g
eDg2IC4uLiB0aGUgdW5jb3JyZWN0ZWQgZGF0YQ0KY291bGQgaGF2ZSBiZWVuIGNvbnN1bWVkIGFu
ZCBwcm9wYWdhdGVkIGxvbmcgYmVmb3JlIHRoZSBzaWduYWxpbmcgdXNlZCBmb3INCkFQRUkgY2Fu
IGFsZXJ0IHRoZSBPUy4NCg0KRG9lcyBBUk0gZGVsaXZlciBBUEVJIHNpZ25hbHMgc3luY2hyb25v
dXNseT8NCg0KSWYgbm90LCB0aGVuIHRoaXMgcGF0Y2ggbWlnaHQgZGVsaXZlciBhIGZhbHNlIHNl
bnNlIG9mIHNlY3VyaXR5IHRvIGFwcGxpY2F0aW9ucw0KYWJvdXQgdGhlIHN0YXRlIG9mIHVuY29y
cmVjdGVkIGRhdGEgaW4gdGhlIHN5c3RlbS4NCg0KLVRvbnkNCg==
