Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B2C3E4C653E
	for <lists+stable@lfdr.de>; Mon, 28 Feb 2022 10:02:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234177AbiB1JDW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Feb 2022 04:03:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41728 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234289AbiB1JDO (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 28 Feb 2022 04:03:14 -0500
Received: from EUR05-VI1-obe.outbound.protection.outlook.com (mail-vi1eur05on2065.outbound.protection.outlook.com [40.107.21.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 82F3E9FD7;
        Mon, 28 Feb 2022 01:02:36 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=b6gWrDCQgal1WU7LpHipW8lJgsRbAHKFVOHtr22+zHiV6YBwqWuIUuFcS5yuCEJGCHCVqFpepHXvVcHFC/7i6UpDqP4jULQgHU0zvf5/RmzUnsKBodnsB6EMAnutYmMTxStlvWxV/WuwdxnZ91qankBTxh5YPefWZ1DlGXwnVkW0oJe33J6B6E7cVIpREbj8wdpEaLBHWzC0RdqHkBW9mmaWNiBG6fEDju8Eo5PmdOKD4yZQw0Yk0s87Mr+0Dy/Ag9fmGtfkdOxskO9gZdlEt/8ljM2N1w3SsRY83nmvlR0TQYhYMxJ3VMKFcpnRouWE2MIzby1Sq8DRnlK8827AVw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=OA6pnhE+2RmvYs9ns/e0hR2fGC6LvEILfC5YKRSL9MU=;
 b=fddu/hqmMrcezCM98WTu2H+sU4sbzlCFWRZUDQdO89W5WqCGQRHqdNBERQa/l1Pw9l9qxB82uKujeNJ/1GGbJm3xjb3tFpyJeEmuLTVQjzz+lHnpfGoO5/TkcU3TZWU1XUTVPl8gSFPC1O7caUjYJ+vy0tbbpVuP0xDD1ACDRKQHSyZ5VU1XVRxHM5r3zfba3NmWFECSoVcHdWay0qwdRv10DqfNGkDmSnCjL6JMja1LSR04FkkBToPS3eXd+Ra8GPBh5FWW1Er0hh0EzI6dCv/BZbPU5J8/v+hd42+qARNWNCEzJdiG6aGwPlzQ4Ep7o8vsl3AVwDNGmgkFZHNDhQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oss.nxp.com; dmarc=pass action=none header.from=oss.nxp.com;
 dkim=pass header.d=oss.nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=NXP1.onmicrosoft.com;
 s=selector2-NXP1-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=OA6pnhE+2RmvYs9ns/e0hR2fGC6LvEILfC5YKRSL9MU=;
 b=HW1ffYEJP0zp2Fq+rtcRkYxMt2yOETQdCmUzfvj1nOW8VcYf0+Rr7D9gTLTFC17xOwa5LXqlpJhmzfmtWBPur0gNSIywWCbGiHxt2HtFqqdH2FOA0jNCeTVxGTcZevyp7fOoOror/NHTUJDpe9HPuq6tTb13DjR7jRaL2EG8jKg=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=oss.nxp.com;
Received: from AM7PR04MB7046.eurprd04.prod.outlook.com (2603:10a6:20b:113::22)
 by VE1PR04MB7278.eurprd04.prod.outlook.com (2603:10a6:800:1b1::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5017.25; Mon, 28 Feb
 2022 09:02:33 +0000
Received: from AM7PR04MB7046.eurprd04.prod.outlook.com
 ([fe80::ddca:beb1:95b0:1ae1]) by AM7PR04MB7046.eurprd04.prod.outlook.com
 ([fe80::ddca:beb1:95b0:1ae1%4]) with mapi id 15.20.5017.027; Mon, 28 Feb 2022
 09:02:33 +0000
Message-ID: <6344d1828760d4d8625a87243fcc5f5b1096b9d4.camel@oss.nxp.com>
Subject: Re: [PATCH 2/2] drm/atomic: Force bridge self-refresh-exit on CRTC
 switch
From:   Liu Ying <victor.liu@oss.nxp.com>
To:     Brian Norris <briannorris@chromium.org>,
        Andrzej Hajda <andrzej.hajda@intel.com>,
        Neil Armstrong <narmstrong@baylibre.com>,
        Robert Foss <robert.foss@linaro.org>,
        David Airlie <airlied@linux.ie>,
        Daniel Vetter <daniel@ffwll.ch>,
        Maarten Lankhorst <maarten.lankhorst@linux.intel.com>,
        Maxime Ripard <mripard@kernel.org>,
        Thomas Zimmermann <tzimmermann@suse.de>
Cc:     Jonas Karlman <jonas@kwiboo.se>, linux-kernel@vger.kernel.org,
        dri-devel@lists.freedesktop.org, Sean Paul <seanpaul@chromium.org>,
        Jernej Skrabec <jernej.skrabec@gmail.com>,
        stable@vger.kernel.org, Sean Paul <sean@poorly.run>,
        Laurent Pinchart <Laurent.pinchart@ideasonboard.com>
Date:   Mon, 28 Feb 2022 17:02:35 +0800
In-Reply-To: <20220215155417.2.Ic15a2ef69c540aee8732703103e2cff51fb9c399@changeid>
References: <20220215235420.1284208-1-briannorris@chromium.org>
         <20220215155417.2.Ic15a2ef69c540aee8732703103e2cff51fb9c399@changeid>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.4-0ubuntu1 
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SG2PR04CA0167.apcprd04.prod.outlook.com (2603:1096:4::29)
 To AM7PR04MB7046.eurprd04.prod.outlook.com (2603:10a6:20b:113::22)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 8de38c92-49f0-485c-5579-08d9fa990e8b
X-MS-TrafficTypeDiagnostic: VE1PR04MB7278:EE_
X-MS-Exchange-SharedMailbox-RoutingAgent-Processed: True
X-Microsoft-Antispam-PRVS: <VE1PR04MB7278DECABCD26B9AFADF37FAD9019@VE1PR04MB7278.eurprd04.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ienPtfAj5eIkqZxQoe0Prq15gvq3CRTLeZww5cEeToajQahFQuvhpnhiabAfiqmLBh2BO9ngndlOEEP7UQeBiMCkOZRCS49B9R7y+WBxdN3g8kax84qHKrg1S4+lVA66GByEzKBFtmq2dQb5GLNyk4xLCQ1JF17u1ZEoSqevRGMRh4vezPgJn8rHHnlCzsnkciaWo2EjyLffyl4WxaloUoP1edGYAnxu4YFExqogEy+GAZ+/ih2Qg+rPrPFYg9sAU/noPU7E785qLTCcOqizhnHX4weGB2TsoY+/sKB5DMNXZOc7GzfcaNbdwvZ3Zcq0ZmRILVJQd45RQdVmj8SO7TYU0KH/hh5w52D+Pdydhzp7hjn7uGuJANzY1hA7Y82mL1oORDTftsEMnf0fbAYp/L8HwEPO59Vx0M+D07fM6C6DUFue29bB2MPlIaEW7tzWrGmm08tKpGOUmrr8VSVCJb1v6gUosqI4BHQpXM8kn1RHryI8QZyBfqP6SQ3vOYlY/94Q+MFGfA80XBl75irNS3TIlywFFvGIGTyeG9PVGNhWly7ZLrJ9XPbM+kOOUh5B/IsovBBL7sXNZOjgbWsINakcAoDmqntQjUX3QIbU//+a7W1StxAHUA0DPuRq1Pi/28nYkbV+Mgm3TqlbJSEoQ5Y65Q/h7dIi8FDdwnpZDii3pVFaqTrJtXl3IuvOFu2qx/J2ppCrpxfkItwWZIx1Mg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM7PR04MB7046.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(8936002)(2616005)(6512007)(66946007)(86362001)(66556008)(4326008)(66476007)(6486002)(8676002)(54906003)(38350700002)(5660300002)(316002)(508600001)(52116002)(110136005)(38100700002)(26005)(186003)(6506007)(2906002)(83380400001)(7416002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?aWp6RElxMUZ4SzlwRXFqOXFHQ2JVYU5kSFo4am1HbzR1Tm12OHhJNmRsY3c2?=
 =?utf-8?B?WkgrWWw0Vncxa0NjOGZLTkgycG0zN2gvemx6OEJaMytvaktnNkJ6YlpHZENS?=
 =?utf-8?B?aTluNWdjejZZN29rRFRCeDkvQ3VzQnkxWnFZVy95UDdQQ1lxcUtSRUtnUW5p?=
 =?utf-8?B?TnMxMUVDckJxMVBySmtqZzVQWDdaWjNuZjVlZzArdGNjcHZ0QzQ0UE5yV21i?=
 =?utf-8?B?U2djUTlTL1dZTlR1MWVnbjRWeG5sSXJhT3ludjQ0ZmhQUXZCQWZVTjh1c0hr?=
 =?utf-8?B?RGM1VGsvOGlyaTVzejBWYnZTbmJZajVvNlNNM1lMbkcwT2diRWdEVXBlaWtB?=
 =?utf-8?B?aUxITWF5eEpGV1NzNk02aTVsYVYzakpmdWJYOU9SZTV6WW5vZFNiUVFGZGhM?=
 =?utf-8?B?dCsrd1dkd3JtY0R6NDlaZW5TeTdxb2U1Ui9hSXY0U1FnQXlXYTVpSGpBSHdP?=
 =?utf-8?B?SWRjdlZhTWVBOEVkOG43KzE2dzVxcXhwbG41dUticGhpaWdpTFo2cVR6eXU2?=
 =?utf-8?B?cTRqVnRpYVNaWHZ0dmx0L1JiY2E5RG9oSTFwOW5SYTNGZyswNWdWdGZ2R0ZP?=
 =?utf-8?B?bWhNRHVaRnFzdmphVnlqbWJBN0JCNldPWVJhT1dlSWZ2a1hhVlBjbHlmN29P?=
 =?utf-8?B?L1kyWG5BOEZiMHlxeERPeHFDY1l3UXVWdkRLaDZvcUJvczlsbTZFdDdzTGJJ?=
 =?utf-8?B?eDhxajlISmRhSS9mWGxFdUFxMG93SGtQZ3JHZFNIUmhPM1gxckNvbU16MHBW?=
 =?utf-8?B?YUlzL3krMS9Md05iMDM4Z1pPZFFsUTNlejlVYzBTd2ZucWo0WEFkV0xZS0JE?=
 =?utf-8?B?ck42QzBWeVZEVlk5dVRFZmYydzlsZGJIbGphM0FKUTNMSG9pTHArdkZNWEZv?=
 =?utf-8?B?aW9raWt0S3lORWo5RFJKUmwzRm1vbkgrY2U4L2gyVTM1OFFQZWorbVR4YkRi?=
 =?utf-8?B?T1NXMmtndVkwYlVkZTJhNzNCS3NxLzFYeXJtN0tQWm9WT2pEYmsvZGhEWmRz?=
 =?utf-8?B?OC9hdE0yQ3IyN2l4NW9MaTNFTURENWJ2SmNVejB2Nzg1T3d1aUt2bDhjdEFW?=
 =?utf-8?B?S0EwK1R4Ni9zKzRTSm1hNXIzN2N5aDRsdmRqWGQyL3VJS0QyUzNCb1Y3L092?=
 =?utf-8?B?ZlBZanVNYjB5dVZ0aFc1azIzS2kyUm1KZVFxUlNyZ1lJaWZyOXVNODRCd3NI?=
 =?utf-8?B?b2xQMUNZU2xmS1l2emZJOVNvQzZEZFdocEtoUUZibXZqU01walRHVXRzQVpm?=
 =?utf-8?B?MVdGOVk4cFBEbWJiMEMvbkhVMitJUUJzaWJIbGVDOG0vUVdJRUpRWkJoSzhF?=
 =?utf-8?B?b1hMVGFnKzBYSHRGSEV5eHZ5VElvclIzemx0Y2tWaE1EUGhQcC82T3YxU0lm?=
 =?utf-8?B?MmdoR2VKeCtaVG5BRjhxOGE4aWJ4WElXWE1XQU40cU93NjVMUHg2TFd3UkxQ?=
 =?utf-8?B?UFdRWXhpRWt5R1FLUTRxRnZKdVJ2eTBweUhmZWZkeThPeXRXSmFXY3FHZVFo?=
 =?utf-8?B?UjNCMlRLZFIzT09QeWFjbkp6QmdJOUgwVTNjZm1ndlNzSGVEZURhZnVjRWlr?=
 =?utf-8?B?NVJTR2pYcWRxeWpHQXM2UXNKNzQzU1dEZUxab3U4RGttVDRwSTk0MEp1eFZy?=
 =?utf-8?B?WGhNQzR5QWdUQkRKSWRxWVVVL3gvaDJhdk04MkNpcGlRYkRKR3pNdGMxbmdp?=
 =?utf-8?B?SkxNbms5WDQyMXN3ZHlmcFN5MDFmKzZNUW4zRGRJVjhiLzZsd0FMZklDbmQv?=
 =?utf-8?B?NUsybEViSi9IcUtHQUltUk8rWCtaRmEvTWJHekRHYkZia0QzMTE3SzY3OVM4?=
 =?utf-8?B?bTNsNXB3akdoYURabytLRkVaSXcwbk1Cd0NBa2xKNkFES0tjV3gwUkh4eWZq?=
 =?utf-8?B?K2R0Z0x1TVV2Y1JoRDYvb3FDL0NyTTVLVzlCa1ZSNlh1Qy9iMjgyMjQyYlFY?=
 =?utf-8?B?alNJS3ByMmFlUTBhaGxLeS9odHJ1bGg3blpRUS8vb21MRUFqNHlTVGFjZ2ht?=
 =?utf-8?B?b0VBTms1bFYwcjBjNVZaVi9rZ3I3N2hWRjhaK0h2eWVLMjd3dzV2TXM0ajdH?=
 =?utf-8?B?azRnUGZYKzV1MkZlYzA3UjhuY0FNOXROdU4vOHpReFNjYnFXRlpRSktRZ1Rv?=
 =?utf-8?B?RCt1U2ZaU3JNZXl0UDU0azVIbzU0Mk9sQzhjYjN1UHpTcHBTSVRQZng1Rkdx?=
 =?utf-8?Q?20NNR4ujESL4Q2RpuNTo/Sw=3D?=
X-OriginatorOrg: oss.nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8de38c92-49f0-485c-5579-08d9fa990e8b
X-MS-Exchange-CrossTenant-AuthSource: AM7PR04MB7046.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Feb 2022 09:02:33.4666
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: IKSS/8q4kC+/krDnDRixZosioDJfJ0WhNJTI6DS66I6L7AigyWCkiq9jLZWRdAZKRTnzVW5J+dtBftbWxv6rAg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VE1PR04MB7278
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Brian,

On Tue, 2022-02-15 at 15:54 -0800, Brian Norris wrote:
> It's possible to change which CRTC is in use for a given
> connector/encoder/bridge while we're in self-refresh without fully
> disabling the connector/encoder/bridge along the way. This can confuse
> the bridge encoder/bridge, because
> (a) it needs to track the SR state (trying to perform "active"
>     operations while the panel is still in SR can be Bad(TM)); and
> (b) it tracks the SR state via the CRTC state (and after the switch, the
>     previous SR state is lost).
> 
> Thus, we need to either somehow carry the self-refresh state over to the
> new CRTC, or else force an encoder/bridge self-refresh transition during
> such a switch.
> 
> I choose the latter, so we disable the encoder (and exit PSR) before
> attaching it to the new CRTC (where we can continue to assume a clean
> (non-self-refresh) state).
> 
> This fixes PSR issues seen on Rockchip RK3399 systems with
> drivers/gpu/drm/bridge/analogix/analogix_dp_core.c.
> 
> Cc: <stable@vger.kernel.org>
> Fixes: 1452c25b0e60 ("drm: Add helpers to kick off self refresh mode in drivers")
> Signed-off-by: Brian Norris <briannorris@chromium.org>
> ---
> 
>  drivers/gpu/drm/drm_atomic_helper.c | 16 +++++++++++++---
>  1 file changed, 13 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/gpu/drm/drm_atomic_helper.c b/drivers/gpu/drm/drm_atomic_helper.c
> index 9603193d2fa1..74161d007894 100644
> --- a/drivers/gpu/drm/drm_atomic_helper.c
> +++ b/drivers/gpu/drm/drm_atomic_helper.c
> @@ -1011,9 +1011,19 @@ crtc_needs_disable(struct drm_crtc_state *old_state,
>  		return drm_atomic_crtc_effectively_active(old_state);
>  
>  	/*
> -	 * We need to run through the crtc_funcs->disable() function if the CRTC
> -	 * is currently on, if it's transitioning to self refresh mode, or if
> -	 * it's in self refresh mode and needs to be fully disabled.
> +	 * We need to disable bridge(s) and CRTC if we're transitioning out of
> +	 * self-refresh and changing CRTCs at the same time, because the
> +	 * bridge tracks self-refresh status via CRTC state.
> +	 */
> +	if (old_state->self_refresh_active && new_state->enable &&
> +	    old_state->crtc != new_state->crtc)
> +		return true;

I think 'new_state->enable' should be changed to 'new_state->active',
because 'active' is the one to enable/disable the CRTC while 'enable'
reflects whether a mode blob is set to CRTC state.  The overall logic
added above is ok to me. Let's see if others have any comments.

Regards,
Liu Ying

> +
> +	/*
> +	 * We also need to run through the crtc_funcs->disable() function if
> +	 * the CRTC is currently on, if it's transitioning to self refresh
> +	 * mode, or if it's in self refresh mode and needs to be fully
> +	 * disabled.
>  	 */
>  	return old_state->active ||
>  	       (old_state->self_refresh_active && !new_state->active) ||

