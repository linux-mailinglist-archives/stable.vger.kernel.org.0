Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A03431E5CA0
	for <lists+stable@lfdr.de>; Thu, 28 May 2020 12:03:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387589AbgE1KDk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 28 May 2020 06:03:40 -0400
Received: from mail-eopbgr00072.outbound.protection.outlook.com ([40.107.0.72]:18049
        "EHLO EUR02-AM5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2387518AbgE1KDk (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 28 May 2020 06:03:40 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=nYwr62FiG629uC+MLbAuUIbFIVRjz+69BPZrVWcu7beUPcmROMX2J0OJII2VhLXmubJ0i5N/Z45cZ/SFLDb2fwrVeKlakUOvW5moXJWqBbf+PjMH7oaSRuyys4opkk37huD7zkqqKfAsMex8sJdJOzWKHGc4nF7Ls5FGSBf75t60HW8oz73i7Rb6kELqaKW0gtfhCXI/M2r01eB5citTVK5wlYnG1TgBIthdHZIZG7F7hhbaj7QL9Kmnz+qgTwdgWzC7m4cMA/9cWWFkuZL9sf0hz8+JH7mQGtVE4zqndc8CYDkb0+8tKslm+MyFzeInLzgBbi1OTcXaVO+Vat4sVw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=fiSKqprrhpQiROE08VUfCHN2l7HN5lH9gB4TIAGLfJ4=;
 b=jRaXP1CswgygoHPFwc+tYx/+aXLBT1qEFiFaLJIF2broENqQF0/MCajZJLdiBVaJ/UemCEHgnWDe6wEoU5gULbQPq1aSwVY8wQ5A4M/+fxFsjQiJZQS2+2SfmkfBhEzU5VNlIUz/ILVqhihvP5GJLyFMtCsgwGLvO/tbonZQ4i/D2pXqXYuX835GofZ4ORtpUwBvrtp7hsLHtBq16q8v/p0BMXFVr7KUR6g9D7CuKq1w/IXbuKDfV4mCQgvfnpGYZnZTZiiIUnDjnurtCHKjPYZNhnyxwt63+TamPPhKt3+mfxQWD/s4FjwbvmA+eW0AoYClLPrrNyjlYhPLMDhT9A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=fiSKqprrhpQiROE08VUfCHN2l7HN5lH9gB4TIAGLfJ4=;
 b=GOTNnu8iVtD0VZA5UwGNtwa1fwh92ED+BJJPM3c/I+1WREnK/Obfzu+4fZEluTMrUb/2ch7ba2OrI7ALv+5XJoxBOozP4Pb/DBYhiL/rOXhfXNvJdhITzM/Gw0Tjf94uXLdpGqXEo/2GO2Fpto1dwpPaWwCzUaa45bF9n4z5r1M=
Authentication-Results: pengutronix.de; dkim=none (message not signed)
 header.d=none;pengutronix.de; dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB3983.eurprd04.prod.outlook.com (2603:10a6:803:4c::16)
 by VI1PR04MB3184.eurprd04.prod.outlook.com (2603:10a6:802:9::33) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3021.26; Thu, 28 May
 2020 10:03:37 +0000
Received: from VI1PR04MB3983.eurprd04.prod.outlook.com
 ([fe80::250a:ccb1:b015:3b38]) by VI1PR04MB3983.eurprd04.prod.outlook.com
 ([fe80::250a:ccb1:b015:3b38%5]) with mapi id 15.20.3021.030; Thu, 28 May 2020
 10:03:37 +0000
Message-ID: <31843bf5ba23d0693cab85fdbb5e3ee8a7453527.camel@nxp.com>
Subject: Re: [PATCH] drm/imx: imx-ldb: Disable both channels for split mode
 in enc->disable()
From:   Liu Ying <victor.liu@nxp.com>
To:     Marco Felsch <m.felsch@pengutronix.de>
Cc:     dri-devel@lists.freedesktop.org, stable@vger.kernel.org,
        s.hauer@pengutronix.de, kernel@pengutronix.de, linux-imx@nxp.com,
        p.zable@pengutronix.de
Date:   Thu, 28 May 2020 18:02:53 +0800
In-Reply-To: <20200528093145.kmpzbnesv25k7wvc@pengutronix.de>
References: <1589268718-29837-1-git-send-email-victor.liu@nxp.com>
         <ce17fb3798b208e63eabee6c1e1197bfce6b77a9.camel@nxp.com>
         <20200528093145.kmpzbnesv25k7wvc@pengutronix.de>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.2-0ubuntu1 
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SG2P153CA0013.APCP153.PROD.OUTLOOK.COM (2603:1096::23) To
 VI1PR04MB3983.eurprd04.prod.outlook.com (2603:10a6:803:4c::16)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from blueberry.ap.freescale.net (119.31.174.66) by SG2P153CA0013.APCP153.PROD.OUTLOOK.COM (2603:1096::23) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3066.2 via Frontend Transport; Thu, 28 May 2020 10:03:35 +0000
X-Originating-IP: [119.31.174.66]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: f49b8261-c671-454b-0ebc-08d802ee63b9
X-MS-TrafficTypeDiagnostic: VI1PR04MB3184:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VI1PR04MB3184B64BDDED651996B8ECC1988E0@VI1PR04MB3184.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7219;
X-Forefront-PRVS: 0417A3FFD2
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: aSWYbKkLJB+J7yM6pvRuSvOlja8GWxkKDwtJjAU/yo8bjTqHTY99ovJcK7vRLkVkQj+l7ZQMNrTCHj39xiglrj7JimKLGl5tO/qOtahBwl1lEzykVF+M5jSoUZrhdV0R5UzOqvPx04pfj5eMznzTfOk5vjI7JmBt/igDdpJEpJeDuTLPxswwGo18/NYb+z4f+bRbGlca8yQCFPIZ+vkjj7oAbpE/hoFLvfOmYHYo4B447feTw8qcrq6WLO5wh5PGfxo9glaKXmgDw9rOkfb7lhSrncAFE6Nr6OlNiAsR8PQ8YSE5isNSoZ27/2/8j7EiaqEDrfPctUoB43vMuNu+bsu5xRQ4yzwf4ITJZQU1/o78c8LojXWjNGwX9Ap6Y75etYzkTXS5rnEUly1TFXINBw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB3983.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(136003)(376002)(366004)(39860400002)(396003)(346002)(36756003)(8936002)(2616005)(956004)(316002)(8676002)(966005)(83380400001)(2906002)(45080400002)(478600001)(86362001)(66476007)(4326008)(6512007)(6486002)(6916009)(52116002)(6666004)(66556008)(66946007)(6506007)(16526019)(186003)(53546011)(5660300002)(26005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: LVE2l9e/c0YpXnJgMqkvUrGQnfEvQEUK41i+cyhV7/oxjbjlIdUktjRLDiycA8X95miM9+lxsUwhR7JwceKIeLiMybolqV6gNO9Dn/i5SMrlhFjtAsVF9cNZj9yOliAkDZO7UGbKTqgR9dyhe+Zg8TDyizvBLvGDWsjcqw2bl6hN9701aUnzbn5NT8ynnB3/VxtzWE2pVOISkzM9fl6qBhWELCs+vkJl8OXVRQOrYhb9+8rxdiBlXApJNWHAzDSaTXs2/Ye1ZEeYt/wYb1xr1SwmWIii4RvtLnVa3l8fmaG9HqLnhQ4iW0vozagxOO6232pkBw3XTCtVGe8WHUvZPeIm7O5ZhVsfY0T9MdAjDkNDMug6vnohuhM61MmDKE8qPBIVk7OAnsSxUxYwGRxAf4NE8zEwkOhL03/3W1ItOmztysxp7jU8xeehGR3cBbYE6mxSLAMmV5j2lhS2umkAoXxzMxcnDKgVaVGvHblX438=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f49b8261-c671-454b-0ebc-08d802ee63b9
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 May 2020 10:03:37.3008
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: yDrWEOIRYkZRDe5nA3GpaagDk3AMH9Qk191/KZOS7QDubPCDISbrRx9uA4+bH+VY1Khr6mILP7qy7+bqbFdBww==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB3184
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Marco,

On Thu, 2020-05-28 at 11:31 +0200, Marco Felsch wrote:
> Hi Liu
> 
> On 20-05-28 10:58, Liu Ying wrote:
> > Gentle ping...
> 
> Please check my "spring cleanup series" [1] which do the split:

It looks that your series doesn't disable both lvds channels in the
encoder disablement callback for the ldb split mode.
So, I think this patch still stands.

Regards,
Liu Ying

> 
> [1] 
> https://eur01.safelinks.protection.outlook.com/?url=https%3A%2F%2Fwww.spinics.net%2Flists%2Farm-kernel%2Fmsg789309.html&amp;data=02%7C01%7Cvictor.liu%40nxp.com%7Cd177bf874b8f41c404e108d802e9f179%7C686ea1d3bc2b4c6fa92cd99c5c301635%7C0%7C0%7C637262551086663318&amp;sdata=PIMNspESt%2BYqEMV1Vh0eBn5PNjKPfz5GdJ6NrnM2bUw%3D&amp;reserved=0
> 
> Regards,
>   Marco
> 
> > On Tue, 2020-05-12 at 15:31 +0800, Liu Ying wrote:
> > > Both of the two LVDS channels should be disabled for split mode
> > > in the encoder's ->disable() callback, because they are enabled
> > > in the encoder's ->enable() callback.
> > > 
> > > Fixes: 6556f7f82b9c ("drm: imx: Move imx-drm driver out of
> > > staging")
> > > Cc: Philipp Zabel <p.zabel@pengutronix.de>
> > > Cc: Sascha Hauer <s.hauer@pengutronix.de>
> > > Cc: Pengutronix Kernel Team <kernel@pengutronix.de>
> > > Cc: NXP Linux Team <linux-imx@nxp.com>
> > > Cc: <stable@vger.kernel.org>
> > > Signed-off-by: Liu Ying <victor.liu@nxp.com>
> > > ---
> > >  drivers/gpu/drm/imx/imx-ldb.c | 7 ++++---
> > >  1 file changed, 4 insertions(+), 3 deletions(-)
> > > 
> > > diff --git a/drivers/gpu/drm/imx/imx-ldb.c
> > > b/drivers/gpu/drm/imx/imx-
> > > ldb.c
> > > index 4da22a9..af4d0d8 100644
> > > --- a/drivers/gpu/drm/imx/imx-ldb.c
> > > +++ b/drivers/gpu/drm/imx/imx-ldb.c
> > > @@ -303,18 +303,19 @@ static void imx_ldb_encoder_disable(struct
> > > drm_encoder *encoder)
> > >  {
> > >  	struct imx_ldb_channel *imx_ldb_ch =
> > > enc_to_imx_ldb_ch(encoder);
> > >  	struct imx_ldb *ldb = imx_ldb_ch->ldb;
> > > +	int dual = ldb->ldb_ctrl & LDB_SPLIT_MODE_EN;
> > >  	int mux, ret;
> > >  
> > >  	drm_panel_disable(imx_ldb_ch->panel);
> > >  
> > > -	if (imx_ldb_ch == &ldb->channel[0])
> > > +	if (imx_ldb_ch == &ldb->channel[0] || dual)
> > >  		ldb->ldb_ctrl &= ~LDB_CH0_MODE_EN_MASK;
> > > -	else if (imx_ldb_ch == &ldb->channel[1])
> > > +	if (imx_ldb_ch == &ldb->channel[1] || dual)
> > >  		ldb->ldb_ctrl &= ~LDB_CH1_MODE_EN_MASK;
> > >  
> > >  	regmap_write(ldb->regmap, IOMUXC_GPR2, ldb->ldb_ctrl);
> > >  
> > > -	if (ldb->ldb_ctrl & LDB_SPLIT_MODE_EN) {
> > > +	if (dual) {
> > >  		clk_disable_unprepare(ldb->clk[0]);
> > >  		clk_disable_unprepare(ldb->clk[1]);
> > >  	}
> > 
> > _______________________________________________
> > dri-devel mailing list
> > dri-devel@lists.freedesktop.org
> > https://eur01.safelinks.protection.outlook.com/?url=https%3A%2F%2Flists.freedesktop.org%2Fmailman%2Flistinfo%2Fdri-devel&amp;data=02%7C01%7Cvictor.liu%40nxp.com%7Cd177bf874b8f41c404e108d802e9f179%7C686ea1d3bc2b4c6fa92cd99c5c301635%7C0%7C0%7C637262551086663318&amp;sdata=lNC4lwLUqM0upUxrrBtk1ap423lBIQlAAqDjdHv92LI%3D&amp;reserved=0
> > 

