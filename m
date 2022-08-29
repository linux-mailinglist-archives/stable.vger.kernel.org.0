Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 04AA85A4A59
	for <lists+stable@lfdr.de>; Mon, 29 Aug 2022 13:37:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232821AbiH2LhQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Aug 2022 07:37:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41724 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232600AbiH2Lg0 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 29 Aug 2022 07:36:26 -0400
Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 724E76F252;
        Mon, 29 Aug 2022 04:20:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1661772054; x=1693308054;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=K5sJIOtvD9V9mVlGbGtKISIHQn8jlO7+B5XnoT/Tnwo=;
  b=nI8CaYyy4RBOqZUrouRHhxb1Yi/kg5iR3HapfNwliEUsb+V9WvSbYefL
   vKoe5QXvGZ1DMrIYyui0gK5UKavxqDmp8D0lQMA/i3cFllV/z5Wm853M5
   aDZCKhfRBdCCcax7/xpfGRA0cCqwtbBM8KrfvGKXykRrQKxGDhbgPKw6e
   6lAR12xNdLw7uUSHYxF0VMz/1Mz0FBO1i17SiDiojox/1/L1bC0sxZY8d
   SctsJC7kV1inweaFkQRwthTlLy0WZNHHn4hEJUMEKP0OkpG/haK+ujWgz
   wSN+QyZstP8OdMIbALA0mO9SfrG15NL4RXoCbWgshZHDfUlb9jKTzOgTE
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10453"; a="320989328"
X-IronPort-AV: E=Sophos;i="5.93,272,1654585200"; 
   d="scan'208";a="320989328"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Aug 2022 04:16:48 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.93,272,1654585200"; 
   d="scan'208";a="714828674"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by fmsmga002.fm.intel.com with ESMTP; 29 Aug 2022 04:16:48 -0700
Received: from orsmsx607.amr.corp.intel.com (10.22.229.20) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Mon, 29 Aug 2022 04:16:48 -0700
Received: from orsmsx607.amr.corp.intel.com (10.22.229.20) by
 ORSMSX607.amr.corp.intel.com (10.22.229.20) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Mon, 29 Aug 2022 04:16:47 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx607.amr.corp.intel.com (10.22.229.20) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31 via Frontend Transport; Mon, 29 Aug 2022 04:16:47 -0700
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (104.47.70.108)
 by edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2375.31; Mon, 29 Aug 2022 04:16:47 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=D1VX8nCNh2HXncG8lCKJyrPY1Ev72OqPDZVlVpaBROSyZQONsJJkvSiJDmCWPzisavK4a23+sOAHenpleCHS76lZ7V4+ik/1Kd9qd4g5vAYz8woIOFEvcW+oZbH9+Iu7SsFPVnI9kyIUz/nUJo1AKlrBx2NrCjFAS/qENncDrMNFmYN4YYTZw4gXFW3Iz/d2F54pqHpLK8uDHLUTELZAx3RlabqDaE5MnDMs+/4yt/kz5aBYpk9e+CijhpliE3AnAutLQ/aL6d51n6SvoBDlUYcj6OTzXOUlhXlDMMmeMtvByiVp9rykdag74h5SK4iGo7c34odIU0z7B5a0OnhGBg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=SLB4s1grG0ju4/QKohsNqpu9Sx1sPYvjc+MBhmNwECk=;
 b=NjmPLXCbpxol/PV2jV+BKwwR6In9N4QdaoYkEtZxbRRA15CS/gecAvAMrhb7pYp0L58KqvD8HJo7f8MqEn9tpXNdRRRXltwCqzX0lMObJlwC/YKl9KzfFpE+Zi17dI15cexMDaRn5EylEGJg96YsU3jKKZ7Jz6a3kpvnDIGZpflkmhu+3UrZMOVDamBT/qlcPWrkfj2jnjwg1PJLpKhFkkY7sMAcm5eO8HtaLt1crFPTr0CQv+sIzhZLa9O4NPMkZbhR3giysvPcA2AtrY41ogFNJg3sdRgRP30MhubGAe6AnhaSTp3zZhTvjuYhOrFQEqAd+CRd/AaWUhbo3GnH1Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DM4PR11MB6117.namprd11.prod.outlook.com (2603:10b6:8:b3::19) by
 DM5PR1101MB2330.namprd11.prod.outlook.com (2603:10b6:3:a8::7) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5566.15; Mon, 29 Aug 2022 11:16:45 +0000
Received: from DM4PR11MB6117.namprd11.prod.outlook.com
 ([fe80::393a:df83:cb78:1e3c]) by DM4PR11MB6117.namprd11.prod.outlook.com
 ([fe80::393a:df83:cb78:1e3c%5]) with mapi id 15.20.5566.021; Mon, 29 Aug 2022
 11:16:45 +0000
Date:   Mon, 29 Aug 2022 13:16:40 +0200
From:   Maciej Fijalkowski <maciej.fijalkowski@intel.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC:     <linux-kernel@vger.kernel.org>, <stable@vger.kernel.org>,
        "Alexander Lobakin" <alexandr.lobakin@intel.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Magnus Karlsson <magnus.karlsson@intel.com>,
        "Sasha Levin" <sashal@kernel.org>
Subject: Re: [PATCH 5.15 042/136] ice: xsk: Force rings to be sized to power
 of 2
Message-ID: <YwygGA09Qtddbgw6@boxer>
References: <20220829105804.609007228@linuxfoundation.org>
 <20220829105806.324347516@linuxfoundation.org>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20220829105806.324347516@linuxfoundation.org>
X-ClientProxiedBy: AM5PR0602CA0017.eurprd06.prod.outlook.com
 (2603:10a6:203:a3::27) To DM4PR11MB6117.namprd11.prod.outlook.com
 (2603:10b6:8:b3::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 51e30f43-65ec-46a9-f2fe-08da89aff56f
X-MS-TrafficTypeDiagnostic: DM5PR1101MB2330:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: P50UmyhLEQXIOoT3t0R9EDB1zIfbd0zIHFJJSv0Pt7n27De4v00RwSdhQ5koV7YFy0BLBQt1IVM5nmjN7YszgE2VasdXEj9Qkklny5GLK+8OkQHrD6n9jHBj96FJe2Vgu8onvnOwVwNayFYnjKKp2wsYjzYgM4tjZ3uXJtF2GX0bPLQuY8ZBcpC9J93lMKQ63j4s40nqMO8LIQXbnsMCoNtFFqUERcWod0B7MrmcHNcvZt3UF+BUHeaNvHz7zjJ0d7GD1gCae6u3O5MFOvsoSC8YzV6nuZwuspT1G3z7TkBy45LVUmG/OoGbXnWC/7x4hMf27p6QPQ+fCJbm+nl/ZG16FQEUBXxvoZ7524MdplEEV/06/kUncKjX5E+4pMTe9+LcyIFtXYKX56sZ+PEFfXY8VWWcNBywQmxe5Cvupd7a7jfl/Uzfcx3ME6O/s28m9YWye1jnhPycF9peEqM7MXfdvW91D2Kq9Y5vrhZwMiXLaW+bkdUV/vJySt1oEXSHRpV3mqCuVrjbYEXzpDBKLDqorDNaR7Lw7mQueY+lTAUBbxnphIgt1ofBwzEPSTEvWgdKem0RAj6KRF4w0yF4jD74+vajvMNu3fSFNm1xHaZSQ6+4qS66mwnZlHbJwF7305WUu7LEUZruDPn4YjoycNSV1C+FZ0XyBnN1lfwSFM645yhNje4t2aP8bTiNRdiNPGvRLh74SbflMYr6u9yMTKVA+/e2522qoaV6PqGmPiRAAP1/0ful5myYRY/RL6PvRjTXi3xTq33zPlwyIgMPZf0Y0RGLHjwj9NAsgdTyPZU=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR11MB6117.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(7916004)(346002)(366004)(39860400002)(376002)(396003)(136003)(82960400001)(86362001)(33716001)(6486002)(4326008)(66476007)(66556008)(8676002)(66946007)(41300700001)(5660300002)(966005)(8936002)(478600001)(54906003)(38100700002)(316002)(6916009)(186003)(2906002)(26005)(83380400001)(6506007)(6666004)(6512007)(9686003)(44832011)(309714004);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?vWeh7uUiCKRSSDdBX+zW7YcMkUocUDTN024zMDdIPywygrHPDAosOVhYn7r2?=
 =?us-ascii?Q?SZyW2RNK7duojkT9+4OxcvU0TMsdCxfbTbJ2VWP07aG+MZ1HdbFMNfygwsvK?=
 =?us-ascii?Q?6LP4PgImmxs3XSOHvIeqXkkkqPcLe1hQpTAn/kM8DsmPXbzMiKHNsjozOIAw?=
 =?us-ascii?Q?EfZtHZMht1ZWXN4fhGTPnyQ2dFK9NIw+DRGzEHIfGIresIOiG0v2N2BsImNt?=
 =?us-ascii?Q?oLyd44lqjwILbCqn1wMsOvZSOv7CRAmJOaVJ5sYxf3g3Qs+xz7JedjYmrQ03?=
 =?us-ascii?Q?fQxXdOBUmn3NQ1i84kadXY9IAQnHXkP74aK5GgofvexTkEtby3jeUyVGJ+BC?=
 =?us-ascii?Q?gG98haY6OReF2OEtHU5ZRB1/SjJJcY8UD4KsLXW4CwKKqYUWRZoCureZheiT?=
 =?us-ascii?Q?pAmNJpwiYSVr65dVvzc8KeKKQpX2oOYFGXNjt0tI7AGW3Hj+Wf5oNY0+aTTJ?=
 =?us-ascii?Q?y33UEI5IY05YLDZbJyp+VGHqKk5l3/3eoKF62Q64vpKaSv3cUD3tRoWUdy73?=
 =?us-ascii?Q?f09fLXXXMqaEC/heOvm7QOaXs7jShm+XyCMvK8gwq+b/XtyYcmoLtwxMn7b0?=
 =?us-ascii?Q?7o/mwLgzv47S5uendB33urx5aIeCpuQaHt34U/fKs4YOtNU/GBalWWvHckDy?=
 =?us-ascii?Q?ZLCqDXr1Jev1GQyL0t4GQQFNwrediuufTsdF2TaLaUfNXJl3T79Nql3+9jNY?=
 =?us-ascii?Q?g+ZV+hpIUco0Dv+KgLTlI3kIDIHeoVwmuGNne3kNUKzReWp0KfJushEaAVcE?=
 =?us-ascii?Q?zG+JJx47srbfvZLZD3jWr5VRf9DGyFr/OpQrfgmjmj2DLsF2D64z2ATB4sr1?=
 =?us-ascii?Q?pzdhMQoss1ADdMBl+MSZqKiqwGozw3qJ17LzBO1gQktF7gAB0v6Zs7ttRQA+?=
 =?us-ascii?Q?q0Iim1aRluxmUmO4dVG7kWmHDXJcHPiQHr9NSa89uTG14tQldRzJL6/LnmGR?=
 =?us-ascii?Q?40hNParmI0ZUYm//bdI/a52Ow/H+M0jdyKNnIibHpWuLEOqEcfqf04nQ1EhD?=
 =?us-ascii?Q?8F3P77Lf5wxadPztCGqkmZTBTGO84ouGal7JNdW4aOI3GZbGOxL8CyNFvReL?=
 =?us-ascii?Q?DBmc5xPAvtrU17+xk/+rIltLks5OK5DpDdHI7Dzr9rHfzj0Q4j7Jlu6b2YB1?=
 =?us-ascii?Q?ThkgyrHr1J1yd1ftFmyVivgDj3+RSuM/CrD0zec3QaRr6eeTs8eRLtoT80Xn?=
 =?us-ascii?Q?9E/O2QFzw1Gd/ESo3oc9UT1Q7Wta8ycQgYj7Yx7deYO1uYHCV19d1YhHUB5z?=
 =?us-ascii?Q?Uhcm+8FU3Ri/vT56ZamXuJWm7u/bLBtbqrjLmtDgK5wU5elHY4AHMd2HVPyi?=
 =?us-ascii?Q?nRRFrgdwELDVFmQROl7PwD795G7En5hkMmPa8vPuJoEi1813KLYc5B7QVaru?=
 =?us-ascii?Q?UDpTJhvxF7y/b+qQE7ey1ciRGmXgMbi0UxHl/cAMdw0nNibVe4NUOzZL3fyp?=
 =?us-ascii?Q?f3J70zAn4O1fWIS0rrpGRaB29M3xLP/OdZj3QjmzKMsdKjc91oFqqUE+5YtM?=
 =?us-ascii?Q?te2DvKHhS9FPLWaOTkgCU/LkUltkSM3DWSde/KN2nAwC+26Irq5DvWN0OK+V?=
 =?us-ascii?Q?JCQukZklcwqY4pMOBUCD1iMnLKDGVbmVbshNhLxmvRhq4W2xUbTvLlU81qWE?=
 =?us-ascii?Q?bQ=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 51e30f43-65ec-46a9-f2fe-08da89aff56f
X-MS-Exchange-CrossTenant-AuthSource: DM4PR11MB6117.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Aug 2022 11:16:45.7164
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: +9n13LTa0iLD1JSXr8ucaoKJmF6yhGj7mxemJaa2Xn9yI+GkSizf9pGNJ131FaFpZXxMO7jJxxc3jJNEbYtkmNSUwQKmmFzNBpcx6iBjBjQ=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR1101MB2330
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Aug 29, 2022 at 12:58:29PM +0200, Greg Kroah-Hartman wrote:
> From: Maciej Fijalkowski <maciej.fijalkowski@intel.com>
> 
> [ Upstream commit 296f13ff3854535009a185aaf8e3603266d39d94 ]
> 
> With the upcoming introduction of batching to XSK data path,
> performance wise it will be the best to have the ring descriptor count
> to be aligned to power of 2.
> 
> Check if ring sizes that user is going to attach the XSK socket fulfill
> the condition above. For Tx side, although check is being done against
> the Tx queue and in the end the socket will be attached to the XDP
> queue, it is fine since XDP queues get the ring->count setting from Tx
> queues.

Hi Greg,

We had multiple customers reporting that this change makes them unable to
use max ring size which is 8160 for this particular driver (which is not a
power of 2 obviously) so we are about to send a patch that will drop this
limitation.

To avoid the double work, can you please not proceed with this one?
The other two:
ice: xsk: prohibit usage of non-balanced queue id
ice: xsk: use Rx rings XDP ring when picking NAPI context

are valid and needed.

FWIW this was a part of -next patch set, so I suppose you picked this due
to some dependency?

Thanks,
Maciej

> 
> Suggested-by: Alexander Lobakin <alexandr.lobakin@intel.com>
> Signed-off-by: Maciej Fijalkowski <maciej.fijalkowski@intel.com>
> Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
> Reviewed-by: Alexander Lobakin <alexandr.lobakin@intel.com>
> Acked-by: Magnus Karlsson <magnus.karlsson@intel.com>
> Link: https://lore.kernel.org/bpf/20220125160446.78976-3-maciej.fijalkowski@intel.com
> Signed-off-by: Sasha Levin <sashal@kernel.org>
> ---
>  drivers/net/ethernet/intel/ice/ice_xsk.c | 8 ++++++++
>  1 file changed, 8 insertions(+)
> 
> diff --git a/drivers/net/ethernet/intel/ice/ice_xsk.c b/drivers/net/ethernet/intel/ice/ice_xsk.c
> index 5581747947e57..0348cc4265034 100644
> --- a/drivers/net/ethernet/intel/ice/ice_xsk.c
> +++ b/drivers/net/ethernet/intel/ice/ice_xsk.c
> @@ -321,6 +321,13 @@ int ice_xsk_pool_setup(struct ice_vsi *vsi, struct xsk_buff_pool *pool, u16 qid)
>  	bool if_running, pool_present = !!pool;
>  	int ret = 0, pool_failure = 0;
>  
> +	if (!is_power_of_2(vsi->rx_rings[qid]->count) ||
> +	    !is_power_of_2(vsi->tx_rings[qid]->count)) {
> +		netdev_err(vsi->netdev, "Please align ring sizes to power of 2\n");
> +		pool_failure = -EINVAL;
> +		goto failure;
> +	}
> +
>  	if_running = netif_running(vsi->netdev) && ice_is_xdp_ena_vsi(vsi);
>  
>  	if (if_running) {
> @@ -343,6 +350,7 @@ int ice_xsk_pool_setup(struct ice_vsi *vsi, struct xsk_buff_pool *pool, u16 qid)
>  			netdev_err(vsi->netdev, "ice_qp_ena error = %d\n", ret);
>  	}
>  
> +failure:
>  	if (pool_failure) {
>  		netdev_err(vsi->netdev, "Could not %sable buffer pool, error = %d\n",
>  			   pool_present ? "en" : "dis", pool_failure);
> -- 
> 2.35.1
> 
> 
> 
