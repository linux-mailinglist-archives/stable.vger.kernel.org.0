Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9A1E2689E8E
	for <lists+stable@lfdr.de>; Fri,  3 Feb 2023 16:56:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232655AbjBCP4X (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 3 Feb 2023 10:56:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59418 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229448AbjBCP4W (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 3 Feb 2023 10:56:22 -0500
Received: from mail-ot1-x32b.google.com (mail-ot1-x32b.google.com [IPv6:2607:f8b0:4864:20::32b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0E3989DEE3;
        Fri,  3 Feb 2023 07:56:22 -0800 (PST)
Received: by mail-ot1-x32b.google.com with SMTP id j6-20020a9d7686000000b0068d4ba9d141so1468117otl.6;
        Fri, 03 Feb 2023 07:56:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=iE1pKpiWh3rkANimRBhetH+fDbjSGx4Mt5I9hOjSbgk=;
        b=o1P4zQrbG/9qLAHCY57S2f0+H1Uz9Ki/jqBNkrNiJnw5a85Chyt5m08RZoPCyBu1TK
         8mPESisNocHPoc3bF+4h4EQ1Cl8ldm+GjD2rM1m3NYwQZykc1J2gCXt7y0WjtbEbG5Ni
         8H3Z4ZyDNzKMFXgjJRSWasGosZBnec3cCI6i5LaQ/q6f3r6S/LduQxZmDa8bL1R0aC5C
         P/GHjNKbsvEEieVmnjrzOd3KnrDlaUzRqsSSCNFfZOREcK6jP1Z/EqYJFOwh3b0ZhGYq
         KRbqKogaZen1RMEREqtncfe1ikQJRHJBCXHpgtJTy4YsD3AlcTxwDK5PQjHGEkQn2vOr
         2itQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=iE1pKpiWh3rkANimRBhetH+fDbjSGx4Mt5I9hOjSbgk=;
        b=F0j9+TWdV6nFxYBHjkUAhLv3rmi9m0K/FYQyJKnv7vSovlrvnx1Ac1fb1GREfee/Cv
         Vb2Vk3s1RvWxIZkqiZdpYu5VKXRfCmS+bexwm3wS4Oki4JgMLPyrCaBxvrU6fBjDLbsK
         pRDUWYK/AqvcOLUTuurxVnYLHLEovQA76/8iSVc4/RhxflZuBUufoGaB8lI+qmLqbQ4W
         rJHFTbOAlCN0VbcV/NTMYBedPr/KOO3/KGmYM2Xqq2WkEJzSpozRHo57fLbNw/gkliC1
         bTyffOnf84TBFpHVMznExPd1W2XoOHZ7PKP3JMFWE4RlLtdcYg/lJiK6fMzQGE0zpBWl
         90qA==
X-Gm-Message-State: AO0yUKWwhZxGnjwU1Dl3QF8jeaf3FKagWJV2SRM5p3MY0tWLBSBnnoWe
        WQT077W+9Oy0skNDDXZEdhs=
X-Google-Smtp-Source: AK7set8I2ugKmFE+rmPgMsepUryVPkqQN88t/SnyDwlij+DzqHItFPGHLEGCKjpKBrpNvjVBfD0sDg==
X-Received: by 2002:a9d:730c:0:b0:68a:443c:8c9e with SMTP id e12-20020a9d730c000000b0068a443c8c9emr5596265otk.4.1675439781369;
        Fri, 03 Feb 2023 07:56:21 -0800 (PST)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id x9-20020a056830114900b0068d49f4d8dfsm1204742otq.63.2023.02.03.07.56.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 03 Feb 2023 07:56:20 -0800 (PST)
Sender: Guenter Roeck <groeck7@gmail.com>
Date:   Fri, 3 Feb 2023 07:56:19 -0800
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     stable@vger.kernel.org, patches@lists.linux.dev,
        linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        srw@sladewatkins.net, rwarsow@gmx.de
Subject: Re: [PATCH 5.4 000/134] 5.4.231-rc1 review
Message-ID: <20230203155619.GA3176223@roeck-us.net>
References: <20230203101023.832083974@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230203101023.832083974@linuxfoundation.org>
X-Spam-Status: No, score=-1.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Feb 03, 2023 at 11:11:45AM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.4.231 release.
> There are 134 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sun, 05 Feb 2023 10:09:58 +0000.
> Anything received after that time might be too late.
> 

Building ia64:defconfig ... failed
--------------
Error log:
<stdin>:1511:2: warning: #warning syscall clone3 not implemented [-Wcpp]
arch/ia64/kernel/mca_drv.c: In function 'mca_handler_bh':
arch/ia64/kernel/mca_drv.c:179:9: error: implicit declaration of function 'make_task_dead'

Caused by "exit: Add and use make_task_dead.". Did that really have to be backported ?

Guenter
