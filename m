Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E67EE31562
	for <lists+stable@lfdr.de>; Fri, 31 May 2019 21:33:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727282AbfEaTdU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 31 May 2019 15:33:20 -0400
Received: from mail-pg1-f182.google.com ([209.85.215.182]:43942 "EHLO
        mail-pg1-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726808AbfEaTdT (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 31 May 2019 15:33:19 -0400
Received: by mail-pg1-f182.google.com with SMTP id f25so4565207pgv.10;
        Fri, 31 May 2019 12:33:19 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=tF4itkqnXuiTyUoa0PM1pBKr3QyIJoJOIgWAaCan9v8=;
        b=UdbkpMHZGzIhlylkhxIi5Co/v81bLstXixqKj7cgvtxn0edtXMQn/XJbieZ2fKRj+5
         mB2voTkAo35pxV10bJcUE7LqNNP5/WoCRjiV2LlxURPj5CDKEKvQXFDotCIbvqffhdjL
         btJY22XZs42LVy1LrHG/926D/UDE3jvh/S2W8qjPlXL2hMzBXTu1zP75W1M4Caf8NH+z
         A61tO7UncvTNlAYOUBIrl02TYkDLSgtaMhb5B4k1QDVoXflCiQ8kOYTzLWqcAcobBCoQ
         DvsRy1+tAbsh+zufIOVz+HWZieUZwDX7X7wr765fAeaUHjzqmnh6VNw/omF7KLkMn0I5
         ygHQ==
X-Gm-Message-State: APjAAAX5H1W3zbHZhEm898ka4cS5jCLTr2CgnT1rBw2ibhU328KYGCE2
        VuACPJWHos1qKGVVEV3QahftO0Q6
X-Google-Smtp-Source: APXvYqy5jhD6b7Wtpuh1kyQPz8jssbocCY50E7GCI4UbM1odJoBKqZ0xOKoo2iyNuep5VB1mGsAqrg==
X-Received: by 2002:a17:90a:2a09:: with SMTP id i9mr11543070pjd.103.1559331198576;
        Fri, 31 May 2019 12:33:18 -0700 (PDT)
Received: from desktop-bart.svl.corp.google.com ([2620:15c:2cd:202:4308:52a3:24b6:2c60])
        by smtp.gmail.com with ESMTPSA id x28sm7843526pfo.78.2019.05.31.12.33.12
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 31 May 2019 12:33:13 -0700 (PDT)
Subject: Re: [PATCH, RESEND] RDMA/srp: Accept again source addresses that do
 not have a port number
To:     Jason Gunthorpe <jgg@ziepe.ca>
Cc:     Leon Romanovsky <leonro@mellanox.com>,
        Doug Ledford <dledford@redhat.com>, linux-rdma@vger.kernel.org,
        Laurence Oberman <loberman@redhat.com>, stable@vger.kernel.org
References: <20190529163831.138926-1-bvanassche@acm.org>
 <20190530184437.GA29836@ziepe.ca>
From:   Bart Van Assche <bvanassche@acm.org>
Message-ID: <aa530e2d-a968-4532-cdaa-a6cbf722f19e@acm.org>
Date:   Fri, 31 May 2019 12:33:12 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <20190530184437.GA29836@ziepe.ca>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 5/30/19 11:44 AM, Jason Gunthorpe wrote:
> On Wed, May 29, 2019 at 09:38:31AM -0700, Bart Van Assche wrote:
>> The function srp_parse_in() is used both for parsing source address
>> specifications and for target address specifications. Target addresses
>> must have a port number. Having to specify a port number for source
>> addresses is inconvenient. Make sure that srp_parse_in() supports again
>> parsing addresses with no port number.
>>
>> Cc: Laurence Oberman <loberman@redhat.com>
>> Cc: <stable@vger.kernel.org>
>> Fixes: c62adb7def71 ("IB/srp: Fix IPv6 address parsing") # v4.17.
>> Signed-off-by: Bart Van Assche <bvanassche@acm.org>
>> ---
>>   drivers/infiniband/ulp/srp/ib_srp.c | 21 +++++++++++++++------
>>   1 file changed, 15 insertions(+), 6 deletions(-)
> 
> Bart, do you want this applied now, or are we still waiting for
> Laurence?

Hi Jason,

Since Laurence has not replied to your e-mail please go ahead and apply 
this patch.

Thanks,

Bart.
