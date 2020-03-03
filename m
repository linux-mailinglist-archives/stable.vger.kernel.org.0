Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E9F4A1781E0
	for <lists+stable@lfdr.de>; Tue,  3 Mar 2020 20:02:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732662AbgCCSHX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Mar 2020 13:07:23 -0500
Received: from mail-il1-f194.google.com ([209.85.166.194]:34911 "EHLO
        mail-il1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732291AbgCCRzH (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 3 Mar 2020 12:55:07 -0500
Received: by mail-il1-f194.google.com with SMTP id g126so3569833ilh.2
        for <stable@vger.kernel.org>; Tue, 03 Mar 2020 09:55:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=ayIxKKAwCnNFCQ+lZzklsRs5rXYB11mGFHyYGI5wUqQ=;
        b=gDBM/cKDaAMh9NyfxfoObozsG9BZGD80+G1UGm/xV8TRxMqdcxd3lkS7Tjc2EZIK5k
         O23wx5QTaZLVh2TUQMR/TRMtGrzlj3bIrack/HPTGO10ixgYa7tKMJ096FUlVlKSpVlk
         4T4h8gnuTVFX1A/hBPx1SunMMPdgrCbXi4uVHq95icV0U4T5UQyhYuUIg4plkkEWhLtK
         iY/tQv5MsboKHbHaXcPeN6P1iYXGkLhHrJcXbFJGYOaBrXt/zh7Z9xLjhLQSofkYiJbd
         L7hD+kdiIc4k3EkxMC+O1Z2XYNe5g1WwxJxZxyKY6/WHpQcxhJwpXpYZ9S8bMjc/4KH3
         aUmw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=ayIxKKAwCnNFCQ+lZzklsRs5rXYB11mGFHyYGI5wUqQ=;
        b=iJ8o9CjAR8NnqLSFx3VT7PSAY9ujUcQw/5ZcNT+rtCDvIMhnJUMyBdyjOm53432efS
         Qkq/cpFZG89QzZETgr+xIQZmDp8xhD8GVqTplUsGMYogfa/DQFq0Txpei7PwgNHq4xxk
         uYnxziBQSBRArGMjbGM5MCfz8/+WA2q8AhPGmuZ3JzNOUbWBKUU0L8LywK3i0xV1sWrJ
         M2yAJWIl/7rHX+0XrnyaDIp+gQPgWvfyY9nDS7C+ABxsCYZcjiUYDXy+rwSo4wPyCvvb
         NiE9fpmuD3a3DKfB1/rqhXj4kffQ0nrc48QOSDK2HDlmPTPSy3rp8eJ/5FiB+aUkJFAu
         WgkQ==
X-Gm-Message-State: ANhLgQ0L5I8YHgBRwbwoEkU5h6p9Nt33kSHOS3C+tfEibxqe+Ry9jsZG
        EM4pWEzj+g7I4alR57DdAkS+WvaOo/c=
X-Google-Smtp-Source: ADFU+vswN1+JEsE23FDapwuSVGGnBVQIgUF2nTXa5raP7vGWLMOlfTYLzjaimZzTkgwmW/1PXcHyyw==
X-Received: by 2002:a92:8f46:: with SMTP id j67mr5772317ild.125.1583258106150;
        Tue, 03 Mar 2020 09:55:06 -0800 (PST)
Received: from [192.168.1.159] ([65.144.74.34])
        by smtp.gmail.com with ESMTPSA id h14sm1061362iow.23.2020.03.03.09.55.05
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 03 Mar 2020 09:55:05 -0800 (PST)
Subject: Re: [PATCH 5.4 062/152] bcache: ignore pending signals when creating
 gc and allocator thread
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     stable@vger.kernel.org, Coly Li <colyli@suse.de>,
        Sasha Levin <sashal@kernel.org>
References: <20200303174302.523080016@linuxfoundation.org>
 <20200303174309.501274295@linuxfoundation.org>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <db776832-64ff-6757-de09-ced1ea8b368f@kernel.dk>
Date:   Tue, 3 Mar 2020 10:55:04 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
MIME-Version: 1.0
In-Reply-To: <20200303174309.501274295@linuxfoundation.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 3/3/20 10:42 AM, Greg Kroah-Hartman wrote:
> From: Coly Li <colyli@suse.de>
> 
> [ Upstream commit 0b96da639a4874311e9b5156405f69ef9fc3bef8 ]
> 
> When run a cache set, all the bcache btree node of this cache set will
> be checked by bch_btree_check(). If the bcache btree is very large,
> iterating all the btree nodes will occupy too much system memory and
> the bcache registering process might be selected and killed by system
> OOM killer. kthread_run() will fail if current process has pending
> signal, therefore the kthread creating in run_cache_set() for gc and
> allocator kernel threads are very probably failed for a very large
> bcache btree.
> 
> Indeed such OOM is safe and the registering process will exit after
> the registration done. Therefore this patch flushes pending signals
> during the cache set start up, specificly in bch_cache_allocator_start()
> and bch_gc_thread_start(), to make sure run_cache_set() won't fail for
> large cahced data set.

Please drop this one, it's being reverted in mainline.

-- 
Jens Axboe

