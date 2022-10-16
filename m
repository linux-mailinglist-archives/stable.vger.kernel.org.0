Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B1DA2600300
	for <lists+stable@lfdr.de>; Sun, 16 Oct 2022 21:19:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229646AbiJPTTu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 16 Oct 2022 15:19:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36420 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229728AbiJPTTs (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 16 Oct 2022 15:19:48 -0400
Received: from mail-ot1-x32e.google.com (mail-ot1-x32e.google.com [IPv6:2607:f8b0:4864:20::32e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 85E7B12D1D;
        Sun, 16 Oct 2022 12:19:46 -0700 (PDT)
Received: by mail-ot1-x32e.google.com with SMTP id r13-20020a056830418d00b0065601df69c0so4709032otu.7;
        Sun, 16 Oct 2022 12:19:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=3+0uGCjNX6LYmm7nh4i76mW8/2lrPNJWHlxvDvv+m+8=;
        b=S6YuVJauLW01FeY/HWdDzPYzqX4mr+V8kTLB8V8e1Cnfhxa62x9+LKj8KARr9WV3Zb
         1DENoa0lgXPK7Lm4lUjoKRlfiYq3Ym0CTlnI6/s/Q0eZdaGVBYjRJUiXH7Td+atr4Jf4
         igd9Mu8X4NiiGdd34+uyPsPJSiHQ/nykdk7wECGgMkB7nkmNmRKG9i6BuwhITDOYEDkx
         smlhQ/K/d1wmvx4Iyu+oorPVkRiowI0JaT1poxOi7Ksd5N1HnmLnCCXUE2FXJ9MZMXtj
         GKmtVAJXLDAgEposno0SPoVBbghfTiCk2i2xxx7YUQ3et8e17+o9oeye0ZfIJmxd0N4z
         lcXg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=3+0uGCjNX6LYmm7nh4i76mW8/2lrPNJWHlxvDvv+m+8=;
        b=MbVLfcpMoZtCtW2A9QpZiaGOxZC0/b6hmYyUyi1FlqPrenaDkR7jMLamPRtmHEqWfi
         DcNMkmHA1EufuUmvWG8yKNP9xvZq17J/UEb2tYgpzlWsmYBVhgkd/xrFR1LZUVJSWqoE
         heRcqEsSPEjNqiZfEzkn3HF07c43zKGwnrjphAaUQCFYDDEIyHCJBplASTRpcZtlswRG
         lILeIz4GVhysunObfmxproIkCkvDmQdHNC1iIsy4NEKpn0f0TWS9QKIP7WZeQeS/A/YF
         uh63Ef6MgPRdnapJtey55NO5tSkXMTXNMSI7poSyPGn/XYIS7vkXuL7OOczumNLqCYOG
         ODkQ==
X-Gm-Message-State: ACrzQf36B4OfhzNjw0EvQAxQMSOGjF7tcmkq/xKJCyl5dmmmtlw4uILe
        ATnNIa5sJlIvcA+TMjrsgYY=
X-Google-Smtp-Source: AMsMyM6Pxn+1a8kJC8PCosTL7GIQ3C2bqgMiI/MNQzpOgTMZfTs80i03UYjHatFgTb6EeiiJye5gKw==
X-Received: by 2002:a9d:2901:0:b0:661:c8d3:6b1e with SMTP id d1-20020a9d2901000000b00661c8d36b1emr3404742otb.229.1665947985919;
        Sun, 16 Oct 2022 12:19:45 -0700 (PDT)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id p65-20020aca5b44000000b0035418324b78sm3594456oib.11.2022.10.16.12.19.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 16 Oct 2022 12:19:45 -0700 (PDT)
Sender: Guenter Roeck <groeck7@gmail.com>
Date:   Sun, 16 Oct 2022 12:19:44 -0700
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        srw@sladewatkins.net
Subject: Re: [PATCH 5.10 0/4] 5.10.149-rc1 review
Message-ID: <20221016191944.GB1277641@roeck-us.net>
References: <20221016064454.382206984@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221016064454.382206984@linuxfoundation.org>
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

On Sun, Oct 16, 2022 at 08:46:10AM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.10.149 release.
> There are 4 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Tue, 18 Oct 2022 06:44:46 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 163 pass: 163 fail: 0
Qemu test results:
	total: 475 pass: 475 fail: 0

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter
