Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1AB12242008
	for <lists+stable@lfdr.de>; Tue, 11 Aug 2020 21:00:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725901AbgHKTAU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 11 Aug 2020 15:00:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36172 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725886AbgHKTAU (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 11 Aug 2020 15:00:20 -0400
Received: from mail-pg1-x52c.google.com (mail-pg1-x52c.google.com [IPv6:2607:f8b0:4864:20::52c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 17F6EC06174A
        for <stable@vger.kernel.org>; Tue, 11 Aug 2020 12:00:20 -0700 (PDT)
Received: by mail-pg1-x52c.google.com with SMTP id t6so7158496pgq.1
        for <stable@vger.kernel.org>; Tue, 11 Aug 2020 12:00:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=4N+bVkL6JONaVXsu8ingBXVn0NWCfUpUWkT+yPiS2Lw=;
        b=lWf1pkcPj9yUwsxF6RdDSPyp7Sq4Rs2HuSoATH0/ac1AlIlIl4tKGopfNJpOD2RroJ
         con+EsFAyYWE5FOMWXtdr1V9H4zHcdWJtXRzFGzoFF6TbVvCObg2au83ClTbhPTGa8ZI
         QmAC4FccFxHo0tqLHvd4FNLzSicIgIC5TKXxeGASS4xW851YCguqM2xLFAIA7gKDQRPh
         yZgPWGFNWoCxXBwyvyiAY1kmUDE7IlS2tG9BelXIBy/W6/h7oEyt3Wpvzr7Qx5O0L9VN
         SyNpP97+e2t6XFEZVPRvbqEmkfNETDJunDBjwbtnMROLS3k1UaNT+1OUmXeTEy90qG9a
         9XZQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=4N+bVkL6JONaVXsu8ingBXVn0NWCfUpUWkT+yPiS2Lw=;
        b=EFMhkeJszbQDxEkdwleALbI2wPSQe4NZnJUBFHZnSMxzBiF3FlPg3mzFxKPbP2Iug/
         pt0qpPTehReGA/ObVeC4zrYrWpZv4wp0FgzmHZMmWPt2mtLJRApL54/krwIpDgfOOm9D
         CQKjyqtw3gZjtK+91joIu0y3IkK/e5oLfWGEUz7lEFWSdQvsQoF/rKmD2ZFGj4T9ASgq
         PkMuIhwqq//zFTZux9mmYiy7/8MnSNBYfLacoUXV27KSYEax8mbS6dx5BzGpA/v+OUSY
         QUCXi1HGJ+QhJ1QT55qCbKWkYCd22S1m61x+paUK0rynND9J8A46VeEz7PXtW9vzT6hd
         FfPg==
X-Gm-Message-State: AOAM532PAg5ZdguwPOeuSJPAC8g/EB755DsEhBJpqblocHpysho2ukVr
        geUtL9hVxICzYC5LvJhdTqWJbQLbRQY=
X-Google-Smtp-Source: ABdhPJzm0wV3q40tpqS8Im1cRFqm7H+Eugy7bOGcgM+ZNeqcuQVCVFAn7SYvWjVQw090muax8aevKA==
X-Received: by 2002:aa7:9386:: with SMTP id t6mr7951338pfe.220.1597172417860;
        Tue, 11 Aug 2020 12:00:17 -0700 (PDT)
Received: from [192.168.1.182] ([66.219.217.173])
        by smtp.gmail.com with ESMTPSA id t13sm22161706pgm.32.2020.08.11.12.00.17
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 11 Aug 2020 12:00:17 -0700 (PDT)
Subject: Re: Stable inclusion request
To:     Sasha Levin <sashal@kernel.org>
Cc:     stable@vger.kernel.org
References: <e708995f-6666-fbdd-9373-792007e7ea73@kernel.dk>
 <20200811164849.GK2975990@sasha-vm>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <8acffeb5-2216-04f5-ec93-7abe9f2d8f5d@kernel.dk>
Date:   Tue, 11 Aug 2020 13:00:16 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20200811164849.GK2975990@sasha-vm>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 8/11/20 10:48 AM, Sasha Levin wrote:
> On Mon, Aug 10, 2020 at 07:14:10PM -0600, Jens Axboe wrote:
>> Hi,
>>
>> Can we queue up a backport of:
>>
>> commit 4c6e277c4cc4a6b3b2b9c66a7b014787ae757cc1
>> Author: Jens Axboe <axboe@kernel.dk>
>> Date:   Wed Jul 1 11:29:10 2020 -0600
>>
>>    io_uring: abstract out task work running
>>
>> for 5.7 and 5.8 stable? It fixes a reported issue from Dave Chinner,
>> since the abstraction also ensures that we always set the current
>> task state appropriately before running task work.
>>
>> I've attached both a 5.8 and 5.7 port of the patch.
> 
> Queued up, thanks!

Thanks Sasha!

-- 
Jens Axboe

