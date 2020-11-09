Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 581512ABE95
	for <lists+stable@lfdr.de>; Mon,  9 Nov 2020 15:25:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729973AbgKIOZH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 9 Nov 2020 09:25:07 -0500
Received: from de-smtp-delivery-52.mimecast.com ([51.163.158.52]:41064 "EHLO
        de-smtp-delivery-52.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1730035AbgKIOZG (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 9 Nov 2020 09:25:06 -0500
X-Greylist: delayed 303 seconds by postgrey-1.27 at vger.kernel.org; Mon, 09 Nov 2020 09:25:04 EST
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=mimecast20200619;
        t=1604931903;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=+amwX91qfqnpD7Xyvvrf0STJs1n2fCZ0yszSKBxxPBU=;
        b=igdl7Pddzh5vH3WhBOWNDVQ9sA/u14Mw5ZShvHfRcHaa7yVrSG+tTbKk/bKhS4ceQ/3+gT
        AwwWkjKWmgvh/SA8NA2Kylb+HQsONwHQip2NbfFtYLqJpSHoLRpPEdjXU0et7MhIgj8qyE
        DKyLhr+r/RMmSQVH2IJeUPMX9885UYg=
Received: from EUR01-DB5-obe.outbound.protection.outlook.com
 (mail-db5eur01lp2052.outbound.protection.outlook.com [104.47.2.52]) (Using
 TLS) by relay.mimecast.com with ESMTP id
 de-mta-10-LEARBd4NOW-hojehEPpNPQ-1; Mon, 09 Nov 2020 15:18:47 +0100
X-MC-Unique: LEARBd4NOW-hojehEPpNPQ-1
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=A+LmwWKCq8Iv9VCkmaK58/E8UL5fuvQDoeI03KR8DNbcIMAT72UxgH/ESnh+JCI6nd9sXaq8z2dKJXiRTKeSD2w8Lz9gKVt1wGyRqostMaUi7ScJjyEDX5+jVY0Iiq+QlrVfiQ3maT679qtyaRllcfrOf4xAAJP51OmN8m9cy4ikshyvCC2F/Rza5fYo30AgO7NUYmjrzXE18cMmhexKtyhplNr6fNJVxN2Z6SqYIz8CPB8tU9xu/DClHPVWyrwBiyeva2QNleXsY9G8ydPPeo1Mi6edjtiRR3t4kAAsv9hsku+Ggj5Dh4fZnwlUzZa0ZLTyo6GvFx1U4mgsCtVPvg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+amwX91qfqnpD7Xyvvrf0STJs1n2fCZ0yszSKBxxPBU=;
 b=FHsCwdYgCbsDwxDwUEXd7CA79cRl+LYvOqjUMmKZHygnEy8KzicXQZMHr9b1J+cJvZ+TUy7DGM4HXbvFQzvQgP5aAmqag8D5GotzlbKWr1D2VdFhG2UHZFnbp0/jZ5L2LzVo2OXZP8uttxKvazTNfnHX1FJWAzBvRPECjgi0Qvc09QQY5gFU5aLSJWGhJiYNp37gcJxnwLPHB8qWsS1yrF2bEzd2h+AC0GeDNaqiTLnsg+BEfoM/YTrPrRGBwf/BIsv21Qokl0YPfUMC1U8ghUHfLPfxzOkVahpPr9QqBwPlaZ7gLToLdLrV6LpqKLYhJqpj4/n4x6VU5aDTMRdTnA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=suse.com; dmarc=pass action=none header.from=suse.com;
 dkim=pass header.d=suse.com; arc=none
Authentication-Results: samsung.com; dkim=none (message not signed)
 header.d=none;samsung.com; dmarc=none action=none header.from=suse.com;
Received: from VI1PR0402MB3359.eurprd04.prod.outlook.com (2603:10a6:803:3::28)
 by VI1PR0401MB2384.eurprd04.prod.outlook.com (2603:10a6:800:25::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3541.25; Mon, 9 Nov
 2020 14:18:45 +0000
Received: from VI1PR0402MB3359.eurprd04.prod.outlook.com
 ([fe80::4dad:a2d3:5076:54f0]) by VI1PR0402MB3359.eurprd04.prod.outlook.com
 ([fe80::4dad:a2d3:5076:54f0%5]) with mapi id 15.20.3541.025; Mon, 9 Nov 2020
 14:18:45 +0000
From:   =?utf-8?Q?Aur=C3=A9lien?= Aptel <aaptel@suse.com>
To:     Namjae Jeon <namjae.jeon@samsung.com>, linux-cifs@vger.kernel.org
Cc:     smfrench@gmail.com, Namjae Jeon <namjae.jeon@samsung.com>,
        Stable <stable@vger.kernel.org>
Subject: Re: [PATCH] cifs: fix a memleak with modefromsid
In-Reply-To: <20201109083533.2701-1-namjae.jeon@samsung.com>
References: <CGME20201109084225epcas1p3522cb6e6b277e76055403b83f6b55a2b@epcas1p3.samsung.com>
 <20201109083533.2701-1-namjae.jeon@samsung.com>
Date:   Mon, 09 Nov 2020 15:18:43 +0100
Message-ID: <87v9eetxz0.fsf@suse.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Originating-IP: [2003:fa:705:6850:d332:5221:af3c:2ef8]
X-ClientProxiedBy: ZR0P278CA0022.CHEP278.PROD.OUTLOOK.COM
 (2603:10a6:910:1c::9) To VI1PR0402MB3359.eurprd04.prod.outlook.com
 (2603:10a6:803:3::28)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost (2003:fa:705:6850:d332:5221:af3c:2ef8) by ZR0P278CA0022.CHEP278.PROD.OUTLOOK.COM (2603:10a6:910:1c::9) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3541.21 via Frontend Transport; Mon, 9 Nov 2020 14:18:45 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 9ff2cbb8-8091-4b8c-7796-08d884ba5e76
X-MS-TrafficTypeDiagnostic: VI1PR0401MB2384:
X-Microsoft-Antispam-PRVS: <VI1PR0401MB23844B4DB5D7770C0E6845C5A8EA0@VI1PR0401MB2384.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:1728;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 2cNEossZI89zVGYTCVuCmVXme4LA/con3QfX3cEc3D6liruSw0nuC90ZHV2ZnL8BsMkS9swaD8uanXELeXviOei1aRY4P2epXuxNU8QszI0Tvk1zdVnuBk8eHPWj+eZzAAl4EvZZGKwqr4PoiFr7eObeK6sxykYM23vsWAPiBcG8ENWuXgI96X7KlQ6YLKlTkQdWY+p2R+c9gJcrgfEFuFdi/Fr0BKKdDoPP+n29D4lYVSmlm83q6uqS7G66WHPaQ8CpySrirICwysluDWuKe3vgVpcfixw5fAFKB4uYrdCgHYEPmruUnx9tzgzPWDfBAX2tPOnp95wMiT8F5MjFEA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR0402MB3359.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(39860400002)(346002)(136003)(376002)(366004)(396003)(2906002)(478600001)(52116002)(6496006)(2616005)(8676002)(54906003)(5660300002)(8936002)(4326008)(86362001)(36756003)(316002)(6486002)(66946007)(66476007)(66556008)(16526019)(558084003)(186003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: SfsPf5ezUIppEsPAlCeWX3HgVnWgtQH0jnvwUcukJyLObw3Wx9CDnoKRam+Rc8kw39hjYGo67a+CsToGur9+mnwgoeGc89zyXgLBq4thY1EcDRoy+Ao62Q149Rfvv0T2aWv7RnMrfFk3sShpU7UDwaOeJmmuTx3rmf5W4Mdf9JOPIkde5MpNOnTSCIInxIwbT1AfwduNPLBU3LJbMuW+fcbN4xsbNe2jFPZnmceKt/3W3C9HM9paR+QegvPW/N4mBFR42H922GX9TMSAYzqVqStt5zJVOVt65An7g2y3h6JQ7HdLBIGMOfdSMyQOqLFUtbVlBaVgW2omBpfh6oPfcztVU7dpUj/zIl70vlq9WdbSy5WSr6ZfnldbOwVLXJ9VPecJTvW6bakjTdG0DsLyr4ykX2Rl8TgPSbrSdpVUOirXNsjL5MwPePItAjQwX+8KlBTuQ+3H+g9DkedVvKEAoQh/Sf8kD3EASTxbRUo3hdsoCG6gqH7Sey3Zyb6MyVSvTa0UrXyoF142neDM0TlWlN0pUkermuHWMoOTAnKPnB866wrvIgNgPU4QZ+0CqNLF2i/iEGfz56CE6PPjET6Gwf9LfaX6dNV5QP15VpEKtOQ3vj2Vy1n+L9zy3zL45LD/CGHYkoCLaRIOU+56cKhE/uFWGW0BuYRyO6rgT+IE+WyGvAvvd7UBG6XeAPtjxsQOY0i9UB0GgdhvGBqjy9vkxA==
X-OriginatorOrg: suse.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9ff2cbb8-8091-4b8c-7796-08d884ba5e76
X-MS-Exchange-CrossTenant-AuthSource: VI1PR0402MB3359.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Nov 2020 14:18:45.8579
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: K80/VnEhy4ic+QzNLIsVOYLPoWPF9CHU/LhUcT2Iuwo2DgOQ24SU7LQR3cCWKu0g
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0401MB2384
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Reviewed-by: Aurelien Aptel <aaptel@suse.com>

Cheers,
--=20
Aur=C3=A9lien Aptel / SUSE Labs Samba Team
GPG: 1839 CB5F 9F5B FB9B AA97  8C99 03C8 A49B 521B D5D3
SUSE Software Solutions Germany GmbH, Maxfeldstr. 5, 90409 N=C3=BCrnberg, D=
E
GF: Felix Imend=C3=B6rffer, Mary Higgins, Sri Rasiah HRB 247165 (AG M=C3=BC=
nchen)

