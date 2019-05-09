Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EF442186CB
	for <lists+stable@lfdr.de>; Thu,  9 May 2019 10:31:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725992AbfEIIbA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 9 May 2019 04:31:00 -0400
Received: from mail.kernel.org ([198.145.29.99]:33988 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725991AbfEIIbA (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 9 May 2019 04:31:00 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id BF434208C3;
        Thu,  9 May 2019 08:30:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1557390659;
        bh=ZWC9HUSg0GsRn5dMGP8oFG/5WfKEOsB37vf9vwmzwNU=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=B1QdDFn/Sqpo7gStzBl0yF4T8on/a+uPsUtw0e40aWhFCmMHjXWTv/jy+bBeGcnQX
         AZlHw3r+e66wh4MJ2Ef0LqMMzMQfutiSQ/j4r/pJQIwleLiU+eS+27ciRjGmxOJp/l
         V6TgOoeuxJFwXIQBFV9SaYcYCRPRqfrUv3qVfqZE=
Date:   Thu, 9 May 2019 10:30:56 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Sasha Levin <sashal@kernel.org>
Cc:     Ingo Molnar <mingo@kernel.org>,
        stable kernel team <stable@vger.kernel.org>
Subject: Re: [PATCH] genirq: Prevent use-after-free and work list corruption]
Message-ID: <20190509083056.GA335@kroah.com>
References: <20190507060708.GA75860@gmail.com>
 <20190507062535.GA21061@kroah.com>
 <20190509005237.GP1747@sasha-vm>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190509005237.GP1747@sasha-vm>
User-Agent: Mutt/1.11.4 (2019-03-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, May 08, 2019 at 08:52:37PM -0400, Sasha Levin wrote:
> On Tue, May 07, 2019 at 08:25:35AM +0200, Greg KH wrote:
> > On Tue, May 07, 2019 at 08:07:08AM +0200, Ingo Molnar wrote:
> > > 
> > > Hi Greg,
> > > 
> > > We forgot to mark 59c39840f5abf4a71e1 for -stable, please apply. It
> > > should apply cleanly all the way back to v3.0.
> > 
> > Thanks, will do for the next round of releases after this one.
> 
> I've queued it for all branches.

You forgot the 5.1.y branch :(

Now added there too, thanks.

greg k-h
