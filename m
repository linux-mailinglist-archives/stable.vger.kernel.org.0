Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 87BDE4E63B0
	for <lists+stable@lfdr.de>; Thu, 24 Mar 2022 13:54:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345439AbiCXMz6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 24 Mar 2022 08:55:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40706 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234892AbiCXMz5 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 24 Mar 2022 08:55:57 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2D81E694AF
        for <stable@vger.kernel.org>; Thu, 24 Mar 2022 05:54:26 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C61EA60EEF
        for <stable@vger.kernel.org>; Thu, 24 Mar 2022 12:54:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B412CC340EC;
        Thu, 24 Mar 2022 12:54:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1648126465;
        bh=TOhg5dBjnov9r7IzEeGrIVzlRPZAoSBt3LPXyjqs6Y4=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=xNG5BsU6xYgCMypnELauIoxjmz1nhXTRG2TkR1WZ3WWY+5zaUn3nQJrYLGMNSB7GZ
         zjlGmYeuxflMZo0AIP8iyPTvNP+ByENaRa/xRXWT2ZV87EtRHFWlEScGpEMURO8CPG
         HDnzb0ungQqEzeLg+7IgEKcMn1ahoMboH4KwQ+Q4=
Date:   Thu, 24 Mar 2022 13:54:17 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     James Smart <jsmart2021@gmail.com>
Cc:     stable <stable@vger.kernel.org>
Subject: Re: Backport Request: scsi: lpfc: Fix DMA virtual address ptr
 assignment in bsg
Message-ID: <Yjxp+RWNiRtNC919@kroah.com>
References: <6aab7d93-7791-fd8b-b0ed-6a0a2ee52472@gmail.com>
 <fd794879-48d6-463a-fe0f-184df7cc66d2@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <fd794879-48d6-463a-fe0f-184df7cc66d2@gmail.com>
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Mar 21, 2022 at 02:45:53PM -0700, James Smart wrote:
> Please backport the following patch to the 5.10 stable kernel. It is was
> upstream'd as of the 5.12 kernel.
> 
> scsi: lpfc: Fix DMA virtual address ptr assignment in bsg
> commit    83adbba746d1
> 
> The error causes diagnostic loopback tests to fail.
> 
> Note: problem was introduced in 5.10 by:
>   scsi: lpfc: Reject CT request for MIB commands
>   commit b67b59443282

It does not apply.  How did you test that this works?

Please send a working backport and we will be glad to queue it up.

thanks,

greg k-h
