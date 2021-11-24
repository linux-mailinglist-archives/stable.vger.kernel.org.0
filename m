Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3F13645CEC4
	for <lists+stable@lfdr.de>; Wed, 24 Nov 2021 22:10:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244478AbhKXVNl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Nov 2021 16:13:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56356 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234102AbhKXVNk (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 24 Nov 2021 16:13:40 -0500
Received: from mail-qk1-x735.google.com (mail-qk1-x735.google.com [IPv6:2607:f8b0:4864:20::735])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0DD42C061574;
        Wed, 24 Nov 2021 13:10:30 -0800 (PST)
Received: by mail-qk1-x735.google.com with SMTP id g28so4993631qkk.9;
        Wed, 24 Nov 2021 13:10:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=oR6E8zBnmhODWHPMx3F2wZsU6hHhkxMyJuWrApA9rcA=;
        b=TR65K2Jbed3UL4cZUuWIa/tmMFINe8fQk3kZxHls81njxdeu3UmsG2lyxZbVwBPLnK
         8X0kFRUeEoli2jBrPyENddOo3CT074peHlEdX3z1wZuBIH0PqtTXI1tW2erp22DuO2g8
         fI/ouPTXcuMpa6vYxTYOw77M7hhbS1acGb8LajGYW74C3EgUItEu2u4whaHD9g8PAPw+
         nfubvPY8l3NFjzXFzv+INzTLGhB1eso9Y+z+3TjNVbCdJG3R3quS6pfYtvSSztrgvlPI
         DHiPfqYno0dM0rDFakpjOJs1yaPTozqZ01+x8eR0Zzfk1lHP1v15pH9hMVfa1jPxxGmz
         b07A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=oR6E8zBnmhODWHPMx3F2wZsU6hHhkxMyJuWrApA9rcA=;
        b=ztmf4JGARLucOIYGOuv67PQsoVhEoRjjt+y3rIt3EvY/WUNj/7Rlwr+fXlhjPA7fbn
         nwsiGN8poeAPJq1cpW/HO6cIgXJa9+bVHG1mqYrrkxCG077W01hsQIU3m4lKXBdxa93G
         O/fb2BT0Q8AzEQWBONn5Q5wc+oXCpUUsEg/vfKusLwLOyKmZb2qm0kgybJO5W2MdPdmH
         IrkazbU2QK8TUeq6ekLqYv3ZuY/UmhD3vvff9SIRMdv6JaMJGSG/CerbEDrjkL0nENCQ
         OHeFfDVExShzxCKPODSIhbAOIdgsQ5VpB/OcLIo7/LQqN0h9oVPZGZIzJJPuJLdnOxxr
         ys6g==
X-Gm-Message-State: AOAM530+9KPRw3a3lV7L2hMceQpwvSOOBPTL48sn26osi9xKAPrilqtW
        PVedLTkQST2+Ar9OwB6bjb9IISGHIe+j2Db4ZLgkcwDLXmw=
X-Google-Smtp-Source: ABdhPJx1jPH36iYXTWv3S72DnH8RBim2yhpfroWQVyB+0K2VeAa4oiI4/wPKel0FdJe2oAc69gOIF+eqJYdDmeq7KKw=
X-Received: by 2002:a25:300a:: with SMTP id w10mr22212ybw.506.1637788229254;
 Wed, 24 Nov 2021 13:10:29 -0800 (PST)
MIME-Version: 1.0
References: <20211124115654.849735859@linuxfoundation.org>
In-Reply-To: <20211124115654.849735859@linuxfoundation.org>
From:   Sudip Mukherjee <sudipm.mukherjee@gmail.com>
Date:   Wed, 24 Nov 2021 21:09:53 +0000
Message-ID: <CADVatmPxvqhQ-iUo3_wY+9D72O0qdBDh02Ewx1Yjz4f2=7uz7g@mail.gmail.com>
Subject: Re: [PATCH 5.4 000/100] 5.4.162-rc1 review
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

On Wed, Nov 24, 2021 at 2:10 PM Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 5.4.162 release.
> There are 100 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Fri, 26 Nov 2021 11:56:36 +0000.
> Anything received after that time might be too late.

Just a quick note, my arm64 builds are failing with the error:
arch/arm64/boot/dts/qcom/apq8016-sbc.dtsi:412.21-414.5: ERROR
(duplicate_label): /soc/codec: Duplicate label 'lpass_codec' on
/soc/codec and /soc@0/codec

I have not yet tested, but I think it will be for:
f4850fe1a15d (\"arm64: dts: qcom: msm8916: Add unit name for /soc node\")


-- 
Regards
Sudip
