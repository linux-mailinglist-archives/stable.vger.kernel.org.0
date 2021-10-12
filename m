Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C5AAE429B42
	for <lists+stable@lfdr.de>; Tue, 12 Oct 2021 04:01:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231467AbhJLCDi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 11 Oct 2021 22:03:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59694 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229556AbhJLCDi (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 11 Oct 2021 22:03:38 -0400
Received: from mail-oi1-x22a.google.com (mail-oi1-x22a.google.com [IPv6:2607:f8b0:4864:20::22a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 84AFFC06161C;
        Mon, 11 Oct 2021 19:01:37 -0700 (PDT)
Received: by mail-oi1-x22a.google.com with SMTP id n64so27122678oih.2;
        Mon, 11 Oct 2021 19:01:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=ONYzTbktYpYsB9h6cAtOgLPLE6h6hIEayfiISjgeLAk=;
        b=ZLBdpYw3ViTXS0Rbdv9i+Ne+rgiM7U1e+bLIDO2Mroncqorja8XIS09evkFVnI2ibg
         lwHD0HyW2CipYjTGI78yPD/wt01MnrhF3yu5n5w/+oLNpWCN/savGb38V+upX23GX0qL
         ZHjLV52Y6seVso+Lro0Pu0FePYKmoznfud3moZ/Hu9dxI4WCAS4lvewVQenY8orR5Mzk
         +Ae+sWw8a+k6dLmvqAc1Y1usPx7eu9I25LiQuNbkLJ1fh2bwvVOOuWc6JSRjUeeZ97S3
         uZVjPAFZwSoh7bOPTLq2ldP24u0BqZGrRDj+FDGdlpXc2yTqC3NVG3yCTWutk1dn65Vz
         swxw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to;
        bh=ONYzTbktYpYsB9h6cAtOgLPLE6h6hIEayfiISjgeLAk=;
        b=TKutdRauI/wKo5Vw9Ng4jhP2KPFJTfaO3OWl0rphe/T6mRoqEBesWmfbMkUcP84Hwm
         h6xYHW4a5odL2KeWyGC6o8NWuc/mhdpFyO9+dL4x+aj7uV/ym6CHy3d3O1kZKV0EsJ4v
         SwjVTkYJdHtOyuiBTeekmZwXY3WHAJEMvrAKOBWcNUReYQrir7CvxgfDIsZ+JVF84mmJ
         CjGePHIIXISWYV9UGrs7K/iUDXgvdJHEOn57Ll+0aP0LB5Ezl1g/E0W115j9mXub1mzY
         nTCcbezo48AcFRPakUIy23SMuAoRwxapU4IlSTyI0z5tg7Nw0ZhDW010+gpuL39jx6fX
         EWjQ==
X-Gm-Message-State: AOAM5331FVCMdU9z67W1DPdr+LHMnoOs07Y2Bqn8hM0BiICNLyj7l581
        dVwiLJ16tMxkxukfXRzACIE=
X-Google-Smtp-Source: ABdhPJw7fq7vP9s6NTLiXvVLrWI8gIIoZdR/gfGI7oGTU0FRSgT2T6pFoFyjaPlq6AFFJat0FQEANQ==
X-Received: by 2002:aca:d984:: with SMTP id q126mr1838089oig.30.1634004096998;
        Mon, 11 Oct 2021 19:01:36 -0700 (PDT)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id g4sm1827286ooa.44.2021.10.11.19.01.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 11 Oct 2021 19:01:36 -0700 (PDT)
Sender: Guenter Roeck <groeck7@gmail.com>
Date:   Mon, 11 Oct 2021 19:01:35 -0700
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, stable@vger.kernel.org
Subject: Re: [PATCH 5.10 00/82] 5.10.73-rc2 review
Message-ID: <20211012020135.GC2033605@roeck-us.net>
References: <20211011153306.939942789@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211011153306.939942789@linuxfoundation.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Oct 11, 2021 at 05:34:39PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.10.73 release.
> There are 82 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 13 Oct 2021 15:32:51 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 159 pass: 159 fail: 0
Qemu test results:
	total: 472 pass: 472 fail: 0

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter
