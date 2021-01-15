Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 745212F70A3
	for <lists+stable@lfdr.de>; Fri, 15 Jan 2021 03:35:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732120AbhAOCeS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 14 Jan 2021 21:34:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51760 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728408AbhAOCeS (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 14 Jan 2021 21:34:18 -0500
Received: from mail-pf1-x430.google.com (mail-pf1-x430.google.com [IPv6:2607:f8b0:4864:20::430])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 22E0EC061575
        for <stable@vger.kernel.org>; Thu, 14 Jan 2021 18:33:38 -0800 (PST)
Received: by mail-pf1-x430.google.com with SMTP id c13so4534315pfi.12
        for <stable@vger.kernel.org>; Thu, 14 Jan 2021 18:33:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=eYLqeZdQGD2OUwFnac1G9gXQd38TgZqPhFGPAW7iHXg=;
        b=bs/SkqjgM2tAhsNNeDnEm0HGpWS4vwU2K+MPoUEd40gURHVSPX1IrA9pSYynAi416W
         wPiimm509iTQ57z/JWX77mZ1exxwMWq22OUYgOUHrx143viRG0pod153kxVu8iQx2kxn
         NMbvflKi2f5VxBk6moDzI0e4DfyBh+lZ7/Wzxd9R2lZcGDv7K3A75RtxB5W47QiFxNwx
         0Endnivl/S4u+onP7CmgUyiRnELMQttLVLKsMRNUeVYJ4zBgA5oVtRx2kQ8VKrRZdi2m
         74nrSLm1ubbA/abQytLZ5TnrF/EIzTGkZLn+QeACi/Vy6n9SxEOKdYZM9jJhNb6uEIFI
         M68Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=eYLqeZdQGD2OUwFnac1G9gXQd38TgZqPhFGPAW7iHXg=;
        b=TfeTs6jS7LeCqB6g1pfQDOdoIgshsY3HtveVAC5asY10MHYHvSmF44P6JhGw7dTMok
         qwFwdzdpM/A9AgoDpyW90mozVz1RvnMNNwd1xvVSicYX8DtoY8t0EWeJcN0nNc6yQk3m
         N4zk4ffmR7hFy9y7M4ZsOuCah2ae3hbmbhssOKY7W6Tns1ZXboZ9zPzIRY8cHFkU4UdV
         qpbNU/NAgv7ol52dGUvVq5UsXs9ZcLlc0KWRKqWBteg2GClYqo1SxWnw84Cg5oLY2bVm
         EpyqQ3YLuu29PYITCZSUspUQ9oUnmnv9TybmdK9N5CC0dZVIF94Gm3T6sieYhJ0cwHUv
         0vQA==
X-Gm-Message-State: AOAM531XuiWrgEz18aiWEOv54Lyi1wQT5zV7Gne7qZ0MsPnBM+2Bg0fS
        qTob0vT65IsTH83c4CbQgZr5OSR4+8xUWQ==
X-Google-Smtp-Source: ABdhPJzqGuZAQsEjG2xm32+qbXuH3B6/TYHmpqKFHlhjOJvTLoetw8j9qBffMsqigO4uxi20MdfwFg==
X-Received: by 2002:a63:6c85:: with SMTP id h127mr10445959pgc.158.1610678017397;
        Thu, 14 Jan 2021 18:33:37 -0800 (PST)
Received: from [192.168.1.134] ([66.219.217.173])
        by smtp.gmail.com with ESMTPSA id z23sm6870877pfj.143.2021.01.14.18.33.36
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 14 Jan 2021 18:33:36 -0800 (PST)
Subject: Re: Fix CVE-2020-29372 in 4.19 and 5.4
To:     Saied Kazemi <saied@google.com>, gregkh@linuxfoundation.org
Cc:     stable@vger.kernel.org, Vaibhav Rustagi <vaibhavrustagi@google.com>
References: <CA+Um-ghfTG=+x8iT-uPikM7NNsN1J6CCiztxsBgQ9OJPUBQjyg@mail.gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <78934fc4-7ab5-1364-c4ae-a215d7808fd8@kernel.dk>
Date:   Thu, 14 Jan 2021 19:33:35 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <CA+Um-ghfTG=+x8iT-uPikM7NNsN1J6CCiztxsBgQ9OJPUBQjyg@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 1/14/21 6:55 PM, Saied Kazemi wrote:
> Hi Greg,
> 
> To fix CVE-2020-29372 in COS kernel versions 4.19 and 5.4, we
> cherry-picked the commit "mm: check that mm is still valid in
> madvise()" (bc0c4d1e176e) that Jens introduced in kernel version 5.7.0
> into our kernel sources.  The commit is small and the cherry-pick was
> successful for both COS kernels versions.
> 
> Because COS 4.19 and 5.4 kernels track 4.19.y and 5.4.y respectively,
> can you please cherry-pick the commit to those stable branches?

In terms of io_uring, 4.19 should not be a concern as it wasn't available
in that kernel.

-- 
Jens Axboe

