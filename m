Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 700D325B206
	for <lists+stable@lfdr.de>; Wed,  2 Sep 2020 18:50:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727065AbgIBQrt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 2 Sep 2020 12:47:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33844 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726567AbgIBQrq (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 2 Sep 2020 12:47:46 -0400
Received: from mail-pg1-x542.google.com (mail-pg1-x542.google.com [IPv6:2607:f8b0:4864:20::542])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E1DDCC061244;
        Wed,  2 Sep 2020 09:47:45 -0700 (PDT)
Received: by mail-pg1-x542.google.com with SMTP id 31so2811403pgy.13;
        Wed, 02 Sep 2020 09:47:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=QaMHW7RRZ1d5wMJq81tsiHDuJko5XahkPWtD7sjM06M=;
        b=ENI+B6QrSSbuYymcd9YwEN1E22Inv32g+rGdxZ+Uc62WoZ7o5tsoqzZeWeSgcBPSfO
         Je+OwJ1fvR95k/+8WWQBUHljUdk0KBKVvWBUekrK9KLrPNGWlfoaRs5cP8LrxGLJaFm5
         xevBWmVitkxUIg/BrQ0C5Oneaydq/ZfIKfEckUEGFAFfi/nCoKGfWZc/e7srONdzML8A
         3Z+WayVAR6XEzAcPOJFTX56IOgvNxweALBA6rVKv4RrQurl6solIMH7RsbSqJfM9w0vo
         l7fhTZ9bf1Jjc54tNh37Zsxd+6XFGotUESzdWpuLJG9zzR5js4TADMSV8nsav6t8fMoO
         Y7TQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to:user-agent;
        bh=QaMHW7RRZ1d5wMJq81tsiHDuJko5XahkPWtD7sjM06M=;
        b=B7x4Ef19CuUnOlZgiDGkYqZTe3OW84mfGwHbCILafzYmofqFfW/DM53RwTFeAat4Zr
         9aT59ofTkrxLAvE7P5Qa2Ukz7fme6PlfAc2xwEWE3ggeecEMyRYFGkZ+kYhlrIwl2S0R
         ljTjUPZAIi/XSvkKZgfjKj06WPYHWIXIQBsFMcdU75DgQEsROkKd/V7CribFKV4EW+Rv
         PzRbEGzPGY4b+STcdWHe8zszr+vrthLpZxaJNUKOVfIq2Ae8PiNHRCtN97yDC7/U1eDQ
         vdbQR0WPU33T3+aJLi4A9zvxu1cw1SaZAuZ9Fu1UKX6kvYvQ8y9C42zyoPtzQQ5g2EDH
         Fgfg==
X-Gm-Message-State: AOAM530qK/kBe7oB8LjOtUVbSz9AOp+vJ/ni2SHEp/mDTPTV2TRJ03sG
        grxnX/gG7QxEHs0wm50kwY4=
X-Google-Smtp-Source: ABdhPJzh60Icx7/awuslXA8jzy20l+eBZOmi1Xe5buD/nwxCEaoW8TXwehd1aiC5lI6nuumveWeqBA==
X-Received: by 2002:a63:d14b:: with SMTP id c11mr2656329pgj.64.1599065265226;
        Wed, 02 Sep 2020 09:47:45 -0700 (PDT)
Received: from localhost ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id i11sm5479265pjg.50.2020.09.02.09.47.44
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Wed, 02 Sep 2020 09:47:44 -0700 (PDT)
Date:   Wed, 2 Sep 2020 09:47:41 -0700
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        stable@vger.kernel.org
Subject: Re: [PATCH 5.4 000/213] 5.4.62-rc2 review
Message-ID: <20200902164741.GE56237@roeck-us.net>
References: <20200902074834.222878009@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200902074834.222878009@linuxfoundation.org>
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Sep 02, 2020 at 09:48:59AM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.4.62 release.
> There are 213 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 04 Sep 2020 07:47:53 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 157 pass: 157 fail: 0
Qemu test results:
	total: 430 pass: 430 fail: 0

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter
