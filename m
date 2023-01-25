Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 18E8A67B299
	for <lists+stable@lfdr.de>; Wed, 25 Jan 2023 13:33:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235392AbjAYMdL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 25 Jan 2023 07:33:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33258 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235411AbjAYMdK (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 25 Jan 2023 07:33:10 -0500
Received: from mga02.intel.com (mga02.intel.com [134.134.136.20])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 20C4E1CF59;
        Wed, 25 Jan 2023 04:33:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1674649989; x=1706185989;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=tyKs+xFI/u8Oo1hDpyNZH22y9hlNFBEUBHGLNY26i8w=;
  b=eMiwITdIIX8ims4MlL3GWtmc3S2sAVgji9iLISurlhUTXeh8hiJyQTmK
   S9zTGHy1Vna4QBSbLhRutNd7c/+rwGvjVlx7PQTZhTfSywK9iYfXtdLtw
   AG0X8KGAIU8iTE5AaFIXQb2zRFeiAVTU8XqLWwBEZt0ykHtmHSq0F/EGh
   lfgzMX74v11lxa/WxuTAatpqV1XBI0r2rGG9uagwl6tlxGiu4SuXCRAuV
   eNymvq6xlY8F7ARRj7VaYGVoH5M1P1cM4R5mRHRI/txmCun5sxRJBWk/2
   pgTLmPGrBUxrR1K8QpfoWqZNYHQKibuAFq/0foad4a24vV14CBbg6muWN
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10600"; a="314447510"
X-IronPort-AV: E=Sophos;i="5.97,245,1669104000"; 
   d="scan'208";a="314447510"
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Jan 2023 04:33:08 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10600"; a="731040973"
X-IronPort-AV: E=Sophos;i="5.97,245,1669104000"; 
   d="scan'208";a="731040973"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by fmsmga004.fm.intel.com with ESMTP; 25 Jan 2023 04:33:07 -0800
Received: from orsmsx612.amr.corp.intel.com (10.22.229.25) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Wed, 25 Jan 2023 04:33:06 -0800
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx612.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16 via Frontend Transport; Wed, 25 Jan 2023 04:33:06 -0800
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (104.47.56.176)
 by edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.16; Wed, 25 Jan 2023 04:33:06 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=eWeIibiLES5IjB7l9j9UiKCotWMEjMZWoRHU//FCWiHeLG7Ak1d2NWEG8ze3oPjtoFwOfqRLOfqKtL4vNr8JP5DvQSZuD17oB1IDbuchkUBOW7qs/7OUjMvHn1aFZa5UT6r6BvfZlaiKUO9nzsEJLfPNovPDzHdMm5ASZMeiTBj2bVBTYXFGdMNjz3NtXsEk4EVqA4CSq5HpB4+lS7Q0ozHMXLPI4QdgQ29ulmuQZMKocG1k7PVuAENoibOf/0bDRQG9KeffExxXqIYDbUsQbA/TslswOAYrUdfoeFy1KY0ArBGDE/dTjI4rgo6Zz/5X3Iv8EkXi89f50Ti+Qem1Ag==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=tyKs+xFI/u8Oo1hDpyNZH22y9hlNFBEUBHGLNY26i8w=;
 b=d0VMvUDIyiQrJnVvCBz2844kQcyFWosA8/ZQ31iydVcoW0jfaL7kzJXmThnQxGvzkMFRrwgmjKFavIukUnDTpWVvKIAfWa+aJ7LI+oLXJbtReNOClqWWTS91Gc1MW1LGGvcYURN6JV5wsA97ySHOGuSHYIm+xs7aMXwkvQJj2F2xh8wxaB5PuP/VY0YWeD181kF1BbwIdXyAaXUATNtpElzXoLhH8YSNseTEaKVg5JI5v7jzKF49nWpH9DcGOEL3ekTyhjXslT7anl38qHRPlB/v0npvpJFsLsZ2hMVkmWNqET9KF1YPHSkkspfwjSBX2zJjQs8qSzjNiVVzE0zjrg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from DM8PR11MB5750.namprd11.prod.outlook.com (2603:10b6:8:11::17) by
 CY8PR11MB7313.namprd11.prod.outlook.com (2603:10b6:930:9c::20) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6002.33; Wed, 25 Jan 2023 12:33:04 +0000
Received: from DM8PR11MB5750.namprd11.prod.outlook.com
 ([fe80::f0e0:ca50:78eb:1030]) by DM8PR11MB5750.namprd11.prod.outlook.com
 ([fe80::f0e0:ca50:78eb:1030%4]) with mapi id 15.20.6043.021; Wed, 25 Jan 2023
 12:33:04 +0000
From:   "Reshetova, Elena" <elena.reshetova@intel.com>
To:     Greg KH <gregkh@linuxfoundation.org>,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>
CC:     Leon Romanovsky <leon@kernel.org>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Marc Zyngier <maz@kernel.org>,
        "darwi@linutronix.de" <darwi@linutronix.de>,
        "kirill.shutemov@linux.intel.com" <kirill.shutemov@linux.intel.com>,
        "Mika Westerberg" <mika.westerberg@linux.intel.com>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: RE: [PATCH 1/2] PCI/MSI: Cache the MSIX table size
Thread-Topic: [PATCH 1/2] PCI/MSI: Cache the MSIX table size
Thread-Index: AQHZLCheeVJV3ORoRE2q8OmR+bNora6qJ4QAgANU4ICAAD2HAIABX5zA
Date:   Wed, 25 Jan 2023 12:33:04 +0000
Message-ID: <DM8PR11MB5750F5873EA182A28ABC7701E7CE9@DM8PR11MB5750.namprd11.prod.outlook.com>
References: <20230119170633.40944-1-alexander.shishkin@linux.intel.com>
 <20230119170633.40944-2-alexander.shishkin@linux.intel.com>
 <Y8z7FPcuDXDBi+1U@unreal> <87v8kwp2t6.fsf@ubik.fi.intel.com>
 <Y8/6InIxcpwM5u2M@kroah.com>
In-Reply-To: <Y8/6InIxcpwM5u2M@kroah.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DM8PR11MB5750:EE_|CY8PR11MB7313:EE_
x-ms-office365-filtering-correlation-id: fd1e41f2-fd45-4789-e106-08dafed04e63
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: DYjduFkcVgD6co6my4ZThZ3S4Grw89M91HbZlasBge5czxF2svB7XcJt53RIyWRMxfJEpzADHRQ8/F4An/B4+hsnxRBjnhOtj7gfJR1pyO+pmINb7tFYneJZpYsaofPqV4bZqWroqFQ6jvDSk6u0Jb8F4Yi6brwrmwWckf742XVWijgBWIk9U80+GjSbt9x9CUjdK62tYob+Fy0Wtctpnjavknum/7dl1+SnSOKBaSz/VZAPEoREp4DAhQDldN3aBJ5TRyP2yzPwlgUPpWnuwMCefurxPjSlke6MZ+HGhvUG12A/vw13QAl1R/n3UvpHBhMFD8HOvchQ2aVMzSG7AFaaoFNKbfqceEzt0bu1D3NIASSLsLKeZCMaLnnQbgi8ZP7ol2KCuYeZxaP8kKBFccPlmcMWcypM0d5E+V9sh/qLdtHCetyz2nm4zD+lsO/O9XvS204Jm6lLZ8SYPHgNK4JfP0QtoU/WvGdbP5vak2D+41EzFWI0MPEGqQ0h1y//j7c+jvvtcsVcP46YEUvDWzkMbjtK3WSm2i/dgafkT97T2hO+QY0UirEDxuEjJstomCO1okN5Ju7/npJcnQixD5sIn2oux/OwMsi4Ojjm0+LG7JGi8R7YDm+pZJ7meTnx/qYzIh6MhDINXmD5+ja53I22FXriFjfzVRsISw9D7CC3AtUGkeq2CpHvbDykZVfZEqb3ighcuxgK6TJDFRa4T4fTSHXfNFaHhVJp5tBhP6g=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM8PR11MB5750.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(366004)(136003)(376002)(396003)(39860400002)(346002)(451199018)(66946007)(86362001)(66556008)(316002)(8676002)(76116006)(66446008)(110136005)(9686003)(55016003)(66476007)(5660300002)(52536014)(71200400001)(38070700005)(122000001)(41300700001)(38100700002)(6506007)(82960400001)(64756008)(2906002)(7416002)(186003)(7696005)(45080400002)(83380400001)(4326008)(26005)(33656002)(478600001)(8936002)(966005)(54906003);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?K0VxQjBjaWdHWWhJN0YwUzFLbzVmZ2piSG1mYjc4SFJmVzYwTDZYRVpQRWYx?=
 =?utf-8?B?alpMRE4zRTk4VlNPVTVEZHhwSGFnc0hrN3BtMHF5emZKNHNVWTBZTDdkYTA1?=
 =?utf-8?B?QjZDcEQ3amMrSlNTZGVCZnEwUlF3MVhRZnpkeUdmUUNDSUpRQlhzbmtQakRG?=
 =?utf-8?B?SDVTNWRrcDI0TkUwMGtXSE1vc05LMVhPcllwRERnazF6TEczKzZlTDhXNDJU?=
 =?utf-8?B?VU5mMTdzSUpxazVyOFBKbTg4V1R2Wnk4WFJWaWVWZ1hoRFNXVWdRa1dnaWt1?=
 =?utf-8?B?UFdUazh3U29WZjRNbHY4dlBIT2FjSW14OXF1ZkhUSlhJcGE0aUcrSG8rekdE?=
 =?utf-8?B?ejlmWEY4YXlpMzhZT2E2czdpMWFBbVIxOG1EbEJoUlFZZTBscDhMcTdVcngv?=
 =?utf-8?B?c0lmV1paOWxxRVRPY3Avd2RWR3FuT3FtUDkyLzRDb1N4N3daV05IUFRJNko5?=
 =?utf-8?B?Q1BocVJFVVNOQkFGNmx0NnY0SFl6QmNvb0ljSVNWTTl1dGxIVCttM3pDZ3JJ?=
 =?utf-8?B?TUg4cXBabDYxTnNSZkh4UXVtdEV3VDBESU5IUU0yZk9xUldLWm5yend2Z0c4?=
 =?utf-8?B?SEN5VHZJTllmK1M2RmhiRnBYWjZPeWFRQThUUFFHZ1BlOUFST29sYlVlWUhO?=
 =?utf-8?B?RHlGK3h3a2IxZWtJQWh3QStibXB1aU5KSk1EckFBWUhUU0NmQVYwcVd4MDhN?=
 =?utf-8?B?RkU0K2ZsL29xejNNYkEvamh1YWZJZ054OU5DdlBJM3JtaG5vb1RlVldlNzQx?=
 =?utf-8?B?bUVoZDlsTW44SDJFQjRwT0RQN0ExU0dmQTlRNXV5TnJNZzJlMkpGaGRPYW5t?=
 =?utf-8?B?TXUwODZOdDFmY25Zak1wNzIwSk5MNTJJY25kWW1NRU4yTTd3dThxVGhKS2lo?=
 =?utf-8?B?alhmYnZSdm1EUVRzcUJOQkdOaURBVm5kbUEwNFpuSjk0dFRjNlFid0J6UEJx?=
 =?utf-8?B?THZnTThEQTN2dEVQN2lHWTg2aFR3VTh0SnZRZGR0Rm9JeFY5VFZ0WjVHL0Vy?=
 =?utf-8?B?TG81WnJSN0VzaUo4bkxWVDRoSUpuR2tIbVNGdEI2ZHgzMnhITUpBdFBGaGU2?=
 =?utf-8?B?Y2dBRnNEQVVHdEhOQmhubEVuMklGZzJmY0ZMd1ZHcTJjQXJpNHF0T0dweTNK?=
 =?utf-8?B?QVhUK1RuNkxuWlZIbXBMVnFwcklGRDRBNmg2VDNWRm1PY2tORDRRRG5zcHAw?=
 =?utf-8?B?S1NHTURrWnBmYWFDTE5IRWZjZW1CNmRvKzRrY0IrYnlISnA0V2NCVDVTc2s3?=
 =?utf-8?B?Q1BuNDBKZmMvV09idVFFL1VGMEJIdGZxRlBrZEFUWThhR09lckVIWU1FUXZu?=
 =?utf-8?B?WFlXN2tTelRaVHJPQXdIUk5PRDVELzlBZHBsNE0ydzY2c2I4aVN1NFZDNzl2?=
 =?utf-8?B?NkdNNVlIM0JHdjBNUGJlc0dXSEdnNm4zZ0Y2dHZuWDgrM2E4bHdKZlhzbjU2?=
 =?utf-8?B?RWc4Qyt6WjIwZnVBWmlzTWhnQThyL1lnVnQxNHQrYllZRUJ6NFRkdGdrTmgw?=
 =?utf-8?B?akZsRmtvV3dVS2R6L1dRWmVNZTIzY3FSU2hBeGV0K001VFNoWm1uZ0VLdGxk?=
 =?utf-8?B?MU51N1lzMUpUVFFpSlNFSHhRMGthMDJ1K1VndTdHSCtXNDVKclh1NGpUSmYy?=
 =?utf-8?B?WUI3ZE92cDR6OU0wQXNJcEdmWjlka0FKV0pWZFI0Q1FYZlZ5TmlRNzE4VDhF?=
 =?utf-8?B?MDFubmw4dE5USDIyZ3BaTlpUeEp2dktTdjEwR2hYa3AvZ0VaV2x1TmNjU2o4?=
 =?utf-8?B?bzRrVmZrMU54UjkwTXZ1ak1RNXpITVkxNGlyQUxJU3pTUEptck4zbEVlbHE4?=
 =?utf-8?B?NHFmREk0QWFIWDZEZHdTT05BTVlOWEpiU3llYTJtajNuRDFCY01hZWZkUjYz?=
 =?utf-8?B?RFkxWjRPbjdRQ1RsNFNYMmhCRWp4Q2k1UVNlTDUveitLelRMTERmWThnVmdY?=
 =?utf-8?B?NXdCUGZ1Q0NGdXp4bHJ1S2tYTkJLbFkxZkZBaCsrU0tFTjhyenVRT1ZVOVgx?=
 =?utf-8?B?K0ZKQ1h6ZStsVTU3S1h2aTd0alVzS2I0UnlDTFhheEFVZk1MWUczcURnbERJ?=
 =?utf-8?B?THk5SGk5M2l2Nk5uRzBNSkIzNXB0Ly9ucVQyU1c4b01BOXFWQmZ0eStMa2lY?=
 =?utf-8?Q?GIS+JHnfrUJc04YK+OJyzRui4?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM8PR11MB5750.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: fd1e41f2-fd45-4789-e106-08dafed04e63
X-MS-Exchange-CrossTenant-originalarrivaltime: 25 Jan 2023 12:33:04.7698
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: gxo3dYmOUOzWY8Tgq1S12qSv0hmjUS7WmM7timfsKs6/slG1Lwu3/bgCte+YnIU444MHgGSvwHc5ogqRzZwRFeEoX8RyMCWJZ5xzl3DPt4U=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY8PR11MB7313
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

DQo+IE9uIFR1ZSwgSmFuIDI0LCAyMDIzIGF0IDAxOjUyOjM3UE0gKzAyMDAsIEFsZXhhbmRlciBT
aGlzaGtpbiB3cm90ZToNCj4gPiBMZW9uIFJvbWFub3Zza3kgPGxlb25Aa2VybmVsLm9yZz4gd3Jp
dGVzOg0KPiA+DQo+ID4gPiBPbiBUaHUsIEphbiAxOSwgMjAyMyBhdCAwNzowNjozMlBNICswMjAw
LCBBbGV4YW5kZXIgU2hpc2hraW4gd3JvdGU6DQo+ID4gPj4gQSBtYWxpY2lvdXMgZGV2aWNlIGNh
biBjaGFuZ2UgaXRzIE1TSVggdGFibGUgc2l6ZSBiZXR3ZWVuIHRoZSB0YWJsZQ0KPiA+ID4+IGlv
cmVtYXAoKSBhbmQgc3Vic2VxdWVudCBhY2Nlc3NlcywgcmVzdWx0aW5nIGluIGEga2VybmVsIHBh
Z2UgZmF1bHQgaW4NCj4gPiA+PiBwY2lfd3JpdGVfbXNnX21zaXgoKS4NCj4gPiA+Pg0KPiA+ID4+
IFRvIGF2b2lkIHRoaXMsIGNhY2hlIHRoZSB0YWJsZSBzaXplIG9ic2VydmVkIGF0IHRoZSBtb21l
bnQgb2YgdGFibGUNCj4gPiA+PiBpb3JlbWFwKCkgYW5kIHVzZSB0aGUgY2FjaGVkIHZhbHVlLiBU
aGlzLCBob3dldmVyLCBkb2VzIG5vdCBoZWxwIGRyaXZlcnMNCj4gPiA+PiB0aGF0IHBlZWsgYXQg
dGhlIFBDSUVfTVNJWF9GTEFHUyByZWdpc3RlciBkaXJlY3RseS4NCj4gPiA+Pg0KPiA+ID4+IFNp
Z25lZC1vZmYtYnk6IEFsZXhhbmRlciBTaGlzaGtpbiA8YWxleGFuZGVyLnNoaXNoa2luQGxpbnV4
LmludGVsLmNvbT4NCj4gPiA+PiBSZXZpZXdlZC1ieTogTWlrYSBXZXN0ZXJiZXJnIDxtaWthLndl
c3RlcmJlcmdAbGludXguaW50ZWwuY29tPg0KPiA+ID4+IENjOiBzdGFibGVAdmdlci5rZXJuZWwu
b3JnDQo+ID4gPj4gLS0tDQo+ID4gPj4gIGRyaXZlcnMvcGNpL21zaS9hcGkuYyB8IDcgKysrKysr
LQ0KPiA+ID4+ICBkcml2ZXJzL3BjaS9tc2kvbXNpLmMgfCAyICstDQo+ID4gPj4gIGluY2x1ZGUv
bGludXgvcGNpLmggICB8IDEgKw0KPiA+ID4+ICAzIGZpbGVzIGNoYW5nZWQsIDggaW5zZXJ0aW9u
cygrKSwgMiBkZWxldGlvbnMoLSkNCj4gPiA+DQo+ID4gPiBJJ20gbm90IHNlY3VyaXR5IGV4cGVy
dCBoZXJlLCBidXQgbm90IHN1cmUgdGhhdCB0aGlzIHByb3RlY3RzIGZyb20gYW55dGhpbmcuDQo+
ID4gPiAxLiBLZXJuZWwgcmVsaWVzIG9uIHdvcmtpbmcgYW5kIG5vdC1tYWxpY2lvdXMgSFcuIFRo
ZXJlIGFyZSBnYXppbGxpb24gd2F5cw0KPiA+ID4gdG8gY2F1c2UgY3Jhc2hlcyBvdGhlciB0aGFu
IGNoYW5naW5nIE1TSS1YLg0KPiA+DQo+ID4gVGhpcyBwYXJ0aWN1bGFyIGJ1ZyB3YXMgcHJldmVu
dGluZyBvdXIgZnV6emluZyBmcm9tIGdvaW5nIGRlZXBlciBpbnRvDQo+ID4gdGhlIGNvZGUgYW5k
IHJlYWNoaW5nIHNvbWUgbW9yZSBvZiB0aGUgYWZvcmVtZW50aW9uZWQgZ2F6aWxsaW9uIGJ1Z3Mu
DQo+IA0KPiBBcyBwZXIgb3VyIGRvY3VtZW50YXRpb24sIGlmIHlvdSBhcmUgImZpeGluZyIgdGhp
bmdzIGJhc2VkIG9uIGEgdG9vbCB5b3UNCj4gaGF2ZSwgeW91IEhBVkUgVE8gZG9jdW1lbnQgdGhh
dCBpbiB0aGUgY2hhbmdlbG9nLiAgT3RoZXJ3aXNlIHdlIGp1c3QgZ2V0DQo+IHRvIHJlamVjdCB0
aGUgcGF0Y2ggZmxhdCBvdXQgKGhpbnQsIHRoaXMgaGFzIGNhdXNlZCBtb3JlIHRoYW4gb25lIGdy
b3VwDQo+IG9mIGRldmVsb3BlcnMgdG8ganVzdCBiZSBmbGF0IG91dCBiYW5uZWQgZm9yIGlnbm9y
aW5nLi4uKQ0KPiANCj4gQW5kIHdoYXQga2luZCBvZiB0b29sIGlzIG5vdyBmdXp6aW5nIFBDSSBj
b25maWcgYWNjZXNzZXMgd2l0aA0KPiAibWFsaWNpb3VzIiBkZXZpY2VzPyAgQWdhaW4sIHRoaXMg
aXMgTk9UIHNvbWV0aGluZyB0aGF0IExpbnV4IGN1cnJlbnRseQ0KPiBldmVuIGF0dGVtcHRzIHRv
IHdhbnQgdG8gcHJvdGVjdCBpdHNlbGYgYWdhaW5zdC4gIElmIHlvdSBhcmUgd2FudGluZyB0bw0K
PiBjaGFuZ2UgdGhhdCBtb2RlbCwgd29uZGVyZnVsLCBsZXQncyBkaXNjdXNzIHRoYXQgYW5kIHdv
cmsgb24gZGVmaW5pbmcNCj4gdGhlIHNjb3BlIG9mIHlvdXIgbmV3IHNlY3VyaXR5IHRocmVhdCBt
b2RlbCBhbmQgZ28gZnJvbSB0aGVyZS4gIERvbid0DQo+IHRocm93IHJhbmRvbSBwYXRjaGVzIGF0
IHVzIGFuZCBleHBlY3QgdXMgdG8gdGhpbmsgdGhleSBhcmUgZXZlbiB2YWxpZC4NCj4gDQo+IEFn
YWluLCBMaW51eCB0cnVzdHMgUENJIGRldmljZXMuICBJZiB5b3UgZG9uJ3Qgd2FudCB0byB0cnVz
dCBQQ0kNCj4gZGV2aWNlcywgd2UgYWxyZWFkeSBoYXZlIGEgZnJhbWV3b3JrIGluIHBsYWNlIHRv
IHByZXZlbnQgdGhhdCB3aGljaCBpcw0KPiBpbmRlcGVuZGFudCBvZiB0aGlzIGFyZWEgb2YgdGhl
IFBDSSBjb2RlLiAgVXNlIHRoYXQsIG9yIGxldCdzIGRpc2N1c3MNCj4gd2h5IHRoYXQgaXMgaW5z
dWZmaWNpZW50Lg0KDQpTdXJlLCBJIGhhdmUgc3RhcnRlZCBhIG5ldyB0aHJlYWQgb24gdGhpcyBp
biANCmh0dHBzOi8vbG9yZS5rZXJuZWwub3JnL2FsbC9ETThQUjExTUI1NzUwNTQ4MUIyRkU3OUMz
RDU2QzkyMDFFN0NFOUBETThQUjExTUI1NzUwLm5hbXByZDExLnByb2Qub3V0bG9vay5jb20vDQoN
CkkgdGhpbmsgaXQgaXMgbXVjaCBiaWdnZXIgdG9waWMgdG8gZGlzY3Vzcywgc28gYmV0dGVyIGJl
IGhhbmRsZWQgc2VwYXJhdGVseS4gDQoNCkJlc3QgUmVnYXJkcywNCkVsZW5hLg0K
