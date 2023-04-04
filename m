Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1326B6D6ECC
	for <lists+stable@lfdr.de>; Tue,  4 Apr 2023 23:20:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232313AbjDDVU1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 4 Apr 2023 17:20:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59576 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229743AbjDDVU0 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 4 Apr 2023 17:20:26 -0400
Received: from mail-ot1-x32f.google.com (mail-ot1-x32f.google.com [IPv6:2607:f8b0:4864:20::32f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E727312F;
        Tue,  4 Apr 2023 14:20:20 -0700 (PDT)
Received: by mail-ot1-x32f.google.com with SMTP id f4-20020a9d0384000000b0069fab3f4cafso18076122otf.9;
        Tue, 04 Apr 2023 14:20:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1680643220;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=tfxpdbuFOonJn9jZwoNDRK7Oo7M2eMNyBRNxPTgb3pE=;
        b=nlZF5MckWdcsD3yTrtDoEG+amux9+C4Z40Fj6nowzZ4zknMCyIY0Xo/bmGo6m2A0cq
         LrJV7s6LuFw1Lopflme4JwaNjCNFa8Vf/mSDR4WU2J1BiOcoaq5/cq6sJVWgRRMk4Enw
         e241lrMINZA6loLBVFL98cqIkzYNMa0Bpxuf9MzVSJJ8LYmbDcFnE3PqHMoVEz1yNE3R
         qqtyuUEbvV62jdSdBQ/dwIBG4WgG/o3m8whi+O9iOXFjORd7e3kt8kMpgJHDGeZoIV7e
         un8MtxtrUjF8mPfbiIl6SvmQuv4iuXz9cqXn/U1ibtR5OI6XCxTHSx3oD1o8Xc810YJQ
         CcQQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680643220;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=tfxpdbuFOonJn9jZwoNDRK7Oo7M2eMNyBRNxPTgb3pE=;
        b=xvXN/H2GQuUqIzXxdHO1RY+Yl4N+3KmUYeIF+nFWU0spcGIXze19UACiVEyFM5Lb8C
         TNnZSbQFnVKQNCyf+jcO5f3PEmcAzzDGdTd5V8h4eNasZazRjs3Sbeq3jvG6KwEGqqP4
         NUtEfmtqTAKzvTfvYX+laIHxTdFaaSkHl8clrpEy+NXR+N1fMb1RI+c4wh7f7LTvy8FD
         rQvNtHq31cs1Ge5cXBGFDOOOc+7P66lvW3bkQIrwOjqlL1yR+dvsE2GR7u59dBtqz7JA
         8mpad/JhwxDDJSBt7Q1ryYJrjlEBdt81vxq929kGitUBIxtDj8UqBrg9gDhcAbVRfEcA
         mamQ==
X-Gm-Message-State: AAQBX9ctrsIH/B92TQYB9TUs3vGAqqI/1DNxT8EXcxg5nhDWcD2K/nN5
        ZVgE4RrF4zHszglpOZkLiDM=
X-Google-Smtp-Source: AKy350aJI/6dxLYLWAoc9XvDP+IWUBXAqrb+bB5yni1lUMeuQglziJ8ffRrIZuoR4ZTcFi+pjIfVXA==
X-Received: by 2002:a05:6830:a:b0:69c:6b3:c7af with SMTP id c10-20020a056830000a00b0069c06b3c7afmr1822503otp.16.1680643220179;
        Tue, 04 Apr 2023 14:20:20 -0700 (PDT)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id m15-20020a9d6acf000000b0069f0794861asm5923942otq.63.2023.04.04.14.20.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 04 Apr 2023 14:20:19 -0700 (PDT)
Sender: Guenter Roeck <groeck7@gmail.com>
Date:   Tue, 4 Apr 2023 14:20:18 -0700
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     stable@vger.kernel.org, patches@lists.linux.dev,
        linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        srw@sladewatkins.net, rwarsow@gmx.de
Subject: Re: [PATCH 4.14 00/66] 4.14.312-rc1 review
Message-ID: <d2c1d38a-03b1-47ca-8b25-6a808d0f2e55@roeck-us.net>
References: <20230403140351.636471867@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230403140351.636471867@linuxfoundation.org>
X-Spam-Status: No, score=0.7 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,FREEMAIL_FORGED_FROMDOMAIN,
        FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Apr 03, 2023 at 04:08:08PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.14.312 release.
> There are 66 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 05 Apr 2023 14:03:18 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 168 pass: 168 fail: 0
Qemu test results:
	total: 430 pass: 430 fail: 0

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter
