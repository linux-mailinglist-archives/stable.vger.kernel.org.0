Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 20F7A552261
	for <lists+stable@lfdr.de>; Mon, 20 Jun 2022 18:39:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232554AbiFTQi7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Jun 2022 12:38:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55964 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231446AbiFTQi6 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Jun 2022 12:38:58 -0400
Received: from mail-il1-x136.google.com (mail-il1-x136.google.com [IPv6:2607:f8b0:4864:20::136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 832F2DEF5;
        Mon, 20 Jun 2022 09:38:57 -0700 (PDT)
Received: by mail-il1-x136.google.com with SMTP id h20so1604900ilj.13;
        Mon, 20 Jun 2022 09:38:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:from:in-reply-to:subject:to:cc
         :content-transfer-encoding;
        bh=lrS+XQ6q0/IbuyZboKtezHKPWmJBm+89oKw9EV9G/So=;
        b=G8LY/7avl7Neq7P1NOZdIS7LJY7m7B559/2aou2WT4U+H4bsLE/d31HyyaL5XVt5f2
         GxlSppbITKjvvwMdVA4Gg3KiY9qLOB+6owOCbEbwKjpGQVd1+YKNcrJ/T/kJxvnvdrIB
         EtrjPpEiZ/4bMvCmAanUfGVKh5iL+YBbXd7XbY2cUwDAPnaAzB6rxJBGAdHk2qkQsJCo
         LFw6n4ldGwr1j1eFxdbjxOKkFwAVHwXnkIAeAFQ7woP6txKaqtWFVAMC6q2ctIYcbGOi
         YgpejF2HipUa37v/LzbkSXcMPADEgGTDijEeirqdmr80Aiip61oVb+kLWq2Lo3rXxEEx
         5NEw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:from:in-reply-to:subject:to:cc
         :content-transfer-encoding;
        bh=lrS+XQ6q0/IbuyZboKtezHKPWmJBm+89oKw9EV9G/So=;
        b=sJtzPgpA9lFiYv2SercaR/Rh2pKswsKaQ0/AVK1j1NOkDDBRLN2iEj2+H99E46L2f8
         rfZEPayvo0b9pixy1oxKSXnkI29LPu+8l9MZYyuoVU0uY+Wy+bXVgU5Vl5FZYDbUlpuK
         Wh7PMos0jG2dBDPAr8R3JVnbV6NzcQQKbkDOql7lxlbwYnZd/RVbn9X9K5gAR85hU1Rx
         FC1v4nyiUmXQTbgQAC7Re/69cTJh2fD6DYAN9L31cucYyTRQn3+7kuXI3xSLCJ/nQgJd
         4LbhBpnpnFTw0MqywTrzDTTn2pRalnN1jDBHyFBUbgeP/aGPmObwclXE64aA30OupvKD
         wjSg==
X-Gm-Message-State: AJIora+22rhq7m+VQ1o4Xxai7HhZg5DTF7EHU1ktc75coE1veLfOGne1
        FxEbd1YLfT4pMk52zOAAOulXw1biDWxUVbJQ
X-Google-Smtp-Source: AGRyM1u3hba50xIf7mH6IAzS37+1OkpcDZgGKoWvomSu/m1NhJgxF9+zp0iUAweDmVxG5wPtW9xW2g==
X-Received: by 2002:a05:6e02:2193:b0:2d9:1195:a080 with SMTP id j19-20020a056e02219300b002d91195a080mr3290832ila.22.1655743136517;
        Mon, 20 Jun 2022 09:38:56 -0700 (PDT)
Received: from cl-arch-kdev (cl-arch-kdev.xen.prgmr.com. [2605:2700:0:2:a800:ff:fed6:fc0d])
        by smtp.gmail.com with ESMTPSA id c9-20020a029609000000b00331fdc68ccesm6153275jai.140.2022.06.20.09.38.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 20 Jun 2022 09:38:56 -0700 (PDT)
Message-ID: <62b0a2a0.1c69fb81.a84ba.6e71@mx.google.com>
Date:   Mon, 20 Jun 2022 09:38:56 -0700 (PDT)
X-Google-Original-Date: Mon, 20 Jun 2022 16:38:54 GMT
From:   Fox Chen <foxhlchen@gmail.com>
In-Reply-To: <20220620124724.380838401@linuxfoundation.org>
Subject: RE: [PATCH 5.15 000/106] 5.15.49-rc1 review
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, f.fainelli@gmail.com,
        sudipm.mukherjee@gmail.com, slade@sladewatkins.com,
        Fox Chen <foxhlchen@gmail.com>
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, 20 Jun 2022 14:50:19 +0200, Greg Kroah-Hartman <gregkh@linuxfoundation.org> wrote:
> This is the start of the stable review cycle for the 5.15.49 release.
> There are 106 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 22 Jun 2022 12:47:02 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.15.49-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.15.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h
> 

5.15.49-rc1 Successfully Compiled and booted on my Raspberry PI 4b (8g) (bcm2711)
                
Tested-by: Fox Chen <foxhlchen@gmail.com>

