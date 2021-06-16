Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3DEAE3A9329
	for <lists+stable@lfdr.de>; Wed, 16 Jun 2021 08:52:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231318AbhFPGyL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 16 Jun 2021 02:54:11 -0400
Received: from mail.kernel.org ([198.145.29.99]:32934 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230515AbhFPGyL (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 16 Jun 2021 02:54:11 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id CE971613BF;
        Wed, 16 Jun 2021 06:52:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1623826325;
        bh=9UaRjatsaFQTUEg2gGSTIIDafY/7w8Vg7XcsqAqgVeY=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=CYS/PgrZe8XX3FTe3UrfeQb+0sHQHEZBRE2b+E5D45UQ6Rdpqd7aXuMNzQ0KbwbiD
         XjfDAGQP42QC80+MJg8xENulKvTHsThg53Gce8FXmgcVfPpKf/whBVuwhk/EqDimgl
         A334R4Dt0nTVFpfmpflmjb7nWTOiRJg+n3XXMGsE=
Date:   Wed, 16 Jun 2021 08:52:01 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Liu Shixin <liushixin2@huawei.com>
Cc:     Suren Baghdasaryan <surenb@google.com>,
        Vlastimil Babka <vbabka@suse.cz>, stable@vger.kernel.org,
        "Jann Horn," <jannh@google.com>,
        Mikulas Patocka <mpatocka@redhat.com>
Subject: Re: Questions about backports of fixes for "CoW after fork() issue"
Message-ID: <YMmfke61mTcPV4vB@kroah.com>
References: <f546c93e-0e36-03a1-fb08-67f46c83d2e7@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <f546c93e-0e36-03a1-fb08-67f46c83d2e7@huawei.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Jun 16, 2021 at 02:47:15PM +0800, Liu Shixin wrote:
> Hi, Suren,
> 
> I read the previous discussion about fixing CVE-2020-29374 in stable 4.14 and 4.19 in
> <https://lore.kernel.org/linux-mm/20210401181741.168763-1-surenb@google.com/>
> 
> https://lore.kernel.org/linux-mm/20210401181741.168763-1-surenb@google.com/
> 
> And the results of the discussion is that you backports of 17839856fd58 for 4.14 and
> 
> 4.19 kernels.
> 
> But the bug about dax and strace in the discussion has not been solved, right? I don't
> 
> find a conclusion on this issue, am I missing something? Does this problem still exist in
> 
> the stable 4.14 and 4.19 kernel?

As the code is all there for you, can you just test them and see for
yourself?

thanks,

greg k-h
