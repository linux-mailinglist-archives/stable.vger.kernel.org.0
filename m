Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B4B52255D1E
	for <lists+stable@lfdr.de>; Fri, 28 Aug 2020 16:54:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726563AbgH1Ox7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 28 Aug 2020 10:53:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59664 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726462AbgH1Ox5 (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 28 Aug 2020 10:53:57 -0400
Received: from mail-io1-xd32.google.com (mail-io1-xd32.google.com [IPv6:2607:f8b0:4864:20::d32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B1492C061264
        for <stable@vger.kernel.org>; Fri, 28 Aug 2020 07:53:56 -0700 (PDT)
Received: by mail-io1-xd32.google.com with SMTP id m23so1497622iol.8
        for <stable@vger.kernel.org>; Fri, 28 Aug 2020 07:53:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=rFhxHBa6asNlvVNqy4ckOxjdDB4bRE2sB1sLEC/3Axk=;
        b=rJnO3SlFxNaw4dIieeLbpf/zESRYt0H8WdhituwSE94gl8BWrU5eaA/rr4bTZikb6k
         xB5JCndzMPzQDa7ZKqUZ0+Fg4FGl83UAVsIxULmXbCjcEO5B7xXWPTJZWR2ImTDMX0st
         cJNn2nmuuSzT3e8Hk+MYc1qfj8DYIqbKcvAfg/iz13qVpD8t+KpOmkvPoWQrrsSb16cP
         PqiD0klB47lOcCzv+bTTwWcN/IQOEU+hpEf0mU/kVSZO3SVYAhSP0t/8os+SxSo/c3Qd
         E7R9z4pUGINW8BcTHTGi7lFgeIzI9YO++CK3n0ucFsDiFO19IBr/LC0rpro7UKRpIqWU
         9srQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=rFhxHBa6asNlvVNqy4ckOxjdDB4bRE2sB1sLEC/3Axk=;
        b=j2AzWvDo6YsaD1QXIl9nJJj2WB3slvG7jig9rXnlKNKeZb6EUAAG0NkWMZFUU+Ph6E
         QTpSQSVfMnemEXgu+MWNURLS3ayfn6VByBmMAVb3MZs8tLVC+yelhL48B1G0EzwTK0BJ
         CLNuHHNbWXYJcIcoisewOixlOcoXuhc3dxiusafiSfq1x+7HAMcUvriyVxu2M7j7Ae/v
         bM0zUUcp1a5ayHmJmUxE6Dvy4Jr4vuSEUf8yPAn2AJkUwrxXTthaJPBzDDdEmLFk5YsY
         /FSDpEclEIMezJouvyGrK2JGRjYd9exznJMPvS9Ne70V59FNAy1/2uzMmV4dgyv7bKVH
         lRnA==
X-Gm-Message-State: AOAM530A1Ik8h5P+Ihhe5NkraHybQrbO/Nk3aKriErWcM/BusPVfAMui
        TAkkXOBU+mjReOHjEyXaRG9SAjoUKvL1dnte
X-Google-Smtp-Source: ABdhPJw00YllUtSJLn/p8+qncO/LdeaBBXdfryu9AApcso5yET9ZPaPxduD2wVvC2sio61VT9sEt8A==
X-Received: by 2002:a05:6638:d4f:: with SMTP id d15mr1422324jak.119.1598626435489;
        Fri, 28 Aug 2020 07:53:55 -0700 (PDT)
Received: from [192.168.1.58] ([65.144.74.34])
        by smtp.gmail.com with ESMTPSA id s143sm700823ilc.14.2020.08.28.07.53.54
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 28 Aug 2020 07:53:55 -0700 (PDT)
Subject: Re: Stable inclusion request, 5.7
To:     Sasha Levin <sashal@kernel.org>
Cc:     stable@vger.kernel.org
References: <00c75f42-f71e-2455-272d-d6efc715f299@kernel.dk>
 <20200828145310.GR8670@sasha-vm>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <06b7462a-61b6-a574-4acf-41b8ed96e196@kernel.dk>
Date:   Fri, 28 Aug 2020 08:53:54 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20200828145310.GR8670@sasha-vm>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 8/28/20 8:53 AM, Sasha Levin wrote:
> On Fri, Aug 28, 2020 at 08:40:24AM -0600, Jens Axboe wrote:
>> Hi,
>>
>> Can you cherry-pick this one:
>>
>> commit e697deed834de15d2322d0619d51893022c90ea2
>> Author: Jiufei Xue <jiufei.xue@linux.alibaba.com>
>> Date:   Wed Jun 10 13:41:59 2020 +0800
>>
>>    io_uring: check file O_NONBLOCK state for accept
>>
>> into 5.7-stable? Thanks!
> 
> 5.7 is dead :)

Oh, long live its memory! Sad...


-- 
Jens Axboe

