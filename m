Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EC7604DA15D
	for <lists+stable@lfdr.de>; Tue, 15 Mar 2022 18:35:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243158AbiCORgU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 15 Mar 2022 13:36:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44950 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350556AbiCORgS (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 15 Mar 2022 13:36:18 -0400
Received: from mail-yb1-xb32.google.com (mail-yb1-xb32.google.com [IPv6:2607:f8b0:4864:20::b32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BA07035DF8
        for <stable@vger.kernel.org>; Tue, 15 Mar 2022 10:35:05 -0700 (PDT)
Received: by mail-yb1-xb32.google.com with SMTP id j2so36134ybu.0
        for <stable@vger.kernel.org>; Tue, 15 Mar 2022 10:35:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rajagiritech-edu-in.20210112.gappssmtp.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=9cxe7F0Mm0a6AxqMIeIGWlQ8NeF1GaRTfZXWG+OuJgM=;
        b=O5uIOAbth+QHgV6WFWP4rYQGes8fCDwvedy6aLvQIIzDYGotbwM9UQGzboKlj6XLQA
         CiK+gyk2qrziLafVjDNSCsbTUkdDx44N9QMU3QQP7/vwON6dt9baTp9iCCJl22hHNd3C
         LsveuF1p2i6QRzRRv1UmMqMyphy1oBu/ZWTDCjstTPvc+tOAxbgJPgFSz0krTq/yAwmw
         m1n7BnE7gzC7CFRtsX5I0o9kdMHMZpYg3nx0563lmtd0CEnG1rdphkqdzndQiFG0CQ0I
         umBFWgxoXha55Gb4J5Yq96gxspBqM/FqVf2CVM1HF1zjC5UwEco3EpLd2TJNnZQuXpBk
         idBw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=9cxe7F0Mm0a6AxqMIeIGWlQ8NeF1GaRTfZXWG+OuJgM=;
        b=beDLns6IEZX6lQTDkr/swXkE6cXt7rhMZleBjoJqSyE9uMAl+a2TDUtoro4U74Rv75
         CKN+76PsgJ13DD+1+9lm/NDc/AdCcbu4fCDtrds/4+7xEiTk/qRsSYFxSzaJjlwt4FDY
         A0RXdri4lWj8AvZ+ovirTF32cabq8gylXh/c75JCm3F0Viopni5Z0M2PqHhuWHTrduDa
         nda2TKCWZnaqNg93Rm6yMH/j/kB10kAFRPt51ebT9U4L9lWJ3F7p+19KLeqYBKe4bFF4
         OrwhuYcHeXKmAA1UvS5zU0qD7WoB9TQ8UF0Q7V/bFRBsOtmy7qEZNH08Jod9XZVcyh1k
         vrVQ==
X-Gm-Message-State: AOAM530SZbn6jCj0LwaTnXTSPtv4CXYFsReVcGrbY6X/SAH0zlOhPu5P
        B82GbM0uwE7KtagSexMdqeCjX6cIBVqURyYuExP0MQ==
X-Google-Smtp-Source: ABdhPJy2I0TVZS5JR6nWQ7Hm2iBK4LhRnGmfmQjqOgBqQmAQT7V/PxHh9ME1T3aj5Vwgcnx8sRTSPFrKPGPugrJLIBA=
X-Received: by 2002:a25:be8b:0:b0:61a:6cf9:7ea6 with SMTP id
 i11-20020a25be8b000000b0061a6cf97ea6mr24909198ybk.309.1647365704939; Tue, 15
 Mar 2022 10:35:04 -0700 (PDT)
MIME-Version: 1.0
References: <20220314145920.247358804@linuxfoundation.org>
In-Reply-To: <20220314145920.247358804@linuxfoundation.org>
From:   Jeffrin Thalakkottoor <jeffrin@rajagiritech.edu.in>
Date:   Tue, 15 Mar 2022 13:34:28 -0400
Message-ID: <CAG=yYwktdQ1Ep0r=VKitta=1gWrNN1Wi0Ft9t0+sXdy1bsX81Q@mail.gmail.com>
Subject: Re: [PATCH 4.19 00/29] 4.19.235-rc2 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     lkml <linux-kernel@vger.kernel.org>, stable@vger.kernel.org,
        torvalds@linux-foundation.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Guenter Roeck <linux@roeck-us.net>,
        Shuah Khan <shuah@kernel.org>, patches@kernelci.org,
        lkft-triage@lists.linaro.org, Pavel Machek <pavel@denx.de>,
        jonathanh@nvidia.com, f.fainelli@gmail.com,
        sudipm.mukherjee@gmail.com, slade@sladewatkins.com
Content-Type: multipart/mixed; boundary="000000000000a8d26605da4537b2"
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

--000000000000a8d26605da4537b2
Content-Type: text/plain; charset="UTF-8"

On Mon, Mar 14, 2022 at 11:00 AM Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 4.19.235 release.
> There are 29 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Wed, 16 Mar 2022 14:59:12 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.19.235-rc2.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-4.19.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h
>
hello,

Compiled and  booted 4.19.235-rc2+ on ...

Processor Information
    Socket Designation: FM2
    Type: Central Processor
    Family: A-Series
    Manufacturer: AuthenticAMD
    ID: 31 0F 61 00 FF FB 8B 17
    Signature: Family 21, Model 19, Stepping 1


I think No major new  regression or regressions  from dmesg.
Some error related stuff has happened.
Please see the  attachment for build issues related.

Tested-by: Jeffrin Jose T <jeffrin@rajagiritech.edu.in>
Reported-by: Jeffrin Jose T <jeffrin@rajagiritech.edu.in>


-- 
software engineer
rajagiri school of engineering and technology  -  autonomous

--000000000000a8d26605da4537b2
Content-Type: text/plain; charset="US-ASCII"; name="error-4.19.235-rc2.txt"
Content-Disposition: attachment; filename="error-4.19.235-rc2.txt"
Content-Transfer-Encoding: base64
Content-ID: <f_l0seymyd0>
X-Attachment-Id: f_l0seymyd0

Ci0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLTxlcnJvciByZWxhdGVkIGNsaXBwaW5nIDE+LS0tLS0t
LS0tLS0tLS0tLS0tLS0tLS0tLS0KSW4gZnVuY3Rpb24gJ21lbWNweScsCiAgaW5saW5lZCBmcm9t
IG1lbWNweV9mcm9taW8gYXQgLi9pbmNsdWRlL2FzbS1nZW5lcmljL2lvLmg6MTExNzoyLAogICAg
aW5saW5lZCBmcm9tIGdoZXNfY29weV90b2Zyb21fcGh5cyBhdCBkcml2ZXJzL2FjcGkvYXBlaS9n
aGVzLmM6MzExOjQ6Ci4vaW5jbHVkZS9saW51eC9zdHJpbmcuaDoyNjE6MzM6IHdhcm5pbmc6IF9f
YnVpbHRpbl9tZW1jcHkgcmVhZGluZyBiZXR3ZWVuIDEgYW5kIDQwOTYgYnl0ZXMgZnJvbSBhIHJl
Z2lvbiBvZiBzaXplIDAgWy1Xc3RyaW5nb3Atb3ZlcnJlYWRdCiAgMjYxIHwgI2RlZmluZSBfX3Vu
ZGVybHlpbmdfbWVtY3B5ICAgICBfX2J1aWx0aW5fbWVtY3B5CiAgICAgIHwgICAgICAgICAgICAg
ICAgICAgICAgICAgICAgICAgICBeCi4vaW5jbHVkZS9saW51eC9zdHJpbmcuaDozNzc6MTY6IG5v
dGU6IGluIGV4cGFuc2lvbiBvZiBtYWNybyBfX3VuZGVybHlpbmdfbWVtY3B5CiAgMzc3IHwgICAg
ICAgICByZXR1cm4gX191bmRlcmx5aW5nX21lbWNweShwLCBxLCBzaXplKTsKCi0tLS0tLS0tLS0t
LS0tLS0tLS0tLS0tLTxlcnJvciByZWxhdGVkIGNsaXBwaW5nID4tLS0tLS0tLS0tLS0tLS0tLS0t
LS0tLS0tLQoKCgoKCi0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLTxlcnJvciByZWxhdGVkIGNsaXBw
aW5nIDI+LS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0KCmRyaXZlcnMvY3J5cHRvL2NjcC9zcC1w
bGF0Zm9ybS5jOjM3OjM0OiB3YXJuaW5nOiBhcnJheSBzcF9vZl9tYXRjaCBhc3N1bWVkIHRvIGhh
dmUgb25lIGVsZW1lbnQKICAgMzcgfCBzdGF0aWMgY29uc3Qgc3RydWN0IG9mX2RldmljZV9pZCBz
cF9vZl9tYXRjaFtdOwotLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS08ZXJyb3IgcmVsYXRlZCBjbGlw
cGluZz4tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLQoKCgoKCgotLS0tLS0tLS0tLS0tLS0tLS0t
LS0tLS08ZXJyb3IgcmVsYXRlZCBjbGlwcGluZyAzPi0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0t
CmxkOiBhcmNoL3g4Ni9ib290L2NvbXByZXNzZWQvaGVhZF82NC5vOiB3YXJuaW5nOiByZWxvY2F0
aW9uIGluIHJlYWQtb25seSBzZWN0aW9uIGAuaGVhZC50ZXh0JwpsZDogd2FybmluZzogY3JlYXRp
bmcgRFRfVEVYVFJFTCBpbiBhIFBJRQotLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS08ZXJyb3IgcmVs
YXRlZCBjbGlwcGluZz4tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLQ==
--000000000000a8d26605da4537b2--
