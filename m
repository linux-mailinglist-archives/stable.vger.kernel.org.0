Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 684F367102E
	for <lists+stable@lfdr.de>; Wed, 18 Jan 2023 02:39:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229808AbjARBjP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 17 Jan 2023 20:39:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55024 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229780AbjARBjN (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 17 Jan 2023 20:39:13 -0500
Received: from mail-ot1-x331.google.com (mail-ot1-x331.google.com [IPv6:2607:f8b0:4864:20::331])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6B0F351C5E;
        Tue, 17 Jan 2023 17:39:12 -0800 (PST)
Received: by mail-ot1-x331.google.com with SMTP id r2-20020a9d7cc2000000b006718a7f7fbaso18902583otn.2;
        Tue, 17 Jan 2023 17:39:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=WjOCE/6QEfK5v5inKKv9A43fPEd/1+NGW5Rg3mfqGHk=;
        b=LVHWbf3VkVq+3DVCVKvwxoa2Yd0ZxD7jd+gso77QzWkzthWv2b4brHEbcX3goledLn
         66yvo/GYW0xJQ5Sevzs+dyx0o7WPPXJfGLNcq23zTH43bY6UR9wP+saoFsLY4kYfLwZH
         3FS5vbW99oHRBM3ybPHFd/JmbBARFHc6ZFRyqjEZEUzv/i2VDlyjra0FobbZAPNsJO1G
         gGCvWlGGlH0kY86IjHhx9550fTfeSuobJrfNuEvPc90j+4l86IKTAqOcWCt1He80zTnF
         l1dHMZ/AjVBPvPQzm8k2p0S+4jb79J720MbZktjpNqf7na8iSX6uHcJXTdI5RiblRqUD
         iLVA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=WjOCE/6QEfK5v5inKKv9A43fPEd/1+NGW5Rg3mfqGHk=;
        b=gIyi//dnGabZkWfOpXFWAcpw5CLUyZqov3DtKzBReXyXV5MuouZTiFHQbWkpdX3ik9
         DEryITyyIgi+rXf+OveWw1/MBPvbZbVbfvEbL0ejRnrciJkpxkNTZ0wpg4GJNiS+loA3
         koXH7O28Sr0ZNHh1VOjg2V+4KreACHvRok7K1Qs6B5XABNrR0kTSiN7Cim8EjgDNuJ6s
         iIr2VIhNgD6ukrG9RjpB7zrqo8rtWkwJo7A/Js93yfoU7lkMOEimnbPjpEhbJWBROVwx
         DgkoHPDWbm9H2BwYxjYx5xXbiYXQQ321FVIPpoCnvqMBOTQdc9wxYBYTTRIqnmOSTNxQ
         BNFw==
X-Gm-Message-State: AFqh2kp+oz2ocTViktfPwuYke7C1HeUcTwSf5As8llHiHpLuJY/udemX
        ynEh+XESBjPKrRPhR+ETz1k=
X-Google-Smtp-Source: AMrXdXuxj89SNu2eoHKAcXG/K66C+TSY83q0QMK0/f/11cH0feaiQRdCiDQ9Oz4+tuYusyjNJRQ5rw==
X-Received: by 2002:a05:6830:6782:b0:684:e78b:348c with SMTP id cs2-20020a056830678200b00684e78b348cmr5630503otb.25.1674005951758;
        Tue, 17 Jan 2023 17:39:11 -0800 (PST)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id r15-20020a056830448f00b006864c8043e0sm1618465otv.61.2023.01.17.17.39.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 17 Jan 2023 17:39:11 -0800 (PST)
Sender: Guenter Roeck <groeck7@gmail.com>
Date:   Tue, 17 Jan 2023 17:39:10 -0800
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     stable@vger.kernel.org, patches@lists.linux.dev,
        linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        srw@sladewatkins.net, rwarsow@gmx.de
Subject: Re: [PATCH 5.10 00/64] 5.10.164-rc2 review
Message-ID: <20230118013910.GD1727121@roeck-us.net>
References: <20230117124526.766388541@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230117124526.766388541@linuxfoundation.org>
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

On Tue, Jan 17, 2023 at 01:48:01PM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.10.164 release.
> There are 64 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 19 Jan 2023 12:45:11 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 162 pass: 162 fail: 0
Qemu test results:
	total: 477 pass: 477 fail: 0

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter
