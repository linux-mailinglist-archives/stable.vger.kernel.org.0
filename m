Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B65244D6BA6
	for <lists+stable@lfdr.de>; Sat, 12 Mar 2022 02:22:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229513AbiCLBXO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 11 Mar 2022 20:23:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52548 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229464AbiCLBXN (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 11 Mar 2022 20:23:13 -0500
Received: from mail-pl1-x62a.google.com (mail-pl1-x62a.google.com [IPv6:2607:f8b0:4864:20::62a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3498B240D22;
        Fri, 11 Mar 2022 17:22:09 -0800 (PST)
Received: by mail-pl1-x62a.google.com with SMTP id n2so9049721plf.4;
        Fri, 11 Mar 2022 17:22:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:from:in-reply-to:subject:to:cc
         :content-transfer-encoding;
        bh=pWYgEiBYOYawrjVkjtKlGXVa4e5QOFCJd9hcRju3xX8=;
        b=moq0CsNcU+qKSsYEfwlsZME/d0xeg2VImMpQvGWcgnw4lydi31sRzzliSC+IorfqVP
         c/50WG7e9LzvmQscmvJrxtlibnPTVXJ2PY5D4vjMVlOhuo1ciQswUDNmFgXsIfuqP/VK
         AH+mWLxHNcpCce6Yq71uiNOw3jJTe4ASulQRj28qzkaQsFyo1iF7YHc/BCfOl7dlU7JU
         06yehRMh5CjK0PCDnhDC6JyIofTgWjU9piX1gH8zFuVWhITM/9Blq/ld371G3Cy3vHIn
         y/qnlLgDwpmlxtu+ifaSMhl73NwVTaJNSnlA0x7WbbvMYiddYmJW5h8dVhWs3vv6AsXI
         zD5Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:from:in-reply-to:subject:to:cc
         :content-transfer-encoding;
        bh=pWYgEiBYOYawrjVkjtKlGXVa4e5QOFCJd9hcRju3xX8=;
        b=NW6sxnIlXcaOFmnmr6aBsgEkxM7/IJeXd/B3YYnSxkRUBcNRZaOhdeR91dRFpq284U
         fa//40zcFHIjaQGnazVQDu2fdakWPoZsS1QuqnmOnsomqk31/KUQ8S+coGmvmQNrmzo8
         OF/52MloQtUGV1qd3/ZuxoUxIGZbQHp5yTIxPUgUFpaeycP08VoSJGx3Y1x4qx5HEEL2
         ywmE4xyYxUQSV5Z0qmUlC2oEW4DgfSh27En1cckXsn2FYMw/lENuq94OFfNBVp6ItL4S
         e9T2EQ4aCvT/NWLGD2tSq27JygKL6SMO81Bq3cS2aXY5gRfj6M2rZBK+n9nQyprmZkgm
         eYGQ==
X-Gm-Message-State: AOAM531ceOsl4jAMlOnLy51moZDoO6FzVi5g3fgqfD9t9vajTPRxmqHa
        nx2G2iVdh3Xe6VdJjLDdsuvysyF3gzq9153HKyTPTA==
X-Google-Smtp-Source: ABdhPJzMD/iAf/t5t7VBM78cI6NgpFald40ejgQ12V8mvmtW8bmH8VTRa1loakC28Lac2gBNMNjvHw==
X-Received: by 2002:a17:90b:3b8c:b0:1bf:8841:41e6 with SMTP id pc12-20020a17090b3b8c00b001bf884141e6mr24321386pjb.242.1647048127677;
        Fri, 11 Mar 2022 17:22:07 -0800 (PST)
Received: from cl-arch-kdev (cl-arch-kdev.xen.prgmr.com. [2605:2700:0:2:a800:ff:fed6:fc0d])
        by smtp.gmail.com with ESMTPSA id 16-20020a17090a19d000b001c1c6b25cb2sm6086556pjj.26.2022.03.11.17.22.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 11 Mar 2022 17:22:06 -0800 (PST)
Message-ID: <622bf5be.1c69fb81.65cb0.f8d7@mx.google.com>
Date:   Fri, 11 Mar 2022 17:22:06 -0800 (PST)
X-Google-Original-Date: Sat, 12 Mar 2022 01:22:04 GMT
From:   Fox Chen <foxhlchen@gmail.com>
In-Reply-To: <20220310140812.869208747@linuxfoundation.org>
Subject: RE: [PATCH 5.10 00/58] 5.10.105-rc2 review
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

On Thu, 10 Mar 2022 15:18:20 +0100, Greg Kroah-Hartman <gregkh@linuxfoundation.org> wrote:
> This is the start of the stable review cycle for the 5.10.105 release.
> There are 58 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sat, 12 Mar 2022 14:07:58 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.105-rc2.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.10.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h
> 

5.10.105-rc2 Successfully Compiled and booted on my Raspberry PI 4b (8g) (bcm2711)
                
Tested-by: Fox Chen <foxhlchen@gmail.com>

