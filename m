Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 255B6231191
	for <lists+stable@lfdr.de>; Tue, 28 Jul 2020 20:23:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732319AbgG1SXv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 28 Jul 2020 14:23:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43744 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728829AbgG1SXu (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 28 Jul 2020 14:23:50 -0400
Received: from mail-pg1-x541.google.com (mail-pg1-x541.google.com [IPv6:2607:f8b0:4864:20::541])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 415E7C061794;
        Tue, 28 Jul 2020 11:23:50 -0700 (PDT)
Received: by mail-pg1-x541.google.com with SMTP id l12so1371518pgt.13;
        Tue, 28 Jul 2020 11:23:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=rBiETnRNxkjk0nqhNccK0+FfnRDrBJ6SKOVzaBDEMg8=;
        b=HILoJDqDDvb79foj8WWV4moawb7eq3pmvzLZJV7HdRokqDw+I07dR//w4zKpnWOGc1
         aiixtKOovKYWz9hivRkjShdi//5o9lbuvLXufA+HOFZ1KfUqWtFvmNyJmBl57dDeP9UK
         OTcTwKl/uBk/T0BQC7x9XALjk2pAA54URI0b+JIJurTSIR/QaF+xJkzuiIQ4lacY8pPr
         go8h4G70YOtydT+BcMPNZQr0mcQJyOXqkau8vrebkvI0X7GrOv2el613shmT0o6l9fCb
         zYGtaWHgpBDIUXjQQtgcn+0zGi4C14keTl/o8vkwRjjELO7sriBGzJIc+D6PW47mWW2h
         4jKQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to:user-agent;
        bh=rBiETnRNxkjk0nqhNccK0+FfnRDrBJ6SKOVzaBDEMg8=;
        b=XGf4A5tAutJCDCfzCSZQl5Y/ssliWJXFeO836J36Nr37QhmQZgWrD/EE/soVkKalKq
         i8GtUBGl4FeJTe9Mj5VUGRl+DbsXJ7e+WuMRgY6Ci6nf7qJC7me2c/3655PTTpIajJCB
         4m9jxLVofIEg6U2KvXV/mgscnIv9p8HPegCStPIx1c+fStGC96YBm/lUGQYfFtRvUf0B
         20zPNmtWr6JEGuI6aaCC12GIbni97yYI5aTJ2pQsfPGLAaekkc4p6Y2eupI/ULEuQYTB
         QHHQlHgDx5FS0q081FcSUDvXkBGMOf957j/I1+1wLnTUktpsFRZHqTWCdDWiining+Ae
         TuCg==
X-Gm-Message-State: AOAM533RXswX4IGKTYALuEe9ozS3p/FtuZk8JiUVVHcabEJJZWRXO2oB
        gT/Z8ggnr8fGL//b0Jhb68c=
X-Google-Smtp-Source: ABdhPJy1ptQO0Zr+f4Ax9MI/K+whvkb3gSvmF1vxA1SHjk13XeiAbF7LcE6Rt9VmxXgSQX7/GUG2XA==
X-Received: by 2002:a62:5284:: with SMTP id g126mr28869pfb.139.1595960629307;
        Tue, 28 Jul 2020 11:23:49 -0700 (PDT)
Received: from localhost ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id j5sm7109353pfg.80.2020.07.28.11.23.48
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Tue, 28 Jul 2020 11:23:48 -0700 (PDT)
Date:   Tue, 28 Jul 2020 11:23:47 -0700
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        stable@vger.kernel.org
Subject: Re: [PATCH 5.4 000/138] 5.4.54-rc1 review
Message-ID: <20200728182347.GC183563@roeck-us.net>
References: <20200727134925.228313570@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200727134925.228313570@linuxfoundation.org>
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Jul 27, 2020 at 04:03:15PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.4.54 release.
> There are 138 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 29 Jul 2020 13:48:51 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 157 pass: 157 fail: 0
Qemu test results:
	total: 430 pass: 430 fail: 0

Guenter
