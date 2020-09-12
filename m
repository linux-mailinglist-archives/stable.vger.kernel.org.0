Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2AC6526772F
	for <lists+stable@lfdr.de>; Sat, 12 Sep 2020 04:16:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725769AbgILCQq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 11 Sep 2020 22:16:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49958 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725765AbgILCQn (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 11 Sep 2020 22:16:43 -0400
Received: from mail-oi1-x244.google.com (mail-oi1-x244.google.com [IPv6:2607:f8b0:4864:20::244])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4B3B0C061573;
        Fri, 11 Sep 2020 19:16:43 -0700 (PDT)
Received: by mail-oi1-x244.google.com with SMTP id i17so11362179oig.10;
        Fri, 11 Sep 2020 19:16:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=31VLsBsowcpDDKfStfPxLG3TShsJhrjzOWnLaMaUKeA=;
        b=aTmdyKKtxqnZKbT5cpanp4VJyoSh9zmZ3GZoWsXP68yhMNeIKtdRquJNyP9dBpvsQK
         HL8FSbTzFpTG2GKD3coRyDx35ZGobikwNssufeCPO+78vyY+Q30FTEBmNDuP5Hf59xvo
         Dyj0rWEGi5737k4pRV562W6mFgEd8q/Z0POJevSfBVDLpAy7TbgBZl7gBNu30AlC2hi4
         NR0uUpnTrEFS4Wr8y5xK8gHNwUXCNF/bzIyr6FBVcFqHpQX2sJF1URFcuwKbxqte62r9
         m5dLvOB5hZwKZkWAlzda9W1A+aZmRP3yPxqafLycEhUS4/b0yBFTfq448tBLHYwUGpbA
         t3NQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to:user-agent;
        bh=31VLsBsowcpDDKfStfPxLG3TShsJhrjzOWnLaMaUKeA=;
        b=g06Gc1pYBUR1Uq+gNKgQ3MiBGa/6EjukNbPh6fXdIoSMtkv0vHYRGLRNdXOUfEP0EK
         4qTWI5y8N0v2eewu3uMwXCc8eJQDnOLOqSoGYolMC3L9iVN+YTBqeHbShJAmZhuuLkn9
         Er25VCvgxzSq5uJASifdbVDrA2usbj720VuSzCz9mBecbZmHRf7RZ2zeY26wm/XZWUqW
         mxPLOiuGi1fRnqGwVR6isinWpW+en57uueBExRo6s+3Hc4GBElTBzFVDn62O1h1ydeqF
         NVD5DcoV4Plt/f/ugvfYsPWSi1Hh4ZBMSEa2GJbIfSKYagPwtbDOWGQZcrKQ4iOfwgHr
         0ZDQ==
X-Gm-Message-State: AOAM533OBsuKaRkW5V7ySm1cFn/UBE7p7xeepvWAH5icDeLwd6bx57dV
        3ANMYL/awLLqpp5c/9GIcbhcGuRXWQM=
X-Google-Smtp-Source: ABdhPJyqoCa5xqkpBkYmrJ6vl6nbpdO2LQh8u9GzlvEi7KFe+6nq1zGFWOHEsht5VhM863xSOKQmOw==
X-Received: by 2002:a54:4501:: with SMTP id l1mr2809994oil.165.1599876999411;
        Fri, 11 Sep 2020 19:16:39 -0700 (PDT)
Received: from localhost ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id n10sm692246ooj.19.2020.09.11.19.16.38
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Fri, 11 Sep 2020 19:16:39 -0700 (PDT)
Date:   Fri, 11 Sep 2020 19:16:37 -0700
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        stable@vger.kernel.org
Subject: Re: [PATCH 4.9 00/71] 4.9.236-rc1 review
Message-ID: <20200912021637.GB50655@roeck-us.net>
References: <20200911122504.928931589@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200911122504.928931589@linuxfoundation.org>
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Sep 11, 2020 at 02:45:44PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.9.236 release.
> There are 71 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sun, 13 Sep 2020 12:24:42 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 171 pass: 171 fail: 0
Qemu test results:
	total: 386 pass: 386 fail: 0

Guenter
