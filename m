Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 541EB1C700
	for <lists+stable@lfdr.de>; Tue, 14 May 2019 12:26:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726075AbfENK0u (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 14 May 2019 06:26:50 -0400
Received: from mail.kernel.org ([198.145.29.99]:39052 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725881AbfENK0u (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 14 May 2019 06:26:50 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 29C2F20881;
        Tue, 14 May 2019 10:26:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1557829609;
        bh=S4RZ/ySRSAyhIk7dfTuvbWvBRk7reLznKFlzKmwNNgA=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=jDIIfR9Yle6VsiyfN3Y1IAX5fnmL21z7sueKvJLDMzwgTEhNAZqOfcvWTokz6yjLM
         XPjtG3+1Q30qVZ+FWE06T63istOaDfx+d8NIhKW3XxT3ooEdgd0qPMT5/vIeypwnVO
         sexE65McNhtSeOc4Wj+wX5UsYEcNIYaVG0jjhTfI=
Date:   Tue, 14 May 2019 12:26:45 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Ritesh Raj Sarraf <rrs@debian.org>
Cc:     stable@vger.kernel.org, debian-kernel@lists.debian.org,
        Ritesh Raj Sarraf <rrs@researchut.com>,
        Richard Weinberger <richard@nod.at>
Subject: Re: [PATCH] um: Don't hardcode path as it is architecture dependent
Message-ID: <20190514102645.GA6845@kroah.com>
References: <20190514101656.10228-1-rrs@debian.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190514101656.10228-1-rrs@debian.org>
User-Agent: Mutt/1.11.4 (2019-03-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, May 14, 2019 at 03:46:57PM +0530, Ritesh Raj Sarraf wrote:
> Dear Stable Team,
> Request for inclusion into the stable branches of Linux. This change
> went into 4.20 but 4.19 is the LTS release that many of the Linux
> Vendors are rebasing on. Hence, it'd be nice to see this part of the LTS
> releases, at least 4.19.
> 
> 
> The current code fails to run on amd64 because of hardcoded reference to
> i386
> 
> Signed-off-by: Ritesh Raj Sarraf <rrs@researchut.com>
> Signed-off-by: Richard Weinberger <richard@nod.at>
> ---
>  arch/um/drivers/port_user.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)

What is the git commit id of this patch in Linus's tree?

thanks,

greg k-h
