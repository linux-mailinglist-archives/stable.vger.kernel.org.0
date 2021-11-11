Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 41B4E44D207
	for <lists+stable@lfdr.de>; Thu, 11 Nov 2021 07:50:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229649AbhKKGxc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 11 Nov 2021 01:53:32 -0500
Received: from mail.kernel.org ([198.145.29.99]:42278 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229564AbhKKGxc (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 11 Nov 2021 01:53:32 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id A2B7B61269;
        Thu, 11 Nov 2021 06:50:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1636613443;
        bh=Za0ha/KPKidU0hYxA5XAAbicjwBHXdy/AC08WuITH28=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=F32G7/zmqv/2mKQ5T7WLd2z4yJ+2qtratvgoirAEAsOtx3whvUDoFA4x0vogRG4FE
         36BYXMbaPGpCcpfKuZgbgGNYS6ZxFjBWtpEjp8f8ln6fp51P2OWC83DaEUKnITN1wd
         0mqaNYouBa1RHjBBwN6kigPkiPgVvxsMUXtFF1fU=
Date:   Thu, 11 Nov 2021 07:50:39 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     "Srivatsa S. Bhat" <srivatsa@csail.mit.edu>
Cc:     jgross@suse.com, x86@kernel.org, pv-drivers@vmware.com,
        Alexey Makhalov <amakhalov@vmware.com>,
        Deep Shah <sdeep@vmware.com>, stable@vger.kernel.org,
        virtualization@lists.linux-foundation.org, keerthanak@vmware.com,
        srivatsab@vmware.com, anishs@vmware.com, vithampi@vmware.com,
        linux-kernel@vger.kernel.org, namit@vmware.com, joe@perches.com,
        kuba@kernel.org, rostedt@goodmis.org
Subject: Re: [PATCH v3 1/3] MAINTAINERS: Update maintainers for paravirt ops
 and VMware hypervisor interface
Message-ID: <YYy9P7Rjg9hntmm3@kroah.com>
References: <163657479269.84207.13658789048079672839.stgit@srivatsa-dev>
 <163657487268.84207.5604596767569015608.stgit@srivatsa-dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <163657487268.84207.5604596767569015608.stgit@srivatsa-dev>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Nov 10, 2021 at 12:08:16PM -0800, Srivatsa S. Bhat wrote:
> From: Srivatsa S. Bhat (VMware) <srivatsa@csail.mit.edu>
> 
> Deep has decided to transfer maintainership of the VMware hypervisor
> interface to Srivatsa, and the joint-maintainership of paravirt ops in
> the Linux kernel to Srivatsa and Alexey. Update the MAINTAINERS file
> to reflect this change.
> 
> Signed-off-by: Srivatsa S. Bhat (VMware) <srivatsa@csail.mit.edu>
> Acked-by: Alexey Makhalov <amakhalov@vmware.com>
> Acked-by: Deep Shah <sdeep@vmware.com>
> Acked-by: Juergen Gross <jgross@suse.com>
> Cc: stable@vger.kernel.org

Why are MAINTAINERS updates needed for stable?  That's not normal :(
