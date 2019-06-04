Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8F4B4345F8
	for <lists+stable@lfdr.de>; Tue,  4 Jun 2019 13:55:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727549AbfFDLzB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 4 Jun 2019 07:55:01 -0400
Received: from mail.kernel.org ([198.145.29.99]:52802 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727250AbfFDLzB (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 4 Jun 2019 07:55:01 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A8F2324622;
        Tue,  4 Jun 2019 11:55:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1559649301;
        bh=DLo4oqISsCYoijHnV7hU7hH++JwMmbkhPnWJYxwVXo4=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Ieh3E54fqfQAEXQjV0n4lI3/DFfuqFHvmmiTJBaYh6+tsmqdV2dBX+R0RyVDun9w2
         52WnTuxtSjeJSH1qYLJ+tEDO7i3IhpqQDbD+F1X3FQhKKLhBvJ/cgGJcctnJ340D1T
         ilEnMrjDwjWUKKyevrn8QO/esjfEPpWk3FxM0zx4=
Date:   Tue, 4 Jun 2019 13:54:58 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     CKI Project <cki-project@redhat.com>
Cc:     Linux Stable maillist <stable@vger.kernel.org>
Subject: Re: =?utf-8?B?4p2OIEZBSUw=?= =?utf-8?Q?=3A?= Stable queue: queue-4.19
Message-ID: <20190604115458.GA23880@kroah.com>
References: <cki.74A370F860.SQ1THKY9U1@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cki.74A370F860.SQ1THKY9U1@redhat.com>
User-Agent: Mutt/1.12.0 (2019-05-25)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Jun 04, 2019 at 05:57:22AM -0400, CKI Project wrote:
> Hello,
> 
> We ran automated tests on a patchset that was proposed for merging into this
> kernel tree. The patches were applied to:
> 
>        Kernel repo: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux.git
>             Commit: e109a984cf38 - Linux 4.19.48
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

My fault, I added a patch that should not have been backported to 4.19.
I've now dropped it, hopefully this should resolve the error.

Thanks for the report, much appreciated!

greg k-h
