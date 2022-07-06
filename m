Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3B1AD5689DF
	for <lists+stable@lfdr.de>; Wed,  6 Jul 2022 15:44:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231321AbiGFNoN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 6 Jul 2022 09:44:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44152 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232632AbiGFNoM (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 6 Jul 2022 09:44:12 -0400
Received: from mail-pg1-x52c.google.com (mail-pg1-x52c.google.com [IPv6:2607:f8b0:4864:20::52c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C8811DEF2;
        Wed,  6 Jul 2022 06:44:11 -0700 (PDT)
Received: by mail-pg1-x52c.google.com with SMTP id 145so14034885pga.12;
        Wed, 06 Jul 2022 06:44:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=LHHGKToiM1OUemXzX1dDbHxH26W+LzkLaTBpHG8rWNM=;
        b=TT/oSCYu+RUKuk7ccRpLt1nm/t7zLtTvvSxoKpYj4CbZEgxKomziH0eGBeqMkmMzNa
         dfhemGBsKyD0qBXgg/jL8pLeyma1d15C5rTu+1AoZuQl7PqVGdHYxRVr76BFgr/6+qFz
         ezeRM1dfChTcTiZSQHbzgYBIeqsGNvaa8uBpcu6tzMrMvMDg4ivBwkpmkT8ejeY/2NgP
         CJUAYwDtr8UIvHmlYpzKYlQzw6HTZHG564GH8Ts4iYnlnSJpkntUDI1bjBIDpsxLrzah
         mbuDOi/iYHHkUIm97Kwg8RG4ILtVTq/oBu5je3ooDJ7lL9Xo52XnVZosp4IpPJ8wlhQz
         ZRrg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to;
        bh=LHHGKToiM1OUemXzX1dDbHxH26W+LzkLaTBpHG8rWNM=;
        b=HvHKbov22hJzk+lwT8BgDshPMTemo+TW5NT2q7EshLfDIYcY0FENrjHtth2u5WPiSH
         18QCHclb+p8NXsEwqcyDyiO1j4fowk1FOuZfpxmt3VTMKiGWEVVDUzmjwBjSa0nds0SM
         CM2+v5YCm4cetp8ymPu8yMt9Sn5t9BJeuXbenajrLswrqA2Ef+5Ko9HUga8IO8LffueF
         plEVIdwB3lBaLyskn2dRx1nWUQnWWisgex4QRUJLfoo0gjlbK0IIA5SEZLHRPbDB95AH
         neNtJXwnS3Nv4oibVNorVecSMtzvcPYpDAXfCR0ZWu3GBZUYNgr3jlMwrX3p+/UY4ZUK
         d+Zw==
X-Gm-Message-State: AJIora/QTfYmnmXq3TfqZHwKo0MGvcYIFCrhbXhgnOscr6GR7WMGIPH/
        NXCC7PsgsL4Rxj9vfgosrJo=
X-Google-Smtp-Source: AGRyM1vGZc3ZXZl/gU/2ubN5ixjl8fD7LwgQW+Z7SUfcqW82dzc2Id8BN5mCvouL35W0B20sGBTIIA==
X-Received: by 2002:a05:6a00:1992:b0:527:c201:ef52 with SMTP id d18-20020a056a00199200b00527c201ef52mr47273913pfl.59.1657115051388;
        Wed, 06 Jul 2022 06:44:11 -0700 (PDT)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id d18-20020a170903231200b0016bf7981d0bsm3164280plh.86.2022.07.06.06.44.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 06 Jul 2022 06:44:10 -0700 (PDT)
Sender: Guenter Roeck <groeck7@gmail.com>
Date:   Wed, 6 Jul 2022 06:44:10 -0700
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        slade@sladewatkins.com
Subject: Re: [PATCH 5.10 00/84] 5.10.129-rc1 review
Message-ID: <20220706134410.GE769692@roeck-us.net>
References: <20220705115615.323395630@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220705115615.323395630@linuxfoundation.org>
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

On Tue, Jul 05, 2022 at 01:57:23PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.10.129 release.
> There are 84 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 07 Jul 2022 11:55:56 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 163 pass: 163 fail: 0
Qemu test results:
	total: 477 pass: 477 fail: 0

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter
