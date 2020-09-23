Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D6E5F275319
	for <lists+stable@lfdr.de>; Wed, 23 Sep 2020 10:20:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726196AbgIWIUM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 23 Sep 2020 04:20:12 -0400
Received: from esa3.microchip.iphmx.com ([68.232.153.233]:33772 "EHLO
        esa3.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726178AbgIWIUM (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 23 Sep 2020 04:20:12 -0400
X-Greylist: delayed 427 seconds by postgrey-1.27 at vger.kernel.org; Wed, 23 Sep 2020 04:20:12 EDT
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1600849212; x=1632385212;
  h=from:to:subject:date:message-id:references:in-reply-to:
   content-id:content-transfer-encoding:mime-version;
  bh=sVXDLEVpB1fwDYZd2wzNZ6+ESokMEqDvMqO0aXurJHI=;
  b=nEiRiYELUqpLjXH96au+1xoKtlOV6iyEk48wxXiBfwk4fnSDpS+HLmJd
   KIsPzcBySBEbuZKQehXS8iSl8Pz9dbAns35JW66qWuUR+Xx6hhLTu4I6b
   xdz3Q4b30NBMewU+9s8gPLDqGjkAE0LiCXUX61wH9nKNWOAoTbrwDMGhm
   cenzCl693yNoOPGExCau4yiwvjCbBvonqNM5OHKnQr6EyJO9VSgpF5m1D
   DD4ZM7HSjKLXQp9PcaR68ZL5s7+cSqhV8ANRVZmGMK/+fZie3WJXBiRu1
   Vv1s9EoS0nD4eGunTggNzgSWRYpekiqAfYKu/4WjsLmW2U6ln9JUWPscM
   g==;
IronPort-SDR: C9G9KPBY2HYmGUtIi8EnwQPjAYaiej8zwQlQRTIpOoLxGH94VjF5VF6j6WNwMHiVDvCgEHysje
 pAWalQSpuRi1TAhCXXlLaAwqxDggoh9vlWl+EKribQ/FyYmgN7QqVRNGrC+f0Ez7Mg1Xv8EvVH
 Z7JGA6n2MzBDeHZhErq3OgA9tqe3Lh4XVh57xmv4Bi+x+M9Uafw2VpFSdP6AR1lOv+uZTnc8km
 hD388pvFUyarBvgSq4FkN0o6GQO7ejF/8/rwdQkdHHECZanoEKyRDw+khcA5wOQJx1El8W/+Vp
 a90=
X-IronPort-AV: E=Sophos;i="5.77,293,1596524400"; 
   d="scan'208";a="92880649"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa3.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 23 Sep 2020 01:13:04 -0700
Received: from chn-vm-ex04.mchp-main.com (10.10.85.152) by
 chn-vm-ex04.mchp-main.com (10.10.85.152) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Wed, 23 Sep 2020 01:13:03 -0700
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (10.10.215.89) by
 email.microchip.com (10.10.87.151) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.1979.3
 via Frontend Transport; Wed, 23 Sep 2020 01:13:03 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ZwgYywzvDOWfYCWkcC1Su0uhhork6wGEsgMtvU/Apjr2p24hcj2k++85mj6rwk+NWH02i4H4S26wwsgLenEWbumXaepoDtBNdNUtesZtDi93We5b6R87Iu4iuti5k8MTw97NVAsQ5D65B4EdtZSArgVyWmcN1W8Gufs1oc6H9QlTG2OZRYdYNs/DDOkY5fNG40D7IL7BJusENt3MlX+MDIZRKWEAxT2MdwvrjEQLNuNYjPOmLTb5rGSwCXCjvvUtja4q82/J8uHW/HwqoLePrllL9KqdxORyZiZZku65IdadzBOf/6+5CyI5TuGOreOCh4WR7RAycqzPTdOkrjnviQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=pZVJShvd/LW5PvOizOKc82ocA5aIXIGxBmbDGUAzZS4=;
 b=WstruwWfQ29H854dSPrCkAv1CdUAF+o+lKM6O6mbRSlDzEq5lk6bd7MvP+ttGYW2ng4XK7ITSDb8vhi3vI9o4VE4oj7UcoCP9RrTiUKkWL9H8tHv4eOnwRT/YfUVWQZ7F9y0gOdhP3Ml/IWTjj+huAo38iJ3jlGpyEWLglN7gHgP55cvUWFmMO+PAWQo6DEeA1EbPJpApFUokr/wT/uY9DY1CejGJZUmRIYD/a5TkPy5EaO7xlrQVroNQkA49Z7/ngMJe9cwVZiIqLFbkQ3hM8bx6wPZBfD2juzC5RWyLZrbwtb6s6k2T2PD2O5YuNhC/A68CgT6EkpsIA4ZywhzLA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microchip.com; dmarc=pass action=none
 header.from=microchip.com; dkim=pass header.d=microchip.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=microchiptechnology.onmicrosoft.com;
 s=selector2-microchiptechnology-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=pZVJShvd/LW5PvOizOKc82ocA5aIXIGxBmbDGUAzZS4=;
 b=vbvR2lk87GFoiuJoTMeK4kcnTOW3uJNjym3uhI3XRia6C6hA0JXWMDhZwYw7R1qLpzFYR6rcY6L8+tDDRjjc5R2qW3b+Io80et7Z9Q4r9Hlqw75f1WJnijIygvIKIm0UhZB90A0dZdo3L3nJIexpJD+BXiiKSwQVCzi0yTN9ENg=
Received: from DM5PR11MB1914.namprd11.prod.outlook.com (2603:10b6:3:112::12)
 by DM6PR11MB3242.namprd11.prod.outlook.com (2603:10b6:5:5b::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3391.11; Wed, 23 Sep
 2020 08:13:03 +0000
Received: from DM5PR11MB1914.namprd11.prod.outlook.com
 ([fe80::a8e8:d0bc:8b3c:d385]) by DM5PR11MB1914.namprd11.prod.outlook.com
 ([fe80::a8e8:d0bc:8b3c:d385%11]) with mapi id 15.20.3391.027; Wed, 23 Sep
 2020 08:13:03 +0000
From:   <Tudor.Ambarus@microchip.com>
To:     <pavel@ucw.cz>, <linux-kernel@vger.kernel.org>,
        <dmaengine@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, <dan.j.williams@intel.com>,
        <vkoul@kernel.org>, <Ludovic.Desroches@microchip.com>,
        <stable@vger.kernel.org>, <greg@kroah.com>
Subject: Re: [PATCH 4.19] dmaengine: at_hdmac: Fix memory leak
Thread-Topic: [PATCH 4.19] dmaengine: at_hdmac: Fix memory leak
Thread-Index: AQHWkYFbVNgbQZmRd0SqW2sKLrUKIA==
Date:   Wed, 23 Sep 2020 08:13:02 +0000
Message-ID: <80065eac-7dce-aadf-51ef-9a290973b9ec@microchip.com>
References: <20200920082838.GA813@amd>
In-Reply-To: <20200920082838.GA813@amd>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
authentication-results: ucw.cz; dkim=none (message not signed)
 header.d=none;ucw.cz; dmarc=none action=none header.from=microchip.com;
x-originating-ip: [82.77.80.152]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: d9e13577-4bdc-4803-34b4-08d85f987e3a
x-ms-traffictypediagnostic: DM6PR11MB3242:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <DM6PR11MB3242943DC43581B38F2E7874F0380@DM6PR11MB3242.namprd11.prod.outlook.com>
x-bypassexternaltag: True
x-ms-oob-tlc-oobclassifiers: OLM:820;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 7wv1WDeMAqsJe/SyatOjsSKOZPfKuhy9zeVq6VsZ2B+q2NcNir7H//1rLeR6UB0VBiLQOjIkyhdPvN52hzzoGqn+GPQZi/7z3F+bgboU2gGTmLbeQEqjreotj9F7Dw7uu1KVIWoZmfzOcV/HSSbtaMCOy2XSNxXnlgIT1eRQRiy5BXOBypBaU20OlYEFFrlvBXqXO5kvFfS/QvdfYPXMdeu0AjaJcjqkitFTTgyKN2cYmTZNcG+ZJtZ8vr17CSRL7u4d6fKfuH6CoZvuPppagHCY38WPnUc8AKiUaQwsSeocFrHUTChbvCaPL1Kjhl0rSck2Oi+dNtxE33UQOcTMyes13xSA3RQj5JrSwvljRY743CJ6IqOq2uNvxUfZemJPvdkBU9S6VoJmNFQ1gURZaAMa6CIE+WnWMny3dps6KFwaiGU3UpKpHDqDhbJ8mTrNHre6H7WdFTK1iNpjyjdk0f6S1bva4jcw/PJPij/P9+XOgoMgDBm+p1qR/3Y32ugR
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR11MB1914.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(376002)(346002)(366004)(396003)(136003)(39860400002)(316002)(76116006)(91956017)(83380400001)(6486002)(6506007)(53546011)(31696002)(966005)(66556008)(66476007)(66446008)(66946007)(64756008)(26005)(2616005)(5660300002)(31686004)(186003)(6512007)(478600001)(71200400001)(8936002)(110136005)(2906002)(8676002)(36756003)(86362001)(43740500002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: tdxFg87R95gH1/HqtyfXP8YDFYkESTfcds6JTyD4z2pkwOZEFW6UhaJohzaVVwIV9bzP7lx3sVlVjR4rdYt7/m8yP/AJkx2nhk0+km3BPqjvQvE2It0Zri5EiRzlw/+GxlDB5Wt7JcoHO49HEkMbm59Pxx6gYlnwIHEQ/vD9vgZIJU4C9lOi77c4jQaVCzLeu18AmLDIkl4bq969YibOahlksrdeuPI2DzoWdEt8402oxwNk8t6kAtg4ZGh9UWV5850A9bIEQzVfE245pss+M+c7QGJfajuelxtulR6Ty/hW7TYBJTWzR0O/B89/zFB19wt69Xbl9v3kEN36Z1AZFTgiOpgIP7pTB5BEVlajuAO8cCm93H8EIOSAcENJpX3p0DKHuzvTG/EPGNcSFwnXNbmovf4kUMHPCkffwxsY7WqFos5zwqUqL+ZF1h3uXEMgJOKRUfznz0/MoNlJ8EJUbtOcEyNuhwh5XQn7tNpoj2OPTbvMdFgeQuu4NiJmy9YtnFgcjXZipalH7b/ACQnsIiFpQgyXvALnpeRAibcs5m4N+7tl9TRlsowUVpLmTPQfSn1KNCPaq+Yc4pvygqb5SBP96FhjYjkhtKx47T3UCMqDX1Ik2aYJDOfCYQLROyQJoG+eOxtfKVV7ejusvSH+WA==
Content-Type: text/plain; charset="Windows-1252"
Content-ID: <0DC78A65EEAEBC4E8B0614F2BCDB86D4@namprd11.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM5PR11MB1914.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d9e13577-4bdc-4803-34b4-08d85f987e3a
X-MS-Exchange-CrossTenant-originalarrivaltime: 23 Sep 2020 08:13:02.9277
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3f4057f3-b418-4d4e-ba84-d55b4e897d88
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: unBXlU6x47XOt6iZhqREBJ2UAlX7NlELDYm06PGZHKWxmUjAkCbG5PBbyda+hrA//Le1qxO689h1TZqjT2P6ma97HpBU6HNBAGPh7oPMZ+8=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR11MB3242
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi, Pavel,

On 9/20/20 11:28 AM, Pavel Machek wrote:
> EXTERNAL EMAIL: Do not click links or open attachments unless you know th=
e content is safe
>=20
> This fixes memory leak in at_hdmac. Mainline does not have the same
> problem.
>=20
> Signed-off-by: Pavel Machek (CIP) <pavel@denx.de>
>=20
> diff --git a/drivers/dma/at_hdmac.c b/drivers/dma/at_hdmac.c
> index 86427f6ba78c..0847b2055857 100644
> --- a/drivers/dma/at_hdmac.c
> +++ b/drivers/dma/at_hdmac.c
> @@ -1714,8 +1714,10 @@ static struct dma_chan *at_dma_xlate(struct of_pha=
ndle_args *dma_spec,
>         atslave->dma_dev =3D &dmac_pdev->dev;
>=20
>         chan =3D dma_request_channel(mask, at_dma_filter, atslave);
> -       if (!chan)
> +       if (!chan) {
> +               kfree(atslave);
>                 return NULL;
> +       }

Thanks for submitting this to stable. While the fix is good, you can instea=
d
cherry-pick the commit that hit upstream. In order to do that cleanly on to=
p
of v4.19.145, you have to pick two other fixes:

commit a6e7f19c9100 ("dmaengine: at_hdmac: Substitute kzalloc with kmalloc"=
)
commit 3832b78b3ec2 ("dmaengine: at_hdmac: add missing put_device() call in=
 at_dma_xlate()")
commit a6e7f19c9100 ("dmaengine: at_hdmac: Substitute kzalloc with kmalloc"=
)

There are also some locking/deadlock fixes in mainline for this driver,
depending on the time you can allocate for this, the list of patches can in=
crease.
I should have Cc'ed stable@vger.kernel.org in the first place, my bad.

Also it may worth to read the rules for submitting to stable at:
https://www.kernel.org/doc/html/latest/process/stable-kernel-rules.html

Cheers,
ta
