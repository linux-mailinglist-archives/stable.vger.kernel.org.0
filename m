Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3542C586663
	for <lists+stable@lfdr.de>; Mon,  1 Aug 2022 10:32:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229936AbiHAIcr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Aug 2022 04:32:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46226 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229727AbiHAIcq (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 1 Aug 2022 04:32:46 -0400
Received: from JPN01-OS0-obe.outbound.protection.outlook.com (mail-os0jpn01on2060.outbound.protection.outlook.com [40.107.113.60])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A6E3726D6
        for <stable@vger.kernel.org>; Mon,  1 Aug 2022 01:32:44 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=jiNNiXi90DKF02lb/WK6Ccv5bN68HWIaMafP07RrgMVJnPCSgD04vReJQySBgsFwe9XJ0/LOmtT247J3oy3UGlAo8wmMM8nB/SXgnz1P2V2M/Jr4CpzIxm1VGoh2OHUZKduuBfz6fzk81TXNh40HMnEffRWUPHoqUqGyNkSfs+NbQYOmnm2k+N9XHetJkaTHKX4Ry4kKprvfPzJwrNMDeFpwHzA6LOvz5bPT7yzLv7XbNKLZzSrXz57DvntYP8LknR3KJX60bFEOC8pC5int1NHt6bNT5ZCa3FMNnKTdZUqO2X795k80/H0fv/TeJjXA6OrCTWHyYjAOL9j57z60pw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=jnAwWBC1U/CWC4jROZkHkSRhoj84nKRytDIAFBSz6UA=;
 b=e1BjasBgzlrCo37nDO7osgtjQXnFvY7RBNkMEZ2nBrA6+BHN53h3EqxkBX8ViyTtYqSPDhJMWFiH4+BerJnbIxTTsIXnwmsh8DmjTfsLoTgMMl9Vd4TVzAaB7FQhVlIhkIw0S9aLNdTk0N0uCs5EsneiPsw4cl+fZVxCrwf61t/LfFq9NIbvjaBibxpfPg2vZJ3HiG+3ybHCLeQO7rdpYKfCL8hIBvatMjIXBpvCK0iR53dxDbMisXbx4llro54cd1jVX8DrX7sDCrh+6LATOYl3GUGEzna0XZqAL91wwXvKMWxog5kwliflvk0y8SdFYPC2gM0j2DYN7VDBVcGUyQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nec.com; dmarc=pass action=none header.from=nec.com; dkim=pass
 header.d=nec.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nec.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jnAwWBC1U/CWC4jROZkHkSRhoj84nKRytDIAFBSz6UA=;
 b=MxxVeOVt38mOJgyygcQWqA8L98CKPwaA5DcWa/UHlvozBZAg+WSAhpptGKwcmlOdNQvE3KtSnDKPP9vKK+0CPt48fMEvMhpxXGuAFIKzAHRMMHikmkyuFLF1PxMu5YZ/idZYQoccEVEHoS58YfVYGH2Nqqj8il1I7f7MAwgB1bw=
Received: from TYWPR01MB8591.jpnprd01.prod.outlook.com (2603:1096:400:13c::10)
 by TYCPR01MB6014.jpnprd01.prod.outlook.com (2603:1096:400:4f::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5482.6; Mon, 1 Aug
 2022 08:32:43 +0000
Received: from TYWPR01MB8591.jpnprd01.prod.outlook.com
 ([fe80::8541:c36f:a141:ddba]) by TYWPR01MB8591.jpnprd01.prod.outlook.com
 ([fe80::8541:c36f:a141:ddba%6]) with mapi id 15.20.5482.016; Mon, 1 Aug 2022
 08:32:43 +0000
From:   =?utf-8?B?SE9SSUdVQ0hJIE5BT1lBKOWggOWPo+OAgOebtOS5nyk=?= 
        <naoya.horiguchi@nec.com>
To:     Greg KH <gregkh@linuxfoundation.org>
CC:     Naoya Horiguchi <naoya.horiguchi@linux.dev>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "david@redhat.com" <david@redhat.com>,
        "linmiaohe@huawei.com" <linmiaohe@huawei.com>,
        "liushixin2@huawei.com" <liushixin2@huawei.com>,
        "mike.kravetz@oracle.com" <mike.kravetz@oracle.com>,
        "osalvador@suse.de" <osalvador@suse.de>,
        "shy828301@gmail.com" <shy828301@gmail.com>,
        "songmuchun@bytedance.com" <songmuchun@bytedance.com>
Subject: Re: FAILED: patch "[PATCH] mm/hugetlb: separate path for hwpoison
 entry in" failed to apply to 5.18-stable tree
Thread-Topic: FAILED: patch "[PATCH] mm/hugetlb: separate path for hwpoison
 entry in" failed to apply to 5.18-stable tree
Thread-Index: AQHYpX9lBpfDr/ySzk+Fp1Np+5i9fq2Zt4IA
Date:   Mon, 1 Aug 2022 08:32:42 +0000
Message-ID: <20220801083236.GA3533582@hori.linux.bs1.fc.nec.co.jp>
References: <165919533798118@kroah.com>
 <20220801062937.GA192992@ik1-406-35019.vs.sakura.ne.jp>
 <YueMeT1huXybhx+1@kroah.com>
In-Reply-To: <YueMeT1huXybhx+1@kroah.com>
Accept-Language: ja-JP, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nec.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 465f52e1-d6f3-4ac3-c5a9-08da7398672c
x-ms-traffictypediagnostic: TYCPR01MB6014:EE_
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: wZh8E4reOpdBS9YoVwuNTBoLO63kMkfpTKfjyLvoHYDwsIi0zBqd8D02/Dk6ZyG/RpK7RWxcAU79aLPsTZn2IXX+q5qXoTAVW1S6L1ynl74DkfjDxqvjgg9wBrbA8rApCx87QllH2pSG3+YdpSrn5sYTgmnWFg4iFuhQY3P63xtBEv4rCOE+pBCy92uvBPTnkPnGEN6glo+DkIfnud+eMeWURNV9BFhE7OBHUGkv2GnRmOLLIwtOh4tTL5feEO8fzNxF/a28q7TvREyHFf1wvsKvD9t/FduoaPE9NyEYeDAOXPMYZqV81KjCVwG269dz7waOWRFTOGYED55cnoORLZTIVGi2AJkjMfYxgXEZHY59JvUToEV8vF/ZqGGHWUTr24jnCIWK/3tFBrTeBvYcLPifmeFn6tPX8ltpsSCPX1EC4q6+729m77+lvSEx9dGGqzcwYFunXH+KjwbiTwE7U6tNjOXCRoVOF14CQMYzbs4bk83aZYxtsT13ymsg08TenWbVxYCyZ2P2hThblmB+P02H6Ek4XhRee7KUxGr1HsDIsMf7qPHKbWmDhanJmjZkpnl4o/8rSft6qCmxGggckn1uxZl6rdHgh5in5YF61X/Xg68DNhRAEqVDIJ6DLUx1+D0MyXKlcxgn4t+R7xy1gNkJImgYoYcUfxOJEcoxGW9aTIPg/2wJhjsHK0Zf9LAVJ1g3b7PU7oWVAbu8BjJ989QzJ19BPUWtmzpwn9HbBBg9H1sqGoBvWVBDcIn0DMx+qFmxqrvjRl8hGwco2xOBAFQrizO827RFhlPp3dbwcfU=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:TYWPR01MB8591.jpnprd01.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(136003)(396003)(39860400002)(346002)(366004)(376002)(38070700005)(1076003)(26005)(6512007)(9686003)(186003)(83380400001)(122000001)(38100700002)(82960400001)(5660300002)(7416002)(8936002)(2906002)(478600001)(6486002)(71200400001)(55236004)(6506007)(8676002)(4326008)(41300700001)(86362001)(66476007)(76116006)(66556008)(64756008)(6916009)(66946007)(54906003)(316002)(66446008)(33656002)(85182001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?YnZGZ1RzbWJsbFhOMGc0c1pmbnU2S1paaXg4VDdyMktpdndOaEkxQzJhZkEr?=
 =?utf-8?B?NXNjTDZrK1ZFNkQ0UzlNd1FmaURkcVV0eVovb2J1Ky8zZU9QMEthZjQxNFFm?=
 =?utf-8?B?MnlSeW0yRmlTd0laN1pnRkwxSG9ZalFYVWZpSVZJUHdya1BzVnJsRmNtb015?=
 =?utf-8?B?SHNSR0pPRzR3b3J6dHZ0ZTNSdm0wbWdGSldDTG93aU8xRXdTRHdGQnUxNkpp?=
 =?utf-8?B?QXIzT2NMK2F5MWxNd1hYOWtyUjJDay9panRoODQwemVYQU12S1Zadm5TUXZY?=
 =?utf-8?B?b0lPY05pK2NSdnhxSjF1SzZkL25lWDc3WmxXclYxbm1PcUNVdkxKdTVVdWRU?=
 =?utf-8?B?Skx1UCtiMW1sS3A3SE5LcjE5WVJvdTgxYWFpYTFqc212Q0Fwd3FVQ2hkUVc1?=
 =?utf-8?B?MmhNOXg4ZytyMUxuMDhkMjRFQUJ2TS84ZGs3KzY0UEFyUHFHZVVoSVZ3eWxC?=
 =?utf-8?B?NVRGNloybS9pbnQ3Lyt3Sm1nT040YWhXMkloc3FJWTZTS20wSEVYbmhBL1Rw?=
 =?utf-8?B?WEsxYXpBbEw0MUVqQkxOR1NBT2hzNUdUWWV6dWhpNjlNMFk1c0d2U1FCLzc3?=
 =?utf-8?B?N1ozOVNzd3JLeENDRkZ1Vmp2OTk2KzgrV3JPeXl6dVdNM1M2cndPM1dJVSty?=
 =?utf-8?B?cmQybGVjMHF6NVIzWHFLT0phbWUrdTlOc1RaTEhnc3V4anQ4R2FXUUljNUhC?=
 =?utf-8?B?Z1RTS3NrbTA4OUd1ZXY0V2k2aDVuQ2krQU5tb2lsOURlUGdaZ0UwWEREQzQz?=
 =?utf-8?B?dVhBSWFDamt4c2pmU3h6TExieWpKSHNBWDdGRGg5ZGg5bSswendRdEVhWDhS?=
 =?utf-8?B?QnNlZ1FHekYvb3EyMy9zWGZLdWRTamhjNThlZ2c2eTZpU2JVcGg1TmR4UXNC?=
 =?utf-8?B?OUFvTlB0WXc1U3VHT1ZkdHFCYTlveE1zT2dIblIwdFJTNXlkdTZGYmcxWWZj?=
 =?utf-8?B?WmNmcHMwbEJSbGpqcTNBYVZ2SEh0aEorck12bjhXU1BOTEFHbCtCMFVrTS83?=
 =?utf-8?B?QTJXbExsZzZMTUJuRHhPUlFnNFBBaWw3czdHQXNFeUZKckFxQnpOS0F3QzNs?=
 =?utf-8?B?clczVFpteTR6WTZibWNqTFpjQjBtc3BHTzVjOUFuemtoOU10TjI1cVA4ZURq?=
 =?utf-8?B?S1UvVWc2TktKRGFDYldXbzVlTG1JZFc3U1JENGtvdXVxdFB3Sys4ekFtV2la?=
 =?utf-8?B?MmhET1NCdmFUSG81ZklJK2NXRFZjdFJ1MWhweFRORFFMeHNQN0kvNk9zTWY0?=
 =?utf-8?B?M3FjQm5nUE5Xc2J4OFJYZnFsOTBocjBHV0JvWW5hVlp2UHlRZXpBaU5HNlNW?=
 =?utf-8?B?UlFXVGxXQkFGSGxUWDN3aStuNjdHMm52dG85bWFyRVlsbEg5Wm9VbndtRnpL?=
 =?utf-8?B?dGNucU4zdWJKWjRmRnFuYjFlK2R6bWZPdURkUWVyUzRiSzM3NlhBVG5ycUln?=
 =?utf-8?B?Y0pRLzRaS3lqSzk4cWJ6anl4Yk1vemVlbEFXbzB1U0drTGJvM1FYd2M3blZp?=
 =?utf-8?B?c0ozYmpMbEpyVVU5R0w5N0hiekdraExDVFlzaUNNdExESVl0bHllcWJac1Q1?=
 =?utf-8?B?OXY3d29PUE1UMlJTV1hxdU41SjN3SEpvczZXZzBwaDByWnkrU0xlcWp5ZTdi?=
 =?utf-8?B?a0VlZ1Jzc1BDY01lalVSbGRINVJiU2dFUEhKQ2Q3bTZIcGEzbTZpelUrVVJO?=
 =?utf-8?B?R2FUbllLVElSNHh4UHVGbnhIM1RyckQ5MUFJR1hiTktxdjJVbGF5UzRZcFI5?=
 =?utf-8?B?QjRQVVBHVnhHZFRyVzRCRUpYTDZSc2F0dW1IaCtNYXA2cjJ2U3JaZjhTNTBO?=
 =?utf-8?B?OUJpQk0vR1F4YTZOTGlvbzhHTk55LzdOZWJhaTBGNitrN29CcmtDbjdOY05k?=
 =?utf-8?B?eGZ5UHNrWWhCbTlZeldRbDdQMDNTMFBscm02aldBN29CbTh4TFBEOTN3OHcr?=
 =?utf-8?B?SkpyT0w1YzlNYjRhb1QrS1lvZDdOUDlodDQzbjhzdzN5RkIwbnlhRldCRTNZ?=
 =?utf-8?B?dVpBRjhSdENhVzRRbGcrcStkTklpMHZydG1RZlpzajJCLzBIdTdDTE5hSlBa?=
 =?utf-8?B?a1UvWUZpb3JmVkxTT1BRWXpTVGQxRk1mOVFRN1dSVFBaZnJCQ05nS2psUlg5?=
 =?utf-8?B?bWszbDY1dndWR0RwVUR1dTFDUnBBNXdVTDlaTlRWVGUyeEx3L3dnS3c5L1gz?=
 =?utf-8?B?WXc9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <80CCB090C7344E43BA786012F2B59113@jpnprd01.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: nec.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: TYWPR01MB8591.jpnprd01.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 465f52e1-d6f3-4ac3-c5a9-08da7398672c
X-MS-Exchange-CrossTenant-originalarrivaltime: 01 Aug 2022 08:32:42.9088
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: e67df547-9d0d-4f4d-9161-51c6ed1f7d11
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 8YLE6w4hgPLahY4+oiheglF0y0VErA0QI0OggU+XRzj+w1unt3tnOF2B47HHcKEjm6Dkf22RXW0AT1bKvbmWZQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: TYCPR01MB6014
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

T24gTW9uLCBBdWcgMDEsIDIwMjIgYXQgMTA6MTk6MDVBTSArMDIwMCwgR3JlZyBLSCB3cm90ZToN
Cj4gT24gTW9uLCBBdWcgMDEsIDIwMjIgYXQgMDM6Mjk6MzdQTSArMDkwMCwgTmFveWEgSG9yaWd1
Y2hpIHdyb3RlOg0KPiA+IE9uIFNhdCwgSnVsIDMwLCAyMDIyIGF0IDA1OjM1OjM3UE0gKzAyMDAs
IGdyZWdraEBsaW51eGZvdW5kYXRpb24ub3JnIHdyb3RlOg0KPiA+ID4gDQo+ID4gPiBUaGUgcGF0
Y2ggYmVsb3cgZG9lcyBub3QgYXBwbHkgdG8gdGhlIDUuMTgtc3RhYmxlIHRyZWUuDQo+ID4gPiBJ
ZiBzb21lb25lIHdhbnRzIGl0IGFwcGxpZWQgdGhlcmUsIG9yIHRvIGFueSBvdGhlciBzdGFibGUg
b3IgbG9uZ3Rlcm0NCj4gPiA+IHRyZWUsIHRoZW4gcGxlYXNlIGVtYWlsIHRoZSBiYWNrcG9ydCwg
aW5jbHVkaW5nIHRoZSBvcmlnaW5hbCBnaXQgY29tbWl0DQo+ID4gPiBpZCB0byA8c3RhYmxlQHZn
ZXIua2VybmVsLm9yZz4uDQo+ID4gPiANCj4gPiA+IHRoYW5rcywNCj4gPiANCj4gPiBIZWxsbywN
Cj4gPiANCj4gPiBJIHVwZGF0ZWQgdGhlIHBhdGNoIGZvciA1LjE4LXN0YWJsZSwgY291bGQgeW91
IGFwcGx5IHRoaXM/DQo+IA0KPiBJIGNhbiwgYnV0IGFyZSB5b3Ugc3VyZSB5b3UgbmVlZC93YW50
IHRoaXMgZm9yIDUuMTgtc3RhYmxlPw0KPiANCj4gSSBhc2sgYmVjYXVzZSBvZiB0aGlzIGxpbmUg
aW4gdGhlIGNoYW5nZWxvZyB0ZXh0Og0KPiANCj4gPiBGaXhlczogNmMyODc2MDVmZDU2ICgibW06
IHJlbWVtYmVyIGV4Y2x1c2l2ZWx5IG1hcHBlZCBhbm9ueW1vdXMgcGFnZXMgd2l0aCBQR19hbm9u
X2V4Y2x1c2l2ZSIpDQo+IA0KPiBXaGljaCBvbmx5IHNob3dlZCB1cCBpbiA1LjE5LXJjMSBhbmQg
aXMgbm90IGJhY2twb3J0ZWQgYW55d2hlcmUuDQoNCk9LLCBTbyB3ZSBkb24ndCBoYXZlIHRvIGJh
Y2twb3J0IHRoaXMgcGF0Y2guDQoNCj4gDQo+IFNvIHdoeSBkaWQgeW91IGhhdmU6DQo+IA0KPiA+
IENjOiA8c3RhYmxlQHZnZXIua2VybmVsLm9yZz4JWzUuMThdDQo+IA0KPiBJbiB0aGUgY2hhbmdl
bG9nIGlmIHRoZSBjb21taXQgdGhpcyBmaXhlcyBpcyBub3QgaW4gNS4xOD8NCg0KSSB3cm9uZ2x5
IGp1ZGdlZCB0aGF0IDZjMjg3NjA1ZmQ1NiB3YXMgYmVmb3JlIDUuMTksIHNvcnJ5IGFib3V0IHRo
YXQuDQpQbGVhc2UgaWdub3JlIG15IGJhY2twb3J0IHJlcXVlc3QuDQoNClRoYW5rcywNCk5hb3lh
IEhvcmlndWNoaQ0KDQo+IA0KPiBjb25mdXNlZCwNCj4gDQo+IGdyZWcgay1o
