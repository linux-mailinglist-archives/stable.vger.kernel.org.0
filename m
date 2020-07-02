Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 91307211AD4
	for <lists+stable@lfdr.de>; Thu,  2 Jul 2020 06:08:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726089AbgGBEH7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 2 Jul 2020 00:07:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36076 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725857AbgGBEH6 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 2 Jul 2020 00:07:58 -0400
Received: from mail-pj1-x1033.google.com (mail-pj1-x1033.google.com [IPv6:2607:f8b0:4864:20::1033])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 795F1C08C5C1
        for <stable@vger.kernel.org>; Wed,  1 Jul 2020 21:07:58 -0700 (PDT)
Received: by mail-pj1-x1033.google.com with SMTP id k71so8354894pje.0
        for <stable@vger.kernel.org>; Wed, 01 Jul 2020 21:07:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=m7j0Rkfwrad2tyURig19idAVXn3V+tmbMme2ir3hSHE=;
        b=A94mNvLiKoLbu+nm6e26veOTgDPfv5oNTccjbAOKO03SWiTqC2r8f8PpdDUTYV0yzT
         KBFIpuqq/PhEn+cPynSgr4DSws2+4M99Uti3TRVMumRmZCKFSg8EdV9HYxmUyBqve5kk
         yi36Q3HCZ2fGgYLiSFXT9n0z6+KiMJBvr5eTPeRqwAWrp1oI6+csXoJStXcwCdFUtLqY
         nRW0kz8ckB7xZ2YWGo4h9nYUcGhUnyh32Q7F6eR1lrnuGLtmrkMW5q35bTZ+b/z8G4GR
         NKJcjYv5OVMpynbFFd/CEN9eYaOqaC4QBzrw8mwSuogOhEfjYPAwvVjdUJoh8rKRfO2k
         +6Xg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=m7j0Rkfwrad2tyURig19idAVXn3V+tmbMme2ir3hSHE=;
        b=YkCIPTe42RPbOaffzuYrQ6MFK8cDx5B9M6HXjXkwiFPLtO5EnnQnI8V32p4WfNKJwg
         9ua26Dh/ggx5+3mosKGwzZr2ESVfurB3TSCAIfBlssGM5ppZzpjW8GqGxdYUx/ti6KCR
         BZanhOT/kx8Hflwo7c65So7goZgJWJuhZ2lHeZUflRtAUL3cFI4x0Sk1pOXrowZIXIS+
         fYF8Lj2cyEloOrXrN7IDZtZ0ISuJitDqAxtwLZIUqLJGh0v5y9cn32smzW7w+8lQPcD5
         Ce37uy2mGNP/tTG4tPB69DFluM4hQlkYNpxqFiNIA/s4NRwxwhOd7WoGF6gGVaGLmhx5
         YgSA==
X-Gm-Message-State: AOAM533GSiZmgzMkWF3ErGkSRgun1CWaz4XyU3qCrS03Rkj6B3aoKZ9O
        AyB47ywq0Kw07JoWFFSAidpjkQ==
X-Google-Smtp-Source: ABdhPJyBaHd16uEIIv3M27j4+nq2qchNpRNwtDD83n0D1DEUKkduPrf5iWFEq/TI4ph/iQFfNL/Abw==
X-Received: by 2002:a17:902:710b:: with SMTP id a11mr24967563pll.156.1593662877044;
        Wed, 01 Jul 2020 21:07:57 -0700 (PDT)
Received: from ?IPv6:2605:e000:100e:8c61:b0a2:2229:1cbe:53d2? ([2605:e000:100e:8c61:b0a2:2229:1cbe:53d2])
        by smtp.gmail.com with ESMTPSA id 9sm7015938pfh.160.2020.07.01.21.07.56
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 01 Jul 2020 21:07:56 -0700 (PDT)
Subject: Re: Request for patch inclusion for 5.4-stable
To:     Sasha Levin <sashal@kernel.org>
Cc:     stable@vger.kernel.org, "Agarwal, Anchal" <anchalag@amazon.com>
References: <dff7fc38-d2b3-1f7c-88c6-085fb93c7f11@kernel.dk>
 <20200702013140.GG2687961@sasha-vm>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <a35028c3-6cb7-99dc-83f0-5b96f015d2c4@kernel.dk>
Date:   Wed, 1 Jul 2020 22:07:55 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.8.0
MIME-Version: 1.0
In-Reply-To: <20200702013140.GG2687961@sasha-vm>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 7/1/20 7:31 PM, Sasha Levin wrote:
> On Wed, Jul 01, 2020 at 12:24:17PM -0600, Jens Axboe wrote:
>> Hi,
>>
>> There's no upstream variant of this, as that would require backporting
>> all the io-wq changes from 5.5 and on. Hence I made a one-off that
>> ensures that we don't leak memory if we have async work items that
>> need active cancelation (like socket IO).
>>
>> Can we get this queued up for 5.4? I've tested it and the original
>> reporter has as well.
> 
> I've added the previous paragraph which explains why there is no
> upstream version of this into the commit message and queued it for 5.4,
> thank you!

Perfect, thanks Sasha!

-- 
Jens Axboe

