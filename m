Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 206D964EEB1
	for <lists+stable@lfdr.de>; Fri, 16 Dec 2022 17:12:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232083AbiLPQMc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 16 Dec 2022 11:12:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44894 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232674AbiLPQME (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 16 Dec 2022 11:12:04 -0500
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 12AF9419B9
        for <stable@vger.kernel.org>; Fri, 16 Dec 2022 08:10:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1671207058; x=1702743058;
  h=from:to:cc:subject:in-reply-to:references:date:
   message-id:mime-version;
  bh=dX9WZ/JD1h3m5AmrtUHUUyLwsWYF2Mia/nik3ZyIzfE=;
  b=Rcf98UtmgzyiL9f1ejPiY469rYk6TcEP+nNUlDy7SY5j/vBBC4DdZk8I
   LJNjgWaYqDMHuaqxMursAezoBXA4jEXi5fEjNfCdHy2dMNhR9tbIo7Boj
   ApJ2xgQpKMBEOyyoi4/pKqZH58N2WKct8XhthtB6Q7tR4mPO0UZhd++bs
   2mM/mb/t613oNaJl5NC1EUaJ44UuYSXZXWIJCTgvz85JR8m1dfxIQvGXe
   9IdnMb+4B/PEB5Yq2aE6gzBAym3UHEk+WeT7mLgxJZWVRgcsH9056UyUO
   cx9iz3lYcM+ZzPTkYyDivpN+zd/umfAV9vzC4QeD53mvMwQ1VbKrlB4CQ
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10563"; a="319050116"
X-IronPort-AV: E=Sophos;i="5.96,249,1665471600"; 
   d="scan'208";a="319050116"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Dec 2022 08:10:43 -0800
X-IronPort-AV: E=McAfee;i="6500,9779,10563"; a="978653047"
X-IronPort-AV: E=Sophos;i="5.96,249,1665471600"; 
   d="scan'208";a="978653047"
Received: from fbielich-mobl3.ger.corp.intel.com (HELO localhost) ([10.252.62.38])
  by fmsmga005-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Dec 2022 08:10:42 -0800
From:   Jani Nikula <jani.nikula@linux.intel.com>
To:     imre.deak@intel.com, Lyude Paul <lyude@redhat.com>
Cc:     intel-gfx@lists.freedesktop.org, stable@vger.kernel.org,
        dri-devel@lists.freedesktop.org
Subject: Re: [Intel-gfx] [PATCH 1/3] drm/display/dp_mst: Fix down/up message
 handling after sink disconnect
In-Reply-To: <Y5yKXXBUycSHov5g@ideak-desk.fi.intel.com>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
References: <20221214184258.2869417-1-imre.deak@intel.com>
 <1ade43347769118c82f1b68bd8b51172a1012a37.camel@redhat.com>
 <Y5yKXXBUycSHov5g@ideak-desk.fi.intel.com>
Date:   Fri, 16 Dec 2022 18:10:39 +0200
Message-ID: <875yebuy68.fsf@intel.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Spam-Status: No, score=-7.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, 16 Dec 2022, Imre Deak <imre.deak@intel.com> wrote:
> On Wed, Dec 14, 2022 at 04:41:42PM -0500, Lyude Paul wrote:
>> For the whole series:
>> 
>> Reviewed-by: Lyude Paul <lyude@redhat.com>
>
> Thanks for the review, pushed it to drm-misc-next.

Hmm, with the drm-misc *not* cherry-picking patches from drm-misc-next
to drm-misc-fixes, these will only get backported to stable kernels
after they hit Linus' tree in the next (as opposed to current) merge
window after a full development cycle. Wonder if they should be
expedited.

BR,
Jani.

>
>> Thanks!
>> 
>> On Wed, 2022-12-14 at 20:42 +0200, Imre Deak wrote:
>> > If the sink gets disconnected during receiving a multi-packet DP MST AUX
>> > down-reply/up-request sideband message, the state keeping track of which
>> > packets have been received already is not reset. This results in a failed
>> > sanity check for the subsequent message packet received after a sink is
>> > reconnected (due to the pending message not yet completed with an
>> > end-of-message-transfer packet), indicated by the
>> > 
>> > "sideband msg set header failed"
>> > 
>> > error.
>> > 
>> > Fix the above by resetting the up/down message reception state after a
>> > disconnect event.
>> > 
>> > Cc: Lyude Paul <lyude@redhat.com>
>> > Cc: <stable@vger.kernel.org> # v3.17+
>> > Signed-off-by: Imre Deak <imre.deak@intel.com>
>> > ---
>> >  drivers/gpu/drm/display/drm_dp_mst_topology.c | 3 +++
>> >  1 file changed, 3 insertions(+)
>> > 
>> > diff --git a/drivers/gpu/drm/display/drm_dp_mst_topology.c b/drivers/gpu/drm/display/drm_dp_mst_topology.c
>> > index 51a46689cda70..90819fff2c9ba 100644
>> > --- a/drivers/gpu/drm/display/drm_dp_mst_topology.c
>> > +++ b/drivers/gpu/drm/display/drm_dp_mst_topology.c
>> > @@ -3641,6 +3641,9 @@ int drm_dp_mst_topology_mgr_set_mst(struct drm_dp_mst_topology_mgr *mgr, bool ms
>> >  		drm_dp_dpcd_writeb(mgr->aux, DP_MSTM_CTRL, 0);
>> >  		ret = 0;
>> >  		mgr->payload_id_table_cleared = false;
>> > +
>> > +		memset(&mgr->down_rep_recv, 0, sizeof(mgr->down_rep_recv));
>> > +		memset(&mgr->up_req_recv, 0, sizeof(mgr->up_req_recv));
>> >  	}
>> >  
>> >  out_unlock:
>> 
>> -- 
>> Cheers,
>>  Lyude Paul (she/her)
>>  Software Engineer at Red Hat
>> 

-- 
Jani Nikula, Intel Open Source Graphics Center
