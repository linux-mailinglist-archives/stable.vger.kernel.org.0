Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D6F51364901
	for <lists+stable@lfdr.de>; Mon, 19 Apr 2021 19:27:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233463AbhDSR2T (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 19 Apr 2021 13:28:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57834 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232572AbhDSR2T (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 19 Apr 2021 13:28:19 -0400
Received: from mail-pg1-x534.google.com (mail-pg1-x534.google.com [IPv6:2607:f8b0:4864:20::534])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 509D4C06174A;
        Mon, 19 Apr 2021 10:27:49 -0700 (PDT)
Received: by mail-pg1-x534.google.com with SMTP id b17so24741965pgh.7;
        Mon, 19 Apr 2021 10:27:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=message-id:date:from:in-reply-to:subject:to:cc
         :content-transfer-encoding;
        bh=ag8lf1ay4VHqV3Svkg8NqjiAMaXgZDMILLv5+nRWbQs=;
        b=Fqh4BOKbYWHTtlzJJYXwT07d63fUKe8rFZBdFdnzSgzF6KAW9/Qey/nfKFszYvpLOG
         ZBoICArGoY/6UaYjA0zGzUa/WAhnlazHAWQq6LwfOh8B/3dy29iCcotG/5JAJOnyE3jZ
         41TaE6e9RPi3eozzjr9E9i/eilFehhWOM0LsFJL9gH9SYieiojgnlPJ0AREoBnh/GQcJ
         39fXaqnWTUb5j9nxqK6UhjafH50kCPTLVwcN+JyuB+mwxSx7hT4J/k2KrG39vl/7iyyv
         U7Z+uGDQj4pxAZTxJ9XnEjXFNbuPHjJpei8gH7pn5HER2fN2HuzUHafbM5tswRnOjldi
         uVMg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:from:in-reply-to:subject:to:cc
         :content-transfer-encoding;
        bh=ag8lf1ay4VHqV3Svkg8NqjiAMaXgZDMILLv5+nRWbQs=;
        b=L5gyMo0eyZiZdoe90EgCBkqxowsAonj6KwQy99Sy0GlNflagsM2BNm0TW0++1slPIz
         u6ZL6htX1U2Ot5ZIlzCOz/QaR9qqO90x7bpvdNbyLPkDalg7iEd4O0WyPaU3l8vsmkz1
         GKd+iOGqPwTFQnYGRgpxbYd8jFmkL2MnOLeWtjT5Vcexs4w4d75RBTcTtfBEwdFAQ71F
         rQBcGIMdpRf19FnqnOcJIOLVBSJyZY9XESbXMdz3l5JzECwKt+EjGzYdZHpsheI0y2Gp
         jvLmrr8aMYMoOLUMiXpVF9mPPjnbAjeTv0P1yXdTccwehlSAXhm97C4hw4j1WUHcZIB+
         HFSw==
X-Gm-Message-State: AOAM531q9vRBQhrgRiAYQ3gnu2QTA50mKUmCL36xDdBLk2toLKIyO9JJ
        Br2XG9qG9QLqo3Oo5gn+FR3QeRYFbFqzRV/GmTTwTA==
X-Google-Smtp-Source: ABdhPJx/7Rl/snexJJh6j/aPworeyt8YzLQ6XUgO+E7b1O31MWi1PaON1DMNZFc1E1j1fCivjv/PDg==
X-Received: by 2002:a63:144e:: with SMTP id 14mr12818564pgu.53.1618853268450;
        Mon, 19 Apr 2021 10:27:48 -0700 (PDT)
Received: from cl-arch-kdev (cl-arch-kdev.xen.prgmr.com. [2605:2700:0:2:a800:ff:fed6:fc0d])
        by smtp.gmail.com with ESMTPSA id x83sm7695702pfc.219.2021.04.19.10.27.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 19 Apr 2021 10:27:47 -0700 (PDT)
Message-ID: <607dbd93.1c69fb81.b1943.240a@mx.google.com>
Date:   Mon, 19 Apr 2021 10:27:47 -0700 (PDT)
X-Google-Original-Date: Mon, 19 Apr 2021 17:27:46 GMT
From:   Fox Chen <foxhlchen@gmail.com>
In-Reply-To: <20210419130527.791982064@linuxfoundation.org>
Subject: RE: [PATCH 5.10 000/103] 5.10.32-rc1 review
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

On Mon, 19 Apr 2021 15:05:11 +0200, Greg Kroah-Hartman <gregkh@linuxfoundation.org> wrote:
> This is the start of the stable review cycle for the 5.10.32 release.
> There are 103 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 21 Apr 2021 13:05:09 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.32-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.10.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h
> 

5.10.32-rc1 Successfully Compiled and booted on my Raspberry PI 4b (8g) (bcm2711)
                
Tested-by: Fox Chen <foxhlchen@gmail.com>

