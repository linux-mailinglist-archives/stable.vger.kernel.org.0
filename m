Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 99B0F44D93A
	for <lists+stable@lfdr.de>; Thu, 11 Nov 2021 16:36:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232033AbhKKPjC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 11 Nov 2021 10:39:02 -0500
Received: from outgoing-stata.csail.mit.edu ([128.30.2.210]:58745 "EHLO
        outgoing-stata.csail.mit.edu" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230177AbhKKPjB (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 11 Nov 2021 10:39:01 -0500
Received: from [128.177.79.46] (helo=csail.mit.edu)
        by outgoing-stata.csail.mit.edu with esmtpsa (TLS1.2:RSA_AES_256_CBC_SHA1:256)
        (Exim 4.82)
        (envelope-from <srivatsa@csail.mit.edu>)
        id 1mlC7U-000Qst-6C; Thu, 11 Nov 2021 10:36:08 -0500
Date:   Thu, 11 Nov 2021 07:39:16 -0800
From:   "Srivatsa S. Bhat" <srivatsa@csail.mit.edu>
To:     Greg KH <gregkh@linuxfoundation.org>
Cc:     jgross@suse.com, x86@kernel.org, pv-drivers@vmware.com,
        Alexey Makhalov <amakhalov@vmware.com>,
        Deep Shah <sdeep@vmware.com>, stable@vger.kernel.org,
        virtualization@lists.linux-foundation.org, keerthanak@vmware.com,
        srivatsab@vmware.com, anishs@vmware.com, vithampi@vmware.com,
        linux-kernel@vger.kernel.org, namit@vmware.com, joe@perches.com,
        kuba@kernel.org, rostedt@goodmis.org
Subject: Re: [PATCH v3 1/3] MAINTAINERS: Update maintainers for paravirt ops
 and VMware hypervisor interface
Message-ID: <20211111153916.GA7966@csail.mit.edu>
References: <163657479269.84207.13658789048079672839.stgit@srivatsa-dev>
 <163657487268.84207.5604596767569015608.stgit@srivatsa-dev>
 <YYy9P7Rjg9hntmm3@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YYy9P7Rjg9hntmm3@kroah.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Nov 11, 2021 at 07:50:39AM +0100, Greg KH wrote:
> On Wed, Nov 10, 2021 at 12:08:16PM -0800, Srivatsa S. Bhat wrote:
> > From: Srivatsa S. Bhat (VMware) <srivatsa@csail.mit.edu>
> > 
> > Deep has decided to transfer maintainership of the VMware hypervisor
> > interface to Srivatsa, and the joint-maintainership of paravirt ops in
> > the Linux kernel to Srivatsa and Alexey. Update the MAINTAINERS file
> > to reflect this change.
> > 
> > Signed-off-by: Srivatsa S. Bhat (VMware) <srivatsa@csail.mit.edu>
> > Acked-by: Alexey Makhalov <amakhalov@vmware.com>
> > Acked-by: Deep Shah <sdeep@vmware.com>
> > Acked-by: Juergen Gross <jgross@suse.com>
> > Cc: stable@vger.kernel.org
> 
> Why are MAINTAINERS updates needed for stable?  That's not normal :(

So that people posting bug-fixes / backports to these subsystems for
older kernels (stable and LTS releases) will CC the new subsystem
maintainers. That's why I added CC stable tag only to the first two
patches which add/replace maintainers and not the third patch which is
just a cleanup.

Regards,
Srivatsa
