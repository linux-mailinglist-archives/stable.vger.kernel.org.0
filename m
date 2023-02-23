Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1D5686A051D
	for <lists+stable@lfdr.de>; Thu, 23 Feb 2023 10:39:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233909AbjBWJjy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 23 Feb 2023 04:39:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43240 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234214AbjBWJjx (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 23 Feb 2023 04:39:53 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 66E07B767
        for <stable@vger.kernel.org>; Thu, 23 Feb 2023 01:39:52 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D71FC61629
        for <stable@vger.kernel.org>; Thu, 23 Feb 2023 09:39:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1AF12C433D2;
        Thu, 23 Feb 2023 09:39:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1677145191;
        bh=p5qstACsvvSKPdCAX9OO7WE6oUb3hnBSioQgRI/CIgo=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=bCzzpH3VMlq1Mq8BP25RVRhBknRHHc2aOyQFkVg+9zqzhbMjrPCH84trJ0v7xu6ps
         E6ngGT2DVIXcNAjJvRJeM1bIf8Y2rMCCq3aSP6/kw37FHWiGdbmeD8RezIyW+DY2SM
         QQvuunaPH1H/SdRrc3BMt4VX/Rx2zq7Zwh/C8H+s=
Date:   Thu, 23 Feb 2023 10:39:49 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     wenyang.linux@foxmail.com
Cc:     Sasha Levin <sashal@kernel.org>, Yu Kuai <yukuai3@huawei.com>,
        Josef Bacik <josef@toxicpanda.com>,
        Jens Axboe <axboe@kernel.dk>, stable@vger.kernel.org
Subject: Re: [PATCH 5.10 2/4] nbd: fix max value for 'first_minor'
Message-ID: <Y/c0Zd2rFDGwhZxT@kroah.com>
References: <20230220180449.36425-1-wenyang.linux@foxmail.com>
 <tencent_B899BECA817A270876922C5D8B19C78FE805@qq.com>
 <Y/c0RaLxCjcY0bFk@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Y/c0RaLxCjcY0bFk@kroah.com>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Feb 23, 2023 at 10:39:17AM +0100, Greg Kroah-Hartman wrote:
> On Tue, Feb 21, 2023 at 02:04:47AM +0800, wenyang.linux@foxmail.com wrote:
> > From: Yu Kuai <yukuai3@huawei.com>
> > 
> > commit e4c4871a73944353ea23e319de27ef73ce546623 upstream.
> 
> <snip>
> 
> I never recieved patch 0/4 or 1/4 of this series saying what it is for
> (and neither did lore.kernel.org.)

Ah, now I found patch 1/4, your email threading got broken somehow,
odd...

thanks

greg k-h
