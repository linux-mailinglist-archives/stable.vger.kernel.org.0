Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6EB732A1542
	for <lists+stable@lfdr.de>; Sat, 31 Oct 2020 11:31:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726730AbgJaKbt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 31 Oct 2020 06:31:49 -0400
Received: from out2-smtp.messagingengine.com ([66.111.4.26]:39823 "EHLO
        out2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726923AbgJaKbt (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 31 Oct 2020 06:31:49 -0400
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailout.nyi.internal (Postfix) with ESMTP id CCC075C0061;
        Sat, 31 Oct 2020 06:31:47 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute4.internal (MEProxy); Sat, 31 Oct 2020 06:31:47 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kroah.com; h=
        date:from:to:cc:subject:message-id:references:mime-version
        :content-type:in-reply-to; s=fm2; bh=uezVWhGmDkUYttCz0C6RGXcT4BV
        seFQq97MY6s/mbtE=; b=jEDxjAi6oeNdlgG5bCmAHsi17mrzkqW9JYoiH/UYOWu
        9c/gLNLfJlzzhj4ENIcw9Y1KgH8FRTF3C65iBdYBj1trTGjjJP7M7YESIoq4GYgQ
        LtNig4dEgv76fDYgBa70jZDkqT4jx8oLlOsMacR6COar86AdCHbfWNpeQEzW6qvE
        0vTDt5RkD4mtAINWVpc2Y05sYdrTw7sttdtuP6KjbnxdQnXQQRbDDm8Jb/CMSXe8
        5jj/AYvExCTdAbdoIHqZO8GQhxfhlIlEqEaKr5gcfxdY/uNeyX9WeFPF6yOXTsMh
        v4Do0DRKcrK5T76M8/Re2URCuOQkmfWDK4wxOl5MogA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=uezVWh
        GmDkUYttCz0C6RGXcT4BVseFQq97MY6s/mbtE=; b=oxKRVjq1xamFZIHz0cIuDO
        duyOcSp0tyqL9un+CD7Vfw4Lx+TeBw/S4edbTK23GFkVugQj+tHZaWZtK4PUO6sD
        eBCwMBPqwmwvdtuE9wNleSQP/0FhPYxYmwCBg9evxPJyukkUvBSNnuVvHLLLc+Nb
        cMagWECMAQY/MqY3vKcrv5+sXV5z2RKfv7bHYMTfHXgym/0XL9ry9AHtpgSQvQaZ
        GHzfkp53Ko6VzE2EGUvdjxc5zbRtrGbpzBlnin/XzP0Mgjn9KZ1gMcyLRC+/8k+P
        eU8HoOvEv3Wb4p+izOrEkIJeqmkKzlABPB3KNp/S5mkiw+Pyzf0XylYjwgEjWKWg
        ==
X-ME-Sender: <xms:Ez2dX5ExMRVJVGX7WWL0y0cCOImb18RmR5HOQXIBv4sv_le8HDZwhA>
    <xme:Ez2dX-V8HPAde11UH2X-gUNq-bMbfoNpLY0lZ9e0i3xdraL4qOJ3MJ2rlvskv8JDw
    _xawZvhuTfy5w>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedujedrleejgddujecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenuc
    fjughrpeffhffvuffkfhggtggujgesthdtredttddtvdenucfhrhhomhepifhrvghgucfm
    jfcuoehgrhgvgheskhhrohgrhhdrtghomheqnecuggftrfgrthhtvghrnhepueelledthe
    ekleethfeludduvdfhffeuvdffudevgeehkeegieffveehgeeftefgnecuffhomhgrihhn
    pehkvghrnhgvlhdrohhrghenucfkphepkeefrdekiedrjeegrdeigeenucevlhhushhtvg
    hrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpehgrhgvgheskhhrohgrhhdr
    tghomh
X-ME-Proxy: <xmx:Ez2dX7JD04Ttn4SYmVu5JSs96cm2oVZrEy9-GqUBbaHeqmBdDu4wpQ>
    <xmx:Ez2dX_EqwWVe3jWNLKr8vrDXyW-P1WVANjb-NvV7VfdEwG8vGPBtHg>
    <xmx:Ez2dX_WSQ7CNPDXpKv44u8qt49fudnFUFfKUvVPNpsvG-i-pvf5FKQ>
    <xmx:Ez2dX2dDvhbGxJAZz7g6O8xQh9Ci_BGTeQZxLsPQGobXRWdhvyPteQ>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA id 17EA13064680;
        Sat, 31 Oct 2020 06:31:47 -0400 (EDT)
Date:   Sat, 31 Oct 2020 11:32:34 +0100
From:   Greg KH <greg@kroah.com>
To:     Stafford Horne <shorne@gmail.com>
Cc:     stable@vger.kernel.org, Openrisc <openrisc@lists.librecores.org>,
        Luc Van Oostenryck <luc.vanoostenryck@gmail.com>
Subject: Re: [PATCH 1/1] openrisc: Fix issue with get_user for 64-bit values
Message-ID: <20201031103234.GB961225@kroah.com>
References: <20201018201651.2604140-1-shorne@gmail.com>
 <20201018201651.2604140-2-shorne@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201018201651.2604140-2-shorne@gmail.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Oct 19, 2020 at 05:16:51AM +0900, Stafford Horne wrote:
> commit d877322bc1adcab9850732275670409e8bcca4c4 upstream
> 
> Backport of v5.9 commit d877322bc1ad for v5.8.y and v5.4.y.
> 
> Change in backport:
>  - The original commit depends on a series of sparse warning fix
>    patches.  This patch elliminates that requirement.
> 
> A build failure was raised by kbuild with the following error.
> 
>     drivers/android/binder.c: Assembler messages:
>     drivers/android/binder.c:3861: Error: unrecognized keyword/register name `l.lwz ?ap,4(r24)'
>     drivers/android/binder.c:3866: Error: unrecognized keyword/register name `l.addi ?ap,r0,0'
> 
> The issue is with 64-bit get_user() calls on openrisc.  I traced this to
> a problem where in the internally in the get_user macros there is a cast
> to long __gu_val this causes GCC to think the get_user call is 32-bit.
> This binder code is really long and GCC allocates register r30, which
> triggers the issue. The 64-bit get_user asm tries to get the 64-bit pair
> register, which for r30 overflows the general register names and returns
> the dummy register ?ap.
> 
> The fix here is to move the temporary variables into the asm macros.  We
> use a 32-bit __gu_tmp for 32-bit and smaller macro and a 64-bit tmp in
> the 64-bit macro.  The cast in the 64-bit macro has a trick of casting
> through __typeof__((x)-(x)) which avoids the below warning.  This was
> borrowed from riscv.
> 
>     arch/openrisc/include/asm/uaccess.h:240:8: warning: cast to pointer from integer of different size
> 
> I tested this in a small unit test to check reading between 64-bit and
> 32-bit pointers to 64-bit and 32-bit values in all combinations.  Also I
> ran make C=1 to confirm no new sparse warnings came up.  It all looks
> clean to me.
> 
> Link: https://lore.kernel.org/lkml/202008200453.ohnhqkjQ%25lkp@intel.com/
> Signed-off-by: Stafford Horne <shorne@gmail.com>
> Reviewed-by: Luc Van Oostenryck <luc.vanoostenryck@gmail.com>
> ---
>  arch/openrisc/include/asm/uaccess.h | 35 ++++++++++++++++++-----------
>  1 file changed, 22 insertions(+), 13 deletions(-)
> 

Now queued up, thanks.

greg k-h
