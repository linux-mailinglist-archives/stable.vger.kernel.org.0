Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7A984283B6F
	for <lists+stable@lfdr.de>; Mon,  5 Oct 2020 17:42:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727358AbgJEPmM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 5 Oct 2020 11:42:12 -0400
Received: from mail-co1nam11on2082.outbound.protection.outlook.com ([40.107.220.82]:61755
        "EHLO NAM11-CO1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727350AbgJEP2N (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 5 Oct 2020 11:28:13 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=CKId5XnT0zR3yT9iC6X4qjzt9sEgjeTKrI4yfkS2JQKWMhkcL6wnQkgT44t7l2iQnjIYCNe7AKhoMJW7wes79weZze0m3YQKDblmDSOdUKvDSuCFR2v9iXs/37aLvOESGF8sS8ttVVMWtUZAHI8hTxxn7HtWIoYoboqlEDdIhOUkowelhHQOgpRlSvarzVyfqa+QcVzsl+0r46NDUC7sXdRR564X2fs3azVpniUUCStblRD5g0iiMurm6nl81qT0Tn/e0qBFCB+j/A1iqABJ0dCmqYkDBrnsBNkzSHJgDS3iLZloXkjAnZTVOQURTP5gV/LK+tncoI5HXDHWE1/sDA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=WbJcvdOrXCcdTfK4/APwh8txAOqgB1QGGF5ri6R5ubc=;
 b=iXOX2P6hC5qZ5VNmAPXMnEmhtm84hQznUhyjgH9/Ov6PWmJcfdCq8auyrEF9sWyt7q08vW7ExA2aip9goSsZmat9q1UUv2jvnOxE7MC3jpLcxHao6QFQ4soJvwC19GkSS6vNUyWWN2CmrzzxgS+0IMXTq5WoTrupqabiepZ6WhF/diIR0er2eeM1OKR9r8NJ2epW15TywcvkiTXlmv+dR/2V90TFlc4GftbDvnou1qt62zlH6hJjc3EEizV+P7x+BSnSD3SHLsigtK2B4iSNiqSYlRXTcjWp4z6JgNv3Gtm44Fn/Ytbe8Ng6huehXsxBz5sArNjTtg7P2Lb/mJ4Wrw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector2-amdcloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=WbJcvdOrXCcdTfK4/APwh8txAOqgB1QGGF5ri6R5ubc=;
 b=zx/kGUV3pXO/Wvj1zVvC2g5RnanXZwurtC69MYpEPdoPCzsnS6mPcggLHew13nFyWFFfc945y6S6npFcKOWDF3OrNQSZOhKYCXuj9DSK7BHaMNMA9Dyx3e+7nWxcD/+um39w10hJZEUry5mWAr0OM8Q8HQ2w1qBxnaHuLb0MkBc=
Authentication-Results: amd.com; dkim=none (message not signed)
 header.d=none;amd.com; dmarc=none action=none header.from=amd.com;
Received: from DM6PR12MB4124.namprd12.prod.outlook.com (2603:10b6:5:221::20)
 by DM6PR12MB3178.namprd12.prod.outlook.com (2603:10b6:5:18d::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3433.39; Mon, 5 Oct
 2020 15:28:10 +0000
Received: from DM6PR12MB4124.namprd12.prod.outlook.com
 ([fe80::25a1:ace4:4ca8:167e]) by DM6PR12MB4124.namprd12.prod.outlook.com
 ([fe80::25a1:ace4:4ca8:167e%8]) with mapi id 15.20.3433.044; Mon, 5 Oct 2020
 15:28:10 +0000
Date:   Mon, 5 Oct 2020 11:27:56 -0400
From:   Rodrigo Siqueira <Rodrigo.Siqueira@amd.com>
To:     Qingqing Zhuo <qingqing.zhuo@amd.com>
Cc:     amd-gfx@lists.freedesktop.org, Harry.Wentland@amd.com,
        Sunpeng.Li@amd.com, Bhawanpreet.Lakha@amd.com, Eryk.Brol@amd.com,
        stable@vger.kernel.org
Subject: Re: [PATCH] drm/amd/display: [FIX] Compilation error
Message-ID: <20201005152756.mpg4rzq7qbc5zavh@outlook.office365.com>
References: <20201003001616.16816-1-qingqing.zhuo@amd.com>
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="km7a3jd4wigd6y5j"
Content-Disposition: inline
In-Reply-To: <20201003001616.16816-1-qingqing.zhuo@amd.com>
X-Originating-IP: [2607:fea8:56e0:6d60:fa59:ed82:d489:7fd1]
X-ClientProxiedBy: YT1PR01CA0093.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:b01:2d::32) To DM6PR12MB4124.namprd12.prod.outlook.com
 (2603:10b6:5:221::20)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from outlook.office365.com (2607:fea8:56e0:6d60:fa59:ed82:d489:7fd1) by YT1PR01CA0093.CANPRD01.PROD.OUTLOOK.COM (2603:10b6:b01:2d::32) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3433.32 via Frontend Transport; Mon, 5 Oct 2020 15:28:09 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: fc598eed-3f6b-4d5d-e9e7-08d869434412
X-MS-TrafficTypeDiagnostic: DM6PR12MB3178:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DM6PR12MB317826D2EB3B56940F1A9E47980C0@DM6PR12MB3178.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:1051;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: /a0c5v9cXmNciU1M/TIrqScsJo15pEvKJaALH0WDJkCpe6dZspBRlLS2cXhV3H5CQqQJjgLAC7Ymr0X8tlXXBt4CuL1SWby/aHIq3AiL/4gmrkZAzuMqAWSqN/yZS/5ph6py7rf7r9CWbeRJE0XvH+uxXwIYkZF0vwk9DDTU84GFjg6JUQuWQjSQlJ+8ru4GnvVgkinCr49MHsuOrMp/y/KVHh4tS+GnxNMVM58Akbz2zRhCpIdMGMpy17ZZB0t/bjoHK1n1DDS/3YMmw5e9L0jhZxpa808lErfvEJotLVFqcGKV7ryhPlFQmWoNbqvrX+VlRcpFgVDOV1MPFZltdM5XiPVqd6W4T7IMp7f7q+DSZUkoOeYtICKyk7ePpLdt3rn0OKvlEnZzt9XRleAmP2cqBQqIEaWHGI8PCRlDT2nJr3Nw/mHNvNYkOARdd7FTjeWWnwc48FujnuU3NbGSoA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR12MB4124.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(346002)(396003)(136003)(376002)(39860400002)(366004)(66556008)(66476007)(66946007)(1076003)(4326008)(8676002)(21480400003)(8936002)(2906002)(6636002)(86362001)(44144004)(9686003)(52116002)(6862004)(186003)(478600001)(83080400001)(16526019)(83380400001)(7696005)(5660300002)(966005)(6666004)(55016002)(316002)(6506007)(2700100001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: LhCbGt/Pp8xJ9FGrnVkkt7XvyJ6oxXjqHXDF37rcOEQ1a7M+R5Pr2WXJ1bNqX0ZQpasW4NbwxVllWQoT1yUoWBd8h25qsiNeJej0+WpvRxX0StlqN4CsVMD10faf9BQGBEJwmk17jeM0Zixyz1jkfzSt9v8s+JJj4T36j4GmXH1mqRujT+JMYhqSPF8NHqN2AABFnPNe7vgjjW/b7Lc8RXPJFqFT3NzOGAslZ8HUz63TS7GuH8WQzyiv/zYWjDtd53JbvdbCKi0wfxpswQfO+Zl7JEYt0JH+PvBBtczpms48RLDBlhkY9/fU/hfzSHUwMzVlcpP2QtuNimOywJ2ffYxcR5ShisBLO5hP72kIXXwmgi8yb8Qjz0Z6FaE3ZgaJgOiH6CjDysBVbbl65Bt0ZUqcwQyEQP0xFQIuD1k7KH1jpnZP6OCJ7G5HH8e6ysmD0ML+TjCQ/dAAjuhRg7T5CCFNvmLAZTYbJwyl28q6DVHsIJAMycjcO9LvcqzBTaW1cEO0swNqZDzl59U0LQaJryR9aqMGx/Au4HimvQhJ+K59dUU5zrTlKnl4uoKNBY/+a0snpHK0VcDLHt0JNOIlTrsQH5VZvzXfu4DT+uBU9/emfDPRJGz1KVB9y2v+qO+EnPNny9HO95GLuU3U77aub5tg1lKo5DBY6HnmYIU8qKgb3Q6fkOcBvoFSRW/WxRlLoo0B3yNg1nvuBp5hiyL8YA==
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: fc598eed-3f6b-4d5d-e9e7-08d869434412
X-MS-Exchange-CrossTenant-AuthSource: DM6PR12MB4124.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Oct 2020 15:28:10.0911
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 5V8U0ijYb872r4Rx6+r3euEpQEt7DWvkqmMsPrSHllvNiXUDo/ldzVUmszzBiA1/BpLiVDLfeRhJn9kymVip2w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB3178
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

--km7a3jd4wigd6y5j
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Reviewed-by: Rodrigo Siqueira <Rodrigo.Siqueira@amd.com>

On 10/02, Qingqing Zhuo wrote:
> [Why]
> ifdef mismatch.
>=20
> [How]
> Update to the correct flag.
>=20
> Signed-off-by: Qingqing Zhuo <qingqing.zhuo@amd.com>
> Cc: <stable@vger.kernel.org>
> ---
>  drivers/gpu/drm/amd/display/dc/dce/dce_abm.h | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>=20
> diff --git a/drivers/gpu/drm/amd/display/dc/dce/dce_abm.h b/drivers/gpu/d=
rm/amd/display/dc/dce/dce_abm.h
> index 389ca0d54d1b..829cd9a93ba9 100644
> --- a/drivers/gpu/drm/amd/display/dc/dce/dce_abm.h
> +++ b/drivers/gpu/drm/amd/display/dc/dce/dce_abm.h
> @@ -189,7 +189,7 @@
> =20
>  #define ABM_MASK_SH_LIST_DCN20(mask_sh) ABM_MASK_SH_LIST_DCE110(mask_sh)
> =20
> -#if defined(CONFIG_DRM_AMD_DC_DCN3_01)
> +#if defined(CONFIG_DRM_AMD_DC_DCN3_0) || defined(CONFIG_DRM_AMD_DC_DCN3_=
01)
>  #define ABM_MASK_SH_LIST_DCN301(mask_sh) ABM_MASK_SH_LIST_DCN10(mask_sh)
>  #endif
> =20
> --=20
> 2.17.1
>=20

--=20
Rodrigo Siqueira
https://siqueira.tech

--km7a3jd4wigd6y5j
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEE4tZ+ii1mjMCMQbfkWJzP/comvP8FAl97O3cACgkQWJzP/com
vP8eHhAAk7D4B9RjckW41P1Kk5ESrj/SnsuhWhZ3Uh2TgPZGoPETsf17BOiFZu0P
DAtbEBO6rUnO9mzAp8E6YKdZVsShkzIu/YWsRjBevi2qsB98xOHysSRUAwc6EqI8
Af+Plwx9HhQzx4++20JPr+oUO4HNIeBX8bhF0vSs5XyO+aX+s3AKko67phBo3qfU
dY6Q+yPEpn90zsQR/PT2/zBLYdSi4niUc5dmap5JNehZQymN3AqCDmaT+bXx1W5b
XGvIFKXQOftEfnaiQiIFS+4XLhMXoqtepCO38uSgdAViP1zpAeSgrl48WkqGfFX8
HZSFvrz2YaETu/YE9UlMXA/RoZQV2WtkPxbSZrzWtmioohwERpG4hpIcAcm6Eusf
8GSlLe0jAcOpQaNirANZnC19wSAKrv/9E9IKyUdoGv2zm2M8oGmazqvfTGjCOlvM
6q8iqhJF/5Bn3xIuMribcVV9VRIgd+GkzVHVjzdCCLWM8cRJMOS4TV9SdLicA4dI
p8nXCJKAGQW3Kvy/bZ7IBZYLRkdsHKg3ENZ4KWEji+lhO2c6gz6/SN9SZmyYkI1D
7igFpF2vxXquk0wAvvHd0/2OZgS+ZfWxV4MEdSPuxYGof5EynWW57z/7iyauaGnz
HxKm5/yIr6rcPfd/8GysTWdVl0vX0STQkOqDz034dh8kwS5i8BY=
=y3ip
-----END PGP SIGNATURE-----

--km7a3jd4wigd6y5j--
