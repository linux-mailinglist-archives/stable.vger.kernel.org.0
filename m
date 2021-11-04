Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3362F445492
	for <lists+stable@lfdr.de>; Thu,  4 Nov 2021 15:11:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230420AbhKDOOA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 4 Nov 2021 10:14:00 -0400
Received: from mail.kernel.org ([198.145.29.99]:44378 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230409AbhKDOOA (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 4 Nov 2021 10:14:00 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id D8E93610FD;
        Thu,  4 Nov 2021 14:11:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1636035082;
        bh=p35SIigJNiF6e9y5qVXtm/FlTvAXp+tlaDLlj9sTNvk=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=MWciCWiGSd11dgEmGpMXdoDrTGaplKpV5uguQCuFLPMmZmP0yTXlaZq87zhxZQvpe
         0jSXvsHGxZnAfn2JZaBrclmIC8GzXTq+1f8U21CwGe8rhU9d73WfK/BqW5Uo0kHnxr
         K0esNdlN5CcBq/aZLmkULKb3IYNVNuhk7iOa/KQI=
Date:   Thu, 4 Nov 2021 15:11:19 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     mike.marciniszyn@cornelisnetworks.com
Cc:     stable@vger.kernel.org, linux-rdma@vger.kernel.org
Subject: Re: [PATCH 4.14-stable 0/2] Port upstream patch
Message-ID: <YYPqB/SECFBCrAJ0@kroah.com>
References: <1636034145-7962-1-git-send-email-mike.marciniszyn@cornelisnetworks.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1636034145-7962-1-git-send-email-mike.marciniszyn@cornelisnetworks.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Nov 04, 2021 at 09:55:43AM -0400, mike.marciniszyn@cornelisnetworks.com wrote:
> From: Mike Marciniszyn <mike.marciniszyn@cornelisnetworks.com>
> 
> This series ports upstream commit:
> 
> d39bf40e55e6 ("IB/qib: Protect from buffer overflow in struct qib_user_sdma_pkt fields")
> 
> Gustavo A. R. Silva (1):
>   IB/qib: Use struct_size() helper
> 
> Mike Marciniszyn (1):
>   IB/qib: Protect from buffer overflow in struct qib_user_sdma_pkt
>     fields
> 
>  drivers/infiniband/hw/qib/qib_user_sdma.c | 35 ++++++++++++++++++++++---------
>  1 file changed, 25 insertions(+), 10 deletions(-)

All now queued up, thanks!

greg k-h
