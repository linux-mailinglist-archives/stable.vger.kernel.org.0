Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0BF856916B9
	for <lists+stable@lfdr.de>; Fri, 10 Feb 2023 03:38:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229861AbjBJCiw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 9 Feb 2023 21:38:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36940 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229627AbjBJCiw (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 9 Feb 2023 21:38:52 -0500
Received: from EUR01-VE1-obe.outbound.protection.outlook.com (mail-ve1eur01on2059.outbound.protection.outlook.com [40.107.14.59])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2CE0A6F8FA;
        Thu,  9 Feb 2023 18:38:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=armh.onmicrosoft.com;
 s=selector2-armh-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vQm4ZWmv4cxDBAwI+19oPTdipsvq3y5jcWr51Oke6P0=;
 b=OhHAGS7jx0fzIm7J00NGUpR5qMFKGYTm2WLqMDEz8FvrDpgcCXlg9nTb10Iv2zV5DSBpcexcc17ZtbSoBqwhWMSeooSFmdwfXylbWt/1MoEwlGCRcV3cX5qmrCROSNdpBwLkTkKg74jmdzw7+xPL+HYqHDDYCSxUNQxdd5gWFBU=
Received: from AS9PR06CA0347.eurprd06.prod.outlook.com (2603:10a6:20b:466::33)
 by AS8PR08MB8184.eurprd08.prod.outlook.com (2603:10a6:20b:561::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6086.19; Fri, 10 Feb
 2023 02:38:39 +0000
Received: from AM7EUR03FT058.eop-EUR03.prod.protection.outlook.com
 (2603:10a6:20b:466:cafe::2c) by AS9PR06CA0347.outlook.office365.com
 (2603:10a6:20b:466::33) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6086.20 via Frontend
 Transport; Fri, 10 Feb 2023 02:38:39 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 63.35.35.123)
 smtp.mailfrom=arm.com; dkim=pass (signature was verified)
 header.d=armh.onmicrosoft.com;dmarc=pass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 63.35.35.123 as permitted sender) receiver=protection.outlook.com;
 client-ip=63.35.35.123; helo=64aa7808-outbound-1.mta.getcheckrecipient.com;
 pr=C
Received: from 64aa7808-outbound-1.mta.getcheckrecipient.com (63.35.35.123) by
 AM7EUR03FT058.mail.protection.outlook.com (100.127.140.247) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6086.19 via Frontend Transport; Fri, 10 Feb 2023 02:38:39 +0000
Received: ("Tessian outbound 43b0faad5a68:v132"); Fri, 10 Feb 2023 02:38:39 +0000
X-CheckRecipientChecked: true
X-CR-MTA-CID: fb99a0de85f215c3
X-CR-MTA-TID: 64aa7808
Received: from 5bc6586828ac.1
        by 64aa7808-outbound-1.mta.getcheckrecipient.com id 0FDD5B92-8CF8-4277-A70F-1B722890D211.1;
        Fri, 10 Feb 2023 02:38:30 +0000
