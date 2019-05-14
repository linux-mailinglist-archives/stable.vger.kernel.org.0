Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 765B91CDEE
	for <lists+stable@lfdr.de>; Tue, 14 May 2019 19:26:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726822AbfENR0P (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 14 May 2019 13:26:15 -0400
Received: from mail.kernel.org ([198.145.29.99]:50518 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726574AbfENR0O (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 14 May 2019 13:26:14 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id DB92620850;
        Tue, 14 May 2019 17:26:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1557854774;
        bh=JdRsQeruZNBoQC4glkxmqVMKhSvy55fKpmlNAHbB5RM=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=UWa0SWgsR7NO9NgnzAfJgiVFwV4EmwEd4V+6gQMjXXG+rWgeBVcD95PHsnyBsgp0d
         QomzHmQ/xW8ohDTA71e1awbXfjOcHKEpzlbgQ8c5Zfn9IS/hy2LsKeoVBtrIO4QxER
         IBYzLGdc4PCXNlyJxUSSciee9HB5iAFO6joER3w4=
Date:   Tue, 14 May 2019 19:26:11 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     CKI Project <cki-project@redhat.com>
Cc:     Linux Stable maillist <stable@vger.kernel.org>
Subject: Re: =?utf-8?B?4p2OIEZBSUw=?= =?utf-8?Q?=3A?= Stable queue: queue-5.1
Message-ID: <20190514172611.GA3890@kroah.com>
References: <cki.A3A8485C6F.6XI265B8MJ@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cki.A3A8485C6F.6XI265B8MJ@redhat.com>
User-Agent: Mutt/1.11.4 (2019-03-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, May 14, 2019 at 01:18:15PM -0400, CKI Project wrote:
> Hello,
> 
> We ran automated tests on a patchset that was proposed for merging into this
> kernel tree. The patches were applied to:
> 
>        Kernel repo: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux.git
>             Commit: b724e9356404 - Linux 5.1.1
> 
> The results of these automated tests are provided below.
> 
>     Overall result: FAILED (see details below)
>              Merge: FAILED
> 
> 
> When we attempted to merge the patchset, we received an error:
> 
>   Patch is empty.
> 
> We hope that these logs can help you find the problem quickly. For the full
> detail on our testing procedures, please scroll to the bottom of this message.
> 
> Please reply to this email if you have any questions about the tests that we
> ran or if you have any suggestions on how to make future tests more effective.
> 
>         ,-.   ,-.
>        ( C ) ( K )  Continuous
>         `-',-.`-'   Kernel
>           ( I )     Integration
>            `-'
> ______________________________________________________________________________
> 
> Merge testing
> -------------
> 
> We cloned this repository and checked out the following commit:
> 
>   Repo: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux.git
>   Commit: b724e9356404 - Linux 5.1.1
> 
> We then merged the patchset with `git am`:
> 

Odd, can't handle an empty queue?
