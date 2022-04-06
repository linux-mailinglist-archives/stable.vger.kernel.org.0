Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A5ABC4F603E
	for <lists+stable@lfdr.de>; Wed,  6 Apr 2022 15:52:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233385AbiDFNwz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 6 Apr 2022 09:52:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55046 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233539AbiDFNwJ (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 6 Apr 2022 09:52:09 -0400
Received: from mail-pj1-x102c.google.com (mail-pj1-x102c.google.com [IPv6:2607:f8b0:4864:20::102c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 652066E7D22;
        Wed,  6 Apr 2022 04:36:27 -0700 (PDT)
Received: by mail-pj1-x102c.google.com with SMTP id kw18so2264235pjb.5;
        Wed, 06 Apr 2022 04:36:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:from:in-reply-to:subject:to:cc
         :content-transfer-encoding;
        bh=JcF6EDWJWC7sbBnSp03RvONvYWLvss+hA7JZkXhjV6w=;
        b=YiOhUqRcgU4VJpElBAe5F6VKY1oprfxuE+lHfLjrL71/0m8KfGPyGnRBv2ZNFrYSes
         SoMhSNCnBCmLHQ8qu3Zddnc6VJoT8DNJHJJTjrxYDDJK67ICnaey9MKSd+TOQHqNy2A9
         i3G46lHjJdD6ntktMmQ272ejyaNk35Sgu4EJLEb2jTMdt2IkNQsoaT4apdvFBEVI43MA
         Zn8GOR9EcTxxiSVk1dR6h+b+BuAUcdtXOfkho0D+jQ1C6x8Sbce0oE2Sxpmjs+xDN0lN
         kkZnqC3hw8FlC1Ch4g1lrzTOnYYyIMP/enflEzlshtu9tkc+spJxHSfmtcLUcPVOAYGN
         ouAg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:from:in-reply-to:subject:to:cc
         :content-transfer-encoding;
        bh=JcF6EDWJWC7sbBnSp03RvONvYWLvss+hA7JZkXhjV6w=;
        b=XhNsMVSZYaQJwIeNv2+7s0WKKUL2qeVE5VmbyeaLF6TkHpw1tlAKhBGJEPZezTBtMu
         ApBLERUeqOO3y55SoUwjwzfQWsoPpuzAc2CIpWH603VFtS8PFsMUMl5AudJ4QLKwMjw4
         wmlK/bg/q0NFa0pPT+HRkb8u3JKxSZRtFM51Ro1JDjul/DtamJ/9Nv69HgIsvg6N0rgJ
         bcBLRX/a841fLsUxAOy7UWzUp5y8rcXFG/m1zWHDT5XA29QgJI4hY+gQsU282F5G4aee
         F+uUEtxL6pDSlfkRrBsaMC1kgh/J3/3ec349XH02iE5VhmtF+O0AF07oni1Noa/2VK4l
         3KOw==
X-Gm-Message-State: AOAM531wxvXq6p2NJpzzHXdJx1gkyF1nQN18fQCgkHkFPR+yzaRw77O/
        NF0EMgj1OSsnD131pZzqIoTJNsNkGh6weDM9buk=
X-Google-Smtp-Source: ABdhPJxGicsQzFGdKqXuiIngjVJRYlBuQ6c4HZ/RsOyjSHWsQ+o/XZ7uRGxIyWf9lP9pV4BdOmTpHQ==
X-Received: by 2002:a17:902:f547:b0:156:c07d:821e with SMTP id h7-20020a170902f54700b00156c07d821emr7961722plf.36.1649244969430;
        Wed, 06 Apr 2022 04:36:09 -0700 (PDT)
Received: from cl-arch-kdev (cl-arch-kdev.xen.prgmr.com. [71.19.144.195])
        by smtp.gmail.com with ESMTPSA id x29-20020aa79a5d000000b004f0ef1822d3sm18857882pfj.128.2022.04.06.04.36.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 06 Apr 2022 04:36:08 -0700 (PDT)
Message-ID: <624d7b28.1c69fb81.7a3e7.15bb@mx.google.com>
Date:   Wed, 06 Apr 2022 04:36:08 -0700 (PDT)
X-Google-Original-Date: Wed, 06 Apr 2022 11:36:02 GMT
From:   Fox Chen <foxhlchen@gmail.com>
In-Reply-To: <20220405070354.155796697@linuxfoundation.org>
Subject: RE: [PATCH 5.16 0000/1017] 5.16.19-rc1 review
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

On Tue,  5 Apr 2022 09:15:13 +0200, Greg Kroah-Hartman <gregkh@linuxfoundation.org> wrote:
> This is the start of the stable review cycle for the 5.16.19 release.
> There are 1017 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 07 Apr 2022 07:01:33 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.16.19-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.16.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h
> 

5.16.19-rc1 Successfully Compiled and booted on my Raspberry PI 4b (8g) (bcm2711)
                
Tested-by: Fox Chen <foxhlchen@gmail.com>

