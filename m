Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DC0DB17573C
	for <lists+stable@lfdr.de>; Mon,  2 Mar 2020 10:36:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727060AbgCBJgh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 2 Mar 2020 04:36:37 -0500
Received: from mail-eopbgr70073.outbound.protection.outlook.com ([40.107.7.73]:63430
        "EHLO EUR04-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726674AbgCBJgh (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 2 Mar 2020 04:36:37 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=SedSrbbES3d4IfQEPyxrKVPzQAPHNxpIEOPDBC0XmygPGQpgjxKC8tsikokj5Dp6lSrzBEalqMV6iVHe6xvI21rsxQerNt0pYr3A9P+mgz4ZNbiUGC9wcy67G2Zl9lZs/LvcUZiFCfAC8yjrlgj3q0nJyOjkd9NBNKkzwrr1Ag4J96hb6LeLCMFOvrFp3Zw2HN9XEUQYGyph8eISzU42Z4kHdfXGLa4Ub9hXAujsPKNCVL2Ubu8A3ktH1Kh9t/YustkcGGomHAZ1jCe6a7qH+ev/GtQNY/o/ftIUaauUMyMVbLkjIteDCYbOhQsyfZkJpr2HeJxQY6gd8NdH5P60jQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=N4VTMR1y/qGwDF9Opj1UTtjSGLtdWO5PxQxFiOvuLoY=;
 b=OiYR3VCAZlbwB9cyL6kBueHTnKJCbFOSxYL9FQlbgbMs8Vceo8knUCedapRas4cxpylSM3wwb7Lr5MwtqjYbmvvDRwzHPUMf32ykqNRH8E3MdqbHscmxK/wsGInNFi5rObYufg/KC+DNqNCqlvmNwVMLzPCblifSnnhoLn4tDjoCEgll9d8rL5fkT+dC2eu/v06Qk60Cl13vieieVK1CvJCGZi58TW2zgJcyWMGYpaZL6+sJW+o1MrsXJZwGYlzOjpamvqLZ+9991jqJGNwFI16BU2ttZfwpgigZl189RT9uGPoGM+vG92vyzTbFraoXnAO0MdudkrPEqkIaChNh/Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=N4VTMR1y/qGwDF9Opj1UTtjSGLtdWO5PxQxFiOvuLoY=;
 b=rBelNWMRHvdY1Wj0T03pPHUwjejkt3xK2TeAYJ1ypIaaYHj0sgNK/+8i+kXSoZmXjAkcg3i6j+5jz1cEQvAhdH1kjLOfV6YVc4MZZL1iQpSPT4Gm/0u6F0qDgvhjjxseNG1nNhzPGDcuYOUTQ5Z9x/cANBdkV7A4XF24p30O9gU=
Received: from VI1PR0402MB3485.eurprd04.prod.outlook.com (52.134.3.153) by
 VI1PR0402MB3552.eurprd04.prod.outlook.com (52.134.4.149) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2772.14; Mon, 2 Mar 2020 09:36:32 +0000
Received: from VI1PR0402MB3485.eurprd04.prod.outlook.com
 ([fe80::751e:7e8d:ed4:ef5f]) by VI1PR0402MB3485.eurprd04.prod.outlook.com
 ([fe80::751e:7e8d:ed4:ef5f%7]) with mapi id 15.20.2772.019; Mon, 2 Mar 2020
 09:36:32 +0000
From:   Horia Geanta <horia.geanta@nxp.com>
To:     "Andrei Botila (OSS)" <andrei.botila@oss.nxp.com>,
        Aymen Sghaier <aymen.sghaier@nxp.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>
CC:     "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Andrei Botila <andrei.botila@nxp.com>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        "dm-devel@redhat.com" <dm-devel@redhat.com>
Subject: Re: [PATCH] crypto: caam - update xts sector size for large input
 length
Thread-Topic: [PATCH] crypto: caam - update xts sector size for large input
 length
Thread-Index: AQHV7iR/GJR55F8brEiS/iBRq64oyA==
Date:   Mon, 2 Mar 2020 09:36:32 +0000
Message-ID: <VI1PR0402MB34851CC70E092F598E9BF32298E70@VI1PR0402MB3485.eurprd04.prod.outlook.com>
References: <20200228104648.18898-1-andrei.botila@oss.nxp.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=horia.geanta@nxp.com; 
x-originating-ip: [212.146.100.6]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 08c672b6-2a6c-40ec-4b0e-08d7be8d3158
x-ms-traffictypediagnostic: VI1PR0402MB3552:|VI1PR0402MB3552:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <VI1PR0402MB3552CEFBCD7A318E0B76120598E70@VI1PR0402MB3552.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:3173;
x-forefront-prvs: 033054F29A
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(366004)(396003)(346002)(376002)(136003)(39860400002)(199004)(189003)(52536014)(5660300002)(2906002)(71200400001)(66946007)(91956017)(76116006)(66476007)(64756008)(66446008)(316002)(7696005)(66556008)(6506007)(33656002)(86362001)(54906003)(44832011)(478600001)(8936002)(26005)(186003)(9686003)(55016002)(8676002)(81166006)(4326008)(81156014)(53546011)(110136005);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR0402MB3552;H:VI1PR0402MB3485.eurprd04.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: nxp.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: S55ul4zv80yDSkwHmggKjBbriz8wSUw4SjcjTmBz68pTJ+LVCkp7KyGTE91IWUEtE+bz1N81bk3WbGSB+Nf6Vv3nR67u8ny5Jxhqxw826bzsZktTIia8K1jsEO/0OyJzJCPGIUAHbCiunNtMCoItKb7rXLOUHuZ0z0FZw0Gnkc4XFW02a2eUPlVrG7FCKevfJ8AY7XcFrMFGFfuydG4PavqnGbO/dGrFBY50/V+nC6yTcSYEiMrI6ZcdEPwUkGFzdIwPRMlXfZJ0e/NbkziYgicrf8fFQqbmxzNI1gXy3RfbQvvzLOXVItfd3m5lRw0fk2nXsCRxAVCZ/Yt4Xtc7t+DbBomXq2FXqT3hM1ctr6K4TFfXgjLmJZv4DhunqeXbxGeRQV7oJe9PoFvLPIiLDMQIENgWN3ipadui+eBp/Ekfa+9f9s1rlU9dWAh0WmQf
x-ms-exchange-antispam-messagedata: b1gwwWdTlZ8bg0ArvcjwWU5oMshxsd7S4ISivJbECXX9L18NQcf6EzNvBxNXKBtQfOcP20cuh7OCYlhWxNhpxexChyd3Ey+pXU4YwslVzh/mt5utiX+43aRBVnntVDy4KaxqLDQ4+nfCqCRYXXQdLQ==
Content-Type: text/plain; charset="iso-8859-2"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 08c672b6-2a6c-40ec-4b0e-08d7be8d3158
X-MS-Exchange-CrossTenant-originalarrivaltime: 02 Mar 2020 09:36:32.2781
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: xRsThamCcsSl5TzGVxYY/M5O4+kbVgEhDN1kZrHVwAey91IpEapYnxKBI5Xt6d/vGSCCtXHO4K5f34qmLPv5Zg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0402MB3552
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

+ dm-devel=0A=
=0A=
On 2/28/2020 12:47 PM, Andrei Botila (OSS) wrote:=0A=
> From: Andrei Botila <andrei.botila@nxp.com>=0A=
> =0A=
> Since in the software implementation of XTS-AES there is=0A=
> no notion of sector every input length is processed the same way.=0A=
> CAAM implementation has the notion of sector which causes different=0A=
> results between the software implementation and the one in CAAM=0A=
> for input lengths bigger than 512 bytes.=0A=
> Increase sector size to maximum value on 16 bits.=0A=
> =0A=
> Fixes: c6415a6016bf ("crypto: caam - add support for acipher xts(aes)")=
=0A=
> Cc: <stable@vger.kernel.org> # v4.12+=0A=
> Signed-off-by: Andrei Botila <andrei.botila@nxp.com>=0A=
Reviewed-by: Horia Geant=E3 <horia.geanta@nxp.com>=0A=
=0A=
Thanks,=0A=
Horia=0A=
=0A=
> ---=0A=
> This patch needs to be applied from v4.12+ because dm-crypt has added sup=
port=0A=
> for 4K sector size at that version. The commit was=0A=
> 8f0009a225171 ("dm-crypt: optionally support larger encryption sector siz=
e").=0A=
> =0A=
>  drivers/crypto/caam/caamalg_desc.c | 16 ++++++++++++++--=0A=
>  1 file changed, 14 insertions(+), 2 deletions(-)=0A=
> =0A=
> diff --git a/drivers/crypto/caam/caamalg_desc.c b/drivers/crypto/caam/caa=
malg_desc.c=0A=
> index aa9ccca67045..8ebbbd28b1f7 100644=0A=
> --- a/drivers/crypto/caam/caamalg_desc.c=0A=
> +++ b/drivers/crypto/caam/caamalg_desc.c=0A=
> @@ -1518,7 +1518,13 @@ EXPORT_SYMBOL(cnstr_shdsc_skcipher_decap);=0A=
>   */=0A=
>  void cnstr_shdsc_xts_skcipher_encap(u32 * const desc, struct alginfo *cd=
ata)=0A=
>  {=0A=
> -	__be64 sector_size =3D cpu_to_be64(512);=0A=
> +	/*=0A=
> +	 * Set sector size to a big value, practically disabling=0A=
> +	 * sector size segmentation in xts implementation. We cannot=0A=
> +	 * take full advantage of this HW feature with existing=0A=
> +	 * crypto API / dm-crypt SW architecture.=0A=
> +	 */=0A=
> +	__be64 sector_size =3D cpu_to_be64(BIT(15));=0A=
>  	u32 *key_jump_cmd;=0A=
>  =0A=
>  	init_sh_desc(desc, HDR_SHARE_SERIAL | HDR_SAVECTX);=0A=
> @@ -1571,7 +1577,13 @@ EXPORT_SYMBOL(cnstr_shdsc_xts_skcipher_encap);=0A=
>   */=0A=
>  void cnstr_shdsc_xts_skcipher_decap(u32 * const desc, struct alginfo *cd=
ata)=0A=
>  {=0A=
> -	__be64 sector_size =3D cpu_to_be64(512);=0A=
> +	/*=0A=
> +	 * Set sector size to a big value, practically disabling=0A=
> +	 * sector size segmentation in xts implementation. We cannot=0A=
> +	 * take full advantage of this HW feature with existing=0A=
> +	 * crypto API / dm-crypt SW architecture.=0A=
> +	 */=0A=
> +	__be64 sector_size =3D cpu_to_be64(BIT(15));=0A=
>  	u32 *key_jump_cmd;=0A=
>  =0A=
>  	init_sh_desc(desc, HDR_SHARE_SERIAL | HDR_SAVECTX);=0A=
> =0A=
=0A=
