Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 239FC6A159F
	for <lists+stable@lfdr.de>; Fri, 24 Feb 2023 04:46:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229625AbjBXDqm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 23 Feb 2023 22:46:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48690 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229605AbjBXDql (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 23 Feb 2023 22:46:41 -0500
Received: from mail-pl1-x634.google.com (mail-pl1-x634.google.com [IPv6:2607:f8b0:4864:20::634])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D91381516B
        for <stable@vger.kernel.org>; Thu, 23 Feb 2023 19:46:39 -0800 (PST)
Received: by mail-pl1-x634.google.com with SMTP id c1so15649929plg.4
        for <stable@vger.kernel.org>; Thu, 23 Feb 2023 19:46:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=sladewatkins.net; s=googled;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=/JfVS6gSRN9xdENO2plX3s3LFcs3qMQlJW27g6ZvzsU=;
        b=ZTEyjiTH+zXzYH6wSkCTrUOxnZHFWUgC2WuZrjzfVC7d5SlVwvIREtWWOZfGb7HvEe
         cuBApiMHt/oHw6gvpv9WQMb6AWfssrQ7RcU82VKS+fCgXgH0IwYzstsz+2AHFjnIqNIZ
         LfCJNEZ2opvJTJ1VV5gEFHFybw7wJRGZEl5DlBNnzdWBj4F+7Bceu42nZEoAxFQNoItm
         c7hY25NGX13iN9cUPUeVnr0ffeZn+LU2BPzrSSne1qxlLvcszgNGV69hjnfa62y3shzQ
         mehn/vic7u7506BpAF1bpnI0J+gtWxx5ztQgrF9Stncp1QYhhxSUkXchgg9+TDMNEQFF
         +qoA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=/JfVS6gSRN9xdENO2plX3s3LFcs3qMQlJW27g6ZvzsU=;
        b=fsqH6UiBhKQdN+lN+Cx49uSIkuh2FqkWu282TvRr850Z8ADGSQlCHNVBpkZMtoeOnd
         vTW1zmD0SxijrUQABjJne1LABYvvXD7aGtfMXSaWLY6l0VmqUqpy++N3zhBUwCGgfmxH
         7DUjebBzn2aU9yW9wuIDfduGYFnAFNfTHvbXj4lbZzhfwQY8x/ETHoGO5D4tSScoYJ9e
         wfCCIrNSI06O37P7Hgwrb9fDceJUgENAegebnF5lNmBi5T6ySKW+CvfoSjE+Bb44HlYj
         nwJMiauknngxh6eAdPNmBVQqG/vKO6wZU+6H1/brczSILx1fYBk16iVVUOjvmB+9+G9t
         CFaQ==
X-Gm-Message-State: AO0yUKWBKN9eyGCrZ1lX4NFT3uRqow/0NqoFJIsq/Hs2JZea08kezsj0
        9U7eEOZ7f/8SIJIkbnot68pf6LDFihEcWsxX/EmmFw==
X-Google-Smtp-Source: AK7set85GZscAWYYUGouXn5Qr4Vng0Gl/yEz+Tbv5OH3JedjpuQ26qMIoJKnYHhBJU8VHI6Na/mSs5dHeh7VN0oqbG4=
X-Received: by 2002:a17:902:684d:b0:19b:f946:e57d with SMTP id
 f13-20020a170902684d00b0019bf946e57dmr2467075pln.11.1677210399139; Thu, 23
 Feb 2023 19:46:39 -0800 (PST)
MIME-Version: 1.0
References: <20230223141538.102388120@linuxfoundation.org>
In-Reply-To: <20230223141538.102388120@linuxfoundation.org>
From:   Slade Watkins <srw@sladewatkins.net>
Date:   Thu, 23 Feb 2023 22:46:27 -0500
Message-ID: <CA+pv=HNryt092838xJmhop5501kCWaHsvEreYaDBJviTB_JVpg@mail.gmail.com>
Subject: Re: [PATCH 4.19 00/12] 4.19.274-rc2 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     stable@vger.kernel.org, patches@lists.linux.dev,
        linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, f.fainelli@gmail.com,
        sudipm.mukherjee@gmail.com, rwarsow@gmx.de
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-1.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Feb 23, 2023 at 9:16 AM Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 4.19.274 release.
> There are 12 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Sat, 25 Feb 2023 14:15:30 +0000.
> Anything received after that time might be too late.

4.19.274-rc2 compiled and booted on my x86_64 test system. No errors
or regressions.

Tested-by: Slade Watkins <srw@sladewatkins.net>

Thanks,
-- Slade
