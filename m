Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 28773136318
	for <lists+stable@lfdr.de>; Thu,  9 Jan 2020 23:12:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725919AbgAIWMW convert rfc822-to-8bit (ORCPT
        <rfc822;lists+stable@lfdr.de>); Thu, 9 Jan 2020 17:12:22 -0500
Received: from mail-oi1-f196.google.com ([209.85.167.196]:34011 "EHLO
        mail-oi1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725951AbgAIWMW (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 9 Jan 2020 17:12:22 -0500
Received: by mail-oi1-f196.google.com with SMTP id l136so165881oig.1;
        Thu, 09 Jan 2020 14:12:21 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=AUzrpm3sEv4FUbDtxyORZJwwFEEsXnw0vdkx3PoXBx8=;
        b=ZrgxLuIx9Xcuar/ap2EP3dhR2TMCT9Gxh/LBClrvvxzj58+v6U/5ASww0KsdJkTH2X
         GaVRs28U9Nfz7HxRDp0MKr5Kuz7/G/LuQN9gR1+VYiL4Vg9JVsF4k5GcC36SJNaqTvkR
         rRe2W5I6UbroUQ1iizE0N60teiW2HIjT+xn0TfR6DE3zVKYkzcx9Qd5GNiXMbnSMOZKx
         nSMTFgDEMI7KYJzj1w21etN9zomLM2u3ToD5/o++xufC9mIqeaeF6Gf6E5SdkbytkJZt
         VVuAX7gb6tkKOCmFPGbpCG8/E0P5k5bdgiIHjQqjWMpFBWwL3AY+kaZ7gfWblBsHmX30
         32ng==
X-Gm-Message-State: APjAAAWix9CHymJnYFari0UhXeM6MMP/2a+ZzPAS9NgXAsdwUJjTZdwL
        0qtcN9T/4TBn3dgdaX1/R7zOaJ7+lRJv9/6hvZ8fe4zV
X-Google-Smtp-Source: APXvYqyX3gzA2iZLZF6a6Zoyk2WBsT2dvHOETCKarm/3/0LNleqC+csc3+SDvQAnjn9N3Mi7D44XlaDDRjRGOGiMZus=
X-Received: by 2002:aca:48cd:: with SMTP id v196mr5203388oia.102.1578607941317;
 Thu, 09 Jan 2020 14:12:21 -0800 (PST)
MIME-Version: 1.0
References: <20191227174055.4923-1-sashal@kernel.org> <20191227174055.4923-96-sashal@kernel.org>
In-Reply-To: <20191227174055.4923-96-sashal@kernel.org>
From:   Geert Uytterhoeven <geert@linux-m68k.org>
Date:   Thu, 9 Jan 2020 23:12:10 +0100
Message-ID: <CAMuHMdVgOPdo1YwcX7wG8tv5+B-ZDR62HS61p3LjqQh-se9h1Q@mail.gmail.com>
Subject: Re: [PATCH AUTOSEL 5.4 096/187] ARM: shmobile: defconfig: Restore
 debugfs support
To:     Sasha Levin <sashal@kernel.org>
Cc:     Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        stable <stable@vger.kernel.org>,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        =?UTF-8?Q?Niklas_S=C3=B6derlund?= 
        <niklas.soderlund+renesas@ragnatech.se>,
        Linux-Renesas <linux-renesas-soc@vger.kernel.org>,
        Linux ARM <linux-arm-kernel@lists.infradead.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Sasha,

(replying with the same response to an email with broader audience)

On Fri, Dec 27, 2019 at 6:42 PM Sasha Levin <sashal@kernel.org> wrote:
>
> From: Geert Uytterhoeven <geert+renesas@glider.be>
>
> [ Upstream commit fa2cdb1762d15f701b83efa60b04f0d04e71bf89 ]
>
> Since commit 0e4a459f56c32d3e ("tracing: Remove unnecessary DEBUG_FS
> dependency"), CONFIG_DEBUG_FS is no longer auto-enabled.  This breaks

AFAIK, that commit is not present in v5.4, and hasn't been backported yet.
So I don't think there is a need to backport this and all other fixes restoring
debugfs support in post-v5.4 kernels.

BTW, I noticed you plan to backport this "fix" not just to v5.4, but also
to v4.19?

> booting Debian 9, as systemd needs debugfs:
>
>     [FAILED] Failed to mount /sys/kernel/debug.
>     See 'systemctl status sys-kernel-debug.mount' for details.
>     [DEPEND] Dependency failed for Local File Systems.
>     ...
>     You are in emergGive root password for maintenance
>     (or press Control-D to continue):
>
> Fix this by enabling CONFIG_DEBUG_FS explicitly.
>
> See also commit 18977008f44c66bd ("ARM: multi_v7_defconfig: Restore
> debugfs support").
>
> Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
> Reviewed-by: Niklas Söderlund <niklas.soderlund+renesas@ragnatech.se>
> Link: https://lore.kernel.org/r/20191209101327.26571-1-geert+renesas@glider.be
> Signed-off-by: Sasha Levin <sashal@kernel.org>
> ---
>  arch/arm/configs/shmobile_defconfig | 1 +
>  1 file changed, 1 insertion(+)
>
> diff --git a/arch/arm/configs/shmobile_defconfig b/arch/arm/configs/shmobile_defconfig
> index c6c70355141c..7e7b678ae153 100644
> --- a/arch/arm/configs/shmobile_defconfig
> +++ b/arch/arm/configs/shmobile_defconfig
> @@ -215,4 +215,5 @@ CONFIG_DMA_CMA=y
>  CONFIG_CMA_SIZE_MBYTES=64
>  CONFIG_PRINTK_TIME=y
>  # CONFIG_ENABLE_MUST_CHECK is not set
> +CONFIG_DEBUG_FS=y
>  CONFIG_DEBUG_KERNEL=y

Gr{oetje,eeting}s,

                        Geert

-- 
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
