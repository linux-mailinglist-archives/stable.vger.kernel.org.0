Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B8FE01B9761
	for <lists+stable@lfdr.de>; Mon, 27 Apr 2020 08:25:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726349AbgD0GZu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 27 Apr 2020 02:25:50 -0400
Received: from esa2.hgst.iphmx.com ([68.232.143.124]:44663 "EHLO
        esa2.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726237AbgD0GZu (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 27 Apr 2020 02:25:50 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1587968755; x=1619504755;
  h=from:to:cc:subject:date:message-id:references:
   content-transfer-encoding:mime-version;
  bh=IQy9STKSFCWc4c/kAgo3cJBYwYrWPmel1JKTAYYVHJM=;
  b=cgoC2A1+SdVD09pYdopnJrXpt+Y9T1MK+X/hJ6ZOIptVXZhETG6cOlJL
   CZgt+5EShyOuMzdbhmO1lnEDjQpKMgfwXUj5iuGiDVdtlBStmp6QeRUa2
   fyetY5+R6jbYKTesKEEltaageG847zZoZLowgiquKyU97gU2wgfp0Q4U5
   BvuRf5zlR2d3mErU6sb54rO7sp2FzqflPWnU2Y2tYCKvyNt2b5JokX4lO
   pEidQcbyJySnycyrgxP5uTSqyyMYFL8uaGA1FzVR9uZkl6GKsQixg3A0I
   K65g9ivqz5K9DTsinWPlbHGhAgkqm9pGLesof/LSTuNHGkGjeHFKrGDUx
   w==;
IronPort-SDR: 7YccEmltGHQJxsSO2kjddjfoRCJ4mmLDtx82VH/wh8RjWSqk3RNz0mJfJ1Bkn0zHchhs5DEOle
 5YIGviybESuvcFqUxogCv6seQLk2WtLBFiduNeewQqALgmKom2ZCFiKqtchwMvv3eFt9MZdSTq
 Y6EL3bQNoV30lqx29x6x+S54gllWyW2A2kRiaNdVF8ESaxBhI6PEunjARqhY4gAUXFTVOsD3Sn
 caXiOQKnONF4WRnwsWgQjj6rFxshaFyMZxdHBYggvuFJiCWYlqwv5NK3qRCUmGT1rKXDoOXU+9
 DjE=
X-IronPort-AV: E=Sophos;i="5.73,323,1583164800"; 
   d="scan'208";a="238757947"
Received: from mail-dm6nam10lp2103.outbound.protection.outlook.com (HELO NAM10-DM6-obe.outbound.protection.outlook.com) ([104.47.58.103])
  by ob1.hgst.iphmx.com with ESMTP; 27 Apr 2020 14:25:54 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=PbYTfuhjVsyCIx082Me4R+PypbQL8rNp/FN4NKQ2wpKVE3z9hp7Fjoz+5J+13fhmQ1PV+AAEvIkj3CbKopOxaeTMcwyt+ZDBA97sKSp+EoNyB8DpDyBiSd4xxZAvli2G9KT3ZGjRS/FKNqbUJh/BoSW+2uMZaE2nmfX94mAcvPIPwVQ/p74kIVP3YN5Al3ldd9hkkQPGzaRk8uG/SSI2aDrvNnANGtT/4JlsmqEG9pfxfNpXeqd6aawZQPKYW6dSLhBOzBD4sQqLtezmDVpPxiFvmuRfOljF0wEs2uPxuxp6juvtmOvVN4SxriOoUvGL2u38CAc+k8c3ptNU/tBFzg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=TraG0fZJAxt744nlUniiDpKMG3yLedRZSbm8yAbLGtU=;
 b=KWFS4JnrnUTyKU5xV4dQojRBkXLhrCk0oz910ytPgH9waiqAZG0E9fc3yyX+NgMtvysWQ8gGoEDneL87pBAtOXY5k0kn97cJzKrt8n2AyFReN1+QExqYV7E9Jw0SbJkW0BqRfU/OKIU75qyo7Xl/wcwnpjL+OdjfoIoNPqVOrMddxyoEx+PywAMQMRojx11vU0KUgdGtgGM1kVtnMV86luv7k4V4XpL3S69GSO+DRBhDuWijg/ntLIad6RFKJd9coHL9iGfC1rWdZuCkThcXMLvagTp5wsjo35ZtqBz2yAaw4r6ySsYwjVsMVjtQW+yZHEqce5XuVb22YQWBMXLmuA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=TraG0fZJAxt744nlUniiDpKMG3yLedRZSbm8yAbLGtU=;
 b=CpG0QJq9FtC9tNayKfEJPvKkh2IgeCEEpqaw1Igd+nrFKqTINkMNnrij8ykYaqCLgtWg5wVDcOo4EmVOLOFwCbSjqQMS3kE1tiiGj94GHLXk5yk2zTwkeCHQ2jZOHcPDR2Rzp1oFPex4OrQhIUhAu877i93DLLrDBAC11CfX0TE=
Received: from BY5PR04MB6900.namprd04.prod.outlook.com (2603:10b6:a03:229::20)
 by BY5PR04MB6817.namprd04.prod.outlook.com (2603:10b6:a03:221::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2937.13; Mon, 27 Apr
 2020 06:25:47 +0000
Received: from BY5PR04MB6900.namprd04.prod.outlook.com
 ([fe80::b574:3071:da2f:7606]) by BY5PR04MB6900.namprd04.prod.outlook.com
 ([fe80::b574:3071:da2f:7606%8]) with mapi id 15.20.2937.023; Mon, 27 Apr 2020
 06:25:47 +0000
From:   Damien Le Moal <Damien.LeMoal@wdc.com>
To:     Vincent Chen <vincent.chen@sifive.com>,
        "paul.walmsley@sifive.com" <paul.walmsley@sifive.com>,
        "palmer@dabbelt.com" <palmer@dabbelt.com>
CC:     "linux-riscv@lists.infradead.org" <linux-riscv@lists.infradead.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: Re: [PATCH v2] riscv: set max_pfn to the PFN of the last page
Thread-Topic: [PATCH v2] riscv: set max_pfn to the PFN of the last page
Thread-Index: AQHWHFvRQfG9/MaXWEOk4NMFgZgCng==
Date:   Mon, 27 Apr 2020 06:25:47 +0000
Message-ID: <BY5PR04MB6900AFB4A434424E65784D21E7AF0@BY5PR04MB6900.namprd04.prod.outlook.com>
References: <1587968351-9507-1-git-send-email-vincent.chen@sifive.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=Damien.LeMoal@wdc.com; 
x-originating-ip: [199.255.47.8]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 0cae61e4-8068-49b8-2270-08d7ea73d2c7
x-ms-traffictypediagnostic: BY5PR04MB6817:
x-microsoft-antispam-prvs: <BY5PR04MB6817793DE7D1E1EB446643A5E7AF0@BY5PR04MB6817.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:6790;
x-forefront-prvs: 0386B406AA
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR04MB6900.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(39860400002)(136003)(396003)(366004)(376002)(346002)(2906002)(91956017)(66556008)(54906003)(66946007)(66476007)(66446008)(8676002)(6506007)(26005)(81156014)(7696005)(76116006)(71200400001)(8936002)(316002)(64756008)(53546011)(110136005)(186003)(52536014)(478600001)(33656002)(9686003)(4326008)(5660300002)(86362001)(55016002);DIR:OUT;SFP:1102;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: kQTwPnvnxQZgUJmGsvFGGb8fnpGuaZWEQJ2s3YDef+TQLvK9W7ZYMyL+9deeJDnLDvLQWPhm7thxhQxw1LYqv8qQCEBSwrbZDGPS7WzwRhhCMO9zzUU8j5y1aMfw17WRHvbSjk+YdDpVAZJnOj1vxa6Z+XeS0mR8DaFSI3q4Urzyktehr63avxF0rc6Xiv+jhP0NJpvK1966dOpMCblFjzHqfnKjWgmBAzrINBCH8QE7zUxN2PgO7EQPiVUTABZYX1b/8QDLnV7rKFfnwOCVOAAi8qFG+NO56kztx7kSVOMRLJLp57rtNWVd9wGrc8bdU/s+zFvMlplxSQAar9OhdqWVL1m3cdRvis/jpbMzEP4ob7ho3LTlkLysY1K8l8kXp4mMZd8Ph5oC/RUraBeLHlVq1d/TepemLPMVDlB47SjiQVbZa5O9S9rQbJOBMQOq
x-ms-exchange-antispam-messagedata: QqGd3dWR62g/y8EjiW9gU9G/GyL0KGh4oRfC72m+S85BO4dVKLls8sVFbzGzJqhhWiDVt8wVE3U9KNH16bjGyia0EtXycJWnYXST4/h3/5+ZXIysHPo8ysm8bhWFzrF5/JHvp9d1LpPxZ+E7gUtsJUnxt6zE94FWeF4Wd05HoYNaBjgCR2OWbrQQ/mPE6F9SPDuQHllEkC4Vpu9Uxh8F8PeovumLLOj5LGKXeTCXRLu0Creh4peG6mmVW73kqQkiLwWAh7mSGPksnbfvb5OShluokBLBJyLTyBZngphZysvqnRni5oa/xV7yPGmFV1g1meoOisb2RzzUnsqoYyKXaBxrVN5sUd4IBwjYC0OXywdoQe20kdOJWZG3u+XyKyOlRcXw2DuZocGvUhGiwM1WWsHEPzqBNNf2YQ0/3pQSG+lgROeEK9ClMUYKcw0GhGzCDyEND0WuaWQwziscHFPKBk/+DrYVpFRJh9SwNtiqAypBsAWoHdHyFt0RIA7lFkCA7MMuIWBD//sX1syYMIy3ng2iCtQpj/+UYhWRJuBnPsG7Oe5Hj6DuMqdWQMMOE56Ket6jg0089AWVQynjc8i1uxO9tXuK0K6vG6Ob63APC/5FNSDqZ5Gl/t0+/LqEcON62QrQ+qhfVpLxdY1g3SYp7uf8qMDyenmO2XEfp8osQxkxPDPZdFFYygWB1cI/GoQ8CCF0eD19aakiU2b/wTKNSFpJUu9KXJqY4WnWPDYQ62qswLSBt2ecQEzajOqNfz385ax6w4sOVzyDP5dbG9ifVlfhSfDXp+qU2SuCvB7jrvY=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0cae61e4-8068-49b8-2270-08d7ea73d2c7
X-MS-Exchange-CrossTenant-originalarrivaltime: 27 Apr 2020 06:25:47.3404
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: /MBZvC2UZNeq4aQoB9pGhvz31bvkkfdU9MmGsq0U+wML/d9gEpg3aM79xmwc4nZW+1qd+jbCfbVvGOlwaX+yFg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR04MB6817
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 2020/04/27 15:19, Vincent Chen wrote:=0A=
> The current max_pfn equals to zero. In this case, I found it caused users=
=0A=
> cannot get some page information through /proc such as kpagecount in v5.6=
=0A=
> kernel because of new sanity checks. The following message is displayed b=
y=0A=
> stress-ng test suite with the command "stress-ng --verbose --physpage 1 -=
t=0A=
> 1" on HiFive unleashed board.=0A=
> =0A=
>  # stress-ng --verbose --physpage 1 -t 1=0A=
>  stress-ng: debug: [109] 4 processors online, 4 processors configured=0A=
>  stress-ng: info: [109] dispatching hogs: 1 physpage=0A=
>  stress-ng: debug: [109] cache allocate: reducing cache level from L3 (to=
o high) to L0=0A=
>  stress-ng: debug: [109] get_cpu_cache: invalid cache_level: 0=0A=
>  stress-ng: info: [109] cache allocate: using built-in defaults as no sui=
table cache found=0A=
>  stress-ng: debug: [109] cache allocate: default cache size: 2048K=0A=
>  stress-ng: debug: [109] starting stressors=0A=
>  stress-ng: debug: [109] 1 stressor spawned=0A=
>  stress-ng: debug: [110] stress-ng-physpage: started [110] (instance 0)=
=0A=
>  stress-ng: error: [110] stress-ng-physpage: cannot read page count for a=
ddress 0x3fd34de000 in /proc/kpagecount, errno=3D0 (Success)=0A=
>  stress-ng: error: [110] stress-ng-physpage: cannot read page count for a=
ddress 0x3fd32db078 in /proc/kpagecount, errno=3D0 (Success)=0A=
>  ...=0A=
>  stress-ng: error: [110] stress-ng-physpage: cannot read page count for a=
ddress 0x3fd32db078 in /proc/kpagecount, errno=3D0 (Success)=0A=
>  stress-ng: debug: [110] stress-ng-physpage: exited [110] (instance 0)=0A=
>  stress-ng: debug: [109] process [110] terminated=0A=
>  stress-ng: info: [109] successful run completed in 1.00s=0A=
>  #=0A=
> =0A=
> After applying this patch, the kernel can pass the test.=0A=
> =0A=
>  # stress-ng --verbose --physpage 1 -t 1=0A=
>  stress-ng: debug: [104] 4 processors online, 4 processors configured str=
ess-ng: info: [104] dispatching hogs: 1 physpage=0A=
>  stress-ng: info: [104] cache allocate: using defaults, can't determine c=
ache details from sysfs=0A=
>  stress-ng: debug: [104] cache allocate: default cache size: 2048K=0A=
>  stress-ng: debug: [104] starting stressors=0A=
>  stress-ng: debug: [104] 1 stressor spawned=0A=
>  stress-ng: debug: [105] stress-ng-physpage: started [105] (instance 0) s=
tress-ng: debug: [105] stress-ng-physpage: exited [105] (instance 0) stress=
-ng: debug: [104] process [105] terminated=0A=
>  stress-ng: info: [104] successful run completed in 1.01s=0A=
>  #=0A=
> =0A=
> Fixes: 0651c263c8e3 (RISC-V: Move setup_bootmem() to mm/init.c)=0A=
> Cc: stable@vger.kernel.org=0A=
> =0A=
> Signed-off-by: Vincent Chen <vincent.chen@sifive.com>=0A=
> Reviewed-by: Anup Patel <anup@brainfault.ort>=0A=
=0A=
email typo not fixed...=0A=
=0A=
As Anup mentioned, it should be: anup@brainfault.org (".org", not ".ort").=
=0A=
=0A=
=0A=
> Reviewed-by: Yash Shah <yash.shah@sifive.com>=0A=
> Tested-by: Yash Shah <yash.shah@sifive.com>=0A=
> =0A=
> Changes since v1:=0A=
> 1. Add Fixes line and Cc stable kernel=0A=
> ---=0A=
>  arch/riscv/mm/init.c | 3 ++-=0A=
>  1 file changed, 2 insertions(+), 1 deletion(-)=0A=
> =0A=
> diff --git a/arch/riscv/mm/init.c b/arch/riscv/mm/init.c=0A=
> index fab855963c73..157924baa191 100644=0A=
> --- a/arch/riscv/mm/init.c=0A=
> +++ b/arch/riscv/mm/init.c=0A=
> @@ -149,7 +149,8 @@ void __init setup_bootmem(void)=0A=
>  	memblock_reserve(vmlinux_start, vmlinux_end - vmlinux_start);=0A=
>  =0A=
>  	set_max_mapnr(PFN_DOWN(mem_size));=0A=
> -	max_low_pfn =3D PFN_DOWN(memblock_end_of_DRAM());=0A=
> +	max_pfn =3D PFN_DOWN(memblock_end_of_DRAM());=0A=
> +	max_low_pfn =3D max_pfn;=0A=
>  =0A=
>  #ifdef CONFIG_BLK_DEV_INITRD=0A=
>  	setup_initrd();=0A=
> =0A=
=0A=
=0A=
-- =0A=
Damien Le Moal=0A=
Western Digital Research=0A=
