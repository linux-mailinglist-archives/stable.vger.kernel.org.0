Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8EF035ED288
	for <lists+stable@lfdr.de>; Wed, 28 Sep 2022 03:14:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230338AbiI1BOm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Sep 2022 21:14:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54878 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229841AbiI1BOk (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 27 Sep 2022 21:14:40 -0400
Received: from mail-pl1-x62c.google.com (mail-pl1-x62c.google.com [IPv6:2607:f8b0:4864:20::62c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 25049103E;
        Tue, 27 Sep 2022 18:14:38 -0700 (PDT)
Received: by mail-pl1-x62c.google.com with SMTP id z20so3664006plb.10;
        Tue, 27 Sep 2022 18:14:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date;
        bh=Zz63sh6ziZfudWEok2q3Ab7KLg83YcR0iqo37cu5uTE=;
        b=O6+L6OxGSg5aQ2TJDjFm1AsKmtUPP6dHhtpFbm2y0R17+HHp27tFZ4N4c6S00LVQOL
         RLRx+sWQShTOr3f+u+TKmxWA1M1SAfgT7p/nmL4jFnuKq86xMUBb8gG5f8lksukLJrOj
         sF9fTr8uDeUuQQRxgzUJscboMek7Bpl+WzDOt3lfU1ayueg2apv0SIeDFUv4bHKUIFkG
         8Hoz/qJfqAxM1Ec1lEqO5FFMp9b/cl4s2UqGi7Kv96GIRkfqU8qQfl+i4sCQc49vEXhd
         ZhrX8TVKmbFfpPQ67r3oA9eAXGtYqwpXcrYtbsifpH+4Ma90mHE/IoWUfK2ShJayDv/f
         HcJQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:x-gm-message-state:from:to:cc
         :subject:date;
        bh=Zz63sh6ziZfudWEok2q3Ab7KLg83YcR0iqo37cu5uTE=;
        b=PIYn92H5pWk0NF9TmZwQwAilqR57jcrJjBENctm9vxRTiyvi2NJCXYFpUuZzRn0ysZ
         fn+71b88sk+kAYmgvg12fqIGNMNFP7FQ0Oz9/fEA3lDZSZLcW0s9FtTkDODYKHpumLDm
         piPN3YPITn1XNeshsNEUBYdE+9iTKLfi+vXaUP8Cm+KWZIIXigQsJYyZoQ9HhJy+R1oj
         0L+vcR+83nJMT8L6bX3ebgafAnaI+GnEzz2py9H7y+RDobSl7MMRPlsQsv5NU2d8Mgg7
         mmd6fX7fUEEAvtdFMEUqhBNQ4jOS3GaGzDW1638+SsUKZgd24ib2sMtIapul/qofoBXk
         om0A==
X-Gm-Message-State: ACrzQf3tk9+srqsNIRX+1gEhaGpXcp1rdbYFQY0X9rBScsbJ8d7zd9/W
        YQtRioT79NYom0gCyi5eGs8=
X-Google-Smtp-Source: AMsMyM5NoqP42TfWttCYMa1O337r1xw9JXKZPURvCXi/6E2elCiGlc3RtmP1ZHIPsOXxaXDTX3m8Yg==
X-Received: by 2002:a17:902:7589:b0:178:4ded:a90a with SMTP id j9-20020a170902758900b001784deda90amr30078632pll.74.1664327677673;
        Tue, 27 Sep 2022 18:14:37 -0700 (PDT)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id y22-20020aa79af6000000b0053b850b17c8sm2415752pfp.152.2022.09.27.18.14.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 27 Sep 2022 18:14:37 -0700 (PDT)
Sender: Guenter Roeck <groeck7@gmail.com>
Date:   Tue, 27 Sep 2022 18:14:36 -0700
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        slade@sladewatkins.com
Subject: Re: [PATCH 4.19 00/55] 4.19.260-rc2 review
Message-ID: <20220928011436.GC1700196@roeck-us.net>
References: <20220926163538.084331103@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220926163538.084331103@linuxfoundation.org>
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

On Mon, Sep 26, 2022 at 06:36:43PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.19.260 release.
> There are 55 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 28 Sep 2022 16:35:25 +0000.
> Anything received after that time might be too late.
> 
Build results:
	total: 157 pass: 157 fail: 0
Qemu test results:
	total: 423 pass: 423 fail: 0

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter
