Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 91260D33D3
	for <lists+stable@lfdr.de>; Fri, 11 Oct 2019 00:19:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726097AbfJJWTY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 10 Oct 2019 18:19:24 -0400
Received: from mail-pf1-f195.google.com ([209.85.210.195]:38739 "EHLO
        mail-pf1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725959AbfJJWTY (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 10 Oct 2019 18:19:24 -0400
Received: by mail-pf1-f195.google.com with SMTP id h195so4795384pfe.5;
        Thu, 10 Oct 2019 15:19:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=F/FYzqQThPjjE+q3xaGHSSSlp3WdxYihIUU+5B3Qq+A=;
        b=nROd86tADP2oU/5PRiHOKrF4MwknyNTYwpmQ15kZS08WWA0p9TgbivLGlsi3JMgOfR
         LFHZHJc3aLYPGBPUfqO0kQKOdIk6RNzjZCj5MbSSqCI/UNEFlyS8fxPnyyze8oPZKkY0
         pFCkxkmNYxDy/FFPH429xUtNlIMAlt7cojJtgpqVECdGa+JSXyg5BbHHCn96ae3vuNI5
         KLsBdcIvao93CI46nIQH/E9RI+OeGoCGkPgPhLYTDIvtZVv9xlNw8FSvC1PJ24S8hgvj
         6r5ine8fh0qoCF3wetH56A0YmGcJHHZWe5EqYwkV7IjBKyW2SIytCEGmPlJqXSVtNiUS
         cmqw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:subject:to:cc:references:from:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=F/FYzqQThPjjE+q3xaGHSSSlp3WdxYihIUU+5B3Qq+A=;
        b=G3QPY+IK7lHvBFf0ncfpleUBbSQu+bhPvPo76sfDQTEpMZSPRYTaL3EnlLvPCg61Jh
         VamN0bf69Dat9qHIwXcc7dY1nKX8Q5zQdQUr1Z0gePx2XbBUhmk0T3rQ2rkRHnd0xyp1
         QsX2WNgmNwze61GgNA0ar2yjmOxctYOYS2WTjxIsZHdEL1dzuTCzM36T8vMLqmuYiDPK
         WuYnfccijjNReLoxQQmozRAb2MmdRVBK0YVzl512BB+QstkBPtz1XBDw/EFMXhOt9psa
         U6p3+kUm6WFtClZq8JkNKHfDyDvuLk5GGrxWcici3rjGCzrXzn3N9C9Uwg/St5cOEjNa
         XBzA==
X-Gm-Message-State: APjAAAVf8hLi/9Mch7I9cgftKMje7Xag7fFDltqlCXfLk4XnpwSwkU7L
        CB+ke8ipuBXHd5PnlWwtNqxuw4yC
X-Google-Smtp-Source: APXvYqwoTKaDpaTaEbEwDe9jRkp5lPzOQJJpygvOLd0xfNYn7aQmZ3HgDuNlr0JyM7+XNLZkszIw7w==
X-Received: by 2002:a17:90a:d983:: with SMTP id d3mr14292492pjv.5.1570745963398;
        Thu, 10 Oct 2019 15:19:23 -0700 (PDT)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id r28sm8841454pfg.62.2019.10.10.15.19.22
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 10 Oct 2019 15:19:22 -0700 (PDT)
Subject: Re: [PATCH 4.19 000/114] 4.19.79-stable review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     torvalds@linux-foundation.org, akpm@linux-foundation.org,
        shuah@kernel.org, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        stable@vger.kernel.org
References: <20191010083544.711104709@linuxfoundation.org>
From:   Guenter Roeck <linux@roeck-us.net>
Message-ID: <4779e5fd-ef78-d0ba-04b1-7d5c520e2f02@roeck-us.net>
Date:   Thu, 10 Oct 2019 15:19:21 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20191010083544.711104709@linuxfoundation.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 10/10/19 1:35 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.19.79 release.
> There are 114 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sat 12 Oct 2019 08:29:51 AM UTC.
> Anything received after that time might be too late.
> 

Build results:
	total: 156 pass: 156 fail: 0
Qemu test results:
	total: 390 pass: 390 fail: 0

Guenter
