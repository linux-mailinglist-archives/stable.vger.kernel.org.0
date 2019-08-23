Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BC7039B200
	for <lists+stable@lfdr.de>; Fri, 23 Aug 2019 16:30:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2393831AbfHWO3l (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 23 Aug 2019 10:29:41 -0400
Received: from mail-pf1-f196.google.com ([209.85.210.196]:44962 "EHLO
        mail-pf1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2390586AbfHWO3k (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 23 Aug 2019 10:29:40 -0400
Received: by mail-pf1-f196.google.com with SMTP id c81so6559744pfc.11;
        Fri, 23 Aug 2019 07:29:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=6jaVskNErW3LY0WFDOmWXPyAuGD4ddrw6oahAqMg7m0=;
        b=c1zuBrWR3SNem1/xZ+/uIoNgFklIKkjvs9CFO2OVgDAHTO6b7+HydzGvuubeO+xMGV
         2+N8mApqFpK+vxbX2Db95PRLX2l6DBPEKyzUW4eUWv/wfvy2qlTz6Z4jq2bdGrBze0t+
         IJjsFEpv+dCrARaOqeyrcRyNVAAE7NRjQovdLqJ2pWbQUvjZ6uCJNZMUQ1BS8WSas3I4
         /ZdDtyAtQyMNTLhuGJgGlOmNJvpQiemJFUMUv7FNO7UNRvFfUqOU4arb5+TsBsDFHnZS
         PQ+Epz5XMVabrh8HR9xDN2dC2/RfbBzHO1ZXLm8x/DIVgjgGpzz09RL8UK/cFPI6wbSO
         KC1A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:subject:to:cc:references:from:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=6jaVskNErW3LY0WFDOmWXPyAuGD4ddrw6oahAqMg7m0=;
        b=hTYZ5AWAnyFLlJscxBcQgMEgSty6BHSSK6Z9s9q3xRkfcGUzAU3EGN6ylImmd2HtpP
         bgfB1TkKfRmiKuwqwWjn46Vz/QL8rqU9AU08T5WcTl0GmUVnkR/1RJERxb8cXlHgcyRQ
         +wfCOswswE85LwhsnZ2SOCqHqRYyVDi9w1OM9bO5Jdj2OWo7bA8Aqdorc/HSMAORpLWX
         lgGHe8/yFDmCWOZmV/b6YJ2qv9fzcqi28xsnCE8uzFMPnnigSKwwfIR27BO8cGzz2ISX
         dNnSHd7Puiq9E6mgaI+VhV0OyhtonHL4OXwDW6JyfhVUi+zWMFows957vxQArUC2e/4z
         kXlw==
X-Gm-Message-State: APjAAAWauWy9NUhPTg/tPodw6WycOdndY1FO1+oLD3gTCi5AOS9oQRK9
        9RYQHigngEQltYiOlOTr+HxS4sJ7
X-Google-Smtp-Source: APXvYqx76qtBpWtHrhNIgLOnEYkNdnrOyFKNbQBd6Mb81PcPczxIQ+WSI1eOzGTCv5PU1ZyAdF9lYQ==
X-Received: by 2002:aa7:8193:: with SMTP id g19mr5513945pfi.16.1566570580192;
        Fri, 23 Aug 2019 07:29:40 -0700 (PDT)
Received: from server.roeck-us.net (108-223-40-66.lightspeed.sntcca.sbcglobal.net. [108.223.40.66])
        by smtp.gmail.com with ESMTPSA id p10sm2542672pjr.14.2019.08.23.07.29.38
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 23 Aug 2019 07:29:39 -0700 (PDT)
Subject: Re: [PATCH 5.2 000/135] 5.2.10-stable review
To:     Sasha Levin <sashal@kernel.org>, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
Cc:     torvalds@linux-foundation.org, akpm@linux-foundation.org,
        shuah@kernel.org, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org
References: <20190822170811.13303-1-sashal@kernel.org>
From:   Guenter Roeck <linux@roeck-us.net>
Message-ID: <b3ad905c-62c9-85c5-13b9-6dda48a8624e@roeck-us.net>
Date:   Fri, 23 Aug 2019 07:29:38 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20190822170811.13303-1-sashal@kernel.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 8/22/19 10:05 AM, Sasha Levin wrote:
> 
> This is the start of the stable review cycle for the 5.2.10 release.
> There are 135 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sat 24 Aug 2019 05:07:10 PM UTC.
> Anything received after that time might be too late.
> 

Build results:
	total: 159 pass: 159 fail: 0
Qemu test results:
	total: 390 pass: 390 fail: 0

Guenter