Received: from EUR05-VI1-obe.outbound.protection.outlook.com
    by 64aa7808-outbound-1.mta.getcheckrecipient.com with ESMTPS id 5bc6586828ac.1
    (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384);
    Fri, 10 Feb 2023 02:38:30 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=hDAGM1RePJHwkJGY0c/vlniLcPg/Ys5seeH9XTcXRK9Ivy6ll3fM5T0nrvhuyVX+vyDzCkIAtnfuUpViAMfUM8IxoEGDrXD4HDNdGZU4JzoXjpQpwka+fYKEF9TmXaoKKDXYk8K2NCsomd6E2PTmBbiwApVcSmDADmmdRCTtzg+qdpgCgCqcBzDMzNm/6+M9ZcyC/igCwGZMC3Ql0rGbQXjGn4Bs3Oi8SLhZTba+oP56XEJMohfewVnDJWEED3XRYBTXlUZELW4b9/2+hYYB1wO05SXHkgkWD0J3NmjtivHOFi5weZQYnWeroGCKo0duvsFQbUvYS6vZRpYuzXJmnQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=vQm4ZWmv4cxDBAwI+19oPTdipsvq3y5jcWr51Oke6P0=;
 b=bGXYf5a4LmBR6q1VTroH+2ikqRG5N0NakFF0Sb2Kc9FXCHxwIXTkq7m/fkedM2U84YhUJx8i3fRzCNdIEBMPcgmMnW/glERpCaSLcXI153/6M5n6JBTqEgBDLcmTe4jYu3sZmmqiBnlNpccSCkf2VQQbO/v21VUtXYMHZylDTPZPmlvQBWbBpDqNL9iGmFxEtiKBkmND3hhtlbArvwOd6WCR1PoDwKrmHw8RYMWIhLq8pLbHZvWRcQ6nf+tDFMymDEuBWucPJNwHUgUbkIrEEX9cNBI/aDaaCpcghYBgINRW8AQ41eXwG/jJktE8+xndUTkPp+35/1+TgZpuEoDtXw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=armh.onmicrosoft.com;
 s=selector2-armh-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vQm4ZWmv4cxDBAwI+19oPTdipsvq3y5jcWr51Oke6P0=;
 b=OhHAGS7jx0fzIm7J00NGUpR5qMFKGYTm2WLqMDEz8FvrDpgcCXlg9nTb10Iv2zV5DSBpcexcc17ZtbSoBqwhWMSeooSFmdwfXylbWt/1MoEwlGCRcV3cX5qmrCROSNdpBwLkTkKg74jmdzw7+xPL+HYqHDDYCSxUNQxdd5gWFBU=
