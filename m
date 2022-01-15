Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A026D48F446
	for <lists+stable@lfdr.de>; Sat, 15 Jan 2022 03:07:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232049AbiAOCHU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 14 Jan 2022 21:07:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39896 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232004AbiAOCHT (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 14 Jan 2022 21:07:19 -0500
Received: from mail-io1-xd2c.google.com (mail-io1-xd2c.google.com [IPv6:2607:f8b0:4864:20::d2c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3FD5CC061574;
        Fri, 14 Jan 2022 18:07:19 -0800 (PST)
Received: by mail-io1-xd2c.google.com with SMTP id w9so14404485iol.13;
        Fri, 14 Jan 2022 18:07:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=4GEpUFBjPvlulBcurcPC2h8tQwUnd6luAjqdEJXuChQ=;
        b=YAjDwFHy3x8ccXbYKaDnkpgOp6L22FrrBuWrn4euADPpVQdzVPxPoJE3NFC98G9cU1
         w6f7TzptCCI7zTd9hl/BfPWRlstL4PpaVPpPZS7AQ7qHq1/PgxgZhXKR4KBYodozbNPS
         Q0rxQo+p1eHzOhy9IZ94a+neRYDR/h1aQ6O+/RXXWRS9XhPPDlItFNhFl3EFAU07+bpO
         4liKa4spA3f12qGX3/USNgjZCiQ915go6kJGe1mtbv8RTAWwHLDTXQED8UJ2aNLF+XXy
         hQzYZnuwpNqvK4JhCQGOf5cE1Wh8Sy1ymp1WsJb0EpAGeNCs0EXspSVIjDyUv3fPvYti
         mzcQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=4GEpUFBjPvlulBcurcPC2h8tQwUnd6luAjqdEJXuChQ=;
        b=hRAwJDLBCCS8s3rUY98ShYEVrC6KbAnVEPCmi62xIjCOVl8oBjlBGR4gi8XsUwpWXL
         FmhgUcSkgiN2rXHVm1Axz77yAhmzU8Ns2VtEUKZ3MXaEQUhNUTmNfFL3EF+el7c9ba1K
         RxpXzmkibTsbFFxTXlyIiI/UXjRt0gS7KcQm9rXGfC58+EE0RuzY95bX6aEeGoCxhCJy
         YIK6jW1LsyU0jVAgjUdEP+tTeL+iBQ4WhV6KwfN5q41xxCpmDzUNtPOeXDlsVhBbn8L/
         F8zK/GupVOgcBvR5FdQ/nlVb8Es+jHTsjuZ9lQ4/hWY53ByqREo5vZrcPraA+AiqclHJ
         ICaA==
X-Gm-Message-State: AOAM531uYe7wGsz1DiYpqBveVcdDBviMvoJI9JMgzhR7C96RV8Tpaj3f
        Km7kYbYseSw1qBHrgirhKI3ZfWtWpcJ6VPHcsCg=
X-Google-Smtp-Source: ABdhPJwkHXOrtF1q7ome0Kt3GmAnhYSCwLGOKbhP5gZ+IJFkQUAcPyzFCLmjCnZv8Esqw0xkZm3bumU9aLi4TxsDXDE=
X-Received: by 2002:a02:a18c:: with SMTP id n12mr5176734jah.196.1642212438612;
 Fri, 14 Jan 2022 18:07:18 -0800 (PST)
MIME-Version: 1.0
References: <20220114081544.849748488@linuxfoundation.org>
In-Reply-To: <20220114081544.849748488@linuxfoundation.org>
From:   Zan Aziz <zanaziz313@gmail.com>
Date:   Fri, 14 Jan 2022 19:07:08 -0700
Message-ID: <CAFU3qoatsvUwxaMmYKVHt-r5ytL3yqaXwKeCJ1CSZsbSJZj72g@mail.gmail.com>
Subject: Re: [PATCH 5.16 00/37] 5.16.1-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, f.fainelli@gmail.com, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Jan 14, 2022 at 11:11 AM Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 5.16.1 release.
> There are 37 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Sun, 16 Jan 2022 08:15:33 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.16.1-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.16.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

Hi Greg,

Compiled and booted on my test system Lenovo P50s: Intel Core i7
No emergency and critical messages in the dmesg

Tested-by: Zan Aziz <zanaziz313@gmail.com>

Thanks
-Zan
