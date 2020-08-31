Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7EF02258247
	for <lists+stable@lfdr.de>; Mon, 31 Aug 2020 22:08:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728903AbgHaUIw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 31 Aug 2020 16:08:52 -0400
Received: from mail.kernel.org ([198.145.29.99]:52936 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729908AbgHaUIv (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 31 Aug 2020 16:08:51 -0400
Received: from localhost (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 856922078B;
        Mon, 31 Aug 2020 20:08:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1598904530;
        bh=6Y0ZdwL5X0Ybc8ryd58Z4SajsjMnC64/o1JAZRemqz4=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=oyITyOc4eCE7cIaibJWTY5Zue1CcZtBsDEksCZEULmBDHMTxy0gIV79a255f3sZ9l
         /qtnXAclSlwuhtsLxi+4j09Dy7Oyt6Uz1tlkc2TdnX//Ls+fQemEzzDTX+DA6xP+bF
         rsGjLL7vCH2QMdvRqVKr07+9f31E9/az6Hct0yTM=
Date:   Mon, 31 Aug 2020 16:08:49 -0400
From:   Sasha Levin <sashal@kernel.org>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     gregkh@linuxfoundation.org, stable@vger.kernel.org
Subject: Re: FAILED: patch "[PATCH] io_uring: don't recurse on
 tsk->sighand->siglock with" failed to apply to 5.8-stable tree
Message-ID: <20200831200849.GD8670@sasha-vm>
References: <1598867905173168@kroah.com>
 <c1700041-1d6d-030e-b249-7c67cc96ac0e@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <c1700041-1d6d-030e-b249-7c67cc96ac0e@kernel.dk>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Aug 31, 2020 at 07:45:49AM -0600, Jens Axboe wrote:
>On 8/31/20 3:58 AM, gregkh@linuxfoundation.org wrote:
>>
>> The patch below does not apply to the 5.8-stable tree.
>> If someone wants it applied there, or to any other stable or longterm
>> tree, then please email the backport, including the original git commit
>> id to <stable@vger.kernel.org>.
>
>Here's a backport:

I've queued up this and the other two backports. Thanks!

-- 
Thanks,
Sasha
