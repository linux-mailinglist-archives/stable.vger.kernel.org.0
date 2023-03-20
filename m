Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 07E9D6C147F
	for <lists+stable@lfdr.de>; Mon, 20 Mar 2023 15:16:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230489AbjCTOQw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Mar 2023 10:16:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41742 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230204AbjCTOQu (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Mar 2023 10:16:50 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C774F1B324
        for <stable@vger.kernel.org>; Mon, 20 Mar 2023 07:16:49 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5C2516152E
        for <stable@vger.kernel.org>; Mon, 20 Mar 2023 14:16:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 70AE5C433D2;
        Mon, 20 Mar 2023 14:16:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1679321808;
        bh=0UpwcYD6QmLPbOEL3Cxb2qRzfyPKw1l0R465Z0cRD9Y=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=L6NPvY1+2H9qLTKDwrRZI3R4lTB4xomx/EMeHzKIYPpdVVhQ7Ace+T6zc9So/gm6V
         Ee900ZQxlotBi8EfNRj76pA7HQjw11EyFUEfGObNTe/mw0+OVmvWguhwGY8KRLKexF
         jgkP/ZYmMF6MWQTiaLVEtfvN0j2af7oKNAcFeMNs=
Date:   Mon, 20 Mar 2023 15:16:38 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     asml.silence@gmail.com, stable@vger.kernel.org
Subject: Re: FAILED: patch "[PATCH] io_uring/msg_ring: let target know
 allocated index" failed to apply to 6.1-stable tree
Message-ID: <ZBhqxkFbmfZfkvgT@kroah.com>
References: <167931300423217@kroah.com>
 <8762c8d4-723d-dcdb-07ce-d90d96c4b32a@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <8762c8d4-723d-dcdb-07ce-d90d96c4b32a@kernel.dk>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Mar 20, 2023 at 07:07:58AM -0600, Jens Axboe wrote:
> On 3/20/23 5:50 AM, gregkh@linuxfoundation.org wrote:
> > 
> > The patch below does not apply to the 6.1-stable tree.
> > If someone wants it applied there, or to any other stable or longterm
> > tree, then please email the backport, including the original git commit
> > id to <stable@vger.kernel.org>.
> > 
> > To reproduce the conflict and resubmit, you may use the following commands:
> > 
> > git fetch https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux.git/ linux-6.1.y
> > git checkout FETCH_HEAD
> > git cherry-pick -x 5da28edd7bd5518f97175ecea77615bb729a7a28
> > # <resolve conflicts, build, test, etc.>
> > git commit -s
> > git send-email --to '<stable@vger.kernel.org>' --in-reply-to '167931300423217@kroah.com' --subject-prefix 'PATCH 6.1.y' HEAD^..
> 
> Here's a tested backport of that patch.

Thanks, now queued up!

greg k-h