Received: from DBBPR08MB4538.eurprd08.prod.outlook.com (2603:10a6:10:d2::15)
 by AM0PR08MB5395.eurprd08.prod.outlook.com (2603:10a6:208:188::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6086.17; Fri, 10 Feb
 2023 02:38:27 +0000
Received: from DBBPR08MB4538.eurprd08.prod.outlook.com
 ([fe80::2d8:92a:3c7:2fcd]) by DBBPR08MB4538.eurprd08.prod.outlook.com
 ([fe80::2d8:92a:3c7:2fcd%4]) with mapi id 15.20.6086.017; Fri, 10 Feb 2023
 02:38:27 +0000
From:   Justin He <Justin.He@arm.com>
To:     Darren Hart <darren@os.amperecomputing.com>,
        Ard Biesheuvel <ardb@kernel.org>
CC:     LKML <linux-kernel@vger.kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        "linux-efi@vger.kernel.org" <linux-efi@vger.kernel.org>,
        Alexandru Elisei <alexandru.elisei@gmail.com>, nd <nd@arm.com>,
        Nathan Chancellor <nathan@kernel.org>
Subject: RE: [PATCH v2] arm64: efi: Force the use of SetVirtualAddressMap() on
 eMAG and Altra Max machines
Thread-Topic: [PATCH v2] arm64: efi: Force the use of SetVirtualAddressMap()
 on eMAG and Altra Max machines
Thread-Index: AQHZPB16WuoCttLgRE2E1vPXNQssV67F5ikggADYnoCAAF3JgIAAWroQ
Date:   Fri, 10 Feb 2023 02:38:26 +0000
Message-ID: <DBBPR08MB4538F7FCCB0D05C1F2FCA853F7DE9@DBBPR08MB4538.eurprd08.prod.outlook.com>
References: <2ab9645789707f31fd37c49435e476d4b5c38a0a.1675901828.git.darren@os.amperecomputing.com>
 <DBBPR08MB4538C586B721C8209B03AEEEF7D99@DBBPR08MB4538.eurprd08.prod.outlook.com>
 <CAMj1kXG8TY9eKJxtSWYPCu_8qs7W3FWwDSZ+teuwhHb1BHUf7g@mail.gmail.com>
 <Y+VgXbVHf0BC3vO6@fedora>
In-Reply-To: <Y+VgXbVHf0BC3vO6@fedora>
Accept-Language: en-US, zh-CN
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Authentication-Results-Original: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=arm.com;
x-ms-traffictypediagnostic: DBBPR08MB4538:EE_|AM0PR08MB5395:EE_|AM7EUR03FT058:EE_|AS8PR08MB8184:EE_
X-MS-Office365-Filtering-Correlation-Id: 4992d3eb-d72c-4979-4b7f-08db0b0feac2
x-checkrecipientrouted: true
nodisclaimer: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted: BCL:0;
X-Microsoft-Antispam-Message-Info-Original: Zkg6vjdxVPepzJBHGmf65cJgntwtJYSME9Of/SJIjxDeU7LNdZ99OThNoSKib8SlaT3VbaLOR6SxOiLO+iPuXQSyfEsrW5qywcVKxH+/uduJejPConfMfFZlZW/IRyWv5h7qp0ihlpLrDUWmGHrHPql4Vp2oJB0i3ZfNjUMganPdavj00NMry5xzuQsYnqPbg9HF5nTM1V2jIydJnLH/LgS32VrY8pF842sk8r1oam8pqaYJbaWmJ1om8MyuoPTCMDJ/IwMnEvGh2NPZR4RYdNMHSLyVPibTnC7HBUkdlLX98r1rh4lk+dbkBNEDwZGA+VLnyFEXACMACpjyBa1Kdsj8qlAmdspuj2lEfFiTVFLVvmcQUgrlioQhn+tImpLYxNmKQpUeR/KFwDpFQs9IC54GWbIuYtgEnmR0J8VeLOQ8Qi8dztISAc0ISsbEO7S9CMNOzeuwwAhtMj9gjyKgr+Es3ZSPQs9ioWzmMxXA9dxvmkB1MMSsgM2qlxLI0TDQcgkysjNGhUKDXDanLzfF/gOjFgMa7lWnyPtsq6FO4x80p2qUl1ShrLNxCqRREr+skuBmsAC3kANrKhwqI0aISuwG+R5D/Ak8VvDuWKrpzs24fGH0+TkP6AP7NsDWPMm+h8b32lQAOsWzN6Vc8qhm0aKJEuikFcf9unznPZeoAnnxhdqivUBA91QO8sL0pXWdf4Bx/BOYRoW6yjN4NAErlA==
X-Forefront-Antispam-Report-Untrusted: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DBBPR08MB4538.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(346002)(366004)(136003)(396003)(39860400002)(376002)(451199018)(66899018)(41300700001)(6506007)(53546011)(26005)(9686003)(33656002)(86362001)(83380400001)(66476007)(2906002)(55016003)(38070700005)(71200400001)(186003)(8936002)(54906003)(66946007)(66556008)(8676002)(52536014)(38100700002)(4326008)(76116006)(64756008)(110136005)(316002)(122000001)(7696005)(478600001)(66446008)(5660300002);DIR:OUT;SFP:1101;
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR08MB5395
Original-Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=arm.com;
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped: AM7EUR03FT058.eop-EUR03.prod.protection.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs: 4a5c5c4c-de14-4680-972b-08db0b0fe322
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: fQlJN7zBgAHOuidXbff2JQNbkRm9zQbG3V8/6c46WAe7eWWChENq3x6h1Flbk1EW1iEcXzeVSQKBNRFzcsmU53VpNKypSr9XF8OqvOrACryf/rg5J7SQjd/2SMBDeoFWFoL+fJQSGEhxKoOqcgs4tQsdngOkGObEJYGhzvdpUa/UAZB2dHMDilfi+QdHXUCYm79w7aJrqdl+UDm8mRKDw+CuQXQ1658mjGYc6syarJoyuNWuQNztWb63TcEgtP5IDoqJ33KFNs3dyQgCE1bIaSX1GIu6VgQUYIvcZ0AI7rhIHUw5UmgwTs55U7P3CJDqRonBqfh9B28vst9In1akZ2zcYWhqRNod2MFeM33BoMOigzaukZ/mcrAZgmlKf2XwfpnyVLewcRz2zipV4zCEklLUvZK0ThF4KeyVvRZc5MJcrDSi6NYSxHI39BU9RQGC1+9LjpDPRkAREtiUQ0TaycS2cbxGMdLK19faDGNJv1fDLhV35nwPab95l2vwLsN0XU3HHzEF5LSSxZoJ1eIWlsjM1twgZF7qcEO3LzDQpGsaLL1Y4MO+2xAmI/Ec8mLEDDlk5xasAvF8c2eIaTgwaWo96qhoyHQhAcjbHWHyhDpZCYptyKumugNd9rN3SLfNbUkIHZOv2I2p6Z1saeqsjY18l/HjBIh7pOUzpsB4kJoUpi1FIO6VxxLX/sgEwKr73xnaWS489N/Z0+gMenffQg==
X-Forefront-Antispam-Report: CIP:63.35.35.123;CTRY:IE;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:64aa7808-outbound-1.mta.getcheckrecipient.com;PTR:ec2-63-35-35-123.eu-west-1.compute.amazonaws.com;CAT:NONE;SFS:(13230025)(4636009)(346002)(136003)(39860400002)(376002)(396003)(451199018)(46966006)(40470700004)(36840700001)(82740400003)(81166007)(66899018)(36860700001)(55016003)(316002)(9686003)(26005)(186003)(53546011)(47076005)(5660300002)(86362001)(41300700001)(336012)(52536014)(33656002)(356005)(8936002)(54906003)(70586007)(110136005)(450100002)(82310400005)(6506007)(70206006)(8676002)(4326008)(478600001)(7696005)(2906002)(40480700001)(83380400001)(40460700003);DIR:OUT;SFP:1101;
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Feb 2023 02:38:39.2980
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 4992d3eb-d72c-4979-4b7f-08db0b0feac2
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[63.35.35.123];Helo=[64aa7808-outbound-1.mta.getcheckrecipient.com]
X-MS-Exchange-CrossTenant-AuthSource: AM7EUR03FT058.eop-EUR03.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS8PR08MB8184
X-Spam-Status: No, score=-0.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,FORGED_SPF_HELO,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,
        SPF_HELO_PASS,SPF_NONE,UNPARSEABLE_RELAY autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Darren and Ard

> -----Original Message-----
> From: Darren Hart <darren@os.amperecomputing.com>
> Sent: Friday, February 10, 2023 5:07 AM
> To: Ard Biesheuvel <ardb@kernel.org>
> Cc: Justin He <Justin.He@arm.com>; LKML <linux-kernel@vger.kernel.org>;
> stable@vger.kernel.org; linux-efi@vger.kernel.org; Alexandru Elisei
> <alexandru.elisei@gmail.com>; nd <nd@arm.com>; Nathan Chancellor
> <nathan@kernel.org>
> Subject: Re: [PATCH v2] arm64: efi: Force the use of SetVirtualAddressMap=
() on
> eMAG and Altra Max machines
>=20
> On Thu, Feb 09, 2023 at 04:30:57PM +0100, Ard Biesheuvel wrote:
> > (cc Nathan, another happy Ampere customer)
> >
> > On Thu, 9 Feb 2023 at 05:26, Justin He <Justin.He@arm.com> wrote:
> > >
> > >
> > >
> > > > -----Original Message-----
> > > > From: Darren Hart <darren@os.amperecomputing.com>
> > > > Sent: Thursday, February 9, 2023 8:28 AM
> > > > To: LKML <linux-kernel@vger.kernel.org>
> > > > Cc: stable@vger.kernel.org; linux-efi@vger.kernel.org; Alexandru
> > > > Elisei <alexandru.elisei@gmail.com>; Justin He
> > > > <Justin.He@arm.com>; Huacai Chen <chenhuacai@kernel.org>; Jason A.
> > > > Donenfeld <Jason@zx2c4.com>; Ard Biesheuvel <ardb@kernel.org>
> > > > Subject: [PATCH v2] arm64: efi: Force the use of
> > > > SetVirtualAddressMap() on eMAG and Altra Max machines
> > > >
> > > > Commit 550b33cfd445 ("arm64: efi: Force the use of
> > > > SetVirtualAddressMap() on Altra machines") identifies the Altra
> > > > family via the family field in the type#1 SMBIOS record. eMAG and
> > > > Altra Max machines are similarly affected but not detected with the=
 strict
> strcmp test.
> > > >
> > > > The type1_family smbios string is not an entirely reliable means
> > > > of identifying systems with this issue as OEMs can, and do, use
> > > > their own strings for these fields. However, until we have a
> > > > better solution, capture the bulk of these systems by adding strcmp
> matching for "eMAG"
> > > > and "Altra Max".
> > > >
> > > > Fixes: 550b33cfd445 ("arm64: efi: Force the use of
> > > > SetVirtualAddressMap() on Altra machines")
> > > > Cc: <stable@vger.kernel.org> # 6.1.x
> > > > Cc: <linux-efi@vger.kernel.org>
> > > > Cc: Alexandru Elisei <alexandru.elisei@gmail.com>
> > > > Cc: Justin He <Justin.He@arm.com>
> > > > Cc: Huacai Chen <chenhuacai@kernel.org>
> > > > Cc: "Jason A. Donenfeld" <Jason@zx2c4.com>
> > > > Cc: Ard Biesheuvel <ardb@kernel.org>
> > > > Signed-off-by: Darren Hart <darren@os.amperecomputing.com>
> > > Tested-by: justin.he@arm.com
> > > > ---
> > > > V1 -> V2: include eMAG
> > > >
> > > >  drivers/firmware/efi/libstub/arm64.c | 9 ++++++---
> > > >  1 file changed, 6 insertions(+), 3 deletions(-)
> > > >
> > > > diff --git a/drivers/firmware/efi/libstub/arm64.c
> > > > b/drivers/firmware/efi/libstub/arm64.c
> > > > index ff2d18c42ee7..4501652e11ab 100644
> > > > --- a/drivers/firmware/efi/libstub/arm64.c
> > > > +++ b/drivers/firmware/efi/libstub/arm64.c
> > > > @@ -19,10 +19,13 @@ static bool system_needs_vamap(void)
> > > >       const u8 *type1_family =3D efi_get_smbios_string(1, family);
> > > >
> > > >       /*
> > > > -      * Ampere Altra machines crash in SetTime() if
> SetVirtualAddressMap()
> > > > -      * has not been called prior.
> > > > +      * Ampere eMAG, Altra, and Altra Max machines crash in SetTim=
e()
> if
> > > > +      * SetVirtualAddressMap() has not been called prior.
> > > >        */
> > > > -     if (!type1_family || strcmp(type1_family, "Altra"))
> > > > +     if (!type1_family || (
> > > > +         strcmp(type1_family, "eMAG") &&
> > > > +         strcmp(type1_family, "Altra") &&
> > > > +         strcmp(type1_family, "Altra Max")))
> > > In terms of resolving the boot hang issue, it looks good to me. And
> > > I've verified the "eMAG" part check.
> > > So please feel free to add:
> > > Tested-by: Justin He <justin.he@arm.com>
> > >
> >
> > Thanks. I've queued this up now.
> >
> > > But I have some other concerns:
> > > 1. On an Altra server, the type1_family returns "Server". I don't
> > > know whether it is a smbios or server firmware bug.
> >
> > This is not really a bug. OEMs are free to put whatever they want into
> > those fields, although that is a great example of a sloppy vendor that
> > just puts random junk in there.
> >
>=20
> We could use the type1 "product name" and have a unique identifier, but t=
hat
> doesn't scale well either. Ampere partners with many OEMs, and we should
> expect this to increase in time.
>=20
> > We could plumb in the type 4 smbios record too, and check the version
> > for *Altra* - however, it would be nice to get an idea of how many
> > more we will end up needing to handle here.
>=20
> If we don't get this fixed in firmware, I think we have two kernel side
> maintainable options:
>=20
> 1) Depend on the type4 string for the SoCs with impacted EDK2 firmware. T=
his
> is suboptimal as OEMs should be able to update the firmware they ship and
> control how the kernel interacts with their platform. This effectively re=
moves
> that option in order to avoid the individual listing of "product name".
>=20
Whether could we introduce a system_force_vamap or similar one to force the=
=20
system_needs_vamap() to return true. I think kernel should allow those
buggy firmware to boot instead of hanging. And the forcible boot parameter =
is
at least better than the complicated workaround patches.

What do you think of it?

--
Cheers,
Justin (Jia He)

> 2) Revert the earlier commit changing the default to not calling
> SetVirtualAddressMap(). Obviously undesirable for the reasons that patch =
went
> in, and it affects all arm64 platforms. The only argument here is it used=
 to
> work and now it doesn't.
>=20
> > Also, is anyone looking to get this fixed? There is Altra code in the
> > public EDK2 repo, but it is very hard to get someone to care about
> > these things, and fix their firmware.
>=20
> Yes, this is a conversation I'm having internally with the firmware teams=
, and
> the preferred approach provided it can be effectively rolled out to event=
ually
> capture all Altra* and future platforms.
>=20

