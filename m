Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7E19528FF81
	for <lists+stable@lfdr.de>; Fri, 16 Oct 2020 09:53:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404878AbgJPHxs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 16 Oct 2020 03:53:48 -0400
Received: from alln-iport-5.cisco.com ([173.37.142.92]:52954 "EHLO
        alln-iport-5.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2404837AbgJPHxs (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 16 Oct 2020 03:53:48 -0400
X-Greylist: delayed 426 seconds by postgrey-1.27 at vger.kernel.org; Fri, 16 Oct 2020 03:53:47 EDT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=cisco.com; i=@cisco.com; l=4576; q=dns/txt; s=iport;
  t=1602834827; x=1604044427;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:mime-version;
  bh=S+psG9w9omIhWHpRbtY+5BithGPMutnmUkd7jh+D8mk=;
  b=UOpZot/6l96xa7K6w2dHWXRV15a36QfpaZ804uS5WCcSaVotksv5hKU0
   kmF+f+WrMnIOgujdsk3URnqw1u0aObEjjE0P54nFe4Q72zE+lVbaRSgdS
   s6V5q/jfO9aEtuQiMGb2TgEZT5Ht3QjM5u9DEq7z9ggdENWQxwHMY+/Ot
   8=;
X-Files: pEpkey.asc : 1813
IronPort-PHdr: =?us-ascii?q?9a23=3AwH0FxRZjYZlt86FCnPFe7Q7/LSx94ef9IxIV55?=
 =?us-ascii?q?w7irlHbqWk+dH4MVfC4el21QSXD4Ha7e9Uhe3LtazpRW0H59CGqn9ROJBPVh?=
 =?us-ascii?q?pQj8IQkkRgBcOeEkT0IbbsaDByB8VNUlJpvhTZeUhYEcrzfRve93u16zNBHh?=
 =?us-ascii?q?T5KBp7IfnzFofOjsOxkeeo9M6bbwBBnjHoZ7R0IV2/phnQsc9Dh4xkJ8NTgh?=
 =?us-ascii?q?vEq3dFYaJY32RtcFmShB37oMy3+c1u?=
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: =?us-ascii?q?A0CvBwAuT4lf/5JdJa1gHAEBAQEBAQc?=
 =?us-ascii?q?BARIBAQQEAQGCD4FSUQeBSS8sCoQzg0YDjSMIJph7glMDVQQHAQEBCgMBAS0?=
 =?us-ascii?q?CBAEBhEoCF4FxAiU4EwIDAQELAQEFAQEBAgEGBG2FXAyFcgEBAQEDEhEdAQE?=
 =?us-ascii?q?3AQ8CAQgVAyoCAgIwJQIEDQEFAgEBChSDBAGCSwMuAQOiIQKBOYhhdoEygwE?=
 =?us-ascii?q?BAQWFJRiCCQcJgTiBU4Efg26GVhuBQT+BOAyCXT6EVIMAgmCQLYMjhw+BTJt?=
 =?us-ascii?q?RCoJqhE2CX5M2BQcCAR+hSi2zLAIEAgQFAg4BAQWBayOBV3AVgyRQFwINjh8?=
 =?us-ascii?q?MFxSDOopWdAI2AgYKAQEDCXyMOwGBEAEB?=
X-IronPort-AV: E=Sophos;i="5.77,382,1596499200"; 
   d="asc'?scan'208";a="577957962"
Received: from rcdn-core-10.cisco.com ([173.37.93.146])
  by alln-iport-5.cisco.com with ESMTP/TLS/DHE-RSA-SEED-SHA; 16 Oct 2020 07:46:41 +0000
Received: from XCH-ALN-004.cisco.com (xch-aln-004.cisco.com [173.36.7.14])
        by rcdn-core-10.cisco.com (8.15.2/8.15.2) with ESMTPS id 09G7kfgg000814
        (version=TLSv1.2 cipher=AES256-SHA bits=256 verify=FAIL);
        Fri, 16 Oct 2020 07:46:41 GMT
Received: from xhs-rcd-002.cisco.com (173.37.227.247) by XCH-ALN-004.cisco.com
 (173.36.7.14) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Fri, 16 Oct
 2020 02:46:40 -0500
Received: from xhs-rcd-002.cisco.com (173.37.227.247) by xhs-rcd-002.cisco.com
 (173.37.227.247) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Fri, 16 Oct
 2020 02:46:40 -0500
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (72.163.14.9) by
 xhs-rcd-002.cisco.com (173.37.227.247) with Microsoft SMTP Server (TLS) id
 15.0.1497.2 via Frontend Transport; Fri, 16 Oct 2020 02:46:40 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=j1je/TBHLlP6HXqgmgsWrXr52K39I5ONvT0Xm9cxE8x4rkikpnm6KHXvNUmh0iSb+cYKYkq4Xna8n4UuFoktIuZdRIo2CVrNq/wtEKhTt7goTGlRhkVh6djhdVvxomE/GKY/dBUeUjElw2CSlPI/X32RL7vDuL3LFtUIDc1Mu4X95DRTJpc6MFQmV57hQJ5rF5e6+Q8M334ieAm+M3flozLD+XuLlfbHJu8GqRJ+t8otwqbOiKd13wAs0QB/dsB0VLk18Srr2cj3IgXsy0jnDW1atLztqF92KZF3uWf1XfieevTTceYAVsLWpWFzY+yKeM+LvvkIG8B2gfzCs5BMVA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=bvY3JRtOkK5ZsS2/I2BREavmd1LcUCsZbA2q8ziCgac=;
 b=CyIc/fknqznHAFtQf1Cy1mun+PSEZpI1PaZtJ5hKycJq9wSoGGsI+L+lv183sTAZ2psXauA63Vmd+lI5MS3nRCnerK/4trdzA0h/l0/aShicTI8K7XG/khGKANk4J3f+dPrKVYwYTcABcGxI41mD29CLeOde40TYtfri6GRuxKKm4HRkyzcsma5j/KrYr5fEddze4gDiIJy7iT1RF/BGmnS3KIXLPWaLtYETEJz72VHcDg8yZ8aPHkEYaKwQaKFBGhQVNQmEBgEe1QAy7GyxElH5ceAeigie6c4xv/B0YFDAq8m61HYvq/KfAAhr6cbEC5Gr2u3+4DreXAoexqQfVQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=cisco.com; dmarc=pass action=none header.from=cisco.com;
 dkim=pass header.d=cisco.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=cisco.onmicrosoft.com;
 s=selector2-cisco-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=bvY3JRtOkK5ZsS2/I2BREavmd1LcUCsZbA2q8ziCgac=;
 b=MlivOHRMxFecmQLmInhGOTwIntSnq6mNliBiVD0JsoXl6wUcieOd0LxhAIdz4LePIkuwSx9lmW/dq9rMJNhUD3IwcH6dZZ8jCaMf8lEo1/mLvLdozV+kS9pMDGN/08HvTKg/NjJfYuTyVuqxyJpZH6u4F3KxCFkzJYP4R973J+E=
Received: from DM6PR11MB3866.namprd11.prod.outlook.com (2603:10b6:5:199::33)
 by DM6PR11MB2540.namprd11.prod.outlook.com (2603:10b6:5:c5::30) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3477.21; Fri, 16 Oct
 2020 07:46:39 +0000
Received: from DM6PR11MB3866.namprd11.prod.outlook.com
 ([fe80::c943:b491:e40e:4f02]) by DM6PR11MB3866.namprd11.prod.outlook.com
 ([fe80::c943:b491:e40e:4f02%7]) with mapi id 15.20.3477.025; Fri, 16 Oct 2020
 07:46:39 +0000
From:   "Hans-Christian Egtvedt (hegtvedt)" <hegtvedt@cisco.com>
To:     Greg KH <gregkh@linuxfoundation.org>
CC:     "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Luiz Augusto von Dentz" <luiz.von.dentz@intel.com>,
        Marcel Holtmann <marcel@holtmann.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: Re: [v4.4/bluetooth PATCH 1/3] Bluetooth: Consolidate encryption
 handling in hci_encrypt_cfm
Thread-Topic: [v4.4/bluetooth PATCH 1/3] Bluetooth: Consolidate encryption
 handling in hci_encrypt_cfm
Thread-Index: AQHWo450DurQMWnTIkuvQlvgtPbczamZ2dgA
Date:   Fri, 16 Oct 2020 07:46:39 +0000
Message-ID: <41626257-e150-e2dd-c6f2-ad586ec94c14@cisco.com>
References: <20201015211225.1188104-1-hegtvedt@cisco.com>
 <20201016073234.GB578349@kroah.com>
In-Reply-To: <20201016073234.GB578349@kroah.com>
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
x-ms-office365-filtering-correlation-id: 7bcbe870-cdaf-4bd3-5b21-08d871a79e06
x-ms-traffictypediagnostic: DM6PR11MB2540:
x-microsoft-antispam-prvs: <DM6PR11MB254070FCD329BA240D7457A0DD030@DM6PR11MB2540.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:813;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: u+CqcBLgtfLentQQ57sfoKni9Jfw/OB3dWtP9rM3zvoxltWnmUsJPUAuAAXF34xh6XPrzUGVBrcqg2QTP24xUlTeU23wUOObNaEtzrjCQ5Wz3C7uhfN02hL9dkFDtl9TJ/QT5AgPnnJlTT2r+2hrvIZ+bvMfg8nAXYW/RzXkOudwj/0mg1YyBxcWWXi/zkVMp5FMFqWpNac1OmNPGqInlocDpnX5ySAdPdSUyhTtre2JWrUmOGWxDIqcfvRQyJAl/ZYq3qohp7r6DAR3isa2f2HAzQS/SkMm9s6BEM6cFCI/lFKqJqQdAbTRyz/XEqfbTaQ8mSDXu4bfS+We90k4SKXJ3v+VCt6knE7K9Jgf5UKrFFsnx9sosNGtxn22ky5X
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR11MB3866.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(39860400002)(366004)(396003)(136003)(346002)(376002)(66946007)(99936003)(8676002)(66616009)(66476007)(91956017)(66446008)(66556008)(76116006)(26005)(478600001)(64756008)(31686004)(6512007)(53546011)(6506007)(4326008)(6486002)(5660300002)(2906002)(86362001)(6916009)(83380400001)(4744005)(8936002)(2616005)(71200400001)(54906003)(316002)(36756003)(186003)(31696002)(43740500002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: 1NbUNQJjzHInS7iHnmaXJiY1VCVEgexzPG7u9RU9xfThn6ThrEEgrGmd57LW7/DmX6U0sAWXymdGRJPOsgiMQ4E1FCci/ogbRxxN6J4BfAIyX8qdOBsr+wdCnvgOWJRizC2BbfluE7Ni3Gqsp5kkXzLJAwEqbkmSm0kuqD0c/pBpLWThIAFUcY4RG+PpIbGIqIClW+60nOkfgLJbsMJdJ9TRFvAj732KV2yGIMgxhH3raj90rBuSLe7lkG66D38u4Sdw246RlBEU+gQAFUwJT7H3dZqrCE2Rf2IrBBEF9zz2H+PhopA2UVn6njbG9MYORu6cHZYcPMGA2O0tlYQJRKE6mLiX+iEF//CacQGo7fW2j4P/Hu0dn7zA1PF0kx9gMnpn0hGKs56Lwq9Ah8v7wx/nBGajeawtSMTXS5wYoGhxJAc0bNkV632z9/xV5SybSem8X26AMTylQ0kwAIu67+u1uVhnffzhhtJKnZwBMQZSugg4BRRB+Eq+bSRXnTjvQ62JqHrgXdhX1CPLHy9IFqjEUxQFAabbq08vzvi5U7YtpMuaNtm4kWTRIWu0+LbdAt+r2MytVxztJRVI3ehiAJxhuXzA9UHzZzU0oUmgej0vhNZqoGCpRu/rtAxlfrLHYnF5kEMKxDw2jfPnsOnzcw==
x-ms-exchange-transport-forked: True
Content-Type: multipart/mixed;
        boundary="_002_41626257e150e2ddc6f2ad586ec94c14ciscocom_"
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM6PR11MB3866.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7bcbe870-cdaf-4bd3-5b21-08d871a79e06
X-MS-Exchange-CrossTenant-originalarrivaltime: 16 Oct 2020 07:46:39.6319
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 5ae1af62-9505-4097-a69a-c1553ef7840e
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 1vsJkrv2lAgiAxS/2JmltZpcC/TRAZQNOBN6gHHr7RgneGbPzt5c7/dehlrrwQsJp/tJTR/ucYRbHLP3PEIY+A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR11MB2540
X-OriginatorOrg: cisco.com
X-Outbound-SMTP-Client: 173.36.7.14, xch-aln-004.cisco.com
X-Outbound-Node: rcdn-core-10.cisco.com
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

--_002_41626257e150e2ddc6f2ad586ec94c14ciscocom_
Content-Type: text/plain; charset="utf-8"
Content-ID: <2B84A33087160D4F9C6F0A548B0118A7@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64

T24gMTYvMTAvMjAyMCAwOTozMiwgR3JlZyBLSCB3cm90ZToNCj4gT24gVGh1LCBPY3QgMTUsIDIw
MjAgYXQgMTE6MTI6MjNQTSArMDIwMCwgSGFucy1DaHJpc3RpYW4gTm9yZW4gRWd0dmVkdCB3cm90
ZToNCj4+IEZyb206IEx1aXogQXVndXN0byB2b24gRGVudHogPGx1aXoudm9uLmRlbnR6QGludGVs
LmNvbT4NCj4+DQo+PiBUaGlzIG1ha2VzIGhjaV9lbmNyeXB0X2NmbSBjYWxscyBoY2lfY29ubmVj
dF9jZm0gaW4gY2FzZSB0aGUgY29ubmVjdGlvbg0KPj4gc3RhdGUgaXMgQlRfQ09ORklHIHNvIGNh
bGxlcnMgZG9uJ3QgaGF2ZSB0byBjaGVjayB0aGUgc3RhdGUuDQo+Pg0KPj4gU2lnbmVkLW9mZi1i
eTogTHVpeiBBdWd1c3RvIHZvbiBEZW50eiA8bHVpei52b24uZGVudHpAaW50ZWwuY29tPg0KPj4g
U2lnbmVkLW9mZi1ieTogTWFyY2VsIEhvbHRtYW5uIDxtYXJjZWxAaG9sdG1hbm4ub3JnPg0KPj4g
KGNoZXJyeSBwaWNrZWQgZnJvbSBjb21taXQgM2NhNDRjMTZiMGRjYzc2NGI2NDFlZTRhYzIyNjkw
OWY1YzQyMWFhMykNCj4+IENjOiBzdGFibGVAdmdlci5rZXJuZWwub3JnICMgNC40DQo+PiAtLS0N
Cj4+ICBpbmNsdWRlL25ldC9ibHVldG9vdGgvaGNpX2NvcmUuaCB8IDIwICsrKysrKysrKysrKysr
KysrKy0tDQo+PiAgbmV0L2JsdWV0b290aC9oY2lfZXZlbnQuYyAgICAgICAgfCAyOCArKystLS0t
LS0tLS0tLS0tLS0tLS0tLS0tLS0tDQo+PiAgMiBmaWxlcyBjaGFuZ2VkLCAyMSBpbnNlcnRpb25z
KCspLCAyNyBkZWxldGlvbnMoLSkNCj4gDQo+IFdoYXQgZGlmZmVycyBoZXJlIGZyb20gdGhlIG90
aGVyIHBhdGNoIHNlcmllcyB5b3Ugc2VudD8gIExvb2tzIHRoZSBzYW1lDQo+IHRvIG1lLi4uDQoN
ClBhdGNoIDEgYW5kIDIgaW4gdGhpcyBzZXJpZXMgaXMgaWRlbnRpY2FsLCBwYXRjaCAzLzMgaXMg
YWRqdXN0ZWQgdG8NCnJlc29sdmUgYSBjb25mbGljdC4gU29ycnkgSSBkaWQgbm90IG1ha2UgdGhh
dCBjbGVhcmVyLg0KDQotLSANCkJlc3QgcmVnYXJkcywgSGFucy1DaHJpc3RpYW4gTm9yZW4gRWd0
dmVkdA0K

--_002_41626257e150e2ddc6f2ad586ec94c14ciscocom_
Content-Type: application/pgp-keys; name="pEpkey.asc"
Content-Description: pEpkey.asc
Content-Disposition: attachment; filename="pEpkey.asc"; size=1813;
	creation-date="Fri, 16 Oct 2020 07:46:38 GMT";
	modification-date="Fri, 16 Oct 2020 07:46:38 GMT"
Content-ID: <305A068A3FFC6741A0704BA087076623@namprd11.prod.outlook.com>
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

--_002_41626257e150e2ddc6f2ad586ec94c14ciscocom_--
