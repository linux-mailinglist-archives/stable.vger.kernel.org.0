Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 03E7347355A
	for <lists+stable@lfdr.de>; Mon, 13 Dec 2021 20:56:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241006AbhLMT4X (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Dec 2021 14:56:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32964 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237026AbhLMT4X (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Dec 2021 14:56:23 -0500
Received: from mail-oi1-x22a.google.com (mail-oi1-x22a.google.com [IPv6:2607:f8b0:4864:20::22a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 20525C061574;
        Mon, 13 Dec 2021 11:56:23 -0800 (PST)
Received: by mail-oi1-x22a.google.com with SMTP id bj13so24657932oib.4;
        Mon, 13 Dec 2021 11:56:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=F3I+D5tWZLjGl05X4qqJCfcOkAn87z3+5VKEc1htsUM=;
        b=M9xKy0P0j+xCzKbaT+Uy/pR7MV+MMyTXDGRe6A2XcjFeHUmhQm3yBAFRF7uNriB7X1
         EFX8HklmQ7dH7UfJ8JsSbW49+KrY8tloXV2IaeLsENat88MHHnHFmdy4u290ubXG+7M2
         PcuV6a8G/+H9rjRkYWBWegHxaZw495QgZS+kfWffU0T6DjOXs7lpX1Z5VQZBCG7GfKza
         FLCwOQuYJ/ZMsQYkY17h91Wf7sDomuyDs/M8xYW9qDvDTv5RKVccB8l4JvyCK3zeItuq
         r4czsF/nA3pq7N/7mLDq7W2jZn75F0/z03SoVmIQOTBK2siwMrGH/q+/VD0fbtz+R+l3
         mVGw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to;
        bh=F3I+D5tWZLjGl05X4qqJCfcOkAn87z3+5VKEc1htsUM=;
        b=BqVWa2SAxplGwhU80XdMMXDu+bnkW3LzCcXQLYN8vwkmoGN7ZlSfe0Uxf25bawZjDM
         dZSEa79xMmkU0U0bs2l54O+bLSvck2TdNbSKDQxciusBTsMYab+fApKh4KKxrD4iUaRC
         hjO8V6rAe3bTWkA4kvwCTEl5WfBfnlI5JoOSabxNV1qLh32W3XRSLzx+9XOE+ZEkXR+q
         pojQPBD0kiUDfCnd7giU9vSVLglRpO/Ibg5JL8wf1Of/WX4dOFM53wJDh8BCY9KebHaL
         7hohjE6h85fVZ8K+7dLC/ecCtzIJXcQTFpzk4MlkABExf7aOKFF3Q5mURhQTWXVokkRX
         iw+w==
X-Gm-Message-State: AOAM533pn/T5xbB3cG0Cq2zMKyQJkeyuk8mg/N44mtvkXIn6K7ePJfhD
        LIZvthFtklJg4qU+Qhht4Yw=
X-Google-Smtp-Source: ABdhPJy+SnOz6CbsyvMH5GB5N12x8nCqn7+1N11GAOIGdNVdYPWmG81VvnELzUHjdeZ2R75voD4ykQ==
X-Received: by 2002:a05:6808:18a9:: with SMTP id bi41mr712233oib.48.1639425382511;
        Mon, 13 Dec 2021 11:56:22 -0800 (PST)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id r23sm2340520ooj.37.2021.12.13.11.56.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 13 Dec 2021 11:56:22 -0800 (PST)
Sender: Guenter Roeck <groeck7@gmail.com>
Date:   Mon, 13 Dec 2021 11:56:20 -0800
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, stable@vger.kernel.org
Subject: Re: [PATCH 5.10 000/132] 5.10.85-rc1 review
Message-ID: <20211213195620.GF2950232@roeck-us.net>
References: <20211213092939.074326017@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211213092939.074326017@linuxfoundation.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Dec 13, 2021 at 10:29:01AM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.10.85 release.
> There are 132 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 15 Dec 2021 09:29:16 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 159 pass: 159 fail: 0
Qemu test results:
	total: 472 pass: 472 fail: 0

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter
