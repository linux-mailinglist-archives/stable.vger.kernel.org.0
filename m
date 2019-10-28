Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 264E1E72BB
	for <lists+stable@lfdr.de>; Mon, 28 Oct 2019 14:39:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731242AbfJ1NjM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Oct 2019 09:39:12 -0400
Received: from mail-pf1-f195.google.com ([209.85.210.195]:47097 "EHLO
        mail-pf1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729742AbfJ1NjM (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 28 Oct 2019 09:39:12 -0400
Received: by mail-pf1-f195.google.com with SMTP id b25so6879472pfi.13;
        Mon, 28 Oct 2019 06:39:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=tmr54Q5Qr/0fvZprRn/mxU/Hu8sttOZ5X5l+6lthxhk=;
        b=QWDThVKDpzTBW5lVtkCPqAODLuSkCr7fRhKQ8gwdT2WnG0XqP+7cr/4/uFgjEjtSqz
         S44K3jdTr6S7r1AF1LiJb5ntHu7Jehfdh/JEfjFOnilcuTRBbAd1irZ/VOFGz5Z0UPR/
         OASlSlBaidDcjt7Q3cCGlVHNOBn0uOy0sr0Ul/cMoIWZuyWGrX0WTgK3OpaRLG6dpakN
         9wuznaWfl4NK6xuyPRD/uDDrVvm7KRSA9S3FrMLsSVzjKu45BA3EnJ15fvUActMxEdbm
         DcbYAIckBro9lRWusSg0yrP0i2g4tEbO/mraq0SzT2qgaXEqxlMPRbvexI2eyePvkR2/
         LXsA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:subject:to:cc:references:from:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=tmr54Q5Qr/0fvZprRn/mxU/Hu8sttOZ5X5l+6lthxhk=;
        b=oz5J+5u08uxJOsiUaNCvG3hCqm3xdtjZzBK00IlW4yCljks3A/2ky+s1jvz5k0jsG8
         Vhzp8AHOOynGkz1mrvxmw2tymVqURGnD3f/3X8CEceJ287VCOHk5253xosAY2OfjcAbB
         UDHc/nkm614aK4zXqb1q/HuNkTFvMrSOuAPjv6NtbGuw7Rlo865ETaX+ZhCZEfpGc9p6
         tsA/XBj4I/TphWD+ahtsnYazOMjuTD0HT5alse15mvo/OGa8jdTBdgwb5a8DN6N/lTMc
         CA9CXRQ9GHCdcNy+iIYfyaHbLQxZkztpqU7PZsAZf+29km32wiGgA2bs9KRIOCNHTqMl
         M1wA==
X-Gm-Message-State: APjAAAXn3JiPKxBbN9BTPqHe+2Dk4d4akvgjplHsitc5mCuOLwZx9IDu
        nLp/j3vWNlJPx+gfsCGR+0M4Odpz
X-Google-Smtp-Source: APXvYqyX5rfytHGtXP46KcsGMlKnTJSgYc2gqhtoRAuQeL4TyOARfPvfIoHDT0Cycvsa2J1sSJAp5A==
X-Received: by 2002:a17:90a:eb02:: with SMTP id j2mr71338pjz.80.1572269949687;
        Mon, 28 Oct 2019 06:39:09 -0700 (PDT)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id j6sm10202591pfa.124.2019.10.28.06.39.08
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 28 Oct 2019 06:39:09 -0700 (PDT)
Subject: Re: [PATCH 5.3 000/197] 5.3.8-stable review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     torvalds@linux-foundation.org, akpm@linux-foundation.org,
        shuah@kernel.org, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        stable@vger.kernel.org
References: <20191027203351.684916567@linuxfoundation.org>
From:   Guenter Roeck <linux@roeck-us.net>
Message-ID: <ca7be240-e71f-58aa-79ef-9d35acb3bc8e@roeck-us.net>
Date:   Mon, 28 Oct 2019 06:39:08 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <20191027203351.684916567@linuxfoundation.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 10/27/19 1:58 PM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.3.8 release.
> There are 197 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Tue 29 Oct 2019 08:27:02 PM UTC.
> Anything received after that time might be too late.
> 


Build results:
	total: 158 pass: 158 fail: 0
Qemu test results:
	total: 391 pass: 391 fail: 0

Guenter
