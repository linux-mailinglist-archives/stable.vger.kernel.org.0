Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 279BB4D92B4
	for <lists+stable@lfdr.de>; Tue, 15 Mar 2022 03:42:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233882AbiCOCng (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Mar 2022 22:43:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34000 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344505AbiCOCnf (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 14 Mar 2022 22:43:35 -0400
Received: from mail-pf1-x42b.google.com (mail-pf1-x42b.google.com [IPv6:2607:f8b0:4864:20::42b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 98EA648307;
        Mon, 14 Mar 2022 19:42:24 -0700 (PDT)
Received: by mail-pf1-x42b.google.com with SMTP id f8so17311214pfj.5;
        Mon, 14 Mar 2022 19:42:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:from:in-reply-to:subject:to:cc
         :content-transfer-encoding;
        bh=SacbrvjKw7fY+dlnnH94qEz643omGhuaUbTvS7BkFpo=;
        b=hbGFk7hNn+JA8tW1p1Q19tn1+HN6SRCnsQx29IQ7L6IdW4wgJthKdqOgCpI4fT8lF2
         MpH6G7I+d/cIyBTzho3hO6Wjwj90GdvxjDv20kGhdGMSjrE5piTETTnHGCX6Bz9gQoG5
         sMM/iezxZVkVtL1eY+zhp0zc3g32h2YdIQlaB/FwEt/JD2dHo1m/v/c7Nqr9bjU1rgzk
         M/1h/VyF5doejhrtu/yxkWhNkBp4jWpgJCOg3S0uNV0nDnChHtUpkZfMcRjpOAysLgNH
         Tals0z290WqhEW8J7/H9vL9wlUsPu0T75eyEVN0Mwp7zAd87QXXIcgTkno2frgxc+NW3
         +Owg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:from:in-reply-to:subject:to:cc
         :content-transfer-encoding;
        bh=SacbrvjKw7fY+dlnnH94qEz643omGhuaUbTvS7BkFpo=;
        b=TSSbQnlj2+3hvMvA9Cr19VRCou2xhu+tfvDi+1seWFzwbrLXUT9bzFCikmQC4e7KOt
         jgNLv9Es/GHt8gbX3ZAZFc7Nczt8EzxnOnXMtdwMuLAZGACQdOAb9IYIjxBe9OLsmY4L
         cg2jN0ecJeflQTCXQL1S/WP3m5T8KSavfbNIB/SbRvWP1tZ1C1FVqftLCpIdBLI8W7u8
         7LV1ULKDZV3uQsTiaGAs9KBz1gE5vdEgx4VFmbsmp/JBHCn6Slyk4xJyzoQkYTxL6xfi
         pEHxX+jv23WX/SMcSZC7UojzrBvJ0UG7CdVTZTXqa9QWPR47Rz4UAlPH2v3u0Uqg4Hpx
         pRuQ==
X-Gm-Message-State: AOAM533fUoRlMY37NLtT8mjun5v1+PwRPZPuvD6YWARmSUe+TvGSUXTQ
        WOczNFq/sV1bbeJasdHFqzvhx+6kNuD8W5kQ41g/QQ==
X-Google-Smtp-Source: ABdhPJy4t6CSSEPvrqfm9rYp9gsqSvnAUObPXgQ9HpMz6DrIwx8y7gwo9ug/OR8NMzOUXb41Q7bGrQ==
X-Received: by 2002:a62:4e48:0:b0:4f6:cc16:8116 with SMTP id c69-20020a624e48000000b004f6cc168116mr26488743pfb.54.1647312143678;
        Mon, 14 Mar 2022 19:42:23 -0700 (PDT)
Received: from cl-arch-kdev (cl-arch-kdev.xen.prgmr.com. [2605:2700:0:2:a800:ff:fed6:fc0d])
        by smtp.gmail.com with ESMTPSA id w17-20020a056a0014d100b004f79bb37b54sm12144891pfu.195.2022.03.14.19.42.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 14 Mar 2022 19:42:23 -0700 (PDT)
Message-ID: <622ffd0f.1c69fb81.c97cd.ed76@mx.google.com>
Date:   Mon, 14 Mar 2022 19:42:23 -0700 (PDT)
X-Google-Original-Date: Tue, 15 Mar 2022 02:42:21 GMT
From:   Fox Chen <foxhlchen@gmail.com>
In-Reply-To: <20220314112744.120491875@linuxfoundation.org>
Subject: RE: [PATCH 5.16 000/121] 5.16.15-rc1 review
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

On Mon, 14 Mar 2022 12:53:03 +0100, Greg Kroah-Hartman <gregkh@linuxfoundation.org> wrote:
> This is the start of the stable review cycle for the 5.16.15 release.
> There are 121 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 16 Mar 2022 11:27:22 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.16.15-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.16.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h
> 

5.16.15-rc1 Successfully Compiled and booted on my Raspberry PI 4b (8g) (bcm2711)
                
Tested-by: Fox Chen <foxhlchen@gmail.com>

