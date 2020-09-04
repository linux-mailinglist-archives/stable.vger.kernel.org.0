Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8098325E1ED
	for <lists+stable@lfdr.de>; Fri,  4 Sep 2020 21:23:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726406AbgIDTXZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 4 Sep 2020 15:23:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49230 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726221AbgIDTXZ (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 4 Sep 2020 15:23:25 -0400
Received: from mail-pl1-x644.google.com (mail-pl1-x644.google.com [IPv6:2607:f8b0:4864:20::644])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D408FC061244;
        Fri,  4 Sep 2020 12:23:24 -0700 (PDT)
Received: by mail-pl1-x644.google.com with SMTP id c3so1346690plz.5;
        Fri, 04 Sep 2020 12:23:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=jo2LrNWEgpQNYtSAG1LE6gXG+UXK/dBbbm524XiWLvQ=;
        b=BH4oPuFdRexT4P8uDX741Yv/+sZA1vdnpjjln90GMw7atpftoe+93ct8XXeIcVCnwd
         sffSx6PBIsTefeSul8A8gg3h4zqNOortt3F/rFE+Z2mnfE9N2bm0WATpviihAjfEeWzf
         8if2Ss1IWb0KVD3DsMyDI0o8W1r0yb9JHpmrz/884/leu8QAgCp8oDQt0Htz9mnleZLv
         amizuo9mokRE9NCabAnnDkfrtb+N0IOovgMzMLERhQFJeV7nkVn/ekY6hfm2cyvGD4D0
         FB5MbNAtRC/bxphvLNRSSz3eqc72rNqgUYkbh0YliNCUSbfHyrT2pHdMJSaUgXesRKF5
         zNFw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to:user-agent;
        bh=jo2LrNWEgpQNYtSAG1LE6gXG+UXK/dBbbm524XiWLvQ=;
        b=uJ/lzd6L/YtfPpQYCFWj4pVnWpjYdYDihov9eHxs3NkvD/x1h1GnakpadyEGPIX315
         N77ZG6PkFNijswwbcUAz5ZlYSvzldpLlu3fM7niFc5vgH1722GYQU3LLTTL5XcYYI1/l
         yjXqK4lDxr9KH3j6+Kz1fDC4w4SMbagE6KhY0KHGvEBvw8ityOgpXdqCcrkVyRV2CW2Z
         onpJV1HBQO3Jo+OAG2mef9prYo13ECqb9g/8cFzS3CkACik4nuzZpfWW7LHsAro9puxw
         WHINH/vqcmOUpokqTXJHehDLM6uz1R21sCEZtVERIROBD3Y7xXSBleVsi2QCYBVELa4R
         WnWw==
X-Gm-Message-State: AOAM5339ha50eqlmX8H2r0I1e8Meu34Y2mJv2Zs2aarTTEaxIt4+VB1x
        FCQRq56aJ741K6rOJinXRYg=
X-Google-Smtp-Source: ABdhPJy+ubz9CdiTuEnQdhUjSGxr2R/t9AssWYIt5Ekmo+hyYet5x2rhHoqXjQk2TZbZDJ2pcxszvg==
X-Received: by 2002:a17:90a:9503:: with SMTP id t3mr9571333pjo.171.1599247404237;
        Fri, 04 Sep 2020 12:23:24 -0700 (PDT)
Received: from localhost ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id l78sm187272pfd.26.2020.09.04.12.23.23
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Fri, 04 Sep 2020 12:23:23 -0700 (PDT)
Date:   Fri, 4 Sep 2020 12:23:22 -0700
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        stable@vger.kernel.org
Subject: Re: [PATCH 5.4 00/16] 5.4.63-rc1 review
Message-ID: <20200904192322.GA211974@roeck-us.net>
References: <20200904120257.203708503@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200904120257.203708503@linuxfoundation.org>
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Sep 04, 2020 at 03:29:53PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.4.63 release.
> There are 16 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sun, 06 Sep 2020 12:02:48 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 157 pass: 157 fail: 0
Qemu test results:
	total: 430 pass: 430 fail: 0

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter
