Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3692A45E6D9
	for <lists+stable@lfdr.de>; Fri, 26 Nov 2021 05:30:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1358217AbhKZEdp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 25 Nov 2021 23:33:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45444 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1358193AbhKZEbp (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 25 Nov 2021 23:31:45 -0500
Received: from mail-oo1-xc32.google.com (mail-oo1-xc32.google.com [IPv6:2607:f8b0:4864:20::c32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B5455C06179B;
        Thu, 25 Nov 2021 20:12:57 -0800 (PST)
Received: by mail-oo1-xc32.google.com with SMTP id x1-20020a4aea01000000b002c296d82604so2702420ood.9;
        Thu, 25 Nov 2021 20:12:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=ACeuRZsLYoEu9PTp4h8uBmcdy4Z3lKlKL5IePDx6dds=;
        b=WZMe+zljoB1Yd8rk8J8/6MEFBM/5nbAk/B1hBjs1aPiz+V4M+DHKsNz5ITiX41P3bb
         MiYnv60oMTkB3ZysdHk2m2Gc0QRN2syjNloi5cpJUgNIWNByhSgWkG0+uSetomvmgg38
         YjqhLgBLlTFoBlQdM0dyRMeNmAfiZWAEyC5cHaKN5t99oy7TIz0RZ0SuTbdSegEz2eaG
         jhjSq6lQjYFo9LsM0Cn3MkNYFCj9SdpFzcF/j/90o2MkSgroXreJNs9koOLTNNQII/4t
         Kx36dek4fmJ7hI73UxaRjFjUqkmgQdy7+qjuDQkwa+SJZhtpnUI0zwkdgWUFvfBn+o1N
         1F6g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to;
        bh=ACeuRZsLYoEu9PTp4h8uBmcdy4Z3lKlKL5IePDx6dds=;
        b=hoR5K3VJd2Q3SkSj9Z6f788Pw5wyukDzPLcH/1JGJvDKX9bpN5LJ5gihwVkfhOpA4t
         0RmMPKUH+sVvQ4dnJTazZjeVNc8V5k6qtiPjXgzwMvJYZc/FWuSYczgwqffcEPW1xgOZ
         NUmgDl23tDYk955rKQ3GCg9+n8lJqnvEbgvy8P7WjTi6LtgXdwYVNdZmGLZlWIVMXAE5
         Ffmx+QbTHGf4zLIeMWk0gCG5knyhgof3ea2zfvU40yVng/H0JodHV/pBe+uPnDxj5AVV
         +166+ynQXBYFEW3VxmFV/mD1h3E0/5fRIWGAlYE6erTE+lQudKW7bxlbsKdX7P3miRXm
         GVeQ==
X-Gm-Message-State: AOAM532sB/L386EKrb4wi3fReCwNiCnNZDSO2JH9PJ9OaITwWayIa36p
        XxTuUFe99Mj2lMVDZuI9uj8=
X-Google-Smtp-Source: ABdhPJzN2kH3aL4+J9ib4YD7iub3zihNimbNE8/f3qrnnkWBN+jFmygmMZRNPOJ1EGRN2s2+GwHzrA==
X-Received: by 2002:a4a:ead8:: with SMTP id s24mr17898876ooh.89.1637899977133;
        Thu, 25 Nov 2021 20:12:57 -0800 (PST)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id z12sm827230oor.45.2021.11.25.20.12.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 25 Nov 2021 20:12:56 -0800 (PST)
Sender: Guenter Roeck <groeck7@gmail.com>
Date:   Thu, 25 Nov 2021 20:12:54 -0800
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, stable@vger.kernel.org
Subject: Re: [PATCH 4.4 000/159] 4.4.293-rc3 review
Message-ID: <20211126041254.GA1376219@roeck-us.net>
References: <20211125160503.347646915@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211125160503.347646915@linuxfoundation.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Nov 25, 2021 at 05:07:18PM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.4.293 release.
> There are 159 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sat, 27 Nov 2021 16:04:43 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 160 pass: 160 fail: 0
Qemu test results:
	total: 341 pass: 341 fail: 0

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter
