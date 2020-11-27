Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5B14A2C644B
	for <lists+stable@lfdr.de>; Fri, 27 Nov 2020 13:08:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726014AbgK0MGy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 27 Nov 2020 07:06:54 -0500
Received: from mail-db8eur05on2085.outbound.protection.outlook.com ([40.107.20.85]:46496
        "EHLO EUR05-DB8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725985AbgK0MGy (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 27 Nov 2020 07:06:54 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=SDf3SMAHRcJKFOt6M+FCXtPcA3eAHNtNRTr67BldRDuyO+sbqQNMPfOzMqfSel4bUGuQ1tjQN45tjK/WdAsRw2oH1ixuPcyZ+jC9UwtjmlWt7PrOQSmMlpwG1Bv2GEf6Io5/6KFZpFczEVHDsuql25FTlXIshQ0BTTymV+SEo7xLc+bHfLRra78vFDADed/+gT51q+ii/3+tkp54wUE/z4qbXGnMn2wSw5BH7e0v9EuFPoqSU21pCVdK5j9XWc7xDB//RDKjxlGiydE9uxMy1acK2HPLxkdRjCDWoSyRMZMM6ieMdTQ7cwGNmrQcaDDkToG2P4VWMHDsYjDERMLjuQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jLg5Q/RD8HECRbge5FVr/x0Jh83z6x4hU0PymZ7ZCbY=;
 b=lvGl3WJfrv9S09rvXhxZSMXfkYtfapMsWVx+qWGRqtr525uWqUDqCWNnnMOrdrZI2FWvcre0v/HvZ/7yxXTCulWKLG1BsrEx3FupawnBQqrVZlvb6fklOeSv7eX9FVsJnASbjf0aleQcSF0qMKahp2hQlIqpfCByuF6DrBKWIJKYvW5NBseWhPXWn1mU7uK4K55Glt6AUwV32BrCfBpyGpOutCUC9Q5XBw6QP2DgKJSMfhqFX9nRMDrPpTHkWEK+sFN0TfvuHItHsVsZoblfDCQPx96wR4mXy8ebkJehtV33oSm9IsIeSWJe5fT5kONTAl89c/m9p5xKqDUNy/kYVg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jLg5Q/RD8HECRbge5FVr/x0Jh83z6x4hU0PymZ7ZCbY=;
 b=KO3wxMgx3NgjLEluMlucx3z9Y7e6iM4o51cZQKbMAJalq+la27gBTyVZ160aHD6y0/zp1d8CgScsaBNy5+l339VlJ0lyaDEn6cIvytsS+tPTpBVr3OwrIX4ZzfoQcA9+K/2RGto8VAtTYXjzMKSZfEU140JjIX0DJzVmtUROY2U=
Received: from DBBPR04MB7979.eurprd04.prod.outlook.com (2603:10a6:10:1ec::9)
 by DB8PR04MB7179.eurprd04.prod.outlook.com (2603:10a6:10:124::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3611.22; Fri, 27 Nov
 2020 12:06:50 +0000
Received: from DBBPR04MB7979.eurprd04.prod.outlook.com
 ([fe80::c8c:888f:3e0c:8d5c]) by DBBPR04MB7979.eurprd04.prod.outlook.com
 ([fe80::c8c:888f:3e0c:8d5c%5]) with mapi id 15.20.3611.025; Fri, 27 Nov 2020
 12:06:50 +0000
From:   Peter Chen <peter.chen@nxp.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC:     "balbi@kernel.org" <balbi@kernel.org>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Will McVicker <willmcvicker@google.com>,
        stable <stable@vger.kernel.org>
Subject: Re: [PATCH 4/4] USB: gadget: f_midi: setup SuperSpeed Plus
 descriptors
Thread-Topic: [PATCH 4/4] USB: gadget: f_midi: setup SuperSpeed Plus
 descriptors
Thread-Index: AQHWxB9kjqaqi8p2XkafJ7Illnrgjanb4zGA
Date:   Fri, 27 Nov 2020 12:06:50 +0000
Message-ID: <20201127120621.GD22238@b29397-desktop>
References: <20201126180937.255892-1-gregkh@linuxfoundation.org>
 <20201126180937.255892-4-gregkh@linuxfoundation.org>
In-Reply-To: <20201126180937.255892-4-gregkh@linuxfoundation.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Mutt/1.9.4 (2018-02-28)
authentication-results: linuxfoundation.org; dkim=none (message not signed)
 header.d=none;linuxfoundation.org; dmarc=none action=none
 header.from=nxp.com;
x-originating-ip: [119.31.174.67]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 5430de21-dc72-4acc-d0f1-08d892ccec5a
x-ms-traffictypediagnostic: DB8PR04MB7179:
x-microsoft-antispam-prvs: <DB8PR04MB7179CB4C5B837193035998368BF80@DB8PR04MB7179.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:6108;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: jJH72sy6pzAZmp9wJRTvo6khlpk9XNxLp+vv8g/mQ8mKZDl2LrHGZ1QlMCufYi/eodubOx/ztqsGbNLaECLelYKHkxaqtfDm/lwYLBxGfWGFE931QDqe2Bhf5HpukXJv91o505TuyLQZ+7SijZjuwkwqPbQcWAfUNAg3AcIhi6KaM0PaAyVgV3dmvvEd9DZOIS8GucdsWTXAD+qeFTwINod5nIvv7m6iFYLTzDTOlJVEZUmU8cCSuVG9VFw+LIbrLVVPQtjAdCetEPP6Bv0vVtBItyHEaiyNJHBnzwDcC4kfTh+pLmgluazkHdOFLVN0z6RLLyL0GHKNqd3THYYJpA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DBBPR04MB7979.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(7916004)(4636009)(366004)(396003)(136003)(376002)(39860400002)(346002)(91956017)(54906003)(4326008)(86362001)(316002)(9686003)(6512007)(5660300002)(2906002)(8936002)(26005)(8676002)(66476007)(6486002)(186003)(71200400001)(1076003)(6506007)(33716001)(33656002)(76116006)(44832011)(478600001)(66446008)(66946007)(64756008)(66556008)(6916009)(53546011);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: =?us-ascii?Q?c+s8Z5acqXdIx4RIjczGqlckQCAcBGWozVvUiZzK732hO3uH2nkeSN5/tNFi?=
 =?us-ascii?Q?o1p5HEAD5vIPtpThSgkGmWADZk5wbJtMyaDz+w4B5esGUmil3+uYQZSCrV14?=
 =?us-ascii?Q?hZQMZst5Q/mBZdl6CyBuTNfhJk1ZhNoDu3k4Es2okFBoZSVlguUYkRlQnkzx?=
 =?us-ascii?Q?9wJwDjpRQhZn1uyEbxQ0MpIrtt4InvpbVAMR5W+pRpclZrkInVkxbBIHn8IQ?=
 =?us-ascii?Q?IBXryKtUWD/Q2fHXpu+GRx8IDfA7iy1ZT2P6GQhkhybl3hvQd13ZGyt9H2ja?=
 =?us-ascii?Q?TM1KVWrzaW8yD7N6f35t4UZ6mAkT7hf6eOvhBznM8VdLrL7/GkfyISjV7aj/?=
 =?us-ascii?Q?V/UnKoZvjZbsYuyrQ2NKRYUuSSdI2Y8G0siIXhyi33i8/vRar/FJtkviaHvP?=
 =?us-ascii?Q?3Uem2IFAe0s0J+QKEHnQIQ0wXVZ4VW8QTRk0sXugLk3Hd8Ka5LfYg8aO4fwl?=
 =?us-ascii?Q?zWojPIk9vBufOnrvqTT9vTqW1kh/+XRqiwdsQmT5pELFlsV6xyemrsXNeE5L?=
 =?us-ascii?Q?lTF0Y6wT2XzDQwFv7Nq9zAz9XZdE97mJlFrmPBW2C/oyTLyGdeA3OnzBh8O3?=
 =?us-ascii?Q?3yFmN1D9TzN32+/j6Awt6Am5O4HAOXds4xX/ksNGi1pKNl5iJLIhJvijoHah?=
 =?us-ascii?Q?cQOJfm99R0YPAaq2Ms+Cr23shcURXyyWyQCc9E1bIb+smjSgNqktCmn4K8q1?=
 =?us-ascii?Q?gaykzwX+NRmk8LSAK5P/az8UKkMDWZY/zSVIiJC8pq0m4LhR8Vg+PpggKhx3?=
 =?us-ascii?Q?VYH2fBEO9u810dKGH/jMqKtcCEurwm/Dj4cMnbhEdLi8vQx+DEh3QU/Qzlqt?=
 =?us-ascii?Q?bNmdVHT1YezrgGVi7+wsV2cVY0yVkI54T+ry7cguwqdLBGuWvSTjwmdGw8To?=
 =?us-ascii?Q?/7gCJ1PjnQRgprANrV5QXeVBWx7qLvM0b8Ha+kwtFgx51+LS5nufgV6vIlJA?=
 =?us-ascii?Q?+HwNSKXV5pgwLV4A9cj3Le+ZLjFZkq9KLw3DkqVRPnIN1fy53IJgU162Mfnd?=
 =?us-ascii?Q?xjNm?=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-ID: <433BF40DE4B49F4881522FE4D01E8F02@eurprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DBBPR04MB7979.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5430de21-dc72-4acc-d0f1-08d892ccec5a
X-MS-Exchange-CrossTenant-originalarrivaltime: 27 Nov 2020 12:06:50.8576
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: U8btwrphde97GHepeUJPBhIoBA+jLdV/z4yqIUa/eLXU+UfOmUWIUnKIK/cGCtVMiXAQcoUTrshdZHTyh8FxFw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB8PR04MB7179
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 20-11-26 19:09:37, Greg Kroah-Hartman wrote:
> From: Will McVicker <willmcvicker@google.com>
>=20
> Needed for SuperSpeed Plus support for f_midi.  This allows the
> gadget to work properly without crashing at SuperSpeed rates.
>=20
> Cc: Felipe Balbi <balbi@kernel.org>
> Cc: stable <stable@vger.kernel.org>
> Signed-off-by: Will McVicker <willmcvicker@google.com>
> Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> ---
>  drivers/usb/gadget/function/f_midi.c | 5 +++++
>  1 file changed, 5 insertions(+)
>=20
> diff --git a/drivers/usb/gadget/function/f_midi.c b/drivers/usb/gadget/fu=
nction/f_midi.c
> index 85cb15734aa8..ceb67651de4f 100644
> --- a/drivers/usb/gadget/function/f_midi.c
> +++ b/drivers/usb/gadget/function/f_midi.c
> @@ -1048,6 +1048,11 @@ static int f_midi_bind(struct usb_configuration *c=
, struct usb_function *f)
>  		f->ss_descriptors =3D usb_copy_descriptors(midi_function);
>  		if (!f->ss_descriptors)
>  			goto fail_f_midi;

Add one blank line, otherwise:

Reviewed-by: Peter Chen <peter.chen@nxp.com>

Peter
> +		if (gadget_is_superspeed_plus(c->cdev->gadget)) {
> +			f->ssp_descriptors =3D usb_copy_descriptors(midi_function);
> +			if (!f->ssp_descriptors)
> +				goto fail_f_midi;
> +		}
>  	}
> =20
>  	kfree(midi_function);
> --=20
> 2.29.2
>=20

--=20

Thanks,
Peter Chen=
