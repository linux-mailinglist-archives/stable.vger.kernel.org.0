Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 13B6B8071F
	for <lists+stable@lfdr.de>; Sat,  3 Aug 2019 18:00:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727961AbfHCQAO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 3 Aug 2019 12:00:14 -0400
Received: from mail-pf1-f193.google.com ([209.85.210.193]:35727 "EHLO
        mail-pf1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726300AbfHCQAO (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 3 Aug 2019 12:00:14 -0400
Received: by mail-pf1-f193.google.com with SMTP id u14so37532568pfn.2;
        Sat, 03 Aug 2019 09:00:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=yTadWe86gKjo9vnan4joaBeNoEwdwBddX6AmXeDPPnk=;
        b=P23R6vcEPbH7WU3Ildsh+a2PH4O0CM6bPHIz/f8xqiz2+k+8yfsr6vKYxNx+JiVqmH
         Zmp8bHEMDNP0AaG2aCd1gFjaxku2PkNZxfpMp13NMtHxFJdEr7cEwcv2uijxknq58b4d
         9XbzIAt/6viyI6Z9k2l0G3KgNMXL5rR8o2z06vO8Ccn6Gmij4MC+pkV6p1HppHg9BOTo
         ++dfSSjbx+KYG7bNI0iKJ1//GAUhtF4x44+h3J8FHKGNv2pqsZUwWXrR5p+nQnWMJubF
         Jhg+oRkUjIROEBzOaLlMyR0AZeCZbzI6brQBAKuLrb5gqp63ZHy40qlSMlmSHOSL4BjM
         6WmQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:subject:to:cc:references:from:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=yTadWe86gKjo9vnan4joaBeNoEwdwBddX6AmXeDPPnk=;
        b=U7jmhERifJixxSDfmjZfuRaOJbfzITASq9xi3QSK/yON0xMIpna9x1mZRGU1Pt/wpZ
         4jgeLkbLIZiQmFL6aFCG0z74n+cqlM1yYqbddnTBilJFvB/PHeHRZ0nWIjEf1jVDMUfH
         NO5vwwhLGi5hhy6zvD//AGWFvEbu1fSNEBbZkNzMXlIciSnHsO0rFJufBs5itsYTar1J
         G+sCWvVLb9BK7Aj04YK4gQmuEwGylB1bLFC6FD58fL6o8uqYuy4IOC+/Q7arulnGga4U
         ypDUIWgl+BVDElJDVbWnmdVzQBKWe9lbTWOVVdSFKeEwozRZ2d6OX/TUJzRzv8eSs5tx
         U8KQ==
X-Gm-Message-State: APjAAAXG34o+kcf/xHzc9uKxc0fLryTlRU7IkJNwXbpe/ZEicrz4ECGu
        abmMNrWJ4vHupwtMrPak/pYgD2hJ
X-Google-Smtp-Source: APXvYqxCvcYpOCV/sU7Hj00YTUEvZToGSzLWs5hHFJyjSUJ9Uw9+OyJLg8DHn5EMMtY/6kgWSaDPrg==
X-Received: by 2002:a65:6846:: with SMTP id q6mr90826502pgt.150.1564848013058;
        Sat, 03 Aug 2019 09:00:13 -0700 (PDT)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id cx22sm10630030pjb.25.2019.08.03.09.00.12
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sat, 03 Aug 2019 09:00:12 -0700 (PDT)
Subject: Re: [PATCH 5.2 00/20] 5.2.6-stable review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     torvalds@linux-foundation.org, akpm@linux-foundation.org,
        shuah@kernel.org, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        stable@vger.kernel.org
References: <20190802092055.131876977@linuxfoundation.org>
From:   Guenter Roeck <linux@roeck-us.net>
Message-ID: <9492210e-e617-f636-d0f6-6a6381ad9461@roeck-us.net>
Date:   Sat, 3 Aug 2019 09:00:11 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20190802092055.131876977@linuxfoundation.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 8/2/19 2:39 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.2.6 release.
> There are 20 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sun 04 Aug 2019 09:19:34 AM UTC.
> Anything received after that time might be too late.
> 

Build results:
	total: 159 pass: 159 fail: 0
Qemu test results:
	total: 364 pass: 364 fail: 0

Guenter
