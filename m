Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E4CF36A15DD
	for <lists+stable@lfdr.de>; Fri, 24 Feb 2023 05:29:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229722AbjBXE3U (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 23 Feb 2023 23:29:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48226 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229622AbjBXE3T (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 23 Feb 2023 23:29:19 -0500
Received: from mail-il1-x131.google.com (mail-il1-x131.google.com [IPv6:2607:f8b0:4864:20::131])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B724B7A8A;
        Thu, 23 Feb 2023 20:29:18 -0800 (PST)
Received: by mail-il1-x131.google.com with SMTP id a1so6756772iln.9;
        Thu, 23 Feb 2023 20:29:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=PQGPN7x6E89EY3z9VBVW5bdYElF7KZEnIddS4aSr7hI=;
        b=nBANjiYn5LxM71zouVdQwM7aYo4icl11doGqNfmorux5H1dwvOc1oCDUZCfkCfJBXT
         nRNLY0XHwvGhPkDuRpYjzFO8xZ8OF1mWeh2cQIiV+b18EuTxHi0pH3Stg8WREzm2y7af
         sgS19adRoCMQYjkvwYGKvIjSCvswoBx5fztFC2sROQlVQXRvTL/Kg009eWZdMe2FIaVu
         C6AolBSaSO9hvfJHmSDz8jiV/IXzYrZOGoinwFc36PNsOrgyt+4J1+e7XsgagnX0bsAG
         DneU/TsOt7odFveO8KAvaAGgShXatmNc+jMbsoSBshq/61SENDNS6rW97WYbpf6B10Wn
         ZKtA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=PQGPN7x6E89EY3z9VBVW5bdYElF7KZEnIddS4aSr7hI=;
        b=400g4jVOfOF2HdDwmYjoITI6Qr6tlzj9K6p4GLoCRc8OAr1TAF6q5+SVA5KhDKv6FR
         HN43GwqrKIuZnZoIBaZrDB4aCSbpt7xXW4YBLMgkOKruauZhKBK3vtyAv2kjzZ4z5Lvi
         j2QDrBUuV6THlwIzDq8FUcGqDdCuFJs5Z4svFFxRzTgj0DCdjUxuFsg1pTOvQ56TD23i
         NhT6ypZkzpJCPIBjCeTLeea27xgSSF2JUIXm9dVa6MUzZB71Km5pwzufAElYSotuE2iS
         MfGv9ZOBYdYKAFdCKd0+5thDa8t5sjEh6lM4XiXbpPODc8NOvfLI79PuqUAokdz8sFOh
         Hktg==
X-Gm-Message-State: AO0yUKVViZq1+lVjWK0TVDykuGcv22D7r+ho9AtXrifDkR/d+t/RhrFU
        4TLh/fWtNGIi/fa/NEz5XWQ=
X-Google-Smtp-Source: AK7set9TscD0WuCDfVVPMIhvNppUgxA3OsL2+JBwaKwGV73U5SF/bKM1k9RnhIKrRQbcNmpCLa8Xfg==
X-Received: by 2002:a92:7602:0:b0:315:3d99:bbd3 with SMTP id r2-20020a927602000000b003153d99bbd3mr10775120ilc.8.1677212958092;
        Thu, 23 Feb 2023 20:29:18 -0800 (PST)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id g14-20020a92520e000000b0030314a7f039sm3592367ilb.10.2023.02.23.20.29.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 23 Feb 2023 20:29:17 -0800 (PST)
Sender: Guenter Roeck <groeck7@gmail.com>
Date:   Thu, 23 Feb 2023 20:29:16 -0800
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     stable@vger.kernel.org, patches@lists.linux.dev,
        linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        srw@sladewatkins.net, rwarsow@gmx.de
Subject: Re: [PATCH 6.1 00/47] 6.1.14-rc2 review
Message-ID: <20230224042916.GD1354431@roeck-us.net>
References: <20230223141545.280864003@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230223141545.280864003@linuxfoundation.org>
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

On Thu, Feb 23, 2023 at 03:16:15PM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.1.14 release.
> There are 47 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sat, 25 Feb 2023 14:15:30 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 155 pass: 155 fail: 0
Qemu test results:
	total: 503 pass: 503 fail: 0

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter
