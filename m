Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 81A8D678E88
	for <lists+stable@lfdr.de>; Tue, 24 Jan 2023 03:49:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231942AbjAXCtn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 23 Jan 2023 21:49:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35160 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232579AbjAXCtm (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 23 Jan 2023 21:49:42 -0500
Received: from mail-oo1-xc2b.google.com (mail-oo1-xc2b.google.com [IPv6:2607:f8b0:4864:20::c2b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C9E2312871;
        Mon, 23 Jan 2023 18:49:29 -0800 (PST)
Received: by mail-oo1-xc2b.google.com with SMTP id c145-20020a4a4f97000000b004f505540a20so2445065oob.1;
        Mon, 23 Jan 2023 18:49:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=kZQ9vrog7jwNZgu5+COhRurOZBjvasf11OGREJXcEyo=;
        b=nXxI9dcxw4FCLr6MFNVsEbPm6aMw9maNM3UTrhikgJbE8snI5b/PV9RbiNWnqiTorx
         WhsNUl7sOR0eSI0BhM3/Pz41FdlYdlXcfPDuIeo19/mULpRQ5nZ53Nl38D8dMBlwdd0o
         MG5ekJIHE5DiKOOyNhzrRCM3tq9K0KGm5prFxh2G631EMp5v3zL3V2Zs7LBtnXek+PMU
         qmTAjhMNB/CzNFzbo/6enO35xUeyrJStGfnDpZFV8xft8DDs3iC3aNwSxte7wEEI6D4a
         OffVuvyUkV7nukWLHytffshM9/37TOtYJ4XOkwcI+KPhgZQD5sar4c9yROJZ/TRyHP0s
         sfRA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=kZQ9vrog7jwNZgu5+COhRurOZBjvasf11OGREJXcEyo=;
        b=xte8jkWnSVP5Ujq4dJR4bb5tLVqYILFoRkp7E2W82xffutjnRaalrm2O7+xFSdP60U
         rvNXHP0/hC32mx+1WnsWvBqLuQnNLOi2zIdXyXu3dFqhs4AVOh6BBP76A86X3iH66wy4
         2GDJORSplBkMecLywExmrqKW3qDqsQ1XJpdLE7tiIFE1KU3WNpHM3K7sovZnX6qt8P+A
         uoAQ4WUsEXYvZzn7FmKom5bn0IeOeUL6jWVjT6JJsv5gq22lmFNp3RC3loHdedmDkuDJ
         gZ/rOBdhDaC4sBaInZ3d4IuuRv7YvnLjY0MjqrOQX2iCwgNyq8E+hah8pvaxjKIMG7uO
         8yJQ==
X-Gm-Message-State: AFqh2kqur6XqeLnrXYzOVhHuq3uKowdnFL932bYhh+bslIKy7ckheV/n
        +SE20zMRWL3lIrXmtFxlj04=
X-Google-Smtp-Source: AMrXdXtjSXuytDtnGpEG907cWjqqFD6TqwgBcWQLdNpexxhGWG5R08Si91mT/uz3nUEwFAS4282gTg==
X-Received: by 2002:a4a:1584:0:b0:4f2:88ea:54dc with SMTP id 126-20020a4a1584000000b004f288ea54dcmr18717473oon.7.1674528569167;
        Mon, 23 Jan 2023 18:49:29 -0800 (PST)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id v25-20020a4ade99000000b0049ee88e86f9sm325889oou.10.2023.01.23.18.49.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 23 Jan 2023 18:49:28 -0800 (PST)
Sender: Guenter Roeck <groeck7@gmail.com>
Date:   Mon, 23 Jan 2023 18:49:27 -0800
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     stable@vger.kernel.org, patches@lists.linux.dev,
        linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        srw@sladewatkins.net, rwarsow@gmx.de
Subject: Re: [PATCH 5.15 000/117] 5.15.90-rc2 review
Message-ID: <20230124024927.GE1495310@roeck-us.net>
References: <20230123094918.977276664@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230123094918.977276664@linuxfoundation.org>
X-Spam-Status: No, score=-1.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Jan 23, 2023 at 10:52:31AM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.15.90 release.
> There are 117 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 25 Jan 2023 09:48:53 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 160 pass: 160 fail: 0
Qemu test results:
	total: 492 pass: 492 fail: 0

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter
