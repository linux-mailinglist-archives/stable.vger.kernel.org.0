Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 00338D090F
	for <lists+stable@lfdr.de>; Wed,  9 Oct 2019 10:04:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725914AbfJIIEx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 9 Oct 2019 04:04:53 -0400
Received: from out2-smtp.messagingengine.com ([66.111.4.26]:36147 "EHLO
        out2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725879AbfJIIEx (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 9 Oct 2019 04:04:53 -0400
Received: from compute6.internal (compute6.nyi.internal [10.202.2.46])
        by mailout.nyi.internal (Postfix) with ESMTP id AAB4F220CF;
        Wed,  9 Oct 2019 04:04:51 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute6.internal (MEProxy); Wed, 09 Oct 2019 04:04:51 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kroah.com; h=
        date:from:to:cc:subject:message-id:references:mime-version
        :content-type:in-reply-to; s=fm2; bh=hQ193SL2uijxMsSZZN+E7UbjF6F
        qcanbIfpsn0ebGWk=; b=reEgUqkjVszHJSqYZVXaDviBOS/Ex3LRnfmaWJAASa8
        ypReR8lktEClOuhJR1ocG1V4ZZ6Al2tFdetTQzTDFVMIaXmMjsvD4Cx2ye4OaGGf
        DONdOOMYDenqA27KzTOxsopJ+BouSBOHg5JugvmwNfsMNiS2/0PSAJoVz0g40K+P
        hY7xl7Fd5GF/SNbBSyeDxNElCooUaYN4mviMNUvFnfyPCsNEYJrsOE9I1rApidFK
        8F0DlgwwZnJb1xSRrm48AH0LlbYxL63Sg1iQOltoTdhBeb2W1svO2yjxYbeqL1Ap
        CbuTMqGNLys5IEILpEysd0QTwqFA5N6LrXsV4CEwIfQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=hQ193S
        L2uijxMsSZZN+E7UbjF6FqcanbIfpsn0ebGWk=; b=Tn6f6UDUEcdux6cDwIfvvo
        ecmpqJ0Ry3UQ5Ez5FCpqvGqNj5lgl4wQ4++ghvad5F/0hM9+DtOiK9S2ylzGw9Fq
        0nDHboysLF7RgLaKBXiHwyJkAIg+78xgCLA4povEW+z8n4fNVriXwJouMsx4hF2P
        ywd038mK7s6Kv75UldGI73v7JAePv4IHmlKTy6dp9LqNTjSUtMYf4sQXfzjUKjmR
        QqoCEeQsG7xAe/OzmAM5ZlLcQg3NdOxWvgiAJCIs7ozZFvsrSr64DiuyZKdfqDr6
        hk6xRWXf81KJparCSLaZr7uZOTbmDIhREYQ29Ret2Xn1UokKsFTbopNbATVfnilQ
        ==
X-ME-Sender: <xms:o5SdXZzGgYdhioi2E_ntiRl1VvsDqC8iXRY2HOZytOHEUW9AFPwTCw>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedufedriedtgdduvdekucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhepfffhvffukfhfgggtuggjfgesthdtredttdervdenucfhrhhomhepifhrvghg
    ucfmjfcuoehgrhgvgheskhhrohgrhhdrtghomheqnecukfhppeekfedrkeeirdekledrud
    dtjeenucfrrghrrghmpehmrghilhhfrhhomhepghhrvghgsehkrhhorghhrdgtohhmnecu
    vehluhhsthgvrhfuihiivgeptd
X-ME-Proxy: <xmx:o5SdXditpksltbspx072ppxr-YFVc6OXhUTj4ZZ3_UWDypA_xq1bGw>
    <xmx:o5SdXeUB80ow9YeOWivLJVXiqDexBR7DyiUDH8C5G9vfPSbvx0Jqzg>
    <xmx:o5SdXf2VRqGvQjdkf-rW7JHc0fyrQXPLYhxFh23BxMPkU48kErOGDw>
    <xmx:o5SdXQ71JEy00ZlmMp5fk8TNGHSoQ321qdu4uuZHrS6Dr93frR2mRw>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id 2B0F7D60057;
        Wed,  9 Oct 2019 04:04:51 -0400 (EDT)
Date:   Wed, 9 Oct 2019 10:04:22 +0200
From:   Greg KH <greg@kroah.com>
To:     Ard Biesheuvel <ard.biesheuvel@linaro.org>
Cc:     linux-arm-kernel@lists.infradead.org, stable@vger.kernel.org,
        Will Deacon <will@kernel.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Marc Zyngier <maz@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Jeremy Linton <jeremy.linton@arm.com>,
        Andre Przywara <andre.przywara@arm.com>
Subject: Re: [PATCH for-stable-v4.19 00/16] arm64 spec mitigation backports
Message-ID: <20191009080422.GA3881278@kroah.com>
References: <20191008153930.15386-1-ard.biesheuvel@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191008153930.15386-1-ard.biesheuvel@linaro.org>
User-Agent: Mutt/1.12.2 (2019-09-21)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Oct 08, 2019 at 05:39:14PM +0200, Ard Biesheuvel wrote:
> This is a backport to v4.19 of the arm64 patches that exists in mainline
> to support CPUs that implement the SSBS capability, which gives the OS
> and user space control over whether Speculative Store Bypass is
> permitted in certain contexts. This gives a substantial performance
> boost on hardware that implements it.
> 
> At the same time, this series backports arm64 support for reporting
> of vulnerabilities via syfs. This is covered by the same series since
> it produces a much cleaner backport, where none of the patches required
> any changes beyond some manual mangling of the context to make them apply.
> 
> Build tested using a fair number of randconfig builds. Boot tested
> under KVM and on ThunderX2.

All now queued up, thanks.

greg k-h
