Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7368218F6C
	for <lists+stable@lfdr.de>; Thu,  9 May 2019 19:41:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726620AbfEIRlu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 9 May 2019 13:41:50 -0400
Received: from mail.kernel.org ([198.145.29.99]:36296 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726576AbfEIRlu (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 9 May 2019 13:41:50 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 38D1120675;
        Thu,  9 May 2019 17:41:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1557423709;
        bh=ES/xr8fFDSwHRvHasEo0bgEx+FZPlfyiAM+2CUsY9OA=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=uccyXC+BzMM4uJkqkR6sAKQy0ByCs4NbEnzmK5+ahJG2Cm1Q8dcJHTOcRVOp4HGe0
         BLoPlqCMciuiURFOwz2H8XtulCIcxk2O0HjUQOzQwwZ23K71+xJtAlXl7fjLuUUuwq
         dPDSegMMQ5Vv0fRV4lPyQCf6PUVATPAmBXllf5z8=
Date:   Thu, 9 May 2019 19:41:47 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Ross Zwisler <zwisler@chromium.org>
Cc:     Sasha Levin <sashal@kernel.org>, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org, Ross Zwisler <zwisler@google.com>,
        Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>,
        Mark Brown <broonie@kernel.org>
Subject: Re: [linux-4.4.y PATCH] ASoC: Intel: avoid Oops if DMA setup fails
Message-ID: <20190509174147.GA17342@kroah.com>
References: <20190429182710.GA209252@google.com>
 <20190503194503.77923-1-zwisler@google.com>
 <20190505131553.GB25640@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190505131553.GB25640@kroah.com>
User-Agent: Mutt/1.11.4 (2019-03-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sun, May 05, 2019 at 03:15:53PM +0200, Greg KH wrote:
> On Fri, May 03, 2019 at 01:45:03PM -0600, Ross Zwisler wrote:
> > From: Ross Zwisler <zwisler@chromium.org>
> > 
> > commit 0efa3334d65b7f421ba12382dfa58f6ff5bf83c4 upstream.
> 
> This commit id is not in Linus's tree :(
> 

Sorry for the noise, I didn't read your note :(
