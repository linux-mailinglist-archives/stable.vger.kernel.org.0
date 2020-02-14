Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6E55315EE2A
	for <lists+stable@lfdr.de>; Fri, 14 Feb 2020 18:39:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392023AbgBNRiy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 14 Feb 2020 12:38:54 -0500
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:60716 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S2389768AbgBNRiy (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 14 Feb 2020 12:38:54 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1581701932;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=LkNDcKP8WfZzEgb1FMJ+6cGSN8qV8eyUCjq3RWyKemo=;
        b=VaO8E14lyU4PZ23yd0YSlvvfURpcz9c/VKxB9iNnzEXVHIv9AJmx09WphJZ7XooaQFY80Z
        pvGqnTJ7jsNaDUN0oXQU91sGIjPpLOaikKSOSOjnIEFHrv5BWge/b+bfYYy0GcFEb6FBbu
        MbyBJEEY7E7AnQEyFEmjokn07tA07/s=
Received: from mail-qk1-f197.google.com (mail-qk1-f197.google.com
 [209.85.222.197]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-199-6X5zf5mvNpWHiDtPQWC5Kw-1; Fri, 14 Feb 2020 12:38:46 -0500
X-MC-Unique: 6X5zf5mvNpWHiDtPQWC5Kw-1
Received: by mail-qk1-f197.google.com with SMTP id h6so2898794qkj.14
        for <stable@vger.kernel.org>; Fri, 14 Feb 2020 09:38:46 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:subject:from:to:cc:date:in-reply-to
         :references:organization:user-agent:mime-version
         :content-transfer-encoding;
        bh=LkNDcKP8WfZzEgb1FMJ+6cGSN8qV8eyUCjq3RWyKemo=;
        b=D0L/sb31qLjmbHqeU8CK87WMzKr9ywDIcBDyJpe+4fPNpSL6vKeVneOptXgJ2AfDaf
         6Bdcy6StCJv1MyI4nqmLnHn4CJyBg7VqBpRW8bonjT0G5tgcvqqg0YBSUjjUFqvGRYQ/
         J8M8C3w2Esufi4g18ZO9F5nAneoGXzi10HTErpAQsuO6723vzjUZz9HQM0sx7C+b1g0W
         wOCEUhsVK+BSCTCNzwys763MjDWBt+JhUtSGIzrdIfd4UTe3IX2k/FA3WgwVXOHtph64
         DYqtdDmfxI91+t9XjKN77z3zULdsH3jCqcRT/61vFFjY3mrtXzArFztxHuzfDrvogTAU
         ayYA==
X-Gm-Message-State: APjAAAV5WFxkmuOL6exAmcc3+8GT201tw87OSM62YclwnRXevufo5dW8
        Jj4BHLoHD+Ap/r1YEvd4DSGV3GhkJOA79+Nk4pQaCu6SvlghaWgoV2FOo6YYYGHSrDT0J47pw4/
        aFAE0LausRQjJDOq5
X-Received: by 2002:a37:6c45:: with SMTP id h66mr3584211qkc.360.1581701926139;
        Fri, 14 Feb 2020 09:38:46 -0800 (PST)
X-Google-Smtp-Source: APXvYqxYO2nGgtY9wiWp/sFhAYQ2hS7P1MCs1W6nqmfBghB9oJYriPY8kbNaYKdzQGMJrePguHQxGw==
X-Received: by 2002:a37:6c45:: with SMTP id h66mr3584200qkc.360.1581701925875;
        Fri, 14 Feb 2020 09:38:45 -0800 (PST)
Received: from dhcp-10-20-1-196.bss.redhat.com ([144.121.20.162])
        by smtp.gmail.com with ESMTPSA id f32sm3801569qtk.89.2020.02.14.09.38.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 14 Feb 2020 09:38:45 -0800 (PST)
Message-ID: <6fa270d0d395d87c41b7d0a9ec87eadea5398eb6.camel@redhat.com>
Subject: Re: [PATCH 4.9 087/116] drm/dp_mst: Remove VCPI while disabling
 topology mgr
From:   Lyude Paul <lyude@redhat.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     stable@vger.kernel.org, Wayne Lin <Wayne.Lin@amd.com>,
        Sasha Levin <sashal@kernel.org>
Date:   Fri, 14 Feb 2020 12:38:44 -0500
In-Reply-To: <20200213151916.429278047@linuxfoundation.org>
References: <20200213151842.259660170@linuxfoundation.org>
         <20200213151916.429278047@linuxfoundation.org>
Organization: Red Hat
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.34.3 (3.34.3-1.fc31) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

We should drop this and the versions for all of the other kernel versions.
This patch later got reverted in a86675968e2300fb567994459da3dbc4cd1b322a in
drm-misc/drm-misc-next, and then replaced with a proper fix in
8732fe46b20c951493bfc4dba0ad08efdf41de81

On Thu, 2020-02-13 at 07:20 -0800, Greg Kroah-Hartman wrote:
> From: Wayne Lin <Wayne.Lin@amd.com>
> 
> [ Upstream commit 64e62bdf04ab8529f45ed0a85122c703035dec3a ]
> 
> [Why]
> 
> This patch is trying to address the issue observed when hotplug DP
> daisy chain monitors.
> 
> e.g.
> src-mstb-mstb-sst -> src (unplug) mstb-mstb-sst -> src-mstb-mstb-sst
> (plug in again)
> 
> Once unplug a DP MST capable device, driver will call
> drm_dp_mst_topology_mgr_set_mst() to disable MST. In this function,
> it cleans data of topology manager while disabling mst_state. However,
> it doesn't clean up the proposed_vcpis of topology manager.
> If proposed_vcpi is not reset, once plug in MST daisy chain monitors
> later, code will fail at checking port validation while trying to
> allocate payloads.
> 
> When MST capable device is plugged in again and try to allocate
> payloads by calling drm_dp_update_payload_part1(), this
> function will iterate over all proposed virtual channels to see if
> any proposed VCPI's num_slots is greater than 0. If any proposed
> VCPI's num_slots is greater than 0 and the port which the
> specific virtual channel directed to is not in the topology, code then
> fails at the port validation. Since there are stale VCPI allocations
> from the previous topology enablement in proposed_vcpi[], code will fail
> at port validation and reurn EINVAL.
> 
> [How]
> 
> Clean up the data of stale proposed_vcpi[] and reset mgr->proposed_vcpis
> to NULL while disabling mst in drm_dp_mst_topology_mgr_set_mst().
> 
> Changes since v1:
> *Add on more details in commit message to describe the issue which the
> patch is trying to fix
> 
> Signed-off-by: Wayne Lin <Wayne.Lin@amd.com>
> [added cc to stable]
> Signed-off-by: Lyude Paul <lyude@redhat.com>
> Link: 
> https://patchwork.freedesktop.org/patch/msgid/20191205090043.7580-1-Wayne.Lin@amd.com
> Cc: <stable@vger.kernel.org> # v3.17+
> Signed-off-by: Sasha Levin <sashal@kernel.org>
> ---
>  drivers/gpu/drm/drm_dp_mst_topology.c | 12 ++++++++++++
>  1 file changed, 12 insertions(+)
> 
> diff --git a/drivers/gpu/drm/drm_dp_mst_topology.c
> b/drivers/gpu/drm/drm_dp_mst_topology.c
> index 17aedaaf364c1..8b1d497b7f99f 100644
> --- a/drivers/gpu/drm/drm_dp_mst_topology.c
> +++ b/drivers/gpu/drm/drm_dp_mst_topology.c
> @@ -2042,6 +2042,7 @@ static bool drm_dp_get_vc_payload_bw(int dp_link_bw,
>  int drm_dp_mst_topology_mgr_set_mst(struct drm_dp_mst_topology_mgr *mgr,
> bool mst_state)
>  {
>  	int ret = 0;
> +	int i = 0;
>  	struct drm_dp_mst_branch *mstb = NULL;
>  
>  	mutex_lock(&mgr->lock);
> @@ -2106,10 +2107,21 @@ int drm_dp_mst_topology_mgr_set_mst(struct
> drm_dp_mst_topology_mgr *mgr, bool ms
>  		/* this can fail if the device is gone */
>  		drm_dp_dpcd_writeb(mgr->aux, DP_MSTM_CTRL, 0);
>  		ret = 0;
> +		mutex_lock(&mgr->payload_lock);
>  		memset(mgr->payloads, 0, mgr->max_payloads * sizeof(struct
> drm_dp_payload));
>  		mgr->payload_mask = 0;
>  		set_bit(0, &mgr->payload_mask);
> +		for (i = 0; i < mgr->max_payloads; i++) {
> +			struct drm_dp_vcpi *vcpi = mgr->proposed_vcpis[i];
> +
> +			if (vcpi) {
> +				vcpi->vcpi = 0;
> +				vcpi->num_slots = 0;
> +			}
> +			mgr->proposed_vcpis[i] = NULL;
> +		}
>  		mgr->vcpi_mask = 0;
> +		mutex_unlock(&mgr->payload_lock);
>  	}
>  
>  out_unlock:
-- 
Cheers,
	Lyude Paul (she/her)
	Associate Software Engineer at Red Hat

