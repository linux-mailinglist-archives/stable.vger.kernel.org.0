Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B8F7871BBA
	for <lists+stable@lfdr.de>; Tue, 23 Jul 2019 17:34:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387644AbfGWPet (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Jul 2019 11:34:49 -0400
Received: from mail-eopbgr680074.outbound.protection.outlook.com ([40.107.68.74]:28236
        "EHLO NAM04-BN3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2387636AbfGWPet (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 23 Jul 2019 11:34:49 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=aMRR0lpFzSeoAWxclnmybS+chqUYH6OKyw57flm9EyDe8ybQkNU01zLDWxzhHyR76CmLAwrM54nKFyt8hash+Lsc+OVNg1h1w6G4q4/jY+2IoWy4qlgmUP3oK1eP049WLHh6fPdIW2q6DIOfYQoVRtb+d8Yc5cY8p080hdRSi7TnmfYy/FclDFr+BY86kSp3PrXWng+R86cf7yIp0HFx3gYjngmsZ5C4Y5jMAMRCP9nYSQ0EW6ski6HeFGAReY5jFtlaTFTK5GWnmu1rR2xBlJD2sAgMN5TbUWbbyLqG7zyQfn4mqGq+gLekcXym1s/Y0VxaOxdLWV35l6SRrYcaGA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=0VKeNLBCY2V0Y05NvU798o7cQop6FjhNf0LvfjiKehA=;
 b=gUIYPQuTpwkR1Je7xfMU6dieX/bihWoKPZTfobo2opZFdmiya3drkFTO0iaF9dA9WnaOBhLbFKQyhhSjgK6NEBSwLNQexmtWVew4JQ0hh0h0r+FIhR6oqTaMBbI3K6YIwZRWAmM08WaNdR4aaZoJZcp6vKfDmLNHh//mDJ7zgKNk+AqlUDrHr90iGayqdB2vNE1FfCZEdNJWC+DbPiWtJP6uB8vweXemMbsFh9zkD0xKPFakF0xKQ6+WiCx+qIrlk2Psk97eY51DfYIUtgutrKk4dciqgt0E6izi4WEbvjLX2aJQgRx3jLgdC3FXLcVQnML6F03q7I5bBwLLF0hSIQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1;spf=pass
 smtp.mailfrom=amd.com;dmarc=pass action=none header.from=amd.com;dkim=pass
 header.d=amd.com;arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector1-amdcloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=0VKeNLBCY2V0Y05NvU798o7cQop6FjhNf0LvfjiKehA=;
 b=g2XdXWM0KfNtYW5mFTKoLHJIumGSwCJK/Iuvpc9AIvWHnZKXQGT2zoAXlWyjPzV8bSYyvyilS/n7Fh2FaSbqlWDl97cS/4X8r0IhssNW8dG8+2fgbUs6Dqer8K1wxW1sJkY9ivL3FFCGNfiP+RA6wsaVBd6TJCrurACI4zQ6pgc=
Received: from DM5PR12MB1449.namprd12.prod.outlook.com (10.172.40.14) by
 DM5PR12MB1132.namprd12.prod.outlook.com (10.168.239.145) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2094.16; Tue, 23 Jul 2019 15:34:45 +0000
Received: from DM5PR12MB1449.namprd12.prod.outlook.com
 ([fe80::3874:39a2:49ea:433a]) by DM5PR12MB1449.namprd12.prod.outlook.com
 ([fe80::3874:39a2:49ea:433a%5]) with mapi id 15.20.2094.013; Tue, 23 Jul 2019
 15:34:45 +0000
From:   Gary R Hook <ghook@amd.com>
To:     "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "Hook, Gary" <Gary.Hook@amd.com>,
        "cfir@google.com" <cfir@google.com>,
        "herbert@gondor.apana.org.au" <herbert@gondor.apana.org.au>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: Re: FAILED: patch "[PATCH] crypto: ccp - Validate the the error value
 used to index" failed to apply to 4.9-stable tree
Thread-Topic: FAILED: patch "[PATCH] crypto: ccp - Validate the the error
 value used to index" failed to apply to 4.9-stable tree
Thread-Index: AQHVQTORA/n0k5hcIUSvOgMD7DQbz6bYVeWA
Date:   Tue, 23 Jul 2019 15:34:45 +0000
Message-ID: <f16ffdc3-d552-56ad-fb61-6730e1d3ea7a@amd.com>
References: <1563871775163255@kroah.com>
In-Reply-To: <1563871775163255@kroah.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: SN4PR0501CA0076.namprd05.prod.outlook.com
 (2603:10b6:803:22::14) To DM5PR12MB1449.namprd12.prod.outlook.com
 (2603:10b6:4:10::14)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=Gary.Hook@amd.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [165.204.78.1]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 31289a20-1c36-4e87-71d0-08d70f8349e9
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(4618075)(2017052603328)(7193020);SRVR:DM5PR12MB1132;
x-ms-traffictypediagnostic: DM5PR12MB1132:
x-microsoft-antispam-prvs: <DM5PR12MB11325187B90CCA7AABAF09ABFDC70@DM5PR12MB1132.namprd12.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:1360;
x-forefront-prvs: 0107098B6C
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(39860400002)(366004)(136003)(346002)(376002)(396003)(199004)(189003)(2501003)(25786009)(31686004)(478600001)(7736002)(8936002)(305945005)(8676002)(14444005)(68736007)(102836004)(386003)(256004)(6436002)(14454004)(26005)(6506007)(486006)(53546011)(5660300002)(186003)(99286004)(36756003)(2616005)(66446008)(6246003)(6486002)(66556008)(446003)(66946007)(66476007)(229853002)(66066001)(316002)(11346002)(110136005)(476003)(64756008)(6116002)(81156014)(81166006)(71190400001)(71200400001)(2906002)(52116002)(15650500001)(2201001)(53936002)(31696002)(3846002)(6512007)(76176011);DIR:OUT;SFP:1101;SCL:1;SRVR:DM5PR12MB1132;H:DM5PR12MB1449.namprd12.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: amd.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: 37XA9PeMKtCGzRqP4j0UegO4tjdXpb9Uz9JSIchYyhxZ+eAWhPwhCwW45imXEOJYo/hE7xCkKHPk1lvh3AZzRsZ7ron3450BPXeQ292ZwV7q0idoyiiT0+Plgir7Gt5e7B3UNziENsOwCa+eiGAwp5dQLWukeU5NaGh7Xkdku/TwDIN9zruWpIjE5rCnwJ2jtpw8FntxsZUfmgZ/O+8bD4A+/YSC+oCa5FHomXVfFGgP+NOK10O1NxoojcjNO+aASfZnyoR4JyFnObBcVn4a2X3EqEzslV800gExp6+0j+18EPCFU4zQr3668a3r0nipoaZlt7eIfzme/BG9M9KVA8FJh7sCS608KnfqlYQd0a32BhKlA4w8LZaAXq9TpIibZW13SesXp/GYzxuWn60twi++1BHCwmvETHfwxeEkCDc=
Content-Type: text/plain; charset="Windows-1252"
Content-ID: <75133C06A776B74FBF24CA507D67493C@namprd12.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 31289a20-1c36-4e87-71d0-08d70f8349e9
X-MS-Exchange-CrossTenant-originalarrivaltime: 23 Jul 2019 15:34:45.4695
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: ghook@amd.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR12MB1132
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 7/23/19 3:49 AM, gregkh@linuxfoundation.org wrote:
>=20
> The patch below does not apply to the 4.9-stable tree.
> If someone wants it applied there, or to any other stable or longterm
> tree, then please email the backport, including the original git commit
> id to <stable@vger.kernel.org>.

Yeah, we think it should be included. I've submitted the updated patch,=20
per your instructions.


>=20
> thanks,
>=20
> greg k-h
>=20
> ------------------ original commit in Linus's tree ------------------
>=20
>  From 52393d617af7b554f03531e6756facf2ea687d2e Mon Sep 17 00:00:00 2001
> From: "Hook, Gary" <Gary.Hook@amd.com>
> Date: Thu, 27 Jun 2019 16:16:23 +0000
> Subject: [PATCH] crypto: ccp - Validate the the error value used to index
>   error messages
>=20
> The error code read from the queue status register is only 6 bits wide,
> but we need to verify its value is within range before indexing the error
> messages.
>=20
> Fixes: 81422badb3907 ("crypto: ccp - Make syslog errors human-readable")
> Cc: <stable@vger.kernel.org>
> Reported-by: Cfir Cohen <cfir@google.com>
> Signed-off-by: Gary R Hook <gary.hook@amd.com>
> Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
>=20
> diff --git a/drivers/crypto/ccp/ccp-dev.c b/drivers/crypto/ccp/ccp-dev.c
> index 1b5035d56288..9b6d8972a565 100644
> --- a/drivers/crypto/ccp/ccp-dev.c
> +++ b/drivers/crypto/ccp/ccp-dev.c
> @@ -35,56 +35,62 @@ struct ccp_tasklet_data {
>   };
>  =20
>   /* Human-readable error strings */
> +#define CCP_MAX_ERROR_CODE	64
>   static char *ccp_error_codes[] =3D {
>   	"",
> -	"ERR 01: ILLEGAL_ENGINE",
> -	"ERR 02: ILLEGAL_KEY_ID",
> -	"ERR 03: ILLEGAL_FUNCTION_TYPE",
> -	"ERR 04: ILLEGAL_FUNCTION_MODE",
> -	"ERR 05: ILLEGAL_FUNCTION_ENCRYPT",
> -	"ERR 06: ILLEGAL_FUNCTION_SIZE",
> -	"ERR 07: Zlib_MISSING_INIT_EOM",
> -	"ERR 08: ILLEGAL_FUNCTION_RSVD",
> -	"ERR 09: ILLEGAL_BUFFER_LENGTH",
> -	"ERR 10: VLSB_FAULT",
> -	"ERR 11: ILLEGAL_MEM_ADDR",
> -	"ERR 12: ILLEGAL_MEM_SEL",
> -	"ERR 13: ILLEGAL_CONTEXT_ID",
> -	"ERR 14: ILLEGAL_KEY_ADDR",
> -	"ERR 15: 0xF Reserved",
> -	"ERR 16: Zlib_ILLEGAL_MULTI_QUEUE",
> -	"ERR 17: Zlib_ILLEGAL_JOBID_CHANGE",
> -	"ERR 18: CMD_TIMEOUT",
> -	"ERR 19: IDMA0_AXI_SLVERR",
> -	"ERR 20: IDMA0_AXI_DECERR",
> -	"ERR 21: 0x15 Reserved",
> -	"ERR 22: IDMA1_AXI_SLAVE_FAULT",
> -	"ERR 23: IDMA1_AIXI_DECERR",
> -	"ERR 24: 0x18 Reserved",
> -	"ERR 25: ZLIBVHB_AXI_SLVERR",
> -	"ERR 26: ZLIBVHB_AXI_DECERR",
> -	"ERR 27: 0x1B Reserved",
> -	"ERR 27: ZLIB_UNEXPECTED_EOM",
> -	"ERR 27: ZLIB_EXTRA_DATA",
> -	"ERR 30: ZLIB_BTYPE",
> -	"ERR 31: ZLIB_UNDEFINED_SYMBOL",
> -	"ERR 32: ZLIB_UNDEFINED_DISTANCE_S",
> -	"ERR 33: ZLIB_CODE_LENGTH_SYMBOL",
> -	"ERR 34: ZLIB _VHB_ILLEGAL_FETCH",
> -	"ERR 35: ZLIB_UNCOMPRESSED_LEN",
> -	"ERR 36: ZLIB_LIMIT_REACHED",
> -	"ERR 37: ZLIB_CHECKSUM_MISMATCH0",
> -	"ERR 38: ODMA0_AXI_SLVERR",
> -	"ERR 39: ODMA0_AXI_DECERR",
> -	"ERR 40: 0x28 Reserved",
> -	"ERR 41: ODMA1_AXI_SLVERR",
> -	"ERR 42: ODMA1_AXI_DECERR",
> -	"ERR 43: LSB_PARITY_ERR",
> +	"ILLEGAL_ENGINE",
> +	"ILLEGAL_KEY_ID",
> +	"ILLEGAL_FUNCTION_TYPE",
> +	"ILLEGAL_FUNCTION_MODE",
> +	"ILLEGAL_FUNCTION_ENCRYPT",
> +	"ILLEGAL_FUNCTION_SIZE",
> +	"Zlib_MISSING_INIT_EOM",
> +	"ILLEGAL_FUNCTION_RSVD",
> +	"ILLEGAL_BUFFER_LENGTH",
> +	"VLSB_FAULT",
> +	"ILLEGAL_MEM_ADDR",
> +	"ILLEGAL_MEM_SEL",
> +	"ILLEGAL_CONTEXT_ID",
> +	"ILLEGAL_KEY_ADDR",
> +	"0xF Reserved",
> +	"Zlib_ILLEGAL_MULTI_QUEUE",
> +	"Zlib_ILLEGAL_JOBID_CHANGE",
> +	"CMD_TIMEOUT",
> +	"IDMA0_AXI_SLVERR",
> +	"IDMA0_AXI_DECERR",
> +	"0x15 Reserved",
> +	"IDMA1_AXI_SLAVE_FAULT",
> +	"IDMA1_AIXI_DECERR",
> +	"0x18 Reserved",
> +	"ZLIBVHB_AXI_SLVERR",
> +	"ZLIBVHB_AXI_DECERR",
> +	"0x1B Reserved",
> +	"ZLIB_UNEXPECTED_EOM",
> +	"ZLIB_EXTRA_DATA",
> +	"ZLIB_BTYPE",
> +	"ZLIB_UNDEFINED_SYMBOL",
> +	"ZLIB_UNDEFINED_DISTANCE_S",
> +	"ZLIB_CODE_LENGTH_SYMBOL",
> +	"ZLIB _VHB_ILLEGAL_FETCH",
> +	"ZLIB_UNCOMPRESSED_LEN",
> +	"ZLIB_LIMIT_REACHED",
> +	"ZLIB_CHECKSUM_MISMATCH0",
> +	"ODMA0_AXI_SLVERR",
> +	"ODMA0_AXI_DECERR",
> +	"0x28 Reserved",
> +	"ODMA1_AXI_SLVERR",
> +	"ODMA1_AXI_DECERR",
>   };
>  =20
> -void ccp_log_error(struct ccp_device *d, int e)
> +void ccp_log_error(struct ccp_device *d, unsigned int e)
>   {
> -	dev_err(d->dev, "CCP error: %s (0x%x)\n", ccp_error_codes[e], e);
> +	if (WARN_ON(e >=3D CCP_MAX_ERROR_CODE))
> +		return;
> +
> +	if (e < ARRAY_SIZE(ccp_error_codes))
> +		dev_err(d->dev, "CCP error %d: %s\n", e, ccp_error_codes[e]);
> +	else
> +		dev_err(d->dev, "CCP error %d: Unknown Error\n", e);
>   }
>  =20
>   /* List of CCPs, CCP count, read-write access lock, and access function=
s
> diff --git a/drivers/crypto/ccp/ccp-dev.h b/drivers/crypto/ccp/ccp-dev.h
> index 6810b65c1939..7442b0422f8a 100644
> --- a/drivers/crypto/ccp/ccp-dev.h
> +++ b/drivers/crypto/ccp/ccp-dev.h
> @@ -632,7 +632,7 @@ struct ccp5_desc {
>   void ccp_add_device(struct ccp_device *ccp);
>   void ccp_del_device(struct ccp_device *ccp);
>  =20
> -extern void ccp_log_error(struct ccp_device *, int);
> +extern void ccp_log_error(struct ccp_device *, unsigned int);
>  =20
>   struct ccp_device *ccp_alloc_struct(struct sp_device *sp);
>   bool ccp_queues_suspended(struct ccp_device *ccp);
>=20

