Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E259A224BB5
	for <lists+stable@lfdr.de>; Sat, 18 Jul 2020 16:15:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726775AbgGROPT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 18 Jul 2020 10:15:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36782 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726574AbgGROPT (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 18 Jul 2020 10:15:19 -0400
Received: from mail-pf1-x443.google.com (mail-pf1-x443.google.com [IPv6:2607:f8b0:4864:20::443])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 197A8C0619D2
        for <stable@vger.kernel.org>; Sat, 18 Jul 2020 07:15:19 -0700 (PDT)
Received: by mail-pf1-x443.google.com with SMTP id 1so6810390pfn.9
        for <stable@vger.kernel.org>; Sat, 18 Jul 2020 07:15:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=t2dtF5Pwe0ZlJk3YRerE3pg08pPXaScJaF84Xkkg7z4=;
        b=eWmd7BPj3GqkknXZzAR8mZcmdwZPR2NUlHwWqasQroVh6l0oA6aWFcjySNFlX1/hzv
         PfC73JVl17jsJbdf/S4cUanCEw4iVzmsjdtdkE75zDMv377j0eA2S5vXBpVbqAD8w7tO
         1kbG0kqACPPZ8QmLqx+/PfpiXdPl6jlVfDJkYZdBg6VPKGafJtAk0RSwFLbeFpt7gDR2
         M/v7wAZotuBOk2/TjQ4eoskvH07UkjEyK97NdEsdOMhKvrxccqseOwEpAdedah9JDnbG
         oGB4k7vc7a81F+61Fl0ht1ou8FSqExuZl7MF4FHGdntA+iFqU9b7k5dv53xhh/DAauor
         P7jQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=t2dtF5Pwe0ZlJk3YRerE3pg08pPXaScJaF84Xkkg7z4=;
        b=B5jJpScpvz2W8L+Qooal+srbxrgPFDpxa5wXwc4pjP0vg/387pfmz/TJNnYgwIHdWa
         taUfFGq867Z1P6MQJYjWCnTl4mZ2jOqvCiBpG19mqrm8uoXEVCxUZsuZ8paM1pvJPWXU
         mVFXmNBTrUhPvUibnoEcLdCyRrBMGSOMRdb+GXdyAd/DPjLsIS6/yizXOYJSxNkTgCvt
         XC3x35OpfHPJRn7Asd+k/J0ODqa89hnkwH0AstPZtzve3nYHFJPWfdvow4YZ6cz/Qt9h
         NX4x1+LuCE6s1uVHxydY7RsYvGHLgiQMZtVrAn6t6UoZVVoy3PDenlbObZBcM+NRWulu
         mgJg==
X-Gm-Message-State: AOAM533eTzBxKWXlEYsT+hcGTuo/fKHT2rIzge8RgvjRXmmbxneY7LF5
        jpfDLJeu9IDw6Mgjmv4UV3QD9U5kQUKSHg==
X-Google-Smtp-Source: ABdhPJzKPA8XfwUKvnEDqNIw7Ahqhzp5HKXMbwp4t1srIhNOepfTeQLxZiut7CkvwAQ85riJUFPrvw==
X-Received: by 2002:a65:408b:: with SMTP id t11mr12358285pgp.407.1595081718146;
        Sat, 18 Jul 2020 07:15:18 -0700 (PDT)
Received: from [192.168.1.182] ([66.219.217.173])
        by smtp.gmail.com with ESMTPSA id p5sm10163070pgi.83.2020.07.18.07.15.17
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 18 Jul 2020 07:15:17 -0700 (PDT)
Subject: Re: Stable inclusion request
To:     Greg KH <gregkh@linuxfoundation.org>
Cc:     stable@vger.kernel.org
References: <bd2a28c0-ee8c-3be9-58f1-a52cc935bb86@kernel.dk>
 <20200718061125.GA3437964@kroah.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <4134bbd7-a22a-09c0-f7d5-0658e057d5aa@kernel.dk>
Date:   Sat, 18 Jul 2020 08:15:16 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20200718061125.GA3437964@kroah.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 7/18/20 12:11 AM, Greg KH wrote:
> On Fri, Jul 17, 2020 at 12:09:58PM -0600, Jens Axboe wrote:
>> Hi,
>>
>> I forgot to mark this one with stable, can you please cherry-pick it
>> for 5.7-stable? It picks cleanly. Thanks!
>>
>> commit 681fda8d27a66f7e65ff7f2d200d7635e64a8d05
>> Author: Pavel Begunkov <asml.silence@gmail.com>
>> Date:   Wed Jul 15 22:20:45 2020 +0300
>>
>>     io_uring: fix recvmsg memory leak with buffer selection
> 
> Now queued up, thanks!

Thanks Greg!

-- 
Jens Axboe

