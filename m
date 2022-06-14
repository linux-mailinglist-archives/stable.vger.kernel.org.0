Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9F30F54A394
	for <lists+stable@lfdr.de>; Tue, 14 Jun 2022 03:26:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232952AbiFNBVF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Jun 2022 21:21:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60542 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233819AbiFNBVE (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Jun 2022 21:21:04 -0400
Received: from mail-il1-x134.google.com (mail-il1-x134.google.com [IPv6:2607:f8b0:4864:20::134])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C3DC3FD09;
        Mon, 13 Jun 2022 18:21:03 -0700 (PDT)
Received: by mail-il1-x134.google.com with SMTP id a15so5536815ilq.12;
        Mon, 13 Jun 2022 18:21:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:from:in-reply-to:subject:to:cc
         :content-transfer-encoding;
        bh=ZA6Evlzlw0hw7IT+x+pNWmsYJBhOhnq7iazEfnfh6d4=;
        b=D2Bc+4WIlgCrdhvGiqML8dGVYgNJCcN/TDf/eGvLshYn+0cj+kVMZ/AD0LlyRitXPf
         eNfnPb3a5egbVnB262GG/7N09bgFZRIkl8slwOZL2nxOdsaqQs83txR/sTYZeeknNdGR
         WlYqUobXuMDyb+0Ba+hHKxA/NqwCQoHihhPEF4HEUR5fmMlEiFIGVi99AcBTGJzdXnvg
         D2Z12h42FKwKX/+Bb8ZhpPrJ0W1ZLRYhO2T5EdDr/QNlVY7BpB4APtWGWzUDZc5gq57Q
         nxJqMjGbkhgXlPjrHEnybfjWlzp8KNwyPHh7PQ67SnMkDISDsfGhSnNIli3kOAMOzPuT
         KGGA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:from:in-reply-to:subject:to:cc
         :content-transfer-encoding;
        bh=ZA6Evlzlw0hw7IT+x+pNWmsYJBhOhnq7iazEfnfh6d4=;
        b=Aqfa4Fgo/wWpG23wlhS9IWwr2QNT4Tvb0TZGMuo7J97U2+q08g+mIe2RJsE6MnNL1W
         QoE6OxJzGzvfRlDZZFN+DaduAHD+XaPy13oWfX07yP5f0gJDhBPFG30IHIG+EowVDOpv
         /lRilzMWhTHWYV3xxF/b8/Q3AEaeAnKye5kpYHEmvtGpTCZOlBfnBOcdZNpdFczU9v32
         Og07yyNkgPnPVeUK83BakWlXGvRGJmDKp3sAZstgX0a/0NZoo2nqSmpb0sTFlDPcg3l9
         T5FBZSHw3or+5qg6G54Q/s22mk5GhSvFrAC86PwkcHq5iqV8tTSxRYlJJnciAw+XCYGF
         aIhQ==
X-Gm-Message-State: AJIora+/aKBU15vI39gZqyu7BkoeYsVLfrOOdz6G8YZCWqnP27P2xy0U
        w0sMBV8uguvuewkQKHo4NtY3Nie2CnXi7upwB/c=
X-Google-Smtp-Source: AGRyM1tmeGzS748YuDP0NgVf2Co9FAs/1lw0LVNWBy9FR49MaS8JSjWXxObu14V3EpK9yt0blgz0hQ==
X-Received: by 2002:a05:6e02:f44:b0:2d3:b54f:d83e with SMTP id y4-20020a056e020f4400b002d3b54fd83emr1497837ilj.9.1655169662748;
        Mon, 13 Jun 2022 18:21:02 -0700 (PDT)
Received: from cl-arch-kdev (cl-arch-kdev.xen.prgmr.com. [2605:2700:0:2:a800:ff:fed6:fc0d])
        by smtp.gmail.com with ESMTPSA id i2-20020a925402000000b002cde6e352ffsm4632413ilb.73.2022.06.13.18.21.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 13 Jun 2022 18:21:02 -0700 (PDT)
Message-ID: <62a7e27e.1c69fb81.d547a.436c@mx.google.com>
Date:   Mon, 13 Jun 2022 18:21:02 -0700 (PDT)
X-Google-Original-Date: Tue, 14 Jun 2022 01:21:01 GMT
From:   Fox Chen <foxhlchen@gmail.com>
In-Reply-To: <20220613181850.655683495@linuxfoundation.org>
Subject: RE: [PATCH 5.10 000/173] 5.10.122-rc2 review
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

On Mon, 13 Jun 2022 20:19:56 +0200, Greg Kroah-Hartman <gregkh@linuxfoundation.org> wrote:
> This is the start of the stable review cycle for the 5.10.122 release.
> There are 173 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 15 Jun 2022 18:18:23 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.122-rc2.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.10.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h
> 

5.10.122-rc2 Successfully Compiled and booted on my Raspberry PI 4b (8g) (bcm2711)
                
Tested-by: Fox Chen <foxhlchen@gmail.com>

