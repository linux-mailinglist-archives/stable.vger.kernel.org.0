Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 66D6443BA7B
	for <lists+stable@lfdr.de>; Tue, 26 Oct 2021 21:15:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236836AbhJZTSH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 26 Oct 2021 15:18:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37468 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230495AbhJZTSG (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 26 Oct 2021 15:18:06 -0400
Received: from mail-oi1-x22b.google.com (mail-oi1-x22b.google.com [IPv6:2607:f8b0:4864:20::22b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 82C45C061570;
        Tue, 26 Oct 2021 12:15:42 -0700 (PDT)
Received: by mail-oi1-x22b.google.com with SMTP id z126so34538oiz.12;
        Tue, 26 Oct 2021 12:15:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=oSfV9PemNVN/8PlGxcQ+fzRoYFkBesnzrhI9utX1w6k=;
        b=QUJn87jnEU3ZtTATd/MgYayn/bwdUsw8VEtZGB8mOKoy6AgT+RNYifqhKM6GgEzWY7
         g+aN5B1cl+TeXdDufYXDCDgV+Z3KoAIlu5b0T40vQr7yCj2xYc+4uuTaX20dbTDvAUDO
         Vqq/E08WufBDff4NdPpUvWEyGN3JuGx8B5ciTg0utmNE9vdEFf54+76Gmaei56QoDxn4
         vEDbPImaJnAc9CtFGSbPs0wNhtJvLfccUH+CqHtnTQrGZgQ7bSZFTSgYG80y47cEKCJ9
         uDCN4YcEDEDxLSG8a5ZZv91k9JmrHId1UbEr7VrtPybfjbF0cdsbHmcRZiIdDR4H17m2
         ZYdg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to;
        bh=oSfV9PemNVN/8PlGxcQ+fzRoYFkBesnzrhI9utX1w6k=;
        b=dGmpTmWQSttO4BQuWtf+awjL//U63jvE+JSNfDzwbCYwvjbqCugeiaNmAth9ac2eNg
         REo5hU5ReoT/FYAmNEZcxh0ufdxR07SwSMaygjSRIh+tBBq11KwqXgOQCOzypbRcOlvT
         j+iYoXjZqva5QbKG5Z1sZcK5P2KsVzVcKDUc4P37jUFeXbXN7WbnDV43jve/edbScPk1
         H042/XRdY5gpXu7MuSlQKXa8kZBt+l9SbnsLwMUQAqj4Hj3Vgj8mUaaXybqsew4TvwRJ
         zLt+E5Bfs8q5HUa+Jc85242/tTqWscalTdbYrzSFqw1i/y+U+br4GxGRI9mT/b2TJR7H
         HUrw==
X-Gm-Message-State: AOAM5335fGjVNGY3gSD2WAXOaIBPFKYxIP+sU7aAPgLamTqN5IQS1b1F
        yJDAglAtJMotyWZTuAArq8s=
X-Google-Smtp-Source: ABdhPJzT/U9qdpaxI3JSzRdFkvylaXWsf3C66VQr7dS28529zX1UDd0ywF+gvpT5OVAiFC6hTJxjuw==
X-Received: by 2002:a54:4401:: with SMTP id k1mr453824oiw.25.1635275741989;
        Tue, 26 Oct 2021 12:15:41 -0700 (PDT)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id o42sm4150059ooi.9.2021.10.26.12.15.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 26 Oct 2021 12:15:41 -0700 (PDT)
Sender: Guenter Roeck <groeck7@gmail.com>
Date:   Tue, 26 Oct 2021 12:15:40 -0700
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, stable@vger.kernel.org
Subject: Re: [PATCH 4.19 00/37] 4.19.214-rc1 review
Message-ID: <20211026191540.GC2014125@roeck-us.net>
References: <20211025190926.680827862@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211025190926.680827862@linuxfoundation.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Oct 25, 2021 at 09:14:25PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.19.214 release.
> There are 37 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 27 Oct 2021 19:07:44 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 155 pass: 155 fail: 0
Qemu test results:
	total: 439 pass: 439 fail: 0

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter
