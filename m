Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EEA0A40FEE3
	for <lists+stable@lfdr.de>; Fri, 17 Sep 2021 19:59:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235676AbhIQSAj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 17 Sep 2021 14:00:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57050 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230115AbhIQSAj (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 17 Sep 2021 14:00:39 -0400
Received: from mail-ot1-x331.google.com (mail-ot1-x331.google.com [IPv6:2607:f8b0:4864:20::331])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 09BF6C061574;
        Fri, 17 Sep 2021 10:59:17 -0700 (PDT)
Received: by mail-ot1-x331.google.com with SMTP id m7-20020a9d4c87000000b0051875f56b95so13950993otf.6;
        Fri, 17 Sep 2021 10:59:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=9Nfu0gbip5e6WVmv1l1WxSZAVtcTUmR8uPodN2uEEMk=;
        b=iu7A9Ppt3Uhw3EfBXr/CQp7xr5kAKSpp+OPso8B55jGg+4GWW2QDJ0F9Ft3CvFa0uX
         byrNt5iBdPJykIHoBmZWsWgA3hvuEVOhBO+oLqsxlsebwvNM8mHfM5PAEN1t97+9HFyH
         SLm+vmiLhsiNCHfLUsjRzLkPBJn0SHSZSAbaCQZVdbhS8JeR0gbVnW0Bcr2m4wNc2rT1
         EQ/n8TKxrLFkhY4vAwW5LsaSyLjBwdcspr4oY2Z7ipp/sHyCrWaA5KtWBRxsEORc7AhS
         CFBRQnLSSeivsnEA86vjILojgyoHswdhz3+faA6UElgU6V6ikCqzWq2vG/ciU65b9dJB
         MRSg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to;
        bh=9Nfu0gbip5e6WVmv1l1WxSZAVtcTUmR8uPodN2uEEMk=;
        b=nqZqU1ajpu+UyaD1iX2v1DRRa/O6A9jDzJJ3WUi6VXNxaQpUTNiUxNlm16RA7aaHp8
         q6LGXzeygdP4iIAXtwcXIasAw3Vg/hJmsAUShj7XiYgAxvVRAQK/P2nIoxDnGJYm9GMi
         DGIG6TdR8eN76Rr6sE4GG1R6n0Wkn+xWihCBZSlyVL07z7mS3g1JfSqO8omidUCGlyPR
         Na3QZ9HtZvrVxno7FBpobedLURVjsPh1hmhcUyrVgNq23So3McrOP5+fXbBALk3ths1b
         83S5YMSecSm/z/h1uvqzB944fKTLmT2uOuaE8V1jflrVUMnAub01wO+M/ZOCO5Bdridt
         lOeA==
X-Gm-Message-State: AOAM532R+lNndgoFjezTaXJCubfTGbu49ju1acoqAtq49jJW5SOXiegs
        g34uZ1BBGFUBjwtm2Pdj0r4sndFGZnc=
X-Google-Smtp-Source: ABdhPJz5KD6puluYqGI6tvGbJgE5d2+WTnpYlKrzP1w0qJRtyi9nHOiY19hvFc7Zmyna8bnfbxG7Pg==
X-Received: by 2002:a9d:7416:: with SMTP id n22mr10922011otk.309.1631901556285;
        Fri, 17 Sep 2021 10:59:16 -0700 (PDT)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id v7sm1688891otq.74.2021.09.17.10.59.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 17 Sep 2021 10:59:15 -0700 (PDT)
Sender: Guenter Roeck <groeck7@gmail.com>
Date:   Fri, 17 Sep 2021 10:59:14 -0700
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, stable@vger.kernel.org
Subject: Re: [PATCH 5.10 000/306] 5.10.67-rc1 review
Message-ID: <20210917175914.GA4056493@roeck-us.net>
References: <20210916155753.903069397@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210916155753.903069397@linuxfoundation.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Sep 16, 2021 at 05:55:45PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.10.67 release.
> There are 306 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sat, 18 Sep 2021 15:57:06 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 159 pass: 159 fail: 0
Qemu test results:
	total: 472 pass: 472 fail: 0

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter
