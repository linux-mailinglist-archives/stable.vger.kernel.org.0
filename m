Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 916E966857B
	for <lists+stable@lfdr.de>; Thu, 12 Jan 2023 22:34:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240203AbjALVe0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 12 Jan 2023 16:34:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56680 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240812AbjALVcl (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 12 Jan 2023 16:32:41 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 39533272B
        for <stable@vger.kernel.org>; Thu, 12 Jan 2023 13:16:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1673558185;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=33a74eDSTYehaGfAn/enobUTzEmdNrC9VwI5gUaFWbI=;
        b=DZYtJdLNIhOibg0P1kRJp+/hIjQMF4LZvHj6odPFT+VM956XiBhsZ9mbeAgDp0aoo4Nbi0
        oSZqP8hcokW5v+Mm3OLMoFVkQhINWRPMhMebZ0R9OXeljM3pIHvhVH63zVRrXAfVWY6Djc
        slnpeeUltTqLa/Sg2hS2ahKmL2viegY=
Received: from mail-qt1-f199.google.com (mail-qt1-f199.google.com
 [209.85.160.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-246-NNiD4_sAM4ywn5aCjQqBHQ-1; Thu, 12 Jan 2023 16:16:22 -0500
X-MC-Unique: NNiD4_sAM4ywn5aCjQqBHQ-1
Received: by mail-qt1-f199.google.com with SMTP id hf20-20020a05622a609400b003abcad051d2so9371644qtb.12
        for <stable@vger.kernel.org>; Thu, 12 Jan 2023 13:16:22 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=mime-version:user-agent:content-transfer-encoding:organization
         :references:in-reply-to:date:cc:to:from:subject:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=33a74eDSTYehaGfAn/enobUTzEmdNrC9VwI5gUaFWbI=;
        b=ze5jr4pfvdqzTbMURqSaiiQLjTWp6w3fOu8XHXqZXpvBsD57B+VqaR35ZxVKBYFrFZ
         7dB6ilN4+bQdTJyjanXy0RhgWZAESklhIsx9RJe1XlB5omksob/zFbKqQNOvvaD2pBQr
         l5r5Ljl8DlX46qctatS/kcO+Gw5TZMm+43/vUE4pkl0ShgtbFzLkVgrM+hf0ni++RDRZ
         EVdb/NqyA6mwiKZYSir1dHLzCzVATTTJitspvoYqrJt7CWsilhvRSIdSj47cG1vpujQD
         Y2QnBX8NOTeEXSe0GhO/GpbL40DcXyOZduxiNN4uEUb5nG+4rNh/cTkqHJrEnbgzF91i
         k7Rg==
X-Gm-Message-State: AFqh2kqWkb0la5WpsnofLaAOddbIWz3juT/PKiA9GNbNdrJpAPYAYsce
        dfOTWZN2tt/O02RP8uPc7bMhzagcs0tBsQ7uCUMY2Ug0APM7qjw9gYi8iqwNRlMFvzxO5lZDHcl
        5U8JrNI9GqY15u+fK
X-Received: by 2002:a05:622a:1b18:b0:3ac:4611:ef20 with SMTP id bb24-20020a05622a1b1800b003ac4611ef20mr27380752qtb.55.1673558181843;
        Thu, 12 Jan 2023 13:16:21 -0800 (PST)
X-Google-Smtp-Source: AMrXdXvEv8HbgYs1GqViZYxO2IFPXguApuXkgA8HolKp63rRIiQ5uCyMXycxiSTlFV72KjILfN/yEg==
X-Received: by 2002:a05:622a:1b18:b0:3ac:4611:ef20 with SMTP id bb24-20020a05622a1b1800b003ac4611ef20mr27380699qtb.55.1673558181270;
        Thu, 12 Jan 2023 13:16:21 -0800 (PST)
Received: from ?IPv6:2600:4040:5c68:6800:3463:5df7:aced:152e? ([2600:4040:5c68:6800:3463:5df7:aced:152e])
        by smtp.gmail.com with ESMTPSA id u8-20020a37ab08000000b00702311aea78sm11361220qke.82.2023.01.12.13.16.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 12 Jan 2023 13:16:20 -0800 (PST)
Message-ID: <4a303c926dc63a4451a661cdb4b4777c8830a17c.camel@redhat.com>
Subject: Re: [PATCH] Revert "drm/display/dp_mst: Move all payload info into
 the atomic state"
From:   Lyude Paul <lyude@redhat.com>
To:     Wayne Lin <Wayne.Lin@amd.com>, dri-devel@lists.freedesktop.org,
        amd-gfx@lists.freedesktop.org
Cc:     mario.limonciello@amd.com, harry.wentland@amd.com,
        jerry.zuo@amd.com, ville.syrjala@linux.intel.com,
        stanislav.lisovskiy@intel.com, bskeggs@redhat.com,
        stable@vger.kernel.org
Date:   Thu, 12 Jan 2023 16:16:19 -0500
In-Reply-To: <20230112085044.1706379-1-Wayne.Lin@amd.com>
References: <20230112085044.1706379-1-Wayne.Lin@amd.com>
Organization: Red Hat Inc.
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.44.4 (3.44.4-2.fc36) 
MIME-Version: 1.0
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Acked-by: Lyude Paul <lyude@redhat.com>

On Thu, 2023-01-12 at 16:50 +0800, Wayne Lin wrote:
> This reverts commit 4d07b0bc403403438d9cf88450506240c5faf92f.
>=20
> [Why]
> Changes cause regression on amdgpu mst.
> E.g.
> In fill_dc_mst_payload_table_from_drm(), amdgpu expects to add/remove pay=
load
> one by one and call fill_dc_mst_payload_table_from_drm() to update the HW
> maintained payload table. But previous change tries to go through all the
> payloads in mst_state and update amdpug hw maintained table in once every=
time
> driver only tries to add/remove a specific payload stream only. The newly
> design idea conflicts with the implementation in amdgpu nowadays.
>=20
> [How]
> Revert this patch first. After addressing all regression problems caused =
by
> this previous patch, will add it back and adjust it.
>=20
> Signed-off-by: Wayne Lin <Wayne.Lin@amd.com>
> Link: https://gitlab.freedesktop.org/drm/amd/-/issues/2171
> Cc: stable@vger.kernel.org # 6.1
> Cc: Lyude Paul <lyude@redhat.com>
> Cc: Harry Wentland <harry.wentland@amd.com>
> Cc: Mario Limonciello <mario.limonciello@amd.com>
> Cc: Ville Syrj=C3=A4l=C3=A4 <ville.syrjala@linux.intel.com>
> Cc: Ben Skeggs <bskeggs@redhat.com>
> Cc: Stanislav Lisovskiy <stanislav.lisovskiy@intel.com>
> Cc: Fangzhi Zuo <Jerry.Zuo@amd.com>
> ---
>  .../gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c |  53 +-
>  .../amd/display/amdgpu_dm/amdgpu_dm_helpers.c | 106 ++-
>  .../display/amdgpu_dm/amdgpu_dm_mst_types.c   |  87 ++-
>  .../amd/display/include/link_service_types.h  |   3 -
>  drivers/gpu/drm/display/drm_dp_mst_topology.c | 724 ++++++++++++------
>  drivers/gpu/drm/i915/display/intel_dp_mst.c   |  67 +-
>  drivers/gpu/drm/i915/display/intel_hdcp.c     |  24 +-
>  drivers/gpu/drm/nouveau/dispnv50/disp.c       | 167 ++--
>  include/drm/display/drm_dp_mst_helper.h       | 177 +++--
>  9 files changed, 878 insertions(+), 530 deletions(-)
>=20
> diff --git a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c b/drivers/=
gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
> index 77277d90b6e2..674f5dc1102b 100644
> --- a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
> +++ b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
> @@ -6548,7 +6548,6 @@ static int dm_encoder_helper_atomic_check(struct dr=
m_encoder *encoder,
>  	const struct drm_display_mode *adjusted_mode =3D &crtc_state->adjusted_=
mode;
>  	struct drm_dp_mst_topology_mgr *mst_mgr;
>  	struct drm_dp_mst_port *mst_port;
> -	struct drm_dp_mst_topology_state *mst_state;
>  	enum dc_color_depth color_depth;
>  	int clock, bpp =3D 0;
>  	bool is_y420 =3D false;
> @@ -6562,13 +6561,6 @@ static int dm_encoder_helper_atomic_check(struct d=
rm_encoder *encoder,
>  	if (!crtc_state->connectors_changed && !crtc_state->mode_changed)
>  		return 0;
> =20
> -	mst_state =3D drm_atomic_get_mst_topology_state(state, mst_mgr);
> -	if (IS_ERR(mst_state))
> -		return PTR_ERR(mst_state);
> -
> -	if (!mst_state->pbn_div)
> -		mst_state->pbn_div =3D dm_mst_get_pbn_divider(aconnector->mst_port->dc=
_link);
> -
>  	if (!state->duplicated) {
>  		int max_bpc =3D conn_state->max_requested_bpc;
>  		is_y420 =3D drm_mode_is_420_also(&connector->display_info, adjusted_mo=
de) &&
> @@ -6580,10 +6572,11 @@ static int dm_encoder_helper_atomic_check(struct =
drm_encoder *encoder,
>  		clock =3D adjusted_mode->clock;
>  		dm_new_connector_state->pbn =3D drm_dp_calc_pbn_mode(clock, bpp, false=
);
>  	}
> -
> -	dm_new_connector_state->vcpi_slots =3D
> -		drm_dp_atomic_find_time_slots(state, mst_mgr, mst_port,
> -					      dm_new_connector_state->pbn);
> +	dm_new_connector_state->vcpi_slots =3D drm_dp_atomic_find_time_slots(st=
ate,
> +									   mst_mgr,
> +									   mst_port,
> +									   dm_new_connector_state->pbn,
> +									   dm_mst_get_pbn_divider(aconnector->dc_link));
>  	if (dm_new_connector_state->vcpi_slots < 0) {
>  		DRM_DEBUG_ATOMIC("failed finding vcpi slots: %d\n", (int)dm_new_connec=
tor_state->vcpi_slots);
>  		return dm_new_connector_state->vcpi_slots;
> @@ -6654,14 +6647,17 @@ static int dm_update_mst_vcpi_slots_for_dsc(struc=
t drm_atomic_state *state,
>  			dm_conn_state->vcpi_slots =3D slot_num;
> =20
>  			ret =3D drm_dp_mst_atomic_enable_dsc(state, aconnector->port,
> -							   dm_conn_state->pbn, false);
> +							   dm_conn_state->pbn, 0, false);
>  			if (ret < 0)
>  				return ret;
> =20
>  			continue;
>  		}
> =20
> -		vcpi =3D drm_dp_mst_atomic_enable_dsc(state, aconnector->port, pbn, tr=
ue);
> +		vcpi =3D drm_dp_mst_atomic_enable_dsc(state,
> +						    aconnector->port,
> +						    pbn, pbn_div,
> +						    true);
>  		if (vcpi < 0)
>  			return vcpi;
> =20
> @@ -9497,6 +9493,8 @@ static int amdgpu_dm_atomic_check(struct drm_device=
 *dev,
>  	struct dm_crtc_state *dm_old_crtc_state, *dm_new_crtc_state;
>  #if defined(CONFIG_DRM_AMD_DC_DCN)
>  	struct dsc_mst_fairness_vars vars[MAX_PIPES];
> +	struct drm_dp_mst_topology_state *mst_state;
> +	struct drm_dp_mst_topology_mgr *mgr;
>  #endif
> =20
>  	trace_amdgpu_dm_atomic_check_begin(state);
> @@ -9744,6 +9742,33 @@ static int amdgpu_dm_atomic_check(struct drm_devic=
e *dev,
>  		lock_and_validation_needed =3D true;
>  	}
> =20
> +#if defined(CONFIG_DRM_AMD_DC_DCN)
> +	/* set the slot info for each mst_state based on the link encoding form=
at */
> +	for_each_new_mst_mgr_in_state(state, mgr, mst_state, i) {
> +		struct amdgpu_dm_connector *aconnector;
> +		struct drm_connector *connector;
> +		struct drm_connector_list_iter iter;
> +		u8 link_coding_cap;
> +
> +		if (!mgr->mst_state )
> +			continue;
> +
> +		drm_connector_list_iter_begin(dev, &iter);
> +		drm_for_each_connector_iter(connector, &iter) {
> +			int id =3D connector->index;
> +
> +			if (id =3D=3D mst_state->mgr->conn_base_id) {
> +				aconnector =3D to_amdgpu_dm_connector(connector);
> +				link_coding_cap =3D dc_link_dp_mst_decide_link_encoding_format(aconn=
ector->dc_link);
> +				drm_dp_mst_update_slots(mst_state, link_coding_cap);
> +
> +				break;
> +			}
> +		}
> +		drm_connector_list_iter_end(&iter);
> +
> +	}
> +#endif
>  	/**
>  	 * Streams and planes are reset when there are changes that affect
>  	 * bandwidth. Anything that affects bandwidth needs to go through
> diff --git a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_helpers.c b/=
drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_helpers.c
> index 6994c9a1ed85..ac5a8cad0695 100644
> --- a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_helpers.c
> +++ b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_helpers.c
> @@ -27,7 +27,6 @@
>  #include <linux/acpi.h>
>  #include <linux/i2c.h>
> =20
> -#include <drm/drm_atomic.h>
>  #include <drm/drm_probe_helper.h>
>  #include <drm/amdgpu_drm.h>
>  #include <drm/drm_edid.h>
> @@ -120,27 +119,40 @@ enum dc_edid_status dm_helpers_parse_edid_caps(
>  }
> =20
>  static void
> -fill_dc_mst_payload_table_from_drm(struct drm_dp_mst_topology_state *mst=
_state,
> -				   struct amdgpu_dm_connector *aconnector,
> -				   struct dc_dp_mst_stream_allocation_table *table)
> -{
> -	struct dc_dp_mst_stream_allocation_table new_table =3D { 0 };
> -	struct dc_dp_mst_stream_allocation *sa;
> -	struct drm_dp_mst_atomic_payload *payload;
> -
> -	/* Fill payload info*/
> -	list_for_each_entry(payload, &mst_state->payloads, next) {
> -		if (payload->delete)
> -			continue;
> -
> -		sa =3D &new_table.stream_allocations[new_table.stream_count];
> -		sa->slot_count =3D payload->time_slots;
> -		sa->vcp_id =3D payload->vcpi;
> -		new_table.stream_count++;
> +fill_dc_mst_payload_table_from_drm(struct amdgpu_dm_connector *aconnecto=
r,
> +				   struct dc_dp_mst_stream_allocation_table *proposed_table)
> +{
> +	int i;
> +	struct drm_dp_mst_topology_mgr *mst_mgr =3D
> +			&aconnector->mst_port->mst_mgr;
> +
> +	mutex_lock(&mst_mgr->payload_lock);
> +
> +	proposed_table->stream_count =3D 0;
> +
> +	/* number of active streams */
> +	for (i =3D 0; i < mst_mgr->max_payloads; i++) {
> +		if (mst_mgr->payloads[i].num_slots =3D=3D 0)
> +			break; /* end of vcp_id table */
> +
> +		ASSERT(mst_mgr->payloads[i].payload_state !=3D
> +				DP_PAYLOAD_DELETE_LOCAL);
> +
> +		if (mst_mgr->payloads[i].payload_state =3D=3D DP_PAYLOAD_LOCAL ||
> +			mst_mgr->payloads[i].payload_state =3D=3D
> +					DP_PAYLOAD_REMOTE) {
> +
> +			struct dc_dp_mst_stream_allocation *sa =3D
> +					&proposed_table->stream_allocations[
> +						proposed_table->stream_count];
> +
> +			sa->slot_count =3D mst_mgr->payloads[i].num_slots;
> +			sa->vcp_id =3D mst_mgr->proposed_vcpis[i]->vcpi;
> +			proposed_table->stream_count++;
> +		}
>  	}
> =20
> -	/* Overwrite the old table */
> -	*table =3D new_table;
> +	mutex_unlock(&mst_mgr->payload_lock);
>  }
> =20
>  void dm_helpers_dp_update_branch_info(
> @@ -158,9 +170,11 @@ bool dm_helpers_dp_mst_write_payload_allocation_tabl=
e(
>  		bool enable)
>  {
>  	struct amdgpu_dm_connector *aconnector;
> -	struct drm_dp_mst_topology_state *mst_state;
> -	struct drm_dp_mst_atomic_payload *payload;
> +	struct dm_connector_state *dm_conn_state;
>  	struct drm_dp_mst_topology_mgr *mst_mgr;
> +	struct drm_dp_mst_port *mst_port;
> +	bool ret;
> +	u8 link_coding_cap =3D DP_8b_10b_ENCODING;
> =20
>  	aconnector =3D (struct amdgpu_dm_connector *)stream->dm_stream_context;
>  	/* Accessing the connector state is required for vcpi_slots allocation
> @@ -171,21 +185,40 @@ bool dm_helpers_dp_mst_write_payload_allocation_tab=
le(
>  	if (!aconnector || !aconnector->mst_port)
>  		return false;
> =20
> +	dm_conn_state =3D to_dm_connector_state(aconnector->base.state);
> +
>  	mst_mgr =3D &aconnector->mst_port->mst_mgr;
> -	mst_state =3D to_drm_dp_mst_topology_state(mst_mgr->base.state);
> +
> +	if (!mst_mgr->mst_state)
> +		return false;
> +
> +	mst_port =3D aconnector->port;
> +
> +#if defined(CONFIG_DRM_AMD_DC_DCN)
> +	link_coding_cap =3D dc_link_dp_mst_decide_link_encoding_format(aconnect=
or->dc_link);
> +#endif
> +
> +	if (enable) {
> +
> +		ret =3D drm_dp_mst_allocate_vcpi(mst_mgr, mst_port,
> +					       dm_conn_state->pbn,
> +					       dm_conn_state->vcpi_slots);
> +		if (!ret)
> +			return false;
> +
> +	} else {
> +		drm_dp_mst_reset_vcpi_slots(mst_mgr, mst_port);
> +	}
> =20
>  	/* It's OK for this to fail */
> -	payload =3D drm_atomic_get_mst_payload_state(mst_state, aconnector->por=
t);
> -	if (enable)
> -		drm_dp_add_payload_part1(mst_mgr, mst_state, payload);
> -	else
> -		drm_dp_remove_payload(mst_mgr, mst_state, payload);
> +	drm_dp_update_payload_part1(mst_mgr, (link_coding_cap =3D=3D DP_CAP_ANS=
I_128B132B) ? 0:1);
> =20
>  	/* mst_mgr->->payloads are VC payload notify MST branch using DPCD or
>  	 * AUX message. The sequence is slot 1-63 allocated sequence for each
>  	 * stream. AMD ASIC stream slot allocation should follow the same
>  	 * sequence. copy DRM MST allocation to dc */
> -	fill_dc_mst_payload_table_from_drm(mst_state, aconnector, proposed_tabl=
e);
> +
> +	fill_dc_mst_payload_table_from_drm(aconnector, proposed_table);
> =20
>  	return true;
>  }
> @@ -242,9 +275,8 @@ bool dm_helpers_dp_mst_send_payload_allocation(
>  		bool enable)
>  {
>  	struct amdgpu_dm_connector *aconnector;
> -	struct drm_dp_mst_topology_state *mst_state;
>  	struct drm_dp_mst_topology_mgr *mst_mgr;
> -	struct drm_dp_mst_atomic_payload *payload;
> +	struct drm_dp_mst_port *mst_port;
>  	enum mst_progress_status set_flag =3D MST_ALLOCATE_NEW_PAYLOAD;
>  	enum mst_progress_status clr_flag =3D MST_CLEAR_ALLOCATED_PAYLOAD;
> =20
> @@ -253,16 +285,19 @@ bool dm_helpers_dp_mst_send_payload_allocation(
>  	if (!aconnector || !aconnector->mst_port)
>  		return false;
> =20
> +	mst_port =3D aconnector->port;
> +
>  	mst_mgr =3D &aconnector->mst_port->mst_mgr;
> -	mst_state =3D to_drm_dp_mst_topology_state(mst_mgr->base.state);
> =20
> -	payload =3D drm_atomic_get_mst_payload_state(mst_state, aconnector->por=
t);
> +	if (!mst_mgr->mst_state)
> +		return false;
> +
>  	if (!enable) {
>  		set_flag =3D MST_CLEAR_ALLOCATED_PAYLOAD;
>  		clr_flag =3D MST_ALLOCATE_NEW_PAYLOAD;
>  	}
> =20
> -	if (enable && drm_dp_add_payload_part2(mst_mgr, mst_state->base.state, =
payload)) {
> +	if (drm_dp_update_payload_part2(mst_mgr)) {
>  		amdgpu_dm_set_mst_status(&aconnector->mst_status,
>  			set_flag, false);
>  	} else {
> @@ -272,6 +307,9 @@ bool dm_helpers_dp_mst_send_payload_allocation(
>  			clr_flag, false);
>  	}
> =20
> +	if (!enable)
> +		drm_dp_mst_deallocate_vcpi(mst_mgr, mst_port);
> +
>  	return true;
>  }
> =20
> diff --git a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_mst_types.c =
b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_mst_types.c
> index 1edf7385f8d8..6207026a200f 100644
> --- a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_mst_types.c
> +++ b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_mst_types.c
> @@ -598,8 +598,15 @@ void amdgpu_dm_initialize_dp_connector(struct amdgpu=
_display_manager *dm,
> =20
>  	dc_link_dp_get_max_link_enc_cap(aconnector->dc_link, &max_link_enc_cap)=
;
>  	aconnector->mst_mgr.cbs =3D &dm_mst_cbs;
> -	drm_dp_mst_topology_mgr_init(&aconnector->mst_mgr, adev_to_drm(dm->adev=
),
> -				     &aconnector->dm_dp_aux.aux, 16, 4, aconnector->connector_id);
> +	drm_dp_mst_topology_mgr_init(
> +		&aconnector->mst_mgr,
> +		adev_to_drm(dm->adev),
> +		&aconnector->dm_dp_aux.aux,
> +		16,
> +		4,
> +		max_link_enc_cap.lane_count,
> +		drm_dp_bw_code_to_link_rate(max_link_enc_cap.link_rate),
> +		aconnector->connector_id);
> =20
>  	drm_connector_attach_dp_subconnector_property(&aconnector->base);
>  }
> @@ -710,13 +717,12 @@ static int bpp_x16_from_pbn(struct dsc_mst_fairness=
_params param, int pbn)
>  	return dsc_config.bits_per_pixel;
>  }
> =20
> -static int increase_dsc_bpp(struct drm_atomic_state *state,
> -			    struct drm_dp_mst_topology_state *mst_state,
> -			    struct dc_link *dc_link,
> -			    struct dsc_mst_fairness_params *params,
> -			    struct dsc_mst_fairness_vars *vars,
> -			    int count,
> -			    int k)
> +static bool increase_dsc_bpp(struct drm_atomic_state *state,
> +			     struct dc_link *dc_link,
> +			     struct dsc_mst_fairness_params *params,
> +			     struct dsc_mst_fairness_vars *vars,
> +			     int count,
> +			     int k)
>  {
>  	int i;
>  	bool bpp_increased[MAX_PIPES];
> @@ -724,10 +730,13 @@ static int increase_dsc_bpp(struct drm_atomic_state=
 *state,
>  	int min_initial_slack;
>  	int next_index;
>  	int remaining_to_increase =3D 0;
> +	int pbn_per_timeslot;
>  	int link_timeslots_used;
>  	int fair_pbn_alloc;
>  	int ret =3D 0;
> =20
> +	pbn_per_timeslot =3D dm_mst_get_pbn_divider(dc_link);
> +
>  	for (i =3D 0; i < count; i++) {
>  		if (vars[i + k].dsc_enabled) {
>  			initial_slack[i] =3D
> @@ -758,17 +767,18 @@ static int increase_dsc_bpp(struct drm_atomic_state=
 *state,
>  		link_timeslots_used =3D 0;
> =20
>  		for (i =3D 0; i < count; i++)
> -			link_timeslots_used +=3D DIV_ROUND_UP(vars[i + k].pbn, mst_state->pbn=
_div);
> +			link_timeslots_used +=3D DIV_ROUND_UP(vars[i + k].pbn, pbn_per_timesl=
ot);
> =20
> -		fair_pbn_alloc =3D
> -			(63 - link_timeslots_used) / remaining_to_increase * mst_state->pbn_d=
iv;
> +		fair_pbn_alloc =3D (63 - link_timeslots_used) / remaining_to_increase =
* pbn_per_timeslot;
> =20
>  		if (initial_slack[next_index] > fair_pbn_alloc) {
>  			vars[next_index].pbn +=3D fair_pbn_alloc;
> +
>  			ret =3D drm_dp_atomic_find_time_slots(state,
>  							    params[next_index].port->mgr,
>  							    params[next_index].port,
> -							    vars[next_index].pbn);
> +							    vars[next_index].pbn,
> +							    pbn_per_timeslot);
>  			if (ret < 0)
>  				return ret;
> =20
> @@ -780,7 +790,8 @@ static int increase_dsc_bpp(struct drm_atomic_state *=
state,
>  				ret =3D drm_dp_atomic_find_time_slots(state,
>  								    params[next_index].port->mgr,
>  								    params[next_index].port,
> -								    vars[next_index].pbn);
> +								    vars[next_index].pbn,
> +								    pbn_per_timeslot);
>  				if (ret < 0)
>  					return ret;
>  			}
> @@ -789,7 +800,8 @@ static int increase_dsc_bpp(struct drm_atomic_state *=
state,
>  			ret =3D drm_dp_atomic_find_time_slots(state,
>  							    params[next_index].port->mgr,
>  							    params[next_index].port,
> -							    vars[next_index].pbn);
> +							    vars[next_index].pbn,
> +							    pbn_per_timeslot);
>  			if (ret < 0)
>  				return ret;
> =20
> @@ -801,7 +813,8 @@ static int increase_dsc_bpp(struct drm_atomic_state *=
state,
>  				ret =3D drm_dp_atomic_find_time_slots(state,
>  								    params[next_index].port->mgr,
>  								    params[next_index].port,
> -								    vars[next_index].pbn);
> +								    vars[next_index].pbn,
> +								    pbn_per_timeslot);
>  				if (ret < 0)
>  					return ret;
>  			}
> @@ -857,10 +870,12 @@ static int try_disable_dsc(struct drm_atomic_state =
*state,
>  			break;
> =20
>  		vars[next_index].pbn =3D kbps_to_peak_pbn(params[next_index].bw_range.=
stream_kbps);
> +
>  		ret =3D drm_dp_atomic_find_time_slots(state,
>  						    params[next_index].port->mgr,
>  						    params[next_index].port,
> -						    vars[next_index].pbn);
> +						    vars[next_index].pbn,
> +						    dm_mst_get_pbn_divider(dc_link));
>  		if (ret < 0)
>  			return ret;
> =20
> @@ -870,10 +885,12 @@ static int try_disable_dsc(struct drm_atomic_state =
*state,
>  			vars[next_index].bpp_x16 =3D 0;
>  		} else {
>  			vars[next_index].pbn =3D kbps_to_peak_pbn(params[next_index].bw_range=
.max_kbps);
> +
>  			ret =3D drm_dp_atomic_find_time_slots(state,
>  							    params[next_index].port->mgr,
>  							    params[next_index].port,
> -							    vars[next_index].pbn);
> +							    vars[next_index].pbn,
> +							    dm_mst_get_pbn_divider(dc_link));
>  			if (ret < 0)
>  				return ret;
>  		}
> @@ -884,31 +901,21 @@ static int try_disable_dsc(struct drm_atomic_state =
*state,
>  	return 0;
>  }
> =20
> -static int compute_mst_dsc_configs_for_link(struct drm_atomic_state *sta=
te,
> -					    struct dc_state *dc_state,
> -					    struct dc_link *dc_link,
> -					    struct dsc_mst_fairness_vars *vars,
> -					    struct drm_dp_mst_topology_mgr *mgr,
> -					    int *link_vars_start_index)
> +static bool compute_mst_dsc_configs_for_link(struct drm_atomic_state *st=
ate,
> +					     struct dc_state *dc_state,
> +					     struct dc_link *dc_link,
> +					     struct dsc_mst_fairness_vars *vars,
> +					     int *link_vars_start_index)
>  {
> +	int i, k, ret;
>  	struct dc_stream_state *stream;
>  	struct dsc_mst_fairness_params params[MAX_PIPES];
>  	struct amdgpu_dm_connector *aconnector;
> -	struct drm_dp_mst_topology_state *mst_state =3D drm_atomic_get_mst_topo=
logy_state(state, mgr);
>  	int count =3D 0;
> -	int i, k, ret;
>  	bool debugfs_overwrite =3D false;
> =20
>  	memset(params, 0, sizeof(params));
> =20
> -	if (IS_ERR(mst_state))
> -		return PTR_ERR(mst_state);
> -
> -	mst_state->pbn_div =3D dm_mst_get_pbn_divider(dc_link);
> -#if defined(CONFIG_DRM_AMD_DC_DCN)
> -	drm_dp_mst_update_slots(mst_state, dc_link_dp_mst_decide_link_encoding_=
format(dc_link));
> -#endif
> -
>  	/* Set up params */
>  	for (i =3D 0; i < dc_state->stream_count; i++) {
>  		struct dc_dsc_policy dsc_policy =3D {0};
> @@ -968,7 +975,7 @@ static int compute_mst_dsc_configs_for_link(struct dr=
m_atomic_state *state,
>  		vars[i + k].dsc_enabled =3D false;
>  		vars[i + k].bpp_x16 =3D 0;
>  		ret =3D drm_dp_atomic_find_time_slots(state, params[i].port->mgr, para=
ms[i].port,
> -						    vars[i + k].pbn);
> +						    vars[i + k].pbn, dm_mst_get_pbn_divider(dc_link));
>  		if (ret < 0)
>  			return ret;
>  	}
> @@ -987,7 +994,7 @@ static int compute_mst_dsc_configs_for_link(struct dr=
m_atomic_state *state,
>  			vars[i + k].dsc_enabled =3D true;
>  			vars[i + k].bpp_x16 =3D params[i].bw_range.min_target_bpp_x16;
>  			ret =3D drm_dp_atomic_find_time_slots(state, params[i].port->mgr,
> -							    params[i].port, vars[i + k].pbn);
> +							    params[i].port, vars[i + k].pbn, dm_mst_get_pbn_divider(dc_li=
nk));
>  			if (ret < 0)
>  				return ret;
>  		} else {
> @@ -995,7 +1002,7 @@ static int compute_mst_dsc_configs_for_link(struct d=
rm_atomic_state *state,
>  			vars[i + k].dsc_enabled =3D false;
>  			vars[i + k].bpp_x16 =3D 0;
>  			ret =3D drm_dp_atomic_find_time_slots(state, params[i].port->mgr,
> -							    params[i].port, vars[i + k].pbn);
> +							    params[i].port, vars[i + k].pbn, dm_mst_get_pbn_divider(dc_li=
nk));
>  			if (ret < 0)
>  				return ret;
>  		}
> @@ -1005,7 +1012,7 @@ static int compute_mst_dsc_configs_for_link(struct =
drm_atomic_state *state,
>  		return ret;
> =20
>  	/* Optimize degree of compression */
> -	ret =3D increase_dsc_bpp(state, mst_state, dc_link, params, vars, count=
, k);
> +	ret =3D increase_dsc_bpp(state, dc_link, params, vars, count, k);
>  	if (ret < 0)
>  		return ret;
> =20
> @@ -1155,7 +1162,7 @@ int compute_mst_dsc_configs_for_state(struct drm_at=
omic_state *state,
>  			continue;
> =20
>  		mst_mgr =3D aconnector->port->mgr;
> -		ret =3D compute_mst_dsc_configs_for_link(state, dc_state, stream->link=
, vars, mst_mgr,
> +		ret =3D compute_mst_dsc_configs_for_link(state, dc_state, stream->link=
, vars,
>  						       &link_vars_start_index);
>  		if (ret !=3D 0)
>  			return ret;
> @@ -1213,7 +1220,7 @@ static int pre_compute_mst_dsc_configs_for_state(st=
ruct drm_atomic_state *state,
>  			continue;
> =20
>  		mst_mgr =3D aconnector->port->mgr;
> -		ret =3D compute_mst_dsc_configs_for_link(state, dc_state, stream->link=
, vars, mst_mgr,
> +		ret =3D compute_mst_dsc_configs_for_link(state, dc_state, stream->link=
, vars,
>  						       &link_vars_start_index);
>  		if (ret !=3D 0)
>  			return ret;
> diff --git a/drivers/gpu/drm/amd/display/include/link_service_types.h b/d=
rivers/gpu/drm/amd/display/include/link_service_types.h
> index d1e91d31d151..0889c2a86733 100644
> --- a/drivers/gpu/drm/amd/display/include/link_service_types.h
> +++ b/drivers/gpu/drm/amd/display/include/link_service_types.h
> @@ -252,9 +252,6 @@ union dpcd_training_lane_set {
>   * _ONLY_ be filled out from DM and then passed to DC, do NOT use these =
for _any_ kind of atomic
>   * state calculations in DM, or you will break something.
>   */
> -
> -struct drm_dp_mst_port;
> -
>  /* DP MST stream allocation (payload bandwidth number) */
>  struct dc_dp_mst_stream_allocation {
>  	uint8_t vcp_id;
> diff --git a/drivers/gpu/drm/display/drm_dp_mst_topology.c b/drivers/gpu/=
drm/display/drm_dp_mst_topology.c
> index 51a46689cda7..95ff57d20216 100644
> --- a/drivers/gpu/drm/display/drm_dp_mst_topology.c
> +++ b/drivers/gpu/drm/display/drm_dp_mst_topology.c
> @@ -68,7 +68,8 @@ static bool dump_dp_payload_table(struct drm_dp_mst_top=
ology_mgr *mgr,
>  static void drm_dp_mst_topology_put_port(struct drm_dp_mst_port *port);
> =20
>  static int drm_dp_dpcd_write_payload(struct drm_dp_mst_topology_mgr *mgr=
,
> -				     int id, u8 start_slot, u8 num_slots);
> +				     int id,
> +				     struct drm_dp_payload *payload);
> =20
>  static int drm_dp_send_dpcd_read(struct drm_dp_mst_topology_mgr *mgr,
>  				 struct drm_dp_mst_port *port,
> @@ -1234,6 +1235,57 @@ build_query_stream_enc_status(struct drm_dp_sideba=
nd_msg_tx *msg, u8 stream_id,
>  	return 0;
>  }
> =20
> +static int drm_dp_mst_assign_payload_id(struct drm_dp_mst_topology_mgr *=
mgr,
> +					struct drm_dp_vcpi *vcpi)
> +{
> +	int ret, vcpi_ret;
> +
> +	mutex_lock(&mgr->payload_lock);
> +	ret =3D find_first_zero_bit(&mgr->payload_mask, mgr->max_payloads + 1);
> +	if (ret > mgr->max_payloads) {
> +		ret =3D -EINVAL;
> +		drm_dbg_kms(mgr->dev, "out of payload ids %d\n", ret);
> +		goto out_unlock;
> +	}
> +
> +	vcpi_ret =3D find_first_zero_bit(&mgr->vcpi_mask, mgr->max_payloads + 1=
);
> +	if (vcpi_ret > mgr->max_payloads) {
> +		ret =3D -EINVAL;
> +		drm_dbg_kms(mgr->dev, "out of vcpi ids %d\n", ret);
> +		goto out_unlock;
> +	}
> +
> +	set_bit(ret, &mgr->payload_mask);
> +	set_bit(vcpi_ret, &mgr->vcpi_mask);
> +	vcpi->vcpi =3D vcpi_ret + 1;
> +	mgr->proposed_vcpis[ret - 1] =3D vcpi;
> +out_unlock:
> +	mutex_unlock(&mgr->payload_lock);
> +	return ret;
> +}
> +
> +static void drm_dp_mst_put_payload_id(struct drm_dp_mst_topology_mgr *mg=
r,
> +				      int vcpi)
> +{
> +	int i;
> +
> +	if (vcpi =3D=3D 0)
> +		return;
> +
> +	mutex_lock(&mgr->payload_lock);
> +	drm_dbg_kms(mgr->dev, "putting payload %d\n", vcpi);
> +	clear_bit(vcpi - 1, &mgr->vcpi_mask);
> +
> +	for (i =3D 0; i < mgr->max_payloads; i++) {
> +		if (mgr->proposed_vcpis[i] &&
> +		    mgr->proposed_vcpis[i]->vcpi =3D=3D vcpi) {
> +			mgr->proposed_vcpis[i] =3D NULL;
> +			clear_bit(i + 1, &mgr->payload_mask);
> +		}
> +	}
> +	mutex_unlock(&mgr->payload_lock);
> +}
> +
>  static bool check_txmsg_state(struct drm_dp_mst_topology_mgr *mgr,
>  			      struct drm_dp_sideband_msg_tx *txmsg)
>  {
> @@ -1686,7 +1738,7 @@ drm_dp_mst_dump_port_topology_history(struct drm_dp=
_mst_port *port) {}
>  #define save_port_topology_ref(port, type)
>  #endif
> =20
> -struct drm_dp_mst_atomic_payload *
> +static struct drm_dp_mst_atomic_payload *
>  drm_atomic_get_mst_payload_state(struct drm_dp_mst_topology_state *state=
,
>  				 struct drm_dp_mst_port *port)
>  {
> @@ -1698,7 +1750,6 @@ drm_atomic_get_mst_payload_state(struct drm_dp_mst_=
topology_state *state,
> =20
>  	return NULL;
>  }
> -EXPORT_SYMBOL(drm_atomic_get_mst_payload_state);
> =20
>  static void drm_dp_destroy_mst_branch_device(struct kref *kref)
>  {
> @@ -3201,8 +3252,6 @@ int drm_dp_send_query_stream_enc_status(struct drm_=
dp_mst_topology_mgr *mgr,
>  		struct drm_dp_mst_port *port,
>  		struct drm_dp_query_stream_enc_status_ack_reply *status)
>  {
> -	struct drm_dp_mst_topology_state *state;
> -	struct drm_dp_mst_atomic_payload *payload;
>  	struct drm_dp_sideband_msg_tx *txmsg;
>  	u8 nonce[7];
>  	int ret;
> @@ -3219,10 +3268,6 @@ int drm_dp_send_query_stream_enc_status(struct drm=
_dp_mst_topology_mgr *mgr,
> =20
>  	get_random_bytes(nonce, sizeof(nonce));
> =20
> -	drm_modeset_lock(&mgr->base.lock, NULL);
> -	state =3D to_drm_dp_mst_topology_state(mgr->base.state);
> -	payload =3D drm_atomic_get_mst_payload_state(state, port);
> -
>  	/*
>  	 * "Source device targets the QUERY_STREAM_ENCRYPTION_STATUS message
>  	 *  transaction at the MST Branch device directly connected to the
> @@ -3230,7 +3275,7 @@ int drm_dp_send_query_stream_enc_status(struct drm_=
dp_mst_topology_mgr *mgr,
>  	 */
>  	txmsg->dst =3D mgr->mst_primary;
> =20
> -	build_query_stream_enc_status(txmsg, payload->vcpi, nonce);
> +	build_query_stream_enc_status(txmsg, port->vcpi.vcpi, nonce);
> =20
>  	drm_dp_queue_down_tx(mgr, txmsg);
> =20
> @@ -3247,7 +3292,6 @@ int drm_dp_send_query_stream_enc_status(struct drm_=
dp_mst_topology_mgr *mgr,
>  	memcpy(status, &txmsg->reply.u.enc_status, sizeof(*status));
> =20
>  out:
> -	drm_modeset_unlock(&mgr->base.lock);
>  	drm_dp_mst_topology_put_port(port);
>  out_get_port:
>  	kfree(txmsg);
> @@ -3256,162 +3300,238 @@ int drm_dp_send_query_stream_enc_status(struct =
drm_dp_mst_topology_mgr *mgr,
>  EXPORT_SYMBOL(drm_dp_send_query_stream_enc_status);
> =20
>  static int drm_dp_create_payload_step1(struct drm_dp_mst_topology_mgr *m=
gr,
> -				       struct drm_dp_mst_atomic_payload *payload)
> +				       int id,
> +				       struct drm_dp_payload *payload)
>  {
> -	return drm_dp_dpcd_write_payload(mgr, payload->vcpi, payload->vc_start_=
slot,
> -					 payload->time_slots);
> +	int ret;
> +
> +	ret =3D drm_dp_dpcd_write_payload(mgr, id, payload);
> +	if (ret < 0) {
> +		payload->payload_state =3D 0;
> +		return ret;
> +	}
> +	payload->payload_state =3D DP_PAYLOAD_LOCAL;
> +	return 0;
>  }
> =20
>  static int drm_dp_create_payload_step2(struct drm_dp_mst_topology_mgr *m=
gr,
> -				       struct drm_dp_mst_atomic_payload *payload)
> +				       struct drm_dp_mst_port *port,
> +				       int id,
> +				       struct drm_dp_payload *payload)
>  {
>  	int ret;
> -	struct drm_dp_mst_port *port =3D drm_dp_mst_topology_get_port_validated=
(mgr, payload->port);
> -
> -	if (!port)
> -		return -EIO;
> =20
> -	ret =3D drm_dp_payload_send_msg(mgr, port, payload->vcpi, payload->pbn)=
;
> -	drm_dp_mst_topology_put_port(port);
> +	ret =3D drm_dp_payload_send_msg(mgr, port, id, port->vcpi.pbn);
> +	if (ret < 0)
> +		return ret;
> +	payload->payload_state =3D DP_PAYLOAD_REMOTE;
>  	return ret;
>  }
> =20
>  static int drm_dp_destroy_payload_step1(struct drm_dp_mst_topology_mgr *=
mgr,
> -					struct drm_dp_mst_topology_state *mst_state,
> -					struct drm_dp_mst_atomic_payload *payload)
> +					struct drm_dp_mst_port *port,
> +					int id,
> +					struct drm_dp_payload *payload)
>  {
>  	drm_dbg_kms(mgr->dev, "\n");
> -
>  	/* it's okay for these to fail */
> -	drm_dp_payload_send_msg(mgr, payload->port, payload->vcpi, 0);
> -	drm_dp_dpcd_write_payload(mgr, payload->vcpi, payload->vc_start_slot, 0=
);
> +	if (port) {
> +		drm_dp_payload_send_msg(mgr, port, id, 0);
> +	}
> =20
> +	drm_dp_dpcd_write_payload(mgr, id, payload);
> +	payload->payload_state =3D DP_PAYLOAD_DELETE_LOCAL;
> +	return 0;
> +}
> +
> +static int drm_dp_destroy_payload_step2(struct drm_dp_mst_topology_mgr *=
mgr,
> +					int id,
> +					struct drm_dp_payload *payload)
> +{
> +	payload->payload_state =3D 0;
>  	return 0;
>  }
> =20
>  /**
> - * drm_dp_add_payload_part1() - Execute payload update part 1
> - * @mgr: Manager to use.
> - * @mst_state: The MST atomic state
> - * @payload: The payload to write
> + * drm_dp_update_payload_part1() - Execute payload update part 1
> + * @mgr: manager to use.
> + * @start_slot: this is the cur slot
> + *
> + * NOTE: start_slot is a temporary workaround for non-atomic drivers,
> + * this will be removed when non-atomic mst helpers are moved out of the=
 helper
>   *
> - * Determines the starting time slot for the given payload, and programs=
 the VCPI for this payload
> - * into hardware. After calling this, the driver should generate ACT and=
 payload packets.
> + * This iterates over all proposed virtual channels, and tries to
> + * allocate space in the link for them. For 0->slots transitions,
> + * this step just writes the VCPI to the MST device. For slots->0
> + * transitions, this writes the updated VCPIs and removes the
> + * remote VC payloads.
>   *
> - * Returns: 0 on success, error code on failure. In the event that this =
fails,
> - * @payload.vc_start_slot will also be set to -1.
> + * after calling this the driver should generate ACT and payload
> + * packets.
>   */
> -int drm_dp_add_payload_part1(struct drm_dp_mst_topology_mgr *mgr,
> -			     struct drm_dp_mst_topology_state *mst_state,
> -			     struct drm_dp_mst_atomic_payload *payload)
> +int drm_dp_update_payload_part1(struct drm_dp_mst_topology_mgr *mgr, int=
 start_slot)
>  {
> +	struct drm_dp_payload req_payload;
>  	struct drm_dp_mst_port *port;
> -	int ret;
> +	int i, j;
> +	int cur_slots =3D start_slot;
> +	bool skip;
> =20
> -	port =3D drm_dp_mst_topology_get_port_validated(mgr, payload->port);
> -	if (!port)
> -		return 0;
> +	mutex_lock(&mgr->payload_lock);
> +	for (i =3D 0; i < mgr->max_payloads; i++) {
> +		struct drm_dp_vcpi *vcpi =3D mgr->proposed_vcpis[i];
> +		struct drm_dp_payload *payload =3D &mgr->payloads[i];
> +		bool put_port =3D false;
> =20
> -	if (mgr->payload_count =3D=3D 0)
> -		mgr->next_start_slot =3D mst_state->start_slot;
> +		/* solve the current payloads - compare to the hw ones
> +		   - update the hw view */
> +		req_payload.start_slot =3D cur_slots;
> +		if (vcpi) {
> +			port =3D container_of(vcpi, struct drm_dp_mst_port,
> +					    vcpi);
> =20
> -	payload->vc_start_slot =3D mgr->next_start_slot;
> +			mutex_lock(&mgr->lock);
> +			skip =3D !drm_dp_mst_port_downstream_of_branch(port, mgr->mst_primary=
);
> +			mutex_unlock(&mgr->lock);
> =20
> -	ret =3D drm_dp_create_payload_step1(mgr, payload);
> -	drm_dp_mst_topology_put_port(port);
> -	if (ret < 0) {
> -		drm_warn(mgr->dev, "Failed to create MST payload for port %p: %d\n",
> -			 payload->port, ret);
> -		payload->vc_start_slot =3D -1;
> -		return ret;
> -	}
> +			if (skip) {
> +				drm_dbg_kms(mgr->dev,
> +					    "Virtual channel %d is not in current topology\n",
> +					    i);
> +				continue;
> +			}
> +			/* Validated ports don't matter if we're releasing
> +			 * VCPI
> +			 */
> +			if (vcpi->num_slots) {
> +				port =3D drm_dp_mst_topology_get_port_validated(
> +				    mgr, port);
> +				if (!port) {
> +					if (vcpi->num_slots =3D=3D payload->num_slots) {
> +						cur_slots +=3D vcpi->num_slots;
> +						payload->start_slot =3D req_payload.start_slot;
> +						continue;
> +					} else {
> +						drm_dbg_kms(mgr->dev,
> +							    "Fail:set payload to invalid sink");
> +						mutex_unlock(&mgr->payload_lock);
> +						return -EINVAL;
> +					}
> +				}
> +				put_port =3D true;
> +			}
> =20
> -	mgr->payload_count++;
> -	mgr->next_start_slot +=3D payload->time_slots;
> +			req_payload.num_slots =3D vcpi->num_slots;
> +			req_payload.vcpi =3D vcpi->vcpi;
> +		} else {
> +			port =3D NULL;
> +			req_payload.num_slots =3D 0;
> +		}
> =20
> -	return 0;
> -}
> -EXPORT_SYMBOL(drm_dp_add_payload_part1);
> +		payload->start_slot =3D req_payload.start_slot;
> +		/* work out what is required to happen with this payload */
> +		if (payload->num_slots !=3D req_payload.num_slots) {
> +
> +			/* need to push an update for this payload */
> +			if (req_payload.num_slots) {
> +				drm_dp_create_payload_step1(mgr, vcpi->vcpi,
> +							    &req_payload);
> +				payload->num_slots =3D req_payload.num_slots;
> +				payload->vcpi =3D req_payload.vcpi;
> +
> +			} else if (payload->num_slots) {
> +				payload->num_slots =3D 0;
> +				drm_dp_destroy_payload_step1(mgr, port,
> +							     payload->vcpi,
> +							     payload);
> +				req_payload.payload_state =3D
> +					payload->payload_state;
> +				payload->start_slot =3D 0;
> +			}
> +			payload->payload_state =3D req_payload.payload_state;
> +		}
> +		cur_slots +=3D req_payload.num_slots;
> =20
> -/**
> - * drm_dp_remove_payload() - Remove an MST payload
> - * @mgr: Manager to use.
> - * @mst_state: The MST atomic state
> - * @payload: The payload to write
> - *
> - * Removes a payload from an MST topology if it was successfully assigne=
d a start slot. Also updates
> - * the starting time slots of all other payloads which would have been s=
hifted towards the start of
> - * the VC table as a result. After calling this, the driver should gener=
ate ACT and payload packets.
> - */
> -void drm_dp_remove_payload(struct drm_dp_mst_topology_mgr *mgr,
> -			   struct drm_dp_mst_topology_state *mst_state,
> -			   struct drm_dp_mst_atomic_payload *payload)
> -{
> -	struct drm_dp_mst_atomic_payload *pos;
> -	bool send_remove =3D false;
> +		if (put_port)
> +			drm_dp_mst_topology_put_port(port);
> +	}
> =20
> -	/* We failed to make the payload, so nothing to do */
> -	if (payload->vc_start_slot =3D=3D -1)
> -		return;
> +	for (i =3D 0; i < mgr->max_payloads; /* do nothing */) {
> +		if (mgr->payloads[i].payload_state !=3D DP_PAYLOAD_DELETE_LOCAL) {
> +			i++;
> +			continue;
> +		}
> =20
> -	mutex_lock(&mgr->lock);
> -	send_remove =3D drm_dp_mst_port_downstream_of_branch(payload->port, mgr=
->mst_primary);
> -	mutex_unlock(&mgr->lock);
> +		drm_dbg_kms(mgr->dev, "removing payload %d\n", i);
> +		for (j =3D i; j < mgr->max_payloads - 1; j++) {
> +			mgr->payloads[j] =3D mgr->payloads[j + 1];
> +			mgr->proposed_vcpis[j] =3D mgr->proposed_vcpis[j + 1];
> =20
> -	if (send_remove)
> -		drm_dp_destroy_payload_step1(mgr, mst_state, payload);
> -	else
> -		drm_dbg_kms(mgr->dev, "Payload for VCPI %d not in topology, not sendin=
g remove\n",
> -			    payload->vcpi);
> +			if (mgr->proposed_vcpis[j] &&
> +			    mgr->proposed_vcpis[j]->num_slots) {
> +				set_bit(j + 1, &mgr->payload_mask);
> +			} else {
> +				clear_bit(j + 1, &mgr->payload_mask);
> +			}
> +		}
> =20
> -	list_for_each_entry(pos, &mst_state->payloads, next) {
> -		if (pos !=3D payload && pos->vc_start_slot > payload->vc_start_slot)
> -			pos->vc_start_slot -=3D payload->time_slots;
> +		memset(&mgr->payloads[mgr->max_payloads - 1], 0,
> +		       sizeof(struct drm_dp_payload));
> +		mgr->proposed_vcpis[mgr->max_payloads - 1] =3D NULL;
> +		clear_bit(mgr->max_payloads, &mgr->payload_mask);
>  	}
> -	payload->vc_start_slot =3D -1;
> +	mutex_unlock(&mgr->payload_lock);
> =20
> -	mgr->payload_count--;
> -	mgr->next_start_slot -=3D payload->time_slots;
> +	return 0;
>  }
> -EXPORT_SYMBOL(drm_dp_remove_payload);
> +EXPORT_SYMBOL(drm_dp_update_payload_part1);
> =20
>  /**
> - * drm_dp_add_payload_part2() - Execute payload update part 2
> - * @mgr: Manager to use.
> - * @state: The global atomic state
> - * @payload: The payload to update
> - *
> - * If @payload was successfully assigned a starting time slot by drm_dp_=
add_payload_part1(), this
> - * function will send the sideband messages to finish allocating this pa=
yload.
> + * drm_dp_update_payload_part2() - Execute payload update part 2
> + * @mgr: manager to use.
>   *
> - * Returns: 0 on success, negative error code on failure.
> + * This iterates over all proposed virtual channels, and tries to
> + * allocate space in the link for them. For 0->slots transitions,
> + * this step writes the remote VC payload commands. For slots->0
> + * this just resets some internal state.
>   */
> -int drm_dp_add_payload_part2(struct drm_dp_mst_topology_mgr *mgr,
> -			     struct drm_atomic_state *state,
> -			     struct drm_dp_mst_atomic_payload *payload)
> +int drm_dp_update_payload_part2(struct drm_dp_mst_topology_mgr *mgr)
>  {
> +	struct drm_dp_mst_port *port;
> +	int i;
>  	int ret =3D 0;
> +	bool skip;
> =20
> -	/* Skip failed payloads */
> -	if (payload->vc_start_slot =3D=3D -1) {
> -		drm_dbg_kms(state->dev, "Part 1 of payload creation for %s failed, ski=
pping part 2\n",
> -			    payload->port->connector->name);
> -		return -EIO;
> -	}
> +	mutex_lock(&mgr->payload_lock);
> +	for (i =3D 0; i < mgr->max_payloads; i++) {
> =20
> -	ret =3D drm_dp_create_payload_step2(mgr, payload);
> -	if (ret < 0) {
> -		if (!payload->delete)
> -			drm_err(mgr->dev, "Step 2 of creating MST payload for %p failed: %d\n=
",
> -				payload->port, ret);
> -		else
> -			drm_dbg_kms(mgr->dev, "Step 2 of removing MST payload for %p failed: =
%d\n",
> -				    payload->port, ret);
> -	}
> +		if (!mgr->proposed_vcpis[i])
> +			continue;
> =20
> -	return ret;
> +		port =3D container_of(mgr->proposed_vcpis[i], struct drm_dp_mst_port, =
vcpi);
> +
> +		mutex_lock(&mgr->lock);
> +		skip =3D !drm_dp_mst_port_downstream_of_branch(port, mgr->mst_primary)=
;
> +		mutex_unlock(&mgr->lock);
> +
> +		if (skip)
> +			continue;
> +
> +		drm_dbg_kms(mgr->dev, "payload %d %d\n", i, mgr->payloads[i].payload_s=
tate);
> +		if (mgr->payloads[i].payload_state =3D=3D DP_PAYLOAD_LOCAL) {
> +			ret =3D drm_dp_create_payload_step2(mgr, port, mgr->proposed_vcpis[i]=
->vcpi, &mgr->payloads[i]);
> +		} else if (mgr->payloads[i].payload_state =3D=3D DP_PAYLOAD_DELETE_LOC=
AL) {
> +			ret =3D drm_dp_destroy_payload_step2(mgr, mgr->proposed_vcpis[i]->vcp=
i, &mgr->payloads[i]);
> +		}
> +		if (ret) {
> +			mutex_unlock(&mgr->payload_lock);
> +			return ret;
> +		}
> +	}
> +	mutex_unlock(&mgr->payload_lock);
> +	return 0;
>  }
> -EXPORT_SYMBOL(drm_dp_add_payload_part2);
> +EXPORT_SYMBOL(drm_dp_update_payload_part2);
> =20
>  static int drm_dp_send_dpcd_read(struct drm_dp_mst_topology_mgr *mgr,
>  				 struct drm_dp_mst_port *port,
> @@ -3591,6 +3711,7 @@ int drm_dp_mst_topology_mgr_set_mst(struct drm_dp_m=
st_topology_mgr *mgr, bool ms
>  	int ret =3D 0;
>  	struct drm_dp_mst_branch *mstb =3D NULL;
> =20
> +	mutex_lock(&mgr->payload_lock);
>  	mutex_lock(&mgr->lock);
>  	if (mst_state =3D=3D mgr->mst_state)
>  		goto out_unlock;
> @@ -3598,6 +3719,10 @@ int drm_dp_mst_topology_mgr_set_mst(struct drm_dp_=
mst_topology_mgr *mgr, bool ms
>  	mgr->mst_state =3D mst_state;
>  	/* set the device into MST mode */
>  	if (mst_state) {
> +		struct drm_dp_payload reset_pay;
> +		int lane_count;
> +		int link_rate;
> +
>  		WARN_ON(mgr->mst_primary);
> =20
>  		/* get dpcd info */
> @@ -3608,6 +3733,16 @@ int drm_dp_mst_topology_mgr_set_mst(struct drm_dp_=
mst_topology_mgr *mgr, bool ms
>  			goto out_unlock;
>  		}
> =20
> +		lane_count =3D min_t(int, mgr->dpcd[2] & DP_MAX_LANE_COUNT_MASK, mgr->=
max_lane_count);
> +		link_rate =3D min_t(int, drm_dp_bw_code_to_link_rate(mgr->dpcd[1]), mg=
r->max_link_rate);
> +		mgr->pbn_div =3D drm_dp_get_vc_payload_bw(mgr,
> +							link_rate,
> +							lane_count);
> +		if (mgr->pbn_div =3D=3D 0) {
> +			ret =3D -EINVAL;
> +			goto out_unlock;
> +		}
> +
>  		/* add initial branch device at LCT 1 */
>  		mstb =3D drm_dp_add_mst_branch_device(1, NULL);
>  		if (mstb =3D=3D NULL) {
> @@ -3627,8 +3762,9 @@ int drm_dp_mst_topology_mgr_set_mst(struct drm_dp_m=
st_topology_mgr *mgr, bool ms
>  		if (ret < 0)
>  			goto out_unlock;
> =20
> -		/* Write reset payload */
> -		drm_dp_dpcd_write_payload(mgr, 0, 0, 0x3f);
> +		reset_pay.start_slot =3D 0;
> +		reset_pay.num_slots =3D 0x3f;
> +		drm_dp_dpcd_write_payload(mgr, 0, &reset_pay);
> =20
>  		queue_work(system_long_wq, &mgr->work);
> =20
> @@ -3640,11 +3776,19 @@ int drm_dp_mst_topology_mgr_set_mst(struct drm_dp=
_mst_topology_mgr *mgr, bool ms
>  		/* this can fail if the device is gone */
>  		drm_dp_dpcd_writeb(mgr->aux, DP_MSTM_CTRL, 0);
>  		ret =3D 0;
> +		memset(mgr->payloads, 0,
> +		       mgr->max_payloads * sizeof(mgr->payloads[0]));
> +		memset(mgr->proposed_vcpis, 0,
> +		       mgr->max_payloads * sizeof(mgr->proposed_vcpis[0]));
> +		mgr->payload_mask =3D 0;
> +		set_bit(0, &mgr->payload_mask);
> +		mgr->vcpi_mask =3D 0;
>  		mgr->payload_id_table_cleared =3D false;
>  	}
> =20
>  out_unlock:
>  	mutex_unlock(&mgr->lock);
> +	mutex_unlock(&mgr->payload_lock);
>  	if (mstb)
>  		drm_dp_mst_topology_put_mstb(mstb);
>  	return ret;
> @@ -4163,18 +4307,62 @@ struct edid *drm_dp_mst_get_edid(struct drm_conne=
ctor *connector, struct drm_dp_
>  }
>  EXPORT_SYMBOL(drm_dp_mst_get_edid);
> =20
> +/**
> + * drm_dp_find_vcpi_slots() - Find time slots for this PBN value
> + * @mgr: manager to use
> + * @pbn: payload bandwidth to convert into slots.
> + *
> + * Calculate the number of time slots that will be required for the give=
n PBN
> + * value. This function is deprecated, and should not be used in atomic
> + * drivers.
> + *
> + * RETURNS:
> + * The total slots required for this port, or error.
> + */
> +int drm_dp_find_vcpi_slots(struct drm_dp_mst_topology_mgr *mgr,
> +			   int pbn)
> +{
> +	int num_slots;
> +
> +	num_slots =3D DIV_ROUND_UP(pbn, mgr->pbn_div);
> +
> +	/* max. time slots - one slot for MTP header */
> +	if (num_slots > 63)
> +		return -ENOSPC;
> +	return num_slots;
> +}
> +EXPORT_SYMBOL(drm_dp_find_vcpi_slots);
> +
> +static int drm_dp_init_vcpi(struct drm_dp_mst_topology_mgr *mgr,
> +			    struct drm_dp_vcpi *vcpi, int pbn, int slots)
> +{
> +	int ret;
> +
> +	vcpi->pbn =3D pbn;
> +	vcpi->aligned_pbn =3D slots * mgr->pbn_div;
> +	vcpi->num_slots =3D slots;
> +
> +	ret =3D drm_dp_mst_assign_payload_id(mgr, vcpi);
> +	if (ret < 0)
> +		return ret;
> +	return 0;
> +}
> +
>  /**
>   * drm_dp_atomic_find_time_slots() - Find and add time slots to the stat=
e
>   * @state: global atomic state
>   * @mgr: MST topology manager for the port
>   * @port: port to find time slots for
>   * @pbn: bandwidth required for the mode in PBN
> + * @pbn_div: divider for DSC mode that takes FEC into account
>   *
> - * Allocates time slots to @port, replacing any previous time slot alloc=
ations it may
> - * have had. Any atomic drivers which support MST must call this functio=
n in
> - * their &drm_encoder_helper_funcs.atomic_check() callback unconditional=
ly to
> - * change the current time slot allocation for the new state, and ensure=
 the MST
> - * atomic state is added whenever the state of payloads in the topology =
changes.
> + * Allocates time slots to @port, replacing any previous timeslot alloca=
tions it
> + * may have had. Any atomic drivers which support MST must call this fun=
ction
> + * in their &drm_encoder_helper_funcs.atomic_check() callback to change =
the
> + * current timeslot allocation for the new state, but only when
> + * &drm_crtc_state.mode_changed or &drm_crtc_state.connectors_changed is=
 set
> + * to ensure compatibility with userspace applications that still use th=
e
> + * legacy modesetting UAPI.
>   *
>   * Allocations set by this function are not checked against the bandwidt=
h
>   * restraints of @mgr until the driver calls drm_dp_mst_atomic_check().
> @@ -4193,7 +4381,8 @@ EXPORT_SYMBOL(drm_dp_mst_get_edid);
>   */
>  int drm_dp_atomic_find_time_slots(struct drm_atomic_state *state,
>  				  struct drm_dp_mst_topology_mgr *mgr,
> -				  struct drm_dp_mst_port *port, int pbn)
> +				  struct drm_dp_mst_port *port, int pbn,
> +				  int pbn_div)
>  {
>  	struct drm_dp_mst_topology_state *topology_state;
>  	struct drm_dp_mst_atomic_payload *payload =3D NULL;
> @@ -4226,7 +4415,10 @@ int drm_dp_atomic_find_time_slots(struct drm_atomi=
c_state *state,
>  		}
>  	}
> =20
> -	req_slots =3D DIV_ROUND_UP(pbn, topology_state->pbn_div);
> +	if (pbn_div <=3D 0)
> +		pbn_div =3D mgr->pbn_div;
> +
> +	req_slots =3D DIV_ROUND_UP(pbn, pbn_div);
> =20
>  	drm_dbg_atomic(mgr->dev, "[CONNECTOR:%d:%s] [MST PORT:%p] TU %d -> %d\n=
",
>  		       port->connector->base.id, port->connector->name,
> @@ -4235,7 +4427,7 @@ int drm_dp_atomic_find_time_slots(struct drm_atomic=
_state *state,
>  		       port->connector->base.id, port->connector->name,
>  		       port, prev_bw, pbn);
> =20
> -	/* Add the new allocation to the state, note the VCPI isn't assigned un=
til the end */
> +	/* Add the new allocation to the state */
>  	if (!payload) {
>  		payload =3D kzalloc(sizeof(*payload), GFP_KERNEL);
>  		if (!payload)
> @@ -4243,7 +4435,6 @@ int drm_dp_atomic_find_time_slots(struct drm_atomic=
_state *state,
> =20
>  		drm_dp_mst_get_port_malloc(port);
>  		payload->port =3D port;
> -		payload->vc_start_slot =3D -1;
>  		list_add(&payload->next, &topology_state->payloads);
>  	}
>  	payload->time_slots =3D req_slots;
> @@ -4260,12 +4451,10 @@ EXPORT_SYMBOL(drm_dp_atomic_find_time_slots);
>   * @port: The port to release the time slots from
>   *
>   * Releases any time slots that have been allocated to a port in the ato=
mic
> - * state. Any atomic drivers which support MST must call this function
> - * unconditionally in their &drm_connector_helper_funcs.atomic_check() c=
allback.
> - * This helper will check whether time slots would be released by the ne=
w state and
> - * respond accordingly, along with ensuring the MST state is always adde=
d to the
> - * atomic state whenever a new state would modify the state of payloads =
on the
> - * topology.
> + * state. Any atomic drivers which support MST must call this function i=
n
> + * their &drm_connector_helper_funcs.atomic_check() callback when the
> + * connector will no longer have VCPI allocated (e.g. because its CRTC w=
as
> + * removed) when it had VCPI allocated in the previous atomic state.
>   *
>   * It is OK to call this even if @port has been removed from the system.
>   * Additionally, it is OK to call this function multiple times on the sa=
me
> @@ -4330,7 +4519,6 @@ int drm_dp_atomic_release_time_slots(struct drm_ato=
mic_state *state,
>  		drm_dp_mst_put_port_malloc(port);
>  		payload->pbn =3D 0;
>  		payload->delete =3D true;
> -		topology_state->payload_mask &=3D ~BIT(payload->vcpi - 1);
>  	}
> =20
>  	return 0;
> @@ -4381,8 +4569,7 @@ int drm_dp_mst_atomic_setup_commit(struct drm_atomi=
c_state *state)
>  EXPORT_SYMBOL(drm_dp_mst_atomic_setup_commit);
> =20
>  /**
> - * drm_dp_mst_atomic_wait_for_dependencies() - Wait for all pending comm=
its on MST topologies,
> - * prepare new MST state for commit
> + * drm_dp_mst_atomic_wait_for_dependencies() - Wait for all pending comm=
its on MST topologies
>   * @state: global atomic state
>   *
>   * Goes through any MST topologies in this atomic state, and waits for a=
ny pending commits which
> @@ -4400,30 +4587,17 @@ EXPORT_SYMBOL(drm_dp_mst_atomic_setup_commit);
>   */
>  void drm_dp_mst_atomic_wait_for_dependencies(struct drm_atomic_state *st=
ate)
>  {
> -	struct drm_dp_mst_topology_state *old_mst_state, *new_mst_state;
> +	struct drm_dp_mst_topology_state *old_mst_state;
>  	struct drm_dp_mst_topology_mgr *mgr;
> -	struct drm_dp_mst_atomic_payload *old_payload, *new_payload;
>  	int i, j, ret;
> =20
> -	for_each_oldnew_mst_mgr_in_state(state, mgr, old_mst_state, new_mst_sta=
te, i) {
> +	for_each_old_mst_mgr_in_state(state, mgr, old_mst_state, i) {
>  		for (j =3D 0; j < old_mst_state->num_commit_deps; j++) {
>  			ret =3D drm_crtc_commit_wait(old_mst_state->commit_deps[j]);
>  			if (ret < 0)
>  				drm_err(state->dev, "Failed to wait for %s: %d\n",
>  					old_mst_state->commit_deps[j]->crtc->name, ret);
>  		}
> -
> -		/* Now that previous state is committed, it's safe to copy over the st=
art slot
> -		 * assignments
> -		 */
> -		list_for_each_entry(old_payload, &old_mst_state->payloads, next) {
> -			if (old_payload->delete)
> -				continue;
> -
> -			new_payload =3D drm_atomic_get_mst_payload_state(new_mst_state,
> -								       old_payload->port);
> -			new_payload->vc_start_slot =3D old_payload->vc_start_slot;
> -		}
>  	}
>  }
>  EXPORT_SYMBOL(drm_dp_mst_atomic_wait_for_dependencies);
> @@ -4508,8 +4682,119 @@ void drm_dp_mst_update_slots(struct drm_dp_mst_to=
pology_state *mst_state, uint8_
>  }
>  EXPORT_SYMBOL(drm_dp_mst_update_slots);
> =20
> +/**
> + * drm_dp_mst_allocate_vcpi() - Allocate a virtual channel
> + * @mgr: manager for this port
> + * @port: port to allocate a virtual channel for.
> + * @pbn: payload bandwidth number to request
> + * @slots: returned number of slots for this PBN.
> + */
> +bool drm_dp_mst_allocate_vcpi(struct drm_dp_mst_topology_mgr *mgr,
> +			      struct drm_dp_mst_port *port, int pbn, int slots)
> +{
> +	int ret;
> +
> +	if (slots < 0)
> +		return false;
> +
> +	port =3D drm_dp_mst_topology_get_port_validated(mgr, port);
> +	if (!port)
> +		return false;
> +
> +	if (port->vcpi.vcpi > 0) {
> +		drm_dbg_kms(mgr->dev,
> +			    "payload: vcpi %d already allocated for pbn %d - requested pbn %d=
\n",
> +			    port->vcpi.vcpi, port->vcpi.pbn, pbn);
> +		if (pbn =3D=3D port->vcpi.pbn) {
> +			drm_dp_mst_topology_put_port(port);
> +			return true;
> +		}
> +	}
> +
> +	ret =3D drm_dp_init_vcpi(mgr, &port->vcpi, pbn, slots);
> +	if (ret) {
> +		drm_dbg_kms(mgr->dev, "failed to init time slots=3D%d ret=3D%d\n",
> +			    DIV_ROUND_UP(pbn, mgr->pbn_div), ret);
> +		drm_dp_mst_topology_put_port(port);
> +		goto out;
> +	}
> +	drm_dbg_kms(mgr->dev, "initing vcpi for pbn=3D%d slots=3D%d\n", pbn, po=
rt->vcpi.num_slots);
> +
> +	/* Keep port allocated until its payload has been removed */
> +	drm_dp_mst_get_port_malloc(port);
> +	drm_dp_mst_topology_put_port(port);
> +	return true;
> +out:
> +	return false;
> +}
> +EXPORT_SYMBOL(drm_dp_mst_allocate_vcpi);
> +
> +int drm_dp_mst_get_vcpi_slots(struct drm_dp_mst_topology_mgr *mgr, struc=
t drm_dp_mst_port *port)
> +{
> +	int slots =3D 0;
> +
> +	port =3D drm_dp_mst_topology_get_port_validated(mgr, port);
> +	if (!port)
> +		return slots;
> +
> +	slots =3D port->vcpi.num_slots;
> +	drm_dp_mst_topology_put_port(port);
> +	return slots;
> +}
> +EXPORT_SYMBOL(drm_dp_mst_get_vcpi_slots);
> +
> +/**
> + * drm_dp_mst_reset_vcpi_slots() - Reset number of slots to 0 for VCPI
> + * @mgr: manager for this port
> + * @port: unverified pointer to a port.
> + *
> + * This just resets the number of slots for the ports VCPI for later pro=
gramming.
> + */
> +void drm_dp_mst_reset_vcpi_slots(struct drm_dp_mst_topology_mgr *mgr, st=
ruct drm_dp_mst_port *port)
> +{
> +	/*
> +	 * A port with VCPI will remain allocated until its VCPI is
> +	 * released, no verified ref needed
> +	 */
> +
> +	port->vcpi.num_slots =3D 0;
> +}
> +EXPORT_SYMBOL(drm_dp_mst_reset_vcpi_slots);
> +
> +/**
> + * drm_dp_mst_deallocate_vcpi() - deallocate a VCPI
> + * @mgr: manager for this port
> + * @port: port to deallocate vcpi for
> + *
> + * This can be called unconditionally, regardless of whether
> + * drm_dp_mst_allocate_vcpi() succeeded or not.
> + */
> +void drm_dp_mst_deallocate_vcpi(struct drm_dp_mst_topology_mgr *mgr,
> +				struct drm_dp_mst_port *port)
> +{
> +	bool skip;
> +
> +	if (!port->vcpi.vcpi)
> +		return;
> +
> +	mutex_lock(&mgr->lock);
> +	skip =3D !drm_dp_mst_port_downstream_of_branch(port, mgr->mst_primary);
> +	mutex_unlock(&mgr->lock);
> +
> +	if (skip)
> +		return;
> +
> +	drm_dp_mst_put_payload_id(mgr, port->vcpi.vcpi);
> +	port->vcpi.num_slots =3D 0;
> +	port->vcpi.pbn =3D 0;
> +	port->vcpi.aligned_pbn =3D 0;
> +	port->vcpi.vcpi =3D 0;
> +	drm_dp_mst_put_port_malloc(port);
> +}
> +EXPORT_SYMBOL(drm_dp_mst_deallocate_vcpi);
> +
>  static int drm_dp_dpcd_write_payload(struct drm_dp_mst_topology_mgr *mgr=
,
> -				     int id, u8 start_slot, u8 num_slots)
> +				     int id, struct drm_dp_payload *payload)
>  {
>  	u8 payload_alloc[3], status;
>  	int ret;
> @@ -4519,8 +4804,8 @@ static int drm_dp_dpcd_write_payload(struct drm_dp_=
mst_topology_mgr *mgr,
>  			   DP_PAYLOAD_TABLE_UPDATED);
> =20
>  	payload_alloc[0] =3D id;
> -	payload_alloc[1] =3D start_slot;
> -	payload_alloc[2] =3D num_slots;
> +	payload_alloc[1] =3D payload->start_slot;
> +	payload_alloc[2] =3D payload->num_slots;
> =20
>  	ret =3D drm_dp_dpcd_write(mgr->aux, DP_PAYLOAD_ALLOCATE_SET, payload_al=
loc, 3);
>  	if (ret !=3D 3) {
> @@ -4735,9 +5020,8 @@ static void fetch_monitor_name(struct drm_dp_mst_to=
pology_mgr *mgr,
>  void drm_dp_mst_dump_topology(struct seq_file *m,
>  			      struct drm_dp_mst_topology_mgr *mgr)
>  {
> -	struct drm_dp_mst_topology_state *state;
> -	struct drm_dp_mst_atomic_payload *payload;
> -	int i, ret;
> +	int i;
> +	struct drm_dp_mst_port *port;
> =20
>  	mutex_lock(&mgr->lock);
>  	if (mgr->mst_primary)
> @@ -4746,35 +5030,36 @@ void drm_dp_mst_dump_topology(struct seq_file *m,
>  	/* dump VCPIs */
>  	mutex_unlock(&mgr->lock);
> =20
> -	ret =3D drm_modeset_lock_single_interruptible(&mgr->base.lock);
> -	if (ret < 0)
> -		return;
> +	mutex_lock(&mgr->payload_lock);
> +	seq_printf(m, "\n*** VCPI Info ***\n");
> +	seq_printf(m, "payload_mask: %lx, vcpi_mask: %lx, max_payloads: %d\n", =
mgr->payload_mask, mgr->vcpi_mask, mgr->max_payloads);
> =20
> -	state =3D to_drm_dp_mst_topology_state(mgr->base.state);
> -	seq_printf(m, "\n*** Atomic state info ***\n");
> -	seq_printf(m, "payload_mask: %x, max_payloads: %d, start_slot: %u, pbn_=
div: %d\n",
> -		   state->payload_mask, mgr->max_payloads, state->start_slot, state->p=
bn_div);
> -
> -	seq_printf(m, "\n| idx | port | vcpi | slots | pbn | dsc |     sink nam=
e     |\n");
> +	seq_printf(m, "\n|   idx   |  port # |  vcp_id | # slots |     sink nam=
e     |\n");
>  	for (i =3D 0; i < mgr->max_payloads; i++) {
> -		list_for_each_entry(payload, &state->payloads, next) {
> +		if (mgr->proposed_vcpis[i]) {
>  			char name[14];
> =20
> -			if (payload->vcpi !=3D i || payload->delete)
> -				continue;
> -
> -			fetch_monitor_name(mgr, payload->port, name, sizeof(name));
> -			seq_printf(m, " %5d %6d %6d %02d - %02d %5d %5s %19s\n",
> +			port =3D container_of(mgr->proposed_vcpis[i], struct drm_dp_mst_port,=
 vcpi);
> +			fetch_monitor_name(mgr, port, name, sizeof(name));
> +			seq_printf(m, "%10d%10d%10d%10d%20s\n",
>  				   i,
> -				   payload->port->port_num,
> -				   payload->vcpi,
> -				   payload->vc_start_slot,
> -				   payload->vc_start_slot + payload->time_slots - 1,
> -				   payload->pbn,
> -				   payload->dsc_enabled ? "Y" : "N",
> +				   port->port_num,
> +				   port->vcpi.vcpi,
> +				   port->vcpi.num_slots,
>  				   (*name !=3D 0) ? name : "Unknown");
> -		}
> +		} else
> +			seq_printf(m, "%6d - Unused\n", i);
> +	}
> +	seq_printf(m, "\n*** Payload Info ***\n");
> +	seq_printf(m, "|   idx   |  state  |  start slot  | # slots |\n");
> +	for (i =3D 0; i < mgr->max_payloads; i++) {
> +		seq_printf(m, "%10d%10d%15d%10d\n",
> +			   i,
> +			   mgr->payloads[i].payload_state,
> +			   mgr->payloads[i].start_slot,
> +			   mgr->payloads[i].num_slots);
>  	}
> +	mutex_unlock(&mgr->payload_lock);
> =20
>  	seq_printf(m, "\n*** DPCD Info ***\n");
>  	mutex_lock(&mgr->lock);
> @@ -4820,7 +5105,7 @@ void drm_dp_mst_dump_topology(struct seq_file *m,
> =20
>  out:
>  	mutex_unlock(&mgr->lock);
> -	drm_modeset_unlock(&mgr->base.lock);
> +
>  }
>  EXPORT_SYMBOL(drm_dp_mst_dump_topology);
> =20
> @@ -5141,22 +5426,9 @@ drm_dp_mst_atomic_check_payload_alloc_limits(struc=
t drm_dp_mst_topology_mgr *mgr
>  				       mgr, mst_state, mgr->max_payloads);
>  			return -EINVAL;
>  		}
> -
> -		/* Assign a VCPI */
> -		if (!payload->vcpi) {
> -			payload->vcpi =3D ffz(mst_state->payload_mask) + 1;
> -			drm_dbg_atomic(mgr->dev, "[MST PORT:%p] assigned VCPI #%d\n",
> -				       payload->port, payload->vcpi);
> -			mst_state->payload_mask |=3D BIT(payload->vcpi - 1);
> -		}
>  	}
> -
> -	if (!payload_count)
> -		mst_state->pbn_div =3D 0;
> -
> -	drm_dbg_atomic(mgr->dev, "[MST MGR:%p] mst state %p TU pbn_div=3D%d ava=
il=3D%d used=3D%d\n",
> -		       mgr, mst_state, mst_state->pbn_div, avail_slots,
> -		       mst_state->total_avail_slots - avail_slots);
> +	drm_dbg_atomic(mgr->dev, "[MST MGR:%p] mst state %p TU avail=3D%d used=
=3D%d\n",
> +		       mgr, mst_state, avail_slots, mst_state->total_avail_slots - ava=
il_slots);
> =20
>  	return 0;
>  }
> @@ -5227,6 +5499,7 @@ EXPORT_SYMBOL(drm_dp_mst_add_affected_dsc_crtcs);
>   * @state: Pointer to the new drm_atomic_state
>   * @port: Pointer to the affected MST Port
>   * @pbn: Newly recalculated bw required for link with DSC enabled
> + * @pbn_div: Divider to calculate correct number of pbn per slot
>   * @enable: Boolean flag to enable or disable DSC on the port
>   *
>   * This function enables DSC on the given Port
> @@ -5237,7 +5510,8 @@ EXPORT_SYMBOL(drm_dp_mst_add_affected_dsc_crtcs);
>   */
>  int drm_dp_mst_atomic_enable_dsc(struct drm_atomic_state *state,
>  				 struct drm_dp_mst_port *port,
> -				 int pbn, bool enable)
> +				 int pbn, int pbn_div,
> +				 bool enable)
>  {
>  	struct drm_dp_mst_topology_state *mst_state;
>  	struct drm_dp_mst_atomic_payload *payload;
> @@ -5263,7 +5537,7 @@ int drm_dp_mst_atomic_enable_dsc(struct drm_atomic_=
state *state,
>  	}
> =20
>  	if (enable) {
> -		time_slots =3D drm_dp_atomic_find_time_slots(state, port->mgr, port, p=
bn);
> +		time_slots =3D drm_dp_atomic_find_time_slots(state, port->mgr, port, p=
bn, pbn_div);
>  		drm_dbg_atomic(state->dev,
>  			       "[MST PORT:%p] Enabling DSC flag, reallocating %d time slots o=
n the port\n",
>  			       port, time_slots);
> @@ -5276,7 +5550,6 @@ int drm_dp_mst_atomic_enable_dsc(struct drm_atomic_=
state *state,
>  	return time_slots;
>  }
>  EXPORT_SYMBOL(drm_dp_mst_atomic_enable_dsc);
> -
>  /**
>   * drm_dp_mst_atomic_check - Check that the new state of an MST topology=
 in an
>   * atomic update is valid
> @@ -5334,6 +5607,7 @@ EXPORT_SYMBOL(drm_dp_mst_topology_state_funcs);
> =20
>  /**
>   * drm_atomic_get_mst_topology_state: get MST topology state
> + *
>   * @state: global atomic state
>   * @mgr: MST topology manager, also the private object in this case
>   *
> @@ -5352,31 +5626,6 @@ struct drm_dp_mst_topology_state *drm_atomic_get_m=
st_topology_state(struct drm_a
>  }
>  EXPORT_SYMBOL(drm_atomic_get_mst_topology_state);
> =20
> -/**
> - * drm_atomic_get_new_mst_topology_state: get new MST topology state in =
atomic state, if any
> - * @state: global atomic state
> - * @mgr: MST topology manager, also the private object in this case
> - *
> - * This function wraps drm_atomic_get_priv_obj_state() passing in the MS=
T atomic
> - * state vtable so that the private object state returned is that of a M=
ST
> - * topology object.
> - *
> - * Returns:
> - *
> - * The MST topology state, or NULL if there's no topology state for this=
 MST mgr
> - * in the global atomic state
> - */
> -struct drm_dp_mst_topology_state *
> -drm_atomic_get_new_mst_topology_state(struct drm_atomic_state *state,
> -				      struct drm_dp_mst_topology_mgr *mgr)
> -{
> -	struct drm_private_state *priv_state =3D
> -		drm_atomic_get_new_private_obj_state(state, &mgr->base);
> -
> -	return priv_state ? to_dp_mst_topology_state(priv_state) : NULL;
> -}
> -EXPORT_SYMBOL(drm_atomic_get_new_mst_topology_state);
> -
>  /**
>   * drm_dp_mst_topology_mgr_init - initialise a topology manager
>   * @mgr: manager struct to initialise
> @@ -5384,6 +5633,8 @@ EXPORT_SYMBOL(drm_atomic_get_new_mst_topology_state=
);
>   * @aux: DP helper aux channel to talk to this device
>   * @max_dpcd_transaction_bytes: hw specific DPCD transaction limit
>   * @max_payloads: maximum number of payloads this GPU can source
> + * @max_lane_count: maximum number of lanes this GPU supports
> + * @max_link_rate: maximum link rate per lane this GPU supports in kHz
>   * @conn_base_id: the connector object ID the MST device is connected to=
.
>   *
>   * Return 0 for success, or negative error code on failure
> @@ -5391,12 +5642,14 @@ EXPORT_SYMBOL(drm_atomic_get_new_mst_topology_sta=
te);
>  int drm_dp_mst_topology_mgr_init(struct drm_dp_mst_topology_mgr *mgr,
>  				 struct drm_device *dev, struct drm_dp_aux *aux,
>  				 int max_dpcd_transaction_bytes, int max_payloads,
> +				 int max_lane_count, int max_link_rate,
>  				 int conn_base_id)
>  {
>  	struct drm_dp_mst_topology_state *mst_state;
> =20
>  	mutex_init(&mgr->lock);
>  	mutex_init(&mgr->qlock);
> +	mutex_init(&mgr->payload_lock);
>  	mutex_init(&mgr->delayed_destroy_lock);
>  	mutex_init(&mgr->up_req_lock);
>  	mutex_init(&mgr->probe_lock);
> @@ -5426,7 +5679,19 @@ int drm_dp_mst_topology_mgr_init(struct drm_dp_mst=
_topology_mgr *mgr,
>  	mgr->aux =3D aux;
>  	mgr->max_dpcd_transaction_bytes =3D max_dpcd_transaction_bytes;
>  	mgr->max_payloads =3D max_payloads;
> +	mgr->max_lane_count =3D max_lane_count;
> +	mgr->max_link_rate =3D max_link_rate;
>  	mgr->conn_base_id =3D conn_base_id;
> +	if (max_payloads + 1 > sizeof(mgr->payload_mask) * 8 ||
> +	    max_payloads + 1 > sizeof(mgr->vcpi_mask) * 8)
> +		return -EINVAL;
> +	mgr->payloads =3D kcalloc(max_payloads, sizeof(struct drm_dp_payload), =
GFP_KERNEL);
> +	if (!mgr->payloads)
> +		return -ENOMEM;
> +	mgr->proposed_vcpis =3D kcalloc(max_payloads, sizeof(struct drm_dp_vcpi=
 *), GFP_KERNEL);
> +	if (!mgr->proposed_vcpis)
> +		return -ENOMEM;
> +	set_bit(0, &mgr->payload_mask);
> =20
>  	mst_state =3D kzalloc(sizeof(*mst_state), GFP_KERNEL);
>  	if (mst_state =3D=3D NULL)
> @@ -5459,12 +5724,19 @@ void drm_dp_mst_topology_mgr_destroy(struct drm_d=
p_mst_topology_mgr *mgr)
>  		destroy_workqueue(mgr->delayed_destroy_wq);
>  		mgr->delayed_destroy_wq =3D NULL;
>  	}
> +	mutex_lock(&mgr->payload_lock);
> +	kfree(mgr->payloads);
> +	mgr->payloads =3D NULL;
> +	kfree(mgr->proposed_vcpis);
> +	mgr->proposed_vcpis =3D NULL;
> +	mutex_unlock(&mgr->payload_lock);
>  	mgr->dev =3D NULL;
>  	mgr->aux =3D NULL;
>  	drm_atomic_private_obj_fini(&mgr->base);
>  	mgr->funcs =3D NULL;
> =20
>  	mutex_destroy(&mgr->delayed_destroy_lock);
> +	mutex_destroy(&mgr->payload_lock);
>  	mutex_destroy(&mgr->qlock);
>  	mutex_destroy(&mgr->lock);
>  	mutex_destroy(&mgr->up_req_lock);
> diff --git a/drivers/gpu/drm/i915/display/intel_dp_mst.c b/drivers/gpu/dr=
m/i915/display/intel_dp_mst.c
> index 8b0e4defa3f1..4428eabc6ff7 100644
> --- a/drivers/gpu/drm/i915/display/intel_dp_mst.c
> +++ b/drivers/gpu/drm/i915/display/intel_dp_mst.c
> @@ -57,7 +57,6 @@ static int intel_dp_mst_find_vcpi_slots_for_bpp(struct =
intel_encoder *encoder,
>  	struct drm_atomic_state *state =3D crtc_state->uapi.state;
>  	struct intel_dp_mst_encoder *intel_mst =3D enc_to_mst(encoder);
>  	struct intel_dp *intel_dp =3D &intel_mst->primary->dp;
> -	struct drm_dp_mst_topology_state *mst_state;
>  	struct intel_connector *connector =3D
>  		to_intel_connector(conn_state->connector);
>  	struct drm_i915_private *i915 =3D to_i915(connector->base.dev);
> @@ -66,30 +65,23 @@ static int intel_dp_mst_find_vcpi_slots_for_bpp(struc=
t intel_encoder *encoder,
>  	int bpp, slots =3D -EINVAL;
>  	int ret =3D 0;
> =20
> -	mst_state =3D drm_atomic_get_mst_topology_state(state, &intel_dp->mst_m=
gr);
> -	if (IS_ERR(mst_state))
> -		return PTR_ERR(mst_state);
> -
>  	crtc_state->lane_count =3D limits->max_lane_count;
>  	crtc_state->port_clock =3D limits->max_rate;
> =20
> -	// TODO: Handle pbn_div changes by adding a new MST helper
> -	if (!mst_state->pbn_div) {
> -		mst_state->pbn_div =3D drm_dp_get_vc_payload_bw(&intel_dp->mst_mgr,
> -							      crtc_state->port_clock,
> -							      crtc_state->lane_count);
> -	}
> +	for (bpp =3D limits->max_bpp; bpp >=3D limits->min_bpp; bpp -=3D 2 * 3)=
 {
> +		crtc_state->pipe_bpp =3D bpp;
> =20
> -	for (bpp =3D max_bpp; bpp >=3D min_bpp; bpp -=3D step) {
>  		crtc_state->pbn =3D drm_dp_calc_pbn_mode(adjusted_mode->crtc_clock,
>  						       dsc ? bpp << 4 : bpp,
>  						       dsc);
> =20
> -		drm_dbg_kms(&i915->drm, "Trying bpp %d\n", bpp);
> -
>  		slots =3D drm_dp_atomic_find_time_slots(state, &intel_dp->mst_mgr,
>  						      connector->port,
> -						      crtc_state->pbn);
> +						      crtc_state->pbn,
> +						      drm_dp_get_vc_payload_bw(&intel_dp->mst_mgr,
> +									       crtc_state->port_clock,
> +									       crtc_state->lane_count));
> +
>  		if (slots =3D=3D -EDEADLK)
>  			return slots;
> =20
> @@ -524,17 +516,21 @@ static void intel_mst_disable_dp(struct intel_atomi=
c_state *state,
>  	struct intel_dp *intel_dp =3D &dig_port->dp;
>  	struct intel_connector *connector =3D
>  		to_intel_connector(old_conn_state->connector);
> -	struct drm_dp_mst_topology_state *mst_state =3D
> -		drm_atomic_get_mst_topology_state(&state->base, &intel_dp->mst_mgr);
>  	struct drm_i915_private *i915 =3D to_i915(connector->base.dev);
> +	int start_slot =3D intel_dp_is_uhbr(old_crtc_state) ? 0 : 1;
> +	int ret;
> =20
>  	drm_dbg_kms(&i915->drm, "active links %d\n",
>  		    intel_dp->active_mst_links);
> =20
>  	intel_hdcp_disable(intel_mst->connector);
> =20
> -	drm_dp_remove_payload(&intel_dp->mst_mgr, mst_state,
> -			      drm_atomic_get_mst_payload_state(mst_state, connector->port));
> +	drm_dp_mst_reset_vcpi_slots(&intel_dp->mst_mgr, connector->port);
> +
> +	ret =3D drm_dp_update_payload_part1(&intel_dp->mst_mgr, start_slot);
> +	if (ret) {
> +		drm_dbg_kms(&i915->drm, "failed to update payload %d\n", ret);
> +	}
> =20
>  	intel_audio_codec_disable(encoder, old_crtc_state, old_conn_state);
>  }
> @@ -562,6 +558,8 @@ static void intel_mst_post_disable_dp(struct intel_at=
omic_state *state,
> =20
>  	intel_disable_transcoder(old_crtc_state);
> =20
> +	drm_dp_update_payload_part2(&intel_dp->mst_mgr);
> +
>  	clear_act_sent(encoder, old_crtc_state);
> =20
>  	intel_de_rmw(dev_priv, TRANS_DDI_FUNC_CTL(old_crtc_state->cpu_transcode=
r),
> @@ -569,6 +567,8 @@ static void intel_mst_post_disable_dp(struct intel_at=
omic_state *state,
> =20
>  	wait_for_act_sent(encoder, old_crtc_state);
> =20
> +	drm_dp_mst_deallocate_vcpi(&intel_dp->mst_mgr, connector->port);
> +
>  	intel_ddi_disable_transcoder_func(old_crtc_state);
> =20
>  	if (DISPLAY_VER(dev_priv) >=3D 9)
> @@ -635,8 +635,7 @@ static void intel_mst_pre_enable_dp(struct intel_atom=
ic_state *state,
>  	struct drm_i915_private *dev_priv =3D to_i915(encoder->base.dev);
>  	struct intel_connector *connector =3D
>  		to_intel_connector(conn_state->connector);
> -	struct drm_dp_mst_topology_state *mst_state =3D
> -		drm_atomic_get_new_mst_topology_state(&state->base, &intel_dp->mst_mgr=
);
> +	int start_slot =3D intel_dp_is_uhbr(pipe_config) ? 0 : 1;
>  	int ret;
>  	bool first_mst_stream;
> =20
> @@ -662,13 +661,16 @@ static void intel_mst_pre_enable_dp(struct intel_at=
omic_state *state,
>  		dig_port->base.pre_enable(state, &dig_port->base,
>  						pipe_config, NULL);
> =20
> +	ret =3D drm_dp_mst_allocate_vcpi(&intel_dp->mst_mgr,
> +				       connector->port,
> +				       pipe_config->pbn,
> +				       pipe_config->dp_m_n.tu);
> +	if (!ret)
> +		drm_err(&dev_priv->drm, "failed to allocate vcpi\n");
> +
>  	intel_dp->active_mst_links++;
> =20
> -	ret =3D drm_dp_add_payload_part1(&intel_dp->mst_mgr, mst_state,
> -				       drm_atomic_get_mst_payload_state(mst_state, connector->port))=
;
> -	if (ret < 0)
> -		drm_err(&dev_priv->drm, "Failed to create MST payload for %s: %d\n",
> -			connector->base.name, ret);
> +	ret =3D drm_dp_update_payload_part1(&intel_dp->mst_mgr, start_slot);
> =20
>  	/*
>  	 * Before Gen 12 this is not done as part of
> @@ -691,10 +693,7 @@ static void intel_mst_enable_dp(struct intel_atomic_=
state *state,
>  	struct intel_dp_mst_encoder *intel_mst =3D enc_to_mst(encoder);
>  	struct intel_digital_port *dig_port =3D intel_mst->primary;
>  	struct intel_dp *intel_dp =3D &dig_port->dp;
> -	struct intel_connector *connector =3D to_intel_connector(conn_state->co=
nnector);
>  	struct drm_i915_private *dev_priv =3D to_i915(encoder->base.dev);
> -	struct drm_dp_mst_topology_state *mst_state =3D
> -		drm_atomic_get_new_mst_topology_state(&state->base, &intel_dp->mst_mgr=
);
>  	enum transcoder trans =3D pipe_config->cpu_transcoder;
> =20
>  	drm_WARN_ON(&dev_priv->drm, pipe_config->has_pch_encoder);
> @@ -722,8 +721,7 @@ static void intel_mst_enable_dp(struct intel_atomic_s=
tate *state,
> =20
>  	wait_for_act_sent(encoder, pipe_config);
> =20
> -	drm_dp_add_payload_part2(&intel_dp->mst_mgr, &state->base,
> -				 drm_atomic_get_mst_payload_state(mst_state, connector->port));
> +	drm_dp_update_payload_part2(&intel_dp->mst_mgr);
> =20
>  	if (DISPLAY_VER(dev_priv) >=3D 14 && pipe_config->fec_enable)
>  		intel_de_rmw(dev_priv, MTL_CHICKEN_TRANS(trans), 0,
> @@ -1170,6 +1168,8 @@ intel_dp_mst_encoder_init(struct intel_digital_port=
 *dig_port, int conn_base_id)
>  	struct intel_dp *intel_dp =3D &dig_port->dp;
>  	enum port port =3D dig_port->base.port;
>  	int ret;
> +	int max_source_rate =3D
> +		intel_dp->source_rates[intel_dp->num_source_rates - 1];
> =20
>  	if (!HAS_DP_MST(i915) || intel_dp_is_edp(intel_dp))
>  		return 0;
> @@ -1185,7 +1185,10 @@ intel_dp_mst_encoder_init(struct intel_digital_por=
t *dig_port, int conn_base_id)
>  	/* create encoders */
>  	intel_dp_create_fake_mst_encoders(dig_port);
>  	ret =3D drm_dp_mst_topology_mgr_init(&intel_dp->mst_mgr, &i915->drm,
> -					   &intel_dp->aux, 16, 3, conn_base_id);
> +					   &intel_dp->aux, 16, 3,
> +					   dig_port->max_lanes,
> +					   max_source_rate,
> +					   conn_base_id);
>  	if (ret) {
>  		intel_dp->mst_mgr.cbs =3D NULL;
>  		return ret;
> diff --git a/drivers/gpu/drm/i915/display/intel_hdcp.c b/drivers/gpu/drm/=
i915/display/intel_hdcp.c
> index 6406fd487ee5..987e02eea66a 100644
> --- a/drivers/gpu/drm/i915/display/intel_hdcp.c
> +++ b/drivers/gpu/drm/i915/display/intel_hdcp.c
> @@ -31,30 +31,8 @@
> =20
>  static int intel_conn_to_vcpi(struct intel_connector *connector)
>  {
> -	struct drm_dp_mst_topology_mgr *mgr;
> -	struct drm_dp_mst_atomic_payload *payload;
> -	struct drm_dp_mst_topology_state *mst_state;
> -	int vcpi =3D 0;
> -
>  	/* For HDMI this is forced to be 0x0. For DP SST also this is 0x0. */
> -	if (!connector->port)
> -		return 0;
> -	mgr =3D connector->port->mgr;
> -
> -	drm_modeset_lock(&mgr->base.lock, NULL);
> -	mst_state =3D to_drm_dp_mst_topology_state(mgr->base.state);
> -	payload =3D drm_atomic_get_mst_payload_state(mst_state, connector->port=
);
> -	if (drm_WARN_ON(mgr->dev, !payload))
> -		goto out;
> -
> -	vcpi =3D payload->vcpi;
> -	if (drm_WARN_ON(mgr->dev, vcpi < 0)) {
> -		vcpi =3D 0;
> -		goto out;
> -	}
> -out:
> -	drm_modeset_unlock(&mgr->base.lock);
> -	return vcpi;
> +	return connector->port	? connector->port->vcpi.vcpi : 0;
>  }
> =20
>  /*
> diff --git a/drivers/gpu/drm/nouveau/dispnv50/disp.c b/drivers/gpu/drm/no=
uveau/dispnv50/disp.c
> index edcb2529b402..9bebe2a5e284 100644
> --- a/drivers/gpu/drm/nouveau/dispnv50/disp.c
> +++ b/drivers/gpu/drm/nouveau/dispnv50/disp.c
> @@ -831,7 +831,6 @@ struct nv50_msto {
>  	struct nv50_head *head;
>  	struct nv50_mstc *mstc;
>  	bool disabled;
> -	bool enabled;
>  };
> =20
>  struct nouveau_encoder *nv50_real_outp(struct drm_encoder *encoder)
> @@ -847,55 +846,82 @@ struct nouveau_encoder *nv50_real_outp(struct drm_e=
ncoder *encoder)
>  	return msto->mstc->mstm->outp;
>  }
> =20
> +static struct drm_dp_payload *
> +nv50_msto_payload(struct nv50_msto *msto)
> +{
> +	struct nouveau_drm *drm =3D nouveau_drm(msto->encoder.dev);
> +	struct nv50_mstc *mstc =3D msto->mstc;
> +	struct nv50_mstm *mstm =3D mstc->mstm;
> +	int vcpi =3D mstc->port->vcpi.vcpi, i;
> +
> +	WARN_ON(!mutex_is_locked(&mstm->mgr.payload_lock));
> +
> +	NV_ATOMIC(drm, "%s: vcpi %d\n", msto->encoder.name, vcpi);
> +	for (i =3D 0; i < mstm->mgr.max_payloads; i++) {
> +		struct drm_dp_payload *payload =3D &mstm->mgr.payloads[i];
> +		NV_ATOMIC(drm, "%s: %d: vcpi %d start 0x%02x slots 0x%02x\n",
> +			  mstm->outp->base.base.name, i, payload->vcpi,
> +			  payload->start_slot, payload->num_slots);
> +	}
> +
> +	for (i =3D 0; i < mstm->mgr.max_payloads; i++) {
> +		struct drm_dp_payload *payload =3D &mstm->mgr.payloads[i];
> +		if (payload->vcpi =3D=3D vcpi)
> +			return payload;
> +	}
> +
> +	return NULL;
> +}
> +
>  static void
> -nv50_msto_cleanup(struct drm_atomic_state *state,
> -		  struct drm_dp_mst_topology_state *mst_state,
> -		  struct drm_dp_mst_topology_mgr *mgr,
> -		  struct nv50_msto *msto)
> +nv50_msto_cleanup(struct nv50_msto *msto)
>  {
>  	struct nouveau_drm *drm =3D nouveau_drm(msto->encoder.dev);
> -	struct drm_dp_mst_atomic_payload *payload =3D
> -		drm_atomic_get_mst_payload_state(mst_state, msto->mstc->port);
> +	struct nv50_mstc *mstc =3D msto->mstc;
> +	struct nv50_mstm *mstm =3D mstc->mstm;
> +
> +	if (!msto->disabled)
> +		return;
> =20
>  	NV_ATOMIC(drm, "%s: msto cleanup\n", msto->encoder.name);
> =20
> -	if (msto->disabled) {
> -		msto->mstc =3D NULL;
> -		msto->disabled =3D false;
> -	} else if (msto->enabled) {
> -		drm_dp_add_payload_part2(mgr, state, payload);
> -		msto->enabled =3D false;
> -	}
> +	drm_dp_mst_deallocate_vcpi(&mstm->mgr, mstc->port);
> +
> +	msto->mstc =3D NULL;
> +	msto->disabled =3D false;
>  }
> =20
>  static void
> -nv50_msto_prepare(struct drm_atomic_state *state,
> -		  struct drm_dp_mst_topology_state *mst_state,
> -		  struct drm_dp_mst_topology_mgr *mgr,
> -		  struct nv50_msto *msto)
> +nv50_msto_prepare(struct nv50_msto *msto)
>  {
>  	struct nouveau_drm *drm =3D nouveau_drm(msto->encoder.dev);
>  	struct nv50_mstc *mstc =3D msto->mstc;
>  	struct nv50_mstm *mstm =3D mstc->mstm;
> -	struct drm_dp_mst_atomic_payload *payload;
> +	struct drm_dp_payload *payload =3D NULL;
> =20
> -	NV_ATOMIC(drm, "%s: msto prepare\n", msto->encoder.name);
> +	mutex_lock(&mstm->mgr.payload_lock);
> =20
> -	payload =3D drm_atomic_get_mst_payload_state(mst_state, mstc->port);
> +	NV_ATOMIC(drm, "%s: msto prepare\n", msto->encoder.name);
> =20
> -	// TODO: Figure out if we want to do a better job of handling VCPI allo=
cation failures here?
> -	if (msto->disabled) {
> -		drm_dp_remove_payload(mgr, mst_state, payload);
> +	if (mstc->port->vcpi.vcpi > 0)
> +		payload =3D nv50_msto_payload(msto);
> =20
> -		nvif_outp_dp_mst_vcpi(&mstm->outp->outp, msto->head->base.index, 0, 0,=
 0, 0);
> -	} else {
> -		if (msto->enabled)
> -			drm_dp_add_payload_part1(mgr, mst_state, payload);
> +	if (payload) {
> +		NV_ATOMIC(drm, "%s: %s: %02x %02x %04x %04x\n",
> +			  msto->encoder.name, msto->head->base.base.name,
> +			  payload->start_slot, payload->num_slots,
> +			  mstc->port->vcpi.pbn, mstc->port->vcpi.aligned_pbn);
> =20
>  		nvif_outp_dp_mst_vcpi(&mstm->outp->outp, msto->head->base.index,
> -				      payload->vc_start_slot, payload->time_slots,
> -				      payload->pbn, payload->time_slots * mst_state->pbn_div);
> +				      payload->start_slot, payload->num_slots,
> +				      mstc->port->vcpi.pbn, mstc->port->vcpi.aligned_pbn);
> +	} else {
> +		NV_ATOMIC(drm, "%s: %s: %02x %02x %04x %04x\n",
> +			  msto->encoder.name, msto->head->base.base.name, 0, 0, 0, 0);
> +		nvif_outp_dp_mst_vcpi(&mstm->outp->outp, msto->head->base.index, 0, 0,=
 0, 0);
>  	}
> +
> +	mutex_unlock(&mstm->mgr.payload_lock);
>  }
> =20
>  static int
> @@ -905,7 +931,6 @@ nv50_msto_atomic_check(struct drm_encoder *encoder,
>  {
>  	struct drm_atomic_state *state =3D crtc_state->state;
>  	struct drm_connector *connector =3D conn_state->connector;
> -	struct drm_dp_mst_topology_state *mst_state;
>  	struct nv50_mstc *mstc =3D nv50_mstc(connector);
>  	struct nv50_mstm *mstm =3D mstc->mstm;
>  	struct nv50_head_atom *asyh =3D nv50_head_atom(crtc_state);
> @@ -933,18 +958,8 @@ nv50_msto_atomic_check(struct drm_encoder *encoder,
>  						    false);
>  	}
> =20
> -	mst_state =3D drm_atomic_get_mst_topology_state(state, &mstm->mgr);
> -	if (IS_ERR(mst_state))
> -		return PTR_ERR(mst_state);
> -
> -	if (!mst_state->pbn_div) {
> -		struct nouveau_encoder *outp =3D mstc->mstm->outp;
> -
> -		mst_state->pbn_div =3D drm_dp_get_vc_payload_bw(&mstm->mgr,
> -							      outp->dp.link_bw, outp->dp.link_nr);
> -	}
> -
> -	slots =3D drm_dp_atomic_find_time_slots(state, &mstm->mgr, mstc->port, =
asyh->dp.pbn);
> +	slots =3D drm_dp_atomic_find_time_slots(state, &mstm->mgr, mstc->port,
> +					      asyh->dp.pbn, 0);
>  	if (slots < 0)
>  		return slots;
> =20
> @@ -976,6 +991,7 @@ nv50_msto_atomic_enable(struct drm_encoder *encoder, =
struct drm_atomic_state *st
>  	struct drm_connector *connector;
>  	struct drm_connector_list_iter conn_iter;
>  	u8 proto;
> +	bool r;
> =20
>  	drm_connector_list_iter_begin(encoder->dev, &conn_iter);
>  	drm_for_each_connector_iter(connector, &conn_iter) {
> @@ -990,6 +1006,10 @@ nv50_msto_atomic_enable(struct drm_encoder *encoder=
, struct drm_atomic_state *st
>  	if (WARN_ON(!mstc))
>  		return;
> =20
> +	r =3D drm_dp_mst_allocate_vcpi(&mstm->mgr, mstc->port, asyh->dp.pbn, as=
yh->dp.tu);
> +	if (!r)
> +		DRM_DEBUG_KMS("Failed to allocate VCPI\n");
> +
>  	if (!mstm->links++) {
>  		/*XXX: MST audio. */
>  		nvif_outp_acquire_dp(&mstm->outp->outp, mstm->outp->dp.dpcd, 0, 0, fal=
se, true);
> @@ -1004,7 +1024,6 @@ nv50_msto_atomic_enable(struct drm_encoder *encoder=
, struct drm_atomic_state *st
>  			   nv50_dp_bpc_to_depth(asyh->or.bpc));
> =20
>  	msto->mstc =3D mstc;
> -	msto->enabled =3D true;
>  	mstm->modified =3D true;
>  }
> =20
> @@ -1015,6 +1034,8 @@ nv50_msto_atomic_disable(struct drm_encoder *encode=
r, struct drm_atomic_state *s
>  	struct nv50_mstc *mstc =3D msto->mstc;
>  	struct nv50_mstm *mstm =3D mstc->mstm;
> =20
> +	drm_dp_mst_reset_vcpi_slots(&mstm->mgr, mstc->port);
> +
>  	mstm->outp->update(mstm->outp, msto->head->base.index, NULL, 0, 0);
>  	mstm->modified =3D true;
>  	if (!--mstm->links)
> @@ -1234,9 +1255,7 @@ nv50_mstc_new(struct nv50_mstm *mstm, struct drm_dp=
_mst_port *port,
>  }
> =20
>  static void
> -nv50_mstm_cleanup(struct drm_atomic_state *state,
> -		  struct drm_dp_mst_topology_state *mst_state,
> -		  struct nv50_mstm *mstm)
> +nv50_mstm_cleanup(struct nv50_mstm *mstm)
>  {
>  	struct nouveau_drm *drm =3D nouveau_drm(mstm->outp->base.base.dev);
>  	struct drm_encoder *encoder;
> @@ -1244,12 +1263,14 @@ nv50_mstm_cleanup(struct drm_atomic_state *state,
>  	NV_ATOMIC(drm, "%s: mstm cleanup\n", mstm->outp->base.base.name);
>  	drm_dp_check_act_status(&mstm->mgr);
> =20
> +	drm_dp_update_payload_part2(&mstm->mgr);
> +
>  	drm_for_each_encoder(encoder, mstm->outp->base.base.dev) {
>  		if (encoder->encoder_type =3D=3D DRM_MODE_ENCODER_DPMST) {
>  			struct nv50_msto *msto =3D nv50_msto(encoder);
>  			struct nv50_mstc *mstc =3D msto->mstc;
>  			if (mstc && mstc->mstm =3D=3D mstm)
> -				nv50_msto_cleanup(state, mst_state, &mstm->mgr, msto);
> +				nv50_msto_cleanup(msto);
>  		}
>  	}
> =20
> @@ -1257,34 +1278,20 @@ nv50_mstm_cleanup(struct drm_atomic_state *state,
>  }
> =20
>  static void
> -nv50_mstm_prepare(struct drm_atomic_state *state,
> -		  struct drm_dp_mst_topology_state *mst_state,
> -		  struct nv50_mstm *mstm)
> +nv50_mstm_prepare(struct nv50_mstm *mstm)
>  {
>  	struct nouveau_drm *drm =3D nouveau_drm(mstm->outp->base.base.dev);
>  	struct drm_encoder *encoder;
> =20
>  	NV_ATOMIC(drm, "%s: mstm prepare\n", mstm->outp->base.base.name);
> +	drm_dp_update_payload_part1(&mstm->mgr, 1);
> =20
> -	/* Disable payloads first */
> -	drm_for_each_encoder(encoder, mstm->outp->base.base.dev) {
> -		if (encoder->encoder_type =3D=3D DRM_MODE_ENCODER_DPMST) {
> -			struct nv50_msto *msto =3D nv50_msto(encoder);
> -			struct nv50_mstc *mstc =3D msto->mstc;
> -			if (mstc && mstc->mstm =3D=3D mstm && msto->disabled)
> -				nv50_msto_prepare(state, mst_state, &mstm->mgr, msto);
> -		}
> -	}
> -
> -	/* Add payloads for new heads, while also updating the start slots of a=
ny unmodified (but
> -	 * active) heads that may have had their VC slots shifted left after th=
e previous step
> -	 */
>  	drm_for_each_encoder(encoder, mstm->outp->base.base.dev) {
>  		if (encoder->encoder_type =3D=3D DRM_MODE_ENCODER_DPMST) {
>  			struct nv50_msto *msto =3D nv50_msto(encoder);
>  			struct nv50_mstc *mstc =3D msto->mstc;
> -			if (mstc && mstc->mstm =3D=3D mstm && !msto->disabled)
> -				nv50_msto_prepare(state, mst_state, &mstm->mgr, msto);
> +			if (mstc && mstc->mstm =3D=3D mstm)
> +				nv50_msto_prepare(msto);
>  		}
>  	}
> =20
> @@ -1455,7 +1462,9 @@ nv50_mstm_new(struct nouveau_encoder *outp, struct =
drm_dp_aux *aux, int aux_max,
>  	mstm->mgr.cbs =3D &nv50_mstm;
> =20
>  	ret =3D drm_dp_mst_topology_mgr_init(&mstm->mgr, dev, aux, aux_max,
> -					   max_payloads, conn_base_id);
> +					   max_payloads, outp->dcb->dpconf.link_nr,
> +					   drm_dp_bw_code_to_link_rate(outp->dcb->dpconf.link_bw),
> +					   conn_base_id);
>  	if (ret)
>  		return ret;
> =20
> @@ -1902,20 +1911,20 @@ nv50_pior_create(struct drm_connector *connector,=
 struct dcb_output *dcbe)
>  static void
>  nv50_disp_atomic_commit_core(struct drm_atomic_state *state, u32 *interl=
ock)
>  {
> -	struct drm_dp_mst_topology_mgr *mgr;
> -	struct drm_dp_mst_topology_state *mst_state;
>  	struct nouveau_drm *drm =3D nouveau_drm(state->dev);
>  	struct nv50_disp *disp =3D nv50_disp(drm->dev);
>  	struct nv50_core *core =3D disp->core;
>  	struct nv50_mstm *mstm;
> -	int i;
> +	struct drm_encoder *encoder;
> =20
>  	NV_ATOMIC(drm, "commit core %08x\n", interlock[NV50_DISP_INTERLOCK_BASE=
]);
> =20
> -	for_each_new_mst_mgr_in_state(state, mgr, mst_state, i) {
> -		mstm =3D nv50_mstm(mgr);
> -		if (mstm->modified)
> -			nv50_mstm_prepare(state, mst_state, mstm);
> +	drm_for_each_encoder(encoder, drm->dev) {
> +		if (encoder->encoder_type !=3D DRM_MODE_ENCODER_DPMST) {
> +			mstm =3D nouveau_encoder(encoder)->dp.mstm;
> +			if (mstm && mstm->modified)
> +				nv50_mstm_prepare(mstm);
> +		}
>  	}
> =20
>  	core->func->ntfy_init(disp->sync, NV50_DISP_CORE_NTFY);
> @@ -1924,10 +1933,12 @@ nv50_disp_atomic_commit_core(struct drm_atomic_st=
ate *state, u32 *interlock)
>  				       disp->core->chan.base.device))
>  		NV_ERROR(drm, "core notifier timeout\n");
> =20
> -	for_each_new_mst_mgr_in_state(state, mgr, mst_state, i) {
> -		mstm =3D nv50_mstm(mgr);
> -		if (mstm->modified)
> -			nv50_mstm_cleanup(state, mst_state, mstm);
> +	drm_for_each_encoder(encoder, drm->dev) {
> +		if (encoder->encoder_type !=3D DRM_MODE_ENCODER_DPMST) {
> +			mstm =3D nouveau_encoder(encoder)->dp.mstm;
> +			if (mstm && mstm->modified)
> +				nv50_mstm_cleanup(mstm);
> +		}
>  	}
>  }
> =20
> diff --git a/include/drm/display/drm_dp_mst_helper.h b/include/drm/displa=
y/drm_dp_mst_helper.h
> index 41fd8352ab65..6b8f738bd622 100644
> --- a/include/drm/display/drm_dp_mst_helper.h
> +++ b/include/drm/display/drm_dp_mst_helper.h
> @@ -48,6 +48,20 @@ struct drm_dp_mst_topology_ref_history {
> =20
>  struct drm_dp_mst_branch;
> =20
> +/**
> + * struct drm_dp_vcpi - Virtual Channel Payload Identifier
> + * @vcpi: Virtual channel ID.
> + * @pbn: Payload Bandwidth Number for this channel
> + * @aligned_pbn: PBN aligned with slot size
> + * @num_slots: number of slots for this PBN
> + */
> +struct drm_dp_vcpi {
> +	int vcpi;
> +	int pbn;
> +	int aligned_pbn;
> +	int num_slots;
> +};
> +
>  /**
>   * struct drm_dp_mst_port - MST port
>   * @port_num: port number
> @@ -131,6 +145,7 @@ struct drm_dp_mst_port {
>  	struct drm_dp_aux *passthrough_aux;
>  	struct drm_dp_mst_branch *parent;
> =20
> +	struct drm_dp_vcpi vcpi;
>  	struct drm_connector *connector;
>  	struct drm_dp_mst_topology_mgr *mgr;
> =20
> @@ -515,6 +530,19 @@ struct drm_dp_mst_topology_cbs {
>  	void (*poll_hpd_irq)(struct drm_dp_mst_topology_mgr *mgr);
>  };
> =20
> +#define DP_MAX_PAYLOAD (sizeof(unsigned long) * 8)
> +
> +#define DP_PAYLOAD_LOCAL 1
> +#define DP_PAYLOAD_REMOTE 2
> +#define DP_PAYLOAD_DELETE_LOCAL 3
> +
> +struct drm_dp_payload {
> +	int payload_state;
> +	int start_slot;
> +	int num_slots;
> +	int vcpi;
> +};
> +
>  #define to_dp_mst_topology_state(x) container_of(x, struct drm_dp_mst_to=
pology_state, base)
> =20
>  /**
> @@ -527,34 +555,6 @@ struct drm_dp_mst_atomic_payload {
>  	/** @port: The MST port assigned to this payload */
>  	struct drm_dp_mst_port *port;
> =20
> -	/**
> -	 * @vc_start_slot: The time slot that this payload starts on. Because p=
ayload start slots
> -	 * can't be determined ahead of time, the contents of this value are UN=
DEFINED at atomic
> -	 * check time. This shouldn't usually matter, as the start slot should =
never be relevant for
> -	 * atomic state computations.
> -	 *
> -	 * Since this value is determined at commit time instead of check time,=
 this value is
> -	 * protected by the MST helpers ensuring that async commits operating o=
n the given topology
> -	 * never run in parallel. In the event that a driver does need to read =
this value (e.g. to
> -	 * inform hardware of the starting timeslot for a payload), the driver =
may either:
> -	 *
> -	 * * Read this field during the atomic commit after
> -	 *   drm_dp_mst_atomic_wait_for_dependencies() has been called, which w=
ill ensure the
> -	 *   previous MST states payload start slots have been copied over to t=
he new state. Note
> -	 *   that a new start slot won't be assigned/removed from this payload =
until
> -	 *   drm_dp_add_payload_part1()/drm_dp_remove_payload() have been calle=
d.
> -	 * * Acquire the MST modesetting lock, and then wait for any pending MS=
T-related commits to
> -	 *   get committed to hardware by calling drm_crtc_commit_wait() on eac=
h of the
> -	 *   &drm_crtc_commit structs in &drm_dp_mst_topology_state.commit_deps=
.
> -	 *
> -	 * If neither of the two above solutions suffice (e.g. the driver needs=
 to read the start
> -	 * slot in the middle of an atomic commit without waiting for some reas=
on), then drivers
> -	 * should cache this value themselves after changing payloads.
> -	 */
> -	s8 vc_start_slot;
> -
> -	/** @vcpi: The Virtual Channel Payload Identifier */
> -	u8 vcpi;
>  	/**
>  	 * @time_slots:
>  	 * The number of timeslots allocated to this payload from the source DP=
 Tx to
> @@ -582,6 +582,8 @@ struct drm_dp_mst_topology_state {
>  	/** @base: Base private state for atomic */
>  	struct drm_private_state base;
> =20
> +	/** @payloads: The list of payloads being created/destroyed in this sta=
te */
> +	struct list_head payloads;
>  	/** @mgr: The topology manager */
>  	struct drm_dp_mst_topology_mgr *mgr;
> =20
> @@ -598,21 +600,10 @@ struct drm_dp_mst_topology_state {
>  	/** @num_commit_deps: The number of CRTC commits in @commit_deps */
>  	size_t num_commit_deps;
> =20
> -	/** @payload_mask: A bitmask of allocated VCPIs, used for VCPI assignme=
nts */
> -	u32 payload_mask;
> -	/** @payloads: The list of payloads being created/destroyed in this sta=
te */
> -	struct list_head payloads;
> -
>  	/** @total_avail_slots: The total number of slots this topology can han=
dle (63 or 64) */
>  	u8 total_avail_slots;
>  	/** @start_slot: The first usable time slot in this topology (1 or 0) *=
/
>  	u8 start_slot;
> -
> -	/**
> -	 * @pbn_div: The current PBN divisor for this topology. The driver is e=
xpected to fill this
> -	 * out itself.
> -	 */
> -	int pbn_div;
>  };
> =20
>  #define to_dp_mst_topology_mgr(x) container_of(x, struct drm_dp_mst_topo=
logy_mgr, base)
> @@ -652,6 +643,14 @@ struct drm_dp_mst_topology_mgr {
>  	 * @max_payloads: maximum number of payloads the GPU can generate.
>  	 */
>  	int max_payloads;
> +	/**
> +	 * @max_lane_count: maximum number of lanes the GPU can drive.
> +	 */
> +	int max_lane_count;
> +	/**
> +	 * @max_link_rate: maximum link rate per lane GPU can output, in kHz.
> +	 */
> +	int max_link_rate;
>  	/**
>  	 * @conn_base_id: DRM connector ID this mgr is connected to. Only used
>  	 * to build the MST connector path value.
> @@ -694,20 +693,6 @@ struct drm_dp_mst_topology_mgr {
>  	 */
>  	bool payload_id_table_cleared : 1;
> =20
> -	/**
> -	 * @payload_count: The number of currently active payloads in hardware.=
 This value is only
> -	 * intended to be used internally by MST helpers for payload tracking, =
and is only safe to
> -	 * read/write from the atomic commit (not check) context.
> -	 */
> -	u8 payload_count;
> -
> -	/**
> -	 * @next_start_slot: The starting timeslot to use for new VC payloads. =
This value is used
> -	 * internally by MST helpers for payload tracking, and is only safe to =
read/write from the
> -	 * atomic commit (not check) context.
> -	 */
> -	u8 next_start_slot;
> -
>  	/**
>  	 * @mst_primary: Pointer to the primary/first branch device.
>  	 */
> @@ -721,6 +706,10 @@ struct drm_dp_mst_topology_mgr {
>  	 * @sink_count: Sink count from DEVICE_SERVICE_IRQ_VECTOR_ESI0.
>  	 */
>  	u8 sink_count;
> +	/**
> +	 * @pbn_div: PBN to slots divisor.
> +	 */
> +	int pbn_div;
> =20
>  	/**
>  	 * @funcs: Atomic helper callbacks
> @@ -737,6 +726,32 @@ struct drm_dp_mst_topology_mgr {
>  	 */
>  	struct list_head tx_msg_downq;
> =20
> +	/**
> +	 * @payload_lock: Protect payload information.
> +	 */
> +	struct mutex payload_lock;
> +	/**
> +	 * @proposed_vcpis: Array of pointers for the new VCPI allocation. The
> +	 * VCPI structure itself is &drm_dp_mst_port.vcpi, and the size of
> +	 * this array is determined by @max_payloads.
> +	 */
> +	struct drm_dp_vcpi **proposed_vcpis;
> +	/**
> +	 * @payloads: Array of payloads. The size of this array is determined
> +	 * by @max_payloads.
> +	 */
> +	struct drm_dp_payload *payloads;
> +	/**
> +	 * @payload_mask: Elements of @payloads actually in use. Since
> +	 * reallocation of active outputs isn't possible gaps can be created by
> +	 * disabling outputs out of order compared to how they've been enabled.
> +	 */
> +	unsigned long payload_mask;
> +	/**
> +	 * @vcpi_mask: Similar to @payload_mask, but for @proposed_vcpis.
> +	 */
> +	unsigned long vcpi_mask;
> +
>  	/**
>  	 * @tx_waitq: Wait to queue stall for the tx worker.
>  	 */
> @@ -808,7 +823,9 @@ struct drm_dp_mst_topology_mgr {
>  int drm_dp_mst_topology_mgr_init(struct drm_dp_mst_topology_mgr *mgr,
>  				 struct drm_device *dev, struct drm_dp_aux *aux,
>  				 int max_dpcd_transaction_bytes,
> -				 int max_payloads, int conn_base_id);
> +				 int max_payloads,
> +				 int max_lane_count, int max_link_rate,
> +				 int conn_base_id);
> =20
>  void drm_dp_mst_topology_mgr_destroy(struct drm_dp_mst_topology_mgr *mgr=
);
> =20
> @@ -831,17 +848,28 @@ int drm_dp_get_vc_payload_bw(const struct drm_dp_ms=
t_topology_mgr *mgr,
> =20
>  int drm_dp_calc_pbn_mode(int clock, int bpp, bool dsc);
> =20
> +bool drm_dp_mst_allocate_vcpi(struct drm_dp_mst_topology_mgr *mgr,
> +			      struct drm_dp_mst_port *port, int pbn, int slots);
> +
> +int drm_dp_mst_get_vcpi_slots(struct drm_dp_mst_topology_mgr *mgr, struc=
t drm_dp_mst_port *port);
> +
> +
> +void drm_dp_mst_reset_vcpi_slots(struct drm_dp_mst_topology_mgr *mgr, st=
ruct drm_dp_mst_port *port);
> +
>  void drm_dp_mst_update_slots(struct drm_dp_mst_topology_state *mst_state=
, uint8_t link_encoding_cap);
> =20
> -int drm_dp_add_payload_part1(struct drm_dp_mst_topology_mgr *mgr,
> -			     struct drm_dp_mst_topology_state *mst_state,
> -			     struct drm_dp_mst_atomic_payload *payload);
> -int drm_dp_add_payload_part2(struct drm_dp_mst_topology_mgr *mgr,
> -			     struct drm_atomic_state *state,
> -			     struct drm_dp_mst_atomic_payload *payload);
> -void drm_dp_remove_payload(struct drm_dp_mst_topology_mgr *mgr,
> -			   struct drm_dp_mst_topology_state *mst_state,
> -			   struct drm_dp_mst_atomic_payload *payload);
> +void drm_dp_mst_deallocate_vcpi(struct drm_dp_mst_topology_mgr *mgr,
> +				struct drm_dp_mst_port *port);
> +
> +
> +int drm_dp_find_vcpi_slots(struct drm_dp_mst_topology_mgr *mgr,
> +			   int pbn);
> +
> +
> +int drm_dp_update_payload_part1(struct drm_dp_mst_topology_mgr *mgr, int=
 start_slot);
> +
> +
> +int drm_dp_update_payload_part2(struct drm_dp_mst_topology_mgr *mgr);
> =20
>  int drm_dp_check_act_status(struct drm_dp_mst_topology_mgr *mgr);
> =20
> @@ -863,22 +891,17 @@ int drm_dp_mst_connector_late_register(struct drm_c=
onnector *connector,
>  void drm_dp_mst_connector_early_unregister(struct drm_connector *connect=
or,
>  					   struct drm_dp_mst_port *port);
> =20
> -struct drm_dp_mst_topology_state *
> -drm_atomic_get_mst_topology_state(struct drm_atomic_state *state,
> -				  struct drm_dp_mst_topology_mgr *mgr);
> -struct drm_dp_mst_topology_state *
> -drm_atomic_get_new_mst_topology_state(struct drm_atomic_state *state,
> -				      struct drm_dp_mst_topology_mgr *mgr);
> -struct drm_dp_mst_atomic_payload *
> -drm_atomic_get_mst_payload_state(struct drm_dp_mst_topology_state *state=
,
> -				 struct drm_dp_mst_port *port);
> +struct drm_dp_mst_topology_state *drm_atomic_get_mst_topology_state(stru=
ct drm_atomic_state *state,
> +								    struct drm_dp_mst_topology_mgr *mgr);
>  int __must_check
>  drm_dp_atomic_find_time_slots(struct drm_atomic_state *state,
>  			      struct drm_dp_mst_topology_mgr *mgr,
> -			      struct drm_dp_mst_port *port, int pbn);
> +			      struct drm_dp_mst_port *port, int pbn,
> +			      int pbn_div);
>  int drm_dp_mst_atomic_enable_dsc(struct drm_atomic_state *state,
>  				 struct drm_dp_mst_port *port,
> -				 int pbn, bool enable);
> +				 int pbn, int pbn_div,
> +				 bool enable);
>  int __must_check
>  drm_dp_mst_add_affected_dsc_crtcs(struct drm_atomic_state *state,
>  				  struct drm_dp_mst_topology_mgr *mgr);
> @@ -902,12 +925,6 @@ void drm_dp_mst_put_port_malloc(struct drm_dp_mst_po=
rt *port);
> =20
>  struct drm_dp_aux *drm_dp_mst_dsc_aux_for_port(struct drm_dp_mst_port *p=
ort);
> =20
> -static inline struct drm_dp_mst_topology_state *
> -to_drm_dp_mst_topology_state(struct drm_private_state *state)
> -{
> -	return container_of(state, struct drm_dp_mst_topology_state, base);
> -}
> -
>  extern const struct drm_private_state_funcs drm_dp_mst_topology_state_fu=
ncs;
> =20
>  /**

--=20
Cheers,
 Lyude Paul (she/her)
 Software Engineer at Red Hat

