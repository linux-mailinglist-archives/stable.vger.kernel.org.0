Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1CB763A1D21
	for <lists+stable@lfdr.de>; Wed,  9 Jun 2021 20:50:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229535AbhFISv6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 9 Jun 2021 14:51:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40272 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229914AbhFISv5 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 9 Jun 2021 14:51:57 -0400
Received: from mail-ot1-x331.google.com (mail-ot1-x331.google.com [IPv6:2607:f8b0:4864:20::331])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A84EEC06175F;
        Wed,  9 Jun 2021 11:49:45 -0700 (PDT)
Received: by mail-ot1-x331.google.com with SMTP id 6-20020a9d07860000b02903e83bf8f8fcso11922584oto.12;
        Wed, 09 Jun 2021 11:49:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=L70pHOFCZ0D53sBhtt+VdCV9jroznKR2TL/zSvh6ExM=;
        b=Ja7uoDAH9noYPSbDaqQqVqh9SpKTYUxY4IKqKpzaLRyxtG+Hd0OeU1t85SByJDL4Rm
         rlWqMyZJ0fEpljO625Y6cL6poVlXel9MsvM88LSrF1Wk37pbk9g84mM+7j8HuI/68Qyu
         Nmb7UcLBjKb54qt7INnQIzLQBnA+zNWmIvEP21STb0cYgaml+91fEH1wfAsb1bxjOp+1
         5om8lWwryjHs5nmMsZlTSVVHoIVgN4imlpxb9iMchr+BvDnHoCS+W6cefqQh7+Wdol0I
         boz3meg1Eh5QhQac8KVNWZB27fj9gJsguCfF53hVOqssSsC1I7D+pHhbdLiT/7wOkXTn
         uFmA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to;
        bh=L70pHOFCZ0D53sBhtt+VdCV9jroznKR2TL/zSvh6ExM=;
        b=Bn9iiQwIMay+468rkzCtJq21Ybfs8nDfbaea5Y2YYbgY7Wr2pbxbB5zCtMG/RxaTjk
         H9qZq8tfCYNQQ+Iq/v6wVEHhmcMP7P16k/Q9wCEF7uLNG0cKVCPMP+65Ud7m6SaHGt/j
         iuySa6+yL1DzSzG64Hi43WBlKRHKbABn4fCFR99tg7C4GLJtENXOZIbsF4rMPHR7d95a
         GOlBRZsqpDVyTfQYPpvajFQFF2O7a/dGZ3ZXaxRNAYLQjqkXxa7WMLGdNAq2xyROJrO0
         uW+xXzwe2Jmc1+Rhb7hUaH1ZoNGZ9R8Sb22C4iDyd2oORE4SYRss9XkSgUcPGV6NNha1
         iOKA==
X-Gm-Message-State: AOAM531AwJ8wT4V+3F4tayctbW4b8z2/hrgoHbcwwlU9+fETIwULIsuh
        4oHdRdSazFXroCT9miW+cOE=
X-Google-Smtp-Source: ABdhPJzKzQPgY/LcqrvDV04OwvthZ32bwjG2MrxC1aGp25jSVIs4t8IBHfVwSO3iOFbxozxSvZDqUQ==
X-Received: by 2002:a05:6830:1f52:: with SMTP id u18mr701552oth.298.1623264585114;
        Wed, 09 Jun 2021 11:49:45 -0700 (PDT)
Received: from localhost ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id o2sm106260oom.26.2021.06.09.11.49.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 09 Jun 2021 11:49:44 -0700 (PDT)
Sender: Guenter Roeck <groeck7@gmail.com>
Date:   Wed, 9 Jun 2021 11:49:43 -0700
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, stable@vger.kernel.org
Subject: Re: [PATCH 5.10 000/137] 5.10.43-rc1 review
Message-ID: <20210609184943.GF2531680@roeck-us.net>
References: <20210608175942.377073879@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210608175942.377073879@linuxfoundation.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Jun 08, 2021 at 08:25:40PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.10.43 release.
> There are 137 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 10 Jun 2021 17:59:18 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 156 pass: 156 fail: 0
Qemu test results:
	total: 455 pass: 455 fail: 0

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter
