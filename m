Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7C958128174
	for <lists+stable@lfdr.de>; Fri, 20 Dec 2019 18:31:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727394AbfLTRbG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 20 Dec 2019 12:31:06 -0500
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:31989 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727388AbfLTRbG (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 20 Dec 2019 12:31:06 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1576863064;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=KiiVtA64ZzOD09ZN5phv+ksxlbwnWqM72ngiuQsVVe8=;
        b=g5USEuhye2y4UOF7kRqmWQdemeZivjymIegdS2ofKDCTVE3tHelC6O1Nk2MvFR5vcIlcgH
        SNuuJlf1DZ2+hKMckMmZLZIc+EAgs+gR9+qXU3iTRn6SYG16M/GgY/IwUUKC9fpbT+4Thv
        O9RIXGS11xEMbY0Y5sSPDK9pcrN0NWU=
Received: from mail-qv1-f69.google.com (mail-qv1-f69.google.com
 [209.85.219.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-49-0kP-Es_WNWqqLHe9TepfPw-1; Fri, 20 Dec 2019 12:31:03 -0500
X-MC-Unique: 0kP-Es_WNWqqLHe9TepfPw-1
Received: by mail-qv1-f69.google.com with SMTP id dw11so6284395qvb.16
        for <stable@vger.kernel.org>; Fri, 20 Dec 2019 09:31:02 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:subject:from:to:cc:date:in-reply-to
         :references:organization:user-agent:mime-version
         :content-transfer-encoding;
        bh=KiiVtA64ZzOD09ZN5phv+ksxlbwnWqM72ngiuQsVVe8=;
        b=W04W6JW9RLCsBRh06exXBW20bXSV2SN+nX9Odh24ZtyW5VxkMQjDLFbeYxdksn2/j4
         iXu5KThYRcVpF4AoGmlJbtqgtNhHOreNiJ0nrRda3OmWBVANKxiZveagamqULKKZgtyf
         XNT9OY6DyjUqesUKo4HfRcioxbDpL6EDOiUoHHV6Lf1Y9uHJY5piYDu6bLNs4OoxFjxM
         kMbZMUaUmbW+MiBTQIchAi4204CUP12pyFYpNlvcs2UQ1eSuQfgMbHCLmvukfUFlM94p
         CA97IaDKGiQ3IrRIomqnx2LUY5qaEy3JgCzx9dlTdnxhgIMXzqj1OjbJJXGbvxc6aj/+
         xQFw==
X-Gm-Message-State: APjAAAUKZxsNue/dS+nKmjIx0MY2VOtBQwagG9MpmEKn6z9B8M3/3hI4
        I2mPTpXyXwe7LxtC0mgyBhtt0GB03o5QsGiNQ6/tDgoyJzVrWd8/Own0uPN742wFl+RHgcuJthQ
        w6ab7SBEwlwNPqW+W
X-Received: by 2002:a05:6214:1090:: with SMTP id o16mr13518235qvr.105.1576863062002;
        Fri, 20 Dec 2019 09:31:02 -0800 (PST)
X-Google-Smtp-Source: APXvYqy6QwQKl2gKERz10vX0sGJVk3xwnLIOPGwkEraifPfUPEGy6/h4yzOx4CTtJcnzfTtzRsU2yQ==
X-Received: by 2002:a05:6214:1090:: with SMTP id o16mr13518211qvr.105.1576863061753;
        Fri, 20 Dec 2019 09:31:01 -0800 (PST)
Received: from malachite.lyude.net (static-173-76-190-23.bstnma.ftas.verizon.net. [173.76.190.23])
        by smtp.gmail.com with ESMTPSA id b7sm3269979qtj.15.2019.12.20.09.31.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 20 Dec 2019 09:31:01 -0800 (PST)
Message-ID: <a0345eca33c0a41ef83ba50bec4d13a9a6a29edb.camel@redhat.com>
Subject: Re: [PATCH] drm/dp_mst: clear time slots for ports invalid
From:   Lyude Paul <lyude@redhat.com>
To:     "Lin, Wayne" <Wayne.Lin@amd.com>,
        "dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>,
        "amd-gfx@lists.freedesktop.org" <amd-gfx@lists.freedesktop.org>
Cc:     "Kazlauskas, Nicholas" <Nicholas.Kazlauskas@amd.com>,
        "Wentland, Harry" <Harry.Wentland@amd.com>,
        "Zuo, Jerry" <Jerry.Zuo@amd.com>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
Date:   Fri, 20 Dec 2019 12:30:59 -0500
In-Reply-To: <DM6PR12MB41379C431DBB59A0C0A4C910FC2D0@DM6PR12MB4137.namprd12.prod.outlook.com>
References: <20191206083937.9411-1-Wayne.Lin@amd.com>
         <DM6PR12MB41379C431DBB59A0C0A4C910FC2D0@DM6PR12MB4137.namprd12.prod.outlook.com>
Organization: Red Hat
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.34.2 (3.34.2-1.fc31) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi! I will try to review this patch today, must have gotten lost in the noise

On Fri, 2019-12-20 at 01:46 +0000, Lin, Wayne wrote:
> [AMD Official Use Only - Internal Distribution Only]
> 
> Pinged.
> Hi, can someone help to review please.
> 
> Thanks a lot.
> 
> Regards,
> Wayne
> 
> ________________________________________
> From: Wayne Lin <Wayne.Lin@amd.com>
> Sent: Friday, December 6, 2019 16:39
> To: dri-devel@lists.freedesktop.org; amd-gfx@lists.freedesktop.org
> Cc: Kazlauskas, Nicholas; Wentland, Harry; Zuo, Jerry; lyude@redhat.com; 
> stable@vger.kernel.org; Lin, Wayne
> Subject: [PATCH] drm/dp_mst: clear time slots for ports invalid
> 
> [Why]
> When change the connection status in a MST topology, mst device
> which detect the event will send out CONNECTION_STATUS_NOTIFY messgae.
> 
> e.g. src-mst-mst-sst => src-mst (unplug) mst-sst
> 
> Currently, under the above case of unplugging device, ports which have
> been allocated payloads and are no longer in the topology still occupy
> time slots and recorded in proposed_vcpi[] of topology manager.
> 
> If we don't clean up the proposed_vcpi[], when code flow goes to try to
> update payload table by calling drm_dp_update_payload_part1(), we will
> fail at checking port validation due to there are ports with proposed
> time slots but no longer in the mst topology. As the result of that, we
> will also stop updating the DPCD payload table of down stream port.
> 
> [How]
> While handling the CONNECTION_STATUS_NOTIFY message, add a detection to
> see if the event indicates that a device is unplugged to an output port.
> If the detection is true, then iterrate over all proposed_vcpi[] to
> see whether a port of the proposed_vcpi[] is still in the topology or
> not. If the port is invalid, set its num_slots to 0.
> 
> Thereafter, when try to update payload table by calling
> drm_dp_update_payload_part1(), we can successfully update the DPCD
> payload table of down stream port and clear the proposed_vcpi[] to NULL.
> 
> Signed-off-by: Wayne Lin <Wayne.Lin@amd.com>
> Cc: stable@vger.kernel.org
> ---
>  drivers/gpu/drm/drm_dp_mst_topology.c | 24 +++++++++++++++++++++++-
>  1 file changed, 23 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/gpu/drm/drm_dp_mst_topology.c
> b/drivers/gpu/drm/drm_dp_mst_topology.c
> index 5306c47dc820..2e236b6275c4 100644
> --- a/drivers/gpu/drm/drm_dp_mst_topology.c
> +++ b/drivers/gpu/drm/drm_dp_mst_topology.c
> @@ -2318,7 +2318,7 @@ drm_dp_mst_handle_conn_stat(struct drm_dp_mst_branch
> *mstb,
>  {
>         struct drm_dp_mst_topology_mgr *mgr = mstb->mgr;
>         struct drm_dp_mst_port *port;
> -       int old_ddps, ret;
> +       int old_ddps, old_input, ret, i;
>         u8 new_pdt;
>         bool dowork = false, create_connector = false;
> 
> @@ -2349,6 +2349,7 @@ drm_dp_mst_handle_conn_stat(struct drm_dp_mst_branch
> *mstb,
>         }
> 
>         old_ddps = port->ddps;
> +       old_input = port->input;
>         port->input = conn_stat->input_port;
>         port->mcs = conn_stat->message_capability_status;
>         port->ldps = conn_stat->legacy_device_plug_status;
> @@ -2373,6 +2374,27 @@ drm_dp_mst_handle_conn_stat(struct drm_dp_mst_branch
> *mstb,
>                 dowork = false;
>         }
> 
> +       if (!old_input && old_ddps != port->ddps && !port->ddps) {
> +               for (i = 0; i < mgr->max_payloads; i++) {
> +                       struct drm_dp_vcpi *vcpi = mgr->proposed_vcpis[i];
> +                       struct drm_dp_mst_port *port_validated;
> +
> +                       if (vcpi) {
> +                               port_validated =
> +                                       container_of(vcpi, struct
> drm_dp_mst_port, vcpi);
> +                               port_validated =
> +                                       drm_dp_mst_topology_get_port_validat
> ed(mgr, port_validated);
> +                               if (!port_validated) {
> +                                       mutex_lock(&mgr->payload_lock);
> +                                       vcpi->num_slots = 0;
> +                                       mutex_unlock(&mgr->payload_lock);
> +                               } else {
> +                                       drm_dp_mst_topology_put_port(port_va
> lidated);
> +                               }
> +                       }
> +               }
> +       }
> +
>         if (port->connector)
>                 drm_modeset_unlock(&mgr->base.lock);
>         else if (create_connector)
> --
> 2.17.1
> 
-- 
Cheers,
	Lyude Paul

