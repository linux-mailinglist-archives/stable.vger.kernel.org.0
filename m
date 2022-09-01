Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 757A35A9431
	for <lists+stable@lfdr.de>; Thu,  1 Sep 2022 12:21:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233070AbiIAKVI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 1 Sep 2022 06:21:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44302 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232723AbiIAKVH (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 1 Sep 2022 06:21:07 -0400
Received: from out1-smtp.messagingengine.com (out1-smtp.messagingengine.com [66.111.4.25])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DCFB8E0FC5
        for <stable@vger.kernel.org>; Thu,  1 Sep 2022 03:21:01 -0700 (PDT)
Received: from compute2.internal (compute2.nyi.internal [10.202.2.46])
        by mailout.nyi.internal (Postfix) with ESMTP id 507455C003B;
        Thu,  1 Sep 2022 06:21:00 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute2.internal (MEProxy); Thu, 01 Sep 2022 06:21:00 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kroah.com; h=cc
        :cc:content-type:date:date:from:from:in-reply-to:in-reply-to
        :message-id:mime-version:references:reply-to:sender:subject
        :subject:to:to; s=fm1; t=1662027660; x=1662114060; bh=62NkKm7F3d
        3G9xHcuF/fP0E9SNVkeefz6lb+Xjq4hOY=; b=oGkzYUiEinyMd80+EghDy+TFTK
        BnrZ0Qy0kEIOQ/Ciw4rKDcqnVPNr+yV1KX6zQCKzWxC+awL5Wmqs4R33KolSldt4
        OQicQaw27/QqbYfxDuZ6q13qGx8oUyl+8yqlnu5zCk6zRafBlh61YUjsCAynkU/F
        57/Ns9G2P6qCKrzdmI8jDKNWFtWw+8XhjuzAS24AEptBNfbHL6cIbIrpWnJgQxkq
        rEAjPzfnpIMY4864sIJWtLMiivlDMrq1aAITiXlkkh1WCtNfD3kEyUFeYiaGTfEj
        smx5TzTbi0AEnA22p8gmP0PX74cEgShhiUDxBA7v+NH/SVk+W9HtISaja6/w==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:cc:content-type:date:date:feedback-id
        :feedback-id:from:from:in-reply-to:in-reply-to:message-id
        :mime-version:references:reply-to:sender:subject:subject:to:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm1; t=1662027660; x=1662114060; bh=62NkKm7F3d3G9xHcuF/fP0E9SNVk
        eefz6lb+Xjq4hOY=; b=mWCPdBnP+LjvdRyUTIADmkRwiFpx0qOIRe9+YI9lhJGr
        /LscUicAGNa8CTUAnIBHP8UGAm6VkhTw0lOweQ9UgtMHjNjmayyDTcCOEvK39rN6
        GVlCtqGCDNKUGrBWHsxMt6l0uEf9kDEXj0gO+d3KcXr+gr7S+U29ceaLeevW1bgb
        fEyrTuIOWjMvKfu1r0wuZ2ioafNM90zb0WJ/Ptazc/EiAL9M6tNABwsL/8CSyrqv
        npP44VbKtVKqFT3x4Nhieqza5TTtFVcb0IP1+telawKUUfPGCIRjTa4sn7xu+VeO
        EHNafEffBEYyAvsu6xTsXCiVPs+9bX9lpmBMoO/cAw==
X-ME-Sender: <xms:i4cQY5RtGJqfbO__P11wLJQMHea5sjzrJhW7vd_kAveGd5fKQsRd4w>
    <xme:i4cQYyy8PzPv-_1XQ2cJHrwU3Cx-fXrDSGCbKBwq8GUKOjvGVRNCGG6gioTaYT5jX
    NNWTzeNAIgKWg>
X-ME-Received: <xmr:i4cQY-3-Iq3N0sjRgcaSXe5_78PqsYzsFFeHIpETrQYkGoQ6a4UQcAUigv9rXCV97fKGMS__omHMN5viEbPW1BKnWkRcX1Zi>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvfedrvdekkedgvdekucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhepfffhvfevuffkfhggtggujgesthdtredttddtvdenucfhrhhomhepifhrvghg
    ucfmjfcuoehgrhgvgheskhhrohgrhhdrtghomheqnecuggftrfgrthhtvghrnhepheegvd
    evvdeljeeugfdtudduhfekledtiefhveejkeejuefhtdeufefhgfehkeetnecuvehluhhs
    thgvrhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomhepghhrvghgsehkrhhorg
    hhrdgtohhm
X-ME-Proxy: <xmx:i4cQYxDlTvYles7CitRMux6QVVHPYIUurEVGKG_fzfdNyyXJlzBUyQ>
    <xmx:i4cQYyisZwh3lcyszLIlOFU65Ceb0yF1BohGgVHMO0yyGXbzfMDqlw>
    <xmx:i4cQY1rZlp7bHGRPOWIbnNdBz1D9MfDgx200jUwv0AKQyN4hG1sJ6A>
    <xmx:jIcQY9VfjCOHCFFH_oP3uPfYgSGdsaoNT7MWs_081UJcCEQG5inQrg>
Feedback-ID: i787e41f1:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Thu,
 1 Sep 2022 06:20:59 -0400 (EDT)
Date:   Thu, 1 Sep 2022 12:20:57 +0200
From:   Greg KH <greg@kroah.com>
To:     Nicolas Schier <n.schier@avm.de>
Cc:     stable@vger.kernel.org, Jing Leng <jleng@ambarella.com>,
        Masahiro Yamada <masahiroy@kernel.org>
Subject: Re: [PATCH 5.4] kbuild: Fix include path in scripts/Makefile.modpost
Message-ID: <YxCHiTdsFI4WRF7F@kroah.com>
References: <20220831041724.1493230-1-n.schier@avm.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220831041724.1493230-1-n.schier@avm.de>
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Aug 31, 2022 at 06:17:24AM +0200, Nicolas Schier wrote:
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
> [nsc: updated context for v5.4]
> Signed-off-by: Nicolas Schier <n.schier@avm.de>
> ---
>  scripts/Makefile.modpost | 3 +--
>  1 file changed, 1 insertion(+), 2 deletions(-)
> 
> diff --git a/scripts/Makefile.modpost b/scripts/Makefile.modpost
> index 48585c4d04ad..0273bf7375e2 100644
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

Does not apply to the 5.4.y tree at all, are you sure you generated this
properly?

thanks,

greg k-h
