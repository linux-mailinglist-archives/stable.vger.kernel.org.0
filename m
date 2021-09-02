Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AB4B03FF5D9
	for <lists+stable@lfdr.de>; Thu,  2 Sep 2021 23:51:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347571AbhIBVv6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 2 Sep 2021 17:51:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38838 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347572AbhIBVv6 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 2 Sep 2021 17:51:58 -0400
Received: from mail-oi1-x22b.google.com (mail-oi1-x22b.google.com [IPv6:2607:f8b0:4864:20::22b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 50B97C061757;
        Thu,  2 Sep 2021 14:50:59 -0700 (PDT)
Received: by mail-oi1-x22b.google.com with SMTP id s20so4454839oiw.3;
        Thu, 02 Sep 2021 14:50:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=2FrG0pPucLE0EBD28xcSLSg/8S2LW0HcIqoJvqo/B1M=;
        b=Qkprh/kaA+yw+/zx93Tz62aEkUmDruvzyk+AzIALwukysSyCQx6rDo9gyVhfaO8310
         TN6BwkbmGXJpnnb2TtXO9MrG8uafeIIzb3szxjz0BkoDCDZvwTVlRz4GLSjplNlT4mFa
         mXgmqyGkd1RWBIxUjsDyKtGtPbTNY4VcvIKKfowezbPDVDFvnAeIykLTzmVkd/qUf6OO
         1dWb2R01jRDHpu0r8XcbYKH89IzkFPOddNXYof1hD5KRBlxR+p1B9b0qBK/c++3MfzAE
         NL2vn53dHV1V8gJasjQ1NkWG/4/iIBeApoFf4icwGU66L9On/IXD7kSkQTuIb9ziMeI+
         Ly/g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to;
        bh=2FrG0pPucLE0EBD28xcSLSg/8S2LW0HcIqoJvqo/B1M=;
        b=Doi61wyXxniT8sGJfiGbAg1AGHKLPmHUozeWGuth+CqS2ewl9TXABaaHZ44fvc5f/l
         J9fdpLyCPya750DoCOwNGapWsfxieHpYkZhn60arhCUhUkkgtCWZdx3NgHIyaPeWGspq
         UfKWVbOI1EYPkStmYpdiVJmQ6n7Xkr2tUoyAHF1cT1XjDmthugZk3eCD4oEi1Ue8j2El
         z5xPjllIG9iazgKcuZ5NJ5xI4hU4yPPFWc0IP/O6Jm511I9ZlrgBUJoXpLMhMinYyB9P
         xHxx8rVT27wHmx6Vu9RA8nfGrrPhzbVzeF58Nfk0TW6iJMSfuch5wgypMAwm/QWY/BqT
         2YWQ==
X-Gm-Message-State: AOAM531+dcdJdEGDHSevHTO7HnZYXL3EBE/OlqJjP422gxe7l93T2Gvo
        FVBrACO+KHRVZszUESzKZz0=
X-Google-Smtp-Source: ABdhPJyfiOumTyaYQseplyB/QfD80zfMH18p2L4kNaxm4id8xJWGXlW/+k1vH+RvtGviXrOhhb4oBw==
X-Received: by 2002:a54:4197:: with SMTP id 23mr3778642oiy.122.1630619458800;
        Thu, 02 Sep 2021 14:50:58 -0700 (PDT)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id w15sm638582oiw.19.2021.09.02.14.50.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 02 Sep 2021 14:50:58 -0700 (PDT)
Sender: Guenter Roeck <groeck7@gmail.com>
Date:   Thu, 2 Sep 2021 14:50:57 -0700
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, stable@vger.kernel.org
Subject: Re: [PATCH 5.4 00/48] 5.4.144-rc1 review
Message-ID: <20210902215057.GE4158230@roeck-us.net>
References: <20210901122253.388326997@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210901122253.388326997@linuxfoundation.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Sep 01, 2021 at 02:27:50PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.4.144 release.
> There are 48 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 03 Sep 2021 12:22:41 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 157 pass: 157 fail: 0
Qemu test results:
	total: 443 pass: 443 fail: 0

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter
