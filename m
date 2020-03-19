Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 795B918C042
	for <lists+stable@lfdr.de>; Thu, 19 Mar 2020 20:28:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726934AbgCST2C (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 19 Mar 2020 15:28:02 -0400
Received: from imap3.hz.codethink.co.uk ([176.9.8.87]:59188 "EHLO
        imap3.hz.codethink.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726785AbgCST2C (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 19 Mar 2020 15:28:02 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126] helo=xylophone)
        by imap3.hz.codethink.co.uk with esmtpsa  (Exim 4.92 #3 (Debian))
        id 1jF0ph-0007ul-Eo; Thu, 19 Mar 2020 19:27:57 +0000
Message-ID: <500c8174c171378e8b6802ad70b4bf5563b3fab0.camel@codethink.co.uk>
Subject: Re: [stable] locks: fix a potential use-after-free problem when
 wakeup a waiter
From:   Ben Hutchings <ben.hutchings@codethink.co.uk>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>
Cc:     Sasha Levin <Alexander.Levin@microsoft.com>,
        stable <stable@vger.kernel.org>
Date:   Thu, 19 Mar 2020 19:27:56 +0000
In-Reply-To: <20200319063742.GB3274814@kroah.com>
References: <2082b1e11fdbf3b64f0da022fb15a8b615c3678c.camel@codethink.co.uk>
         <20200318222906.GJ4189@sasha-vm> <20200319063742.GB3274814@kroah.com>
Organization: Codethink Ltd.
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.30.5-1.1 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, 2020-03-19 at 07:37 +0100, Greg Kroah-Hartman wrote:
> On Wed, Mar 18, 2020 at 06:29:06PM -0400, Sasha Levin wrote:
> > On Wed, Mar 18, 2020 at 10:09:20PM +0000, Ben Hutchings wrote:
> > > This commit (included in 5.6-rc5) seems to be needed for 5.4 and 5.5
> > > branches:
> > > 
> > > commit 6d390e4b5d48ec03bb87e63cf0a2bff5f4e116da
> > > Author: yangerkun <yangerkun@huawei.com>
> > > Date:   Wed Mar 4 15:25:56 2020 +0800
> > > 
> > >    locks: fix a potential use-after-free problem when wakeup a waiter
> > 
> > I've queued it up for 5.5 and 5.4, thanks!
> > 
> > > I'm a bit surprised that it hasn't yet been applied, while some fixes
> > > from 5.6-rc6 have.
> > 
> > Greg, I wonder if it makes sense to have you push a "Greg is here
> > --->" "bookmark" in the form of a tag/branch on linux-stable-rc.git? at
> > the very least it'll make it easy to see if something was missed or
> > still waiting in the queue.
> 
> To quote Jeff Layton:
> 
> 	Hi Greg, there is a performance regression with this patch. We're
> 	sorting through potential ways to address it at the moment, but you may
> 	want to hold off until we have a fix for that merged.
> 	
> 	Sorry for the hassle!
> 
> Which is why I dropped it for now.
> 
> I'll go drop it again :)

I didn't see any mention of this on the stable list though.
I also don't think that a performance regression outweighs the
seriousness of the bug being fixed.

Ben.

-- 
Ben Hutchings, Software Developer                         Codethink Ltd
https://www.codethink.co.uk/                 Dale House, 35 Dale Street
                                     Manchester, M1 2HF, United Kingdom

