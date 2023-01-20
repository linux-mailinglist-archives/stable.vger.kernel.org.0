Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A7825676155
	for <lists+stable@lfdr.de>; Sat, 21 Jan 2023 00:15:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230047AbjATXP4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 20 Jan 2023 18:15:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52124 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230154AbjATXPy (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 20 Jan 2023 18:15:54 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5320C43925
        for <stable@vger.kernel.org>; Fri, 20 Jan 2023 15:15:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1674256505;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=XoknDUURrHLa74EzxLJ8GYuKHj7PHhY7S/GVYWdBSwk=;
        b=EwRdcSrnTNRQraJwNwT3RZHTtBGvrYhgC/C1SFawqk9PAJC89oZnivFuSxD/2NZMpmh1fH
        UTPceuWo3R86hkoWpevIiptmu59zNVF01oQkvtqI2B0om+HyZUC7Mqph8fcpz6JCbay+c9
        2HXLy8QmG6uiDUBdYsPY4ibnTH2YBuI=
Received: from mail-qv1-f72.google.com (mail-qv1-f72.google.com
 [209.85.219.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-255-u2zeqzsVOJ2e5Tm0M2c6Pw-1; Fri, 20 Jan 2023 18:15:04 -0500
X-MC-Unique: u2zeqzsVOJ2e5Tm0M2c6Pw-1
Received: by mail-qv1-f72.google.com with SMTP id kr11-20020a0562142b8b00b005355b472a65so2442777qvb.7
        for <stable@vger.kernel.org>; Fri, 20 Jan 2023 15:15:04 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=mime-version:user-agent:content-transfer-encoding:organization
         :references:in-reply-to:date:cc:to:from:subject:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=XoknDUURrHLa74EzxLJ8GYuKHj7PHhY7S/GVYWdBSwk=;
        b=XYqSt1bx2AAb6G5fno4xrKG88+9HMTuX176qu8O15u2JHr/IQbbBBYehpA+RTcqg9B
         xaBVUvpMMamhMFpEOjPZMfq7e3Tbzvp9f0GYAmZcPO82YBZju9aP5NWEbn3eUtOvDST0
         x7OzfypHTs4efgU4+3/kBmfgf3I9ByKhhiADBpl5hcTUnsmcuNTWNajp2xPjldqWEXXp
         za3pSrT6q6zpNZ740ZT9uXsxbrxLATZ64BV598zPxQz4ciyzfTD8skFoNM0OKdwSkxhl
         1t0jFR5vROg5JcUeqc157NG+9VqAqEQ3Lgt3E1fhtUHBCfIh3mrKC4NBr9uvBtzU807S
         Xsxw==
X-Gm-Message-State: AFqh2koiKf7AtsQoEusy79uVZ/563FLlxJRXSDd3ZUORPe4DjrZePY6t
        drPUZbWDQhu1Rc8d8KdRSwGC23wFBLt15arp0Slcq4Q04bogGwybzflZ3Nv3aiw5g1lr0987QM6
        MzELnp03ML/Jxri61
X-Received: by 2002:ac8:4a9a:0:b0:3a7:e727:a015 with SMTP id l26-20020ac84a9a000000b003a7e727a015mr23249543qtq.20.1674256503675;
        Fri, 20 Jan 2023 15:15:03 -0800 (PST)
X-Google-Smtp-Source: AMrXdXuZ3OPhHyBXwLeLq03lJ8ap+cBCoJRfLsiSu+d4wxp73Gisjo99Hu0iq4zK0iczrQyF7CosDA==
X-Received: by 2002:ac8:4a9a:0:b0:3a7:e727:a015 with SMTP id l26-20020ac84a9a000000b003a7e727a015mr23249517qtq.20.1674256503430;
        Fri, 20 Jan 2023 15:15:03 -0800 (PST)
Received: from ?IPv6:2607:fb91:2d97:94eb:ed0e:2784:4519:138f? ([2607:fb91:2d97:94eb:ed0e:2784:4519:138f])
        by smtp.gmail.com with ESMTPSA id c4-20020a05620a268400b006fefa5f7fcesm22371923qkp.10.2023.01.20.15.15.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 20 Jan 2023 15:15:02 -0800 (PST)
Message-ID: <965500917008cd17b47c1be1f5eeda7ccc4eede6.camel@redhat.com>
Subject: Re: [PATCH 0/7] Fix MST on amdgpu
From:   Lyude Paul <lyude@redhat.com>
To:     Harry Wentland <harry.wentland@amd.com>,
        amd-gfx@lists.freedesktop.org, dri-devel@lists.freedesktop.org
Cc:     ville.syrjala@linux.intel.com, stanislav.lisovskiy@intel.com,
        bskeggs@redhat.com, jerry.zuo@amd.com, mario.limonciello@amd.com,
        stable@vger.kernel.org, Wayne.Lin@amd.com
Date:   Fri, 20 Jan 2023 18:15:00 -0500
In-Reply-To: <20230119235200.441386-1-harry.wentland@amd.com>
References: <20230119235200.441386-1-harry.wentland@amd.com>
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

So glad to have this fixed finally =E2=99=A5

On Thu, 2023-01-19 at 18:51 -0500, Harry Wentland wrote:
> MST has been broken on amdgpu after a refactor in drm_dp_mst
> code that was aligning drm_dp_mst more closely with the atomic
> model.
>=20
> The gitlab issue: https://gitlab.freedesktop.org/drm/amd/-/issues/2171
>=20
> This series fixes it.
>=20
> It can be found at
> https://gitlab.freedesktop.org/hwentland/linux/-/tree/mst_regression
>=20
> A stable-6.1.y rebase can be found at
> https://gitlab.freedesktop.org/hwentland/linux/-/tree/mst_regression_6.1
>=20
> Lyude Paul (1):
>   drm/amdgpu/display/mst: Fix mst_state->pbn_div and slot count
>     assignments
>=20
> Wayne Lin (6):
>   drm/amdgpu/display/mst: limit payload to be updated one by one
>   drm/amdgpu/display/mst: update mst_mgr relevant variable when long HPD
>   drm/drm_print: correct format problem
>   drm/display/dp_mst: Correct the kref of port.
>   drm/amdgpu/display/mst: adjust the naming of mst_port and port of
>     aconnector
>   drm/amdgpu/display/mst: adjust the logic in 2nd phase of updating
>     payload
>=20
>  drivers/gpu/drm/amd/amdgpu/amdgpu_mode.h      |  4 +-
>  .../gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c | 48 +++++++++---
>  .../gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.h |  4 +-
>  .../drm/amd/display/amdgpu_dm/amdgpu_dm_crc.c |  2 +-
>  .../amd/display/amdgpu_dm/amdgpu_dm_debugfs.c | 16 ++--
>  .../amd/display/amdgpu_dm/amdgpu_dm_helpers.c | 76 +++++++++++++------
>  .../display/amdgpu_dm/amdgpu_dm_mst_types.c   | 53 ++++++-------
>  drivers/gpu/drm/amd/display/dc/core/dc_link.c | 14 +++-
>  drivers/gpu/drm/display/drm_dp_mst_topology.c |  4 +-
>  include/drm/drm_print.h                       |  2 +-
>  10 files changed, 143 insertions(+), 80 deletions(-)
>=20
> --
> 2.39.0
>=20

--=20
Cheers,
 Lyude Paul (she/her)
 Software Engineer at Red Hat

