Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8C7124B5437
	for <lists+stable@lfdr.de>; Mon, 14 Feb 2022 16:09:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353007AbiBNPJ2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Feb 2022 10:09:28 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:38918 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243886AbiBNPJ1 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 14 Feb 2022 10:09:27 -0500
Received: from mail-lj1-x233.google.com (mail-lj1-x233.google.com [IPv6:2a00:1450:4864:20::233])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ACAC2B84F;
        Mon, 14 Feb 2022 07:09:18 -0800 (PST)
Received: by mail-lj1-x233.google.com with SMTP id w6so2583763ljj.3;
        Mon, 14 Feb 2022 07:09:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:from:in-reply-to:subject:to:cc
         :content-transfer-encoding;
        bh=OgvzWeL2gxETa8bIbp1BwS5Hh69YjWAn3iFy8+tRqGw=;
        b=ak1nW1+BZAwK5RCQKmXlHfSW8FsrZ12pXLx6VLwCzJBSGaf/eYxYKTIozKy/iHq9Eb
         gbhUrDLfhXd8mt4gE72NMH0Y0SUrbG8XX62VFN8dHZMJktdj/W9Jc/i3b3ljvRBc/KWS
         IHa+v553SIYYrKwb0KeM17Xi25jAQ6eSQ35ZwWvJBO32mmBC95rXiTdBKt0mo/tBjKwV
         dXk3Znze1VIp9N57+uSfoW1OFPcqVVO/3adZiBAIt/wRh8nfTQxMRxxLfGA+X1UjIBXh
         chXl+gzl7OYVrJtXByRIMPaPWcfjqbKMdKngl3p8QE5n0rH+LyTO/UbHvJLVcwhotIjL
         kRFg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:from:in-reply-to:subject:to:cc
         :content-transfer-encoding;
        bh=OgvzWeL2gxETa8bIbp1BwS5Hh69YjWAn3iFy8+tRqGw=;
        b=bIlESxHdvG1N/UaYKz+kqkU2m0+o1WEB47iRrUdIsc6Qmu53zYWQsDLug5GGvjdu0j
         828UtS1zmZLeERudyaW/OJj6XsEBMD2IiVQwmug+JWrWEFp59fXgE83Efv8OWxF65zDZ
         UPKHFTSmF0HL4Ktq1V3mfXaEiu4WQhyzI1AAJllHnw6hpk8A/iCMnCWxTiGubaOjFyRR
         g6k/pdyNSw2jVfsGWJW1AL1HYa7Axvew1QS6BVweWbHDiEX4W3fYyZm0X4HvtRasB6Jr
         LYvCQe9w7YzfRNXpz0zxMl1x6l79c0NfGXhu/Xqx/n1KCP3r38nRLm8wqXf2Ue1Jd8bK
         HqMA==
X-Gm-Message-State: AOAM531Jro/Nvx3X0U8jNivzBJFk0o2F7SW0P+0O821yVaMJQc1OeKMf
        2miRVuQ3QDNzJrwHgO7fqfrzP3LdKhdDIm2xAAc=
X-Google-Smtp-Source: ABdhPJzrVtGFstrzvnKZ4tnYHXap5XehMS2FWVkPXeBZVXB9SQTHOhHBolLaHw90l3iPGN3chwWx+A==
X-Received: by 2002:a2e:a0cd:: with SMTP id f13mr134764ljm.116.1644851356663;
        Mon, 14 Feb 2022 07:09:16 -0800 (PST)
Received: from cl-arch-kdev (cl-arch-kdev.xen.prgmr.com. [2605:2700:0:2:a800:ff:fed6:fc0d])
        by smtp.gmail.com with ESMTPSA id bp37sm3933236lfb.86.2022.02.14.07.09.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 14 Feb 2022 07:09:16 -0800 (PST)
Message-ID: <620a709c.1c69fb81.2fe5d.168b@mx.google.com>
Date:   Mon, 14 Feb 2022 07:09:16 -0800 (PST)
X-Google-Original-Date: Mon, 14 Feb 2022 15:09:11 GMT
From:   Fox Chen <foxhlchen@gmail.com>
In-Reply-To: <20220214092510.221474733@linuxfoundation.org>
Subject: RE: [PATCH 5.16 000/203] 5.16.10-rc1 review
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

On Mon, 14 Feb 2022 10:24:04 +0100, Greg Kroah-Hartman <gregkh@linuxfoundation.org> wrote:
> This is the start of the stable review cycle for the 5.16.10 release.
> There are 203 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 16 Feb 2022 09:24:36 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.16.10-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.16.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h
> 

5.16.10-rc1 Successfully Compiled and booted on my Raspberry PI 4b (8g) (bcm2711)
                
Tested-by: Fox Chen <foxhlchen@gmail.com>

