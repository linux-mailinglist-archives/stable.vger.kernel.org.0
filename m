Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7564A32D471
	for <lists+stable@lfdr.de>; Thu,  4 Mar 2021 14:47:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238404AbhCDNq7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 4 Mar 2021 08:46:59 -0500
Received: from mail.kernel.org ([198.145.29.99]:54514 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237864AbhCDNqp (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 4 Mar 2021 08:46:45 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id ED35164F45;
        Thu,  4 Mar 2021 13:46:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614865564;
        bh=uStLyUhWNhdDMx2ZDs6rM4kw9fBh35DMg6kTC+SrY7s=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=ZRUezqyN1ysi7HtF16CF7nuZo6UsGoPaDbTYbYgpGpbVmqzDVHBFKpIvcZ1q65qSM
         ZM8HUea5+V2FKGsb9fHWDtkf+JfNN9cQaeEfel2jc+XfPUE9crlQNkw8chIREWQXz2
         w1RPFbmaDCrgE9/gX4eJ8aJboJhnH8N896kft6YE=
Date:   Thu, 4 Mar 2021 14:46:02 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Jing Xiangfeng <jingxiangfeng@huawei.com>
Cc:     catalin.marinas@arm.com, will@kernel.org,
        akpm@linux-foundation.org, nsaenzjulienne@suse.de,
        paul.walmsley@sifive.com, palmer@dabbelt.com,
        aou@eecs.berkeley.edu, rppt@kernel.org, lorenzo.pieralisi@arm.com,
        guohanjun@huawei.com, sudeep.holla@arm.com, rjw@rjwysocki.net,
        lenb@kernel.org, song.bao.hua@hisilicon.com, ardb@kernel.org,
        anshuman.khandual@arm.com, bhelgaas@google.com, guro@fb.com,
        robh+dt@kernel.org, stable@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, frowand.list@gmail.com,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, linux-riscv@lists.infradead.org,
        wangkefeng.wang@huawei.com
Subject: Re: [PATCH stable v5.10 0/7] arm64: Default to 32-bit wide ZONE_DMA
Message-ID: <YEDkmj6cchMPAq2h@kroah.com>
References: <20210303073319.2215839-1-jingxiangfeng@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210303073319.2215839-1-jingxiangfeng@huawei.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Mar 03, 2021 at 03:33:12PM +0800, Jing Xiangfeng wrote:
> Using two distinct DMA zones turned out to be problematic. Here's an
> attempt go back to a saner default.

What problem does this solve?  How does this fit into the stable kernel
rules?

thanks,

greg k-h
