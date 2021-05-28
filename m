Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1F2E9394611
	for <lists+stable@lfdr.de>; Fri, 28 May 2021 18:51:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236540AbhE1QxL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 28 May 2021 12:53:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36828 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236722AbhE1QxD (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 28 May 2021 12:53:03 -0400
Received: from mail-wm1-x32b.google.com (mail-wm1-x32b.google.com [IPv6:2a00:1450:4864:20::32b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DB58FC06174A;
        Fri, 28 May 2021 09:51:25 -0700 (PDT)
Received: by mail-wm1-x32b.google.com with SMTP id 16so2473655wmj.5;
        Fri, 28 May 2021 09:51:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=VeH55SqKcgEvNH7a6J6PaexwuGotGkZufPQW7i3JWWI=;
        b=Z4jsWc1Ck75LtSXwagXRc+fAqCWfIhmsPbzF5nW+0iumpZt6ZUVOoMtjLmIoxO9Cg6
         ixnQNSl0mEx1LYB5q3m6ZAmYWiOghhncmgQPiwRSVt85cHHDMD/J2Txrs7kjhBKgd60o
         Kx/QUMs3KxwkmwnYnE7WazqfO2z98qpPiYi1TESEv7zHL70y714D++f9sJbXPXXSPeDj
         DVmBL3E++6TuVoF1XNL8t5ndveBPaar/r6QACwAtpJo0fDHcGhOhuRIFSYgCsa+LnhOS
         EzlbfF/+/Wr8GXFyt5ErScD1pl4FB0WrcKwf5WaCFoT/CFwAooWIBRbX1Gm15xHVjCCu
         MlSA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=VeH55SqKcgEvNH7a6J6PaexwuGotGkZufPQW7i3JWWI=;
        b=KO2JFTEzeWqjAO4DcRDCyEp02fOKo9nvgQLJlMX6HB184URczoNzF8HFvvIRZ20wUp
         pbfx26OTudo2bo5VCt7kxuACygAn07AzD5NSKPqJ8pSj2B61aXdWfan1Nky5G8hl/XOS
         IYQk822NlTwNcYRadz26tYbFYfE7w8aMAlYA7WtSAxcC5AV2D/TC2wnTzQ46WHGryhme
         ct1t1IGl4QJ4pP3LaXIEMqEzR0Th4/0i8IuYpO20IWllLcP29QlzYpLlSCgYM1H7nZVZ
         CTESrbDKOuP1Fa8Kk6TX3hHHJnBwwHmBMX2rbVWWKCwRA8vPBC2qBlC6I8JdDwbhAtZs
         CNmA==
X-Gm-Message-State: AOAM531hDcSwAR8JbWGwckMRxUkFEA6lLMdNrY+G72dUTTz60UPAC51P
        1bFSmoGFR/0pvFrWh/Hb1EO2sFpvzZ+srA==
X-Google-Smtp-Source: ABdhPJwI9u7zjZFlf2J5ISZl7yoErItXEC9NJNhOydsNGnCeBDF4sCAvrGI/0LVB2PZvfuQbTWODaw==
X-Received: by 2002:a7b:c114:: with SMTP id w20mr14965773wmi.45.1622220684495;
        Fri, 28 May 2021 09:51:24 -0700 (PDT)
Received: from debian (host-2-98-62-17.as13285.net. [2.98.62.17])
        by smtp.gmail.com with ESMTPSA id c6sm7617869wrt.20.2021.05.28.09.51.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 28 May 2021 09:51:24 -0700 (PDT)
Date:   Fri, 28 May 2021 17:51:22 +0100
From:   Sudip Mukherjee <sudipm.mukherjee@gmail.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, f.fainelli@gmail.com, stable@vger.kernel.org
Subject: Re: [PATCH 5.10 0/9] 5.10.41-rc1 review
Message-ID: <YLEfirRcvJ0HGNDH@debian>
References: <20210527151139.242182390@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210527151139.242182390@linuxfoundation.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Greg,

On Thu, May 27, 2021 at 05:12:52PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.10.41 release.
> There are 9 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sat, 29 May 2021 15:11:29 +0000.
> Anything received after that time might be too late.

Build test:
mips (gcc version 11.1.1 20210523): 63 configs -> no failure
arm (gcc version 11.1.1 20210523): 105 configs -> no new failure
arm64 (gcc version 11.1.1 20210523): 2 configs -> no failure
x86_64 (gcc version 10.2.1 20210110): 2 configs -> no failure

Boot test:
x86_64: Booted on my test laptop. No regression.
x86_64: Booted on qemu. No regression.
arm64: Booted on rpi4b (4GB model). No regression.

Tested-by: Sudip Mukherjee <sudip.mukherjee@codethink.co.uk>


--
Regards
Sudip

