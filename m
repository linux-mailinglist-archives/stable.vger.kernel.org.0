Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2A9D122E207
	for <lists+stable@lfdr.de>; Sun, 26 Jul 2020 20:37:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726717AbgGZShA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 26 Jul 2020 14:37:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51942 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726072AbgGZSg7 (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 26 Jul 2020 14:36:59 -0400
Received: from mail-pj1-x1044.google.com (mail-pj1-x1044.google.com [IPv6:2607:f8b0:4864:20::1044])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CF85EC0619D2
        for <stable@vger.kernel.org>; Sun, 26 Jul 2020 11:36:59 -0700 (PDT)
Received: by mail-pj1-x1044.google.com with SMTP id mt12so524421pjb.4
        for <stable@vger.kernel.org>; Sun, 26 Jul 2020 11:36:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:subject:in-reply-to:cc:from:to:message-id:mime-version
         :content-transfer-encoding;
        bh=JnUU93WKUKWrXbn9kgNlLm9JHar+29seJwT67nss/Ow=;
        b=nG3iBDXv6+813nvKzqFi/7D1yujtCUMoArCy+DcXTmZ4I+ju4cUuNU7FW7uA5qY49Z
         ahZqNfeUh/0ve0ztq5LULa1EdAVrpXYDBPr6fNriCImZTYtzcyey4UvcFxtlbUZhf6K+
         dBMM/A/8iLFwllKgkA9vjtMBbEawjuQICs3wmlYinNGG/5h0dW1M5DxVk99vKXZn0XVy
         ANwa+nPHlWm3+6Hw/FXfkx2MdNSxPUaAHqWd8lwl6ZvyE3dpmGdtRQ3AODmaQRqLyPtY
         6lPlKthvNWbkEmlUgXvS6Y34a9+GTfX+QnlxmES6i6gOxi4ETMgasw0oEqkeVJZv4+jy
         7hgQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:subject:in-reply-to:cc:from:to:message-id
         :mime-version:content-transfer-encoding;
        bh=JnUU93WKUKWrXbn9kgNlLm9JHar+29seJwT67nss/Ow=;
        b=UhkZhb5ul0eIAX6ymysyKfrHCwFmNMsxRUD4pLn4zVH0AFOpyg3F274g+okcsQWoga
         3PD4rA81nBC/mM7bkWE+/RATQb3rQxZC6pZP7D4Kzzn23cTzyb78DFvqXwwJ6LposFGk
         M1QxB+2BAEh6yZwf0TAn0vvhRUYdslZmlBGG0ny+/jfnPE6hgBY5jS4hvCIDuIUBDgyx
         clryMJ3YYgIMOCt2USh6qGjuTjJwVP1aVwpHcdfmMd3gFSnCBKQLnnuFrp0ak+S0GyEZ
         JxddKYCKkA/2KlLp73HmEh6B62SfFiVqiGwxTwsrGi8VbfDB9D7/1AzR0A2zruKwz5uy
         GY7w==
X-Gm-Message-State: AOAM5338/NRVU19QEHYh7G+vdFa/6F/PPmcgHgQQl90eXdw7CFvdDead
        XttpFOuAE9CykB5A64zD7RWx+A==
X-Google-Smtp-Source: ABdhPJx6qjIBH11BxaatM2ew4upUkR6JBUEegthI6NcPTsjsf+zkeU/A6V44/q74Th3YbWdN+FdGdQ==
X-Received: by 2002:a17:90a:bf04:: with SMTP id c4mr2738242pjs.149.1595788619210;
        Sun, 26 Jul 2020 11:36:59 -0700 (PDT)
Received: from localhost (76-210-143-223.lightspeed.sntcca.sbcglobal.net. [76.210.143.223])
        by smtp.gmail.com with ESMTPSA id c125sm11977747pfa.119.2020.07.26.11.36.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 26 Jul 2020 11:36:58 -0700 (PDT)
Date:   Sun, 26 Jul 2020 11:36:58 -0700 (PDT)
X-Google-Original-Date: Sun, 26 Jul 2020 10:59:11 PDT (-0700)
Subject:     Re: [PATCH AUTOSEL 4.19 18/19] RISC-V: Upgrade smp_mb__after_spinlock() to iorw,iorw
In-Reply-To: <20200720213851.407715-18-sashal@kernel.org>
CC:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        sashal@kernel.org, linux-riscv@lists.infradead.org
From:   Palmer Dabbelt <palmerdabbelt@google.com>
To:     sashal@kernel.org
Message-ID: <mhng-5bf9e67f-f6f9-4c9b-9d56-afd0a6e21cd6@palmerdabbelt-glaptop1>
Mime-Version: 1.0 (MHng)
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, 20 Jul 2020 14:38:49 PDT (-0700), sashal@kernel.org wrote:
> From: Palmer Dabbelt <palmerdabbelt@google.com>
>
> [ Upstream commit 38b7c2a3ffb1fce8358ddc6006cfe5c038ff9963 ]
>
> While digging through the recent mmiowb preemption issue it came up that
> we aren't actually preventing IO from crossing a scheduling boundary.
> While it's a bit ugly to overload smp_mb__after_spinlock() with this
> behavior, it's what PowerPC is doing so there's some precedent.
>
> Signed-off-by: Palmer Dabbelt <palmerdabbelt@google.com>
> Signed-off-by: Sasha Levin <sashal@kernel.org>
> ---
>  arch/riscv/include/asm/barrier.h | 10 +++++++++-
>  1 file changed, 9 insertions(+), 1 deletion(-)
>
> diff --git a/arch/riscv/include/asm/barrier.h b/arch/riscv/include/asm/barrier.h
> index d4628e4b3a5ea..f4c92c91aa047 100644
> --- a/arch/riscv/include/asm/barrier.h
> +++ b/arch/riscv/include/asm/barrier.h
> @@ -69,8 +69,16 @@ do {									\
>   * The AQ/RL pair provides a RCpc critical section, but there's not really any
>   * way we can take advantage of that here because the ordering is only enforced
>   * on that one lock.  Thus, we're just doing a full fence.
> + *
> + * Since we allow writeX to be called from preemptive regions we need at least
> + * an "o" in the predecessor set to ensure device writes are visible before the
> + * task is marked as available for scheduling on a new hart.  While I don't see
> + * any concrete reason we need a full IO fence, it seems safer to just upgrade
> + * this in order to avoid any IO crossing a scheduling boundary.  In both
> + * instances the scheduler pairs this with an mb(), so nothing is necessary on
> + * the new hart.
>   */
> -#define smp_mb__after_spinlock()	RISCV_FENCE(rw,rw)
> +#define smp_mb__after_spinlock()	RISCV_FENCE(iorw,iorw)
>
>  #include <asm-generic/barrier.h>

While I don't think it hurts to have this, IIRC we didn't have the generic
mmiowb spinlock stuff back then so it doesn't really fix the problem.  That
said, I'm pretty sure 4.19 doesn't make it to userspace so backports are really
an academic discussion at this point.  Whatever's less work for everyone is
fine on my end for 4.19.
