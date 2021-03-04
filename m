Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0C20832D483
	for <lists+stable@lfdr.de>; Thu,  4 Mar 2021 14:49:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241536AbhCDNtI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 4 Mar 2021 08:49:08 -0500
Received: from wout1-smtp.messagingengine.com ([64.147.123.24]:52769 "EHLO
        wout1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S241531AbhCDNtF (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 4 Mar 2021 08:49:05 -0500
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailout.west.internal (Postfix) with ESMTP id 6AEEF1427;
        Thu,  4 Mar 2021 08:48:19 -0500 (EST)
Received: from mailfrontend1 ([10.202.2.162])
  by compute4.internal (MEProxy); Thu, 04 Mar 2021 08:48:19 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kroah.com; h=
        date:from:to:cc:subject:message-id:references:mime-version
        :content-type:in-reply-to; s=fm3; bh=DQk+fVQWg7QVeTQR2torAfBzJdw
        D7skt7PPRTAqJAdk=; b=eSbvzT5s8PoimNGpOwGfgtVhpXdhMHIRaO9/NtTKps+
        928zjc+CEyeSbSw1oTgT/SeTbean66mgor0+Be/IqYu7Y6sERzAu8xlK4PaKRH92
        KSP2G0Tw20rVmzntqgQ0pCx03mLN/LRiWLC0S6THk6ag590RST7KAMebt1DSciZ5
        IjkCLiuv41Hv/kvafj0qA3JpsfXaUc/TmplutqwK2AT537tBiAC4cKm/2/lLwLYV
        NGLjlEi0D0jBFdbvdvox8qd4rZ0RK0AFAb8SEESJF1P2jNRheIWWtKENEb6tVMGY
        58x3S/qJSGk1csotWE7TTl6dUCHXoD0xCnQTDMYqt2Q==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=DQk+fV
        QWg7QVeTQR2torAfBzJdwD7skt7PPRTAqJAdk=; b=oNwmVy+wy3PfEGboq91e1P
        gOKrjA/JHKgoMKPXw+3YMZNSUc/0/QKkdi0CNlATgXEb5ebF5SPHQIqK7xhbrZVF
        O/ZXNRrVSzuYA10eELYjiuhYsH/cA75VxtyY4Y6RVEbTwnN6gbisoQZh4O1MI57X
        cN2LAEL9Qaze78I+uhdvJ9UCK9knJcnOMV88ya7N/qYd67OZ/nU4uWOv2smJvJ0U
        bu5BlVsASbYrOqOZCOziCScVoiwsbet6f9fTQHRLvXooDcHsR/qDdSYf5buX//hm
        oRL2Ny7XjAKbKVjdeZ1b3uCm3x0qZFfX1T7C6EJuHlVE9Xh/GJBNUDivQOfMvX4A
        ==
X-ME-Sender: <xms:I-VAYLlouIQ97x_UC0Pl9qqsl5VpwZSGRjqM0u9xE_FqBXvp5IiPSg>
    <xme:I-VAYO3oHHGJrohD7u1t2irgNznlWix7ATcGYAFVpknO2yPJqYvq8AIarEbzv4jvr
    yqzJ4xzzhk-lA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledruddtgedgheduucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhepfffhvffukfhfgggtuggjsehttdortddttddvnecuhfhrohhmpefirhgvghcu
    mffjuceoghhrvghgsehkrhhorghhrdgtohhmqeenucggtffrrghtthgvrhhnpedutdeivd
    ejgedufffgvdfhtdejuefghfehvdejhefggfeludeugfefkeegvdelhfenucffohhmrghi
    nhepkhgvrhhnvghlrdhorhhgnecukfhppeekfedrkeeirdejgedrieegnecuvehluhhsth
    gvrhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomhepghhrvghgsehkrhhorghh
    rdgtohhm
X-ME-Proxy: <xmx:I-VAYBpzcFo9wpuO3tdVmG7zFXnatiGey4et3BfdBACXc0Zggh7xkQ>
    <xmx:I-VAYDnKJXaef7yHtrxd1z5Zuh4T83sm_d6nPmm5nmQSpxE45X0yPw>
    <xmx:I-VAYJ0UlliTLFFaEhSqqtgYjwLmocRPWKispeLVhXxsBWyuk8pYSA>
    <xmx:I-VAYG8ZC3FkQjpI6MEZ5np5NDLaAKVwkse8vbLec8QSlSGyBQY-pg>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA id BDB5E240068;
        Thu,  4 Mar 2021 08:48:18 -0500 (EST)
Date:   Thu, 4 Mar 2021 14:48:17 +0100
From:   Greg KH <greg@kroah.com>
To:     Shaoying Xu <shaoyi@amazon.com>
Cc:     stable@vger.kernel.org, fllinden@amazon.com
Subject: Re: [PATCH 5.4] arm64 module: set plt* section addresses to 0x0
Message-ID: <YEDlIRilWxQCSTBF@kroah.com>
References: <20210301212346.GA1021@amazon.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210301212346.GA1021@amazon.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Mar 01, 2021 at 09:23:46PM +0000, Shaoying Xu wrote:
> commit f5c6d0fcf90ce07ee0d686d465b19b247ebd5ed7 upstream.
> 
> These plt* and .text.ftrace_trampoline sections specified for arm64 have
> non-zero addressses. Non-zero section addresses in a relocatable ELF would
> confuse GDB when it tries to compute the section offsets and it ends up
> printing wrong symbol addresses. Therefore, set them to zero, which mirrors
> the change in commit 5d8591bc0fba ("module: set ksymtab/kcrctab* section
> addresses to 0x0").
> 
> Reported-by: Frank van der Linden <fllinden@amazon.com>
> Signed-off-by: Shaoying Xu <shaoyi@amazon.com>
> Cc: <stable@vger.kernel.org>
> Link: https://lore.kernel.org/r/20210216183234.GA23876@amazon.com
> Signed-off-by: Will Deacon <will@kernel.org>
> [shaoyi@amazon.com: made same changes in arch/arm64/kernel/module.lds for 5.4]
> Signed-off-by: Shaoying Xu <shaoyi@amazon.com>
> ---
> arch/arm64/include/asm/module.lds.h was renamed from arch/arm64/kernel/module.lds
> by commit 596b0474d3d9 ("kbuild: preprocess module linker script") since v5.10.
> Therefore, made same changes in arch/arm64/kernel/module.lds for 5.4.

Now queued up, thanks.

greg k-h
