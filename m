Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 182BD296082
	for <lists+stable@lfdr.de>; Thu, 22 Oct 2020 15:57:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2900530AbgJVN5Z (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 22 Oct 2020 09:57:25 -0400
Received: from mail.kernel.org ([198.145.29.99]:36078 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2443798AbgJVN5Z (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 22 Oct 2020 09:57:25 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 10B9F2085B;
        Thu, 22 Oct 2020 13:57:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603375043;
        bh=bKPjkUKQuK42e+zQkxR2JKO0CY2iL+sL+1ptac2lo6g=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=H4UeW7ZXepjo4PME3Em3JRUTomjH6qW64i36v0SqoEUlnQRKSUo5niS3TdIUJlRJE
         ddXO0PrX0KNsSKpCpU23pk3tWKt9t/wKFfDb/lbWzU9q1+MwsemxZ+Nj/SiGDH494v
         tugwsGhmWyyofXS2g8aLTPMx1sqDr7REUrgVXaUQ=
Date:   Thu, 22 Oct 2020 15:57:49 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Ben Hutchings <ben.hutchings@codethink.co.uk>
Cc:     stable <stable@vger.kernel.org>
Subject: Re: [4.4] Fix warnings with KASAN enabled
Message-ID: <20201022135749.GA1799093@kroah.com>
References: <994ec2d7674602c00c9d55d866b8e8ebe6efa253.camel@codethink.co.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <994ec2d7674602c00c9d55d866b8e8ebe6efa253.camel@codethink.co.uk>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Oct 21, 2020 at 10:21:11PM +0100, Ben Hutchings wrote:
> The attached patches fix:
> 
> * KASAN warnings for strscpy()
> * RCU and soft-lockup warnings with CONFIG_KASAN and CONFIG_DEBUG_WX
>   enabled
> 
> All of these are already present in later stable branches.

All now queued up, thanks.

greg k-h
