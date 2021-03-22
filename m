Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EB3B0343C25
	for <lists+stable@lfdr.de>; Mon, 22 Mar 2021 09:56:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229614AbhCVIzj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 22 Mar 2021 04:55:39 -0400
Received: from mail.kernel.org ([198.145.29.99]:55218 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229883AbhCVIz3 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 22 Mar 2021 04:55:29 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 97A2A6191C;
        Mon, 22 Mar 2021 08:55:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1616403329;
        bh=874VFtrnH/YZSOHHxxysxEmkenAactX77Y8IT+SL/B0=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=M1FFf6mz3LlGRzzZvyjTiacYYOq7K1A+EWFN2f3Nar6IGXzE3/ahxJf8LW9zUNlJB
         u6Oy7kfnPe4gHd2aeu6XejnCTWaTO5HYKhBTJkj7bKvQ3XbpUeKKIr/Z7Co2LG4KFZ
         tMMfPwnY5jSnA8pJAvCWJHlZco7yWDXRwnqOA9YA=
Date:   Mon, 22 Mar 2021 09:55:26 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Sergey Shtylyov <s.shtylyov@omprussia.ru>
Cc:     Sasha Levin <sashal@kernel.org>, stable-commits@vger.kernel.org,
        stable@vger.kernel.org
Subject: Re: Patch "module: avoid *goto*s in module_sig_check()" has been
 added to the 5.10-stable tree
Message-ID: <YFhbfgOF4BXqrzxG@kroah.com>
References: <20210322030545.C1CC761931@mail.kernel.org>
 <b57c2e45-0114-c7ea-4665-307a82826ff7@omprussia.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <b57c2e45-0114-c7ea-4665-307a82826ff7@omprussia.ru>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Mar 22, 2021 at 11:35:01AM +0300, Sergey Shtylyov wrote:
> On 22.03.2021 6:05, Sasha Levin wrote:
> 
> > This is a note to let you know that I've just added the patch titled
> > 
> >      module: avoid *goto*s in module_sig_check()
> > 
> > to the 5.10-stable tree which can be found at:
> >      http://www.kernel.org/git/?p=linux/kernel/git/stable/stable-queue.git;a=summary
> > 
> > The filename of the patch is:
> >       module-avoid-goto-s-in-module_sig_check.patch
> > and it can be found in the queue-5.10 subdirectory.
> > 
> > If you, or anyone else, feels it should not be added to the stable tree,
> > please let <stable@vger.kernel.org> know about it.
> 
>    Again, it's just a cleanup...

It is needed for ec2a29593c83 ("module: harden ELF info handling").
