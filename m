Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D5D7C64AC71
	for <lists+stable@lfdr.de>; Tue, 13 Dec 2022 01:28:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233850AbiLMA2N (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Dec 2022 19:28:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47176 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233883AbiLMA1l (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 12 Dec 2022 19:27:41 -0500
Received: from mail-oi1-x236.google.com (mail-oi1-x236.google.com [IPv6:2607:f8b0:4864:20::236])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8C9931EAEA;
        Mon, 12 Dec 2022 16:25:38 -0800 (PST)
Received: by mail-oi1-x236.google.com with SMTP id s187so12835043oie.10;
        Mon, 12 Dec 2022 16:25:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=HjhAEhNy4eBz0xtQln6cgYjayNXGTWsSk8Q5Ye+0zcU=;
        b=FmIEJwgvNlXRTvqKSvAGzatkGqI7kzhAcmwAz1d12dSMm78DRc1Ki9jDTTYMzL1F8r
         2lSFrevaF7b1CFDdpmAXKr2WWpx08aYT793tt0WNw5PTBe4mql/2voi+//2UDN1A50xO
         vta8z5b7TiDxh4GVsbst/w0Hw0gSWL0htbaE0zCfOyK2yBskiw5WNYfZciE0KpS1+KiE
         JJmVZxnQNd3iAQktFRajsedXm4NfPTVcW7U9T6rEC/Yvd1U1Fz9+Bgh1j7yDKcJQf3s+
         vAO2p15i3nuCEPZTd0MDWq+Ww6zel5qQNNelWBiYYqCBUlpl+M8vzUnlubntlTujpNrK
         lfrg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=HjhAEhNy4eBz0xtQln6cgYjayNXGTWsSk8Q5Ye+0zcU=;
        b=ImSyItt6EUazlg+BEx+TBIrh5OCx3MY2A5uEqTC8p/h08y2OvxP9o8H5psZnbHZWKu
         utsf12Zo6RNPigtnFE/aKiijYgpsYv8vD5Y9i53L8Voj19pZK/5B6L2NKh5/iqv5T8Z6
         SfVl8NlYehIFgsKlBbiqIi1o0a4Qr/pNh4IJp5Sn24I+sBZeVmMKoVAxJ9D85XJ1OMtI
         M//qROGmkKZaJoO6yHvszoYBBu181lGhIr9Lllete29qvGijXzFZrV5+zijp+LHRmntC
         BSNXNrrhWkTa/wu/XpAp0p1Hm+G0wbOTFWiqY6DBvSv5qufthTBvn+Ef1G9dRxczkaA6
         L0HQ==
X-Gm-Message-State: ANoB5pmZfz7huPHK1ZwQp+bqkQX1SepTY4bqgBXv5ecJP8d9Ky5Hkk+F
        sxY2AsFcfviy0OMtp0Uunr8=
X-Google-Smtp-Source: AA0mqf5sdy4PFIu9ZH/vUGeGoeF9W7DuK7dztuSjeyeOKkE2dXAmxUNwCArg96qatQLPjowvXaBorg==
X-Received: by 2002:a05:6808:10c8:b0:35a:2325:7b04 with SMTP id s8-20020a05680810c800b0035a23257b04mr10158574ois.54.1670891138202;
        Mon, 12 Dec 2022 16:25:38 -0800 (PST)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id 5-20020aca0605000000b0035a7fc53a26sm4030367oig.42.2022.12.12.16.25.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 12 Dec 2022 16:25:37 -0800 (PST)
Sender: Guenter Roeck <groeck7@gmail.com>
Date:   Mon, 12 Dec 2022 16:25:37 -0800
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     stable@vger.kernel.org, patches@lists.linux.dev,
        linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        srw@sladewatkins.net, rwarsow@gmx.de
Subject: Re: [PATCH 6.0 000/157] 6.0.13-rc1 review
Message-ID: <20221213002537.GG2375064@roeck-us.net>
References: <20221212130934.337225088@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221212130934.337225088@linuxfoundation.org>
X-Spam-Status: No, score=-1.5 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Dec 12, 2022 at 02:15:48PM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.0.13 release.
> There are 157 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 14 Dec 2022 13:08:57 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 155 pass: 155 fail: 0
Qemu test results:
	total: 500 pass: 500 fail: 0

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter
