Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2532A23371F
	for <lists+stable@lfdr.de>; Thu, 30 Jul 2020 18:48:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729996AbgG3QsZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 30 Jul 2020 12:48:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48412 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728492AbgG3QsZ (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 30 Jul 2020 12:48:25 -0400
Received: from mail-pj1-x1043.google.com (mail-pj1-x1043.google.com [IPv6:2607:f8b0:4864:20::1043])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 25DCCC061574;
        Thu, 30 Jul 2020 09:48:25 -0700 (PDT)
Received: by mail-pj1-x1043.google.com with SMTP id t6so1216256pjr.0;
        Thu, 30 Jul 2020 09:48:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=8pqbxjS8L2yEPnu5KBBVfAuXZ06g9Py8DOMu09+tNiY=;
        b=qUrUFIWH0dTYJusmG7LwlIwq8yggXFuPc4LfzHX4yvYxtRQsIKTE9Y3+drjMazj42W
         j64mY90k3jpoK/1NmHli355+yQ3T2C3Ped9HF0GCm7p7Genh0QJu+tZ9Kr/2q+WLBBZV
         Solx/XY22NKFFFOMGfFJLhUUaY5M94u7AJ1vWGKZi4tUS2S2uT+4i8VL+tNRtdegoikP
         83H2N2W1NMGIugeOOtnAsRsqfzYwg5L1aknCLdxMruiEA+9/8GXWg/dXZrg5Zq40zMb4
         wOzq2cmgIql8yQe+42CbwMDrDk5pONPgbS54zTZm+nJ/Ej0N4Ep6S9jbNY3Ey4BRNutN
         lvEw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to:user-agent;
        bh=8pqbxjS8L2yEPnu5KBBVfAuXZ06g9Py8DOMu09+tNiY=;
        b=VIo3adQCIl7A6+mi47HIV2FuoPyB+gNqK1on6BhvKfKqPUn/murMzr49orRfGcco1c
         ZyXbVz44vdU+NjPDjCTzja0livGeufBCz3RdkRAJqiEHwEBkgaajCwZ4cH31/Ty+eDhz
         IaFitHldbpfr1F2+ZbGd8mQTGMniSNeyGdbBaFm7PkndNORX8iPwUfdGNLi7vGhVzvuy
         hKPbQZTXY2ENMGA8wdqu6wHGmiFb2csxfN7SSKp3IqRuXS1Pv9nVdOlxot3AyA5mPyPE
         p6EiX4ZjFxcJ+7RBvwOx0VZ2TAzYUjjZQb2NubSB6QJO240Kj3stT2q06Xujx4xLImNX
         lq4w==
X-Gm-Message-State: AOAM533rxJ0Lu3j6LJmP4Q3fdrA4geb0Qdif4uIlEmzYXa0bYzbnqG7O
        FtrSYnaW2VthZcwP7ACSiWyBo/R5
X-Google-Smtp-Source: ABdhPJyLlfSKJaf689h5T58XI/xyizNBGDah8rGKDuxTy6G5cXg+nyXVDaqk4j0jBhMJBi4sBgHRkQ==
X-Received: by 2002:a17:90a:2c0e:: with SMTP id m14mr4212737pjd.166.1596127704725;
        Thu, 30 Jul 2020 09:48:24 -0700 (PDT)
Received: from localhost ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id k21sm3430973pgl.0.2020.07.30.09.48.24
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Thu, 30 Jul 2020 09:48:24 -0700 (PDT)
Date:   Thu, 30 Jul 2020 09:48:23 -0700
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        stable@vger.kernel.org
Subject: Re: [PATCH 5.7 00/20] 5.7.12-rc1 review
Message-ID: <20200730164823.GF57647@roeck-us.net>
References: <20200730074420.533211699@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200730074420.533211699@linuxfoundation.org>
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Jul 30, 2020 at 10:03:50AM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.7.12 release.
> There are 20 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sat, 01 Aug 2020 07:44:05 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 155 pass: 155 fail: 0
Qemu test results:
	total: 431 pass: 431 fail: 0

Guenter
