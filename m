Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AB8565FD385
	for <lists+stable@lfdr.de>; Thu, 13 Oct 2022 05:18:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229543AbiJMDSS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 Oct 2022 23:18:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59972 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229451AbiJMDSP (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 12 Oct 2022 23:18:15 -0400
Received: from APC01-SG2-obe.outbound.protection.outlook.com (mail-sgaapc01on2079.outbound.protection.outlook.com [40.107.215.79])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3469F110B15
        for <stable@vger.kernel.org>; Wed, 12 Oct 2022 20:18:13 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=SHNY1iGv4x0uLPzDRRUvGGKfEM+W2WoctoQXNIoD3FZAgbfD1EJvFC0FXLRD0jCjPB38bgUCFo0SjGaJWyghGRdSXVBisHqT0KWfOekPHYryDRRYj5juEB0rA2jRFoYIOszIOe9bPhWHp/eF5gDe1sryhW+Q5iVU15x8T/dJFw/VrTzl7u8XW6Q+sJGxLFA4HVuWqG8CNMjmmYHEuQG0wB7y7zHQNdxQi0q5aCuquVx3ADs+zixkcyj9Mw+HNl3o9n4c8A6ZhgXIA3blWtvqI6PeBJ9xZdtNsQmLRXkacCEXTqVJ793ni4VM2KeOGYjb2ebGj8kemhxaQj13iW02/Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=XsgeX3jWbQgWmjICUdwp9FHAdDIV/izg+qcCK4rvC98=;
 b=Ye/lf4TAMURGX1JktioQGizsyifb02q1xf2ILfKjLNwlYVrFBPqWCEaly+lsCRj8jQ3wyWyymO3XFuj/INyvDG8JeWYpt0xYs7jjAXmEX6RlOmdSKNFFqEPjS2TTaTgyDnsUMRraGrAjVCkjLG4+QijY8/tmlF7kFCcsz1ME2VHZOaEdA+SQv0C8RWHZre93vw+QwFFAKsD5MI0XarWllt/BXJZi1entaE3jXQIXG/uyCtwKCT0lQowUBWXFXoZ3A3MkGlf8STnK2lZv2Q4k0nviVFY2Lq85+G9Uf7MRg+X8HwRCEQbkGUFDCJEPuFNz0BREzOkrCgTv0oiCSr3btA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oppo.com; dmarc=pass action=none header.from=oppo.com;
 dkim=pass header.d=oppo.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oppo.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=XsgeX3jWbQgWmjICUdwp9FHAdDIV/izg+qcCK4rvC98=;
 b=QmSPVASj4VEKKSUKL7VGLkL53qC/OrijYWsHQhTjWlBYCB+/lqsiR+ql8kj9PztiJJZted4qk7rraU2c6CtE0QapQBMOjzs97llv8K4sZTOuOvyxYDpHpRpgnkdC1yWat4v+xtOnbLyAEq/oJjs0IE2qC/cH3nrnX7t567SVq4Q=
Received: from SEZPR02MB6007.apcprd02.prod.outlook.com (2603:1096:101:7e::10)
 by KL1PR02MB6168.apcprd02.prod.outlook.com (2603:1096:820:b1::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5723.22; Thu, 13 Oct
 2022 03:18:10 +0000
Received: from SEZPR02MB6007.apcprd02.prod.outlook.com
 ([fe80::3402:acf8:13e7:9741]) by SEZPR02MB6007.apcprd02.prod.outlook.com
 ([fe80::3402:acf8:13e7:9741%7]) with mapi id 15.20.5709.015; Thu, 13 Oct 2022
 03:18:10 +0000
From:   =?gb2312?B?wsC437fJKEdhb2ZlaSBMeXUp?= <lvgaofei@oppo.com>
To:     "stable@vger.kernel.org" <stable@vger.kernel.org>
CC:     "gregkh@google.com" <gregkh@google.com>,
        "jaegeuk@kernel.org" <jaegeuk@kernel.org>,
        "chao@kernel.org" <chao@kernel.org>,
        "drosen@google.com" <drosen@google.com>,
        "linux-f2fs-devel@lists.sourceforge.net" 
        <linux-f2fs-devel@lists.sourceforge.net>,
        =?gb2312?B?wsC437fJKEdhb2ZlaSBMeXUp?= <lvgaofei@oppo.com>,
        Hyeong-Jun Kim <hj514.kim@samsung.com>
Subject: =?gb2312?B?s7e72DogW1BBVENIXSBDaGVycnkgcGlja2VkIGZyb20gY29tbWl0IGUzYjQ5?=
 =?gb2312?B?ZWEzNjgwMjA1M2YzMTIwMTNmZDRjY2I2ZTU5OTIwYTlmNzYgW1BsZWFzZSBh?=
 =?gb2312?Q?pply_to_5.10-stable_and_5.15-stable.]?=
Thread-Topic: [PATCH] Cherry picked from commit
 e3b49ea36802053f312013fd4ccb6e59920a9f76 [Please apply to 5.10-stable and
 5.15-stable.]
Thread-Index: AQHY3rJrqaHnZrUO7kO2CGyCX3qiMw==
X-CallingTelephoneNumber: IPM.Note
X-VoiceMessageDuration: 1
X-FaxNumberOfPages: 0
Date:   Thu, 13 Oct 2022 03:18:10 +0000
Message-ID: <SEZPR02MB6007FD0908879CDAEBB12216AC259@SEZPR02MB6007.apcprd02.prod.outlook.com>
Accept-Language: zh-CN, en-US
Content-Language: zh-CN
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=oppo.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SEZPR02MB6007:EE_|KL1PR02MB6168:EE_
x-ms-office365-filtering-correlation-id: f4bf3a6f-beec-4d8d-18c1-08daacc98e43
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: fYgrfOt67pT987izloYQWwF/3s1F1sNdV87TrnzmY8o2wHkrB9I0rJ5CPqYXe+2InsVy5Rz8p0qEu07cDuEYQxJ0Njkqv5km1wiHuWwCudvQ2Ku03deitFdUDSRqAQkui8VO4gSuNHfGh3eYQX57wuQnFum7cOk7NWG8vA+sqPZj5dLX3qDjyT7Ldr/ICPz/pasm75tSYsPXiwO5DtC50gKZDeqXiELg+5EOowJLaUWZ17t5Kx4RhCi9w07yBUv7h3Try7tMtdFm19laQMp57gJag+5e6i7WZcg8PvFP5B0yTk/djbIMjyBl2RllvaNGHHp1EWavuGgILz05G7rFxretKJYzIQtHPVhrkWkB3aFMQxgQ3pJjGMHgLCL2359PqHOsiyQe549Zr/RcI+xfWN0btKgPQNim6dJhRnCtQIC8wPBBBPnRZRDU9AIx4HjKvsOLjowHJCO0/sNwPOTeUaz0+Hrn2pd9y8qDAvxRDYuvGjOv2W/2fOTdkru0inxkh+sU2iW3VMzC2FKQa4T+9pqwx68QKV/+FKtPcEfOud1jaSoWebW0DhmzmU2L6ncke7fBUxf8kUWYE6yU38YlTQBubXRwkWmCv0q715aa2bbS4Jk4sAU7k4fA4oTmWEl59zzxD2Q9fP8N8H50/N4ukNK6v/fZMXncGQ4RMuIwV15t4fECjvVU2KTgMQet5nFXjMg9tZHZ+sm0PAkaRZfO+ahXtMqTA3rV1Rd8kJmpOyAF6Woivz6xi56qJ7DULvbR
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SEZPR02MB6007.apcprd02.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(136003)(39860400002)(396003)(346002)(376002)(366004)(451199015)(316002)(55016003)(33656002)(54906003)(6916009)(8936002)(186003)(122000001)(26005)(9686003)(52536014)(4744005)(5660300002)(2906002)(224303003)(85182001)(4326008)(66476007)(7696005)(66446008)(64756008)(38100700002)(76116006)(66946007)(6506007)(66556008)(41300700001)(71200400001)(38070700005)(83380400001)(86362001)(478600001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?gb2312?B?eGRKamdPOVlsdGZtcnpEUjk5TmxVTmRsY1A0TTdKams3eUsrVExnVG5OTC9E?=
 =?gb2312?B?Z3BhT1QyRlFIb3RmTkdLbkZzekREWVVoalNWWllEWE9KTW53YnBGd2dDZDhH?=
 =?gb2312?B?emswRFc4Qk5BRVUxSmdlM3BPdGZ6ZkJPaWVsclowSHZWVnRkcVpnT00yMkZi?=
 =?gb2312?B?RWlCa1lHRklRaUhNK29tTWpWZVVjL2lPZWZqTktmL1NydXBIYk5NSlRBTkU3?=
 =?gb2312?B?QmJMQklOd0t1aUM2bWFGVGYzOU9wWW5GaWZMQ0UyL2VUaDFSL1pXSlhUMm8x?=
 =?gb2312?B?V3ludDJwbVlUSmdmeERwSHlEZFBHYS91c0JnZzExWjlBemZWaEUvUFpSOFNK?=
 =?gb2312?B?UEVBYzRySDROL1d1UHRHTGMwdnIxRlVxT00vY2RQOE5KckVWT0QyeWZFMjRY?=
 =?gb2312?B?ZnlSeVNzdFdQcVlQSU5PT1VBNS92S0gxRGgvRlRoMDZEY0dVeVRheGNmTEIx?=
 =?gb2312?B?R1V3UjFGb3ZISDNMZXFjS1JLRXhsU2RPQmRNKzNpNTlvaXhlbFRmMEZHYzJL?=
 =?gb2312?B?UW80TGRqczUzdE1LU0g1QXp4azI1TWlTZmtDZVRxeGFzSERKQmY2MmdTaS9u?=
 =?gb2312?B?bklyek5sT1AvWEZ5bVlDYWRBYzIybUdBUnRiWlE1dTYwaTFqZEdQZVRkOTRM?=
 =?gb2312?B?RkNFdWc4MU1GemFON0VEbmU5ZjdqNTlsL2VQZXFRdzZJYk9oMFZOTWxMbzRW?=
 =?gb2312?B?emxYaEo4M2NTb3pZaHkzS3hyRjNGdlJHRkpsd3VDL1g2NHlTZXVNY3ZsUUlj?=
 =?gb2312?B?YXpHK1Y3aTRDMWFjTFZwYzcxUGdCOGVTSHNsdlFRaWlSZXUycU5wWUYxbkFj?=
 =?gb2312?B?ZnlraHp5d1hQZ05hZEJzVXovTkFhRjIwYmtpdVIrUTdxYzRtSExadWZQOWJ2?=
 =?gb2312?B?VGdWbllhaXU0OG0yb1NiUk1STkNONm9IMWJnNDJHd0xEb256MlB4MFV6dTdj?=
 =?gb2312?B?b3JGVkhKbEd4ZVR5dGFqZ0gvS3dqMUFOMFVBdVAwRENOeEF1YXFHelJyK1NN?=
 =?gb2312?B?UTJ1NTdzUU81VXJ0MmEwOGc5ZE90eHVIM2FNMDVWZ2tXK2xOalZFMlVtc01M?=
 =?gb2312?B?WDBRYWxEY01YenUwSUJXZG9QalRMWG1XWDk1a0JRK0ZYQ2V6U0hVVTR2NVdl?=
 =?gb2312?B?Si9TRjJvZFF0eVMzR1dMelAvQmpYNG1Pb2RmUjZWMk5RNmV1TkxrODcyYWx0?=
 =?gb2312?B?NGpsV0J6aW1mTFRWNU9pd1V4Qk1lTkFEZmtNR2QwZzgzOWp3Rnd6MTVuc0M4?=
 =?gb2312?B?bTdQMkFSQUVoUDMydHlwMnVGR3pvZDNFQmVXSDBQZTFyckJxY2pYWEZCQjhK?=
 =?gb2312?B?SURYV1Z6RkxNVkVIemhSdThDa2xyRS92NGN1RFRhcTFEVDNMZzY2Vk81MGl2?=
 =?gb2312?B?RTZOTDBNaFJXa25oZkllSDRyQzQ5UmJNWVUySnNUK1M1YytUKytBTGYrOVly?=
 =?gb2312?B?bW8xQkxJeDQ3U2psSWRIeXJ6bzNuQ1NWZStqZUZudlNiUlFibENJOG9Ka2Nq?=
 =?gb2312?B?K3E4K1RQaUtiREFGKzBnYjEwN2NZaXFEcUVvaldLa2lWMCtWRitRVDROVE5v?=
 =?gb2312?B?R0ZHNWFEWGxrTi9WZTV1TGFEMURLRkdnZDNHNGorZnBwd09CQ3BETmV6bysr?=
 =?gb2312?B?a3Bhc1BQekNwUVpVR2o0SGVoT1RUQld6TUpJQmMzSWlXdnZFSXo4M04wdWIy?=
 =?gb2312?B?UjRuRGdUblBINFptR1JhbnNHaWFWcDJIY2V5STZLaDNRWStKbmJsWFRHZUhE?=
 =?gb2312?B?V3hZNUxNSnh0amVVTzJKVHJaWEgrV0ExVkhEdURpTzE5RW90RHRydEtUK3NO?=
 =?gb2312?B?TVhPbkVyRDRIeGRORVRrTUdXN1J0R045ODVkaXR3Yks1eHJaUUlDeXBTY3ow?=
 =?gb2312?B?OUdPSVZ5dW5jZ2cwb1V5WTBYcmtvT3R6T09aMzBGT0gzdWNVVnNIdHN0a3NI?=
 =?gb2312?B?YWp0QzFYNTI2MGJtNFppWjlEUUVTRUZKNWZYcy9FYUlSaEp6eVA5SFZnUjZD?=
 =?gb2312?B?QWFLQ2Q1UmxGTlJMaVdGZHZscDdaTXdwa1E4bE0wdStrN05aSXYxekhMZUE4?=
 =?gb2312?B?M29MRmNRV0VkZFVROW5QVW9hQjIxRFhuYmc5ZyszUFd5MnNBVGg4MHFtWTR1?=
 =?gb2312?Q?XjOJIz7PuJNHjr49/tT1kOzcu?=
Content-Type: text/plain; charset="gb2312"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: oppo.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SEZPR02MB6007.apcprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f4bf3a6f-beec-4d8d-18c1-08daacc98e43
X-MS-Exchange-CrossTenant-originalarrivaltime: 13 Oct 2022 03:18:10.1199
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: f1905eb1-c353-41c5-9516-62b4a54b5ee6
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: RI3nvQGPFn0zXZvBgxgu26oxCz+ncmCA1hS8ZBLoKauY4oLk0iWE2AovGHn46S5L1dujTrjrlyOF7VoxkiRL3Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: KL1PR02MB6168
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

wsC437fJKEdhb2ZlaSBMeXUpIL2rs7e72NPKvP6hsFtQQVRDSF0gQ2hlcnJ5IHBpY2tlZCBmcm9t
IGNvbW1pdCBlM2I0OWVhMzY4MDIwNTNmMzEyMDEzZmQ0Y2NiNmU1OTkyMGE5Zjc2IFtQbGVhc2Ug
YXBwbHkgdG8gNS4xMC1zdGFibGUgYW5kIDUuMTUtc3RhYmxlLl2hsaGjDQpfX19fX19fX19fX19f
X19fX19fX19fX19fX19fX19fXw0KT1BQTw0KDQqxvrXn19PTyrz+vLDG5Li9vP66rNPQT1BQT7mr
y761xLGjw9zQxc+io6y99s/e09rTyrz+1rjD97XEytW8/sjLyrnTw6OosPy6rLj2yMu8sMi61+mj
qaGjvfvWucjOus7Iy9TazrS+rcrayKi1xMfpv/bPwtLUyM66ztDOyr3KudPDoaPI57n7xPq07crV
wcuxvtPKvP6jrMfrwaK8tNLUtefX09PKvP7NqNaqt6K8/sjLsqLJvrP9sb7Tyrz+vLDG5Li9vP6h
ow0KDQpUaGlzIGUtbWFpbCBhbmQgaXRzIGF0dGFjaG1lbnRzIGNvbnRhaW4gY29uZmlkZW50aWFs
IGluZm9ybWF0aW9uIGZyb20gT1BQTywgd2hpY2ggaXMgaW50ZW5kZWQgb25seSBmb3IgdGhlIHBl
cnNvbiBvciBlbnRpdHkgd2hvc2UgYWRkcmVzcyBpcyBsaXN0ZWQgYWJvdmUuIEFueSB1c2Ugb2Yg
dGhlIGluZm9ybWF0aW9uIGNvbnRhaW5lZCBoZXJlaW4gaW4gYW55IHdheSAoaW5jbHVkaW5nLCBi
dXQgbm90IGxpbWl0ZWQgdG8sIHRvdGFsIG9yIHBhcnRpYWwgZGlzY2xvc3VyZSwgcmVwcm9kdWN0
aW9uLCBvciBkaXNzZW1pbmF0aW9uKSBieSBwZXJzb25zIG90aGVyIHRoYW4gdGhlIGludGVuZGVk
IHJlY2lwaWVudChzKSBpcyBwcm9oaWJpdGVkLiBJZiB5b3UgcmVjZWl2ZSB0aGlzIGUtbWFpbCBp
biBlcnJvciwgcGxlYXNlIG5vdGlmeSB0aGUgc2VuZGVyIGJ5IHBob25lIG9yIGVtYWlsIGltbWVk
aWF0ZWx5IGFuZCBkZWxldGUgaXQhDQo=
