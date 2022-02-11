Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 07FAB4B21A7
	for <lists+stable@lfdr.de>; Fri, 11 Feb 2022 10:22:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244598AbiBKJWu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 11 Feb 2022 04:22:50 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:36426 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234323AbiBKJWu (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 11 Feb 2022 04:22:50 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B79F5B2D
        for <stable@vger.kernel.org>; Fri, 11 Feb 2022 01:22:49 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 56D1161EBB
        for <stable@vger.kernel.org>; Fri, 11 Feb 2022 09:22:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 057A2C340E9;
        Fri, 11 Feb 2022 09:22:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1644571368;
        bh=4JY8k3mu5Slip+PnSdQ/X5pwdPrc5woMD/PCaEaRGmI=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=0tnJvRrPHTp1n+94dgVvIxo+cH47mViUZSN2V0YfyjVrAAScxb4oPst79wc58z2oP
         ySnAGOjye87+g6BY0UUN6VRTKHpB07OeITb4wZlAxHIgIeC6T7MkHoqH25xUnD4LhC
         l3yugQXfPETUisWLabJrqaBajNIuLvR6yDJfrerU=
Date:   Fri, 11 Feb 2022 10:22:21 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Sumeet Pawnikar <sumeet.r.pawnikar@intel.com>
Cc:     stable@vger.kernel.org, rafael.j.wysocki@intel.com,
        srinivas.pandruvada@linux.intel.com,
        Antoine Tenart <atenart@kernel.org>
Subject: Re: [PATCH  1/4] thermal/drivers/int340x: Improve the tcc offset
 saving for suspend/resume
Message-ID: <YgYqzaJhJ5sQDy/Y@kroah.com>
References: <20220211093437.8713-1-sumeet.r.pawnikar@intel.com>
 <20220211093437.8713-2-sumeet.r.pawnikar@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220211093437.8713-2-sumeet.r.pawnikar@intel.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Feb 11, 2022 at 03:04:34PM +0530, Sumeet Pawnikar wrote:
> From: Antoine Tenart <atenart@kernel.org>
> 
> When the driver resumes, the tcc offset is set back to its previous
> value. But this only works if the value was user defined as otherwise
> the offset isn't saved. This asymmetric logic is harder to maintain and
> introduced some issues.
> 
> Improve the logic by saving the tcc offset in a suspend op, so the right
> value is always restored after a resume.
> 
> Signed-off-by: Antoine Tenart <atenart@kernel.org>
> Reviewed-by: Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>
> Tested-by: Srinivas Pandruvada <srinivas.pI andruvada@linux.intel.com>
> Link: https://lore.kernel.org/r/20210909085613.5577-3-atenart@kernel.org
> Signed-off-by: Daniel Lezcano <daniel.lezcano@linaro.org>
> Signed-off-by: Sumeet Pawnikar <sumeet.r.pawnikar@intel.com>
> ---

What is the git commit id of this commit in Linus's tree?

Same for the other 3, I need a hint here please...

thanks,

greg k-h
