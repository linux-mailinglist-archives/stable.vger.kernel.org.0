Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F3E293950E5
	for <lists+stable@lfdr.de>; Sun, 30 May 2021 14:23:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229580AbhE3MZS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 30 May 2021 08:25:18 -0400
Received: from new3-smtp.messagingengine.com ([66.111.4.229]:58773 "EHLO
        new3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229500AbhE3MZR (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 30 May 2021 08:25:17 -0400
Received: from compute5.internal (compute5.nyi.internal [10.202.2.45])
        by mailnew.nyi.internal (Postfix) with ESMTP id 3AEC2584A26;
        Sun, 30 May 2021 08:23:39 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute5.internal (MEProxy); Sun, 30 May 2021 08:23:39 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kroah.com; h=
        date:from:to:cc:subject:message-id:references:mime-version
        :content-type:in-reply-to; s=fm3; bh=g3n6yfJqdIpcEP08vWZP1V+qNW5
        j/UC1YpybDlneieA=; b=bVjQVIMZkImoRFBCNdMSxqi97l36Wf2BOud1vPqCEEu
        10GAyEozhwuuby6wUu4YlO8cCK9mukpUsz9jHKzEdHtVcI1MSC+DjUQqv8WV6emI
        f/1kVDuUp8u3BnByDNSORtkjbJYKcgEvsczzsi0X/IhrD8UKNxzkZ0pHgvnJFCIu
        Lfuy7IGRehGFAQpW4OL7/SYOhduSRac/NV1XdCavx/yDww3zmSOwAvkyrwkrcm8z
        tEeDZOjTKaOjOdCvTp2XIeeCq8PId828weOPVFYiv8J+HELwFAUDlLaFXBLwROT1
        pEiyqlqdfSNCR6sX6AkltMHgL02QE495rkz/Mcgh5/A==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=g3n6yf
        JqdIpcEP08vWZP1V+qNW5j/UC1YpybDlneieA=; b=o1yhYCqv2BOuaGlRwh04D2
        NG00VMxCVn28NTCmXASWXJbNXaRVSoFxZx7rCBRyUaJIY48dFDzSj9VBWVrLiE3c
        bZEHl12c9NnbVF3cZxTekJy31PkqXdb3sVBy+HsXI+limfW/sij/MwWC4nArWmJP
        gmSywOpZ8fUx2UMgT6F3sODsu49XuFCttbf71UTPKk4zy1NS44giAOrg6wQtJrGc
        YsUzHbF8UeZVVI6HuHFtpf38yibb7YgFtD6ocX0BxnVcU6An/0odKoQYpWwlOJV/
        6j+yRpjchuuwMwvGyxTQ6zmBFCF0bkfuIpaMBqf/Fzx22mqFOfW2QutNelm8SONA
        ==
X-ME-Sender: <xms:yoOzYNmsu9pMRCKqtveaeE9CHmUzZe4wu7TmQ_98NxSoFz_YRpGO5g>
    <xme:yoOzYI2qNY0hIickISSlwaXInL0S57xDgKAlukHT78BmpfFHvCuvxZUmN6333mPCF
    dm2eEoSgI2MfQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrvdeluddgheduucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhepfffhvffukfhfgggtuggjsehttdertddttddvnecuhfhrohhmpefirhgvghcu
    mffjuceoghhrvghgsehkrhhorghhrdgtohhmqeenucggtffrrghtthgvrhhnpeeuleeltd
    ehkeeltefhleduuddvhfffuedvffduveegheekgeeiffevheegfeetgfenucffohhmrghi
    nhepkhgvrhhnvghlrdhorhhgnecukfhppeekfedrkeeirdejgedrieegnecuvehluhhsth
    gvrhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomhepghhrvghgsehkrhhorghh
    rdgtohhm
X-ME-Proxy: <xmx:yoOzYDqkcM5U17kh5aLX75OqwIjZO1SeD9YCePA0CQOqpKIKXy6F9A>
    <xmx:yoOzYNl03Q_-jAF6nOsqAMvi7QBxGKrCqkq7x6trIjDnc_llJwX6Vw>
    <xmx:yoOzYL16ldoPYDYv21XAzCCswYYzn5JQ4NE7ZsXdYkn2LeQgCGsvng>
    <xmx:y4OzYC3WH5eUnM_VUZ6uLGDAv_0HaU94_fIwJcjpoGZmww_2lKcQnA>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA;
        Sun, 30 May 2021 08:23:38 -0400 (EDT)
Date:   Sun, 30 May 2021 14:23:35 +0200
From:   Greg KH <greg@kroah.com>
To:     Ovidiu Panait <ovidiu.panait@windriver.com>
Cc:     stable@vger.kernel.org, fllinden@amazon.com, bpf@vger.kernel.org,
        ast@kernel.org, daniel@iogearbox.net, yhs@fb.com,
        john.fastabend@gmail.com, samjonas@amazon.com
Subject: Re: [PATCH v2 4.19 00/19] bpf: fix verifier selftests, add
 CVE-2021-29155, CVE-2021-33200 fixes
Message-ID: <YLODx1+HRBoHU7fc@kroah.com>
References: <20210528103810.22025-1-ovidiu.panait@windriver.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210528103810.22025-1-ovidiu.panait@windriver.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, May 28, 2021 at 01:37:51PM +0300, Ovidiu Panait wrote:
> v2 updates:
> - fix the last failing verfifier selftest by backporting the following
>   commits:
> * https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?id=fb8d251ee2a6bf4d7f4af5548e9c8f4fb5f90402
> * https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux.git/commit/?h=linux-5.4.y&id=37e1cdff90c1bc448edb4d73a18d89e05e36ab55
> * https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux.git/commit/?h=linux-5.4.y&id=a801a05ca7145fd2b72dad35bd01977014241e55
> - add CVE-2021-33200 fixes + support patch from 5.4:
> * https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux.git/commit/?h=linux-5.4.y&id=8ba25a9ef9b9ca84d085aea4737e6c0852aa5bfd
> * https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?id=3d0220f6861d713213b015b582e9f21e5b28d2e0
> * https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?id=bb01a1bba579b4b1c5566af24d95f1767859771e
> * https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?id=a7036191277f9fa68d92f2071ddc38c09b1e5ee5
> 
> The CVE-2021-29155 part of this series is based on Frank van der Linden's
> backport to 5.4 and 4.14:
> https://lore.kernel.org/stable/20210429220839.15667-1-fllinden@amazon.com/
> https://lore.kernel.org/stable/20210501043014.33300-1-fllinden@amazon.com/
> 
> With this series, all verifier selftests pass:
> /root# ./test_verifier
> ...
> Summary: 916 PASSED, 0 SKIPPED, 0 FAILED
> 
> What the series does is:
> * Fix verifier selftests by backporting various bpf/selftest upstream commits +
>   add two 4.19 specific fixes
> * Backport fixes for CVE-2021-29155 from 5.4 stable, including selftest
>   changes. Only minor context adjustements were made for 4.19 backport.
> * Backport CVE-2021-33200 fixes. No modifications were made, all patches
>   apply cleanly.
> 
> The following commits that fix selftests are 4.19 specific:
> Ovidiu Panait (2):
>    1. bpf: fix up selftests after backports were fixed
> 
>       This is the 4.19 equivalent of
>       https://lore.kernel.org/stable/20210501043014.33300-3-fllinden@amazon.com/
> 
>       Basically a backport of upstream commit 80c9b2fae87b ("bpf: add various
>       test cases to selftests") adapted to 4.19 in order to fix the
>       selftests that began to fail after CVE-2019-7308 fixes.
> 
>   2. selftests/bpf: add selftest part of "bpf: improve verifier branch
>      analysis"
> 
>      This is a cherry-pick of the selftest parts that have been left out when
>      backporting 4f7b3e82589e0 ("bpf: improve verifier branch analysis") to 4.19.

All now queued up, thanks!

greg k-h
