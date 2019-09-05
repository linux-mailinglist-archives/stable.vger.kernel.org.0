Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 13D45AAC54
	for <lists+stable@lfdr.de>; Thu,  5 Sep 2019 21:50:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2403967AbfIETub (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 5 Sep 2019 15:50:31 -0400
Received: from mail-io1-f68.google.com ([209.85.166.68]:39948 "EHLO
        mail-io1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2391509AbfIETuU (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 5 Sep 2019 15:50:20 -0400
Received: by mail-io1-f68.google.com with SMTP id h144so7501392iof.7;
        Thu, 05 Sep 2019 12:50:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=m0NtsRxeuK1+l8toJgXjCUzorXMC0p0PoCXPP7s64bE=;
        b=aPkfZ/ro6nm5G8OA3TvPBAPJ3If/AwjZ31fFqZblCq0YviXO1Yd6xiH3lIaAjDGnXk
         oRbiJeCQpczUTneO1hWN+iiKz4b1VU7ymFchKhHzxwHR7/zRRcLaPA3MuIWq+xnlLVsI
         U3AITEvbg3YgxGkmvM44DKr7i8U1Q7FJxN8OVU3lWaD8HIyktVBrJ2j3AsTYLD9davZ9
         cEspVGwDBZOGIQdeU4tdhaXkSGwzaj8lCwZPaSa14Ih7P093bkIdLawy3WnrcQBHUJap
         +eGBeGJkLowAl2dMZY/MsqzDc7cH11ixLDswqSsTix3Nh05BFo/S++xOUkGBt+izLNC1
         hNPw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=m0NtsRxeuK1+l8toJgXjCUzorXMC0p0PoCXPP7s64bE=;
        b=fRb/3kBaB1grJx3hbcZFTrr3weeKghCuDXXq/KbOEuYEjZ53PNEhIj8P5gTmFadFtr
         P5Vf+e2Na+OQioKdfhZK7r+hnMQXlKxZnPzB3zOfm2XE05cpiKMLkOcWBbnRcqka7ylK
         3T2x+pQEYNxkXX9obEqiHpjT29z2TI/ETpQh6Fzdj08X9zelB5+ZP46gbJ5hIYiCK0LT
         tto6cMHOZdFRzcLgra2/JdoBHVSXZVqXXPkOoFREvLS4L3NSEBio/ym9M3QDYdR7YLMT
         buMdrwsC6ZZVMK8Rv/o6l7njxS0jUMa1ZDBB84JbxMmeuu37VyqcDepBlBM9vrIWMznq
         2h/Q==
X-Gm-Message-State: APjAAAUc/JrqO8nHOK+pexImr9/Rr5RhN4ARhRVnSY9VDzP2QwyD/hZ9
        E31TuVG74mbUjz3pxi49qZU=
X-Google-Smtp-Source: APXvYqyyW3qMLfOYq8S97IamK8vrqK14u3FJjP0cM5OOKHN9MFM7rxiDvK7D2Lce5ekw6xXd2R79yw==
X-Received: by 2002:a5d:9342:: with SMTP id i2mr5838470ioo.297.1567713020057;
        Thu, 05 Sep 2019 12:50:20 -0700 (PDT)
Received: from JATN (c-73-243-191-173.hsd1.co.comcast.net. [73.243.191.173])
        by smtp.gmail.com with ESMTPSA id l21sm2092513iom.24.2019.09.05.12.50.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 05 Sep 2019 12:50:19 -0700 (PDT)
Date:   Thu, 5 Sep 2019 13:50:17 -0600
From:   Kelsey Skunberg <skunberg.kelsey@gmail.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, ben.hutchings@codethink.co.uk,
        lkft-triage@lists.linaro.org, stable@vger.kernel.org
Subject: Re: [PATCH 4.4 00/77] 4.4.191-stable review
Message-ID: <20190905195017.GA3397@JATN>
References: <20190904175303.317468926@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190904175303.317468926@linuxfoundation.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Sep 04, 2019 at 07:52:47PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.4.191 release.
> There are 77 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri 06 Sep 2019 05:50:23 PM UTC.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.4.191-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-4.4.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

Compiled, booted, and no regressions on my system.

-Kelsey
