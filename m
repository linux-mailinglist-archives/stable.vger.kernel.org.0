Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E218F4B05E9
	for <lists+stable@lfdr.de>; Thu, 10 Feb 2022 06:55:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234524AbiBJFym (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 10 Feb 2022 00:54:42 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:47224 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231797AbiBJFyk (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 10 Feb 2022 00:54:40 -0500
Received: from IND01-MA1-obe.outbound.protection.outlook.com (mail-ma1ind01olkn0168.outbound.protection.outlook.com [104.47.100.168])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3A3E71D6;
        Wed,  9 Feb 2022 21:54:42 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=LLMqN5W8Wd1Y9NbGyFlDiN/dCsm6QbsnFCTVBv/ZGyUv/fIe8r+Fn7nLTPsSeWbMAZ0iCSYKLWH1tq6xN5MbbyJibAsY7ytj2cNkegINsRUYlBHFp0TWj3IoBhVayPRxYThhFDIVfXwaqHo7sxk0IseI+uOvpBKdZNNEQtEETj5TWRRCDYRFyI+iRnQWwVfn0KuwVd9Urn0Mk/mM+dPsEg9FC7wlrdU7QvXFPcmS5IQZ5QAfvOXLfWVMjMbutTE8KQSZo10nZ3W1J8K57zqNq53X/bpHYAMaTYszyEuQyCVXmaWQ7RpgkJRqH+o0deYuMWnrd2VOZH4SscVwr7YNdw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=JqtCOiZqURTFMZ+gtzsSxcOqfT6krkYRHwNRIJ3LFWA=;
 b=JKp+DthAemMTE/N7YrVap0xjV5iXhNOL7M9z2h3KC+eS1Z6YLv4XZueWkyXtXu3qdZGwC49yN9SNGyqI5NkWC4nUgtf6ZnmpzhhHsarkDTDpkFbMJisH86H3nqCp7I+iAlOCAHxQCdHMzvBHJyKZXX8opVCIvZS+RxcD4kQzt9IWczu3p9Fc+XmZw243tmocxwQ1/b2V3+pJBDYrd+1fWuS4BIjucG0RtMujGC5i8ZIWUklKXism/Icl5eb1UyVUPE2iK6mNrv3jmL/o91X4Y4ZE7jQvbhjiTY/2to1hyIcgrqZfWJN4g0xHB9cYP1zB9K7xktewkFQhGG6xmAj1fA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=live.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=JqtCOiZqURTFMZ+gtzsSxcOqfT6krkYRHwNRIJ3LFWA=;
 b=klBsvJp6yfRmpjbyntlu1x72/jtPR7OwsALGAc1rp0PBYIqr8NFkfwtwOswIBG0eDRAc9l+/1b5Yb6P3FhAT7hm3IDCdzEWaySLK0zfI7chNvJs78hhfz9KwVr2+5NWOkLPJh+wULKDKDdyiWJYUIo1tRrFoz+POVYNcgo4fxUPiRZxUBrLTbDHvP8sxspbu61FTl4nUAh8d51t4hHFYElOMfdbkBh2k33BDnwqjcLvuH2hWvPuO0k02F33IOUQNupGnxa81lKz8wYu1fb+Nua19eOgxlS+TVY6hD+jkl87VJohXsxYj/bOYFC63YQITAltoaehU691Ii+9GrQFGVA==
Received: from PNZPR01MB4415.INDPRD01.PROD.OUTLOOK.COM (2603:1096:c01:1b::13)
 by BM1PR0101MB1220.INDPRD01.PROD.OUTLOOK.COM (2603:1096:b00:25::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4975.11; Thu, 10 Feb
 2022 05:54:34 +0000
Received: from PNZPR01MB4415.INDPRD01.PROD.OUTLOOK.COM
 ([fe80::d19b:7cd1:3760:b055]) by PNZPR01MB4415.INDPRD01.PROD.OUTLOOK.COM
 ([fe80::d19b:7cd1:3760:b055%9]) with mapi id 15.20.4975.011; Thu, 10 Feb 2022
 05:54:34 +0000
From:   Aditya Garg <gargaditya08@live.com>
To:     Matthew Garrett <mjg59@srcf.ucam.org>
CC:     Ard Biesheuvel <ardb@kernel.org>, Jeremy Kerr <jk@ozlabs.org>,
        "joeyli.kernel@gmail.com" <joeyli.kernel@gmail.com>,
        "zohar@linux.ibm.com" <zohar@linux.ibm.com>,
        "jmorris@namei.org" <jmorris@namei.org>,
        "eric.snowberg@oracle.com" <eric.snowberg@oracle.com>,
        "dhowells@redhat.com" <dhowells@redhat.com>,
        "jlee@suse.com" <jlee@suse.com>,
        "James.Bottomley@hansenpartnership.com" 
        <James.Bottomley@HansenPartnership.com>,
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
Subject: Re: [PATCH] efi: Do not import certificates from UEFI Secure Boot for
 T2 Macs
Thread-Topic: [PATCH] efi: Do not import certificates from UEFI Secure Boot
 for T2 Macs
Thread-Index: AQHYHcE4ht34Z1CESEaNjR8+yzmieayLbqGAgAAURwCAAAlIgIAAvaYA
Date:   Thu, 10 Feb 2022 05:54:34 +0000
Message-ID: <A069AC2B-7F37-414E-A411-291DCF407AF8@live.com>
References: <9D0C961D-9999-4C41-A44B-22FEAF0DAB7F@live.com>
 <20220209164957.GB12763@srcf.ucam.org>
 <5A3C2EBF-13FF-4C37-B2A0-1533A818109F@live.com>
 <20220209183545.GA14552@srcf.ucam.org>
In-Reply-To: <20220209183545.GA14552@srcf.ucam.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-exchange-messagesentrepresentingtype: 1
x-tmn:  [UaDD2WGAm/O1gcf9fqoyIgMNS3CC01GJcZwpzTSxae16H4Xxil6PobQbOWV5LFVG]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 7dc7c251-fdc3-48f4-c01e-08d9ec59d09e
x-ms-traffictypediagnostic: BM1PR0101MB1220:EE_
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: sf75rDWroWd5tIq/jIhi7GxRnTB5dwWpsVEsgJBC7f5xecHYjduUmiMUsVx9tySHLcDHa1Y8WXkSnt+cLQ8oBZFGUE6bgAj3Uv4ZzcVRrNs+XI6A31CdUaJhfiydihsXfixjav35/jHv7NJKtW1q7vPa/9fh7IHKfr9B0doGWI3QyeYrwxLAV+EFnc4PYoAO/TMJeNz4kkvT8JnNR8Ie9qGtZNNKzJCHuGaj1lz/b759t55SO2hBGMc2NLQMuEs+FdDbjjBCH2MFn70FQ00O+S9ZKvACg9TEFRFtqx6oTD2/BVjyPXZIiuC3KqUwojOBnaoj30n5WdI6bqamMcTRHCMZy2rE8G1UU0hzQZ15XrQuLKyD5lIK++VhmyQ1LJh+5u6zxv6V439mxqv7LghaEJa6VJ/mi2DzGvWxpbvBsDwxGD6vnT4Oc5u7MnKu3ekY4wpoNEkRjTiI2HdAsHpDWkWgn+o8rPzjAMDkioso+G9eixornw/p++UIfBPYEd5lXpPxjDU7fxibT/h/UB2iKUz7/RmM791W8mZVbeop9MyGz/VxK7m2a6TlP5/3UxlOsVNauq8Bbf254gjrHG3taw==
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?n0oaiaq2kP/y+aj6D+eH68bYGrtG+cge2mmPSJzothDyucqjJ+1aoWL95kxj?=
 =?us-ascii?Q?k6x6zsdwdQvgPGr/tki5qOwyLgz2dXS4tj3u3W6DHtpeiuPkbtMwOjMd9PEe?=
 =?us-ascii?Q?x8X0HgPozp9RDLyoat9JIGmSrYztHEj6wJSi8exgSHXtZZYyZK1CgImJZSkY?=
 =?us-ascii?Q?bdmki7QaHBWVuEPVinIUpJ7n6LdFRylWYibY7Z2cagN0ERr1x+ReruAzI6zO?=
 =?us-ascii?Q?eIufQntCUNS7Tek64UX1wy6sZ8wXu2nFMZE2TgieRwhC3mQZQa1hEVBozq2x?=
 =?us-ascii?Q?FlyP9lvtM8jIHUgHs4yFPTdGMPNv1YPjbWYXqpD/Fd+1raE4scniM1HYbeWn?=
 =?us-ascii?Q?bRpoQ/2aaU7YPGkEJ4KoRlkbRWseIATzureyrel0r/sdRE4irm9FFS2NzDLG?=
 =?us-ascii?Q?iEP7+MMiXlNFcXHffRTu3Lug22aJNqZKOSyv9fNaqdZdxU3exWKLbAkrs2gE?=
 =?us-ascii?Q?dBbNOxW8vMrHcMZSFQTwR0lD6KlBtpMm0cjbXrjFn4vA8B0TPx8f3K5HPAow?=
 =?us-ascii?Q?MiwUcjPVPQ3SPm5qsl2ztPQ5TccwoxP4xoCqYKlM+8Q7Vq8B8JkD1aWt00lS?=
 =?us-ascii?Q?eijM6K6V1m7BBdUKMNJcH/0EH5CpOAUdWv1hzOwSYbL3S5gDBI+/nJIYRcNY?=
 =?us-ascii?Q?evcyCTqJ+AAjKPPBXCHFOcz8iO9MYXXSKQ6kNiICelzdztOpdLxEnoWCXNk+?=
 =?us-ascii?Q?R3vSufEAiaTcvOjNmdgxcpbO2tWskr+g69MAqlHlnsPJP7sbFN74VhAoEJr7?=
 =?us-ascii?Q?bHp5nuxYzlaF8mEFoJ8vg7drugM8YAvAWtMWGpCuIlbPypbySKfmg32KW89D?=
 =?us-ascii?Q?o+00eSOJtYh/KTW2FDWuGHAgpBKWnDBL77+/bxEEQstNzlYB/nPYwTL8GEIx?=
 =?us-ascii?Q?2CrHCyJ1on4echB+tqEEEk0rt38E1hzUoPJgw2yBILwH2LPP0YFRRaZ7QTOu?=
 =?us-ascii?Q?greinLiwq/NtHfXbRGTn/YRsJki4fKLuwXcHrY6im0Swc+NuoieGOakM4b5a?=
 =?us-ascii?Q?N6vT1cN2KcVFim7Aq96y6DApmw=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <A0A64CBA3BE0714DB71E34B4491AE05B@INDPRD01.PROD.OUTLOOK.COM>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: sct-15-20-4755-11-msonline-outlook-42ed3.templateTenant
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PNZPR01MB4415.INDPRD01.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-RMS-PersistedConsumerOrg: 00000000-0000-0000-0000-000000000000
X-MS-Exchange-CrossTenant-Network-Message-Id: 7dc7c251-fdc3-48f4-c01e-08d9ec59d09e
X-MS-Exchange-CrossTenant-originalarrivaltime: 10 Feb 2022 05:54:34.2820
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 84df9e7f-e9f6-40af-b435-aaaaaaaaaaaa
X-MS-Exchange-CrossTenant-rms-persistedconsumerorg: 00000000-0000-0000-0000-000000000000
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BM1PR0101MB1220
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


>=20
> The LOAD_UEFI_KEYS code isn't doing anything special here - it's just=20
> trying to read some variables. If we simply disable that then the=20
> expectation would be that reading the same variables from userland would=
=20
> trigger the same failure. So the question is which of the variables that=
=20
> LOAD_UEFI_KEYS accesses is triggering the failure, and what's special=20
> about that? If it's a specific variable GUID or name that's failing, we=20
> should block that on Apple hardware in order to avoid issues caused by=20
> userland performing equivalent accesses.

The size log seems to be extra when crash occurs

integrity: Couldn't get size: 0x8000000000000015
integrity: MODSIGN: Couldn't get UEFI db list
efi: EFI Runtime Services are disabled!
integrity: Couldn't get size: 0x8000000000000015
integrity: Couldn't get UEFI dbx list
integrity: Couldn't get size: 0x8000000000000015
integrity: Couldn't get mokx list
integrity: Couldn't get size: 0x80000000

