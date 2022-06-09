Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6DEBF544184
	for <lists+stable@lfdr.de>; Thu,  9 Jun 2022 04:32:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236698AbiFICc5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 8 Jun 2022 22:32:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60768 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230391AbiFICcz (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 8 Jun 2022 22:32:55 -0400
Received: from APC01-PSA-obe.outbound.protection.outlook.com (mail-psaapc01on2118.outbound.protection.outlook.com [40.107.255.118])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BDD0E3ED03
        for <stable@vger.kernel.org>; Wed,  8 Jun 2022 19:32:50 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=hoJVo3fpjx624VW2Gp64x194FOv0BtuSKVuCyuwNNNvGwfMhul4laPJfkPYkTxiZ+zO4hjTl7vRX5q6VGi3oeep3ZhJV/6zp6eCSOZTmEu+Q4BEhyoCY8IkClxuv7bTq8CIPFdOxABbjNA2i3XlI93zUgCIYnKTSD7gbG9J9VFpBJf4PlbKA43GqKI11wWk7zIa/SX7lldnSAGL9zAWmnmFibUrxy0Q6baklDvBEsYD0xllFlVeN1K2EsyKG0FHRBaA87UKS+KqBFyif2upbTADIaHPb4IsZpDIQlFg91FNBts75KI/FQ4XKP265oSB1VDePKRdIYP+S7kL+AVOM1Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=WHc2UlKZ1V6vYiH/Y7PlHleYrkkthHk3ybwTzfeLr3M=;
 b=kZVJBCYFeEy1ts367Izebu9N27M1l4YMvYkoR/CGe6YDWWeNvwZt4W0dkPx+uc3t1/JnK0NJUgMdoOsXHzA8+NQ9V5VqZjTV/kuwmzmCzYlMNmJ9Iiirjb0rbnVqxvFTOCD66ZQkrdyrDl/RUmLpZlEIq5GWzUSuCDXi/BF5bm1/MQSymSmI094yGvvFDu5eyCUYpMjF11lpgvhm7o5MOAgafxC7Jn/eQhkIGmxwh8mi4DAQFxPL49B+1qBSJZROfBXdnpILBE7+fImwDsQ779VM7nwP3an6ldBHvKtB8rCmayJG1mX71XSZuRs9uU7e3h7qrLz7QW2UhKQk7NtFqw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=aspeedtech.com; dmarc=pass action=none
 header.from=aspeedtech.com; dkim=pass header.d=aspeedtech.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=aspeedtech.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=WHc2UlKZ1V6vYiH/Y7PlHleYrkkthHk3ybwTzfeLr3M=;
 b=PesivY1gIbWdpldVMdeSFmE8fjV/XXaM5G9tSs/YrHG8U8mlYrTB/DVvymJnZo1ivCNIFjAP5En+5MRzBJcsqLB19HQEsRGgIWoZdY1Jqg7eU7+FZLm+XO8vwzO0ZfTK5CZoljf61wYBXAN5vQ3dO5JHiWVO6cSrqeCO/cSSd8KS0hnB1QNuiIdDxbtLOxz8cB+ACIMMCG8wCdDtkjDeC6mHoMcA98N7FQTvVvfNceIO/7RRlLhrXW0Xis2qXso3LRM1JogCnXf1dWT2YQAU3jInITkqpGaBdsIn/tP7Xa8RyU5m1yVxSDpio25M5sX7xpy1+Gv6XLImGprL8SFgag==
Received: from PSAPR06MB4805.apcprd06.prod.outlook.com (2603:1096:301:9a::13)
 by TYZPR06MB4511.apcprd06.prod.outlook.com (2603:1096:400:66::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5332.11; Thu, 9 Jun
 2022 02:32:48 +0000
Received: from PSAPR06MB4805.apcprd06.prod.outlook.com
 ([fe80::a05e:baab:fb12:c6fa]) by PSAPR06MB4805.apcprd06.prod.outlook.com
 ([fe80::a05e:baab:fb12:c6fa%6]) with mapi id 15.20.5314.019; Thu, 9 Jun 2022
 02:32:48 +0000
From:   Kuo-Hsiang Chou <kuohsiang_chou@aspeedtech.com>
To:     Jocelyn Falempe <jfalempe@redhat.com>,
        Thomas Zimmermann <tzimmermann@suse.de>,
        "airlied@redhat.com" <airlied@redhat.com>,
        "airlied@linux.ie" <airlied@linux.ie>,
        "daniel@ffwll.ch" <daniel@ffwll.ch>,
        "regressions@leemhuis.info" <regressions@leemhuis.info>
CC:     "dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        Luke Chen <luke_chen@aspeedtech.com>,
        Hungju Huang <hungju_huang@aspeedtech.com>,
        Charles Kuan <charles_kuan@aspeedtech.com>
Subject: RE: [PATCH] drm/ast: Treat AST2600 like AST2500 in most places
Thread-Topic: [PATCH] drm/ast: Treat AST2600 like AST2500 in most places
Thread-Index: AQHYemaHfJa2yEMfXkmDImVEyBPZjq1E3VTwgACh7gCAANxHgA==
Date:   Thu, 9 Jun 2022 02:32:47 +0000
Message-ID: <PSAPR06MB48051E6CA20163561BAD80298CA79@PSAPR06MB4805.apcprd06.prod.outlook.com>
References: <20220607120248.31716-1-tzimmermann@suse.de>
 <PSAPR06MB4805B23B053F80C0F23A8C6C8CA49@PSAPR06MB4805.apcprd06.prod.outlook.com>
 <c99f305f-ac4d-628b-b092-920af767a2e4@redhat.com>
In-Reply-To: <c99f305f-ac4d-628b-b092-920af767a2e4@redhat.com>
Accept-Language: en-US
Content-Language: zh-TW
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=aspeedtech.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: a755d33d-1ddc-4b3b-1ffc-08da49c057a6
x-ms-traffictypediagnostic: TYZPR06MB4511:EE_
x-microsoft-antispam-prvs: <TYZPR06MB45116DD32BEC6AA2D22818EC8CA79@TYZPR06MB4511.apcprd06.prod.outlook.com>
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: Dfm9cXn2sOn8N0nq2bjHmzqDHz1HxKMx3MXbs2oeuFWr0y8jAVzTH8PcygrjJ33PRMNbR9zOlQrlc+1cqZ/LMT25t1A80idrn6KwwnXHXJ+C+nAilk9APyHdebbHg3GnzSXubymAyYIh8S2bbijmPj/8a+0+IRWtPsuML+YWT8fVKisoG6KJNY/7w7xIfvM7nfbfkh7mU5oEaO67R7ftwaU/gZrUpcd6k6TAhKyYfB559Ri/+yr8WJvKOMSyAgrpOBu9+i2wH51M06qOFa8igBsoOE2/CFv6Ywglk1u0dyuJAsm9dbY6oW+NPpzSR23hwYN4IqBwjzZToxnJXVuuBOZFb9AEEOVcF/w7vgZvTnHpBy38kfFoPvOWOpOOrSkF2RuHGnqQ5eLKGiBxzHhEEdlL4cssZaoD5CPQvRWplLoKqdbkqUimPKHzDaRZ4H4AX734YYvD8JYniszmihJL1dG8MJdEBskOU9BthYXLhcHjLfGlQQLXpichfzsIumiqF0BQNjFxwkSxuqf+GHhDkOb5KTp9vMt9iQ1Bp8OBaQx5nEKoZRi+ZVQ11fcubkUKDRjGnuU2J1tPxVZJY0DNrxcx2i54O8IxeQgK2k8W3lWAk23V5edBPAyyqmk520FuDkXprLR/iwnKHe5U/cifCmx99rC25+nMpqOiAdF55py6AElemVxLBH9CporOWr2FJeDAD47NWPRVGpJNzNegog==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PSAPR06MB4805.apcprd06.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(64756008)(26005)(52536014)(66476007)(316002)(9686003)(66946007)(33656002)(107886003)(186003)(66446008)(8936002)(83380400001)(86362001)(71200400001)(8676002)(122000001)(53546011)(38070700005)(2906002)(66556008)(4326008)(55016003)(5660300002)(38100700002)(6506007)(110136005)(7696005)(54906003)(508600001)(76116006);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?cDk4cmF0UEsyS3YyZTBpZ2QwallyMnEvQW8wNDVtdXpYS1FaNTlXU05vdlVI?=
 =?utf-8?B?UENvMk45U2J0Ylg1eUEweWRiaFNmNFE5ZE1mdlZKRHBjNTF4cklYUHdQSlp2?=
 =?utf-8?B?S0FmdHgwVFJBZGErVFlYT3g3cC9TMUE1c0lvUm0vdXhjcko3dmwzYU5IYU56?=
 =?utf-8?B?RHZIdUlYMEJ4Q2lmaFZ0dCtaUlRIUnVKWDNOS3dwZFB1MUVrOU1QWVJxK1Rs?=
 =?utf-8?B?bDdVd0F0Ny9ZLzRYL2dzYm15NWUwV0xlNzdYSldrTnptSnZaTldWcWJlUDVp?=
 =?utf-8?B?MDExTVdleWFJbjBZek4vWGtRbDJJNWpzZTNHMll2cnh0VkRDUUdEK2dmTU1E?=
 =?utf-8?B?V2NrdEdJYmxtempZSlh0eWFRYkM5MHNOWlFIRU9xcHN0eTZWRTY1R1E5dzQw?=
 =?utf-8?B?NnU4MUh2YzVIUHBKK2Z5RHU3WmlIbVllbU5SMUNKM3RmU243eWJrOTNUOE15?=
 =?utf-8?B?RGVtWnVmakxCRXFpOTJIK3p2dEFVY0RBYzhTTUc2Rk1GK2x6MkIvcGZKSDE0?=
 =?utf-8?B?aytNcCt0bytuSnpjRk0ya2kvR0hEdDErSXZCMExrVVlyNDkxN0tNL2JzZnNC?=
 =?utf-8?B?SzQ5cHM5V290L1hTRlJlOUJFQkU4MFVpK21pcFpma05xeTFqb2hKTXpwVmZU?=
 =?utf-8?B?dFRneHo4aDhOaWQzV3NadXZMd0ZXb1B4NFVxandobnBDMGYrWm10TlNWZkZS?=
 =?utf-8?B?RGRUS2NnckliK05za1pxZng1ckd3c0s0dmZWU0lsaE01SUdEb2d6R2FwZzM3?=
 =?utf-8?B?bGlVZ1U5VVhUWG56a05RZElUdWZqWTdoU0xRbWNFbDUvSFlYN0xiN3FNdys5?=
 =?utf-8?B?OXJkNTJBREgyK1A5cXBFamxrU2ZIbVNvV3dSQk12OEVDbUlZY3h3ODVLTVlP?=
 =?utf-8?B?QUVKc0ErVmdvV2JidENud3JOajBpNU00c1U4WEZ0SnVGdE5PS2c3YUptc0Fr?=
 =?utf-8?B?RE9OVmpFeCtRdEJsK1BuTHc2d20yRmNuV2QvWW1aR3JZaXJrWWE0cE51ZFRk?=
 =?utf-8?B?elJXbzgxUWJyY3NuQzBRaEZ1L00wWThiUDBzcVBmV2lHcWIxeEg3MDBHWnpz?=
 =?utf-8?B?U2pFVGVUektXMHl5WFl0UFE0SzJ5azlVcHFNbW16VU1oak1ZNDMzWTBwNGsx?=
 =?utf-8?B?K2l1YlpTbFlpdUxOdy9jWjYrTDhkVzRtVGNyeVNLRkhVbTBVa1N0WjRWRUtL?=
 =?utf-8?B?N3JSZms4NzhOY3pYbVNwVVJHRVo2bkpERU5iMCtQbTZ1dnI1YjVvWDhwUWxh?=
 =?utf-8?B?dS92ZlJ1RHF6Zmo0dVRNc0p1dW1oc096TFp5aDZsRDE2K3RWS2ZHQ1N3aWcv?=
 =?utf-8?B?QmhZYmRrd24vTW4xTkkrbE5HbDBIM29qQi9UVDVNQnFOOGJ0U3h5U1YwaVQx?=
 =?utf-8?B?am5Ga1ArR1FxMHphV0FqMVN1cWxCZ0Z0UDJET3VNcjFEQzFTSENyanZZa1Bp?=
 =?utf-8?B?Z09RQVZvRW1hSzM2dDFjOUphbExCVVFaTTh2cXJHVFN4THRQR096NnFNTkFR?=
 =?utf-8?B?RlVqK1dRL1UxZjJ0UmwyZzhIZW5QOWJJU05YcFlhNzlSYTVRb1UxUlo5L3Nx?=
 =?utf-8?B?OThMdnJXeG5YaGZSVWVocVQ3Y3VaRHBCL1A4ZnV5Mm5zWE9tUEVGajlzYWZU?=
 =?utf-8?B?MEZjNnVJcEpxM1lYUC83RXJSd3ZhR2FiK2RWQmRlRGZ3N0ZaOE5hV0p0cTM5?=
 =?utf-8?B?WE56RDVkeDQrNVQ5Uy9MUTFGV3FJejNySDdMaWxCaFNvQmhoUXM0MTRjVzQw?=
 =?utf-8?B?QlBONjhCTkRYeU55bDVUWTJOcUJYdXgreUVzVDBESlFnY3ZpcTJ4SFZvY3g5?=
 =?utf-8?B?d3Fkdjl1eHIyUTVQRW1ueWRKbU15Wk1YWUZSNUdNRlFLRE8zNUFDZ3l2Yi8v?=
 =?utf-8?B?dEhYY25RTTMzTXpsVFZUK0Mya1pEMWMvVnY4cUxtZkhmOE5oNWhlNUl2RGFH?=
 =?utf-8?B?NnF1R045eWZCdzN6RlE0V25uZEFsL01nUGFiRDlnRE14UHYyNlkvdHVKTko2?=
 =?utf-8?B?eENhUXBSandncksxM0FNQzBYUFNoWEo2dmZiM2pwZ0Q5cEZmVlhTUmoyMWJi?=
 =?utf-8?B?KzNvdVAyQndtOGRud2ZoQTB0cHY1Yk51aXhkQjR4N3Jtd2JvOEJBeGQ1Qllh?=
 =?utf-8?B?Nnk5NUZLY0lRY01ERVJhQnhKbmdvamIyWE0yTnlXbDN4NlVzVEdYZ1E0TTBY?=
 =?utf-8?B?Ry9od1BQM3BDa29seERoOUY2bnR5TnJyUzlEdUZlVEdacWtnQkxJR3ZaZEJR?=
 =?utf-8?B?alI1ODJnSDQzaklVZXM3MmxPVVZGMjQwbEREWjFwNGFEd3JyY3ludUxHYXdF?=
 =?utf-8?B?R0NVc2dmeDFzSlpCSmM3YnhCUWhOYXRRUTV0MDVPVVRpRURqd3NuQU5ML2E0?=
 =?utf-8?Q?O2u1vuEBYa3X5d4I=3D?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: aspeedtech.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PSAPR06MB4805.apcprd06.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a755d33d-1ddc-4b3b-1ffc-08da49c057a6
X-MS-Exchange-CrossTenant-originalarrivaltime: 09 Jun 2022 02:32:47.9087
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 43d4aa98-e35b-4575-8939-080e90d5a249
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: SGpWB5Y6zfKh+kxaLyTgFZkNAh93AvHQBTS/yEGODo1M8J5IHsf9yZT4QFjwfPP1FhzMP+u2QL1DVRgpPCMASaTTAeH3FXtHXpikhnA3PsI=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: TYZPR06MB4511
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

SGkgSm9jZWx5biBGYWxlbXBlLA0KDQotLS0tLU9yaWdpbmFsIE1lc3NhZ2UtLS0tLQ0KRnJvbTog
Sm9jZWx5biBGYWxlbXBlIFttYWlsdG86amZhbGVtcGVAcmVkaGF0LmNvbV0gDQpTZW50OiBXZWRu
ZXNkYXksIEp1bmUgMDgsIDIwMjIgOToxNyBQTQ0KVG86IEt1by1Ic2lhbmcgQ2hvdSA8a3VvaHNp
YW5nX2Nob3VAYXNwZWVkdGVjaC5jb20+OyBUaG9tYXMgWmltbWVybWFubiA8dHppbW1lcm1hbm5A
c3VzZS5kZT47IGFpcmxpZWRAcmVkaGF0LmNvbTsgYWlybGllZEBsaW51eC5pZTsgZGFuaWVsQGZm
d2xsLmNoOyByZWdyZXNzaW9uc0BsZWVtaHVpcy5pbmZvDQpDYzogZHJpLWRldmVsQGxpc3RzLmZy
ZWVkZXNrdG9wLm9yZzsgc3RhYmxlQHZnZXIua2VybmVsLm9yZzsgTHVrZSBDaGVuIDxsdWtlX2No
ZW5AYXNwZWVkdGVjaC5jb20+OyBIdW5nanUgSHVhbmcgPGh1bmdqdV9odWFuZ0Bhc3BlZWR0ZWNo
LmNvbT47IENoYXJsZXMgS3VhbiA8Y2hhcmxlc19rdWFuQGFzcGVlZHRlY2guY29tPg0KU3ViamVj
dDogUmU6IFtQQVRDSF0gZHJtL2FzdDogVHJlYXQgQVNUMjYwMCBsaWtlIEFTVDI1MDAgaW4gbW9z
dCBwbGFjZXMNCg0KT24gMDgvMDYvMjAyMiAxMDowOSwgS3VvLUhzaWFuZyBDaG91IHdyb3RlOg0K
PiBIaSBUaG9tYXMNCj4gDQo+IFRoYW5rcyBmb3IgeW91ciBzdWdnZXN0aW9ucyENCj4gDQo+IEkg
YW5zd2VyIGVhY2ggcmV2aXNpb24gaW5saW5lIHRoYXQgZm9sbG93ZWQgYnkgW0tIXTouDQoNClRo
YW5rcyBmb3IgcmV2aWV3aW5nIHRoaXMuDQo+IA0KPiBSZWdhcmRzLA0KPiANCj4gIMKgwqDCoMKg
wqDCoMKgIEt1by1Ic2lhbmcgQ2hvdQ0KPiANCj4gLS0tLS1PcmlnaW5hbCBNZXNzYWdlLS0tLS0N
Cj4gDQo+IEZyb206IFRob21hcyBaaW1tZXJtYW5uIFttYWlsdG86dHppbW1lcm1hbm5Ac3VzZS5k
ZV0NCj4gDQo+IFNlbnQ6IFR1ZXNkYXksIEp1bmUgMDcsIDIwMjIgODowMyBQTQ0KPiANCj4gVG86
IGFpcmxpZWRAcmVkaGF0LmNvbTsgYWlybGllZEBsaW51eC5pZTsgZGFuaWVsQGZmd2xsLmNoOyAN
Cj4gamZhbGVtcGVAcmVkaGF0LmNvbTsgcmVncmVzc2lvbnNAbGVlbWh1aXMuaW5mbzsgS3VvLUhz
aWFuZyBDaG91IA0KPiA8a3VvaHNpYW5nX2Nob3VAYXNwZWVkdGVjaC5jb20+DQo+IA0KPiBTdWJq
ZWN0OiBbUEFUQ0hdIGRybS9hc3Q6IFRyZWF0IEFTVDI2MDAgbGlrZSBBU1QyNTAwIGluIG1vc3Qg
cGxhY2VzDQo+IA0KPiBJbmNsdWRlIEFTVDI2MDAgaW4gbW9zdCBvZiB0aGUgYnJhbmNoZXMgZm9y
IEFTVDI1MDAuIFRoZXJlYnkgcmV2ZXJ0IA0KPiBtb3N0IGVmZmVjdHMgb2YgY29tbWl0IGY5YmQw
MGUwZWE5ZCAoImRybS9hc3Q6IENyZWF0ZSBjaGlwIEFTVDI2MDAiKS4NCj4gDQo+IFRoZSBBU1Qy
NjAwIHVzZWQgdG8gYmUgdHJlYXRlZCBsaWtlIGFuIEFTVDI1MDAsIHdoaWNoIGF0IGxlYXN0IGdh
dmUgDQo+IHVzYWJsZSBkaXNwbGF5IG91dHB1dC4gQWZ0ZXIgaW50cm9kdWNpbmcgQVNUMjYwMCBp
biB0aGUgZHJpdmVyIHdpdGhvdXQgDQo+IGZ1cnRoZXIgdXBkYXRlcywgbG90cyBvZiBmdW5jdGlv
bnMgdGFrZSB0aGUgd3JvbmcgYnJhbmNoZXMuDQo+IA0KPiBIYW5kbGluZyBBU1QyNjAwIGluIHRo
ZSBBU1QyNTAwIGJyYW5jaGVzIHJldmVydHMgYmFjayB0byB0aGUgb3JpZ2luYWwgDQo+IHNldHRp
bmdzLiBUaGUgZXhjZXB0aW9uIGFyZSBjYXNlcyB3aGVyZSBBU1QyNjAwIG1lYW53aGlsZSBnb3Qg
aXRzIG93biANCj4gYnJhbmNoLg0KPiANCj4gW0tIXTogQmFzZWQgb24gQ1ZFXzIwMTlfNjI2MCBp
dGVtMywgUDJBIGlzIGRpc2FsbG93ZWQgYW55bW9yZS4NCj4gDQo+IFAyQSAoUENJZSB0byBBTUJB
KSBpcyBhIGJyaWRnZSB0aGF0IGlzIGFibGUgdG8gcmV2aXNlIGFueSBCTUMgcmVnaXN0ZXJzLg0K
PiANCj4gWWVzLCBQMkEgaXMgZGFuZ2Vyb3VzIG9uIHNlY3VyaXR5IGlzc3VlLCBiZWNhdXNlIEhv
c3Qgb3BlbiBhIGJhY2tkb29yIA0KPiBhbmQgc29tZW9uZSBtYWxpY2lvdXMgU1cvQVBQIHdpbGwg
YmUgZWFzeSB0byB0YWtlIGNvbnRyb2wgb2YgQk1DLg0KPiANCj4gVGhlcmVmb3JlLCBQMkEgaXMg
ZGlzYWJsZWQgZm9yZXZlci4NCj4gDQo+IE5vdywgcmV0dXJuIHRvIHRoaXMgcGF0Y2gsIHRoZXJl
IGlzIG5vIG5lZWQgdG8gYWRkIEFTVDI2MDAgY29uZGl0aW9uIA0KPiBvbiB0aGUgUDJBIGZsb3cu
DQo+IA0KDQpbc25pcF0NCj4gDQo+IFtLSF06IFllcywgdGhlIHBhdGNoIGlzICJkcm0vYXN0OiBD
cmVhdGUgdGhyZXNob2xkIHZhbHVlcyBmb3IgQVNUMjYwMCIgDQo+IHRoYXQgaXMgdGhlIHJvb3Qg
Y2F1c2Ugb2Ygd2hpdGVzIGxpbmVzIG9uIEFTVDI2MDANCj4gDQo+IGNvbW1pdA0KPiANCj4gDQo+
IGJjYzc3NDExZThhNjU5Mjk2NTVjZWY3YjYzYTM2MDAwNzI0Y2RjNGINCj4gPGh0dHBzOi8vY2dp
dC5mcmVlZGVza3RvcC5vcmcvZHJtL2RybS9jb21taXQvP2lkPWJjYzc3NDExZThhNjU5Mjk2NTVj
ZQ0KPiBmN2I2M2EzNjAwMDcyNGNkYzRiPsKgKHBhdGNoDQo+IDxodHRwczovL2NnaXQuZnJlZWRl
c2t0b3Aub3JnL2RybS9kcm0vcGF0Y2gvP2lkPWJjYzc3NDExZThhNjU5Mjk2NTVjZWYNCj4gN2I2
M2EzNjAwMDcyNGNkYzRiPikNCj4gDQoNCg0KU28gYmFzaWNhbGx5IHRoaXMgY29tbWl0IHNob3Vs
ZCBiZSBlbm91Z2ggdG8gZml4IHRoZSB3aGl0ZSBsaW5lcyAgYW5kIGZsaWNrZXJpbmcgd2l0aCBW
R0Egb3V0cHV0IG9uIEFTVDI2MDAgPw0KW0tIXTogWWVzLiANCglZb3UgYXJlIHdlbGNvbWUgdG8g
dGVsbCBtZSBzb21ldGhpbmcgaWYgeW91IGNvbnNpZGVyIHRoZXJlIGlzIG90aGVyIHN0cmFuZ2Ug
aXNzdWUuDQoJVGhhbmtzIGZvciB5b3VyIGVmZm9ydHMgb24gZHJtL2FzdCBwcm9qZWN0IQ0KUmVn
YXJkcywNCglLdW8tSHNpYW5nIENob3UNCg0KSSB3aWxsIHRyeSB0byBoYXZlIGl0IHRlc3RlZCwg
YW5kIGlmIGl0J3MgZ29vZCwgd2UgbWF5IHdhbnQgdG8gaGF2ZSBpdCBvbiBzdGFibGUga2VybmVs
Lg0KDQpCZXN0IHJlZ2FyZHMsDQoNCi0tIA0KDQpKb2NlbHluDQoNCg==
