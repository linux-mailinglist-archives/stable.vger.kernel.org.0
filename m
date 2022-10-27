Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4184160FD55
	for <lists+stable@lfdr.de>; Thu, 27 Oct 2022 18:45:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235581AbiJ0QpC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 27 Oct 2022 12:45:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42784 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234219AbiJ0QpB (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 27 Oct 2022 12:45:01 -0400
Received: from out4-smtp.messagingengine.com (out4-smtp.messagingengine.com [66.111.4.28])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A74CD402C2
        for <stable@vger.kernel.org>; Thu, 27 Oct 2022 09:44:58 -0700 (PDT)
Received: from compute2.internal (compute2.nyi.internal [10.202.2.46])
        by mailout.nyi.internal (Postfix) with ESMTP id 8E1E35C0183;
        Thu, 27 Oct 2022 12:44:55 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute2.internal (MEProxy); Thu, 27 Oct 2022 12:44:55 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kroah.com; h=cc
        :cc:content-type:date:date:from:from:in-reply-to:in-reply-to
        :message-id:mime-version:references:reply-to:sender:subject
        :subject:to:to; s=fm3; t=1666889095; x=1666975495; bh=AYpXDOUpdf
        w0TDHk31kbXzhf3mqVzE3mgPyTTPWsdyY=; b=a5+AGTjUiCh6q9uIs5qmYAO1Qi
        D796wHBld4UFqCk8aMi0hIojJOFQnlJ+h7hlWlCe6fiUdckwkM7UaqQ0ZYYnA2Ub
        /YO2VCgfZN2kWbdpus1dK5n39rsO4EiLgnoovQr9Dmjh7a0wvv+dwXCCy7JavUcf
        B4f6wn4+QFxlmsGnpWuyz8aUdN2GZ/PZg0/W1PIQoZfSiGMj7AgJGFlZETnrnX7/
        VzW4F3aJBt+Ms43mdcnPQypZehiceBJfLNqFuKOYr5xy7bigeQgUtI+ZLXKfAfqx
        ZEYsv9TaTyzG4dXr1fi7hz584WFDgyaJFbJ1IHi6NYQIJhY6vT4GN3z/fhwg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:cc:content-type:date:date:feedback-id
        :feedback-id:from:from:in-reply-to:in-reply-to:message-id
        :mime-version:references:reply-to:sender:subject:subject:to:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm3; t=1666889095; x=1666975495; bh=AYpXDOUpdfw0TDHk31kbXzhf3mqV
        zE3mgPyTTPWsdyY=; b=YjhaEl/HTH4FNW0ePh5zhHTAng1jcXOjznZ4a03y6d2W
        uKxFWF5MmbVQWmSntf+BSQeu7Hp6sVXXcHUSBCc+tYUXstkPpcuypJWyKjTAgwJx
        fYS7xw4EMoNcIVO1HtYPhxSClB4Se4AjrWOC1lVwKBeUtivB+xZnPuFccHH6fyTI
        LBzAwHjbOmgqYwZI/KUuIl8rH96sVAwUPlc3oZS5jr/2aErUovQd82FOOPLdcRZs
        pGTFWbS5OTV+9NgjPsFPE38Udfj//lBiufLwaaifmVZBLKrtMLX3HwT68ohW1qC6
        2FbYGnxVzPKeCdx4DtrB1z5F8PiYCQE5L9z2uM1BaA==
X-ME-Sender: <xms:h7VaY5IVxULmgxStWu0kcxKAu1tXfn_M_KqIjbCPGUaDRQN3yx-6mw>
    <xme:h7VaY1J32UXZ6_4QO1ODwq7Pp369kJYYf_1Rchan2DIHishhzJjX8mzpe8OFMGohK
    04KEmZ251cyVA>
X-ME-Received: <xmr:h7VaYxvSwzHMnHi6NbrxoHEYW7KoiAY79_Nkgoy6pbkvU332jXvRnuOzo6Tz94C8ppemnL6LdGz1XPbXIyEV7-sJlcbn_HHZ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvgedrtdeggddutdefucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhepfffhvfevuffkfhggtggujgesthdtredttddtvdenucfhrhhomhepifhrvghg
    ucfmjfcuoehgrhgvgheskhhrohgrhhdrtghomheqnecuggftrfgrthhtvghrnhepheegvd
    evvdeljeeugfdtudduhfekledtiefhveejkeejuefhtdeufefhgfehkeetnecuvehluhhs
    thgvrhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomhepghhrvghgsehkrhhorg
    hhrdgtohhm
X-ME-Proxy: <xmx:h7VaY6Yj7H4Rcu8BYvOMVYklKYc4IQ3x8iSDv0as6jDXu8Rnv5xaag>
    <xmx:h7VaYwYW3j9J0FuD41bpF2V1A0POM7y6Th9Q5-JvhdrCMcv5CV77hg>
    <xmx:h7VaY-Bgx7vQ1msWYM-R7DWgv5tDLR415IX8KKBKDFTJlhQiBq8XuQ>
    <xmx:h7VaY1MDy69C2I0JU_Iu2vZ6JfLMhUZmXOQXmic1xdRDZBPMK_80JA>
Feedback-ID: i787e41f1:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Thu,
 27 Oct 2022 12:44:54 -0400 (EDT)
Date:   Thu, 27 Oct 2022 18:44:51 +0200
From:   Greg KH <greg@kroah.com>
To:     Seth Jenkins <sethjenkins@google.com>
Cc:     stable@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        Alexey Dobriyan <adobriyan@gmail.com>
Subject: Re: [PATCH stable 4.19-5.19] mm: /proc/pid/smaps_rollup: fix no
 vma's null-deref
Message-ID: <Y1q1gxgK7tQXeeBU@kroah.com>
References: <20221027153652.899495-1-sethjenkins@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221027153652.899495-1-sethjenkins@google.com>
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Oct 27, 2022 at 11:36:52AM -0400, Seth Jenkins wrote:
> Commit 258f669e7e88 ("mm: /proc/pid/smaps_rollup: convert to single value
> seq_file") introduced a null-deref if there are no vma's in the task in
> show_smaps_rollup.
> 
> Fixes: 258f669e7e88 ("mm: /proc/pid/smaps_rollup: convert to single value seq_file")
> Signed-off-by: Seth Jenkins <sethjenkins@google.com>
> Reviewed-by: Alexey Dobriyan <adobriyan@gmail.com>
> Tested-by: Alexey Dobriyan <adobriyan@gmail.com>
> ---
> c4c84f06285e on upstream resolves this issue as part of the switch to using
> maple trees for VMA lookups, but a fix must still be applied to stable trees
> 4.19-5.19.

Now queued up, thanks.

greg k-h
