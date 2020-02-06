Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D791B153EE2
	for <lists+stable@lfdr.de>; Thu,  6 Feb 2020 07:49:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727500AbgBFGtO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 6 Feb 2020 01:49:14 -0500
Received: from mail.kernel.org ([198.145.29.99]:39272 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726538AbgBFGtN (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 6 Feb 2020 01:49:13 -0500
Received: from localhost (unknown [213.123.58.114])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id ADE7020720;
        Thu,  6 Feb 2020 06:49:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1580971753;
        bh=1BeRsZ4nTkgf7UvEx0NaXnnJRtfYYwFgl2in/aZ3/Vg=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=s7wFZ2qdF6ecHMieaYTGBMZ3/WKqIjyeF3+WuqKC5MGvyDFBhl6EOYWGER+Y44pMZ
         yGoh2b25P9YMq9ld8nqeBCCK3hEBcbTFp54O2oFZTMvEoh0Wo5C0kezVkX1EkniywU
         z1Uy45eG1hE9RZwLfzpfnVqavXqG3dd1nSGzr4O8=
Date:   Thu, 6 Feb 2020 06:49:10 +0000
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Sasha Levin <sashal@kernel.org>
Cc:     David Miller <davem@davemloft.net>, stable@vger.kernel.org
Subject: Re: [PATCH] Sparc
Message-ID: <20200206064910.GA3238182@kroah.com>
References: <20200205.151110.999222765422116817.davem@davemloft.net>
 <20200206045426.GM31482@sasha-vm>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200206045426.GM31482@sasha-vm>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Feb 05, 2020 at 11:54:26PM -0500, Sasha Levin wrote:
> On Wed, Feb 05, 2020 at 03:11:10PM +0100, David Miller wrote:
> > 
> > Please queue up the attached sparc bug fix for -stable, thanks!
> 
> I've queued it up for all branches, thanks!

You forgot 5.5.y :)

I've added it there now too, thanks.

greg k-h
