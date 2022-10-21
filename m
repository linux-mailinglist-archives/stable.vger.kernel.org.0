Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A7C64606E3E
	for <lists+stable@lfdr.de>; Fri, 21 Oct 2022 05:18:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229948AbiJUDSm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 20 Oct 2022 23:18:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33084 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229868AbiJUDSj (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 20 Oct 2022 23:18:39 -0400
Received: from mga06.intel.com (mga06b.intel.com [134.134.136.31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 847DE1D93EE;
        Thu, 20 Oct 2022 20:18:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1666322318; x=1697858318;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=0iWLdo2t+Y7EaRLIc93EwOUZeCQKb8gMVderT/Tkc4w=;
  b=jJGnVbDKUSaY6STIqNSlQf4CcYXXi/riZMNg3os600sYmYyI2Ivc7l4U
   FL7eCqwBXYwHk5E9O8MW2SVgGHaAOKaLpLW3Uqm95tnblt0hrPbTueRui
   s8Qya3obqGrinu1Gdq6z6GzzZ6Vn2bfibZF1lpOCO3C9uP1WIkYYa/BbO
   5JYdXwxMl/M/T96aNnsSyp1nP0kZtEAmmXC2vW5ADyL6mCQrUPGPw0+gi
   fIpBUVzqMlUjXA5PFrYoSXyaUV9TIIS+qZOWGQRNZ5U/vrIE9qYX4GEbt
   8H8s3oRX7ZdaBWiOx/Zs6EOyahllTghQoN4BkJOuOO37iW0lCzeokoAV6
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10506"; a="368946485"
X-IronPort-AV: E=Sophos;i="5.95,200,1661842800"; 
   d="scan'208";a="368946485"
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Oct 2022 20:18:38 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10506"; a="630234748"
X-IronPort-AV: E=Sophos;i="5.95,200,1661842800"; 
   d="scan'208";a="630234748"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by orsmga002.jf.intel.com with ESMTP; 20 Oct 2022 20:18:37 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Thu, 20 Oct 2022 20:18:37 -0700
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31 via Frontend Transport; Thu, 20 Oct 2022 20:18:37 -0700
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (104.47.58.169)
 by edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2375.31; Thu, 20 Oct 2022 20:18:37 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=RFpDS6uN/i7eIQIuKJBmJep9y0tbhBrg4sDtw21CSFxzKtI0SJ2kqyxTgyvnUTJz89m3D9eGDNL2HZa0Mz5ivBrTSXRif9trl5gYbFOC6ZIuefiYA8ndhW5LsFe8S4pRoNwfQyGeNn0AY4RSkSXVMr4ClA1tWc4LQajF/6QSKFJeG5gSox1dUZnVwwRSX8+dTBY4hR7hL2z6rOThtOwuUqDOeH21y+chpfVG4vPFyjo0vkFAnWVE78v5tFViVM0YVE+HRIeCefyruPw7JMp8QDioXzTfGNmuGqQgep6T2y1q7UM9KMXwynVrdQ+L7QFZIjFOcM1yY3GPPIRplfiZpw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=0iWLdo2t+Y7EaRLIc93EwOUZeCQKb8gMVderT/Tkc4w=;
 b=hqsaqXPBgrMo/Rc7W1tXv7yspKVATDCW2soP+pKOT3Ne7UWM59Pf6Mq2G0IGJLas+ErPskaxNnGPZUynwIK5fofELzc2BUPEUoWxHJNV3Ybpw9Wh0q4tNGeBBFDSPvoo4PTFPZWO+3PzE196LtUcClE3RVy5A1C30a5Rsqb5jGSM72iDC9MckVFddoiuJ8WTL0o9kFyROmXPI1npQPmPdACdO5XTaDAimTBHwxpFIGxDISuHll63Wt452NcW4F7pLvauXsQaD12Ic116B28QVVpcNNV3455B+PkMlPCcxImli5jUUr4dbwaTuNY3k9bPMEeEfK8bgOMw+nPO3i2bVw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from MN2PR11MB3999.namprd11.prod.outlook.com (2603:10b6:208:154::32)
 by MW3PR11MB4540.namprd11.prod.outlook.com (2603:10b6:303:56::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5723.30; Fri, 21 Oct
 2022 03:18:30 +0000
Received: from MN2PR11MB3999.namprd11.prod.outlook.com
 ([fe80::c275:940e:a871:646e]) by MN2PR11MB3999.namprd11.prod.outlook.com
 ([fe80::c275:940e:a871:646e%7]) with mapi id 15.20.5723.033; Fri, 21 Oct 2022
 03:18:30 +0000
From:   "Verma, Vishal L" <vishal.l.verma@intel.com>
To:     "Williams, Dan J" <dan.j.williams@intel.com>,
        "linux-cxl@vger.kernel.org" <linux-cxl@vger.kernel.org>
CC:     "Schofield, Alison" <alison.schofield@intel.com>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        "Wysocki, Rafael J" <rafael.j.wysocki@intel.com>,
        "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>
Subject: Re: [PATCH] ACPI: NUMA: Add CXL CFMWS 'nodes' to the possible nodes
 set
Thread-Topic: [PATCH] ACPI: NUMA: Add CXL CFMWS 'nodes' to the possible nodes
 set
Thread-Index: AQHY5N9gqZxKyFf6M02GId8v3QEAcq4YLdWA
Date:   Fri, 21 Oct 2022 03:18:30 +0000
Message-ID: <e8576cfeb90df3a977626e5c56c37156379fa727.camel@intel.com>
References: <166631003537.1167078.9373680312035292395.stgit@dwillia2-xfh.jf.intel.com>
In-Reply-To: <166631003537.1167078.9373680312035292395.stgit@dwillia2-xfh.jf.intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.44.4 (3.44.4-2.fc36) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MN2PR11MB3999:EE_|MW3PR11MB4540:EE_
x-ms-office365-filtering-correlation-id: 367cc6bf-9780-4ea3-6dab-08dab312ed7a
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: OLu0Ejpi9LGLL4AQzTKRWNUzN3GkSo/TBGuGukXzHELDEbRJDUKOsvfFSCS3DXHPpkWzS0HWVsI/b0rsg88v9gCPNG+vr/84RugezbCYSfAB0HNLB9x6V9ZeL872p/xt+pXR+rQmxK8DXup1IWunc2dENTD74VJ9KcG7e6DU6x8vn7+4KHAUWIamdh4+JLvk1P00vHonQDwpen3Ut6Y0F+Bb+7wN9dakZkR5ijRay7rBF5pkvIL5LgtE/aw/XrR5rmQ3hZDPhIRYcaNd0XqtjRbfnwRFLjFJwVyT92kXvA+6i2I4vOXIzHlQesAHlBrUNNrQAFlGvYG+p2zX90j25iFh2DCQuKVL8hSUGl7FNQj7RLRMtZ4I8bKe/F+ULnfZ9Y8fGvlMmaEwYn/0Bthmz0Nf0Sl/tpswOxnQ33sTowOj817gTKiuESBkSzV8XFko5WlLTYK6Wp5J2mZHiCHn5S1INMi1jNSNFSF6WSJRTQtOmXyY79iw3R5bwUiNJVfWcWQM+aklkeKcu4dhizuzI0XMoIiffqHp543B4I9OWxkAfQ/5FcGbuQvH7NNlAjlftMRfk+8exUHlnbCmWGcZ1Nwlfyg+NrDz7dTEZHlMi87g3wGRaeyJj0S8HSOR7K260A406LUBNWmmbM7JeKpwomhzFPHEksdQCrm+Ekg34VpGeYqqLb3n7/E+9A5ZPP5SVvGGWsNXoGrAnOG6TDq6fQ70DHocoBKr9MCBrVPSJBb7eTiranOkDqQCJDSiLY90LvD5QiDehmp+CImRoEVSIA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR11MB3999.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(366004)(39860400002)(396003)(376002)(136003)(346002)(451199015)(4326008)(110136005)(76116006)(54906003)(66476007)(8676002)(91956017)(316002)(66556008)(66946007)(6506007)(186003)(450100002)(66446008)(2906002)(5660300002)(86362001)(41300700001)(26005)(2616005)(4001150100001)(36756003)(6512007)(8936002)(64756008)(478600001)(6486002)(38100700002)(82960400001)(71200400001)(38070700005)(122000001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?N0RJNUhJSS94cVptUC94eDVxNTBTWHRaLzIwRExSVWtVVFFtc0dCRXZIb0Vw?=
 =?utf-8?B?V0lVQjN6bGo1NkVzeEQ1UjlhZEZ2WWZOcFoySzRvNEN2U0krdkxvZnlkQ21L?=
 =?utf-8?B?cXEzOTVFQ1RQVUgvNytFZ3NRL0p4Rnl2THBXeVNpWUNITlZIQ2dHS3NQa0g3?=
 =?utf-8?B?am5SS2lFaWVleDVVTXBOckRkMG5QdlNEdExIZGdHTGJuQk1NTDJEcjZtQ3cy?=
 =?utf-8?B?eEVYOG42bGVBTXhYcE1kNDJpeFZya2hRbnJYVlEyK1NqMzhRNFNxbno5L2Uy?=
 =?utf-8?B?WG9CVjFuUzVKMmdicGhObU9sLzNEelZLdGNmdzg5V1ZvMzVuR2NucU5EVzg2?=
 =?utf-8?B?VEJNTWU2RkVqN2RQREs3KzhyUWVJYmpFbHV1MDB4YWZzcTdEZXNvVEFTcUZV?=
 =?utf-8?B?VFhZMS9HV2s0VVdyaDBMZmRsdkIrbDhaQy9OUlNjcU1iMXlsTXN2TDdzellW?=
 =?utf-8?B?Tk9SWnk2NWtmZzFmU0ZTdzFDQWlYZUVtVU53blpDV1RFM1hpSTRHSG9Pa05W?=
 =?utf-8?B?NjRXa0ZHUGV4WWdKNGZIblpiRXppbzhWVXZGMENBN296NldTcEg3UU5xNlRF?=
 =?utf-8?B?V05lTEN5U1NMZmE3Q2NnVjVBQ3FUdmJVMXFVcUlBd2w4bzdENkZabkNlbng5?=
 =?utf-8?B?OUJaK04rM0c3RWNlUjM3Q21lQVRuOFp6eWpMUmthQlAzaTdIYmFqY3NUWFFq?=
 =?utf-8?B?MHcrWUNoSks5Sm12TVN1UDMvOG0xRDd6RUtpc1ZHSVJYSDNFaTNQVzZnTkt4?=
 =?utf-8?B?djlWOS82NEZTVStVVlBaTkxGeFNpZ1lpYmMwVWVscC9vUEVFdnNvSE1aR1FV?=
 =?utf-8?B?bTJ3SU5jV3VQRjl6U1hLTzI2N3YxNDBaU2tvVmNCU3Jtb1AvWitKMW5LNkNu?=
 =?utf-8?B?Q0Q3TjJtWnhlVW1XbzBtRXJTNnF6YmtQd2wvYmJReGoxckFGV2l0aWNIcWpO?=
 =?utf-8?B?eHB0Z1BYU0RFVStLNFNwUkp5OEkvV3VtRGJZVVhvT24vVXBXMU80cStVbjQ1?=
 =?utf-8?B?Yzd3NE1qSVRER3h3eUlYNTJwYktnd3FQZjNpYnptazhTZUQ4T3dzZ0RwOU53?=
 =?utf-8?B?bklnTzBwbUYycnhiMU1FNGQrdVkvUEhyeVlNVDZUNHBlekVkZnl5ZUtOR01W?=
 =?utf-8?B?eWlTdHVTTHJjblNhdS9mMGpFMllPOW9ZNGR6QzNReDVBWWVwYUpkZkJERFJn?=
 =?utf-8?B?eEFZZmV0RmllekhFdTZVOXJxV2w5LzlXbFdYc2daQS8ybE02K2dha2U0bURo?=
 =?utf-8?B?ZnBtcWk4VW8wcXc2S3dISmtHN2p4bXAwZ2gxazR6S0hpbVJEMlVFT3hUNGVa?=
 =?utf-8?B?YjMzcGhEbUVtL1A5Ti9JRitsRlZoL0pYZTZkVlpLWjVRbTVHNzQzdTg5Rlhs?=
 =?utf-8?B?ajhEYk04Q1lMcCtyV09OdE5IYUo0N2VGWkcxczY1OWFJVVgxa3p1b3Y5ZXRo?=
 =?utf-8?B?bWdvVWxXRDkvY084VmJ1RDEyR29Nc2RXN085Zkp6ZGJnQWg2MVZ5eGNNeEs2?=
 =?utf-8?B?bU1QdDlvbXdzTTVqTk51dGJDcENPbUFsQmJDVHBQMTd0Y0IvbllqNnlUSVZn?=
 =?utf-8?B?ZmZKQnh4UDA3bitQaWNIN2pEZGFJQlVKbkFNeUxzRHNOZlFraGg1Z2FUSVh3?=
 =?utf-8?B?K1lWSlBuaE5iYXNOSk5UVGpUbHdUMTkxQ3BqSThubXRaSlR2RzNIV0RVb3Jr?=
 =?utf-8?B?QTNwOWt5d2M0UGF3NjNrTVdUY1R0dUJldmN4SFpOWko2dE9aS3FDbHpaMGVn?=
 =?utf-8?B?c045S1pLSjkxZXo4S3k3TjR5QTl4eWJXZ3NZclh1WWd1NzIvU2tMVWNZcFE1?=
 =?utf-8?B?T253VzVvOVFPYmx3WmIyd1hSaFY1b2IxOEtRYXJWNnBUMElnZkpZQlhkdXln?=
 =?utf-8?B?RzlkUTdtL1UyMjBWeHRBK1I5WGJsV2E2NkdtOUR6bW96M2piZFNJenFNcTg5?=
 =?utf-8?B?RXh3T2h5NURFeXhRSkFxUDdaNURjZmJxUkdNTEFqZTdXQXRlVTZJN1Y0U2VQ?=
 =?utf-8?B?SHd2R1ZFRThVRTUrWWloQmNxTzBLbHY4Y1k5MFVRaTdGYk5hcHFkcXJPMGky?=
 =?utf-8?B?Z2h1Z2VubE1MaUJiT1A1K2dmTFBWMjgwR2MzZ0VpWVdnRzAvbE53LzZvMm9y?=
 =?utf-8?B?Z29CUURKTTB1RnhTUVBTMnJKTldTL0JTZGhJZ3JoblZNQ3QrQnNJeWtkQVo1?=
 =?utf-8?B?Z3c9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <5A95D22EE9909340A00C8F3B8929734F@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MN2PR11MB3999.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 367cc6bf-9780-4ea3-6dab-08dab312ed7a
X-MS-Exchange-CrossTenant-originalarrivaltime: 21 Oct 2022 03:18:30.1197
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 7ZvXWZ/0He8F1f1JXocgXYb3OTmwEi7n3uRVkHxKiBEd28yex0bNjB4dPxc5hHArZUS4qCHo8R1poK1Y4Oq92ksSnGntaAxEW2Y7urR0Q5k=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW3PR11MB4540
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

T24gVGh1LCAyMDIyLTEwLTIwIGF0IDE2OjU0IC0wNzAwLCBEYW4gV2lsbGlhbXMgd3JvdGU6DQo+
IFRoZSBBQ1BJIENFRFQuQ0ZNV1MgaW5kaWNhdGVzIGEgcmFuZ2Ugb2YgcG9zc2libGUgYWRkcmVz
cyB3aGVyZSBuZXcgQ1hMDQo+IHJlZ2lvbnMgY2FuIGFwcGVhci4gRWFjaCByYW5nZSBpcyBhc3Nv
Y2lhdGVkIHdpdGggYSBRVEcgaWQgKFFvUw0KPiBUaHJvdHRsaW5nIEdyb3VwIGlkKS4gRm9yIGVh
Y2ggcmFuZ2UgKyBRVEcgcGFpciB0aGF0IGlzIG5vdCBjb3ZlcmVkIGJ5IGEgcHJveGltaXR5DQo+
IGRvbWFpbiBpbiB0aGUgU1JBVCwgTGludXggY3JlYXRlcyBhIG5ldyBOVU1BIG5vZGUuIEhvd2V2
ZXIsIHRoZSBjb21taXQNCj4gdGhhdCBhZGRlZCB0aGUgbmV3IHJhbmdlcyBtaXNzZWQgdXBkYXRp
bmcgdGhlIG5vZGVfcG9zc2libGUgbWFzayB3aGljaA0KPiBjYXVzZXMgbWVtb3J5X2dyb3VwX3Jl
Z2lzdGVyKCkgdG8gZmFpbC4gQWRkIHRoZSBuZXcgbm9kZXMgdG8gdGhlDQo+IG5vZGVzX3Bvc3Np
YmxlIG1hc2suDQo+IA0KPiBDYzogPHN0YWJsZUB2Z2VyLmtlcm5lbC5vcmc+DQo+IEZpeGVzOiBm
ZDQ5Zjk5YzE4MDkgKCJBQ1BJOiBOVU1BOiBBZGQgYSBub2RlIGFuZCBtZW1ibGsgZm9yIGVhY2gg
Q0ZNV1Mgbm90IGluIFNSQVQiKQ0KPiBDYzogQWxpc29uIFNjaG9maWVsZCA8YWxpc29uLnNjaG9m
aWVsZEBpbnRlbC5jb20+DQo+IENjOiBSYWZhZWwgSi4gV3lzb2NraSA8cmFmYWVsLmoud3lzb2Nr
aUBpbnRlbC5jb20+DQo+IFJlcG9ydGVkLWJ5OiBWaXNoYWwgVmVybWEgPHZpc2hhbC5sLnZlcm1h
QGludGVsLmNvbT4NCj4gVGVzdGVkLWJ5OiBWaXNoYWwgVmVybWEgPHZpc2hhbC5sLnZlcm1hQGlu
dGVsLmNvbT4NCj4gU2lnbmVkLW9mZi1ieTogRGFuIFdpbGxpYW1zIDxkYW4uai53aWxsaWFtc0Bp
bnRlbC5jb20+DQo+IC0tLQ0KPiBSYWZhZWwsIEkgY2FuIHRha2UgdGhpcyB0aHJvdWdoIHRoZSBD
WEwgdHJlZSB3aXRoIHNvbWUgb3RoZXIgcGVuZGluZw0KPiBmaXhlcy4NCj4gDQo+IMKgZHJpdmVy
cy9hY3BpL251bWEvc3JhdC5jIHzCoMKgwqAgMSArDQo+IMKgMSBmaWxlIGNoYW5nZWQsIDEgaW5z
ZXJ0aW9uKCspDQoNCkxvb2tzIGdvb2QsDQoNClJldmlld2VkLWJ5OiBWaXNoYWwgVmVybWEgPHZp
c2hhbC5sLnZlcm1hQGludGVsLmNvbT4NCg0KPiANCj4gZGlmZiAtLWdpdCBhL2RyaXZlcnMvYWNw
aS9udW1hL3NyYXQuYyBiL2RyaXZlcnMvYWNwaS9udW1hL3NyYXQuYw0KPiBpbmRleCAzYjgxOGFi
MTg2YmUuLjFmNGZjNWY4YTgxOSAxMDA2NDQNCj4gLS0tIGEvZHJpdmVycy9hY3BpL251bWEvc3Jh
dC5jDQo+ICsrKyBiL2RyaXZlcnMvYWNwaS9udW1hL3NyYXQuYw0KPiBAQCAtMzI3LDYgKzMyNyw3
IEBAIHN0YXRpYyBpbnQgX19pbml0IGFjcGlfcGFyc2VfY2Ztd3ModW5pb24gYWNwaV9zdWJ0YWJs
ZV9oZWFkZXJzICpoZWFkZXIsDQo+IMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgcHJf
d2FybigiQUNQSSBOVU1BOiBGYWlsZWQgdG8gYWRkIG1lbWJsayBmb3IgQ0ZNV1Mgbm9kZSAlZCBb
bWVtICUjbGx4LSUjbGx4XVxuIiwNCj4gwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgbm9kZSwgc3RhcnQsIGVuZCk7DQo+IMKgwqDCoMKgwqDCoMKgwqB9DQo+
ICvCoMKgwqDCoMKgwqDCoG5vZGVfc2V0KG5vZGUsIG51bWFfbm9kZXNfcGFyc2VkKTsNCj4gwqAN
Cj4gwqDCoMKgwqDCoMKgwqDCoC8qIFNldCB0aGUgbmV4dCBhdmFpbGFibGUgZmFrZV9weG0gdmFs
dWUgKi8NCj4gwqDCoMKgwqDCoMKgwqDCoCgqZmFrZV9weG0pKys7DQo+IA0KDQo=
