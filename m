Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EE81B3C7F4B
	for <lists+stable@lfdr.de>; Wed, 14 Jul 2021 09:24:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238079AbhGNH1s (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 14 Jul 2021 03:27:48 -0400
Received: from mail-wr1-f52.google.com ([209.85.221.52]:39614 "EHLO
        mail-wr1-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238257AbhGNH1s (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 14 Jul 2021 03:27:48 -0400
Received: by mail-wr1-f52.google.com with SMTP id f17so1928021wrt.6;
        Wed, 14 Jul 2021 00:24:56 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=GQ0u+slWZ8Bb87rt4Vm27M42/eqTUFnU65XMqjSO0JE=;
        b=Cn+RVFp6S1mE5J2ewwDe7Ru4jU5c/D7xtVnbLPbAtgzmGqc4jaciQkZboGqUA9mHMa
         Fdb9GzgK7l2rP5kEpvAg4NJOA7pUiQQ3cKyEE02sybhmw7RZ1FicK15jzNJ2NiPcCEjM
         YYT+GWckzwxY6jsnw5cAfD85dtnRB7R/RpujuW+JziylZApiEmOKazjMCsGRXS7Rywut
         SzV8VD2NXmfy4Vd2k/H0J68RmS4PyogwPm2Sz1FKZTfU3WMj1yEWG3fxfueUut8l+X/7
         +EWRooa5U6lSDZGav3r8NoYGHSJsNjdouE7V02KYIZDAUbaFKWoWT+RGh9imZEFt0MYW
         zmOQ==
X-Gm-Message-State: AOAM5302dWI8d65IJfK6VrxgMTeh0LrvQX+evmuA155mgNsS5rzr2NeH
        FEGxwcV82as0N/jAn7fF4U/QqEUje9Dwfw==
X-Google-Smtp-Source: ABdhPJyoJT1NNCQ98cQsL6uKUtc8AuBYVvUEW7VDpz1HPx1f1Lq5GQlpkxieWhNRjdCYwCk4nR+57w==
X-Received: by 2002:a5d:4522:: with SMTP id j2mr10721624wra.43.1626247495231;
        Wed, 14 Jul 2021 00:24:55 -0700 (PDT)
Received: from ?IPv6:2a0b:e7c0:0:107::70f? ([2a0b:e7c0:0:107::70f])
        by smtp.gmail.com with ESMTPSA id m18sm1142863wmq.45.2021.07.14.00.24.54
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 14 Jul 2021 00:24:54 -0700 (PDT)
Subject: Re: 5.13.2-rc and others have many not for stable
To:     Andrew Morton <akpm@linux-foundation.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     Hugh Dickins <hughd@google.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Sasha Levin <sashal@kernel.org>,
        Michal Hocko <mhocko@kernel.org>,
        Mike Kravetz <mike.kravetz@oracle.com>,
        Miaohe Lin <linmiaohe@huawei.com>,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        stable@vger.kernel.org
References: <2b1b798e-8449-11e-e2a1-daf6a341409b@google.com>
 <YO0zXVX9Bx9QZCTs@kroah.com>
 <20210713182813.2fdd57075a732c229f901140@linux-foundation.org>
From:   Jiri Slaby <jirislaby@kernel.org>
Message-ID: <00091a33-52de-175b-b870-c45ebc1d9cc0@kernel.org>
Date:   Wed, 14 Jul 2021 09:24:53 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <20210713182813.2fdd57075a732c229f901140@linux-foundation.org>
Content-Type: text/plain; charset=iso-8859-2; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 14. 07. 21, 3:28, Andrew Morton wrote:
> Alternatively I could just invent a new tag to replace the "Fixes:"
> ("Fixes-no-backport?") to be used on patches which fix a known previous
> commit but which we don't want backported.

Or what about:
No-stable: <reason>
like:
No-stable: too intrusive
No-stable: too dangerous
No-stable: <5.10, isn't vulnerable

So that the reason is known at least.

thanks,
-- 
js
suse labs
