Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 24E605A0FF4
	for <lists+stable@lfdr.de>; Thu, 25 Aug 2022 14:07:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235303AbiHYMHg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 25 Aug 2022 08:07:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48974 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231283AbiHYMHf (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 25 Aug 2022 08:07:35 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 81110AA3F2;
        Thu, 25 Aug 2022 05:07:34 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id F2CD661B32;
        Thu, 25 Aug 2022 12:07:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C58B2C433D7;
        Thu, 25 Aug 2022 12:07:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1661429253;
        bh=mBSggpsrQGQX1tnoN8PPl4zbTZYNJxA+1wdzRz2h784=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=tQhPHVFI+ra7S+yILF7wFSA3Stk5osFHj0X8rajH6+FVwkJ7o0U9mCiqnzFr4su0M
         3Hh7VCNA/kp4dh8uBWxQ6swVUSmCSr7dgyt+XyYmMnt9AEob/7xC431VRxPeMSCRO2
         MHZ2pxOQLSlSv+SdJxF1X7QkJ0bFdmhTY4Agwrvc=
Date:   Thu, 25 Aug 2022 14:07:18 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Amir Goldstein <amir73il@gmail.com>
Cc:     Sasha Levin <sashal@kernel.org>,
        "Darrick J . Wong" <djwong@kernel.org>,
        Leah Rumancik <leah.rumancik@gmail.com>,
        Chandan Babu R <chandan.babu@oracle.com>,
        Luis Chamberlain <mcgrof@kernel.org>,
        Adam Manzanares <a.manzanares@samsung.com>,
        linux-xfs@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH 5.10 v2 0/6] xfs stable patches for 5.10.y (from v5.17)
Message-ID: <Ywdl9satF+g7dPhV@kroah.com>
References: <20220823121136.1806820-1-amir73il@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220823121136.1806820-1-amir73il@gmail.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Aug 23, 2022 at 03:11:30PM +0300, Amir Goldstein wrote:
> Hi Greg,
> 
> This 5.10.y backport series contains fixes from v5.17 release.
> 
> All the patches in this series have already been applied to 5.15.y
> except for patch 2 which you have queued to 5.15.y yesterday [1].
> 
> Yesterday's 5.15.y series contains mostly fixed from v5.18/v5.19.
> The applicable fixed from that series will be included in the next
> 5.10.y series.
> 

All now queued up, thanks.

greg k-h
