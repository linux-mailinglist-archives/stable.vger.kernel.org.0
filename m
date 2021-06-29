Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F217B3B77B8
	for <lists+stable@lfdr.de>; Tue, 29 Jun 2021 20:20:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235038AbhF2SXH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 29 Jun 2021 14:23:07 -0400
Received: from mga11.intel.com ([192.55.52.93]:18249 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235052AbhF2SXC (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 29 Jun 2021 14:23:02 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10030"; a="205200674"
X-IronPort-AV: E=Sophos;i="5.83,309,1616482800"; 
   d="scan'208";a="205200674"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Jun 2021 11:20:33 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.83,309,1616482800"; 
   d="scan'208";a="408530210"
Received: from orsmsx606.amr.corp.intel.com ([10.22.229.19])
  by orsmga003.jf.intel.com with ESMTP; 29 Jun 2021 11:20:33 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX606.amr.corp.intel.com (10.22.229.19) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2242.4; Tue, 29 Jun 2021 11:20:32 -0700
Received: from orsmsx611.amr.corp.intel.com (10.22.229.24) by
 ORSMSX610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2242.4; Tue, 29 Jun 2021 11:20:32 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx611.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2242.4
 via Frontend Transport; Tue, 29 Jun 2021 11:20:32 -0700
Received: from NAM04-DM6-obe.outbound.protection.outlook.com (104.47.73.40) by
 edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2242.4; Tue, 29 Jun 2021 11:20:32 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=bXbZ5+qF42X1NlYFH9ivLzblGS1ep4jS+EP5tYYk1QERQvimmIK3qIu6kMaPXTq9anGgxd6h3VgKEzbLgU0nBuKG33WvVYQSKQGEG4hZMw7Bh25Z+z1dIX+OC4LxT1EfPIl9GMtvC9adoVwR4H1FtJnOPT5D8pK3fXQ8xLTwW2xYaN83Wiiqn541A1sbRNddWbQ7KBR0e5QJnTp0vV1R3vhQiEmS62WpwcVr59ghr90XrwCvDsNSoOtUr0W4ttohjl071EndwmTmSUGw/bMvBOb58Eszu5jAGtwJyNQOoADcQxABPMwNpKfT5HME11uhf6pVG3q++UdcHcHMi0qXIA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=svjdYOESlXt5KzscBoqBxIMWfYs6M6k38ya7jDZT9IA=;
 b=C4RZQUe+5ixPB3+B6PNUuMewvtiD6IoVUE2oaVCtDR0SOW2JgYl8XaY77E3WVdmYvjm9Pa2Z4stfSiBhLItebUe8rCWs/9Ahf1a0H+GqblC+Ud2C4tEkk/M77YdAwC70A4OeSXxEx3mIDbBHfYpV+4zBKUpsugzzb8G+4LDEMrIUK7W4qLrIyNPHWHT7YlQ8lDEw4SMMseYTldQ7lui9Uanpa5aOg7NmSNV+YUZx6rooFkpOoZCah6uFLKbplnhfZnI5ax68Lugr2ae/4f/c0Q6P3rwmuprZkYd/SRI6mIe3HiFBEy655+GIx+edXGmArlxZMyGa0ebD+vZoViqzKg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=intel.onmicrosoft.com;
 s=selector2-intel-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=svjdYOESlXt5KzscBoqBxIMWfYs6M6k38ya7jDZT9IA=;
 b=jxWdC8wUE35Q1J9PWOfMiflBQoEp0okO1mva2DPlSAc53VGAMTvoK6C3T9WrWv/HkV2H7OhL78aV7kpcC/jbFXCEKo63u7YEtuL6KIhBtTLxI/SyMfCa9X9QUNhyp0n7iZQDyiqPNZBGAXoMcXIdK5FDbkMLoby3CQCQfipD6TA=
Received: from BYAPR11MB3606.namprd11.prod.outlook.com (2603:10b6:a03:b5::25)
 by BY5PR11MB3975.namprd11.prod.outlook.com (2603:10b6:a03:184::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4264.20; Tue, 29 Jun
 2021 18:20:30 +0000
Received: from BYAPR11MB3606.namprd11.prod.outlook.com
 ([fe80::815a:9b19:3b72:59a5]) by BYAPR11MB3606.namprd11.prod.outlook.com
 ([fe80::815a:9b19:3b72:59a5%6]) with mapi id 15.20.4264.026; Tue, 29 Jun 2021
 18:20:30 +0000
From:   "Fujinaka, Todd" <todd.fujinaka@intel.com>
To:     Philipp Hahn <hahn@univention.de>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        "892105@bugs.debian.org" <892105@bugs.debian.org>,
        Ben Hutchings <benh@debian.org>,
        "intel-wired-lan@osuosl.org" <intel-wired-lan@osuosl.org>
CC:     "Bonaccorso, Salvatore" <carnil@debian.org>,
        "alexander.duyck@gmail.com" <alexander.duyck@gmail.com>
Subject: RE: Cherry-pick "i40e: Be much more verbose about what we can and
 cannot offload"
Thread-Topic: Cherry-pick "i40e: Be much more verbose about what we can and
 cannot offload"
Thread-Index: AQHXbOTlXuHddK+oPUSlmVWRbTl3c6srS5Kw
Date:   Tue, 29 Jun 2021 18:20:30 +0000
Message-ID: <BYAPR11MB360618A581F56D9054B2148AEF029@BYAPR11MB3606.namprd11.prod.outlook.com>
References: <937dd880-f902-aa9c-67d5-2d582a29e122@univention.de>
In-Reply-To: <937dd880-f902-aa9c-67d5-2d582a29e122@univention.de>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
dlp-product: dlpe-windows
dlp-version: 11.6.100.41
dlp-reaction: no-action
authentication-results: univention.de; dkim=none (message not signed)
 header.d=none;univention.de; dmarc=none action=none header.from=intel.com;
x-originating-ip: [97.115.165.120]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 550a564b-f2f2-49db-a8d3-08d93b2a93df
x-ms-traffictypediagnostic: BY5PR11MB3975:
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-microsoft-antispam-prvs: <BY5PR11MB39755464B8C61B4A0923652CEF029@BY5PR11MB3975.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:6430;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: Q6Kdia+E095e7PQ2kC82sA/5aVKH9IgLAWHLGSEtHCiwoxT0tkY1qW4gQnBNNz4OeAJ37QvpULOGZGnXj/ClUXlgL1cA057QrO7z+AI8eiTSEwRmBTPfH64j7pFNIx1D7aP2+P2QSP7+0wy742EZTng8p7NMMJUpbB5DwgVliiK/oBFgaHpozc6zG/VV2zA+tmVBwdrlnUehC9SP9QMOXYV+Bt8xI3QFmfYigTggezbpv/2+6Sjv4U+mXs1BzOeMpch2ZyQj/SAjUV8sWxrlSCEWdESvGqz/YFhRJ8xvoD6NQArq5n92BhmjJOSb10BZ4/Pmb7eWJeL+jEffHUy2jeJeyNTF6ZWQ8lgUO7eN70SP2CQQuFDgYfMrGejBmSviD2YWjejZfDjKV0h0IJJnrBrmxhvK0ia6LtO+/ukEf0XG8xEC363Yx0H5z6oQZMMegnV2py+OnGaB01VHJgGIrgJhz1tZF80/7lYW6P/nGPpyxoe4xI7mT5u1/S4x8OsaHKshRe1QUo7s88u03ekrl0xYYCq3xdBxHIn0BlCst1A1oLOJcjbiYbaAJELPUwHyz6Ejud0e2ZHUrYFJsQaPnhMJnd7wb8oTBFEOHnTL+Km6ayuOwgeIyF2yzQog+jEFhmwPdAqV+RhJNR3BTK42poOmredL42E7M1qoh9aRwzHM0LZcwakEfFM+6huJN21NLWxzcUmp2hKXeu9Glkgcrvb4ppRlpxisXT5cmuLmmCAQdDSbuSJforcZG++kjXD+IaStl/bd5ZhqVWImYQiIbA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR11MB3606.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(396003)(136003)(346002)(376002)(39860400002)(366004)(86362001)(26005)(76116006)(2906002)(4326008)(9686003)(71200400001)(55016002)(8676002)(186003)(7696005)(54906003)(53546011)(66946007)(38100700002)(64756008)(316002)(478600001)(66574015)(52536014)(8936002)(5660300002)(966005)(110136005)(66556008)(6506007)(33656002)(66446008)(122000001)(66476007)(83380400001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?emYydFJoZUE2UFdUaTd0ajZTZ3BsbnhJTFlGMmNmU0svQWs2aEZWNnlkZmpF?=
 =?utf-8?B?WWpHMnZKVlFOaVBzTjBTM0hhK3RUU1QycUUyK2ttaUM1d29ZYzdaL1VXNjc1?=
 =?utf-8?B?TU1ac2IzYVlCWXhINzdSOFpZL1B4NjZtSkRhNE5IOTZxeFltMU9VNm9jaHZu?=
 =?utf-8?B?ZHF6YStBUjJ2YkpXVW9kbitBL0t3b3k3S0FaZnVIaXJsNEZxMmhXVnlrM1Jj?=
 =?utf-8?B?U0ZoMnZZQ3h4SjZVclovWE9ycE5ac2wrU1RYa2pPbVl3VzhYWjY4a2VtckNm?=
 =?utf-8?B?QnZTc1Fzdnc1T0M3dHk1QzJiQnZGQ2cydGJldlNFdi9lQnlPZGI4VmZIM0RB?=
 =?utf-8?B?U3NteVRrTGJoSDhXaTIwMzFGdnd0ZlJrREh4Tlkxd091dDNiRUJHS05iMytt?=
 =?utf-8?B?NGFJZ1pJVUFHcWlDWnN3ZWxrdUsra0s1WTZHQW0rVGtWL3dZNXBxZmJkUzQy?=
 =?utf-8?B?RllzbXhnekwxOUNIK2JiWjhCWDhrQ1pIZC9iOFNBYURkZlcxWHdhMzZEUXVH?=
 =?utf-8?B?d0FlRTZYQmRTTVV0dDJseXlXaUd1RmpoMm4zbHhUYVpYdmptcjQyL0pQUFlo?=
 =?utf-8?B?dW1jRXFibWNEdU1JeVBGanRySUw5ZGJ5aWxkUURVaGhiKzFOajZFRllhUlRw?=
 =?utf-8?B?UkpPbjJlYlFnTVBUeEMwTDk2MnNmM0ZNU0hsOGNuQ01xN2tSU2VlTDBzRjJY?=
 =?utf-8?B?Q1lvaDR5NHFxMHBtSnQxcVUrTXI3V0xyVXZwSEZKVmpBUm1CTEZKNXBZRW1J?=
 =?utf-8?B?aFVZUmtYeXRwQnYycmZaV21EMk5ZVzMzditsbkxiUzVTa1J1ZXoySkZ6U0Z2?=
 =?utf-8?B?UzJtaVlSd1hNTGFpNlc2Zkh0NW9Hanpqd3BkbWc0eG1mdzdFdmUzYWZMZDVs?=
 =?utf-8?B?V3hRRDVLdFpBTWg3VVlOVDQ5NkpMc1VwZytPRUJ0TUpobVcvMlpudnBzR0NB?=
 =?utf-8?B?bWlEOGsydkt6Tk1wVk1lMXN6d2tVQ01OUlk5TEpVbi82dHU2emRQVkk3Mm1h?=
 =?utf-8?B?T2NzSG9vVFJCZEx5aHk3Nm84RWF2L3l5RFozb3MrQW5yOEY2WFUwSTdIMXp0?=
 =?utf-8?B?WTFMejhLZzV2ZUs2OXllOURNbXhHM00xQUhNamJ6bUJWQmhJdExHQ05VaUUz?=
 =?utf-8?B?dURMbDZieXUrNG13U1luc1FQNXF4eERVa2pUTnBteHdPSGgzd3pGekF5MVMz?=
 =?utf-8?B?NlMvOEFaSjExbFpabFl1QzFhOEpmL29iZ0V5U1gvSHNrWmpYVnpJVXA0TFZk?=
 =?utf-8?B?ZmQraENPTllWUEUydVBiVHRQOURSUzJCVDRUd3draVRKaUx5d1d4TEJtQ09Y?=
 =?utf-8?B?YjZxNyswZyttWmtrZEVyMmNaK1RuTmdaMm4vMVN1emFUZUkrSlJPWm53bTJ1?=
 =?utf-8?B?REZKZGdZdkJFZ013V2pBSGduN21PQlFCT1dRWTBtUk9BdU10K2FKMk0xdlor?=
 =?utf-8?B?OFNUTXY2QzhGM1F0bTBYMU5OSkwwZENnNWdVbjlYM0N5c3RrMElrc0Vub1Vl?=
 =?utf-8?B?clR2U3Exa3dMeGpmNkpHMXRZMUhyOW5hUmQvL29KRWZuMmlMQ3ZXTkhJK0ZF?=
 =?utf-8?B?aFlRb24zQ3diSHM1MTJ3Y0VQbDRWeEJFNEJlY1FUU1pHb2I2eG9YMk03WCs4?=
 =?utf-8?B?QjZzTmNUUkNJN1d5LzVsMTF2NVJTYjhSa0VLYWgvUndHMkp1eGxuQ2M1MEp0?=
 =?utf-8?B?ZXZpNkExS3Jhb2xhbTZVbEVNS1BnUVdMWmhDQkpqMHRSSTFWbXVybFlBSlhK?=
 =?utf-8?Q?/xmey+NuDGMMcXZknQb5ypFlmiDutoR9K7ljRHX?=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BYAPR11MB3606.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 550a564b-f2f2-49db-a8d3-08d93b2a93df
X-MS-Exchange-CrossTenant-originalarrivaltime: 29 Jun 2021 18:20:30.4080
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: YRroxjgKg9l2poQWwDOWE1bpknHwIhDyNitV8Ws62EX1IwWesca4i6GfQQ03cAZqwo78GqY+Lyqs/NcTDELIfQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR11MB3975
X-OriginatorOrg: intel.com
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

SSB0aGluayBJIGFjY2lkZW50YWxseSBkZWxldGVkIHRoZSBmb3J3YXJkIGZyb20gdGhlIGludGVs
LXdpcmVkLWxhbiBzcGFtIGZpbHRlci4gUmUtZm9yd2FyZGluZyBhbmQgYWRkaW5nIEFsZXgncyBn
bWFpbCBhZGRyZXNzLg0KDQpBbHNvLCANCg0KVG9kZCBGdWppbmFrYQ0KU29mdHdhcmUgQXBwbGlj
YXRpb24gRW5naW5lZXINCkRhdGEgQ2VudGVyIEdyb3VwDQpJbnRlbCBDb3Jwb3JhdGlvbg0KdG9k
ZC5mdWppbmFrYUBpbnRlbC5jb20NCg0KLS0tLS1PcmlnaW5hbCBNZXNzYWdlLS0tLS0NCkZyb206
IFBoaWxpcHAgSGFobiA8aGFobkB1bml2ZW50aW9uLmRlPiANClNlbnQ6IFR1ZXNkYXksIEp1bmUg
MjIsIDIwMjEgMTE6MTkgQU0NClRvOiBzdGFibGVAdmdlci5rZXJuZWwub3JnOyA4OTIxMDVAYnVn
cy5kZWJpYW4ub3JnOyBCZW4gSHV0Y2hpbmdzIDxiZW5oQGRlYmlhbi5vcmc+DQpDYzogQWxleGFu
ZGVyIER1eWNrIDxhbGV4YW5kZXIuaC5kdXlja0BpbnRlbC5jb20+OyBBbmRyZXcgQm93ZXJzIDxh
bmRyZXd4LmJvd2Vyc0BpbnRlbC5jb20+OyBCb25hY2NvcnNvLCBTYWx2YXRvcmUgPGNhcm5pbEBk
ZWJpYW4ub3JnPg0KU3ViamVjdDogQ2hlcnJ5LXBpY2sgImk0MGU6IEJlIG11Y2ggbW9yZSB2ZXJi
b3NlIGFib3V0IHdoYXQgd2UgY2FuIGFuZCBjYW5ub3Qgb2ZmbG9hZCINCg0KSGVsbG8sDQoNCkkg
cmVxdWVzdCB0aGUgZm9sbG93aW5nIHBhdGNoIGZyb20gdjQuMTAtcmMxIHRvIGdldCBjaGVycnkt
cGlja2VkIGludG8NCiJzdGFibGUvbGludXgtNC45LnkiOg0KDQo+IGNvbW1pdCBmMTE0ZGNhMjUz
M2NhNzcwYWViZWJmZmI1ZWQ1NmU1ZTdkMWZiM2ZiDQo+IEF1dGhvcjogQWxleGFuZGVyIER1eWNr
IDxhbGV4YW5kZXIuaC5kdXlja0BpbnRlbC5jb20+DQo+IERhdGU6ICAgVHVlIE9jdCAyNSAxNjow
ODo0NiAyMDE2IC0wNzAwDQo+IA0KPiAgICAgaTQwZTogQmUgbXVjaCBtb3JlIHZlcmJvc2UgYWJv
dXQgd2hhdCB3ZSBjYW4gYW5kIGNhbm5vdCBvZmZsb2FkDQo+ICAgICANCj4gICAgIFRoaXMgY2hh
bmdlIG1ha2VzIGl0IHNvIHRoYXQgd2UgYXJlIG11Y2ggbW9yZSByb2J1c3QgYWJvdXQgZGVmaW5p
bmcgd2hhdCB3ZQ0KPiAgICAgY2FuIGFuZCBjYW5ub3Qgb2ZmbG9hZC4gIFByZXZpb3VzbHkgd2Ug
d2VyZSBqdXN0IGNoZWNraW5nIGZvciB0aGUgTDQgdHVubmVsDQo+ICAgICBoZWFkZXIgbGVuZ3Ro
LCBob3dldmVyIHRoZXJlIGFyZSBvdGhlciBmaWVsZHMgd2Ugc2hvdWxkIGJlIHZlcmlmeWluZyBh
cw0KPiAgICAgdGhlcmUgYXJlIG11bHRpcGxlIHNjZW5hcmlvcyBpbiB3aGljaCB3ZSBjYW5ub3Qg
cGVyZm9ybSBoYXJkd2FyZSBvZmZsb2Fkcy4NCj4gICAgIA0KPiAgICAgSW4gYWRkaXRpb24gdGhl
IGRldmljZSBvbmx5IHN1cHBvcnRzIEdTTyBhcyBsb25nIGFzIHRoZSBNU1MgaXMgNjQgb3INCj4g
ICAgIGdyZWF0ZXIuICBXZSB3ZXJlIG5vdCBjaGVja2luZyB0aGlzIHNvIGFuIE1TUyBsZXNzIHRo
YW4gdGhhdCB3YXMgcmVzdWx0aW5nDQo+ICAgICBpbiBUeCBoYW5ncy4NCj4gICAgIA0KPiAgICAg
Q2hhbmdlLUlEOiBJNWUyZmQ1ZjMwNzVjNzM2MDFiNGIzNjMyN2I3NzFjNjRmY2I2YzMxYg0KPiAg
ICAgU2lnbmVkLW9mZi1ieTogQWxleGFuZGVyIER1eWNrIDxhbGV4YW5kZXIuaC5kdXlja0BpbnRl
bC5jb20+DQo+ICAgICBUZXN0ZWQtYnk6IEFuZHJldyBCb3dlcnMgPGFuZHJld3guYm93ZXJzQGlu
dGVsLmNvbT4NCg0KRGViaWFuIGhhZCB0aGlzIG9sZCBCdWcNCjxodHRwczovL2J1Z3MuZGViaWFu
Lm9yZy9jZ2ktYmluL2J1Z3JlcG9ydC5jZ2k/YnVnPTg5MjEwNT4gcmVwb3J0ZWQgYWdhaW5zdCA0
LjkuODIsIHdoaWNoIHN0aWxsIGV4aXN0cyBpbiBEZWJpYW5zIG9sZC1zdGFibGUgOSAiU3RyZXRj
aCIgDQpjdXJyZW50IGtlcm5lbCA0LjkuMjU4LCBidXQgYWxzbyB3aXRoIGxhdGVzdCBzdGFibGUg
NC45LjI3My4NCg0KDQpPdXIgZW52aXJvbm1lbnQNCj09PT09PT09PT09PT09PQ0KLSBLVk0gc2Vy
dmVyDQotIGR1YWwgcG9ydCBpNDBlDQotIGNsYXNzaWMgYnJpZGdlIHdpdGggZW5wOTZzMGYwDQot
IFZNIGF0dGFjaGVkIHRvIGJyaWRnZSB2aWEgdmV0aA0KLSBubyBWTEFOcw0KLSBubyBNYWNWTGFu
DQoNCj4gIyBldGh0b29sIC1pIGVucDk2czBmMA0KPiBkcml2ZXI6IGk0MGUNCj4gdmVyc2lvbjog
MS42LjE2LWsNCj4gZmlybXdhcmUtdmVyc2lvbjogMy4zMyAweDgwMDAwZTQ4IDEuMTg3Ni4wDQo+
IGV4cGFuc2lvbi1yb20tdmVyc2lvbjogDQo+IGJ1cy1pbmZvOiAwMDAwOjYwOjAwLjANCj4gc3Vw
cG9ydHMtc3RhdGlzdGljczogeWVzDQo+IHN1cHBvcnRzLXRlc3Q6IHllcw0KPiBzdXBwb3J0cy1l
ZXByb20tYWNjZXNzOiB5ZXMNCj4gc3VwcG9ydHMtcmVnaXN0ZXItZHVtcDogeWVzDQo+IHN1cHBv
cnRzLXByaXYtZmxhZ3M6IHllDQoNCj4gIyBsc3BjaSAtcyAwMDAwOjYwOjAwLjANCj4gNjA6MDAu
MCBFdGhlcm5ldCBjb250cm9sbGVyOiBJbnRlbCBDb3Jwb3JhdGlvbiBFdGhlcm5ldCBDb25uZWN0
aW9uIA0KPiBYNzIyIGZvciAxMEdCQVNFLVQgKHJldiAwOSkNCg0KDQpBbmFseXNpcw0KPT09PT09
PT0NCkFzIHNvb24gYXMgd2Ugc3RhcnQgb25lIG9mIG91ciAiVWJ1bnR1IiBpbWFnZXMgdGhlIGJy
aWRnZSBzdG9wcyByZWNlaXZpbmcgdW5pY2FzdCBwYWNrYWdlcyBmb3IgKmFsbCogVk1zIG9uIHRo
YXQgYnJpZGdlLg0KLSB3ZSBzdGlsbCBzZWUgb3V0Z29pbmcgdHJhZmZpYyBsZWF2aW5nIHRoZSBo
b3N0LCBlLmcuIEFSUCByZXF1ZXN0cw0KLSAidGNwZHVtcCAtaSBlbnA5NnMwZjAiIHNob3dzIG5v
IGluY29taW5nIHVuaWNhc3QgdHJhZmZpYywgZS5nLiBubyBBUlAgcmVzcG9uc2UNCi0gYnJvYWRj
YXN0IHRyYWZmaWMgcGFzc2VzIHRoZSBicmlkZ2UNCi0gVk1zIG9uIHRoZSBzYW1lIGJyaWRnZSBj
YW4gY29tbXVuaWNhdGUgd2l0aCBlYWNoIG90aGVyDQoNCk1vc3Qgb2Z0ZW4gSSBzZWUgdGhlIGZv
bGxvd2luZyBlcnJvciBtZXNzYWdlIGFmdGVyIGRvaW5nIGBkbWVzZyAtbiA4YDoNCj4gWyAgKzks
Mzc2MzY3XSBpNDBlIDAwMDA6NjA6MDAuMDogY2xlYXJlZCBQRV9DUklURVJSIFsgICswLDAwMDI1
Ml0gaTQwZSANCj4gMDAwMDo2MDowMC4wOiBUWCBkcml2ZXIgaXNzdWUgZGV0ZWN0ZWQsIFBGIHJl
c2V0IGlzc3VlZCBbICArMCw4NTk5MTJdIA0KPiBpNDBlIDAwMDA6NjA6MDAuMDogRXJyb3IgSTQw
RV9BUV9SQ19FSU5WQUwgYWRkaW5nIFJYIGZpbHRlcnMgb24gUEYsIA0KPiBwcm9taXNjdW91cyBt
b2RlIGZvcmNlZCBvbg0KDQpJbiBvbmUgY2FzZSBJJ3ZlIHNlZW4gdGhpcyBhbHNvIChkb24ndCBr
bm93IGlmIGl0IGlzIHJlbGV2YW50KToNCj4gWyAgMjE4LjkyMTQ2Nl0gaTQwZSAwMDAwOjYwOjAw
LjAgZW5wOTZzMGYwOiBWU0lfc2VpZCAzOTAsIEh1bmcgVFggDQo+IHF1ZXVlIDQzLCB0eF9wZW5k
aW5nX2h3OiAxLCBOVEM6MHhhNiwgSFdCOiAweGE2LCBOVFU6IDB4YTcsIFRBSUw6IDB4YTcgDQo+
IFsgIDIxOC45MjE0NzBdIGk0MGUgMDAwMDo2MDowMC4wIGVucDk2czBmMDogVlNJX3NlaWQgMzkw
LCBJc3N1aW5nIA0KPiBmb3JjZV93YiBmb3IgVFggcXVldWUgNDMsIEludGVycnVwdCBSZWc6IDB4
MA0KDQpBZnRlciB0aGF0IGVycm9yIHRoZSBvbmx5IHdheSB0byByZXNldCB0aGlzIGJyb2tlbiBz
dGF0ZSBpdCB0byByZWJvb3QgdGhlIGhvc3QuIEkndmUgYmVlbiB1bmFibGUgdG8gdGVhciBkb3du
IHRoZSBicmlkZ2UgYW5kL29yIHJlbW92ZSB0aGUgYGk0MGVgIGRyaXZlciwgd2hpY2ggbW9zdCBv
ZnRlbiBjcmFzaGVzIHRoZSBMaW51eCBrZXJuZWwgKHNvbWUgb3RoZXIgYnVnIG9uIGBpcCBsaW5r
IHNldCBlbnA5NnMwZjAgbm9tYXN0ZXJgKS4NCg0KSWYgeW91IG5lZWQgbW9yZSBkYXRhIEkgaGF2
ZSBhIFBDQVAgZmlsZSwgYnV0IEkgc3RpbGwgZG9uJ3Qga25vdyB3aGljaCBwYWNrZXQgZXhhY3Rs
eSB0cmlnZ2VycyB0aGUgYnVnLg0KDQoNClRoZSBidWdzIHNlZW1zIHRvIGJlIGZpeGVkIHdpdGgg
NC4xMC4wIGFuZCBJIGJpc2VjdGVkIGl0IGRvd24gdG8NCg0KPiBnaXQgYmlzZWN0IHN0YXJ0ICct
LScgJ2RyaXZlcnMvbmV0L2V0aGVybmV0L2ludGVsL2k0MGUnDQo+ICMgbmV3OiBbYzQ3MGFiZDRm
ZGU0MGVhNmEwODQ2YTJiZWFiNjQyYTU3OGMwYjhjZF0gTGludXggNC4xMA0KPiBnaXQgYmlzZWN0
IG5ldyBjNDcwYWJkNGZkZTQwZWE2YTA4NDZhMmJlYWI2NDJhNTc4YzBiOGNkDQo+ICMgb2xkOiBb
Njk5NzNiODMwODU5YmM2NTI5YTdhMDQ2OGJhMGQ4MGVlNTExNzgyNl0gTGludXggNC45DQo+IGdp
dCBiaXNlY3Qgb2xkIDY5OTczYjgzMDg1OWJjNjUyOWE3YTA0NjhiYTBkODBlZTUxMTc4MjYNCj4g
IyBvbGQ6IFsxM2ZkM2Y5Y2MzZGVmOGIyNzZjNzkxM2FlNGFjYmZhMjY1M2NiMTk4XSBpNDBlOiBj
bGVhciBtYWMgZmlsdGVyIGNvdW50IG9uIHJlc2V0DQo+IGdpdCBiaXNlY3Qgb2xkIDEzZmQzZjlj
YzNkZWY4YjI3NmM3OTEzYWU0YWNiZmEyNjUzY2IxOTgNCj4gIyBuZXc6IFs3ZWM5YmExMWIwNDZi
NGI3ZmQ3NjhjMzY2ODcwYWRhNjBkNDA5Mjk1XSBpNDBlOiBEcml2ZXIgcHJpbnRzIGxvZyBtZXNz
YWdlIG9uIGxpbmsgc3BlZWQgY2hhbmdlDQo+IGdpdCBiaXNlY3QgbmV3IDdlYzliYTExYjA0NmI0
YjdmZDc2OGMzNjY4NzBhZGE2MGQ0MDkyOTUNCj4gIyBuZXc6IFswYjdjOGI1ZDU0MzYzMTdhNWY0
NTA5ZTJhMTUwYzZjZWMwMTdmMzQ4XSBpNDBlOiBmaXggdHJpdmlhbCB0eXBvIGluIG5hbWluZyBv
ZiBpNDBlX3N5bmNfZmlsdGVyc19zdWJ0YXNrDQo+IGdpdCBiaXNlY3QgbmV3IDBiN2M4YjVkNTQz
NjMxN2E1ZjQ1MDllMmExNTBjNmNlYzAxN2YzNDgNCj4gIyBuZXc6IFtmMTE0ZGNhMjUzM2NhNzcw
YWViZWJmZmI1ZWQ1NmU1ZTdkMWZiM2ZiXSBpNDBlOiBCZSBtdWNoIG1vcmUgdmVyYm9zZSBhYm91
dCB3aGF0IHdlIGNhbiBhbmQgY2Fubm90IG9mZmxvYWQNCj4gZ2l0IGJpc2VjdCBuZXcgZjExNGRj
YTI1MzNjYTc3MGFlYmViZmZiNWVkNTZlNWU3ZDFmYjNmYg0KPiAjIG9sZDogWzgxZmE3Yzk3YmVi
ZDZlMWE1MmM0ZTA1OWVlZmZlMThkZjViM2YxMWZdIGk0MGU6IEltcGxlbWVudGF0aW9uIG9mIEVS
Uk9SIHN0YXRlIGZvciBOVk0gdXBkYXRlIHN0YXRlIG1hY2hpbmUNCj4gZ2l0IGJpc2VjdCBvbGQg
ODFmYTdjOTdiZWJkNmUxYTUyYzRlMDU5ZWVmZmUxOGRmNWIzZjExZg0KPiAjIG9sZDogWzNhYTdi
NzRkYmVlZGZiMzI0MDZmZWM3MGNmZDc2ZDc5NzIwOWU4YzldIGk0MGU6IHJlbW92ZWQgdW5yZWFj
aGFibGUgY29kZQ0KPiBnaXQgYmlzZWN0IG9sZCAzYWE3Yjc0ZGJlZWRmYjMyNDA2ZmVjNzBjZmQ3
NmQ3OTcyMDllOGM5DQo+ICMgZmlyc3QgbmV3IGNvbW1pdDogW2YxMTRkY2EyNTMzY2E3NzBhZWJl
YmZmYjVlZDU2ZTVlN2QxZmIzZmJdIGk0MGU6IEJlIG11Y2ggbW9yZSB2ZXJib3NlIGFib3V0IHdo
YXQgd2UgY2FuIGFuZCBjYW5ub3Qgb2ZmbG9hZA0KDQpJIHVzZWQgdjQuMTAgYXMgdGhlIGJhc2lz
IGFuZCBvbmx5IGJpc2VjdGVkIGV2ZXJ5dGhpbmcgaW4gDQpkcml2ZXJzL25ldC9ldGhlcm5ldC9p
bnRlbC9pNDBlLyBhcyB2YW5pbGxhIHY0LjkgYW5kIHNldmVyYWwgb3RoZXIgDQp2ZXJzaW9ucyBi
ZXR3ZWVuIHRoYXQgYW5kIHY0LjEwIGNyYXNoZWQgbXkgaG9zdCwgc28gYmFzaWNhbGx5DQogICBn
aXQgY2hlY2tvdXQgdjQuMTANCiAgIGdpdCBjaGVja291dCAkaGFzaCAtLSBkcml2ZXJzL25ldC9l
dGhlcm5ldC9pbnRlbC9pNDBlLw0KICAgbWFrZSBhbGwgbW9kdWxlc19pbnN0YWxsIGluc3RhbGwN
CiAgIGdpdCBjaGVja291dCB2NC0xMCAtLSBkcml2ZXJzL25ldC9ldGhlcm5ldC9pbnRlbC9pNDBl
Lw0KICAgZ2l0IGJpc2VjdCAob2xkfG5ldykgJGhhc2gNCg0KSSB2ZXJpZmllZCB0aGF0IGNoZXJy
eS1waWNraW5nIGYxMTRkY2EyNTMzY2E3NzBhZWJlYmZmYjVlZDU2ZTVlN2QxZmIzZmIgDQpvbiB0
b3Agb2YgdjQuOS4yNzMgZml4ZXMgdGhlIHByb2JsZW0gYW5kIHJldmVydGluZyBpdCBhZ2FpbiBz
aG93cyB0aGUgDQpwcm9ibGVtIGFnYWluLg0KDQpQaGlsaXBwDQotLSANClBoaWxpcHAgSGFobg0K
T3BlbiBTb3VyY2UgU29mdHdhcmUgRW5naW5lZXINCg0KVW5pdmVudGlvbiBHbWJIDQpiZSBvcGVu
Lg0KTWFyeS1Tb21lcnZpbGxlLVN0ci4gMQ0KRC0yODM1OSBCcmVtZW4NCg0K8J+TniArNDktNDIx
LTIyMjMyLTU3DQrwn5a2ICs0OS00MjEtMjIyMzItOTkNCg0K4pyJ77iPIGhhaG5AdW5pdmVudGlv
bi5kZQ0K8J+MkCBodHRwczovL3d3dy51bml2ZW50aW9uLmRlLw0KDQpHZXNjaMOkZnRzZsO8aHJl
cjogUGV0ZXIgSC4gR2FudGVuDQpIUkIgMjA3NTUgQW10c2dlcmljaHQgQnJlbWVuDQpTdGV1ZXIt
TnIuOiA3MS01OTctMDI4NzYNCg==
