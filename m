Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5C962138214
	for <lists+stable@lfdr.de>; Sat, 11 Jan 2020 16:44:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730068AbgAKPof (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 11 Jan 2020 10:44:35 -0500
Received: from mail-pl1-f193.google.com ([209.85.214.193]:32876 "EHLO
        mail-pl1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730067AbgAKPof (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 11 Jan 2020 10:44:35 -0500
Received: by mail-pl1-f193.google.com with SMTP id ay11so2054509plb.0;
        Sat, 11 Jan 2020 07:44:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=TwY4SgunnR+6rbriJ5GEpUiDkOUjDSHdKPVKt5rqqb4=;
        b=usf/N6x6ISNupI8sac7VeF5oK8mACfvuhvVCTaauNlwA2NbgyORIEZrEzMIpxBWtRp
         9gsWRhz7OOUFRjOFd+HX+cVV2Gyx7p3aFZpD/h2GYzc3sjw94+Z4P7A2XTyjKDgKPzCx
         mkb0vGKXGKl30HLobrMz+SnCGs5uuR6gj6SHjVJXRr/IV1KCftN7yfVRZ5SD8/dCcqfO
         8qRzW4kBeWAyIttVrk6mf6L7c3hF21tIuiA9+r8S+mF/QyqiU4BRaInPFk/CuqKxwIlt
         MjhrqW/tfS4qwi8G9AUKJKcbDG+aLhVOSHGJvo4IQ4L2LdZB7i9TbvwoIJdubrj7ufPB
         7V7Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:subject:to:cc:references:from:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=TwY4SgunnR+6rbriJ5GEpUiDkOUjDSHdKPVKt5rqqb4=;
        b=SzaXx8ylqLHg7O4Qq6mZ1mxdThzX6HD2QdVaVA8FKkELsTm78HFAP+mMNBlZS6uQrN
         xoyxd9CkQjW7Q3l2akYyCT3r+h02QolKdOgNaTfK0alh2L3vVU2zJbCbhDSDzKVUr31D
         fMgbQP7cF608CE2NELKG7gJ8OgtVd4l+Gd7aje0caDm0wFG+wTm1t7Ta2ABrnYa19yug
         n11hEjOBV/VVsMv6QAWHLZyNoHaYXyerhthd0FSEJN6bs37G3KgweMNu7udx5UIY7RYQ
         KMyn3GZXEP46EpB1n6bEenDY+CXblpDC6wQlLRZUgA63Xambm58v3PvSbdNAHHddeRSu
         akaA==
X-Gm-Message-State: APjAAAUPFFJoTiYScOMZju59jatFXKEC9JBdJXUbWrbLt5wmj4E83hOj
        yu8vjGrXi+H7CnEHuUw0tjtXUyfP
X-Google-Smtp-Source: APXvYqxmUHMsyvH5wnvXijEkmPj6S0YpTTRJ12dE4/KFI120smGZIFx5ryIu0RiXedXCBbqUgQfdiA==
X-Received: by 2002:a17:902:bc85:: with SMTP id bb5mr11132281plb.208.1578757474063;
        Sat, 11 Jan 2020 07:44:34 -0800 (PST)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id q22sm7579507pfg.170.2020.01.11.07.44.32
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 11 Jan 2020 07:44:33 -0800 (PST)
Subject: Re: [PATCH 4.9 00/91] 4.9.209-stable review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     torvalds@linux-foundation.org, akpm@linux-foundation.org,
        shuah@kernel.org, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        stable@vger.kernel.org
References: <20200111094844.748507863@linuxfoundation.org>
From:   Guenter Roeck <linux@roeck-us.net>
Message-ID: <0668a7b6-502b-719b-a2eb-59519de7bf3e@roeck-us.net>
Date:   Sat, 11 Jan 2020 07:44:31 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.2
MIME-Version: 1.0
In-Reply-To: <20200111094844.748507863@linuxfoundation.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 1/11/20 1:48 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.9.209 release.
> There are 91 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Mon, 13 Jan 2020 09:46:17 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 172 pass: 169 fail: 3
Failed builds:
	arm:allmodconfig
	arm:u8500_defconfig
	arm64:allmodconfig
Qemu test results:
	total: 358 pass: 358 fail: 0

drivers/hwtracing/coresight/coresight-tmc-etf.c: In function 'tmc_alloc_etf_buffer':
drivers/hwtracing/coresight/coresight-tmc-etf.c:295:10: error: 'event' undeclared

Guenter
