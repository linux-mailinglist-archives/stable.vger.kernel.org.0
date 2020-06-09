Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D3C861F3EC6
	for <lists+stable@lfdr.de>; Tue,  9 Jun 2020 17:01:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730656AbgFIPBs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 9 Jun 2020 11:01:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43572 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730531AbgFIPBm (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 9 Jun 2020 11:01:42 -0400
Received: from mail-ot1-x342.google.com (mail-ot1-x342.google.com [IPv6:2607:f8b0:4864:20::342])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D014CC08C5C3
        for <stable@vger.kernel.org>; Tue,  9 Jun 2020 08:01:38 -0700 (PDT)
Received: by mail-ot1-x342.google.com with SMTP id n6so7503030otl.0
        for <stable@vger.kernel.org>; Tue, 09 Jun 2020 08:01:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=fV8ZFDB43FV3g5g5fZTxYLi7vsPxA13YSgKOxxB6Lc4=;
        b=ifgMqLNaEDoJ3ggtZ+CDKXlxlAhzRY618v/+r51qXTg5XTFIpLHDYpOowMjKcjIxfH
         TS9NlRSEADUBQ12AB25ifuTk2OIXnmtJ5PptilvJ0j8B/+B1Y69m5jA7/p0DkP1IjQ6+
         yEOpkGL/mNoOp/IWAhjZxONzJuJU9Z3p8hbNg=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=fV8ZFDB43FV3g5g5fZTxYLi7vsPxA13YSgKOxxB6Lc4=;
        b=EvGXPWFj/8dxSYF6zfy1K6S6ui5CvWrjx2c4bsXGoX55XyZBnAQXTGsrfdoCUlQKPs
         zf88Lj1UGhVRpn2H37JRLu4zoQnX0PNxU3MdddPh3RG9IPKqnH6lIYJI3Wx0cCcgDM9j
         0KTmh+HL21exk8vWREKcGZiEQWm55pSh++2K3z2DUTehf41czMcnMlrf3HVBaWILH5Za
         ytDxWiUbtk1tjz0ivZ/kMZmXexEMFIPNcrUUYa1OhYD92AgaiO1E3cQCPWu+HorRcbDl
         LSB4g5l2B+DLOPexT8KHDWxqMGUSPXmYOLgM01TxfQHo2cibLAfB8otZC42Xo2GdWDe1
         73AQ==
X-Gm-Message-State: AOAM531H8Bwz7FzMwUvfw/MMPBEHESIsvLVjDotQguaomIFYLQzD9QZa
        82TlkxPLG5/wWciY5y57umNfGA==
X-Google-Smtp-Source: ABdhPJxGmnoepX29AANMk4+Z5b3vk+XlqO9YIXrRdoke3DisNE70ra7JK0DqrOFn056B0XzmgUHgGQ==
X-Received: by 2002:a9d:969:: with SMTP id 96mr15323599otp.319.1591714897141;
        Tue, 09 Jun 2020 08:01:37 -0700 (PDT)
Received: from [192.168.1.112] (c-24-9-64-241.hsd1.co.comcast.net. [24.9.64.241])
        by smtp.gmail.com with ESMTPSA id s124sm3209070oig.19.2020.06.09.08.01.35
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 09 Jun 2020 08:01:36 -0700 (PDT)
Subject: Re: [PATCH 1/1] selftests: fpga: dfl: A test for afu interrupt
 support
To:     Tom Rix <trix@redhat.com>, Greg KH <gregkh@linuxfoundation.org>
Cc:     stable <stable@vger.kernel.org>, linux-fpga@vger.kernel.org,
        shuah@kernel.org, linux-kernel@vger.kernel.org,
        linux-kselftest@vger.kernel.org,
        Shuah Khan <skhan@linuxfoundation.org>
References: <20200609130208.27390-1-trix@redhat.com>
 <20200609130208.27390-2-trix@redhat.com> <20200609142007.GA831428@kroah.com>
 <d3d8e518-0760-8cbe-cf74-191f70329a46@redhat.com>
From:   Shuah Khan <skhan@linuxfoundation.org>
Message-ID: <340c25e4-579b-a06b-49ae-63937dc0fbf0@linuxfoundation.org>
Date:   Tue, 9 Jun 2020 09:01:35 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.8.0
MIME-Version: 1.0
In-Reply-To: <d3d8e518-0760-8cbe-cf74-191f70329a46@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 6/9/20 8:45 AM, Tom Rix wrote:
> 
>> Why not use the ksft_* functions and frameworks to properly print out
>> the test status and results so that tools can correctly parse it?
>>
>> It's generally bad-form to make up your own format.
> 
> I used the the drivers/dma-buf test a basis example.  Can you point me at a better example ?
> 

A few examples to choose from as a reference:

tools/testing/selftests/breakpoints
tools/testing/selftests/timens

Please reach out to me if you have any questions.

thanks,
-- Shuah


