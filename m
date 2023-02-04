Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9D12768A7A9
	for <lists+stable@lfdr.de>; Sat,  4 Feb 2023 02:50:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232670AbjBDBuf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 3 Feb 2023 20:50:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57092 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233339AbjBDBud (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 3 Feb 2023 20:50:33 -0500
Received: from mail-oi1-x229.google.com (mail-oi1-x229.google.com [IPv6:2607:f8b0:4864:20::229])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A0A50A0E89;
        Fri,  3 Feb 2023 17:50:30 -0800 (PST)
Received: by mail-oi1-x229.google.com with SMTP id j21so5704504oie.4;
        Fri, 03 Feb 2023 17:50:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=zhmFp+m5BOhDIQMjpmUyZASvbs/UBISjLx6cXPlayfE=;
        b=alQ6IDk9qPd/josJoGtkQ6v+hNK+qwfRZUGliivEUjMd99zWZqtl1prBLfKvz4qNAU
         zjLsJ2DFWKmp2hu4npnW01XIKa+l/FgpZl/s1NRkpzZXstB02Y7cXXjwl72Hg/COzWuH
         hswUpbd6ozTFEsg+dZy9q7tqhc8LT7RqETkMk+fhI5aqh5EjKytuo8QJu9oeL6RxktU4
         7DzLvtOZUZDsRMULYcp4T6I9aNBq13tZen/OCefZ+SgrWYIz1Ar4T5vmDPsqgHkvX2sE
         iNLYYLc0q6LnED3bQmN+0NQSZ+8uf45rh25s+R8FdUul4tXbJTav+QI6h24I5EpGEEYw
         964w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=zhmFp+m5BOhDIQMjpmUyZASvbs/UBISjLx6cXPlayfE=;
        b=Lr5k6t0EW3LfRRVy427wxKXSJB4kDEcBPwbzSw2Uo5OE2U+kaptdbD04wFb1D0mPHn
         UywGTioqZak28iqkAHx6DcLD+imq+DMdZCnS/PHSTBjNqxVI7GTe+BGtgwYXYu07DzWb
         UJQoEiCfVigsCR1Az89Vo3s40V34OrlDG+hfueMUZ5J0wTMKTUccDPZGHsd8dDWa74Sn
         J8RtBjQG7do5HZnpiLHnqmKeD82TPd29oAorNpIlYRDaLcyy4ErQJMPP+4CW0HhtgtV1
         c5D3mpj8438xPZvEV2tzbu4iXzBDFmCp2u8uJTMnvlfQATc/3Z0Xk13DkOnfWniaxNUR
         VlSw==
X-Gm-Message-State: AO0yUKUBOI2KylOyERldrqD2I0+QTyw8oMVGrn0ijNHQRxHbfQ+xa6og
        ldwqzRt7kR9VDhu1AjhLAhzpHKOa0VM=
X-Google-Smtp-Source: AK7set/k4nC5XQdhGxsTmJ7b1NIMNHs8P85/gu/4kNtvcybGlhUxA1rAF8VQOE7DIOREU1nL/yToMg==
X-Received: by 2002:aca:4586:0:b0:363:a5fd:9cd5 with SMTP id s128-20020aca4586000000b00363a5fd9cd5mr4472301oia.3.1675475429993;
        Fri, 03 Feb 2023 17:50:29 -0800 (PST)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id d2-20020a056830138200b0068bd3001922sm1831736otq.45.2023.02.03.17.50.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 03 Feb 2023 17:50:29 -0800 (PST)
Sender: Guenter Roeck <groeck7@gmail.com>
Date:   Fri, 3 Feb 2023 17:50:28 -0800
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     stable@vger.kernel.org, patches@lists.linux.dev,
        linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        srw@sladewatkins.net, rwarsow@gmx.de
Subject: Re: [PATCH 5.10 0/9] 5.10.167-rc1 review
Message-ID: <20230204015028.GD3089769@roeck-us.net>
References: <20230203101006.422534094@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230203101006.422534094@linuxfoundation.org>
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

On Fri, Feb 03, 2023 at 11:13:29AM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.10.167 release.
> There are 9 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sun, 05 Feb 2023 10:09:58 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 162 pass: 162 fail: 0
Qemu test results:
	total: 478 pass: 478 fail: 0

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter
