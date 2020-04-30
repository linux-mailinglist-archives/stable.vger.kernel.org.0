Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4F2A31BF378
	for <lists+stable@lfdr.de>; Thu, 30 Apr 2020 10:49:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726616AbgD3ItT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 30 Apr 2020 04:49:19 -0400
Received: from mail.kernel.org ([198.145.29.99]:38076 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726420AbgD3ItT (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 30 Apr 2020 04:49:19 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6931920787;
        Thu, 30 Apr 2020 08:49:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1588236557;
        bh=J8dfL1puxygVx/IlBM6DbxBoxp2B2lbaeh0Jyf/zt5I=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=lUgdFv3A3wy6Cj/P0sEaQQmV4uf/6P3kcXZ8rX9/GDr5VkbFPSBo+sRbDzL50gNvz
         grVtyzjVTf4taIT/s9ZbxFgeIWE/UgM3KvPoEqaZgNvvKbvgdFMBTVC0D/3hRe0Veu
         aC2Yxj5t8OI6L5lOXN3ZVg3JqAV+B9c2CZXqn2p0=
Date:   Thu, 30 Apr 2020 10:49:15 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Michal Simek <michal.simek@xilinx.com>
Cc:     linux-kernel@vger.kernel.org, monstr@monstr.eu, git@xilinx.com,
        stable@vger.kernel.org,
        Shubhrajyoti Datta <shubhrajyoti.datta@xilinx.com>,
        Jiri Slaby <jslaby@suse.com>,
        linux-arm-kernel@lists.infradead.org, linux-serial@vger.kernel.org
Subject: Re: [PATCH] tty: xilinx_uartps: Add the id to the console
Message-ID: <20200430084915.GD2496467@kroah.com>
References: <06195dc0effe2fb82e264e4faefcfdd6ebc00516.1588234277.git.michal.simek@xilinx.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <06195dc0effe2fb82e264e4faefcfdd6ebc00516.1588234277.git.michal.simek@xilinx.com>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Apr 30, 2020 at 10:11:21AM +0200, Michal Simek wrote:
> From: Shubhrajyoti Datta <shubhrajyoti.datta@xilinx.com>
> 
> Update the console index. Once the serial node is found update it to the
> console index.
> 
> Fixes: 18cc7ac8a28e ("Revert "serial: uartps: Register own uart console and driver structures"")
> Signed-off-by: Shubhrajyoti Datta <shubhrajyoti.datta@xilinx.com>
> Cc: stable <stable@vger.kernel.org>
> Signed-off-by: Michal Simek <michal.simek@xilinx.com>
> ---
> 
> Greg: Would be good if you can take this patch to 5.7 and also to stable
> trees.

WHy?  I don't understand what bug this fixes/resolves, please be much
more descriptive in your changelog text showing this if you wish for it
to be backported to a stable tree.  As it is, this just looks like you
are adding a new feature.

thanks,

greg k-h
