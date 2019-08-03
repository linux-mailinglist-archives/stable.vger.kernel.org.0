Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8CF848071C
	for <lists+stable@lfdr.de>; Sat,  3 Aug 2019 17:59:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728069AbfHCP7h (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 3 Aug 2019 11:59:37 -0400
Received: from mail-pg1-f196.google.com ([209.85.215.196]:38041 "EHLO
        mail-pg1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726300AbfHCP7h (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 3 Aug 2019 11:59:37 -0400
Received: by mail-pg1-f196.google.com with SMTP id z14so326593pga.5;
        Sat, 03 Aug 2019 08:59:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=Y3MkGnG+LMH2nH0yTCtZYLfApoOMzmYScJTXAjGWDXw=;
        b=g1wthnUdgXGIK2KQYUPChaKI04jLFyY+yqBqI9tYHHP0mXiGKO4zK7EFkUGL8VNm7k
         icRbWa2CwYsCUDViev9mDnTUtL9e0IRgAjXZN8qqMzXs8b6s4DYpLEvoA2CzrbYRZ8sD
         JIrwQKWZwJsDHiZLYaBLS2VbsHAbcCDBL3Zv4NdR+ZTu/eb6alKVunOk4Jg63jNojefk
         i1a4bAEBO1EtVWA4H+WzjlLpf3hNysI99I2PAOgbP3HpKXPkF8c+ejTi2Wb0mK+JzZVZ
         MJ3U7Lki662/GwylDE7BIJggz4z7jqxTvMlsLzYc/BQLoeMuAo9KZAt451m+hXJqO/ab
         pSNA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:subject:to:cc:references:from:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=Y3MkGnG+LMH2nH0yTCtZYLfApoOMzmYScJTXAjGWDXw=;
        b=uC7EyfgA/tgxDtjKQcxJt7nMnpz17tx1o8TG6YV5x1nxTEC5/10JrSQLgcOkcvfPvL
         eqmWvka2hWyMm9NL5M5CWSI0QgNIgyrgePYEscvSSJYAjKX8JNsIGvODT8EJkt2xX7TB
         vn2p7tc+mK4vj+s/xeRxqBKOXpBWmBTkpptR9ouBEtpZBvnjLArDFXLGDPt0qIMhpHtM
         3HSzP6EVgPwhbOZ6WXHrqvVODlh0KQQhwmH3nDmS2CMf9PiRM9G0/KQzsAlcl/1APe9m
         zu3byHcaHlTxJODJ2DZGa1SXsP1Zk8y5+/ZCfjX7vU/mU+n1rtcPVm22PepR03vGrLPh
         +X+Q==
X-Gm-Message-State: APjAAAVMR33Ean7FTtsEdTBZ9Bp4vDe8PkS0rRss7rN0b7W4117MJhOB
        +Nou7CN/ie+K9HjHk5LIxxok0/y4
X-Google-Smtp-Source: APXvYqzslopK1wgYldrWwk0wZ9xclnFqjZWz8+Dwg7+W3NnmUp+CONCYzYjnOHU4mB+i9nFPxQyreA==
X-Received: by 2002:a62:ae02:: with SMTP id q2mr63665960pff.1.1564847976618;
        Sat, 03 Aug 2019 08:59:36 -0700 (PDT)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id z13sm79320199pfa.94.2019.08.03.08.59.35
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sat, 03 Aug 2019 08:59:36 -0700 (PDT)
Subject: Re: [PATCH 4.19 00/32] 4.19.64-stable review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     torvalds@linux-foundation.org, akpm@linux-foundation.org,
        shuah@kernel.org, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        stable@vger.kernel.org
References: <20190802092101.913646560@linuxfoundation.org>
From:   Guenter Roeck <linux@roeck-us.net>
Message-ID: <4a00e471-92cb-986b-48b8-9477208c9dd0@roeck-us.net>
Date:   Sat, 3 Aug 2019 08:59:34 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20190802092101.913646560@linuxfoundation.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 8/2/19 2:39 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.19.64 release.
> There are 32 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sun 04 Aug 2019 09:19:34 AM UTC.
> Anything received after that time might be too late.
> 

Build results:
	total: 156 pass: 156 fail: 0
Qemu test results:
	total: 364 pass: 364 fail: 0

Guenter
