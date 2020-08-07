Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 44D8723EEEE
	for <lists+stable@lfdr.de>; Fri,  7 Aug 2020 16:19:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726095AbgHGOTE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 7 Aug 2020 10:19:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43868 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725815AbgHGOTE (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 7 Aug 2020 10:19:04 -0400
Received: from mail-pj1-x102e.google.com (mail-pj1-x102e.google.com [IPv6:2607:f8b0:4864:20::102e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 61AA7C061756
        for <stable@vger.kernel.org>; Fri,  7 Aug 2020 07:19:04 -0700 (PDT)
Received: by mail-pj1-x102e.google.com with SMTP id e4so954281pjd.0
        for <stable@vger.kernel.org>; Fri, 07 Aug 2020 07:19:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=PB81bzp2sOZ8tK55CDVhvVJAfHAeYdnIrn19hx46dww=;
        b=WqNmBCdtBP2HyRPpHqxIuZjsAlPwpxCOoHyIkf3ysu+Yh2ymURdQD4HXVG11o5gz2Z
         e+/C1yx0Tg5L9wjGh6V9UP5b81GRFrMeb/7G2W2OnhQdmgjLPmCHgITbnh5nS1SD7kJ8
         kmSdxjy47Prf31+oBg5GCCOSu6+mW+ZLtDIWarKFKMuj846Xk4BzZwGIY7lqie60+LKQ
         ULuuZ7VN4+BV0BIiqKe+xqRP7nktriq8TAma4Xm28ZsTpff2SzV2KFtDXEQTzl3Ps8Aa
         8o5z7BQhmu8ThSH4XsVUuWzEu/WJtJe48FnbKmOe5pCST/t7va5Hwh6zCF/ZKYWHvUnd
         X2kw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=PB81bzp2sOZ8tK55CDVhvVJAfHAeYdnIrn19hx46dww=;
        b=IvN42DX+zRHnTNKa6j7m5HC3wlm7T4jKaBuoSooh3IXtTalKerwFiBgolZ125OQXQY
         v5ANlzRMir3G9nCoN8P3ydIlAQsQ2Fx9nMQMOiL7nxN+rG2x4us82FamISL8GVHMl6Y4
         SsAw3Bc92QnsYlwqYC4vnYxV/QK7j/Qzu2wFVEZBgSeobNkvnN1xwzNdBHkKk+ZRa+Yw
         ePjPLrJzVe9VTQcE7r/qJ2k+VOgw2gRNuuCWwP75J9TFUetQ0ALq81FthDOcNerfVBO4
         rvR+e+PfmJlion8ZopEzReIz9UpSQkegRG65ZWxrBt9mLcuzt9eS1df1X5KJ6YJaWeHR
         VQkg==
X-Gm-Message-State: AOAM530LOtlh9yytS8iC0bqgQD8LD6WV7m+NnQBH3GeGD6Iq8unDx9M0
        owtw02EPidliP5Zt6DlcCLMVAkZmxm4=
X-Google-Smtp-Source: ABdhPJwxDVeskgWwIfD47Ek1Z0JKHP5A4oUc6VelTezSNDpaLnH/vb6BCc23gNvEeoht5+VoCETi7g==
X-Received: by 2002:a17:90a:13c7:: with SMTP id s7mr13630645pjf.233.1596809942769;
        Fri, 07 Aug 2020 07:19:02 -0700 (PDT)
Received: from [192.168.1.182] ([66.219.217.173])
        by smtp.gmail.com with ESMTPSA id g129sm12737569pfb.33.2020.08.07.07.19.01
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 07 Aug 2020 07:19:02 -0700 (PDT)
Subject: Re: 5.4 stable inclusion request
To:     Greg KH <greg@kroah.com>
Cc:     stable@vger.kernel.org
References: <9740b863-25f0-7adc-7bdc-f95bf8c664f5@kernel.dk>
 <69e11137-dd04-5c95-e73c-6c826196d46d@kernel.dk>
 <20200807131933.GD664450@kroah.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <359fa946-0114-84f5-fa3d-d8d59a964ec7@kernel.dk>
Date:   Fri, 7 Aug 2020 08:19:00 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20200807131933.GD664450@kroah.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 8/7/20 7:19 AM, Greg KH wrote:
> On Wed, Aug 05, 2020 at 01:10:25PM -0600, Jens Axboe wrote:
>> On 8/5/20 12:34 PM, Jens Axboe wrote:
>>> Hi,
>>>
>>> Below is a io_uring patch that I'd like to get into 5.4. There's no
>>> equiv 5.5 commit, because the resulting changes were a lot more invasive
>>> there to avoid re-reading important sqe fields. But the reporter has
>>> also tested this one and verifies it fixes his issue. Can we get this
>>> queued up for 5.4?
>>
>> And on top of that, this one as well which is also only applicable to
>> 5.4. Thanks!
> 
> Also queued up, thanks!

Thanks, for both!

-- 
Jens Axboe

