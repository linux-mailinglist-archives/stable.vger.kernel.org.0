Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7A0CC12FF29
	for <lists+stable@lfdr.de>; Sat,  4 Jan 2020 00:33:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726229AbgACXd4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 3 Jan 2020 18:33:56 -0500
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:27893 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726118AbgACXd4 (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 3 Jan 2020 18:33:56 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1578094433;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=efyUivrwT0eWnB85XA6uiUcfaQf7j2WsI1fpRnj8uyY=;
        b=MR1tWbaiNogFwHj1yxtPfSQygUrB7peMLnKCMILNUX/sV3LqHbmVxm480HQvsBuDIWSj6x
        pVai5EhebJi/yA6WTbpvGSorK7wDqrcxTSuoSwg5t2Ac7rhDto88wL78TztAGD8ZTJdud4
        uU8xfMLYSQXzHXmqbLmbzrNfVSjaoz0=
Received: from mail-qt1-f199.google.com (mail-qt1-f199.google.com
 [209.85.160.199]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-156-k0cm3GPVOQKrIPfEoAe9Qw-1; Fri, 03 Jan 2020 18:33:52 -0500
X-MC-Unique: k0cm3GPVOQKrIPfEoAe9Qw-1
Received: by mail-qt1-f199.google.com with SMTP id e8so6561708qtg.9
        for <stable@vger.kernel.org>; Fri, 03 Jan 2020 15:33:52 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:subject:from:to:cc:date:in-reply-to
         :references:organization:user-agent:mime-version
         :content-transfer-encoding;
        bh=efyUivrwT0eWnB85XA6uiUcfaQf7j2WsI1fpRnj8uyY=;
        b=LNkUm4mBBAdQgjWrv52MC+MBWAQzBOo4zXCw8jT5cWr1AuhgoXP54MWcsOCfqvnWid
         thb1LQMx353S8a2IG7jGoh/8CEQv/62SgIOkPdpCoenBqbemw9vxl2nd+BMnJW3sADVL
         lxOT6g8+8LG9IhJ/Zn/ONzafFv2ggZ/lGJEFFSK4NQvmgPfikpACYyOdekZD61haQefk
         hzaYigV7vvYR1PxuB/XqGWZOCH4TvgscX9IRdGEwPI6U/KBhc6l47xAfv+5dj1TVdo4C
         nuvQBYkyjilqM9/bsOZFNHeHpit/JCLSHzVn4BmZRQ/zIpArefCyqm4b579zOCQBBgay
         KsQA==
X-Gm-Message-State: APjAAAU/ZjzSRhMvXc4DNXzVYA8R/vuNlya27YEXkqYjzRPX7xPFt2kj
        z03dJ3qu4Cni6PlTNhwiPe7awkPdd8ihh5VZKipI+pW63+tzjqLYPwZbI4d9hI5vhr3NzNORLb1
        INWIuGU3cF3J3tF9M
X-Received: by 2002:ac8:6f63:: with SMTP id u3mr59105793qtv.39.1578094431955;
        Fri, 03 Jan 2020 15:33:51 -0800 (PST)
X-Google-Smtp-Source: APXvYqybxLCuuJeoaEoZ5+yINE7ht+XYIreLY5viupkoDidVs4ryN0W62LaqFy4zA3OnAD4Gq88meQ==
X-Received: by 2002:ac8:6f63:: with SMTP id u3mr59105786qtv.39.1578094431747;
        Fri, 03 Jan 2020 15:33:51 -0800 (PST)
Received: from dhcp-10-20-1-90.bss.redhat.com ([144.121.20.162])
        by smtp.gmail.com with ESMTPSA id h32sm19522562qth.2.2020.01.03.15.33.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 03 Jan 2020 15:33:50 -0800 (PST)
Message-ID: <2fe0b1d172044934b9414a5497861f9c1f12cb24.camel@redhat.com>
Subject: Re: [PATCH] drm/dp_mst: clear time slots for ports invalid
From:   Lyude Paul <lyude@redhat.com>
To:     "Lin, Wayne" <Wayne.Lin@amd.com>,
        "dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>,
        "amd-gfx@lists.freedesktop.org" <amd-gfx@lists.freedesktop.org>
Cc:     "Kazlauskas, Nicholas" <Nicholas.Kazlauskas@amd.com>,
        "Wentland, Harry" <Harry.Wentland@amd.com>,
        "Zuo, Jerry" <Jerry.Zuo@amd.com>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
Date:   Fri, 03 Jan 2020 18:33:50 -0500
In-Reply-To: <DM6PR12MB41378AEE89F13DA0825F2AD5FC280@DM6PR12MB4137.namprd12.prod.outlook.com>
References: <20191206083937.9411-1-Wayne.Lin@amd.com>
         <589e939efca5209af318645fa6799c423897eea6.camel@redhat.com>
         <DM6PR12MB41378AEE89F13DA0825F2AD5FC280@DM6PR12MB4137.namprd12.prod.outlook.com>
Organization: Red Hat
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.34.2 (3.34.2-1.fc31) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, 2019-12-25 at 06:45 +0000, Lin, Wayne wrote:
> > -----Original Message-----
> > From: Lyude Paul <lyude@redhat.com>
> > Sent: Saturday, December 21, 2019 8:12 AM
> > To: Lin, Wayne <Wayne.Lin@amd.com>; dri-devel@lists.freedesktop.org;
> > amd-gfx@lists.freedesktop.org
> > Cc: Kazlauskas, Nicholas <Nicholas.Kazlauskas@amd.com>; Wentland, Harry
> > <Harry.Wentland@amd.com>; Zuo, Jerry <Jerry.Zuo@amd.com>;
> > stable@vger.kernel.org
> > Subject: Re: [PATCH] drm/dp_mst: clear time slots for ports invalid
> > 
> > Mhh-I think I understand the problem you're trying to solve here but I
> > think this
> > solution might be a bit overkill. When I did the rework of topology
> > references
> > for ports, I made it so that we can guarantee memory access to a port
> > without
> > it needing to be a valid part of the topology. As well, all parents of the
> > port are
> > guaranteed to be accessible for as long as the child is. Take a look at:
> > 
> > https://nam11.safelinks.protection.outlook.com/?url=https%3A%2F%2F01.org%
> > 2Flinuxgraphics%2Fgfx-docs%2Fdrm%2Fgpu%2Fdrm-kms-helpers.html%23refco
> > unt-relationships-in-a-topology&amp;data=02%7C01%7Cwayne.lin%40amd.co
> > m%7C722655b546c049dc081908d785aa6758%7C3dd8961fe4884e608e11a82d
> > 994e183d%7C0%7C0%7C637124839257213115&amp;sdata=Ctha3ja8kleeFOp
> > PpA7EwDV1is81RAMsjqd1P6463ak%3D&amp;reserved=0
> > 
> > It's also worth noting that because of this there's a lot of
> > get_port_validated()/put_port_validated() calls in the MST helpers that
> > are
> > now bogus and need to be removed once I get a chance. For new code we
> > should limit the use of topology references to sections of code where we
> > need
> > a guarantee that resources on the port/branch (such as a drm connector, dp
> > aux port, etc.) won't go away for as long as we need to use them.
> > 
> > Do you think we could change this patch so instead of removing it from the
> > proposed payloads on the CONNECTION_STATUS_NOTIFY, we keep the port's
> > memory allocation around until it's been removed from the proposed
> > payloads
> > table and clean it up there on the next payload update?
> > 
> Really appreciate for your time and comments in detail.
> 
> In this patch, I wanted to just set the proposed_vcpi->num_slots to 0 for
> those
> ports which are no longer in the topology due to there is no need to
> allocate time
> slots for these port. And expect those vcpi will be updated during next
> update of 
> payload ID table by drm_dp_update_payload_part1(). 
> 
> I tried to use drm_dp_mst_topology_get_port_validated() as a helper to 
> decide whether a port is in the topology or not. Use this function to
> iterate over
> all ports that all proposed_vcpi[] drive to. If one port is not in the
> topology, set the
> num_slots of the proposed_vcpi for this port to 0. With num_slots as 0,
> these 
> proposed_vcpi will be clean up in next payload table update by 
> drm_dp_update_payload_part1(). If a port is still in the topology, then
> release
> the reference count which was acquired previously from
> drm_dp_mst_topology_get_port_validated() and do nothing.
> 
> I didn't mean to kill invalid ports on receiving CONNECTION_STATUS_NOTIFY.
> Sorry if I misuse or misunderstand something here?

Ahh, it seems I made the mistake here then because from your explanation
you're using the API exactly as intended :). All of this has me wondering if
some day we should try to get rid of the payload tracking we have and move it
into atomic. But, that's a problem for another day.

Anyway-one small change below:

> 
> > On Fri, 2019-12-06 at 16:39 +0800, Wayne Lin wrote:
> > > [Why]
> > > When change the connection status in a MST topology, mst device which
> > > detect the event will send out CONNECTION_STATUS_NOTIFY messgae.
> > > 
> > > e.g. src-mst-mst-sst => src-mst (unplug) mst-sst
> > > 
> > > Currently, under the above case of unplugging device, ports which have
> > > been allocated payloads and are no longer in the topology still occupy
> > > time slots and recorded in proposed_vcpi[] of topology manager.
> > > 
> > > If we don't clean up the proposed_vcpi[], when code flow goes to try
> > > to update payload table by calling drm_dp_update_payload_part1(), we
> > > will fail at checking port validation due to there are ports with
> > > proposed time slots but no longer in the mst topology. As the result
> > > of that, we will also stop updating the DPCD payload table of down
> > > stream
> > port.
> > > [How]
> > > While handling the CONNECTION_STATUS_NOTIFY message, add a detection
> > > to see if the event indicates that a device is unplugged to an output
> > > port.
> > > If the detection is true, then iterrate over all proposed_vcpi[] to
> > > see whether a port of the proposed_vcpi[] is still in the topology or
> > > not. If the port is invalid, set its num_slots to 0.
> > > 
> > > Thereafter, when try to update payload table by calling
> > > drm_dp_update_payload_part1(), we can successfully update the DPCD
> > > payload table of down stream port and clear the proposed_vcpi[] to NULL.
> > > 
> > > Signed-off-by: Wayne Lin <Wayne.Lin@amd.com>
> > > Cc: stable@vger.kernel.org
> > > ---
> > >  drivers/gpu/drm/drm_dp_mst_topology.c | 24
> > +++++++++++++++++++++++-
> > >  1 file changed, 23 insertions(+), 1 deletion(-)
> > > 
> > > diff --git a/drivers/gpu/drm/drm_dp_mst_topology.c
> > > b/drivers/gpu/drm/drm_dp_mst_topology.c
> > > index 5306c47dc820..2e236b6275c4 100644
> > > --- a/drivers/gpu/drm/drm_dp_mst_topology.c
> > > +++ b/drivers/gpu/drm/drm_dp_mst_topology.c
> > > @@ -2318,7 +2318,7 @@ drm_dp_mst_handle_conn_stat(struct
> > > drm_dp_mst_branch *mstb,  {
> > >  	struct drm_dp_mst_topology_mgr *mgr = mstb->mgr;
> > >  	struct drm_dp_mst_port *port;
> > > -	int old_ddps, ret;
> > > +	int old_ddps, old_input, ret, i;
> > >  	u8 new_pdt;
> > >  	bool dowork = false, create_connector = false;
> > > 
> > > @@ -2349,6 +2349,7 @@ drm_dp_mst_handle_conn_stat(struct
> > > drm_dp_mst_branch *mstb,
> > >  	}
> > > 
> > >  	old_ddps = port->ddps;
> > > +	old_input = port->input;
> > >  	port->input = conn_stat->input_port;
> > >  	port->mcs = conn_stat->message_capability_status;
> > >  	port->ldps = conn_stat->legacy_device_plug_status;
> > > @@ -2373,6 +2374,27 @@ drm_dp_mst_handle_conn_stat(struct
> > > drm_dp_mst_branch *mstb,
> > >  		dowork = false;
> > >  	}
> > > 
> > > +	if (!old_input && old_ddps != port->ddps && !port->ddps) {
> > > +		for (i = 0; i < mgr->max_payloads; i++) {
> > > +			struct drm_dp_vcpi *vcpi = mgr->proposed_vcpis[i];
> > > +			struct drm_dp_mst_port *port_validated;
> > > +
> > > +			if (vcpi) {

Let's invert this conditional to reduce the indenting here a bit
if (!vcpi)
     continue;

With that change this is:

Reviewed-by: Lyude Paul <lyude@redhat.com>

> > > +				port_validated =
> > > +					container_of(vcpi, struct
> > > drm_dp_mst_port, vcpi);
> > > +				port_validated =
> > > +					drm_dp_mst_topology_get_port_validated
> > > (mgr, port_validated);
> > > +				if (!port_validated) {
> > > +					mutex_lock(&mgr->payload_lock);
> > > +					vcpi->num_slots = 0;
> > > +					mutex_unlock(&mgr->payload_lock);
> > > +				} else {
> > > +					drm_dp_mst_topology_put_port(port_vali
> > > dated);
> > > +				}
> > > +			}
> > > +		}
> > > +	}
> > > +
> > >  	if (port->connector)
> > >  		drm_modeset_unlock(&mgr->base.lock);
> > >  	else if (create_connector)
> > --
> > Cheers,
> > 	Lyude Paul
> --
> Best regards,
> Wayne Lin
-- 
Cheers,
	Lyude Paul

