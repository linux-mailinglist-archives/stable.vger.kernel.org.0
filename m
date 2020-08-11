Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 45A9C241EA0
	for <lists+stable@lfdr.de>; Tue, 11 Aug 2020 18:49:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728975AbgHKQsv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 11 Aug 2020 12:48:51 -0400
Received: from mail.kernel.org ([198.145.29.99]:48568 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728962AbgHKQsv (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 11 Aug 2020 12:48:51 -0400
Received: from localhost (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9CBBC2076B;
        Tue, 11 Aug 2020 16:48:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597164530;
        bh=WoC8mft2A9GVDHZk3GWNFGv/xNTEXvYJmANvhuu3i1o=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=hrUgm4xn8SxQwYVCWU8KNaTDr4kbQkqc6kut5tYhdMpQdwFwTP3MHDXUoO7UL19Ll
         XX2J+fjfyOF0FzNuAyxfyWBHNQ8B+/w/lTvFbd4Fc7iRH+X2TM0xdkLfs75U6u4dNi
         raKsbzT9fR/dKTNREJi9AipsjuQE8fauji3/Li00=
Date:   Tue, 11 Aug 2020 12:48:49 -0400
From:   Sasha Levin <sashal@kernel.org>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     stable@vger.kernel.org
Subject: Re: Stable inclusion request
Message-ID: <20200811164849.GK2975990@sasha-vm>
References: <e708995f-6666-fbdd-9373-792007e7ea73@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <e708995f-6666-fbdd-9373-792007e7ea73@kernel.dk>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Aug 10, 2020 at 07:14:10PM -0600, Jens Axboe wrote:
>Hi,
>
>Can we queue up a backport of:
>
>commit 4c6e277c4cc4a6b3b2b9c66a7b014787ae757cc1
>Author: Jens Axboe <axboe@kernel.dk>
>Date:   Wed Jul 1 11:29:10 2020 -0600
>
>    io_uring: abstract out task work running
>
>for 5.7 and 5.8 stable? It fixes a reported issue from Dave Chinner,
>since the abstraction also ensures that we always set the current
>task state appropriately before running task work.
>
>I've attached both a 5.8 and 5.7 port of the patch.

Queued up, thanks!

-- 
Thanks,
Sasha
