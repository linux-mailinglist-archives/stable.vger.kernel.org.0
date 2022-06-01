Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2CFF353A079
	for <lists+stable@lfdr.de>; Wed,  1 Jun 2022 11:33:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236040AbiFAJdX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 1 Jun 2022 05:33:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48972 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242772AbiFAJdW (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 1 Jun 2022 05:33:22 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 7EBCA8AE42
        for <stable@vger.kernel.org>; Wed,  1 Jun 2022 02:33:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1654075999;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=VuuX8qrSGJ4hyfsiDt/rM6t9GO/71AZB53O3hdvqWXI=;
        b=bdhC3W64gChtxoHObZd7iUZujqSUpNJcWAzohxM3p4miDLAyhzRz3gmGiCcjfvtb5yJZ9x
        7r/2utIx+uA61BMON2Giq85gauC682+cyglTmiWCxVtPcFdSF4+q39jSSOSi0r96HYWTj7
        kRQh9YA5nmiXwX2nWOf1lpPhonHvw2Q=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-259-Fc7LbQ6nMR2gtCJqvWNnVg-1; Wed, 01 Jun 2022 05:33:18 -0400
X-MC-Unique: Fc7LbQ6nMR2gtCJqvWNnVg-1
Received: by mail-wm1-f69.google.com with SMTP id u12-20020a05600c19cc00b0038ec265155fso3061747wmq.6
        for <stable@vger.kernel.org>; Wed, 01 Jun 2022 02:33:18 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent
         :content-language:from:subject:to:cc:content-transfer-encoding;
        bh=VuuX8qrSGJ4hyfsiDt/rM6t9GO/71AZB53O3hdvqWXI=;
        b=UrZfMxLXpKeUPv6yM5bRg90DPAzE7ThnZ4OQOUDBP5twGLCmHwi75JJz+45FOD+/bp
         6mm2AOf5kGRE6OmUtjop/YzeTy1QM8HBuZ5TrmtiBxt5OErsArsCKIuwshZzmNMHbo/M
         ZNkqr8udqM5eu+vuG5OAaOeIAW66mmUICuGkihv+Q1+cE8zX+F8DN7CqRGagse2qq2FD
         utnkpa3WlquJqhk5gRaUySp77whRjuMaw9E+1q63nQYdFaSGJAvVe4wGjv5cuU93qOgU
         OamJ2IeMaIPQ4wY8itOyZ+Uu7AbcWNmL966HAuieAAGb9WniipszObGj0StcDZ4b796K
         QJ3A==
X-Gm-Message-State: AOAM533A9MbFvrY8ZBUJI4oHqvFxQtWH9QddmNiqxFR13MzwwloHOc7d
        Fo9QLk5fHHjyHxG17c+p/qzIO9VehXl09iFu7Pv0E2QasUluNbSrxV6m4ZG6tR47Igy+f07WiwJ
        YxRE4/FILdlFGwOjq
X-Received: by 2002:a5d:584b:0:b0:20f:ec17:30b8 with SMTP id i11-20020a5d584b000000b0020fec1730b8mr35520934wrf.461.1654075997558;
        Wed, 01 Jun 2022 02:33:17 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyvPKsSO/EFfPQVcpaiIDFTmJhbxQDRZXO4y+u2IxIwew8MR3rn8Ub+0M0Zn3HNAQ5cwMZZdA==
X-Received: by 2002:a5d:584b:0:b0:20f:ec17:30b8 with SMTP id i11-20020a5d584b000000b0020fec1730b8mr35520919wrf.461.1654075997356;
        Wed, 01 Jun 2022 02:33:17 -0700 (PDT)
Received: from ?IPV6:2a01:e0a:c:37e0:f4b2:2105:b039:7367? ([2a01:e0a:c:37e0:f4b2:2105:b039:7367])
        by smtp.gmail.com with ESMTPSA id j22-20020a05600c485600b0039756cdc8e1sm1362865wmo.37.2022.06.01.02.33.16
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 01 Jun 2022 02:33:16 -0700 (PDT)
Message-ID: <d84ba981-d907-f942-6b05-67c836580542@redhat.com>
Date:   Wed, 1 Jun 2022 11:33:16 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.9.0
Content-Language: en-US
From:   Jocelyn Falempe <jfalempe@redhat.com>
Subject: [REGRESSION] VGA output with AST 2600 graphics.
To:     dri-devel@lists.freedesktop.org, kuohsiang_chou@aspeedtech.com,
        David Airlie <airlied@redhat.com>,
        Thomas Zimmermann <tzimmermann@suse.de>
Cc:     regressions@lists.linux.dev, stable@vger.kernel.org
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi,

I've found a regression in the ast driver, for AST2600 hardware.

before the upstream commit f9bd00e0ea9d
https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux.git/commit/?id=f9bd00e0ea9d9b04140aa969a9a13ad3597a1e4e

The ast driver handled AST 2600 chip like an AST 2500.

After this commit, it uses some default values, more like the older AST 
chip.

There are a lot of places in the driver like this:
https://elixir.bootlin.com/linux/v5.18.1/source/drivers/gpu/drm/ast/ast_post.c#L82
where it checks for (AST2300 || AST2400 || AST2500) but not for AST2600.

This makes the VGA output, to be blurred and flickered with whites lines 
on AST2600.

The issue is present since v5.11

For v5.11~v5.17 I propose a simple workaround (as there are no other 
reference to AST2600 in the driver):
--- a/drivers/gpu/drm/ast/ast_main.c
+++ b/drivers/gpu/drm/ast/ast_main.c
@@ -146,7 +146,8 @@ static int ast_detect_chip(struct drm_device *dev, 
bool *need_post)

  	/* Identify chipset */
  	if (pdev->revision >= 0x50) {
-		ast->chip = AST2600;
+		/* Workaround to use the same codepath for AST2600 */
+		ast->chip = AST2500;
  		drm_info(dev, "AST 2600 detected\n");
  	} else if (pdev->revision >= 0x40) {
  		ast->chip = AST2500;

starting from v5.18, there is another reference to AST2600 in the code
https://elixir.bootlin.com/linux/v5.18/source/drivers/gpu/drm/ast/ast_main.c#L212

So I think someone with good aspeed knowledge should review all 
locations where there is a test for AST2500, and figure out what should 
be done for AST2600

Thanks,

-- 

Jocelyn

