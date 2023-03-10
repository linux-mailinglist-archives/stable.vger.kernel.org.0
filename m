Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E574D6B3EA3
	for <lists+stable@lfdr.de>; Fri, 10 Mar 2023 13:05:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229580AbjCJMFc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 10 Mar 2023 07:05:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52566 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229721AbjCJMFV (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 10 Mar 2023 07:05:21 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8FCEDF186F
        for <stable@vger.kernel.org>; Fri, 10 Mar 2023 04:05:13 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2B7C761510
        for <stable@vger.kernel.org>; Fri, 10 Mar 2023 12:05:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4228DC433D2;
        Fri, 10 Mar 2023 12:05:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678449912;
        bh=r4K/eaq2AvEyRA3+maqlecID146MNzhbmUC2uhjXPuk=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=XHEoST3yvCT0ZoxG7Z6wxxs4c5uv0IaK3op/ljs+GBlK70nt6XxMHVP/yNQgmv46s
         sQPG8KKHgiYiy9ZwH66PQL+p+86/K63NF5mAHQ8hdTbAITXc/E/lU3xYscCXV7P3Na
         TsX85ovq2tjTNZJd7j91r+9NyXXpoljx7lUrgq2s=
Date:   Fri, 10 Mar 2023 13:05:09 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     stable@vger.kernel.org
Subject: Re: FAILED: patch "[PATCH] io_uring/poll: allow some retries for
 poll triggering" failed to apply to 6.1-stable tree
Message-ID: <ZAsc9ds8vLrmmkPD@kroah.com>
References: <167809981810941@kroah.com>
 <5ec382c3-1de3-abf4-e6a4-b50c75a1eb28@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <5ec382c3-1de3-abf4-e6a4-b50c75a1eb28@kernel.dk>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Mar 07, 2023 at 04:51:08PM -0700, Jens Axboe wrote:
> On 3/6/23 3:50 AM, gregkh@linuxfoundation.org wrote:
> > 
> > The patch below does not apply to the 6.1-stable tree.
> > If someone wants it applied there, or to any other stable or longterm
> > tree, then please email the backport, including the original git commit
> > id to <stable@vger.kernel.org>.
> 
> This patch just needs:
> 
> df730ec21f7b ("io_uring: fix two assignments in if conditions")
> 
> cherry picked first. I'm attaching that one, and the one from this email,
> they will apply directly to 6.1-stable. Or you can just cherry-pick
> them as that'll work too, as long as you do df730ec21f7b first. Thanks!

Both now queued up, thanks!

greg k-h
