Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 660165220FF
	for <lists+stable@lfdr.de>; Tue, 10 May 2022 18:18:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237840AbiEJQWm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 May 2022 12:22:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39504 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243801AbiEJQWj (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 10 May 2022 12:22:39 -0400
Received: from mail-qt1-x835.google.com (mail-qt1-x835.google.com [IPv6:2607:f8b0:4864:20::835])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AAB142A18A0;
        Tue, 10 May 2022 09:18:40 -0700 (PDT)
Received: by mail-qt1-x835.google.com with SMTP id o11so13877078qtp.13;
        Tue, 10 May 2022 09:18:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:from:in-reply-to:subject:to:cc
         :content-transfer-encoding;
        bh=WZFJVSLYEsdaFnH3dpu2L483nVqAlbLk7pa0X9x1/2Y=;
        b=NcxlizgewyzMW/58LRCivKGuJpjWOAqVBBvWSQy4tP8WohfKpk0UxHJE59eAkNciWc
         2jcq/wkF2e44aVKlFwTlf8iUp4hDe1LrZ4Cu6zItStxGwNmpbrbZiMztkh6kpVt95GhG
         Se13pWxZwHJDpkWr6d6WcM7GzbjnqXUA0BLrutP4MS2kc/66zFCSQtVNMBa21aNykvKG
         jDUyIV1JqyZtmQCTa51kOQXRxlJaoXwHGuGiG/VgHETrgVdGyRJ93lQ/4TBJvaRF70If
         4FSCS+kNN61oyhuXMoV8BGwl/jf0R5lc8c3pNE6gO/3SEy9089iilaa6wcZLwIcf+MmO
         jj+A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:from:in-reply-to:subject:to:cc
         :content-transfer-encoding;
        bh=WZFJVSLYEsdaFnH3dpu2L483nVqAlbLk7pa0X9x1/2Y=;
        b=iXHLKwi9Fh4jih3aSqi2NaNHkWbBD/NpMp6Ud6bCHUOR2Mv7TqSY2Vxgw/jeo5Q1mn
         7C6psdguTLT07HDxsyASqo9u1C+UNweTJoDj4VEL71+mAG1qpntTCx87dYM5SwGM+kC4
         Ob0Vwo/4IdijOBamp5C+43Oy4mWe0WONEdqb5w8NW/+yP0QUTTQgnLIgBwaCpsEbFug9
         Bq3kXD3HdCirY44crfF2LMdVrfKHOpDF1S2jv95bd9sbMyZ5c0AexahxHkRI2+OFWTLJ
         MBuEtPQWKRU3f3WXoEFjdZtYn7RrTib3cpg8xy/XEhGh3Uy+7Kkc7sbDqq+V2coDJv7W
         pZ0g==
X-Gm-Message-State: AOAM530xJsnyhgvHTefOTflO7N694bODlN8vCS3Ke2/dgijIKYnPn4M9
        fa+wZu1ETH+8Aaw2XJ1K+rBvOyko4suktpMrLB8=
X-Google-Smtp-Source: ABdhPJy7s9JXYUqzGD/yM4HzMBZVXLf/mZabqM8GB6lgrZioJDd2Zz6j24qMIdlkI9/oqwXVXxACyg==
X-Received: by 2002:ac8:7d13:0:b0:2f3:b53c:a691 with SMTP id g19-20020ac87d13000000b002f3b53ca691mr20461179qtb.525.1652199519433;
        Tue, 10 May 2022 09:18:39 -0700 (PDT)
Received: from cl-arch-kdev (cl-arch-kdev.xen.prgmr.com. [2605:2700:0:2:a800:ff:fed6:fc0d])
        by smtp.gmail.com with ESMTPSA id x14-20020ac8538e000000b002f3bbad9e37sm9326364qtp.91.2022.05.10.09.18.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 10 May 2022 09:18:39 -0700 (PDT)
Message-ID: <627a905f.1c69fb81.eb942.e552@mx.google.com>
Date:   Tue, 10 May 2022 09:18:39 -0700 (PDT)
X-Google-Original-Date: Tue, 10 May 2022 16:18:36 GMT
From:   Fox Chen <foxhlchen@gmail.com>
In-Reply-To: <20220510130740.392653815@linuxfoundation.org>
Subject: RE: [PATCH 5.15 000/135] 5.15.39-rc1 review
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

On Tue, 10 May 2022 15:06:22 +0200, Greg Kroah-Hartman <gregkh@linuxfoundation.org> wrote:
> This is the start of the stable review cycle for the 5.15.39 release.
> There are 135 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 12 May 2022 13:07:16 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.15.39-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.15.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h
> 

5.15.39-rc1 Successfully Compiled and booted on my Raspberry PI 4b (8g) (bcm2711)
                
Tested-by: Fox Chen <foxhlchen@gmail.com>

