Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 80F5FAAC6B
	for <lists+stable@lfdr.de>; Thu,  5 Sep 2019 21:51:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732567AbfIETvY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 5 Sep 2019 15:51:24 -0400
Received: from mail-io1-f66.google.com ([209.85.166.66]:38274 "EHLO
        mail-io1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732081AbfIETvX (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 5 Sep 2019 15:51:23 -0400
Received: by mail-io1-f66.google.com with SMTP id p12so7548337iog.5;
        Thu, 05 Sep 2019 12:51:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=lyT6YuOmLituwU2N7i+W9QW0JEtw/N4RH9huVkG7ZMI=;
        b=eGrbQM6dD97fdoUWq3X0vlcpzjL/N3GTrDHeCY6ie0OQrFMDcGNqJy+IKlHCsEhlYD
         LCyF5sa3KY2kvhlf3t+qf0LBWb0Y8GMFis+nJBKEkgetGb3aWqSI2OocKXuenc2pQ0UJ
         gnTXfabyfgGaI+1zdgedFRYgZ/+6YU0mgVvkIpx3CGDsuUBPwBUWZS7kG6Cjowc4FzPT
         hh9c/7+iBvLfoaSMtdBerR6Mxm24HprRBKp/Eilw8OB2+pwd/89cvtVc2aTQT4wWVpq0
         Jg2Fu6mD9PlA0HDilwGqhuHh1g9dPXy08Az2al68LtxQ08gPToDeP3woQJgMWw8Q1LnX
         02WQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=lyT6YuOmLituwU2N7i+W9QW0JEtw/N4RH9huVkG7ZMI=;
        b=pS3zvrcAcFcifXX71dCdvsJyfQoP5/2JT4qRM/zyay8o15b4SdixfkwuZIUbjsp88i
         0SzmzjHwiWxNJhZmw3g6aKwidn9AjuXdBB3r43X9FfycEas+Q9xE9GjVh8vJuKXvK8j2
         /SIBpHrMzHRNrC3sizN8p9weH3i/0oiXeG4boArY2malad97LNm+X3BfOSG/lXFSd5gf
         Wtfg45UNCImEHg1fTE+t/ZNLG1Fm1/2ajQx8tyFU/js7x+7F1pj15o+v8P4CkGNQJ4Nj
         6nRbf0mjckiljidlRhSCQbgSEDseo8G2Kb/eVPQoKQ3FVdroMM03urnp/zhFP7WKQilQ
         zkXQ==
X-Gm-Message-State: APjAAAWkDNt4BmyF3N/V/BooL8IDRCWMWhPeCWjvnxuHtNaCRUy6KAat
        c6+1ZrVLVCd9k0nPQanQKkg=
X-Google-Smtp-Source: APXvYqyvaf9TjsGptibp/pz+iWmCQ3Io3TRfB36QINya5dhg6MAXG7o195lKDTMsOwKakP0m4eGnPw==
X-Received: by 2002:a5d:89c1:: with SMTP id a1mr5841295iot.306.1567713083218;
        Thu, 05 Sep 2019 12:51:23 -0700 (PDT)
Received: from JATN (c-73-243-191-173.hsd1.co.comcast.net. [73.243.191.173])
        by smtp.gmail.com with ESMTPSA id k17sm2585093ioc.30.2019.09.05.12.51.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 05 Sep 2019 12:51:22 -0700 (PDT)
Date:   Thu, 5 Sep 2019 13:51:20 -0600
From:   Kelsey Skunberg <skunberg.kelsey@gmail.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, ben.hutchings@codethink.co.uk,
        lkft-triage@lists.linaro.org, stable@vger.kernel.org
Subject: Re: [PATCH 4.19 00/93] 4.19.70-stable review
Message-ID: <20190905195120.GC3397@JATN>
References: <20190904175302.845828956@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190904175302.845828956@linuxfoundation.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Sep 04, 2019 at 07:53:02PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.19.70 release.
> There are 93 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri 06 Sep 2019 05:50:23 PM UTC.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.19.70-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-4.19.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

Compiled, booted, and no regressions on my system.

-Kelsey
