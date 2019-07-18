Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DAB066D61F
	for <lists+stable@lfdr.de>; Thu, 18 Jul 2019 22:57:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728032AbfGRU5w (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 18 Jul 2019 16:57:52 -0400
Received: from mail-io1-f67.google.com ([209.85.166.67]:43767 "EHLO
        mail-io1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727781AbfGRU5w (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 18 Jul 2019 16:57:52 -0400
Received: by mail-io1-f67.google.com with SMTP id k20so53858483ios.10;
        Thu, 18 Jul 2019 13:57:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=ePNCI820lghtKksPpKcrFA4V7bC23W5Wd15/YvQXqbs=;
        b=RAmZz6OYXZjuED5313v1Vl9yPTC83ni/NTpRtEOYaYTnNiUguJ4cYdMLxYBmwIQIwR
         jqze+U15rZ7j0cp4X1YKOtnE7xvidsUnPYV28flovyOE3ZuU/+fEf+kZx+Ytyw/3rilL
         BZHuSjG3S+pAuFyWAL2mITtyEekoJpWCQBjJHa88v8QWOHASA1Csr+gSgaB/RhF9nA+P
         AuBn0t1QDez0zyUXH1zrOxwiwShgDFs44ng3T8NEUHb+Zv32+DLFJsJ0gF0+797sCu4u
         cXPeTJvOlYjLgnfwDt2YOjnmwQ9DHQbiEe8+qooPNRVmuzSl9Gn8fNqhB8MxXhfIn5kA
         HFqQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=ePNCI820lghtKksPpKcrFA4V7bC23W5Wd15/YvQXqbs=;
        b=fk25DWuMOzCyi6EedC5xVD/Sj2fQEyDzN6ik1Miuso8mMQ8jErxe35Cv9bSMRdfC+7
         gQTlp4y550ToDLqOgo66u7Y3zOz4hSYYLFr14Mpc0Ut06pLD+/Ko2prZDU0Ed3OwLKJX
         pMFiJIekAaPu8u3JF/X5tCWYeoInWbyLGt3+xFk7X2PlNEGDwFO1W5/dBN94tnH2J833
         kT0ceU4UpImytbtw6JEoXYSsvT4aNdbfnb2WTW3g6zY3s/ocsNjzPoaPXSzfzR4pPd4d
         4lVimz0f0J3TmvujLhcvTDRhxj4IgcmNf+WCJo9aDsDYgaZFeimWpyd96MPpBh62ShDC
         L6Pg==
X-Gm-Message-State: APjAAAXHdL1iwXkl5+56xaoyDKpqFhFWKo1C9gYFaSOEUZqSthD9z0dG
        mpTG9BKIT2qym2T+zrbZRYk=
X-Google-Smtp-Source: APXvYqz/KSrnQr2133GIWXoEX7Dw6CeOnG9MNN6J7Pp714iH2qo1ADP0WDD/4k5uIshsHMxCOq7mYg==
X-Received: by 2002:a02:9a03:: with SMTP id b3mr52174334jal.0.1563483471337;
        Thu, 18 Jul 2019 13:57:51 -0700 (PDT)
Received: from JATN (c-73-243-191-173.hsd1.co.comcast.net. [73.243.191.173])
        by smtp.gmail.com with ESMTPSA id m10sm47441334ioj.75.2019.07.18.13.57.49
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Thu, 18 Jul 2019 13:57:50 -0700 (PDT)
Date:   Thu, 18 Jul 2019 14:57:49 -0600
From:   Kelsey Skunberg <skunberg.kelsey@gmail.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, ben.hutchings@codethink.co.uk,
        lkft-triage@lists.linaro.org, stable@vger.kernel.org
Subject: Re: [PATCH 5.1 00/54] 5.1.19-stable review
Message-ID: <20190718205749.GE6020@JATN>
References: <20190718030053.287374640@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190718030053.287374640@linuxfoundation.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Jul 18, 2019 at 12:00:55PM +0900, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.1.19 release.
> There are 54 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sat 20 Jul 2019 02:59:27 AM UTC.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.1.19-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.1.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h
> 

Compiled and booted with no regressions on my system.

-Kelsey
 
