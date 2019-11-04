Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 78A2CEE2BC
	for <lists+stable@lfdr.de>; Mon,  4 Nov 2019 15:40:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728178AbfKDOkK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 4 Nov 2019 09:40:10 -0500
Received: from mail-il1-f196.google.com ([209.85.166.196]:37548 "EHLO
        mail-il1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727838AbfKDOkK (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 4 Nov 2019 09:40:10 -0500
Received: by mail-il1-f196.google.com with SMTP id s5so4740491iln.4
        for <stable@vger.kernel.org>; Mon, 04 Nov 2019 06:40:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=1maQznnFPCS8MYdM80PT/zKI7lZX/fnbIlpd2FjS0T0=;
        b=EeyzUmIPrpCMrSLP0ymZMFw1RYmjtC/hh6lgAEyVpOU9HhqSvusOKMyVisIfZKL5ZB
         hbt0ypkw15CyI9GpuKqUdyzMgsZ/qeZCYTxW+J+uPhTH4A/5qsZB0Huy7P60dxCujZ4L
         EmXgp9Dckr0Vu8vH3Z4YcjFD8FqAwV61DtHR1p3hE6yrhcnidcfVhXRDSpc34f/NmG0U
         hOZfbV2sPeiZK6Vwe6w4zYYHfgLd/yE1wHUBft7Ok+U/eElO7cIs+jOKZMRhGMo9M5lo
         tit8bWW8lNL4X6qjO3DDF/hdWzhosdTKw9DyS95wSWzq0vEKk2EDfpWvc3hU5YnImoY0
         4+Qw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=1maQznnFPCS8MYdM80PT/zKI7lZX/fnbIlpd2FjS0T0=;
        b=Q2UUVgYGR+tiWl7Kl0qC/la9q/rFWGG6YLPV9uDdrUB6UHqoZtb/xTviLIWmRgZlKi
         gkwh/PvlXtf7UN8VlCdAjXwfbkT/hYg84PGN7eZF1dQDN+gU7HktWhs3I7kADhk9J8RJ
         Is1mgF1QwKIxFwqCtDwXcqe7I7xk0Kd5uiCy4npRBnCl7AD8XQR2UtqAJirJc0x5+iLn
         8NCvORKOxknldO89qMot0jdqI03DgYo5+a2QbTEghiU1Wm/AmAx3ynm7b75yFNWx428z
         nKCL32vxWWf7Sv2tbmyeggBK5Y+5gs+zIxKmz0g4WYJOlPlQcUYGpiK3dLLgHoA5PRLA
         lZnA==
X-Gm-Message-State: APjAAAUw3qRpgji1NOvKCfA+yP8xeKhrVUacGehtPuYtxRafRXsjJOQC
        4f2xlDiuGYGxP4HOcUDRa/Zz08pptz+yGaWbu8Klpg==
X-Google-Smtp-Source: APXvYqySkvnoTfvITfdrzI7UrnW9d3Uz/86wobwolcB1+V4bHcaQCvDjt4f9B0SE1EuNSfcKrXA9HuVEbtd17MsrTts=
X-Received: by 2002:a92:17c8:: with SMTP id 69mr29064331ilx.42.1572878409560;
 Mon, 04 Nov 2019 06:40:09 -0800 (PST)
MIME-Version: 1.0
References: <15728601263783@kroah.com> <20191104140713.GE4787@sasha-vm>
In-Reply-To: <20191104140713.GE4787@sasha-vm>
From:   Jeffrey Hugo <jeffrey.l.hugo@gmail.com>
Date:   Mon, 4 Nov 2019 07:39:58 -0700
Message-ID: <CAOCk7Nr+-=oFMQp+sHzUbYEE0AP0W+uwTRsezMJiJtt9Fhmifw@mail.gmail.com>
Subject: Re: FAILED: patch "[PATCH] dmaengine: qcom: bam_dma: Fix resource
 leak" failed to apply to 4.14-stable tree
To:     Sasha Levin <sashal@kernel.org>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>, vkoul@kernel.org,
        stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Nov 4, 2019 at 7:07 AM Sasha Levin <sashal@kernel.org> wrote:
>
> On Mon, Nov 04, 2019 at 10:35:26AM +0100, gregkh@linuxfoundation.org wrote:
> >
> >The patch below does not apply to the 4.14-stable tree.
> >If someone wants it applied there, or to any other stable or longterm
> >tree, then please email the backport, including the original git commit
> >id to <stable@vger.kernel.org>.
> >
> >thanks,
> >
> >greg k-h
> >
> >------------------ original commit in Linus's tree ------------------
> >
> >From 7667819385457b4aeb5fac94f67f52ab52cc10d5 Mon Sep 17 00:00:00 2001
> >From: Jeffrey Hugo <jeffrey.l.hugo@gmail.com>
> >Date: Thu, 17 Oct 2019 08:26:06 -0700
> >Subject: [PATCH] dmaengine: qcom: bam_dma: Fix resource leak
> >
> >bam_dma_terminate_all() will leak resources if any of the transactions are
> >committed to the hardware (present in the desc fifo), and not complete.
> >Since bam_dma_terminate_all() does not cause the hardware to be updated,
> >the hardware will still operate on any previously committed transactions.
> >This can cause memory corruption if the memory for the transaction has been
> >reassigned, and will cause a sync issue between the BAM and its client(s).
> >
> >Fix this by properly updating the hardware in bam_dma_terminate_all().
> >
> >Fixes: e7c0fe2a5c84 ("dmaengine: add Qualcomm BAM dma driver")
> >Signed-off-by: Jeffrey Hugo <jeffrey.l.hugo@gmail.com>
> >Cc: stable@vger.kernel.org
> >Link: https://lore.kernel.org/r/20191017152606.34120-1-jeffrey.l.hugo@gmail.com
> >Signed-off-by: Vinod Koul <vkoul@kernel.org>
>
> Is the "Fixes:" tag correct here? Is it an issue without 6b4faeac05bc
> ("dmaengine: qcom-bam: Process multiple pending descriptors")?

Yes.  The issue will occur, even if you submit only one descriptor.
The uart_dm driver which exposed this issue (msm_serial), only uses
one descriptor at a time, despite the hardware and some versions of
the bam driver allowing more than that.

A trivial way to trigger this would be to queue a descriptor to
receive data from some peripheral that is attached to the BAM dma
engine, but the peripheral never sends that data - ie if you had a NIC
and you wanted to prequeue a receive buffer to accept an incoming
packet.  If you then invoke terminate_all(), perhaps you need to
renegotiate the link speed of the NIC, you'll hit the same issue -
with or without "Process multiple pending descriptors".
>
> --
> Thanks,
> Sasha
