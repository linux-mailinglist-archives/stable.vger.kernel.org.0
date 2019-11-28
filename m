Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0A0E510CC85
	for <lists+stable@lfdr.de>; Thu, 28 Nov 2019 17:13:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726510AbfK1QNi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 28 Nov 2019 11:13:38 -0500
Received: from mail-ot1-f67.google.com ([209.85.210.67]:41671 "EHLO
        mail-ot1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726446AbfK1QNi (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 28 Nov 2019 11:13:38 -0500
Received: by mail-ot1-f67.google.com with SMTP id r27so8038919otc.8;
        Thu, 28 Nov 2019 08:13:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=hiXEUpIIPHvSovonzi/yF3+y+4Mf9i8FsBGcIABv/ZA=;
        b=aT/1pj89u2x7JKUWY72APirBvyJ55YPaAnQBkeQBuYRBCV8s8JzZVNi2vv9tpxatgK
         PzetLCVctRuRdBM433SQ1AZjgLRF+EeZAk0uWLnHjzL+ja4cEndH127q6Ofxq30SiyZd
         lLcekjmLjwyFV1AlReRez0hOoEj6LhkomCZ1q5fo+xFWI7bePZQtoP+wQ1pz3qS0M7gO
         mRf7XARglJ7PdcY2ezRcxAaXvG26yn2jTWYf4ZWHKKQmXFv+oo/oHrNU2KRRbyFf23AV
         1wh2uRLrPRLbVDMpcP7T5npwv1WNkIPQGJifsmldc5O9Pcy53uqAOSMZx+rT/HVDMUaS
         mNrg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:subject:to:cc:references:from:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=hiXEUpIIPHvSovonzi/yF3+y+4Mf9i8FsBGcIABv/ZA=;
        b=W52BCxzM0VfelBB45IsMt1vC0dXCVWgRSYT/MYJ2KaeCyR1k6t1ZTu+A/wrFZDJCRf
         NPHsRxZXNgrkVykIxaznxexgl6zajp9NoGGn9LHezAfT+GerobdWmsQvHYhbzH2Lq+RI
         8gD5gcYPpY9RyHG2ZwuYdlUwXb6RBAGE5uQZrBknPAWDQVl/fmVbmYmNDjQyyW6BPFsu
         knEx1yMSZhRxb2zH9qA1boMubde1F0M7rQsF0HEMjRg55CtZ9FHonx/fpYkRGrjNkdPS
         w4DiAgqoFLD1tnqq1t8Z/7y5bYaP6DzCgPztMoY7lKIjsXwai6BzVLpWsVdu3DWXmJxU
         xaug==
X-Gm-Message-State: APjAAAUBA2sVPtrsNNmGtdGJQPmHufZ/HEo86/5DnteEV9SdcpJcXrOd
        lnKWdJpsAUFASbGkf+0j0/Tbsnxm
X-Google-Smtp-Source: APXvYqzaLe5UdudfmhfjGV1g4ahyg43i8gCIgXJowgi56v2LMMcUpWu+tH4n7GUZQhPXDJeeSnM+VQ==
X-Received: by 2002:a9d:3982:: with SMTP id y2mr8148222otb.191.1574957616994;
        Thu, 28 Nov 2019 08:13:36 -0800 (PST)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id d2sm6173073oth.48.2019.11.28.08.13.35
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 28 Nov 2019 08:13:36 -0800 (PST)
Subject: Re: [PATCH 4.4 000/132] 4.4.204-stable review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     torvalds@linux-foundation.org, akpm@linux-foundation.org,
        shuah@kernel.org, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        stable@vger.kernel.org
References: <20191127202857.270233486@linuxfoundation.org>
From:   Guenter Roeck <linux@roeck-us.net>
Message-ID: <4cc31e37-7e26-bf69-d58e-ff031b79fdc0@roeck-us.net>
Date:   Thu, 28 Nov 2019 08:13:34 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <20191127202857.270233486@linuxfoundation.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 11/27/19 12:29 PM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.4.204 release.
> There are 132 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 29 Nov 2019 20:18:09 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 170 pass: 170 fail: 0
Qemu test results:
	total: 324 pass: 324 fail: 0

Guenter
