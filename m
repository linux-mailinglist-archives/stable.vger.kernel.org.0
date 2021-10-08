Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 854F04272C1
	for <lists+stable@lfdr.de>; Fri,  8 Oct 2021 23:02:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243151AbhJHVEp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 8 Oct 2021 17:04:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53758 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231506AbhJHVEp (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 8 Oct 2021 17:04:45 -0400
Received: from mail-ot1-x32a.google.com (mail-ot1-x32a.google.com [IPv6:2607:f8b0:4864:20::32a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CEB20C061570;
        Fri,  8 Oct 2021 14:02:49 -0700 (PDT)
Received: by mail-ot1-x32a.google.com with SMTP id g62-20020a9d2dc4000000b0054752cfbc59so13250954otb.1;
        Fri, 08 Oct 2021 14:02:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=v5VeiAs4IhPpx0slfD8MYO1ptKdKsl2MA5UpzcRb7Ag=;
        b=BFGkMrUy2ChcsEF7nxCHaN6Rt+ZLpxo1WpbMUsbvCfVlmwBmSGhNk6CAlYFr6JA8wP
         gJ97YPP9+plvNk7ef0aetzRzzoW2vIeM+mVzr6AF1CmJ1QyYf8s3RsIhf2LXptJc54SV
         5Rt9DZTSg4Uv/YfsoUNUQUJzgZfZLetvydoJ0ttwbfuNZ8R477ewFZ4vfF8sYl4RjWh9
         pG0bj5VaNtlWXFuuEbwIEoSzi5/VSU1PMKleDltQOkFptf1Diad0IZ2DGwq4w9w32EM8
         atmPUXWLT9ZV2Mzl85mTBZMecMrhPfPVSXEM8WnsRac60Bm6OeuL1WNQIkySQaPLZMFk
         2uUQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to;
        bh=v5VeiAs4IhPpx0slfD8MYO1ptKdKsl2MA5UpzcRb7Ag=;
        b=ieEXcTmOo0YrYAnzO4fvq7B387aVoyeKX/Ix90uZ06k4xUC1u+fC5J+FDAAuSeb6wr
         LlISQuP67y6uVTRFE+LCX+0va8JsXwLlqeLLcrxc2+BVzwqhHSVZoHZze8lyb/AXeGni
         OhUk45UL7DM8eiDjMT/sDOSS7CQ8IOX9Oa+qsY2ZlvP3IhFlI9flO216BChFYMMM9N6n
         0a4Pi3FKi4lHuklSq200Fir64x/2f0NAe9e4jthNa3mWavpcfsT0lr4wd2QxTXeN/5NB
         3kyyCBsC2QZjIPBFV3uxc2j+i3n2iHaVoo+WGUsahtzRWozilRVatvCNwimldAsm3Qs1
         yFKg==
X-Gm-Message-State: AOAM531Oq6YLGPwD/O5xZa2WoBXBlIkY8+wdC95yWkoxeb+zfPmiJBpC
        1DF/S41jBq1SjIW6BsJG/O4=
X-Google-Smtp-Source: ABdhPJyBbiFTsynQ6hAGd9MOyts7fyQBMcf2Sy8SaKBuY85vRQWF/0um/8O0JcHannzqAnBn6qzy2A==
X-Received: by 2002:a05:6830:410c:: with SMTP id w12mr10198260ott.224.1633726969227;
        Fri, 08 Oct 2021 14:02:49 -0700 (PDT)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id i15sm89409otu.67.2021.10.08.14.02.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 08 Oct 2021 14:02:48 -0700 (PDT)
Sender: Guenter Roeck <groeck7@gmail.com>
Date:   Fri, 8 Oct 2021 14:02:47 -0700
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, stable@vger.kernel.org
Subject: Re: [PATCH 4.9 0/8] 4.9.286-rc1 review
Message-ID: <20211008210247.GB3473085@roeck-us.net>
References: <20211008112713.941269121@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211008112713.941269121@linuxfoundation.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Oct 08, 2021 at 01:27:37PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.9.286 release.
> There are 8 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sun, 10 Oct 2021 11:27:07 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 163 pass: 163 fail: 0
Qemu test results:
	total: 394 pass: 394 fail: 0

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter
