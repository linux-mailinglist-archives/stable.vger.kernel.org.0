Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 912DB4FECAF
	for <lists+stable@lfdr.de>; Wed, 13 Apr 2022 04:02:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229769AbiDMCEt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 12 Apr 2022 22:04:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60486 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229681AbiDMCEs (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 12 Apr 2022 22:04:48 -0400
Received: from mail-pl1-x636.google.com (mail-pl1-x636.google.com [IPv6:2607:f8b0:4864:20::636])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BDF4433A13;
        Tue, 12 Apr 2022 19:02:28 -0700 (PDT)
Received: by mail-pl1-x636.google.com with SMTP id n18so689291plg.5;
        Tue, 12 Apr 2022 19:02:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:from:in-reply-to:subject:to:cc
         :content-transfer-encoding;
        bh=bRQdjfSB+NzTzGDCOpwO8fHk5ZBQGDsMCp7g0Z2cWSY=;
        b=TMFEJQp+nHaBJGb4nIHboKkXVS4nvp7iilxTVimyn78Uh5Wq9UrFH4JbgAS5QyYHNM
         qxSNxppMKvjEZXXXhRX859KO4bWF8RE50RQnvwb5CKuYneD88+SOgbrIn9o7BBdrDZJ0
         dd32phf6oQbbPB25OrkpV5E/zAXdD4XrXtzhIc7nmnslTYCTLcJMuBJsHqelAiDVXr4F
         xpzo38msbpgy8KeHO+eGYepcuSUuPg5cY8p9JFx4FyfY5KAcj9kvCbG9Aj7A03yNT+EP
         6SJdXGtQkTEVB3MA+tSDl+l8+xyb4tyZwPSwG4C2GH7kro/L+Xb+VJnlherIM8K830ET
         tOvQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:from:in-reply-to:subject:to:cc
         :content-transfer-encoding;
        bh=bRQdjfSB+NzTzGDCOpwO8fHk5ZBQGDsMCp7g0Z2cWSY=;
        b=TCU5WIB8Wc4L1AaDkKY6t8iiOPYWnbaerAmLgCYcH311r80dizZWfJsf2lb1o9H7g5
         oWvI71/q8C8y5e069f4Y5oLDVPiPC+nelHnyX8dqTlBefISLqLcc2PG0RjmuLkKWdfnV
         NMJ0Xt8+Cxsrk7rxuakntecdysoN7JlJ/ZtHOXN9AuMswTP8WMZqYjD5lb2lpTRWjIPN
         1DjV+gdcxusT7LKy7Lk+Ac/H6+AX+CfnBHZPA241Z2UrnfcdlXt80g7Wf19pK/SgUREF
         eT1BHYkA8T2imqjbjUKTTDtKXzMReiGKP4+d3qwjh7iByEouv+a1CN25a0m0z+urIalm
         ZSFg==
X-Gm-Message-State: AOAM5329dIj0Bt0iJZxB0mRdXHIV4iC93WIIXQmHuhivlYo+4r1vZC9R
        i73NRoapegxhA0iIfsml/xmPMor6eqgRZHB3TLk=
X-Google-Smtp-Source: ABdhPJxVQKei4bDkivdniXg6jJ3fb9GTXqP5IcXQXi+GwhUNVt7mByI8V8sZR0Dkmst1FEp7iZSmZg==
X-Received: by 2002:a17:902:cf05:b0:156:2aa:6e13 with SMTP id i5-20020a170902cf0500b0015602aa6e13mr40059919plg.137.1649815347724;
        Tue, 12 Apr 2022 19:02:27 -0700 (PDT)
Received: from cl-arch-kdev (cl-arch-kdev.xen.prgmr.com. [2605:2700:0:2:a800:ff:fed6:fc0d])
        by smtp.gmail.com with ESMTPSA id t184-20020a625fc1000000b004fa3bd9bef0sm18939984pfb.110.2022.04.12.19.02.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 12 Apr 2022 19:02:27 -0700 (PDT)
Message-ID: <62562f33.1c69fb81.e4a9.1b0e@mx.google.com>
Date:   Tue, 12 Apr 2022 19:02:27 -0700 (PDT)
X-Google-Original-Date: Wed, 13 Apr 2022 02:02:24 GMT
From:   Fox Chen <foxhlchen@gmail.com>
In-Reply-To: <20220412173836.126811734@linuxfoundation.org>
Subject: RE: [PATCH 5.15 000/277] 5.15.34-rc2 review
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

On Tue, 12 Apr 2022 19:47:07 +0200, Greg Kroah-Hartman <gregkh@linuxfoundation.org> wrote:
> This is the start of the stable review cycle for the 5.15.34 release.
> There are 277 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 14 Apr 2022 17:37:56 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.15.34-rc2.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.15.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h
> 

5.15.34-rc2 Successfully Compiled and booted on my Raspberry PI 4b (8g) (bcm2711)
                
Tested-by: Fox Chen <foxhlchen@gmail.com>

