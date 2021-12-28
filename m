Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3D3D1480BC8
	for <lists+stable@lfdr.de>; Tue, 28 Dec 2021 18:05:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236553AbhL1RFQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 28 Dec 2021 12:05:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34930 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236545AbhL1RFP (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 28 Dec 2021 12:05:15 -0500
Received: from mail-oi1-x22f.google.com (mail-oi1-x22f.google.com [IPv6:2607:f8b0:4864:20::22f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 63D7FC061574;
        Tue, 28 Dec 2021 09:05:15 -0800 (PST)
Received: by mail-oi1-x22f.google.com with SMTP id t19so30973203oij.1;
        Tue, 28 Dec 2021 09:05:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=jd6ctTjZ269iZe0uy5XMTWdT2aFUjKmvJL3ZHMqbsho=;
        b=DCSNX2cK/XyIkXM5trPACt0l5rFcbm7dqWVUGRVLEaGRsqNQ2Sz9WyrXeE0MrN/z95
         5yeP+jJ3bx2azzFXPQFhF5Pyik4KxSWNU9mlsS5yG3Ou+fvR4xm2h0gu8ol3dYRDgxme
         jus06RqazwAfoqobpNg++ZlkCitLQB94VYe9lIAKhcsI+QaV25V+pisZTgnuuGWH9P3x
         DQ8KT+wBXeeIGhhluvqC7TmUGoPpixjpHqw357CfPsx3DefVn10HiRtgijsCOWB1W/Jb
         usbeiL4iFu17TfFN0E6SLi3zkSEi0pRT9vc2pGim4B3epIIZ/NR8sS2SipjoF/4uTeVR
         RJhA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to;
        bh=jd6ctTjZ269iZe0uy5XMTWdT2aFUjKmvJL3ZHMqbsho=;
        b=rIeZSJmSSVuXUbySH5/apqgfS9oZ58udNlA9/nClRt4bxjZyz2yN7ZgP/8VihB6KEZ
         h/yWZ59yNAD/Wq3nw8ZuSu/3CL8wi617W/K47Gz98vW1BGZVCa3A0MIb1kVA/gyEf4E3
         5etPteKTpwgon77o0DC5wBQOQItbg/4d7OPcJcTD6sABvUZD26/79/JuofFsVUorXgt1
         Oz1uIzWeZX4wHGu/IutIS4cKahtzhW1qa/IoalNqwCqJNSq6gexsaYBsND1sc4TUQdu5
         Y/ckYHIDpmc5lGSsUR5WHoaFDWbHwCw7P5HERW7Ul8TNnoAHLaoI50QBvtLXoK6jcrEH
         U42Q==
X-Gm-Message-State: AOAM532DIrL+krsoVa9Kj7SULu+QC/EONQm5t6/tXBRScxXrbKdjgOhp
        +7BeqD6iHhtaLhSCRyFhKVA=
X-Google-Smtp-Source: ABdhPJyROPByj6s13siEazYF6bBrtn/WlItMk7GQZ4SDRyr/eP37EprzA4HBlqt4YUMuunpVlaTcUA==
X-Received: by 2002:aca:3148:: with SMTP id x69mr15861784oix.95.1640711114843;
        Tue, 28 Dec 2021 09:05:14 -0800 (PST)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id l9sm3138935oom.4.2021.12.28.09.05.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 28 Dec 2021 09:05:14 -0800 (PST)
Sender: Guenter Roeck <groeck7@gmail.com>
Date:   Tue, 28 Dec 2021 09:05:12 -0800
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, stable@vger.kernel.org
Subject: Re: [PATCH 4.4 00/17] 4.4.297-rc1 review
Message-ID: <20211228170512.GA1225572@roeck-us.net>
References: <20211227151315.962187770@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211227151315.962187770@linuxfoundation.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Dec 27, 2021 at 04:26:55PM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.4.297 release.
> There are 17 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 29 Dec 2021 15:13:09 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 160 pass: 160 fail: 0
Qemu test results:
	total: 339 pass: 339 fail: 0

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter
