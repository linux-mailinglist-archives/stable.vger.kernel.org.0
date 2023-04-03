Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 205106D4BF0
	for <lists+stable@lfdr.de>; Mon,  3 Apr 2023 17:31:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232508AbjDCPbP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 Apr 2023 11:31:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38006 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232806AbjDCPbO (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 3 Apr 2023 11:31:14 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7E86F213B
        for <stable@vger.kernel.org>; Mon,  3 Apr 2023 08:31:13 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0FB4461B04
        for <stable@vger.kernel.org>; Mon,  3 Apr 2023 15:31:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 21781C433D2;
        Mon,  3 Apr 2023 15:31:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1680535872;
        bh=smyFd17r8YFFmdrrC95HNqQ0yRqa/BfRnlEf2fqw0wY=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=so3KNLy4CQOZxgr3qaFMMakTYJ38vt99vv4jKEr/R5oqqu4XbciKXu7o2wf+gi6RJ
         cHTom70mffT093tJnhDyFXwj9ZRtKSPvp0Pvf0h6Bci7XGzttYR75PmqXRoX9St1O+
         DSxlegNPC86Rdj1jnzdCBAWY6/5fAW3Fw+NU/+Io=
Date:   Mon, 3 Apr 2023 17:31:09 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     pengfei.xu@intel.com, stable@vger.kernel.org
Subject: Re: FAILED: patch "[PATCH] io_uring/poll: clear single/double poll
 flags on poll arming" failed to apply to 5.10-stable tree
Message-ID: <2023040303-goofy-trustless-6972@gregkh>
References: <2023040352-overbuilt-backshift-9c74@gregkh>
 <27b87281-1341-f044-cf94-85083c2b090b@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <27b87281-1341-f044-cf94-85083c2b090b@kernel.dk>
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Apr 03, 2023 at 09:01:25AM -0600, Jens Axboe wrote:
> On 4/3/23 2:18 AM, gregkh@linuxfoundation.org wrote:
> > 
> > The patch below does not apply to the 5.10-stable tree.
> > If someone wants it applied there, or to any other stable or longterm
> > tree, then please email the backport, including the original git commit
> > id to <stable@vger.kernel.org>.
> 
> After reviewing 5.10/15-stable, I don't think we need this patch
> there. You can drop those two, thanks.

Great, will do, thanks!

greg k-h
