Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 194F96C3DC8
	for <lists+stable@lfdr.de>; Tue, 21 Mar 2023 23:37:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229835AbjCUWhg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 21 Mar 2023 18:37:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39072 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229739AbjCUWhf (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 21 Mar 2023 18:37:35 -0400
Received: from mail-ed1-x533.google.com (mail-ed1-x533.google.com [IPv6:2a00:1450:4864:20::533])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A887C570B5
        for <stable@vger.kernel.org>; Tue, 21 Mar 2023 15:37:33 -0700 (PDT)
Received: by mail-ed1-x533.google.com with SMTP id b20so32764124edd.1
        for <stable@vger.kernel.org>; Tue, 21 Mar 2023 15:37:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=futuring-girl-com.20210112.gappssmtp.com; s=20210112; t=1679438252;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ocTha7DGqOt2lsARrHmD/l31irURcj6Ur3gV5sNzmus=;
        b=8W5ZDfBkuOZCUXNvnGLVSBsEQVaP9mwB3g2PUxnEPf6yzSzbB5PNaHKE+lAXlCoR4t
         NVSwSmzHiBmQrbjCbtZlZg3mPoQy4Qgcevm4JCncjnhdX+eZhZ2K2WzOzK5aJY0z/dZE
         jVZBUfdZZ37YVXLUmiqsTNpiQ7rtYhRUivGBmp6jKr5AZd/uV2/DE7SDQ1LU82PH9GWC
         L5TjMPIbuzvikaiX3Eh7jz0u5RtWLYh6Yb93YYJUJZbVXW5zHEh92rgwD0K3GIL3jVGw
         UOSVmEM1V231OEywVHVZ8xCQk3KxB8BgtpzTtYtx9OJ53wmJ0Pk3wut30FZ9kxxcO5Wf
         5qJQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679438252;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ocTha7DGqOt2lsARrHmD/l31irURcj6Ur3gV5sNzmus=;
        b=3735wdMzxEaNrpBP1gIP08uHS7RF1PknpB5VYtp0aPiPBFzpC8V3dmNDwts32qeWUX
         LvaqPV/2WveWpU6zDGIYGi3xXOnjkfBZnK0zVEocXSNIfW+Q83N0KXlzP2wMuAcHwJ/9
         orOuthuwqgi+PE6qfTck9aSUWCVon6TCPbbIUBU4Kd9KMABT2LCSijkKqZ1f+WCzux+f
         m2YNerJsQUarCVuUZ9obmLx3zxmu07r4jSFDmtWkIlyOFCdEg0g3THkwdHl82F+tDqPj
         MB6tyAW/jliFqBf2tX+TCcNNFjtNDbPN4Qpr5FxCnqJjimP1c7IcYcs7VpXVZMpx/ddR
         coIA==
X-Gm-Message-State: AO0yUKXzY9ptMgDV4BhpS8p55K+ay8s9A1DP8qVD6PcWi3emi9qEgSWJ
        pZFz5h/LuprcToLo+nfCldpqSfZo0CYY0jIrd/RqVg==
X-Google-Smtp-Source: AK7set9vpRzYsNlI+JFaLX3iFRSqQZhT0xDtyIHnp7WFNAx5HG+zmZVpj8c8/6eMuUUoigdFRDyCEqvTa+T2tX7Pxqw=
X-Received: by 2002:a17:906:bccd:b0:8b1:28f6:8ab3 with SMTP id
 lw13-20020a170906bccd00b008b128f68ab3mr2299216ejb.15.1679438252083; Tue, 21
 Mar 2023 15:37:32 -0700 (PDT)
MIME-Version: 1.0
References: <20230321180747.474321236@linuxfoundation.org>
In-Reply-To: <20230321180747.474321236@linuxfoundation.org>
From:   ogasawara takeshi <takeshi.ogasawara@futuring-girl.com>
Date:   Wed, 22 Mar 2023 07:37:21 +0900
Message-ID: <CAKL4bV6syYjNPkcLN0c2BfkJan3ZETwA6BfR_cS8okOYQ84LKA@mail.gmail.com>
Subject: Re: [PATCH 6.1 000/199] 6.1.21-rc3 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     stable@vger.kernel.org, patches@lists.linux.dev,
        linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, f.fainelli@gmail.com,
        sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=0.0 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Greg

On Wed, Mar 22, 2023 at 3:08=E2=80=AFAM Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 6.1.21 release.
> There are 199 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Thu, 23 Mar 2023 18:07:05 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-=
6.1.21-rc3.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable=
-rc.git linux-6.1.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h
>

6.1.21-rc3 tested.

x86_64

Build successfully completed.
Boot successfully completed.
No dmesg regressions.
Video output normal.
Sound output normal.

Lenovo ThinkPad X1 Carbon Gen10(Intel i7-1260P, arch linux)

Thanks

Tested-by: Takeshi Ogasawara <takeshi.ogasawara@futuring-girl.com>
