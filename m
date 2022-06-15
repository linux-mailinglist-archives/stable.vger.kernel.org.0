Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2915154C49B
	for <lists+stable@lfdr.de>; Wed, 15 Jun 2022 11:26:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245758AbiFOJ0v (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 15 Jun 2022 05:26:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38698 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238242AbiFOJ0v (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 15 Jun 2022 05:26:51 -0400
Received: from mail-wm1-x329.google.com (mail-wm1-x329.google.com [IPv6:2a00:1450:4864:20::329])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 00BD215828;
        Wed, 15 Jun 2022 02:26:49 -0700 (PDT)
Received: by mail-wm1-x329.google.com with SMTP id z9so5962932wmf.3;
        Wed, 15 Jun 2022 02:26:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=UWQhQKyh7LCFwndabc/wa7U3fjetUDKPUrL6qA9/OOQ=;
        b=bQdgh6MXU2h9dubnJPuRMAEdgWGuEtu84HbWVqZH7J1BE6/Jo7SD5kY3kaL10aGT1z
         +2eLyASFKlAribFeMES1yGj1E4xX3B/eMt0vQSkoerPofZyl4utHmCavgjk4Dwc8rCA0
         QXK1LK1/wDH+rs+p3t5320XqKXVc1BjgIpA8qeRUzSusFYip3igcgpKe+MHwuJctYXyb
         YI5wxeze3B5dSXglaU46PU6MZpThsF6B2XhGXP3fugUL8uMWPwR/LE1jNXdW8quQ9t0F
         sNfDnsWLb4Bt8BMV8BPoPzt1PV4oZSqSnWqAYXlDcksYbEdv55OYMQK/mW5fcZozvbDr
         03eQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=UWQhQKyh7LCFwndabc/wa7U3fjetUDKPUrL6qA9/OOQ=;
        b=EsIzqvFn0NlMbwbTfgUeKBJeWehmxyLeeSo9CVGKoQZQCWKRu9B/ZgRVyyNHig/KBG
         Snm5Dry40A0QgLxQHtyIhVzVy9tvSMTM8eXEDlbuB2c4j41sf7AVzD31kAHXroc59lpu
         Ysx3U0sEZNVj7vVAsBnvMGTqerMGPfmeLcy7bwUl3byLUyywClzPnNq5WO6SMF9kXray
         qo0rHUds/f5lCJ+Gptjlh6z3zQLqnrPkyADmNuR02nTHxM/9gNPatW16z4xyDqLzmpb2
         OXk6ERIV9iQoll2oVs1hG335f3gI3Icwgzp+193gzk0PVAAjB2O3LPokeTGux+nAPiii
         ywVg==
X-Gm-Message-State: AOAM532OWPWgyZKkaG6jqTJL8BnjB2IZvf4IAKIS/4pqNFRLcQ4dpdbA
        +SEuu6p36iOpN2PvlIE16/A=
X-Google-Smtp-Source: ABdhPJzosdotAY4JQkY3kVQH6a1ROLp7+In78qTkc3vRbVzm21IULNVo7ozzV40+UmQTKNE6hM6bIg==
X-Received: by 2002:a7b:c4d4:0:b0:39c:5bb7:2210 with SMTP id g20-20020a7bc4d4000000b0039c5bb72210mr8756289wmk.99.1655285208475;
        Wed, 15 Jun 2022 02:26:48 -0700 (PDT)
Received: from debian ([167.98.27.226])
        by smtp.gmail.com with ESMTPSA id bh4-20020a05600005c400b002103bd9c5acsm14775782wrb.105.2022.06.15.02.26.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 15 Jun 2022 02:26:48 -0700 (PDT)
Date:   Wed, 15 Jun 2022 10:26:46 +0100
From:   Sudip Mukherjee <sudipm.mukherjee@gmail.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, slade@sladewatkins.com
Subject: Re: [PATCH 4.19 00/16] 4.19.248-rc1 review
Message-ID: <Yqml1qX4/LcNV1o2@debian>
References: <20220614183720.928818645@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220614183720.928818645@linuxfoundation.org>
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

On Tue, Jun 14, 2022 at 08:40:01PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.19.248 release.
> There are 16 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 16 Jun 2022 18:37:02 +0000.
> Anything received after that time might be too late.

Build test (gcc version 11.3.1 20220612):
mips: 63 configs -> no  failure
arm: 115 configs -> no failure
arm64: 2 configs -> no failure
x86_64: 4 configs -> no failure
alpha allmodconfig -> no failure
s390 allmodconfig -> no failure
xtensa allmodconfig -> no failure

Boot test:
x86_64: Booted on my test laptop. No regression.
x86_64: Booted on qemu. No regression. [1]

[1]. https://openqa.qa.codethink.co.uk/tests/1338


Tested-by: Sudip Mukherjee <sudip.mukherjee@codethink.co.uk>

--
Regards
Sudip
