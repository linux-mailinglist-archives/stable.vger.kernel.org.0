Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6F2A34B0B72
	for <lists+stable@lfdr.de>; Thu, 10 Feb 2022 11:53:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240252AbiBJKxi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 10 Feb 2022 05:53:38 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:32840 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233542AbiBJKxh (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 10 Feb 2022 05:53:37 -0500
Received: from IND01-MA1-obe.outbound.protection.outlook.com (mail-ma1ind01olkn0170.outbound.protection.outlook.com [104.47.100.170])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 410ED190;
        Thu, 10 Feb 2022 02:53:38 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=AxuiZb9oB0yIPOf8AKh1gpaB7Vk2Q0jSyKyy/snwbfdU6wBhKFvwzobHVav+Tt5Va5harJAN6kRQTOTmOJQoUKtxOreCVV0ZOnxYtx9+0AFOI50nTS8EYDeIdTIU1WFZAOI+juKU2kAEl1WBQD9yNuwpImM1CYieReA3a5hkCKIsApueYCKRKxk+5JAIrzRKTcgfxaMpV0dVY0Qpa9CZybR89d3Rde0Za+8vCooqQMYRjrmfaYZVc/MscZbZfNTjzsXHROsA8efIDCqVgKxdZx2Ttp5x+f18RcrkCVB4IwMmAUSE1I6K9mxuiKXl19bH+3w2TfQ3XW+dB7bxPFXwVw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=UdPU5n90kBz6rNCDQOarVwI+VpqDMmnHaxK7mL3bNIs=;
 b=DNMoDYlwH9oIQL2XmRwaOWI8vjT4JF4I+p2WTTbF8DoEHQeutDgyfLtdCSUgKl0ujquraShJPMZIL/fQL2KSMj4J1EZ5QCw5k88ccmRaEV4dyUHHCaBGHBsRNTI+X4105prFuMw4z+rUnwmqStKta8c5C55n9+B6Ka9SRUNm9d8Bl9TcKVnHkPxrow38MoUXob2Ai6LOSGIKhH7lhU8gdtVWysn6kCoi6poUuKdm3N14Iml844mifM8mMrib0Sk6v2zq2obzLhiIknfAcAq8p0iylEUe9Lwbg7TFl4HtHtwkOXcddePPP510sEPQUI/FSexWEElz4slxXmgcRo5kBA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=live.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=UdPU5n90kBz6rNCDQOarVwI+VpqDMmnHaxK7mL3bNIs=;
 b=paT4wm1Q8XkhldEuRrYnhi8ajwPB/4tQgg9RP/zGiJPC885yNRocrDTl8+3cfly8gRkyCXiDiMLiKLnnOwHguqef4g0WGr+iNoB95jKYltWYsA12zhqySNUU9OGScKxDuZjbPEcFCaSoUXlaACAt5J1WS5G21qvWo5geueW5SCLBjaGhUU5kf4iBHT6R6ww/loSUldqVX+QWGzoX26pO/uGpbcWxRB4P+Jeomw6kxXB/e7RdDpEPGGSbFnSC5oem1Tq5uHT0jmRJRrwbvXhIfAuWScGUgkJyBe/2R2bqgiqhV46kFjaKGyguJn70diKNGGoEC5yez4hVmnMTDq7QyQ==
Received: from PNZPR01MB4415.INDPRD01.PROD.OUTLOOK.COM (2603:1096:c01:1b::13)
 by PN2PR01MB4714.INDPRD01.PROD.OUTLOOK.COM (2603:1096:c01:e::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4951.12; Thu, 10 Feb
 2022 10:53:27 +0000
Received: from PNZPR01MB4415.INDPRD01.PROD.OUTLOOK.COM
 ([fe80::d19b:7cd1:3760:b055]) by PNZPR01MB4415.INDPRD01.PROD.OUTLOOK.COM
 ([fe80::d19b:7cd1:3760:b055%9]) with mapi id 15.20.4975.011; Thu, 10 Feb 2022
 10:53:27 +0000
From:   Aditya Garg <gargaditya08@live.com>
To:     Ard Biesheuvel <ardb@kernel.org>
CC:     David Laight <David.Laight@aculab.com>,
        Matthew Garrett <mjg59@srcf.ucam.org>,
        Jeremy Kerr <jk@ozlabs.org>,
        "joeyli.kernel@gmail.com" <joeyli.kernel@gmail.com>,
        "zohar@linux.ibm.com" <zohar@linux.ibm.com>,
        "jmorris@namei.org" <jmorris@namei.org>,
        "eric.snowberg@oracle.com" <eric.snowberg@oracle.com>,
        "dhowells@redhat.com" <dhowells@redhat.com>,
        "jlee@suse.com" <jlee@suse.com>,
        "James.Bottomley@hansenpartnership.com" 
        <James.Bottomley@hansenpartnership.com>,
        "jarkko@kernel.org" <jarkko@kernel.org>,
        "mic@digikod.net" <mic@digikod.net>,
        "dmitry.kasatkin@gmail.com" <dmitry.kasatkin@gmail.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "linux-efi@vger.kernel.org" <linux-efi@vger.kernel.org>,
        "linux-security-module@vger.kernel.org" 
        <linux-security-module@vger.kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        "keyrings@vger.kernel.org" <keyrings@vger.kernel.org>,
        "linux-integrity@vger.kernel.org" <linux-integrity@vger.kernel.org>,
        Orlando Chamberlain <redecorating@protonmail.com>,
        Aun-Ali Zaidi <admin@kodeit.net>
Subject: Re: [PATCH v2] efi: Do not import certificates from UEFI Secure Boot
 for T2 Macs
Thread-Topic: [PATCH v2] efi: Do not import certificates from UEFI Secure Boot
 for T2 Macs
Thread-Index: AQHYHmtA7l9yrHRekkSNjXfJLtGDQKyMmlyAgAABqIA=
Date:   Thu, 10 Feb 2022 10:53:27 +0000
Message-ID: <F6FFC34F-4ACC-424E-85C2-FA482609815E@live.com>
References: <9D0C961D-9999-4C41-A44B-22FEAF0DAB7F@live.com>
 <755cffe1dfaf43ea87cfeea124160fe0@AcuMS.aculab.com>
 <B6D697AB-2AC5-4925-8300-26BBB4AC3D99@live.com>
 <20103919-A276-4CA6-B1AD-6E45DB58500B@live.com>
 <CAMj1kXFCibuLxbv2VxVsS0mWJ=6Lv8Q8sNq2GfPQDJ9qi5XB8w@mail.gmail.com>
In-Reply-To: <CAMj1kXFCibuLxbv2VxVsS0mWJ=6Lv8Q8sNq2GfPQDJ9qi5XB8w@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-exchange-messagesentrepresentingtype: 1
x-tmn:  [L2xrRFA2O/fP1eX7goCudnylWXLwdh7e3AU6ehaUbHNOIWmtnEJei3/ks1mR3z++]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: caf58f83-d8ac-4f23-b305-08d9ec8391a7
x-ms-traffictypediagnostic: PN2PR01MB4714:EE_
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 2QodOMR6Jsu1xrPPJefAijccH0MftdnsqhUGApa0f5FHscuM+aop+z++TaRSTwf+hhLZ6nFNHUWtQiqj/tzB1mOyeCXCDmlj6wfUfa52sKZq513/7hWkbqE8Cx3QhUyAgyXywdAZIgi7jX2N5hM6ix47Qhv6WNqXRkTk4TPXOcxpNiS+IlV7B7wlLARk7032H0ae8bZm7k9uxuAuKGf/v6GDOGxkSVu/DXjPt2nlo1KxLFae9oEDTksKlpVt7ancujL12I0vP6+qgKM6ytFSjEtUZQAHnlo5P+q40l+EFHNp2GCprh4Mf+FpDOpJKNOkmh6OxWj9p6r1XHv0fJPDq9l98Gqza3yOV0A8MvhmYHpN6aOLSmtpnL0avAV/7DH5mfuNv8tcnxPrjsj3x7f+yrN5ZvY5nHc81uC2FWd9YFwlOOyyifRQ+ihhyvoZJmR64ZdxkwCPORrCKECBThbR2a+5h0I09QO1bJV8+rN/N/pr1XwtF/60SY3T3wAQ0RthNOavNHlFwLl0IWAHXdRMplgZaM13SPQFcVoj+qmk09HBW8watY3avNLhEe8BKBv+4QTdFdt8KstNH0RrpnWPJA==
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?K3RlV0U2M2RtdlBBM2dZS1JaQS9QOXFFRVlwNVg0WHg0dHp0Mm03UUFKOEN1?=
 =?utf-8?B?WC81YmNaTGdpaTE1eG80SWtWYjZiTUh6ZnBsV1ZwUDh4RjBQV3pPaWZ6ZVpL?=
 =?utf-8?B?dXFaaEw4bkZ1N2pSWmxDenZPOCtiT09BVmFueEtzRzZoQkt1Q0VXR2Y0K0pl?=
 =?utf-8?B?bzFKeHpzOUNQN3Zuc2RENjZaMFdtTHgrY1Vyak92QVozbWwwVnplN01KNVBo?=
 =?utf-8?B?WUplTmxqR2tEY0xtRDM3Z1Arc1dYQ0ZQY0NxUWlZZXVMWlV5NVp5MkY3Ym1D?=
 =?utf-8?B?aGFGdDg1R2dhUDlQQ3AxcXJreHMyYWxvNWQvSmcvQjhyTmNQMEdUNSthVkgy?=
 =?utf-8?B?YnhjL0NIeW1EaXQzaXlrRUJlRVc1aHRZYjU4UExLNVVQeHQybFEwVGVuVlhH?=
 =?utf-8?B?Q3Ztb0I5TVJDUVFsWnJnT2hoeVF0am9La2FVL1BuRXR4aVJsS1pMSXJRQVp5?=
 =?utf-8?B?bXJkNG5JYldqb1JDU20xdStFQkwzQnkraFIvdk9kTE45b0dWUGxxVlh6Wlgz?=
 =?utf-8?B?Vm5lZUhiTVRpSDVEa2tJbmxJQm9xUUZteXA3Z3BPYjhoZTBDd3hSV0swZWFu?=
 =?utf-8?B?M3NJSGc4QTRNYm9RS3lvbzZsdmo0dElyMkViZElUa2Rod2U2YUg3dkloSFFZ?=
 =?utf-8?B?aUlHWjJydUxZODFZZnNFQkF2ZndyNjA5eE0wZzNRT29xSVpSdWFhYjB1ejJh?=
 =?utf-8?B?TFFjbTMzOWJPd2Q4cE9KSGoxNjk1Y1Y0STRWaFZWb2VZVUNjTFRxSG9pTlA4?=
 =?utf-8?B?eVNiU2VZd0RjSFo2WjZvRU41WVJXZjcyNVd4akxsZURycHFaY0VBNFJJWXlN?=
 =?utf-8?B?R2wwM0VsZnhVRlZnRFNuSlI2bzZDV3NkQy84Z2dMcE9aRnY3N3NJc3MySzBL?=
 =?utf-8?B?NCtQdzBkcFhwM3VJZTZBUFBJeTdYOExzNnRUS0M4eVRDa3BKeTJDUTE2ZTly?=
 =?utf-8?B?bWo3UC9rVUxsdWlqQ0NaMG1jV0dtcURnaTNUR2w5UitycjIyc0NsS3ZnQk9R?=
 =?utf-8?B?Wm5kYnNHam9ETVNZcEwvY3RaQzkxS1R2c0RtNVg1Q20yeXpQcHkweEY2WkJI?=
 =?utf-8?B?anJjSExXSGxxd2JjTVU3REpvM2hhUjJad2ZEZTcxak9xYmZrZ2p1UVJLSnZU?=
 =?utf-8?B?NFRzWWdMRnc5TldVZ2dZd1A5MjFHTmxER3I4azNYYWgxTGZXSXh5L0dhVWVi?=
 =?utf-8?B?VXFmTzBpclA3SWJGa2kyNXZsVTlSdmlKbjIvT1VuOTJyT1VWMXRrNG9JNTFC?=
 =?utf-8?B?eHlWSkRmM095Z0N3M0hOSkphdlR2YU5DZVpUc2ZpcGllY1IyNFZpeEtFaHd6?=
 =?utf-8?B?SXlIV21iVXd2cFFCZE14TlZUU010eWk2ZllESk1kU3RyeUhNdElSK3RoNUdJ?=
 =?utf-8?B?NzNoR0FmNFRBQVE9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <A9294B01946586428B7DC25C889E2F52@INDPRD01.PROD.OUTLOOK.COM>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: sct-15-20-4755-11-msonline-outlook-42ed3.templateTenant
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PNZPR01MB4415.INDPRD01.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-RMS-PersistedConsumerOrg: 00000000-0000-0000-0000-000000000000
X-MS-Exchange-CrossTenant-Network-Message-Id: caf58f83-d8ac-4f23-b305-08d9ec8391a7
X-MS-Exchange-CrossTenant-originalarrivaltime: 10 Feb 2022 10:53:27.7411
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 84df9e7f-e9f6-40af-b435-aaaaaaaaaaaa
X-MS-Exchange-CrossTenant-rms-persistedconsumerorg: 00000000-0000-0000-0000-000000000000
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PN2PR01MB4714
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

DQo+IA0KPiBOQUsuIEFzIE1hdHRoZXcgcG9pbnRlZCBvdXQsIG90aGVyIHJlYWRzIG9mIHRoZSBz
YW1lIHZhcmlhYmxlcyBtYXkNCj4gc3RpbGwgdHJpZ2dlciB0aGUgc2FtZSBpc3N1ZS4NCj4gDQoN
Ck9oay4gSSBqdXN0IHNlbnQgYSB2MiBpbiBvcmRlciB0byBmaXggdGhlIGlzc3VlIHBvaW50IG91
dCBieSBEYXZpZC4gV2UgY2FuIGdvIGFoZWFkIHdpdGggTWF0dGhld+KAmXMgcG9pbnQgb2Ygdmll
dywgd2hpY2ggbWFrZXMgc2Vuc2UsIGluIGZ1cnRoZXIgdmVyc2lvbnMu
