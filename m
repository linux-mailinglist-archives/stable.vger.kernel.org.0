Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3D1DA5A9433
	for <lists+stable@lfdr.de>; Thu,  1 Sep 2022 12:21:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233522AbiIAKV3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 1 Sep 2022 06:21:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44812 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233710AbiIAKV1 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 1 Sep 2022 06:21:27 -0400
Received: from out1-smtp.messagingengine.com (out1-smtp.messagingengine.com [66.111.4.25])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 70A0AED00E
        for <stable@vger.kernel.org>; Thu,  1 Sep 2022 03:21:26 -0700 (PDT)
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailout.nyi.internal (Postfix) with ESMTP id D501E5C0136;
        Thu,  1 Sep 2022 06:21:25 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute3.internal (MEProxy); Thu, 01 Sep 2022 06:21:25 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kroah.com; h=cc
        :cc:content-type:date:date:from:from:in-reply-to:in-reply-to
        :message-id:mime-version:references:reply-to:sender:subject
        :subject:to:to; s=fm1; t=1662027685; x=1662114085; bh=rqTtckrHep
        b/R/MHCuX41lBrcgv30lDCSawc1O9D1JU=; b=NDr+0jkOoGyLEMwYrzc+TiuseO
        SMvCAmv4vkhdpCngXUZtHJE21D6ZpYZpMK1xUqPi8/Lx2Ub1nHTGAlnAHEDjtDnR
        7TIfAHaeq+wXGzTnWuFsm0KR5lUV5MrorZGLnPNP8Wxu03ZESYTcdIuGd/gNE/3X
        iISW5UA9SUpMJhvPqdJdT3Cre1LlFvduwx4uU0l2TdhD5fCU9t7qILw+Y+r9VaZb
        xsVu7sEfXPfA6SAdBTzzyz5babvnSGgX9HBNLzTuUPVubvjZvZpSzWHV8DksYdh0
        LgJMpFVM1UfODI0Rdi/IAEUrzNA79/WFfoAbiBWBaaywsK8ceT/NfFXMB3VA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:cc:content-type:date:date:feedback-id
        :feedback-id:from:from:in-reply-to:in-reply-to:message-id
        :mime-version:references:reply-to:sender:subject:subject:to:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm1; t=1662027685; x=1662114085; bh=rqTtckrHepb/R/MHCuX41lBrcgv3
        0lDCSawc1O9D1JU=; b=1W5l37evHJf5EyRoCS97dFsi8BhMsGPxtc/tfT28J8eT
        iDQ1dA9HRkNkp+GC6NNRKcrfOnEKTuqxR9QeFM2iUlyY8SlrfG12rMubJraNSBKq
        bl/HrPEVmsapg3aLJT690nnVdlzw0rsLV1sRL/LyVoGKcIfi0KzdjWyvaN4lTzGM
        hP1dx9li44TkhtDbLgG0fYlef4p9y/5pvZ66Bk05s2F3r9BgHnE+erM7S7PY4v3k
        LbYpLZwr2nz6GvohXc+8+MAk+BqJX9qYdxUpLQiQcq9/tSU7Ytf+BuEZ/r50MPfz
        nVUqre5zC1z51bx2HpiMtFdPzsnhQP2SYXKCpwywoA==
X-ME-Sender: <xms:pYcQYzdWFVashqZpzMRdr584fF8OSfyIlCKOpij3zF36NIgVBQMvZw>
    <xme:pYcQY5M7NUdNtNP51qqH4zPx79gmfhD6zJ6eRdadFlyR_joRo9ynYID-oYCqDN4Xc
    _R__jgjcqfi4Q>
X-ME-Received: <xmr:pYcQY8jHFIJ00QMaO76skMzoInyJBUsUGZnBrIQSdgizeNt4i0EXnd-8WKdErijCHV4TCuvjzSe1iHDw8VputOQz6tJoK2A_>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvfedrvdekkedgvdekucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhepfffhvfevuffkfhggtggujgesthdtredttddtvdenucfhrhhomhepifhrvghg
    ucfmjfcuoehgrhgvgheskhhrohgrhhdrtghomheqnecuggftrfgrthhtvghrnhepheegvd
    evvdeljeeugfdtudduhfekledtiefhveejkeejuefhtdeufefhgfehkeetnecuvehluhhs
    thgvrhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomhepghhrvghgsehkrhhorg
    hhrdgtohhm
