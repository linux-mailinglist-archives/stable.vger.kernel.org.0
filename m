Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F29802FB66
	for <lists+stable@lfdr.de>; Thu, 30 May 2019 14:05:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726994AbfE3MFk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 30 May 2019 08:05:40 -0400
Received: from mail.kernel.org ([198.145.29.99]:43976 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726806AbfE3MFk (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 30 May 2019 08:05:40 -0400
Received: from localhost (ip67-88-213-2.z213-88-67.customer.algx.net [67.88.213.2])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 551F82437C;
        Thu, 30 May 2019 12:05:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1559217939;
        bh=pp1hvMzKCMB9bjdex9motvDpcBZpEz3b1wQNmSJGjWw=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=PgP1ep0eqHY7WDt7cC6k5oF2hPmgLAQIye0U1cQj6B3wmTzW1E/3G4eo3Xb05YgAB
         86OxJkDAzQIl5VXc/546x3Z6qhJZy8DR+RnB7gnphuwmY6Fx7OEeQuTSWEuwP0bny0
         VifmYN/1ncF++9A8xBd9PVJrO5Jm3H8IC8es4PqA=
Date:   Thu, 30 May 2019 05:05:39 -0700
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Ben Hutchings <ben.hutchings@codethink.co.uk>
Cc:     Sasha Levin <Alexander.Levin@microsoft.com>,
        stable <stable@vger.kernel.org>
Subject: Re: [4.9] Security fixes
Message-ID: <20190530120539.GA16049@kroah.com>
References: <1559217157.2631.17.camel@codethink.co.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1559217157.2631.17.camel@codethink.co.uk>
User-Agent: Mutt/1.12.0 (2019-05-25)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, May 30, 2019 at 12:52:37PM +0100, Ben Hutchings wrote:
> I've attached the following fixes to 4.9, as an mbox:
> 
> - brcmfmac: add length checks in scheduled scan result handler
> - brcmfmac: assure SSID length from firmware is limited
> - brcmfmac: add subtype check for event handling in data path
> - binder: Replace "%p" with "%pK" for stable
> - binder: replace "%p" with "%pK"
> - fs: prevent page refcount overflow in pipe_buf_get
> - mm, gup: remove broken VM_BUG_ON_PAGE compound check for hugepages
> - mm, gup: ensure real head page is ref-counted when using hugepages
> - mm: prevent get_user_pages() from overflowing page refcount
> - mm: make page ref count overflow check tighter and more explicit
> - coredump: fix race condition between mmget_not_zero()/get_task_mm() and core dumping
> 
> The first two "mm, gup" commits might not be strictly security fixes
> but the next one depends on them.

Thanks for these, I'll queue them up after the current kernels out for
-rc is released.

greg k-h
