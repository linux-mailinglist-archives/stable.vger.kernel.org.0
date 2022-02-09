Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B05154AECFD
	for <lists+stable@lfdr.de>; Wed,  9 Feb 2022 09:46:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230002AbiBIIpe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 9 Feb 2022 03:45:34 -0500
Received: from gmail-smtp-in.l.google.com ([23.128.96.19]:43882 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236668AbiBIIp1 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 9 Feb 2022 03:45:27 -0500
Received: from mail-lj1-x22d.google.com (mail-lj1-x22d.google.com [IPv6:2a00:1450:4864:20::22d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BB65CDF48F30;
        Wed,  9 Feb 2022 00:45:21 -0800 (PST)
Received: by mail-lj1-x22d.google.com with SMTP id p21so2325127ljn.13;
        Wed, 09 Feb 2022 00:45:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:from:in-reply-to:subject:to:cc
         :content-transfer-encoding;
        bh=N7l+9Q3ZbYKnRblvKhK4ZFvRYFW4s+Ggznb+bCIOL84=;
        b=P1ISCF7QFW/wQMWGWkkhsucsTYEDNNHdWyRWuGC/YcgrdYOCxU6uhL0SIQB6CuPNUt
         Th88IPkkAETe7IKcuEdXS8ZvC5n2VYR4RmWdWoUSQZOi/PJN4hHLx/W2MRvcHF1s+jVC
         iZ/2nIWYaaqxe7kmdpbL95TMEyJAzsg9u3vrfV9AcqdMph9Mw81bpoT2kQIjexEqu967
         23cleR/wc8wivOfHBWuX4fGa37z3jRIngks/MCYwUaa2j5V2ZRqKLijhbRVajTV/lh7G
         Nj7hUGxfcTJI9LmGAHjIq3SHpzM1XxcVq5XPk4g6bOI/CHAzvAuTis+toiuqp28HEhsK
         axDQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:from:in-reply-to:subject:to:cc
         :content-transfer-encoding;
        bh=N7l+9Q3ZbYKnRblvKhK4ZFvRYFW4s+Ggznb+bCIOL84=;
        b=FC2mudEdJLIOdIzlgnorze1/EHFYjOUKW9ns9OKyAeJlsFw/oODcyszIHeBE9U4vBH
         8J+cekVLz3AYQ2kUok/Q4suapZQ8XxFq4tBIDyUTCQBpk8s4HBoCxVYCwUlPVVJ04ujN
         4PJATmgIXR85HtfVEnRjC9J0Uo413NTvlp5rlIaCaOx+ved7hBCluT7sYoGymaTzLUVf
         Bo273IWDHhaQCoGLoI+itEI1F1YtYJBOey7BBP+jlxehp43ZRQSJJ3yOS3oTsds0mVDw
         MuJ5pnlpQi7qqqZ7pPHQhPiUPiWdnI4drMNNqA6Ub9EXWs5USCgU5aRTBooetGE43zHw
         a9SA==
X-Gm-Message-State: AOAM5312+68/L5emO0zCglgk8I9vj/icCEG6WKwgqHQeWXR4gwGa6xUV
        9Q60GnzAiNgucvGcNnFMt+gAS/TMKJZ+btVauUUDtA==
X-Google-Smtp-Source: ABdhPJw0ar4oP76VUNH1nOGbF4UnZQE5IVHHEfbQkFW9UBNVqyZk6bDQ4CcTPRQjaKXHpCTPQ4gneg==
X-Received: by 2002:a05:651c:1305:: with SMTP id u5mr807263lja.339.1644396279093;
        Wed, 09 Feb 2022 00:44:39 -0800 (PST)
Received: from cl-arch-kdev (cl-arch-kdev.xen.prgmr.com. [2605:2700:0:2:a800:ff:fed6:fc0d])
        by smtp.gmail.com with ESMTPSA id b8sm2265030lfb.22.2022.02.09.00.44.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 09 Feb 2022 00:44:38 -0800 (PST)
Message-ID: <62037ef6.1c69fb81.44b8c.90ab@mx.google.com>
Date:   Wed, 09 Feb 2022 00:44:38 -0800 (PST)
X-Google-Original-Date: Wed, 09 Feb 2022 08:44:33 GMT
From:   Fox Chen <foxhlchen@gmail.com>
In-Reply-To: <20220207133903.595766086@linuxfoundation.org>
Subject: RE: [PATCH 5.15 000/111] 5.15.22-rc2 review
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

On Mon,  7 Feb 2022 15:04:35 +0100, Greg Kroah-Hartman <gregkh@linuxfoundation.org> wrote:
> This is the start of the stable review cycle for the 5.15.22 release.
> There are 111 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 09 Feb 2022 13:38:43 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.15.22-rc2.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.15.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h
> 

5.15.22-rc2 Successfully Compiled and booted on my Raspberry PI 4b (8g) (bcm2711)
                
Tested-by: Fox Chen <foxhlchen@gmail.com>

