Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3021E5967F9
	for <lists+stable@lfdr.de>; Wed, 17 Aug 2022 06:24:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230221AbiHQEYt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 17 Aug 2022 00:24:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48012 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229807AbiHQEYs (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 17 Aug 2022 00:24:48 -0400
Received: from mail-pl1-x636.google.com (mail-pl1-x636.google.com [IPv6:2607:f8b0:4864:20::636])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 533536B8FF;
        Tue, 16 Aug 2022 21:24:48 -0700 (PDT)
Received: by mail-pl1-x636.google.com with SMTP id u22so2731887plq.12;
        Tue, 16 Aug 2022 21:24:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc;
        bh=m2zvuN/KHMxBv6pMHUuoCAdTkOJOJy9bh9tnfk5o8BI=;
        b=jfk2y7kVKsARLMfub1KeeU/B2oM0i1wPe3OlpzmhZwDfH21GbxMsWAwqLx+/fmj6zg
         QL+o1ItAF1aSEDD46qiFCg1cmKKBUPO/16IfSVZ4o5NWP36DHVud88m6rDqnfAGWunpG
         DrMlXhIrM6m/K2CMbPqqEowEjOUjqV1iJz8xU8o3EBDevLzrafiozGJuBUB+59nsKIdp
         VtBxpmh7yc9iyG99KSHmTHhRYclMHhN+rYgoZVsluh1VBjnyVhn/nrRmpRSDEeOy4vVs
         TXMhWX42LpxdSaKoWOVPGO4IVp9p0qXdUiJYZmnRjlZGHL9u6D7kQrbWhIgAPJFydMMG
         6eYQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:x-gm-message-state:from:to:cc;
        bh=m2zvuN/KHMxBv6pMHUuoCAdTkOJOJy9bh9tnfk5o8BI=;
        b=eZCx/dGZ7JXLnRQEg8hC/FVLGS8f5jEWBICD6UNEli58SC8oD0uurseFmGNg1LGvoR
         /qoTK8pYAf6FQfEt+XzAUMbJ2v5qFL9VgdOzpj0AOMHHjDNt4adPq0oKJv5wkTFj20zB
         92QkzDLzLgk5Px4DYeTvU+O8/E4gs+VRB5xtTmptsg2ezwEG3fQ7jMTXpE8gv2HW3s6J
         2PypfDL7V7MQ6HRxzcvoBcBc2M35Q4XJn1mF8TFr6gByuo3HNx2gffbA80ND3aMOQTBu
         jMqMTADSoIvQqyrp+L9sTUy0I91yt3X2geBtFbwDEJBmjMNwWUZ1/sT/3P7VBSxOR1XK
         SbkQ==
X-Gm-Message-State: ACgBeo0EPEBqmqjo54VrGBWVU4XlHFuUs+4UWDPZMKxXtVU8C3qAf2jn
        NyUpDfhXeTbQ1CPktvllVvR5761UcQM=
X-Google-Smtp-Source: AA6agR584FqfevFJk6HVYHSYhA/RFgsBtlHK03+kL4XRUSPLUgo+tM8tLzF9cDPzwoUkM4j3cD2yRQ==
X-Received: by 2002:a17:90a:1b65:b0:1f7:4725:aa6e with SMTP id q92-20020a17090a1b6500b001f74725aa6emr1839666pjq.179.1660710287832;
        Tue, 16 Aug 2022 21:24:47 -0700 (PDT)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id k4-20020a170902c40400b00170953de050sm262410plk.50.2022.08.16.21.24.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 16 Aug 2022 21:24:46 -0700 (PDT)
Sender: Guenter Roeck <groeck7@gmail.com>
Date:   Tue, 16 Aug 2022 21:24:45 -0700
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        slade@sladewatkins.com
Subject: Re: [PATCH 5.18 0000/1094] 5.18.18-rc2 review
Message-ID: <20220817042445.GC1880847@roeck-us.net>
References: <20220816124604.978842485@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220816124604.978842485@linuxfoundation.org>
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

On Tue, Aug 16, 2022 at 02:59:27PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.18.18 release.
> There are 1094 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 18 Aug 2022 12:43:14 +0000.
> Anything received after that time might be too late.
> 
Build results:
	total: 154 pass: 154 fail: 0
Qemu test results:
	total: 481 pass: 480 fail: 1
Failed tests:
	arm:bletchley-bmc:aspeed_g5_defconfig:notests:usb0:net,nic:aspeed-bmc-facebook-bletchley:rootfs

The failing boot test is new and not a concern. I'll see if I can figure
out why it fails. If it is too difficult to fix (for example because 5.18
simply doesn't support usb on bletchley-bmc), I'll just skip it next time.

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter
