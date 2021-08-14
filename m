Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4CD843EC45E
	for <lists+stable@lfdr.de>; Sat, 14 Aug 2021 20:15:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229751AbhHNSPb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 14 Aug 2021 14:15:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41832 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238892AbhHNSP3 (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 14 Aug 2021 14:15:29 -0400
Received: from mail-ot1-x32f.google.com (mail-ot1-x32f.google.com [IPv6:2607:f8b0:4864:20::32f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 09445C061764;
        Sat, 14 Aug 2021 11:15:01 -0700 (PDT)
Received: by mail-ot1-x32f.google.com with SMTP id u13-20020a9d4d8d0000b02905177c9e0a4aso5457528otk.3;
        Sat, 14 Aug 2021 11:15:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=p80w+kYx9s0KuK7Y3YoAqeOi9i6ZYz+JxuHcK6VAQvA=;
        b=s+Aym6WfyRC4+jGhO5yu3qkrSU+gKsPSRsTBZS5RfW+PCoLM9YNoYQvISTEpWtQbVc
         08ByC3OUu74QBc3PbiZ4lH41IBs8M+bgznIUriHrq8PqNbAlfw6QIc9i3ctbP+B/ZcZo
         rUQd0Lm/RDbyiBEX3D39iog1VDCZFPFGQDTb8TQYpg6HJUwYBkWBeDejl0X3jn7nN92v
         KJ4lgBPYDYUAvD+iBQQG5BEed+MHACSe9T6v8bh5HffmB3cBzxDhFslCek1pUQS91t+M
         HOqLueHrVDP8slwrDPUitKXSGjNSumctXghE6MqAjqSI8Ak2mbicnFb3UAGmq4GwanQ3
         x1WA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to;
        bh=p80w+kYx9s0KuK7Y3YoAqeOi9i6ZYz+JxuHcK6VAQvA=;
        b=YI91up9/hhFAa3/ahLTYUif6I6tS1iG2vOzB5Te6lk0pQhkf6P/XNkDceXMGXgmw1D
         Vboew6ZUNzepE+JMwGWZfkdXZKA0aMPdopFyj1dDarfgZb1EPcWLLlVKv3v8h3TjM+AF
         +FD5UYluaqpG1G0Nw4dQfwhBZLwANK27p3sKKlAmRnkc0AtrnYv9Psgtaukv9OoA/r94
         4AncDlVWXuRzp7GcMeTsvipgfhirWMvMtY8MyaP40nsl2fKEbuzBEh23lIMyvizK7IcT
         5A5ztrjERwvZBg7+zyaUPo5vi4rYgM3HAXS3dA9mbhPZsb3UUuGDg7CbA4GCmajE3YLo
         b8iA==
X-Gm-Message-State: AOAM532VDrYn6ZQCA7r/9pxZT0Ca5xRVM8G4sT7BBWnPjAC6+TaFgY0b
        pqitkDV4emKf3EO4RfVrdQ9FehdZPso=
X-Google-Smtp-Source: ABdhPJwlx2pwIRqr/fLYMy0CBjk6WYtE22GhXtOCf7ey4gb0Fh9bnFUmAcUd1V1aatxGrt3vbPVIYg==
X-Received: by 2002:a9d:491c:: with SMTP id e28mr6655745otf.342.1628964900454;
        Sat, 14 Aug 2021 11:15:00 -0700 (PDT)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id s184sm1079824oif.20.2021.08.14.11.14.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 14 Aug 2021 11:15:00 -0700 (PDT)
Sender: Guenter Roeck <groeck7@gmail.com>
Date:   Sat, 14 Aug 2021 11:14:58 -0700
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, stable@vger.kernel.org
Subject: Re: [PATCH 4.14 00/42] 4.14.244-rc1 review
Message-ID: <20210814181458.GB2785521@roeck-us.net>
References: <20210813150525.098817398@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210813150525.098817398@linuxfoundation.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Aug 13, 2021 at 05:06:26PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.14.244 release.
> There are 42 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sun, 15 Aug 2021 15:05:12 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 168 pass: 168 fail: 0
Qemu test results:
	total: 421 pass: 421 fail: 0

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter
