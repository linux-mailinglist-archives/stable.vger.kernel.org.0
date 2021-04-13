Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D274B35DC3E
	for <lists+stable@lfdr.de>; Tue, 13 Apr 2021 12:11:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230163AbhDMKLf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 13 Apr 2021 06:11:35 -0400
Received: from mail.kernel.org ([198.145.29.99]:41740 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229835AbhDMKLd (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 13 Apr 2021 06:11:33 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 71BA4613B2;
        Tue, 13 Apr 2021 10:11:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1618308669;
        bh=/D/oYhNB0J0V0t5MY6qpxHqiR8LW5iJBR05naXme4xc=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=LnhjtBAmw/hUajpQgwxwyoNef5Rg/zWYFPdcE25qbmfEBHxP6nr3GxxTtRW2oN7wg
         xBx34SZ3722MvK1R6uSsIoB+0U5KTg2dUbdCTZYjrQdhdaS4JaN5nL0e/BYS1LTHIC
         ilHHpcTOgn6xbx5ASVJ83OlkrvOF5CL8tkUmJZVM=
Date:   Tue, 13 Apr 2021 12:11:07 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Prike Liang <Prike.Liang@amd.com>
Cc:     linux-nvme@lists.infradead.org, kbusch@kernel.org,
        Chaitanya.Kulkarni@wdc.com, stable@vger.kernel.org,
        Shyam-sundar.S-k@amd.com, Alexander.Deucher@amd.com
Subject: Re: [PATCH] nvme: put some AMD PCIE downstream NVME device to simple
 suspend/resume path
Message-ID: <YHVuOwc4KlF6Qvg7@kroah.com>
References: <1618308289-12929-1-git-send-email-Prike.Liang@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1618308289-12929-1-git-send-email-Prike.Liang@amd.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Apr 13, 2021 at 06:04:49PM +0800, Prike Liang wrote:
> The NVME device pluged in some AMD PCIE root port will resume timeout
> from s2idle which caused by NVME power CFG lost in the SMU FW restore.
> This issue can be workaround by using PCIe power set with simple
> suspend/resume process path instead of APST. In the onwards ASIC will
> try do the NVME shutdown save and restore in the BIOS and still need PCIe
> power setting to resume from RTD3 for s2idle.
> 
> Signed-off-by: Prike Liang <Prike.Liang@amd.com>
> Signed-off-by: Shyam Sundar S K <Shyam-sundar.S-k@amd.com>
> Reviewed-by: Chaitanya Kulkarni <chaitanya.kulkarni@wdc.com>
> Cc: <stable@vger.kernel.org> # 5.11+
> ---
>  drivers/nvme/host/pci.c |  5 +++++
>  drivers/pci/quirks.c    | 10 ++++++++++
>  include/linux/pci.h     |  2 ++
>  3 files changed, 17 insertions(+)

Hi,

This is the friendly patch-bot of Greg Kroah-Hartman.  You have sent him
a patch that has triggered this response.  He used to manually respond
to these common problems, but in order to save his sanity (he kept
writing the same thing over and over, yet to different people), I was
created.  Hopefully you will not take offence and will fix the problem
in your patch and resubmit it so that it can be accepted into the Linux
kernel tree.

You are receiving this message because of the following common error(s)
as indicated below:

- This looks like a new version of a previously submitted patch, but you
  did not list below the --- line any changes from the previous version.
  Please read the section entitled "The canonical patch format" in the
  kernel file, Documentation/SubmittingPatches for what needs to be done
  here to properly describe this.

If you wish to discuss this problem further, or you have questions about
how to resolve this issue, please feel free to respond to this email and
Greg will reply once he has dug out from the pending patches received
from other developers.

thanks,

greg k-h's patch email bot
