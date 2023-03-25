Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6B9976C8E14
	for <lists+stable@lfdr.de>; Sat, 25 Mar 2023 13:25:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231211AbjCYMZk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 25 Mar 2023 08:25:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52742 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230265AbjCYMZi (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 25 Mar 2023 08:25:38 -0400
Received: from wout2-smtp.messagingengine.com (wout2-smtp.messagingengine.com [64.147.123.25])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 263DC15140;
        Sat, 25 Mar 2023 05:25:20 -0700 (PDT)
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailout.west.internal (Postfix) with ESMTP id ECF5D32009CF;
        Sat, 25 Mar 2023 08:25:15 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute4.internal (MEProxy); Sat, 25 Mar 2023 08:25:16 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kroah.com; h=cc
        :cc:content-type:content-type:date:date:from:from:in-reply-to
        :in-reply-to:message-id:mime-version:references:reply-to:sender
        :subject:subject:to:to; s=fm2; t=1679747115; x=1679833515; bh=Yq
        I1d6KkWsEnleRd2d0xiQZ2fNQcyMDsVJhmQu6rnqM=; b=vZy2Jy4GarQ31oUt+4
        vv32Vl7Zlv52AwdV4SeA2EGe35BJbYpPHfiPMN3K3ncWNUJYPSP4xW3sK/+htVp7
        zz6nb3hpC7ZdpIAWueaoSsQTI4RHIx+XMGUvZ0wUswjLeCB74s3+6W76tqrZEjc+
        It7PvDpGT5x2f3WUN9JcagllMxpLzUrRMJj5ycUa8JUBbE8gVlp/1II4yTyDhjCK
        AZTQ1RTOAg4/pVO2jazvZ9hQcbu/ERElG4xuhhzwMBBqqBTOUuOrIsn9CTOH08Dh
        ABxbS5GQB9RhO5yEGa+9WYOvtLkUVhSsS1+rLF75l4gbOZiMAImR6CHiWUWs2MOk
        /UHw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:cc:content-type:content-type:date:date
        :feedback-id:feedback-id:from:from:in-reply-to:in-reply-to
        :message-id:mime-version:references:reply-to:sender:subject
        :subject:to:to:x-me-proxy:x-me-proxy:x-me-sender:x-me-sender
        :x-sasl-enc; s=fm2; t=1679747115; x=1679833515; bh=YqI1d6KkWsEnl
        eRd2d0xiQZ2fNQcyMDsVJhmQu6rnqM=; b=sQqGu/3h6gyfqkmQljID6RDw+QBM/
        XI3sI4niUKwMifskto0C4p1VMZA7WvPyLrwCZ2P+xM4d7QxQL3WbNUDuIwinjFNd
        w/Qor9mETObWZNQ5MWfWRu0II7u8x7jGf6twqrB2xSAVqZRyTduDrIQsr/omorVs
        y/fEtRBnT+/EllKpJy5oDKfVqe0aOokreXfYZNnFqXjIojyxWR1hUQjcFWlPDSy0
        34kt5Wg4K8JYfaOGlu9RLV0KbnaWO6L3YW8yWUmeB6CChX+pXQpAmRGzUnTVQzZg
        7gFi4srfSltjnvUmXgy87hDBARXgl9d++GQyv8ivNSv6mEvvdvaHAp89A==
X-ME-Sender: <xms:K-geZF6Kj528xzRMXpqEAV8TsTwRKfSrFAfcxAXoJolPExER5NnMdA>
    <xme:K-geZC56DGe1QnLlrPh1raiIMU5yTeTq7VqiCjsJBmvdz0objV2_EuNwKpgF1gj-N
    75Kahr3bM1VCw>
X-ME-Received: <xmr:K-geZMex3ZNYdIZGe6Ci5-7dw5t5rbU7K2y9Yzu8R0QBqOudIZCbB5M2uQyGBnSIIuiriMJDAAbadTfhMsPMt2JBi_g0NssDZ_6suA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvhedrvdegkedggeduucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhepfffhvfevuffkfhggtggujgesthdtredttddtvdenucfhrhhomhepifhrvghg
    ucfmjfcuoehgrhgvgheskhhrohgrhhdrtghomheqnecuggftrfgrthhtvghrnhepudeife
    evhefhvddtiefhvdevhfelleefieeffeekieeggfethfdvudetfeetffeknecuffhomhgr
    ihhnpehkvghrnhgvlhdrohhrghdpghhithhhuhgsrdgtohhmnecuvehluhhsthgvrhfuih
    iivgeptdenucfrrghrrghmpehmrghilhhfrhhomhepghhrvghgsehkrhhorghhrdgtohhm
X-ME-Proxy: <xmx:K-geZOLndN0yjRda1zgjEVgGAnZYy4cUK4xuoQyquQMjHl7sd38zJQ>
    <xmx:K-geZJKLt0_nqOrgoB9OsL4zdNfjT8O7-wENFzeNcu04PbknlwMPBg>
    <xmx:K-geZHw1CqDN9HzsckObz_s0pBrCAKX0ctyOr60jvr2FJVzC5oG71g>
    <xmx:K-geZA-aiKxqxMcaSl4jEK5MA5cUGBL68PTLuSCTjjxEdgYcjdUs7g>
Feedback-ID: i787e41f1:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Sat,
 25 Mar 2023 08:25:14 -0400 (EDT)
Date:   Sat, 25 Mar 2023 13:25:12 +0100
From:   Greg KH <greg@kroah.com>
To:     Mathias Krause <minipli@grsecurity.net>
Cc:     Sean Christopherson <seanjc@google.com>, kvm@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>, stable@vger.kernel.org
Subject: Re: [PATCH v4 0/6] KVM: MMU: performance tweaks for heavy CR0.WP
 users
Message-ID: <ZB7oKD6CHa6f2IEO@kroah.com>
References: <20230322013731.102955-1-minipli@grsecurity.net>
 <167949641597.2215962.13042575709754610384.b4-ty@google.com>
 <190509c8-0f05-d05c-831c-596d2c9664ac@grsecurity.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <190509c8-0f05-d05c-831c-596d2c9664ac@grsecurity.net>
X-Spam-Status: No, score=-0.9 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,RCVD_IN_MSPIKE_H2,
        SPF_HELO_PASS,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sat, Mar 25, 2023 at 12:39:59PM +0100, Mathias Krause wrote:
> On 23.03.23 23:50, Sean Christopherson wrote:
> > On Wed, 22 Mar 2023 02:37:25 +0100, Mathias Krause wrote:
> >> v3: https://lore.kernel.org/kvm/20230201194604.11135-1-minipli@grsecurity.net/
> >>
> >> This series is the fourth iteration of resurrecting the missing pieces of
> >> Paolo's previous attempt[1] to avoid needless MMU roots unloading.
> >>
> >> It's incorporating Sean's feedback to v3 and rebased on top of
> >> kvm-x86/next, namely commit d8708b80fa0e ("KVM: Change return type of
> >> kvm_arch_vm_ioctl() to "int"").
> >>
> >> [...]
> > 
> > Applied 1 and 5 to kvm-x86 mmu, and the rest to kvm-x86 misc, thanks!
> > 
> > [1/6] KVM: x86/mmu: Avoid indirect call for get_cr3
> >       https://github.com/kvm-x86/linux/commit/2fdcc1b32418
> > [2/6] KVM: x86: Do not unload MMU roots when only toggling CR0.WP with TDP enabled
> >       https://github.com/kvm-x86/linux/commit/01b31714bd90
> > [3/6] KVM: x86: Ignore CR0.WP toggles in non-paging mode
> >       https://github.com/kvm-x86/linux/commit/e40bcf9f3a18
> > [4/6] KVM: x86: Make use of kvm_read_cr*_bits() when testing bits
> >       https://github.com/kvm-x86/linux/commit/74cdc836919b
> > [5/6] KVM: x86/mmu: Fix comment typo
> >       https://github.com/kvm-x86/linux/commit/50f13998451e
> > [6/6] KVM: VMX: Make CR0.WP a guest owned bit
> >       https://github.com/kvm-x86/linux/commit/fb509f76acc8
> 
> Thanks a lot, Sean!
> 
> As this is a huge performance fix for us, we'd like to get it integrated
> into current stable kernels as well -- not without having the changes
> get some wider testing, of course, i.e. not before they end up in a
> non-rc version released by Linus. But I already did a backport to 5.4 to
> get a feeling how hard it would be and for the impact it has on older
> kernels.
> 
> Using the 'ssdd 10 50000' test I used before, I get promising results
> there as well. Without the patches it takes 9.31s, while with them we're
> down to 4.64s. Taking into account that this is the runtime of a
> workload in a VM that gets cut in half, I hope this qualifies as stable
> material, as it's a huge performance fix.
> 
> Greg, what's your opinion on it? Original series here:
> https://lore.kernel.org/kvm/20230322013731.102955-1-minipli@grsecurity.net/

I'll leave the judgement call up to the KVM maintainers, as they are the
ones that need to ack any KVM patch added to stable trees.

thanks,

greg k-h
