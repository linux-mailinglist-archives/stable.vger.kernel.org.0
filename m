Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3BCF21FE2D
	for <lists+stable@lfdr.de>; Thu, 16 May 2019 05:34:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726394AbfEPDeK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 15 May 2019 23:34:10 -0400
Received: from mail-pl1-f193.google.com ([209.85.214.193]:45073 "EHLO
        mail-pl1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726218AbfEPDeJ (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 15 May 2019 23:34:09 -0400
Received: by mail-pl1-f193.google.com with SMTP id a5so856122pls.12;
        Wed, 15 May 2019 20:34:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=5qtrpQxz8Ihh1G35ldmcNIfnxr7BZgltd9PNOsZiXk8=;
        b=ZvTNCHkqWJHVhjvOhbtk9rxZzSCK3wmi3Ufqe7U4w7m5VpB9wHvRYA/PEdOukG3Kv8
         2jQPPc1CZjHB85harY/n9wL3/pjBVB0x1MfMR79cvS7YMq54K8Dv1sEJsfjkeUhdNS8h
         SypWolMf4zpkLxtH5HGzclezvce8/1i11CNRpIWIX8Nr0AqX1827YizjO/Rcei+pEOKA
         eLjxkUrlgrAfS5xBXkdZGtT3GkIlIfmPNdOae+FKa5SEL5cv3YBeDevJ7hNXJAXwYCRf
         GQ+0scLBGjvyDu9VjI5JQgIwSjU47HCy8+Br512sbbbMtVWCIag8Y+yWmFpx+dpUGRvo
         yMXQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:subject:to:cc:references:from:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=5qtrpQxz8Ihh1G35ldmcNIfnxr7BZgltd9PNOsZiXk8=;
        b=BSHNSdZanV35JzjryqhLe0zRPcUv37i/ld5KP7S/bYM5iyZ8D9hA9mKj+lcFHdLlks
         7X+0MGlSrdqfDnH1Zwbx1QQIE+rzTBAD1oUNpAEN1+kbJg8c/1C5u1HLa0rdyxnyMPJc
         LVkARO36EkkKD7zP4a++KsumvQVcdjjCEEvKni+uh8uS7dGZNz0EoH0cg448jyDCyhb3
         j+6ehNChND/PTJBsX6+5oArrcxTTa1ftNgl1aMy5IX+Oad3xo/KdK6D3VNFfppyGFqI8
         e2VTlRIkI+JeEZ7cjs9cM62rJqKKbV9peE58xwRq1i80DgE0Q8qzHTWNDdrE7FDZMJe4
         MiwA==
X-Gm-Message-State: APjAAAUr7+JVXCVH/fHfbvGBTttZhALtHcxaJIDaI6vwKm5Aad8IyXBa
        4gCM1wahvtt7Cy0444DvgDuCBiV8
X-Google-Smtp-Source: APXvYqyVGMKNfOry3K++8U2vk5CGj44bVMceXC3P8yBwM3+bpQburD7/24vHQKOABoAYUBnuNWSWLQ==
X-Received: by 2002:a17:902:728d:: with SMTP id d13mr5025947pll.337.1557977648872;
        Wed, 15 May 2019 20:34:08 -0700 (PDT)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id s11sm3992074pga.36.2019.05.15.20.34.07
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 15 May 2019 20:34:08 -0700 (PDT)
Subject: Re: [PATCH 4.4 000/266] 4.4.180-stable review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     torvalds@linux-foundation.org, akpm@linux-foundation.org,
        shuah@kernel.org, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        stable@vger.kernel.org
References: <20190515090722.696531131@linuxfoundation.org>
From:   Guenter Roeck <linux@roeck-us.net>
Message-ID: <d27103f6-f763-d3db-b207-b1a8c8f6ac88@roeck-us.net>
Date:   Wed, 15 May 2019 20:34:07 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <20190515090722.696531131@linuxfoundation.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 5/15/19 3:51 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.4.180 release.
> There are 266 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri 17 May 2019 09:04:49 AM UTC.
> Anything received after that time might be too late.
> 

Build results:
	total: 170 pass: 170 fail: 0
Qemu test results:
	total: 296 pass: 296 fail: 0

Guenter
