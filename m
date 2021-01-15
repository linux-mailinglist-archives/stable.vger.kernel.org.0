Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3D1042F877A
	for <lists+stable@lfdr.de>; Fri, 15 Jan 2021 22:18:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725772AbhAOVSA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 15 Jan 2021 16:18:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39660 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725536AbhAOVR7 (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 15 Jan 2021 16:17:59 -0500
Received: from mail-ot1-x330.google.com (mail-ot1-x330.google.com [IPv6:2607:f8b0:4864:20::330])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 468C5C061757;
        Fri, 15 Jan 2021 13:17:19 -0800 (PST)
Received: by mail-ot1-x330.google.com with SMTP id c18so4146083oto.3;
        Fri, 15 Jan 2021 13:17:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=0pLcBSr3BPwmsvvDMP73l1M6SO8raxb6NNR5738Ti84=;
        b=MSTA/yo8EA1c3eArSReuUIOju9ZdCkM3Sm3qB/R5Ru9P6iysUp4lIV1j1YOt9R9bkV
         aD/LN2GMdJsvzDBcwvViRoqsLDXxSAV+V5Acf0avslc8qeTT/JaAnWLd/NpZIh4L7mp7
         LPN7Npd6cyy6zqzhDKgUXJ4Ag+Ln60j/8NdXPDADBIoTS7QYveTVJZtgFPxPUJC/tGJv
         x10lb1QrsWF9k2F8GheuomhaL2s23JURleID4sVK9ZmtEENMaXk86iVmxmENq9cu/n1d
         1E5SmSG7UvPi9rrd/5/WQX2jmb59xbMcEBV6lz0CtTyUkca2k+RsZ2PtPR+NclVzYiQG
         ELKQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to:user-agent;
        bh=0pLcBSr3BPwmsvvDMP73l1M6SO8raxb6NNR5738Ti84=;
        b=cZOZ65cmGmqSyF5pFGpNAP29+23qYz5fan8J9kKqU7j3zUrLrVD0C33nyATULRt2oT
         SfKvEGbb2u46WAEQ8F6AGwzd5y2ihyN3ApHjJtjoxeIZDJw+SW4D+BjVr3CdbDNFPv9a
         BRcvO9N42s8hy5zGeESkb8377r25TeirpH84fCPcypi7sKqCVn3A6JT2EsfEiTlcEKS3
         5rf0rRuMOI2Y2zYmg9Awf/6/LkIdwKzujLn8w4fz842Jk29/3Nsxl4SQb3xLCok1yK9b
         OjnXxhZJRWQYQM1HCyaHL3tz2bEqRMRcEn36c7McROa69a35HOEWWDDTmNMf17ZPtnO/
         Exow==
X-Gm-Message-State: AOAM530XcBHHHowZgwK1+BP48uCzFjP9/TLsZo2NunodKQZVPAu8j5SR
        RuXolblodKopJyBhm+6T1q4=
X-Google-Smtp-Source: ABdhPJwxRCTDZVzZwxM5mLrLFDlk6jKMOKy5UFI1hWmk9YaL604yryMZFY1Hz73crjV5SirXFSpa2Q==
X-Received: by 2002:a05:6830:1105:: with SMTP id w5mr9975095otq.255.1610745438748;
        Fri, 15 Jan 2021 13:17:18 -0800 (PST)
Received: from localhost ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id o49sm2046764ota.51.2021.01.15.13.17.16
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Fri, 15 Jan 2021 13:17:17 -0800 (PST)
Sender: Guenter Roeck <groeck7@gmail.com>
Date:   Fri, 15 Jan 2021 13:17:15 -0800
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, stable@vger.kernel.org
Subject: Re: [PATCH 4.4 00/18] 4.4.252-rc1 review
Message-ID: <20210115211715.GA128727@roeck-us.net>
References: <20210115121955.112329537@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210115121955.112329537@linuxfoundation.org>
User-Agent: Mutt/1.9.4 (2018-02-28)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Jan 15, 2021 at 01:27:28PM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.4.252 release.
> There are 18 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sun, 17 Jan 2021 12:19:42 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 165 pass: 165 fail: 0
Qemu test results:
	total: 328 pass: 328 fail: 0

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter
