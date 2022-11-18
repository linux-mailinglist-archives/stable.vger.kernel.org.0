Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D12EE62FE8A
	for <lists+stable@lfdr.de>; Fri, 18 Nov 2022 21:07:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229933AbiKRUHM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 18 Nov 2022 15:07:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45996 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229611AbiKRUHL (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 18 Nov 2022 15:07:11 -0500
Received: from mail-ot1-x32e.google.com (mail-ot1-x32e.google.com [IPv6:2607:f8b0:4864:20::32e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 221CE6473;
        Fri, 18 Nov 2022 12:07:09 -0800 (PST)
Received: by mail-ot1-x32e.google.com with SMTP id p27-20020a056830319b00b0066d7a348e20so3722457ots.8;
        Fri, 18 Nov 2022 12:07:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=iWrLQzZhWGg40xm1HIoW5q0rE7DyoZ/31a5Rtn1G1iU=;
        b=aRNAQzOIlzGiW0Vb2egsDYPo7zoOlexmzfz2OaGh6TLZ0jo0eZ8NFeoQn3RUn39QV3
         wdV4gBPASZdh1svL6GvvWcweSm8eRS9kPJSzwJgo1oklU6o152T/BQSqmt5WUhDq4K1X
         9YdTRWfxpX+QYb7d2b+en0gc22eBVKUy6RbmofcM0Bd+GMZF64qkGORMB51Lk3bm42yt
         5ZItF8H0laOOsGor/9bocsW1lunnzNbA7leu2OAJLVC0aVT0OibXnJur2JEgI3fNDnye
         qPnBNLLqJnfl9BFuyxzkV/peJMs2k4wfqaLxpHi/8yl98ZTOaJAZMNBrLVh0TXftkomC
         ByKA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=iWrLQzZhWGg40xm1HIoW5q0rE7DyoZ/31a5Rtn1G1iU=;
        b=YQjbLBh5W3TWZdgnvQukmY2cs8oR02oj5WgfAwasDnABYTbolo9gihJNcUHGaHK3lX
         BhoWtRhk1/LcuQkz7T2uUVkFhIxTBvJ/JtTFZ106CiDHbA+RdN7gLfZ8Anv32fYM7yIo
         Jim4TiWj4slowWDZBbzLIIr73v3fgR4T8yInWxsnx+RQu22/cnf9UvNiS0ur0us4ZiuJ
         cm3W/RRGHP/ajZROg/ohTj0Tj4q6HXIgIXjveOIVxJyM0srCYvwLXu6928+0vLdtNnUj
         fffC/0m54Cxow2HP5Cis82DcBlb1XD5i6pycasovdGUtUmXqllOzfRC2tWzeisAOVEz5
         /tmw==
X-Gm-Message-State: ANoB5pnDLrCpp8QFNs2vSfDP7SC0e6oWIS3IweGml7RkmuYh92mFgO1v
        5At/tu4cRjubxfjaec1l+jqMX8j0HSrEAJqzei0=
X-Google-Smtp-Source: AA0mqf7KPqPMZtzQjWZyLdnum9C/3DhaU0UAR0F5VlnIiHqzEwjpiLKLONJNMKkkP/A7sef4FjnKAddhehVEtuLM53Q=
X-Received: by 2002:a05:6830:1b62:b0:66c:7982:2d45 with SMTP id
 d2-20020a0568301b6200b0066c79822d45mr4648224ote.123.1668802028331; Fri, 18
 Nov 2022 12:07:08 -0800 (PST)
MIME-Version: 1.0
References: <20221114221754.385090-1-lyude@redhat.com> <20221114221754.385090-2-lyude@redhat.com>
 <CO6PR12MB548932515652B8D3130C66DEFC079@CO6PR12MB5489.namprd12.prod.outlook.com>
 <35e55d8040afdcb5684bec16ff710ce5ff32b202.camel@redhat.com>
 <CADnq5_PgU-XO2nYGYwmod0VX750SXarkk+tsX3qfzqyos7Cx1g@mail.gmail.com>
 <cf10ae993fb08c474b1dff1e2a5ef7d11d519055.camel@redhat.com> <b4391ff6a53a7c9a4d532c929b0dd62c9e80a562.camel@redhat.com>
In-Reply-To: <b4391ff6a53a7c9a4d532c929b0dd62c9e80a562.camel@redhat.com>
From:   Alex Deucher <alexdeucher@gmail.com>
Date:   Fri, 18 Nov 2022 15:06:56 -0500
Message-ID: <CADnq5_O8z6PFjtHmkvQ09zr2Gbe9zO+S4JsAhoZLScO94vaAdQ@mail.gmail.com>
Subject: Re: [PATCH v2 1/4] drm/amdgpu/mst: Stop ignoring error codes and deadlocking
To:     Lyude Paul <lyude@redhat.com>
Cc:     "Lin, Wayne" <Wayne.Lin@amd.com>,
        "amd-gfx@lists.freedesktop.org" <amd-gfx@lists.freedesktop.org>,
        "Liu, Wenjing" <Wenjing.Liu@amd.com>,
        "open list:DRM DRIVERS" <dri-devel@lists.freedesktop.org>,
        open list <linux-kernel@vger.kernel.org>,
        "Mahfooz, Hamza" <Hamza.Mahfooz@amd.com>,
        David Airlie <airlied@gmail.com>,
        "Francis, David" <David.Francis@amd.com>,
        "Siqueira, Rodrigo" <Rodrigo.Siqueira@amd.com>,
        "Hung, Alex" <Alex.Hung@amd.com>, "Zuo, Jerry" <Jerry.Zuo@amd.com>,
        "Pillai, Aurabindo" <Aurabindo.Pillai@amd.com>,
        "Wentland, Harry" <Harry.Wentland@amd.com>,
        Daniel Vetter <daniel@ffwll.ch>,
        "Li, Sun peng (Leo)" <Sunpeng.Li@amd.com>,
        "Wu, Hersen" <hersenxs.wu@amd.com>,
        Mikita Lipski <mikita.lipski@amd.com>,
        "Pan, Xinhui" <Xinhui.Pan@amd.com>, "Li, Roman" <Roman.Li@amd.com>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        "Koenig, Christian" <Christian.Koenig@amd.com>,
        Thomas Zimmermann <tzimmermann@suse.de>,
        "Deucher, Alexander" <Alexander.Deucher@amd.com>,
        "Kazlauskas, Nicholas" <Nicholas.Kazlauskas@amd.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Nov 18, 2022 at 2:53 PM Lyude Paul <lyude@redhat.com> wrote:
>
> JFYI - I'm not sure of the correct commit ID to add for the Fixes: tag since
> it's in your branch, so I'll omit that and let you add it into the patch

Yeah, I'll add that.  Many thanks!

Alex

>
> On Fri, 2022-11-18 at 14:47 -0500, Lyude Paul wrote:
> > of course, will do in just a moment
> >
> > On Fri, 2022-11-18 at 14:46 -0500, Alex Deucher wrote:
> > > I've already picked this up.  Can you send a follow up patch with just
> > > the coverity fix?
> > >
> > > Alex
> > >
> > > On Fri, Nov 18, 2022 at 2:17 PM Lyude Paul <lyude@redhat.com> wrote:
> > > >
> > > > JFYI, Coverity pointed out one more issue with this series so I'm going to
> > > > send out a respin real quick to fix it. It's just a missing variable
> > > > assignment (we leave ret unassigned by mistake in
> > > > pre_compute_mst_dsc_configs()) so I will carry over your r-b on it.
> > > >
> > > > On Wed, 2022-11-16 at 04:39 +0000, Lin, Wayne wrote:
> > > > > [Public]
> > > > >
> > > > > All the patch set looks good to me. Feel free to add:
> > > > > Reviewed-by: Wayne Lin <Wayne.Lin@amd.com>
> > > > >
> > > > > Again, thank you Lyude for helping on this!!!
> > > > >
> > > > > Regards,
> > > > > Wayne
> > > > > > -----Original Message-----
> > > > > > From: Lyude Paul <lyude@redhat.com>
> > > > > > Sent: Tuesday, November 15, 2022 6:18 AM
> > > > > > To: amd-gfx@lists.freedesktop.org
> > > > > > Cc: Wentland, Harry <Harry.Wentland@amd.com>; stable@vger.kernel.org;
> > > > > > Li, Sun peng (Leo) <Sunpeng.Li@amd.com>; Siqueira, Rodrigo
> > > > > > <Rodrigo.Siqueira@amd.com>; Deucher, Alexander
> > > > > > <Alexander.Deucher@amd.com>; Koenig, Christian
> > > > > > <Christian.Koenig@amd.com>; Pan, Xinhui <Xinhui.Pan@amd.com>; David
> > > > > > Airlie <airlied@gmail.com>; Daniel Vetter <daniel@ffwll.ch>; Kazlauskas,
> > > > > > Nicholas <Nicholas.Kazlauskas@amd.com>; Pillai, Aurabindo
> > > > > > <Aurabindo.Pillai@amd.com>; Li, Roman <Roman.Li@amd.com>; Zuo, Jerry
> > > > > > <Jerry.Zuo@amd.com>; Wu, Hersen <hersenxs.wu@amd.com>; Lin, Wayne
> > > > > > <Wayne.Lin@amd.com>; Thomas Zimmermann <tzimmermann@suse.de>;
> > > > > > Mahfooz, Hamza <Hamza.Mahfooz@amd.com>; Hung, Alex
> > > > > > <Alex.Hung@amd.com>; Mikita Lipski <mikita.lipski@amd.com>; Liu,
> > > > > > Wenjing <Wenjing.Liu@amd.com>; Francis, David
> > > > > > <David.Francis@amd.com>; open list:DRM DRIVERS <dri-
> > > > > > devel@lists.freedesktop.org>; open list <linux-kernel@vger.kernel.org>
> > > > > > Subject: [PATCH v2 1/4] drm/amdgpu/mst: Stop ignoring error codes and
> > > > > > deadlocking
> > > > > >
> > > > > > It appears that amdgpu makes the mistake of completely ignoring the return
> > > > > > values from the DP MST helpers, and instead just returns a simple true/false.
> > > > > > In this case, it seems to have come back to bite us because as a result of
> > > > > > simply returning false from compute_mst_dsc_configs_for_state(), amdgpu
> > > > > > had no way of telling when a deadlock happened from these helpers. This
> > > > > > could definitely result in some kernel splats.
> > > > > >
> > > > > > V2:
> > > > > > * Address Wayne's comments (fix another bunch of spots where we weren't
> > > > > >   passing down return codes)
> > > > > >
> > > > > > Signed-off-by: Lyude Paul <lyude@redhat.com>
> > > > > > Fixes: 8c20a1ed9b4f ("drm/amd/display: MST DSC compute fair share")
> > > > > > Cc: Harry Wentland <harry.wentland@amd.com>
> > > > > > Cc: <stable@vger.kernel.org> # v5.6+
> > > > > > ---
> > > > > >  .../gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c |  18 +-
> > > > > >  .../display/amdgpu_dm/amdgpu_dm_mst_types.c   | 235 ++++++++++------
> > > > > > --
> > > > > >  .../display/amdgpu_dm/amdgpu_dm_mst_types.h   |  12 +-
> > > > > >  3 files changed, 147 insertions(+), 118 deletions(-)
> > > > > >
> > > > > > diff --git a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
> > > > > > b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
> > > > > > index 0db2a88cd4d7b..852a2100c6b38 100644
> > > > > > --- a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
> > > > > > +++ b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
> > > > > > @@ -6462,7 +6462,7 @@ static int
> > > > > > dm_update_mst_vcpi_slots_for_dsc(struct drm_atomic_state *state,
> > > > > >     struct drm_connector_state *new_con_state;
> > > > > >     struct amdgpu_dm_connector *aconnector;
> > > > > >     struct dm_connector_state *dm_conn_state;
> > > > > > -   int i, j;
> > > > > > +   int i, j, ret;
> > > > > >     int vcpi, pbn_div, pbn, slot_num = 0;
> > > > > >
> > > > > >     for_each_new_connector_in_state(state, connector,
> > > > > > new_con_state, i) { @@ -6509,8 +6509,11 @@ static int
> > > > > > dm_update_mst_vcpi_slots_for_dsc(struct drm_atomic_state *state,
> > > > > >                     dm_conn_state->pbn = pbn;
> > > > > >                     dm_conn_state->vcpi_slots = slot_num;
> > > > > >
> > > > > > -                   drm_dp_mst_atomic_enable_dsc(state, aconnector-
> > > > > > > port, dm_conn_state->pbn,
> > > > > > -                                                false);
> > > > > > +                   ret = drm_dp_mst_atomic_enable_dsc(state,
> > > > > > aconnector->port,
> > > > > > +                                                      dm_conn_state-
> > > > > > > pbn, false);
> > > > > > +                   if (ret < 0)
> > > > > > +                           return ret;
> > > > > > +
> > > > > >                     continue;
> > > > > >             }
> > > > > >
> > > > > > @@ -9523,10 +9526,9 @@ static int amdgpu_dm_atomic_check(struct
> > > > > > drm_device *dev,
> > > > > >
> > > > > >  #if defined(CONFIG_DRM_AMD_DC_DCN)
> > > > > >     if (dc_resource_is_dsc_encoding_supported(dc)) {
> > > > > > -           if (!pre_validate_dsc(state, &dm_state, vars)) {
> > > > > > -                   ret = -EINVAL;
> > > > > > +           ret = pre_validate_dsc(state, &dm_state, vars);
> > > > > > +           if (ret != 0)
> > > > > >                     goto fail;
> > > > > > -           }
> > > > > >     }
> > > > > >  #endif
> > > > > >
> > > > > > @@ -9621,9 +9623,9 @@ static int amdgpu_dm_atomic_check(struct
> > > > > > drm_device *dev,
> > > > > >             }
> > > > > >
> > > > > >  #if defined(CONFIG_DRM_AMD_DC_DCN)
> > > > > > -           if (!compute_mst_dsc_configs_for_state(state, dm_state-
> > > > > > > context, vars)) {
> > > > > > +           ret = compute_mst_dsc_configs_for_state(state, dm_state-
> > > > > > > context, vars);
> > > > > > +           if (ret) {
> > > > > >
> > > > > >     DRM_DEBUG_DRIVER("compute_mst_dsc_configs_for_state()
> > > > > > failed\n");
> > > > > > -                   ret = -EINVAL;
> > > > > >                     goto fail;
> > > > > >             }
> > > > > >
> > > > > > diff --git
> > > > > > a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_mst_types.c
> > > > > > b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_mst_types.c
> > > > > > index 6ff96b4bdda5c..bba2e8aaa2c20 100644
> > > > > > --- a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_mst_types.c
> > > > > > +++
> > > > > > b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_mst_types.c
> > > > > > @@ -703,13 +703,13 @@ static int bpp_x16_from_pbn(struct
> > > > > > dsc_mst_fairness_params param, int pbn)
> > > > > >     return dsc_config.bits_per_pixel;
> > > > > >  }
> > > > > >
> > > > > > -static bool increase_dsc_bpp(struct drm_atomic_state *state,
> > > > > > -                        struct drm_dp_mst_topology_state *mst_state,
> > > > > > -                        struct dc_link *dc_link,
> > > > > > -                        struct dsc_mst_fairness_params *params,
> > > > > > -                        struct dsc_mst_fairness_vars *vars,
> > > > > > -                        int count,
> > > > > > -                        int k)
> > > > > > +static int increase_dsc_bpp(struct drm_atomic_state *state,
> > > > > > +                       struct drm_dp_mst_topology_state *mst_state,
> > > > > > +                       struct dc_link *dc_link,
> > > > > > +                       struct dsc_mst_fairness_params *params,
> > > > > > +                       struct dsc_mst_fairness_vars *vars,
> > > > > > +                       int count,
> > > > > > +                       int k)
> > > > > >  {
> > > > > >     int i;
> > > > > >     bool bpp_increased[MAX_PIPES];
> > > > > > @@ -719,6 +719,7 @@ static bool increase_dsc_bpp(struct
> > > > > > drm_atomic_state *state,
> > > > > >     int remaining_to_increase = 0;
> > > > > >     int link_timeslots_used;
> > > > > >     int fair_pbn_alloc;
> > > > > > +   int ret = 0;
> > > > > >
> > > > > >     for (i = 0; i < count; i++) {
> > > > > >             if (vars[i + k].dsc_enabled) {
> > > > > > @@ -757,52 +758,60 @@ static bool increase_dsc_bpp(struct
> > > > > > drm_atomic_state *state,
> > > > > >
> > > > > >             if (initial_slack[next_index] > fair_pbn_alloc) {
> > > > > >                     vars[next_index].pbn += fair_pbn_alloc;
> > > > > > -                   if (drm_dp_atomic_find_time_slots(state,
> > > > > > -
> > > > > > params[next_index].port->mgr,
> > > > > > -
> > > > > > params[next_index].port,
> > > > > > -
> > > > > > vars[next_index].pbn) < 0)
> > > > > > -                           return false;
> > > > > > -                   if (!drm_dp_mst_atomic_check(state)) {
> > > > > > +                   ret = drm_dp_atomic_find_time_slots(state,
> > > > > > +
> > > > > > params[next_index].port->mgr,
> > > > > > +
> > > > > > params[next_index].port,
> > > > > > +
> > > > > > vars[next_index].pbn);
> > > > > > +                   if (ret < 0)
> > > > > > +                           return ret;
> > > > > > +
> > > > > > +                   ret = drm_dp_mst_atomic_check(state);
> > > > > > +                   if (ret == 0) {
> > > > > >                             vars[next_index].bpp_x16 =
> > > > > > bpp_x16_from_pbn(params[next_index], vars[next_index].pbn);
> > > > > >                     } else {
> > > > > >                             vars[next_index].pbn -= fair_pbn_alloc;
> > > > > > -                           if (drm_dp_atomic_find_time_slots(state,
> > > > > > -
> > > > > > params[next_index].port->mgr,
> > > > > > -
> > > > > > params[next_index].port,
> > > > > > -
> > > > > > vars[next_index].pbn) < 0)
> > > > > > -                                   return false;
> > > > > > +                           ret = drm_dp_atomic_find_time_slots(state,
> > > > > > +
> > > > > > params[next_index].port->mgr,
> > > > > > +
> > > > > > params[next_index].port,
> > > > > > +
> > > > > > vars[next_index].pbn);
> > > > > > +                           if (ret < 0)
> > > > > > +                                   return ret;
> > > > > >                     }
> > > > > >             } else {
> > > > > >                     vars[next_index].pbn += initial_slack[next_index];
> > > > > > -                   if (drm_dp_atomic_find_time_slots(state,
> > > > > > -
> > > > > > params[next_index].port->mgr,
> > > > > > -
> > > > > > params[next_index].port,
> > > > > > -
> > > > > > vars[next_index].pbn) < 0)
> > > > > > -                           return false;
> > > > > > -                   if (!drm_dp_mst_atomic_check(state)) {
> > > > > > +                   ret = drm_dp_atomic_find_time_slots(state,
> > > > > > +
> > > > > > params[next_index].port->mgr,
> > > > > > +
> > > > > > params[next_index].port,
> > > > > > +
> > > > > > vars[next_index].pbn);
> > > > > > +                   if (ret < 0)
> > > > > > +                           return ret;
> > > > > > +
> > > > > > +                   ret = drm_dp_mst_atomic_check(state);
> > > > > > +                   if (ret == 0) {
> > > > > >                             vars[next_index].bpp_x16 =
> > > > > > params[next_index].bw_range.max_target_bpp_x16;
> > > > > >                     } else {
> > > > > >                             vars[next_index].pbn -=
> > > > > > initial_slack[next_index];
> > > > > > -                           if (drm_dp_atomic_find_time_slots(state,
> > > > > > -
> > > > > > params[next_index].port->mgr,
> > > > > > -
> > > > > > params[next_index].port,
> > > > > > -
> > > > > > vars[next_index].pbn) < 0)
> > > > > > -                                   return false;
> > > > > > +                           ret = drm_dp_atomic_find_time_slots(state,
> > > > > > +
> > > > > > params[next_index].port->mgr,
> > > > > > +
> > > > > > params[next_index].port,
> > > > > > +
> > > > > > vars[next_index].pbn);
> > > > > > +                           if (ret < 0)
> > > > > > +                                   return ret;
> > > > > >                     }
> > > > > >             }
> > > > > >
> > > > > >             bpp_increased[next_index] = true;
> > > > > >             remaining_to_increase--;
> > > > > >     }
> > > > > > -   return true;
> > > > > > +   return 0;
> > > > > >  }
> > > > > >
> > > > > > -static bool try_disable_dsc(struct drm_atomic_state *state,
> > > > > > -                       struct dc_link *dc_link,
> > > > > > -                       struct dsc_mst_fairness_params *params,
> > > > > > -                       struct dsc_mst_fairness_vars *vars,
> > > > > > -                       int count,
> > > > > > -                       int k)
> > > > > > +static int try_disable_dsc(struct drm_atomic_state *state,
> > > > > > +                      struct dc_link *dc_link,
> > > > > > +                      struct dsc_mst_fairness_params *params,
> > > > > > +                      struct dsc_mst_fairness_vars *vars,
> > > > > > +                      int count,
> > > > > > +                      int k)
> > > > > >  {
> > > > > >     int i;
> > > > > >     bool tried[MAX_PIPES];
> > > > > > @@ -810,6 +819,7 @@ static bool try_disable_dsc(struct drm_atomic_state
> > > > > > *state,
> > > > > >     int max_kbps_increase;
> > > > > >     int next_index;
> > > > > >     int remaining_to_try = 0;
> > > > > > +   int ret;
> > > > > >
> > > > > >     for (i = 0; i < count; i++) {
> > > > > >             if (vars[i + k].dsc_enabled
> > > > > > @@ -840,49 +850,52 @@ static bool try_disable_dsc(struct
> > > > > > drm_atomic_state *state,
> > > > > >                     break;
> > > > > >
> > > > > >             vars[next_index].pbn =
> > > > > > kbps_to_peak_pbn(params[next_index].bw_range.stream_kbps);
> > > > > > -           if (drm_dp_atomic_find_time_slots(state,
> > > > > > -                                             params[next_index].port-
> > > > > > > mgr,
> > > > > > -                                             params[next_index].port,
> > > > > > -                                             vars[next_index].pbn) < 0)
> > > > > > -                   return false;
> > > > > > +           ret = drm_dp_atomic_find_time_slots(state,
> > > > > > +                                               params[next_index].port-
> > > > > > > mgr,
> > > > > > +                                               params[next_index].port,
> > > > > > +                                               vars[next_index].pbn);
> > > > > > +           if (ret < 0)
> > > > > > +                   return ret;
> > > > > >
> > > > > > -           if (!drm_dp_mst_atomic_check(state)) {
> > > > > > +           ret = drm_dp_mst_atomic_check(state);
> > > > > > +           if (ret == 0) {
> > > > > >                     vars[next_index].dsc_enabled = false;
> > > > > >                     vars[next_index].bpp_x16 = 0;
> > > > > >             } else {
> > > > > >                     vars[next_index].pbn =
> > > > > > kbps_to_peak_pbn(params[next_index].bw_range.max_kbps);
> > > > > > -                   if (drm_dp_atomic_find_time_slots(state,
> > > > > > -
> > > > > > params[next_index].port->mgr,
> > > > > > -
> > > > > > params[next_index].port,
> > > > > > -
> > > > > > vars[next_index].pbn) < 0)
> > > > > > -                           return false;
> > > > > > +                   ret = drm_dp_atomic_find_time_slots(state,
> > > > > > +
> > > > > > params[next_index].port->mgr,
> > > > > > +
> > > > > > params[next_index].port,
> > > > > > +
> > > > > > vars[next_index].pbn);
> > > > > > +                   if (ret < 0)
> > > > > > +                           return ret;
> > > > > >             }
> > > > > >
> > > > > >             tried[next_index] = true;
> > > > > >             remaining_to_try--;
> > > > > >     }
> > > > > > -   return true;
> > > > > > +   return 0;
> > > > > >  }
> > > > > >
> > > > > > -static bool compute_mst_dsc_configs_for_link(struct drm_atomic_state
> > > > > > *state,
> > > > > > -                                        struct dc_state *dc_state,
> > > > > > -                                        struct dc_link *dc_link,
> > > > > > -                                        struct dsc_mst_fairness_vars *vars,
> > > > > > -                                        struct drm_dp_mst_topology_mgr
> > > > > > *mgr,
> > > > > > -                                        int *link_vars_start_index)
> > > > > > +static int compute_mst_dsc_configs_for_link(struct drm_atomic_state
> > > > > > *state,
> > > > > > +                                       struct dc_state *dc_state,
> > > > > > +                                       struct dc_link *dc_link,
> > > > > > +                                       struct dsc_mst_fairness_vars *vars,
> > > > > > +                                       struct drm_dp_mst_topology_mgr
> > > > > > *mgr,
> > > > > > +                                       int *link_vars_start_index)
> > > > > >  {
> > > > > >     struct dc_stream_state *stream;
> > > > > >     struct dsc_mst_fairness_params params[MAX_PIPES];
> > > > > >     struct amdgpu_dm_connector *aconnector;
> > > > > >     struct drm_dp_mst_topology_state *mst_state =
> > > > > > drm_atomic_get_mst_topology_state(state, mgr);
> > > > > >     int count = 0;
> > > > > > -   int i, k;
> > > > > > +   int i, k, ret;
> > > > > >     bool debugfs_overwrite = false;
> > > > > >
> > > > > >     memset(params, 0, sizeof(params));
> > > > > >
> > > > > >     if (IS_ERR(mst_state))
> > > > > > -           return false;
> > > > > > +           return PTR_ERR(mst_state);
> > > > > >
> > > > > >     mst_state->pbn_div = dm_mst_get_pbn_divider(dc_link);  #if
> > > > > > defined(CONFIG_DRM_AMD_DC_DCN) @@ -933,7 +946,7 @@ static bool
> > > > > > compute_mst_dsc_configs_for_link(struct drm_atomic_state *state,
> > > > > >
> > > > > >     if (count == 0) {
> > > > > >             ASSERT(0);
> > > > > > -           return true;
> > > > > > +           return 0;
> > > > > >     }
> > > > > >
> > > > > >     /* k is start index of vars for current phy link used by mst hub */ @@
> > > > > > -947,13 +960,17 @@ static bool compute_mst_dsc_configs_for_link(struct
> > > > > > drm_atomic_state *state,
> > > > > >             vars[i + k].pbn =
> > > > > > kbps_to_peak_pbn(params[i].bw_range.stream_kbps);
> > > > > >             vars[i + k].dsc_enabled = false;
> > > > > >             vars[i + k].bpp_x16 = 0;
> > > > > > -           if (drm_dp_atomic_find_time_slots(state, params[i].port-
> > > > > > > mgr, params[i].port,
> > > > > > -                                             vars[i + k].pbn) < 0)
> > > > > > -                   return false;
> > > > > > +           ret = drm_dp_atomic_find_time_slots(state, params[i].port-
> > > > > > > mgr, params[i].port,
> > > > > > +                                               vars[i + k].pbn);
> > > > > > +           if (ret < 0)
> > > > > > +                   return ret;
> > > > > >     }
> > > > > > -   if (!drm_dp_mst_atomic_check(state) && !debugfs_overwrite) {
> > > > > > +   ret = drm_dp_mst_atomic_check(state);
> > > > > > +   if (ret == 0 && !debugfs_overwrite) {
> > > > > >             set_dsc_configs_from_fairness_vars(params, vars, count, k);
> > > > > > -           return true;
> > > > > > +           return 0;
> > > > > > +   } else if (ret != -ENOSPC) {
> > > > > > +           return ret;
> > > > > >     }
> > > > > >
> > > > > >     /* Try max compression */
> > > > > > @@ -962,31 +979,36 @@ static bool
> > > > > > compute_mst_dsc_configs_for_link(struct drm_atomic_state *state,
> > > > > >                     vars[i + k].pbn =
> > > > > > kbps_to_peak_pbn(params[i].bw_range.min_kbps);
> > > > > >                     vars[i + k].dsc_enabled = true;
> > > > > >                     vars[i + k].bpp_x16 =
> > > > > > params[i].bw_range.min_target_bpp_x16;
> > > > > > -                   if (drm_dp_atomic_find_time_slots(state,
> > > > > > params[i].port->mgr,
> > > > > > -                                                     params[i].port, vars[i
> > > > > > + k].pbn) < 0)
> > > > > > -                           return false;
> > > > > > +                   ret = drm_dp_atomic_find_time_slots(state,
> > > > > > params[i].port->mgr,
> > > > > > +                                                       params[i].port,
> > > > > > vars[i + k].pbn);
> > > > > > +                   if (ret < 0)
> > > > > > +                           return ret;
> > > > > >             } else {
> > > > > >                     vars[i + k].pbn =
> > > > > > kbps_to_peak_pbn(params[i].bw_range.stream_kbps);
> > > > > >                     vars[i + k].dsc_enabled = false;
> > > > > >                     vars[i + k].bpp_x16 = 0;
> > > > > > -                   if (drm_dp_atomic_find_time_slots(state,
> > > > > > params[i].port->mgr,
> > > > > > -                                                     params[i].port, vars[i
> > > > > > + k].pbn) < 0)
> > > > > > -                           return false;
> > > > > > +                   ret = drm_dp_atomic_find_time_slots(state,
> > > > > > params[i].port->mgr,
> > > > > > +                                                       params[i].port,
> > > > > > vars[i + k].pbn);
> > > > > > +                   if (ret < 0)
> > > > > > +                           return ret;
> > > > > >             }
> > > > > >     }
> > > > > > -   if (drm_dp_mst_atomic_check(state))
> > > > > > -           return false;
> > > > > > +   ret = drm_dp_mst_atomic_check(state);
> > > > > > +   if (ret != 0)
> > > > > > +           return ret;
> > > > > >
> > > > > >     /* Optimize degree of compression */
> > > > > > -   if (!increase_dsc_bpp(state, mst_state, dc_link, params, vars, count,
> > > > > > k))
> > > > > > -           return false;
> > > > > > +   ret = increase_dsc_bpp(state, mst_state, dc_link, params, vars,
> > > > > > count, k);
> > > > > > +   if (ret < 0)
> > > > > > +           return ret;
> > > > > >
> > > > > > -   if (!try_disable_dsc(state, dc_link, params, vars, count, k))
> > > > > > -           return false;
> > > > > > +   ret = try_disable_dsc(state, dc_link, params, vars, count, k);
> > > > > > +   if (ret < 0)
> > > > > > +           return ret;
> > > > > >
> > > > > >     set_dsc_configs_from_fairness_vars(params, vars, count, k);
> > > > > >
> > > > > > -   return true;
> > > > > > +   return 0;
> > > > > >  }
> > > > > >
> > > > > >  static bool is_dsc_need_re_compute(
> > > > > > @@ -1087,15 +1109,16 @@ static bool is_dsc_need_re_compute(
> > > > > >     return is_dsc_need_re_compute;
> > > > > >  }
> > > > > >
> > > > > > -bool compute_mst_dsc_configs_for_state(struct drm_atomic_state *state,
> > > > > > -                                  struct dc_state *dc_state,
> > > > > > -                                  struct dsc_mst_fairness_vars *vars)
> > > > > > +int compute_mst_dsc_configs_for_state(struct drm_atomic_state *state,
> > > > > > +                                 struct dc_state *dc_state,
> > > > > > +                                 struct dsc_mst_fairness_vars *vars)
> > > > > >  {
> > > > > >     int i, j;
> > > > > >     struct dc_stream_state *stream;
> > > > > >     bool computed_streams[MAX_PIPES];
> > > > > >     struct amdgpu_dm_connector *aconnector;
> > > > > >     int link_vars_start_index = 0;
> > > > > > +   int ret = 0;
> > > > > >
> > > > > >     for (i = 0; i < dc_state->stream_count; i++)
> > > > > >             computed_streams[i] = false;
> > > > > > @@ -1118,17 +1141,19 @@ bool compute_mst_dsc_configs_for_state(struct
> > > > > > drm_atomic_state *state,
> > > > > >                     continue;
> > > > > >
> > > > > >             if (dcn20_remove_stream_from_ctx(stream->ctx->dc,
> > > > > > dc_state, stream) != DC_OK)
> > > > > > -                   return false;
> > > > > > +                   return -EINVAL;
> > > > > >
> > > > > >             if (!is_dsc_need_re_compute(state, dc_state, stream->link))
> > > > > >                     continue;
> > > > > >
> > > > > >             mutex_lock(&aconnector->mst_mgr.lock);
> > > > > > -           if (!compute_mst_dsc_configs_for_link(state, dc_state,
> > > > > > stream->link, vars,
> > > > > > -                                                 &aconnector->mst_mgr,
> > > > > > -                                                 &link_vars_start_index)) {
> > > > > > +
> > > > > > +           ret = compute_mst_dsc_configs_for_link(state, dc_state,
> > > > > > stream->link, vars,
> > > > > > +                                                  &aconnector->mst_mgr,
> > > > > > +                                                  &link_vars_start_index);
> > > > > > +           if (ret != 0) {
> > > > > >                     mutex_unlock(&aconnector->mst_mgr.lock);
> > > > > > -                   return false;
> > > > > > +                   return ret;
> > > > > >             }
> > > > > >             mutex_unlock(&aconnector->mst_mgr.lock);
> > > > > >
> > > > > > @@ -1143,22 +1168,22 @@ bool compute_mst_dsc_configs_for_state(struct
> > > > > > drm_atomic_state *state,
> > > > > >
> > > > > >             if (stream->timing.flags.DSC == 1)
> > > > > >                     if (dc_stream_add_dsc_to_resource(stream->ctx-
> > > > > > > dc, dc_state, stream) != DC_OK)
> > > > > > -                           return false;
> > > > > > +                           return -EINVAL;
> > > > > >     }
> > > > > >
> > > > > > -   return true;
> > > > > > +   return ret;
> > > > > >  }
> > > > > >
> > > > > > -static bool
> > > > > > -   pre_compute_mst_dsc_configs_for_state(struct drm_atomic_state
> > > > > > *state,
> > > > > > -                                         struct dc_state *dc_state,
> > > > > > -                                         struct dsc_mst_fairness_vars
> > > > > > *vars)
> > > > > > +static int pre_compute_mst_dsc_configs_for_state(struct
> > > > > > drm_atomic_state *state,
> > > > > > +                                            struct dc_state *dc_state,
> > > > > > +                                            struct dsc_mst_fairness_vars
> > > > > > *vars)
> > > > > >  {
> > > > > >     int i, j;
> > > > > >     struct dc_stream_state *stream;
> > > > > >     bool computed_streams[MAX_PIPES];
> > > > > >     struct amdgpu_dm_connector *aconnector;
> > > > > >     int link_vars_start_index = 0;
> > > > > > +   int ret;
> > > > > >
> > > > > >     for (i = 0; i < dc_state->stream_count; i++)
> > > > > >             computed_streams[i] = false;
> > > > > > @@ -1184,11 +1209,12 @@ static bool
> > > > > >                     continue;
> > > > > >
> > > > > >             mutex_lock(&aconnector->mst_mgr.lock);
> > > > > > -           if (!compute_mst_dsc_configs_for_link(state, dc_state,
> > > > > > stream->link, vars,
> > > > > > -                                                 &aconnector->mst_mgr,
> > > > > > -                                                 &link_vars_start_index)) {
> > > > > > +           ret = compute_mst_dsc_configs_for_link(state, dc_state,
> > > > > > stream->link, vars,
> > > > > > +                                                  &aconnector->mst_mgr,
> > > > > > +                                                  &link_vars_start_index);
> > > > > > +           if (ret != 0) {
> > > > > >                     mutex_unlock(&aconnector->mst_mgr.lock);
> > > > > > -                   return false;
> > > > > > +                   return ret;
> > > > > >             }
> > > > > >             mutex_unlock(&aconnector->mst_mgr.lock);
> > > > > >
> > > > > > @@ -1198,7 +1224,7 @@ static bool
> > > > > >             }
> > > > > >     }
> > > > > >
> > > > > > -   return true;
> > > > > > +   return ret;
> > > > > >  }
> > > > > >
> > > > > >  static int find_crtc_index_in_state_by_stream(struct drm_atomic_state
> > > > > > *state, @@ -1253,9 +1279,9 @@ static bool
> > > > > > is_dsc_precompute_needed(struct drm_atomic_state *state)
> > > > > >     return ret;
> > > > > >  }
> > > > > >
> > > > > > -bool pre_validate_dsc(struct drm_atomic_state *state,
> > > > > > -                 struct dm_atomic_state **dm_state_ptr,
> > > > > > -                 struct dsc_mst_fairness_vars *vars)
> > > > > > +int pre_validate_dsc(struct drm_atomic_state *state,
> > > > > > +                struct dm_atomic_state **dm_state_ptr,
> > > > > > +                struct dsc_mst_fairness_vars *vars)
> > > > > >  {
> > > > > >     int i;
> > > > > >     struct dm_atomic_state *dm_state;
> > > > > > @@ -1264,11 +1290,12 @@ bool pre_validate_dsc(struct drm_atomic_state
> > > > > > *state,
> > > > > >
> > > > > >     if (!is_dsc_precompute_needed(state)) {
> > > > > >             DRM_INFO_ONCE("DSC precompute is not needed.\n");
> > > > > > -           return true;
> > > > > > +           return 0;
> > > > > >     }
> > > > > > -   if (dm_atomic_get_state(state, dm_state_ptr)) {
> > > > > > +   ret = dm_atomic_get_state(state, dm_state_ptr);
> > > > > > +   if (ret != 0) {
> > > > > >             DRM_INFO_ONCE("dm_atomic_get_state() failed\n");
> > > > > > -           return false;
> > > > > > +           return ret;
> > > > > >     }
> > > > > >     dm_state = *dm_state_ptr;
> > > > > >
> > > > > > @@ -1280,7 +1307,7 @@ bool pre_validate_dsc(struct drm_atomic_state
> > > > > > *state,
> > > > > >
> > > > > >     local_dc_state = kmemdup(dm_state->context, sizeof(struct
> > > > > > dc_state), GFP_KERNEL);
> > > > > >     if (!local_dc_state)
> > > > > > -           return false;
> > > > > > +           return -ENOMEM;
> > > > > >
> > > > > >     for (i = 0; i < local_dc_state->stream_count; i++) {
> > > > > >             struct dc_stream_state *stream = dm_state->context-
> > > > > > > streams[i]; @@ -1316,9 +1343,9 @@ bool pre_validate_dsc(struct
> > > > > > drm_atomic_state *state,
> > > > > >     if (ret != 0)
> > > > > >             goto clean_exit;
> > > > > >
> > > > > > -   if (!pre_compute_mst_dsc_configs_for_state(state, local_dc_state,
> > > > > > vars)) {
> > > > > > +   ret = pre_compute_mst_dsc_configs_for_state(state, local_dc_state,
> > > > > > vars);
> > > > > > +   if (ret != 0) {
> > > > > >
> > > > > >     DRM_INFO_ONCE("pre_compute_mst_dsc_configs_for_state()
> > > > > > failed\n");
> > > > > > -           ret = -EINVAL;
> > > > > >             goto clean_exit;
> > > > > >     }
> > > > > >
> > > > > > @@ -1349,7 +1376,7 @@ bool pre_validate_dsc(struct drm_atomic_state
> > > > > > *state,
> > > > > >
> > > > > >     kfree(local_dc_state);
> > > > > >
> > > > > > -   return (ret == 0);
> > > > > > +   return ret;
> > > > > >  }
> > > > > >
> > > > > >  static unsigned int kbps_from_pbn(unsigned int pbn) diff --git
> > > > > > a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_mst_types.h
> > > > > > b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_mst_types.h
> > > > > > index b92a7c5671aa2..97fd70df531bf 100644
> > > > > > --- a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_mst_types.h
> > > > > > +++
> > > > > > b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_mst_types.h
> > > > > > @@ -53,15 +53,15 @@ struct dsc_mst_fairness_vars {
> > > > > >     struct amdgpu_dm_connector *aconnector;  };
> > > > > >
> > > > > > -bool compute_mst_dsc_configs_for_state(struct drm_atomic_state *state,
> > > > > > -                                  struct dc_state *dc_state,
> > > > > > -                                  struct dsc_mst_fairness_vars *vars);
> > > > > > +int compute_mst_dsc_configs_for_state(struct drm_atomic_state *state,
> > > > > > +                                 struct dc_state *dc_state,
> > > > > > +                                 struct dsc_mst_fairness_vars *vars);
> > > > > >
> > > > > >  bool needs_dsc_aux_workaround(struct dc_link *link);
> > > > > >
> > > > > > -bool pre_validate_dsc(struct drm_atomic_state *state,
> > > > > > -                 struct dm_atomic_state **dm_state_ptr,
> > > > > > -                 struct dsc_mst_fairness_vars *vars);
> > > > > > +int pre_validate_dsc(struct drm_atomic_state *state,
> > > > > > +                struct dm_atomic_state **dm_state_ptr,
> > > > > > +                struct dsc_mst_fairness_vars *vars);
> > > > > >
> > > > > >  enum dc_status dm_dp_mst_is_port_support_mode(
> > > > > >     struct amdgpu_dm_connector *aconnector,
> > > > > > --
> > > > > > 2.37.3
> > > > >
> > > >
> > > > --
> > > > Cheers,
> > > >  Lyude Paul (she/her)
> > > >  Software Engineer at Red Hat
> > > >
> > >
> >
>
> --
> Cheers,
>  Lyude Paul (she/her)
>  Software Engineer at Red Hat
>
