Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 090E34B428E
	for <lists+stable@lfdr.de>; Mon, 14 Feb 2022 08:13:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233426AbiBNHMG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Feb 2022 02:12:06 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:33912 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241297AbiBNHMF (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 14 Feb 2022 02:12:05 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2E27B5939C
        for <stable@vger.kernel.org>; Sun, 13 Feb 2022 23:11:58 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id D243DB80ACB
        for <stable@vger.kernel.org>; Mon, 14 Feb 2022 07:11:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CABE8C340EB;
        Mon, 14 Feb 2022 07:11:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1644822715;
        bh=uRsYDief9VoZYlVvR6vpDwfpY+qPKUE/rMSYZoghqcM=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=wTAOA0pGwR+4a1y3z11uzMXwD493H3rI784hreAf5tFWypPKJrLrAOl+UKtSN/8cP
         Gd9zxi9Gp6tEU88q4Jg687ZHAInpew5h1dU+H6dp0KQ1UuuFpH3tgj+5Cfo4V6Rrom
         wPjxlXd9mIyvICQ5FBVbRtxsSTR53NDukrhHf81o=
Date:   Mon, 14 Feb 2022 08:11:52 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     James Smart <jsmart2021@gmail.com>
Cc:     stable <stable@vger.kernel.org>
Subject: Re: backport of lpfc patches: NVME_FC disabled and Reducing Log msgs
Message-ID: <YgoAuFRKWOIfY8ai@kroah.com>
References: <9d661b63-5640-fe88-b938-1f4d1767908c@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <9d661b63-5640-fe88-b938-1f4d1767908c@gmail.com>
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sun, Feb 13, 2022 at 09:26:16AM -0800, James Smart wrote:
> I'd like to request the 2 patches below to be backported to the 5.6 and 5.12

5.6 and 5.12 are long end-of-life, see the front page of kernel.org for
the active kernel trees please.

> kernels. Other stable kernels are fine. The fixes were recently merged into
> linus's tree:
> 
> scsi: lpfc: Remove NVMe support if kernel has NVME_FC disabled
> This can cause device connectivity failure.
> commit c80b27cfd93b

This one applied to 5.4, 5.10, 5.15, and 5.16 ok.

> scsi: lpfc: Reduce log messages seen after firmware download
> This was causing overruns and headaches on consoles that were very slow.
> commit 5852ed2a6a39

This only could be applied to 5.10 and newer stable kernels.  If you
want any of these applied to older kernel trees, please provide working
backports.

thanks,

greg k-h
