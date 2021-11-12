Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E639344DF73
	for <lists+stable@lfdr.de>; Fri, 12 Nov 2021 01:58:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234638AbhKLBBW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 11 Nov 2021 20:01:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57500 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234652AbhKLBBV (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 11 Nov 2021 20:01:21 -0500
Received: from mail-oi1-x231.google.com (mail-oi1-x231.google.com [IPv6:2607:f8b0:4864:20::231])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BA389C061767;
        Thu, 11 Nov 2021 16:58:29 -0800 (PST)
Received: by mail-oi1-x231.google.com with SMTP id r26so14861204oiw.5;
        Thu, 11 Nov 2021 16:58:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=mQamr4Qqy75nSLDM5mNB+Wu3nw5ZcbzTj0+gLqwDWsY=;
        b=SJSiBIKJEDzx81AC4Y7nHNfhtnhzDnKy2+cIPC/2VBP1rynqljaZZhfVvdOJ2XkzFS
         akKNT//CYt9tqMhkGUIxbdfUO0eaQTfVmMqDdsi4qezJEHWlDTqafNkQL+emxX71hprz
         STm72h87015/5hkfFmcLtfAoQdDXaK6JXgJ1GjBRAd9gttV7utHmdCEv4CxAdRNMmH9D
         mZFn1B57CJ8en+z83sitMHwXfS+XaUQJ581fshd8Ov5q7fpeZgk6fyP+4bV/PabyTVIs
         eXOqP+J1sDJxmBZL3/+lXhD9wJmy1lpRZfqTWVuhbf/+RIEAgbORoUtE2/aLqLb9jiB7
         ASaQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to;
        bh=mQamr4Qqy75nSLDM5mNB+Wu3nw5ZcbzTj0+gLqwDWsY=;
        b=OlvycrX2e6LCCRsv9L3UESWgGyX0zgO3E3uJqO5KZhM0ob31zDLSHpVYNk/6+Qe0XR
         xSvZnMIJ8Mpwz/Xpu4/DYN8pfgss7qHpJvtx9thRNjKwa0rrKgnkED6PxhIn7XnsoC8z
         zE7SbKgwBHkSuXdM2ETWQVJtUh9V4ARoSXgCSvvYK4nTw6PA5XtU4AxyqpQg6pFD1DNq
         tlwm7IIdmJO243h4AuJ4m14N9FqUv6iOTz6C7uAVg4y69HTLSNvOn+lJcE+dHwYUHhrc
         sD57Y9HYdrd7lmKnqIna8aLIy78xVEhhZH2T3gycd2Bf67jzmbrJG92bcQkQFC3cn0fO
         XpCA==
X-Gm-Message-State: AOAM533yLxri7uaJf7MUBf/sCBhe2P5NDdZldtP40mLoaoATHCw5JDHk
        YzRSLDjbhTNiHL7pZ+m1KKQ=
X-Google-Smtp-Source: ABdhPJyKKPWliHevZ3crOKFkFcnzbTnnkobmTWPbj2YNuCEK3tsl6MICBHsOQ4KbahhoWVzjYI8ijg==
X-Received: by 2002:aca:a941:: with SMTP id s62mr9675388oie.87.1636678709184;
        Thu, 11 Nov 2021 16:58:29 -0800 (PST)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id ay42sm1135211oib.22.2021.11.11.16.58.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 11 Nov 2021 16:58:28 -0800 (PST)
Sender: Guenter Roeck <groeck7@gmail.com>
Date:   Thu, 11 Nov 2021 16:58:27 -0800
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, stable@vger.kernel.org
Subject: Re: [PATCH 4.14 00/22] 4.14.255-rc1 review
Message-ID: <20211112005827.GC2453414@roeck-us.net>
References: <20211110182002.666244094@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211110182002.666244094@linuxfoundation.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Nov 10, 2021 at 07:43:20PM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.14.255 release.
> There are 22 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 12 Nov 2021 18:19:54 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 168 pass: 168 fail: 0
Qemu test results:
	total: 423 pass: 423 fail: 0

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter
