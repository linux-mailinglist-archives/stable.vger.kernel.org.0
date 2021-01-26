Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DD240304BD9
	for <lists+stable@lfdr.de>; Tue, 26 Jan 2021 22:56:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727290AbhAZVzQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 26 Jan 2021 16:55:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52000 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389223AbhAZROK (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 26 Jan 2021 12:14:10 -0500
Received: from mail-pj1-x102f.google.com (mail-pj1-x102f.google.com [IPv6:2607:f8b0:4864:20::102f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CEA60C061786
        for <stable@vger.kernel.org>; Tue, 26 Jan 2021 09:13:29 -0800 (PST)
Received: by mail-pj1-x102f.google.com with SMTP id my11so1568991pjb.1
        for <stable@vger.kernel.org>; Tue, 26 Jan 2021 09:13:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=CPRnAIv/Fa+uZfXurfUkpzpAVBZGCypZL/PlKuxn3JM=;
        b=dVq5pQR5F6yfQznj6eiroTor24hX3DY7b7Mb28YdVuAc1Ts/nXwEALaN/FXWm2ro8i
         g+jl4xpQT8M+Yx2yWjl8dtNyAZHZ4ePmRSt4EmctlUdukDncIXBi3B7omdrirjZKeUaw
         GHFE2yWu1SdNpcqyGFDOi5+mGiKKuPbbdDqoGh52qMdw7IFo1h5UVLsz85fRvFkn8b61
         KvJu5mqRy7vHgqJnBCqVrMMCRfT14wdR2Et2f7PDGrkO1EnuI9/WMSu2xTZEgun3fUlp
         dKa0aDdq1zGZg01T8KIa0fHhovHMcKBuJILSXzbNgrj8+QyFzHSpyCvOQ0dGvPktwMul
         Rnpg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=CPRnAIv/Fa+uZfXurfUkpzpAVBZGCypZL/PlKuxn3JM=;
        b=Udhba09pDxJCpYNctK4q4u6enSpcfe515EYpSkRLOiwOh/Z/l10ryfVRZD9lTV3+Eq
         7O6lJrSiYs7MMzrKII/R4Sa761hkkgDRDeMmP8ly0xE736kq+DGrvr8xCBofmzp+XSuG
         sJ/uMbM84ZFeV5ZdNYtSyJQnAXMmeqUgsDWoXiZ9/C7A2w+ffpxClkRdCuvZCHHU0VRV
         j1bIyZGyQ3mxsDi3yZluwtlkjyPQ8GJvhmOhddXYFXxdHirLFRQcGR7VX9c3SdPRi6HA
         0WPL13sHToDwoNKRL1amHs+l5qr9GKL4W6v31PrxOP3FqdtcF00OKj1DdmaxpZzRXYKR
         Urtw==
X-Gm-Message-State: AOAM530h1da22vSP417sJTmagBYWaD1yUnZdgLxlDxLgxJZWaAX34s0l
        csSOi4qAzyyQbMmhowM/UM3RmJA83CICIQ==
X-Google-Smtp-Source: ABdhPJxSyn2oq4HXQKmoN6Pu5MulNXoIW8PjqWMDR2blwYfhcRt72XvvoGx3dUffua0X+r27/fbqQg==
X-Received: by 2002:a17:902:a501:b029:dc:3e1d:4ddb with SMTP id s1-20020a170902a501b02900dc3e1d4ddbmr6956040plq.60.1611681209117;
        Tue, 26 Jan 2021 09:13:29 -0800 (PST)
Received: from [192.168.4.41] (cpe-72-132-29-68.dc.res.rr.com. [72.132.29.68])
        by smtp.gmail.com with ESMTPSA id 145sm19781418pge.88.2021.01.26.09.13.27
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 26 Jan 2021 09:13:28 -0800 (PST)
Subject: Re: [PATCH stable 00/11] io_uring for-stable
To:     Pavel Begunkov <asml.silence@gmail.com>, stable@vger.kernel.org
References: <cover.1611659564.git.asml.silence@gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <6734cf0f-0ff2-a29f-21f8-9e25eaba1cb4@kernel.dk>
Date:   Tue, 26 Jan 2021 10:13:26 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <cover.1611659564.git.asml.silence@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 1/26/21 4:16 AM, Pavel Begunkov wrote:
> Rebased on linux-5.10.y, stable tags added. The first was dropped
> before, most of others make it right.
> 
> Pavel Begunkov (11):
>   kernel/io_uring: cancel io_uring before task works
>   io_uring: inline io_uring_attempt_task_drop()
>   io_uring: add warn_once for io_uring_flush()
>   io_uring: stop SQPOLL submit on creator's death
>   io_uring: fix null-deref in io_disable_sqo_submit
>   io_uring: do sqo disable on install_fd error
>   io_uring: fix false positive sqo warning on flush
>   io_uring: fix uring_flush in exit_files() warning
>   io_uring: fix skipping disabling sqo on exec
>   io_uring: dont kill fasync under completion_lock
>   io_uring: fix sleeping under spin in __io_clean_op
> 
>  fs/file.c     |   2 -
>  fs/io_uring.c | 119 +++++++++++++++++++++++++++++++++++---------------
>  kernel/exit.c |   2 +
>  3 files changed, 86 insertions(+), 37 deletions(-)

Thanks for doing this work, Pavel. We'll need a few followups once the
current io_uring-5.11 has been merged to Linus's tree, but that's really
minor compared to getting this series together.

Greg/Sasha, please apply.

-- 
Jens Axboe

