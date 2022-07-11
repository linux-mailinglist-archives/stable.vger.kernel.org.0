Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3AA085704F1
	for <lists+stable@lfdr.de>; Mon, 11 Jul 2022 16:04:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230369AbiGKOEM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 11 Jul 2022 10:04:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57200 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229973AbiGKOEK (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 11 Jul 2022 10:04:10 -0400
Received: from mailgw02.mediatek.com (unknown [210.61.82.184])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7AE97BC17
        for <stable@vger.kernel.org>; Mon, 11 Jul 2022 07:04:04 -0700 (PDT)
X-UUID: ec4e5f9f7b8641cf88a80d914529d5d5-20220711
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.1.8,REQID:c4ecb1ea-a1a1-44ed-9769-bcf7574c0235,OB:0,LO
        B:0,IP:0,URL:5,TC:0,Content:-5,EDM:0,RT:0,SF:0,FILE:0,RULE:Release_Ham,ACT
        ION:release,TS:0
X-CID-META: VersionHash:0f94e32,CLOUDID:c3421c87-57f0-47ca-ba27-fe8c57fbf305,C
        OID:IGNORED,Recheck:0,SF:nil,TC:nil,Content:0,EDM:-3,IP:nil,URL:1,File:nil
        ,QS:nil,BEC:nil,COL:0
X-UUID: ec4e5f9f7b8641cf88a80d914529d5d5-20220711
Received: from mtkmbs11n2.mediatek.inc [(172.21.101.187)] by mailgw02.mediatek.com
        (envelope-from <peter.wang@mediatek.com>)
        (Generic MTA with TLSv1.2 ECDHE-RSA-AES256-GCM-SHA384 256/256)
        with ESMTP id 1459214770; Mon, 11 Jul 2022 22:03:59 +0800
Received: from mtkmbs10n2.mediatek.inc (172.21.101.183) by
 mtkmbs10n1.mediatek.inc (172.21.101.34) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.792.15; Mon, 11 Jul 2022 22:03:58 +0800
Received: from APC01-TYZ-obe.outbound.protection.outlook.com (172.21.101.239)
 by mtkmbs10n2.mediatek.inc (172.21.101.183) with Microsoft SMTP Server id
 15.2.792.3 via Frontend Transport; Mon, 11 Jul 2022 22:03:57 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=nWO7+1MeXg6PIcZklfQatKhBYwHO398j/m86zgCDTUzOy5+lTujncjn+1B8y6t/ZQnZK57DaRvpH2ud04FnIoNSyJuD1zAznkAe2QjHI4ciw3MrvhkLKA2YiTC6q4+c5bvkymz5h3uGgr7evaPdZMbf4veGskjcGDTTzmYSUYUm645i3h1OizSx5rg6lmbW2CN3+GuvFY7meVbNt7JAwCwmId8VcKONXt0ko4zTM5PdWniZVH8UWFBP5Ee5DhYF5w53g25hxIEDfR4hu0oeg3x02cOZ1TkrPyD4iFwxQ+u/1rItfqvjZ+hpI9VHPwICHtuVc0ptE5cxMWnjA3AlSCw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Ljn5dD1rNcivS3lwsy7J+9TckrwjkfvLuXdB4PlIz8M=;
 b=Z0asGUv3lEpwjnnJL48OES8KDUv4msxCIzYj9STp9x+EdyDwpZ//QzbJwehMDW1XGi3Fe+XyWsSQ6Ph3xOLHFr5NIvtTqCWX8DVfH8BfRI1ltWxq9mPmoRLeRbbx0L0ChoU/mceEA5BUi/a0TgzH2S4VjBd5hb5II+Yk2qtc6cArVnw+P9FXkljDVl/JUUZaW/FBf6avxXegGjGFo875JCN2n4EiGXjZe3cN3YJFobZc5Q/LURONDBBv7WPAtTM8jRFGcgVt+LKdnSlHVxUgJ5w4CWJPFTuFQEwEvgQLLFdkCCZwCILWZiEMvmruOI9r803aufeyHrqHhP5xfk+NeQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mediatek.com; dmarc=pass action=none header.from=mediatek.com;
 dkim=pass header.d=mediatek.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=mediateko365.onmicrosoft.com; s=selector2-mediateko365-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Ljn5dD1rNcivS3lwsy7J+9TckrwjkfvLuXdB4PlIz8M=;
 b=rDtZsu1T11z5/IBjihoGl+zC1dUOvrK+V0xGaNnPvoA+BrBikGbk+spA9gUXsN/TV68lgM45LbynfIsEyK68CveaUI6bucAUCjfxWUHbZCg926vKRPogqQQPkJxQzCoVWLVLx7+owtMkChJmDFv+01WGevOT3LcaS8SP+IzVbUM=
Received: from PSAPR03MB5605.apcprd03.prod.outlook.com (2603:1096:301:66::6)
 by SI2PR03MB6807.apcprd03.prod.outlook.com (2603:1096:4:1ee::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5438.11; Mon, 11 Jul
 2022 14:03:51 +0000
Received: from PSAPR03MB5605.apcprd03.prod.outlook.com
 ([fe80::dd2f:414f:70df:ff81]) by PSAPR03MB5605.apcprd03.prod.outlook.com
 ([fe80::dd2f:414f:70df:ff81%9]) with mapi id 15.20.5417.023; Mon, 11 Jul 2022
 14:03:50 +0000
From:   =?big5?B?UGV0ZXIgV2FuZyAopP2rSKTNKQ==?= <peter.wang@mediatek.com>
To:     "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "rafael.j.wysocki@intel.com" <rafael.j.wysocki@intel.com>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
CC:     "stable@vger.kernel.org" <stable@vger.kernel.org>,
        =?big5?B?U3RhbmxleSBDaHUgKKa2reywpSk=?= <stanley.chu@mediatek.com>
Subject: backport commit ("887371066039011144b4a94af97d9328df6869a2 PM:
 runtime: Fix supplier device management during consumer probe") to linux-5.15
Thread-Topic: backport commit ("887371066039011144b4a94af97d9328df6869a2 PM:
 runtime: Fix supplier device management during consumer probe") to linux-5.15
Thread-Index: AdiVLsOnpTn7mKfJSwqX9lLPu68PIQ==
Date:   Mon, 11 Jul 2022 14:03:50 +0000
Message-ID: <PSAPR03MB5605DCFFD56137A47C1CA05CEC879@PSAPR03MB5605.apcprd03.prod.outlook.com>
Accept-Language: zh-TW, en-US
Content-Language: zh-TW
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=mediatek.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: eb1bcaf2-fb5b-463e-05f2-08da63462eba
x-ms-traffictypediagnostic: SI2PR03MB6807:EE_
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 8oPzc5UqR0NjYS92+H4T6gkuGL4678DhMjUM4VO03yGYo6uFquxwUgxMbHfxHUAsT9Us1bxaKDS7vjhlYt6HXya4GJSrE5xPi9KCEdpaPo3FmE2BdnRv/8rttV9uypNRR5Xz7+nskBIRL1WaHDA9ecfQ6UMgvzCPgTU+ZjLf5ZxxCUt+oW+Q3r+HbHxKT9AUFVrfuEKlG1KevawAMs58y7AGtNOGOugtHStJ0nTiNuylDhWORg2pny9pALSuL5IzKvuZvsKC54eOjYNoD6pp81dDgNFnEteJlfMabv8Pv75TOVWiC2CKgB6FzOxPV9ldoLxBZDKsXzbioXyLf4MiCc/Q2Gun5i5s6lEai+Kbgu5nR/vX17/FIyYhsCefOLVgCpEuIvwLqTI9lCJ6J4lc1Ej/+1pi6IrlIcD6eROBP8AUao307vVilNsy/fRnHjJGW5TsoNvCBcQneDldu8gwflTMwVi79s4L12YJUE77ss2ZgweNqwd1RPaU0+o+OJLx6dlRrSJUdhEf3SguA38PIaw0plZTqo6cxyEpBCP/dGTuNP6LfOn1KMKn/5fY3nY9B1EV7lV7w+kPtyKdx9YPJ8Hl9gJSzGz837trZqAaOzYGIZj4apWNuvQBQnfmxutH9NH3PKUYiQPMhz/qIvsP/4crlqZMhceORTl5dJKC27sJka4D27rTPQ+6EAjfFYEJQdZJCNjmSQK8GCqlRWgWljhnVvdE2xS34FFkMNUoDWOGMOn8EW6voZwTjTP+J5MD8AifuyZJHE37nh8Jhn5pgxeq98OpsvKc2N+TzQfL0xfbzanwAEMJgMx9eUsTVjWn
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PSAPR03MB5605.apcprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(346002)(366004)(376002)(39860400002)(396003)(136003)(33656002)(55016003)(2906002)(5660300002)(52536014)(122000001)(4326008)(76116006)(8676002)(66946007)(85182001)(86362001)(8936002)(66476007)(66446008)(110136005)(54906003)(316002)(71200400001)(66556008)(9686003)(478600001)(64756008)(186003)(41300700001)(7696005)(6506007)(107886003)(26005)(38070700005)(38100700002)(83380400001)(53546011);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?big5?B?ODFLaGdDdm1MbW4zRkptQm55S1dQdHdOUXRKSzV4eXBTdGdZYjRrc1ZRRzNkUlVO?=
 =?big5?B?dis1dTFLREQvYldXTW1ocE92a1grM3dNVzJYRlRZdUFZTFBGZTFObFhISDI4c3FQ?=
 =?big5?B?T1pRMk5oenpOQmRCQ2VIVmlHekx3WXN1eDJzVk9hbmdrRGZNck1veU52U3JwbzRT?=
 =?big5?B?RmZEdmhoU0F3NG9hc3hhYWxZMzRBc05xK0hwazcxL0hLd0dDcTFBWXBrSTJiaTVX?=
 =?big5?B?SE5yK0ZMNDVvRnlkVk9iMnJNWnpxZHo3eUQ5NUNuUFNNMEs3NGRZZm0yd0JNWEFT?=
 =?big5?B?dDVNeEh6SFJPNWhMZlVMT3JIRFRDVGRFRU5hQ083MWE5T2U4dXlpK0VrbjZiTUdo?=
 =?big5?B?akVVcFN2VEZvVjFUWDFwYnNib2pvS1VHYWx6ZU16ZUVtR0NyTjVSMEkvaGI3eVpj?=
 =?big5?B?SnMyRlgrZGtTRVBKNHpYYkl5TUpEeDMrUUJPUjRFN0lmbXF6TzVxQ0VlaExTUm9F?=
 =?big5?B?dkdERTM1anpMbFBOc2tJcjlDZnJkalgxNUI2TVBHVi9ibXRMRGxCemxaVTZoWGR1?=
 =?big5?B?THB6VXRhbm50NkZ0UXFSOFBuNmw0NUZMMVQ1WFkzUTU4WkpwN01NNnFCdUxocjU1?=
 =?big5?B?bk0vVkZnWDJmQmlIWmNhWFBlM0pWS3NXL2JHWG13RTFnNE1CUHZzZWk0QW1lbmtE?=
 =?big5?B?cDRrWkxTV0pIZ3JZYlVsS28xeWw0WXl2d1o3V0NYNTk1VUtGd3l6cGhuSXhtTTEv?=
 =?big5?B?ejZseWpNNVc1QTEvb2UxSHBMalgrSjdodnZubCtGUVJGSVhnbG5wWkhtbitNQ01U?=
 =?big5?B?VzJaSHAvcDAxSTFSMlVmWWdUeHRkSGU3aVBwNThIQjRwR0hRT1dEc0taYXY4SGQv?=
 =?big5?B?dk5jY1BHVEtWdUxWUmRNeTk2dWttRW05RmQ4SGhGRTlEUTM5SWh1Mm1uUVBzMFpU?=
 =?big5?B?TTdwZ2xXUW1jaFpKYmhHbEtXWlVCUFVkWGgxSFY3YWpvMzBOVlRSM0t5UWR5cG5K?=
 =?big5?B?TFhjNGdZN2N1ZVJPUktoY3ZLVkJ1Q1pzK0FoaGwyMVZNQzJOWURWSTlLN0JLTk9w?=
 =?big5?B?T2RJR3BjcitjVzRQc3F4ZzBpY05oVWdoTE5aZmlmSTU1enNpRnRJZDRVZ1QwNzNR?=
 =?big5?B?VG90K2JXNnJaM1kxTnR3U1lJdTQvYlVuRzg2OTQ2ZmFXMVQwd2Q2OGkzeUtsYkR2?=
 =?big5?B?RlhoMHJMK3ltZ010OEU1dExOaGZ6cDBmSndraWh2RmQxdFlaTlVKUnZKNkwxUVpt?=
 =?big5?B?M3RsekVwa29pTkFtdEQ0TndONGFuWTJ5SXhQTXN3QXcxbExKWjNCUlJ0blgxRkNa?=
 =?big5?B?SlJpQ044S2w0SXpYckNjWDZOSkRQM3NaL3lIb01tTVhOR01HUTllSUtvNGdyU0k0?=
 =?big5?B?VWVacDNWY0RRTlVjQ1B1RmRVMCtraVUvTXJGeTlLdFZYdFlKcTVGWjh4U3drWGdF?=
 =?big5?B?QlRhYS9pS05IbVFUOFdHaDJOS1czN1JYM2hzdERPNWtaVTM5eE43ZElSZnBYaTJo?=
 =?big5?B?QThJank1VkhzMGJXeWtwWFdML1dPenQyV2RNN0RBdHlEV3VxQVVYUjdoM1dzelhF?=
 =?big5?B?bEdGZmJkVXdHR1U3SlE2UUdYNDlqSWo0c05zT0FDUnJNVFFTUEtML1ZjbGsxcTdC?=
 =?big5?B?alJhWmlSSzNpckRGbS83TThlUWRHRjlNTHBkbXIvLzhMTjlCR1E3TW1NTlRHL1dP?=
 =?big5?B?VWtoejdQaERVM3JBR3BDNG91V25GNk02OE1ES3REY3JST0srTUkySk1TSnMrb25T?=
 =?big5?B?bWxHMHR0SHJHOWh1bzBaa3VDTzBXYUhwR3FkK1ZEVXd0Q0NLT2tNeVVBMEJGQUVn?=
 =?big5?B?Q1RUTEF1d21JaTNWbU15Ris2YzJjOWZTNlZ5Q2JTTFcrRkdrVDBFdlFYM3RKSVNW?=
 =?big5?B?L2V0S3dkMDJXYnFoZUR6bEM2ZHZUcFhzSTgydE1xSDAxVzRFWWR0dGw1TjE5OStq?=
 =?big5?B?U3dVRlh0VEVXOFhwT2dJSlNsRVBaek1oeVhyeXlmbkxJT1JaZExTc2NWRjJGckhn?=
 =?big5?B?NW5IR2ZmZXFhbkdLM0IwSVRJa0xxU2IyaGlaTFJwbU9uY20zM2l3cFZITWJQbXhR?=
 =?big5?Q?PaTxFohFa9SfMTq/?=
Content-Type: text/plain; charset="big5"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PSAPR03MB5605.apcprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: eb1bcaf2-fb5b-463e-05f2-08da63462eba
X-MS-Exchange-CrossTenant-originalarrivaltime: 11 Jul 2022 14:03:50.8681
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a7687ede-7a6b-4ef6-bace-642f677fbe31
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: FBNtsM5NeAHLMMRcsr7mrXx7Jqs3fgVQSiadlZEQNouQKt8dX/Xg8itaa8kTY3HbWuHNnEnC8gUtOzxS2iYD1g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SI2PR03MB6807
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,T_SCC_BODY_TEXT_LINE,
        T_SPF_TEMPERROR,UNPARSEABLE_RELAY autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

SGkgcmV2aWV3ZXJzLA0KDQpJIHN1Z2dlc3QgdG8gYmFja3BvcnQNCmNvbW1pdCAiODg3MzcxMDY2
MDM5MDExMTQ0YjRhOTRhZjk3ZDkzMjhkZjY4NjlhMiBQTTogcnVudGltZTogRml4IHN1cHBsaWVy
IGRldmljZSBtYW5hZ2VtZW50IGR1cmluZyBjb25zdW1lciBwcm9iZSINCnRvIGxpbnV4LTUuMTUg
dHJlZS4NCg0KVGhpcyBwYXRjaCBmaXggZGV2aWNlIGxpbmsgb2YgcnVudGltZSBwbSBpc3N1ZS4N
Cg0KY29tbWl0OiA4ODczNzEwNjYwMzkwMTExNDRiNGE5NGFmOTdkOTMyOGRmNjg2OWEyDQpzdWJq
ZWN0OiBQTTogcnVudGltZTogRml4IHN1cHBsaWVyIGRldmljZSBtYW5hZ2VtZW50IGR1cmluZyBj
b25zdW1lciBwcm9iZQ0KDQpUaGFua3MuDQpCUg0KUGV0ZXINCg0KDQotLS0tLU9yaWdpbmFsIE1l
c3NhZ2UtLS0tLQ0KRnJvbTogZ3JlZ2toQGxpbnV4Zm91bmRhdGlvbi5vcmcgPGdyZWdraEBsaW51
eGZvdW5kYXRpb24ub3JnPiANClNlbnQ6IFNhdHVyZGF5LCBKdWx5IDksIDIwMjIgNDoyMiBQTQ0K
VG86IHJhZmFlbC5qLnd5c29ja2lAaW50ZWwuY29tOyBncmVna2hAbGludXhmb3VuZGF0aW9uLm9y
ZzsgUGV0ZXIgV2FuZyAopP2rSKTNKSA8cGV0ZXIud2FuZ0BtZWRpYXRlay5jb20+OyBzdGFibGVA
dmdlci5rZXJuZWwub3JnDQpDYzogc3RhYmxlQHZnZXIua2VybmVsLm9yZw0KU3ViamVjdDogRkFJ
TEVEOiBwYXRjaCAiW1BBVENIXSBQTTogcnVudGltZTogRml4IHN1cHBsaWVyIGRldmljZSBtYW5h
Z2VtZW50IGR1cmluZyBjb25zdW1lciIgZmFpbGVkIHRvIGFwcGx5IHRvIDUuMTUtc3RhYmxlIHRy
ZWUNCg0KDQpUaGUgcGF0Y2ggYmVsb3cgZG9lcyBub3QgYXBwbHkgdG8gdGhlIDUuMTUtc3RhYmxl
IHRyZWUuDQpJZiBzb21lb25lIHdhbnRzIGl0IGFwcGxpZWQgdGhlcmUsIG9yIHRvIGFueSBvdGhl
ciBzdGFibGUgb3IgbG9uZ3Rlcm0gdHJlZSwgdGhlbiBwbGVhc2UgZW1haWwgdGhlIGJhY2twb3J0
LCBpbmNsdWRpbmcgdGhlIG9yaWdpbmFsIGdpdCBjb21taXQgaWQgdG8gPHN0YWJsZUB2Z2VyLmtl
cm5lbC5vcmc+Lg0KDQp0aGFua3MsDQoNCmdyZWcgay1oDQoNCi0tLS0tLS0tLS0tLS0tLS0tLSBv
cmlnaW5hbCBjb21taXQgaW4gTGludXMncyB0cmVlIC0tLS0tLS0tLS0tLS0tLS0tLQ0KDQpGcm9t
IDg4NzM3MTA2NjAzOTAxMTE0NGI0YTk0YWY5N2Q5MzI4ZGY2ODY5YTIgTW9uIFNlcCAxNyAwMDow
MDowMCAyMDAxDQpGcm9tOiAiUmFmYWVsIEouIFd5c29ja2kiIDxyYWZhZWwuai53eXNvY2tpQGlu
dGVsLmNvbT4NCkRhdGU6IFRodSwgMzAgSnVuIDIwMjIgMjE6MTY6NDEgKzAyMDANClN1YmplY3Q6
IFtQQVRDSF0gUE06IHJ1bnRpbWU6IEZpeCBzdXBwbGllciBkZXZpY2UgbWFuYWdlbWVudCBkdXJp
bmcgY29uc3VtZXIgIHByb2JlDQoNCkJlY2F1c2UgcG1fcnVudGltZV9nZXRfc3VwcGxpZXJzKCkg
YnVtcHMgdXAgdGhlIHJwbV9hY3RpdmUgY291bnRlciBvZiBlYWNoIGRldmljZSBsaW5rIHRvIGEg
c3VwcGxpZXIgb2YgdGhlIGdpdmVuIGRldmljZSBpbiBhZGRpdGlvbiB0byBidW1waW5nIHVwIHRo
ZSBzdXBwbGllcidzIFBNLXJ1bnRpbWUgdXNhZ2UgY291bnRlciwgYSBydW50aW1lIHN1c3BlbmQg
b2YgdGhlIGNvbnN1bWVyIGRldmljZSBtYXkgY2FzZSB0aGUgbGF0dGVyIHRvIGdvIGRvd24gdG8g
MCB3aGVuIHBtX3J1bnRpbWVfcHV0X3N1cHBsaWVycygpIGlzIHJ1bm5pbmcgb24gYSByZW1vdGUg
Q1BVLiAgSWYgdGhhdCBoYXBwZW5zIGFmdGVyIHBtX3J1bnRpbWVfcHV0X3N1cHBsaWVycygpIGhh
cyByZWxlYXNlZCBwb3dlci5sb2NrIGZvciB0aGUgY29uc3VtZXIgZGV2aWNlLCBhbmQgYSBydW50
aW1lIHJlc3VtZSBvZiB0aGF0IGRldmljZSB0YWtlcyBwbGFjZSBpbW1lZGlhdGVseSBhZnRlciBp
dCwgYmVmb3JlIHBtX3J1bnRpbWVfcHV0KCkgaXMgY2FsbGVkIGZvciB0aGUgc3VwcGxpZXIsIHRo
YXQgcG1fcnVudGltZV9wdXQoKSBjYWxsIG1heSBjYXVzZSB0aGUgc3VwcGxpZXIgdG8gYmUgc3Vz
cGVuZGVkIGV2ZW4gdGhvdWdoIHRoZSBjb25zdW1lciBpcyBhY3RpdmUuDQoNClRvIHByZXZlbnQg
dGhhdCBmcm9tIGhhcHBlbmluZywgbW9kaWZ5IHBtX3J1bnRpbWVfZ2V0X3N1cHBsaWVycygpIHRv
IGNhbGwgcG1fcnVudGltZV9nZXRfc3luYygpIGZvciB0aGUgZ2l2ZW4gZGV2aWNlJ3Mgc3VwcGxp
ZXJzIHdpdGhvdXQgdG91Y2hpbmcgdGhlIHJwbV9hY3RpdmUgY291bnRlcnMgb2YgdGhlIGludm9s
dmVkIGRldmljZSBsaW5rcyBBY2NvcmRpbmdseSwgbW9kaWZ5IHBtX3J1bnRpbWVfcHV0X3N1cHBs
aWVycygpIHRvIGNhbGwgcG1fcnVudGltZV9wdXQoKSBmb3IgdGhlIGdpdmVuIGRldmljZSdzIHN1
cHBsaWVycyB3aXRob3V0IGxvb2tpbmcgYXQgdGhlIHJwbV9hY3RpdmUgY291bnRlcnMgb2YgdGhl
IGRldmljZSBsaW5rcyBhdCBoYW5kLiAgW1RoaXMgaXMgYW5hbG9nb3VzIHRvIHdoYXQgaGFwcGVu
ZWQgYmVmb3JlIGNvbW1pdCA0YzA2YzRlNmNmNjMgKCJkcml2ZXIgY29yZTogRml4IHBvc3NpYmxl
IHN1cHBsaWVyIFBNLXVzYWdlIGNvdW50ZXIgaW1iYWxhbmNlIikuXQ0KDQpTaW5jZSBwbV9ydW50
aW1lX2dldF9zdXBwbGllcnMoKSBzZXRzIHN1cHBsaWVyX3ByZWFjdGl2YXRlZCBmb3IgZWFjaCBk
ZXZpY2UgbGluayB3aGVyZSB0aGUgc3VwcGxpZXIncyBQTS1ydW50aW1lIHVzYWdlIGNvdW50ZXIg
aGFzIGJlZW4gaW5jcmVtZW50ZWQgYW5kIHBtX3J1bnRpbWVfcHV0X3N1cHBsaWVycygpIGNhbGxz
IHBtX3J1bnRpbWVfcHV0KCkgZm9yIHRoZSBzdXBwbGllcnMgd2hvc2UgZGV2aWNlIGxpbmtzIGhh
dmUgc3VwcGxpZXJfcHJlYWN0aXZhdGVkIHNldCwgdGhlIFBNLXJ1bnRpbWUgdXNhZ2UgY291bnRl
ciBpcyBiYWxhbmNlZCBmb3IgZWFjaCBzdXBwbGllciBhbmQgdGhpcyBpcyBpbmRlcGVuZGVudCBv
ZiB0aGUgcnVudGltZSBzdXNwZW5kIGFuZCByZXN1bWUgb2YgdGhlIGNvbnN1bWVyIGRldmljZS4N
Cg0KSG93ZXZlciwgaW4gY2FzZSBhIGRldmljZSBsaW5rIHdpdGggRExfRkxBR19QTV9SVU5USU1F
IHNldCBpcyBkcm9wcGVkIGR1cmluZyB0aGUgY29uc3VtZXIgZGV2aWNlIHByb2JlLCBzbyBwbV9y
dW50aW1lX2dldF9zdXBwbGllcnMoKSBidW1wcyB1cCB0aGUgc3VwcGxpZXIncyBQTS1ydW50aW1l
IHVzYWdlIGNvdW50ZXIsIGJ1dCBpdCBjYW5ub3QgYmUgZHJvcHBlZCBieSBwbV9ydW50aW1lX3B1
dF9zdXBwbGllcnMoKSwgbWFrZSBkZXZpY2VfbGlua19yZWxlYXNlX2ZuKCkgdGFrZSBjYXJlIG9m
IHRoYXQuDQoNCkZpeGVzOiA0YzA2YzRlNmNmNjMgKCJkcml2ZXIgY29yZTogRml4IHBvc3NpYmxl
IHN1cHBsaWVyIFBNLXVzYWdlIGNvdW50ZXIgaW1iYWxhbmNlIikNClJlcG9ydGVkLWJ5OiBQZXRl
ciBXYW5nIDxwZXRlci53YW5nQG1lZGlhdGVrLmNvbT4NClNpZ25lZC1vZmYtYnk6IFJhZmFlbCBK
LiBXeXNvY2tpIDxyYWZhZWwuai53eXNvY2tpQGludGVsLmNvbT4NClJldmlld2VkLWJ5OiBHcmVn
IEtyb2FoLUhhcnRtYW4gPGdyZWdraEBsaW51eGZvdW5kYXRpb24ub3JnPg0KUmV2aWV3ZWQtYnk6
IFBldGVyIFdhbmcgPHBldGVyLndhbmdAbWVkaWF0ZWsuY29tPg0KQ2M6IDUuMSsgPHN0YWJsZUB2
Z2VyLmtlcm5lbC5vcmc+ICMgNS4xKw0KDQpkaWZmIC0tZ2l0IGEvZHJpdmVycy9iYXNlL2NvcmUu
YyBiL2RyaXZlcnMvYmFzZS9jb3JlLmMgaW5kZXggNThhYTQ5NTI3ZDNhLi40NjBkNmYxNjNlNDEg
MTAwNjQ0DQotLS0gYS9kcml2ZXJzL2Jhc2UvY29yZS5jDQorKysgYi9kcml2ZXJzL2Jhc2UvY29y
ZS5jDQpAQCAtNDg3LDYgKzQ4NywxNiBAQCBzdGF0aWMgdm9pZCBkZXZpY2VfbGlua19yZWxlYXNl
X2ZuKHN0cnVjdCB3b3JrX3N0cnVjdCAqd29yaykNCiAJZGV2aWNlX2xpbmtfc3luY2hyb25pemVf
cmVtb3ZhbCgpOw0KIA0KIAlwbV9ydW50aW1lX3JlbGVhc2Vfc3VwcGxpZXIobGluayk7DQorCS8q
DQorCSAqIElmIHN1cHBsaWVyX3ByZWFjdGl2YXRlZCBpcyBzZXQsIHRoZSBsaW5rIGhhcyBiZWVu
IGRyb3BwZWQgYmV0d2Vlbg0KKwkgKiB0aGUgcG1fcnVudGltZV9nZXRfc3VwcGxpZXJzKCkgYW5k
IHBtX3J1bnRpbWVfcHV0X3N1cHBsaWVycygpIGNhbGxzDQorCSAqIGluIF9fZHJpdmVyX3Byb2Jl
X2RldmljZSgpLiAgSW4gdGhhdCBjYXNlLCBkcm9wIHRoZSBzdXBwbGllcidzDQorCSAqIFBNLXJ1
bnRpbWUgdXNhZ2UgY291bnRlciB0byByZW1vdmUgdGhlIHJlZmVyZW5jZSB0YWtlbiBieQ0KKwkg
KiBwbV9ydW50aW1lX2dldF9zdXBwbGllcnMoKS4NCisJICovDQorCWlmIChsaW5rLT5zdXBwbGll
cl9wcmVhY3RpdmF0ZWQpDQorCQlwbV9ydW50aW1lX3B1dF9ub2lkbGUobGluay0+c3VwcGxpZXIp
Ow0KKw0KIAlwbV9yZXF1ZXN0X2lkbGUobGluay0+c3VwcGxpZXIpOw0KIA0KIAlwdXRfZGV2aWNl
KGxpbmstPmNvbnN1bWVyKTsNCmRpZmYgLS1naXQgYS9kcml2ZXJzL2Jhc2UvcG93ZXIvcnVudGlt
ZS5jIGIvZHJpdmVycy9iYXNlL3Bvd2VyL3J1bnRpbWUuYyBpbmRleCAyM2NjNGMzNzdkNzcuLjk0
OTkwN2UyZTI0MiAxMDA2NDQNCi0tLSBhL2RyaXZlcnMvYmFzZS9wb3dlci9ydW50aW1lLmMNCisr
KyBiL2RyaXZlcnMvYmFzZS9wb3dlci9ydW50aW1lLmMNCkBAIC0xNzY4LDcgKzE3NjgsNiBAQCB2
b2lkIHBtX3J1bnRpbWVfZ2V0X3N1cHBsaWVycyhzdHJ1Y3QgZGV2aWNlICpkZXYpDQogCQlpZiAo
bGluay0+ZmxhZ3MgJiBETF9GTEFHX1BNX1JVTlRJTUUpIHsNCiAJCQlsaW5rLT5zdXBwbGllcl9w
cmVhY3RpdmF0ZWQgPSB0cnVlOw0KIAkJCXBtX3J1bnRpbWVfZ2V0X3N5bmMobGluay0+c3VwcGxp
ZXIpOw0KLQkJCXJlZmNvdW50X2luYygmbGluay0+cnBtX2FjdGl2ZSk7DQogCQl9DQogDQogCWRl
dmljZV9saW5rc19yZWFkX3VubG9jayhpZHgpOw0KQEAgLTE3ODgsMTkgKzE3ODcsOCBAQCB2b2lk
IHBtX3J1bnRpbWVfcHV0X3N1cHBsaWVycyhzdHJ1Y3QgZGV2aWNlICpkZXYpDQogCWxpc3RfZm9y
X2VhY2hfZW50cnlfcmN1KGxpbmssICZkZXYtPmxpbmtzLnN1cHBsaWVycywgY19ub2RlLA0KIAkJ
CQlkZXZpY2VfbGlua3NfcmVhZF9sb2NrX2hlbGQoKSkNCiAJCWlmIChsaW5rLT5zdXBwbGllcl9w
cmVhY3RpdmF0ZWQpIHsNCi0JCQlib29sIHB1dDsNCi0NCiAJCQlsaW5rLT5zdXBwbGllcl9wcmVh
Y3RpdmF0ZWQgPSBmYWxzZTsNCi0NCi0JCQlzcGluX2xvY2tfaXJxKCZkZXYtPnBvd2VyLmxvY2sp
Ow0KLQ0KLQkJCXB1dCA9IHBtX3J1bnRpbWVfc3RhdHVzX3N1c3BlbmRlZChkZXYpICYmDQotCQkJ
ICAgICAgcmVmY291bnRfZGVjX25vdF9vbmUoJmxpbmstPnJwbV9hY3RpdmUpOw0KLQ0KLQkJCXNw
aW5fdW5sb2NrX2lycSgmZGV2LT5wb3dlci5sb2NrKTsNCi0NCi0JCQlpZiAocHV0KQ0KLQkJCQlw
bV9ydW50aW1lX3B1dChsaW5rLT5zdXBwbGllcik7DQorCQkJcG1fcnVudGltZV9wdXQobGluay0+
c3VwcGxpZXIpOw0KIAkJfQ0KIA0KIAlkZXZpY2VfbGlua3NfcmVhZF91bmxvY2soaWR4KTsNCg0K
