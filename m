Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 164701BF3E5
	for <lists+stable@lfdr.de>; Thu, 30 Apr 2020 11:14:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726378AbgD3JOJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 30 Apr 2020 05:14:09 -0400
Received: from mail.kernel.org ([198.145.29.99]:49312 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726358AbgD3JOJ (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 30 Apr 2020 05:14:09 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id CB788214D8;
        Thu, 30 Apr 2020 09:14:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1588238048;
        bh=mSje/NaSb9e4Wew2kwalY+57dPnZ2IJf9lAYF7I3jc0=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=ao/FedAMWY+aX8J/dZfdmA2hgqgXRMweORZ0QV8I8xlvy+c6XrcdGureYPxLrF9my
         UQd34+pgCn719tmoppczyI3PDrT8z7eh4cQgV+iCUP8Bpj48xRO1G4M7pwcrs88Dqw
         kA4xojKW05iPNrpnQFds31sG2sFfTj9cds4PcpgU=
Date:   Thu, 30 Apr 2020 11:14:05 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Guenter Roeck <linux@roeck-us.net>
Cc:     stable@vger.kernel.org, Sasha Levin <sashal@kernel.org>
Subject: Re: Commit ab6f762f0f5 ("printk: queue wake_up_klogd irq_work only
 if per-CPU areas are ready") for v5.4.y/v5.6.y
Message-ID: <20200430091405.GA2503105@kroah.com>
References: <20200429162510.GA40432@roeck-us.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200429162510.GA40432@roeck-us.net>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Apr 29, 2020 at 09:25:10AM -0700, Guenter Roeck wrote:
> Hi,
> 
> commit ab6f762f0f53 ("printk: queue wake_up_klogd irq_work only if per-CPU
> areas are ready") fixes a critical problem introduced with commit
> 1b710b1b10ef ("char/random: silence a lockdep splat with printk()").
> Since commit 1b710b1b10ef has been applied to v5.4.y, commit ab6f762f0f53
> needs to be applied as well.
> 
> An alternative might be to revert commit 1b710b1b10ef from v5.4.y, as
> it was done for older kernel branches. However, we found that ab6f762f0f53
> applies cleanly to v5.4.y and fixes the problem, so applying the fix
> is probably a better solution.
> 
> Commit ab6f762f0f53 also needs to be applied to v5.6.y.

I have applied it to 5.4.y and 5.6.y now, thanks.

greg k-h
