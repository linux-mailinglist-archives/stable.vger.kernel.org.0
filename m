Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9FEA9689AE1
	for <lists+stable@lfdr.de>; Fri,  3 Feb 2023 15:02:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233504AbjBCOCP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 3 Feb 2023 09:02:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40352 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232054AbjBCOBu (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 3 Feb 2023 09:01:50 -0500
Received: from mail-ej1-x62c.google.com (mail-ej1-x62c.google.com [IPv6:2a00:1450:4864:20::62c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B54ADAC203
        for <stable@vger.kernel.org>; Fri,  3 Feb 2023 05:59:17 -0800 (PST)
Received: by mail-ej1-x62c.google.com with SMTP id p26so15446984ejx.13
        for <stable@vger.kernel.org>; Fri, 03 Feb 2023 05:59:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=futuring-girl-com.20210112.gappssmtp.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=pCUGL8VPixgFHZJLqdb1k6pVMMrRD13TGA08RWk+l2Y=;
        b=vrHrIoSZwFiYyiaGc3dS5QJxFJej28syqCpWncYrNGrbz0vi/zIiXmS4Kom8vck4CI
         yqNepijzzfhWSqWDOj+XJRmVxvvUQERcHVGRjWyfhxbbS0HUQfbax0MQQN/XgYDdymKV
         0QpPOmD71yg5s3NZa64KjhwS34e/ApmwvFSMLE+hmeKV/uKmjNwRqAO+2mln0r23UJpo
         1BbxYvkdCkuiM3LjhxW9Atj5WMh6jri684Fweg1YoZ+upBKs9l3lNfSAFPoJmebe3KnM
         e0vzFOHykfF327dU9jCUroD/licQxP71m4CpiN1NrWmEYY5boyWzw1CHElzGN0/9v6pu
         NYWg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=pCUGL8VPixgFHZJLqdb1k6pVMMrRD13TGA08RWk+l2Y=;
        b=vyJ7SqpQW0w28SYiKAYT9jufDzsknob7H7qfbnfG6TewmBuSEmLmw21qICN4eZqg6E
         b/O8l6FjjQtLVHX2/GawlMcZmNYhp5dkmO8Kg02lRuyns/Yk+pfMReC0lzK+mrITtxUf
         n62XNSN2yzdH973mQoG1C4sxCKhUPwiry9NCAxV7dN/Hx++sQ68ynyCFCGbNBgmDvHgP
         2bv0EBfmgi7vyOyOD4sxLFMO+j31nrzaquGNsTfB85lHRN+y4mjD7LZmrQv8qD3svQKK
         MmOy+rxxqZBvsoNSeyMm77bNoWMhWdFZihTXSsmqYs/VJzjNr2T3W/7KGgjvLKsbSMo3
         LI8w==
X-Gm-Message-State: AO0yUKXBDDu4yWHN8lr7jypA+Ct3rcQi7Pc5qHvx9IByavnyiefjtxtk
        abXG3IeE140Wd596EpOZVsFupRt2//OlYi7nCTCNyg==
X-Google-Smtp-Source: AK7set/HKO5v6FkHVvwoDYgd8Or22xvQOYV8kCOWchXa4DTk6K6JpVwZu/1GF39IGoqCWYV3PX37bIrqVnVrHpEPo+A=
X-Received: by 2002:a17:906:650:b0:88a:bec0:11df with SMTP id
 t16-20020a170906065000b0088abec011dfmr3308020ejb.178.1675432700555; Fri, 03
 Feb 2023 05:58:20 -0800 (PST)
MIME-Version: 1.0
References: <20230203101009.946745030@linuxfoundation.org>
In-Reply-To: <20230203101009.946745030@linuxfoundation.org>
From:   ogasawara takeshi <takeshi.ogasawara@futuring-girl.com>
Date:   Fri, 3 Feb 2023 22:58:09 +0900
Message-ID: <CAKL4bV5HVujYHpAjYQGZG42imRnQpOsHm15hOiwy-E6Qe+qHQg@mail.gmail.com>
Subject: Re: [PATCH 6.1 00/28] 6.1.10-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     stable@vger.kernel.org, patches@lists.linux.dev,
        linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, f.fainelli@gmail.com,
        sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Greg

On Fri, Feb 3, 2023 at 7:26 PM Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 6.1.10 release.
> There are 28 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Sun, 05 Feb 2023 10:09:58 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.1.10-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.1.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h
>

6.1.10-rc1 tested.

x86_64

Build successfully completed.
Boot successfully completed.
No dmesg regressions.
Video output normal.
Sound output normal.

Lenovo ThinkPad X1 Nano Gen1(Intel i5-1130G7, arch linux)

Thanks

Tested-by: Takeshi Ogasawara <takeshi.ogasawara@futuring-girl.com>
