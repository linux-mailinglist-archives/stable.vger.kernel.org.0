Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 044996BDC17
	for <lists+stable@lfdr.de>; Thu, 16 Mar 2023 23:54:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230164AbjCPWyb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Mar 2023 18:54:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59246 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230154AbjCPWy3 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 16 Mar 2023 18:54:29 -0400
Received: from mail-io1-xd33.google.com (mail-io1-xd33.google.com [IPv6:2607:f8b0:4864:20::d33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E06AD67817;
        Thu, 16 Mar 2023 15:54:24 -0700 (PDT)
Received: by mail-io1-xd33.google.com with SMTP id b5so1545479iow.0;
        Thu, 16 Mar 2023 15:54:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1679007264;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=noRAcyDP/DNfjl0bH6mzBUk0AhaaiXFphuu8aQobzic=;
        b=bCd3ZHQvFPLCKPpUiTnkGXZoN0l5MvAEa7vxTv8HcSbImXe22JDL+GwJJLqBU2ttHc
         NhMOnOio1GkP37DahAgOd054DXQSQP5YBUYkIwwJ8w6iAJagtqiaPQy8LlUYw6Mfueg0
         lvIEuFPzNh5WSbN0OdMl9fA1/A7mi0lxPog/GSU5CaZLvuP+U7dpaH0QHA3WMzpc5iks
         xBEYKv5CxZKoQkqKl2XtYoB1VRnvqy0yy5dOGVe7uU95D9PXM89XrpBPjcWre1VPIULY
         pvQn3xDYNfJM0525t/OG2X8J892LrKDDIEOV91eaTUTB1qZjqDPQ4Cbw5qCseMXLjuo7
         dfrQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679007264;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=noRAcyDP/DNfjl0bH6mzBUk0AhaaiXFphuu8aQobzic=;
        b=YAEDofwbg+JYqWz5AiTAqBkm5NAMubu6QvQCIencccTLXJuwXBxmxCpVccyKYHxBsZ
         3Fme8Bk4gVYz2drBi5KHdSg99aLksfltXtQ3UfzAr2v1Rl1FITIDuvHIw6n0ug1X6oWH
         9bO+fj1vBIx3YLQq5wOmsoOsIRpiPp/DOT4mjD05xPsbcg2uk7Cf0PRV7hcaJ4QrGDG6
         10NCwMb/WcNddXvY0/ZHxV8pHZ+hQVW9xeTi9j4Np0PCiQLZWmypNf1SG741sPKtv3xC
         bElUPlDVUg0YbJEj/hRZ0qruymSNMTHTjw12vxKD64fkdGq22GtTn8Jh60bv7TEPxHpc
         3zdA==
X-Gm-Message-State: AO0yUKW2YLwDn4JQJd0eo7F3EsSMk0z/kGXPqiCyIU/bpeH2eGDkCNXp
        oFV7H7v5yivvsRO+kt/JSFc=
X-Google-Smtp-Source: AK7set8mOnMvwTH8RSo5A3TnDh8qw5vTt25VO9g2z9SUQRy2QvOHUI2jIlErP1F6HkLBUVAOxTQs5g==
X-Received: by 2002:a05:6602:4217:b0:74c:99e8:5a83 with SMTP id cb23-20020a056602421700b0074c99e85a83mr396639iob.9.1679007264248;
        Thu, 16 Mar 2023 15:54:24 -0700 (PDT)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id d4-20020a6b6804000000b0073f8a470bacsm126718ioc.16.2023.03.16.15.54.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 16 Mar 2023 15:54:23 -0700 (PDT)
Sender: Guenter Roeck <groeck7@gmail.com>
Date:   Thu, 16 Mar 2023 15:54:22 -0700
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     stable@vger.kernel.org, patches@lists.linux.dev,
        linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        srw@sladewatkins.net, rwarsow@gmx.de
Subject: Re: [PATCH 5.4 00/55] 5.4.237-rc2 review
Message-ID: <88ed612e-8dd2-4322-a745-a2045d3e0500@roeck-us.net>
References: <20230316083403.224993044@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230316083403.224993044@linuxfoundation.org>
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

On Thu, Mar 16, 2023 at 09:49:55AM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.4.237 release.
> There are 55 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sat, 18 Mar 2023 08:33:04 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 159 pass: 159 fail: 0
Qemu test results:
	total: 455 pass: 455 fail: 0

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter
