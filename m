Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A698C7692D
	for <lists+stable@lfdr.de>; Fri, 26 Jul 2019 15:50:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388603AbfGZNts (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 26 Jul 2019 09:49:48 -0400
Received: from wout1-smtp.messagingengine.com ([64.147.123.24]:47311 "EHLO
        wout1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2388765AbfGZNts (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 26 Jul 2019 09:49:48 -0400
Received: from compute6.internal (compute6.nyi.internal [10.202.2.46])
        by mailout.west.internal (Postfix) with ESMTP id F00E15C9;
        Fri, 26 Jul 2019 09:49:46 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute6.internal (MEProxy); Fri, 26 Jul 2019 09:49:47 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kroah.com; h=
        date:from:to:cc:subject:message-id:references:mime-version
        :content-type:in-reply-to; s=fm1; bh=motsW62/zDKPXGCLrT7MqZ29ytZ
        w59P9Qz8xs3ekSRg=; b=aVDDRB+zax/ku7QQ5cjTDGVh7dRXVJO7keafLqzQQNk
        1X4raI1/HMUuJt14w6nbNtAIHmLyrnWLIaQPCVK5e+JwrI2bif6EJl/bSvxKDxRd
        tyYX/JxBvH3QiwVsLaz2fahvQDexwQ4r8X8mx9Tt3p64g5U2YdYx8SphmLqxYAON
        1E89TqiIjDZHbJxGDskIfpVhesxstcY8sKShZLfwCYpeLXexAeqBuymf/uw6AreC
        MiI6ieTnqI4P8h9d9l/jNxG/YvpAbINFe92mP01bvrexIIvMdJU3vCi6Iwcpv/eq
        GTcfxeoZl/qg/tBwEx8VuSmRSKJxVQsos0j3xkV8BqQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=motsW6
        2/zDKPXGCLrT7MqZ29ytZw59P9Qz8xs3ekSRg=; b=yiu5fdhUcPkBy7xm4u7X8C
        UMQ6OLqoMfAIOfGvPx4M5LHpNW7A74j4Te/PK479oa4eUI39ZzU27wczzWCs8oBC
        arIYaDxbFOqTBdmLImD7jRL9xp9s0ShU2uAmGapevAXoQgtazYbI9nZ1mpRm/gxf
        bTiibrzKM/uWMc1TdFpgMoYMACFPGQSJWGMOvibKDMUvBvXnre/mTsuwUE3bTuz4
        2pK7ez9WGoSvcMHwctuZM1K9aDaX74NqmswTJnNHbye3rJ7o0v9xKBL4KNKqUTj3
        SQzojnWYiGPQ/sGuxaviq198wDlNtgPPNGFhTp9QDfXY9gNHqDRp+otbYqudHykA
        ==
X-ME-Sender: <xms:-gQ7XTvBeiatOwXS8KwV3f58eu4a2ROmO0gQC59aAHJBgLG7PNzE2g>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduvddrkeeggdeilecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenuc
    fjughrpeffhffvuffkfhggtggujggfsehttdertddtredvnecuhfhrohhmpefirhgvghcu
    mffjuceoghhrvghgsehkrhhorghhrdgtohhmqeenucfkphepkeefrdekiedrkeelrddutd
    ejnecurfgrrhgrmhepmhgrihhlfhhrohhmpehgrhgvgheskhhrohgrhhdrtghomhenucev
    lhhushhtvghrufhiiigvpedv
X-ME-Proxy: <xmx:-gQ7XdY89d0Cinh3qP3tBJ3seK1uE1fPZ6_WEEHwgRGDggIT5x1AcQ>
    <xmx:-gQ7XfhQ1-W8hMsLqI9kLU8Z1iLO35VA6AzrElY7ga37YXS8Na7bdQ>
    <xmx:-gQ7XVVkli7gn4vuX6RTEUPAq3xTUEaCfHpmONQ6UGrN_c1XTz_ysA>
    <xmx:-gQ7Xf8kThzapeyEozunRzL5KdfaXoVrn0ak3OK0NS7ZHct_liiUaA>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id 1CB16380074;
        Fri, 26 Jul 2019 09:49:46 -0400 (EDT)
Date:   Fri, 26 Jul 2019 15:49:44 +0200
From:   Greg KH <greg@kroah.com>
To:     Vitaly Kuznetsov <vkuznets@redhat.com>
Cc:     stable@vger.kernel.org, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        Radim =?utf-8?B?S3LEjW3DocWZ?= <rkrcmar@redhat.com>
Subject: Re: [PATCH stable-5.1 0/3] KVM: x86: FPU and nested VMX guest reset
 fixes
Message-ID: <20190726134944.GC23085@kroah.com>
References: <20190725114938.3976-1-vkuznets@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190725114938.3976-1-vkuznets@redhat.com>
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Jul 25, 2019 at 01:49:35PM +0200, Vitaly Kuznetsov wrote:
> Few patches were recently marked for stable@ but commits are not
> backportable as-is and require a few tweaks. Here is 5.1 stable backport.
> 
> [PATCH2 of the series applies as-is, I have it here for completeness]
> 
> Jan Kiszka (1):
>   KVM: nVMX: Clear pending KVM_REQ_GET_VMCS12_PAGES when leaving nested
> 
> Paolo Bonzini (2):
>   KVM: nVMX: do not use dangling shadow VMCS after guest reset
>   Revert "kvm: x86: Use task structs fpu field for user"

All now applied, thanks!

greg k-h
