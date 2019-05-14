Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 85BD11D022
	for <lists+stable@lfdr.de>; Tue, 14 May 2019 21:45:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726218AbfENTpO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 14 May 2019 15:45:14 -0400
Received: from mail.kernel.org ([198.145.29.99]:48498 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726216AbfENTpO (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 14 May 2019 15:45:14 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 474A520873;
        Tue, 14 May 2019 19:45:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1557863113;
        bh=gIUqCd10g3Ofi5AGtvqghyiFV4ozJPK/4AWoBYHUI40=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=aZkFMvNtvhmsDvbie6tPkk2mGZ7Uo155pt4uPcvabGtFUrIvw2LDhNceNBC9/ETzu
         MsyLlO3qpp6XpJ7Ng21sEiCyT7EFM4PKg3i8vuX5T2yywGtu5uX6sIi6ZwFkL8KYyT
         FQw91JKqVxH5/GJffhJptavq1xh4AohWAtFQWqUg=
Date:   Tue, 14 May 2019 21:45:11 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     CKI Project <cki-project@redhat.com>
Cc:     Linux Stable maillist <stable@vger.kernel.org>
Subject: Re: =?utf-8?B?4p2OIEZBSUw=?= =?utf-8?Q?=3A?= Test report for kernel
 4.19.44-rc1-f1f5cdf.cki (stable)
Message-ID: <20190514194511.GA22244@kroah.com>
References: <cki.2A0764DDE0.XWP9Z2MJYF@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cki.2A0764DDE0.XWP9Z2MJYF@redhat.com>
User-Agent: Mutt/1.11.4 (2019-03-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, May 14, 2019 at 03:38:28PM -0400, CKI Project wrote:
> Hello,
> 
> We ran automated tests on a recent commit from this kernel tree:
> 
>        Kernel repo: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
>             Commit: c209b8bd5e5e - Linux 4.19.44-rc1
> 
> The results of these automated tests are provided below.
> 
>     Overall result: FAILED (see details below)
>              Merge: OK
>            Compile: FAILED
> 
> 
> We attempted to compile the kernel for multiple architectures, but the compile
> failed on one or more architectures:
> 
>            ppc64le: FAILED (see build-ppc64le.log.xz attachment)

Is everything failing now?  Has this ever worked?
