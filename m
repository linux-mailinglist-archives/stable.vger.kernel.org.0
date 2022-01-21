Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 506744961AF
	for <lists+stable@lfdr.de>; Fri, 21 Jan 2022 16:03:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1381448AbiAUPDV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 21 Jan 2022 10:03:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52322 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238192AbiAUPDU (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 21 Jan 2022 10:03:20 -0500
Received: from mail-yb1-xb31.google.com (mail-yb1-xb31.google.com [IPv6:2607:f8b0:4864:20::b31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 72CB6C06173B;
        Fri, 21 Jan 2022 07:03:20 -0800 (PST)
Received: by mail-yb1-xb31.google.com with SMTP id v186so28455577ybg.1;
        Fri, 21 Jan 2022 07:03:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Ygh2WtsM0rqeWC47MeOF6Vq/PrWpbCmbpsiWibezTCo=;
        b=nQDctmIve4M2xoQKdwtBRxIQWIjmXDphQ9F/MUW6yfNtcSNgi7GgErh5y+I+SgE/tJ
         dx/yBZFqiPQ/aDHH0LkUoexAwGhhpdckVq/M1iApdsPV40XoraKJ9FtIP1wmhBt+1FUP
         2fTqYZbLWywTMnPh6EXbx4cyseJyu0FnFlp0YMVCU7VW4ZkQ+YOuIcgJF3KRi6/oVeNX
         AjaheosjIvYOT/yIDmuAFG98kfgu3enRYnj0rglYfhS4bEnV5eLpY31kgWRXYcjQSJZg
         SsXUk1Kn5Xc+pE6X5uJkp2MqZg7hTZKtwPlym2NOHOZKWkdCXo0l/rIhjZhZ/CKOQ8aN
         SAQg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Ygh2WtsM0rqeWC47MeOF6Vq/PrWpbCmbpsiWibezTCo=;
        b=Voq8UCTMSEiQ+G5cxAy5/NF9AYUjO/e0YrFosQzu5g+ThnVyAUWfDEzG7FOtte2mik
         mzDWw8Q/Bn+X3Fdfcdm34i0p2jFLDJx/c5FIe4fXPnimeIk/Nm69XswcH8EFkWxz0ajH
         QoeHdbeEKG8HEVnCkCpuAkAzXPNEiQ6qwqWGq/VHdBcJl+wk6TPL9sk4BujkLC4d8MW8
         LNauO/2a8nxjPf0rYQLZamHvxxpEIbxzv14tLzIdqsz8YsfB9sweUDT6QpQu+cJDmmHM
         0GNeml+YCmnSBwYOZk7U3db8jNIVP6ssiRt3Vr/8ntlnOuoWxA1zf1V6BfIJ3GTXUbT1
         +fDQ==
X-Gm-Message-State: AOAM531HFb6soNybiKLgpcHOTm2AT8U2ky9u98eg3gqkIxMszK0odAuP
        i23fwVQDAvs5wUUt4q/25CVwRor81HGh3w0WcmA=
X-Google-Smtp-Source: ABdhPJxpqMWXzaGVe28BBN9Pl//sjXvCfDKa3Bf8cGvQ0T1Wrvd+ljiR1tDlwL/BeIu3U7xkLHNzPq+j9kNE+pgkNv8=
X-Received: by 2002:a5b:312:: with SMTP id j18mr7333000ybp.640.1642777399510;
 Fri, 21 Jan 2022 07:03:19 -0800 (PST)
MIME-Version: 1.0
References: <20220118160451.233828401@linuxfoundation.org>
In-Reply-To: <20220118160451.233828401@linuxfoundation.org>
From:   Sudip Mukherjee <sudipm.mukherjee@gmail.com>
Date:   Fri, 21 Jan 2022 15:02:43 +0000
Message-ID: <CADVatmPaK616c8FW_iGjzMU9Cd81BndvGj+Zb-1dA7a6eCPw3Q@mail.gmail.com>
Subject: Re: [PATCH 5.10 00/23] 5.10.93-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Guenter Roeck <linux@roeck-us.net>,
        Shuah Khan <shuah@kernel.org>, patches@kernelci.org,
        lkft-triage@lists.linaro.org, Pavel Machek <pavel@denx.de>,
        Jonathan Hunter <jonathanh@nvidia.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Stable <stable@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Greg,

On Thu, Jan 20, 2022 at 3:05 PM Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 5.10.93 release.
> There are 23 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Thu, 20 Jan 2022 16:04:42 +0000.
> Anything received after that time might be too late.

gmail says you have sent this mail on "Jan 20, 2022 at 3:05 PM" but
https://lore.kernel.org/stable/20220118160451.233828401@linuxfoundation.org/
says you have sent it on "18 Jan 2022 17:05:40". :(
Is it possible to add my email on the Cc list for the stable review
mails please..

-- 
Regards
Sudip
