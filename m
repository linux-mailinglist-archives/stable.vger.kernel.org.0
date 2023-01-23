Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 04931678A8D
	for <lists+stable@lfdr.de>; Mon, 23 Jan 2023 23:14:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233233AbjAWWOW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 23 Jan 2023 17:14:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58790 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233166AbjAWWOA (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 23 Jan 2023 17:14:00 -0500
Received: from mail-ej1-x634.google.com (mail-ej1-x634.google.com [IPv6:2a00:1450:4864:20::634])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BFDBC392B7
        for <stable@vger.kernel.org>; Mon, 23 Jan 2023 14:13:32 -0800 (PST)
Received: by mail-ej1-x634.google.com with SMTP id v6so34351768ejg.6
        for <stable@vger.kernel.org>; Mon, 23 Jan 2023 14:13:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=futuring-girl-com.20210112.gappssmtp.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=rYPZ+3YT/ARBog0kfKkyDDBPModET6xjd2wsv8OlAvE=;
        b=WXh+sD+kaChN4eOaCIw0TMZJr1IxW6MHJiCxhokTU3okHjoJ5FnMq9GXK2LwxnE1P8
         0VkGNKmYE02Rox1UIC4Sn5jEamziyDba/YMDXSqQ8q4wuI1/CEYFmdnOj1u03wzgJrNy
         q3jEpnFvUBMcwXcQGxNSJAV9ddhKRjxFy7FhJD95OQyQQSES8UzXDN6sqSm46k/9Q+3I
         96M7DxyCsUQjRm2vuYlvGmBJnyqggF8qZlHSQZgnO6c3yjAZGbvhqSjV0K7fVlcTPOTp
         7FLeAsGUtpXromrqzyz/rp/XxEXx5+7iXmTFTpoxCrYecyWt4nDIS2Tq1350S4gYbRzQ
         3VSw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=rYPZ+3YT/ARBog0kfKkyDDBPModET6xjd2wsv8OlAvE=;
        b=AccyjGKVSWnDKr7hIMQkOMWp3odGF3ONCKU49VmG8L1tntV1jvBHrP9QKqRiSN3iRM
         8nW4D/dJxNtZdlj2k8IQKDEKvOuXuVhMjoatc1PCh21KsIFEzQeafse9mFWny1K1vCdP
         /sDLFFQlz1XnNOR7+nkUhXLbSoUsFRAKh93UBzlqMR2XGPNuS7xMFsKk1ay1ZFVHLwEj
         kTwVM/ORSBaTNnpzoXaY9kcjSiHzktXYB5LSt3XxvMA0I8etCKGOBIQpqg9k58KXkWlu
         wd+jslMuN4GX2b/jbx/b1J43B3LOaKEtJHvQwyAHCBh1vj7EWUM0gSLpHcQzpWVRKAJO
         9iKQ==
X-Gm-Message-State: AFqh2koKG5qYiH9z5+v6NqAEo3jmFT1nPUOjWgtIddQUMcpNzzN6hGX4
        qPa6y6GUND/AsJ/kzKoxJt3ZJ2pnJgUUE/SrBd6a+maZkQadnwfMP24=
X-Google-Smtp-Source: AMrXdXs2HnS1FJKy54VHK8KGVBckkCk5VAFa3vB+laLe/GcGT2JQehojeIFRMupuvIsIkQctXz+BF7H8u3GtSEje2FY=
X-Received: by 2002:a17:906:151b:b0:7c1:6091:e7b with SMTP id
 b27-20020a170906151b00b007c160910e7bmr2615615ejd.513.1674512008619; Mon, 23
 Jan 2023 14:13:28 -0800 (PST)
MIME-Version: 1.0
References: <20230123094931.568794202@linuxfoundation.org>
In-Reply-To: <20230123094931.568794202@linuxfoundation.org>
From:   ogasawara takeshi <takeshi.ogasawara@futuring-girl.com>
Date:   Tue, 24 Jan 2023 07:13:17 +0900
Message-ID: <CAKL4bV5C27Su54FT7SSEDiCzH=2XB7JuPkZObD3HHsQB4NhxGA@mail.gmail.com>
Subject: Re: [PATCH 6.1 000/188] 6.1.8-rc2 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     stable@vger.kernel.org, patches@lists.linux.dev,
        linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, f.fainelli@gmail.com,
        sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Greg

On Mon, Jan 23, 2023 at 6:52 PM Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 6.1.8 release.
> There are 188 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Wed, 25 Jan 2023 09:48:53 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.1.8-rc2.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.1.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h
>

6.1.8-rc2 tested.

x86_64

build successfully completed.
boot successfully completed.
No dmesg regressions.

Lenovo ThinkPad X1 Nano Gen1(Intel i5-1130G7, arch linux)

Thanks

Tested-by: Takeshi Ogasawara <takeshi.ogasawara@futuring-girl.com>
