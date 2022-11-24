Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0908D637076
	for <lists+stable@lfdr.de>; Thu, 24 Nov 2022 03:35:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229554AbiKXCff (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 23 Nov 2022 21:35:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56694 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229553AbiKXCfe (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 23 Nov 2022 21:35:34 -0500
Received: from mail-oa1-x2a.google.com (mail-oa1-x2a.google.com [IPv6:2001:4860:4864:20::2a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AAE5A5ADEB;
        Wed, 23 Nov 2022 18:35:33 -0800 (PST)
Received: by mail-oa1-x2a.google.com with SMTP id 586e51a60fabf-142306beb9aso560286fac.11;
        Wed, 23 Nov 2022 18:35:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=KUoqze+xSNxAMqVOPVKPXTaUSVPflC4yczGR1lDLO0w=;
        b=AXr1iQIyFFDkcMVIccPxp34ePsZcqVX8raWOnzMvx1qmBEgbylSkL5DHByciuiYfOo
         93YleFrIII65s3Q6Did2WEpRPI3lrHogrUFSJyAXzARhuA6nO1qVWVN2r4qlQocKki80
         ic7ysYJvJrDe3As4Mqdf75pN0MODbA1XlMNyFyhyALU9ZcbPFbT3FXJ5gEKWw/XBqPGT
         iyHt4hPS2gNGqKVjOwnJBiRHq6Oqe16bRuHvHKctJDDWM/lpB8rGWSDc2gAVjN8MTtXe
         TufB51/h9Na0kldSpmf5cmWY2Etegd2EXjvKcqbLVID1Y7PSfTsV59bvquw5hVytJQGc
         oTqw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=KUoqze+xSNxAMqVOPVKPXTaUSVPflC4yczGR1lDLO0w=;
        b=bUGlAZiDP9timwA3Id3sDi8areNmUkaMzM9bwwLUzX3EKZ+BJ72U4vjdztXcg5TPd1
         7uPkKJCx3TyI3XrZGkN3QtDJm/X3PpmVQCK3AdeizP0qR80rf6Hqfz8pusUkGYXZp3NP
         mYC5JMxqn4E4c/sKEAjD7hpZHLc1fR1Aj08kcq6LCApItDA05E65tbNU0+l++i+hmlGx
         iNgy1P8/d3mOU2rFzHqYB5oLjDLPMANnBMiAY6JxzheZCNtrDAorssJ1MC1KkSKvn8GX
         nwxqRjQDmc1iNZf/9WlHieHBLrgGYpType0yC+6mfffOd3BxKOSndxHw7cculQTkrKHu
         6aGw==
X-Gm-Message-State: ANoB5pmHSSAvabes12EcUJONAPshekRBzi3/R9uhUoNUFcW32lzXfQJa
        umtydQiJ0do588Hlb6P3dHU=
X-Google-Smtp-Source: AA0mqf7JGg02CUJcn37B2qC88bNCiMncxD/78VpGOOJRv9j3lYhxyXdcPOYrfllY2XU4cjnPECZT9g==
X-Received: by 2002:a05:6870:479b:b0:142:7f3b:d60a with SMTP id c27-20020a056870479b00b001427f3bd60amr16610771oaq.111.1669257333023;
        Wed, 23 Nov 2022 18:35:33 -0800 (PST)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id r139-20020acaa891000000b00354932bae03sm7222100oie.10.2022.11.23.18.35.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 23 Nov 2022 18:35:32 -0800 (PST)
Sender: Guenter Roeck <groeck7@gmail.com>
Date:   Wed, 23 Nov 2022 18:35:30 -0800
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     stable@vger.kernel.org, patches@lists.linux.dev,
        linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        srw@sladewatkins.net, rwarsow@gmx.de
Subject: Re: [PATCH 4.9 00/76] 4.9.334-rc1 review
Message-ID: <20221124023530.GA2576375@roeck-us.net>
References: <20221123084546.742331901@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221123084546.742331901@linuxfoundation.org>
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

On Wed, Nov 23, 2022 at 09:49:59AM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.9.334 release.
> There are 76 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 25 Nov 2022 08:45:20 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 164 pass: 164 fail: 0
Qemu test results:
	total: 395 pass: 395 fail: 0

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter
