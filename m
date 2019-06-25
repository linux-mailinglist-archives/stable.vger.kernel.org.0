Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 84A8651FCC
	for <lists+stable@lfdr.de>; Tue, 25 Jun 2019 02:15:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730080AbfFYAO5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jun 2019 20:14:57 -0400
Received: from mail-pf1-f195.google.com ([209.85.210.195]:35400 "EHLO
        mail-pf1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729202AbfFYAO4 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jun 2019 20:14:56 -0400
Received: by mail-pf1-f195.google.com with SMTP id d126so8432518pfd.2;
        Mon, 24 Jun 2019 17:14:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=xN6gcDovCiA+43T8KtnAGd5MrtIeIvCobe6Sye7XCPQ=;
        b=TT6Ee6KZQdqlSZrXq7Pq2yeotp2LcXxmie06Xi0bBWdoPOkQZb8FhE0SE8ZLEIN2xa
         ASC0TvOs6Kvpqy7KTt9GjRWuLH27jPH14iOG7nKJ58klDnczeGQ7uyd4lRK9QJHL82Hb
         sKBmaUBnzf4gsx0feUL7oNsDeQ1Twh1eZCyTGzVJ+M85ol+yGVBztyuHbujiCiNypYhw
         hZuHsQLU6z9gc8aJfeVdZ9s0ee1nCcGZh8F18+Bbd8IaRuHP7SXchP+J//qfAf5BiCzf
         P/gDW7FO4Ay7EF8Q/t7Mac0Je163f9OMqFouYtQXdMdy76e0dwiylUg628ULQQC2E3y3
         SKMg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:subject:to:cc:references:from:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=xN6gcDovCiA+43T8KtnAGd5MrtIeIvCobe6Sye7XCPQ=;
        b=dYrI+4nz0vP7W7ko0XcIlDjtMQfjSF6spzPxNjQU9qbVxvV6J/9+oiO0H4/x2q4Cgv
         PYqgqpz6rG81PdSZ2bfZf/nm2VPYGnor2Ke6eme63Q7dM+YzY+O0KhRIy5CSXyx/fWEL
         CfddovMahsAyA1P9AcgUx7dXc2OA8G2TSbEu0T10D7O1RMVuK0ZFoQd1CsbVN9LCZJy3
         hSDjoLLHkxbJU/+30uHGw/UTAJIsBb2k2tEM0/Mmr/2BREE458M5YAQiVwi8Eedx9cJ/
         IL4pSKgVckLb8o1g1dw6Nr99mh5ZAShJB0Xk2yQWLXqsbl3L+SPgpztH7T8jGw27FSaI
         fATA==
X-Gm-Message-State: APjAAAWfWtYoAxDv8y6cLVViL3p6d5KBWFmnmXLhBgxkgKY2x4qzBSat
        XHkFQwJQmDfL8Y5Xau0d6zZ7yLZr
X-Google-Smtp-Source: APXvYqxQb3oCt+Ol4W6ofuBsljRoToTTJRZC+scaQ9964KbN/N+1cKSBR0Ko55TRnLhzmFIZecyVzg==
X-Received: by 2002:a17:90a:32c7:: with SMTP id l65mr15964832pjb.1.1561421694786;
        Mon, 24 Jun 2019 17:14:54 -0700 (PDT)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id s129sm12859194pfb.186.2019.06.24.17.14.53
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 24 Jun 2019 17:14:53 -0700 (PDT)
Subject: Re: [PATCH 4.19 00/90] 4.19.56-stable review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     torvalds@linux-foundation.org, akpm@linux-foundation.org,
        shuah@kernel.org, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        stable@vger.kernel.org
References: <20190624092313.788773607@linuxfoundation.org>
From:   Guenter Roeck <linux@roeck-us.net>
Message-ID: <76fe752e-834c-335f-aac3-64e7bc2ab92a@roeck-us.net>
Date:   Mon, 24 Jun 2019 17:14:52 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.1
MIME-Version: 1.0
In-Reply-To: <20190624092313.788773607@linuxfoundation.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 6/24/19 2:55 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.19.56 release.
> There are 90 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed 26 Jun 2019 09:22:03 AM UTC.
> Anything received after that time might be too late.
> 

For v4.19.55-92-gd8e5ade617e9:

Build results:
	total: 156 pass: 156 fail: 0
Qemu test results:
	total: 364 pass: 364 fail: 0

Guenter
