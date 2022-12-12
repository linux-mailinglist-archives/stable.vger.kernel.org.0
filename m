Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1C4CC649979
	for <lists+stable@lfdr.de>; Mon, 12 Dec 2022 08:21:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231536AbiLLHVv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Dec 2022 02:21:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56474 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230079AbiLLHVq (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 12 Dec 2022 02:21:46 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B94C2B1C3
        for <stable@vger.kernel.org>; Sun, 11 Dec 2022 23:21:45 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 767C1B80B84
        for <stable@vger.kernel.org>; Mon, 12 Dec 2022 07:21:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DA1A8C433F0;
        Mon, 12 Dec 2022 07:21:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1670829703;
        bh=XuCn6jetfBmv/m/dP7n5H6v4s3EIbgBoN0+ddPz0vpw=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=yQSBKUPP40+eO74OegCdwxeHW2oc1f00FS08t0gYnZIgeo2h/ouqeXXITu99F+5f9
         8ZhdOrESv5qkx1ItnQ9TI6j1net1XACAmeSTMENUxOBT2kNxdP7Pz/cNu8/SaHmHH0
         /fM69Sf4LetHIUC3LV6cHzlicF2s/4SGknO7ux3I=
Date:   Mon, 12 Dec 2022 08:21:40 +0100
From:   "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>
To:     "Limonciello, Mario" <Mario.Limonciello@amd.com>
Cc:     "stable@vger.kernel.org" <stable@vger.kernel.org>,
        "Dong, Ruijing" <Ruijing.Dong@amd.com>,
        "Liu, Leo" <Leo.Liu@amd.com>,
        "Deucher, Alexander" <Alexander.Deucher@amd.com>
Subject: Re: [PATCH 1/1] drm/amdgpu/vcn: update vcn4 fw shared data structure
Message-ID: <Y5bWhPvCG9XkTvp9@kroah.com>
References: <20221201225417.12452-1-mario.limonciello@amd.com>
 <20221201225417.12452-2-mario.limonciello@amd.com>
 <MN0PR12MB6101E8DA6281B2B40ECCE705E21E9@MN0PR12MB6101.namprd12.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <MN0PR12MB6101E8DA6281B2B40ECCE705E21E9@MN0PR12MB6101.namprd12.prod.outlook.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sun, Dec 11, 2022 at 05:55:47PM +0000, Limonciello, Mario wrote:
> [Public]
> 
> > -----Original Message-----
> > From: Limonciello, Mario <Mario.Limonciello@amd.com>
> > Sent: Thursday, December 1, 2022 16:54
> > To: stable@vger.kernel.org
> > Cc: Dong, Ruijing <Ruijing.Dong@amd.com>; Liu, Leo <Leo.Liu@amd.com>;
> > Deucher, Alexander <Alexander.Deucher@amd.com>; Limonciello, Mario
> > <Mario.Limonciello@amd.com>
> > Subject: [PATCH 1/1] drm/amdgpu/vcn: update vcn4 fw shared data
> > structure
> > 
> > From: Ruijing Dong <ruijing.dong@amd.com>
> > 
> > update VF_RB_SETUP_FLAG, add SMU_DPM_INTERFACE_FLAG,
> > and corresponding change in VCN4.
> > 
> > Reviewed-by: Leo Liu <leo.liu@amd.com>
> > Signed-off-by: Ruijing Dong <ruijing.dong@amd.com>
> > Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
> > (cherry picked from commit 167be8522821fd38636410103e1c154b589cb1d9)
> > Hand modified large dependency of commit aa44beb5f0155
> > ("drm/amdgpu/vcn: Add sriov VCN v4_0 unified queue support")
> > This no longer updates VF_RB_SETUP_FLAG, but just adds
> > SMU_DPM_INTERFACE_FLAG.
> > Signed-off-by: Mario Limonciello <mario.limonciello@amd.com>
> > ---
> >  drivers/gpu/drm/amd/amdgpu/amdgpu_vcn.h | 7 +++++++
> >  drivers/gpu/drm/amd/amdgpu/vcn_v4_0.c   | 4 ++++
> >  2 files changed, 11 insertions(+)
> > 
> > diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_vcn.h
> > b/drivers/gpu/drm/amd/amdgpu/amdgpu_vcn.h
> > index 60c608144480..ecb8db731081 100644
> > --- a/drivers/gpu/drm/amd/amdgpu/amdgpu_vcn.h
> > +++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_vcn.h
> > @@ -161,6 +161,7 @@
> >  #define AMDGPU_VCN_SW_RING_FLAG		(1 << 9)
> >  #define AMDGPU_VCN_FW_LOGGING_FLAG	(1 << 10)
> >  #define AMDGPU_VCN_SMU_VERSION_INFO_FLAG (1 << 11)
> > +#define AMDGPU_VCN_SMU_DPM_INTERFACE_FLAG (1 << 11)
> > 
> >  #define AMDGPU_VCN_IB_FLAG_DECODE_BUFFER	0x00000001
> >  #define AMDGPU_VCN_CMD_FLAG_MSG_BUFFER		0x00000001
> > @@ -170,6 +171,9 @@
> >  #define VCN_CODEC_DISABLE_MASK_HEVC (1 << 2)
> >  #define VCN_CODEC_DISABLE_MASK_H264 (1 << 3)
> > 
> > +#define AMDGPU_VCN_SMU_DPM_INTERFACE_DGPU (0)
> > +#define AMDGPU_VCN_SMU_DPM_INTERFACE_APU (1)
> > +
> >  enum fw_queue_mode {
> >  	FW_QUEUE_RING_RESET = 1,
> >  	FW_QUEUE_DPG_HOLD_OFF = 2,
> > @@ -323,6 +327,9 @@ struct amdgpu_vcn4_fw_shared {
> >  	struct amdgpu_fw_shared_unified_queue_struct sq;
> >  	uint8_t pad1[8];
> >  	struct amdgpu_fw_shared_fw_logging fw_log;
> > +	uint8_t pad2[20];
> > +	uint32_t pad3[13];
> > +	struct amdgpu_fw_shared_smu_interface_info
> > smu_dpm_interface;
> >  };
> > 
> >  struct amdgpu_vcn_fwlog {
> > diff --git a/drivers/gpu/drm/amd/amdgpu/vcn_v4_0.c
> > b/drivers/gpu/drm/amd/amdgpu/vcn_v4_0.c
> > index fb2d74f30448..c5afb5bc9eb6 100644
> > --- a/drivers/gpu/drm/amd/amdgpu/vcn_v4_0.c
> > +++ b/drivers/gpu/drm/amd/amdgpu/vcn_v4_0.c
> > @@ -132,6 +132,10 @@ static int vcn_v4_0_sw_init(void *handle)
> >  		fw_shared->present_flag_0 =
> > cpu_to_le32(AMDGPU_FW_SHARED_FLAG_0_UNIFIED_QUEUE);
> >  		fw_shared->sq.is_enabled = 1;
> > 
> > +		fw_shared->present_flag_0 |=
> > cpu_to_le32(AMDGPU_VCN_SMU_DPM_INTERFACE_FLAG);
> > +		fw_shared->smu_dpm_interface.smu_interface_type =
> > (adev->flags & AMD_IS_APU) ?
> > +			AMDGPU_VCN_SMU_DPM_INTERFACE_APU :
> > AMDGPU_VCN_SMU_DPM_INTERFACE_DGPU;
> > +
> >  		if (amdgpu_vcnfw_log)
> >  			amdgpu_vcn_fwlog_init(&adev->vcn.inst[i]);
> >  	}
> > --
> > 2.34.1
> 
> Hi Greg,
> 
> I didn't see this one get picked up I sent back a week and half ago, did you miss it or did it
> need more discussion?
> 
> The cover letter [1] for it indicated all the background for why it's important and intended
> kernel (6.0.y).
> 
> [1] https://lore.kernel.org/stable/20221201225417.12452-1-mario.limonciello@amd.com/

Sorry, yes, I missed this, next time maybe put:
	[PATCH 0/1 6.0]
in the subject line, I thought this was just yet-another drm patch
getting cc:ed to the stable list...

thanks,

greg k-h
