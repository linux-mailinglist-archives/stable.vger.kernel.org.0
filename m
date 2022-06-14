Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EE15C54A78B
	for <lists+stable@lfdr.de>; Tue, 14 Jun 2022 05:32:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231129AbiFNDci (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Jun 2022 23:32:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57610 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230431AbiFNDch (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Jun 2022 23:32:37 -0400
Received: from mail-il1-x12e.google.com (mail-il1-x12e.google.com [IPv6:2607:f8b0:4864:20::12e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8EFA11208B;
        Mon, 13 Jun 2022 20:32:33 -0700 (PDT)
Received: by mail-il1-x12e.google.com with SMTP id z11so5705270ilq.6;
        Mon, 13 Jun 2022 20:32:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:from:in-reply-to:subject:to:cc
         :content-transfer-encoding;
        bh=HXaze6xz2LJYzVu1bjuLJoxmoSQPYixWJiqoG7qVxOs=;
        b=qpDh7KMZKhQmbgYYV2u5rdCcpghLSCusFW9qUK47NA6BxjYWCli500sxKw3tRhcaCS
         ewiHlOjtPavZ0fQMc7Yn6vNOBhljK+r5vEoxYoR9GMH6fx75GNlYJRvxFlooe3/3RGVy
         0oFXSgIrsVjFrTzFktwOXsmc1xuP58DiPLgcTDxe1ikAjHjltL4N5A7rvixCmQ0ou6+3
         NLdliVOa2h2b+wGcQXtbOVTkx5nJASzENjDUWyct/G6LttlKqBZaPhRnZ9R5ADoXrmJl
         ajaKgBmNNuoyJgennNYKXqn99XjFqne5sXwi81jCbKalDeBHcZ5op1/wJ4x9siw9G5Gd
         7bjA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:from:in-reply-to:subject:to:cc
         :content-transfer-encoding;
        bh=HXaze6xz2LJYzVu1bjuLJoxmoSQPYixWJiqoG7qVxOs=;
        b=erWCOvxEDokVhH1YOdh/xtVwjM66eL++iepXfPSbO84QnsZxjVi6+7zFeq9isy7WbM
         D1gi/RqzFyUBDmYKcpoBq6aAd1iOgIA2KwarGbzSWxBWqaJ54Whx58RAW2HxJcTxb+N0
         FEdbsDMvu0bOOPUvMQUyAdUPBGU8oKH/U38k0WZDc4rcuFf1ZcVkcpVtp+JsLv0dsI9+
         ZAu5SQNsPmAjIsbVUtXmCcFga0ZxYXmt7j3umi+lIOAvoQmRmrFduqt19bdKpIDZVuyf
         +88Zub+4vaq57hbc8/si1pkJLwFg2xvvha212nX7rGkI46oCT9sNSa/l/MmPL9deKvi/
         dRoQ==
X-Gm-Message-State: AJIora+GWV0TS/3kMyHRagjryiFRgH6uIzOPXYrqeq5nyaz6oINxM9Gf
        WbGtCWxP3uVjRKGkVaW8F6H215ofEmh67ZkQ/JA=
X-Google-Smtp-Source: AGRyM1v0zupLAW0SN72zd3jdInEcY8R+mehREzuBvRhD/5igiHacLGKonITBSRvE/cbs+Tou0I7BtQ==
X-Received: by 2002:a05:6e02:2169:b0:2d1:bd96:a440 with SMTP id s9-20020a056e02216900b002d1bd96a440mr1735097ilv.225.1655177552586;
        Mon, 13 Jun 2022 20:32:32 -0700 (PDT)
Received: from cl-arch-kdev (cl-arch-kdev.xen.prgmr.com. [2605:2700:0:2:a800:ff:fed6:fc0d])
        by smtp.gmail.com with ESMTPSA id a21-20020a056638019500b0032b3a7817dbsm4352357jaq.159.2022.06.13.20.32.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 13 Jun 2022 20:32:32 -0700 (PDT)
Message-ID: <62a80150.1c69fb81.4bc2c.42a8@mx.google.com>
Date:   Mon, 13 Jun 2022 20:32:32 -0700 (PDT)
X-Google-Original-Date: Tue, 14 Jun 2022 03:32:30 GMT
From:   Fox Chen <foxhlchen@gmail.com>
In-Reply-To: <20220613181847.216528857@linuxfoundation.org>
Subject: RE: [PATCH 5.15 000/251] 5.15.47-rc2 review
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

On Mon, 13 Jun 2022 20:19:49 +0200, Greg Kroah-Hartman <gregkh@linuxfoundation.org> wrote:
> This is the start of the stable review cycle for the 5.15.47 release.
> There are 251 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 15 Jun 2022 18:18:03 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.15.47-rc2.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.15.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h
> 

5.15.47-rc2 Successfully Compiled and booted on my Raspberry PI 4b (8g) (bcm2711)
                
Tested-by: Fox Chen <foxhlchen@gmail.com>

