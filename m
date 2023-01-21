Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9D7F86764E7
	for <lists+stable@lfdr.de>; Sat, 21 Jan 2023 08:20:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229568AbjAUHUe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 21 Jan 2023 02:20:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47044 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229544AbjAUHUd (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 21 Jan 2023 02:20:33 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D3E8A6E0FE
        for <stable@vger.kernel.org>; Fri, 20 Jan 2023 23:20:32 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1339C6023E
        for <stable@vger.kernel.org>; Sat, 21 Jan 2023 07:20:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 10DDCC433D2;
        Sat, 21 Jan 2023 07:20:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1674285631;
        bh=PnVSxXkaLYKWQfgTwGiRvhv/631TKMtH6r7V3MnhUjE=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=CGVVHl+901mj841DkQ2+w2VR97373sUHMkCDOghEHcOWA1pfL1RGPRwRzyaDjBZa6
         4rXUkYyPUp6Z2xu2LfLZ3jbO1vDGYF9xbykdYjnEYn2d/LOvYSQYXiraqdQoBmY2Or
         BSSvubc/g2KSCM9x8I36Wk6ssk+5iOM1GQDmzAVo=
Date:   Sat, 21 Jan 2023 08:20:28 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Tim Huang <tim.huang@amd.com>
Cc:     amd-gfx@lists.freedesktop.org, stable@vger.kernel.org,
        Alexander.Deucher@amd.com, Yifan1.zhang@amd.com,
        Xiaojian.Du@amd.com, li.ma@amd.com, mario.limonciello@amd.com
Subject: Re: [PATCH v2] drm/amd/pm: drop unneeded dpm features disablement
 for SMU 13.0.4/11
Message-ID: <Y8uSPP34u39uPvvp@kroah.com>
References: <20230121024955.1601467-1-tim.huang@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230121024955.1601467-1-tim.huang@amd.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sat, Jan 21, 2023 at 10:49:55AM +0800, Tim Huang wrote:
> PMFW will handle that properly for gpu reset case. Driver involvement
> may cause some unexpected issues.
> 
> Signed-off-by: Tim Huang <tim.huang@amd.com>
> ---
>  drivers/gpu/drm/amd/pm/swsmu/amdgpu_smu.c | 14 ++++++++++++++
>  1 file changed, 14 insertions(+)
> 

<formletter>

This is not the correct way to submit patches for inclusion in the
stable kernel tree.  Please read:
    https://www.kernel.org/doc/html/latest/process/stable-kernel-rules.html
for how to do this properly.

</formletter>
