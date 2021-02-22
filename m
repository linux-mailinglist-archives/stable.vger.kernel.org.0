Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1EB323213F2
	for <lists+stable@lfdr.de>; Mon, 22 Feb 2021 11:17:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230403AbhBVKQx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 22 Feb 2021 05:16:53 -0500
Received: from mail.kernel.org ([198.145.29.99]:55678 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230312AbhBVKQt (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 22 Feb 2021 05:16:49 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1162E64E25;
        Mon, 22 Feb 2021 10:16:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1613988968;
        bh=O0NvwfBKkS0RnKoR4ARbDP43jooN9w/n0isV/TdnQVk=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=zEMZMb9NrGtQGKSt52jxbjiK0ZZTsrOnedUNufG9wbMEMgISCCazwD96jny7hfuA4
         +EiFzYvD5Zn8IlIsI2W/VgvyQRQ7QThsYNlyR0GLZod/FobA8dtKrapjOxj8hsBSmc
         mCL6uwkdDEDl9hYsDhrVlKJOCKNt2MhPHovTW/CU=
Date:   Mon, 22 Feb 2021 11:16:06 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Xiaoming Ni <nixiaoming@huawei.com>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        sashal@kernel.org, tglx@linutronix.de, wangle6@huawei.com,
        zhengyejian1@huawei.com
Subject: Re: [PATCH stable-rc queue/4.9 1/1] futex: Provide distinct return
 value when owner is exiting
Message-ID: <YDOEZhmKqjTVxtMn@kroah.com>
References: <20210222070328.102384-1-nixiaoming@huawei.com>
 <20210222070328.102384-2-nixiaoming@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210222070328.102384-2-nixiaoming@huawei.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Feb 22, 2021 at 03:03:28PM +0800, Xiaoming Ni wrote:
> From: Thomas Gleixner <tglx@linutronix.de>
> 
> commit ac31c7ff8624409ba3c4901df9237a616c187a5d upstream.

This commit is already in the 4.9 tree.  If the backport was incorrect,
say that here, and describe what went wrong and why this commit fixes
it.

Also state what commit this fixes as well, otherwise this changelog just
looks like it is being applied again to the tree, which doesn't make
much sense.

thanks,

greg k-h
