Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 866DF29D5C0
	for <lists+stable@lfdr.de>; Wed, 28 Oct 2020 23:08:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730292AbgJ1WI3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 28 Oct 2020 18:08:29 -0400
Received: from mail.kernel.org ([198.145.29.99]:53242 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730324AbgJ1WI2 (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 28 Oct 2020 18:08:28 -0400
Received: from localhost (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6BE2624724;
        Wed, 28 Oct 2020 22:08:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603922907;
        bh=yL5J7c1q5ay690O6rsSJuvA1s+2PdZYpho9NQRq8YWw=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=XalUGPqlra2XP8lwKDPMvpxskZkdfBM9b/GDI7B3tQ87XeRlSYn9K6j60JPFbqrDz
         rJg9FXRu3jJX9GoYhgfuaqIqiEfawZMnKChIm24CBR5wLETc8IbY6rflU0IIvN8SMK
         Xlv5pKee3cw5Nx1VMiUWN7GMGdOnmLcFcN1FRYvA=
Date:   Wed, 28 Oct 2020 18:08:26 -0400
From:   Sasha Levin <sashal@kernel.org>
To:     Alan Maguire <alan.maguire@oracle.com>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Alexei Starovoitov <ast@kernel.org>
Subject: Re: [PATCH 5.8 574/633] selftests/bpf: Fix overflow tests to reflect
 iter size increase
Message-ID: <20201028220826.GB87646@sasha-vm>
References: <20201027135522.655719020@linuxfoundation.org>
 <20201027135549.734594680@linuxfoundation.org>
 <alpine.LRH.2.21.2010271538290.12876@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <alpine.LRH.2.21.2010271538290.12876@localhost>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Oct 27, 2020 at 03:42:10PM +0000, Alan Maguire wrote:
>On Tue, 27 Oct 2020, Greg Kroah-Hartman wrote:
>
>> From: Alan Maguire <alan.maguire@oracle.com>
>>
>> [ Upstream commit eb58bbf2e5c7917aa30bf8818761f26bbeeb2290 ]
>>
>> bpf iter size increase to PAGE_SIZE << 3 means overflow tests assuming
>> page size need to be bumped also.
>>
>
>Alexei can correct me if I've got this wrong but I don't believe
>it's a stable backport candidate.
>
>This selftests change should only be relevant when the BPF iterator
>size has been bumped up as it was in
>
>af65320 bpf: Bump iter seq size to support BTF representation of large
>data structures
>
>...so I don't _think_ this commit belongs in stable unless the
>above commit is backported also (and unless I'm missing something
>I don't see a burning reason to do that currently).
>
>Backporting this alone will likely induce bpf test failures.
>Apologies if the "Fix" in the title was misleading; it should
>probably have been "Update" to reflect the fact it's not fixing
>an existing bug but rather updating the test to operate correctly
>in the context of other changes in the for-next patch series
>it was part of.

I'll drop it, thanks!

-- 
Thanks,
Sasha
