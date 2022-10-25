Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6952560C2AB
	for <lists+stable@lfdr.de>; Tue, 25 Oct 2022 06:31:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229506AbiJYEbo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 25 Oct 2022 00:31:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44294 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231259AbiJYEbb (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 25 Oct 2022 00:31:31 -0400
Received: from mail-oa1-x2a.google.com (mail-oa1-x2a.google.com [IPv6:2001:4860:4864:20::2a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C9D2FDDB58;
        Mon, 24 Oct 2022 21:31:30 -0700 (PDT)
Received: by mail-oa1-x2a.google.com with SMTP id 586e51a60fabf-13ba86b5ac0so5670747fac.1;
        Mon, 24 Oct 2022 21:31:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=grW/BvV5sKz3AguS7RIqCnQjI90+2M1SSEUDFsuzVnU=;
        b=IBqSkJLWEaov7LfilXKWcbSUHdZGL9JLFNSoRsEvoo+jLzP6lGbUBkce4EBNi+l4IP
         qJxmxBBpQHed/Sk6D7UlHnk/2EtZddAWLLADp6ngsbouZeOFbcgHXoXL41VU4DL+kPMf
         86ITF/yCxyejdnBQjMQYhtK0NfoeMHcBX/X+uM12ANAuicv6hXpgx3uko1IvonLLTCJ5
         abjZKEuEch6yyL0cdnDd49bEga99MuTLwrov5RGRws5mi4o7BtWxWb1MkFIBx82zcila
         sKBJlub2pkeXVgqHrdJjkftmU6Bi5TvDv1NyTSiXK4fCntgRc6Qt4VcYr7Kv/wjF1CBT
         G7Xw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=grW/BvV5sKz3AguS7RIqCnQjI90+2M1SSEUDFsuzVnU=;
        b=QLH3+xIhp4NFLB2c0G1kIUvLUYzF++P3pHA1s5ANmUTWFpQsh9KHsm6/YRJRl6W+ua
         fOW0NOqQ+iHbnizp6qDnkZwhLtsMFWM5NZz8n6akbFxM8j3Iar2U4ul8eF0fmsaz82i8
         KZatEUAHIWRhc3iYPY8eJfkndP8c1gl0PfFN+8X0l9Pn/HBYkkhPzupvu+kU/6Vvm8hD
         SXtFpj6CIRonoaJSupmJqZN2cyVn3Q6Hq+5tGyZD45Ofnk2cAcmM6hfLTfBhC9qccDMG
         QX0O2jJeksxZJgj17TTUq8GbSJ4zOan+cxwsdcNog4VD9PPy/0VZ469g7bC8E/NqXbZC
         higA==
X-Gm-Message-State: ACrzQf3OFjsbbMZzDVhlpv9AQKgKUnPmcRdKVCID+js2+g9JHwkfG1Wr
        ZKzEG35PbbPYXNqu9gTJRM0=
X-Google-Smtp-Source: AMsMyM70lBbq/hdvAHePpE0GnhFI0nYLmIZSgt3F0vlL211cE8Rte6W9+XHhxB0OboydwwDPT8eIGA==
X-Received: by 2002:a05:6870:4188:b0:12d:484a:2592 with SMTP id y8-20020a056870418800b0012d484a2592mr39819770oac.5.1666672290185;
        Mon, 24 Oct 2022 21:31:30 -0700 (PDT)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id m28-20020a056870a11c00b0012d6f3d370bsm969022oae.55.2022.10.24.21.31.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 24 Oct 2022 21:31:29 -0700 (PDT)
Sender: Guenter Roeck <groeck7@gmail.com>
Date:   Mon, 24 Oct 2022 21:31:28 -0700
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        srw@sladewatkins.net
Subject: Re: [PATCH 5.15 000/530] 5.15.75-rc1 review
Message-ID: <20221025043128.GF4152986@roeck-us.net>
References: <20221024113044.976326639@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221024113044.976326639@linuxfoundation.org>
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

On Mon, Oct 24, 2022 at 01:25:44PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.15.75 release.
> There are 530 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 26 Oct 2022 11:29:24 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 159 pass: 159 fail: 0
Qemu test results:
	total: 488 pass: 488 fail: 0

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter
