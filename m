Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7B00F4D3A4F
	for <lists+stable@lfdr.de>; Wed,  9 Mar 2022 20:25:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234853AbiCIT0U (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 9 Mar 2022 14:26:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55872 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230368AbiCIT0R (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 9 Mar 2022 14:26:17 -0500
Received: from mail-ot1-x32f.google.com (mail-ot1-x32f.google.com [IPv6:2607:f8b0:4864:20::32f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DF9F3326
        for <stable@vger.kernel.org>; Wed,  9 Mar 2022 11:25:17 -0800 (PST)
Received: by mail-ot1-x32f.google.com with SMTP id g6-20020a9d6486000000b005acf9a0b644so2463042otl.12
        for <stable@vger.kernel.org>; Wed, 09 Mar 2022 11:25:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=sZdhFaJEobLHUcXbgZ55Zl3n5c/STYpZoXh4bxvyXeo=;
        b=K51U7US/nV+BkVPmQJmjXEiv9gUhg6nSo1hKROyXZYMeYcrcBATR+1DdDO0+ZayScD
         TxGgiZCJDoAA75Plrcw5ly8nWEZBGWTWM0xSheapUbyXSF/xI3/rrPEYxyZVNiaHURW6
         KjlZNtHvOi41YlJktKdkgPhCMM7WJDRdUhtkY=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=sZdhFaJEobLHUcXbgZ55Zl3n5c/STYpZoXh4bxvyXeo=;
        b=iA3CTKzBTncxRGuUQ3GhNet3O4ve7z5IOiWl1z0735tV2Ju/1U+ZPAoVuux6h0SgVk
         PZ8F7GyD10UJC282jRrkgEUt/cNkKu1i81GZtfO04LpYyMY3pUBg7Lg3n+NrrfJv5+Sm
         RA69/adO1uCzR69IvMmqfMIj306wNxcTNC7wdtQViDutk1mLvY8f/cQ8quTyAFvUvLRY
         guYT+cKv2Ey+UjU/iFmGoTHj1WwC5DPrSBfyAm5iUOylsdWH/SPY0kQNn69Em01SMPI6
         jpMlrQ6yMGkWZtJpH8+bDSASmfwSL30qxVZwF7nGOP0xWZNXDTGkHTHwGSAjb929R3Gn
         02wA==
X-Gm-Message-State: AOAM533vxbe2+VV5H5+WE/29yqcvCPMev8hDyY67bWjDNKxpsG7KgbGa
        mw0ShZy0W7IWqR2N2td0HnnyUORjjaBUvz6AkO8=
X-Google-Smtp-Source: ABdhPJzbByZWjN5iZx2xqUPrHw3o0QeS8M/wxzYV7ZFXJ4B2bMkqSnnT1WZtzLcnwRQucD5uUkAAMg==
X-Received: by 2002:a05:6830:449e:b0:5af:e826:b507 with SMTP id r30-20020a056830449e00b005afe826b507mr720310otv.262.1646853916952;
        Wed, 09 Mar 2022 11:25:16 -0800 (PST)
Received: from mail-oi1-f171.google.com (mail-oi1-f171.google.com. [209.85.167.171])
        by smtp.gmail.com with ESMTPSA id j145-20020acaeb97000000b002d9f37166c1sm1354178oih.17.2022.03.09.11.25.14
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 09 Mar 2022 11:25:14 -0800 (PST)
Received: by mail-oi1-f171.google.com with SMTP id ay7so3684267oib.8
        for <stable@vger.kernel.org>; Wed, 09 Mar 2022 11:25:14 -0800 (PST)
X-Received: by 2002:a05:6808:2209:b0:2d5:1bb4:bb37 with SMTP id
 bd9-20020a056808220900b002d51bb4bb37mr710633oib.53.1646853913865; Wed, 09 Mar
 2022 11:25:13 -0800 (PST)
MIME-Version: 1.0
References: <20211217165552.746-1-manishc@marvell.com> <ea05bcab-fe72-4bc2-3337-460888b2c44e@molgen.mpg.de>
 <BY3PR18MB46129282EBA1F699583134A4AB0A9@BY3PR18MB4612.namprd18.prod.outlook.com>
 <e884cf16-3f98-e9a7-ce96-9028592246cc@molgen.mpg.de> <BY3PR18MB4612BC158A048053BAC7A30EAB0A9@BY3PR18MB4612.namprd18.prod.outlook.com>
In-Reply-To: <BY3PR18MB4612BC158A048053BAC7A30EAB0A9@BY3PR18MB4612.namprd18.prod.outlook.com>
From:   Linus Torvalds <torvalds@linux-foundation.org>
Date:   Wed, 9 Mar 2022 11:24:58 -0800
X-Gmail-Original-Message-ID: <CAHk-=wjN22EeVLviARu=amf1+422U2iswCC6cz7cN8h+S9=-Jg@mail.gmail.com>
Message-ID: <CAHk-=wjN22EeVLviARu=amf1+422U2iswCC6cz7cN8h+S9=-Jg@mail.gmail.com>
Subject: Re: [EXT] Re: [PATCH v2 net-next 1/2] bnx2x: Utilize firmware 7.13.21.0
To:     Manish Chopra <manishc@marvell.com>
Cc:     Paul Menzel <pmenzel@molgen.mpg.de>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Ariel Elior <aelior@marvell.com>,
        Alok Prasad <palok@marvell.com>,
        Prabhakar Kushwaha <pkushwaha@marvell.com>,
        "David S. Miller" <davem@davemloft.net>,
        Greg KH <gregkh@linuxfoundation.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        "it+netdev@molgen.mpg.de" <it+netdev@molgen.mpg.de>,
        "regressions@lists.linux.dev" <regressions@lists.linux.dev>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-1.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Mar 9, 2022 at 11:22 AM Manish Chopra <manishc@marvell.com> wrote:
>
> This move was intentional, as follow up driver flow [bnx2x_compare_fw_ver()] needs to know which exact FW version (newer or older fw version which will be decided at run time now)
> the function is supposed to be run with in order to compare against already loaded FW on the adapter to decide on function probe/init failure (as opposed to earlier where driver was
> always stick to the one specific/fixed firmware version). So for that reason I chose the right place to invoke the bnx2x_init_firmware() during the probe early instead of later stage.

.. but since that fundamentally DOES NOT WORK, we'll clearly have to
revert that change.

Firmware loading cannot happen early in boot. End of story. You need
to delay firmware loading until the device is actually opened.

                                 Linus
