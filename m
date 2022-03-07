Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 67CFF4D013C
	for <lists+stable@lfdr.de>; Mon,  7 Mar 2022 15:29:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235954AbiCGOau (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 7 Mar 2022 09:30:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51114 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243188AbiCGOat (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 7 Mar 2022 09:30:49 -0500
Received: from mail-pl1-x62f.google.com (mail-pl1-x62f.google.com [IPv6:2607:f8b0:4864:20::62f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 852C878934;
        Mon,  7 Mar 2022 06:29:55 -0800 (PST)
Received: by mail-pl1-x62f.google.com with SMTP id n2so4398794plf.4;
        Mon, 07 Mar 2022 06:29:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:from:in-reply-to:subject:to:cc
         :content-transfer-encoding;
        bh=SqUFf/0e9pIfYA2SPUi1rOc62Loeelt2Cp4NKFK25pw=;
        b=n2oWKDzxZmGwqowGp4AEgcRLjh1BUYKx02aE7FgNv+I+jooioHnW++CUWq65y81gqd
         wJR5Nf4BCpjvQYuIL5lM0tRI7ZVy3yll2SaMzR+LVWc4mWiFB7B8eaW81T7j+y3hiRlo
         TfHC5LPZWHf5cHH1Liyq0OwcN+VBfwXtOeJHs1MDbbWeyfRNRGQRJf2QWZt02ifKpgFy
         qOb8LdDDEriC/4n+YRsl3ZSVKte854pch8MIyJnjJ4aj+gJUUjue+lEHyy0Eu2PeO/Kk
         TUwiZ6h5PdokAeFgavsw+8ntKTaDjTB4PpsEkQD6ek5guB7A/0KPsIWt4hhOsR1YWtWh
         osyQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:from:in-reply-to:subject:to:cc
         :content-transfer-encoding;
        bh=SqUFf/0e9pIfYA2SPUi1rOc62Loeelt2Cp4NKFK25pw=;
        b=Hl6eeTTUAr1E2y3KnKDuFZRUCSfR0+FHMZlz1K8diW5NgbiujgHcLFdW4iRkm0fVyu
         wt8j6T7NIBxXJSGKiEF+8pgdJoYhmeh+7dcCzkkZdEMyOGP3xu0BLfdTqRNmoQpdYyTp
         CJNYLd7cnZBiCAUQxNFugafC8cB17mdusp45rDp3KU7hnGqcOCc8FZNDoHelBKOBPQai
         wA9NFVkBDL3Uo3CV4fmCMKU/bQzj94bgstesPpUWdb4bdDibVMb6SrE4d654HyXEVFMr
         HU35eZALEvu8q/grTER27qMVJfMOZ2rM1K48AwL9YM/WRkrRelVfbmWbrVRfMGT23by5
         fbJg==
X-Gm-Message-State: AOAM532L5i/7r1Ab7/eqm7a3XtyQvOxCTPPO/Co2WRL7slA6KjxAOlH8
        eZKRm5kQUhGYml9u+zr/WIDavxvcmOXDFmR2UoHqmg==
X-Google-Smtp-Source: ABdhPJycETZ3OKOAQKgyTTtP46/9uLpeaMNzbTPBQSO4ZbB7wkp+zOyMQI5/hBmYYalbGljhIbtL2w==
X-Received: by 2002:a17:902:b683:b0:150:c60:288f with SMTP id c3-20020a170902b68300b001500c60288fmr12359661pls.61.1646663394339;
        Mon, 07 Mar 2022 06:29:54 -0800 (PST)
Received: from cl-arch-kdev (cl-arch-kdev.xen.prgmr.com. [2605:2700:0:2:a800:ff:fed6:fc0d])
        by smtp.gmail.com with ESMTPSA id r16-20020a17090a0ad000b001bf6ab71e75sm3105914pje.28.2022.03.07.06.29.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 07 Mar 2022 06:29:53 -0800 (PST)
Message-ID: <622616e1.1c69fb81.33021.7133@mx.google.com>
Date:   Mon, 07 Mar 2022 06:29:53 -0800 (PST)
X-Google-Original-Date: Mon, 07 Mar 2022 14:29:51 GMT
From:   Fox Chen <foxhlchen@gmail.com>
In-Reply-To: <20220307091654.092878898@linuxfoundation.org>
Subject: RE: [PATCH 5.16 000/186] 5.16.13-rc1 review
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

On Mon,  7 Mar 2022 10:17:18 +0100, Greg Kroah-Hartman <gregkh@linuxfoundation.org> wrote:
> This is the start of the stable review cycle for the 5.16.13 release.
> There are 186 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 09 Mar 2022 09:16:25 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.16.13-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.16.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h
> 

5.16.13-rc1 Successfully Compiled and booted on my Raspberry PI 4b (8g) (bcm2711)
                
Tested-by: Fox Chen <foxhlchen@gmail.com>

