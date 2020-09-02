Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 13DE325AE8A
	for <lists+stable@lfdr.de>; Wed,  2 Sep 2020 17:15:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726947AbgIBPMO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 2 Sep 2020 11:12:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47198 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728041AbgIBPLt (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 2 Sep 2020 11:11:49 -0400
Received: from mail-io1-xd42.google.com (mail-io1-xd42.google.com [IPv6:2607:f8b0:4864:20::d42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F39F6C061245
        for <stable@vger.kernel.org>; Wed,  2 Sep 2020 08:11:48 -0700 (PDT)
Received: by mail-io1-xd42.google.com with SMTP id u126so6102856iod.12
        for <stable@vger.kernel.org>; Wed, 02 Sep 2020 08:11:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=tccld8pu/vEeZLLEWOkGb3/sHgIFzGzccr/6cDpn/3A=;
        b=lWOqeuHWb77h2WHZn0TNujlRTzxPNZnXDvUd5IeeJEl2IBu7CCBmaw5IP4ouZ1KzBg
         1xGzH8NsntPF5nI+pEfSvJbfHhyt45MgcgDw7B2GE9z/E8RPpbyPoz/fpqIbJDT9IOAu
         ko4tdtufl8fplgAaoi2mX2zPxpE/7I/W47rhgVpWWBGejdSZjtyb5xBoPk1cECSYCFqE
         4NDjWCX/DuszyLTIayqfDZZ9irDKkwgRVj28tRB6qcy5Wmbzw6WlM9rIGRXze5WpW2z2
         k9rzK9lFB4kddpYpnBd7v1R674eEO2Dgb9G4TG7NgbL9J7r/6zFxVD6v73rfoea4jIXg
         Trtg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=tccld8pu/vEeZLLEWOkGb3/sHgIFzGzccr/6cDpn/3A=;
        b=tXuTd8xj0zasiXGQ0gE5ETZa0O+tobWXmaPgYWRDl49kO8t4pqmj+Xc3UUEjJQjwS9
         eYJeRB7BFWMF4Ve3WVBbfz4j4LMYLmWfn1bnlR0S6nY/j2fz9RZwoTUxvS8/5H6deMfK
         E4SHOQBIM1wSeYUPz1TNDM90LdtZhdZ31382bfnIDhe3Ikx654p0XW6Ko3kTcZx83HjQ
         X8HPO9HQ/c3ogmdvED+C5tGitkcbpxBjloxzhhPEY07xCB0CXbdnpOH7BOoCZmJD/IAF
         sG69cfxffwXmxT6kJx6YmlatNhPQsOnNwVUhE/Isfb1wwh4fNzrRNsUOA+NjDo+vEWyq
         jK1A==
X-Gm-Message-State: AOAM530kBfPzrM99nDwfVrUyexiPjiId9GdlJ3vASxgkEuPxGd8zk97s
        x8wuyEZuH4AKwRe++4mzohUGH+J2IoIbIXDK
X-Google-Smtp-Source: ABdhPJwrX7GVty5AE9tUrROvoRhZ9AV5BRdBRXOc/qjXzPgeBoViP3Ks3Ph1GRvx7naE45qEjU6Lzg==
X-Received: by 2002:a05:6638:967:: with SMTP id o7mr3773414jaj.27.1599059507934;
        Wed, 02 Sep 2020 08:11:47 -0700 (PDT)
Received: from [192.168.1.57] ([65.144.74.34])
        by smtp.gmail.com with ESMTPSA id o6sm2326563ilq.54.2020.09.02.08.11.46
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 02 Sep 2020 08:11:46 -0700 (PDT)
Subject: Re: missing backport markings on security fix [was: [PATCH] io_uring:
 set table->files[i] to NULL when io_sqe_file_register failed]
To:     Jann Horn <jannh@google.com>
Cc:     Jiufei Xue <jiufei.xue@linux.alibaba.com>,
        io-uring <io-uring@vger.kernel.org>,
        stable <stable@vger.kernel.org>
References: <1599040779-41219-1-git-send-email-jiufei.xue@linux.alibaba.com>
 <c278224e-314d-e810-67f3-f5353daf9045@kernel.dk>
 <CAG48ez1MLMDPLA28HhRLcp+skk8KBawMq7qLv91kNY_prkZ4uw@mail.gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <6ab2ce3c-36b5-fcab-02b1-320401b97f8c@kernel.dk>
Date:   Wed, 2 Sep 2020 09:11:46 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <CAG48ez1MLMDPLA28HhRLcp+skk8KBawMq7qLv91kNY_prkZ4uw@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 9/2/20 9:07 AM, Jann Horn wrote:
> On Wed, Sep 2, 2020 at 4:49 PM Jens Axboe <axboe@kernel.dk> wrote:
>> On 9/2/20 3:59 AM, Jiufei Xue wrote:
>>> While io_sqe_file_register() failed in __io_sqe_files_update(),
>>> table->files[i] still point to the original file which may freed
>>> soon, and that will trigger use-after-free problems.
>>
>> Applied, thanks.
> 
> Shouldn't this have a CC stable tag and a fixes tag on it? AFAICS this
> is a fix for a UAF that exists since
> f3bd9dae3708a0ff6b067e766073ffeb853301f9 ("io_uring: fix memleak in
> __io_sqe_files_update()"), and that commit was marked for stable
> backporting back to when c3a31e605620 landed, and that commit was
> introduced in Linux 5.5.
> 
> You can see at <https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux.git/tree/fs/io_uring.c?h=linux-5.8.y#n6933>
> that this security vulnerability currently exists in the stable 5.8
> branch.

I'll mark it for stable, it should have been just like the previous one
is.

-- 
Jens Axboe

