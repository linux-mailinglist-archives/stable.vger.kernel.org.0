Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 086E64A2B31
	for <lists+stable@lfdr.de>; Sat, 29 Jan 2022 03:05:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352162AbiA2CE4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 28 Jan 2022 21:04:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59868 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352154AbiA2CEs (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 28 Jan 2022 21:04:48 -0500
Received: from mail-oi1-x231.google.com (mail-oi1-x231.google.com [IPv6:2607:f8b0:4864:20::231])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EF947C061747;
        Fri, 28 Jan 2022 18:04:47 -0800 (PST)
Received: by mail-oi1-x231.google.com with SMTP id q186so15796905oih.8;
        Fri, 28 Jan 2022 18:04:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=0HHFLAt37bQ+Ld7bLyKXZLTob9ybfeckmNEDmuL1v7g=;
        b=MCbAKVhsHdaBx0CY7+a1FHUozV9IDSNnaStIst6q3qZEC56tPt0SB/EtEyNwwUJhXU
         aC+FkCWw9FxxvRIRr3H8qJPmiSFucYbvWlTz8rwaOVcqM/DxUtHXFzIKHyG8yyJq6Z89
         NbfTFpdLMwK1h0MGxTWtg4tpzQpWymMyZJzGiOsWq2Db8h1BMftHLn1kb9aiy/ldii6Q
         2jra0zskOYFm9575A0jIETurpMdvHUAZXHhODwcLE6KAQVGDfE022C9xZTKPkfIScwSb
         epN2juVAOYwEYTkaMttdFWUT0Ls9uVeCpvhmzEDKtV05/ZqRhsuVzyS0ytGqlQ8Su8HR
         otdQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to;
        bh=0HHFLAt37bQ+Ld7bLyKXZLTob9ybfeckmNEDmuL1v7g=;
        b=xMISnza4NLmfXBqxuPMFbr5HSLEbr12k6fyD8I4+PEbif6WWoAzBjm1gccmHBuBOJE
         TbeSUP+Vs2jRheFxOvNTXwpJUKzU24aLPUYsXJJY9EIDRbyTtUSXJbsNyCpSz/wQkEEs
         /pjkavC1FgIpjdXzK1dVPZOFemNW5KdsrzTMSpYF040XKFzTdDlMHGQVpWItqZjOKs9L
         EGVAIZXTzX12AaqB2RVF0F8FrjdSpaYm1bCnPUV0KWUpQLlldsmpDvX5jcuHTcyCv1hK
         qViSxNd8JLI+NqT2rmXJ7wer+ss3yfZUkFJQb1B5kduX7wQngFPY/PsOL3I33H0OVJQ7
         CKpg==
X-Gm-Message-State: AOAM531y/GdlTrA5PtKIdormPD1KBGTntr7n2GGhfYE4TkT+uGx5ORvL
        xHXH4EEgLiY3ivU0/0vQn/M=
X-Google-Smtp-Source: ABdhPJzT9KnvwZ2sBE8cNRIHlpO+VTJuKWvDO9Wv8b2oJ3tvyaCPW8UUJx/eE+Sz+SGH2tOi8e+xrA==
X-Received: by 2002:aca:1001:: with SMTP id 1mr7166468oiq.82.1643421887276;
        Fri, 28 Jan 2022 18:04:47 -0800 (PST)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id v31sm5885754ott.25.2022.01.28.18.04.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 28 Jan 2022 18:04:45 -0800 (PST)
Sender: Guenter Roeck <groeck7@gmail.com>
Date:   Fri, 28 Jan 2022 18:04:44 -0800
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com
Subject: Re: [PATCH 5.16 0/9] 5.16.4-rc1 review
Message-ID: <20220129020444.GA961158@roeck-us.net>
References: <20220127180258.892788582@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220127180258.892788582@linuxfoundation.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Jan 27, 2022 at 07:09:35PM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.16.4 release.
> There are 9 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sat, 29 Jan 2022 18:02:51 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 153 pass: 153 fail: 0
Qemu test results:
	total: 488 pass: 488 fail: 0

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter
