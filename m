Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 74D0C67A635
	for <lists+stable@lfdr.de>; Tue, 24 Jan 2023 23:58:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231987AbjAXW6R (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 24 Jan 2023 17:58:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51328 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232748AbjAXW6E (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 24 Jan 2023 17:58:04 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 517DE4497
        for <stable@vger.kernel.org>; Tue, 24 Jan 2023 14:58:03 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id EF1D7B81683
        for <stable@vger.kernel.org>; Tue, 24 Jan 2023 22:58:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7B400C433EF;
        Tue, 24 Jan 2023 22:58:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1674601080;
        bh=5fd7fYjqz+eAn+5EIUhPV66R+1iJj8/bNPdKAx5QOFI=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=hlH0PLDbCqerTLOS8HLR/0N5eGOxC4EoUAF+ts0fKxVKGegthQr0/b2tUZCUH9u4X
         vEBoNWFk+odKG26iAkGlo5PTuYwPBBUSvW2o0+sLV3CSFSWyTmVDZ/BHdeIO2y4LSW
         l5ma3QCZ3bwfotMU2D+IR+BGIgcqWRrIj1DqbIcfdTEm3DKjGHNu51rL6kNl81gw3W
         sZ63H3ZlQCRfIU0Tw1JPjtk+PkJRAyb0ykOLwRI32E18bgS7f9iiCyarkRle43/L8p
         b5mqFvFSqCN42y/Zf/ZCj5PeY99SseV8EFC5dxlPVxkdJsb6YbcoLiYRl4hhc/eg1Y
         Wefl1XYLgmubw==
Date:   Tue, 24 Jan 2023 17:57:59 -0500
From:   Sasha Levin <sashal@kernel.org>
To:     Kevin Hao <haokexin@gmail.com>
Cc:     stable@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Geetha sowjanya <gakula@marvell.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: [PATCH 5.15 1/2] octeontx2-pf: Avoid use of GFP_KERNEL in atomic
 context
Message-ID: <Y9Bid3RHX9AB25HQ@sashalap>
References: <20230122224735.3713948-1-haokexin@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20230122224735.3713948-1-haokexin@gmail.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Jan 23, 2023 at 06:47:34AM +0800, Kevin Hao wrote:
>From: Geetha sowjanya <gakula@marvell.com>
>
>commit 87b93b678e95c7d93fe6a55b0e0fbda26d8c7760 upstream.

Queued up, thanks!

-- 
Thanks,
Sasha
