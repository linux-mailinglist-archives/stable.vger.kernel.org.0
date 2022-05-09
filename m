Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6B15851F991
	for <lists+stable@lfdr.de>; Mon,  9 May 2022 12:18:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231804AbiEIKTG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 9 May 2022 06:19:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38084 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231322AbiEIKTE (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 9 May 2022 06:19:04 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E2B991BDDA8;
        Mon,  9 May 2022 03:15:08 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2FC5E60C0B;
        Mon,  9 May 2022 10:14:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 729AEC385AB;
        Mon,  9 May 2022 10:14:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1652091290;
        bh=+9srvDHqiWKm6OjKS3qVUqzfohs6qxQD/zq2WlbkEa0=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=z7vtLfTH8SA1J3f2yk0yw/6kQ1lAOH0G7IygugS0czPnxCS71yOLEDkH9PKXy1in/
         PshnArIMLgpNvDyeaVZIyWVAGJn5J67zPbng2Cu+rjP7yWCDRKdyHzx1SaHITM5mB4
         UQmrOxirfZMwsX7gnCdghtChxLaLJI+zMEpL/yGI=
Date:   Mon, 9 May 2022 12:14:46 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Chen Zhongjin <chenzhongjin@huawei.com>
Cc:     linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-arch@vger.kernel.org, stable@vger.kernel.org,
        peterz@infradead.org, tglx@linutronix.de, namit@vmware.com,
        gor@linux.ibm.com, rdunlap@infradead.org, sashal@kernel.org
Subject: Re: [PATCH 5.10 v3] locking/csd_lock: fix csdlock_debug cause arm64
 boot panic
Message-ID: <YnjpljvWncezV0G0@kroah.com>
References: <20220507084510.14761-1-chenzhongjin@huawei.com>
 <YnZAO+3Rhj0gwq38@kroah.com>
 <e8715911-f835-059d-27f8-cc5f5ad30a07@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <e8715911-f835-059d-27f8-cc5f5ad30a07@huawei.com>
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


A: http://en.wikipedia.org/wiki/Top_post
Q: Were do I find info about this thing called top-posting?
A: Because it messes up the order in which people normally read text.
Q: Why is top-posting such a bad thing?
A: Top-posting.
Q: What is the most annoying thing in e-mail?

A: No.
Q: Should I include quotations after my reply?

http://daringfireball.net/2007/07/on_top

On Mon, May 09, 2022 at 11:14:12AM +0800, Chen Zhongjin wrote:
> Hi Greg,
> 
> Since the patch:
> https://lore.kernel.org/all/20210420093559.23168-1-catalin.marinas@arm.com/
> has forced CONFIG_SPARSEMEM_VMEMMAP=y from 5.12, it's not necessary to include
> this patch on master.
> 
> However this problem still exist on 5.10 stable, so either we can backport the
> above patch to 5.10, or independently apply mine.
> 
> I'm not sure if backporting one exist patch is better, but that patch only
> changed configs without any fix for old builds.
> 
> If you have any advice please tell me.

If you want to include a patch in the stable tree that is NOT in Linus's
tree, then you need to document it very very well as to why this is not
the case.

If backporting the above commit is better, I would much rather do that,
please ask the maintainers and developers of it if they will do that.

thanks,

greg k-h
