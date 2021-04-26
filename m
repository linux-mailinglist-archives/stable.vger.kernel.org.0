Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 75DA936B902
	for <lists+stable@lfdr.de>; Mon, 26 Apr 2021 20:34:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234274AbhDZSfD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 26 Apr 2021 14:35:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45690 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234161AbhDZSfD (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 26 Apr 2021 14:35:03 -0400
Received: from mail-ot1-x331.google.com (mail-ot1-x331.google.com [IPv6:2607:f8b0:4864:20::331])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 725FDC061574;
        Mon, 26 Apr 2021 11:34:21 -0700 (PDT)
Received: by mail-ot1-x331.google.com with SMTP id f75-20020a9d03d10000b0290280def9ab76so47920514otf.12;
        Mon, 26 Apr 2021 11:34:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=j5+TAGuZH1hpYbwmR1SzngIyH1QNf56GiC8nwL1mKOY=;
        b=AUYxZzlLlk4ReLwEoXuGkdCIQdur1RPk7qWMek+FJfO6QkJwEcmyHnxclWkhnZsDhz
         wMb2KckliPkkGlS0XCKvo0yTRr8kVQQ5CV1R1IGuO94iUe00IphtGGt2hON+Z6qvepvn
         43XUsIehmnoLsdgkRqzjLsql9QSVkQ2eZlYuhhM8ox4bK/2bdbg8ZUZ34ttRFY84Jfto
         ZOKf14ZkjYm7/wWwQUc/SNY/p5kfUsw6a3Tp+hIyAJpSHb8YZ1q5WLuaCV/2pK/nRi3M
         8YqPDxtg1RK7C9/Va3CBFQZ2qpz/6SJ5SumZwrIwAl3nX+77mWbtlBDvEvi6SzQZON4c
         dg2w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to:user-agent;
        bh=j5+TAGuZH1hpYbwmR1SzngIyH1QNf56GiC8nwL1mKOY=;
        b=W4k2BhklYYfF/Qoe1XkFcv8Jmh37Hl7LKVsmBjC5NG3g0qcRIT6WIrqgFGRVgQQeay
         og4zGx4RFtacLWdtwo5rV4WnuTv3Ft/pInPae9nxR+NPaIf1o4a3lsRRSTI0/bF9WaNk
         C5LI2Tq4X9E0AWxVCSHzUKcqYhmN0m+rjNOHMTE/RXE3y73AN2Q4SWrtUX9A5ku/+04z
         AFt/IkHUJWKVs49QzNw/MHB6nVDRZtaJ5XIFtHxyNsl3ATqRn0JTs3ENorJIwpeKias3
         2R2QkKnU97rIskZDtbkaoVI6EY0IPSfYpPoRJ+UrarzlcubmDCfbK2id1uhzz3JU3EWj
         Zl7w==
X-Gm-Message-State: AOAM530mz5b+0mk+yOpeGlHP0TQLa3qyQMhyxf25mGD2mnxBxLMwzuHt
        1nZhff2WvfnwdwQYSrAhg1Q=
X-Google-Smtp-Source: ABdhPJyX5mR4+KybrmTgdvtrgzwnhYn3KQLcSoNIIBBUNFQ914rgHtpi/eFN9acUAZ2i++NSGXjRnQ==
X-Received: by 2002:a05:6830:1d56:: with SMTP id p22mr15620775oth.329.1619462060940;
        Mon, 26 Apr 2021 11:34:20 -0700 (PDT)
Received: from localhost ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id q1sm3584612otm.26.2021.04.26.11.34.20
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Mon, 26 Apr 2021 11:34:20 -0700 (PDT)
Sender: Guenter Roeck <groeck7@gmail.com>
Date:   Mon, 26 Apr 2021 11:34:19 -0700
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, stable@vger.kernel.org
Subject: Re: [PATCH 5.4 00/20] 5.4.115-rc1 review
Message-ID: <20210426183419.GE204131@roeck-us.net>
References: <20210426072816.686976183@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210426072816.686976183@linuxfoundation.org>
User-Agent: Mutt/1.9.4 (2018-02-28)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Apr 26, 2021 at 09:29:51AM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.4.115 release.
> There are 20 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 28 Apr 2021 07:28:08 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 157 pass: 157 fail: 0
Qemu test results:
	total: 433 pass: 433 fail: 0

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter
