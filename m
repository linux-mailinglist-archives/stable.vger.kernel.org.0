Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3230159EDED
	for <lists+stable@lfdr.de>; Tue, 23 Aug 2022 23:03:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229622AbiHWVCc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Aug 2022 17:02:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54764 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229778AbiHWVCa (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 23 Aug 2022 17:02:30 -0400
Received: from mail-pl1-x634.google.com (mail-pl1-x634.google.com [IPv6:2607:f8b0:4864:20::634])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 404437F13B;
        Tue, 23 Aug 2022 14:02:28 -0700 (PDT)
Received: by mail-pl1-x634.google.com with SMTP id c2so13912394plo.3;
        Tue, 23 Aug 2022 14:02:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc;
        bh=daxGDaLiDmevUPPK2yqaQGLkiBYxbmd1niJSMsxmrJU=;
        b=p4PCdHdzlXFXdf++8dra3WZtKQtsFYuXCeTzvOfZlBS6ZTGDt/3fPlx8+6IP+vMTsA
         52wKyr427J4eExWY9s4024FjvweSttAkNYuTAcjMoUpIJYJdjvT/NnryjYkZHRvnI41+
         OFe5LKyzGqahx4WbtO7RTZzxnyEhwKtYRVXTYyAs02mvkhmgkfldTC+vZvmrHcGZ4duU
         uP1wTVGM4jlwSPUEbcmJjZzFtqhxK1nh+10F+i8qa+JpIMzP7z39Hb8ob3js7TaaUsR6
         ZcxrvuvzLoojmqW3Bunbx+RqEfW76h4kXWDaraTWkbmUcNyyAL+fQ0hLPEoOSw6zf60W
         XRrA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:x-gm-message-state:from:to:cc;
        bh=daxGDaLiDmevUPPK2yqaQGLkiBYxbmd1niJSMsxmrJU=;
        b=qGZla5QRobU40SmgpgsJi5Em1CO0/CdJXV2ztL4HaijBRSdofCCg4KxAk3d6mrFEyc
         YwrOiv2YKok+8zu025GOMost+odNRf9GH/dxkRRly/Fxx+aUpOqAxepMkX4Pmc8N4U7S
         LJWWc77CcqODhXUFUmz6HNNKEuqOtEKZOQupSDMnFOsparujPHg1ZFk7CNouDBkieuT4
         BXl2m0EbftbjlotE9zuMN+dvTLFmiUB4TMDNjRtnxZKSg0ahtC8cCjgV+NQW46zVG32F
         nB+YWCzDBGvGTmOdHZzkwzzESsDWdfdQx5cSGSPU0DxOZSma+qiIhqN8POJ5To2MwxOB
         b5bw==
X-Gm-Message-State: ACgBeo1mkuP3ijzS89JQ31EZH1tI3rGaIDyuTndEpphVcVPt3XmBpcro
        tUugRItXrJzv7nNtdpgm6E46hvcjwuc=
X-Google-Smtp-Source: AA6agR43Nc/llAAIWMYpU4Q8A5OaIBpUExQmZ+L0WG6Mc8juahWDAuAUtg93DdJ242zjmICG891S+A==
X-Received: by 2002:a17:903:11c7:b0:171:2818:4cd7 with SMTP id q7-20020a17090311c700b0017128184cd7mr25478922plh.136.1661288547769;
        Tue, 23 Aug 2022 14:02:27 -0700 (PDT)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id d7-20020a170903230700b0016d338160d6sm11058652plh.155.2022.08.23.14.02.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 23 Aug 2022 14:02:26 -0700 (PDT)
Sender: Guenter Roeck <groeck7@gmail.com>
Date:   Tue, 23 Aug 2022 14:02:26 -0700
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        slade@sladewatkins.com
Subject: Re: [PATCH 5.4 000/389] 5.4.211-rc1 review
Message-ID: <20220823210226.GC2371231@roeck-us.net>
References: <20220823080115.331990024@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220823080115.331990024@linuxfoundation.org>
X-Spam-Status: No, score=-1.3 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Aug 23, 2022 at 10:21:18AM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.4.211 release.
> There are 389 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 25 Aug 2022 08:00:15 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 161 pass: 161 fail: 0
Qemu test results:
	total: 446 pass: 446 fail: 0

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter
