Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5F2C74E37AD
	for <lists+stable@lfdr.de>; Tue, 22 Mar 2022 04:44:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236186AbiCVDoO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 21 Mar 2022 23:44:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56020 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236164AbiCVDoN (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 21 Mar 2022 23:44:13 -0400
Received: from mail-pg1-x52f.google.com (mail-pg1-x52f.google.com [IPv6:2607:f8b0:4864:20::52f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6EAA6D58;
        Mon, 21 Mar 2022 20:42:47 -0700 (PDT)
Received: by mail-pg1-x52f.google.com with SMTP id e6so11722380pgn.2;
        Mon, 21 Mar 2022 20:42:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:from:in-reply-to:subject:to:cc
         :content-transfer-encoding;
        bh=2xc5SxBoq4WyWsvCTWJsq+KYX7o7EsIW2a5WZ0HaK6A=;
        b=pEUP4+kK0Vlm39hzsMw+RMJlp7CjZE5DbPXFIpHRNitwIsxgJi01KxdXq3mBD5vaun
         6zrCPP+naabqljpA/4DAbqLPBIMt1yI4Fgk0mQnlS5KwzXch+FfVueGef9/fuTcaBo6x
         NkGonr+EtFmt2wZqAbLmZdrd3T9FDL30c7bHw/kqAQa1UzP8UYEeML91Qosx/m87KfOY
         NqrigOa/0jYQeZYlEYlAVtrLUL/THlV4WHOSXHu2Kuu5JmJYFX5jWW40zAChmsKl0ovt
         f03OEQgPSqEsliwJnCqdBVY6ijRmyjcN7I/jkt9MZXhQ2749haXbiQxprLQ0iqwVO4OY
         lfYg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:from:in-reply-to:subject:to:cc
         :content-transfer-encoding;
        bh=2xc5SxBoq4WyWsvCTWJsq+KYX7o7EsIW2a5WZ0HaK6A=;
        b=Jvrd7jpx+rnj+nnBizLPnWp5Lf1kudHM1EUWXLvbW/Duqi7Ctf2/ISooZNQQDT/VbT
         H7Thj8FMM0GycixaOQ0Zh352bSCotzVzqGNNSePOY8uH22hSEpDzwgJxOIw4dANQcT6J
         CGicPh+lw8PptMrDJgvLxW0uA2/QKF2QEFzHAZlcxOvdo0EkcyW4hjEvXELIyrPfB5b9
         /d6cAotOnl92iZZqYAqsxxGT3ApLXLgv36OvCwJKIn00qDlkN8UB7e3/XlLR+/1FxkY9
         jFM2KEJF/EIvYydUhE/lHDq625hKnMHsUKXRqDskXl+LOv5djnVy4iyevJSKs9qtOJAj
         9Yyg==
X-Gm-Message-State: AOAM532fHNY5cSvfylu9D7xzqSBDw9rn+dTiUXDJlMMQKX6LuUURlAiV
        6r9DQjyJOMLcXtNgWyNWHcVQVFwXhPM0kAdaPCw=
X-Google-Smtp-Source: ABdhPJwuUKlr5LwgD0hOQ4fp6yT3xGuGYvRKGA9s8Cnczr4DvSEfpOKUdicz5H16rMPN7MvjJkD2ug==
X-Received: by 2002:a05:6a00:1a88:b0:4fa:9a8c:c05f with SMTP id e8-20020a056a001a8800b004fa9a8cc05fmr9389075pfv.46.1647920566407;
        Mon, 21 Mar 2022 20:42:46 -0700 (PDT)
Received: from cl-arch-kdev (cl-arch-kdev.xen.prgmr.com. [71.19.144.195])
        by smtp.gmail.com with ESMTPSA id o7-20020aa79787000000b004f8e44a02e2sm22800575pfp.45.2022.03.21.20.42.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 21 Mar 2022 20:42:45 -0700 (PDT)
Message-ID: <623945b5.1c69fb81.fdd30.e714@mx.google.com>
Date:   Mon, 21 Mar 2022 20:42:45 -0700 (PDT)
X-Google-Original-Date: Tue, 22 Mar 2022 03:42:39 GMT
From:   Fox Chen <foxhlchen@gmail.com>
In-Reply-To: <20220321133219.643490199@linuxfoundation.org>
Subject: RE: [PATCH 5.10 00/30] 5.10.108-rc1 review
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

On Mon, 21 Mar 2022 14:52:30 +0100, Greg Kroah-Hartman <gregkh@linuxfoundation.org> wrote:
> This is the start of the stable review cycle for the 5.10.108 release.
> There are 30 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 23 Mar 2022 13:32:09 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.108-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.10.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h
> 

5.10.108-rc1 Successfully Compiled and booted on my Raspberry PI 4b (8g) (bcm2711)
                
Tested-by: Fox Chen <foxhlchen@gmail.com>

