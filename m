Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 13295536D85
	for <lists+stable@lfdr.de>; Sat, 28 May 2022 17:29:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237630AbiE1P3X (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 28 May 2022 11:29:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48338 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233773AbiE1P3V (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 28 May 2022 11:29:21 -0400
Received: from mail-wr1-x432.google.com (mail-wr1-x432.google.com [IPv6:2a00:1450:4864:20::432])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E8173175A6;
        Sat, 28 May 2022 08:29:20 -0700 (PDT)
Received: by mail-wr1-x432.google.com with SMTP id k16so4981002wrg.7;
        Sat, 28 May 2022 08:29:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=RyZiticXf+XdVOEgPcxMcKDhVfj059iHazDCUg4DtB4=;
        b=Y7LvlM5LMMlY0zJKbWlgqkF1bOb0ZO3jjQ9Q5DER8/DbkdXFUmetKX1dANZkX5LTay
         iovhwfk+fouRvV/SM/zn5p3tsuVwXB7I7f1Qh3ynMNMay9yhK4Sk3vcaBC8OrytLIJAW
         beyl7JIH3STHnc2q71OuLFfSpwtaHVgJY7zopnYSRyuIlyrsofRtJAcqq4qLbY/Qy6IH
         ncOVbS+EDBfDvNrKl+EIYlG3Q0wrHCl+CtwjT8UcH38syC52ci8jOA3La0O8+HbcCta2
         WQ7v9hzBxe9GHGusRM/0rhu1T1RY+/kMMnJTOSdtskFcZlOXY9cEJq8rjJ7B/ldHF+bD
         OdlA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=RyZiticXf+XdVOEgPcxMcKDhVfj059iHazDCUg4DtB4=;
        b=YX3oK5bTB8EeQvTSmX4DBJV7MIKSrfEDUxcthw/CudKJcdhCaz+zcuVgEgvDhMyHw4
         resnrl8Qqa+SBZTWb6gfoK3V1k/PFKBgvmVlOrA+nJy0MdZwSnWMZ/oWPnZpTuPIKzUH
         nZROol02Vn06k4YSwdS3sjKTU9L+Hov7SFGscOQmBqro19ooAsWJj0C3nvakU+ERzY2a
         tmqqCbJi9f7xwOKZLbE+ee+iGG8dQxAh2535ONySH8WWJtvAHrDZiYygHXF6wm6noyuy
         qW+5n15vkImGVxWswdcm16jt2hggzkXPfuYz211X/AQwn5E4oWukh1XV0cCd+cJ5k47y
         TtVg==
X-Gm-Message-State: AOAM532A2MtPoR3X6a2bcsNK17osRsAy6kY6EQ7hfxuzCFP75fQ8Jo2p
        6WcfdI/sXUpk+KpqGNV++TXJbOiJWUw=
X-Google-Smtp-Source: ABdhPJxk8NWwd1MpVxRtvnzynGS+eoL9nGQNsxYYLTa2RavI91tb+Si6G1RHIAzk6w0qnZF3lYhbmQ==
X-Received: by 2002:adf:ebc7:0:b0:20c:d65d:3f19 with SMTP id v7-20020adfebc7000000b0020cd65d3f19mr39357683wrn.613.1653751759503;
        Sat, 28 May 2022 08:29:19 -0700 (PDT)
Received: from debian (host-2-98-37-191.as13285.net. [2.98.37.191])
        by smtp.gmail.com with ESMTPSA id w1-20020a5d6081000000b0020fdc90aeabsm4399661wrt.82.2022.05.28.08.29.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 28 May 2022 08:29:19 -0700 (PDT)
Date:   Sat, 28 May 2022 16:29:17 +0100
From:   Sudip Mukherjee <sudipm.mukherjee@gmail.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, slade@sladewatkins.com
Subject: Re: [PATCH 5.10 000/163] 5.10.119-rc1 review
Message-ID: <YpI/zcih1HvyobxC@debian>
References: <20220527084828.156494029@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220527084828.156494029@linuxfoundation.org>
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

On Fri, May 27, 2022 at 10:48:00AM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.10.119 release.
> There are 163 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sun, 29 May 2022 08:46:26 +0000.
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

[1]. https://openqa.qa.codethink.co.uk/tests/1218
[2]. https://openqa.qa.codethink.co.uk/tests/1220


Tested-by: Sudip Mukherjee <sudip.mukherjee@codethink.co.uk>

--
Regards
Sudip

