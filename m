Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 94925D040F
	for <lists+stable@lfdr.de>; Wed,  9 Oct 2019 01:25:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726336AbfJHXZg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 8 Oct 2019 19:25:36 -0400
Received: from mail.kernel.org ([198.145.29.99]:43946 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725908AbfJHXZf (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 8 Oct 2019 19:25:35 -0400
Received: from localhost (unknown [131.107.159.163])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8D77A2054F;
        Tue,  8 Oct 2019 23:25:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1570577135;
        bh=RHivqV1pFqHavZhUoxDO2P7k4DZIgA1xhOkdJ4KoJnk=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=MqImylbMBcKl6dOwH0rQZUcl25bx4gWghColmh5p49VpqJ9Y9BfkQsF69AbqWA6bN
         5oFT3OqKuXJIrGFh9Nb/vyTI8+wIZDM3DB4TqQYEAefnEVym2KvzKuD2NvXvddvjHN
         0qDC26cRXz56j5H86V2XtlS+cmqKfF6y4O4jRkqc=
Date:   Tue, 8 Oct 2019 19:25:35 -0400
From:   Sasha Levin <sashal@kernel.org>
To:     gregkh@linuxfoundation.org
Cc:     decui@microsoft.com, lorenzo.pieralisi@arm.com,
        stable@vger.kernel.org
Subject: Re: FAILED: patch "[PATCH] PCI: hv: Avoid use of
 hv_pci_dev->pci_slot after freeing it" failed to apply to 4.19-stable tree
Message-ID: <20191008232535.GL1396@sasha-vm>
References: <157055512417249@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <157055512417249@kroah.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Oct 08, 2019 at 07:18:44PM +0200, gregkh@linuxfoundation.org wrote:
>
>The patch below does not apply to the 4.19-stable tree.
>If someone wants it applied there, or to any other stable or longterm
>tree, then please email the backport, including the original git commit
>id to <stable@vger.kernel.org>.
>
>thanks,
>
>greg k-h
>
>------------------ original commit in Linus's tree ------------------
>
>From 533ca1feed98b0bf024779a14760694c7cb4d431 Mon Sep 17 00:00:00 2001
>From: Dexuan Cui <decui@microsoft.com>
>Date: Fri, 2 Aug 2019 22:50:20 +0000
>Subject: [PATCH] PCI: hv: Avoid use of hv_pci_dev->pci_slot after freeing it
>
>The slot must be removed before the pci_dev is removed, otherwise a panic
>can happen due to use-after-free.
>
>Fixes: 15becc2b56c6 ("PCI: hv: Add hv_pci_remove_slots() when we unload the driver")
>Signed-off-by: Dexuan Cui <decui@microsoft.com>
>Signed-off-by: Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>
>Cc: stable@vger.kernel.org

Doesn't look like it's relevant for <=4.19 .

-- 
Thanks,
Sasha
