Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C5190500B47
	for <lists+stable@lfdr.de>; Thu, 14 Apr 2022 12:39:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235333AbiDNKlk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 14 Apr 2022 06:41:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46454 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233528AbiDNKlk (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 14 Apr 2022 06:41:40 -0400
Received: from out2-smtp.messagingengine.com (out2-smtp.messagingengine.com [66.111.4.26])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9F2C876E07
        for <stable@vger.kernel.org>; Thu, 14 Apr 2022 03:39:15 -0700 (PDT)
Received: from compute2.internal (compute2.nyi.internal [10.202.2.46])
        by mailout.nyi.internal (Postfix) with ESMTP id 7970B5C0220;
        Thu, 14 Apr 2022 06:39:14 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute2.internal (MEProxy); Thu, 14 Apr 2022 06:39:14 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kroah.com; h=cc
        :cc:content-transfer-encoding:content-type:date:date:from:from
        :in-reply-to:in-reply-to:message-id:mime-version:references
        :reply-to:sender:subject:subject:to:to; s=fm1; t=1649932754; x=
        1650019154; bh=vLA0u71ZLF0VcyHL0SIWbeMVXZKhWvjOv7ANtqzkCZQ=; b=J
        cg75aITzxJRy3Zwz1WlT4n4k4zIWc5BQW06/XDxGe9mz7X2rNH3d4R6BmnONxcSr
        t/a/GFDdULkb3UcjtUfOXmmIGtcuRf2m2Z4zeNUU+L0dXVocXmvkRfE9oHReaVZF
        O/lca/KQQwAcpTPwq2XwYUn3c10lyh08dqVdNRu2i8291uXb3EDxQkksOrzQvOhS
        xUIV5drK4lIScAIzIlT/v6bU+KyrKm8fMYY3FxhI2K/XfQey3QtBxnTgbzX6K1Or
        mgdMpkx6dZx3RsI1zZlFuZbTLoVbE7chNMzZQzaYF4HauJ56qyX6Y2EvkKXrtlzU
        J0o/oWg0GpoaGwrcWF8Bg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:cc:content-transfer-encoding
        :content-type:date:date:from:from:in-reply-to:in-reply-to
        :message-id:mime-version:references:reply-to:sender:subject
        :subject:to:to:x-me-proxy:x-me-proxy:x-me-sender:x-me-sender
        :x-sasl-enc; s=fm1; t=1649932754; x=1650019154; bh=vLA0u71ZLF0Vc
        yHL0SIWbeMVXZKhWvjOv7ANtqzkCZQ=; b=jMC0k3q1bG9Y2+DOGz5mC5xB0Xl5b
        P1aGUAAgFlKZ4GP1NNd5DUFleq69G4rOq/B/Miy+mP1v+5oNgr26tglNaXcFNGtI
        p5hBVzKzGx9zZVqXox051CsWdVd0PyHWdU6HwJqyOm9iEZBVzyJOuZqYj8unOEnh
        /n6Gc6QAWW+yqze+4AVWlfLGdHkKIClE8Ls0FhhrXgLf21XhY8T1EnIpKQYUSOW+
        fhCvKleHrMEAbkO4M4fEX5LA1wMU7REP0vGzNJyGAs+PbagLblgpQSm9VtitqyOb
        316XH10S2ClPPDpsvOxKYsfhDeLkM2kloJ88MnRWyU4p7Ppjy2le1Lbeg==
X-ME-Sender: <xms:0vlXYkqgg3sEfK03lXvA0wM75Dl_mIRhnwnq6sF8y7bwnxRrU7qQEw>
    <xme:0vlXYqrXOxGkUjUFXey_EN7QI3Ejb1njY0pSYFagn812bTWQpJNw-i1R3dYkbC96y
    wVCN8k9V6PTsA>
X-ME-Received: <xmr:0vlXYpPnVU474PyKh00YakZ9O-opf2mtqJMy5Azs8cdQyRk8AwZT10d4U9Z1uKQbhpHXvyFt9Rjuw0OanBW1nomqgYx0grER>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvvddrudelfedgfeduucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhepfffhvffukfhfgggtugfgjgesthekredttddtudenucfhrhhomhepifhrvghg
    ucfmjfcuoehgrhgvgheskhhrohgrhhdrtghomheqnecuggftrfgrthhtvghrnhepvedtie
    elueetgeeggfeufefhvefgtdetgfetgfdtvdegjeehieduvddtkeffheffnecuvehluhhs
    thgvrhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomhepghhrvghgsehkrhhorg
    hhrdgtohhm
X-ME-Proxy: <xmx:0vlXYr4XCcN2oEk53QJEFZxnLQU399Uvi3lk8gqUqMdWXN25lPAhEg>
    <xmx:0vlXYj6UnxmGcpOKng3omE0CWs6Q6_1KZr2GOtUpr7pOU6YXrK7DwA>
    <xmx:0vlXYrhuMDZdKYs4aoRMgZAO_KrI2acppWZUtckzQfszLZ4DWMbZ3Q>
    <xmx:0vlXYnqlYNoxwTpANenJTheHnZBurKMRLIclsQ81NeX5xwX4Hw-_IA>
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Thu,
 14 Apr 2022 06:39:13 -0400 (EDT)
Date:   Thu, 14 Apr 2022 12:39:10 +0200
From:   Greg KH <greg@kroah.com>
To:     Lee Jones <lee.jones@linaro.org>
Cc:     stable@vger.kernel.org, Felix Kuehling <Felix.Kuehling@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Christian =?iso-8859-1?Q?K=F6nig?= <christian.koenig@amd.com>,
        David Airlie <airlied@linux.ie>,
        Daniel Vetter <daniel@ffwll.ch>, amd-gfx@lists.freedesktop.org,
        dri-devel@lists.freedesktop.org
Subject: Re: [PATCH 5.10 1/1] drm/amdgpu: Ensure the AMDGPU file descriptor
 is legitimate
Message-ID: <Ylf5zmP88Lw0md47@kroah.com>
References: <20220412152057.1170235-1-lee.jones@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20220412152057.1170235-1-lee.jones@linaro.org>
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Apr 12, 2022 at 04:20:57PM +0100, Lee Jones wrote:
> [ Upstream commit b40a6ab2cf9213923bf8e821ce7fa7f6a0a26990 ]
> 
> This is a partial cherry-pick of the above upstream commit.
> 
> It ensures the file descriptor passed in by userspace is a valid one.
> 
> Cc: Felix Kuehling <Felix.Kuehling@amd.com>
> Cc: Alex Deucher <alexander.deucher@amd.com>
> Cc: "Christian König" <christian.koenig@amd.com>
> Cc: David Airlie <airlied@linux.ie>
> Cc: Daniel Vetter <daniel@ffwll.ch>
> Cc: amd-gfx@lists.freedesktop.org
> Cc: dri-devel@lists.freedesktop.org
> Signed-off-by: Lee Jones <lee.jones@linaro.org>
> ---
>  drivers/gpu/drm/amd/amdgpu/amdgpu_amdkfd_gpuvm.c | 10 +++++++---
>  1 file changed, 7 insertions(+), 3 deletions(-)

Now queued up, thanks.

greg k-h
