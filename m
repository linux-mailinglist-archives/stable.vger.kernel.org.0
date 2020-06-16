Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3EFF41FB10D
	for <lists+stable@lfdr.de>; Tue, 16 Jun 2020 14:45:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726261AbgFPMp6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 16 Jun 2020 08:45:58 -0400
Received: from mail.kernel.org ([198.145.29.99]:38236 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725843AbgFPMp6 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 16 Jun 2020 08:45:58 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E7ACC2071A;
        Tue, 16 Jun 2020 12:45:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592311557;
        bh=VSam0rIL1Z9N7gSsqHkmqBvoxS8S2nH1Bqeh9ZRJCes=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=FbzrLvNj2f7py2zr98HJkD0p62tEYfy+H+lVMFG3K91FVVkF9Vrtl+0PmRU6dr12W
         NDlfiS6VCzn+NWy51dW0OjXDKRr35ZWshwMD7Yjg6WdKxJi7CQRRlh9CDe/GxOLA1E
         nLspAzJDSWc30a1P4rradLJg7KGaYnugMSBxV+0U=
Date:   Tue, 16 Jun 2020 14:45:51 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Mattia Dongili <malattia@linux.it>
Cc:     stable@vger.kernel.org
Subject: Re: sony-laptop fix for 5.6 and 5.7
Message-ID: <20200616124551.GA3867993@kroah.com>
References: <20200607035055.GA8646@taihen.jp>
 <20200616121601.GC3542686@kroah.com>
 <20200616123031.GA5705@taihen.jp>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200616123031.GA5705@taihen.jp>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Jun 16, 2020 at 09:30:31PM +0900, Mattia Dongili wrote:
> On Tue, Jun 16, 2020 at 02:16:01PM +0200, Greg KH wrote:
> > On Sun, Jun 07, 2020 at 12:50:55PM +0900, Mattia Dongili wrote:
> > > commit 95e2c5b0fd6d7a022f37e7c762ea093aba7b8e34 upstream
> > 
> > I do not see that commit id in Linus's tree.  Are you sure it is
> > correct?
> 
> Heh, no. I didn't rebase my local tree... rookie mistake.
> It should be 47828d22539f76c8c9dcf2a55f18ea3a8039d8ef.
> 
> I noticed that Sasha Levin autoselected for 5.7 both the patches for
> sony-laptop related to the ACPI breakage.
> So they are only missing in 5.6 at this point and it's worth getting
> both even though only 47828d22539f should be sufficient.
> 
> The two commit ids that were picked up for 5.7 are:
> 
> [ Upstream commit 47828d22539f76c8c9dcf2a55f18ea3a8039d8ef ]
> [ Upstream commit 476d60b1b4c8a2b14a53ef9b772058f35e604661 ]

Thanks, I'll go queue those up now.

greg k-h
