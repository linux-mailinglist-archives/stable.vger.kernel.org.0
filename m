Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E8F63524EBC
	for <lists+stable@lfdr.de>; Thu, 12 May 2022 15:50:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245295AbiELNuL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 12 May 2022 09:50:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56066 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1354494AbiELNuJ (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 12 May 2022 09:50:09 -0400
Received: from wout5-smtp.messagingengine.com (wout5-smtp.messagingengine.com [64.147.123.21])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 41A14186281;
        Thu, 12 May 2022 06:50:06 -0700 (PDT)
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
        by mailout.west.internal (Postfix) with ESMTP id DE81F320091A;
        Thu, 12 May 2022 09:50:03 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute1.internal (MEProxy); Thu, 12 May 2022 09:50:05 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kroah.com; h=cc
        :cc:content-type:date:date:from:from:in-reply-to:in-reply-to
        :message-id:mime-version:references:reply-to:sender:subject
        :subject:to:to; s=fm1; t=1652363403; x=1652449803; bh=ExibuCiB+X
        dpmRZ8B1eDLpOU68gZln+bHOo4WJx0oDY=; b=PdVFdC7VYDOQw5CEXCIZw264ZA
        BrUaSsb5Wf5CMzhAZWRsLjgdReoP0FvjlGw25lZ3zPDmV9YNfFYqmmIOpYtGiYHS
        8dRptuAFDVOqZQisU38kXNMsEOHIjwub1T6ziKtc7tJMo69M10rUhNwHcnn6NPa1
        xXK3N8BVf/5bhNuvplg8lFdS11UXxN70tPEpzdYVspHRtzHBG9tRCUuLZNYJ4AHa
        xuVRJu0gxbEeYIISPPb6qQkWwA/zXxNH9mHmbdi3EzF5HQZTFskre8lgZ8L5uEG2
        YTtksexJsif3uNSqc80XiHmx6ICuQlqBp4H9M16lLSOtQsZ66AJEYl8e4WtQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:cc:content-type:date:date:from:from
        :in-reply-to:in-reply-to:message-id:mime-version:references
        :reply-to:sender:subject:subject:to:to:x-me-proxy:x-me-proxy
        :x-me-sender:x-me-sender:x-sasl-enc; s=fm1; t=1652363403; x=
        1652449803; bh=ExibuCiB+XdpmRZ8B1eDLpOU68gZln+bHOo4WJx0oDY=; b=q
        wX5clGN0EVj3owZf9qYbBDlYCVylNXNnDkF66APYuJc460HIwB7AJ/hpVBFhyKmg
        aWNKZBr1lAct+VI+wxLoMJYaQZvUBbRlyvYg1qP4am2X+VK9vi1Z28JxqHsJTKJc
        jQAfShvS6XdetAqyhm1NfoieoZTlc20nCTczXHPPxJckYI2QcYCymoarHu+RUCDl
        d6xLOc1gcCkYMbl668HkOQBmAXtRaFHopR8fuVmdlwyATpdxj7OhJZwWyCTDNDvl
        ggwAFIkOUycXgh7dB+yckXreOoHEz27BTXXWKs/VXIdndWWbiKZyA2u7MRrT2q7F
        qdQXwMR53OGABMyvcT8/g==
X-ME-Sender: <xms:ihB9YlH5YhDCCfFU1-PQCN-V-Vk1UGwkFWkT1i_KFVV7CLWZ7_SuVQ>
    <xme:ihB9YqUJxUL2sxSV-bsZFm5KuQ01EgSkKN40yQjOPHTbA121yQSXVnXVaX47HVTGj
    izklTCp4iYhWg>
X-ME-Received: <xmr:ihB9YnKxC2YCf-R8fgkxS9OrB8OhyRPaugpNdCbZXPNIHwBOOk2BzJhP897hkbmKJ3-pD1r7V_w3EPlklvF4EA9T7kaBrJhe>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvfedrgeejgdeiiecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenuc
    fjughrpeffhffvvefukfhfgggtuggjsehttdertddttddvnecuhfhrohhmpefirhgvghcu
    mffjuceoghhrvghgsehkrhhorghhrdgtohhmqeenucggtffrrghtthgvrhhnpeehgedvve
    dvleejuefgtdduudfhkeeltdeihfevjeekjeeuhfdtueefhffgheekteenucevlhhushht
    vghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpehgrhgvgheskhhrohgrhh
    drtghomh
X-ME-Proxy: <xmx:ihB9YrFlYqrS2mVEyNHBtMGKY1Fcr-uxnzGl6PcLkHPsl54uIfxE5g>
    <xmx:ihB9YrUWsmzKUFvvYGp7q9VegyzjTuyNAZbLgRmtslx5s5K_xMV4lQ>
    <xmx:ihB9YmPl_K0JK-Pj15oqr9N55FpAIC8jybswVOZX83UrfttMiszpOA>
    <xmx:ixB9YvlZ54db-38vaUuhoou7aHMguqLiFO4Pwef3-5RJYEh25hNrBg>
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Thu,
 12 May 2022 09:50:01 -0400 (EDT)
Date:   Thu, 12 May 2022 15:49:59 +0200
From:   Greg KH <greg@kroah.com>
To:     Kyle Huey <me@kylehuey.com>
Cc:     stable@vger.kernel.org, kvm@vger.kernel.org, x86@kernel.org,
        Robert O'Callahan <robert@ocallahan.org>,
        Keno Fischer <keno@juliacomputing.com>,
        Like Xu <likexu@tencent.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH 5.4] KVM: x86/pmu: Refactoring find_arch_event() to
 pmc_perf_hw_id()
Message-ID: <Yn0Qh+ZiON2+gaph@kroah.com>
References: <20220510155814.40457-1-khuey@kylehuey.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220510155814.40457-1-khuey@kylehuey.com>
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_PASS,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, May 10, 2022 at 08:58:14AM -0700, Kyle Huey wrote:
> From: Like Xu <likexu@tencent.com>
> 
> [ Upstream commit 7c174f305cbee6bdba5018aae02b84369e7ab995 ]
> 
> The find_arch_event() returns a "unsigned int" value,
> which is used by the pmc_reprogram_counter() to
> program a PERF_TYPE_HARDWARE type perf_event.
> 
> The returned value is actually the kernel defined generic
> perf_hw_id, let's rename it to pmc_perf_hw_id() with simpler
> incoming parameters for better self-explanation.
> 
> Signed-off-by: Like Xu <likexu@tencent.com>
> Message-Id: <20211130074221.93635-3-likexu@tencent.com>
> Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
> Signed-off-by: Sasha Levin <sashal@kernel.org>
> [Backport to 5.4: kvm_x86_ops is a pointer here]
> Signed-off-by: Kyle Huey <me@kylehuey.com>]
> ---
>  arch/x86/kvm/pmu.c           | 8 +-------
>  arch/x86/kvm/pmu.h           | 3 +--
>  arch/x86/kvm/pmu_amd.c       | 8 ++++----
>  arch/x86/kvm/vmx/pmu_intel.c | 9 +++++----
>  4 files changed, 11 insertions(+), 17 deletions(-)

Now queued up, thanks.

greg k-h
