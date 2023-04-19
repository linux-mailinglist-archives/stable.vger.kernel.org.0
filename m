Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A6F776E719B
	for <lists+stable@lfdr.de>; Wed, 19 Apr 2023 05:33:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229980AbjDSDdL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 18 Apr 2023 23:33:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52964 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229884AbjDSDdK (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 18 Apr 2023 23:33:10 -0400
Received: from mail-pl1-x62a.google.com (mail-pl1-x62a.google.com [IPv6:2607:f8b0:4864:20::62a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3E51E2708;
        Tue, 18 Apr 2023 20:33:07 -0700 (PDT)
Received: by mail-pl1-x62a.google.com with SMTP id q2so33146733pll.7;
        Tue, 18 Apr 2023 20:33:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1681875187; x=1684467187;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=5zouXbp8ZPl0MdWpzxDdQ30m2pJpDuz4uXDplfNvXnE=;
        b=qJDcdkdBGGZ11t7TxtBnbnOAxPxjMKpp+W492ZTMl8nSA37rFYoV/8tGgvfuz6hDji
         Ic2kTYRZmOiDXhkdhv+SHpfW1lttOkohXyAbNyl43r9/4yt6RFh1I3r0+gU51cuNJLKr
         olQ7vBeVVtxmXaF1mHK7xSQGAU8/y/Wf8P+ZP3oC7jduylxsx2i3lXHnBDUPBEw2L36Y
         W/9UCy2GeEM2RxSeqqDCtyCgIbU/lKOyWrORxH9M3UOGsaFn5T4NttgHMqoIg36P+G2v
         ytPu0WU3uoafGrZn6sowa5ihAzqdbDG8TYv1wKov6gO/4j7s4cNC/JSSNn66oJYACPzJ
         G/ig==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1681875187; x=1684467187;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=5zouXbp8ZPl0MdWpzxDdQ30m2pJpDuz4uXDplfNvXnE=;
        b=VPrnrAPXFdw6YCPGYc+xUFNiAtvifcfxCba3z/wl8XH9ZjNBdT4SzbOydxWKV7Ae4Z
         Y00/PoSOas3tL27iGzl0CeG5NjbU9zborNonahckAipXrbVWLROEzyj/qzDK5033L8zp
         EpLFxauaqW3Yoztp3if4Ac2D6Nk/YFv8uPn7muJGywZr8uFH3C2yju9zWTOWpczDLdje
         y2YEDj/KbQ90tVSTlAepqks8WB3COd44ngMBKs/+5dHfRIG+LO/1l3NUA4NRRNvVupdq
         XlD7OAHUw06aUmPRxCHvuf3GaG9Cqs4bpCAZR4u8OTqwS5vZiyhJzaxdHHo2KNW2bXTe
         C8pg==
X-Gm-Message-State: AAQBX9eF+GG33rAf4i+qIt0wOOM2s3FM7ZCPMNV3KG3VAQcZInk3WO0N
        sGpUdMKFKeX8cDdV5p1vxEOzMiWBWyk=
X-Google-Smtp-Source: AKy350aL3CS55612HBRg6wDR5eOE0B4NB3o76CO+7vysLQSHNmozyI/yzLumzO0+bivXo8zfj5N3dQ==
X-Received: by 2002:a05:6a20:158c:b0:f0:5920:77b1 with SMTP id h12-20020a056a20158c00b000f0592077b1mr2001520pzj.28.1681875186566;
        Tue, 18 Apr 2023 20:33:06 -0700 (PDT)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id a20-20020aa78654000000b00627e55f383dsm364815pfo.3.2023.04.18.20.33.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 18 Apr 2023 20:33:05 -0700 (PDT)
Sender: Guenter Roeck <groeck7@gmail.com>
Date:   Tue, 18 Apr 2023 20:33:03 -0700
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     stable@vger.kernel.org, patches@lists.linux.dev,
        linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        srw@sladewatkins.net, rwarsow@gmx.de
Subject: Re: [PATCH 4.14 00/37] 4.14.313-rc1 review
Message-ID: <ac457e3c-fdbc-430a-a0a8-8850c69e06bd@roeck-us.net>
References: <20230418120254.687480980@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230418120254.687480980@linuxfoundation.org>
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

On Tue, Apr 18, 2023 at 02:21:10PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.14.313 release.
> There are 37 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 20 Apr 2023 12:02:44 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 168 pass: 168 fail: 0
Qemu test results:
	total: 430 pass: 430 fail: 0

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter
