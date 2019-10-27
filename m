Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0C21CE6260
	for <lists+stable@lfdr.de>; Sun, 27 Oct 2019 13:06:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726674AbfJ0MG0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 27 Oct 2019 08:06:26 -0400
Received: from mail-pf1-f193.google.com ([209.85.210.193]:42298 "EHLO
        mail-pf1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726469AbfJ0MG0 (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 27 Oct 2019 08:06:26 -0400
Received: by mail-pf1-f193.google.com with SMTP id 21so4731456pfj.9
        for <stable@vger.kernel.org>; Sun, 27 Oct 2019 05:06:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:from:to:cc:references:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=qbGT3k7kbmTIvKilRXtZPhGxYdxoPdbbkjO2kJy3DD4=;
        b=cmvj1vthJjxWSu57NCDMMpxLHaUXRFe/eHxfw/cpIvxUEt0u5P30gTzmqt0Dvuq1cK
         Z7OLtAhmCDUoQnOwg2aTGFVfVL3sZyDQYe6Rwdfx67zsFyW/sEwvQ6VUzcktqmCQqOaw
         ogRESCBIGt7ZdVOkNjR0atZ3l0gj997unQaQvrMxP0Uwuh3mwOK0N4S5CWNHHbrd/BVz
         CLvpjfbqXsWVP7ShMqvpP1qfmctujlZKrNctoReD08w/sJZZ5812kcvyHi3a5nPyR4Yo
         ShDGga2HuGOfClsUBNbYXsqjWqYlAql02yJDFpq4LTMZco/uyIbIl5hWODgMovHSiZT8
         Ylkg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:references:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=qbGT3k7kbmTIvKilRXtZPhGxYdxoPdbbkjO2kJy3DD4=;
        b=lvPFKnqfkc8pNYYNmtQB8p3IVN/9gYopTUNzDlsXAcfgOw/YPPtLuOsuNbNSVZZYEi
         pmC3Uf5PYedP7bGhMrelLhw7uHQbsaRmDsbcHxhZFyGe0prthOSEyGrm27Ng2lKprrPR
         sAAFMvA2AC5qRfiDeRLsSOF/jJDXFe7YuDLVaeZNBC8vD4n86sKRRU6O7roITJtpypnT
         sX0/NwvxWRuKBrEh+pPcUxil4PmPWOZJXOG87TCtiSbG0E17CdcHdYE+dc7Jb7XJVls5
         AWSjfvFfB07aiEa4/kDSBLLXnQ4E1zNvEy4GnldAiNs6QmHncpytER3gTTrUZYqW8oLC
         LOMA==
X-Gm-Message-State: APjAAAUf/aJ42M9VDJGEITSuxFD+ryeZ+P9/C2r1rYnjaCZugb7243H2
        8tr5SgzznU6Eid/yjyrq3/j1PbQRO9khFQ==
X-Google-Smtp-Source: APXvYqw4VgN2kSo6dT+SxXLxsjUkA4V0Otuwc9ORmYnoGn56iXq/ag0CWQTha3ewzDE1ZulMHGeeiw==
X-Received: by 2002:a17:90a:a417:: with SMTP id y23mr15813198pjp.126.1572177984833;
        Sun, 27 Oct 2019 05:06:24 -0700 (PDT)
Received: from [192.168.1.188] ([66.219.217.79])
        by smtp.gmail.com with ESMTPSA id q23sm6752888pjd.2.2019.10.27.05.06.23
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 27 Oct 2019 05:06:23 -0700 (PDT)
Subject: Re: io_uring stable 5.3 backports
From:   Jens Axboe <axboe@kernel.dk>
To:     Sasha Levin <sashal@kernel.org>
Cc:     stable@vger.kernel.org
References: <efc9278b-de72-40b2-9a0a-48df0c64edc1@kernel.dk>
 <20191027085204.GA1560@sasha-vm>
 <f90a0bd3-3074-ee14-dea9-63d520bd72a2@kernel.dk>
Message-ID: <a6a6fd4d-a469-43d2-7ea9-1a57e38d62cf@kernel.dk>
Date:   Sun, 27 Oct 2019 06:06:22 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <f90a0bd3-3074-ee14-dea9-63d520bd72a2@kernel.dk>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 10/27/19 6:01 AM, Jens Axboe wrote:
>> Jens, could you please take a look at my backport of fb5ccc98782f65:
>>
>> https://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git/tree/queue-5.3/io_uring-fix-broken-links-with-offloading.patch
>>
>> And 498ccd9eda491:
>>
>> https://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git/tree/queue-5.3/io_uring-used-cached-copies-of-sq-dropped-and-cq-ove.patch
>>
>> And confirm I did the right thing?
> 
> Of course, I'll take a look right now. Thanks for taking care of these!

Both look good to me.

-- 
Jens Axboe