X-ME-Proxy: <xmx:pYcQY08smu8drr6nRcVHyXc0Rn7Ofpb_XXCdyxR_EfS4jJZewxWJYg>
    <xmx:pYcQY_ubix8r6TA1gTs56OdiVzI2lGzlPgs8XP6Rr-Kx6GAZ4jP7yQ>
    <xmx:pYcQYzGI39JCAcGsa5Ak0SX0emCBA8CEo3FS1qk4a62RoslLWT3d4Q>
    <xmx:pYcQYzi3cGKCpSS1OvbLSQgjcOthYdRvvGeHNNKlqmW65JEdzoicow>
Feedback-ID: i787e41f1:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Thu,
 1 Sep 2022 06:21:25 -0400 (EDT)
Date:   Thu, 1 Sep 2022 12:21:22 +0200
From:   Greg KH <greg@kroah.com>
To:     Nicolas Schier <n.schier@avm.de>
Cc:     stable@vger.kernel.org, Jing Leng <jleng@ambarella.com>,
        Masahiro Yamada <masahiroy@kernel.org>
Subject: Re: [PATCH 5.10/5.15] kbuild: Fix include path in
 scripts/Makefile.modpost
Message-ID: <YxCHoqECh0T1r1B3@kroah.com>
References: <20220831041719.1493107-1-n.schier@avm.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220831041719.1493107-1-n.schier@avm.de>
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Aug 31, 2022 at 06:17:19AM +0200, Nicolas Schier wrote:
> From: Jing Leng <jleng@ambarella.com>
> 
> commit 23a0cb8e3225122496bfa79172005c587c2d64bf upstream.
> 
> When building an external module, if users don't need to separate the
> compilation output and source code, they run the following command:
> "make -C $(LINUX_SRC_DIR) M=$(PWD)". At this point, "$(KBUILD_EXTMOD)"
> and "$(src)" are the same.
> 
> If they need to separate them, they run "make -C $(KERNEL_SRC_DIR)
> O=$(KERNEL_OUT_DIR) M=$(OUT_DIR) src=$(PWD)". Before running the
> command, they need to copy "Kbuild" or "Makefile" to "$(OUT_DIR)" to
> prevent compilation failure.
> 
> So the kernel should change the included path to avoid the copy operation.
> 
> Signed-off-by: Jing Leng <jleng@ambarella.com>
> [masahiro: I do not think "M=$(OUT_DIR) src=$(PWD)" is the official way,
> but this patch is a nice clean up anyway.]
> Signed-off-by: Masahiro Yamada <masahiroy@kernel.org>
> Signed-off-by: Nicolas Schier <n.schier@avm.de>
> ---
>  scripts/Makefile.modpost | 3 +--
>  1 file changed, 1 insertion(+), 2 deletions(-)
> 
> diff --git a/scripts/Makefile.modpost b/scripts/Makefile.modpost
> index 12a87be0fb44..42154b6df652 100644
> --- a/scripts/Makefile.modpost
> +++ b/scripts/Makefile.modpost
> @@ -87,8 +87,7 @@ obj := $(KBUILD_EXTMOD)
>  src := $(obj)
>  
>  # Include the module's Makefile to find KBUILD_EXTRA_SYMBOLS
> -include $(if $(wildcard $(KBUILD_EXTMOD)/Kbuild), \
> -             $(KBUILD_EXTMOD)/Kbuild, $(KBUILD_EXTMOD)/Makefile)
> +include $(if $(wildcard $(src)/Kbuild), $(src)/Kbuild, $(src)/Makefile)
>  
>  # modpost option for external modules
>  MODPOST += -e
> -- 
> 2.37.2
> 

Now queued up, thanks.

greg k-h
