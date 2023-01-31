Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 39E6F6822A6
	for <lists+stable@lfdr.de>; Tue, 31 Jan 2023 04:13:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230394AbjAaDNe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 30 Jan 2023 22:13:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42216 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230502AbjAaDNH (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 30 Jan 2023 22:13:07 -0500
Received: from mail-oa1-x36.google.com (mail-oa1-x36.google.com [IPv6:2001:4860:4864:20::36])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 473A839BAC;
        Mon, 30 Jan 2023 19:12:35 -0800 (PST)
Received: by mail-oa1-x36.google.com with SMTP id 586e51a60fabf-16346330067so17819571fac.3;
        Mon, 30 Jan 2023 19:12:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=L/yFocoAYOTu5Uft/lZVZXiYiDwDL6YcXu2NwPqre3s=;
        b=aDSBNEUP8tbrXHIFzNhcEdGzUNi7f/asW71tXpYn5t0/NNx3nJ3CQuZhUojBGkX4O8
         rpvhSo8BJh4iFMcr/t9XbpvDUZeZiSmUR5npEYVvTrNLkwuENm7ttH4fpiE7dfJdsstV
         HAjaDj+JUUU4h14EbMRwynY6vTR/kCDwpkhPyE19UulRk/ioti9jbLJro3nm6lh1myXe
         yQb7jWeqDaWABwGjJmALirR61gLkVPk21/Aj0KYYTb+aufd+Yv9P98DlOLd9ll7/+NUX
         +d7NZX5lSc/7AkQpIZQS1ZJnRkm55b2dTJJ+oCGkvTs0mwYz5D1YSxZqULRoDAGb025O
         Sw8g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=L/yFocoAYOTu5Uft/lZVZXiYiDwDL6YcXu2NwPqre3s=;
        b=4EGVmpnKPRYcCMzv+1NG4gMAJuUC8I/b6j7HyhgVK+TVkjX6WBMNImwlPWUOSUF5Jg
         2IqmrBsWXlCJtQP1ultaB0UIKxABHMdfGUwLv/2ROhTXHk1q6XuJCmKx1sQDKbf2drPx
         Nxe8WejB8Bhsd4B7MWp3R3oa7GuyA4sKclTcx/jpCmak3s5ovgEkVj91MWxIQhAowRhR
         Du2zlHOCU6tvE2Jj+i3UPBzpjRuW97SgFC4RhhmqHrPOEbhAr5DDR5DDTyaFj6YGQnWI
         U/KoKAHlNlld7x+gH2iBPVaW8UuBL+A6RdsDV1aQ+wlPskFGLhRA0JsKdewJLo8xPIUq
         0lbg==
X-Gm-Message-State: AO0yUKVo2Dm2YL15EUt21SIjHdJIG1YHLnX4bl8+fvfROwtgArkSqz2Z
        1mzCbDqsT1+CTEHb499Cs/U=
X-Google-Smtp-Source: AK7set+2/9rBzTouYtt3GOr3dKVr0B8Kqi90JNM+W2VJ9815/BgBt/8XlGzdAWBlvU5GsCHqP0iohw==
X-Received: by 2002:a05:6871:8aa:b0:163:4a41:ea94 with SMTP id r42-20020a05687108aa00b001634a41ea94mr10380304oaq.49.1675134751027;
        Mon, 30 Jan 2023 19:12:31 -0800 (PST)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id f4-20020a9d5f04000000b00684bcc9e204sm6074907oti.78.2023.01.30.19.12.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 30 Jan 2023 19:12:30 -0800 (PST)
Sender: Guenter Roeck <groeck7@gmail.com>
Date:   Mon, 30 Jan 2023 19:12:29 -0800
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     stable@vger.kernel.org, patches@lists.linux.dev,
        linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        srw@sladewatkins.net, rwarsow@gmx.de
Subject: Re: [PATCH 6.1 000/313] 6.1.9-rc2 review
Message-ID: <20230131031229.GC835036@roeck-us.net>
References: <20230130181611.883327545@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230130181611.883327545@linuxfoundation.org>
X-Spam-Status: No, score=-1.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Jan 30, 2023 at 07:24:47PM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.1.9 release.
> There are 313 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 01 Feb 2023 18:15:14 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 155 pass: 155 fail: 0
Qemu test results:
	total: 503 pass: 503 fail: 0

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter
