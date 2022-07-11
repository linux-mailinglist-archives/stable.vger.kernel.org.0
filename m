Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0FD8056FEC8
	for <lists+stable@lfdr.de>; Mon, 11 Jul 2022 12:23:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230193AbiGKKXp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 11 Jul 2022 06:23:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41360 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229617AbiGKKXS (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 11 Jul 2022 06:23:18 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BC8BACAF2C;
        Mon, 11 Jul 2022 02:37:39 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 55E50B80E9B;
        Mon, 11 Jul 2022 09:37:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9E7C4C34115;
        Mon, 11 Jul 2022 09:37:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1657532257;
        bh=bcLD/qxsUGv+AF1rTNdpKdzVizCDffffHzxuyCpZio4=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=2qf86FdYQl0eJl6YZA6POKfpuzIr8AZzwyHXZPN5qCylgtNW/KMDmytEszIvoQoaK
         19pJELOavgTCURd9gaJk09ISsDUMY1h3n06IPUrbaxfaWtnSxgXHEsPqjHDhEQmiOG
         BM/MS7yqUUJPEQIVJnJQQsa8sR+X+r9FA8T+db6E=
Date:   Mon, 11 Jul 2022 11:37:34 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Christian =?iso-8859-1?Q?K=F6nig?= <christian.koenig@amd.com>
Cc:     Alex Deucher <alexander.deucher@amd.com>,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH 5.15 138/230] drm/amdgpu: bind to any 0x1002 PCI diplay
 class device
Message-ID: <YsvvXmH9DpMMIIiK@kroah.com>
References: <20220711090604.055883544@linuxfoundation.org>
 <20220711090607.978575207@linuxfoundation.org>
 <8c73c2b5-f70e-f343-7ca4-e1db420d5419@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <8c73c2b5-f70e-f343-7ca4-e1db420d5419@amd.com>
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Jul 11, 2022 at 11:29:53AM +0200, Christian König wrote:
> Hi Greg & Alex
> 
> why is that patch picked up for stable? Or are we backporting IP based
> discovery?

New device ids are usually added to stable trees as they are "trivial".

> If yes, is that wise? IIRC we had quite a number of typos etc.. in the
> initial patches.

If this commit is incorrect, we will be glad to drop it, or add any
needed add-on commits.  Which do you want to see happen here?

thanks,

greg k-h
