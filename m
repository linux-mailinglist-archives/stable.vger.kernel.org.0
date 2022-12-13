Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9F83664B4D2
	for <lists+stable@lfdr.de>; Tue, 13 Dec 2022 13:09:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234899AbiLMMJV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 13 Dec 2022 07:09:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59014 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235196AbiLMMJU (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 13 Dec 2022 07:09:20 -0500
Received: from mail-wr1-x42b.google.com (mail-wr1-x42b.google.com [IPv6:2a00:1450:4864:20::42b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 968361401C;
        Tue, 13 Dec 2022 04:09:19 -0800 (PST)
Received: by mail-wr1-x42b.google.com with SMTP id y16so15386012wrm.2;
        Tue, 13 Dec 2022 04:09:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=S7mo+32hCAdhTEsB/h4ej2yddd4gj6GzVkAb5emTsrQ=;
        b=fXQzjyb++ZUafp//8w5B4bODhZeoUJvUOtDLBqaURXYK/XYE7h9FpG86ZF4cLGN2QA
         akGIYZVLmkIwkPwWeCb64/aajtR1ymlxaRUEBk9ktzd6wmtfJ3LtElFCdrdknAwY0qIn
         PECZLcO/jR/ezzFBHMlP15CzvU2D2RYa9W2No/qiHJhj+19USP9PcyggrJyTusnzsHaK
         wBlCd6KnJ9/3hWmS2+s23TlWmROvu4daYEuRF7npE7eA516I1v7wcoob1uxPq6uWNo6w
         2HkrVrtaUox+2Du326yBxDdNtLiKifsTEwy5hI6lwB/1ehsWGcHI+lKJHotkIXFDQI6J
         mhnw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=S7mo+32hCAdhTEsB/h4ej2yddd4gj6GzVkAb5emTsrQ=;
        b=2/2W8lVEixpaAxAQ/JPAOc8sejHBopmtfXaTRgpJE4r44igVBp5WRVZwkkAUYkcUA0
         4ORLo+zoOBs8oBC4WHT9MkEy4vdLwNt67QWHPxjGrqqSREHSCUlW+cMTxVQ1I2sYSXq7
         t/OI68FmPqswr+lj4oS9qy6A58jLrf5peqTQhyc+WsC2Zgn3vMVmThkXsE3TuOf06ARX
         mxtgzS7I/OmRDsvOJhdSIUizPyDMm2ZF9J6RP/q7SDO+FBInRIo/ypnpr/XczgUgJIUC
         escDNXQw+urdUVBMQ+TKbGodSuWn5j+P/Ppqd/6+BM0OfxHnnLClJGaheg4NhXaF0J31
         kKxw==
X-Gm-Message-State: ANoB5pk0lPzjFPpmtcsRxdWEKCvyr9MNpHtlIR0tp+ZJ/V5rL5MT+RuK
        gNIinGftdxop68kmQlFswDM=
X-Google-Smtp-Source: AA0mqf4JoX1P7+deIH1yzYTqw4QP70qZorpLiOopnZuJ3Ywc5/DJ59eDvBwLUOU47jV6eXqIXRRl+A==
X-Received: by 2002:a5d:68c8:0:b0:242:15e1:5805 with SMTP id p8-20020a5d68c8000000b0024215e15805mr12712664wrw.55.1670933358068;
        Tue, 13 Dec 2022 04:09:18 -0800 (PST)
Received: from debian (host-78-150-37-98.as13285.net. [78.150.37.98])
        by smtp.gmail.com with ESMTPSA id v1-20020a5d6781000000b002422b462975sm11329673wru.34.2022.12.13.04.09.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 13 Dec 2022 04:09:17 -0800 (PST)
Date:   Tue, 13 Dec 2022 12:09:16 +0000
From:   "Sudip Mukherjee (Codethink)" <sudipm.mukherjee@gmail.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     stable@vger.kernel.org, patches@lists.linux.dev,
        linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, f.fainelli@gmail.com, srw@sladewatkins.net,
        rwarsow@gmx.de
Subject: Re: [PATCH 6.0 000/157] 6.0.13-rc1 review
Message-ID: <Y5hrbCeCIHo+tigK@debian>
References: <20221212130934.337225088@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221212130934.337225088@linuxfoundation.org>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Greg,

On Mon, Dec 12, 2022 at 02:15:48PM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.0.13 release.
> There are 157 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 14 Dec 2022 13:08:57 +0000.
> Anything received after that time might be too late.

Build test (gcc version 12.2.1 20221127):
mips: 52 configs -> no failure
arm: 100 configs -> no failure
arm64: 3 configs -> no failure
x86_64: 4 configs -> no failure
alpha allmodconfig -> no failure
csky allmodconfig -> no failure
powerpc allmodconfig -> no failure
riscv allmodconfig -> no failure
s390 allmodconfig -> no failure
xtensa allmodconfig -> no failure

Boot test:
x86_64: Booted on my test laptop. No regression.
x86_64: Booted on qemu. No regression. [1]
arm64: Booted on rpi4b (4GB model). No regression. [2]
mips: Booted on ci20 board. No regression. [3]

[1]. https://openqa.qa.codethink.co.uk/tests/2341
[2]. https://openqa.qa.codethink.co.uk/tests/2343
[3]. https://openqa.qa.codethink.co.uk/tests/2345

Tested-by: Sudip Mukherjee <sudip.mukherjee@codethink.co.uk>

-- 
Regards
Sudip
