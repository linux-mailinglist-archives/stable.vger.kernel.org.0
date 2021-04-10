Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A6E3035AD02
	for <lists+stable@lfdr.de>; Sat, 10 Apr 2021 13:39:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234431AbhDJLiN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 10 Apr 2021 07:38:13 -0400
Received: from mail.kernel.org ([198.145.29.99]:50784 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234377AbhDJLiN (ORCPT <rfc822;Stable@vger.kernel.org>);
        Sat, 10 Apr 2021 07:38:13 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4BE34610CF;
        Sat, 10 Apr 2021 11:37:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1618054678;
        bh=H0f0ThPvR8ZQ2jH4I+vTDWlduV2mJF14aBYMvrYkTB4=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=cP+zgurbdDP9cj6UNR5SYQWOCnUrIXJrSXCybkSE0P5+ohtPZTbljA9EQSlY0/zHj
         QBaY8GFP9CFmfap1ggR/K2qg/3iJ6FivqvQjvbuwR2tOuN8QU/LQxwUU4AldYkNIDL
         inLQXhmzqeYs/cDhRnS98uzTLw4XXKMam/eH7kt8=
Date:   Sat, 10 Apr 2021 13:37:56 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Sudip Mukherjee <sudipm.mukherjee@gmail.com>
Cc:     fabrice.gasnier@foss.st.com, Jonathan.Cameron@huawei.com,
        Stable@vger.kernel.org, vilhelm.gray@gmail.com
Subject: Re: FAILED: patch "[PATCH] counter: stm32-timer-cnt: fix ceiling
 miss-alignment with" failed to apply to 5.4-stable tree
Message-ID: <YHGOFJLnztPNXAJd@kroah.com>
References: <161640433820229@kroah.com>
 <YGyI2ICCPj2AJl9a@debian>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YGyI2ICCPj2AJl9a@debian>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Apr 06, 2021 at 05:14:16PM +0100, Sudip Mukherjee wrote:
> Hi Greg,
> 
> On Mon, Mar 22, 2021 at 10:12:18AM +0100, gregkh@linuxfoundation.org wrote:
> > 
> > The patch below does not apply to the 5.4-stable tree.
> > If someone wants it applied there, or to any other stable or longterm
> > tree, then please email the backport, including the original git commit
> > id to <stable@vger.kernel.org>.
> 
> Here is the bakport.

Now queued up, thanks.

greg k-h
