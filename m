Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BE8F86A051C
	for <lists+stable@lfdr.de>; Thu, 23 Feb 2023 10:39:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233628AbjBWJjx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 23 Feb 2023 04:39:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42854 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234095AbjBWJjZ (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 23 Feb 2023 04:39:25 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8DC937EDA
        for <stable@vger.kernel.org>; Thu, 23 Feb 2023 01:39:21 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E517061636
        for <stable@vger.kernel.org>; Thu, 23 Feb 2023 09:39:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 26EDCC433EF;
        Thu, 23 Feb 2023 09:39:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1677145160;
        bh=hsXH15A/iTWr95qpPnNpVUJCniMs3haQxRqPUrVVG6g=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=SnBvQI3x9rGZJbN0lI17oa+HjlJ+I53Pn2kpMk+08zvSjL7LbE19ShPj6SwgELovK
         pc560X3YQI4WB3+t1cLJXO+64oKBI55ymAuj71nKyi/aNAtqsAXWjl2uFoJGR4g0oh
         cr2/XUq0wcwAlYf0aA6Wk7lkdLNBPffQpqUzhghQ=
Date:   Thu, 23 Feb 2023 10:39:17 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     wenyang.linux@foxmail.com
Cc:     Sasha Levin <sashal@kernel.org>, Yu Kuai <yukuai3@huawei.com>,
        Josef Bacik <josef@toxicpanda.com>,
        Jens Axboe <axboe@kernel.dk>, stable@vger.kernel.org
Subject: Re: [PATCH 5.10 2/4] nbd: fix max value for 'first_minor'
Message-ID: <Y/c0RaLxCjcY0bFk@kroah.com>
References: <20230220180449.36425-1-wenyang.linux@foxmail.com>
 <tencent_B899BECA817A270876922C5D8B19C78FE805@qq.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <tencent_B899BECA817A270876922C5D8B19C78FE805@qq.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Feb 21, 2023 at 02:04:47AM +0800, wenyang.linux@foxmail.com wrote:
> From: Yu Kuai <yukuai3@huawei.com>
> 
> commit e4c4871a73944353ea23e319de27ef73ce546623 upstream.

<snip>

I never recieved patch 0/4 or 1/4 of this series saying what it is for
(and neither did lore.kernel.org.)

Please fix up and resend a v2 series.

thanks,

greg k-h
