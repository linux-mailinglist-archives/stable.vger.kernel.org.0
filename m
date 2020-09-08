Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5C653261774
	for <lists+stable@lfdr.de>; Tue,  8 Sep 2020 19:35:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730277AbgIHRe7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 8 Sep 2020 13:34:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56710 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731595AbgIHQPM (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 8 Sep 2020 12:15:12 -0400
Received: from mail-il1-x141.google.com (mail-il1-x141.google.com [IPv6:2607:f8b0:4864:20::141])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 13205C061235
        for <stable@vger.kernel.org>; Tue,  8 Sep 2020 06:29:08 -0700 (PDT)
Received: by mail-il1-x141.google.com with SMTP id a8so9646379ilk.1
        for <stable@vger.kernel.org>; Tue, 08 Sep 2020 06:29:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:from:to:cc:references:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=GhdRp0aepZK0I4AkCcc/ijBgn3ADrD7bOtPUhqFCBCo=;
        b=0Gb8FN1HmjsLC1r8xDmc4eERVxTosc0WHeYo+PEDGyWwOW1FOSr2TOKJTrbiM+zUs4
         Yas0hLw5Acr/8aDqSgp1N8oJr8vxk0kAEj3b/Bu3aQ93I+iDkkcbhaQ6c6jcuv8ZxJCF
         R4MOnke7eKRMBBb9qfpiLu98FiTjG4w8IXDbZ+Cg73j/DtJ85NF8cy5EhmD/98+egIlr
         hunUrLMBPKE50Hh0xEPwhLci3nWyHc79aWP4xU5cMl0FHjvUO8E/eyWka/QjNfCtyBqB
         +wjPBNc956I8qupbP08Od/YvsdJMoxf98FV+7DfWSOnj+8NNVvPeqTvIMNXAttCjb0Rx
         EK0Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:references:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=GhdRp0aepZK0I4AkCcc/ijBgn3ADrD7bOtPUhqFCBCo=;
        b=dw+M5TWUt6b36rRU5XthcV1ES6RyN+E2R1GIX5Md/qKyv5WPv477Ixxt5VR0RNDO3L
         Sa+n3ddBupWZEkM3Gwz8ZCUY0HNSUU8QH9c3sbw82uPWkpzpI/vpGxrxnQueI5CsxuIo
         32IoLM3Nk9vMHeTswmLkMIoewcQWPlDA6g0f2xJJP7yHKnkaQdB6ZMpkC0dLMBLek7bK
         snHM04zey0309WLCqGpxp7fJtJ2nDEwyARKY52NVUd+1kSiKVz6dvgivu2IwM2QyFbR7
         N1d9a5H1aKXy1x7NcwaOVCGh/+AONavdoggLyhhVIsvCnUr1ROIoSQKSflgS+2wTsa1M
         Mi6g==
X-Gm-Message-State: AOAM5327yn99L95EIm7hIMaRk+gpBgLXZwKbxmLbXomYbQFuBAmrwZDf
        AnlUp5m51U5FAjRvWrJHuHvQEP0QffnCTByc
X-Google-Smtp-Source: ABdhPJymIhDHGnL0yJJ/rZ0qIEirMA/jQPebFsVm8ZwH3GiFyK9ASfX3W6YJLQbpdWgKMng3ofZ7Gw==
X-Received: by 2002:a92:1551:: with SMTP id v78mr22302401ilk.157.1599571747095;
        Tue, 08 Sep 2020 06:29:07 -0700 (PDT)
Received: from [192.168.1.10] ([65.144.74.34])
        by smtp.gmail.com with ESMTPSA id z26sm10359448ilf.60.2020.09.08.06.29.06
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 08 Sep 2020 06:29:06 -0700 (PDT)
Subject: Re: 5.8 io_uring stable
From:   Jens Axboe <axboe@kernel.dk>
To:     Greg KH <gregkh@linuxfoundation.org>
Cc:     stable@vger.kernel.org
References: <49361215-3d71-71e8-7cd2-1f7009323a30@kernel.dk>
 <20200908123129.GA1960547@kroah.com>
 <9e66ef5d-0dfa-8061-1a17-7e2bb722e43e@kernel.dk>
Message-ID: <7e412946-c85a-658d-1b07-dbe3551dc3cd@kernel.dk>
Date:   Tue, 8 Sep 2020 07:29:05 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <9e66ef5d-0dfa-8061-1a17-7e2bb722e43e@kernel.dk>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 9/8/20 7:11 AM, Jens Axboe wrote:
> On 9/8/20 6:31 AM, Greg KH wrote:
>> On Fri, Sep 04, 2020 at 03:06:28PM -0600, Jens Axboe wrote:
>>> Hi,
>>>
>>> Linus just pulled 3 fixes from me - 1+2 should apply directly, here's
>>> the 3rd one which will need some love for 5.8-stable. I'm including it
>>> below to preempt the failed to apply message :-)
>>>
>>>
>>> commit fb8d4046d50f77a26570101e5b8a7a026320a610
>>> Author: Jens Axboe <axboe@kernel.dk>
>>> Date:   Wed Sep 2 10:19:04 2020 -0600
>>>
>>>     io_uring: no read/write-retry on -EAGAIN error and O_NONBLOCK marked file
>>>     
>>>     Actually two things that need fixing up here:
>>>     
>>>     - The io_rw_reissue() -EAGAIN retry is explicit to block devices and
>>>       regular files, so don't ever attempt to do that on other types of
>>>       files.
>>>     
>>>     - If we hit -EAGAIN on a nonblock marked file, don't arm poll handler for
>>>       it. It should just complete with -EAGAIN.
>>>     
>>>     Cc: stable@vger.kernel.org
>>>     Reported-by: Norman Maurer <norman.maurer@googlemail.com>
>>>     Signed-off-by: Jens Axboe <axboe@kernel.dk>
>>>
>>> diff --git a/fs/io_uring.c b/fs/io_uring.c
>>> index 82e15020d9a8..96be21ace79a 100644
>>> --- a/fs/io_uring.c
>>> +++ b/fs/io_uring.c
>>> @@ -2726,6 +2726,12 @@ static int io_read(struct io_kiocb *req, bool force_nonblock)
>>>  				ret = ret2;
>>>  				goto done;
>>>  			}
>>> +			/* no retry on NONBLOCK marked file */
>>> +			if (req->file->f_flags & O_NONBLOCK) {
>>> +				ret = ret2;
>>> +				goto done;
>>> +			}
>>> +
>>>  			/* some cases will consume bytes even on error returns */
>>>  			iov_iter_revert(iter, iov_count - iov_iter_count(iter));
>>>  			ret2 = 0;
>>> @@ -2869,9 +2875,15 @@ static int io_write(struct io_kiocb *req, bool force_nonblock)
>>>  		 */
>>>  		if (ret2 == -EOPNOTSUPP && (kiocb->ki_flags & IOCB_NOWAIT))
>>>  			ret2 = -EAGAIN;
>>> +		/* no retry on NONBLOCK marked file */
>>> +		if (ret2 == -EAGAIN && (req->file->f_flags & O_NONBLOCK)) {
>>> +			ret = 0;
>>> +			goto done;
>>> +		}
>>>  		if (!force_nonblock || ret2 != -EAGAIN) {
>>>  			if ((req->ctx->flags & IORING_SETUP_IOPOLL) && ret2 == -EAGAIN)
>>>  				goto copy_iov;
>>> +done:
>>>  			kiocb_done(kiocb, ret2);
>>>  		} else {
>>>  copy_iov:
>>>
>>> -- 
>>> Jens Axboe
>>
>>
>> Thanks for the backport, but this didn't apply at all to the 5.8.y tree.
>> What one did you make it against?
> 
> Oh, might have been because I have a pile of pending 5.8 stable patches...
> Let me apply to pristine stable, test, and then I'll send it to you.

Here it is:


commit d0ea3f3d17cf891244f17f8ceb43d4988c170471
Author: Jens Axboe <axboe@kernel.dk>
Date:   Tue Sep 8 07:16:12 2020 -0600

    io_uring: no read/write-retry on -EAGAIN error and O_NONBLOCK marked file
    
    Actually two things that need fixing up here:
    
    - The io_rw_reissue() -EAGAIN retry is explicit to block devices and
      regular files, so don't ever attempt to do that on other types of
      files.
    
    - If we hit -EAGAIN on a nonblock marked file, don't arm poll handler for
      it. It should just complete with -EAGAIN.
    
    Cc: stable@vger.kernel.org
    Reported-by: Norman Maurer <norman.maurer@googlemail.com>
    Signed-off-by: Jens Axboe <axboe@kernel.dk>

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 4115bfedf15d..fe114511d6d6 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -2697,8 +2697,15 @@ static int io_read(struct io_kiocb *req, bool force_nonblock)
 		else
 			ret2 = -EINVAL;
 
+		/* no retry on NONBLOCK marked file */
+		if (ret2 == -EAGAIN && (req->file->f_flags & O_NONBLOCK)) {
+			ret = 0;
+			goto done;
+		}
+
 		/* Catch -EAGAIN return for forced non-blocking submission */
 		if (!force_nonblock || ret2 != -EAGAIN) {
+	done:
 			kiocb_done(kiocb, ret2);
 		} else {
 copy_iov:
@@ -2823,7 +2830,13 @@ static int io_write(struct io_kiocb *req, bool force_nonblock)
 		 */
 		if (ret2 == -EOPNOTSUPP && (kiocb->ki_flags & IOCB_NOWAIT))
 			ret2 = -EAGAIN;
+		/* no retry on NONBLOCK marked file */
+		if (ret2 == -EAGAIN && (req->file->f_flags & O_NONBLOCK)) {
+			ret = 0;
+			goto done;
+		}
 		if (!force_nonblock || ret2 != -EAGAIN) {
+done:
 			kiocb_done(kiocb, ret2);
 		} else {
 copy_iov:

-- 
Jens Axboe

