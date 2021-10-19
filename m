Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E7ED4433FC9
	for <lists+stable@lfdr.de>; Tue, 19 Oct 2021 22:27:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230481AbhJSU3Z (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 19 Oct 2021 16:29:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34022 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230147AbhJSU3Y (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 19 Oct 2021 16:29:24 -0400
Received: from mail-oi1-x234.google.com (mail-oi1-x234.google.com [IPv6:2607:f8b0:4864:20::234])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 72810C06161C;
        Tue, 19 Oct 2021 13:27:11 -0700 (PDT)
Received: by mail-oi1-x234.google.com with SMTP id s9so4427882oiw.6;
        Tue, 19 Oct 2021 13:27:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=qLcba04mbUmZIS4AOMt4t0WPHcaWrgX1wGkbO9ZG8vw=;
        b=TTPjcElIywbVgsB+BckAwGvEW2Qtkgrn95QXMGV4FP1PiKEdYhCY+8gjKplniotCd7
         wdls+hNLx9jP8+hyKwgV1ovXkmOlZPbUSlvbLlk4axyP59bYNunmDkSgEnd1N7Yj7rFH
         NcxKW9ybgbgYN3ap/ZkvsuJWpBveTN1zf7qb/GVwf0M+w0KirKlYGPhQeN9sEreR+f+S
         I4HT+vbHcjh84Ml2n6TMqJyPTBXTp/O5lIlfUY4KMQ6/+fQRghW/lXvsZlE4FQ0IFwBN
         XXgWnNWTbSpPrjv4iyuDsmFwOAg/oTXVDopSOrGlKHE+eusufs2eCWG0efhZ31LmtYK3
         sSVg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to;
        bh=qLcba04mbUmZIS4AOMt4t0WPHcaWrgX1wGkbO9ZG8vw=;
        b=ypRt6Ue5jSpIXoe84GjG7q7KIqWwtqWVoN/vtkbK1ExQioLTKS98S8zV+NQsUV4zmi
         XY4m5iFUzV+IVS2C35WjXWjia8+jaErlY6bHgrWktWVgWmC7mxHLPMn7CGBQkko+S0SX
         iIc2TtfbV9XrhwgKD+U7oAf8SaMsOqY0sV7hp6/W02dDBb6UYd+M7S+a70pvyumX6ymY
         bOwdEdqRJQ4CRbdoEBtfnN58MFQ4oOIj2BtN1SkivUC6djE5fzY44T19+kdoWsCVWkZz
         gPDoHglRvngojICXGJCuzAsOrVWqNeP3HaDjfTHdPp3mJ/3LoZseZOHfXkte+XOwygjs
         hsYw==
X-Gm-Message-State: AOAM5301lpxIr80OaPsR4ckI3Fy5+V/Kj6wx2RbcsqSPYhUFHcjei1Rh
        MQAjtdlAFThObS6JGKRYzVo=
X-Google-Smtp-Source: ABdhPJze0dfomB0sK5MYF+r2lQa7Ckzix/pIRAdCgZ0MjTGTtM3CkEX1eDFTuyLoNONLHnhqgV/qFA==
X-Received: by 2002:a05:6808:1187:: with SMTP id j7mr5986281oil.135.1634675230953;
        Tue, 19 Oct 2021 13:27:10 -0700 (PDT)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id k5sm22167oil.7.2021.10.19.13.27.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 19 Oct 2021 13:27:09 -0700 (PDT)
Sender: Guenter Roeck <groeck7@gmail.com>
Date:   Tue, 19 Oct 2021 13:27:08 -0700
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, stable@vger.kernel.org
Subject: Re: [PATCH 5.10 000/103] 5.10.75-rc1 review
Message-ID: <20211019202708.GD748554@roeck-us.net>
References: <20211018132334.702559133@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211018132334.702559133@linuxfoundation.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Oct 18, 2021 at 03:23:36PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.10.75 release.
> There are 103 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 20 Oct 2021 13:23:15 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 159 pass: 159 fail: 0
Qemu test results:
	total: 472 pass: 472 fail: 0

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter
