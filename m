Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B1F794B0097
	for <lists+stable@lfdr.de>; Wed,  9 Feb 2022 23:48:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236271AbiBIWsB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 9 Feb 2022 17:48:01 -0500
Received: from gmail-smtp-in.l.google.com ([23.128.96.19]:49714 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236164AbiBIWr7 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 9 Feb 2022 17:47:59 -0500
Received: from mail-pj1-x1034.google.com (mail-pj1-x1034.google.com [IPv6:2607:f8b0:4864:20::1034])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 32D8DE01644C;
        Wed,  9 Feb 2022 14:48:02 -0800 (PST)
Received: by mail-pj1-x1034.google.com with SMTP id v13-20020a17090ac90d00b001b87bc106bdso6656528pjt.4;
        Wed, 09 Feb 2022 14:48:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:from:in-reply-to:subject:to:cc
         :content-transfer-encoding;
        bh=KXc1sqyU2Qd7WQy9J1rum8wM80ISZeqcdXY4bjyOVmg=;
        b=RJoS/D+pCheo/4MzOz0AdAlQsEred3Y17syMeJcS2OQxl049MoB7xQ3sDmUuZKI0no
         BPjQSUwQLhUbyfNZ0Oi1B8W7Xlgg/9WHHmffv6TKffiwVLA8qQyyDHo/iXLnNvDTUGZq
         khNLvzT1As7jOtP4kKZl6uVGbK0/lLrmaXtX/iSHgwrlH8TugatOaeoBcjV01baSnLfF
         7B0gk2/Q0THvxfCUfcARX9gIEgc7bMX0LWbXPR3iIGv073uL5+R2kReHpXxaHmF7Qep9
         xeNlmnWHPs44BLnKJ4sIHEG1ziqoJHW+RWmqEiXwn/urRdTKSDuA8444lNKt9HXnePy0
         jMIg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:from:in-reply-to:subject:to:cc
         :content-transfer-encoding;
        bh=KXc1sqyU2Qd7WQy9J1rum8wM80ISZeqcdXY4bjyOVmg=;
        b=YF7/tWGIn4zhxJ7QRZI7G6crPoW+pwyIYa87tVU3esG7csB2i9LI21bEfrdKkZFLZ8
         BDI9+oSNSDss/sRzXziwH708ckql3jDKcFVEnZ65yqr6u/dmxfoXtsDpilw+1PDKzVxD
         qAEDhSBqORiooF2wDH5TWFgKAcn5b1XhjY7NIU19tFnQH7gCRDuXw48H9RXjV22+pteK
         AhhJwbOL3fD75xesTLJmy7CIMHdcXXwe+AOOClTCuttfbB8i0rwo9xDv2U6uEPElbaLR
         IRVofTluipaiLqZht+O6ZqdztWQMSu6phIUwM3kjmDdfH+IQ/gkKLTEIfCP4Gr9m7sRG
         fTCw==
X-Gm-Message-State: AOAM5339qpfeLqHf7yZuirCfE3sem9eSKLVvqtwm/wbQ75K/knpbkV4I
        BSUtpZi/30nn+Hi1sME/oQaDEGmmo1ritZyhU1KALg==
X-Google-Smtp-Source: ABdhPJyThSBmBM2LV3bKOXvGwHD6J/HGztn5/d/UZGnKv84QhsHzmiJczkjkm3O/iWjI1mEM0S70FQ==
X-Received: by 2002:a17:903:228c:: with SMTP id b12mr4714648plh.39.1644446881046;
        Wed, 09 Feb 2022 14:48:01 -0800 (PST)
Received: from cl-arch-kdev (cl-arch-kdev.xen.prgmr.com. [71.19.144.195])
        by smtp.gmail.com with ESMTPSA id k21sm20985332pff.33.2022.02.09.14.47.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 09 Feb 2022 14:48:00 -0800 (PST)
Message-ID: <620444a0.1c69fb81.12f9e.457f@mx.google.com>
Date:   Wed, 09 Feb 2022 14:48:00 -0800 (PST)
X-Google-Original-Date: Wed, 09 Feb 2022 22:47:53 GMT
From:   Fox Chen <foxhlchen@gmail.com>
In-Reply-To: <20220209191249.887150036@linuxfoundation.org>
Subject: RE: [PATCH 5.16 0/5] 5.16.9-rc1 review
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

On Wed,  9 Feb 2022 20:14:32 +0100, Greg Kroah-Hartman <gregkh@linuxfoundation.org> wrote:
> This is the start of the stable review cycle for the 5.16.9 release.
> There are 5 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 11 Feb 2022 19:12:41 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.16.9-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.16.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h
> 

5.16.9-rc1 Successfully Compiled and booted on my Raspberry PI 4b (8g) (bcm2711)
                
Tested-by: Fox Chen <foxhlchen@gmail.com>

