Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5AF526DDE0C
	for <lists+stable@lfdr.de>; Tue, 11 Apr 2023 16:35:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229525AbjDKOfm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 11 Apr 2023 10:35:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51392 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229799AbjDKOfl (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 11 Apr 2023 10:35:41 -0400
Received: from mga17.intel.com (mga17.intel.com [192.55.52.151])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BC9D010EF
        for <stable@vger.kernel.org>; Tue, 11 Apr 2023 07:35:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1681223738; x=1712759738;
  h=date:from:to:cc:subject:message-id:references:
   content-transfer-encoding:in-reply-to:mime-version;
  bh=QpXRGd4MFHHq1fOU+ZlexJRWWPmNnWZy6qEFEi/i5j0=;
  b=P/rxtQvm72Sk5pfTLaT8rLUR0B7hWsgpmwTCOU3fPiCaf47pATCeX0q2
   RLkCtSai6v/h3j1KRYmZJqriyKfKBiCVHpXPvXbL0mObWJLD9dgDo6/pg
   rm7nLSEnOPtqFwE8cbVd1xmLJqs/1+l0zU7oANh83pjR4N6+nAAm/DHS1
   CaXY0kfX6Vt1sMLFVdmkCbvL9R8W+oeSmMl3URZ73DYV+w2cR6vrbQ5Wg
   dLZdaRqHveYrY0aFCrC8z8et+Jxl1HXVL0QnNfXLgaPEQPNINwazcAMS8
   dNUedAVrwRRVIQAmEBx+xxTrXnfWd/xAj+ZYB5uimiSbJ10Q3AsALFnTV
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10677"; a="323993826"
X-IronPort-AV: E=Sophos;i="5.98,336,1673942400"; 
   d="scan'208";a="323993826"
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Apr 2023 07:35:38 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10677"; a="812584449"
X-IronPort-AV: E=Sophos;i="5.98,336,1673942400"; 
   d="scan'208";a="812584449"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by orsmga004.jf.intel.com with ESMTP; 11 Apr 2023 07:35:37 -0700
Received: from fmsmsx601.amr.corp.intel.com (10.18.126.81) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Tue, 11 Apr 2023 07:35:37 -0700
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23 via Frontend Transport; Tue, 11 Apr 2023 07:35:37 -0700
Received: from NAM04-MW2-obe.outbound.protection.outlook.com (104.47.73.168)
 by edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.21; Tue, 11 Apr 2023 07:35:37 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=TsWs1hnkIlmz+yBdmY1SryILJY36D8Ed2bn4Z67rD4ocdH79nlpjM0twc9/3nAaeaz9qYZ7D23YfhejrnDZT/RTHv5FP9tVbv2BcYRECRMjs6TcmqDvWkT78VH0ghXA3X8qhuMh2V5Um1z0GkcFca21lu49GQ0F+W7cox6uSqUNxGUihy3cRcNhyK0KKb85rQ6AAhjIkvH2Q/sPngtt+eBoRcVGWew0puE68oginqV447+ylXFJrHQ4NJiTiwi2agRm4Mlq2hPTjCno5ZJgObDLBycQq7VkkLphpqpG4Xs1jDA21amRDewIK8Gr6k0hX6iHV43GpeRAwpgMoAYmngA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=M1jcBUbB6wiFgbp22VSms1W0B7l22XOeyINFLKIG4Bw=;
 b=T7Yxw4Qqif1u+t6VHoqTrK+KAJQuXlbsdnWTsVN0yI3JJq87WxXzGstwmiEznNqWqdlkQPxtLqdkSvkDL/TDOs0hlrtVn14AKtXQKK0jmXg9woEMAbQBG7A0t3Z2ThE1FNfuS2+VMlJllHkW9+S4igEfSlK6zI7GLAmQIGDhUCdjs93v6sgiWF6fTLHmWbs+n2zJ0mXh432RTVc9qCSqchw3gp8LAOtiTnjjpHkU4JVplKQj6gT6IkzGknfopv+4P+AJ2XnqNFQRAYmaeeQAqxg2Z/ViUC4mjfTI2Vx1+H4l1w1qPyc8qt365upOGClRKU88lTEbRUlnKbOLC3Y8Dw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from MN0PR11MB6059.namprd11.prod.outlook.com (2603:10b6:208:377::9)
 by DS7PR11MB7690.namprd11.prod.outlook.com (2603:10b6:8:e6::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6277.34; Tue, 11 Apr
 2023 14:35:35 +0000
Received: from MN0PR11MB6059.namprd11.prod.outlook.com
 ([fe80::2b57:646c:1b01:cd18]) by MN0PR11MB6059.namprd11.prod.outlook.com
 ([fe80::2b57:646c:1b01:cd18%6]) with mapi id 15.20.6277.036; Tue, 11 Apr 2023
 14:35:35 +0000
Date:   Tue, 11 Apr 2023 10:35:29 -0400
From:   Rodrigo Vivi <rodrigo.vivi@intel.com>
To:     "Das, Nirmoy" <nirmoy.das@intel.com>,
        Joonas Lahtinen <joonas.lahtinen@linux.intel.com>,
        Tvrtko Ursulin <tvrtko.ursulin@linux.intel.com>
CC:     Andi Shyti <andi.shyti@linux.intel.com>,
        <intel-gfx@lists.freedesktop.org>,
        <dri-devel@lists.freedesktop.org>, <stable@vger.kernel.org>,
        Andi Shyti <andi.shyti@kernel.org>,
        Chris Wilson <chris.p.wilson@linux.intel.com>,
        Matthew Auld <matthew.auld@intel.com>,
        Maciej Patelczyk <maciej.patelczyk@intel.com>
Subject: Re: [Intel-gfx] [PATCH v4 5/5] drm/i915/gt: Make sure that errors
 are propagated through request chains
Message-ID: <ZDVwMawvlOLZ2VZt@intel.com>
References: <20230308094106.203686-1-andi.shyti@linux.intel.com>
 <20230308094106.203686-6-andi.shyti@linux.intel.com>
 <1bee29d0-a5cc-9ff3-d164-f162259558e2@intel.com>
Content-Type: text/plain; charset="iso-8859-1"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1bee29d0-a5cc-9ff3-d164-f162259558e2@intel.com>
X-ClientProxiedBy: SJ0PR13CA0106.namprd13.prod.outlook.com
 (2603:10b6:a03:2c5::21) To MN0PR11MB6059.namprd11.prod.outlook.com
 (2603:10b6:208:377::9)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MN0PR11MB6059:EE_|DS7PR11MB7690:EE_
X-MS-Office365-Filtering-Correlation-Id: 81eb0da1-1bfc-4922-ac0e-08db3a9a028d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: gDOoaLcQPOSen4pl7h3uu2eZIbXA80kReqnBlF9GYs9uonBuhk3fvfkspbtB6FtC8uNJMr3KEOV0AqUU0gD7yR3xt5t2So2wIdMppNgWGtZNmA1yVuRA5cwNxJXrHxh+YENfjNlaGqbG9YmiutFIKhOSvVFDVrJxGkhVz7XauYHF6s7sYsJhJmoWyV2Apmt/sa4PSQErfVNfaNtPr4W5YA856mLI1f3QGFncWmOU+5iVmUH1Yx3T3cKVg3bH4YURpacTjcWA2o3JevGPp/B8m+IcmEqlxouOPGfSx70s7KkdRovPYiij3bd9tVjn/6r2ylTzuygHlUu1Bk1IPqBCjABnmR8IuOfH9LTOBs99AV5iWX4SrW5VnDl87dgTUaY46mnm574qijaylSoYEoCM8Zc6c1pVh/62qre8yrGmZF30OhVSRx0IbZle5OPL9ygeanc4sbFrlnpBdzdmrBFr7xdA10JORoDwb67af+e56/Fzc18UUz64LtDTAGvkS4O04jjE0LItuxbcyhKcCM/qc2wps6eMsQQnkF/fYBkKiBcNE+o9IjH2Q7PcjLTm63oK
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN0PR11MB6059.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(346002)(376002)(39860400002)(136003)(366004)(396003)(451199021)(110136005)(316002)(478600001)(86362001)(54906003)(82960400001)(44832011)(5660300002)(8936002)(66946007)(66476007)(38100700002)(36756003)(66556008)(2906002)(41300700001)(8676002)(4326008)(83380400001)(6486002)(186003)(2616005)(53546011)(6506007)(6512007)(26005)(6666004);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?iso-8859-1?Q?cOuycNr0tPumbuIkZdAJXtwkfAdd1/bgFRhoHu/M0MjERXcaCY3U1zwMX6?=
 =?iso-8859-1?Q?YTVQecO22Ln498SJkyc19Hku/IrDS7E0ysqlR+Pk6vwXMLli2phfG72Ejm?=
 =?iso-8859-1?Q?EeUdY31PtSQ7LVPnkMJbk6hMB3/KkhqRi/hiBgfSFqlVgWRqluIBguKUkS?=
 =?iso-8859-1?Q?xddZtSwykV+RwOatWXtl8i9Wo2SHN10ffBjxE4a0uKLNGVeiGBFU53f7dT?=
 =?iso-8859-1?Q?zq3R98KU+m+HHEceP0BGYQD+uZn3r0NzIEaeFJ4qypafyEuIB+cCkxPqup?=
 =?iso-8859-1?Q?rKj1Iz2oJueVFRZYHdFfCiNYPBcHRPyjKTatAY1+RlU+ZHREPojfTgCbKQ?=
 =?iso-8859-1?Q?W/TtTHX9+839ibKxDmFI0pT0sk5efKNiCzQoy2r7yOWzDWEbx1OIyEpowG?=
 =?iso-8859-1?Q?9MoGhVY52MVVatPZL2QN8wINKAR9vfTq0mSc2FiatIUJPyl+GRdCiIbjRI?=
 =?iso-8859-1?Q?AFkRojlSbs1bS6rgGSEFzt15I6zDItVS60VCEwg5/6kLTtWt64EcqgrCC5?=
 =?iso-8859-1?Q?k32jDm+n5PoThgrWktg4bJ7nvYcpTdITBsmbzT1zsYdmQaV57mJHnfItqk?=
 =?iso-8859-1?Q?q+KWBJbuiyoJ2YAFWFPi/CgXEbBSlXE7xq+gnW8ZK9qKuOModJwIYWVjVk?=
 =?iso-8859-1?Q?N/F4kIHj6QLr1xqFPdxP3UtQa6RFv0RUccTkJ5h+aWjpHHcvdr54M2Al7+?=
 =?iso-8859-1?Q?IXNLUFPMQzPog/guwGC5VfvBnl3JXb0ss5I4gkdc4oz7etOyRPP7FyAhGy?=
 =?iso-8859-1?Q?HpGWMxjV07gBIgrixQ271MXrKIs91O3a5/tT/SYSAIG6ZQ2BfBNySBeX9a?=
 =?iso-8859-1?Q?StiwrSxzC7XWV7g25YYATFo4U37j6KMa1mrdEOJ4E6gYkPC9q9A3jyQxyK?=
 =?iso-8859-1?Q?0v8GaBUdIQWF67vEO/cslftAPYMzB/887VbD4phKceyPhm7T+0X7cD6s4v?=
 =?iso-8859-1?Q?ro6H5UVwkkM+yOfCXSRlYu3lYZnGEDPm6ktdCdlR8ktZwxI9DpXvsDvU37?=
 =?iso-8859-1?Q?x2QimPBZh9KneY5gKp1m/m5qAhm13YNHFUxZ+QnXtcANGK4FCWgQtFwSrO?=
 =?iso-8859-1?Q?KEgmJ0/1uGirSvUlx93//qjsuXX3AC1aLqwbCcJvgqiNrQXC67LyEGfT8z?=
 =?iso-8859-1?Q?w3cOA6Zhx3AWpNXA9RVMPvfDoLlo/CwXcnK1YLgj2sPic/I0b84Y5k+fYb?=
 =?iso-8859-1?Q?2rmQsluFY7ELkNcaq2/0upbZRjWCq5cAAmlHxWOf3Knyt5hQU498FjmzBI?=
 =?iso-8859-1?Q?hrwsGhuRvfyUgm70UNMFJ2LZSnnawI61qpAYP1VtCBSdVLRunIv2OsUGqm?=
 =?iso-8859-1?Q?IE/NzC4XdasZe2zilR/Fj8UiRkVdF+/lHDmN/l/vMc28SPzAfbbFiULvj+?=
 =?iso-8859-1?Q?Qv5b8YphamE7VJwBDKTVbO1KJTL2xWlCMjvCbXdfI+Dzf5+CQtAlC7n1SZ?=
 =?iso-8859-1?Q?Wf9vnGkozOYxrav0LC4mYHXzxU6l6BkkJkIR0XBcXAzuYOZkKhjH+DAML+?=
 =?iso-8859-1?Q?2gGks68YFqMPQXUcqUpoh0XdYCAVMBOMkiy1bPmQ0HxwuQSPEBBsZu+7te?=
 =?iso-8859-1?Q?V3URIRYjMujVtsAqy8sDwD6eheq5mm0la3gLMvFQxiW2xqQkHnRaWIf8eF?=
 =?iso-8859-1?Q?rL/zTEb3fwfA5j9nTnrl7P64+8qIeOF1o5?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 81eb0da1-1bfc-4922-ac0e-08db3a9a028d
X-MS-Exchange-CrossTenant-AuthSource: MN0PR11MB6059.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Apr 2023 14:35:35.0014
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 7RrPpnfo9EKuzFn6AF3p7SiNDhD29Abn0gblKyeepA8ieLz7cHC7ye92wmrRYdXiosQXso65/nTXZ2muJgxBQA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR11MB7690
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Apr 11, 2023 at 08:39:00AM +0200, Das, Nirmoy wrote:
> 
> On 3/8/2023 10:41 AM, Andi Shyti wrote:
> > Currently, when we perform operations such as clearing or copying
> > large blocks of memory, we generate multiple requests that are
> > executed in a chain.
> > 
> > However, if one of these requests fails, we may not realize it
> > unless it happens to be the last request in the chain. This is
> > because errors are not properly propagated.
> > 
> > For this we need to keep propagating the chain of fence
> > notification in order to always reach the final fence associated
> > to the final request.
> > 
> > To address this issue, we need to ensure that the chain of fence
> > notifications is always propagated so that we can reach the final
> > fence associated with the last request. By doing so, we will be
> > able to detect any memory operation  failures and determine
> > whether the memory is still invalid.
> > 
> > On copy and clear migration signal fences upon completion.
> > 
> > On copy and clear migration, signal fences upon request
> > completion to ensure that we have a reliable perpetuation of the
> > operation outcome.
> > 
> > Fixes: cf586021642d80 ("drm/i915/gt: Pipelined page migration")
> > Reported-by: Matthew Auld <matthew.auld@intel.com>
> > Suggested-by: Chris Wilson <chris@chris-wilson.co.uk>
> > Signed-off-by: Andi Shyti <andi.shyti@linux.intel.com>
> > Cc: stable@vger.kernel.org
> > Reviewed-by: Matthew Auld <matthew.auld@intel.com>
> With  Matt's comment regarding missing lock in intel_context_migrate_clear
> addressed, this is:
> 
> Acked-by: Nirmoy Das <nirmoy.das@intel.com>

Nack!

Please get some ack from Joonas or Tvrtko before merging this series.

It is a big series targeting stable o.O where the revisions in the cover
letter are not helping me to be confident that this is the right approach
instead of simply reverting the original offending commit:

cf586021642d ("drm/i915/gt: Pipelined page migration")

It looks to me that we are adding magic on top of magic to workaround
the deadlocks, but then adding more waits inside locks... And this with
the hang checks vs heartbeats, is this really an issue on current upstream
code? or was only on DII?

Where was the bug report to start with?

> 
> > ---
> >   drivers/gpu/drm/i915/gt/intel_migrate.c | 41 ++++++++++++++++++-------
> >   1 file changed, 30 insertions(+), 11 deletions(-)
> > 
> > diff --git a/drivers/gpu/drm/i915/gt/intel_migrate.c b/drivers/gpu/drm/i915/gt/intel_migrate.c
> > index 3f638f1987968..0031e7b1b4704 100644
> > --- a/drivers/gpu/drm/i915/gt/intel_migrate.c
> > +++ b/drivers/gpu/drm/i915/gt/intel_migrate.c
> > @@ -742,13 +742,19 @@ intel_context_migrate_copy(struct intel_context *ce,
> >   			dst_offset = 2 * CHUNK_SZ;
> >   	}
> > +	/*
> > +	 * While building the chain of requests, we need to ensure
> > +	 * that no one can sneak into the timeline unnoticed.
> > +	 */
> > +	mutex_lock(&ce->timeline->mutex);
> > +
> >   	do {
> >   		int len;
> > -		rq = i915_request_create(ce);
> > +		rq = i915_request_create_locked(ce);
> >   		if (IS_ERR(rq)) {
> >   			err = PTR_ERR(rq);
> > -			goto out_ce;
> > +			break;
> >   		}
> >   		if (deps) {
> > @@ -878,10 +884,14 @@ intel_context_migrate_copy(struct intel_context *ce,
> >   		/* Arbitration is re-enabled between requests. */
> >   out_rq:
> > -		if (*out)
> > +		i915_sw_fence_await(&rq->submit);
> > +		i915_request_get(rq);
> > +		i915_request_add_locked(rq);
> > +		if (*out) {
> > +			i915_sw_fence_complete(&(*out)->submit);
> >   			i915_request_put(*out);
> > -		*out = i915_request_get(rq);
> > -		i915_request_add(rq);
> > +		}
> > +		*out = rq;
> >   		if (err)
> >   			break;
> > @@ -905,7 +915,10 @@ intel_context_migrate_copy(struct intel_context *ce,
> >   		cond_resched();
> >   	} while (1);
> > -out_ce:
> > +	mutex_unlock(&ce->timeline->mutex);
> > +
> > +	if (*out)
> > +		i915_sw_fence_complete(&(*out)->submit);
> >   	return err;
> >   }
> > @@ -1005,7 +1018,7 @@ intel_context_migrate_clear(struct intel_context *ce,
> >   		rq = i915_request_create(ce);
> >   		if (IS_ERR(rq)) {
> >   			err = PTR_ERR(rq);
> > -			goto out_ce;
> > +			break;
> >   		}
> >   		if (deps) {
> > @@ -1056,17 +1069,23 @@ intel_context_migrate_clear(struct intel_context *ce,
> >   		/* Arbitration is re-enabled between requests. */
> >   out_rq:
> > -		if (*out)
> > -			i915_request_put(*out);
> > -		*out = i915_request_get(rq);
> > +		i915_sw_fence_await(&rq->submit);
> > +		i915_request_get(rq);
> >   		i915_request_add(rq);
> > +		if (*out) {
> > +			i915_sw_fence_complete(&(*out)->submit);
> > +			i915_request_put(*out);
> > +		}
> > +		*out = rq;
> > +
> >   		if (err || !it.sg || !sg_dma_len(it.sg))
> >   			break;
> >   		cond_resched();
> >   	} while (1);
> > -out_ce:
> > +	if (*out)
> > +		i915_sw_fence_complete(&(*out)->submit);
> >   	return err;
> >   }
