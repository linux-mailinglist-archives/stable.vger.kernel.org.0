Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8B63931D3AF
	for <lists+stable@lfdr.de>; Wed, 17 Feb 2021 02:15:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230029AbhBQBNE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 16 Feb 2021 20:13:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48222 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231563AbhBQBMs (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 16 Feb 2021 20:12:48 -0500
Received: from mail-io1-xd36.google.com (mail-io1-xd36.google.com [IPv6:2607:f8b0:4864:20::d36])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B5596C061574;
        Tue, 16 Feb 2021 17:12:07 -0800 (PST)
Received: by mail-io1-xd36.google.com with SMTP id u20so12148068iot.9;
        Tue, 16 Feb 2021 17:12:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=d8UdNd3nDtWSlDpG1wDbaA501Q1kxHTdjGnzgmdnFU4=;
        b=Fdhaz04OOefejFr2lbTRdQg335nqILkUJzIIUPPiA83i/0P6SPcbGCrMrC+Oek2xcm
         JfQFMbvchcAqOnqDkMGwDfBHZ2IPNGV4VwefgF4K/dA12J9kyKKocgKlUsvj9+k3QA8S
         T5vOu5Fil9KsmdMuLktFymRaSMFhwBnggCCt5oje05zab7BThYz1LwG/ZmDWvFzND+f5
         uvZS0H4MpZwNRcGHTiIHqextJ31geZuVBvUE9JZ+BTKDxTjeLBYGH3qST3WIOr7rK8HS
         zniRZiJofUdIHKrmEpdZj+8i2cMPlTqSe7qKg/QoW/mS7/cwmB71HnyhMrvc1GCEDzgm
         Co7w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=d8UdNd3nDtWSlDpG1wDbaA501Q1kxHTdjGnzgmdnFU4=;
        b=ueNLUFtNtfkJNa3buICshyeJM9+QrPN0GVcs8R3CKNlQjLh+ccsplKJVLcYDcMzpGR
         AKnr7WfwyFf0d2psuCQbKuhrPSSOFizN/j3coWu/JTvSM64GM0ZQvw27IgACsungKkkd
         gyJ7pvwF2Fgl0p/22EpF8BVPwn86oVQiPBrzIhQc40+pQomHmxuBqK3GTmD3cb7tBO4s
         Kvf0FtzuuYJZm3apJ8Bi1+fYS6AbwG0WRUM9e1P29SOrJO/GOOdTPpbcx2hBIzBg0yTM
         FyHdAW3SHXRQyLIeEXozKxOn6lLPfTSNey6of3/+QlHI+9L9IOolt4tBybXGcOcSAJ3e
         2+2Q==
X-Gm-Message-State: AOAM531M/Pi6lDqQ1tzbO+wChjqqbQR4CedKT+zaGTfjboBTtkU3YuU8
        4NCva29sYffgphemsvAu4GeoniOZLzAYvQ==
X-Google-Smtp-Source: ABdhPJwj3iChKvtm3mmis/xlHPDt4fd5KX5rXWCiNpJ42W8cBEVPqzFUOJ1vMpCX1mE6Fvyv6VpMAg==
X-Received: by 2002:a5d:9641:: with SMTP id d1mr18579198ios.123.1613524327215;
        Tue, 16 Feb 2021 17:12:07 -0800 (PST)
Received: from book ([2601:445:8200:6c90::4121])
        by smtp.gmail.com with ESMTPSA id n7sm154245ili.79.2021.02.16.17.12.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 16 Feb 2021 17:12:06 -0800 (PST)
Date:   Tue, 16 Feb 2021 19:12:04 -0600
From:   Ross Schmidt <ross.schm.dev@gmail.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, stable@vger.kernel.org
Subject: Re: [PATCH 5.4 00/60] 5.4.99-rc1 review
Message-ID: <20210217011204.GA4678@book>
References: <20210215152715.401453874@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210215152715.401453874@linuxfoundation.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Feb 15, 2021 at 04:26:48PM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.4.99 release.
> There are 60 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>

Compiled and booted with no regressions on x86_64.

Tested-by: Ross Schmidt <ross.schm.dev@gmail.com>


thanks,

Ross
