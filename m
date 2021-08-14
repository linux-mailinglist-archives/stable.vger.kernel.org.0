Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4B6D53EC30D
	for <lists+stable@lfdr.de>; Sat, 14 Aug 2021 16:02:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232315AbhHNODJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 14 Aug 2021 10:03:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42700 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231956AbhHNODJ (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 14 Aug 2021 10:03:09 -0400
Received: from mail-pj1-x1034.google.com (mail-pj1-x1034.google.com [IPv6:2607:f8b0:4864:20::1034])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CE53CC061764;
        Sat, 14 Aug 2021 07:02:40 -0700 (PDT)
Received: by mail-pj1-x1034.google.com with SMTP id w13-20020a17090aea0db029017897a5f7bcso20239534pjy.5;
        Sat, 14 Aug 2021 07:02:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=message-id:subject:from:to:cc:date:in-reply-to:user-agent
         :mime-version:content-transfer-encoding;
        bh=/fbXKPao9RfhNoOpmTGhd3hQyQYFlKY+K99YwG6o1NA=;
        b=fvQoglxHo2NpAW6Fsh46xRCAPP79e+fFPZ6dVmDjrUvsXO8By5ifjv7qBq/nRh/VZN
         hwQ3v7kOp7XndcgbSlQT8x8J7v4qnNEjj9vIOMnehaO2nKON67I6IkzB/Jre50Pl0xX1
         WRpgN14+PKEbi7zNuwjVp7FAIXnG++Hjvh2NuHMudYR2RkWOyX3vGQlqJfyTo6P8lAOk
         Pusf12oRF1EMDXRm9Bb603d7yzg5nWKTJTVPIbgnYYD9b9BDz6Fw5aqJobmnBMV51rax
         4s0jHgcaXlaWaA7L8FX/u6reeC9Ig1jZDEflStUyyEoQX9rg4JRg77rW+tlX+PZgizE1
         MFPQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:subject:from:to:cc:date:in-reply-to
         :user-agent:mime-version:content-transfer-encoding;
        bh=/fbXKPao9RfhNoOpmTGhd3hQyQYFlKY+K99YwG6o1NA=;
        b=KYTNElZP/9bS83HZyZuLfyL3GzqTp29S5gGoOdHuqPfFZEmabHH5nZF3DbkC5T+MIs
         MKL/sgXcS74k7nCdTbfvsRfoKeboMbQDWQIK7nbzAoqjU8DUGkwuuMdD5mBPqq3PkZnb
         b34dhk8u+3NnHJJGqm59lifbfZY/KGyTBP7hH9KHf7FZ7KPhygL45q+4HiawZykO2Pr6
         4bjt2jw0KNlvrpmCo89Xxtjzo2mJ/u6CVyeTvUO7ILQn2KEhk3ZrtooQffcXVhSqiCAt
         GE+akQZdj+fzSfGSCy1A04X4QiR3AnReEslLAehKms7my6qPUo3sVmIyIIoyoYsRIAPW
         Ul6g==
X-Gm-Message-State: AOAM533Ah4C4hw3GEhowhWFYOqaguwrH5MJhn44KSEXYX8UOIoBUAuyi
        CaYxi6PwyyvesQ99Qf7JqseVVqG4NATIM+9j
X-Google-Smtp-Source: ABdhPJycTCoo1xTBH2a3y0Zz/dHjjWhQfGK2XxwcOVOj198rQtnEh8sxXcRCRXFmTdEOS4q39zsUcg==
X-Received: by 2002:a63:7c5:: with SMTP id 188mr7002295pgh.211.1628949760225;
        Sat, 14 Aug 2021 07:02:40 -0700 (PDT)
Received: from [192.168.1.92] ([106.104.151.171])
        by smtp.gmail.com with ESMTPSA id g13sm4376701pfo.53.2021.08.14.07.02.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 14 Aug 2021 07:02:39 -0700 (PDT)
Message-ID: <ac2232f142efcd67fe6ac38897f704f7176bd200.camel@gmail.com>
Subject: Re: [REGRESSION] "ALSA: HDA: Early Forbid of runtime PM" broke my
 laptop's internal audio
From:   =?Big5?Q?=C2=C5=AE=BC=DE=B3?= <lantw44@gmail.com>
To:     tiwai@suse.de
Cc:     alsa-devel@alsa-project.org, harshapriya.n@intel.com,
        kai.vehmanen@intel.com, linux-kernel@vger.kernel.org,
        mcatanzaro@redhat.com, perex@perex.cz, stable@vger.kernel.org,
        tiwai@suse.com
Date:   Sat, 14 Aug 2021 22:02:36 +0800
In-Reply-To: <s5h7dnvlgg8.wl-tiwai@suse.de>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.41.2 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

I am not sure if I should join this old thread, but it seems that I saw the same
issue on my ASUS B23E laptop. It couldn't produce any sound after upgrading to
Linux 5.10, and 'git bisect' shows it was broken by the same commit
a0645daf16101bb9a6d87598c17e9a8b7bd60ea7.

I have tested the latest master branch (v5.14-rc4-322-gcceb634774ef) last week.
It still had no sound. If I reverted the broken commit, sound worked.

alsa-info from the broken kernel:
https://gist.github.com/lantw44/0660e059c488e3ff3d841bb03b371866

alsa-info from the working kernel:
https://gist.github.com/lantw44/9367f425e4f5ba98cf12343cb90f3301

lspci:
00:00.0 Host bridge: Intel Corporation 2nd Generation Core Processor Family DRAM
Controller (rev 09)
00:02.0 VGA compatible controller: Intel Corporation 2nd Generation Core
Processor Family Integrated Graphics Controller (rev 09)
00:16.0 Communication controller: Intel Corporation 6 Series/C200 Series Chipset
Family MEI Controller #1 (rev 04)
00:16.3 Serial controller: Intel Corporation 6 Series/C200 Series Chipset Family
KT Controller (rev 04)
00:19.0 Ethernet controller: Intel Corporation 82579LM Gigabit Network
Connection (Lewisville) (rev 05)
00:1a.0 USB controller: Intel Corporation 6 Series/C200 Series Chipset Family
USB Enhanced Host Controller #2 (rev 05)
00:1b.0 Audio device: Intel Corporation 6 Series/C200 Series Chipset Family High
Definition Audio Controller (rev 05)
00:1c.0 PCI bridge: Intel Corporation 6 Series/C200 Series Chipset Family PCI
Express Root Port 1 (rev b5)
00:1c.1 PCI bridge: Intel Corporation 6 Series/C200 Series Chipset Family PCI
Express Root Port 2 (rev b5)
00:1c.2 PCI bridge: Intel Corporation 6 Series/C200 Series Chipset Family PCI
Express Root Port 3 (rev b5)
00:1c.3 PCI bridge: Intel Corporation 6 Series/C200 Series Chipset Family PCI
Express Root Port 4 (rev b5)
00:1d.0 USB controller: Intel Corporation 6 Series/C200 Series Chipset Family
USB Enhanced Host Controller #1 (rev 05)
00:1f.0 ISA bridge: Intel Corporation QM67 Express Chipset LPC Controller (rev
05)
00:1f.2 SATA controller: Intel Corporation 6 Series/C200 Series Chipset Family 6
port Mobile SATA AHCI Controller (rev 05)
00:1f.3 SMBus: Intel Corporation 6 Series/C200 Series Chipset Family SMBus
Controller (rev 05)
02:00.0 Network controller: Intel Corporation Centrino Advanced-N 6230 [Rainbow
Peak] (rev 34)
06:00.0 USB controller: Fresco Logic FL1000G USB 3.0 Host Controller (rev 04)
