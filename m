Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 41BF524EFA7
	for <lists+stable@lfdr.de>; Sun, 23 Aug 2020 22:04:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726676AbgHWUE3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 23 Aug 2020 16:04:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59920 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725887AbgHWUE2 (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 23 Aug 2020 16:04:28 -0400
Received: from mail-pl1-x644.google.com (mail-pl1-x644.google.com [IPv6:2607:f8b0:4864:20::644])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1BE7BC061573
        for <stable@vger.kernel.org>; Sun, 23 Aug 2020 13:04:28 -0700 (PDT)
Received: by mail-pl1-x644.google.com with SMTP id s14so3203896plp.4
        for <stable@vger.kernel.org>; Sun, 23 Aug 2020 13:04:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:from:to:cc:references:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=+fUnehflCVpHq+u7hWqpUt9SBoPnsF+D0FfpXnNx1Ow=;
        b=dBnKJdesjHpf3iCBlPg6XV9VINrpkPjWJd5HV5qV163E3t8578YvqVXGbyPzbJz0mP
         dhGOX5wDMN1LTSgH7tbUBMjs0rAJzPVNaKIfILxECpinVZM/yhR7I6ftzJseN00PR8s4
         gsM6V/VdTzaG3kqPgJXTMxgEGRoJWwKPKmr6LlxJU4MsstJKFyf0NtG6J93YgTWQbqUt
         yobnB0UOw9KL1Dxs4GBux5n2rBNtbiLvupI41f+oR5oNCKmInylkh3Ozn59t65MGCCzU
         GTHE4IFgtZjvniVKSy93vvh1vkCVJ09pZwRj6EY5iP76PbYaBS2y0tIEBIYoim7IejK5
         F2ug==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:references:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=+fUnehflCVpHq+u7hWqpUt9SBoPnsF+D0FfpXnNx1Ow=;
        b=C5hR8MoArT5ZAaE3UcOb7Nc1LM49B37N/MOLHm4OD7ldNtGHjhQ/9xhmnFcYDiHN6B
         N3Fw5uxcwbpJoo6piKBCtrE7+X+bGLP6NgK+xftiSeGS+ekDIYneql3D8zcr5a59+o7z
         an1e4syHWjuaSlxbDo+GnN6UgH5cKbx/2+PJKWHbAuONRsibw26VrXc+WPkCOTxAUP7T
         ZTBxfexiA4BbJRbQEWA8goah5V93oJfOH1g0J0fogBbN8xxeB2aD0Y/WjXlf8BYPjEIj
         OU2JEg1IUI5f7TLPwb/e9CRFYJ2aXDM7zFfqIKdn2zl5Sj99N45lEyY16booqpnC+mLh
         gmDQ==
X-Gm-Message-State: AOAM531N7pE5Ht7+NpQt8ttouEwrXtwU9vA9LpljIY7PUNeuIRHdjh9w
        hf87c1c0jt1tKgPuJRSiWI5mCkdRhu/LaUah
X-Google-Smtp-Source: ABdhPJzarQdD8ZTeRm/5wvibVkqaCyEg25Ef2YGxZPhE28bURlMKaXBscUvG4cBXlZWbBFLdZG6csA==
X-Received: by 2002:a17:902:9890:: with SMTP id s16mr1643805plp.332.1598213067290;
        Sun, 23 Aug 2020 13:04:27 -0700 (PDT)
Received: from [192.168.1.182] ([66.219.217.173])
        by smtp.gmail.com with ESMTPSA id w16sm8902161pfq.13.2020.08.23.13.04.25
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 23 Aug 2020 13:04:26 -0700 (PDT)
Subject: Re: FAILED: patch "[PATCH] io_uring: find and cancel head link async
 work on files exit" failed to apply to 5.7-stable tree
From:   Jens Axboe <axboe@kernel.dk>
To:     gregkh@linuxfoundation.org, asml.silence@gmail.com
Cc:     stable@vger.kernel.org
References: <159818496684216@kroah.com>
 <5e0d43b1-f2ed-3faa-cb30-8cacd5f16faa@kernel.dk>
Message-ID: <fcf3384c-956e-8310-d0d6-1ac8e1f66ebe@kernel.dk>
Date:   Sun, 23 Aug 2020 14:04:25 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <5e0d43b1-f2ed-3faa-cb30-8cacd5f16faa@kernel.dk>
Content-Type: text/plain; charset=windows-1252
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 8/23/20 7:48 AM, Jens Axboe wrote:
> On 8/23/20 6:16 AM, gregkh@linuxfoundation.org wrote:
>>
>> The patch below does not apply to the 5.7-stable tree.
>> If someone wants it applied there, or to any other stable or longterm
>> tree, then please email the backport, including the original git commit
>> id to <stable@vger.kernel.org>.
> 
> This needs this one backported:
> 
> commit 4f26bda1522c35d2701fc219368c7101c17005c1
> Author: Pavel Begunkov <asml.silence@gmail.com>
> Date:   Mon Jun 15 10:24:03 2020 +0300
> 
>     io-wq: add an option to cancel all matched reqs
> 
> I'll take a look later today, unless Pavel beats me to it.

OK, you just need to cherry pick this one:

commit f4c2665e33f48904f2766d644df33fb3fd54b5ec
Author: Pavel Begunkov <asml.silence@gmail.com>
Date:   Mon Jun 15 10:24:02 2020 +0300

    io-wq: reorder cancellation pending -> running

and then cherry pick this one:

commit 4f26bda1522c35d2701fc219368c7101c17005c1
Author: Pavel Begunkov <asml.silence@gmail.com>
Date:   Mon Jun 15 10:24:03 2020 +0300

    io-wq: add an option to cancel all matched reqs

and then the patch will apply directly without needing any sort of
massaging. Looking at that series, please pick this one as well (either
at the end, or after the first two):

commit 44e728b8aae0bb6d4229129083974f9dea43f50b
Author: Pavel Begunkov <asml.silence@gmail.com>
Date:   Mon Jun 15 10:24:04 2020 +0300

    io_uring: cancel all task's requests on exit

Thanks!

-- 
Jens Axboe

