Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 42FC8522436
	for <lists+stable@lfdr.de>; Tue, 10 May 2022 20:38:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237656AbiEJSi0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 May 2022 14:38:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55770 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344143AbiEJSiV (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 10 May 2022 14:38:21 -0400
Received: from mail-qv1-xf2d.google.com (mail-qv1-xf2d.google.com [IPv6:2607:f8b0:4864:20::f2d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9A11F6FD08;
        Tue, 10 May 2022 11:38:20 -0700 (PDT)
Received: by mail-qv1-xf2d.google.com with SMTP id l1so38158qvh.1;
        Tue, 10 May 2022 11:38:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:from:in-reply-to:subject:to:cc
         :content-transfer-encoding;
        bh=3i0o2RjISbHzplMGs9rxWuU8t6q+njoGFhr3PKo/BKo=;
        b=c0/oUdxw8OKV5X60GS6CBJgLivoGBVmBS/Es2OCag8OUA1wsvMH6NEQT+E9R2pNCbV
         2+n7+4Ln4Sc18cDTDsvKrN6QH5oJrH3lcMZ8qFOahhc4Glx8sOLlhhl2/BrSfP6im6Fx
         QvDWhnCiAdpu4/TKRGo+J4w8WLPQDgU7x+NrXrpM5sjxHCfnoxbFOYoYfY9Qdr2rAPWN
         yewB0WVqyXCYlp8zZaYeR1Rwwj3HdPpZiPdGFDAmomtooos0RICMyJQ1q4Md6dMD+74B
         PNJDs143yPd0DnQQU//VLy1kU672PjAvCkoLwkgcOg0IRpYCDCEv29zCOLiiAXboCU01
         Vp6w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:from:in-reply-to:subject:to:cc
         :content-transfer-encoding;
        bh=3i0o2RjISbHzplMGs9rxWuU8t6q+njoGFhr3PKo/BKo=;
        b=HRl6M2dLwe/u6WrKzr/twEXsNZy4lom+d/dkXuBx9fe1BOmxr32UVRqelxliRQw1z2
         ptzeecy3xt7RpKaS9D306vb+51KyF8iDkhSY+sPhm9irA8alXrWzOCtOIo8rLTiRCVMp
         /KL67eyTcXSPK/EaiAA9uUwU000AhCxIvQyL+MQpVqSdiy+igUjOa4KJSIic790CHLhx
         WBL0BPxqs2BZd0I1MsF0b22cY/OT1q31toOzDmEqTL+nF28Oj3HFlE/8NzC4ElI9nS/q
         MGYesApg/VUa+zO2wGdgLbqG3/X/uJd0gVtkKW4L9bzut2zI2cp84YTetjkjY2J75Is1
         wTTQ==
X-Gm-Message-State: AOAM530IoOpi9Rvc01S203WKhXlJEKWOKCRv4RiWzoFTfq+KENi3OHFA
        PK63ILqO5ESOW7/XXhZYxBCn1X/vX4EG0bA2Np4=
X-Google-Smtp-Source: ABdhPJy74F0aNhLsdW3x2ak8TKZNncUr8m61MRcmXL/Rs+CxlINexgr9o8yT9b5Gn0uV9p0+jnbO1Q==
X-Received: by 2002:a05:6214:27c7:b0:45a:d4c1:70ae with SMTP id ge7-20020a05621427c700b0045ad4c170aemr19655776qvb.117.1652207899313;
        Tue, 10 May 2022 11:38:19 -0700 (PDT)
Received: from cl-arch-kdev (cl-arch-kdev.xen.prgmr.com. [2605:2700:0:2:a800:ff:fed6:fc0d])
        by smtp.gmail.com with ESMTPSA id z6-20020ac84546000000b002f39b99f6b4sm9696524qtn.78.2022.05.10.11.38.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 10 May 2022 11:38:18 -0700 (PDT)
Message-ID: <627ab11a.1c69fb81.94594.1090@mx.google.com>
Date:   Tue, 10 May 2022 11:38:18 -0700 (PDT)
X-Google-Original-Date: Tue, 10 May 2022 18:38:16 GMT
From:   Fox Chen <foxhlchen@gmail.com>
In-Reply-To: <20220510130732.861729621@linuxfoundation.org>
Subject: RE: [PATCH 5.10 00/70] 5.10.115-rc1 review
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

On Tue, 10 May 2022 15:07:19 +0200, Greg Kroah-Hartman <gregkh@linuxfoundation.org> wrote:
> This is the start of the stable review cycle for the 5.10.115 release.
> There are 70 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 12 May 2022 13:07:16 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.115-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.10.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h
> 

5.10.115-rc1 Successfully Compiled and booted on my Raspberry PI 4b (8g) (bcm2711)
                
Tested-by: Fox Chen <foxhlchen@gmail.com>

