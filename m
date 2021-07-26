Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EFCEC3D5328
	for <lists+stable@lfdr.de>; Mon, 26 Jul 2021 08:33:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231639AbhGZFfa (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 26 Jul 2021 01:35:30 -0400
Received: from mail-eopbgr1410050.outbound.protection.outlook.com ([40.107.141.50]:6016
        "EHLO JPN01-OS2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S231263AbhGZFf3 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 26 Jul 2021 01:35:29 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=kKs4MB/yuRzSOWZNMVLsq33dS1+xXW+3QEtiRUmZFpAKNxezkckbZIPDEtNsG9cD47ky6DoOEe3Kl4IJyh8wsq2kojfaMAwobHRjZX4lBgiYW7gBdMQYfGlmy5ncK+/SQ+/IDTLgzRGQLbaf484Eka/1lEKRmKxZaeSa2b/TDJVOlqoehW38QbsyOTjFIC9UHMGqrrcy1UGJv6ApuOneVHAR6dWJwDTJglKGU9tB56uhBX9KBRNACk8aK/1k23QfXhunQICYIpg68bR7Mw9w94rO1oebTxFVK9T+e1SqN9gPIdGJDdijXLHa6ebbcED+HeDnr7OJstmnUBCofHoraw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=UkY5gZaf/XO6gNuwGUav/aoUqy8vPPR+cMS/M1LwxLc=;
 b=kE7u5VUAOQ/bixilkJbW1IDK65fd1zQezhfzsbOIv4x0XAOoP3hiKFqA2Of4xyheqbM7Ghcw5LLpCiPzp/DXUTwvtkuAsqc+9+2IES1T6sLfuj0+8er8Zp+VDfLm82/9NmEGlY4aRzzYuRFt1s0eg+PIErbsOe8QqtTaW3X7XO9vJev4/RTZEPxn8P5M0kyaHf36cZ8HAQjhXRt01EHMWRPEZjGlSz3LuycZpv5eKjSY9tMFSGNOsidBBJFBJIhqWT5e3itg7cvorgWdQNsGfroGZwhMgDjVkMq/6k95D0Ofno6Pq8aU5XBOjhxXYdYqbMkp5UDTbmTKtcwlpRnbNA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nskint.co.jp; dmarc=pass action=none header.from=nskint.co.jp;
 dkim=pass header.d=nskint.co.jp; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=nskint.onmicrosoft.com; s=selector1-nskint-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=UkY5gZaf/XO6gNuwGUav/aoUqy8vPPR+cMS/M1LwxLc=;
 b=Y0fnRKnj79aNqIc60rK4aytl+u+7TJyCyHIC53hDujVhD8OcwVt0jfeDHByn8OOCQD9cWx5+dqc0Ljb+FyQxH+blulpITitWqGKprLlCblN+1Yc4rkKxcPjhe5QiSNENwbaRULI7LtgAZyBnMX5jmKdG2R+bTKRjRCxpKb0x1P4=
Received: from OSZPR01MB7004.jpnprd01.prod.outlook.com (2603:1096:604:13c::9)
 by OSAPR01MB3378.jpnprd01.prod.outlook.com (2603:1096:604:5f::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4352.25; Mon, 26 Jul
 2021 06:15:55 +0000
Received: from OSZPR01MB7004.jpnprd01.prod.outlook.com
 ([fe80::94dd:c412:338:709e]) by OSZPR01MB7004.jpnprd01.prod.outlook.com
 ([fe80::94dd:c412:338:709e%5]) with mapi id 15.20.4352.031; Mon, 26 Jul 2021
 06:15:55 +0000
From:   Yoshitaka Ikeda <ikeda@nskint.co.jp>
To:     "stable@vger.kernel.org" <stable@vger.kernel.org>
CC:     Yoshitaka Ikeda <ikeda@nskint.co.jp>
Subject: Re: Patch "spi: spi-cadence-quadspi: Fix division by zero warning"
 has been added to the 5.13-stable tree
Thread-Topic: Patch "spi: spi-cadence-quadspi: Fix division by zero warning"
 has been added to the 5.13-stable tree
Thread-Index: AQHXgcgiVsY52GVDQ0S1djyU8MKltqtUx9GA
Date:   Mon, 26 Jul 2021 06:15:55 +0000
Message-ID: <8543ac03-7b27-ce1d-d5d8-156a91a272d3@nskint.co.jp>
References: <20210726024417.6A37860F11@mail.kernel.org>
In-Reply-To: <20210726024417.6A37860F11@mail.kernel.org>
Accept-Language: ja-JP, en-US
Content-Language: ja-JP
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.12.0
authentication-results: nskint.co.jp; dkim=none (message not signed)
 header.d=none;nskint.co.jp; dmarc=none action=none header.from=nskint.co.jp;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: e4aaa552-b4d9-4b44-2035-08d94ffcd411
x-ms-traffictypediagnostic: OSAPR01MB3378:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <OSAPR01MB3378C3DFC180E88513F689E38BE89@OSAPR01MB3378.jpnprd01.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: RD+QD7tZyVznlTLtHtCymqd38SLJR0QU4uxfalUHWNpM8HhVKvuHgcaKCekzYjBy6nrxaKxECvlE5Y8tHQNips3cbB8QqCOh6u8Ap4A4+gJRjMvZXbxh1ej5y+Yn9zecp/i46bsXrQAu8N0OmThmrDEKxY00A/AkmT2cUWOgfot+wVUqsAE3l6mhh+33/0cqK7FVZqJL3L+Jgnc7N9Wxi2kRnzR2T7Ka44B20CmH7sL/vRRTKeN/t/w5brGTTejPxqfJXhoF0d6jQgz1aS4tvbaCZxE54swCe6JfUdkBh8IkBxdkl+JeNSYpka/iIXmx4d6YS7t4NWky0X53MlXuyCbiqhFkFOpBdoBL2y2QaLZ8liTEKRf6DfvQKFBImnEp2xZpA9OhGdH/VAHNE/lBtldB6IOH0U+skdTzUSLd8k2I28TwkLO61GYDBmdErEndgdiup1HiYXd3Q/FLM5mKyncVbzim65/XSPbn1RlVnPdp7dH/3iD8ADVQZFTp4wMFWaJRWO0Eclj+aEP89yu2VicrDWevoGUpLxbwXfV6k5ss5bZGNtIQ1ZckbIMNW+bza4WKuTK8umqJEEImo+KgF4ScC0goOWE9IDfTPMKa4u+I835xlu2tIeMXZ3xJxnSn86zUdx2tXDI6TodL45Q1Qfh5Y4bfFBF7C9rXlgxmA5BZrDcrUvnvTO+OI6TYE1/522m2uhzyApQpg7frhG4yYQFiv5zbsflklLnrVrAHHLNEBxcNn0PmQvOr6fj5ysSQPJXxu6CE1YtZr5qRx3WP1w8fQe/Wo5BRm+qawF33VdyP5BYaVIeNB9EPtSxYyu1+HS/ibRTXCbp0HB7vIB/7QmsJxB3KG/lOR/KcutNo3OU=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:OSZPR01MB7004.jpnprd01.prod.outlook.com;PTR:;CAT:NONE;SFS:(346002)(39830400003)(396003)(136003)(376002)(366004)(107886003)(26005)(966005)(316002)(71200400001)(86362001)(5660300002)(186003)(4326008)(36756003)(83380400001)(38100700002)(53546011)(6506007)(6916009)(122000001)(31686004)(66476007)(66446008)(64756008)(66556008)(76116006)(2616005)(6512007)(478600001)(2906002)(31696002)(8676002)(66946007)(8936002)(6486002)(38070700004)(45980500001)(43740500002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?iso-2022-jp?B?NHJWSU4yT3AxMmUvOUVUcnl6aTNtUXBtYWs0WVVzZnNTdVRMY1I0V3V4?=
 =?iso-2022-jp?B?R2RRUERlVFpaUERGSGxUK1FFcnpnQ1NscGxnVSs5d1NXZ0l1c1ZtcUw1?=
 =?iso-2022-jp?B?bWtzM0tQd0hqRU83bTVRMEd1VUt2WWIvMUtZSDRmTllWeXEzSHZJeEk2?=
 =?iso-2022-jp?B?YjBlWk9wbmlpL3FjT1hLUFpERDdGTUViSGppaUpoNzd1cU00cGVBdHFn?=
 =?iso-2022-jp?B?bzRzaFE1cVRuQ2FESlVzUTJSTXhMZUhWNm81UEVkejR1SzJFK0RGQTFY?=
 =?iso-2022-jp?B?QlBHOVVXZnRVQ0plTlQ0MGJRNU82QTJLK3RDM0FTVkNrWEpibWZLeUxO?=
 =?iso-2022-jp?B?c2FxK3hnRDNuZ0IxeVJUYVhhVzFvUW04cHc0OThhamZWWDNVNm5qeHFw?=
 =?iso-2022-jp?B?RjNDeE5KZzhBREszaWd6aGw4SEdZRGMvTTBiWERLV1NPNmRSNysva1Zs?=
 =?iso-2022-jp?B?YXAyQU1ud1Q3Zm8zR0Z1eHUwaXdyZHZReW5PdzZVWjRLWWI1SWJKdGEv?=
 =?iso-2022-jp?B?YlpyVUdLVlg1Nm1jRjkvY0NlaTFtSXE2am9jM0xlUkp3bENHQkJ5ajdT?=
 =?iso-2022-jp?B?UVNhRWVSNm1zbVg3dDNrY3hSekJWM25Ebmt4WEJjSkZEVmVtZTJSUURx?=
 =?iso-2022-jp?B?K0szdkFYZHhVZGFKbjhkbXRKQmpmWnhPQWRYdTRCeFdwS1RvM0R3MG1i?=
 =?iso-2022-jp?B?TXErRkQrQTNSVkZzNHJvNzRSOUNYRkdkbVJ5d0I0bTNWL2xORURYeDNj?=
 =?iso-2022-jp?B?RS9uYi9zdGZEMlREeW9Pd2RGNk9lOHlZd29WNnczZS9ObVZWL1ZqWkdP?=
 =?iso-2022-jp?B?NlJJTUVZaTF0WGtPeXNaZXFZMEFvV0lYcDJUYUNJcnp1MWx6YklidERt?=
 =?iso-2022-jp?B?amhUQlZwYkUvUDhLaXEyMitaSkVUcTIvUXMwVDVxT1JjQmZua2ZSMjB2?=
 =?iso-2022-jp?B?UkNLcS93RS9wcW5tS1cxS0hvQVlrclJ6UTZlZ2xoeS9odUNzdE9mdGtQ?=
 =?iso-2022-jp?B?Wk9qNGJKY2RlaXFaZGpQUFZrbVR6ZXE0SWgxOWh6M1RubXRwbHNvcmpC?=
 =?iso-2022-jp?B?MWZ6OWVQWW03bDZyK1VFc25Wam5QRExWSlE1ZVhsazZieGhhbkIwV0pF?=
 =?iso-2022-jp?B?amZaYmVkY0Y0T3FmalE2S3FuM25rMm1OR2syUDVjQTVlMkZCeTVQaFFj?=
 =?iso-2022-jp?B?K0dzUlRZSEhZTWtoSWZQS3J5cnFrMHpMdDhUcnBXam5UQy9jVHVPTXFy?=
 =?iso-2022-jp?B?OW1kcHpGdFozTUlUdUFzUUZhRWpOYW40TWt3cDBSUU9CVHViNHdNbDdu?=
 =?iso-2022-jp?B?U0Zmbmd2bXB0dG9BZVlOa0s2aTJjUnBWMm5VN1RYOWxpdE9Bbm10MEpU?=
 =?iso-2022-jp?B?ejU3NG9SNVZzdHkrdDFHMWxZaWhtTVlSUjRMZTRmN0N1aXp2S3hScUxS?=
 =?iso-2022-jp?B?MEtZNXlObk4wSHpCNXdYNFh1K25YU21mYk1qcjFkbWpWOVNLZS9uYWpV?=
 =?iso-2022-jp?B?OUpibGdJdURHa0JWWng4SGx3eHMwcVBHcFVZTU5ROGNaVGlmOSsyYTVi?=
 =?iso-2022-jp?B?SU5abjZ0SVJsc3dTeWZGRmFIRXNXVHZqeWUwMXNFYllWaWRGVDdyczkr?=
 =?iso-2022-jp?B?YUQydDRJNk1SMTJ0UWwyVysvOHFmaE96REZDc3I5SnFlbVgyQU5Ka0ox?=
 =?iso-2022-jp?B?TkgrQlhOT0RCT2NIWFVNQ3doYU9zUmZ3WExjaFp4MUJsTktGNHJXMmQ2?=
 =?iso-2022-jp?B?RDRiZ3N0a0ZHdmcvaHE1Tmt2b1gyTmhZWHMwcENZbWhpVDlQdWgzUEh2?=
 =?iso-2022-jp?B?dHRISGszcllXNytnVTJybGdNOXBHRkYySWRKa1NUb3NJNGZyWjZUOUtq?=
 =?iso-2022-jp?B?ZDhrR3V2cUtIUnp0VGJYWXRhN2FKRXRhTGdIby9LdUZvWURPYkNXTTV4?=
Content-Type: text/plain; charset="iso-2022-jp"
Content-ID: <62718D2E3D687142A216059A28FF911E@jpnprd01.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nskint.co.jp
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: OSZPR01MB7004.jpnprd01.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e4aaa552-b4d9-4b44-2035-08d94ffcd411
X-MS-Exchange-CrossTenant-originalarrivaltime: 26 Jul 2021 06:15:55.6735
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 727455a2-9822-4451-819f-f03e059d1a55
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: i3hlCOGbIBa9DnsRBttVzdxawwUsO7ZwRzdm3399mrwrvzDqj0v1wr9GrcxMsIrJbJbW8lZ8b17KB03oSVpWIw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: OSAPR01MB3378
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi,

This patch is not up to date.

The following revert and commit are the latest.
  https://patchwork.kernel.org/project/spi-devel-general/patch/bd30bdb4-07c=
4-f713-5648-01c898d51f1b@nskint.co.jp/
  https://patchwork.kernel.org/project/spi-devel-general/patch/92eea403-9b2=
1-2488-9cc1-664bee760c5e@nskint.co.jp/

Please replace it with the latest patch.

Best Regards,


On 2021/07/26 11:44, Sasha Levin wrote:
> This is a note to let you know that I've just added the patch titled
>=20
>     spi: spi-cadence-quadspi: Fix division by zero warning
>=20
> to the 5.13-stable tree which can be found at:
>     http://www.kernel.org/git/?p=3Dlinux/kernel/git/stable/stable-queue.g=
it;a=3Dsummary
>=20
> The filename of the patch is:
>      spi-spi-cadence-quadspi-fix-division-by-zero-warning.patch
> and it can be found in the queue-5.13 subdirectory.
>=20
> If you, or anyone else, feels it should not be added to the stable tree,
> please let <stable@vger.kernel.org> know about it.
>=20
>=20
>=20
> commit 8e7f9650f5d883bca7b0239529c1b704673abd38
> Author: Yoshitaka Ikeda <ikeda@nskint.co.jp>
> Date:   Thu Jul 15 16:21:32 2021 +0000
>=20
>     spi: spi-cadence-quadspi: Fix division by zero warning
>    =20
>     [ Upstream commit 55cef88bbf12f3bfbe5c2379a8868a034707e755 ]
>    =20
>     Fix below division by zero warning:
>     - Added an if statement because buswidth can be zero, resulting in di=
vision by zero.
>     - The modified code was based on another driver (atmel-quadspi).
>    =20
>     [    0.795337] Division by zero in kernel.
>        :
>     [    0.834051] [<807fd40c>] (__div0) from [<804e1acc>] (Ldiv0+0x8/0x1=
0)
>     [    0.839097] [<805f0710>] (cqspi_exec_mem_op) from [<805edb4c>] (sp=
i_mem_exec_op+0x3b0/0x3f8)
>    =20
>     Fixes: 7512eaf54190 ("spi: cadence-quadspi: Fix dummy cycle calculati=
on when buswidth > 1")
>     Signed-off-by: Yoshitaka Ikeda <ikeda@nskint.co.jp>
>     Link: https://lore.kernel.org/r/ed989af6-da88-4e0b-9ed8-126db6cad2e4@=
nskint.co.jp
>     Signed-off-by: Mark Brown <broonie@kernel.org>
>     Signed-off-by: Sasha Levin <sashal@kernel.org>
>=20
> diff --git a/drivers/spi/spi-cadence-quadspi.c b/drivers/spi/spi-cadence-=
quadspi.c
> index 7a00346ff9b9..13d1f0ce618e 100644
> --- a/drivers/spi/spi-cadence-quadspi.c
> +++ b/drivers/spi/spi-cadence-quadspi.c
> @@ -307,11 +307,13 @@ static unsigned int cqspi_calc_rdreg(struct cqspi_f=
lash_pdata *f_pdata)
> =20
>  static unsigned int cqspi_calc_dummy(const struct spi_mem_op *op, bool d=
tr)
>  {
> -	unsigned int dummy_clk;
> +	unsigned int dummy_clk =3D 0;
> =20
> -	dummy_clk =3D op->dummy.nbytes * (8 / op->dummy.buswidth);
> -	if (dtr)
> -		dummy_clk /=3D 2;
> +	if (op->dummy.buswidth && op->dummy.nbytes) {
> +		dummy_clk =3D op->dummy.nbytes * (8 / op->dummy.buswidth);
> +		if (dtr)
> +			dummy_clk /=3D 2;
> +	}
> =20
>  	return dummy_clk;
>  }
>=20

