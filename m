Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EB4C018937
	for <lists+stable@lfdr.de>; Thu,  9 May 2019 13:47:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726054AbfEILrC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 9 May 2019 07:47:02 -0400
Received: from mail.kernel.org ([198.145.29.99]:59816 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725961AbfEILrC (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 9 May 2019 07:47:02 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2B07C216C4;
        Thu,  9 May 2019 11:47:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1557402421;
        bh=4qXOUA2qkml4WBPqz3qTf2qGuDahh2J/XlaE6KTj4nw=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Hsu12C8kP9AoSZUL2ZA09GGnz0YK9mavwbWGcv+IQ+6W7Jt4ZleG22Kqk4n+zmLp+
         lxvePH+iNtQIfZrZJv/ocEBmSXQd4TJoqewB46WkOd01Mh4WmDaVRmceL6IUOyrhQR
         Y5C0FI46vqSlg70Rbfey11YA0oZiMbPFIekT3bQY=
Date:   Thu, 9 May 2019 13:46:58 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     CKI Project <cki-project@redhat.com>
Cc:     Linux Stable maillist <stable@vger.kernel.org>
Subject: Re: =?utf-8?B?4pyFIFBBU1M=?= =?utf-8?Q?=3A?= Test report for kernel
 4.19.41-3b27f7b.cki (stable)
Message-ID: <20190509114658.GA666@kroah.com>
References: <cki.1028419619.B2683TGTB9@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cki.1028419619.B2683TGTB9@redhat.com>
User-Agent: Mutt/1.11.4 (2019-03-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, May 09, 2019 at 07:25:40AM -0400, CKI Project wrote:
> Hello,
> 
> We ran automated tests on a recent commit from this kernel tree:
> 
>        Kernel repo: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
>             Commit: 21de7eb67cff - Linux 4.19.41
> 
> The results of these automated tests are provided below.
> 
>     Overall result: PASSED
>              Merge: OK
>            Compile: OK
>              Tests: OK
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
> Compile testing
> ---------------

You are not merging from the stable-queue any patches fro 4.19?
