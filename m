Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 51A6519E4C
	for <lists+stable@lfdr.de>; Fri, 10 May 2019 15:35:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727709AbfEJNf5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 10 May 2019 09:35:57 -0400
Received: from mail-pf1-f194.google.com ([209.85.210.194]:36680 "EHLO
        mail-pf1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727258AbfEJNf5 (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 10 May 2019 09:35:57 -0400
Received: by mail-pf1-f194.google.com with SMTP id v80so3262048pfa.3;
        Fri, 10 May 2019 06:35:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=nAK8e3z4DOSVOpU9buaFNcLqqKQNJvVc2tzVS1VmazI=;
        b=nMZKVmeqJX6zhqrENtRhq1oELWaJVxyHzWCRth46zHCSazrT0YqMRScDA2rJi7hExc
         jXmBzcBedUPvCMVPXkO0/MSQy1GZ9sUdoi36K+1hevYGSwyk+4zgbcJnl9tmxJkwzVDg
         CXnaHNfD2YJa81/46Er2a402EAoOSXmVG2EBKhnHsSAoIdpYMv4VxgX9XHNOlWXFV0Uz
         YYnRSF97Xt6JlCMwO+Fwp5knurpibVtOStujYd+0DADTlAF9z99P3xgVGS20IuA/ruU2
         t3vN4+sFwvSr08/JaGiw71Yop0Kb3AYG1YEl7gkX+7WYVhnyYBg1NhBNsi7tZvgIc9zd
         Ic1Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:subject:to:cc:references:from:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=nAK8e3z4DOSVOpU9buaFNcLqqKQNJvVc2tzVS1VmazI=;
        b=LZ+iJ6esaQ20lbJZ1xfv58qrxhET/jMKJpAGznwRVVVAFVjCQShzwLTOQ0BdmzAbX1
         yLZaW7GI/xHaxNkSkJ/3whM+0VJ+1D+Wvr9TYbqSrcb9VCucoTYuYCA/YFap9lZKQm+n
         p1B2miHTfUbpDPNKjDeLZ2xY4r/ALKtpGVHZ3YGJr8Hw+nuepeCsGlxJAeESL9T6VEkd
         4ptOYobnn3rZUHXW1tauEtN1R4eaQOkhOhq//7TkoIHXPUljF3J2C2r3F+NR7bCAjVbX
         GgeaihMEE9sLpzmopGSi3+k12PSTi920PxewULqc6HUcdXUBew9fnyjgnoNJCuvtI1sk
         VAhA==
X-Gm-Message-State: APjAAAW0rSnAsgI7DtQ/IqJXauPw2zAhuSbT/DNZ6PhAYAQCSTT0gJwL
        FXhE30alJXoTr3sA7VfbkeMDQ8S4
X-Google-Smtp-Source: APXvYqx7OsCUltjtZPk5PzFgfzOrKv1My8twQurOpg+QkzbhhWYLFvtzsm1CItMver2aSustTrHrLg==
X-Received: by 2002:a63:db55:: with SMTP id x21mr12998283pgi.219.1557495356345;
        Fri, 10 May 2019 06:35:56 -0700 (PDT)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id j12sm6628442pff.148.2019.05.10.06.35.54
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 10 May 2019 06:35:55 -0700 (PDT)
Subject: Re: [PATCH 4.19 00/66] 4.19.42-stable review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     torvalds@linux-foundation.org, akpm@linux-foundation.org,
        shuah@kernel.org, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        stable@vger.kernel.org
References: <20190509181301.719249738@linuxfoundation.org>
From:   Guenter Roeck <linux@roeck-us.net>
Message-ID: <67b5b17d-93a7-24b0-1644-4a66373dfcb7@roeck-us.net>
Date:   Fri, 10 May 2019 06:35:54 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <20190509181301.719249738@linuxfoundation.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 5/9/19 11:41 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.19.42 release.
> There are 66 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sat 11 May 2019 06:11:18 PM UTC.
> Anything received after that time might be too late.
> 

Build results:
	total: 156 pass: 156 fail: 0
Qemu test results:
	total: 349 pass: 349 fail: 0

Guenter
