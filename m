Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6C03868FF76
	for <lists+stable@lfdr.de>; Thu,  9 Feb 2023 05:42:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230235AbjBIEmy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 8 Feb 2023 23:42:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35192 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230288AbjBIEmh (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 8 Feb 2023 23:42:37 -0500
Received: from EUR02-VI1-obe.outbound.protection.outlook.com (mail-vi1eur02on2062f.outbound.protection.outlook.com [IPv6:2a01:111:f400:fe16::62f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4DD02530DA;
        Wed,  8 Feb 2023 20:39:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=armh.onmicrosoft.com;
 s=selector2-armh-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=KBNhfpycmxPHkeTEBHZjaPedOW0kPo7H1xp13lo5QFI=;
 b=CDI9neIC0p+IYuC6iHsZIQ8Ex+19D+Dvxz+Wfpj4YGDk3JRyYEg/FmpHr5Y3e4YeRPHSp5p8JUEsXYUu5GzBu847WKwMS6ouJW5aJVbCWOMrsaVVwWhBvK6jiFH34N3crYqScQ62TKxTGJAMBj/cApQENjerDK6/t2F7Bx5RdZw=
Received: from DUZPR01CA0085.eurprd01.prod.exchangelabs.com
 (2603:10a6:10:46a::17) by DBBPR08MB6282.eurprd08.prod.outlook.com
 (2603:10a6:10:20c::14) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6086.18; Thu, 9 Feb
 2023 04:26:25 +0000
Received: from DBAEUR03FT056.eop-EUR03.prod.protection.outlook.com
 (2603:10a6:10:46a:cafe::fc) by DUZPR01CA0085.outlook.office365.com
 (2603:10a6:10:46a::17) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6086.19 via Frontend
 Transport; Thu, 9 Feb 2023 04:26:25 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 63.35.35.123)
 smtp.mailfrom=arm.com; dkim=pass (signature was verified)
 header.d=armh.onmicrosoft.com;dmarc=pass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 63.35.35.123 as permitted sender) receiver=protection.outlook.com;
 client-ip=63.35.35.123; helo=64aa7808-outbound-1.mta.getcheckrecipient.com;
 pr=C
Received: from 64aa7808-outbound-1.mta.getcheckrecipient.com (63.35.35.123) by
 DBAEUR03FT056.mail.protection.outlook.com (100.127.142.88) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6086.18 via Frontend Transport; Thu, 9 Feb 2023 04:26:25 +0000
Received: ("Tessian outbound 8038f0863a52:v132"); Thu, 09 Feb 2023 04:26:25 +0000
X-CheckRecipientChecked: true
X-CR-MTA-CID: ed8a50f540f812fb
X-CR-MTA-TID: 64aa7808
Received: from 714a94582052.1
        by 64aa7808-outbound-1.mta.getcheckrecipient.com id E987A2B2-E6B2-46A5-8832-09FE5A42E147.1;
        Thu, 09 Feb 2023 04:26:19 +0000
Received: from EUR02-DB5-obe.outbound.protection.outlook.com
    by 64aa7808-outbound-1.mta.getcheckrecipient.com with ESMTPS id 714a94582052.1
    (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384);
    Thu, 09 Feb 2023 04:26:19 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=VthB1gN9cl2cR+rxrxB9k/EbNLJn/bVcQb5PajHXg0IXmKNQzN+KOyRHu23GidKYrUTRblT6fngDiSMISBn4my+bV8MtwEe5DAYwj1V21Gl4yk8x9ZBgrCyovU9x9DTB5CSRQvOkkXKaTyWDDU73S4EbS9JF+TIxYUjFORxoWrJWfyylyZFdIdYcQr37fu3CU+VZP3AbQCVLyhI2BcIqc3uOPhb7x60MAZXsOuAZvwVF8N3A0WNRt5KFzl6whvbTanCVSVo9GUPqCRfRNl83/5yKeWA3e0qoahybQo3mqpnA+Icne/PVyL4tmtZREfEQfGKKOh+o1/3THovg9++kEg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=KBNhfpycmxPHkeTEBHZjaPedOW0kPo7H1xp13lo5QFI=;
 b=J/wxJ7HbBF+zpdRxNQEPs+SeyMh9VoskZjTg+3ElJ4GT3uvv5VTx63v8V2Hn5ZVGSj4iV4i4Z+Xej12IQXDfaahcFmLyOQnoOAlAYp3odcZivJga+6jcZvvIvRBoo9dnNJKI5hlQ4pRW1f/hJCTZrYQbRHIljTH4f+wuvvEut5bNJCx7HAuki6kGtWgKV51qudfotk4kiUN3VUV4ID23ESeTPSCfCAT/nq2PpraRu6FDJiLknGeXoORCgUw9it7T4oj2YbPx6bqcHWpcfbIO4x3NIvMkLZauNVdMC3NSEpUBv0oNbLrd38RdRinnEExymhiITuG7XXqdRUAtALdL4A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=armh.onmicrosoft.com;
 s=selector2-armh-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=KBNhfpycmxPHkeTEBHZjaPedOW0kPo7H1xp13lo5QFI=;
 b=CDI9neIC0p+IYuC6iHsZIQ8Ex+19D+Dvxz+Wfpj4YGDk3JRyYEg/FmpHr5Y3e4YeRPHSp5p8JUEsXYUu5GzBu847WKwMS6ouJW5aJVbCWOMrsaVVwWhBvK6jiFH34N3crYqScQ62TKxTGJAMBj/cApQENjerDK6/t2F7Bx5RdZw=
Received: from DBBPR08MB4538.eurprd08.prod.outlook.com (2603:10a6:10:d2::15)
 by DBBPR08MB6297.eurprd08.prod.outlook.com (2603:10a6:10:20b::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6086.17; Thu, 9 Feb
 2023 04:26:17 +0000
Received: from DBBPR08MB4538.eurprd08.prod.outlook.com
 ([fe80::2d8:92a:3c7:2fcd]) by DBBPR08MB4538.eurprd08.prod.outlook.com
 ([fe80::2d8:92a:3c7:2fcd%4]) with mapi id 15.20.6086.017; Thu, 9 Feb 2023
 04:26:17 +0000
From:   Justin He <Justin.He@arm.com>
To:     Darren Hart <darren@os.amperecomputing.com>,
        LKML <linux-kernel@vger.kernel.org>
CC:     "stable@vger.kernel.org" <stable@vger.kernel.org>,
        "linux-efi@vger.kernel.org" <linux-efi@vger.kernel.org>,
        Alexandru Elisei <alexandru.elisei@gmail.com>,
        Huacai Chen <chenhuacai@kernel.org>,
        "Jason A. Donenfeld" <Jason@zx2c4.com>,
        Ard Biesheuvel <ardb@kernel.org>, nd <nd@arm.com>
Subject: RE: [PATCH v2] arm64: efi: Force the use of SetVirtualAddressMap() on
 eMAG and Altra Max machines
Thread-Topic: [PATCH v2] arm64: efi: Force the use of SetVirtualAddressMap()
 on eMAG and Altra Max machines
Thread-Index: AQHZPB16WuoCttLgRE2E1vPXNQssV67F5ikg
Date:   Thu, 9 Feb 2023 04:26:16 +0000
Message-ID: <DBBPR08MB4538C586B721C8209B03AEEEF7D99@DBBPR08MB4538.eurprd08.prod.outlook.com>
References: <2ab9645789707f31fd37c49435e476d4b5c38a0a.1675901828.git.darren@os.amperecomputing.com>
In-Reply-To: <2ab9645789707f31fd37c49435e476d4b5c38a0a.1675901828.git.darren@os.amperecomputing.com>
Accept-Language: en-US, zh-CN
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Authentication-Results-Original: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=arm.com;
x-ms-traffictypediagnostic: DBBPR08MB4538:EE_|DBBPR08MB6297:EE_|DBAEUR03FT056:EE_|DBBPR08MB6282:EE_
X-MS-Office365-Filtering-Correlation-Id: ba551e31-1ac1-4d7f-4e17-08db0a55ce73
x-checkrecipientrouted: true
nodisclaimer: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted: BCL:0;
X-Microsoft-Antispam-Message-Info-Original: w3Q+kG9JiL3pAxCt7DlIEfFqGDyMw/kAjduYw67lh2Ci++YeZNzd1mEvwKD2ebNmqflj/NnPJuTrw8KkQpLtucEq+EkmgyZkm6KDYIMwiCALdUcy6BEd2yAyNGKKyHppp1kWrItcxq8bgitt9slPK1zQdOgj3iCU1lTmAcZo0ChB1vXIoO1afjgkIFlirDkIRlqk93alpq3OGSol5ZJBgHB4uy94QiJp4MuExPDwcYob+yeW+a7RKR56fXYIdt+MSYDwhqpteL3rxB9v99kO9h3XkqmDNmYWT8LGRI/PPq1D7Nfe0dK9RWxgf/J/RAGWqgQg54EgOK6uPkLpT84cMICfbq36bXuFB502hCxVO1pQ1rLs5/BK7JgqR7yRLaAt5tHPh9LBpJQc2jyLRm8P7gp0SaAcl2SftEIwx5zwoQIBmXUzjaYrQcPoe+XV198v7LDwgzug+5EpJrXQL/bT+EaYFPNYXyOu/GhEfpPYjAnXrVT9mjPzS+XJg5ioxVJgBiNfUKopxte/1pwuj0xi2HCH5amdnzKHoMmZtRuDejMXrFo7OZWHINXNLJu9TysLq875PGyCSUBIdEOI9SJMOkCHmrs57uwljHTcpSbmim4x9RBD1ZkidN8tn82tAu8+0lXwRJCta82AzmQUozuRUgJpgZ/1UjB4VZdggewlGM/Vvrs2sOuVNWjKys3UxcoVTy+92Hex6UDlLVQO7WhTsw==
X-Forefront-Antispam-Report-Untrusted: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DBBPR08MB4538.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(39860400002)(396003)(366004)(136003)(376002)(346002)(451199018)(66476007)(83380400001)(8936002)(76116006)(66946007)(316002)(54906003)(66446008)(64756008)(52536014)(5660300002)(478600001)(110136005)(8676002)(4326008)(41300700001)(186003)(6506007)(53546011)(26005)(7696005)(71200400001)(9686003)(33656002)(66556008)(38070700005)(55016003)(86362001)(2906002)(122000001)(38100700002);DIR:OUT;SFP:1101;
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DBBPR08MB6297
Original-Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=arm.com;
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped: DBAEUR03FT056.eop-EUR03.prod.protection.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs: 54571038-1344-4ea8-6407-08db0a55c95e
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: W0fqpg3UNoQbJ6CXWk+3oMsnuhy6ErfDYKmSn1cQGgep5A37sgy+Gr+ath/6z6W76K+GMV+tTJ5zYvYcjEkLijY7v/wOV4322UuZtPfEyOXstpAXL9EnJaNW5dNy6vwAXsuJBDyAa7GmzE40nkE0SqXcGvXMgLDCtJUsEtzdz8Xz+Y62uIE1RumB5ipUtwh5ONIUzT4OFnKDccNdFw9qZfqa7vJvy6HPZf3llCAl8/TQbrj6lMTyusRqHHzVsH9Z4wqS76ApCQ4UaghQ+YOJpEkIjwkR/0b9sCzLq0PBVSwfeLU1yXga6z4UcJuq4LL51L2jYNbsGFvY3CHgQNZU95An83bTO3pZAbCjiIxg1ptHFHe7U6bdyFH0nDaBCfBC5NyDNNMhWnTMOZf0x7JB2TKlQB+9n7t75F46OiESe4LlPD1sYP2Hah2XiTKzKYfTyHbIKvHw7Z1QedSZ5UhPwKi99AwydALK53GnNAPBb3t6TbuCKovLM8evpTBdtEGMtwVHYMOFCxf/ap7KVSqv+IIEtvaDBDQnyVx2VY2HXKWdJoUrky0bQN4R8DejgZ1lvW0Q+PumILpI/6HjoSdH306akGuJxEyf7jHc+Cvf8EZcn4ehlH7QC9ztfdr4feLsf5ukziIWX8Mlkkzp1AKUxRw5BPErcywofnL1IW2qFYyFvv/AviuOes6HUUfMTjDLgjv6w4/gSnRRJ0RcfIOxgA==
X-Forefront-Antispam-Report: CIP:63.35.35.123;CTRY:IE;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:64aa7808-outbound-1.mta.getcheckrecipient.com;PTR:ec2-63-35-35-123.eu-west-1.compute.amazonaws.com;CAT:NONE;SFS:(13230025)(4636009)(376002)(136003)(39860400002)(396003)(346002)(451199018)(40470700004)(46966006)(36840700001)(82740400003)(81166007)(356005)(86362001)(33656002)(40460700003)(41300700001)(52536014)(8936002)(5660300002)(316002)(110136005)(70206006)(4326008)(8676002)(54906003)(7696005)(70586007)(450100002)(2906002)(82310400005)(55016003)(83380400001)(336012)(47076005)(36860700001)(40480700001)(478600001)(9686003)(53546011)(186003)(26005)(6506007);DIR:OUT;SFP:1101;
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Feb 2023 04:26:25.5061
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: ba551e31-1ac1-4d7f-4e17-08db0a55ce73
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[63.35.35.123];Helo=[64aa7808-outbound-1.mta.getcheckrecipient.com]
X-MS-Exchange-CrossTenant-AuthSource: DBAEUR03FT056.eop-EUR03.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DBBPR08MB6282
X-Spam-Status: No, score=-0.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,FORGED_SPF_HELO,SPF_HELO_PASS,SPF_NONE,UNPARSEABLE_RELAY
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



> -----Original Message-----
> From: Darren Hart <darren@os.amperecomputing.com>
> Sent: Thursday, February 9, 2023 8:28 AM
> To: LKML <linux-kernel@vger.kernel.org>
> Cc: stable@vger.kernel.org; linux-efi@vger.kernel.org; Alexandru Elisei
> <alexandru.elisei@gmail.com>; Justin He <Justin.He@arm.com>; Huacai Chen
> <chenhuacai@kernel.org>; Jason A. Donenfeld <Jason@zx2c4.com>; Ard
> Biesheuvel <ardb@kernel.org>
> Subject: [PATCH v2] arm64: efi: Force the use of SetVirtualAddressMap() o=
n
> eMAG and Altra Max machines
>=20
> Commit 550b33cfd445 ("arm64: efi: Force the use of SetVirtualAddressMap()
> on Altra machines") identifies the Altra family via the family field in t=
he type#1
> SMBIOS record. eMAG and Altra Max machines are similarly affected but not
> detected with the strict strcmp test.
>=20
> The type1_family smbios string is not an entirely reliable means of ident=
ifying
> systems with this issue as OEMs can, and do, use their own strings for th=
ese
> fields. However, until we have a better solution, capture the bulk of the=
se
> systems by adding strcmp matching for "eMAG"
> and "Altra Max".
>=20
> Fixes: 550b33cfd445 ("arm64: efi: Force the use of SetVirtualAddressMap()=
 on
> Altra machines")
> Cc: <stable@vger.kernel.org> # 6.1.x
> Cc: <linux-efi@vger.kernel.org>
> Cc: Alexandru Elisei <alexandru.elisei@gmail.com>
> Cc: Justin He <Justin.He@arm.com>
> Cc: Huacai Chen <chenhuacai@kernel.org>
> Cc: "Jason A. Donenfeld" <Jason@zx2c4.com>
> Cc: Ard Biesheuvel <ardb@kernel.org>
> Signed-off-by: Darren Hart <darren@os.amperecomputing.com>
Tested-by: justin.he@arm.com
> ---
> V1 -> V2: include eMAG
>=20
>  drivers/firmware/efi/libstub/arm64.c | 9 ++++++---
>  1 file changed, 6 insertions(+), 3 deletions(-)
>=20
> diff --git a/drivers/firmware/efi/libstub/arm64.c
> b/drivers/firmware/efi/libstub/arm64.c
> index ff2d18c42ee7..4501652e11ab 100644
> --- a/drivers/firmware/efi/libstub/arm64.c
> +++ b/drivers/firmware/efi/libstub/arm64.c
> @@ -19,10 +19,13 @@ static bool system_needs_vamap(void)
>  	const u8 *type1_family =3D efi_get_smbios_string(1, family);
>=20
>  	/*
> -	 * Ampere Altra machines crash in SetTime() if SetVirtualAddressMap()
> -	 * has not been called prior.
> +	 * Ampere eMAG, Altra, and Altra Max machines crash in SetTime() if
> +	 * SetVirtualAddressMap() has not been called prior.
>  	 */
> -	if (!type1_family || strcmp(type1_family, "Altra"))
> +	if (!type1_family || (
> +	    strcmp(type1_family, "eMAG") &&
> +	    strcmp(type1_family, "Altra") &&
> +	    strcmp(type1_family, "Altra Max")))
In terms of resolving the boot hang issue, it looks good to me. And I've ve=
rified the
"eMAG" part check.
So please feel free to add:
Tested-by: Justin He <justin.he@arm.com>

But I have some other concerns:
1. On an Altra server, the type1_family returns "Server". I don't know whet=
her it
is a smbios or server firmware bug.
2. On an eMAG server, I once successfully run efibootmgr -t 10 to call the
Set_variable rts, but currently I always met the error, even with above pat=
ch:
# efibootmgr -t 9; efibootmgr -t 5;
Could not set Timeout: Input/output error
Could not set Timeout: Input/output error

Meanwhile, on the Altra server, it works:
# efibootmgr -t 9; efibootmgr -t 5;
BootCurrent: 0007
Timeout: 9 seconds
BootOrder: 0007,0005,0006,0001
Boot0001* UEFI: Built-in EFI Shell
Boot0005* UEFI: PXE IPv4 Intel(R) I350 Gigabit Network Connection
Boot0006* UEFI: PXE IPv4 Intel(R) I350 Gigabit Network Connection
Boot0007* ubuntu
BootCurrent: 0007
Timeout: 5 seconds
BootOrder: 0007,0005,0006,0001
Boot0001* UEFI: Built-in EFI Shell
Boot0005* UEFI: PXE IPv4 Intel(R) I350 Gigabit Network Connection
Boot0006* UEFI: PXE IPv4 Intel(R) I350 Gigabit Network Connection
Boot0007* ubuntu



--
Cheers,
Justin (Jia He)


