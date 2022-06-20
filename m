Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AB30D5517D3
	for <lists+stable@lfdr.de>; Mon, 20 Jun 2022 13:53:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241509AbiFTLxr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Jun 2022 07:53:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40108 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239789AbiFTLxq (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Jun 2022 07:53:46 -0400
Received: from out4-smtp.messagingengine.com (out4-smtp.messagingengine.com [66.111.4.28])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 91A5D26DC;
        Mon, 20 Jun 2022 04:53:45 -0700 (PDT)
Received: from compute2.internal (compute2.nyi.internal [10.202.2.46])
        by mailout.nyi.internal (Postfix) with ESMTP id 002EC5C016C;
        Mon, 20 Jun 2022 07:53:44 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute2.internal (MEProxy); Mon, 20 Jun 2022 07:53:45 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kroah.com; h=cc
        :cc:content-type:date:date:from:from:in-reply-to:in-reply-to
        :message-id:mime-version:references:reply-to:sender:subject
        :subject:to:to; s=fm2; t=1655726024; x=1655812424; bh=Y+1ESBA9Is
        I+iRB5+jQBFbcdOi0iPcqA++20lElc3hg=; b=Io6UhmJvaC1FoVxHZJrCKFpyOh
        rINcO69oMm/0UV11V3RH7maqJe6sbNp/IhEJqhUd9KKM2md4OY4w4CiIicJ9yFNZ
        rZCFvQrjzlS29BFCtnh4ZRQlYTKw2qYdDXOOr3DP/uhMkyUFfJjV+aUnP/PKkT1q
        iM4aEbSzm6rGdKCjNYNeBVXLWx0FCmXx1TKU+PSKjjx3dC+/7jJxLF6MP8xd2r3a
        AmCgP8nt9vgpSr7aUq4Pak6X0aYRdrqlteG1OQft/6xgLLmniLNTU3caxVfs5Kyh
        S/nYTji5Xi/e8XeNy6vvbgcoS/DRWIqAE/L3w6P1/buzzMOwzgnS8vyznSow==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:cc:content-type:date:date:feedback-id
        :feedback-id:from:from:in-reply-to:in-reply-to:message-id
        :mime-version:references:reply-to:sender:subject:subject:to:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm2; t=1655726024; x=1655812424; bh=Y+1ESBA9IsI+iRB5+jQBFbcdOi0i
        PcqA++20lElc3hg=; b=ZQKehoPa92vHTB3MVokYv0jGD3YgpQGvHsf+7hFhM6bZ
        ctnu+AlzMCAwOAPIhtIZXfGPTsJE7al3E5I0t36vg9o0rj5H8Fq1qKDmpnvN1Feb
        9ln3Cneoqx3rif8B7ZorZr+vscztBQKzPkxchGDw4M7bAlU5kJ0H0OTHg5yB4Wvn
        wjfESFXEHcxU/2COzMIs/u4leikWuz6IeEsMRR7RXji6E6bsEhFcaGsW1L/3GoS0
        FNe1EGJjbI5bnGoY1Q6BPm4nmfZ9AVSxw72P0oLmJ5m2jop6b3sH39ZbGwLr0TZg
        uHpWbd/Wxeqc7EKoL0yVKaPa0aTPvs2opaiLe+licQ==
X-ME-Sender: <xms:yF-wYgAP5MfdxDk7JW_Kk_KgOM075cRy1l5AA6Nf7nY8ThN63z4RRw>
    <xme:yF-wYih_ih0c5JjpzIJvUkxTpm3XI_cuRJq3VhwCikId4AJUP4agxhRvSTWscfcd0
    RDlqX7-Ozkbhw>
X-ME-Received: <xmr:yF-wYjlsduLWkjj5PPvg5nUHkxpA_U3T9j69UicGafWeyCfuxjURlojKK3j8HZMjWLi1V9PyuPKvb-f2br4UVYz6SHmCpn3r>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvfedrudefuddggeeiucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhepfffhvfevuffkfhggtggujgesthdtredttddtvdenucfhrhhomhepifhrvghg
    ucfmjfcuoehgrhgvgheskhhrohgrhhdrtghomheqnecuggftrfgrthhtvghrnhepgeehue
    ehgfdtledutdelkeefgeejteegieekheefudeiffdvudeffeelvedttddvnecuffhomhgr
    ihhnpehkvghrnhgvlhdrohhrghenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmh
    epmhgrihhlfhhrohhmpehgrhgvgheskhhrohgrhhdrtghomh
X-ME-Proxy: <xmx:yF-wYmy2FklshFwWNHRNFtFirhSO2PFccWwOJrRpYPs4cdYcF-RWAA>
    <xmx:yF-wYlR4ZJZ6TuavJxxGeYdSn8YBrebt3kQD-fzfXJzcuTdfOkM_GQ>
    <xmx:yF-wYhZQOZOGmJIHCoWEvHyiNRm0cuD0Pw7zbW-IJN8A8YfNHhseHA>
    <xmx:yF-wYmSJ73Wh2ZjQveb_0CpkecEnzMkLq5iisX5MOzp8Snbz-XzueQ>
Feedback-ID: i787e41f1:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Mon,
 20 Jun 2022 07:53:43 -0400 (EDT)
Date:   Mon, 20 Jun 2022 13:53:41 +0200
From:   Greg KH <greg@kroah.com>
To:     Mark-PK Tsai <mark-pk.tsai@mediatek.com>
Cc:     Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will@kernel.org>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        yj.chiang@mediatek.com,
        Jean-Philippe Brucker <jean-philippe@linaro.org>,
        stable@vger.kernel.org, Masami Hiramatsu <mhiramat@kernel.org>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-mediatek@lists.infradead.org
Subject: Re: [PATCH 5.4] arm64: kprobes: Use BRK instead of single-step when
 executing instructions out-of-line
Message-ID: <YrBfxXwumb30FEtV@kroah.com>
References: <20220615015928.19181-1-mark-pk.tsai@mediatek.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220615015928.19181-1-mark-pk.tsai@mediatek.com>
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Jun 15, 2022 at 09:59:23AM +0800, Mark-PK Tsai wrote:
> From: Jean-Philippe Brucker <jean-philippe@linaro.org>
> 
> commit 7ee31a3aa8f490c6507bc4294df6b70bed1c593e upstream.
> 
> Commit 36dadef23fcc ("kprobes: Init kprobes in early_initcall") enabled
> using kprobes from early_initcall. Unfortunately at this point the
> hardware debug infrastructure is not operational. The OS lock may still
> be locked, and the hardware watchpoints may have unknown values when
> kprobe enables debug monitors to single-step instructions.
> 
> Rather than using hardware single-step, append a BRK instruction after
> the instruction to be executed out-of-line.
> 
> Fixes: 36dadef23fcc ("kprobes: Init kprobes in early_initcall")
> Suggested-by: Will Deacon <will@kernel.org>
> Signed-off-by: Jean-Philippe Brucker <jean-philippe@linaro.org>
> Acked-by: Masami Hiramatsu <mhiramat@kernel.org>
> Link: https://lore.kernel.org/r/20201103134900.337243-1-jean-philippe@linaro.org
> Signed-off-by: Will Deacon <will@kernel.org>
> Link: https://lore.kernel.org/lkml/20220610063619.7921-1-mark-pk.tsai@mediatek.com/
> Cc: stable@vger.kernel.org
> Signed-off-by: Mark-PK Tsai <mark-pk.tsai@mediatek.com>

Now queued up, thanks.

greg k-h
