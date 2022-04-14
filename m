Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A0EF5501825
	for <lists+stable@lfdr.de>; Thu, 14 Apr 2022 18:05:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346371AbiDNQBh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 14 Apr 2022 12:01:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56656 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345240AbiDNP6v (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 14 Apr 2022 11:58:51 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 63735E887B;
        Thu, 14 Apr 2022 08:46:57 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 0FBA6B82A6C;
        Thu, 14 Apr 2022 15:46:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1D44BC385A1;
        Thu, 14 Apr 2022 15:46:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649951214;
        bh=YI3janPqCGGpL43fJmJ7YmCOtmGN8l5vINsH5oQ0IAA=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=bQKoWCyRd8em/bYwFNH1A4WzMKQ7OrHr7G67J05FiF4x+PyLmR42XraX7Vwuq/U9C
         IuE7Mh/Yz3Vsk7xllyGfDifcnD045sI2M/Faf+JUfOHy7h+z4Ym8sLlGcbg2mSIXi0
         e2F86TC6Wz73nRnwmyEEUjclfoIhIr8J6DHHjCQQ=
Date:   Thu, 14 Apr 2022 17:46:51 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Jeremy Linton <jeremy.linton@arm.com>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Peter Robinson <pbrobinson@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH 5.4 222/475] net: bcmgenet: Use stronger register
 read/writes to assure ordering
Message-ID: <YlhB67C6LV+oyYir@kroah.com>
References: <20220414110855.141582785@linuxfoundation.org>
 <20220414110901.335632939@linuxfoundation.org>
 <d5ad3e6f-769d-05d8-3e94-21ec8b5cb3ba@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <d5ad3e6f-769d-05d8-3e94-21ec8b5cb3ba@arm.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Apr 14, 2022 at 10:01:30AM -0500, Jeremy Linton wrote:
> Hi,
> 
> I would kill this commit since the final conclusion was that underlying
> problem was a compiler bug (which has now been fixed).

Ok, thanks, now dropped from all queues.

greg k-h
