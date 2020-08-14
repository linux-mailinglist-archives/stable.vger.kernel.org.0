Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BB00C244CE2
	for <lists+stable@lfdr.de>; Fri, 14 Aug 2020 18:43:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726658AbgHNQnA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 14 Aug 2020 12:43:00 -0400
Received: from mail.kernel.org ([198.145.29.99]:36864 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726641AbgHNQm7 (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 14 Aug 2020 12:42:59 -0400
Received: from localhost (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4B65120829;
        Fri, 14 Aug 2020 16:42:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597423379;
        bh=a8FLIpjrmfbRA1D09JLqP+LW8w6HDkXgrSRJmi7Ljvs=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=I7lnfUuNq5dixgfOb90O7bN4R3V/Weco0OkW4Cqlif7N+Rs+s8yczaDwAzSaogj/L
         jTxXsDoATaIixiz1EVM8ayb4qOYwaa2//pjW4zQ0iFjfBGsIpYVza3dL7r2qAl6wqP
         1KdKPatygnQhXAWCqZJp9oEupIQF4EIaDOeLPjHA=
Date:   Fri, 14 Aug 2020 12:42:58 -0400
From:   Sasha Levin <sashal@kernel.org>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     stable@vger.kernel.org
Subject: Re: Fwd: [PATCH] fs/io_uring.c: Fix uninitialized variable is
 referenced in io_submit_sqe
Message-ID: <20200814164258.GS2975990@sasha-vm>
References: <20200813065644.GA91891@ubuntu>
 <d62db5aa-c821-367b-6188-e9dc9bd1a0f0@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <d62db5aa-c821-367b-6188-e9dc9bd1a0f0@kernel.dk>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Aug 13, 2020 at 09:11:37AM -0600, Jens Axboe wrote:
>Hi,
>
>Can you queue this up for 5.4 as well? Thanks!

Queued up, thanks!

-- 
Thanks,
Sasha
