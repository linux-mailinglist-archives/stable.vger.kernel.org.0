Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 937355689D3
	for <lists+stable@lfdr.de>; Wed,  6 Jul 2022 15:43:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233305AbiGFNmn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 6 Jul 2022 09:42:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41884 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233814AbiGFNmd (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 6 Jul 2022 09:42:33 -0400
Received: from mail-pg1-x52a.google.com (mail-pg1-x52a.google.com [IPv6:2607:f8b0:4864:20::52a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 683EE25584;
        Wed,  6 Jul 2022 06:42:33 -0700 (PDT)
Received: by mail-pg1-x52a.google.com with SMTP id g4so14080465pgc.1;
        Wed, 06 Jul 2022 06:42:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=DbjIk79fyg4YUcvWnOXH9cTaF4pGPrZq7GabLkQZPi8=;
        b=DBM+EzJagj6EqPDy5wsmNoq/KkUWG69D8LBACawkCaiuG15l+W4/XBEVJLLDaw/lUK
         4J/56ovzkWopcAlydZCuZg4we62eVig5puE9T7SNQ9QdTr3jaOkmqhFkjRu4bQKylhI1
         1r9voXrkgJoJD1C5UNPdtIlhbqZKa4tMTbgWCtNpA6Wr1Bz7Z+MFQB7ukUOqxBbrhUuT
         RmdPlbYyi25hV1qlOKG0KUUap8U6TtzZD5V/ce10oV67wa36QYRH2iwUgJZYKlhW/bIe
         Ms0UUVb9bYvsHUb/tZXddjHTZ7CIKIR3CgrFp4RFGVqX1Z6LNu6iKFb3Eied9+FCrOq4
         kVRg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to;
        bh=DbjIk79fyg4YUcvWnOXH9cTaF4pGPrZq7GabLkQZPi8=;
        b=6FF5Od/HQZT4Mmh8DSocvbfvL8Xbcd2IwzS3GQpVFT+4y4EnksAuUM/yOnbDYFGwuX
         MCfduvW15QRbqAbYN9i17+bBkhjSvZMYwfSPARTDtN7BQt3nF9aVzls7zSHpC64SXvge
         V1ypGxCZHzsggbVEgdrqZtsrEyrn/VO14ykzb7Ti/W3PA0FrwdJwOc4Gbr6C1TP5Un/o
         cgmtS33k7V2Kthvhl/QRV2+QPoWZLqJj6UkFiEtDkDESZTa0MVsGJJYWYbjhtbIl+EHj
         R1sQE76WvJjWsctluORUZh6ivAvqEiw3dsdVtWFe0HRbWjrrMkwpbUCRbHa/acsdrL2m
         RjPg==
X-Gm-Message-State: AJIora8j0j5H2ns6tGnVhLFoF1uUI2F3nvA949d8wQvIks5M93S6Xl/P
        /S5Qploe2MpLR+cBDl67QPw=
X-Google-Smtp-Source: AGRyM1tiTx60BnKGfpdssF9RB+V15F/h0sLYp/+Lpd0HHQ9wTKAf3aymp3q18xCPoEabjr9rQEO1Og==
X-Received: by 2002:aa7:93a5:0:b0:51b:e0f8:97a6 with SMTP id x5-20020aa793a5000000b0051be0f897a6mr46550932pff.44.1657114952955;
        Wed, 06 Jul 2022 06:42:32 -0700 (PDT)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id h14-20020a170902f70e00b0016be14a776asm7100751plo.286.2022.07.06.06.42.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 06 Jul 2022 06:42:32 -0700 (PDT)
Sender: Guenter Roeck <groeck7@gmail.com>
Date:   Wed, 6 Jul 2022 06:42:31 -0700
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        slade@sladewatkins.com
Subject: Re: [PATCH 4.14 00/29] 4.14.287-rc1 review
Message-ID: <20220706134231.GB769692@roeck-us.net>
References: <20220705115606.333669144@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220705115606.333669144@linuxfoundation.org>
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

On Tue, Jul 05, 2022 at 01:57:48PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.14.287 release.
> There are 29 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 07 Jul 2022 11:55:56 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 170 pass: 170 fail: 0
Qemu test results:
	total: 424 pass: 424 fail: 0

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter
