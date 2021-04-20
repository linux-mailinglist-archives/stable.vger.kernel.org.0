Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 234903654FD
	for <lists+stable@lfdr.de>; Tue, 20 Apr 2021 11:11:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230491AbhDTJMR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 20 Apr 2021 05:12:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37504 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230168AbhDTJMR (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 20 Apr 2021 05:12:17 -0400
Received: from mail-wm1-x32d.google.com (mail-wm1-x32d.google.com [IPv6:2a00:1450:4864:20::32d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E1D17C06174A;
        Tue, 20 Apr 2021 02:11:44 -0700 (PDT)
Received: by mail-wm1-x32d.google.com with SMTP id o21-20020a1c4d150000b029012e52898006so9892018wmh.0;
        Tue, 20 Apr 2021 02:11:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=SZlSKMrtfhgd/t1916znKN1PAPJqii0M6UczvCZ0x0U=;
        b=R/A80gw26eTkugrRAr1b++r/GSZYlECbYoz0A2XuDjoKpwDTXLIawo6gKHweE4vsVu
         ggDwWJe48N8HH2lxr+VEQGCHM/Hmp2D0yGdVV0LSZ4rbxmCyKUOyWTGQ4CEOwJfcopNP
         4PijSE5NqoenJ+AVNX1otIFkQ0bZHOLLvdR9UvBJ6+iXNAG8jlWPj0T7CtW0f3MCFJwJ
         lJRUtenbYQm5pqsAHz1pjCKSP0UDnQod8ArdDdX2CAiNqhvlV+c/ODAq6ZH81KIklsSJ
         fFHJJO4CbZ62aNt7ndS8XrUEExzBXSRe/ZiRhNhTgnNggsI9NeKUQLeE18Fea2E12Gah
         QHIw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=SZlSKMrtfhgd/t1916znKN1PAPJqii0M6UczvCZ0x0U=;
        b=Mk0EEcxYFp2aniHEWcJTW8AJ7SlaUiyJIxkH1czr9nndAdDy1sK5Slcx6uHJT/gM87
         dCZNcBRF9VnpXKgCfaRSus4H1kex63MAy5dLU3Ft8Ht5YgjtGlSKayc44NVGdMUP6uol
         UwHmhVxpOZU8boKOO5zvzxs6W54Qtwl/1tUwhnB/zqmriMPqva3itKczUWYJZIVFG0u7
         vndY5cJhT9nhrJIddYDneZMFS2Rs6WtG6WqvEcyOwTIaw3Dzl/z1Pi+NkYHqoWuet0ks
         WVcQiJvSZ/6itMKxfsLn+HxKzlN9DdpmApQ78Y/Oi1zxb7TU/kTeh8DVqoUeY//amYaJ
         71Ww==
X-Gm-Message-State: AOAM5307Xf/Avs5pDQMEnNAyM8NT+xqwKWz50xbs4MRw8kgWrGFAS+eC
        WvabMXKXR8Az/86ybCV2pTk=
X-Google-Smtp-Source: ABdhPJxiSzwZxE5wQhVvaVoCtVVJlI4JThz0z67P/oEnz2k1IOgQK2CNobmALNHa7rt8QHapwIYDZw==
X-Received: by 2002:a05:600c:9:: with SMTP id g9mr3433449wmc.134.1618909903629;
        Tue, 20 Apr 2021 02:11:43 -0700 (PDT)
Received: from debian (host-84-13-30-150.opaltelecom.net. [84.13.30.150])
        by smtp.gmail.com with ESMTPSA id c18sm26384470wrn.92.2021.04.20.02.11.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 20 Apr 2021 02:11:43 -0700 (PDT)
Date:   Tue, 20 Apr 2021 10:11:41 +0100
From:   Sudip Mukherjee <sudipm.mukherjee@gmail.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, f.fainelli@gmail.com, stable@vger.kernel.org
Subject: Re: [PATCH 5.4 00/73] 5.4.114-rc1 review
Message-ID: <YH6azU0HsVLzlcgX@debian>
References: <20210419130523.802169214@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210419130523.802169214@linuxfoundation.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Greg,

On Mon, Apr 19, 2021 at 03:05:51PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.4.114 release.
> There are 73 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 21 Apr 2021 13:05:09 +0000.
> Anything received after that time might be too late.

Build test:
mips (gcc version 10.3.1 20210416): 65 configs -> no new failure
arm (gcc version 10.3.1 20210416): 107 configs -> no new failure
x86_64 (gcc version 10.2.1 20210110): 2 configs -> no failure

Boot test:
x86_64: Booted on my test laptop. No regression.
x86_64: Booted on qemu. No regression.
arm: Booted on rpi3b. No regression.

Tested-by: Sudip Mukherjee <sudip.mukherjee@codethink.co.uk>

--
Regards
Sudip
