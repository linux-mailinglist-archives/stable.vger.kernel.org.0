Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8462F2D5B04
	for <lists+stable@lfdr.de>; Thu, 10 Dec 2020 13:56:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726439AbgLJM4Z (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 10 Dec 2020 07:56:25 -0500
Received: from mail.kernel.org ([198.145.29.99]:47170 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387506AbgLJM4P (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 10 Dec 2020 07:56:15 -0500
Date:   Thu, 10 Dec 2020 13:56:50 +0100
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1607604935;
        bh=pVcCSiBLIZxTrarAIbVfE/y5QBFQ9zTia/5AhHvoR78=;
        h=From:To:Cc:Subject:References:In-Reply-To:From;
        b=gXWYLqgFjsYiYSAD/STbCRQH8NWGw+CDVvZUpXu2Bw180b12jCKMuHjgbmwqYFdgO
         dVDRsGvxxJgwJhcinGwuqkkB12al9yctmVFiao8I3C49c9CJH0hUYvXwP+mvrOLINO
         OwLq6eaf/NuU4FdFw0Unf6al5EOTbpMv8l2UUXEQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Sudip Mukherjee <sudipm.mukherjee@gmail.com>
Cc:     sashal@kernel.org, stable@vger.kernel.org
Subject: Re: request for 5.9/5.4-stable: 4f134b89a24b ("lib/syscall: fix
 syscall registers retrieval on 32-bit platforms")
Message-ID: <X9IbEj3vSK2U4sz4@kroah.com>
References: <20201210121947.shepiv5mqewbtdzu@debian>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201210121947.shepiv5mqewbtdzu@debian>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Dec 10, 2020 at 12:19:47PM +0000, Sudip Mukherjee wrote:
> Hi Greg, Sasha,
> 
> 4f134b89a24b ("lib/syscall: fix syscall registers retrieval on 32-bit platforms")
> is not marked for stable but I guess it should be in stable.
> Applies cleanly to 5.9-stable and 5.4-stable.

Yes, it's on my list of "patches to queue up", sorry for the delay.

thanks,

greg k-h
