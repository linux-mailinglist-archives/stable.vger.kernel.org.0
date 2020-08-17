Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1B5C624676B
	for <lists+stable@lfdr.de>; Mon, 17 Aug 2020 15:37:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728550AbgHQNhC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 Aug 2020 09:37:02 -0400
Received: from mail.kernel.org ([198.145.29.99]:35758 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728443AbgHQNhA (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 17 Aug 2020 09:37:00 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id DB71D204FD;
        Mon, 17 Aug 2020 13:36:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597671420;
        bh=GbT7Wmq5VqzyxTisFFzTnT/7da18yyliiEKjBEZGiZI=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=gloJiQX6r+sRvWN701BFwxagiOwbgXBuKBrztL7Zfj8WrBhXt/IqD0HYrK0Shlcm1
         e19w+EtExPO2YLzmBX96qWg5yalmL5ndjTMDZGFCH23GeGSiCcfpoHbtM7iPnt54w7
         rG6/cqBYh4aF5pIl0AnwIOFK9Q+lRm1wfLSUs5Ik=
Date:   Mon, 17 Aug 2020 15:37:19 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     stable@vger.kernel.org
Subject: Re: FAILED: patch "[PATCH] io_uring: hold 'ctx' reference around
 task_work queue +" failed to apply to 5.7-stable tree
Message-ID: <20200817133719.GA359148@kroah.com>
References: <159766104348155@kroah.com>
 <5e62e5ea-6bd4-5d43-b836-a4f012bafc7c@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5e62e5ea-6bd4-5d43-b836-a4f012bafc7c@kernel.dk>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Aug 17, 2020 at 06:27:59AM -0700, Jens Axboe wrote:
> On 8/17/20 3:44 AM, gregkh@linuxfoundation.org wrote:
> > 
> > The patch below does not apply to the 5.7-stable tree.
> > If someone wants it applied there, or to any other stable or longterm
> > tree, then please email the backport, including the original git commit
> > id to <stable@vger.kernel.org>.
> 
> 5.4 doesn't need this patch, only 5.7+ as per the Cc stable instruction.
> Did I type it wrong?

Oops, nope, my fault, you are correct, sorry, only 5.7+

greg k-h
