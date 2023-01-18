Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 10B5567101E
	for <lists+stable@lfdr.de>; Wed, 18 Jan 2023 02:38:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229624AbjARBis (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 17 Jan 2023 20:38:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54440 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229575AbjARBir (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 17 Jan 2023 20:38:47 -0500
Received: from mail-oi1-x232.google.com (mail-oi1-x232.google.com [IPv6:2607:f8b0:4864:20::232])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 07BCD5143A;
        Tue, 17 Jan 2023 17:38:46 -0800 (PST)
Received: by mail-oi1-x232.google.com with SMTP id r9so3305950oig.12;
        Tue, 17 Jan 2023 17:38:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=U+mLuTnVSSAD7w5mwhHi5UEgGDE84dVWZRrqxw0eEAM=;
        b=kA4AD5jaGRzxrKGfZ/f48vjc5qv6OVDkQqmihfVV3ZezGNSJa9KzkrE/tF0b8gIesR
         1RsJ4P/lP1+XrleyVobTQpv3/OW/m4s7TknMmLBfLcct0TJHw+fI+C7Vt2C4V30ag/iG
         g4Ie9kiLEeJ8sqdeG9NlfUcFNI6bTDmfFp+bAUWGaEDXW7YFYiZaoaJcDLaFqX9T+VKC
         oKbtAj9TB12eGUINMqPdehkOsog3gVP9atgDFvgHU7nKt27J8DVbVazDSp7qwu+rrySi
         ajpay8XiWcN21JEW6yydazYJytpyI7WfgCGH6CaJvOdlYOaGc+iELIYBJIgQkZzJ91/+
         8Gww==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=U+mLuTnVSSAD7w5mwhHi5UEgGDE84dVWZRrqxw0eEAM=;
        b=usahjS1M+3LBVCXM6xI7vvLU9jP3YqrnG7hWZjlyqzVM6A2mqaQC+1lLQN6TlAExx+
         KuPv1s1avoK6XPjBmOqKvlBz8wZBcAKQwUiwIOXYaYL2q+tUTPWiHmpoXKnbEhXu+P1G
         ecS+nNV9D9oAv1lzdZhY+QYOB3/fE7Nnmw9LbfsRpaOypPyZtWpRSX+7vrrDcV1omyDl
         G4PUYgcpnESkj4r4p3gTuuZ+oNplK/GTltbBKX9oXB5YHmncvMuQTvZR9+cyYlSwcwwB
         erV6mVBv7dBSXW0RcuwXf+vb777FuhCm3DluxRyWR71l5SHybb/nbgg3tKbTxaWYLSpp
         PDyQ==
X-Gm-Message-State: AFqh2kqH8FFVo/y5oFVZkqv8jgUyJCiA/hruBv08cmw8ilE9ssVBCSZd
        FaAaZQODpQa5YGhACr/VrK4=
X-Google-Smtp-Source: AMrXdXsZGZNNTvJRCoJB3U3rjREvBmFCn1e7Cv+4byADtBByjbU66lq5cL6uiXWVc3gVL4F1Sg6Iew==
X-Received: by 2002:a05:6808:1687:b0:364:c2a9:5584 with SMTP id bb7-20020a056808168700b00364c2a95584mr3430470oib.32.1674005925400;
        Tue, 17 Jan 2023 17:38:45 -0800 (PST)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id bt25-20020a05683039d900b0066e80774203sm17739933otb.43.2023.01.17.17.38.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 17 Jan 2023 17:38:45 -0800 (PST)
Sender: Guenter Roeck <groeck7@gmail.com>
Date:   Tue, 17 Jan 2023 17:38:43 -0800
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     stable@vger.kernel.org, patches@lists.linux.dev,
        linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        srw@sladewatkins.net, rwarsow@gmx.de
Subject: Re: [PATCH 5.4 000/622] 5.4.229-rc2 review
Message-ID: <20230118013843.GC1727121@roeck-us.net>
References: <20230117124648.308618956@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230117124648.308618956@linuxfoundation.org>
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

On Tue, Jan 17, 2023 at 01:48:21PM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.4.229 release.
> There are 622 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 19 Jan 2023 12:45:11 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 159 pass: 159 fail: 0
Qemu test results:
	total: 449 pass: 449 fail: 0

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter
