Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7EF1D1AB53C
	for <lists+stable@lfdr.de>; Thu, 16 Apr 2020 03:08:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729471AbgDPBI1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 15 Apr 2020 21:08:27 -0400
Received: from mail.kernel.org ([198.145.29.99]:44748 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2406125AbgDPBIX (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 15 Apr 2020 21:08:23 -0400
Received: from localhost (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7A3E2206A2;
        Thu, 16 Apr 2020 01:08:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1586999302;
        bh=o3QpDloB0ek2Ef6CmmGFpHYp9oMn7Ioqbg3mRjudu1w=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=fkYUNZjfxGn2BPuGcqvqlfXPD/+TKlgMSGi8eQCYAhgPSTw5YCnx3VgYaBOjvwqqJ
         v9QLg/MZJ2+58QdvndalFhR61eRZKxiWjqGaW9FYyxiGP5PWt4TNBCYFl+DMTlsBN2
         UzRPeyVGdfihO8HdflcpLPlzOdrqCq0vlWN5k6Yg=
Date:   Wed, 15 Apr 2020 21:08:21 -0400
From:   Sasha Levin <sashal@kernel.org>
To:     gregkh@linuxfoundation.org
Cc:     ntsironis@arrikto.com, snitzer@redhat.com, stable@vger.kernel.org
Subject: Re: FAILED: patch "[PATCH] dm clone: Add missing casts to prevent
 overflows and data" failed to apply to 5.4-stable tree
Message-ID: <20200416010821.GQ1068@sasha-vm>
References: <15869486198643@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <15869486198643@kroah.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Apr 15, 2020 at 01:03:39PM +0200, gregkh@linuxfoundation.org wrote:
>
>The patch below does not apply to the 5.4-stable tree.
>If someone wants it applied there, or to any other stable or longterm
>tree, then please email the backport, including the original git commit
>id to <stable@vger.kernel.org>.
>
>thanks,
>
>greg k-h
>
>------------------ original commit in Linus's tree ------------------
>
>From 9fc06ff56845cc5ccafec52f545fc2e08d22f849 Mon Sep 17 00:00:00 2001
>From: Nikos Tsironis <ntsironis@arrikto.com>
>Date: Fri, 27 Mar 2020 16:01:10 +0200
>Subject: [PATCH] dm clone: Add missing casts to prevent overflows and data
> corruption
>
>Add missing casts when converting from regions to sectors.
>
>In case BITS_PER_LONG == 32, the lack of the appropriate casts can lead
>to overflows and miscalculation of the device sector.
>
>As a result, we could end up discarding and/or copying the wrong parts
>of the device, thus corrupting the device's data.
>
>Fixes: 7431b7835f55 ("dm: add clone target")
>Cc: stable@vger.kernel.org # v5.4+
>Signed-off-by: Nikos Tsironis <ntsironis@arrikto.com>
>Signed-off-by: Mike Snitzer <snitzer@redhat.com>

Looks like addressing the other dm patches made this one apply/build as
well.

-- 
Thanks,
Sasha
