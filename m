Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C57346C5A29
	for <lists+stable@lfdr.de>; Thu, 23 Mar 2023 00:16:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229600AbjCVXQH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 22 Mar 2023 19:16:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49390 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229848AbjCVXQF (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 22 Mar 2023 19:16:05 -0400
Received: from angie.orcam.me.uk (angie.orcam.me.uk [IPv6:2001:4190:8020::34])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id C9EC41912A;
        Wed, 22 Mar 2023 16:16:02 -0700 (PDT)
Received: by angie.orcam.me.uk (Postfix, from userid 500)
        id B5BB892009E; Thu, 23 Mar 2023 00:16:00 +0100 (CET)
Received: from localhost (localhost [127.0.0.1])
        by angie.orcam.me.uk (Postfix) with ESMTP id AFC1192009D;
        Wed, 22 Mar 2023 23:16:00 +0000 (GMT)
Date:   Wed, 22 Mar 2023 23:16:00 +0000 (GMT)
From:   "Maciej W. Rozycki" <macro@orcam.me.uk>
To:     Sasha Levin <sashal@kernel.org>
cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Sudip Mukherjee <sudipm.mukherjee@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: [PATCH AUTOSEL 6.2 19/64] parport_pc: Set up mode and ECR masks
 for Oxford Semiconductor devices
In-Reply-To: <20230303214106.1446460-19-sashal@kernel.org>
Message-ID: <alpine.DEB.2.21.2303222259100.55912@angie.orcam.me.uk>
References: <20230303214106.1446460-1-sashal@kernel.org> <20230303214106.1446460-19-sashal@kernel.org>
User-Agent: Alpine 2.21 (DEB 202 2017-01-01)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
X-Spam-Status: No, score=0.0 required=5.0 tests=SPF_HELO_NONE,SPF_NONE
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, 3 Mar 2023, Sasha Levin wrote:

> From: "Maciej W. Rozycki" <macro@orcam.me.uk>
> 
> [ Upstream commit c087df8d1e7dc2e764d11234d84b5af46d500f16 ]

 This patch cannot work without changes 2-5 from the series referred:

> Link: https://lore.kernel.org/r/20230108215656.6433-6-sudipm.mukherjee@gmail.com

and it's not clear to me if it's worth backporting as I think the problem 
it addresses may not be critical enough (though indeed it may be a bit 
annoying to have a non-working parallel port device).  Setting `hi' to -1 
would be a simple yet crippling workaround, but I gather we don't usually 
apply changes to -stable that are functionally different from the upstream 
version.

  Maciej
