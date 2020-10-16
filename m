Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BC65828FF90
	for <lists+stable@lfdr.de>; Fri, 16 Oct 2020 09:55:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404888AbgJPHz3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 16 Oct 2020 03:55:29 -0400
Received: from alln-iport-1.cisco.com ([173.37.142.88]:56361 "EHLO
        alln-iport-1.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2404826AbgJPHz2 (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 16 Oct 2020 03:55:28 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=cisco.com; i=@cisco.com; l=6210; q=dns/txt; s=iport;
  t=1602834927; x=1604044527;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:mime-version;
  bh=G+8sVqnMv/pLJI+viaNOv8cVsIOrsDn4gfG05Iy9MOw=;
  b=GN8sm3oJWdMZCTYoEtUSSTPvr9yq2sOD6qtFuhVnrtn8nSKNXsXWmZou
   FhGOY9QDcXjRsqoJCgCxFV9aHsuOq/UdjTDXVMKZDn7jIt5QQsJgmE8nD
   ggbwiS6t4TKD0XuPf8R4bCOw26B4567jU7KV5EusN5uDkDLjZPyDoiisd
   c=;
X-Files: pEpkey.asc : 1813
IronPort-PHdr: =?us-ascii?q?9a23=3AKUMNYBGOTZiGjFOtSqSHIJ1GYnJ96bzpIg4Y7I?=
 =?us-ascii?q?YmgLtSc6Oluo7vJ1Hb+e401wGbWYTd9uJKjPfQv6n8WGsGp5GbvyNKfJ9NUk?=
 =?us-ascii?q?oDjsMb10wlDdWeAEL2ZPjtc2QhHctEWVMkmhPzMUVcFMvkIVGHpHq04G0WGx?=
 =?us-ascii?q?PiJQRyO+L5E5LTiMLx0Pq9qNXfZgxSj2+7ZrV/ZBy9sQTWsJwQho1vT8R5yh?=
 =?us-ascii?q?bArnZSPepMwmY9LlOIlBG67cC1r5M=3D?=
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: =?us-ascii?q?A0BVBwAuT4lf/5xdJa1gHAEBAQEBAQc?=
 =?us-ascii?q?BARIBAQQEAQGCD4FSKSgHgUkvLAqEM4NGA40jLph7glMDVQQHAQEBCgMBAS0?=
 =?us-ascii?q?CBAEBhEoCF4FxAiU4EwIDAQELAQEFAQEBAgEGBG2FXAyFcgEBAQEDEhEdAQE?=
 =?us-ascii?q?3AQ8CAQgVAyoCAgIwJQIEDQEFAgEBChSCOUsBgksDLgEDoiECgTmIYXaBMoM?=
 =?us-ascii?q?BAQEFhSUYggkHCYE4gVOBH4NuhlYbgUE/gREngjsuPoRUgwCCYJApgyeHD4F?=
 =?us-ascii?q?Mm1EKgmqETYJfkzYFBwMfgxaPTo5mjkmlEAIEAgQFAg4BAQWBayOBV3AVgyR?=
 =?us-ascii?q?QFwINjh+DcYpWdAI2AgYKAQEDCXyMOwGBEAEB?=
X-IronPort-AV: E=Sophos;i="5.77,382,1596499200"; 
   d="asc'?scan'208";a="563969916"
Received: from rcdn-core-5.cisco.com ([173.37.93.156])
  by alln-iport-1.cisco.com with ESMTP/TLS/DHE-RSA-SEED-SHA; 16 Oct 2020 07:48:22 +0000
Received: from XCH-ALN-004.cisco.com (xch-aln-004.cisco.com [173.36.7.14])
        by rcdn-core-5.cisco.com (8.15.2/8.15.2) with ESMTPS id 09G7mMsN020500
        (version=TLSv1.2 cipher=AES256-SHA bits=256 verify=FAIL);
        Fri, 16 Oct 2020 07:48:22 GMT
Received: from xhs-rtp-001.cisco.com (64.101.210.228) by XCH-ALN-004.cisco.com
 (173.36.7.14) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Fri, 16 Oct
 2020 02:48:21 -0500
Received: from xhs-aln-002.cisco.com (173.37.135.119) by xhs-rtp-001.cisco.com
 (64.101.210.228) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Fri, 16 Oct
 2020 03:48:20 -0400
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (173.37.151.57)
 by xhs-aln-002.cisco.com (173.37.135.119) with Microsoft SMTP Server (TLS) id
 15.0.1497.2 via Frontend Transport; Fri, 16 Oct 2020 02:48:20 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ED1/0YgWyXsvGJ/oMqKEugo4Y8YJ78f4SG9Tj0u3lMRn6a5HfPfp2/h3Rm6zynpI/TDcSpYUw158J5mRzQmuART1aH6r3CdormusoWqcgSRRohZt1A5Feh0950MmbaZd+YAByrbLX+OnihAbUkhr51z7lDCfoBvS1pclZ9JIOlKnrqeLHK+REj8QkCi4U8SX+4GRJEfWNnMvckJl27lGKyEC51LaNaMcq3V+hSIq3S2Uc58bLUXtLF5vZkIxuWD3N/jTj/tYhjLZhI/YHVF8r8qRfx2Q1iRn1pj5h2OXvdVLsjE/3gCKE/G+IxKad7saK1jlNCBtZatFhlHfzSSRsw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5yOeKuJ093LrV1CkdGWLZtu5RUsY3/uqnizxE7ot2D8=;
 b=JaovmsmlNaI+ZBP8+XA3K3t8VB5ZwsljFt7rAcB4DDqUdI3j4UpOhkq4zUvggwzlCrIXqakb3e4ugKUToMUJ2lqB77emPaQt82cGotXgSfBbCpm0xqVymKCjf7avhECtAZ6KTdN55klwOYXlCo3NJm453bu3jzyMMHwW4RyBnJA9L1ai5fXRHIhQ6iUFjS6/xhPtf43mvhn9tRrt4e2CxOcR0i9oo0hT67+EukBgvw6hDxUlyrefnDYdMmeVdkexLQBJHBC8/tCBAgZbgeF/f37nghE4wHXdHSVM/47kIGERSAYQj/2fpDgd9ZmHpWN6WJeMsH+/53VVr5sE7tNguQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=cisco.com; dmarc=pass action=none header.from=cisco.com;
 dkim=pass header.d=cisco.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=cisco.onmicrosoft.com;
 s=selector2-cisco-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5yOeKuJ093LrV1CkdGWLZtu5RUsY3/uqnizxE7ot2D8=;
 b=YpYewHhhc5LvGeG/Brb07fYqpeuwyCfd0zgS+uRnPo0AJVbN++ItCYyTDktgtJBum/WNw/BnJLaxJ9YAeOcE0tqicTs1e1WFMRn2RJDKmM1ux8/NXbJNlNtBe2+eXMhUHuusx4x7g0wYKqNE90k4lW2qPQRqoHEfJAs366RMDPI=
Received: from DM6PR11MB3866.namprd11.prod.outlook.com (2603:10b6:5:199::33)
 by DM6PR11MB2540.namprd11.prod.outlook.com (2603:10b6:5:c5::30) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3477.21; Fri, 16 Oct
 2020 07:48:19 +0000
Received: from DM6PR11MB3866.namprd11.prod.outlook.com
 ([fe80::c943:b491:e40e:4f02]) by DM6PR11MB3866.namprd11.prod.outlook.com
 ([fe80::c943:b491:e40e:4f02%7]) with mapi id 15.20.3477.025; Fri, 16 Oct 2020
 07:48:19 +0000
From:   "Hans-Christian Egtvedt (hegtvedt)" <hegtvedt@cisco.com>
To:     Greg KH <gregkh@linuxfoundation.org>
CC:     "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Luiz Augusto von Dentz" <luiz.von.dentz@intel.com>,
        Marcel Holtmann <marcel@holtmann.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: Re: [v5.8/bluetooth PATCH] Bluetooth: Disconnect if E0 is used for
 Level 4
Thread-Topic: [v5.8/bluetooth PATCH] Bluetooth: Disconnect if E0 is used for
 Level 4
Thread-Index: AQHWo42PA8eSz5GJ+UWkEBYQcxu8TamZ2lEA
Date:   Fri, 16 Oct 2020 07:48:19 +0000
Message-ID: <b65dadad-ff95-671e-f330-7179b5752d75@cisco.com>
References: <20201015211124.1187822-1-hegtvedt@cisco.com>
 <20201016072553.GA578349@kroah.com>
In-Reply-To: <20201016072553.GA578349@kroah.com>
Accept-Language: en-DK, en-US
Content-Language: aa
X-MS-Has-Attach: yes
X-MS-TNEF-Correlator: 
user-agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.12.1
authentication-results: linuxfoundation.org; dkim=none (message not signed)
 header.d=none;linuxfoundation.org; dmarc=none action=none
 header.from=cisco.com;
x-originating-ip: [31.45.31.45]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: a8b19ad2-2c8b-4f76-8244-08d871a7d98f
x-ms-traffictypediagnostic: DM6PR11MB2540:
x-microsoft-antispam-prvs: <DM6PR11MB2540F750F32545FA1B58064DDD030@DM6PR11MB2540.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:663;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: /rP4dwzOIx83L0/7HHIesk1yg7pYaHkERGm8jZGLBWQvFfNN044HPzdYZUDxP/rl7ZvkrkXbQ3o+xfuBT/MOlyMW2O4RrEwRPPDlv1CD7uhb30Bf86ukBi9ZayR3J2Ke8+Ku6QEnUUSg1uZxF6wVt8wddlZjj8brvZSGofDHuDywGUp8mRAWT0PWih4p8cl/asuL02TaiwRs07fl7MSr66ELeirbzojZveCN67ag+DQOv0eLEYEBCwyihVo0oO3XpxpcF5OsrDoo7KlQU51YPT66L8EeLTS6p8scpHPf29SR1oxfEoqWIfbjGcWqywgdODWY5rVso0xi/CDhiKjptDO96FtuYUFGVO6Q++NE79Rxgap3rlUAsn2dx0OBn2Vu
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR11MB3866.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(39860400002)(366004)(396003)(136003)(346002)(376002)(66946007)(99936003)(8676002)(66616009)(66476007)(91956017)(66446008)(66556008)(76116006)(26005)(478600001)(64756008)(31686004)(6512007)(53546011)(6506007)(4326008)(6486002)(5660300002)(2906002)(86362001)(6916009)(83380400001)(8936002)(2616005)(71200400001)(54906003)(316002)(36756003)(186003)(31696002)(43740500002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: iBoTFO/vRCCn4QcYts86AV2U0eE1UWeivRX5VFkhYxFrBQJV42pDhB84Wafr4KgdSs9g7r/4W9EW/mpAmRrm/ulnHkh3PqPoTsFuE0ulc4q9Tee9e/gwD5fWa8/g4n2Wo7YITyF4H8KsnYDoF85hrwsINs1j6gYEsu5KEGtBV9I/f0qGI1X+qDnnExFopdfGBlLBnNkl2erGd8yn5yavHSgkJjzyyI3XfkwWLL1QAbTAkUiwidF9STtcgq1C4omcJOT1111pbN9c/FDjl9SzwT7fiahmQX0WXhknVrpMCOA19GJmyAuyyOl4xaJy5Z2edHP3rx5NpAA3nU9SQ4H3m+p+RtgxGqGeCxRyIQI8vS5zMQDhNFijWU8c2c8M5MW9cOJ146SdDUMevXAkXJWQPHS9g1q0uZPH84IOHDnrJhwJMZKjfMgZFQ2cMvsrpxBTr4pg76LaZ9gUZyW88YHl4IjArBXqWq3HvZyPrXT6pW2jboR5/O7wUVdbkOHU8Ke/otrc/vHtVDS3m3r4DzMjLIziIEgAa4+cTwvCw6lDFwaW5lGx/+6gdUmcdZMGj9E50dWzLq2MXqS8vHrMgm6JgoMVxut0Qy+AOBa7vAoZwvAjs4gHev4kO4bbqFdfBuNNMz4DF0yvlzj/5wm5fZL3bw==
x-ms-exchange-transport-forked: True
Content-Type: multipart/mixed;
        boundary="_002_b65dadadff95671ef3307179b5752d75ciscocom_"
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM6PR11MB3866.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a8b19ad2-2c8b-4f76-8244-08d871a7d98f
X-MS-Exchange-CrossTenant-originalarrivaltime: 16 Oct 2020 07:48:19.4744
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 5ae1af62-9505-4097-a69a-c1553ef7840e
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: b0Ay98LM6TU1dl5nxtaXXLfDJ8oA3xiJN+A5Ugl0+CtO1hwfiFGI9j4ccgDMuwh9khRete8T67P36Na5iclrag==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR11MB2540
X-OriginatorOrg: cisco.com
X-Outbound-SMTP-Client: 173.36.7.14, xch-aln-004.cisco.com
X-Outbound-Node: rcdn-core-5.cisco.com
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

--_002_b65dadadff95671ef3307179b5752d75ciscocom_
Content-Type: text/plain; charset="utf-8"
Content-ID: <2B989E30DA1860419DBA361D778A5D37@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64

T24gMTYvMTAvMjAyMCAwOToyNSwgR3JlZyBLSCB3cm90ZToNCj4gT24gVGh1LCBPY3QgMTUsIDIw
MjAgYXQgMTE6MTE6MjRQTSArMDIwMCwgSGFucy1DaHJpc3RpYW4gTm9yZW4gRWd0dmVkdCB3cm90
ZToNCj4+IEZyb206IEx1aXogQXVndXN0byB2b24gRGVudHogPGx1aXoudm9uLmRlbnR6QGludGVs
LmNvbT4NCj4+DQo+PiBFMCBpcyBub3QgYWxsb3dlZCB3aXRoIExldmVsIDQ6DQo+Pg0KPj4gQkxV
RVRPT1RIIENPUkUgU1BFQ0lGSUNBVElPTiBWZXJzaW9uIDUuMiB8IFZvbCAzLCBQYXJ0IEMgcGFn
ZSAxMzE5Og0KPj4NCj4+ICAgJzEyOC1iaXQgZXF1aXZhbGVudCBzdHJlbmd0aCBmb3IgbGluayBh
bmQgZW5jcnlwdGlvbiBrZXlzDQo+PiAgICByZXF1aXJlZCB1c2luZyBGSVBTIGFwcHJvdmVkIGFs
Z29yaXRobXMgKEUwIG5vdCBhbGxvd2VkLA0KPj4gICAgU0FGRVIrIG5vdCBhbGxvd2VkLCBhbmQg
UC0xOTIgbm90IGFsbG93ZWQ7IGVuY3J5cHRpb24ga2V5DQo+PiAgICBub3Qgc2hvcnRlbmVkJw0K
Pj4NCj4+IFNDIGVuYWJsZWQ6DQo+Pg0KPj4+IEhDSSBFdmVudDogUmVhZCBSZW1vdGUgRXh0ZW5k
ZWQgRmVhdHVyZXMgKDB4MjMpIHBsZW4gMTMNCj4+ICAgICAgICAgU3RhdHVzOiBTdWNjZXNzICgw
eDAwKQ0KPj4gICAgICAgICBIYW5kbGU6IDI1Ng0KPj4gICAgICAgICBQYWdlOiAxLzINCj4+ICAg
ICAgICAgRmVhdHVyZXM6IDB4MGIgMHgwMCAweDAwIDB4MDAgMHgwMCAweDAwIDB4MDAgMHgwMA0K
Pj4gICAgICAgICAgIFNlY3VyZSBTaW1wbGUgUGFpcmluZyAoSG9zdCBTdXBwb3J0KQ0KPj4gICAg
ICAgICAgIExFIFN1cHBvcnRlZCAoSG9zdCkNCj4+ICAgICAgICAgICBTZWN1cmUgQ29ubmVjdGlv
bnMgKEhvc3QgU3VwcG9ydCkNCj4+PiBIQ0kgRXZlbnQ6IEVuY3J5cHRpb24gQ2hhbmdlICgweDA4
KSBwbGVuIDQNCj4+ICAgICAgICAgU3RhdHVzOiBTdWNjZXNzICgweDAwKQ0KPj4gICAgICAgICBI
YW5kbGU6IDI1Ng0KPj4gICAgICAgICBFbmNyeXB0aW9uOiBFbmFibGVkIHdpdGggQUVTLUNDTSAo
MHgwMikNCj4+DQo+PiBTQyBkaXNhYmxlZDoNCj4+DQo+Pj4gSENJIEV2ZW50OiBSZWFkIFJlbW90
ZSBFeHRlbmRlZCBGZWF0dXJlcyAoMHgyMykgcGxlbiAxMw0KPj4gICAgICAgICBTdGF0dXM6IFN1
Y2Nlc3MgKDB4MDApDQo+PiAgICAgICAgIEhhbmRsZTogMjU2DQo+PiAgICAgICAgIFBhZ2U6IDEv
Mg0KPj4gICAgICAgICBGZWF0dXJlczogMHgwMyAweDAwIDB4MDAgMHgwMCAweDAwIDB4MDAgMHgw
MCAweDAwDQo+PiAgICAgICAgICAgU2VjdXJlIFNpbXBsZSBQYWlyaW5nIChIb3N0IFN1cHBvcnQp
DQo+PiAgICAgICAgICAgTEUgU3VwcG9ydGVkIChIb3N0KQ0KPj4+IEhDSSBFdmVudDogRW5jcnlw
dGlvbiBDaGFuZ2UgKDB4MDgpIHBsZW4gNA0KPj4gICAgICAgICBTdGF0dXM6IFN1Y2Nlc3MgKDB4
MDApDQo+PiAgICAgICAgIEhhbmRsZTogMjU2DQo+PiAgICAgICAgIEVuY3J5cHRpb246IEVuYWJs
ZWQgd2l0aCBFMCAoMHgwMSkNCj4+IFtNYXkgOCAyMDoyM10gQmx1ZXRvb3RoOiBoY2kwOiBJbnZh
bGlkIHNlY3VyaXR5OiBleHBlY3QgQUVTIGJ1dCBFMCB3YXMgdXNlZA0KPj4gPCBIQ0kgQ29tbWFu
ZDogRGlzY29ubmVjdCAoMHgwMXwweDAwMDYpIHBsZW4gMw0KPj4gICAgICAgICBIYW5kbGU6IDI1
Ng0KPj4gICAgICAgICBSZWFzb246IEF1dGhlbnRpY2F0aW9uIEZhaWx1cmUgKDB4MDUpDQo+Pg0K
Pj4gU2lnbmVkLW9mZi1ieTogTHVpeiBBdWd1c3RvIHZvbiBEZW50eiA8bHVpei52b24uZGVudHpA
aW50ZWwuY29tPg0KPj4gU2lnbmVkLW9mZi1ieTogTWFyY2VsIEhvbHRtYW5uIDxtYXJjZWxAaG9s
dG1hbm4ub3JnPg0KPj4gKGNoZXJyeSBwaWNrZWQgZnJvbSBjb21taXQgODc0NmYxMzViYjAxODcy
ZmY0MTJkNDA4ZWExYWE5ZWJkMzI4YzFmNSkNCj4+IENjOiBzdGFibGVAdmdlci5rZXJuZWwub3Jn
ICMgNS44DQo+IA0KPiBBbnkgcmVhc29uIHlvdSBkaWRuJ3Qgc2lnbiBvZmYgb24gdGhlc2UgYmFj
a3BvcnRzPyAgWW91IHNob3VsZCB0YWtlIHRoZQ0KPiBjcmVkaXQgZm9yIHRoZW0gOikNCg0KSSBq
dXN0IGNoZXJyeS1waWNrICgtOiBJIGhhdmUgYWx3YXlzIHJlc2VydmVkIHRoZSBzaWduIG9mZiBw
YXJ0IGZvciBjb2RlDQpjaGFuZ2UuIFdpbGwgbWFrZSBhIG5vdGUgb2YgdGhhdCBmb3IgdGhlIGZ1
dHVyZS4NCg0KLS0gDQpCZXN0IHJlZ2FyZHMsIEhhbnMtQ2hyaXN0aWFuIE5vcmVuIEVndHZlZHQN
Cg==

--_002_b65dadadff95671ef3307179b5752d75ciscocom_
Content-Type: application/pgp-keys; name="pEpkey.asc"
Content-Description: pEpkey.asc
Content-Disposition: attachment; filename="pEpkey.asc"; size=1813;
	creation-date="Fri, 16 Oct 2020 07:48:19 GMT";
	modification-date="Fri, 16 Oct 2020 07:48:19 GMT"
Content-ID: <4FEAFD38A1702E4C9CDA440531F96ABA@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64

LS0tLS1CRUdJTiBQR1AgUFVCTElDIEtFWSBCTE9DSy0tLS0tDQoNCm1RRU5CRjkyUTYwQkNBRERq
dUxjNDlMSEQ2WmVsNW5xekxnclVWczRiSE94M3hlTkxRSVpGNXBIemxXa2VqMzYNCmtyRjltcFN1
TGdUamtsd2dkN2ZzNE44NHlEVllZbXZIR0l0NVpzZVRqTW53aFVodUNNY2FHNERVUEFsMk9CNHkN
CkxIUUFVY0QxdktKU2pEM21GWDYzR1hzajJTSzluTWthYmxCVDcxVXBCcUdSVVVyY2c3OVRreGg5
b3VjblU3UnQNCnUzWTZzTWhDancvU1gwWmVJb2VxU1NaZWlDS3l4OXlSZ3JiNkJGSXFWMm16QUZB
YWcyK1BZYVQ5dWs1NWlnUzgNCklhM2M0aVVxbllHeWNnQ2hYZ1NuVk91eGJwWC9LeEVsM3pmVTA3
RzZVSTRMejcwR3lDOXRKMU1kUE1tWnhwTUMNCldZYWMwQSt5SEcrTGIrQ1lNVDBvQS9yK3dZZXgz
RXBBODI1YkFCRUJBQUcwTVVoaGJuTXRRMmh5YVhOMGFXRnUNCklFNXZjbVZ1SUVWbmRIWmxaSFFn
UEdobFozUjJaV1IwUUdOcGMyTnZMbU52YlQ2SkFWUUVFd0VJQUQ0V0lRUTgNClJJdmZkUXpWN3FB
dmRvY3BqV0VUWUhyRE9RVUNYM1pEcmdJYkF3VUpBZUV6Z0FVTENRZ0hBZ1lWQ2drSUN3SUUNCkZn
SURBUUllQVFJWGdBQUtDUkFwaldFVFlIckRPWklIQ0FDQjdncXMvSVdwTkU2TlNsS2l1eSs3SkR1
ZEJaRkENCklMMVJFUlBsSU9uWkRTQm5TMkcyakkvQ25IL0NWYlAyaVdHSy9WdUx6ZUdVM2QrNy9R
VkN4U2xXd0NHUmw5SnENCnYyaXFlemxpeHNrUVJRSVdGL2t2MWxKNVJXUzRFMzRLVUxiak44WTF2
WGhwOExjRnA2WGtmMDEzSWZodHJRZlENCllLaW1zWjlvNzd6VDZJVHhiOTZsK0xabVZlWTdrNGd3
MExQbEdFZkh1N25hNFNWS05xSTd3cHMzWEZhWGVJN00NCnp6MVlvZ2oxL0l2d1ZpczM2dmtickNV
b2lVeWprSC9zRVhVdUI1amNXeXFaOGpYY2daZUN1dHlEQVNRVFJHSFgNClFPdkRoV3JFbUlZTzNl
OE9hYjg3R1ZmVXNwd1pRWnY0STdCQnVCbkZySFFFL2RTcHFzOWtFdXhxdVFFTkJGOTINClE2NEJD
QUMrd1JZZ1IxcEtuZDZWWGhRdWg1b3hqbXlLTkQ4Uy91SE9SOVVXeUZnUnBpSzhlWmFUMUdOc2ow
c1UNCnZ1ZytZcVZMekZHWG04djg4STBWVEgydU1USmw5VHUzeEo0THhuYjJsdnFiaE1wQ2UzOG1O
em1UOFh3cXJ4WjkNCms3cmx0a24vWjVBV1JoRHVoZFJORHVHWENmL0Zua1FFczIyVmpxN0JQTkZn
Z0RCakliU3VGOVRWbnMvL0FVSkUNCk9GOE1uWFhuSWdEK3dKc25maDcwcTVRbFFjRURzMkhCMEFD
R0g4NHovc3lWeGdpRGFlYklELy9SMXVzNDJyWEENCktETHZQZ2tmRDdRbUNlQ1JrRUt1SmorQWRM
U3ZFRE5jUXhZSE13eTRBTC9qd0hNM0RwYjI5WFFRdnVMcm5RckwNClpGQzE5WXVpSTFMY2RkWUFi
STM3UFV0cnhvZ0xBQkVCQUFHSkFUd0VHQUVJQUNZV0lRUThSSXZmZFF6VjdxQXYNCmRvY3BqV0VU
WUhyRE9RVUNYM1pEcmdJYkRBVUpBZUV6Z0FBS0NSQXBqV0VUWUhyRE9TbzBCLzl3RDVTYVYxQWIN
CnAvNVVuMHJvYy9nRGhteGsrT3dDcWpPKytMaEZNOVovK2grVVZYeEw1Y25MTE05NUZuQ0RWSngr
dTIyQ1dkTnQNCnNlVDFWejVHLzVlaXZ6SXA2cSt5a3pOUFpPVUxaRVNoSmpQYnRDa1FyRDFIY3NO
MTJNNXdKcm1TVFlOTXN1MC8NCkI4dDBxaVJ4WFpybi9uRlVaTXVsL2FLTmI4d0dDcVpUbWFEL1hQ
b3Z5d2c0QW5DcDRRR2JFQlJFTjJMcis3NWwNClJmSlJSMkU2MENHaUpxdEZOUjZwUG5GSmg4ajR2
dUVZS0MvY3QvRmxpRk1lTVVQWEl4YnYrUTdVUnI1all5SHUNCjVwVldrVWRvSU9ZcVc4THVsL2dZ
RUY0MTgrdGJ1Qk13TG5maDhraFBGVGhmYjlUditGY0llZmR6Uk9KTzJOTncNClJuUFNJTzBYWkll
Sw0KPU8vR1UNCi0tLS0tRU5EIFBHUCBQVUJMSUMgS0VZIEJMT0NLLS0tLS0NCg==

--_002_b65dadadff95671ef3307179b5752d75ciscocom_--
