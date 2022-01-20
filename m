Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EE4C04944F0
	for <lists+stable@lfdr.de>; Thu, 20 Jan 2022 01:43:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240592AbiATAnb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 19 Jan 2022 19:43:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43738 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232101AbiATAnb (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 19 Jan 2022 19:43:31 -0500
Received: from mail-ot1-x331.google.com (mail-ot1-x331.google.com [IPv6:2607:f8b0:4864:20::331])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2E7F9C061574;
        Wed, 19 Jan 2022 16:43:31 -0800 (PST)
Received: by mail-ot1-x331.google.com with SMTP id k13-20020a056830150d00b0059c6afb8627so3329048otp.5;
        Wed, 19 Jan 2022 16:43:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=Cl3JsBDouJuhHBZEXyBrdyFpqc1sq6He81+fquGUGM4=;
        b=jdveH7V/0uAGkcl81TeWJ1lHZo1ZIfyqf+356BEKQX6M+KsR9j2NWjvQ1oUCb71jX5
         z2fBGvZn08DcY0cElgTOgh8d8Dfvuf9pmElfz09eXI+wiL+/c+V8K64h8GBX+v5z2x7U
         HqbOArQM0L1OFhPc7GcT7OQ58kEkDdEnu83zZvxbFLd6wL80+kQPYYuXtwgsnfWT1+0W
         YVOpcOE7cA4dZmt+hw0z6ZozWwfHA3xBIr1YA72ihrcvVBm6ARyg7Lwpkgb0CyWKA0pb
         ppWyzNcP3xUrjNLEAY67NF+/WL4pgwZfG2GuC+RS3eqOYfabXDNxrO8ROKRWUZeNT9v5
         rwcw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to;
        bh=Cl3JsBDouJuhHBZEXyBrdyFpqc1sq6He81+fquGUGM4=;
        b=rPBitUAgxilSWJCmdj4XFbvSajwJqeD4lrCa/MVLrrn/5y8EVlf3v3V9wW6zkMsPfb
         MtEDPlmXocIHo3VTZ84JpLu2vaKh20s/fcTpMcqQaKyw8hZ9cjxRxyXaAUBtOZFY28uj
         dC5MYXAqObHkalXktGJJK9PWyqNqQv+g5fKDlVXAMXZPB99caYDfqnhq2XTbs5xdKocX
         zR9Q3xidlFqD84jq5RBIz1qxzheXWhXBZq18xxjCJObcGVbIFwXn7zfKP7bWCjvrUhtR
         Q/AqcCewNyNzGMjO40OGGY7ty8RBYUvl2iEDTqc91JiQvN4561xLWVxZPiLZF/O01eng
         Qx3Q==
X-Gm-Message-State: AOAM533f6SHwQdc5AiC9izGa6lTPhnumDFNF8IDWEA59iT1HVpE/B1nm
        04I3adD/KLqTFjStBzbYJT+SPS7VAck=
X-Google-Smtp-Source: ABdhPJwwpN13YBh1paM8fY5yvCufvTOCcNRUzMMNbxvvGK8FbSNlUsVpbLM54H0HPH7k36gYTejmJA==
X-Received: by 2002:a9d:2ae9:: with SMTP id e96mr25581034otb.130.1642639410536;
        Wed, 19 Jan 2022 16:43:30 -0800 (PST)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id q12sm616987otm.2.2022.01.19.16.43.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 19 Jan 2022 16:43:29 -0800 (PST)
Sender: Guenter Roeck <groeck7@gmail.com>
Date:   Wed, 19 Jan 2022 16:43:28 -0800
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, stable@vger.kernel.org
Subject: Re: [PATCH 5.4 00/15] 5.4.173-rc1 review
Message-ID: <20220120004328.GA3474033@roeck-us.net>
References: <20220118160450.062004175@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220118160450.062004175@linuxfoundation.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Jan 18, 2022 at 05:05:39PM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.4.173 release.
> There are 15 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 20 Jan 2022 16:04:42 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 157 pass: 157 fail: 0
Qemu test results:
	total: 446 pass: 446 fail: 0

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter
