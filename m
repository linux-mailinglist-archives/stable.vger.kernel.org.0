Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 83B306499DC
	for <lists+stable@lfdr.de>; Mon, 12 Dec 2022 09:04:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231359AbiLLIEb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Dec 2022 03:04:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41664 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230504AbiLLIEa (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 12 Dec 2022 03:04:30 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 934ACD5F
        for <stable@vger.kernel.org>; Mon, 12 Dec 2022 00:04:29 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3052B60EE9
        for <stable@vger.kernel.org>; Mon, 12 Dec 2022 08:04:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 200F9C433D2;
        Mon, 12 Dec 2022 08:04:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1670832268;
        bh=aYqBJ5xArgntUOn2E7p36CfasEh/zyrG6bRaDwrACXc=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=fHIU+33nP3s3KeUAabKDDvct3zkoCkxMYJDR+Ow5rDypujLG7wNxxhawfpC637V4y
         zegwpGKpkMg5oo68g0TbSbhukOiFxQ2fhNxBWYCu+yepVkInYlv1uSt1HUQLgxsPXw
         LJmw5OB1pN/1AyRsfQFRR+yo9EBL482Xl5Rac+IE=
Date:   Mon, 12 Dec 2022 09:04:25 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     harshit.m.mogalapalli@oracle.com, syzkaller@googlegroups.com,
        stable@vger.kernel.org
Subject: Re: FAILED: patch "[PATCH] io_uring: Fix a null-ptr-deref in
 io_tctx_exit_cb()" failed to apply to 5.15-stable tree
Message-ID: <Y5bgiQ2VmG8Le3NW@kroah.com>
References: <16707522923183@kroah.com>
 <24918edb-e6eb-a093-51cf-519c7ece88a3@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <24918edb-e6eb-a093-51cf-519c7ece88a3@kernel.dk>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sun, Dec 11, 2022 at 10:32:59AM -0700, Jens Axboe wrote:
> On 12/11/22 2:51?AM, gregkh@linuxfoundation.org wrote:
> > 
> > The patch below does not apply to the 5.15-stable tree.
> > If someone wants it applied there, or to any other stable or longterm
> > tree, then please email the backport, including the original git commit
> > id to <stable@vger.kernel.org>.
> 
> It does apply fine, but it's in fs/io_uring.c rather than
> io_uring/io_uring.c as for the newer kernels. Attached one here that
> just does the patch change and it applies witha a slight offset:
> 

Sorry, my fault, I should have caught this.  Thanks for the backport!

greg k-h
