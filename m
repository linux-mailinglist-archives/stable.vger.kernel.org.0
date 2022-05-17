Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5C4D4529BCB
	for <lists+stable@lfdr.de>; Tue, 17 May 2022 10:08:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242396AbiEQIIP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 17 May 2022 04:08:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58846 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236249AbiEQIIO (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 17 May 2022 04:08:14 -0400
Received: from mail-io1-xd34.google.com (mail-io1-xd34.google.com [IPv6:2607:f8b0:4864:20::d34])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 021CD3BBF3;
        Tue, 17 May 2022 01:08:12 -0700 (PDT)
Received: by mail-io1-xd34.google.com with SMTP id o190so18439263iof.10;
        Tue, 17 May 2022 01:08:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:from:in-reply-to:subject:to:cc
         :content-transfer-encoding;
        bh=uqBuyz0vb3Im0RdIoWGhyWrZQdrO0ywLM0M+Qv0sRv0=;
        b=hHH4I0ryVz7JP0EnFxhCLLypTYJknvGcioKD03MLxJbkfO6bEHLuvnfXXKD7iPwZcO
         hl8lamixpy6EUBCec7pduHmcXDkgK7mHCq3AL29nf7bmhgysm4MGwcu0jDQtIK9EX29V
         U3+e5aZMMM6sIdWQZA7Mz7EnbdvvnsIQuV2r3GUvklm1XmAjQlpnVkXsuUmgg6x2lslX
         cjBPwmBa1gFKdQg5HHkxWfKjtfE6wF15oSrS1J4hzgQLMBzFY3SoxAUdNupNFd0q98IU
         +HpsZbmP4cQ1orA/VdMVcEwvUn45x+A0Xrah4QACJ0t6mDtoQgVZwgJhLGQ2wp4fdkGM
         gR9g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:from:in-reply-to:subject:to:cc
         :content-transfer-encoding;
        bh=uqBuyz0vb3Im0RdIoWGhyWrZQdrO0ywLM0M+Qv0sRv0=;
        b=KYkfjbWDZMsoTTcixQ2C8lEm5v8kLfA+yzd/CbiruY7hnZobZ1CZFzNrK/wMOTORms
         qZG4hV4AfGHOo1HS3kkJmBOgi0JWQitfDR9eGJtKvCi0u3u5s4ipnlSqunlg6Ju+NTvT
         XXrxHycy3BClR6q5ojSzXa8ODLflRrHKbagXecxQt+HZh1acYGncZrdSHaUGbOQmlGnD
         gsHxK2z5KVkwDqxZ4g8m56Y3tiTRKFXx5IxlRTu9zITmBBEkLZFXXgiYSi2MQXQb7zi0
         kgmzbXCEwcSq7wdmCgIVrVjVv307oYJc2YGq+F4QfiLizZaVLQ7BUiBvvAiok7CNSvKz
         yckQ==
X-Gm-Message-State: AOAM530VrWdUdyYlIkHHZlTGGcXZBBC/Ioni95HQdUYW++u15u1blx2l
        LtQ4jiMSLxghHnBRTuZQwsrpQipzJseweF+g
X-Google-Smtp-Source: ABdhPJzGGV1cgu3m7nAzR/ddstZnp9k13hHNVKhG8k0XzzNNvkBZMs2IUyUmXnnzeGFEV3GncwAHzA==
X-Received: by 2002:a05:6602:148b:b0:657:c59b:f336 with SMTP id a11-20020a056602148b00b00657c59bf336mr9923076iow.141.1652774891449;
        Tue, 17 May 2022 01:08:11 -0700 (PDT)
Received: from cl-arch-kdev (cl-arch-kdev.xen.prgmr.com. [2605:2700:0:2:a800:ff:fed6:fc0d])
        by smtp.gmail.com with ESMTPSA id t20-20020a02ab94000000b0032e5205f4e7sm440535jan.4.2022.05.17.01.08.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 17 May 2022 01:08:11 -0700 (PDT)
Message-ID: <628357eb.1c69fb81.3bc22.1805@mx.google.com>
Date:   Tue, 17 May 2022 01:08:11 -0700 (PDT)
X-Google-Original-Date: Tue, 17 May 2022 08:08:09 GMT
From:   Fox Chen <foxhlchen@gmail.com>
In-Reply-To: <20220516193623.989270214@linuxfoundation.org>
Subject: RE: [PATCH 5.15 000/102] 5.15.41-rc1 review
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

On Mon, 16 May 2022 21:35:34 +0200, Greg Kroah-Hartman <gregkh@linuxfoundation.org> wrote:
> This is the start of the stable review cycle for the 5.15.41 release.
> There are 102 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 18 May 2022 19:36:02 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.15.41-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.15.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h
> 

5.15.41-rc1 Successfully Compiled and booted on my Raspberry PI 4b (8g) (bcm2711)
                
Tested-by: Fox Chen <foxhlchen@gmail.com>

