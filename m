Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3CCF764D1E9
	for <lists+stable@lfdr.de>; Wed, 14 Dec 2022 22:42:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229658AbiLNVmi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 14 Dec 2022 16:42:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37822 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229558AbiLNVme (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 14 Dec 2022 16:42:34 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 79854112A
        for <stable@vger.kernel.org>; Wed, 14 Dec 2022 13:41:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1671054106;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=cdHdAoArTyqSXyDa1PEkCBag/sq888ZHYvAImxogP+M=;
        b=QUfsSdcVsNQnBCTCzLuhBnXl2a9A3NjR2yB5U8Myk1hfuTICSK63rNqX4aaAKRUxpcffVX
        0P+nscIDWYnCP/e1kaN1n6Vs2mf5nQNND+yDhKSpxKymCN9FCLm73yQRwcXnPBNfqNaR0x
        Jlmu47VT2q9aYfNM/VGp2Ueq4dJitDI=
Received: from mail-qk1-f200.google.com (mail-qk1-f200.google.com
 [209.85.222.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-122-wUR0_d5GN3qdrhxdOTq7mQ-1; Wed, 14 Dec 2022 16:41:45 -0500
X-MC-Unique: wUR0_d5GN3qdrhxdOTq7mQ-1
Received: by mail-qk1-f200.google.com with SMTP id bq39-20020a05620a46a700b006ffd5db9fe9so1804184qkb.2
        for <stable@vger.kernel.org>; Wed, 14 Dec 2022 13:41:45 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=mime-version:user-agent:content-transfer-encoding:organization
         :references:in-reply-to:date:cc:to:from:subject:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=cdHdAoArTyqSXyDa1PEkCBag/sq888ZHYvAImxogP+M=;
        b=6t5UwFXz4BpPYUIXhQ1/MIyeeBIRm8KfIHeWuASxgAqBj/SH4K8jkOPE+4dd68C/aR
         quEMS5rRSunGPZVN2nTJ2kpnQZPiLBqZSfysz6fN18janoaLoWw0ugIgAXvXOf8yi6m5
         CJ7b8jbQkZyAof/P04Winn0CSS6vpC7DOzQcMihGgyrF6hfJ8MZNxysqBccpsZvYP3Zh
         ksnqv534vqQqfiOc7tfLAEOLJacG4BKRkrpWxIHEyfvWusKFtAt1icpwsl/roT+QmwD3
         p6HVNCdQ3sGzkzdFwHIe3l8UfKtCI7871eCC4/GErfm//NiG3TwuivqxZPLvtirKFOMZ
         TfWQ==
X-Gm-Message-State: ANoB5pn9ioSzYfFmJR+T3LIFd5F7rvUMG/zHrTvl9DluFG3X8XUkp/0Q
        ny97OmW4hn9dxXB5bfPj/ilcQJjDXnl8ngfjxYJYyGS4E6NHVo26s1W77ASlzei1vtSgZ04z8jl
        OKkjMYucCsS+NtWzX
X-Received: by 2002:a0c:ee42:0:b0:4c6:9271:a037 with SMTP id m2-20020a0cee42000000b004c69271a037mr31285565qvs.30.1671054104458;
        Wed, 14 Dec 2022 13:41:44 -0800 (PST)
X-Google-Smtp-Source: AA0mqf6/X83985KkuvLTvoDpqH8sCw8wzfXSCZscLl6n0ADVrXXhZF1/89D4asUprsIO5b6HJfQikQ==
X-Received: by 2002:a0c:ee42:0:b0:4c6:9271:a037 with SMTP id m2-20020a0cee42000000b004c69271a037mr31285543qvs.30.1671054104212;
        Wed, 14 Dec 2022 13:41:44 -0800 (PST)
Received: from ?IPv6:2600:4040:5c6c:9200:beb9:10e2:8071:6929? ([2600:4040:5c6c:9200:beb9:10e2:8071:6929])
        by smtp.gmail.com with ESMTPSA id u15-20020a05620a454f00b006fa22f0494bsm10879054qkp.117.2022.12.14.13.41.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 14 Dec 2022 13:41:43 -0800 (PST)
Message-ID: <1ade43347769118c82f1b68bd8b51172a1012a37.camel@redhat.com>
Subject: Re: [PATCH 1/3] drm/display/dp_mst: Fix down/up message handling
 after sink disconnect
From:   Lyude Paul <lyude@redhat.com>
To:     Imre Deak <imre.deak@intel.com>, intel-gfx@lists.freedesktop.org
Cc:     dri-devel@lists.freedesktop.org, stable@vger.kernel.org
Date:   Wed, 14 Dec 2022 16:41:42 -0500
In-Reply-To: <20221214184258.2869417-1-imre.deak@intel.com>
References: <20221214184258.2869417-1-imre.deak@intel.com>
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

For the whole series:

Reviewed-by: Lyude Paul <lyude@redhat.com>

Thanks!

On Wed, 2022-12-14 at 20:42 +0200, Imre Deak wrote:
> If the sink gets disconnected during receiving a multi-packet DP MST AUX
> down-reply/up-request sideband message, the state keeping track of which
> packets have been received already is not reset. This results in a failed
> sanity check for the subsequent message packet received after a sink is
> reconnected (due to the pending message not yet completed with an
> end-of-message-transfer packet), indicated by the
>=20
> "sideband msg set header failed"
>=20
> error.
>=20
> Fix the above by resetting the up/down message reception state after a
> disconnect event.
>=20
> Cc: Lyude Paul <lyude@redhat.com>
> Cc: <stable@vger.kernel.org> # v3.17+
> Signed-off-by: Imre Deak <imre.deak@intel.com>
> ---
>  drivers/gpu/drm/display/drm_dp_mst_topology.c | 3 +++
>  1 file changed, 3 insertions(+)
>=20
> diff --git a/drivers/gpu/drm/display/drm_dp_mst_topology.c b/drivers/gpu/=
drm/display/drm_dp_mst_topology.c
> index 51a46689cda70..90819fff2c9ba 100644
> --- a/drivers/gpu/drm/display/drm_dp_mst_topology.c
> +++ b/drivers/gpu/drm/display/drm_dp_mst_topology.c
> @@ -3641,6 +3641,9 @@ int drm_dp_mst_topology_mgr_set_mst(struct drm_dp_m=
st_topology_mgr *mgr, bool ms
>  		drm_dp_dpcd_writeb(mgr->aux, DP_MSTM_CTRL, 0);
>  		ret =3D 0;
>  		mgr->payload_id_table_cleared =3D false;
> +
> +		memset(&mgr->down_rep_recv, 0, sizeof(mgr->down_rep_recv));
> +		memset(&mgr->up_req_recv, 0, sizeof(mgr->up_req_recv));
>  	}
> =20
>  out_unlock:

--=20
Cheers,
 Lyude Paul (she/her)
 Software Engineer at Red Hat

