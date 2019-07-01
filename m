Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 68B195BFE4
	for <lists+stable@lfdr.de>; Mon,  1 Jul 2019 17:33:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727676AbfGAPdV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Jul 2019 11:33:21 -0400
Received: from mx1.redhat.com ([209.132.183.28]:44972 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727379AbfGAPdV (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Jul 2019 11:33:21 -0400
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 3AE6D58E23;
        Mon,  1 Jul 2019 15:32:58 +0000 (UTC)
Received: from horse.redhat.com (unknown [10.18.25.109])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 038B11001B20;
        Mon,  1 Jul 2019 15:32:52 +0000 (UTC)
Received: by horse.redhat.com (Postfix, from userid 10451)
        id 6B2EE220B2B; Mon,  1 Jul 2019 11:32:52 -0400 (EDT)
Date:   Mon, 1 Jul 2019 11:32:52 -0400
From:   Vivek Goyal <vgoyal@redhat.com>
To:     "Srivatsa S. Bhat" <srivatsa@csail.mit.edu>
Cc:     stable@vger.kernel.org, gregkh@linuxfoundation.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        Miklos Szeredi <mszeredi@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Radim =?utf-8?B?S3LEjW3DocWZ?= <rkrcmar@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>, Wei Wu <ww9210@gmail.com>,
        Gen Zhang <blackgod016574@gmail.com>, akaher@vmware.com,
        srinidhir@vmware.com, bvikas@vmware.com, amakhalov@vmware.com,
        srivatsab@vmware.com
Subject: Re: [4.4.y PATCH 0/4] Backported fixes for 4.4 stable tree
Message-ID: <20190701153252.GA32227@redhat.com>
References: <156174751125.35226.7600381640894671668.stgit@srivatsa-ubuntu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <156174751125.35226.7600381640894671668.stgit@srivatsa-ubuntu>
User-Agent: Mutt/1.11.3 (2019-02-01)
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.39]); Mon, 01 Jul 2019 15:33:21 +0000 (UTC)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Jun 28, 2019 at 11:45:40AM -0700, Srivatsa S. Bhat wrote:
> Hi,
> 
> This patchset includes a few backported fixes for the 4.4 stable tree.
> I would appreciate if you could kindly consider including them in the
> next release.
> 
> Thank you!
> 
> Regards,
> Srivatsa
> 
> ---
> 
> Gen Zhang (2):
>       ip_sockglue: Fix missing-check bug in ip_ra_control()
>       ipv6_sockglue: Fix a missing-check bug in ip6_ra_control()
> 
> Vivek Goyal (1):
>       ovl: modify ovl_permission() to do checks on two inodes

Hi Srivatsa,

Curious, why are you backporting above patch. These changes were done in
a series primarily to support SELinux with overlay. Are you fixing a
particular issue with this single patch?

Vivek

> 
> Wanpeng Li (1):
>       KVM: X86: Fix scan ioapic use-before-initialization
> 
> 
>  arch/x86/kvm/x86.c       |    3 ++-
>  fs/overlayfs/inode.c     |   13 +++++++++++++
>  net/ipv4/ip_sockglue.c   |    2 ++
>  net/ipv6/ipv6_sockglue.c |    2 ++
>  4 files changed, 19 insertions(+), 1 deletion(-)
