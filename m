Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B6B465FF69C
	for <lists+stable@lfdr.de>; Sat, 15 Oct 2022 01:08:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229588AbiJNXIX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 14 Oct 2022 19:08:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40462 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229459AbiJNXIW (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 14 Oct 2022 19:08:22 -0400
Received: from mail-pf1-x42f.google.com (mail-pf1-x42f.google.com [IPv6:2607:f8b0:4864:20::42f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A07D9C4DAC;
        Fri, 14 Oct 2022 16:08:20 -0700 (PDT)
Received: by mail-pf1-x42f.google.com with SMTP id y191so6217494pfb.2;
        Fri, 14 Oct 2022 16:08:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=xA9/arI+/naVtFonz1cU1+tqTyndVtYWYxi/ANmebK0=;
        b=g4wY4rJQafGVoy3K3vy1fTM/iLTHh6LQeW+Adgpng74I4Pb+74uwAIm9KZDhtHs1i6
         PalgkfPSBoAIHeltQjjtdeyRjb73F959KgtJ4YX+9Tsc+ciWtk7txA4IqJ8Axf8JPCiW
         qmR7akkRrKCdaZh4xR6q5I9G87S0jLpfTw4yv50/g57weazG+/E2eqwiqnCMd0fNg5b+
         gsQpzH+YkiXW9qXkQxstz4N0kTqFa3bDrspEJUTtlEEIqmk6yh3RkXFjvg0CdHTu/BoS
         5gZI0T+/hf6MqgodrwqLYw6n31ZeMRnOdjbkapQUtXIHg8I32UHJYhHBYhVLfeHv96Mp
         6ytg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=xA9/arI+/naVtFonz1cU1+tqTyndVtYWYxi/ANmebK0=;
        b=hXRNsCUuLFNklIkFbI2sPMjELnBPROKBHsooRui2KNDEbycIO0Xzl+r6xP6ndzE1IS
         LS4VrllXUQtefXoX6QA9Jf6exV+SAiw0LOR980RHEiAOtfLnEyXQc7pN+nR8fulzuZkL
         ++gnDJ04CMJLYyK2P/LxYmgXIec3xo22rtihZDJc0kO/HO1vuyAdihqKbW4i8dnQQFtw
         ZffCYluqsFs9lQCqiSlodQe96bpke4fbBT9OOGSYp5vkAeuL9cCEfP5LxVkzuVN4ccBS
         I0kBUyFM/w8TwUxbI5N+Cv5s5MnN8Dee30WLFVeDXOsR/1QDr3i3aPPEmZ4eNehNCagb
         w5AQ==
X-Gm-Message-State: ACrzQf3Ro28MFvje/+enq0xDkLugRq3NZcGEQnxOXRXLdwL3QNn4hOAY
        smeVbT4HG//WVJMEMSnijYg=
X-Google-Smtp-Source: AMsMyM4NITwkGp9BZIJ89YG3H42PPkSckMw6VTE+GiSi6tVUU7RHmuJp8UqWPH0F6GQ22aqLfZaSOw==
X-Received: by 2002:a63:1612:0:b0:461:4180:d88b with SMTP id w18-20020a631612000000b004614180d88bmr190983pgl.434.1665788900159;
        Fri, 14 Oct 2022 16:08:20 -0700 (PDT)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id i16-20020a17090332d000b00181f1f4fcc0sm2203905plr.202.2022.10.14.16.08.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 14 Oct 2022 16:08:19 -0700 (PDT)
Sender: Guenter Roeck <groeck7@gmail.com>
Date:   Fri, 14 Oct 2022 16:08:19 -0700
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        srw@sladewatkins.net
Subject: Re: [PATCH 5.19 00/33] 5.19.16-rc1 review
Message-ID: <20221014230819.GD4126318@roeck-us.net>
References: <20221013175145.236739253@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221013175145.236739253@linuxfoundation.org>
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

On Thu, Oct 13, 2022 at 07:52:32PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.19.16 release.
> There are 33 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sat, 15 Oct 2022 17:51:33 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 150 pass: 150 fail: 0
Qemu test results:
	total: 490 pass: 490 fail: 0

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter
