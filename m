Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C63503E7BBB
	for <lists+stable@lfdr.de>; Tue, 10 Aug 2021 17:08:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239566AbhHJPIW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 Aug 2021 11:08:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45188 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234153AbhHJPIW (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 10 Aug 2021 11:08:22 -0400
Received: from mail-pl1-x631.google.com (mail-pl1-x631.google.com [IPv6:2607:f8b0:4864:20::631])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3B675C0613C1
        for <stable@vger.kernel.org>; Tue, 10 Aug 2021 08:08:00 -0700 (PDT)
Received: by mail-pl1-x631.google.com with SMTP id k2so21394502plk.13
        for <stable@vger.kernel.org>; Tue, 10 Aug 2021 08:08:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:subject:in-reply-to:cc:from:to:message-id:mime-version
         :content-transfer-encoding;
        bh=zXIE0VA4FuinL8Z/yOhm9OZFdjaDEtHYtu4g6/qx+q4=;
        b=s3c6oP2fU8fqSF8fbenJBTJhWLHtMsxaQ29gK7inXFL0FvbgZVAb25RJpQoml9Onvh
         Cu132tGd4eiwLiLOl+xKQkp7pl/KjLO55aa2GH9TURTZLS70L/R1xVa61uyGsrNuRev7
         5/ZmNOxew5QGRHc3at1hOPo++0c954wxlWh50yAH5ZuGlZ/rrNiO0AtL5foMkzoluWuT
         fHGcaVm4jAXQN+UfgQekZmjCjV6Q3M11Q2AxDlp2R8k1bmxKvVYVxZhufCYmrMPYROvo
         7RszPVoVBSTQZDSSApm8H0hSqNwt/OrOKB+iVcQJnqnBBj+mDeLRHCnzLumxTnD68gbS
         rEcQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:subject:in-reply-to:cc:from:to:message-id
         :mime-version:content-transfer-encoding;
        bh=zXIE0VA4FuinL8Z/yOhm9OZFdjaDEtHYtu4g6/qx+q4=;
        b=l+AWah4pvsKuzmax10W0D8ycaeo9pVddz6OlqfK2YhEZFWaqiSD2mNxOks/8AsemT+
         KCLlJi/unR7o5qByU+UZH99utOhShAo/BUzclwIA+Qso79FEJ+oXw4zZxQceYHUiShd6
         /XyMaitvLu/HBzjTUaHVMroEBhaK1yhtLLN/vZv06xxE12xu/wDj43WECOYUoP90g+L1
         URMNtUg0qOTY7r+Yb54Wl78dUD8wsijV4M0Ys6BQEqJ6htZEDczBCxbxYxlBINL03k24
         6fm13LK5Ap/Suq7Vyiq2670eXxt6F2oy4Om3Hf8bpY3I/0WSHaefQH8ygxCglImPXC7H
         CWdA==
X-Gm-Message-State: AOAM531IIaRKE4wlgDNkwC0VuUAgm/fKNJoTAmtgJ0Mt/oS7zvSFR0FV
        56HamlqmlRbNqEbMNXM/eTpuGQ==
X-Google-Smtp-Source: ABdhPJzqx5Nc5m3qa6DsXaktbQwS8HBJ+F7ZT6vcJzaE3M04FMMuoDPfvz66wp7N4a2QBQloMnnjaQ==
X-Received: by 2002:a65:6910:: with SMTP id s16mr904197pgq.270.1628608079479;
        Tue, 10 Aug 2021 08:07:59 -0700 (PDT)
Received: from localhost (76-210-143-223.lightspeed.sntcca.sbcglobal.net. [76.210.143.223])
        by smtp.gmail.com with ESMTPSA id q29sm2653520pfl.142.2021.08.10.08.07.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 10 Aug 2021 08:07:58 -0700 (PDT)
Date:   Tue, 10 Aug 2021 08:07:58 -0700 (PDT)
X-Google-Original-Date: Tue, 10 Aug 2021 08:07:56 PDT (-0700)
Subject:     Re: FAILED: patch "[PATCH] riscv: Get rid of CONFIG_PHYS_RAM_BASE in kernel physical" failed to apply to 5.13-stable tree
In-Reply-To: <YRJIXUxK3vn7h+W3@kroah.com>
CC:     alex@ghiti.fr, jszhang@kernel.org, kernel@esmil.dk,
        stable@vger.kernel.org
From:   Palmer Dabbelt <palmerdabbelt@google.com>
To:     Greg KH <gregkh@linuxfoundation.org>
Message-ID: <mhng-6aba8a9e-0527-47a3-8f64-128a9f7e8342@palmerdabbelt-glaptop>
Mime-Version: 1.0 (MHng)
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, 10 Aug 2021 02:35:25 PDT (-0700), Greg KH wrote:
> On Tue, Aug 10, 2021 at 10:26:31AM +0200, Alex Ghiti wrote:
>> Hi Greg,
>>
>> Le 9/08/2021 à 12:42, gregkh@linuxfoundation.org a écrit :
>> >
>> > The patch below does not apply to the 5.13-stable tree.
>>
>> I don't know when stable was cc on this patch, this fixes something
>> introduced in 5.14-rc1, so this is not normal it can't be applied.
>>
>> Sorry for the noise,
>>
>> Alex
>>
>> > If someone wants it applied there, or to any other stable or longterm
>> > tree, then please email the backport, including the original git commit
>> > id to <stable@vger.kernel.org>.
>> >
>> > thanks,
>> >
>> > greg k-h
>> >
>> > ------------------ original commit in Linus's tree ------------------
>> >
>> >  From 6d7f91d914bc90a15ebc426440c26081337ceaa1 Mon Sep 17 00:00:00 2001
>> > From: Alexandre Ghiti <alex@ghiti.fr>
>> > Date: Wed, 21 Jul 2021 09:59:35 +0200
>> > Subject: [PATCH] riscv: Get rid of CONFIG_PHYS_RAM_BASE in kernel physical
>> >   address conversion
>> >
>> > The usage of CONFIG_PHYS_RAM_BASE for all kernel types was a mistake:
>> > this value is implementation-specific and this breaks the genericity of
>> > the RISC-V kernel.
>> >
>> > Fix this by introducing a new variable phys_ram_base that holds this
>> > value at runtime and use it in the kernel physical address conversion
>> > macro. Since this value is used only for XIP kernels, evaluate it only if
>> > CONFIG_XIP_KERNEL is set which in addition optimizes this macro for
>> > standard kernels at compile-time.
>> >
>> > Signed-off-by: Alexandre Ghiti <alex@ghiti.fr>
>> > Tested-by: Emil Renner Berthing <kernel@esmil.dk>
>> > Reviewed-by: Jisheng Zhang <jszhang@kernel.org>
>> > Fixes: 44c922572952 ("RISC-V: enable XIP")
>
> But this commit id is in 5.13, is that incorrect?

I wasn't sure what to do here: IMO this fixes a bug that was there the 
whole time, it's just not one that actually manifests until the 
refactoring.  I figured I'd put the farther back tag just to be safe, in 
case someone had picked up the feature (more likely a distro tree, but 
IIUC they're also looking here).
