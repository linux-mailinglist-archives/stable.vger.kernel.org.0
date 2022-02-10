Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 75E914B1504
	for <lists+stable@lfdr.de>; Thu, 10 Feb 2022 19:11:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245585AbiBJSLi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 10 Feb 2022 13:11:38 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:37112 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245583AbiBJSLi (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 10 Feb 2022 13:11:38 -0500
Received: from mail-vs1-xe2f.google.com (mail-vs1-xe2f.google.com [IPv6:2607:f8b0:4864:20::e2f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F2E6A1169
        for <stable@vger.kernel.org>; Thu, 10 Feb 2022 10:11:38 -0800 (PST)
Received: by mail-vs1-xe2f.google.com with SMTP id r13so2871086vsg.6
        for <stable@vger.kernel.org>; Thu, 10 Feb 2022 10:11:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rajagiritech-edu-in.20210112.gappssmtp.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=m+hInPGeofgQvr+B+jVJK410sDOyGMUjmtcn9HJ0ffY=;
        b=flqnBBPVANSD1q26AJK1xKHd6Pz8XsN5l5tNUv0zrjZ6RUkvAhmsCcb2usX76C3vze
         BKQrSKHOjwhTWQ8zLtP0DwlqZU2SZ1gutMd+mUC2qMxIBtTl+AZrnhS8Ud7gT9mdwbxi
         5BDCER/FC7wNbWpnFp5+7hKfdPu2ON2BDi0AWBt9Q/lbujogRcsefNa6QEIFX42OADob
         kQ50VLfgVRE2YphEk0I5jOQvXDCXzqj2VfDbkAFstqP0CW3rjHIZ/2kOGpi+2ej68ixh
         swkWO+3eL+q68NYwP5EkES500gpKk9md4DW9TPEE87u0QzYq/Lr6RF9kWQd2Jiwq8Fpi
         MJnA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=m+hInPGeofgQvr+B+jVJK410sDOyGMUjmtcn9HJ0ffY=;
        b=1TJSfBlTQef+ImuWDuwhs8yL4UNbhajkioJ1a34xFaoLH9rcQAORIMvvLCpFEfW0ia
         PCHqsAoq+9a+0ry3zC1FWK/37eDI5HF3krx2qE8wM/zzeR8sMCKikYbIXotu0Iw4ZNpA
         dFxX4MvZt43hVbhJYcrHF2WX9JkbP/bZioduw53jrxQUttRhQIlph0mIJbepdS6MBGLC
         7dK1evVkCW4Xei3w6sAu5n2wpxGN4kMcjaE0I5fXyZDntjuJm47EeMtv57uKHjy2jKv3
         D7LNz3xVf7nAjnDnWbHzKbbFqX9P56PM1hRG4m/pYC6hNWveb1MXGa0fgijlQzSo5EdN
         by0w==
X-Gm-Message-State: AOAM532N7LNILxvPtlgAm923v6N4UopbGeK50om29nntTnnrRPWjfeRt
        rqE30XlEJp4NVDUoREhq/uWw3O1/ub1rPh6nYR/yQA==
X-Google-Smtp-Source: ABdhPJw0wrjMPSV0KitDigRahLC/42LEA2IINh4KLCyn8gAYrV3PQkar+WOmsLQ0V6q190C4yh2BfHWfFZg0RMqQ4wo=
X-Received: by 2002:a67:ff0a:: with SMTP id v10mr1811061vsp.3.1644516698069;
 Thu, 10 Feb 2022 10:11:38 -0800 (PST)
MIME-Version: 1.0
References: <20220209191248.596319706@linuxfoundation.org>
In-Reply-To: <20220209191248.596319706@linuxfoundation.org>
From:   Jeffrin Thalakkottoor <jeffrin@rajagiritech.edu.in>
Date:   Thu, 10 Feb 2022 13:11:01 -0500
Message-ID: <CAG=yYwk2JyJsUsBR_aRxY2j=i=snjoCTx+D70x78BRwN-X53=Q@mail.gmail.com>
Subject: Re: [PATCH 4.19 0/2] 4.19.229-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     lkml <linux-kernel@vger.kernel.org>, stable@vger.kernel.org,
        torvalds@linux-foundation.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Guenter Roeck <linux@roeck-us.net>,
        Shuah Khan <shuah@kernel.org>, patches@kernelci.org,
        lkft-triage@lists.linaro.org, Pavel Machek <pavel@denx.de>,
        jonathanh@nvidia.com, f.fainelli@gmail.com,
        sudipm.mukherjee@gmail.com, slade@sladewatkins.com
Content-Type: multipart/mixed; boundary="0000000000009ddee705d7ade1bc"
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

--0000000000009ddee705d7ade1bc
Content-Type: text/plain; charset="UTF-8"

On Wed, Feb 9, 2022 at 2:25 PM Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 4.19.229 release.
> There are 2 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Fri, 11 Feb 2022 19:12:41 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.19.229-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-4.19.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

hello,
Compiled  and booted kernel 4.19.229-rc1+ on :

Processor Information:
    Socket Designation: FM2
    Type: Central Processor
    Family: A-Series
    Manufacturer: AuthenticAMD
    ID: 31 0F 61 00 FF FB 8B 17
    Signature: Family 21, Model 19, Stepping 1


i have a new  display card of nvidia chipset. iam using non-free drivers here.
01:00.0 VGA compatible controller: NVIDIA Corporation GP108 [GeForce
GT 1030] (rev a1) (from lspci output)
resources: irq:29 memory:fd000000-fdffffff memory:c0000000-cfffffff
memory:d0000000-d1ffffff ioport:e000(size=128) memory:c0000-dffff
(from "sudo lshw -c video"  output)

dmesg related actions attached.

Tested-by: Jeffrin Jose T <jeffrin@rajagiritech.edu.in>
--
software engineer
rajagiri school of engineering and technology  -  autonomous

--0000000000009ddee705d7ade1bc
Content-Type: text/plain; charset="US-ASCII"; name="dmesg0.txt"
Content-Disposition: attachment; filename="dmesg0.txt"
Content-Transfer-Encoding: base64
Content-ID: <f_kzhaqwpy0>
X-Attachment-Id: f_kzhaqwpy0

JHN1ZG8gc3lzY3RsIC13IGtlcm5lbC5kbWVzZ19yZXN0cmljdD0wCmtlcm5lbC5kbWVzZ19yZXN0
cmljdCA9IDAKJGRtZXNnIC1sIGVtZXJnCiRkbWVzZyAtbCBhbGVydAokZG1lc2cgLWwgY3JpdAok
ZG1lc2cgLWwgZXJyClsgICAgMS4yNzAwOTJdIG52aWRpYWZiOiB1bmtub3duIE5WX0FSQ0gKWyAg
ICA1LjUzMTk5Ml0gY2dyb3VwOiBjZ3JvdXAyOiB1bmtub3duIG9wdGlvbiAibWVtb3J5X3JlY3Vy
c2l2ZXByb3QiCiRkbWVzZyAtbCB3YXJuClsgICAgMC4wMTczODRdIEFDUEkgQklPUyBXYXJuaW5n
IChidWcpOiBPcHRpb25hbCBGQURUIGZpZWxkIFBtMkNvbnRyb2xCbG9jayBoYXMgdmFsaWQgTGVu
Z3RoIGJ1dCB6ZXJvIEFkZHJlc3M6IDB4MDAwMDAwMDAwMDAwMDAwMC8weDEgKDIwMTgwODEwL3Ri
ZmFkdC02MTUpClsgICAgMS4yNzAwNDBdIG52aWRpYWZiX3NldHVwIFNUQVJUClsgICAgMS4yNzAw
NDddIG52aWRpYWZiX3Byb2JlIFNUQVJUClsgICAxMi4zMjk2OTZdIG52aWRpYTogbG9hZGluZyBv
dXQtb2YtdHJlZSBtb2R1bGUgdGFpbnRzIGtlcm5lbC4KWyAgIDEyLjMyOTcxMF0gbnZpZGlhOiBt
b2R1bGUgbGljZW5zZSAnTlZJRElBJyB0YWludHMga2VybmVsLgpbICAgMTIuMzI5NzExXSBEaXNh
YmxpbmcgbG9jayBkZWJ1Z2dpbmcgZHVlIHRvIGtlcm5lbCB0YWludApbICAgMTIuNDg2Mjg5XSBO
VlJNOiBsb2FkaW5nIE5WSURJQSBVTklYIHg4Nl82NCBLZXJuZWwgTW9kdWxlICA0NzAuMTAzLjAx
ICBUaHUgSmFuICA2IDEyOjEwOjA0IFVUQyAyMDIyClsgICAzMS41NDcwNzNdIHJlc291cmNlIHNh
bml0eSBjaGVjazogcmVxdWVzdGluZyBbbWVtIDB4MDAwYzAwMDAtMHgwMDBmZmZmZl0sIHdoaWNo
IHNwYW5zIG1vcmUgdGhhbiBQQ0kgQnVzIDAwMDA6MDAgW21lbSAweDAwMGMwMDAwLTB4MDAwZGZm
ZmYgd2luZG93XQpbICAgMzEuNTQ3NDgzXSBjYWxsZXIgX252MDAwNzIycm0rMHgxYWQvMHgyMDAg
W252aWRpYV0gbWFwcGluZyBtdWx0aXBsZSBCQVJzClsgICA0MC4wOTk0MDJdIGthdWRpdGRfcHJp
bnRrX3NrYjogMTEgY2FsbGJhY2tzIHN1cHByZXNzZWQKJAo=
--0000000000009ddee705d7ade1bc--
