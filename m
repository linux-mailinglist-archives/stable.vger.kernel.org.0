Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 82C1557B0F4
	for <lists+stable@lfdr.de>; Wed, 20 Jul 2022 08:19:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239637AbiGTGTb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 20 Jul 2022 02:19:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55632 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239620AbiGTGTa (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 20 Jul 2022 02:19:30 -0400
Received: from mail-pg1-x531.google.com (mail-pg1-x531.google.com [IPv6:2607:f8b0:4864:20::531])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D42E06555E;
        Tue, 19 Jul 2022 23:19:29 -0700 (PDT)
Received: by mail-pg1-x531.google.com with SMTP id h132so15503516pgc.10;
        Tue, 19 Jul 2022 23:19:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=afHJW/+Uqll/hbOI5EuT2LCcDohGOYnrFSkF/PMj+O4=;
        b=eYuG8TH6KlSaJ2B+D6Ikn1yFRFU0+dljnUq8jJtugo06Aw0gF7damUpUvlidWKTeo5
         O8FTbVm3kqtMy41k+5zzXwE6FtJ0yhBFzvzQghr8/hmldqdW/DqyWYDefonIHHsukLB5
         n1rTNaGQThqxx0Sqr5C9B5Rs6U9Rwl/NpCtRLTKIPaU34o/neXMWpxiMq5Bw8v3pE6Yc
         0tIkHBIECFY6ZLZ9NT2c+GqENFY96YfDs3Ewcw9csCWll+/NNHMPSxsnS5QGK6dYFZad
         hHNP2pssMc8yBQED+36MYDpWGKbJJpCz6Jw2kjimGGeWHkpTcEQnCNA/4lEmmuxPYGz3
         4jmA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to;
        bh=afHJW/+Uqll/hbOI5EuT2LCcDohGOYnrFSkF/PMj+O4=;
        b=Q5T//GSdV+ZU0+dO/Ok/VKn/YFckIq79wyHgVRXBWg6QTCk2GCqn2kAWZl9SQbQdP3
         LaykBUkXBIaE7XrVhF9pIPkckASbquSty1VBn+bPVUSXPiO5+SA1slLz623+mq2QVjTP
         6yT45RFHFUwOvRz2dPf+tFA10qmomUKy43vQLOd9pKm8hMwuEPJzXFe1LcFML44qtaDX
         OCX7lGg64VBlKsY+nuBycP5pgW1fdbt1WHpiR9cJnVgapNrkOuILQVcINs9NTE8mBEKL
         Jtec+VKTVOClDnYirKBwvTX4eFWTg1KmXTgEIrG8hPqmTGx3YPmeA52bxnLf8aWuBBMx
         llAw==
X-Gm-Message-State: AJIora95mrJf7gl1fLyI+FHpN7fQU98+/EFBnJuRZXiToX7hScdWZpnj
        oIsJyyytCSiaNZ7tw4kjSjM=
X-Google-Smtp-Source: AGRyM1vthtLMQGyMH0rv7dJRkLC+pz3hB6Jv63AUfZYDuCaoVAVONL843NCNbc0VvUnPNhdtuL2nhg==
X-Received: by 2002:a05:6a00:230d:b0:52b:1819:3a0 with SMTP id h13-20020a056a00230d00b0052b181903a0mr34028884pfh.53.1658297969285;
        Tue, 19 Jul 2022 23:19:29 -0700 (PDT)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id i2-20020a17090ac40200b001efbc3ad105sm662400pjt.54.2022.07.19.23.19.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 19 Jul 2022 23:19:27 -0700 (PDT)
Sender: Guenter Roeck <groeck7@gmail.com>
Date:   Tue, 19 Jul 2022 23:19:26 -0700
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        slade@sladewatkins.com
Subject: Re: [PATCH 5.15 000/167] 5.15.56-rc1 review
Message-ID: <20220720061926.GF4107175@roeck-us.net>
References: <20220719114656.750574879@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220719114656.750574879@linuxfoundation.org>
X-Spam-Status: No, score=-1.3 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Jul 19, 2022 at 01:52:12PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.15.56 release.
> There are 167 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 21 Jul 2022 11:43:40 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 159 pass: 159 fail: 0
Qemu test results:
	total: 488 pass: 488 fail: 0

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter
