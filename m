Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CC2DE6C1368
	for <lists+stable@lfdr.de>; Mon, 20 Mar 2023 14:30:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230082AbjCTNa0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Mar 2023 09:30:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60122 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231382AbjCTNaY (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Mar 2023 09:30:24 -0400
Received: from out3-smtp.messagingengine.com (out3-smtp.messagingengine.com [66.111.4.27])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4571249EE
        for <stable@vger.kernel.org>; Mon, 20 Mar 2023 06:29:59 -0700 (PDT)
Received: from compute6.internal (compute6.nyi.internal [10.202.2.47])
        by mailout.nyi.internal (Postfix) with ESMTP id C535F5C0125;
        Mon, 20 Mar 2023 09:29:54 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute6.internal (MEProxy); Mon, 20 Mar 2023 09:29:54 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kroah.com; h=cc
        :cc:content-type:content-type:date:date:from:from:in-reply-to
        :in-reply-to:message-id:mime-version:references:reply-to:sender
        :subject:subject:to:to; s=fm2; t=1679318994; x=1679405394; bh=qv
        X9zx3KAw16Ja13RgmgQbU7FAVBJJp8PsL97exb4Dc=; b=ZBN8Jh4q8K4ZXWJNkp
        22dwEatSEl26OcygVwn5ckPqPW0OgdJbjAjRsBTaLk5e++CaQUlZemRHtvX2j2EE
        s2czrxX7ZxIQmat/+6GdTjKUqrbKojK724RCPC+P3ppyx+ZX4sEbx+oxhoF+5L+h
        znYLGNtRk63bcSW/AvPPvqp+oxqJgxlkyWk2WmVDS7lpH2FgpegORoBRC+3xJpl1
        7B423kq0SQtuFY8qo67hOxF3b0BzPrIBvvPdwJBr2plzXgS24hfvb4EnFEHKwpWo
        1Expl4lLQ3w11az9G00g04P04unl2ZkyV/CnnlKayzr74Hlh5lyhISK/JgUoA4w/
        dENQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:cc:content-type:content-type:date:date
        :feedback-id:feedback-id:from:from:in-reply-to:in-reply-to
        :message-id:mime-version:references:reply-to:sender:subject
        :subject:to:to:x-me-proxy:x-me-proxy:x-me-sender:x-me-sender
        :x-sasl-enc; s=fm2; t=1679318994; x=1679405394; bh=qvX9zx3KAw16J
        a13RgmgQbU7FAVBJJp8PsL97exb4Dc=; b=ae9nJvhotF2lU3OTFYWpd271ztUgr
        uK7+zuudnVGMLYvlwgPbwjX83zhQsPyl0FuKAIAhcrF3lKY9RefFqz3LDyZdcnWE
        3GvQ8YBEmxmtGB8HypScBzKfi9OVeClo2g3k+/M8LypjieTAP5oJksvxYfiulJ4x
        ZNpXDpOykkWlPJhLUBI4PbollqbXYXngHeN3WUrlcRituSkU6Va1zPFKcF5M1nol
        9dEUYRTL1ZV0LSRuA8MdMN2nB0MaQCL48ztjQQaKshgk2rVgzDydE/SNtdCYIt69
        R4HowVBirBwfCBu3/J2VTcB1vtvY0b27J6BM/DooQCubW/nD5gSDd7yYw==
X-ME-Sender: <xms:0l8YZF9NvEAwXc3nl4Lj8DxvWndnC6WFUOn7zwtRSDcxnJuf715IXA>
    <xme:0l8YZJtnOrsC4mPtgVsL1sjsnIko9Lh7Hxau5SOr-X_HaXoh1qSVNe7aIaAsd-qEc
    cvr1Iec7FcpXg>
X-ME-Received: <xmr:0l8YZDC3NxUgzfs_ntbGbB6zb7dXxdwEZdqmb96HrzsnLgWKuUNouNEahEKR-4E0P_NTcfTlRZiOlxz4SpKBttoPc_s6bKu6dyg0BA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvhedrvdefkedghedvucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhepfffhvfevuffkfhggtggujgesthdtredttddtvdenucfhrhhomhepifhrvghg
    ucfmjfcuoehgrhgvgheskhhrohgrhhdrtghomheqnecuggftrfgrthhtvghrnhepleeite
    evieefteelfeehveegvdetveehgffhvdejffdvleevhfffgeffffejlefgnecuffhomhgr
    ihhnpehfrhgvvgguvghskhhtohhprdhorhhgnecuvehluhhsthgvrhfuihiivgeptdenuc
    frrghrrghmpehmrghilhhfrhhomhepghhrvghgsehkrhhorghhrdgtohhm
X-ME-Proxy: <xmx:0l8YZJeLcdwNS2fHWZFaaOeD0AWpLWsbBQiG13-Tr-Q6oyt5Zv1JaA>
    <xmx:0l8YZKPdOb3OElc-4W_T1nm1hAJjZH37uSTa5g5YFUNjkXaRNDNblg>
    <xmx:0l8YZLls7rs_i9d-oyI7Pn8uIK3pizcqgkTTm-zrEoueeICB_ThT0w>
    <xmx:0l8YZDbcd1fEzn7ryVNgnI8q6vHvjm7yxa1sEWJKMwl5iqWsENbKnQ>
Feedback-ID: i787e41f1:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Mon,
 20 Mar 2023 09:29:54 -0400 (EDT)
Date:   Mon, 20 Mar 2023 14:29:51 +0100
From:   Greg KH <greg@kroah.com>
To:     Janusz Krzysztofik <janusz.krzysztofik@linux.intel.com>
Cc:     stable@vger.kernel.org
Subject: Re: [PATCH 5.15.y] drm/i915/active: Fix misuse of non-idle barriers
 as fence trackers
Message-ID: <ZBhfz5KP4kOQ3WO6@kroah.com>
References: <1679307444199182@kroah.com>
 <20230320114752.169004-1-janusz.krzysztofik@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230320114752.169004-1-janusz.krzysztofik@linux.intel.com>
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Mar 20, 2023 at 12:47:52PM +0100, Janusz Krzysztofik wrote:
> Users reported oopses on list corruptions when using i915 perf with a
> number of concurrently running graphics applications.  Root cause analysis
> pointed at an issue in barrier processing code -- a race among perf open /
> close replacing active barriers with perf requests on kernel context and
> concurrent barrier preallocate / acquire operations performed during user
> context first pin / last unpin.
> 
> When adding a request to a composite tracker, we try to reuse an existing
> fence tracker, already allocated and registered with that composite.  The
> tracker we obtain may already track another fence, may be an idle barrier,
> or an active barrier.
> 
> If the tracker we get occurs a non-idle barrier then we try to delete that
> barrier from a list of barrier tasks it belongs to.  However, while doing
> that we don't respect return value from a function that performs the
> barrier deletion.  Should the deletion ever fail, we would end up reusing
> the tracker still registered as a barrier task.  Since the same structure
> field is reused with both fence callback lists and barrier tasks list,
> list corruptions would likely occur.
> 
> Barriers are now deleted from a barrier tasks list by temporarily removing
> the list content, traversing that content with skip over the node to be
> deleted, then populating the list back with the modified content.  Should
> that intentionally racy concurrent deletion attempts be not serialized,
> one or more of those may fail because of the list being temporary empty.
> 
> Related code that ignores the results of barrier deletion was initially
> introduced in v5.4 by commit d8af05ff38ae ("drm/i915: Allow sharing the
> idle-barrier from other kernel requests").  However, all users of the
> barrier deletion routine were apparently serialized at that time, then the
> issue didn't exhibit itself.  Results of git bisect with help of a newly
> developed igt@gem_barrier_race@remote-request IGT test indicate that list
> corruptions might start to appear after commit 311770173fac ("drm/i915/gt:
> Schedule request retirement when timeline idles"), introduced in v5.5.
> 
> Respect results of barrier deletion attempts -- mark the barrier as idle
> only if successfully deleted from the list.  Then, before proceeding with
> setting our fence as the one currently tracked, make sure that the tracker
> we've got is not a non-idle barrier.  If that check fails then don't use
> that tracker but go back and try to acquire a new, usable one.
> 
> v3: use unlikely() to document what outcome we expect (Andi),
>   - fix bad grammar in commit description.
> v2: no code changes,
>   - blame commit 311770173fac ("drm/i915/gt: Schedule request retirement
>     when timeline idles"), v5.5, not commit d8af05ff38ae ("drm/i915: Allow
>     sharing the idle-barrier from other kernel requests"), v5.4,
>   - reword commit description.
> 
> Closes: https://gitlab.freedesktop.org/drm/intel/-/issues/6333
> Fixes: 311770173fac ("drm/i915/gt: Schedule request retirement when timeline idles")
> Cc: Chris Wilson <chris@chris-wilson.co.uk>
> Cc: stable@vger.kernel.org # v5.5
> Cc: Andi Shyti <andi.shyti@linux.intel.com>
> Signed-off-by: Janusz Krzysztofik <janusz.krzysztofik@linux.intel.com>
> Reviewed-by: Andi Shyti <andi.shyti@linux.intel.com>
> Signed-off-by: Andi Shyti <andi.shyti@linux.intel.com>
> Link: https://patchwork.freedesktop.org/patch/msgid/20230302120820.48740-1-janusz.krzysztofik@linux.intel.com
> (cherry picked from commit 506006055769b10d1b2b4e22f636f3b45e0e9fc7)
> Signed-off-by: Jani Nikula <jani.nikula@intel.com>
> (cherry picked from commit e0e6b416b25ee14716f3549e0cbec1011b193809)
> Signed-off-by: Janusz Krzysztofik <janusz.krzysztofik@linux.intel.com>

Both backports now queued up, thanks.

greg k-h
