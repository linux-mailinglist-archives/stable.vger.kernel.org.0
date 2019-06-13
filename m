Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6540444D07
	for <lists+stable@lfdr.de>; Thu, 13 Jun 2019 22:08:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727059AbfFMUIv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 13 Jun 2019 16:08:51 -0400
Received: from mail-oi1-f196.google.com ([209.85.167.196]:39513 "EHLO
        mail-oi1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726551AbfFMUIv (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 13 Jun 2019 16:08:51 -0400
Received: by mail-oi1-f196.google.com with SMTP id m202so294774oig.6;
        Thu, 13 Jun 2019 13:08:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=S+rn+qRO+LubHbImJc8sQ6OUovsePfdG7zWxutbSvrM=;
        b=lQKtRHD+Y+Oukze8lK4XSnxKP44nypu9Z5VDv9ad93tgN8dfbT+ir47OA7EIuHwbyi
         c+Xe2lhOeLQbJOTGcdsRAfcFaCIoChROiJ/IAcRRDTs3/lFo4QY940+/4Q3mo8RukJTH
         z55GZLmG3mFLu5EBa+iIeHrxWOOR77uffZt4EQbGdg6FEiXVN452oX5Wx+i9V9Y+axf0
         SBcSCp5pQfsqrRKXGs7ekzCUHdGz+I8e8HpNY4sN+5nL+eldFmzVbOE/gQQloKQvuu7H
         JJqiAhEmjAnwtqTjeDnDeNfY/V2Z4SXfndetJvqvqTZ5NGR0l3GACdpqzo/lQUMPB37A
         Z4IA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=S+rn+qRO+LubHbImJc8sQ6OUovsePfdG7zWxutbSvrM=;
        b=omlbl8+HV/hnU/CSqEAn9joykbF0R6PxiWyFCYFNC9vEUaxwct0BVuXrIhhG7uAvXp
         oVidTsYbi6a8CGeGaW81OMBKMP7S3zlPMG83moXaTaHiafRjVVR+8ff7Wspqje/xjjfK
         czZlCbn/On+CFytQwsQEcYrN25ot2JyI7+12oeMRKjr1l46wq0LDFL8HJ2nJcVhcu2js
         HZAva9+lXAo2H1wsGNLfrkbD2ZQBF8RL0q5BLstlI5ZxcNuMuSyMqEC2LsTKk1D4CE82
         b50Tp7Zv8Qdfn1AIiSl3f32KkckyBZVOO+00MB4bfzMtzvD62OSOjtXvllG0Df/dzBUT
         HyHg==
X-Gm-Message-State: APjAAAUOKTYCIUblNJ2zc4rxtgnRm1ImYS7UQjKUygg1cMThdAAAIEsd
        IByWKUlNkS0KB6fsiO5CliDH5UQa
X-Google-Smtp-Source: APXvYqzm/4ssKGKYp7L4QegaZIxHYhy8SN8hNPuQVOTV7ALoFK9EsoVvFI8YDftSWegecffWV2W1EQ==
X-Received: by 2002:aca:ac48:: with SMTP id v69mr3952706oie.48.1560456530644;
        Thu, 13 Jun 2019 13:08:50 -0700 (PDT)
Received: from rYz3n ([2600:1700:210:3790::40])
        by smtp.gmail.com with ESMTPSA id o32sm367028ota.37.2019.06.13.13.08.50
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Thu, 13 Jun 2019 13:08:50 -0700 (PDT)
Date:   Thu, 13 Jun 2019 15:08:49 -0500
From:   Jiunn Chang <c0d1n61at3@gmail.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, ben.hutchings@codethink.co.uk,
        lkft-triage@lists.linaro.org, stable@vger.kernel.org
Subject: Re: [PATCH 5.1 000/155] 5.1.10-stable review
Message-ID: <20190613200849.veuc5crfejlcepgh@rYz3n>
References: <20190613075652.691765927@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190613075652.691765927@linuxfoundation.org>
User-Agent: NeoMutt/20180716
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Jun 13, 2019 at 10:31:52AM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.1.10 release.
> There are 155 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sat 15 Jun 2019 07:54:40 AM UTC.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.1.10-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.1.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h
> 
> -------------
Compiled and booted.  No regressions on x86_64.

This is for 5.1.10-rc2 from git --no-pager log --oneline -1.

THX
