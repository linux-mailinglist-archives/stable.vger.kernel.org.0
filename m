Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 42BC24E80BC
	for <lists+stable@lfdr.de>; Sat, 26 Mar 2022 13:14:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232827AbiCZMQG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 26 Mar 2022 08:16:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52066 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232775AbiCZMQG (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 26 Mar 2022 08:16:06 -0400
Received: from mail-qv1-xf2f.google.com (mail-qv1-xf2f.google.com [IPv6:2607:f8b0:4864:20::f2f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6CBA2AD10C
        for <stable@vger.kernel.org>; Sat, 26 Mar 2022 05:14:30 -0700 (PDT)
Received: by mail-qv1-xf2f.google.com with SMTP id r1so8238482qvr.12
        for <stable@vger.kernel.org>; Sat, 26 Mar 2022 05:14:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rajagiritech-edu-in.20210112.gappssmtp.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=8CN3XDI/Kikx5MENEa/tbihTLWeVZI4RXfOrXnD280I=;
        b=KiSZ+CdSN2dRnbZ/oxPH29gWwQkkNXh4VpVpLOrBIZmj+VbzOMhvWihZ1geRYi7n1o
         D0ExO6FSxo2RObJnaQakExMvaIAQo8pP00wxnlHVdxub5TdzWmEbox+1rsNNXTvoEsFk
         z7ydih+8TVUQ/BqUOsG7iu99TPDk42/quY76laMk4qJ3GnJbVX/jQ1XVcwtngLP83BUs
         FFFW4knBnJjeuiPsdqvRUdgkupjgzZBiP/Ejvhh0ei32+eYz8fVu4L8LKUsxHM2In3AT
         nbOydBzbD8TbIShxrng4wrymYozyMiMCVr+Tmb00IhlFgz7wR+YZHRRDy6KFRzJ/UIgp
         vy2Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=8CN3XDI/Kikx5MENEa/tbihTLWeVZI4RXfOrXnD280I=;
        b=dsTGjXlRFwJVNzbOFiPnCfo1zG7lsfKO03KUdHmNAnUeBSkCjYJUq9W6q3Dty3DH4x
         HVqGI0c5zA4ooEhD52+ZQG5Wi5SgC9iVk2x+tYEaf0PxBP9bfqS8UZCa8ujCYurmxv5n
         EcahiLp1z93grOdrcNEIIzC4yuYy6mUmSdwWP0MOykEmTKUQXlhoGlFhF/cM//pRbMOF
         44jNTs8lSwKTaj3XuPhmMbxeLfPIiwMd2LCyBzQGa2IoEyAnj+SIr81dV3Mqq3kkVcMT
         7xSSg9LEFIDhLGVhurECSB4wrAo06KYS/1wKlcH4htRsj93tB5oR5Sd7gkzCCeD28k4o
         gXGQ==
X-Gm-Message-State: AOAM5326L6UoAGlftL/JBiWb6oK5HcEoTArLZjbTHXlazuUEOC1psS8A
        A3J0wb3HFaVIlCPzZ74Evka2KL7rQLfURuFcx8sCUg==
X-Google-Smtp-Source: ABdhPJw5WvCUsY8nlzbbVap8BaOMAl65D6VYoQCV765hRXnvIWaqXUrCBgvAMzyu4fCyxLw04caV9Yub3eyv1ag8QZo=
X-Received: by 2002:ad4:5bc1:0:b0:42c:37be:6ac3 with SMTP id
 t1-20020ad45bc1000000b0042c37be6ac3mr13189412qvt.18.1648296868938; Sat, 26
 Mar 2022 05:14:28 -0700 (PDT)
MIME-Version: 1.0
References: <20220325150420.046488912@linuxfoundation.org>
In-Reply-To: <20220325150420.046488912@linuxfoundation.org>
From:   Jeffrin Thalakkottoor <jeffrin@rajagiritech.edu.in>
Date:   Sat, 26 Mar 2022 08:13:52 -0400
Message-ID: <CAG=yYwk8w5N8EL0dTTCWcmsqOEjqF1LLF+VSOW3vT6k6kUTAOQ@mail.gmail.com>
Subject: Re: [PATCH 5.16 00/37] 5.16.18-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     lkml <linux-kernel@vger.kernel.org>, stable@vger.kernel.org,
        torvalds@linux-foundation.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Guenter Roeck <linux@roeck-us.net>,
        Shuah Khan <shuah@kernel.org>, patches@kernelci.org,
        lkft-triage@lists.linaro.org, Pavel Machek <pavel@denx.de>,
        jonathanh@nvidia.com, f.fainelli@gmail.com,
        sudipm.mukherjee@gmail.com, slade@sladewatkins.com
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Mar 25, 2022 at 11:30 AM Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 5.16.18 release.
> There are 37 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Sun, 27 Mar 2022 15:04:08 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.16.18-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.16.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h
hello,

Compiled and booted  5.16.18-rc1+ on ...
Processor Information
    Socket Designation: FM2
    Type: Central Processor
    Family: A-Series
    Manufacturer: AuthenticAMD
    ID: 31 0F 61 00 FF FB 8B 17
    Signature: Family 21, Model 19, Stepping 1

NO new regression and issue from dmesg

Tested-by: Jeffrin Jose T <jeffrin@rajagiritech.edu.in>

-- 
software engineer
rajagiri school of engineering and technology
