Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ECEA036B8F3
	for <lists+stable@lfdr.de>; Mon, 26 Apr 2021 20:32:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234108AbhDZSdM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 26 Apr 2021 14:33:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45230 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233934AbhDZSdL (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 26 Apr 2021 14:33:11 -0400
Received: from mail-oo1-xc33.google.com (mail-oo1-xc33.google.com [IPv6:2607:f8b0:4864:20::c33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 14F76C061574;
        Mon, 26 Apr 2021 11:32:30 -0700 (PDT)
Received: by mail-oo1-xc33.google.com with SMTP id e9-20020a4ada090000b02901f91091e5acso424071oou.0;
        Mon, 26 Apr 2021 11:32:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=lHRHIg6eExYOnMdAZ4K798iABqZIckcUExnA1wyVAto=;
        b=BhXBnnF1n04QL7A0i0FcE8tab8KvYiDq31uxOqVCljsStqAqJkY/uTfzxOJNv1owYd
         xUjBzksdanQOf8eXGp+jJQ9sjt1in3t7IqL10k2XEHicGRP4jjLAsyqcN2g47042nxpN
         u+3aAViwieX02kSc6MpDa+Tfh/dJB6bdZGknaQgX3hj4G8daNlaSpIP9+7fln4cv0gWg
         4AkwHxp60LYT8PsBXh93+NhJyKwgQU1Ma5HSVPkBWwFPJm0xA0NMPGrpvKbrUMMr7jIV
         7B1O0m2ZEpYN0kuxMFBBbhZ8IkeDaF4C4yuV6bkKDmyifQYn7o2KGijU/g00YHQkqlAb
         PsZA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to:user-agent;
        bh=lHRHIg6eExYOnMdAZ4K798iABqZIckcUExnA1wyVAto=;
        b=FtCkm/ylBT1UwZTSTlbmHUFhIz0ewMrlqbja8T/9IWEXZBcSNcLAkiwJoJh8NBihoN
         VgfcIR74KoHVNX6ghxwQjZhRU8t7nGX0SkMHujNLY/BDMezFFFr9/nMohzOZnD8jP2Qi
         WeTF6oRkEBvOyuT98cJhkG00qAVs0c7lkPlOxT4ga8Mokysr8EDtdOxso3UPn+WehIuu
         8Pcf4NiZv1zCIVeRAchD8AdvZpTe6GReFRnlwr84pC4F8yQhcaTPJBLPQxneH1b95O2g
         rwfidkwN3n/3f+0MDaF+T5nB14aF+yPf9LZaisAMx1JcZhf8AXSDGoIBNK/k0+k40Oe8
         PSCQ==
X-Gm-Message-State: AOAM531jXJM6IOiE2AurNLX6jjTibMy4dBcDvL4HHDHcOus/2R2qGer6
        FCrmCxETi5t1RxpHcFFhn3g=
X-Google-Smtp-Source: ABdhPJzW2YHDLFch//i7PL5jxpQ/qG+5K5gNn6fb6Km/gCrr/1aSzBm9mvUtnPytsOZYtarEBrN/nw==
X-Received: by 2002:a4a:dc84:: with SMTP id g4mr14571207oou.24.1619461949511;
        Mon, 26 Apr 2021 11:32:29 -0700 (PDT)
Received: from localhost ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id z123sm158698ooa.7.2021.04.26.11.32.27
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Mon, 26 Apr 2021 11:32:28 -0700 (PDT)
Sender: Guenter Roeck <groeck7@gmail.com>
Date:   Mon, 26 Apr 2021 11:32:26 -0700
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, stable@vger.kernel.org
Subject: Re: [PATCH 4.4 00/32] 4.4.268-rc1 review
Message-ID: <20210426183226.GA204131@roeck-us.net>
References: <20210426072816.574319312@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210426072816.574319312@linuxfoundation.org>
User-Agent: Mutt/1.9.4 (2018-02-28)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Apr 26, 2021 at 09:28:58AM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.4.268 release.
> There are 32 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 28 Apr 2021 07:28:08 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 160 pass: 160 fail: 0
Qemu test results:
	total: 329 pass: 329 fail: 0

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter
