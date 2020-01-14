Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C559413B27E
	for <lists+stable@lfdr.de>; Tue, 14 Jan 2020 19:59:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726053AbgANS7O (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 14 Jan 2020 13:59:14 -0500
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:43407 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726450AbgANS7O (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 14 Jan 2020 13:59:14 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1579028352;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=PwpWz00zPvOTxEDC2m5Pchh05Zedu3Yy2VaiY8a4/yk=;
        b=DIqGAGIbtlvrH7ot1TLzRlqCLWVgBld05lI6IlWWG/Gtq0ANCNV38I/qBtpht4p+RyLFyL
        q/nVcVPCmjPImw0bnClNBhz33PexfLnfM2zX45lj/0bTm1DHWaNNBjkJfagUx4gBuR7OOf
        e59P6WySpLIbxlY+oXPkLcvYZtyfs6M=
Received: from mail-qk1-f198.google.com (mail-qk1-f198.google.com
 [209.85.222.198]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-360--kqjaKJwPN-T0jnBCKjL4A-1; Tue, 14 Jan 2020 13:59:11 -0500
X-MC-Unique: -kqjaKJwPN-T0jnBCKjL4A-1
Received: by mail-qk1-f198.google.com with SMTP id d1so9017429qkk.15
        for <stable@vger.kernel.org>; Tue, 14 Jan 2020 10:59:10 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:subject:from:to:cc:date:in-reply-to
         :references:organization:user-agent:mime-version
         :content-transfer-encoding;
        bh=PwpWz00zPvOTxEDC2m5Pchh05Zedu3Yy2VaiY8a4/yk=;
        b=E0a7t+aJ3R0mZv9jdkst2b0hDR5i3JXsX+uJpnjRG0SAgQZQv1NADQNN62iCLcxWgP
         jLDbq+/tmqqkYtH29G4D0TLtoo+Ao3Wcy9bN5umH14nWG4OGGjs8brA08LVsrqLyK+9h
         cVeU6+Wpm/v4XIQPaXQwjslzoGDTzfpgZCbPKEZZT/9LglxBBsRrUGk9r5rdP4fIKDxK
         A3DobDpLADiiPrG4z4IeAs4RpAYNgn7L8pN7Gs8dpe/LUnk8PqXeIZqCAN1HvDKDOGjC
         ypK/1Q+c483bBAXeDwlGbuBcfUv7ro8EwTiVNAQOF+aFND2+khaECQY7DpQg+SIWh4UK
         O9zg==
X-Gm-Message-State: APjAAAU2AOx8+LKciDjakQ5gRqiddceJkrRHxgL/BMIP45iYsb+RqZnf
        SiQTydzNuvdohJJge6cFuRn1WRSvBV04wJvsP78hQPHDPBlHJBs94xAsfV1rmTgIOt1cs+SZrAf
        J2l53IrJtEXefhvRw
X-Received: by 2002:a05:6214:1633:: with SMTP id e19mr18421862qvw.104.1579028349788;
        Tue, 14 Jan 2020 10:59:09 -0800 (PST)
X-Google-Smtp-Source: APXvYqwY2/fKFFhCvEzdMQ6FBvDbrjhrTs78nHi5cZi/VS2pIEMJFMI01ZtXvX7HTE7sW5Sa5bbOrg==
X-Received: by 2002:a05:6214:1633:: with SMTP id e19mr18421840qvw.104.1579028349472;
        Tue, 14 Jan 2020 10:59:09 -0800 (PST)
Received: from dhcp-10-20-1-90.bss.redhat.com ([144.121.20.162])
        by smtp.gmail.com with ESMTPSA id t3sm8116880qtc.8.2020.01.14.10.59.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 14 Jan 2020 10:59:08 -0800 (PST)
Message-ID: <1f57547db3b36c032f07edaff325726698df3c3f.camel@redhat.com>
Subject: Re: [PATCH v2] drm/dp_mst: clear time slots for ports invalid
From:   Lyude Paul <lyude@redhat.com>
To:     Wayne Lin <Wayne.Lin@amd.com>, dri-devel@lists.freedesktop.org,
        amd-gfx@lists.freedesktop.org
Cc:     Nicholas.Kazlauskas@amd.com, harry.wentland@amd.com,
        jerry.zuo@amd.com, stable@vger.kernel.org
Date:   Tue, 14 Jan 2020 13:59:07 -0500
In-Reply-To: <20200106102158.28261-1-Wayne.Lin@amd.com>
References: <20200106102158.28261-1-Wayne.Lin@amd.com>
Organization: Red Hat
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.34.3 (3.34.3-1.fc31) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Pushed, thanks!

On Mon, 2020-01-06 at 18:21 +0800, Wayne Lin wrote:
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
> Changes since v1:(https://patchwork.kernel.org/patch/11275801/)
> * Invert the conditional to reduce the indenting
> 
> Reviewed-by: Lyude Paul <lyude@redhat.com>
> Signed-off-by: Wayne Lin <Wayne.Lin@amd.com>
> Cc: stable@vger.kernel.org
> ---
>  drivers/gpu/drm/drm_dp_mst_topology.c | 25 ++++++++++++++++++++++++-
>  1 file changed, 24 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/gpu/drm/drm_dp_mst_topology.c
> b/drivers/gpu/drm/drm_dp_mst_topology.c
> index 6e10f6235009..e37cd6ec6e36 100644
> --- a/drivers/gpu/drm/drm_dp_mst_topology.c
> +++ b/drivers/gpu/drm/drm_dp_mst_topology.c
> @@ -2321,7 +2321,7 @@ drm_dp_mst_handle_conn_stat(struct drm_dp_mst_branch
> *mstb,
>  {
>  	struct drm_dp_mst_topology_mgr *mgr = mstb->mgr;
>  	struct drm_dp_mst_port *port;
> -	int old_ddps, ret;
> +	int old_ddps, old_input, ret, i;
>  	u8 new_pdt;
>  	bool dowork = false, create_connector = false;
>  
> @@ -2352,6 +2352,7 @@ drm_dp_mst_handle_conn_stat(struct drm_dp_mst_branch
> *mstb,
>  	}
>  
>  	old_ddps = port->ddps;
> +	old_input = port->input;
>  	port->input = conn_stat->input_port;
>  	port->mcs = conn_stat->message_capability_status;
>  	port->ldps = conn_stat->legacy_device_plug_status;
> @@ -2376,6 +2377,28 @@ drm_dp_mst_handle_conn_stat(struct drm_dp_mst_branch
> *mstb,
>  		dowork = false;
>  	}
>  
> +	if (!old_input && old_ddps != port->ddps && !port->ddps) {
> +		for (i = 0; i < mgr->max_payloads; i++) {
> +			struct drm_dp_vcpi *vcpi = mgr->proposed_vcpis[i];
> +			struct drm_dp_mst_port *port_validated;
> +
> +			if (!vcpi)
> +				continue;
> +
> +			port_validated =
> +				container_of(vcpi, struct drm_dp_mst_port,
> vcpi);
> +			port_validated =
> +				drm_dp_mst_topology_get_port_validated(mgr,
> port_validated);
> +			if (!port_validated) {
> +				mutex_lock(&mgr->payload_lock);
> +				vcpi->num_slots = 0;
> +				mutex_unlock(&mgr->payload_lock);
> +			} else {
> +				drm_dp_mst_topology_put_port(port_validated);
> +			}
> +		}
> +	}
> +
>  	if (port->connector)
>  		drm_modeset_unlock(&mgr->base.lock);
>  	else if (create_connector)
-- 
Cheers,
	Lyude Paul

