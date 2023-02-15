Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6F7FA6975F6
	for <lists+stable@lfdr.de>; Wed, 15 Feb 2023 06:45:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229579AbjBOFpc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 15 Feb 2023 00:45:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53582 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229553AbjBOFpb (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 15 Feb 2023 00:45:31 -0500
Received: from EUR01-DB5-obe.outbound.protection.outlook.com (mail-db5eur01on2072.outbound.protection.outlook.com [40.107.15.72])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 15D6F1CAEA
        for <stable@vger.kernel.org>; Tue, 14 Feb 2023 21:45:29 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=XhkNyuifBNfkqQOSqroVX5JDUkyc7SfJ0BCTIxrL1YXsYwQuXPSVJJ/n5HEdSSYyClg2WMzkVL33shl1zhIKSqhxUpCFpvF6GGMtALbUgQf2Zo0hz4hX4LN/reP7osOrrEtBMVvYFt3El4zX16JRpVI8LQJ1ivePUB3iXHSzA4k58gbFcKyovpG/H3dz+ThOu63PWpJqW70GcIGebS0Tk6jDPDpvJORev7vb4lykvVggksjGjG65PlTc0BOIWLSSqzqOesIvi/Hx83PMyJo4je9zi/gxDl0CWbCRlvfIiMFB/rYNH8Yo2AmCFePc92JS/G2odPTDSVf2X5bGhk78jg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=K7PIejlUCrqUYge4QUSpCv0c+WiB0Khome7CmtzrDd0=;
 b=AEcRoykdscv/ig2nhmwRno1s1LmgyFWD+y8K5uEoUqJiAt/cXdiLOdv7nY1o2nuoKoWgcT+pdq+guigcGsyZgk/y1BF9ggBiMj+jLNgZwvD5dIvHWMiaotpKwX3HhP73MBW9rWKL6xLVwWicFdeypzrlkuQnJ06r/71Yliflx2bjxw443JSvsmXla3BRW8YA+aeid+M3j5l29vdUPuj+B7w+vQsDmj/oTHwmCmlyUCUSYns184/rbqw8XjLpn3TrLkAdg3no/atkzeM9orGbR5x6vyC511SCB3dsgiSsuSriMHG+ZGqpIQAiXso7YVNaH9RpR5Osx3SJsNBJ7SV0KA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=K7PIejlUCrqUYge4QUSpCv0c+WiB0Khome7CmtzrDd0=;
 b=p4Qa5lLrPmPeM0GQcrDNg0ydLayjBhquMn34uwj980AklZBJeDPIfdPhoqDpd4txBEIRACM+ONX4QvG3SPOS2Vcblw3yQPVlqBQ74qISNq8/z8Y5JMJ6Mwsogsb+N2cOMngjyEcMJLcWo43w1BNyrxUKUWsMaMJ2DEvSzJ1RTL8=
Received: from DB7PR04MB4505.eurprd04.prod.outlook.com (2603:10a6:5:39::26) by
 AS8PR04MB8024.eurprd04.prod.outlook.com (2603:10a6:20b:2a3::9) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6086.26; Wed, 15 Feb 2023 05:45:25 +0000
Received: from DB7PR04MB4505.eurprd04.prod.outlook.com
 ([fe80::f874:ee07:56fb:cbe0]) by DB7PR04MB4505.eurprd04.prod.outlook.com
 ([fe80::f874:ee07:56fb:cbe0%6]) with mapi id 15.20.6086.026; Wed, 15 Feb 2023
 05:45:25 +0000
From:   Xu Yang <xu.yang_2@nxp.com>
To:     "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "heikki.krogerus@linux.intel.com" <heikki.krogerus@linux.intel.com>,
        "linux@roeck-us.net" <linux@roeck-us.net>
CC:     "stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: RE: [EXT] patch "usb: typec: tcpm: fix create duplicate
 source/sink-capabilities file" added to usb-testing
Thread-Topic: [EXT] patch "usb: typec: tcpm: fix create duplicate
 source/sink-capabilities file" added to usb-testing
Thread-Index: AQHZQHpnMs6YB2COHEabflw0119h5a7Pf4vQ
Date:   Wed, 15 Feb 2023 05:45:25 +0000
Message-ID: <DB7PR04MB4505FB65BB4277C9D3182B598CA39@DB7PR04MB4505.eurprd04.prod.outlook.com>
References: <167638223881128@kroah.com>
In-Reply-To: <167638223881128@kroah.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DB7PR04MB4505:EE_|AS8PR04MB8024:EE_
x-ms-office365-filtering-correlation-id: 209ff4ef-9a8f-4f22-ceef-08db0f17d62f
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: o0Ma3rHmtDfJ5GM+v11yarfiHNoit3j0MmaLD4evT63Om7LbLoprMAfOGQ0BLtWiNc9JjMJWwrBGTlH2U13YXfgcgT5V2l6MPFxIbAmeB9kd/4AkhbLkveTur/S/wvBNITr5v0zsTaLDn5YtCAIpqDha4zF1vE+KxWb0YvQzDKt1zncjCX5zPFmMYwLmO0oClwJKTbXVfO5DLxtOOkcXkdm162TfqAgZ+rtbpQTQPAftC/33PYtDQalxDFtRq9LQStdUIZtfM+cTc+wIXjKptn4ApYVTs2McZmFpUV3DhjldL2Kr4k7mlRC2ATuD4p6GYGOsw3XIzsriVKnRuFeCjRqEszzkG8hVYkYAA2mfhfIOEXg588oBR1mqrMYmnJgBQ6b/zqgIMOj+OahJx0Tf+izruojZEkRtnmT1hGd8AbxCmsGFpmkij5XZdz6sDvjZx48XeBcb4HUPDOuYoDkoojfrwFWj2MFYW4utWFoQbnEPjiDp0nXiNLegfVgT6YLIdWcsD0l9xCta9kA4Q2pwCQUweDugWKmjK2w/fB4sjYCfKJ+mosRLi6ZGyn5+OQwb/D1lymlwICx/IiW3bx8sWq9XqemwZB9YESnnG0kaNGmATL0G23Rz2Sjo9xpGcMzaCI5lYd25VoMpnQItk4KIo4kegCUtQOwAipknhRRJAUdFXdpJpyDwI+9S9kf3R44Q
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB7PR04MB4505.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(136003)(376002)(346002)(39860400002)(396003)(366004)(451199018)(478600001)(122000001)(66476007)(66446008)(66556008)(66946007)(8676002)(64756008)(83380400001)(38100700002)(110136005)(316002)(76116006)(186003)(9686003)(71200400001)(6506007)(53546011)(45954011)(966005)(8936002)(5660300002)(33656002)(26005)(7696005)(38070700005)(4326008)(45080400002)(52536014)(41300700001)(86362001)(55016003)(2906002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?aTFTj9BchpwqKRhQytl926kiBYQTlaxNX0cngT8/W4YOmW2qiZGv3aIUIYxL?=
 =?us-ascii?Q?g4ip+I3MY9z9UnPPH4m1FSBCHtsuqAGRHmWkkSdsFQYcB3WSYSLpm4ePpuOG?=
 =?us-ascii?Q?fvRfG0HKwpG1jWkTmN6aSIDDG7BnN6WZDwNpHxf47As5gWtPKqx+SC6O13CZ?=
 =?us-ascii?Q?JXdDsNBYz3wiYEo3WRIESWRHM3i08L/YoMUPWUAn7dsneBlqD3eFEJE4YapT?=
 =?us-ascii?Q?cAjTzlbor1rNzEwnZI+o5AX9cf0ulhFXWWpxLbWwoZSLrCpgskvXCzejkJw5?=
 =?us-ascii?Q?f64uPAhtxAp8+X2Xr/eZTHrLIIp3l1Z20lPi9I8If4OT749LLm9hCWO8Jhye?=
 =?us-ascii?Q?4JyAYHoeCX7WvjFLn71WsBsJA1SgcRS0UgvlsKgDb+ClKRaRu1DwCKW56qy9?=
 =?us-ascii?Q?R8NegNiEu6eSuOwTc0/QHpfregVGBdqCObhXsTSUuvmGKPxhtuSxh8+be5ex?=
 =?us-ascii?Q?j34DWW4a5OKPvlUO7qHy0qrMt2l9SwjSML+rOEIw6MZvGcvzyMsTvwV76XwW?=
 =?us-ascii?Q?cbUlVRDfZq1PuymvsqnHTP+PWcyEwFlH2HBv5gqE48zyVyL5120unpx3Hlbc?=
 =?us-ascii?Q?EFRelQggfEZKhRkIh36OuCB9rGN+N4Aohy6LPiwR1yqQ20/U8XlaSuk7Lx8A?=
 =?us-ascii?Q?H6PGWC5l/hwgJnGQhkLUoqo0KhOSVQK/6yJ93ydSQ8Jq6P0LNBBKClDvytO6?=
 =?us-ascii?Q?I388/C5nGuv2y0ulLxoVCirRLYcV0q7CaPcVZcdVXHBvbSsDBMubzKvIdkiJ?=
 =?us-ascii?Q?qqJzrb389Gv7yup9x0MmMzBqqQRc49wtET57R5Do6aMl9u0kJH6q4lfNPya8?=
 =?us-ascii?Q?UbXI+7zWlyGPON2oF7J9yGYgLfLVUoB1sb2+MIuOAFusjNcI/xrjdMI6FZc4?=
 =?us-ascii?Q?UwujkVZ3g7ICtazAKCPVGfwiWXwfuU84D+QZiFPXfPyuhlGWHE6VwwC3XVk5?=
 =?us-ascii?Q?AYU2iTsFHuumx26a7DZNWkqaYFj4+d9BSgOX+8iGdGb9sLx4ksmELkl/hAY3?=
 =?us-ascii?Q?a5j6div2ZWRmpRMFY3CTuDHZ5MibpcOYS/Pl/KE6qybXNYdsQlkWv3GVDf3s?=
 =?us-ascii?Q?7Mz5KZkpdpNbcfge2gnm254KL3lSIhqnilxbOeQs6mR65MoBuUL+1R8xHEsW?=
 =?us-ascii?Q?212FMuCiaH0bXAKPDsxzc0pvbnLIiUrFer78gcz1hjNKXKuvp40hR0Jl7osz?=
 =?us-ascii?Q?BQqOqx5jE3oj1DaB4O84r9/dbEE/As7sTxXvri7RCsQaMdP2oDz/b1wDxqmB?=
 =?us-ascii?Q?AWNuCLukb39cFLXPSmzrHbRcs09nDLRz0OddWJZ0h1+352KKC/o1zTq8A3XR?=
 =?us-ascii?Q?kccyc7jM/ZW/m59Zj79ouw+nqJXT51oXvhWOg9r0pt8VFxj0r8oYo6AIycYs?=
 =?us-ascii?Q?Y0Vzm6nwdwax0e6l1zR/XvP3mAb81d9TZ2xKHXW3G0hffwczAaJ77+h80mkq?=
 =?us-ascii?Q?sCrb5BvA2e+l3VEZM8AT2q80RdQFb1BPhcKt9EtA0Y8c5/g1NUn3veaMHTP2?=
 =?us-ascii?Q?Js6rvJ9d5IJeRCbNx7ouMpNOEEX9o8XtugA7r/hMWI+I6fuvaA1vGTrWqImU?=
 =?us-ascii?Q?hQGC8WEDmeFSZQpSl/o=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DB7PR04MB4505.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 209ff4ef-9a8f-4f22-ceef-08db0f17d62f
X-MS-Exchange-CrossTenant-originalarrivaltime: 15 Feb 2023 05:45:25.4866
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 8yuv5sJJtcvuQGgXRYNv6f2B560OmuawAGRknEsGKfGAcxe2/cW6lDTwO/rPCx0UuQU2cbn3w1GnzltatWczFQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS8PR04MB8024
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Just noticed that port->partner_source_caps should also be reset to NULL.

I'll send a V4 for this soon.

Best Regards,
Xu Yang

> -----Original Message-----
> From: gregkh@linuxfoundation.org <gregkh@linuxfoundation.org>
> Sent: Tuesday, February 14, 2023 9:44 PM
> To: Xu Yang <xu.yang_2@nxp.com>; gregkh@linuxfoundation.org; heikki.kroge=
rus@linux.intel.com; linux@roeck-us.net;
> stable@vger.kernel.org
> Subject: [EXT] patch "usb: typec: tcpm: fix create duplicate source/sink-=
capabilities file" added to usb-testing
>=20
> Caution: EXT Email
>=20
> This is a note to let you know that I've just added the patch titled
>=20
>     usb: typec: tcpm: fix create duplicate source/sink-capabilities file
>=20
> to my usb git tree which can be found at
>     git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/usb.git
> in the usb-testing branch.
>=20
> The patch will show up in the next release of the linux-next tree
> (usually sometime within the next 24 hours during the week.)
>=20
> The patch will be merged to the usb-next branch sometime soon,
> after it passes testing, and the merge window is open.
>=20
> If you have any questions about this process, please let me know.
>=20
>=20
> From f430e60b78c6359ba4cb4e521d7df7f9a0484e03 Mon Sep 17 00:00:00 2001
> From: Xu Yang <xu.yang_2@nxp.com>
> Date: Tue, 14 Feb 2023 14:56:35 +0800
> Subject: usb: typec: tcpm: fix create duplicate source/sink-capabilities =
file
>=20
> The kernel will dump in the below cases:
> sysfs: cannot create duplicate filename
> '/devices/virtual/usb_power_delivery/pd1/source-capabilities'
>=20
> 1. After soft reset has completed, an Explicit Contract negotiation occur=
s.
> The sink device will receive source capabilitys again. This will cause
> a duplicate source-capabilities file be created.
> 2. Power swap twice on a device that is initailly sink role.
>=20
> This will unregister existing capabilities when above cases occurs.
>=20
> Fixes: 8203d26905ee ("usb: typec: tcpm: Register USB Power Delivery Capab=
ilities")
> cc: <stable@vger.kernel.org>
> Signed-off-by: Xu Yang <xu.yang_2@nxp.com>
> Reviewed-by: Heikki Krogerus <heikki.krogerus@linux.intel.com>
> Reviewed-by: Guenter Roeck <linux@roeck-us.net>
> Link:
> https://eur01.safelinks.protection.outlook.com/?url=3Dhttps%3A%2F%2Flore.=
kernel.org%2Fr%2F20230214065635.972698-1-
> xu.yang_2%40nxp.com&data=3D05%7C01%7Cxu.yang_2%40nxp.com%7C0a677a0f0f744f=
dba90608db0e918880%7C686ea1d3b
> c2b4c6fa92cd99c5c301635%7C0%7C0%7C638119790442766596%7CUnknown%7CTWFpbGZs=
b3d8eyJWIjoiMC4wLjAwMDAiL
> CJQIjoiV2luMzIiLCJBTiI6Ik1haWwiLCJXVCI6Mn0%3D%7C3000%7C%7C%7C&sdata=3DLBw=
dwkjQxcH1NSRUEstHtYDDTCacXUg8p
> bQ%2B1b6nQKY%3D&reserved=3D0
> Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> ---
>  drivers/usb/typec/tcpm/tcpm.c | 6 ++++++
>  1 file changed, 6 insertions(+)
>=20
> diff --git a/drivers/usb/typec/tcpm/tcpm.c b/drivers/usb/typec/tcpm/tcpm.=
c
> index a0d943d78580..7d8c53d96c3b 100644
> --- a/drivers/usb/typec/tcpm/tcpm.c
> +++ b/drivers/usb/typec/tcpm/tcpm.c
> @@ -4570,6 +4570,8 @@ static void run_state_machine(struct tcpm_port *por=
t)
>         case SOFT_RESET:
>                 port->message_id =3D 0;
>                 port->rx_msgid =3D -1;
> +               /* remove existing capabilities */
> +               usb_power_delivery_unregister_capabilities(port->partner_=
source_caps);
>                 tcpm_pd_send_control(port, PD_CTRL_ACCEPT);
>                 tcpm_ams_finish(port);
>                 if (port->pwr_role =3D=3D TYPEC_SOURCE) {
> @@ -4589,6 +4591,8 @@ static void run_state_machine(struct tcpm_port *por=
t)
>         case SOFT_RESET_SEND:
>                 port->message_id =3D 0;
>                 port->rx_msgid =3D -1;
> +               /* remove existing capabilities */
> +               usb_power_delivery_unregister_capabilities(port->partner_=
source_caps);
>                 if (tcpm_pd_send_control(port, PD_CTRL_SOFT_RESET))
>                         tcpm_set_state_cond(port, hard_reset_state(port),=
 0);
>                 else
> @@ -4718,6 +4722,8 @@ static void run_state_machine(struct tcpm_port *por=
t)
>                 tcpm_set_state(port, SNK_STARTUP, 0);
>                 break;
>         case PR_SWAP_SNK_SRC_SINK_OFF:
> +               /* will be source, remove existing capabilities */
> +               usb_power_delivery_unregister_capabilities(port->partner_=
source_caps);
>                 /*
>                  * Prevent vbus discharge circuit from turning on during =
PR_SWAP
>                  * as this is not a disconnect.
> --
> 2.39.1
>=20

