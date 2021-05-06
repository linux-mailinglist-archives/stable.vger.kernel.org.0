Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B3B5B375200
	for <lists+stable@lfdr.de>; Thu,  6 May 2021 12:07:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230225AbhEFKIK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 6 May 2021 06:08:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44642 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229836AbhEFKIJ (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 6 May 2021 06:08:09 -0400
Received: from mail-wm1-x335.google.com (mail-wm1-x335.google.com [IPv6:2a00:1450:4864:20::335])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2302CC061574;
        Thu,  6 May 2021 03:07:11 -0700 (PDT)
Received: by mail-wm1-x335.google.com with SMTP id u5-20020a7bc0450000b02901480e40338bso4467494wmc.1;
        Thu, 06 May 2021 03:07:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=qk0Phljf3pVZNUl13wCN9M+I5aWffl2B9luGQSwYHpc=;
        b=iV3HAGzn+GnBYPl9kQo/JilbKrUptI4R+VPvICC2rqLmdZBvRl3cwUOY2peu9VKKVn
         trobQB1DTlGnjhd+8diK3G3yzMmsA9dvb8NjcTWXMPDfOEXAaPtUrAfnI8DVV3redEpX
         Xr80c9VlM9Ao07Tf7+4ZOImXrdKd7jPYytqgE3R10eDLIEthAi4rQd7tfU1+Fv0l4Bf+
         gzZoH6kH//QVC/p7VE9VMNKZSIAwO0v8NNE/ggoXEeKIcfe7InkKBbO/rOeZq2p0NH18
         NbRefFIN1klL8KA4Qbkr3Q60nn5uBRcSeRplUGWzWfk33xMrkloNaBFq37FY+qAyrYss
         M3Rg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=qk0Phljf3pVZNUl13wCN9M+I5aWffl2B9luGQSwYHpc=;
        b=g2LXNOOvsf3uYhwxPuE0GTJ/No0KuC10rcE9fbS7BAAmowlhpjlN1z581Q8HKEMpvu
         rUGzAbD3oncGo8GtQI8R0lGmCmSB0qUB6iJq2ccbVOc9KEgOS1ACp6XHC/Ty3Kb2qz9h
         Xazhi8wWqX1uyXAqhyv2FGWsaIw5z+rCod4z1Rn/pWL3ohAbVsN/F4SC99XfzMiSTe2B
         by8YQcQ/MHuzgC/V/ZbxEnCZGdfbdAbZe0U0GIP/06AWbLc4kRNpieNj/4BBh9atcoqr
         cyA7uPZpLVCZL7BkJYVDAaR5H4EVjxhfKNoiTObp45Ugb5fVmFdqpATjKnUMuThPAjjN
         ZMrw==
X-Gm-Message-State: AOAM531lkIK5ce7sxCVAgxLlB7gddJl+hfLo/mlSW/29xL5we+04HSde
        F4jZy1EwSB5YKltOpWT/9vo=
X-Google-Smtp-Source: ABdhPJxkKPhZJtBPWeassX/n7aUlEdgs0FT0D7cBU0L6ss6x81LSJz/epZqKIIYN532BDV7n1N+MBA==
X-Received: by 2002:a05:600c:249:: with SMTP id 9mr3081162wmj.175.1620295629835;
        Thu, 06 May 2021 03:07:09 -0700 (PDT)
Received: from debian (host-2-98-62-17.as13285.net. [2.98.62.17])
        by smtp.gmail.com with ESMTPSA id k10sm16470828wmf.0.2021.05.06.03.07.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 06 May 2021 03:07:09 -0700 (PDT)
Date:   Thu, 6 May 2021 11:07:07 +0100
From:   Sudip Mukherjee <sudipm.mukherjee@gmail.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, f.fainelli@gmail.com, stable@vger.kernel.org
Subject: Re: [PATCH 5.10 00/29] 5.10.35-rc1 review
Message-ID: <YJO/y4Lv/hu6xEAY@debian>
References: <20210505112326.195493232@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210505112326.195493232@linuxfoundation.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Greg,

On Wed, May 05, 2021 at 02:05:03PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.10.35 release.
> There are 29 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 07 May 2021 11:23:16 +0000.
> Anything received after that time might be too late.

Build test:
mips (gcc version 11.1.1 20210430): 63 configs -> no failure
arm (gcc version 11.1.1 20210430): 105 configs -> no new failure
x86_64 (gcc version 10.2.1 20210110): 2 configs -> no failure

Boot test:
x86_64: Booted on my test laptop. No regression.
x86_64: Booted on qemu. No regression.

Tested-by: Sudip Mukherjee <sudip.mukherjee@codethink.co.uk>


--
Regards
Sudip
