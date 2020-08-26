Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B1CAC252FEE
	for <lists+stable@lfdr.de>; Wed, 26 Aug 2020 15:32:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730051AbgHZNbf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 26 Aug 2020 09:31:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49172 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730286AbgHZNam (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 26 Aug 2020 09:30:42 -0400
Received: from mail-io1-xd36.google.com (mail-io1-xd36.google.com [IPv6:2607:f8b0:4864:20::d36])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 35CE9C061574
        for <stable@vger.kernel.org>; Wed, 26 Aug 2020 06:30:05 -0700 (PDT)
Received: by mail-io1-xd36.google.com with SMTP id v6so2058653iow.11
        for <stable@vger.kernel.org>; Wed, 26 Aug 2020 06:30:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=poM+lQtBssF0aCZYnLKRKD9hwY5qDrWsSm+NnhHcPRw=;
        b=cINWcGp9t2KbrOFsjuqECoqJ3ZfToCOJYxDz0I0yIwUEdeBp6O1NWoUwgCeaMcPNi4
         gVzqnjXeYVgfb4nS9VZpqxA0KEBQVXEoxcx7umJXd+vHsZZm9IqkOAhYovwXmdIpYkGL
         7Kppd1t9IJM6Bj0/Ad9SNroaJPtQ2FukCXyT3yTOeqzjpWWAtfB2TbfsIzRcKzJoDizJ
         r9P1ckAraARWpULu/uSr0PybiQHONXjpdXSgL1fZuXKJV+XQ9SNvAxPPnJmCqfehN8mC
         HrvwyGkHRLj7s6Cmxmgslw4cMGw+SstCmQdyXNpDEWHPwryT3Or9jzFBK0bMOw/rofOR
         BK4A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=poM+lQtBssF0aCZYnLKRKD9hwY5qDrWsSm+NnhHcPRw=;
        b=OFx6lKJaUZfuH4xgoNEP+Oaiv7eQQKk4DH7PLaX1/s+lGhXaHnm1E0+0z3YXVzvbEr
         VNSAc9lE8vgOG3enFpDY0H7rhVHt5L1OWuul8yKYYYq1B5fvHbg9y13EauXY7440vRF7
         FuC0tnbob30PTYi3Zn4h82szFp1PYAu748vnQCCwerd6SckHeqJwbrfyrQudSeTaGJo2
         wBOmevY1/yN76tJ0JyF8mczXzQELjSIcKwrtLV9hLtzH2yeH9QhX7viToVAZ1OBtB0jI
         pti/Y9hPDBqPW289X3l31u75zDYzQIbsG7PM6RQuVrYCDPpaiHB8kKS7wfdkl18TpjYT
         Ghqg==
X-Gm-Message-State: AOAM531cNnyIu0/yvh9qRz0jK6oYyLi24Uif5Vwf0+vm0EFQoc9XXRex
        SvfMu6Z/Mr0OYLfxiyP5lk9gg+7e7JsJuXUF
X-Google-Smtp-Source: ABdhPJxXqlbcm1stLYb2MWb0BzMWoBK0fWjAA9XDtMGiNF38yxEYnqxjmfjn5s/+55wf5/z51yLyMA==
X-Received: by 2002:a6b:6e07:: with SMTP id d7mr12301228ioh.35.1598448603548;
        Wed, 26 Aug 2020 06:30:03 -0700 (PDT)
Received: from [192.168.1.58] ([65.144.74.34])
        by smtp.gmail.com with ESMTPSA id b23sm1150043ios.39.2020.08.26.06.30.02
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 26 Aug 2020 06:30:03 -0700 (PDT)
Subject: Re: 5.8 stable inclusion request
To:     Greg KH <gregkh@linuxfoundation.org>
Cc:     stable@vger.kernel.org
References: <eac5cc64-641f-58b9-5f58-7bc1c4393bbb@kernel.dk>
 <20200826103041.GB3356257@kroah.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <de9539b3-2ac5-6664-3121-24977401ceea@kernel.dk>
Date:   Wed, 26 Aug 2020 07:30:02 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20200826103041.GB3356257@kroah.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 8/26/20 4:30 AM, Greg KH wrote:
> On Mon, Aug 24, 2020 at 04:42:35PM -0600, Jens Axboe wrote:
>> Hi,
>>
>> Can I get this patch queued up for 5.8? It's a backport of two
>> commits from upstream. Thanks!
> 
> Now queued up, thanks!

Thanks Greg!

-- 
Jens Axboe

