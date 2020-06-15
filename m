Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 781811FA176
	for <lists+stable@lfdr.de>; Mon, 15 Jun 2020 22:28:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731411AbgFOU20 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Jun 2020 16:28:26 -0400
Received: from out4-smtp.messagingengine.com ([66.111.4.28]:48891 "EHLO
        out4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728346AbgFOU2Y (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Jun 2020 16:28:24 -0400
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
        by mailout.nyi.internal (Postfix) with ESMTP id AAF625C00B3;
        Mon, 15 Jun 2020 16:28:23 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute1.internal (MEProxy); Mon, 15 Jun 2020 16:28:23 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kroah.com; h=
        date:from:to:cc:subject:message-id:references:mime-version
        :content-type:in-reply-to; s=fm1; bh=zaHda/1z2Mxa5qlCGOFVLukriAs
        4p8P8IzWAm+QE1x0=; b=fJ8TPHZAqgE+kS6/Py4LPP5Cck5kczjOgiDjikmDG/I
        vgqeXlJCIOexe6KdDHpv1NoUJg35LDUlw0rmlILTLBK5x4fldjQmtvQKY+/wHbL2
        g61g5O9o5RNuTFNjCl/0GCOB8qvBlBRMYNjbqx0MIO7G2KlwWjlAr0IFN6c+sG11
        zDFAkf9WTemQd/ek+erHk9oIHjS+tra1fxS9GwGiGOx1Zp4HDX6wf2w/k1aQEIuB
        ZduXeYSN2w9ioayJNJqje2MNszdNWbhlFOBjx9ddohPc7J1X6Xa5vUHHA5ACW0/E
        LokI0UvGEXatnQKzQzCeJw3dh8YcMFAsjcBwWn2dmdA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=zaHda/
        1z2Mxa5qlCGOFVLukriAs4p8P8IzWAm+QE1x0=; b=o8nWA++Qz82knNHvwT25g/
        E8EKpBPxVsLH7/hszPuXHwVt6o8/XpP3uJ0W4ut3DZrpjLLlHHo4YX/s6FWBRvDA
        aZ6P/hJk35+L6SUiDW+Slr38fc13wr1E094vIpf+Z+ipEEnr4ARCEthTenft2eb4
        mTQ2vH+8oLlmPnwHQkUBS+pmlysWgHNp9ihGq1O0ZWQ6ZHyxYXifK8+TI9m/DmpY
        9CJQJFOR8xuO+7BWLhGoNkOxW3gznnqrR6YC3sSSlh78W2CNhzsf35DhXGt0fW+f
        qBPcot6W9jo5Nup0tFg8RYca8y4KmBLbtL0zlJ6ICQqBvOVkswpCRdTQ0G2AHYPw
        ==
X-ME-Sender: <xms:59nnXgZEr2HVjoSfuZUc3h2KAx0S6oTpGHGZ_eQjdF31YwsOGM-c5A>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduhedrudeikedgudehudcutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfgh
    necuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
    enucfjughrpeffhffvuffkfhggtggujgesthdtredttddtvdenucfhrhhomhepifhrvghg
    ucfmjfcuoehgrhgvgheskhhrohgrhhdrtghomheqnecuggftrfgrthhtvghrnhepueelle
    dtheekleethfeludduvdfhffeuvdffudevgeehkeegieffveehgeeftefgnecuffhomhgr
    ihhnpehkvghrnhgvlhdrohhrghenucfkphepkeefrdekiedrkeelrddutdejnecuvehluh
    hsthgvrhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomhepghhrvghgsehkrhho
    rghhrdgtohhm
X-ME-Proxy: <xmx:59nnXrZ2O0DaWeQ3qsoXo9aFtjVVjQOPIeOZRhKuZ0vW0ISZB3E18Q>
    <xmx:59nnXq9nIQFqPGEX8cw-y6adXNFbVL26eehz3KMggEybroeeONsU7w>
    <xmx:59nnXqrLlxoye-weVZodl0eqphatOBT1bzYb6-JsPw8ButFgMhBLWA>
    <xmx:59nnXlGKd9hpf247Usj-vV_XrCCOsezjWaxTpeApPXExcxOJK_RTcg>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id 07990328005D;
        Mon, 15 Jun 2020 16:28:22 -0400 (EDT)
Date:   Mon, 15 Jun 2020 22:28:12 +0200
From:   Greg KH <greg@kroah.com>
To:     Tony Luck <tony.luck@intel.com>
Cc:     stable@vger.kernel.org, Jue Wang <juew@google.com>
Subject: Re: [PATCH stable 4.19, 5.4] x86/mm: Change so poison pages are
 either unmapped or marked uncacheable
Message-ID: <20200615202812.GC437074@kroah.com>
References: <20200615180003.24390-1-tony.luck@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200615180003.24390-1-tony.luck@intel.com>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Jun 15, 2020 at 11:00:03AM -0700, Tony Luck wrote:
> From: "Luck, Tony" <tony.luck@intel.com>
> 
> commit 17fae1294ad9d711b2c3dd0edef479d40c76a5e8 upstream
> 
> An interesting thing happened when a guest Linux instance took
> a machine check. The VMM unmapped the bad page from guest physical
> space and passed the machine check to the guest.
> 
> Linux took all the normal actions to offline the page from the process
> that was using it. But then guest Linux crashed because it said there
> was a second machine check inside the kernel with this stack trace:
> 
> do_memory_failure
>     set_mce_nospec
>          set_memory_uc
>               _set_memory_uc
>                    change_page_attr_set_clr
>                         cpa_flush
>                              clflush_cache_range_opt
> 
> This was odd, because a CLFLUSH instruction shouldn't raise a machine
> check (it isn't consuming the data). Further investigation showed that
> the VMM had passed in another machine check because is appeared that the
> guest was accessing the bad page.
> 
> Fix is to check the scope of the poison by checking the MCi_MISC register.
> If the entire page is affected, then unmap the page. If only part of the
> page is affected, then mark the page as uncacheable.
> 
> This assumes that VMMs will do the logical thing and pass in the "whole
> page scope" via the MCi_MISC register (since they unmapped the entire
> page).
> 
> Reported-by: Jue Wang <juew@google.com>
> Tested-by: Jue Wang <juew@google.com>
> Fixes: 284ce4011ba6 ("x86/memory_failure: Introduce {set, clear}_mce_nospec()")
> Cc: <stable@vger.kernel.org>
> Signed-off-by: Tony Luck <tony.luck@intel.com>
> Signed-off-by: Tony Luck <tony.luck@intel.com>
> Link: https://lore.kernel.org/r/20200520163546.GA7977@agluck-desk2.amr.corp.intel.com
> ---
>  arch/x86/include/asm/set_memory.h | 19 +++++++++++++------
>  arch/x86/kernel/cpu/mce/core.c    | 11 +++++++++--
>  include/linux/set_memory.h        |  2 +-
>  3 files changed, 23 insertions(+), 9 deletions(-)

Thanks for both backports, now queued up.

greg k-h
