Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0664F1F9BC3
	for <lists+stable@lfdr.de>; Mon, 15 Jun 2020 17:18:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730158AbgFOPSd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Jun 2020 11:18:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45612 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730147AbgFOPSd (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Jun 2020 11:18:33 -0400
Received: from mail-pj1-x1036.google.com (mail-pj1-x1036.google.com [IPv6:2607:f8b0:4864:20::1036])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 94D0AC061A0E
        for <stable@vger.kernel.org>; Mon, 15 Jun 2020 08:18:32 -0700 (PDT)
Received: by mail-pj1-x1036.google.com with SMTP id ga6so6974831pjb.1
        for <stable@vger.kernel.org>; Mon, 15 Jun 2020 08:18:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=4HI35qKiudWZZmIhL6UbwW8CX9wnRCUpDIEPSZf9/4Q=;
        b=RrmHKXR51oJjteTZfSFpK+p8PDJ3QXbvpBXJHUcrfZonepNXTuqKYT0iM7E4Tt2kZC
         Q2ZICrTUNpaKnuBfKy77Uv9jIGHpexxuaeB5t5q5LitNLWty8K8t97SE4jVTSKidDx0i
         95TlOI4/UHd8JEANaq/4oYS/UBVk1INsCWDOqCd4gb3o7fLO0OxLCAlrBTlVD3Hoh/V1
         QieB3X4GAPC6sUxufSXsMyHtOwV57F7JJbwAKXluCa1PkGhZUVEpNyY7WCApMvYMJf0G
         uxpekoWigk+guIN4kqatAc1nIYl/7GZKGDYm78xibba1TsqHrJ4+PXyiV1pmHO8VfjKq
         N++g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=4HI35qKiudWZZmIhL6UbwW8CX9wnRCUpDIEPSZf9/4Q=;
        b=I0SLJMS6hB26NksW28HbCS6BL8EFce7SQvVm4kiOIVd1wcc8yRAGTPQ3eRSdL1MMv3
         5nxdwM0dE5z8TbG/ci2d4DFW0cKD/IHPGDJqsfWCwRTKdfeYS+CI+/Ppivmk92DigFVm
         YmjxTCyAPh5hJX8ymHI8fNUFyPKV1h0OCdqr4cXiVpNL5usWrBUg3opM6fRn3WfTmfsj
         I9diOvosaAM9c7Sy3tkpsIkZyZqWoPnG1PL/b0Rcvn6NnReqASf0VC1V2j/VsPYVINoY
         OncNL0T+0vMDBQY55+FNHwvPW7EWzceVou2ywMyXHrweRa2yZU7uNlKpsyEzPQQLH05Q
         IOJw==
X-Gm-Message-State: AOAM533DZ+ksVRr0oxfgxGw9vs2wRC74Rx6p/9XTntgFR5IETKTZToYS
        RTQtexbWSK5RUxtXuXjU3gf6NqJuX0psMA==
X-Google-Smtp-Source: ABdhPJzDCj5/HLDdtt6peIdtKzPDOU9UfaEYKzYjtukTIziCl1qMigp+OHBe0EZRGdxWDNcEJXRX1Q==
X-Received: by 2002:a17:902:7c96:: with SMTP id y22mr21712858pll.293.1592234311410;
        Mon, 15 Jun 2020 08:18:31 -0700 (PDT)
Received: from [192.168.1.188] ([66.219.217.173])
        by smtp.gmail.com with ESMTPSA id q1sm15328262pfk.132.2020.06.15.08.18.30
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 15 Jun 2020 08:18:30 -0700 (PDT)
Subject: Re: FAILED: patch "[PATCH] io_uring: fix flush req->refs underflow"
 failed to apply to 5.6-stable tree
To:     gregkh@linuxfoundation.org, asml.silence@gmail.com
Cc:     stable@vger.kernel.org
References: <159222954019964@kroah.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <a4ac1fdd-576c-9cff-bc54-4d090f2bad2c@kernel.dk>
Date:   Mon, 15 Jun 2020 09:18:29 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.8.0
MIME-Version: 1.0
In-Reply-To: <159222954019964@kroah.com>
Content-Type: text/plain; charset=windows-1252
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 6/15/20 7:59 AM, gregkh@linuxfoundation.org wrote:
> 
> The patch below does not apply to the 5.6-stable tree.
> If someone wants it applied there, or to any other stable or longterm
> tree, then please email the backport, including the original git commit
> id to <stable@vger.kernel.org>.

Greg, if you could cherry pick this one:

commit d8f1b9716cfd1a1f74c0fedad40c5f65a25aa208
Author: Xiaoguang Wang <xiaoguang.wang@linux.alibaba.com>
Date:   Sun Apr 26 15:54:43 2020 +0800

    io_uring: fix mismatched finish_wait() calls in io_uring_cancel_files()

first (which should also go into stable), the below will apply without
conflicts after that.

-- 
Jens Axboe

