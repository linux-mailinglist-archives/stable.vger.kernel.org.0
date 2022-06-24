Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 79810559818
	for <lists+stable@lfdr.de>; Fri, 24 Jun 2022 12:46:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230014AbiFXKpd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 24 Jun 2022 06:45:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54178 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229464AbiFXKpb (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 24 Jun 2022 06:45:31 -0400
Received: from mail-ed1-x534.google.com (mail-ed1-x534.google.com [IPv6:2a00:1450:4864:20::534])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1D5295536A;
        Fri, 24 Jun 2022 03:45:29 -0700 (PDT)
Received: by mail-ed1-x534.google.com with SMTP id z11so2846567edp.9;
        Fri, 24 Jun 2022 03:45:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=vD8qTDNfZOQ6NPYpH26T+Xs/UdmEQBlYDvLq5NZ9kMA=;
        b=HUCDUn1TsftDl9cyoWqdrcOk8paUH3ZsAqdqQ9p6jcRDpkxla6x6Hd0Rcw1m4yNbDG
         00ahyYm3vG/6aYamqFqJG8zSEScQqCSejV/e1ut6k5QErm9w2rc5nglt88R2WZZ4pfcj
         ugr8oPsLKBqgGAHFvxG31p06lKSXD6e/bwnzvpDpS+mElHByKQTR5+5BEIP5FRxKwn5b
         Wr/nIh5CTvb5Ghv0Y7AfQAw9aFwTPnF7CzIFJHCebMuQjWeE42z/lcUSfJzPcciCcIS/
         36HY3q1mD6COUjpisiPt1A2SIEdQgrXon5UIsgXABj2jTx78BDxT5mLrhK9BPMb1uXxN
         ZzTw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=vD8qTDNfZOQ6NPYpH26T+Xs/UdmEQBlYDvLq5NZ9kMA=;
        b=00/XtNLEWQlh7UFB/pACmFUNbkTgLDb+tYZrUwP0maKPztSrbvScChWN5ruN/MpPSw
         PgkFGCa6NEO+xJerUtfsnfmKBDfoRQhEZg9vwzU4u37PSqb5PVEwhEtX+RQlt7+kmf6l
         7w45M0qQvHCVRxcb+oXIftxoo2XOawwu9oF5IaWfBm8CbEWu1nVHaW7fq7h65DA4IIxn
         kgWDq/DmyBE/shggJcvqhGBGJCIar0cB3c0LMzNlHcU8u774vXt1TOIooMnQp0QXuntP
         qvZFZHF0yy1hw028lFzpCB775yfUg4gqP/wcozcz98WB1/T203f7fr/sosRtPpnRRwRD
         wD1Q==
X-Gm-Message-State: AJIora/71XFqViSfqaD0Pb/uRQcLFHIDgHPOd5j1Z1X9qh3dDgETyVPm
        TausoJ8/4NXNky+aSER+Sjc=
X-Google-Smtp-Source: AGRyM1ve5r84sbDZYWwRrYlt9CZ15HqfxjLKLM2sQcB0POHAygnIpAi9Bi2clBLt5q7hlL/ZUd/oHg==
X-Received: by 2002:a05:6402:3909:b0:435:7a69:2cfd with SMTP id fe9-20020a056402390900b004357a692cfdmr16837153edb.166.1656067528339;
        Fri, 24 Jun 2022 03:45:28 -0700 (PDT)
Received: from debian (host-78-150-47-22.as13285.net. [78.150.47.22])
        by smtp.gmail.com with ESMTPSA id b9-20020aa7d489000000b004358243e752sm1713883edr.5.2022.06.24.03.45.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 24 Jun 2022 03:45:27 -0700 (PDT)
Date:   Fri, 24 Jun 2022 11:45:26 +0100
From:   Sudip Mukherjee <sudipm.mukherjee@gmail.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, slade@sladewatkins.com
Subject: Re: [PATCH 5.4 00/11] 5.4.201-rc1 review
Message-ID: <YrWVxuA3SSWxWP+q@debian>
References: <20220623164321.195163701@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220623164321.195163701@linuxfoundation.org>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Greg,

On Thu, Jun 23, 2022 at 06:45:04PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.4.201 release.
> There are 11 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sat, 25 Jun 2022 16:43:11 +0000.
> Anything received after that time might be too late.

Build test (gcc version 11.3.1 20220621):
mips: 65 configs -> no failure
arm: 106 configs -> no failure
arm64: 2 configs -> no failure
x86_64: 4 configs -> no failure
alpha allmodconfig -> no failure
powerpc allmodconfig -> no failure
riscv allmodconfig -> no failure
s390 allmodconfig -> no failure
xtensa allmodconfig -> no failure


Boot test:
x86_64: Booted on my test laptop. No regression.
x86_64: Booted on qemu. No regression. [1]

[1]. https://openqa.qa.codethink.co.uk/tests/1384


Tested-by: Sudip Mukherjee <sudip.mukherjee@codethink.co.uk>

--
Regards
Sudip
