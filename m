Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 468F840EA9C
	for <lists+stable@lfdr.de>; Thu, 16 Sep 2021 21:06:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235661AbhIPTHb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Sep 2021 15:07:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54284 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346951AbhIPTH2 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 16 Sep 2021 15:07:28 -0400
Received: from mail-pf1-x434.google.com (mail-pf1-x434.google.com [IPv6:2607:f8b0:4864:20::434])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8B0BEC0613B5;
        Thu, 16 Sep 2021 11:59:37 -0700 (PDT)
Received: by mail-pf1-x434.google.com with SMTP id w19so6730975pfn.12;
        Thu, 16 Sep 2021 11:59:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:from:in-reply-to:subject:to:cc
         :content-transfer-encoding;
        bh=Mjgi8XeN/cBVgQfdEOFYYeQ4LhqIBS4y+Zl+2GKXRcA=;
        b=AZ4TNfRWRj4KLFcrJTVjfvUxFkC22yZQ4HdH8pBOha7x5753jTXjlFWh47zz95J0yf
         S+8Ql2KqA34Nnjjc5TUac+3RjzrPpdUB8MYh/Acts3sV4vZAdI/sAqYu+gqE8oqq97ET
         zoxwkzwhMS0eA0GEB10a87U+63lV51mqIEvmjUXkyDiiVNHn+rk/+Cp99v8igpvYDCV9
         CoP5CiXh8XF+qqqx2aJX55qe3qlJghAOzycvcGEJkOjb49+2E1kHQSGXGT/CovAH2xHK
         Ys0YsWVJPNlNgYCZtVasswS9op5P+1uxvjV1unbuiFR7LHkjlxXZwtT/TnYJRv5jXhTh
         SS4Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:from:in-reply-to:subject:to:cc
         :content-transfer-encoding;
        bh=Mjgi8XeN/cBVgQfdEOFYYeQ4LhqIBS4y+Zl+2GKXRcA=;
        b=DxB0hm3FrsVvgbu6rlydPmfoMacrszp1Q43QOooIOK4ZQvljZ3tTPPcv95smC4fI1n
         EluD7LSbJtnrxUHCrlz2M8faixwf//d1DVJn+1W+nQaGmmdSkwgtITviUtVQ9JOdgOWb
         HPe4ku9AI4DYNRG4dsh898AG6SMlR2O1+mrYPMtBw84pNUAti7bL23tZweEwXbN8My+8
         iI+uqn4Xc+QpFP8YPzEkXnzWe+bbnHEAbN+qfKCLjSuz4J0bDTJNQl5ADhctesQ5Bjx/
         VYGdLFZqEwsdkKb9wolptxYus6Ivg5B8OcyJJ9U8bhZUNfoGnP2uJrkbSx9b4c6BCh0Y
         KXBw==
X-Gm-Message-State: AOAM530JiU3pn/Ge+CeAWhlg/p47hNXDvgK/UEfeh4prtjqrHvAMA6Hu
        SKz+72aG+cjgSZRVXFrot1lin2FIH5l1+ygEeVk=
X-Google-Smtp-Source: ABdhPJyhH/VFfmVOgtnSphG29A7hfX6NmbD34cvjdM1mR9VyA5inKkjD8hQ6PBN4UnCB1ads2yCyJw==
X-Received: by 2002:a62:8496:0:b0:43c:204e:acc8 with SMTP id k144-20020a628496000000b0043c204eacc8mr6417506pfd.71.1631818776516;
        Thu, 16 Sep 2021 11:59:36 -0700 (PDT)
Received: from cl-arch-kdev (cl-arch-kdev.xen.prgmr.com. [2605:2700:0:2:a800:ff:fed6:fc0d])
        by smtp.gmail.com with ESMTPSA id b129sm2199577pfg.157.2021.09.16.11.59.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 16 Sep 2021 11:59:35 -0700 (PDT)
Message-ID: <61439417.1c69fb81.e4b11.7255@mx.google.com>
Date:   Thu, 16 Sep 2021 11:59:35 -0700 (PDT)
X-Google-Original-Date: Thu, 16 Sep 2021 18:59:34 GMT
From:   Fox Chen <foxhlchen@gmail.com>
In-Reply-To: <20210916155753.903069397@linuxfoundation.org>
Subject: RE: [PATCH 5.10 000/306] 5.10.67-rc1 review
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, stable@vger.kernel.org,
        Fox Chen <foxhlchen@gmail.com>
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, 16 Sep 2021 17:55:45 +0200, Greg Kroah-Hartman <gregkh@linuxfoundation.org> wrote:
> This is the start of the stable review cycle for the 5.10.67 release.
> There are 306 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sat, 18 Sep 2021 15:57:06 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.67-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.10.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h
> 

5.10.67-rc1 Successfully Compiled and booted on my Raspberry PI 4b (8g) (bcm2711)
                
Tested-by: Fox Chen <foxhlchen@gmail.com>

