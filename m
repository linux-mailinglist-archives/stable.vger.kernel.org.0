Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 766AB6764F5
	for <lists+stable@lfdr.de>; Sat, 21 Jan 2023 08:28:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229518AbjAUH21 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 21 Jan 2023 02:28:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49456 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229637AbjAUH20 (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 21 Jan 2023 02:28:26 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6521C70294
        for <stable@vger.kernel.org>; Fri, 20 Jan 2023 23:28:21 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7F3E760ACA
        for <stable@vger.kernel.org>; Sat, 21 Jan 2023 07:28:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 89570C433EF;
        Sat, 21 Jan 2023 07:28:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1674286099;
        bh=uelgkkZaVqe9jys5JEJEwc7kCy9WMXkTngwZlLUTO98=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=RZj7zOmZx4ZeiLs0jZLeZMGauIj7LrvvUlujVoVmB4FMVRDd25R1M1Uh8ou4k2dnS
         e/F9G58buKo8i24ohcNp2za464IXZhUdMUrO9k53bZwFJ0cCMU6u+y17J6QHzRQfPj
         NZKcSJLBmGvT3Dt1yKoE1eUHe9S/prcVM2cIKnvk=
Date:   Sat, 21 Jan 2023 08:28:17 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Tim Huang <tim.huang@amd.com>
Cc:     amd-gfx@lists.freedesktop.org, stable@vger.kernel.org,
        Alexander.Deucher@amd.com, Yifan1.zhang@amd.com,
        Xiaojian.Du@amd.com, li.ma@amd.com, mario.limonciello@amd.com
Subject: Re: [PATCH RESEND] drm/amdgpu: skip psp suspend for IMU enabled
 ASICs mode2 reset
Message-ID: <Y8uUEUwXCq0yztbq@kroah.com>
References: <20230121021216.1596133-1-tim.huang@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230121021216.1596133-1-tim.huang@amd.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sat, Jan 21, 2023 at 10:12:16AM +0800, Tim Huang wrote:
> The psp suspend & resume should be skipped to avoid destroy
> the TMR and reload FWs again for IMU enabled APU ASICs.
> 
> Signed-off-by: Tim Huang <tim.huang@amd.com>
> Acked-by: Alex Deucher <alexander.deucher@amd.com>
> Reviewed-by: Mario Limonciello <mario.limonciello@amd.com>
> ---
>  drivers/gpu/drm/amd/amdgpu/amdgpu_device.c | 12 ++++++++++++
>  1 file changed, 12 insertions(+)
> 

<formletter>

This is not the correct way to submit patches for inclusion in the
stable kernel tree.  Please read:
    https://www.kernel.org/doc/html/latest/process/stable-kernel-rules.html
for how to do this properly.

</formletter>
