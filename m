Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1FF9B6ED97B
	for <lists+stable@lfdr.de>; Tue, 25 Apr 2023 03:04:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229822AbjDYBEZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Apr 2023 21:04:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50586 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232213AbjDYBEX (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Apr 2023 21:04:23 -0400
Received: from mail-pf1-x42d.google.com (mail-pf1-x42d.google.com [IPv6:2607:f8b0:4864:20::42d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 104E4AF2B;
        Mon, 24 Apr 2023 18:04:14 -0700 (PDT)
Received: by mail-pf1-x42d.google.com with SMTP id d2e1a72fcca58-63b5c4c76aaso3822403b3a.2;
        Mon, 24 Apr 2023 18:04:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1682384653; x=1684976653;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=fsQqb2H+qRpsMxKuYszpVTWj+hhKcaKTqbB2Oq+E+xU=;
        b=Wm7VbjnqzCkn5n3G5cXm7zmTnejDV7bOZZB+UJZGHas2fMvYCp/mHogoCK9j+Q9wCU
         Z0v1QhW5zDF9Fo5W6j5sLtYkWdypJGiUE92aiyEzg4nbZgVWQRghq1YSgbHaLtMJNF0B
         5Cf5maEUCNMY04wJfRSbrMh0JLE0L7RbszxWgAg0fJ57V66hW/khsU6WISquyafLjZas
         a6OVmuwepwkP72EeeQ0xTCFRpse+z7J0lCNZFKi7RBqk2aU8LVifQQQ1agg/2S9O5/nO
         AmbaLsNQyomoqc9htGk+ca1HSPBmjD0Efixfm4zhs53NagX2uAVMyYwhp2Q2uOFNIKbU
         Rvtg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1682384653; x=1684976653;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=fsQqb2H+qRpsMxKuYszpVTWj+hhKcaKTqbB2Oq+E+xU=;
        b=Jq8EBTt75Q3yefV077s+AkBcliogvA5kQj3dWIk6lYmHP7qPL8bujsBdBjuw66zlEx
         YsEap11SXSVVHoZV/TiG6vyCM6kfe3v58qK/4hmD9cGrLg7sAzEgwI3f2GZ6DG3jXqHS
         gWfWRvORMe5iBfAwtdi/+cv4O4cBI6yncQOMCj6/AOe48+TDPsyiLBpi1ZNxcGweFREw
         JA43bef6VJHSUhh67B6HxI29sgX2Zqj4eHsTC7M6nml7pC0jGlsS+YZVS7/XIeBbAaQl
         sn+ml0QMJ1S31+ckYBl9PqMOGb+myk5PACAOD3ckIAR2BvZpZ1Jw1+W2yU+o3K8spIt2
         fjVQ==
X-Gm-Message-State: AAQBX9cYV0Q6uxP79dXPEhF9gAT3B90zPK/OducUN6cmS6+sd96snEJR
        qQne5hlr+lcT2f+44jeQmHo=
X-Google-Smtp-Source: AKy350YhtlRHdLXNB6OF9hPuJYKhs8q6iWIx+5vUHb+/bE754932eSzmW8qRpIV/hWXoFm7j7ckWLw==
X-Received: by 2002:a05:6a00:134a:b0:637:253a:531c with SMTP id k10-20020a056a00134a00b00637253a531cmr22924038pfu.27.1682384653265;
        Mon, 24 Apr 2023 18:04:13 -0700 (PDT)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id x35-20020a056a0018a300b0063b6cccd5dfsm8044024pfh.195.2023.04.24.18.04.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 24 Apr 2023 18:04:12 -0700 (PDT)
Sender: Guenter Roeck <groeck7@gmail.com>
Date:   Mon, 24 Apr 2023 18:04:11 -0700
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     stable@vger.kernel.org, patches@lists.linux.dev,
        linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        srw@sladewatkins.net, rwarsow@gmx.de
Subject: Re: [PATCH 4.19 00/29] 4.19.282-rc1 review
Message-ID: <49c952f5-1ecb-4608-8aa5-f184f74d9eb5@roeck-us.net>
References: <20230424131121.155649464@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230424131121.155649464@linuxfoundation.org>
X-Spam-Status: No, score=-1.3 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Apr 24, 2023 at 03:18:27PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.19.282 release.
> There are 29 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 26 Apr 2023 13:11:11 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 155 pass: 155 fail: 0
Qemu test results:
	total: 431 pass: 431 fail: 0

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter
