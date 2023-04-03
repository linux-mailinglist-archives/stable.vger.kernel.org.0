Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 919586D45E8
	for <lists+stable@lfdr.de>; Mon,  3 Apr 2023 15:34:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231808AbjDCNe5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 Apr 2023 09:34:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39054 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229473AbjDCNe5 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 3 Apr 2023 09:34:57 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DE006C647
        for <stable@vger.kernel.org>; Mon,  3 Apr 2023 06:34:44 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 79F7D61B94
        for <stable@vger.kernel.org>; Mon,  3 Apr 2023 13:34:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 920FFC433EF;
        Mon,  3 Apr 2023 13:34:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1680528883;
        bh=sQFzQDCi63N0ANiiuqbw7cGpVkM678KYFwPiVixuUG8=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=BZbQKujoXoup9Zf39hoUA10r+0sZVOTTOXVPw8+suMh0fX/TZ/QAIyqCwzxR7PbBs
         Cfsebfh6P05Gp5PXak86J2imPMFDsAYeUBNo5AI0hcnjeZWvd3c5FTYAgUw7bm4DAH
         +sK73sPYz/zsFq5qXXVEzwA7wKfFV0Q9Yd3q6Iw8=
Date:   Mon, 3 Apr 2023 15:34:41 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     mpe@ellerman.id.au, stable@vger.kernel.org
Subject: Re: FAILED: patch "[PATCH] powerpc: Don't try to copy PPR for task
 with NULL pt_regs" failed to apply to 5.4-stable tree
Message-ID: <2023040331-stubble-jingle-6800@gregkh>
References: <2023040302-flakily-define-371e@gregkh>
 <c6134352-74a1-d3c9-5a21-e0e6822ed0f2@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <c6134352-74a1-d3c9-5a21-e0e6822ed0f2@kernel.dk>
X-Spam-Status: No, score=-5.2 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Apr 03, 2023 at 07:21:54AM -0600, Jens Axboe wrote:
> On 4/3/23 2:40?AM, gregkh@linuxfoundation.org wrote:
> > 
> > The patch below does not apply to the 5.4-stable tree.
> > If someone wants it applied there, or to any other stable or longterm
> > tree, then please email the backport, including the original git commit
> > id to <stable@vger.kernel.org>.
> 
> PF_IO_WORKER doesn't exist before 5.10-stable, so we don't need to
> backport this patch to older version. You can drop this one, and the
> ones for 4.x.

Great, thanks for letting us know.

greg k-h
