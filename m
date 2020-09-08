Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DA94D261D7C
	for <lists+stable@lfdr.de>; Tue,  8 Sep 2020 21:38:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732286AbgIHThu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 8 Sep 2020 15:37:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53428 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730779AbgIHPzo (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 8 Sep 2020 11:55:44 -0400
Received: from mail-il1-x141.google.com (mail-il1-x141.google.com [IPv6:2607:f8b0:4864:20::141])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 660E3C0612AC
        for <stable@vger.kernel.org>; Tue,  8 Sep 2020 06:11:06 -0700 (PDT)
Received: by mail-il1-x141.google.com with SMTP id t13so15268138ile.9
        for <stable@vger.kernel.org>; Tue, 08 Sep 2020 06:11:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=VPeq+tYgMnJD3rxUaqN60m0e01kG/g729pTiFT5ThKg=;
        b=VBAQ83Eb8vwxqYn24pCHgmsWilSUsRY2xFfph6eAKwmtJoq8//4jI/nEVKJd2VrdC2
         zXRGwiRHriJhEYmZqJzpYxd7coaGOy1z7brcs/JrSVOpP7neAJDniDNZWpBGhauRZAmP
         tAouJnkofUCZCbRIu6rtlqOyxQdQokK3FJTZ2yq2ifW0Zj4Rh+Tae33hu6pVh2TQe0Yx
         2dcshHjsT0aLEYl6HlYv7xNbW6W8RtAWGdlt6tKIQfIpEm846HCnmXd4mhZShErhfBCB
         XOTng+weLW5bfHW9IIY/CfxrClpQoO6qr0hhmnI6m0WJo4N/RrfI6lOOsKx8StitBKOX
         wkdg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=VPeq+tYgMnJD3rxUaqN60m0e01kG/g729pTiFT5ThKg=;
        b=TEVpq3Gn/jFS66V4gy96UEW1UHsrMLm66rDsiv758qpEyZRHb0fkKsIOgRngykQz+G
         bWjoj5L1WayTeBlB17eGsmRp0zMgQFfJYeYsXseLUjJ1H35WVX1GiOCNXf3HrAKHYTDW
         XzJrCuA1FBVXQZcx70hVcff3i+6FvDWSxRAeD9VSEsm/g8eliyzWQYqb6zEA3u/ipssL
         IT4IRZWFosLFsHvMQ9gZ22vrsiyRHf3nyqqcKNlhmkgACxQf9Yx5s0KM33JTnh5EFyqu
         bxdsTNvCg77RUa1PCu0R5gosAa4QCN0fI/aWiF7gIOMyzUTKzciCPeLSF6ue+oQaL4x9
         hEqg==
X-Gm-Message-State: AOAM533qqCTYP8qLrNFk6UAbFD5A/gEcL9lYpaoUDcksqlHhnoD0Z8Up
        ZxqXPI1vsuNUJaFhkbHCda8dNlVrBTv6wNdi
X-Google-Smtp-Source: ABdhPJxBgYpsubIcBhk0231WgOdZ6mWzVamBSBcWytHxKssGQFjWg5qNXg7PtsYf7Yabj1K/tL0TYQ==
X-Received: by 2002:a92:ba45:: with SMTP id o66mr21375257ili.38.1599570665383;
        Tue, 08 Sep 2020 06:11:05 -0700 (PDT)
Received: from [192.168.1.10] ([65.144.74.34])
        by smtp.gmail.com with ESMTPSA id r17sm10385913ilj.72.2020.09.08.06.11.04
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 08 Sep 2020 06:11:04 -0700 (PDT)
Subject: Re: 5.8 io_uring stable
To:     Greg KH <gregkh@linuxfoundation.org>
Cc:     stable@vger.kernel.org
References: <49361215-3d71-71e8-7cd2-1f7009323a30@kernel.dk>
 <20200908123129.GA1960547@kroah.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <9e66ef5d-0dfa-8061-1a17-7e2bb722e43e@kernel.dk>
Date:   Tue, 8 Sep 2020 07:11:04 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20200908123129.GA1960547@kroah.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 9/8/20 6:31 AM, Greg KH wrote:
> On Fri, Sep 04, 2020 at 03:06:28PM -0600, Jens Axboe wrote:
>> Hi,
>>
>> Linus just pulled 3 fixes from me - 1+2 should apply directly, here's
>> the 3rd one which will need some love for 5.8-stable. I'm including it
>> below to preempt the failed to apply message :-)
>>
>>
>> commit fb8d4046d50f77a26570101e5b8a7a026320a610
>> Author: Jens Axboe <axboe@kernel.dk>
>> Date:   Wed Sep 2 10:19:04 2020 -0600
>>
>>     io_uring: no read/write-retry on -EAGAIN error and O_NONBLOCK marked file
>>     
>>     Actually two things that need fixing up here:
>>     
>>     - The io_rw_reissue() -EAGAIN retry is explicit to block devices and
>>       regular files, so don't ever attempt to do that on other types of
>>       files.
>>     
>>     - If we hit -EAGAIN on a nonblock marked file, don't arm poll handler for
>>       it. It should just complete with -EAGAIN.
>>     
>>     Cc: stable@vger.kernel.org
>>     Reported-by: Norman Maurer <norman.maurer@googlemail.com>
>>     Signed-off-by: Jens Axboe <axboe@kernel.dk>
>>
>> diff --git a/fs/io_uring.c b/fs/io_uring.c
>> index 82e15020d9a8..96be21ace79a 100644
>> --- a/fs/io_uring.c
>> +++ b/fs/io_uring.c
>> @@ -2726,6 +2726,12 @@ static int io_read(struct io_kiocb *req, bool force_nonblock)
>>  				ret = ret2;
>>  				goto done;
>>  			}
>> +			/* no retry on NONBLOCK marked file */
>> +			if (req->file->f_flags & O_NONBLOCK) {
>> +				ret = ret2;
>> +				goto done;
>> +			}
>> +
>>  			/* some cases will consume bytes even on error returns */
>>  			iov_iter_revert(iter, iov_count - iov_iter_count(iter));
>>  			ret2 = 0;
>> @@ -2869,9 +2875,15 @@ static int io_write(struct io_kiocb *req, bool force_nonblock)
>>  		 */
>>  		if (ret2 == -EOPNOTSUPP && (kiocb->ki_flags & IOCB_NOWAIT))
>>  			ret2 = -EAGAIN;
>> +		/* no retry on NONBLOCK marked file */
>> +		if (ret2 == -EAGAIN && (req->file->f_flags & O_NONBLOCK)) {
>> +			ret = 0;
>> +			goto done;
>> +		}
>>  		if (!force_nonblock || ret2 != -EAGAIN) {
>>  			if ((req->ctx->flags & IORING_SETUP_IOPOLL) && ret2 == -EAGAIN)
>>  				goto copy_iov;
>> +done:
>>  			kiocb_done(kiocb, ret2);
>>  		} else {
>>  copy_iov:
>>
>> -- 
>> Jens Axboe
> 
> 
> Thanks for the backport, but this didn't apply at all to the 5.8.y tree.
> What one did you make it against?

Oh, might have been because I have a pile of pending 5.8 stable patches...
Let me apply to pristine stable, test, and then I'll send it to you.

-- 
Jens Axboe

