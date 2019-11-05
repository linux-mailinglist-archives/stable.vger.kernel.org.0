Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5CD07EFFA3
	for <lists+stable@lfdr.de>; Tue,  5 Nov 2019 15:25:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730671AbfKEOZL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Nov 2019 09:25:11 -0500
Received: from mail-pg1-f194.google.com ([209.85.215.194]:36509 "EHLO
        mail-pg1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727888AbfKEOZL (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Nov 2019 09:25:11 -0500
Received: by mail-pg1-f194.google.com with SMTP id k13so2995507pgh.3;
        Tue, 05 Nov 2019 06:25:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=GJMezQQNlVnSwv2ss+Vd/RJX6IaTNnaSBUgM/8Icdzo=;
        b=IAnvAP6fmKtj1mzVM1soJxYG/rMKvYt3X/sVWJ5Kmq5/XEazv53mNk7AixmsnXdvge
         bxiGSe/5roFCaQUbjjBLgpO+ktqTQFit+jHTc7nqeQ3vGqQzn+tWzTGrKUys15oG1l1p
         Yg2bjj6Fc2on5Z6w+SHBpdcgt2vjdX+W169HGXt5XEOj4KVGL0MCJ6kXe/7TOQdxMIR/
         /mHtxGPdlAHCLyo7aFq+EFQcOzH1uSs6vFUYvW8f4d7sNlKN5sx3tZYOcOXwF3PF+lMV
         zwfjePigRR9rnXLcb+81MQ1bjH7Q9F95u19eT3IJE1iA/E8WvddcLV3gxA71LzAY3zg5
         4Wzw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:subject:to:cc:references:from:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=GJMezQQNlVnSwv2ss+Vd/RJX6IaTNnaSBUgM/8Icdzo=;
        b=YUkezHHB/lfP82wyWRwlfUcO0v29VIG+eBKMHH2YEVFmQL4Jfc/E5vVE7QrhqplibC
         ff4T3fmybAYs9esgQtYdp+QEmZ07HRIYHI0e5duQdt6fjnN2/CH/PZFKa+MO8TsMJLjV
         n4Rkt1SQ6fF8BTjRQNoC81mKTvywidn3TMtV9djfM/nET4oUWS47z6+WdG/yVAQ1woHp
         NLAAzasXjINcxyvehyUfCf2ugniyVwWXQ+B0/q/B3zVMo3x0Bempffowjuli+Nyv5UoG
         qf05RffNhjoiWglrix9yxPCQdiCvCLiJuCnm9Jr+oJoADEpE3NVY0Mdk367mXlun9cdG
         oWug==
X-Gm-Message-State: APjAAAVNt7yeCdSwAvQJGsN/uwjUZsvlmdjafdnIX09nRq0o+t6/8uv/
        doT0Z9pFqp3vfyn4pbLIfa7Iq0kQ
X-Google-Smtp-Source: APXvYqxmU2162+a9Cv7q4D7WGAbOIY+Prp42x16BKgp9cQoWhE2Oy4+J6Qkfksg+unZRjEsF263uVA==
X-Received: by 2002:aa7:82cd:: with SMTP id f13mr38855759pfn.69.1572963910351;
        Tue, 05 Nov 2019 06:25:10 -0800 (PST)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id w2sm25285318pgm.18.2019.11.05.06.25.09
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 05 Nov 2019 06:25:09 -0800 (PST)
Subject: Re: [PATCH 4.14 00/95] 4.14.152-stable review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     torvalds@linux-foundation.org, akpm@linux-foundation.org,
        shuah@kernel.org, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        stable@vger.kernel.org
References: <20191104212038.056365853@linuxfoundation.org>
From:   Guenter Roeck <linux@roeck-us.net>
Message-ID: <4689ed0b-bad0-db14-892d-18257ac21a14@roeck-us.net>
Date:   Tue, 5 Nov 2019 06:25:08 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <20191104212038.056365853@linuxfoundation.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 11/4/19 1:43 PM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.14.152 release.
> There are 95 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed 06 Nov 2019 09:14:04 PM UTC.
> Anything received after that time might be too late.
> 

Build results:
	total: 172 pass: 172 fail: 0
Qemu test results:
	total: 372 pass: 372 fail: 0

Guenter
