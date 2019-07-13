Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3670B67BED
	for <lists+stable@lfdr.de>; Sat, 13 Jul 2019 22:38:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727983AbfGMUiF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 13 Jul 2019 16:38:05 -0400
Received: from mail-lj1-f195.google.com ([209.85.208.195]:39900 "EHLO
        mail-lj1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727961AbfGMUiF (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 13 Jul 2019 16:38:05 -0400
Received: by mail-lj1-f195.google.com with SMTP id v18so12483174ljh.6
        for <stable@vger.kernel.org>; Sat, 13 Jul 2019 13:38:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=eng.ucsd.edu; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=tXKppyFkV9Cu+XvMRsRi85se3HOSY/fflJyKkgfBWtM=;
        b=Mx5Gw4dddXxtC2/af8XThgO1MZShGZv7qQNFe/lh95wWlkkzxgE9Ky+mdotdQV8PqP
         OEoFs1mOPB/CrfF7TDNPkPYou6fZhHXUj/SkWPBrC1QZLROOmawDQEY3Nom+z+EXbiDj
         rA10hLjvaJ2vvGCsSPJngm93bSVq6NMhz2c/s=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=tXKppyFkV9Cu+XvMRsRi85se3HOSY/fflJyKkgfBWtM=;
        b=YAtvjg6sJJfsMjPRvYVx4lvS8V+bzt9rNq4R8Uu1n3sniL/NCDFtWeq3Rm7xuh8bZI
         gaSkaFwiZyS6qylBwUfKOlvkrGSQyZiJ9mxpSwvkzWAvkXyxsJn5RUspV5QCywd+lb5/
         mkktF4oPaTxDpasHlLk5CLw06Fn0SsDapaMfLKuNA+o4wd9L5JF5cQP91pxBnWedpkj3
         6W0u2dODoFUX/yJJiUKgZ9AbUoTgJVp7FqiSvjnE/JaL6ZlIhHRt1iAPmGG5pLmuSXem
         tIkNXI04wSW20fUhmRIT1CGorAEQhcf5fBxG7vlE+JWgGVo7zfAyX+GSVWYwSp9UK9f7
         rgSg==
X-Gm-Message-State: APjAAAWJuA2KV8hNtYEJ2SxNo+IJHjPSHbAzCjhGhdLXA+hrunsOzYvx
        YOZsYvEDnKk5C7OX2lVQo2SlnA==
X-Google-Smtp-Source: APXvYqw093/1yZBjhnueyOmkc4lybKjFiHYF0zmbyYKXZOTEDt0yLp05kHaXe5KkExRYobtaXiCZog==
X-Received: by 2002:a2e:8744:: with SMTP id q4mr9333872ljj.77.1563050283137;
        Sat, 13 Jul 2019 13:38:03 -0700 (PDT)
Received: from luke-XPS-13 ([213.146.33.133])
        by smtp.gmail.com with ESMTPSA id l11sm1810470lfc.18.2019.07.13.13.37.57
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Sat, 13 Jul 2019 13:38:02 -0700 (PDT)
Date:   Sat, 13 Jul 2019 13:37:51 -0700
From:   Luke Nowakowski-Krijger <lnowakow@eng.ucsd.edu>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, ben.hutchings@codethink.co.uk,
        lkft-triage@lists.linaro.org, stable@vger.kernel.org
Subject: Re: [PATCH 5.2 00/61] 5.2.1-stable review
Message-ID: <20190713203751.GA14762@luke-XPS-13>
References: <20190712121620.632595223@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190712121620.632595223@linuxfoundation.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Jul 12, 2019 at 02:19:13PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.2.1 release.
> There are 61 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sun 14 Jul 2019 12:14:36 PM UTC.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.2.1-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.2.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h
> 

Compiled and booted on my x86_64 system. No dmesg regressions. 

Thanks, 

Luke
