Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DE24C4F7224
	for <lists+stable@lfdr.de>; Thu,  7 Apr 2022 04:37:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239258AbiDGCjK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 6 Apr 2022 22:39:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42440 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239239AbiDGCjH (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 6 Apr 2022 22:39:07 -0400
Received: from mail-pg1-x52d.google.com (mail-pg1-x52d.google.com [IPv6:2607:f8b0:4864:20::52d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B3D822ADF;
        Wed,  6 Apr 2022 19:37:08 -0700 (PDT)
Received: by mail-pg1-x52d.google.com with SMTP id q19so3786953pgm.6;
        Wed, 06 Apr 2022 19:37:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:from:in-reply-to:subject:to:cc
         :content-transfer-encoding;
        bh=YY4xm0Ao2hFqDf4Z8dPBnmSK82yFlxFIuMj1IZ+m9lA=;
        b=P4cFrrMSdA21LaxqYCgENK9leFvpEhtQxTtS3vUL702ONItdn/YdVLU7xJkF5mfSkb
         diKVsicn58moUarbr+gMsqfz0UAjiNfDi7x/ddGrMbHMl8p+nyUovfZdIUHGPG36gn64
         TYMvQ9RXRjrtJJ58cQLOGfAK+1Xri53yxgIW1Zj6iGySCsBEFWFD48U1c6F69SGxkD7V
         05a6rObG7eQg4+VoraBmkbbFi1s5MxBLsQNtthbnd+o75QPHgYUJ7KQzD4EzEbrT06ej
         +9vc7dOFh5Mbxx/Vmekbc8JDY8NZT3AgqVwtJH+XQDwHBnwpjNE2to4mKsuTkBLrewnE
         xSQQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:from:in-reply-to:subject:to:cc
         :content-transfer-encoding;
        bh=YY4xm0Ao2hFqDf4Z8dPBnmSK82yFlxFIuMj1IZ+m9lA=;
        b=U8jTAnU71LQ2uKgsXWmXyJpjmqcjNqVdJ8PFB6lN2/jZeNQf3G8HSjKpdL3FKA+Gnh
         vIohG6C/S4xRpAORSnx+uZbXlJhJqH4lSopmORdA76AisOdF7upgLHaAvWwa6oKyTmAO
         SaPuPSbHw5P2yOYRcIZJRve/vbdLLQ9weKb30f7ktLnidpipYZOJbAWod0rhFCth7grQ
         mJ06S07Ju/h6U60PymPhydXDnMm0Wm7XzZ0OdXww0sqGNuOqQma/AyuHbqTqPIhmSYHw
         vlAWWIOwJwSzE3wdRv4zsfYczatW9FNffqBjras3J3ai8FfDAWvIDx4HcwwGW1fI974L
         IZCg==
X-Gm-Message-State: AOAM533HHf3X31QfJU8ny41dCEC6iTfLJEyJ6Gt/J6AWy0tPqSsY7iLQ
        7QhihsSrZiVC/qCKevuLVfdZaIHBcZicSYLkOvA=
X-Google-Smtp-Source: ABdhPJzMrt+kkgp2S6Kt2D+Gby1fNQ789xRPcVSZaN3s+5BJTGpYw2XWL9SnNUVuUfs5Uky6vJFSKQ==
X-Received: by 2002:a05:6a00:22d1:b0:4fa:e87c:9424 with SMTP id f17-20020a056a0022d100b004fae87c9424mr11904767pfj.51.1649299027752;
        Wed, 06 Apr 2022 19:37:07 -0700 (PDT)
Received: from cl-arch-kdev (cl-arch-kdev.xen.prgmr.com. [2605:2700:0:2:a800:ff:fed6:fc0d])
        by smtp.gmail.com with ESMTPSA id n19-20020a62e513000000b005048eef5827sm862467pff.142.2022.04.06.19.37.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 06 Apr 2022 19:37:07 -0700 (PDT)
Message-ID: <624e4e53.1c69fb81.43bdc.41e1@mx.google.com>
Date:   Wed, 06 Apr 2022 19:37:07 -0700 (PDT)
X-Google-Original-Date: Thu, 07 Apr 2022 02:37:05 GMT
From:   Fox Chen <foxhlchen@gmail.com>
In-Reply-To: <20220406133055.820319940@linuxfoundation.org>
Subject: RE: [PATCH 5.15 000/911] 5.15.33-rc2 review
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

On Wed,  6 Apr 2022 15:44:09 +0200, Greg Kroah-Hartman <gregkh@linuxfoundation.org> wrote:
> This is the start of the stable review cycle for the 5.15.33 release.
> There are 911 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 08 Apr 2022 13:27:53 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.15.33-rc2.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.15.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h
> 

5.15.33-rc2 Successfully Compiled and booted on my Raspberry PI 4b (8g) (bcm2711)
                
Tested-by: Fox Chen <foxhlchen@gmail.com>

