Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4048AE6EBE
	for <lists+stable@lfdr.de>; Mon, 28 Oct 2019 10:12:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387432AbfJ1JMK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Oct 2019 05:12:10 -0400
Received: from mail.kernel.org ([198.145.29.99]:35170 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727586AbfJ1JMK (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Oct 2019 05:12:10 -0400
Received: from localhost (unknown [91.217.168.176])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 636F6208C0;
        Mon, 28 Oct 2019 09:12:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1572253930;
        bh=PFvAjNHvWF8pJN19sI/vbfmlvaaIpQsV9Tdjplz1y8E=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=ogRO9auIEgcH1+ZTg82lcFiwXAG+G9d8yp5t9mRYnyDHBI6mW4ITuUfnzDuCq9mha
         2GDKjgidl7maWgUaSMSGeGZriizQoPjR3nR8BXO4dPvxloxneqkOLBneFthRpZ5iJL
         4VlPM71BFJVE6mQ7T+V4kNcKDAnPIusJHX/ecHtQ=
Date:   Mon, 28 Oct 2019 05:12:07 -0400
From:   Sasha Levin <sashal@kernel.org>
To:     gregkh@linuxfoundation.org
Cc:     maz@kernel.org, marc.zyngier@arm.com, stable@vger.kernel.org,
        will@kernel.org
Subject: Re: FAILED: patch "[PATCH] arm64: Avoid Cavium TX2 erratum 219 when
 switching TTBR" failed to apply to 4.19-stable tree
Message-ID: <20191028091207.GL1560@sasha-vm>
References: <157218441316235@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <157218441316235@kroah.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sun, Oct 27, 2019 at 02:53:33PM +0100, gregkh@linuxfoundation.org wrote:
>
>The patch below does not apply to the 4.19-stable tree.
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
>From 9405447ef79bc93101373e130f72e9e6cbf17dbb Mon Sep 17 00:00:00 2001
>From: Marc Zyngier <maz@kernel.org>
>Date: Tue, 9 Apr 2019 16:22:24 +0100
>Subject: [PATCH] arm64: Avoid Cavium TX2 erratum 219 when switching TTBR
>
>As a PRFM instruction racing against a TTBR update can have undesirable
>effects on TX2, NOP-out such PRFM on cores that are affected by
>the TX2-219 erratum.
>
>Cc: <stable@vger.kernel.org>
>Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
>Signed-off-by: Will Deacon <will@kernel.org>

Rather than backporting this, we need to look into backporting the rest
of the errata fixes. I'll look into that...

-- 
Thanks,
Sasha
