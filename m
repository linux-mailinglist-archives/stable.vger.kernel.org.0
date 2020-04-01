Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3C52319A305
	for <lists+stable@lfdr.de>; Wed,  1 Apr 2020 02:43:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731548AbgDAAnM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 31 Mar 2020 20:43:12 -0400
Received: from mail-qt1-f195.google.com ([209.85.160.195]:33438 "EHLO
        mail-qt1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731541AbgDAAnM (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 31 Mar 2020 20:43:12 -0400
Received: by mail-qt1-f195.google.com with SMTP id c14so20290165qtp.0
        for <stable@vger.kernel.org>; Tue, 31 Mar 2020 17:43:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=massaru-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:subject:from:to:cc:date:in-reply-to:references
         :user-agent:mime-version:content-transfer-encoding;
        bh=29l1Cx3EQRTg+9C3FuFocy47P0Q9W5pPReVeNSwur6o=;
        b=RWI+XKWfSaDXusY29+11maE3rke9eaax5k1NXL5V9s98nlLQhJPNZ2LnX2kCDNSbFK
         GGEqZ3xA9w34hAVSlAySVBdYgSLzJPzitgoYCw2moesOic+Frdo4IM1fs2gszhJyJllw
         dCGmFewutA47Tm/igpqUDGnir/3efzX6vIkAX6O4zsQbbrXLLquizZDKw6Uk76Boe3zU
         vKuNi0JYie6zKdtWajostEv0sbOV3Ny/W+WOzH5GXP51U3bAEZ8kbGfPPLJyQmkX4+j8
         9EXLT2JSRXvuw/cvedQKJK8Gd8Hr/lkohg8/CyqTajxurMpQKGLWx0qorUnnEoKNr1DS
         C8Cw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:subject:from:to:cc:date:in-reply-to
         :references:user-agent:mime-version:content-transfer-encoding;
        bh=29l1Cx3EQRTg+9C3FuFocy47P0Q9W5pPReVeNSwur6o=;
        b=VjGCNOEkwoDqa/2CmOC/lfiEEmiwC4iyBv7VcCUfxdwPCr+Qpl3e+F7fIY7PdW+kSL
         LvApTFdbsj0SoRoH2CnJIm10Qq+kUlynwFi9fJF6tR0FG+RHO/+HMb70AMWHUmgkKhu+
         3T5BD13I1GCo6HwwGyduEHG87t8XTTsOf7jgtRb6wy1AL0cEeYOoYSBCrdwsQVVK7zWM
         gY2uAYkwjo/r608tdRvZ+0rCQgltYHYwqrKO3L1wHc9uCq3YDWh0+/h3CLe1MTXiK5Oz
         FdGWvfH4ye8ydhh7t1DppHA3tDdYFbjBNkEq/qyxiTZH2nz2LKH+r3cjHD/wKfoxVAwu
         NItw==
X-Gm-Message-State: ANhLgQ0aHhrp/ZTrwcLtAp0URYHOaP35g1E+36QrPso080fJTW8lsOe8
        uGZg7n+U65m7tv6qWQhzXgxX70i7uyobDw==
X-Google-Smtp-Source: ADFU+vsa9O48OZ0BTiH0JIAZqbnWZeB9KY6uad99GDtbM5YxMPs8wVGAqMTdKHx3aP9ZXRMIqGiC3g==
X-Received: by 2002:ac8:2d88:: with SMTP id p8mr8191570qta.346.1585701789565;
        Tue, 31 Mar 2020 17:43:09 -0700 (PDT)
Received: from bbking.lan ([2804:14c:4a5:36c::cd2])
        by smtp.gmail.com with ESMTPSA id t6sm430247qkd.60.2020.03.31.17.43.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 31 Mar 2020 17:43:08 -0700 (PDT)
Message-ID: <5ccaf0509d415643338abdd04493a4c6f4a77c9f.camel@massaru.org>
Subject: Re: [PATCH 5.5 000/171] 5.5.14-rc2 review
From:   Vitor Massaru Iha <vitor@massaru.org>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        stable@vger.kernel.org, Shuah Khan <skhan@linuxfoundation.org>,
        Brendan Higgins <brendanhiggins@google.com>,
        "linux-kernel-mentees@lists.linuxfoundation.org" 
        <linux-kernel-mentees@lists.linuxfoundation.org>
Date:   Tue, 31 Mar 2020 21:43:04 -0300
In-Reply-To: <20200331141450.035873853@linuxfoundation.org>
References: <20200331141450.035873853@linuxfoundation.org>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.32.5 (3.32.5-1.fc30) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, 2020-03-31 at 17:32 +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.5.14 release.
> There are 171 patches in this series, all will be posted as a
> response
> to this one.  If anyone has any issues with these being applied,
> please
> let me know.
> 
> Responses should be made by Thu, 02 Apr 2020 14:12:02 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	
> https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.5.14-rc2.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-
> stable-rc.git linux-5.5.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h
> 

Compiled, booted, and no regressions on my machine.

BR,
Vitor


