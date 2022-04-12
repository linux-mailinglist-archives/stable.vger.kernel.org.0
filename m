Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 392724FCE9A
	for <lists+stable@lfdr.de>; Tue, 12 Apr 2022 07:12:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233285AbiDLFOh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 12 Apr 2022 01:14:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39906 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229593AbiDLFOg (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 12 Apr 2022 01:14:36 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A151B344D3
        for <stable@vger.kernel.org>; Mon, 11 Apr 2022 22:12:18 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4432C617ED
        for <stable@vger.kernel.org>; Tue, 12 Apr 2022 05:12:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 52158C385A6;
        Tue, 12 Apr 2022 05:12:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649740337;
        bh=2Ld5jJGw1PTp6etetci6q4nHbD29mJ6Wlzif29xyTUs=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=zphAaCydtxTVuJT+cGNtr6OOpoZb1NLB7k1MgfnGC0zC5Qn4F8cR2o/vkG0PBFu8n
         d1Khuw43auqxFvOo26oP6woMwdAsyD8pOydyLLe5/rTarRdexTPLaLsyLHwsD36VR5
         NP5QBHKjLmKLpfPBsoJBVTfuDn2649ISyBKYBgNQ=
Date:   Tue, 12 Apr 2022 07:12:15 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     stable@vger.kernel.org
Subject: Re: FAILED: patch "[PATCH] io_uring: move read/write file prep state
 into actual opcode" failed to apply to 5.15-stable tree
Message-ID: <YlUKLyMirD242p1l@kroah.com>
References: <164966306719476@kroah.com>
 <7bc5956c-46f1-9411-7ba7-6bfd92b7323c@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <7bc5956c-46f1-9411-7ba7-6bfd92b7323c@kernel.dk>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Apr 11, 2022 at 01:50:55PM -0600, Jens Axboe wrote:
> On 4/11/22 1:44 AM, gregkh@linuxfoundation.org wrote:
> > 
> > The patch below does not apply to the 5.15-stable tree.
> > If someone wants it applied there, or to any other stable or longterm
> > tree, then please email the backport, including the original git commit
> > id to <stable@vger.kernel.org>.
> 
> For now, let's just drop this series otherwise marked for 5.15+ for
> 5.15-stable and 5.16-stable. It would require further backporting, and
> it isn't strictly necessary.

Ok, thanks for letting me know.

greg k-h
