Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0656724ED5C
	for <lists+stable@lfdr.de>; Sun, 23 Aug 2020 15:48:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726000AbgHWNsl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 23 Aug 2020 09:48:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58482 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725884AbgHWNsk (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 23 Aug 2020 09:48:40 -0400
Received: from mail-pj1-x1041.google.com (mail-pj1-x1041.google.com [IPv6:2607:f8b0:4864:20::1041])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 06305C061573
        for <stable@vger.kernel.org>; Sun, 23 Aug 2020 06:48:39 -0700 (PDT)
Received: by mail-pj1-x1041.google.com with SMTP id ds1so2847317pjb.1
        for <stable@vger.kernel.org>; Sun, 23 Aug 2020 06:48:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=8xEbn7rrg3huAV8Jxd2sZXnscQ8mfN0Ik3M9JFlCpso=;
        b=UBJ/T5IUxkCmaUF2/aUMxaHu/iy+nBW6c7ZzBVtCqElQEAclodPYpX2bO1p4D96CcI
         5FspBSIrxYSLoDac1bcBqP350EO2DNCGDs0blXYwZYbiCPmznNooO12gvPXhr7HX1RGd
         vBRuyZhKn4Qoq72N1h7yKmUaWSg2wvzsLQQpQh+f/UCtRH8RLtNpedBGKGAh/MxG6X90
         CM2BSxHEKQqoTTHpFQDU2XoYwrCxo+BvI1PYxzCmByYD0SPweDhx5/MmUwYvu2pQ8Y/V
         566njMGFdTwDnTFlCs4OL7rn54TIpcaWtFo7q7PyMyoC0YyDB3QorBfRa+gOvhjDVWLY
         UsGg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=8xEbn7rrg3huAV8Jxd2sZXnscQ8mfN0Ik3M9JFlCpso=;
        b=oNMowCTWyfCS4J0X84qe8ZQK8juLH1RyN314ItADKRIrJhxJPSDEvfbFFqomoHWCvk
         +QvfCelj56XqNsLeUEER2Jlk08xNtPLrB4+xbQ2SmSazIar7BlL7mY6Y4UPpJoxcQoXL
         th+ywace+COagbxCSHILn7g5V/PzMXQar+zzdyu4uGK+6DbJ3jDhcPCPuyPhj00XzMhJ
         Tg/S4PDFTft1j1P5XrbaXTONQ9iORHl3kuvkdPbZTKNSb+aI8UOx+fZkSRIlJP5Yogjt
         PhUS7L++luDGdM4kGLECVHa1zDymflxHdD7krIOlnr8FDrMpZ+9HlRJRe2Z6IblXCAKv
         a02A==
X-Gm-Message-State: AOAM530SS8ejsjAtBbuwLjBvnZrn/wa5zmGFi93DyLgcALVoCuVQcde8
        NdbM16CDJ7C3qHoa2kaXkXuQXOVNtkysJ6qx
X-Google-Smtp-Source: ABdhPJwMei0WSzxk2T+kcuUDW/qeiIkMtjHdAuAmiEYoBsjsURzDc2zcyoJSLoHDBlDMevhfr1T7Hw==
X-Received: by 2002:a17:902:a503:: with SMTP id s3mr932361plq.190.1598190512932;
        Sun, 23 Aug 2020 06:48:32 -0700 (PDT)
Received: from [192.168.1.182] ([66.219.217.173])
        by smtp.gmail.com with ESMTPSA id a6sm487510pgt.70.2020.08.23.06.48.31
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 23 Aug 2020 06:48:32 -0700 (PDT)
Subject: Re: FAILED: patch "[PATCH] io_uring: find and cancel head link async
 work on files exit" failed to apply to 5.7-stable tree
To:     gregkh@linuxfoundation.org, asml.silence@gmail.com
Cc:     stable@vger.kernel.org
References: <159818496684216@kroah.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <5e0d43b1-f2ed-3faa-cb30-8cacd5f16faa@kernel.dk>
Date:   Sun, 23 Aug 2020 07:48:30 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <159818496684216@kroah.com>
Content-Type: text/plain; charset=windows-1252
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 8/23/20 6:16 AM, gregkh@linuxfoundation.org wrote:
> 
> The patch below does not apply to the 5.7-stable tree.
> If someone wants it applied there, or to any other stable or longterm
> tree, then please email the backport, including the original git commit
> id to <stable@vger.kernel.org>.

This needs this one backported:

commit 4f26bda1522c35d2701fc219368c7101c17005c1
Author: Pavel Begunkov <asml.silence@gmail.com>
Date:   Mon Jun 15 10:24:03 2020 +0300

    io-wq: add an option to cancel all matched reqs

I'll take a look later today, unless Pavel beats me to it.

-- 
Jens Axboe

