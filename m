Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 616D85AF83C
	for <lists+stable@lfdr.de>; Wed,  7 Sep 2022 01:07:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229561AbiIFXH1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 6 Sep 2022 19:07:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60518 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229449AbiIFXH0 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 6 Sep 2022 19:07:26 -0400
Received: from mail-pf1-x42f.google.com (mail-pf1-x42f.google.com [IPv6:2607:f8b0:4864:20::42f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D407B861FC;
        Tue,  6 Sep 2022 16:07:25 -0700 (PDT)
Received: by mail-pf1-x42f.google.com with SMTP id y136so7915827pfb.3;
        Tue, 06 Sep 2022 16:07:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date;
        bh=KT/ry2p0gdOb2e9NM3GcxTZOWcGsrIJ1KYsbBHoYVUU=;
        b=bsZIn+VU1xJjX8VmAJr3McehZHYJz1UX82le0PQVffH3eRCYdUjD57MdztvsYmIfLI
         cpbF1jXrntvRZ9cZ/b+lQIu3/39XrvpJZ3C7WJlxhVPwDbdIrvmGJBlDgwo7NbgtJxJ4
         ngPTPWeZYWa7C3GNbDSMA1Z+d7SBHbgXfUTfNVJAnonPcwtcWpPalcvH6dBtFib4Ze5a
         vlnXXko1IPFOECz0HyTDyMIsyTb57f5Vhkgl2O3biqtnoppWoiIQnlVD1XrGSMkvtkUg
         Ee05MxlTI6TTrinB/Nu6X2FrJT8yUzR8XXQMKMNCgJKGnCKVYEDjsL5jzlgcK/DTnJOE
         lRBQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date;
        bh=KT/ry2p0gdOb2e9NM3GcxTZOWcGsrIJ1KYsbBHoYVUU=;
        b=45exJ8ebEgXChYFMCCWZMZqLVDK1auTz2s981juRR1CPywZrENH2lFaTYPP0xUBy9p
         nSogoBasbwDfmanBnaJzVY1hhlYHVV0lUyCl9R3kjZGsy02KTrImm5WK10E2b3gEflJS
         w3aV9ETbVC16ZcGqL/eb5YHvsJXluCRuPRP27iv5ReiPvjhzuf69H6jzYgoNziAqlz12
         k4SL5av8FBWhdRCNWDwjUE95kwEZ/NdihdbGQHANAirstQSu+tN6fPEGiVx8AD/QiLO5
         ohbw9wIoDcJEpbHnvNfq8RcZvIPxmFyRAQL/K09DEYQVXDRez88cwsOmd1GTeo49wG/7
         gaVQ==
X-Gm-Message-State: ACgBeo3tCcVWRna7O5Uc0g4r0Kd69nh3wuCCoSQ+NoFjUMVVUqjOdsFH
        vp+BkSN0ew5OPz2cJv4qZ3Noi09oH+SV3eOT40Q=
X-Google-Smtp-Source: AA6agR6BtbKLkFmHZOWx4xGIZIlcRabsKR81xGUkze3hwJQwdgxEczk1SZTnjE5T9BTfz+0psbJnTqG9YBuprHrejxo=
X-Received: by 2002:a63:e452:0:b0:42c:60ce:8b78 with SMTP id
 i18-20020a63e452000000b0042c60ce8b78mr805208pgk.453.1662505645263; Tue, 06
 Sep 2022 16:07:25 -0700 (PDT)
MIME-Version: 1.0
References: <20220906132829.417117002@linuxfoundation.org>
In-Reply-To: <20220906132829.417117002@linuxfoundation.org>
From:   Zan Aziz <zanaziz313@gmail.com>
Date:   Tue, 6 Sep 2022 17:07:13 -0600
Message-ID: <CAFU3qoZBr4DTUe6rgh0pjABD29bRvUKw5JkUJzx_fVwRqgbz4A@mail.gmail.com>
Subject: Re: [PATCH 5.19 000/155] 5.19.8-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        slade@sladewatkins.com
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Sep 6, 2022 at 8:53 AM Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 5.19.8 release.
> There are 155 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Thu, 08 Sep 2022 13:27:58 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.19.8-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.19.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

Hi Greg,

Compiled and booted on my test system Lenovo P50s: Intel Core i7
No emergency and critical messages in the dmesg

./perf bench sched all
# Running sched/messaging benchmark...
# 20 sender and receiver processes per group
# 10 groups == 400 processes run

     Total time: 0.808 [sec]

# Running sched/pipe benchmark...
# Executed 1000000 pipe operations between two processes

     Total time: 9.461 [sec]

       9.461262 usecs/op
         105694 ops/sec

Tested-by: Zan Aziz <zanaziz313@gmail.com>

Thanks
-Zan
