Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0EEB234A80
	for <lists+stable@lfdr.de>; Tue,  4 Jun 2019 16:34:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727405AbfFDOe0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 4 Jun 2019 10:34:26 -0400
Received: from mail.kernel.org ([198.145.29.99]:49720 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727169AbfFDOe0 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 4 Jun 2019 10:34:26 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 81E4424A38;
        Tue,  4 Jun 2019 14:34:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1559658866;
        bh=UO69YyEkEd7qUh32pfpN/kqShz4lTTpVn16idLA0qaI=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=pUxI0ESlP1YJOTW72sUdOCnO8W/Q/4vg/LMWvrSZ5N7dH4p71IJ3ra1pQXGXJw2Uq
         afahEYsl/jXJcg/DMeN8OeannCb5OAv9whkczaGY8+R1Xs4H9S6Xj9DVK8Rn/si/Wy
         l7GSsOc/7oW+I4DGyNfQAvu2uWC/0lzQVMIRHqdY=
Date:   Tue, 4 Jun 2019 16:34:23 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     CKI Project <cki-project@redhat.com>
Cc:     Linux Stable maillist <stable@vger.kernel.org>
Subject: Re: =?utf-8?B?4p2OIEZBSUw=?= =?utf-8?Q?=3A?= Stable queue: queue-4.19
Message-ID: <20190604143423.GA17667@kroah.com>
References: <cki.3C4E7A4885.RP5CKJBZGV@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cki.3C4E7A4885.RP5CKJBZGV@redhat.com>
User-Agent: Mutt/1.12.0 (2019-05-25)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Jun 04, 2019 at 10:04:51AM -0400, CKI Project wrote:
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

Should now be fixed, thanks.

greg k-h
