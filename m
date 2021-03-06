Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3A86F32FBE7
	for <lists+stable@lfdr.de>; Sat,  6 Mar 2021 17:30:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230329AbhCFQ3Z (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 6 Mar 2021 11:29:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57796 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230216AbhCFQ3U (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 6 Mar 2021 11:29:20 -0500
Received: from mail-oi1-x229.google.com (mail-oi1-x229.google.com [IPv6:2607:f8b0:4864:20::229])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2DEA6C06175F;
        Sat,  6 Mar 2021 08:29:20 -0800 (PST)
Received: by mail-oi1-x229.google.com with SMTP id j1so6209588oiw.3;
        Sat, 06 Mar 2021 08:29:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=9jwT9U90LFDaFnTNBBjDuWZoivncPcPASfaho+Z03+U=;
        b=J2ne/afTvjLdlU3TNXlOR++efBToq8RJwxBCk3lZKwnkEeZXcnjg85u9a9Y5E0pPEo
         4bwQlOzFbyQosSBCUErurL1JIltQrpm3fI/KQc+mKfO3ALRuOz9ppOvBmObHr1GjBNb5
         hriQXrbHwrC1bAdimXU1uZ9J85nCF3ft+ruPPCdglhC6AHhtghXLXX3xApOIEMBnyYjN
         9dTopVohRyYRSAPpLTwR9dNDqgQWvnBDPnWG1AnyWhF+Zixh2DQODQwCDPkmuO6Xn+4u
         gUvBFcAtXU0m14gwQy25uWT3YnBOorqOr8YWEYOZgFtoQ6gFvKiD1KQV+moQob5ZfJF9
         zT+g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to:user-agent;
        bh=9jwT9U90LFDaFnTNBBjDuWZoivncPcPASfaho+Z03+U=;
        b=rXmfxRLLJ8oGiTkZ3wOQZogVwO2lCMp1Jmm+Y6f2UN1fRxCnV5HNIoWDQaxs76wnab
         N1zptrNUf8Qp0/aPWdV9A8u9qdxmbbavZw6556bbuzYSfxV645f+jZBk/GP2o0s2Nlj2
         H7heptAQuoPpBDrl8pZ4PdORUYA0cQHdNzL6ny/blmcA2YDduBhVOOQ6MXnTk3ji7D+r
         B6KhknivDcTRtEl9M5+XaNjCMjUTQvGjHuD7t8HqokTh1ZnAvE1ZNmeIVPSooO3rF6me
         D4N6169xmOCzGxHz3V9UwEp8juNEDJH6L3RH7GWoSPz5yDg2WkWXC6etrUL3YbCMzqzr
         IUyw==
X-Gm-Message-State: AOAM5311tns2eQbdGv6xiOIbeB2Ual9CSrS4+u7v8LBKJB7rDPS9+olH
        yTQqONWpxcUOQkR2B5ExHsk=
X-Google-Smtp-Source: ABdhPJypuQfNymmZrCp4b6wyKm9EU9oR/ZnrqN85toRc4KptkO/59p4tT1qCKlS1bS+4sVT+7UQwdA==
X-Received: by 2002:aca:908:: with SMTP id 8mr11548988oij.80.1615048159667;
        Sat, 06 Mar 2021 08:29:19 -0800 (PST)
Received: from localhost ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id n20sm1430183otj.3.2021.03.06.08.29.18
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Sat, 06 Mar 2021 08:29:19 -0800 (PST)
Sender: Guenter Roeck <groeck7@gmail.com>
Date:   Sat, 6 Mar 2021 08:29:18 -0800
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, stable@vger.kernel.org
Subject: Re: [PATCH 4.9 00/41] 4.9.260-rc1 review
Message-ID: <20210306162918.GB25820@roeck-us.net>
References: <20210305120851.255002428@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210305120851.255002428@linuxfoundation.org>
User-Agent: Mutt/1.9.4 (2018-02-28)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Mar 05, 2021 at 01:22:07PM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.9.260 release.
> There are 41 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sun, 07 Mar 2021 12:08:39 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 168 pass: 168 fail: 0
Qemu test results:
	total: 383 pass: 383 fail: 0

Guenter
