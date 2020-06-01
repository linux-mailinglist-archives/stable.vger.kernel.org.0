Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B8E251EA26F
	for <lists+stable@lfdr.de>; Mon,  1 Jun 2020 13:11:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726067AbgFALLK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Jun 2020 07:11:10 -0400
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:35513 "EHLO
        out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725946AbgFALLK (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 1 Jun 2020 07:11:10 -0400
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
        by mailout.nyi.internal (Postfix) with ESMTP id 07C1D5C0035;
        Mon,  1 Jun 2020 07:11:08 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute1.internal (MEProxy); Mon, 01 Jun 2020 07:11:08 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kroah.com; h=
        date:from:to:cc:subject:message-id:references:mime-version
        :content-type:in-reply-to; s=fm3; bh=3XvqIZoNbkcvmPOyxJdZmpK2ijZ
        lRphPyOlcJMHTT+Q=; b=JJ/TQUxpepzueCA1KYXlq6WDfiutndE/JCfQXK3I72O
        5/VL95WRTtP49v7SVoadRP8EA2QkgJKxSubKRa2AAGrBZJudSLK9Tz5Dgy3Xe3yi
        JkP01TXJAfsvEkjMa67DyvZS4n/uv90E1itX404wsSTGISZhJJQa/7GCcIPDwtxO
        yefM1FNBrs0+dkXzQHPoAg1DyBXb7HBMEXJYW94P/4CaQpE0XIMQxhkE83ljKCaK
        E8Ah8TwwvBDFgD9kF/ajuyl0oe8Dn8Ly2SuqfkGF1CcQtbMuXHNvpv2mVYKWRSBs
        IRtJXOGDTQORxQFKRcZ/VWor/HvnOEm2U2gTzPm8/ig==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=3XvqIZ
        oNbkcvmPOyxJdZmpK2ijZlRphPyOlcJMHTT+Q=; b=yhrpZBt6qEtxPMSUBwZAuU
        05+EAmZxIVtvDR/dIdynQb5GNs6PEBFb3PPKAnofj4iZSU69xXCsqBhQkz9rFPXc
        Pc33zztT34lbQpQVHz1Y7PZ0RWddOfdBYX50KDzAFXPMAuxcpnSPmaJibGeDTHSs
        AW+DjUa1/LPYIGAxzE1GbDMmImB3H5luelfIG6ba0+s+7VwhvgqjtlIDUMdZ56xZ
        ZGxbl76b/8WeyWNKd4nrOHMYjEZAYpCxd+jByWgDpXToDpCewoh9kH2sTzi3fjdQ
        m31yOWvfU4hpKjcLHOsjd1Z4rI/Y6m3q+aKjGz9OjzKp0yRuFFpWf0Se7FkmjjRA
        ==
X-ME-Sender: <xms:S-LUXgTq3hMiiDPpyldzfyqdHzkFBSrL3UOftoV114FgSJMxama64A>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduhedrudefhedgfedtucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhepfffhvffukfhfgggtuggjsehttdertddttddvnecuhfhrohhmpefirhgvghcu
    mffjuceoghhrvghgsehkrhhorghhrdgtohhmqeenucggtffrrghtthgvrhhnpeeuleeltd
    ehkeeltefhleduuddvhfffuedvffduveegheekgeeiffevheegfeetgfenucffohhmrghi
    nhepkhgvrhhnvghlrdhorhhgnecukfhppeekfedrkeeirdekledruddtjeenucevlhhush
    htvghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpehgrhgvgheskhhrohgr
    hhdrtghomh
X-ME-Proxy: <xmx:S-LUXtxXzzebuxxWcVLqwmkqKjqR3ausMtPdxaLdzklf3NSISk5nbQ>
    <xmx:S-LUXt1oaMrWUFlOVCHW8v9gQ2JG9xIEavF9RembbNvwMgcAceTZ1w>
    <xmx:S-LUXkCgSpPOaD3v9WjBoi6cOUc0cOzLLASUeNp4R86aa1UtnDfsww>
    <xmx:TOLUXnYdFNvio5rOs8Dy0_sZ9XczUptnQ28w6Z30zKv7epBkA-lBLQ>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id 2BA463060F09;
        Mon,  1 Jun 2020 07:11:07 -0400 (EDT)
Date:   Mon, 1 Jun 2020 13:11:05 +0200
From:   Greg KH <greg@kroah.com>
To:     Sarthak Garg <sartgarg@codeaurora.org>
Cc:     stable@vger.kernel.org, adrian.hunter@intel.com,
        ulf.hansson@linaro.org, vbadigan@codeaurora.org,
        stummala@codeaurora.org, linux-mmc@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org
Subject: Re: [4.19.124 V1] mmc: core: Fix recursive locking issue in CQE
 recovery path
Message-ID: <20200601111105.GC124421@kroah.com>
References: <1590581942-24283-1-git-send-email-sartgarg@codeaurora.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1590581942-24283-1-git-send-email-sartgarg@codeaurora.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, May 27, 2020 at 05:49:02PM +0530, Sarthak Garg wrote:
> [ Upstream commit 39a22f73744d5baee30b5f134ae2e30b668b66ed ]
> 
> Consider the following stack trace
> 
> -001|raw_spin_lock_irqsave
> -002|mmc_blk_cqe_complete_rq
> -003|__blk_mq_complete_request(inline)
> -003|blk_mq_complete_request(rq)
> -004|mmc_cqe_timed_out(inline)
> -004|mmc_mq_timed_out
> 
> mmc_mq_timed_out acquires the queue_lock for the first
> time. The mmc_blk_cqe_complete_rq function also tries to acquire
> the same queue lock resulting in recursive locking where the task
> is spinning for the same lock which it has already acquired leading
> to watchdog bark.
> 
> Fix this issue with the lock only for the required critical section.
> 
> Cc: <stable@vger.kernel.org>
> Fixes: 1e8e55b67030 ("mmc: block: Add CQE support")
> Suggested-by: Sahitya Tummala <stummala@codeaurora.org>
> Signed-off-by: Sarthak Garg <sartgarg@codeaurora.org>
> Acked-by: Adrian Hunter <adrian.hunter@intel.com>
> Link: https://lore.kernel.org/r/1588868135-31783-1-git-send-email-vbadigan@codeaurora.org
> Signed-off-by: Ulf Hansson <ulf.hansson@linaro.org>
> ---

Thanks for the backport, now queued up.

greg k-h
