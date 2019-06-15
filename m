Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2C05546E84
	for <lists+stable@lfdr.de>; Sat, 15 Jun 2019 07:50:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725830AbfFOFuW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 15 Jun 2019 01:50:22 -0400
Received: from mail.kernel.org ([198.145.29.99]:43334 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725786AbfFOFuW (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 15 Jun 2019 01:50:22 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7B71C2084D;
        Sat, 15 Jun 2019 05:50:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1560577822;
        bh=ZGVEz5W7fSK9yM6g3HmG8Fd2s6oQWJL4f41cyscrD40=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=D9lcxTas7YscTCGetZere7/h4KQYBnkc+2EK+zLtB/bLZTnCo154dl2Xvlta07i8X
         iqFKZEVjxhdK7z6a9Me4HznGJm3h3NMTq4wj25Ji2B9XHP6E/CIjg5bcyyL0cVGk3T
         s+y0FtO1jGG925SUYmRrL4YBxswq7Lj+3j4+PzSI=
Date:   Sat, 15 Jun 2019 07:50:19 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     James Feeney <james@nurealm.net>
Cc:     Benjamin Tissoires <benjamin.tissoires@redhat.com>,
        Peter Hutterer <peter.hutterer@who-t.net>,
        Sasha Levin <sashal@kernel.org>,
        Jiri Kosina <jikos@kernel.org>, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH 1/2] HID: input: make sure the wheel high resolution
 multiplier is set
Message-ID: <20190615055019.GC23883@kroah.com>
References: <20190423154615.18257-1-benjamin.tissoires@redhat.com>
 <CAO-hwJLCL95pAzO9kco2jo2_uCV2=3f5OEf=P=AoB9EpEjFTAw@mail.gmail.com>
 <43a56e9b-6e44-76b7-efff-fa8996183fbc@nurealm.net>
 <CAO-hwJK614pzseUsGqH65fCnrm=N7970i4_mqi0m1gdkY=J0ag@mail.gmail.com>
 <b6410e5d-b165-7a9b-2ef5-eb44c8de7753@nurealm.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <b6410e5d-b165-7a9b-2ef5-eb44c8de7753@nurealm.net>
User-Agent: Mutt/1.12.0 (2019-05-25)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Jun 14, 2019 at 04:09:35PM -0600, James Feeney wrote:
> Hey Everyone
> 
> On 4/24/19 10:41 AM, Benjamin Tissoires wrote:
> >>> For a patch to be picked up by stable, it first needs to go in Linus'
> >>> tree. Currently we are working on 5.1, so any stable patches need to
> >>> go in 5.1 first. Then, once they hit Linus' tree, the stable team will
> >>> pick them and backport them in the appropriate stable tree.
> 
> Hmm - so, I just booted linux 5.1.9, and this patch set is *still* missing from the kernel.
> 
> Is there anything that we can do about this?

What is the git commit id of the patch in Linus's tree?

As I said before, it can not be backported until it shows up there
first.

thanks,

greg k-h
