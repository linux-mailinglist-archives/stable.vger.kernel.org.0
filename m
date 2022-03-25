Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8979C4E7B40
	for <lists+stable@lfdr.de>; Sat, 26 Mar 2022 01:20:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232449AbiCYVFI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 25 Mar 2022 17:05:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53800 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232445AbiCYVFH (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 25 Mar 2022 17:05:07 -0400
Received: from mail-pf1-x42b.google.com (mail-pf1-x42b.google.com [IPv6:2607:f8b0:4864:20::42b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 27CF4222A0;
        Fri, 25 Mar 2022 14:03:29 -0700 (PDT)
Received: by mail-pf1-x42b.google.com with SMTP id b15so7480938pfm.5;
        Fri, 25 Mar 2022 14:03:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:from:in-reply-to:subject:to:cc
         :content-transfer-encoding;
        bh=LVeL2mViXZFlNIpamMsf3vs45VxHMWIP8zNw4VZI46w=;
        b=XQjaT5TMI7t/8Y5obR0vhoJ0JNLK7DFfG4JC024Zjna5j3zHxG5eri23eIIHiNu6bC
         ZQpzznz2VjsRQ2TbzrC+bnl6iHziOqxzm/TUhqIHeuTEwtQwwfklNLTY622ophtQLgXl
         QbH1bEBK8DXWfyz8+BmV9Dcd6M8atlLJ+cNjsNDYg199VIdDi7XfgxKB1yFaqgvL99u3
         zScpL1fd8X95oHC4U0M0SFqL5rYnzICp5qQ7t2vMcT2OB3z7gep70EV1JHbnkRH/qFtI
         krOgBac6b8c9kB8xLh39sgOK+lJdALzLTBgt4bdUC1l/FWqZLHHIpESvMMRoR9AAZ9Ve
         WimA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:from:in-reply-to:subject:to:cc
         :content-transfer-encoding;
        bh=LVeL2mViXZFlNIpamMsf3vs45VxHMWIP8zNw4VZI46w=;
        b=i9ixnymD4lINiqmx6Rvv8LCvRmVZvN8odpSQfvY0+dFkPagxuukX7IfTfxIowCKtVE
         LhkYyThl1knWb65z3lq3qOFGJKyKFmqZSXgujWO1Eq98MvWtpQ2lEa5kexAqutravCIO
         9+JrN+t/dzZvSXIsYsFszPwjvxVVLvRIf1IXySlmf6+1nG0Br7LdmRoEOiWvz2KRzrVo
         1IBy8pGvmlT4QjqtECkD0OmJyeVdcapzN6Vd4hwfVQvZEX09Jk/oJuh5YDaEsUfmc0Uo
         Z74f9ZFHG5gpJRPfPxpkSIoQ0sxg6zeMq9eC2/0evoX83nmwVVIgWDdbRPjXvmZOekK2
         TjLw==
X-Gm-Message-State: AOAM532e3QdHyfHf7ZdchTcb5gddw3cyzzzcCoGAKrPABmznoYdWt2xB
        +ioniNyoY4HG0ZjsiGj01luq0DBvVSFA4RBdKjw=
X-Google-Smtp-Source: ABdhPJyjpxz6ddApS2vwGHdXsn/LqjD/KQJqfzP4NjH0UFVatd8GtS4C6X6vUIf+xtV0h+cLxCooxA==
X-Received: by 2002:a63:4707:0:b0:382:207b:889c with SMTP id u7-20020a634707000000b00382207b889cmr1082697pga.541.1648242208272;
        Fri, 25 Mar 2022 14:03:28 -0700 (PDT)
Received: from cl-arch-kdev (cl-arch-kdev.xen.prgmr.com. [2605:2700:0:2:a800:ff:fed6:fc0d])
        by smtp.gmail.com with ESMTPSA id g6-20020a056a001a0600b004f7bd56cc08sm7564991pfv.123.2022.03.25.14.03.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 25 Mar 2022 14:03:27 -0700 (PDT)
Message-ID: <623e2e1f.1c69fb81.ce989.5adf@mx.google.com>
Date:   Fri, 25 Mar 2022 14:03:27 -0700 (PDT)
X-Google-Original-Date: Fri, 25 Mar 2022 21:03:12 GMT
From:   Fox Chen <foxhlchen@gmail.com>
In-Reply-To: <20220325150419.757836392@linuxfoundation.org>
Subject: RE: [PATCH 5.10 00/38] 5.10.109-rc1 review
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

On Fri, 25 Mar 2022 16:04:44 +0100, Greg Kroah-Hartman <gregkh@linuxfoundation.org> wrote:
> This is the start of the stable review cycle for the 5.10.109 release.
> There are 38 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sun, 27 Mar 2022 15:04:08 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.109-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.10.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h
> 

5.10.109-rc1 Successfully Compiled and booted on my Raspberry PI 4b (8g) (bcm2711)
                
Tested-by: Fox Chen <foxhlchen@gmail.com>

