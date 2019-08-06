Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AB7DE82D41
	for <lists+stable@lfdr.de>; Tue,  6 Aug 2019 09:58:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728843AbfHFH64 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 6 Aug 2019 03:58:56 -0400
Received: from mail.kernel.org ([198.145.29.99]:47134 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728056AbfHFH64 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 6 Aug 2019 03:58:56 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 18FF12070C;
        Tue,  6 Aug 2019 07:58:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1565078335;
        bh=h/SZtPXyoVtslJ/aDAxmxK3G7rUocWNqG9K8r9KAwNM=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Ft2d60yt5RYukvor98l3LO4iOnt5V6kl6XcNkugZHqLca9jwwp57nWooNi9/QcQsK
         j2V707yx+kFTm773Cp/0B7hSI8zSGkzYrf0XJ6vpP7IxJ2AMAsiQfb8FCU1fwB21kt
         TzspB5IIf6Jio1QQTkV0f7/kCRboGJvniAReOSNc=
Date:   Tue, 6 Aug 2019 09:58:53 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     chenzefeng <chenzefeng2@huawei.com>
Cc:     tony.luck@intel.com, fenghua.yu@intel.com,
        linux-ia64@vger.kernel.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
Subject: Re: [PATCH] ia64:unwind: fix double free for mod->arch.init_unw_table
Message-ID: <20190806075853.GA701@kroah.com>
References: <1565077593-72480-1-git-send-email-chenzefeng2@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1565077593-72480-1-git-send-email-chenzefeng2@huawei.com>
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Aug 06, 2019 at 03:46:33PM +0800, chenzefeng wrote:
> The function free_module in file kernel/module.c as follow:
> 
> void free_module(struct module *mod) {
> 	......
> 	module_arch_cleanup(mod);
> 	......
> 	module_arch_freeing_init(mod);
> 	......
> }
> 
> Both module_arch_cleanup and module_arch_freeing_init function
> would free the mod->arch.init_unw_table, which cause double free.
> 
> Here, set mod->arch.init_unw_table = NULL after remove the unwind
> table to avoid double free.
> 
> Signed-off-by: chenzefeng <chenzefeng2@huawei.com>
> ---
>  arch/ia64/kernel/module.c | 8 ++++++--
>  1 file changed, 6 insertions(+), 2 deletions(-)

<formletter>

This is not the correct way to submit patches for inclusion in the
stable kernel tree.  Please read:
    https://www.kernel.org/doc/html/latest/process/stable-kernel-rules.html
for how to do this properly.

</formletter>
