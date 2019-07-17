Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0418F6C391
	for <lists+stable@lfdr.de>; Thu, 18 Jul 2019 01:38:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727792AbfGQXiN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 17 Jul 2019 19:38:13 -0400
Received: from mail.kernel.org ([198.145.29.99]:52806 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727653AbfGQXiM (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 17 Jul 2019 19:38:12 -0400
Received: from localhost (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9BDFD20818;
        Wed, 17 Jul 2019 23:38:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1563406691;
        bh=yxNO/Eb686+iPbC8dTMlq1hz3CyvwhzujesAIwhWYX0=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=OOiTzIEotd6i9BSjxsjCVva2wzMhVCwuPLCSjlDQjv/JcN9WggFDTYf0ktAnsgiq+
         ZgyF5jCOcHgI+AP+CqwrOij9O8AArM/R42GbM5cQrymqM3Vps4Wn/WWSxjB9WPIZyR
         +tUXgRNF8RJbF0uIXBNBHOYsamUvbYxWcY7o5mPA=
Date:   Wed, 17 Jul 2019 19:38:10 -0400
From:   Sasha Levin <sashal@kernel.org>
To:     Thomas Gleixner <tglx@linutronix.de>
Cc:     stable@vger.kernel.org
Subject: Re: Backport request
Message-ID: <20190717233810.GC3079@sasha-vm>
References: <alpine.DEB.2.21.1907162318380.1767@nanos.tec.linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.21.1907162318380.1767@nanos.tec.linutronix.de>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Jul 17, 2019 at 12:08:38AM +0200, Thomas Gleixner wrote:
> 4001d8e8762f ("genirq: Delay deactivation in free_irq()")

Thomas, would just this one be relevant for 4.14 (and older)?

--
Thanks,
Sasha
