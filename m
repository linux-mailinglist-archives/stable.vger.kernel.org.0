Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 12C9969E468
	for <lists+stable@lfdr.de>; Tue, 21 Feb 2023 17:20:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233381AbjBUQUq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 21 Feb 2023 11:20:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45270 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229549AbjBUQUo (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 21 Feb 2023 11:20:44 -0500
Received: from mail-il1-x12e.google.com (mail-il1-x12e.google.com [IPv6:2607:f8b0:4864:20::12e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 471012BEE8;
        Tue, 21 Feb 2023 08:20:42 -0800 (PST)
Received: by mail-il1-x12e.google.com with SMTP id e9so2007401ile.8;
        Tue, 21 Feb 2023 08:20:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=lvy3YpG6fUfsNhQdLT4uSWASabiPlYT3UrmLmjXm6og=;
        b=IdJWNTKxjvxJcywtwglQBUyWbO9cOEP3vGfkHalfnXvaCJjKrJrJZSZ29wxDTRDlX3
         ywh34N/qYtJ9krPU9lR4I263YK14US9Hd9HICz/YiCC0SRWe21lGu43PPpnF291TPT1O
         Dve9OI/LxFbUhEE2eoyGFOEoL4vKayJjrU0qduOOyxtL84OHjLWzulVo0RoAh/PAEcNO
         XKvWi//1jiLMP1Wjk1KglF/AxVS0OMFXzhCQ1/2wd/AgWXYuKXwfGlSk/OmSmlmMPaHY
         4J/+j5YPy59lpldIJGDcFCBHvOHOu9K6Cn6e8uCDTCxTJaSTUAMC3yFzERyUkv8GYM65
         RluA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=lvy3YpG6fUfsNhQdLT4uSWASabiPlYT3UrmLmjXm6og=;
        b=NqpCC2zODG7bjHwIMQTSjT7SexoDmPVlGzqUznoBBCD3dtMHqQ9+VL3/lb138L7fo+
         su0qSAu5SGydvuJ6M/DIzCrJmHa+SufKrkW9xDCPY5pCFE8pcHKAiRnewyIhE57z2yXz
         Ax+NNTuXD29jVYwk4p9Qz+gblGkw5WE+c/1wLa19orBFTQY3nzcsO791oCSgFDl24w0/
         CCBhF1TXVjGgw2qdZQOEkwRab4dreFC/fRKahGOSveCXTMONByi0jzVj4Ub1d6FHwX4Z
         gplmtlFYjwRIRzzxXWff4J9crnHs+8GT+X3AHrLI2B27pF7eICX6gOeLJT/T7j5r5NNw
         Ou2Q==
X-Gm-Message-State: AO0yUKXWIzu75UI/+RdWBJ8YatTNYcWn15ll1Z6BkqTdT0aHtxsgRbaR
        Epm3VoB9xH0rFEaw6hfJayduuPnme7E=
X-Google-Smtp-Source: AK7set+NbUBthW2fUIHGs5Yt+sBytF1d2+YkSigavPKpcfVcZkR7jcKCc7F1A+dpadvZPlELHHleXA==
X-Received: by 2002:a05:6e02:1849:b0:316:dc3a:fe80 with SMTP id b9-20020a056e02184900b00316dc3afe80mr2533906ilv.0.1676996441657;
        Tue, 21 Feb 2023 08:20:41 -0800 (PST)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id j7-20020a056e02014700b00313d32f8345sm1926175ilr.66.2023.02.21.08.20.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 21 Feb 2023 08:20:41 -0800 (PST)
Sender: Guenter Roeck <groeck7@gmail.com>
Date:   Tue, 21 Feb 2023 08:20:40 -0800
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     stable@vger.kernel.org, patches@lists.linux.dev,
        linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        srw@sladewatkins.net, rwarsow@gmx.de
Subject: Re: [PATCH 5.4 000/156] 5.4.232-rc1 review
Message-ID: <20230221162040.GC1588041@roeck-us.net>
References: <20230220133602.515342638@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230220133602.515342638@linuxfoundation.org>
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

On Mon, Feb 20, 2023 at 02:34:04PM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.4.232 release.
> There are 156 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 22 Feb 2023 13:35:35 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 159 pass: 159 fail: 0
Qemu test results:
	total: 450 pass: 450 fail: 0

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter
