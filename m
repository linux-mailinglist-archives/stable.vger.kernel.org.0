Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AD60E29C2F5
	for <lists+stable@lfdr.de>; Tue, 27 Oct 2020 18:42:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1821289AbgJ0Rl6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Oct 2020 13:41:58 -0400
Received: from mail-pg1-f195.google.com ([209.85.215.195]:39553 "EHLO
        mail-pg1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1821283AbgJ0Rl4 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 27 Oct 2020 13:41:56 -0400
Received: by mail-pg1-f195.google.com with SMTP id o7so1207257pgv.6
        for <stable@vger.kernel.org>; Tue, 27 Oct 2020 10:41:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rajagiritech-edu-in.20150623.gappssmtp.com; s=20150623;
        h=message-id:subject:from:to:cc:date:in-reply-to:references
         :user-agent:mime-version:content-transfer-encoding;
        bh=0CO1zeTWUysqgAKdJuZ6Y9RdJac7Bbof6WX21/2NFNE=;
        b=0Z28RaPwcWIO4K9FcoLxNq6dbeEZ5R2dF6DT4oTBLzSLuDuUjwpWvrpk6KSDigymXJ
         vRuqQ5FfcFXEsgSjgqtyk95NbR3R4ZM8MD0tGw/jTH6O+v2xX0xk28xtvrnUSkw+lQZe
         mgK9uE0zqyvaIDxvNv1HLkskdEsLCxYGOuf3v49thzCD6ZGH4uDzWIq92788X7CucRND
         bpUkL7byN19+6jxUAREvKcGzGcOHKLn4x9E7MHLv/1AqhYOe/LNTGAY8hO+o9MZhdHxs
         oGD8WMlw978m5WhD0Ew/X6Rdr+/AdvFzG8Q+8bGZkyv1toQQrYRwq7PWHxhLb5TaezTO
         G5Cg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:subject:from:to:cc:date:in-reply-to
         :references:user-agent:mime-version:content-transfer-encoding;
        bh=0CO1zeTWUysqgAKdJuZ6Y9RdJac7Bbof6WX21/2NFNE=;
        b=nnDQJUnBIgEYvqoD3xfuQSiJi3pXMwYO1OzVfw7y8ozgSbSHMq26Tw7tYuIm5v/0+h
         cm8n3PZLdmukgzHgx21IvbXB8WfNPWCq2qEWEd1fqJOVbbtW1JlApIWPUuEDc5290F3c
         CLOoiXA+wogPByFDCpts5zv3RRpeB9u+gmd7sTUSfsQETn9PT+bHT3GQncrPPAfc7b+h
         eeOBV9qqcc8lLhIQxtyIGAPztGhl1jTw180MCf7E+fZWkMIC4k65iyGMZ+ZoeOwR39ge
         KJGyYnbRkxeD0Aq3SKOIUN1SDhRzKqXjBC/sAZ7Dmq0Fp+CpA7O7psKoVP3cTGBajNeV
         3wMA==
X-Gm-Message-State: AOAM532YF25sXtVDi5cSiDAGDxIgXzQsTiyF0qHSr0BV5ZUZb904FGqT
        NjDHbjxEWmq2Fa7FhTGnpwLbXQ==
X-Google-Smtp-Source: ABdhPJxiufQxV0ZKD/20TC+CmwbDIPysEcCylvSAWjyRbhrQaQo4Augl/p4OlYdKIHrBuFrzuthMhw==
X-Received: by 2002:aa7:96b9:0:b029:155:6332:e1c7 with SMTP id g25-20020aa796b90000b02901556332e1c7mr3275225pfk.35.1603820515592;
        Tue, 27 Oct 2020 10:41:55 -0700 (PDT)
Received: from debian ([122.164.48.88])
        by smtp.gmail.com with ESMTPSA id b67sm2710808pfa.151.2020.10.27.10.41.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 27 Oct 2020 10:41:55 -0700 (PDT)
Message-ID: <36462d17b9db3698015b5d28474f9ee5218a9cdd.camel@rajagiritech.edu.in>
Subject: Re: [PATCH 5.9 000/757] 5.9.2-rc1 review
From:   Jeffrin Jose T <jeffrin@rajagiritech.edu.in>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, stable@vger.kernel.org
Date:   Tue, 27 Oct 2020 23:11:50 +0530
In-Reply-To: <20201027135450.497324313@linuxfoundation.org>
References: <20201027135450.497324313@linuxfoundation.org>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.4-2 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, 2020-10-27 at 14:44 +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.9.2 release.
> There are 757 patches in this series, all will be posted as a
> response
> to this one.  If anyone has any issues with these being applied,
> please
> let me know.
> 
> Responses should be made by Thu, 29 Oct 2020 13:52:54 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	
> https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.9.2-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-
> stable-rc.git linux-5.9.y
> and the diffstat can be found below.
> 
> thanks,
> 
> 

hello,

Compiled and booted  5.9.2-rc1+.
Looks like no typical regression or regressions.

Tested-by: Jeffrin Jose T <jeffrin@rajagiritech.edu.in>

-- 
software engineer
rajagiri school of engineering and technology  -  autonomous

