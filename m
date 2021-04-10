Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A288835ACF1
	for <lists+stable@lfdr.de>; Sat, 10 Apr 2021 13:29:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234377AbhDJL3o (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 10 Apr 2021 07:29:44 -0400
Received: from out5-smtp.messagingengine.com ([66.111.4.29]:49507 "EHLO
        out5-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231279AbhDJL3o (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 10 Apr 2021 07:29:44 -0400
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailout.nyi.internal (Postfix) with ESMTP id B8D5A5C010D;
        Sat, 10 Apr 2021 07:29:29 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute4.internal (MEProxy); Sat, 10 Apr 2021 07:29:29 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kroah.com; h=
        date:from:to:cc:subject:message-id:references:mime-version
        :content-type:content-transfer-encoding:in-reply-to; s=fm3; bh=u
        Nr89qBrvqJaDvZlgc1/0a1+GzCy4fKuCehy3CQnpJk=; b=uIEmGKvnCHjSTMXkb
        03cN8fFDEA2tPM/3wwx4NZDLWIJegLVPIR3sEXQDQHMth+tUvpAHyiPRnGP1Td9n
        +CRv8yLWzCpQC/YE1Ga9RQufQOMKUZMNqycTfTW7uXWX5Hldi9qxGEeQ8s1VRimc
        BdGTmsbHX4HtE7NF034vdL12fkJ68cxisAM1Xu+IxOQZVyqQrau8ZIYkxvlOkU6B
        PQkekTe2rAYratTBx0lyUpu+i4A8KhTOWThfE+PkDSHpcXVt7VjHutti4f/LHbgQ
        YMIPPeb5G7q9xQ2xR5xse/oAqNsWxXU0jAMZ/a9EBqxC/nl7sy/llK2yuGpj6hIS
        wdD7A==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:in-reply-to:message-id:mime-version:references
        :subject:to:x-me-proxy:x-me-proxy:x-me-sender:x-me-sender
        :x-sasl-enc; s=fm2; bh=uNr89qBrvqJaDvZlgc1/0a1+GzCy4fKuCehy3CQnp
        Jk=; b=RU9RFwWgsYM0rd8S9F8frqV1Gqo1kXtxXfEyqs/ls3x3xMHDBvSXzDDQG
        hMbfej897XTw0hNBe0o1dmX9B3dQs5Xo+aEo94gciYkO5A0kDEHh4Zi8oYapBejP
        CDjzvof54aV7NRA1OdZkFQGx6Lzr9KE4uunYNazH32GmZ7KfJ60x7z38SmgiwcAF
        8bCQ5WuO7TlX8AbTa9/I8MogId/tE8IdSpgtcaaKMfhikHsoqD0HG7REagYXoJ+v
        1ZB4ul39NX/EtXCVRY2PJVdUBjdbPu/Nl7fxQXnhmQbVk2yn1RyImldNFlVpNwPT
        E1MdhQe8mMAqCQzhBulCJLdKJNiaw==
X-ME-Sender: <xms:GYxxYOoqeGQgayIDI4q5ex3RZJTR0TNtY5WCVp43yenFyCKGbbPrFQ>
    <xme:GYxxYMqdZoE1F3H_LEN4U7d2U5VemVXu9bwnQ_dbrwvDdyQgw39kndWFrtxNJXoZp
    gHv1XSBbCqBfg>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrudekfedggeduucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpeffhffvuffkfhggtggugfgjsehtke
    ortddttddunecuhfhrohhmpefirhgvghcumffjuceoghhrvghgsehkrhhorghhrdgtohhm
    qeenucggtffrrghtthgvrhhnpeegiefgvdekgfeludehleeguddvvdfhgfegjeeufffgve
    ehuddujeeihfejveeifeenucfkphepkeefrdekiedrjeegrdeigeenucevlhhushhtvghr
    ufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpehgrhgvgheskhhrohgrhhdrtg
    homh
X-ME-Proxy: <xmx:GYxxYDMDDeSiDEGtM0NNMJUqew1t8Nk2GVLpRuWzK2tqtaiFJDf1lg>
    <xmx:GYxxYN6aUTynq7zxn-ePCQl6TliJIg61TSHMxKzPziPMFCvaK_cs0A>
    <xmx:GYxxYN4ozoQ1j8qz0C7lagHR10yuwZ8d5hH30mDUxPINtO_Aajdo6w>
    <xmx:GYxxYOX_MB4jp5Fj5uces-P44ZvghXF-aKjZDKF6nCPk6JiVyawG4Q>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA id 4EF871080066;
        Sat, 10 Apr 2021 07:29:29 -0400 (EDT)
Date:   Sat, 10 Apr 2021 13:29:27 +0200
From:   Greg KH <greg@kroah.com>
To:     "Zidenberg, Tsahi" <tsahee@amazon.com>
Cc:     stable@vger.kernel.org
Subject: Re: [PATCH 2/2] tracing/kprobes: handle userspace access on unified
 probes
Message-ID: <YHGMFzQlHomDtZYG@kroah.com>
References: <56be4b97-8283-cf09-4dac-46d602cae97c@amazon.com>
 <ea2d7cd2-9891-573e-ebcb-bfeebd79661a@amazon.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <ea2d7cd2-9891-573e-ebcb-bfeebd79661a@amazon.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Mar 29, 2021 at 01:59:48PM +0300, Zidenberg, Tsahi wrote:
> 
> commit 9de1fec50b23117f0a19f7609cc837ca72e764a6 upstream.
> 
> This is an adaptation of parts from the above commit to kernel 5.4.
> 
> Allow Kprobes to access userspace data correctly in architectures with no
> overlap between kernel and userspace addresses.
> 
> Cc: <stable@vger.kernel.org> # 5.4.x
> Signed-off-by: Tsahi Zidenberg <tsahee@amazon.com>
> ---
>  kernel/trace/trace_kprobe.c | 15 +++++++++++++++
>  1 file changed, 15 insertions(+)
> 
> diff --git a/kernel/trace/trace_kprobe.c b/kernel/trace/trace_kprobe.c
> index 233322c77b76..cbd72a1c9530 100644
> --- a/kernel/trace/trace_kprobe.c
> +++ b/kernel/trace/trace_kprobe.c
> @@ -1043,6 +1043,11 @@ fetch_store_strlen(unsigned long addr)
>      int ret, len = 0;
>      u8 c;
>  
> +#ifdef CONFIG_ARCH_HAS_NON_OVERLAPPING_ADDRESS_SPACE
> +    if (addr < TASK_SIZE)
> +        return fetch_store_strlen_user(addr);
> +#endif
> +
>      do {
>          ret = probe_kernel_read(&c, (u8 *)addr + len, 1);
>          len++;
> @@ -1071,6 +1076,11 @@ fetch_store_string(unsigned long addr, void *dest, void *base)
>      void *__dest;
>      long ret;
>  
> +#ifdef CONFIG_ARCH_HAS_NON_OVERLAPPING_ADDRESS_SPACE
> +    if (addr < TASK_SIZE)
> +        return fetch_store_string_user(addr, dest, base);
> +#endif
> +
>      if (unlikely(!maxlen))
>          return -ENOMEM;
>  
> @@ -1114,6 +1124,11 @@ fetch_store_string_user(unsigned long addr, void *dest, void *base)
>  static nokprobe_inline int
>  probe_mem_read(void *dest, void *src, size_t size)
>  {
> +#ifdef CONFIG_ARCH_HAS_NON_OVERLAPPING_ADDRESS_SPACE
> +    if ((unsigned long)src < TASK_SIZE)
> +        return probe_mem_read_user(dest, src, size);
> +#endif
> +
>      return probe_kernel_read(dest, src, size);
>  }
>  
> -- 
> 2.25.1

What problem is this fixing?

thanks,

greg k-h
