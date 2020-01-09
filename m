Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 52BE813630E
	for <lists+stable@lfdr.de>; Thu,  9 Jan 2020 23:09:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725840AbgAIWJa convert rfc822-to-8bit (ORCPT
        <rfc822;lists+stable@lfdr.de>); Thu, 9 Jan 2020 17:09:30 -0500
Received: from mail-oi1-f194.google.com ([209.85.167.194]:45200 "EHLO
        mail-oi1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725775AbgAIWJa (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 9 Jan 2020 17:09:30 -0500
Received: by mail-oi1-f194.google.com with SMTP id n16so95898oie.12;
        Thu, 09 Jan 2020 14:09:29 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=b6zdP+4ezdaWmrmstWZr4Ef+4+QYkTOZwXSnjeAq9iE=;
        b=h/c797jGaQ5nZHEyYqMEwVhQvDuos1gibxLivTdQFLxWcUWxQ2f91IgJxbCYAVdqam
         uk7kjeX4Ya3X8LHUtuXhzrzFXFGH2P8YbX8FZNHfVgu5/uOoBegJZyRaZIBGBynJz+bC
         D0SbttWVnPi6ME3Z9u4ZQ8yU69oeIvlB/cfpahoaQbnyYmIjIJpuLWS+uKWtBSWs3aMd
         0mX9HrJMCc0p46iqJO/oXVJWGx+GjxowCkhoa3Kcvo2XQM47kkYQXfj8C2Oq1kUO4FaQ
         4cUCTWGJ7RLZDg3RYQseJCac1BGioYa61hRZFPg5CG5AsmdJ0mzsPbh1Xs8gLdcD5nC4
         ZtIg==
X-Gm-Message-State: APjAAAV45GeepIeseyV1pPH78pJ4KVqQnZS00xKVliliRJydzFYLs18I
        41UoWI59EKjrVOjZgLALeyz+MRr+tLQc+Sz+YCs=
X-Google-Smtp-Source: APXvYqzlIGd8xnxYkeaHlqu13vHOyX4TJHiM2RDE4U53W7gzzcU0tlk6ml61hZBx3NUsTrCijWmby0vB/c69WLU//V0=
X-Received: by 2002:aca:eb83:: with SMTP id j125mr4744312oih.153.1578607769329;
 Thu, 09 Jan 2020 14:09:29 -0800 (PST)
MIME-Version: 1.0
References: <20200109203851.7078B2072E@mail.kernel.org>
In-Reply-To: <20200109203851.7078B2072E@mail.kernel.org>
From:   Geert Uytterhoeven <geert@linux-m68k.org>
Date:   Thu, 9 Jan 2020 23:09:18 +0100
Message-ID: <CAMuHMdUBMoNRK++Uadq2CYdK_Dv5W1vrBu+6VaOc=Tn-CUPVdA@mail.gmail.com>
Subject: Re: Patch "ARM: shmobile: defconfig: Restore debugfs support" has
 been added to the 5.4-stable tree
To:     Sasha Levin <sashal@kernel.org>
Cc:     stable-commits@vger.kernel.org, stable <stable@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Sasha,

On Thu, Jan 9, 2020 at 9:38 PM Sasha Levin <sashal@kernel.org> wrote:
> This is a note to let you know that I've just added the patch titled
>
>     ARM: shmobile: defconfig: Restore debugfs support
>
> to the 5.4-stable tree which can be found at:
>     http://www.kernel.org/git/?p=linux/kernel/git/stable/stable-queue.git;a=summary
>
> The filename of the patch is:
>      arm-shmobile-defconfig-restore-debugfs-support.patch
> and it can be found in the queue-5.4 subdirectory.
>
> If you, or anyone else, feels it should not be added to the stable tree,
> please let <stable@vger.kernel.org> know about it.
>
>
>
> commit b56e3b1467eba2ba55bca05e3c8697b23304f12b
> Author: Geert Uytterhoeven <geert+renesas@glider.be>
> Date:   Mon Dec 9 11:13:27 2019 +0100
>
>     ARM: shmobile: defconfig: Restore debugfs support
>
>     [ Upstream commit fa2cdb1762d15f701b83efa60b04f0d04e71bf89 ]
>
>     Since commit 0e4a459f56c32d3e ("tracing: Remove unnecessary DEBUG_FS
>     dependency"), CONFIG_DEBUG_FS is no longer auto-enabled.  This breaks

AFAIK, that commit is not present in v5.4, and hasn't been backported yet.
So I don't think there is a need to backport this and all other fixes restoring
debugfs support in post-v5.4 kernels.

BTW, I noticed you plan to backport this "fix" not just to v5.4, but also
to v4.19?

>     booting Debian 9, as systemd needs debugfs:
>
>         [FAILED] Failed to mount /sys/kernel/debug.
>         See 'systemctl status sys-kernel-debug.mount' for details.
>         [DEPEND] Dependency failed for Local File Systems.
>         ...
>         You are in emergGive root password for maintenance
>         (or press Control-D to continue):
>
>     Fix this by enabling CONFIG_DEBUG_FS explicitly.
>
>     See also commit 18977008f44c66bd ("ARM: multi_v7_defconfig: Restore
>     debugfs support").
>
>     Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
>     Reviewed-by: Niklas Söderlund <niklas.soderlund+renesas@ragnatech.se>
>     Link: https://lore.kernel.org/r/20191209101327.26571-1-geert+renesas@glider.be
>     Signed-off-by: Sasha Levin <sashal@kernel.org>
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
