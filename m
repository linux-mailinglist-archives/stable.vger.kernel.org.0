Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5D602604A46
	for <lists+stable@lfdr.de>; Wed, 19 Oct 2022 17:02:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230180AbiJSPCl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 19 Oct 2022 11:02:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42254 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229872AbiJSPCX (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 19 Oct 2022 11:02:23 -0400
Received: from new1-smtp.messagingengine.com (new1-smtp.messagingengine.com [66.111.4.221])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4CF473BC7C;
        Wed, 19 Oct 2022 07:56:56 -0700 (PDT)
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailnew.nyi.internal (Postfix) with ESMTP id DC54158037C;
        Wed, 19 Oct 2022 10:55:49 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute4.internal (MEProxy); Wed, 19 Oct 2022 10:55:49 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kroah.com; h=cc
        :cc:content-type:date:date:from:from:in-reply-to:in-reply-to
        :message-id:mime-version:references:reply-to:sender:subject
        :subject:to:to; s=fm3; t=1666191349; x=1666198549; bh=vLMDs+R0Qm
        IdgQZ4Vz8PN8O4cAAR90i7fWXyp/iiOtc=; b=eyPQSFmtsV8ZrW+KoU8ZZZuZ3r
        ODVWj7YuCHZwM3N4oWayR3z/2AN1JLQFIHNaMoBx8toiX0A0FiTUJ3fKvDg887Oo
        IvZMp21KAJ84vUjsHadH3NwbxwbDUo7fnqrGmFEU92SyOJj33DcKI87e42Hllb1z
        rHyqGmJAEO+LqDbb15dQmL3ad5+yKGHNOkweoQd8+ExBXHzTmLutlC/zHQqafm/z
        Cb9G8SiIMuFqGgfZ+lt6MUrj3n18zERq7u7ESZ6s12bXWH0c+CZPFq6FzgX4eGdM
        jqf295mnXW9LI3zTK3I4Bj/ROpx886y/YHUOaKepc+X+ZnVfoLLpBTSvdosw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:cc:content-type:date:date:feedback-id
        :feedback-id:from:from:in-reply-to:in-reply-to:message-id
        :mime-version:references:reply-to:sender:subject:subject:to:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm3; t=1666191349; x=1666198549; bh=vLMDs+R0QmIdgQZ4Vz8PN8O4cAAR
        90i7fWXyp/iiOtc=; b=PkCKZoZcXQRzr50Ourdgvcz5hJGG2JhYJrLiTGCV06Ql
        ReinxzTYVo0wO7G3VQTsIUt2djGct10NNn2tKXlImjCe6Iu2ZrBBmOMS/j4Pa0x8
        zzC1JpNSG4oHQzEQUghJ9X1FA82EVYDGVb2eyNuFevea5yFOJLO3fBKFTdiKWGln
        Jb6FDg3AHFkAHJODQIDEjjpEWkjN+pZgNy28t/MNtkDynBOSC/TxTcw9LaI0aHmF
        Bf4Xs73MTikPQwdfzK0gKS4LoVQpbOpcPp+c45MmFl16dbb9Hwq24DNuXNWM1+1Z
        nM952PQeHD70YfPkqyGjBfZKpytZ4tn//ZYT9/WbXQ==
X-ME-Sender: <xms:9Q9QY_87-oWhliLkEklgr0elc74zNdq_y5dbEug9VPpbZ6J0HLNivA>
    <xme:9Q9QY7vBfJb39zKh6-i42buww6wgIrtemr7SlGG5ny9VjtwQ7MPU-VvD80rZAzGSF
    Y1l4dA7PUII8Q>
X-ME-Received: <xmr:9Q9QY9DW8OLXIUeOOI2PYxu3YxE02dh3JeHXx6Ngsp-_kx9MYYyOB1ulDcRnf2yaVnErC_Ok6PFLYXZRuWHNVGUs2qMSbhRX>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvfedrfeelgedgkeduucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhepfffhvfevuffkfhggtggujgesthdtredttddtvdenucfhrhhomhepifhrvghg
    ucfmjfcuoehgrhgvgheskhhrohgrhhdrtghomheqnecuggftrfgrthhtvghrnhepgeehue
    ehgfdtledutdelkeefgeejteegieekheefudeiffdvudeffeelvedttddvnecuffhomhgr
    ihhnpehkvghrnhgvlhdrohhrghenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmh
    epmhgrihhlfhhrohhmpehgrhgvgheskhhrohgrhhdrtghomh
X-ME-Proxy: <xmx:9Q9QY7fCLa7BEWX1y5Lz0na0bRJ2av_Nxn13_BRHIsXyBZFYo0zF-g>
    <xmx:9Q9QY0MWZLXDoPWRcpR1RTLsE-nP-D9Tr0TbDXplqBZS2SdkobusDw>
    <xmx:9Q9QY9lISEjJksidcPuIAHm-TKUaYvXXqszRRktbHPu5TRkuwVdS-g>
    <xmx:9Q9QYwsoIEQhS4X_HZaocxA6hX0RO1Xetz4aCt2z3Z8sIA39iH-Hrg>
Feedback-ID: i787e41f1:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Wed,
 19 Oct 2022 10:55:48 -0400 (EDT)
Date:   Wed, 19 Oct 2022 16:55:46 +0200
From:   Greg KH <greg@kroah.com>
To:     Jiri Olsa <jolsa@kernel.org>
Cc:     stable@vger.kernel.org, bpf@vger.kernel.org,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin Rodriguez Reboredo <yakoyoku@gmail.com>,
        Andrii Nakryiko <andrii@kernel.org>,
        Javier Martinez Canillas <javierm@redhat.com>,
        Ilya Leoshkevich <iii@linux.ibm.com>,
        Nathan Chancellor <nathan@kernel.org>,
        Philip =?iso-8859-1?Q?M=FCller?= <philm@manjaro.org>
Subject: Re: [PATCH stable 5.10 0/5] kbuild: Fix compilation for latest
 pahole release
Message-ID: <Y1AP8h6YGiDZAgyp@kroah.com>
References: <20221019085604.1017583-1-jolsa@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221019085604.1017583-1-jolsa@kernel.org>
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Oct 19, 2022 at 10:55:59AM +0200, Jiri Olsa wrote:
> hi,
> new version of pahole (1.24) is causing compilation fail for 5.10
> stable kernel, discussed in here [1][2]. Sending fix for that plus
> dependency patches.
> 
> thanks,
> jirka
> 
> 
> [1] https://lore.kernel.org/bpf/20220825163538.vajnsv3xcpbhl47v@altlinux.org/
> [2] https://lore.kernel.org/bpf/YwQRKkmWqsf%2FDu6A@kernel.org/
> ---
> Andrii Nakryiko (1):
>       kbuild: skip per-CPU BTF generation for pahole v1.18-v1.21
> 
> Ilya Leoshkevich (1):
>       bpf: Generate BTF_KIND_FLOAT when linking vmlinux
> 
> Javier Martinez Canillas (1):
>       kbuild: Quote OBJCOPY var to avoid a pahole call break the build
> 
> Jiri Olsa (1):
>       kbuild: Unify options for BTF generation for vmlinux and modules
> 
> Martin Rodriguez Reboredo (1):
>       kbuild: Add skip_encoding_btf_enum64 option to pahole
> 
>  Makefile                |  3 +++
>  scripts/link-vmlinux.sh |  2 +-
>  scripts/pahole-flags.sh | 21 +++++++++++++++++++++
>  3 files changed, 25 insertions(+), 1 deletion(-)
>  create mode 100755 scripts/pahole-flags.sh

Ah, all showed up now.  I'll look at these tomorrow, thanks!

greg k-h
