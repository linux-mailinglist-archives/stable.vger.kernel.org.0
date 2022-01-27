Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CAA3449E53C
	for <lists+stable@lfdr.de>; Thu, 27 Jan 2022 15:54:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232420AbiA0Oye (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 27 Jan 2022 09:54:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55424 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232133AbiA0Oye (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 27 Jan 2022 09:54:34 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9142AC061714
        for <stable@vger.kernel.org>; Thu, 27 Jan 2022 06:54:32 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 2C445B822B6
        for <stable@vger.kernel.org>; Thu, 27 Jan 2022 14:54:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 330C8C340E8;
        Thu, 27 Jan 2022 14:54:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643295269;
        bh=ztssI2Eh5h1E+rYlmNQzsZI2OvHtWI9BWKQpo3yAuAE=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Wdwea8bp0LFLYYxj3esf5wpZP+wD3O/fIqySyPXqKYA0kaIIUrhSesW1CmW/UWUY3
         dnqhLWpPHCKEuv8fx7p+FrcQT1uSIY4MPtdKYFYE5zffC4gKoRgJMOHe9BcYMkO3sI
         zdii7zk2Ph/dA+bijxl4FnEfX2E44RG0/sEgD5hg=
Date:   Thu, 27 Jan 2022 15:54:26 +0100
From:   "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>
To:     Manish Chopra <manishc@marvell.com>
Cc:     Ariel Elior <aelior@marvell.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        Alok Prasad <palok@marvell.com>,
        Prabhakar Kushwaha <pkushwaha@marvell.com>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: Re: [EXT] FAILED: patch "[PATCH] bnx2x: Invalidate fastpath HSI
 version for VFs" failed to apply to 5.10-stable tree
Message-ID: <YfKyIoc2Wwjphgkj@kroah.com>
References: <164303346429105@kroah.com>
 <BY3PR18MB4612CDF3D37F516764972650AB5F9@BY3PR18MB4612.namprd18.prod.outlook.com>
 <Ye/QynAZSyyHdgbQ@kroah.com>
 <BY3PR18MB46126A183605747B9550E536AB5F9@BY3PR18MB4612.namprd18.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <BY3PR18MB46126A183605747B9550E536AB5F9@BY3PR18MB4612.namprd18.prod.outlook.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Jan 25, 2022 at 07:17:15PM +0000, Manish Chopra wrote:
> > -----Original Message-----
> > From: gregkh@linuxfoundation.org <gregkh@linuxfoundation.org>
> > Sent: Tuesday, January 25, 2022 3:58 PM
> > To: Manish Chopra <manishc@marvell.com>
> > Cc: Ariel Elior <aelior@marvell.com>; davem@davemloft.net; Alok Prasad
> > <palok@marvell.com>; Prabhakar Kushwaha <pkushwaha@marvell.com>;
> > stable@vger.kernel.org
> > Subject: Re: [EXT] FAILED: patch "[PATCH] bnx2x: Invalidate fastpath HSI
> > version for VFs" failed to apply to 5.10-stable tree
> > 
> > On Tue, Jan 25, 2022 at 09:30:53AM +0000, Manish Chopra wrote:
> > > > -----Original Message-----
> > > > From: gregkh@linuxfoundation.org <gregkh@linuxfoundation.org>
> > > > Sent: Monday, January 24, 2022 7:41 PM
> > > > To: Manish Chopra <manishc@marvell.com>; Ariel Elior
> > > > <aelior@marvell.com>; davem@davemloft.net; Alok Prasad
> > > > <palok@marvell.com>; Prabhakar Kushwaha <pkushwaha@marvell.com>
> > > > Cc: stable@vger.kernel.org
> > > > Subject: [EXT] FAILED: patch "[PATCH] bnx2x: Invalidate fastpath HSI
> > > > version for VFs" failed to apply to 5.10-stable tree
> > > >
> > > > External Email
> > > >
> > > > --------------------------------------------------------------------
> > > > --
> > > >
> > > > The patch below does not apply to the 5.10-stable tree.
> > > > If someone wants it applied there, or to any other stable or
> > > > longterm tree, then please email the backport, including the
> > > > original git commit id to <stable@vger.kernel.org>.
> > > >
> > > > thanks,
> > > >
> > > > greg k-h
> > > >
> > > > ------------------ original commit in Linus's tree
> > > > ------------------
> > > >
> > > > From 802d4d207e75d7208ff75adb712b556c1e91cf1c Mon Sep 17
> > 00:00:00
> > > > 2001
> > > > From: Manish Chopra <manishc@marvell.com>
> > > > Date: Fri, 17 Dec 2021 08:55:52 -0800
> > > > Subject: [PATCH] bnx2x: Invalidate fastpath HSI version for VFs
> > > >
> > > > Commit 0a6890b9b4df ("bnx2x: Utilize FW 7.13.15.0.") added
> > > > validation for fastpath HSI versions for different client init which
> > > > was not meant for SR-IOV VF clients, which resulted in firmware
> > > > asserts when running VF clients with different fastpath HSI version.
> > > >
> > > > This patch along with the new firmware support in patch #1 fixes
> > > > this behavior in order to not validate fastpath HSI version for the VFs.
> > > >
> > > > Fixes: 0a6890b9b4df ("bnx2x: Utilize FW 7.13.15.0.")
> > > > Signed-off-by: Manish Chopra <manishc@marvell.com>
> > > > Signed-off-by: Prabhakar Kushwaha <pkushwaha@marvell.com>
> > > > Signed-off-by: Alok Prasad <palok@marvell.com>
> > > > Signed-off-by: Ariel Elior <aelior@marvell.com>
> > > > Signed-off-by: David S. Miller <davem@davemloft.net>
> > > >
> > > > diff --git a/drivers/net/ethernet/broadcom/bnx2x/bnx2x_sriov.c
> > > > b/drivers/net/ethernet/broadcom/bnx2x/bnx2x_sriov.c
> > > > index 74a8931ce1d1..11d15cd03600 100644
> > > > --- a/drivers/net/ethernet/broadcom/bnx2x/bnx2x_sriov.c
> > > > +++ b/drivers/net/ethernet/broadcom/bnx2x/bnx2x_sriov.c
> > > > @@ -758,9 +758,18 @@ static void bnx2x_vf_igu_reset(struct bnx2x
> > > > *bp, struct bnx2x_virtf *vf)
> > > >
> > > >  void bnx2x_vf_enable_access(struct bnx2x *bp, u8 abs_vfid)  {
> > > > +	u16 abs_fid;
> > > > +
> > > > +	abs_fid = FW_VF_HANDLE(abs_vfid);
> > > > +
> > > >  	/* set the VF-PF association in the FW */
> > > > -	storm_memset_vf_to_pf(bp, FW_VF_HANDLE(abs_vfid),
> > > > BP_FUNC(bp));
> > > > -	storm_memset_func_en(bp, FW_VF_HANDLE(abs_vfid), 1);
> > > > +	storm_memset_vf_to_pf(bp, abs_fid, BP_FUNC(bp));
> > > > +	storm_memset_func_en(bp, abs_fid, 1);
> > > > +
> > > > +	/* Invalidate fp_hsi version for vfs */
> > > > +	if (bp->fw_cap & FW_CAP_INVALIDATE_VF_FP_HSI)
> > > > +		REG_WR8(bp, BAR_XSTRORM_INTMEM +
> > > > +
> > > > XSTORM_ETH_FUNCTION_INFO_FP_HSI_VALID_E2_OFFSET(abs_fid), 0);
> > > >
> > > >  	/* clear vf errors*/
> > > >  	bnx2x_vf_semi_clear_err(bp, abs_vfid);
> > >
> > > Hello Greg,
> > >
> > > Although this patch fixes the actual issue but the patch is dependent on
> > below patch as those were part of same series, due to this it fails to apply
> > probably.
> > >
> > > commit b7a49f73059fe6147b6b78e8f674ce0d21237432
> > > Author: Manish Chopra <manishc@marvell.com>
> > > Date:   Fri Dec 17 08:55:51 2021 -0800
> > >
> > >     bnx2x: Utilize firmware 7.13.21.0
> > >
> > >     This new firmware addresses few important issues and enhancements
> > >     as mentioned below -
> > >
> > >     - Support direct invalidation of FP HSI Ver per function ID, required for
> > >       invalidating FP HSI Ver prior to each VF start, as there is no VF start
> > >     - BRB hardware block parity error detection support for the driver
> > >     - Fix the FCOE underrun flow
> > >     - Fix PSOD during FCoE BFS over the NIC ports after preboot driver
> > >     - Maintains backward compatibility
> > >
> > >     This patch incorporates this new firmware 7.13.21.0 in bnx2x driver.
> > >
> > >     Signed-off-by: Manish Chopra <manishc@marvell.com>
> > >     Signed-off-by: Prabhakar Kushwaha <pkushwaha@marvell.com>
> > >     Signed-off-by: Alok Prasad <palok@marvell.com>
> > >     Signed-off-by: Ariel Elior <aelior@marvell.com>
> > >     Signed-off-by: David S. Miller <davem@davemloft.net>
> > >
> > > Thanks,
> > > Manish
> > 
> > Ok, care to send a working backport?
> 
> Hi Greg,
> 
> I have sent relevant backport for each of the kernel. By the way I have got two questions here -
> 
> 1. when doing backporting over stable/linux.git (let's say backport for 5.10-stable kernel)
>     should we backport on particular kernel branch (origin/linux-5.10.y) or we should backport based on resetting master branch on a git tag (git reset --hard v5.10) ?

You should do it on the linux-5.10.y branch.  5.10.0 is very old by now
and you might have conflicts.

> 2. if the same backport works for multiple stable kernels - do we need to send the backport separately for each kernel ? OR we can send it single backport mentioning all the kernels in the subject like below ?
>     [PATCH stable 5.10, 5.15, 5.16] ?

A subject line like that is fine.

thanks,

greg k-h
