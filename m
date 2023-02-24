Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5FC876A15E0
	for <lists+stable@lfdr.de>; Fri, 24 Feb 2023 05:29:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229622AbjBXE3r (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 23 Feb 2023 23:29:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48786 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229553AbjBXE3q (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 23 Feb 2023 23:29:46 -0500
Received: from mail-il1-x12f.google.com (mail-il1-x12f.google.com [IPv6:2607:f8b0:4864:20::12f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 666CC25293;
        Thu, 23 Feb 2023 20:29:45 -0800 (PST)
Received: by mail-il1-x12f.google.com with SMTP id h10so2441185ila.11;
        Thu, 23 Feb 2023 20:29:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=bFcCAGcExvL1TUhy9/ONz2HJhq249qLecHd7Ujep69E=;
        b=EPK9SKNxDXpAG4KK7C0t7TYCyuqrFSIdMsrEL6J/boNFOE1e0mzeKA2JZ7ghjdDf2H
         ZrfHmp82vQ1f8ufVgQMotnh2cirtXi9o96qJ5SIQgceRU6jqeuWFlF4J4tcWTj0q2aWj
         TrBwKn97VsU0i7qe4a9zfKN4jvGfGkD3N+i2qt/+BSR+19uZWD36HI82/6wcFaQcOSZf
         qfjj/jUTId0oJYxl3QGoGYq84q2qS1n+plPz9rRc0jh2hRQJqr/RA1hT5Bi2yddb8G43
         Bux7Aca0CrOaeR48sH7YO4BC4CyCW3C5UketUD7IOHt4kIv+nI4dlBGiEx9M9NqRPS4q
         lDXw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=bFcCAGcExvL1TUhy9/ONz2HJhq249qLecHd7Ujep69E=;
        b=TkzcoirKIdKiGURtRDug1PObdcwyyFB4bsUbXEwxaI8LVkpA8CyrLIYOmcmNOmq595
         Oj2j/8TLK0p4XL0FGZoIKemQgAhvqiDoQNDvqyq5SbJprkD84Ht7ci91vgbXRTDQqZ4h
         p1+A0QxjUbZ2HKPaJsU0W4KIAQwOO30P2hj0CxvvCQ7m/pcdIAAUPbP6/7YIy0aOYGlU
         jVISteZ8TSmFjhO4o7bC9AUxa/xpANj9x/P4Tktv5opzvZuGeviZYoqr3mLhs/w79fGi
         AG60JmsSA27Dn/C8XZq0B1DbAaet+VWTXyKCGB4iQnPLJ0xKvtJC+EBVoZZ/xtmJhwfO
         c8Fw==
X-Gm-Message-State: AO0yUKXeMvYvg1NBpxML4fcWDdhuTKgrOwfui3G+QotKqyBuWajRUzoS
        1RGR7+fTYtbFkxXcaSIp/JA=
X-Google-Smtp-Source: AK7set80xtq++KVR8NwURwDqQiq7UYsT0qUlqRG4VROqQ1BSuWy/QeJAGfVR4Yro2p9h7zjMXHOa8Q==
X-Received: by 2002:a05:6e02:1849:b0:316:dc3a:fe80 with SMTP id b9-20020a056e02184900b00316dc3afe80mr10828322ilv.0.1677212984802;
        Thu, 23 Feb 2023 20:29:44 -0800 (PST)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id s24-20020a02c518000000b003ad13752c9csm1999216jam.72.2023.02.23.20.29.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 23 Feb 2023 20:29:44 -0800 (PST)
Sender: Guenter Roeck <groeck7@gmail.com>
Date:   Thu, 23 Feb 2023 20:29:43 -0800
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     stable@vger.kernel.org, patches@lists.linux.dev,
        linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        srw@sladewatkins.net, rwarsow@gmx.de
Subject: Re: [PATCH 6.2 00/12] 6.2.1-rc2 review
Message-ID: <20230224042943.GE1354431@roeck-us.net>
References: <20230223141539.893173089@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230223141539.893173089@linuxfoundation.org>
X-Spam-Status: No, score=-1.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Feb 23, 2023 at 03:16:08PM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.2.1 release.
> There are 12 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sat, 25 Feb 2023 14:15:30 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 155 pass: 155 fail: 0
Qemu test results:
	total: 504 pass: 504 fail: 0

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter
