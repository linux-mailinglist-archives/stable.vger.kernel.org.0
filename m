Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A55044C4427
	for <lists+stable@lfdr.de>; Fri, 25 Feb 2022 13:02:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235001AbiBYMCY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 25 Feb 2022 07:02:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40586 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240420AbiBYMCX (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 25 Feb 2022 07:02:23 -0500
Received: from new1-smtp.messagingengine.com (new1-smtp.messagingengine.com [66.111.4.221])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D70EF3700F;
        Fri, 25 Feb 2022 04:01:48 -0800 (PST)
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailnew.nyi.internal (Postfix) with ESMTP id A104D58020B;
        Fri, 25 Feb 2022 07:01:46 -0500 (EST)
Received: from mailfrontend1 ([10.202.2.162])
  by compute3.internal (MEProxy); Fri, 25 Feb 2022 07:01:46 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kroah.com; h=cc
        :cc:content-type:date:date:from:from:in-reply-to:in-reply-to
        :message-id:mime-version:references:reply-to:sender:subject
        :subject:to:to; s=fm3; bh=lpk6Zx5vLH3g9YKAgyZ0UlC2jGDF3JNRknjCX1
        k4WEM=; b=Ra85Lyrj7DE+Z6BJpWwApGJO/IWX+xfyjyySBy60QGUazgcCk1PpMN
        sWkr+3Xa8AGMjioiyt4N4fDFvRNP0dEU+XExVYfIkjed76krycxgNx4ZkVDmoKeN
        4xAxmQktAFnxbGQU9WwO04kGNUh6bnbs+LJlYESauGSHGK28j8QfTooGkbZnJYjh
        nchggdgxm+DKs4OyEZa1t25/15zE9GsCV/J++IHGYflfQhzlPEMaOi3ACHQjfe9c
        Yi9aVboSiu6tDsjaxt10IpTfp2Qt5SXrvcSOP3ajhiaJmPtG9nCbGJEJjZ/x2p2y
        tyBLV2Y3s6rAtdwYhKm6f9H+2LBsTqPw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:cc:content-type:date:date:from:from
        :in-reply-to:in-reply-to:message-id:mime-version:references
        :reply-to:sender:subject:subject:to:to:x-me-proxy:x-me-proxy
        :x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=lpk6Zx5vLH3g9YKAg
        yZ0UlC2jGDF3JNRknjCX1k4WEM=; b=WAnr+3RwsYLSCEC9UhhdxxgWEdIrBKyZo
        4OM6RAH4325BbXTKucDgEpM7FdFwf0I6sXWble0jxwGdGFb+701xTfFut3tCszNH
        dwQw/dljKv7Ub/UQrZVvuQiTuiI/SOCsingGBhwEOGIoSSTbyArw4OoNfCZiANUO
        tv3soaaAFjqhP8L4d/TWURRjLfj6LKcRobAoXhEyn6qXPmD2jvgCgD7DQEsZnJUo
        kFdW4kuHjP3ECN2UtpcaHKv/w6Rkpu6wrK2xyPexT/OMDkGQOhPL1mHew75dFzoj
        RsZTHIASvhjvOmGn/E6uCJZW63xhFrS16IUZVGANmt86CKZRj7gVQ==
X-ME-Sender: <xms:J8UYYlFhAVAkXdSz7F7Ge-uN9BMOjhwhwBao-9ywwPtc-tBymUu7gg>
    <xme:J8UYYqVRp4rApepZCAuBd7DTGDT-OpKzuDPFbsBeUOeAJRm_lBQtFJbncok6wSwzI
    gTxfTP5cdmRsg>
X-ME-Received: <xmr:J8UYYnJZFK5vCjZ3GUeCU87WxISIIpx6vMIPcUGgbbvj46XsXnxDqc_UUIRGbP4zdhaAEd25VZHqRc3_C5CghFBU8ATFqoAX>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvvddrleeggdefiecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenuc
    fjughrpeffhffvuffkfhggtggujgesthdtredttddtvdenucfhrhhomhepifhrvghgucfm
    jfcuoehgrhgvgheskhhrohgrhhdrtghomheqnecuggftrfgrthhtvghrnhepveeuheejgf
    ffgfeivddukedvkedtleelleeghfeljeeiueeggeevueduudekvdetnecuvehluhhsthgv
    rhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomhepghhrvghgsehkrhhorghhrd
    gtohhm
X-ME-Proxy: <xmx:KMUYYrHtAf32ms7u4rAKfZP7IrxWGkSvRnjr6fXHNoSUnsXGaGVegA>
    <xmx:KMUYYrX-zk6FsDsIcLoby2WmmxhtJv6uGgNzzOXzDThXlsMPbR8vdQ>
    <xmx:KMUYYmOtu8yaTUcvP0dbGhN2tIqElttzR7mM5TN1_znVwEQPCee4Kg>
    <xmx:KsUYYiM_wVt7VfJRGHlQ4TaUtLzDSMXbXxKt3PbIblcX61cfV2t-2g>
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Fri,
 25 Feb 2022 07:01:43 -0500 (EST)
Date:   Fri, 25 Feb 2022 13:01:02 +0100
From:   Greg KH <greg@kroah.com>
To:     Dave Hansen <dave.hansen@intel.com>
Cc:     Brian Geffon <bgeffon@google.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Willis Kung <williskung@google.com>,
        Guenter Roeck <groeck@google.com>,
        Borislav Petkov <bp@suse.de>,
        Andy Lutomirski <luto@kernel.org>, stable@vger.kernel.org,
        x86@kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH stable 5.4,5.10] x86/fpu: Correct pkru/xstate
 inconsistency
Message-ID: <YhjE/uAlxfL0/0zL@kroah.com>
References: <543efc25-9b99-53cd-e305-d8b4d917b64b@intel.com>
 <20220215192233.8717-1-bgeffon@google.com>
 <e495d70b-f138-367d-e1d7-67c77149db7a@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <e495d70b-f138-367d-e1d7-67c77149db7a@intel.com>
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Feb 24, 2022 at 07:16:17AM -0800, Dave Hansen wrote:
> On 2/15/22 11:22, Brian Geffon wrote:
> > When eagerly switching PKRU in switch_fpu_finish() it checks that
> > current is not a kernel thread as kernel threads will never use PKRU.
> > It's possible that this_cpu_read_stable() on current_task
> > (ie. get_current()) is returning an old cached value. To resolve this
> > reference next_p directly rather than relying on current.
> > 
> > As written it's possible when switching from a kernel thread to a
> > userspace thread to observe a cached PF_KTHREAD flag and never restore
> > the PKRU. And as a result this issue only occurs when switching
> > from a kernel thread to a userspace thread, switching from a non kernel
> > thread works perfectly fine because all that is considered in that
> > situation are the flags from some other non kernel task and the next fpu
> > is passed in to switch_fpu_finish().
> > 
> > This behavior only exists between 5.2 and 5.13 when it was fixed by a
> > rewrite decoupling PKRU from xstate, in:
> >   commit 954436989cc5 ("x86/fpu: Remove PKRU handling from switch_fpu_finish()")
> > 
> > Unfortunately backporting the fix from 5.13 is probably not realistic as
> > it's part of a 60+ patch series which rewrites most of the PKRU handling.
> > 
> > Fixes: 0cecca9d03c9 ("x86/fpu: Eager switch PKRU state")
> > Signed-off-by: Brian Geffon <bgeffon@google.com>
> > Signed-off-by: Willis Kung <williskung@google.com>
> > Tested-by: Willis Kung <williskung@google.com>
> > Cc: <stable@vger.kernel.org> # v5.4.x
> > Cc: <stable@vger.kernel.org> # v5.10.x
> 
> I don't like forking the stable code from mainline.  But I also think
> that backporting the FPU reworking that changed the PKRU handling is
> likely to cause more bugs in stable than it fixes.
> 
> This fix is at least isolated to the protection keys code.
> 
> Acked-by: Dave Hansen <dave.hansen@linux.intel.com>

now queued up, thanks.

greg k-h
