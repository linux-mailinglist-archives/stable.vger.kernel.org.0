Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E6E883F4C2B
	for <lists+stable@lfdr.de>; Mon, 23 Aug 2021 16:16:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229743AbhHWOQn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 23 Aug 2021 10:16:43 -0400
Received: from esa2.hgst.iphmx.com ([68.232.143.124]:20477 "EHLO
        esa2.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229518AbhHWOQm (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 23 Aug 2021 10:16:42 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1629728160; x=1661264160;
  h=from:to:cc:subject:date:message-id:references:
   content-transfer-encoding:mime-version;
  bh=4ViEOjKRZ5Q5DloozNphuYmUYX9EKLJtjvVnwqy72z8=;
  b=PgFVtx6mlzdERE87IQDOZKlAU3cTw/mVquiQp5gLBHcO3Sa1i++nq2pG
   Z/wOOy7QkBwXRRewFKKkN94Vcdz1sKUb7mOaIB2S9OQIErWC5a2sYBqsb
   YtHwEIjeJongNPmTpkC5KzrhOz/gfOr1vg/uMsH6D8FqYUQdrFgsADvcl
   b3smL5XGyOR/2VdlkxQoA3Z81mzx6/xXqlDgZFprBzAa31mfLfaND+YrN
   XaeA0OdN6AZCnw8UVJyoTMNUI5tbjnI2LQzcF2No8KzR5t/sfQlNSUYBR
   owkc8HEC5npEwMCLpzkOESuFz7XzKqZzNoC8MuAobME7js2pSwmF6djYr
   A==;
X-IronPort-AV: E=Sophos;i="5.84,344,1620662400"; 
   d="scan'208";a="281910140"
Received: from mail-bn8nam11lp2176.outbound.protection.outlook.com (HELO NAM11-BN8-obe.outbound.protection.outlook.com) ([104.47.58.176])
  by ob1.hgst.iphmx.com with ESMTP; 23 Aug 2021 22:15:58 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=TnoHQXEwvg+gCq6s2+L1g4sYa+kosVIBPQ4ohTNEjS9Uc6tzvGljqPtUjkRm8qgNCk0U2P7WOC+hSnUaSgWbG5cUg5qhUKs/TuQ8hGe3ZFpS29s0h+lf5lOgE2oNtcAmSbesVQh4fO+7bARzTwJdVbuK3Sk0mN2ufKR64HyLblQcM3dwm162bYfpFyS7mjxobLjmWRSEpQVZslZNVd8GEIZ6L+imwUz+gz3wFNv6YWAlfYNSk0RtAfbSCFCBfl9fhrRXcajEfM2ZYy7OzLDn5yB4JUYMWmsNUd6rUE7fJGh8ZSuocm9JO8gCwU6r8pZhZb85enPWpNTUQTjHViwLCQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=eO5kfhkR3D/WwQ2Zouij+2AAhqvqRm4c7TeMjPBwqco=;
 b=n0kb2NHTOGf2oKziket2a0PM6Eg7g8nFHDKeqmhhTTPwrl5wZU8ojfqfhFioyLYG/8a5pK82mXCi/GaxkWAUtbEL7HjTPuranw9sAqYqeSo+kRqviSfGS4Kw5xcXaCFc6QqkHZCzQjie8Hf8AxEMW4wRy82DsPIpSKizQJ71uqkyXF5/WhpAwEAr+d7T9JQwKAic8HDuIHpnYD1LQ6FzeGLiyeeahGWkdPLigebsqFP4HmPAnDLdwM1bJl6+31olK5KEkNtKjXGSFENcsuIPUilo1HhaYGhXDz712YyF2F2zh6GTXLzNTbxIchQvTsff8niNyOVptWJuhgRMNbiOvg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=eO5kfhkR3D/WwQ2Zouij+2AAhqvqRm4c7TeMjPBwqco=;
 b=qBTFCLCTkiphUwsWG6y5OhjVHYYGoIBmmpQIZXQeUcuBy+6cHQ2x6jKm9Y5cnv07qBwvacYSdSQGcPUphbJt7gYeCLftq7xJ9Fy8x44Zp/S+RL0T9dgaWQiRb5qFwYRb9V6rp6QycY7dMuPKcS6CWBHQ29AeL6v8nhWuURv6NWM=
Received: from DM6PR04MB7081.namprd04.prod.outlook.com (2603:10b6:5:244::21)
 by DM6PR04MB4826.namprd04.prod.outlook.com (2603:10b6:5:29::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4436.21; Mon, 23 Aug
 2021 14:15:57 +0000
Received: from DM6PR04MB7081.namprd04.prod.outlook.com
 ([fe80::e521:352:1d70:31c]) by DM6PR04MB7081.namprd04.prod.outlook.com
 ([fe80::e521:352:1d70:31c%9]) with mapi id 15.20.4436.024; Mon, 23 Aug 2021
 14:15:57 +0000
From:   Damien Le Moal <Damien.LeMoal@wdc.com>
To:     Hans de Goede <hdegoede@redhat.com>, Jens Axboe <axboe@kernel.dk>
CC:     "linux-ide@vger.kernel.org" <linux-ide@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        Kate Hsuan <hpa@redhat.com>
Subject: Re: [PATCH] libata: add ATA_HORKAGE_NO_NCQ_TRIM for Samsung 860 and
 870 SSDs
Thread-Topic: [PATCH] libata: add ATA_HORKAGE_NO_NCQ_TRIM for Samsung 860 and
 870 SSDs
Thread-Index: AQHXmASX5h8/WsRkXEOh63fUfKAP4w==
Date:   Mon, 23 Aug 2021 14:15:57 +0000
Message-ID: <DM6PR04MB7081C79995F84D84800D8EA9E7C49@DM6PR04MB7081.namprd04.prod.outlook.com>
References: <20210823095220.30157-1-hdegoede@redhat.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: redhat.com; dkim=none (message not signed)
 header.d=none;redhat.com; dmarc=none action=none header.from=wdc.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 0c656e7b-0f69-4f6e-ad05-08d966408708
x-ms-traffictypediagnostic: DM6PR04MB4826:
x-microsoft-antispam-prvs: <DM6PR04MB482671FB32DC52F8279810E9E7C49@DM6PR04MB4826.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:7691;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 4NawodVXZ/r9tbPT5c1aHEsP8R3JGOcx6kIaeObuUocdsvg90GoWaNSFnqcTdV09/D76wBAX2uEOpywldXglTkEM3NemPs/zTGVtdJFPcaUvBPXSkOBTloamwrtHXwqpOefBONcjMR0CuXn3HW3/UbTbJv4E17UUFel7LqhkgFt3AaHUD2HKm3nIpt3Wt9BW3aKRBoOD/T5tJQMCSjmkUuVZdKK0mFw3A/T2D9f7vcZ7gPpW8dcwhXUtqJQnfWgAxUjc2cR2oaqOBf7B+jg3ZYGF9SIB89KzoIWDvVkE4gj2L+cIcMlFpCMUOw0V8Gqc+VYjcRHL4a0HasU2xNXghyLFYMDg5RipjZ1sea6jHcuSpAQBe5YtduZCn/1AqpRn6c4rptKV49v/lyZgqIYuuKIM785VnOLHyhGTyiIsgamh4sEm0k+5TM6+v/ZJVUfDYEvo2QJZKUFCQzlXRK02LNq6t0Y+UUGJwYNeLzuPXEnmcJ3IYcOsDyCT+BwsNfuMUp8qofBvlPaznnpvPJa3Bwt/7XqkSoAiFWUay74ZoKWP+V8f3H//RenuluIoVhgQsJtWw+UJTVqGJ6JN8wigPNPSV0D8eCdsQQl1pnVz7DLhLcGSgBfg1NW+dwknhj0Oe+/HZ5a2GUvDyUu+YtMf80GdeIbNkTvocP+NNrqq6Rd33w04h0bKquGlDHDr6Edqx9d8bkZeg1jDiNAqx7Onr0f9jDgdE/680NNBfCHNFpLpvFB+6YYgW45sP6yVaHky2KVqx/bpugJS7urVJmgfyR5EOZGPQol+Q6I82YwgfvI=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR04MB7081.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(39860400002)(376002)(366004)(396003)(136003)(346002)(478600001)(54906003)(4326008)(110136005)(86362001)(8936002)(966005)(6506007)(71200400001)(7696005)(33656002)(2906002)(83380400001)(316002)(66556008)(38070700005)(66946007)(64756008)(66476007)(55016002)(66446008)(122000001)(91956017)(8676002)(76116006)(9686003)(186003)(52536014)(53546011)(38100700002)(5660300002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?UGvNPjIqg4e5esxFmmo9Rq26KxzIKMhb6N3QfHN+Mwxvpc3Dc72TObfjQkcI?=
 =?us-ascii?Q?tbKOZ9nnfQUuoyjNGakrpXmQMkmfMv7oAQSFw1+KXxeuksZ7o9lzrUIvxYKc?=
 =?us-ascii?Q?glt9+8gFCx9Va/U9pv3Jq1xwqFeP4g8xNZ4dVHOpVO1NUo4UnsG01oDOO+aE?=
 =?us-ascii?Q?hm8p6xQ3/Z3vzQOTaLgGAqJfjh/qBBVbKTGfHO/kypfeJzebGJnFPXiHbkr2?=
 =?us-ascii?Q?XtzbZbCX3pRa2AVe8YxEc9xsM+WdP3Vf5a0M2o5BoIGVYPJN7zyKvQO36ECV?=
 =?us-ascii?Q?Q+nOWg4Iswu29WHRn8V9vKXOqON7kqj39wrcfRu7Aq1J5+XzjpD6qsWtYOob?=
 =?us-ascii?Q?JUkgeLQUPXpHs2JImk5BdwUp5H+k9Ee+eqszs+R0rKO6yqrSVXrgBsjNVJi8?=
 =?us-ascii?Q?VyBKVgmw69lHOMbImWc82/3BUzlu8OLHCsum4Q48Mcicd46lZjBVL5zxmTiC?=
 =?us-ascii?Q?5jie33zpKoV0oOvpyP7pNE4DllihrZ3rPrEf2KyRjhFFRAa/EA1bcohEVM4D?=
 =?us-ascii?Q?rUhhDkneqzDoFCQ4715Eu/ka5ec4RRTs9bNYd5YxK8MEVJV+csMLS9IXSaFJ?=
 =?us-ascii?Q?SvX4H2pWS8hKKdpQX91wnxOnWGT5KpSwKBSQIXtGF4djTUwLfQglZcpWjMBL?=
 =?us-ascii?Q?ieIc5bnBDOjUPd5J5/q7JgvfYBn3Y8w+g+ftdWaDP5GX1CKkJo59rIOcdMa8?=
 =?us-ascii?Q?50CN7NNlzqTgExtHu5FKMKf8PKkjDVVYNjkZ0PtqDVpjNRNtq9Va6r513EpE?=
 =?us-ascii?Q?nsub+X7VcCSeKcebu3glk/IcU/3LRzvDd1NIdHXBoO5cFVuU5V/h/YmGNJ0p?=
 =?us-ascii?Q?+kC9C2AHeR3KdLpqK/dv4SxD0ruDFp3e7eKW950KrnRCTZ3poBeFrGxw4Llo?=
 =?us-ascii?Q?mEkjsLpei/uBJiZPqo/e6GK4eHBpX4sfQ6ViOd54rfAG9fxNowel3eVLwLbv?=
 =?us-ascii?Q?QQs3rNjhKmMzoD461SEDa531WDRWyvkglmkHoYP75AinUXFxcg6nhtNgLGL+?=
 =?us-ascii?Q?px1zRg6LfvwemcC8k6M1enDUcr4Q4qzPN4yWM5Z+BKCByoEOGj9SIecN0im/?=
 =?us-ascii?Q?kAaS1Yq3dP1V3LiK0PIxW6SIHqK2LqrIeDYfAcNeRD5ecfc2bAaSi/6Cvo+C?=
 =?us-ascii?Q?GXyQZnl+gxggPTpj1Hl8nyDQu22yJjGHSgmmUv2NXGeD2oLElrfxRblzrcR9?=
 =?us-ascii?Q?nS8Fjk7Io8GN7qI3bPi/UsOIANfe3O9tGEspB0oRY/EWsLs6K9ZOMC58rJ66?=
 =?us-ascii?Q?KFrMX6ifTRIKt4WpuBdCBoev6aJT7MWLe2Uv2koKf5DbLbJ3pQNukeholWKr?=
 =?us-ascii?Q?+xsdgh8/+BOWz03MIFWI8rMUKZhC+LXq3eqQ7owJIc4u0ee5pIZ7PtRQ18KV?=
 =?us-ascii?Q?30XBnzXh5vTqPoPRReZ1OlMlW2vXihJ4crSVuBy9oVeFMRzWCA=3D=3D?=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM6PR04MB7081.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0c656e7b-0f69-4f6e-ad05-08d966408708
X-MS-Exchange-CrossTenant-originalarrivaltime: 23 Aug 2021 14:15:57.8441
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: DlZX7BmOUiiZyoOBV/KD1w7PzvVcNMW0UaM65hZLE7SucwdF10LPwITaxtRbcvQ8Q4nrGeDBOo6up2Ed5tzUbA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR04MB4826
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 2021/08/23 18:52, Hans de Goede wrote:=0A=
> Commit ca6bfcb2f6d9 ("libata: Enable queued TRIM for Samsung SSD 860")=0A=
> limited the existing ATA_HORKAGE_NO_NCQ_TRIM quirk from "Samsung SSD 8*",=
=0A=
> covering all Samsung 800 series SSDs, to only apply to "Samsung SSD 840*"=
=0A=
> and "Samsung SSD 850*" series based on information from Samsung.=0A=
> =0A=
> But there is a large number of users which is still reporting issues=0A=
> with the Samsung 860 and 870 SSDs combined with Intel, ASmedia or=0A=
> Marvell SATA controllers and all reporters also report these problems=0A=
> going away when disabling queued trims.=0A=
> =0A=
> Note that with AMD SATA controllers users are reporting even worse=0A=
> issues and only completely disabling NCQ helps there, this will be=0A=
> addressed in a separate patch.=0A=
> =0A=
> Fixes: ca6bfcb2f6d9 ("libata: Enable queued TRIM for Samsung SSD 860")=0A=
> BugLink: https://bugzilla.kernel.org/show_bug.cgi?id=3D203475=0A=
> Cc: stable@vger.kernel.org=0A=
> Cc: Kate Hsuan <hpa@redhat.com>=0A=
> Signed-off-by: Hans de Goede <hdegoede@redhat.com>=0A=
> ---=0A=
>  drivers/ata/libata-core.c | 4 ++++=0A=
>  1 file changed, 4 insertions(+)=0A=
> =0A=
> diff --git a/drivers/ata/libata-core.c b/drivers/ata/libata-core.c=0A=
> index 61c762961ca8..3eda3291952b 100644=0A=
> --- a/drivers/ata/libata-core.c=0A=
> +++ b/drivers/ata/libata-core.c=0A=
> @@ -3950,6 +3950,10 @@ static const struct ata_blacklist_entry ata_device=
_blacklist [] =3D {=0A=
>  						ATA_HORKAGE_ZERO_AFTER_TRIM, },=0A=
>  	{ "Samsung SSD 850*",		NULL,	ATA_HORKAGE_NO_NCQ_TRIM |=0A=
>  						ATA_HORKAGE_ZERO_AFTER_TRIM, },=0A=
> +	{ "Samsung SSD 860*",		NULL,	ATA_HORKAGE_NO_NCQ_TRIM |=0A=
> +						ATA_HORKAGE_ZERO_AFTER_TRIM, },=0A=
> +	{ "Samsung SSD 870*",		NULL,	ATA_HORKAGE_NO_NCQ_TRIM |=0A=
> +						ATA_HORKAGE_ZERO_AFTER_TRIM, },=0A=
>  	{ "FCCT*M500*",			NULL,	ATA_HORKAGE_NO_NCQ_TRIM |=0A=
>  						ATA_HORKAGE_ZERO_AFTER_TRIM, },=0A=
>  =0A=
> =0A=
Reviewed-by: Damien Le Moal <damien.lemoal@wdc.com>=0A=
=0A=
-- =0A=
Damien Le Moal=0A=
Western Digital Research=0A=
