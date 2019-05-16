Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E38271FE36
	for <lists+stable@lfdr.de>; Thu, 16 May 2019 05:38:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726259AbfEPDho (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 15 May 2019 23:37:44 -0400
Received: from mail-pf1-f196.google.com ([209.85.210.196]:37280 "EHLO
        mail-pf1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726190AbfEPDhn (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 15 May 2019 23:37:43 -0400
Received: by mail-pf1-f196.google.com with SMTP id g3so1068482pfi.4;
        Wed, 15 May 2019 20:37:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=E7y6k4UKls0iAYkSQsVw17d37O67Rv5C5tXD2wC5vZg=;
        b=oVrXWTGMyjRbM9/MYuM0U4LNsxcjwi/9hzRSEa5gkURIbdSfT9lxdvXSbvpx2r8Rkb
         idHfkYB+7Q1MR+nEyjEj+PtHrvR3JC0WjdqNKjjvUnvTv6bddvOJbopIG6SfULNirtTI
         /V3ccrbMZSBn+EhDq1CbwKS55vWj7Gv0sKyx696ecV2ElTsES9xkR5SZ+32EyZ2xm1l6
         CFtSObygAkNFiAVWFbtqZ+Xh/n97SbvaPDIImp3msGzEmW7E/wnZH4BnrHvNj4MQ8ZfS
         GpgUWlofFoFlpZpiLOuVT6a2IIStugwzk7tTvMIUQ94+Pn3veQ+t/JVEIbox45p9Ws2K
         JbWQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:subject:to:cc:references:from:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=E7y6k4UKls0iAYkSQsVw17d37O67Rv5C5tXD2wC5vZg=;
        b=VEPQFyLYljyXRMKFk3jAqfwIOVBVJNw6BT5AczUQf2vhCm/LbkKNoK45fCy/WdEtGU
         xrLRnaVt5AjivJlc9QP0F6KOLiJPEtv+RSxxjOv+sJGrhMAzY0cyG27H85Yi27bHqDPC
         8jlI6vvMSZ50/mb18cooab+b797BI0Jix3xhjTohsS09uDG+wJuMHm+CSUpK/SuZPMrf
         Cj+1k2KYgFQjTKQ7ZXDorFws1yGiYfmzMS748Ru+4QIymQV99d99Aaw4VltDQMc+CVkG
         1zLYJkyPvry1/yAnGM35oW9Ic+DqlNFXN5q1N3VN1PTFdrAmPoU+D01hxF2NkYcoCB1s
         zJEA==
X-Gm-Message-State: APjAAAWi0fcZvV7KAbpwCeIhn/uBb4FGn0BbMfokGZAnkiuRR93k+7CB
        ARQqtQeB/YY2Rw2sxO73M1Rlxzwh
X-Google-Smtp-Source: APXvYqz4LHjDcnUQ/8ezGu5f6AJ5ohC5DIrYqf0+cmICXa9FiwrOFcsT8/21w5M4MHTt+kM6DYNjwQ==
X-Received: by 2002:a62:38d3:: with SMTP id f202mr6223330pfa.41.1557977862803;
        Wed, 15 May 2019 20:37:42 -0700 (PDT)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id b32sm4129880pgm.87.2019.05.15.20.37.41
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 15 May 2019 20:37:42 -0700 (PDT)
Subject: Re: [PATCH 5.0 000/137] 5.0.17-stable review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     torvalds@linux-foundation.org, akpm@linux-foundation.org,
        shuah@kernel.org, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        stable@vger.kernel.org
References: <20190515090651.633556783@linuxfoundation.org>
From:   Guenter Roeck <linux@roeck-us.net>
Message-ID: <00af42c1-520b-46a9-5278-feecd92ae8b9@roeck-us.net>
Date:   Wed, 15 May 2019 20:37:41 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <20190515090651.633556783@linuxfoundation.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 5/15/19 3:54 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.0.17 release.
> There are 137 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri 17 May 2019 09:04:31 AM UTC.
> Anything received after that time might be too late.
> 

Build results:
	total: 159 pass: 159 fail: 0
Qemu test results:
	total: 349 pass: 349 fail: 0

Guenter
