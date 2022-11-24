Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 450DD637080
	for <lists+stable@lfdr.de>; Thu, 24 Nov 2022 03:36:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229874AbiKXCg5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 23 Nov 2022 21:36:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58048 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229886AbiKXCgu (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 23 Nov 2022 21:36:50 -0500
Received: from mail-oa1-x33.google.com (mail-oa1-x33.google.com [IPv6:2001:4860:4864:20::33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CE4945E3C6;
        Wed, 23 Nov 2022 18:36:48 -0800 (PST)
Received: by mail-oa1-x33.google.com with SMTP id 586e51a60fabf-142306beb9aso562706fac.11;
        Wed, 23 Nov 2022 18:36:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=xGSTj1CNxP9OD7Gaq7hokMZxT8fLBPdy9uv3vJ9zQ2I=;
        b=gR/iyFQdEl29PJOXaK8phjF+4oy5R7htq+2ofBhGsWCXAspBiCjoFViLlzJi4qj/t+
         R/TD1taf7qK0eLTEYgb+eqs7PmISbzByHE8oXQ+LI6xy5/U+FgXdXbFRQyq1/xLuzn/B
         jzymDmcuvfkU29faWSmIdZzMmw2O/Drs9TP4ZWHKfikArizvj5iqmc3v0VdYrjihGbWA
         PVT/qnebzm+uhBVVbjtFq7JZsLK/1j0gZqv4pXqZv/GibCRkigvxUbJySLM/DgJQVuTe
         d07iFVGAwkEK7UTqM1zl4YXwX7fKkOZTyIKbQw02i2Hg90i1w5FiCGrggeSQMhmPNqB2
         mYtw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=xGSTj1CNxP9OD7Gaq7hokMZxT8fLBPdy9uv3vJ9zQ2I=;
        b=lxNIaxjlqRkr5FE8aoHIT5gmp9yeLSv3TQKt/WpjOGKqekjO3gJnG+qBSZ0wbHT266
         CRHBrQeZKD9ofT4/6pTASYmiCJmMF7XmNzQ//eWJys2lKN7O5xUtv+p76jK3pQDKGDLC
         NRN8qeP7fEtZMGJPn2sRbPzU8SPxf5G5nQXYcFM69vDo3OFIr4ARW1n3FJYjFymVkVLA
         vS3xE+by6/rbKuXE6cX7Y/EWaIA7QnbJhhJqM+ikmR6f3CUPgAMCooJL5xFoL3luKbWt
         7f0xDY41/4Q5IcdX4XUvxX/+L4/OOSpMXZkfYv3y5oNiSdnWmHVjKs1b/m62UFBsTnan
         QnQg==
X-Gm-Message-State: ANoB5pkc1kysV95cvc/jAVTilff+MIvS5VuPj22C4q8AkucbofO7qGA4
        QxzR0FflB1ZjJk9tuqJO+YQ=
X-Google-Smtp-Source: AA0mqf63ryiDNShByjbNu2s2PvzAsd+Y3ODXQFdSrrXR4oNePankXbhXAYbHH3vX1wYpRgqLMfJL3g==
X-Received: by 2002:a05:6870:7d0e:b0:142:821a:590e with SMTP id os14-20020a0568707d0e00b00142821a590emr15549099oab.55.1669257408508;
        Wed, 23 Nov 2022 18:36:48 -0800 (PST)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id s7-20020aca4507000000b0035a81480ffcsm7213716oia.38.2022.11.23.18.36.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 23 Nov 2022 18:36:48 -0800 (PST)
Sender: Guenter Roeck <groeck7@gmail.com>
Date:   Wed, 23 Nov 2022 18:36:47 -0800
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     stable@vger.kernel.org, patches@lists.linux.dev,
        linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        srw@sladewatkins.net, rwarsow@gmx.de
Subject: Re: [PATCH 5.4 000/156] 5.4.225-rc1 review
Message-ID: <20221124023647.GD2576375@roeck-us.net>
References: <20221123084557.816085212@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221123084557.816085212@linuxfoundation.org>
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

On Wed, Nov 23, 2022 at 09:49:17AM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.4.225 release.
> There are 156 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 25 Nov 2022 08:45:20 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 161 pass: 161 fail: 0
Qemu test results:
	total: 447 pass: 447 fail: 0

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter
