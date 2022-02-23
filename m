Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 091BE4C14AD
	for <lists+stable@lfdr.de>; Wed, 23 Feb 2022 14:49:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239923AbiBWNuI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 23 Feb 2022 08:50:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56022 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233661AbiBWNuG (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 23 Feb 2022 08:50:06 -0500
Received: from IND01-MA1-obe.outbound.protection.outlook.com (mail-ma1ind01olkn0161.outbound.protection.outlook.com [104.47.100.161])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 757A7AF1FB;
        Wed, 23 Feb 2022 05:49:38 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ma0fjdUz8ekrmYNDNdA3zbat0QgJufcMbfNige6QulJCY9owxWAcVSKw/qiV7VLLe0V7gP0XeJW/Xw67S4ZmTXC5Cy2JRuwGGgxor2CfKax9Wt9+HKrlXWtiO/zrf26z7bEdPyK7wlPZR+yt3boHIVudy8RHOnjS6GB58ahmfFICWMAF2LHaBuVqfd3Qrq/zYH6SCBTXHH9p/F58cE7yudUZGKK3HSsLjK+Ekh+XJD16WCaGlDeGyipaf8sSd5AgNq3YzSMGuHiwggRPuOrSsvytxGn+YPs0e+n8D6kqzHo3oEBierlGuPVoy/5pUfvbfb/FMfG6K6sM1pT9V5qErQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=4u+RDUfMDE3xKyZarNNKto50bKqo0jR1iJcPz636rQU=;
 b=Nr99NYcre/nmOFvPlJqMclAtvY0ebq6CHk/BUTN7wtwafDi+RCAlt175Cwp2XDV75bGg4JDoq5ofcpOdbrsAwyeFg/sV96HPyvYVCPjEsZTgdUGyZk/4bQvivupRPYL2g6hRztX7HwqeZJXK+oVdij4Rgtf/apW4X7lNhkbpfY/FJT7ev6t1JDGg98P5Iccm7wQ98Gx5PVTaYV4+Q6Xhe2dsJHqqjwzQFoZCh6QTXnIGQWHQaTalgPQcRomZ8Age7jcvbZIa2+ImFrGXUn9FlfBxjIof5cmVL1AANOBav1Hv3t2LLIj1XOIqRmy13Y1Sg5WOZw5Q8VL53zz5sR+m1A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=live.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4u+RDUfMDE3xKyZarNNKto50bKqo0jR1iJcPz636rQU=;
 b=KKi/uPkycI4y6jgihyVfheHdvGT9JfyLJZ4wmy3LVsmrWMQlmv629LI06MZdyrtM/jLyDD8O86zvZifVyCSrOxsobm5lF4e6ihm6CS5ai5Id4zD8NSoI6FDxNU16K4tRvEoS+wZSLgcbLk0Oohmi299svSFsyThwjQcpiCr4DeH+tKAcg2KQwfN1tWswOss5CBd71kMBblOGVKO1BFpE7J8vvUpwhBTfWSfmtDcLh38Un21n4CEfr3o83r9VuOxhWUfTjw4v+SZAvqH1otAdB/zoGHSzoznC0v/gCrR+Z550WMtuYLZtrYEuf2AS3kTvaKUB1wYlzTR9A3bUB2fLXA==
Received: from PN2PR01MB4411.INDPRD01.PROD.OUTLOOK.COM (2603:1096:c01:17::10)
 by MA0PR01MB6778.INDPRD01.PROD.OUTLOOK.COM (2603:1096:a01:37::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4975.18; Wed, 23 Feb
 2022 13:49:29 +0000
Received: from PN2PR01MB4411.INDPRD01.PROD.OUTLOOK.COM
 ([fe80::9051:483f:8c51:66e1]) by PN2PR01MB4411.INDPRD01.PROD.OUTLOOK.COM
 ([fe80::9051:483f:8c51:66e1%5]) with mapi id 15.20.4995.027; Wed, 23 Feb 2022
 13:49:29 +0000
From:   Aditya Garg <gargaditya08@live.com>
To:     David Laight <David.Laight@ACULAB.COM>
CC:     Ard Biesheuvel <ardb@kernel.org>,
        Matthew Garrett <mjg59@srcf.ucam.org>,
        Jeremy Kerr <jk@ozlabs.org>,
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
Subject: Re: [PATCH v3] efi: Do not import certificates from UEFI Secure Boot
 for T2 Macs
Thread-Topic: [PATCH v3] efi: Do not import certificates from UEFI Secure Boot
 for T2 Macs
Thread-Index: AQHYHmuXCUX8clA/f0+kyOomS1U+nayhO3+A
Date:   Wed, 23 Feb 2022 13:49:29 +0000
Message-ID: <522D95FA-C088-4488-B240-1E97274CEB74@live.com>
References: <9D0C961D-9999-4C41-A44B-22FEAF0DAB7F@live.com>
 <755cffe1dfaf43ea87cfeea124160fe0@AcuMS.aculab.com>
 <B6D697AB-2AC5-4925-8300-26BBB4AC3D99@live.com>
 <20103919-A276-4CA6-B1AD-6E45DB58500B@live.com>
 <7038A8ED-AC52-4966-836B-7B346713AEE9@live.com>
In-Reply-To: <7038A8ED-AC52-4966-836B-7B346713AEE9@live.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-exchange-messagesentrepresentingtype: 1
x-tmn:  [9B13q2migWtEoPivY19gt0LFRpUuxI3q8PIEfysBRFg=]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: aa7a214a-417a-4d64-e159-08d9f6d35073
x-ms-traffictypediagnostic: MA0PR01MB6778:EE_
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 2iDNvvWmoLcGHiLnGyDcweX/EqxPVfhO29XVdqL89cz1JamNEolHuXEujUwCZkEYP3yRfdLSVdUr5/Y0fvIyxwIhyASi11BBJASm26/vPHdkJrG3mRvebBVEeRNOtYyUQvnSyGp6k0fbbRRSUgAFKQ5CKJWp+HMt28CNtb+YeAWz0yHT39TFns40wRG9nnMHsK6t5KIo8Pxx7w1M++Vm/Dx1GNP4vQN8u9ak64kazjG3jYHJauucrUcmTYopatAs0yzjA1yZWOLut3jcPN8byOq8aR0ueJ/VqHrdQK6uh2Vjb245zQknxwlABXtxEFR/dw0d5O/LKaPjnMLLye1wYwBBsPaDnCrL0onGcMCcV8VKE3g8fjhE6bJQF17T5J+hE/9wyf/269vzwP1tVXnj9pKySOmAYNC0RBf6QYyxzkMDhoFJvHO480iNZVKUrMIoAzmYWlV+p3l4FCPqvQs5wNHByVEsSrNYO0M9vBoOzY0GTcH5PkMPMZRKaNjkHPq7xLmpPFtNPHVEL8i0q8uZvaafPKjPSy4FyCWmz+dmanzYD6oUf87to/wBBZVlhTV+2yuDsBUNik+lOlobeXxVrA==
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?rSFicyk8rsPp4pB1oCeTlXSvo+FYPicqaOaaSAHlZ0WIg79clqJHHnoXwLjV?=
 =?us-ascii?Q?yRbgRKjK1vJdcNmh7NRAV/U3/E+YNsZ6QVzaZdU4tnvr9/APDI4RqRZ+Ht2G?=
 =?us-ascii?Q?XjGiB5nmZNQyCYQxBriG6xflqQufYIWtbUx7eQel9UdOXdqSetDtDu2xQrZl?=
 =?us-ascii?Q?7P5qge2TKGltQvaBs8CYj0shKo3wqoNRAJTmVQMWlwvBFGsbkyPYLo7cMKj1?=
 =?us-ascii?Q?zGm7Y0sPPpxGpTYrC+6Jh6DZVKLlhFPAlHywyi9NZf3CSyFH7WbbcVXWY5Zu?=
 =?us-ascii?Q?yvvtaFofaqAFmg+QRPkIMvnK8j8/1h2R3DRxVIH9wNAt5sC3LbkXKXkl+PaZ?=
 =?us-ascii?Q?es4hl/1NxkF6UGKsDpjufSZ7GQuCTpHS/LYbK0rZpMTDe7yB10oP2J7C8dJm?=
 =?us-ascii?Q?2cP9AXjEcIGPJNEoSfDoRKQ7RXjpK/MkR9MXmJsij4rwJoxP/0WiWhfkaH3c?=
 =?us-ascii?Q?do18ozZClFQ8Cme0Oe4r+dXWVsd3quHNWIS2Lr7LQEDxSvk1GXyAi0XSjOQz?=
 =?us-ascii?Q?ZyPHj7iooNdKwO+W44GRb1thFQZD15k/LQ/g1EOAUg/9QzHOSfztEGyFG7gx?=
 =?us-ascii?Q?LfxZWm+JcYkqcq60omxITaZf/2jm2WOKtP/df6nKRsmNv8uT431DGpWVmlAk?=
 =?us-ascii?Q?RHsEbssKYuusgjEaf3f+ZpiJbwP0Gr3wr1mtVIq8S5K13g5592mvlVhjapRi?=
 =?us-ascii?Q?priZLiN4iCkXoYRn1FSQ+HRukT04SUTI2WBBQsT8rMMR8uBCRJ8udxkiIvDE?=
 =?us-ascii?Q?KkusCuMkA2jSvGHOCNLwhoKlezkO/JwkGZlEJ4ClTHqLmHCo//bjAoakgR3M?=
 =?us-ascii?Q?MwevKIDWqmExfQo8tHDHehuKXS7zyrliZ9Elmfi8HB5rn14Rp8oZe2OOLnDo?=
 =?us-ascii?Q?an184A5YoHXfScNTmJOI6TLuZT9Z+fEN/xXYbNKQ3niCmup0L8RaN5WbgK7Y?=
 =?us-ascii?Q?YGwqgvWn+NaUYubCVuMMQ3ktKqA3yq7JAiHO9Qj/2q4=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <48868A70D4BE1D48BB730167F812112D@INDPRD01.PROD.OUTLOOK.COM>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: sct-15-20-4755-11-msonline-outlook-42ed3.templateTenant
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PN2PR01MB4411.INDPRD01.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-RMS-PersistedConsumerOrg: 00000000-0000-0000-0000-000000000000
X-MS-Exchange-CrossTenant-Network-Message-Id: aa7a214a-417a-4d64-e159-08d9f6d35073
X-MS-Exchange-CrossTenant-originalarrivaltime: 23 Feb 2022 13:49:29.4971
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 84df9e7f-e9f6-40af-b435-aaaaaaaaaaaa
X-MS-Exchange-CrossTenant-rms-persistedconsumerorg: 00000000-0000-0000-0000-000000000000
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MA0PR01MB6778
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



> On 10-Feb-2022, at 4:17 PM, Aditya Garg <gargaditya08@live.com> wrote:
>=20
> From: Aditya Garg <gargaditya08@live.com>
>=20
> On T2 Macs, the secure boot is handled by the T2 Chip. If enabled, only
> macOS and Windows are allowed to boot on these machines. Thus we need to
> disable secure boot for Linux. If we boot into Linux after disabling
> secure boot, if CONFIG_LOAD_UEFI_KEYS is enabled, EFI Runtime services
> fail to start, with the following logs in dmesg
>=20
> Call Trace:
> <TASK>
> page_fault_oops+0x4f/0x2c0
> ? search_bpf_extables+0x6b/0x80
> ? search_module_extables+0x50/0x80
> ? search_exception_tables+0x5b/0x60
> kernelmode_fixup_or_oops+0x9e/0x110
> __bad_area_nosemaphore+0x155/0x190
> bad_area_nosemaphore+0x16/0x20
> do_kern_addr_fault+0x8c/0xa0
> exc_page_fault+0xd8/0x180
> asm_exc_page_fault+0x1e/0x30
> (Removed some logs from here)
> ? __efi_call+0x28/0x30
> ? switch_mm+0x20/0x30
> ? efi_call_rts+0x19a/0x8e0
> ? process_one_work+0x222/0x3f0
> ? worker_thread+0x4a/0x3d0
> ? kthread+0x17a/0x1a0
> ? process_one_work+0x3f0/0x3f0
> ? set_kthread_struct+0x40/0x40
> ? ret_from_fork+0x22/0x30
> </TASK>
> ---[ end trace 1f82023595a5927f ]---
> efi: Froze efi_rts_wq and disabled EFI Runtime Services
> integrity: Couldn't get size: 0x8000000000000015
> integrity: MODSIGN: Couldn't get UEFI db list
> efi: EFI Runtime Services are disabled!
> integrity: Couldn't get size: 0x8000000000000015
> integrity: Couldn't get UEFI dbx list
> integrity: Couldn't get size: 0x8000000000000015
> integrity: Couldn't get mokx list
> integrity: Couldn't get size: 0x80000000
>=20
> This patch prevents querying of these UEFI variables, since these Macs
> seem to use a non-standard EFI hardware
>=20
> Cc: stable@vger.kernel.org
> Signed-off-by: Aditya Garg <gargaditya08@live.com>
> ---
> v2 :- Reduce code size of the table.
> V3 :- Close the brackets which were left open by mistake.
> .../platform_certs/keyring_handler.h          |  8 ++++
> security/integrity/platform_certs/load_uefi.c | 48 +++++++++++++++++++
> 2 files changed, 56 insertions(+)
>=20
Hi

May I have any updates on this patch?

