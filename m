Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8DC1D5AFB63
	for <lists+stable@lfdr.de>; Wed,  7 Sep 2022 06:43:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229514AbiIGEnW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 7 Sep 2022 00:43:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46540 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229446AbiIGEnV (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 7 Sep 2022 00:43:21 -0400
Received: from mail-pf1-x433.google.com (mail-pf1-x433.google.com [IPv6:2607:f8b0:4864:20::433])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 476078769A;
        Tue,  6 Sep 2022 21:43:20 -0700 (PDT)
Received: by mail-pf1-x433.google.com with SMTP id 65so3203314pfx.0;
        Tue, 06 Sep 2022 21:43:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date;
        bh=EXvZBTlXMuYIKGKBphwvS7xUdfVs4EWHOwQs0tSqSyo=;
        b=dx8qaxuKfLnOYXciAZ4ThVmSIqqNinf7L7pYSjalBncjR/NyUxVKj1CIXNWSvG7KI2
         9Ksy/aUxD3Lmir1waQzNkTLeh9HouEnDV53e8mR4RXM0/tpcNUVb0OrJjCkKkB7GfiyK
         Ire+g5aCr8z9D/icXlm6VDx8c9z6tSuZ9Sj5nr7+iPHMzkvBoigXJpA6EijyPB9ajkw9
         adIKgKMq4lIr8u76dWYB25/I2nS+VrJbrBYXNGYTPPOGD/lz5SBJ51Rp0pujwVoEQkn4
         eVQV5rRGY09fxggjks8A/8lhnjXFmtEC3pL1vIaHRon9PQDsMljcPh4OL+GfOlRSnlUp
         iLOQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:x-gm-message-state:from:to:cc
         :subject:date;
        bh=EXvZBTlXMuYIKGKBphwvS7xUdfVs4EWHOwQs0tSqSyo=;
        b=XjvC1wPkw0b5lv5Z22F59sSqah6Al61RzrYZqiHGTpnLjJg4gEcsSZ7ldN/oQaocp+
         lbwiJM9R4pE7HEObCvrsGb7+SYYoBThHGA0ZQCQuKdmtqoNsL1x+BOrza8MHVuFdsKxP
         JoB/BgH+ICoIklDtLBGuU4s5EDwCtQz9uEsjFcIMsObvcmPIWhms1talz8EWEg6OkL2W
         pYODBKRJnP0qc+tmwHbfZYrM3+IMeOaWlOzpAjup9vvaGHTPQ7nazrSpZFU5ENyksgmQ
         P2BrdEVPHw8ZbOIaMdcDqNBNaZxViGpm1E1PAqgPb0B4mTa9N3aVkzblRneno8MqRStk
         nahA==
X-Gm-Message-State: ACgBeo18tdxbcqU6MgzpithF4BeQmJouvqKO9uIL/kACTPU69yQeFBw7
        5PJJ1Gzi/xeahrCwznBPhIz/SLBk+adnQg==
X-Google-Smtp-Source: AA6agR7vK1AUZCw1Inrwnc6CQAKSsj5cs3F5haKNfLCEuq9rqE/Al2jsTWDadHxWYFfsZJq6NaEdqA==
X-Received: by 2002:a05:6a00:1ca1:b0:53e:2d4b:67a1 with SMTP id y33-20020a056a001ca100b0053e2d4b67a1mr2083237pfw.35.1662525799736;
        Tue, 06 Sep 2022 21:43:19 -0700 (PDT)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id n10-20020a170902d2ca00b0017515e598c5sm4970894plc.40.2022.09.06.21.43.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 06 Sep 2022 21:43:18 -0700 (PDT)
Sender: Guenter Roeck <groeck7@gmail.com>
Date:   Tue, 6 Sep 2022 21:43:16 -0700
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        slade@sladewatkins.com
Subject: Re: [PATCH 5.10 00/80] 5.10.142-rc1 review
Message-ID: <20220907044316.GA854810@roeck-us.net>
References: <20220906132816.936069583@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220906132816.936069583@linuxfoundation.org>
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

On Tue, Sep 06, 2022 at 03:29:57PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.10.142 release.
> There are 80 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 08 Sep 2022 13:27:58 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 163 pass: 163 fail: 0
Qemu test results:
	total: 475 pass: 475 fail: 0

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter
