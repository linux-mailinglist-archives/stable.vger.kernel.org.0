Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F39CB6C4ED2
	for <lists+stable@lfdr.de>; Wed, 22 Mar 2023 16:02:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229841AbjCVPCW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 22 Mar 2023 11:02:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47252 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229999AbjCVPCU (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 22 Mar 2023 11:02:20 -0400
Received: from mail-qt1-x831.google.com (mail-qt1-x831.google.com [IPv6:2607:f8b0:4864:20::831])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3542853DB1;
        Wed, 22 Mar 2023 08:02:14 -0700 (PDT)
Received: by mail-qt1-x831.google.com with SMTP id w25so358318qtc.5;
        Wed, 22 Mar 2023 08:02:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1679497333;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=oYQM2jTlS604YN00nsC6X2GY/6e0UfH9fOU0JivRqjA=;
        b=BepWEHbj3mt2tBk5UbRdoICuoZOmlUmehPOK+rh8KH6n7Gkz3nDN6yexr1uFBBCN08
         n93JvWdYsFafoBStPlqo7Pfh2+dm6S3wgmHXiRf8EPgjomkKbXnRMWkD+T+9MZ/L9y7f
         keA59Fx/mRmtKbiefe/YRaJL8tq99rW6rsHVf5pKq1dE0fOKaS7QfthYIdv3MOCOfoiv
         dFyBizEhGxWmjyLPygxqW/tLFjKFhub+UAVsofox9zIGFV4H+QEmP9t/V12hN8d3bzY2
         TOq7dLlK/9EdNk259OqeXrnrRCWLZg74+kSBn8lUWYvcCmqMj74T/+yur75BVJFJMjp4
         FczA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679497333;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=oYQM2jTlS604YN00nsC6X2GY/6e0UfH9fOU0JivRqjA=;
        b=oCaymZu2J7n8wd4GVyzqmbnwfgkryrkIKm6zWIVz9eXEwOzA41quAdG2rH/7w9wOm3
         xJTwKjBsRaspxo2Okz/3D2iToQk0P867OTCnHdweyMnHuQ08h5ApOePTzNxgmr6HWHpw
         vGjHxyEC2R2UMJ3hgWwpQOBAsCs+Hsi+hLI5j3v+3RL/6/mJikXHr+MkcCF5VCXZdCOh
         g/FW2NitR7D1jfUxoEdoK61V8ULLPRvEpSq79nHpVqD2S1CY+cnGuueVpMTiOa8bW3r1
         cVg6L/ra7VRigSACEA9OjGAxKuvP5qXpeGx6f1Vmm/UUGlJe1nSwl2MODrJ2roI5x652
         FmSA==
X-Gm-Message-State: AO0yUKU4POfp79wlJPt5s6VQdWiUG4w0aR5Mgg9l+taFB6RKRmeWI8Km
        7ds4JchjuxmxVWja0x2OVhs=
X-Google-Smtp-Source: AK7set+VSdynk8EYuC29vErScyxFanU8Uii9XxtvdSxj02AVCP1dgudhg6cXvrFOxzfMt0SkyJCcBw==
X-Received: by 2002:a05:622a:314:b0:3bf:cfe8:f8f5 with SMTP id q20-20020a05622a031400b003bfcfe8f8f5mr6794567qtw.41.1679497333222;
        Wed, 22 Mar 2023 08:02:13 -0700 (PDT)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id d3-20020ac851c3000000b003e37d646221sm3990901qtn.96.2023.03.22.08.02.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 22 Mar 2023 08:02:12 -0700 (PDT)
Sender: Guenter Roeck <groeck7@gmail.com>
Date:   Wed, 22 Mar 2023 08:02:10 -0700
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     stable@vger.kernel.org, patches@lists.linux.dev,
        linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        srw@sladewatkins.net, rwarsow@gmx.de
Subject: Re: [PATCH 6.1 000/199] 6.1.21-rc3 review
Message-ID: <ea7d76f4-806d-4643-8339-aced5bf4b858@roeck-us.net>
References: <20230321180747.474321236@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230321180747.474321236@linuxfoundation.org>
X-Spam-Status: No, score=0.7 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,FREEMAIL_FORGED_FROMDOMAIN,
        FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Mar 21, 2023 at 07:08:16PM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.1.21 release.
> There are 199 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 23 Mar 2023 18:07:05 +0000.
> Anything received after that time might be too late.
> 

It is still Wednesday here, but v6.1.21 has already been released.
Sorry, my test bed isn't that fast. No issues reported yet, but
it seems pointless to send final results at this point. I'll only
report if there is a problem. Same for v6.2.8.

Guenter
