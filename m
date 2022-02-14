Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EC0F14B3EA3
	for <lists+stable@lfdr.de>; Mon, 14 Feb 2022 01:33:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238881AbiBNAdi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 13 Feb 2022 19:33:38 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:51878 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231916AbiBNAdh (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 13 Feb 2022 19:33:37 -0500
Received: from IND01-MA1-obe.outbound.protection.outlook.com (mail-ma1ind01olkn0156.outbound.protection.outlook.com [104.47.100.156])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7FF3851E72;
        Sun, 13 Feb 2022 16:33:29 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=aTuJlX+H4dsjfKf6AUr+X07xjf1PnuaD+hGL2JzhSkHDas2+f7G5RoXoABikklPjpMDnxzGjMgcjdcg8zKV8yb7A90aJwpwepSkVtFPLF22008+01rQgzpGFZsHSs7k7t7Z8y1qzczgECICVc8Kz4q6OQvyUFGhe9PTvY+H1MZ/lKv0PTOfOJad0AF+S9sYRtLWcksgDvqrBEHfmeSUOvv7NCw7mBmxGJVcTrMOVletH2s+T/+iMrCiQd9X1ngw14ho3YopID7cdgHbwddM90ZorlOj9tPkrtqosUFK79Xlg9N0NS4XzBCfTtyeyM03F1wT0FzuMByJ4G8Jwm0qsug==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=uy9W82p7OTLyHEyOZZdb+e40a7gufEU1KmEYAT8FBVg=;
 b=mP+uFuKjXDjs1fURXZ8nzbNynxGSHSMN0rXWrAOlvERTBD4ChlmrKSgz9pDYobTomjU3fHgyWAg9l/jiHOviQB3KJOEFYvGhUv54RienbRUhE4sC6q2tZCAeWCkCnr2dUBmTiuGnKF0PS6LXCqkH3H1+OGJSmTIyLpSqQ3ody3uK/6zAAUpd7ysddHepVRXIcUvTvxS1poHJV/1ASZCkNVr6h0RVSTQOqSrbjdPUYDU7yFP4Ky0QVwbYpoXudAv3NUULLz4HPxmQhFB+YFC+RfxXF0pUAw0dAmJXu3maqoo/Qv+55MbPzNoMZ/xNZMVnKp7arhMZkVOShiBy2tekzg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=live.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=uy9W82p7OTLyHEyOZZdb+e40a7gufEU1KmEYAT8FBVg=;
 b=WOq7m/KdCjkGB772cKWngw22XJdU3PI5zXGjKOvlXgEEZMf0/1aEtx3hTjBCsD5Hek0Ohy4skv9Epinx8jBYaORIc8/EHWfwc7HZtdkwxWWuJhYmdh+QFAGpH79IjHncc681aDlUz8DT9qGVRtDwRRVY9F9AbaxuHtnaU4XAzSgbFaq+d/QIq0/f9Cx8LHkGLsfXALY5QrqGUGE8RU7pWOxyzoIuqa6QpMm+C8gd0ZCK2zKETXFrahcjEEoncmopHprEJWpgw/EQd//qLyWg7H+tKiZO8fpKZp6/djlaq4vR01s53EKxN5AuvUzfsdp7YuLGqek++6cUePV6HVy6Kw==
Received: from PNZPR01MB4415.INDPRD01.PROD.OUTLOOK.COM (2603:1096:c01:1b::13)
 by BM1PR01MB3458.INDPRD01.PROD.OUTLOOK.COM (2603:1096:b00:69::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4975.11; Mon, 14 Feb
 2022 00:33:17 +0000
Received: from PNZPR01MB4415.INDPRD01.PROD.OUTLOOK.COM
 ([fe80::d19b:7cd1:3760:b055]) by PNZPR01MB4415.INDPRD01.PROD.OUTLOOK.COM
 ([fe80::d19b:7cd1:3760:b055%9]) with mapi id 15.20.4975.018; Mon, 14 Feb 2022
 00:33:17 +0000
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
Thread-Index: AQHYHcE4ht34Z1CESEaNjR8+yzmieayLbqGAgAAURwCAAAlIgIAAESOAgACrMQCAAM6NgIAAs3IAgADC6YCAAODbAIAA55oAgADUSoCAAN0EAIAAMjSA
Date:   Mon, 14 Feb 2022 00:33:17 +0000
Message-ID: <272196DB-04A8-49E2-8BFA-545F989C0A5C@live.com>
References: <5A3C2EBF-13FF-4C37-B2A0-1533A818109F@live.com>
 <20220209183545.GA14552@srcf.ucam.org> <20220209193705.GA15463@srcf.ucam.org>
 <2F1CC5DE-5A03-46D2-95E7-DD07A4EF2766@live.com>
 <20220210180905.GB18445@srcf.ucam.org>
 <99BB011C-71DE-49FA-81CB-BE2AC9613030@live.com>
 <20220211162857.GB10606@srcf.ucam.org>
 <F078BEBE-3DED-4EE3-A2B8-2C5744B5454C@live.com>
 <20220212194240.GA4131@srcf.ucam.org>
 <C737F740-9039-4730-9F08-9E9E9674B6C8@live.com>
 <20220213213332.GA30613@srcf.ucam.org>
In-Reply-To: <20220213213332.GA30613@srcf.ucam.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-exchange-messagesentrepresentingtype: 1
x-tmn:  [34BNRea3seamNuZhnMi5/nbZaP5GvQBLBOmY5TDKuBRPu8dfDAB3lwSkfepxnK2E9+m6adSn1gU=]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 5d93fe6f-7807-49c5-99ec-08d9ef519867
x-ms-traffictypediagnostic: BM1PR01MB3458:EE_
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: icmID9FJgPz/gtb8PHnb5/Yrp+SQR+EDYtK4KshTV7clXrnvVXVhvTC78FYHv56+0iscePRXzf2jd1l4OM62P+KcB0Wv8oAiB9HOmJ4Ro6dfrLUR5jgqAazywMqUgjZtr9jM7ejS5lU+3qTZCWhN1UzvH8fpJgO8+yq5hlzBFdbTYKwsoBamQly8vcFXnC00D4jTAOV+tyXuKSXHGlnqSHu3puml5CL+49PNvfrlCOzNDBWi8CZXPwSWb0q4BCeACfUuNNqZHONtssesLLXUqMCYTARF6VYPtYVhgdyq1cCtRKTL0Mc0h4WoiaLI/QYl8AIWKMAyljvBMBTmf9nfd5ya9QCSORRTSajiHkZyk5laE1II2PrHoBPG+zmTQA1zJ+CXVz+7nuTIZIwmey+AkygEvuty74OPY2reAGeGWP+sYBbgVrHniioHBe+Bu5xlQQy8mGHn8l3wNkVNUCJ5gc6ACIpxM9Bqpoq/6SKBhu1vYXqrm1w0pKELUP8sdrA8CrwExACmQZ1cYPjkEl9jcP0HiqwgwM/h3jGxxcaRM9wrJqhPEzjdcQ4tFJbI7AfP8P8mHpKqHygX5TJ1MQiJGyQIctlnhbjCC+CEX9On/783SFZhPNNxiKw+GYY52+Ia
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?Nodu13WKxulrXKuuhOpdiNhHh/erYsstyrgvolR3unUMHfJBSELtymVHEnmu?=
 =?us-ascii?Q?7niIox2I0Ieh83tvYeTfnXxWPKjM5HH5GHumtZ1Lt8ghH+oKbQhchpOfWASY?=
 =?us-ascii?Q?33y2yfiiK7BiHY6LE2djDg1cJpLTiMZbnIaUvXTuCY50iJjsUKLD61r91DNY?=
 =?us-ascii?Q?hbtkilcRM3FxQ0djupuIBT00TPyqK120r4e9gsmT6NqDQwnGt6NR28fu81dJ?=
 =?us-ascii?Q?uSmTczHOtcHymSDjrWWw6imgJa8wGQpWZsJLw8+nVXh6WDwekWILPcDX10zt?=
 =?us-ascii?Q?62PJUumPWo9GOUnFnxgpUxUPoH2CBv87V1/ukl+hDhibR6nccTrRAKP+eguT?=
 =?us-ascii?Q?LEzAgp/BqwFK/N03ZcEybQ32MINw0BGrqlcVPkaEE7abeBErU98K/dD3/Ca2?=
 =?us-ascii?Q?vAmMK98D8dQMmwnxvBMvtxLOAmrgVB4BFDWppzZMJATF3R6c/NmlxWAPCt9M?=
 =?us-ascii?Q?Mi5JK/+SVqUD6jkXQ6+ScUqAX22K2kwm3KKhBlFPoB5awxz1xHevJZHD8Kdz?=
 =?us-ascii?Q?aY45riP+/+BpZQBzNtxDCZLS4iY6v8+eLWCa7gFmINywAj4ehKDb34qvCqDB?=
 =?us-ascii?Q?i6eehR9G65g2pFlkrXV/TBNqhl60Wtovp7EbHLMvhwyHM+kv7brDaITbIguh?=
 =?us-ascii?Q?tdiDtmDKgMozPuk0LSBIFwx+kjMCA55JJ27odvvXOLCzu7kLsN/ulNS61dEV?=
 =?us-ascii?Q?PsWyPhB16ltZ1xtPZ87wxdK6MtZoAgr609dKKWagL4gF9NuZrQ3GTSTdvFsn?=
 =?us-ascii?Q?2/4Ixu5Ar6bD5PFr0qjr5XxE/ar8gtG5RegF7JtKP0brCsvtoV0rYb8LCkpS?=
 =?us-ascii?Q?qsLaVzLlj6fScPSJ9r04hhHr03/6Q8zXzZJhg5hb6VZ+sv2MSUdpvhmU1ZXA?=
 =?us-ascii?Q?0JeraCPH19k/NPBO662xiLzPWUuLyimLNIX3qHESU4i1vCd0cKh4wrU6ZeLS?=
 =?us-ascii?Q?IOMRq3VI0ObFRsb5x8Gcd5vPZ0kCz3UY6EAG1DtyFFyJ1W4M3ssKhSDHd1j+?=
 =?us-ascii?Q?1mivIFnrIKRzvgyJ+kqAXKvZcVRrGU4Dr1wAtJ89YpXkXjM=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <801CC6D1B0D40347ACED9598DFC84A83@INDPRD01.PROD.OUTLOOK.COM>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: sct-15-20-4755-11-msonline-outlook-42ed3.templateTenant
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PNZPR01MB4415.INDPRD01.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-RMS-PersistedConsumerOrg: 00000000-0000-0000-0000-000000000000
X-MS-Exchange-CrossTenant-Network-Message-Id: 5d93fe6f-7807-49c5-99ec-08d9ef519867
X-MS-Exchange-CrossTenant-originalarrivaltime: 14 Feb 2022 00:33:17.7327
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 84df9e7f-e9f6-40af-b435-aaaaaaaaaaaa
X-MS-Exchange-CrossTenant-rms-persistedconsumerorg: 00000000-0000-0000-0000-000000000000
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BM1PR01MB3458
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
> Interesting. Ok, so there's something else going on here. I'll have=20
> access to a T2 system next week, so I'll take a look then. Is this=20
> something that started happening recently, or has it always happened if=20
> this config option is set on these platforms?

Before https://github.com/torvalds/linux/commit/f5390cd0b43c2e54c7cf5506c7d=
a4a37c5cef746, we had to add efi=3Dnoruntime to get Linux working on these =
machines. Now, its this config option only which is the issue.

You may want to follow https://wiki.t2linux.org/ to test on a T2 Mac, since=
 many T2 patches haven't been upstreamed yet.=
