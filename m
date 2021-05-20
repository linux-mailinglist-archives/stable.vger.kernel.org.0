Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3730538B9CD
	for <lists+stable@lfdr.de>; Fri, 21 May 2021 00:54:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232442AbhETWzc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 20 May 2021 18:55:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57336 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232354AbhETWzc (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 20 May 2021 18:55:32 -0400
Received: from mail-ot1-x336.google.com (mail-ot1-x336.google.com [IPv6:2607:f8b0:4864:20::336])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CD590C061574;
        Thu, 20 May 2021 15:54:10 -0700 (PDT)
Received: by mail-ot1-x336.google.com with SMTP id n32-20020a9d1ea30000b02902a53d6ad4bdso16355562otn.3;
        Thu, 20 May 2021 15:54:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=sV/6Dp7bJ79dTx05SROX8BqVb/4hvZ5AVWo82WhJrTU=;
        b=jmyM+zxu4qGke06k8dKZWeMUJAGw4u0LpV5QMH4nsvkFm8goV+/TMOdm/sx1zxoGsY
         AOZlhVoyvR+eeuhZNfWrf4+9pDjCbfwar63kO9zLdLfVa/X6s9ccTlu3YTs7BmtLP8dz
         nlH8biKaWjqkrFaguQg8CZPY/SOmqHLPfcy8i8yZpZz1fJ7l6jETAQnbVD4UKczc7LKL
         BLPdhXeHleaUIOwtovVaz3HAGvgM0LDa8CaR4reGTj3krfxme/BbLNjNx8YMaFmZIFmE
         o8pTmPatSmfoGVnID41VjBjMfuHC9WejhWwrxYw5iI2gCRN+tuV1e0dlSIao9tAhVa6i
         7YtA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to;
        bh=sV/6Dp7bJ79dTx05SROX8BqVb/4hvZ5AVWo82WhJrTU=;
        b=sd7tXEjf+DzaDUZSg0TM3WRq9EEhjbEzQw3rT+w2NMo1VGiDx8vFmXuHEzZpLWA7CD
         W3srbfBx0TrNbxxw1vDlBvWhitiE3qlVdt3R8tIN1sJqOYscOkXUppCqKMcd0dSivqed
         Kqhd/aIKWY2T48wEyPn/zLTiasWhDomXV/HNDHFdSIaFZq8vGPRYDjkP4eYNcstJlyeP
         Eys5t8uzuE4JrCqh5e0y03aG2yim+fpdaTpOHLNoYPHS4rmz5eECM4r+cA66KJ7bc8zl
         Kl6IyZPNMTig6/yH7i3QGH+H5lxEvnuhzlY9JUen4Eu22Kbura7EtMzuo8YjAoErbA6s
         gjZg==
X-Gm-Message-State: AOAM5311W49/wxOpg26bHScDOq4XlJ7ToOpXI5dHTWv8U+5pjEziC1jh
        uTc578z3scYvdDgkU6EWSew=
X-Google-Smtp-Source: ABdhPJzYPa/XMzkp6WSbRF5X5ER8aKKeNcmIgTRtz5UDhLd5BGKGCduWZAJSDi6fpIIeUHlihapcog==
X-Received: by 2002:a9d:17d0:: with SMTP id j74mr5619231otj.92.1621551250234;
        Thu, 20 May 2021 15:54:10 -0700 (PDT)
Received: from localhost ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id c18sm950665otm.1.2021.05.20.15.54.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 20 May 2021 15:54:09 -0700 (PDT)
Sender: Guenter Roeck <groeck7@gmail.com>
Date:   Thu, 20 May 2021 15:54:08 -0700
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, stable@vger.kernel.org
Subject: Re: [PATCH 5.10 00/45] 5.10.39-rc2 review
Message-ID: <20210520225408.GE2968078@roeck-us.net>
References: <20210520152240.517446848@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210520152240.517446848@linuxfoundation.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, May 20, 2021 at 05:23:18PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.10.39 release.
> There are 45 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sat, 22 May 2021 15:22:29 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 156 pass: 156 fail: 0
Qemu test results:
	total: 455 pass: 455 fail: 0

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter
