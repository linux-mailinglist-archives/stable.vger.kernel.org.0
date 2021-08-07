Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DA7293E34F6
	for <lists+stable@lfdr.de>; Sat,  7 Aug 2021 12:41:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232066AbhHGKlc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 7 Aug 2021 06:41:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43364 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231899AbhHGKlc (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 7 Aug 2021 06:41:32 -0400
Received: from mail-wr1-x434.google.com (mail-wr1-x434.google.com [IPv6:2a00:1450:4864:20::434])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 409F0C0613D3;
        Sat,  7 Aug 2021 03:41:14 -0700 (PDT)
Received: by mail-wr1-x434.google.com with SMTP id c16so14421470wrp.13;
        Sat, 07 Aug 2021 03:41:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=WLMFkHqK0hywRW33ybZckX3zab2S7PBYo9DPVyDa7TE=;
        b=qrmFAp7VFk/IrMtxwQuSD/t5P3rn1S8yGLVMWAO/EyuA07iD5LqtdjYSSZadSAr+xQ
         hf/WrSfbCZ3sJ66eUUB2s8wfZ4MgmVQAljCBRVOdFZm4hxTyZFFrat2WcCYJM6Rwqo2D
         1aYJKDPYwQv54dQdK+Ww52ITsjo9RJlqdoeyezheWKY+P8zYZeRSlq949afzxBjA7gl8
         BzZm+87l1LKDOQvVQ1eBExI/yVyFWACd0Spxd4WIIfKVTQNnlo4B8nH6E/rDn779HtYo
         QIt2r2hX70k8lLofNNsLIo1ENBvaDNkkp8ojgliCqiBrQSficr06w0sC6Zbu4C4HONR5
         59Vg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=WLMFkHqK0hywRW33ybZckX3zab2S7PBYo9DPVyDa7TE=;
        b=Q/GQXpV/zwiKNKpRa6Eo+ONu8PmkV843HbbPxnJl6k51KFEuvv1kqR2dEnjw0wkUrB
         72EsOV9OBfmCEHkL0rnJI78Z41DFxbwLfonfhkZGH0oanpmy/8iEZndExpfTdpbvxV3H
         DpcpG8O9ImEiIMqCUgN0Esw4lYzHoRQ6kKrBbCqaRJYB3qZCDq+9+IdwTly/IIie/IO6
         rXPv+J2l2xavs51LpmzCBs0UpiaZuTEs3OKylZis+Bb41TobgnOc8h+u4TFTtO1DSe6o
         EWsMMr4jTPEfve7+/iqADD0xVSHB9fm7Bkl99xxmp5l7JIBB0WEthWTOistX968c4wvz
         5s5w==
X-Gm-Message-State: AOAM532F5n0a2W7EkfayKpiAc6cpq7WA/ydx+kWudxiOzt7qldPVAOcD
        6Lk8n4adk5xlKzXUoq+Q0z0=
X-Google-Smtp-Source: ABdhPJwK8TZCf+zWlVb39zFUO8j6Vu6rk4q1/4j96xPmv1bT/Ny2/qKS34TQlebWMrwyc394CUIZMA==
X-Received: by 2002:adf:8b86:: with SMTP id o6mr15101318wra.116.1628332872908;
        Sat, 07 Aug 2021 03:41:12 -0700 (PDT)
Received: from debian (host-2-99-153-109.as13285.net. [2.99.153.109])
        by smtp.gmail.com with ESMTPSA id m32sm9996479wms.2.2021.08.07.03.41.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 07 Aug 2021 03:41:12 -0700 (PDT)
Date:   Sat, 7 Aug 2021 11:41:10 +0100
From:   Sudip Mukherjee <sudipm.mukherjee@gmail.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, f.fainelli@gmail.com, stable@vger.kernel.org
Subject: Re: [PATCH 5.4 00/23] 5.4.139-rc1 review
Message-ID: <YQ5jRk6QExGJlu0o@debian>
References: <20210806081112.104686873@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210806081112.104686873@linuxfoundation.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Greg,

On Fri, Aug 06, 2021 at 10:16:32AM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.4.139 release.
> There are 23 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sun, 08 Aug 2021 08:11:03 +0000.
> Anything received after that time might be too late.

Build test:
mips (gcc version 11.1.1 20210723): 65 configs -> no failure
arm (gcc version 11.1.1 20210723): 107 configs -> no new failure
arm64 (gcc version 11.1.1 20210723): 2 configs -> no failure
x86_64 (gcc version 10.2.1 20210110): 4 configs -> no failure

Boot test:
x86_64: Booted on my test laptop. No regression.
x86_64: Booted on qemu. No regression. [1]

[1]. https://openqa.qa.codethink.co.uk/tests/10


Tested-by: Sudip Mukherjee <sudip.mukherjee@codethink.co.uk>

--
Regards
Sudip

