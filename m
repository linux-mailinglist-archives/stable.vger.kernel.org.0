Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0C712532C8A
	for <lists+stable@lfdr.de>; Tue, 24 May 2022 16:49:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233163AbiEXOti (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 24 May 2022 10:49:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58294 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229967AbiEXOtg (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 24 May 2022 10:49:36 -0400
Received: from mail-wm1-x334.google.com (mail-wm1-x334.google.com [IPv6:2a00:1450:4864:20::334])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 059EA9B186;
        Tue, 24 May 2022 07:49:35 -0700 (PDT)
Received: by mail-wm1-x334.google.com with SMTP id c9-20020a7bc009000000b0039750ec5774so1537871wmb.5;
        Tue, 24 May 2022 07:49:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=HSe3SR6LmDG7CRp32Ute9I1Li7XkZpuPhrErvCpv9tA=;
        b=On00eNXzQza82e6YpgabAa76bbKkkofRjnCgyw55PkU2abxrQT9l156TmQpLWOx+IK
         jvSfq/647oEIJnk7T2Y3pROcpCtaEMa1HDv+IP+Q0fpvmTotR1XCuov6MrCsnM7uYrmH
         PpVdZxHXIOwq4fTAOJ+hepr8j9FRgOnyn56C4J4/kd4vkunYTnJEoGy+R1zvse3ggyIz
         2kGZtGwuVEXqwWDVZf4+OQ8TPH966t54Z5tQFN3URObb64ispknoIFjZgMioLd2rb5Fe
         IJn8u1496acXARtAYmQWfQ2czZx0we1L5zlyxiHoNmPp9ESSN5szp3tQYXWRhctFpObp
         QgkQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=HSe3SR6LmDG7CRp32Ute9I1Li7XkZpuPhrErvCpv9tA=;
        b=ZG8u+6AM0RpmpvQPMmnr+vNDl010ty76HNYyn7DWA637h/TkloLEdp9H5iLQxMy0LV
         MWRHsh54wU+49AKcptUqkh0MwPT0ajWuYtdreHI+JKX6En3Q6k+mlwS4nPqHnLr/Bzbv
         NC+9QYEbGmmStHnZSgf9SZOj+32jHbdiRA6nvBU9iVE/oo9JofDFxSRJs9qyyhIYgnei
         A9qlhq8pq0q1PnPuNuKLmzJxXrps++zYB1oj/GmO5L+FVUYBSPr9Yg9IYFWDtgez2V70
         m/9y7lSWkU7lDk5V88KoxqiVMOvPZNOYT6BvU4rbM6GPKfPFc4m1ggDwJ/zWfsTRBIPb
         4DcQ==
X-Gm-Message-State: AOAM530v7p2R4QYMe+WpPzpXubn76sAw05pBQs1mJK2b7xsDvRzNx3zx
        9mudQ8HVhr/t2xAQpT0Yafw=
X-Google-Smtp-Source: ABdhPJzQohh04YZUq4Cyo9izrUyZiibZvCLf5v4wnsBfI7EcyV4MVcETM2DiwJqyfODCLqxDl7mpgg==
X-Received: by 2002:a05:600c:4f95:b0:394:8919:7557 with SMTP id n21-20020a05600c4f9500b0039489197557mr4266713wmq.166.1653403773385;
        Tue, 24 May 2022 07:49:33 -0700 (PDT)
Received: from debian (host-2-98-37-191.as13285.net. [2.98.37.191])
        by smtp.gmail.com with ESMTPSA id c23-20020a7bc857000000b003942a244ebfsm2241235wml.4.2022.05.24.07.49.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 24 May 2022 07:49:32 -0700 (PDT)
Date:   Tue, 24 May 2022 15:49:30 +0100
From:   Sudip Mukherjee <sudipm.mukherjee@gmail.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, slade@sladewatkins.com
Subject: Re: [PATCH 5.10 00/97] 5.10.118-rc1 review
Message-ID: <YozwemCxrd5uXanL@debian>
References: <20220523165812.244140613@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220523165812.244140613@linuxfoundation.org>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Greg,

On Mon, May 23, 2022 at 07:05:04PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.10.118 release.
> There are 97 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 25 May 2022 16:56:55 +0000.
> Anything received after that time might be too late.

Build test:
mips (gcc version 11.3.1 20220517): 63 configs -> no failure
arm (gcc version 11.3.1 20220517): 105 configs -> no new failure
arm64 (gcc version 11.3.1 20220517): 3 configs -> no failure
x86_64 (gcc version 11.3.1 20220517): 4 configs -> no failure

Boot test:
x86_64: Booted on my test laptop. No regression.
x86_64: Booted on qemu. No regression. [1]
arm64: Booted on rpi4b (4GB model). No regression. [2]

[1]. https://openqa.qa.codethink.co.uk/tests/1198
[2]. https://openqa.qa.codethink.co.uk/tests/1201


Tested-by: Sudip Mukherjee <sudip.mukherjee@codethink.co.uk>

--
Regards
Sudip
