Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3DEF82ED05C
	for <lists+stable@lfdr.de>; Thu,  7 Jan 2021 14:05:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727413AbhAGNEh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 7 Jan 2021 08:04:37 -0500
Received: from mail.kernel.org ([198.145.29.99]:54462 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727327AbhAGNEh (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 7 Jan 2021 08:04:37 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id B6BB123372;
        Thu,  7 Jan 2021 13:03:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1610024637;
        bh=FAIcxnstFLJsxJXcVOdEddMcKMU4wNCXtz6OaYIyIf8=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=AvYmiJR/bDgVJ8MNNL4W8XJYmKYUPPrWna6Of11uvcJo6uMd0AG55K+tvr+FXDIsm
         7zUFWmKRRG7P0hjq45gAgsB6tR0uqk2WCVjeRnske60Am6ygCdCM/RQnQ3kPC2kaia
         Ef+0PieFX18O9Nt4EzXD00unp5zSoCLDFJQ6m4VQ=
Date:   Thu, 7 Jan 2021 14:05:17 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Guenter Roeck <linux@roeck-us.net>
Cc:     stable <stable@vger.kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: Re: build failures in v4.4.y/v4.9.y stable queues
Message-ID: <X/cHDTpV9ceDDLDu@kroah.com>
References: <701a5cce-ab93-d1b3-1004-d7d15742a715@roeck-us.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <701a5cce-ab93-d1b3-1004-d7d15742a715@roeck-us.net>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Jan 06, 2021 at 05:52:52PM -0800, Guenter Roeck wrote:
> Building s390:defconfig ... failed
> Building s390:allmodconfig ... failed
> Building s390:performance_defconfig ... failed
> 
> --------------
> Error log:
> arch/s390/kernel/smp.c: In function 'cpu_configure_store':
> arch/s390/kernel/smp.c:1009:8: error: implicit declaration of function 'smp_get_base_cpu'
> 
> The problem affects v4.4.y and v4.9.y stable queues.

Thanks for the report, I've dropped the offending patches from the
queues now.

greg k-h
