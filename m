Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 22A2939FB18
	for <lists+stable@lfdr.de>; Tue,  8 Jun 2021 17:44:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232487AbhFHPp6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 8 Jun 2021 11:45:58 -0400
Received: from wout5-smtp.messagingengine.com ([64.147.123.21]:45837 "EHLO
        wout5-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231842AbhFHPp5 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 8 Jun 2021 11:45:57 -0400
Received: from compute6.internal (compute6.nyi.internal [10.202.2.46])
        by mailout.west.internal (Postfix) with ESMTP id C13C51A35;
        Tue,  8 Jun 2021 11:44:02 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute6.internal (MEProxy); Tue, 08 Jun 2021 11:44:03 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kroah.com; h=
        date:from:to:cc:subject:message-id:references:mime-version
        :content-type:in-reply-to; s=fm1; bh=5ygIiFybP+zK8yQPHdLQWCfyes0
        YtqkvhRoExrQnHLQ=; b=StmgOIRfyD7PUs0sYAqI5A4nJtJc0rwrKmy3eKAdbY6
        MQjCk5NwpzzPeUupZCKYz08GVET5VqfWgz3E/o1T/iX0L3vhfHveBezJ4cKrTvVk
        t8nGiyZ8MEozD1cvH48c9aTFMbIcX7cQbVUdisT7oehUpS6V0mNkHFB/eZfm1u7g
        8yDazYjsgLu9mL/6axMwySl2AEy+DvV53GPFusneEB7a6liVHLP9vbsCrvIqQDM/
        dbvri3NK/ncNCjvTChCpren/zHQXqL83kLoRy1NoogsoXbspLhTe/Ro8kTmovl59
        BkoqAkMx84xDk/SHLKZGKyZlLYOFnMZbM4Cj2BNJyKg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=5ygIiF
        ybP+zK8yQPHdLQWCfyes0YtqkvhRoExrQnHLQ=; b=Auy9lhOK94qWHo7eXL6fVj
        XFIt3QGUA1jm08ktdQ0MUAR1Rt9xDJVRnGgTCociftmV+w85k4/X6OpF8fK6Z5Wl
        PbE8+bUgvjyQvGi5pnjV4z7YF8Guc8U1S9vMLwFHXMmfTlFxKzytJ8tV2U2YyzW3
        /DscPYFiWwb6YeaJpMnV2m7dgR5OpJtBYJIJV+nTSAkml6DvRNr1qmzT92eVyv75
        FFlG0vdu+GWMnxI7UlA8a952+wjj3VL/A7nUeNvu8D1k+DXS12/zFhlYzvyMFq/x
        jOxJeRFfOhvJGn8a1hvIvWvCtCTXCYxfl1CUtu6I8MxWxRFqgoyH+/VedBXcPbFA
        ==
X-ME-Sender: <xms:QZC_YIhOZNHCO9RTSctWhpWAikpQRSrf0yLySk2G7zvkrKM61KgzZA>
    <xme:QZC_YBC8meNBIjclzg3bkz5hRaNXUDc3xu6WBKpah-tf0TCLQb_WOe6Aw9ldNsx-D
    m60EP-78kBhiQ>
X-ME-Received: <xmr:QZC_YAHLiz0hdPMx228N4P80Nzofv9BL8ixP1aDyeft02fs2kdEBSCQD6RYRGgWCba5meCAqHYa4IoQdl5uDsrpdFJ8Uo1EH>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrfedtledgjeeiucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhepfffhvffukfhfgggtuggjsehttdertddttddvnecuhfhrohhmpefirhgvghcu
    mffjuceoghhrvghgsehkrhhorghhrdgtohhmqeenucggtffrrghtthgvrhhnpeevueehje
    fgfffgiedvudekvdektdelleelgefhleejieeugeegveeuuddukedvteenucevlhhushht
    vghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpehgrhgvgheskhhrohgrhh
    drtghomh
X-ME-Proxy: <xmx:QZC_YJTBtxTMMTeNWtUrqLXR0LkVDyEekwAUGa7Q-GjbuKBpetpsaQ>
    <xmx:QZC_YFwo3PJtfY8sOH1FZ-BDwqqIr_KX2kgtRR9bjx7k0ijanIQiag>
    <xmx:QZC_YH5ztrGcPyfwQqZElGdzCeNDIGSxhX6TC42_PwgusdbsyARuSg>
    <xmx:QpC_YMl1N0yr-z46Jk5dqxAQIUKEmdv7mD1m_GjEKnJTxY4kIuR1dQ>
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Tue,
 8 Jun 2021 11:44:01 -0400 (EDT)
Date:   Tue, 8 Jun 2021 17:43:58 +0200
From:   Greg KH <greg@kroah.com>
To:     Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>
Cc:     stable@vger.kernel.org, Andrea Righi <andrea.righi@canonical.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>
Subject: Re: [PATCH v3 | stable v5.12 1/3] x86/kvm: Teardown PV features on
 boot CPU as well
Message-ID: <YL+QPpGgI3R+rqg3@kroah.com>
References: <20210601071644.6055-1-krzysztof.kozlowski@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210601071644.6055-1-krzysztof.kozlowski@canonical.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Jun 01, 2021 at 09:16:42AM +0200, Krzysztof Kozlowski wrote:
> From: Vitaly Kuznetsov <vkuznets@redhat.com>
> 
> commit 8b79feffeca28c5459458fe78676b081e87c93a4 upstream.
> 
> Various PV features (Async PF, PV EOI, steal time) work through memory
> shared with hypervisor and when we restore from hibernation we must
> properly teardown all these features to make sure hypervisor doesn't
> write to stale locations after we jump to the previously hibernated kernel
> (which can try to place anything there). For secondary CPUs the job is
> already done by kvm_cpu_down_prepare(), register syscore ops to do
> the same for boot CPU.
> 
> Krzysztof:
> This fixes memory corruption visible after second resume from
> hibernation:
> 
>   BUG: Bad page state in process dbus-daemon  pfn:18b01
>   page:ffffea000062c040 refcount:0 mapcount:0 mapping:0000000000000000 index:0x1 compound_mapcount: -30591
>   flags: 0xfffffc0078141(locked|error|workingset|writeback|head|mappedtodisk|reclaim)
>   raw: 000fffffc0078141 dead0000000002d0 dead000000000100 0000000000000000
>   raw: 0000000000000001 0000000000000000 00000000ffffffff 0000000000000000
>   page dumped because: PAGE_FLAGS_CHECK_AT_PREP flag set
>   bad because of flags: 0x78141(locked|error|workingset|writeback|head|mappedtodisk|reclaim)
> 
> Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
> Message-Id: <20210414123544.1060604-3-vkuznets@redhat.com>
> Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
> Signed-off-by: Andrea Righi <andrea.righi@canonical.com>
> [krzysztof: Extend the commit message, adjust for v5.10 context]
> Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>
> ---
>  arch/x86/kernel/kvm.c | 57 +++++++++++++++++++++++++++++++------------
>  1 file changed, 41 insertions(+), 16 deletions(-)

All now queued up, thanks.

greg k-h
