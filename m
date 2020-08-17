Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0E499246745
	for <lists+stable@lfdr.de>; Mon, 17 Aug 2020 15:21:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728471AbgHQNVG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 Aug 2020 09:21:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42074 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728443AbgHQNVF (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 17 Aug 2020 09:21:05 -0400
Received: from mail-pl1-x641.google.com (mail-pl1-x641.google.com [IPv6:2607:f8b0:4864:20::641])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 52A46C061389
        for <stable@vger.kernel.org>; Mon, 17 Aug 2020 06:21:05 -0700 (PDT)
Received: by mail-pl1-x641.google.com with SMTP id g7so6381124plq.1
        for <stable@vger.kernel.org>; Mon, 17 Aug 2020 06:21:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=SRfpIkoaS3RZqmzXMaOm4ZiEh21uoEiPvC5L4jQPAPA=;
        b=ogwik2o8wURNEfnH3+sbHGTZsyvzZobbzORIhP/yMXHDbU4xvQrMG3CLlv2mjze8Nb
         LDRmBjhGgO/rCuhIgivQKE8gePQred/gHKJPSZbBuQ1fO/Y/8XiI+wprXkI86kPh8Wi0
         lirFiiPXPpJRlWFANhjYfcrNdDAo5LC388Fxn6eY4ZgXmJxjGZAuWBijWFJYfFUr4sI3
         4CV4pgp3lPazZEFZSLb6JFVMozMWuS1HSgDn1m9dCqCBydo0hsB3qD4Fb9xE/nsV3SJ0
         zICYt0rvApQfDG4z3bkFHCFnnWIwv0wB2W3E8OVX2rzy/4fEvLAkZqclZJ3yqkStM+61
         2sNg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=SRfpIkoaS3RZqmzXMaOm4ZiEh21uoEiPvC5L4jQPAPA=;
        b=DAMgcF8hiaiAt201r2nIX4lV3MFyAvxQgp/XCjNKBBs8Y+cg1Q6vDKP0qgPUKNrOvK
         6/Hlk8oZKBhs/lRvfoyLpxYS6ITbk0MR7T7U2boCmX2BiWIcH1Y5LxyDjXdnJL9i8a2g
         O6Wdwi6D0W27OrCYy3Z924+PzJpag1IkPvRMQ6bAwIPR4vrr1zW/4Zyndz+OT0R6geXT
         VkPhKY4vag0dPx3svIjSi1lfXd018fTwqx88qyErnlBaRMYmp+LVufnxhTD+1nUXi9ZW
         R49LCcFT1bwCUHOlDGm8Ga0A2xhCmYaBFKFbRQbyBFxkbERrr+x/LLIfc06t2Kjwz48K
         gHbA==
X-Gm-Message-State: AOAM531wBN1xyLHNJnd4IX3MRlEzeSyFZymb2tcGxwFaOAHai+Moz7Ee
        omxAl1X/eeN57FGysv2t/k0cfhs8W9g8CQ==
X-Google-Smtp-Source: ABdhPJw1slM/8lWr2ajbMoItcKdaVJuv2syX4iHXZzgVAiM7doH7PSYav+oqlcycQAQmGrJxcQQUhg==
X-Received: by 2002:a17:902:fe10:: with SMTP id g16mr11317342plj.43.1597670464632;
        Mon, 17 Aug 2020 06:21:04 -0700 (PDT)
Received: from ?IPv6:2605:e000:100e:8c61:ff2c:a74f:a461:daa2? ([2605:e000:100e:8c61:ff2c:a74f:a461:daa2])
        by smtp.gmail.com with ESMTPSA id 77sm19839149pfx.85.2020.08.17.06.21.03
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 17 Aug 2020 06:21:03 -0700 (PDT)
Subject: Re: FAILED: patch "[PATCH] io_uring: hold 'ctx' reference around
 task_work queue +" failed to apply to 5.8-stable tree
To:     Greg KH <gregkh@linuxfoundation.org>
Cc:     stable@vger.kernel.org
References: <1597661043160117@kroah.com>
 <6d363f5c-711c-6953-d417-2f9dfbf3dd7a@kernel.dk>
 <20200817131341.GA208556@kroah.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <da8acd62-2312-1baf-8562-d2085c78e062@kernel.dk>
Date:   Mon, 17 Aug 2020 06:21:02 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20200817131341.GA208556@kroah.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 8/17/20 6:13 AM, Greg KH wrote:
> On Mon, Aug 17, 2020 at 06:10:04AM -0700, Jens Axboe wrote:
>> On 8/17/20 3:44 AM, gregkh@linuxfoundation.org wrote:
>>>
>>> The patch below does not apply to the 5.8-stable tree.
>>> If someone wants it applied there, or to any other stable or longterm
>>> tree, then please email the backport, including the original git commit
>>> id to <stable@vger.kernel.org>.
>>
>> Here's a 5.8 version.
> 
> Applied, thanks!
> 
> Looks like it applies to 5.7 too, want me to take this for that as well?

Heh, didn't see this email, just going through this by kernel revision.
Either one should work, sent a specific set for that too.

BTW, for both 5.7 and 5.8, could you please queue up:

commit ebf0d100df0731901c16632f78d78d35f4123bc4
Author: Jens Axboe <axboe@kernel.dk>
Date:   Thu Aug 13 09:01:38 2020 -0600

    task_work: only grab task signal lock when needed

as well, to avoid a perf regression with the TWA_SIGNAL change? Thanks!

-- 
Jens Axboe

