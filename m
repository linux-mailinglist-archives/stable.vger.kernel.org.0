Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 78E262EAB49
	for <lists+stable@lfdr.de>; Tue,  5 Jan 2021 13:57:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727016AbhAEM4B (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Jan 2021 07:56:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42164 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726543AbhAEM4A (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Jan 2021 07:56:00 -0500
Received: from mail-pl1-x634.google.com (mail-pl1-x634.google.com [IPv6:2607:f8b0:4864:20::634])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A5DFBC061793
        for <stable@vger.kernel.org>; Tue,  5 Jan 2021 04:55:20 -0800 (PST)
Received: by mail-pl1-x634.google.com with SMTP id 4so16322345plk.5
        for <stable@vger.kernel.org>; Tue, 05 Jan 2021 04:55:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rajagiritech-edu-in.20150623.gappssmtp.com; s=20150623;
        h=message-id:subject:from:to:cc:date:in-reply-to:references
         :user-agent:mime-version;
        bh=0qHKJdutKKfCE1SlOOQQbXgrMfvAnp3g7onb8DDjyh4=;
        b=SudaatuYwpq4D3hZ1BGpZF/I6IjntPgGIqOi/3WUb75DRV1rBN7sMxvSpgRq4X1gN4
         V0CYT6rFpHONP+quGpN0VXh69wRE2ubfTwf5MyQPySIJp8OB5dCmhD2ntrSv0VqWu8Gn
         WicRvg3MzCqD8xrWt+2hxz/Qp6HelPNRu+dTjlauhVBJkQyLQ5AK8wljI4Mlt3NoZA6x
         d3I0yQmWC3PSaGiYesnvI/3bqbSBWdPkSOthI6JJxi0Danj7rXvgsrcHG+df0u1idXA8
         KgCovWlWGPmvEKASSBIEjHPFtM/NEAeQnEtrt4WDNE7th1ZlQJGDMDZksUTiuuwvfCE+
         Tadg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:subject:from:to:cc:date:in-reply-to
         :references:user-agent:mime-version;
        bh=0qHKJdutKKfCE1SlOOQQbXgrMfvAnp3g7onb8DDjyh4=;
        b=DrK2MV+4tOnhyVJvegNOBP9++m6+ZgsQT03nTO/+VhoGZ81uJEK9B5QYoVtwIlHWLy
         6pleH5cgAn4D9qnJ9pjGYnFw9DjHOC4YMEDowM1UwLIHicBncB8oHhpfp5QwqIuCedku
         gezKCXtr80vFdTeizK5R+blBn1wY+/mxIn4aFdkkZSkRrrU9xYra/siH+RsoY57bC6C6
         QJ6zfyesvnpiHNwSIgiKoJFm6sliuhs1ZLTo7YeuoPZsnichDD/S7tKKmeiYeORn/8ev
         T8T4EAdfDkpaSKkcDtgdcu8HABDRYaIbqUTassdb0oNNiwytlItH4tsb1HXNo1r/F6Bo
         XYRg==
X-Gm-Message-State: AOAM5310y1H8J5mW3UACg5Njo63yZkb4Rq9MGMCCtiXhEVxjU31Y0jaZ
        n2D8X894F7Orkj5j1SblkSOjcA==
X-Google-Smtp-Source: ABdhPJxxMv9S2uC2slZoHDLFtNPCyao0AfGk8DF6miGs45nGzt18+UdYNSrhi3XV3TDzO4PkzkDqiA==
X-Received: by 2002:a17:902:8541:b029:da:fcd1:7bf with SMTP id d1-20020a1709028541b02900dafcd107bfmr76343623plo.56.1609851320129;
        Tue, 05 Jan 2021 04:55:20 -0800 (PST)
Received: from [192.168.0.4] ([122.174.122.15])
        by smtp.gmail.com with ESMTPSA id ft19sm2632558pjb.44.2021.01.05.04.55.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 05 Jan 2021 04:55:19 -0800 (PST)
Message-ID: <69f585d13328c51811441c967243f4918f6a3c84.camel@rajagiritech.edu.in>
Subject: Re: [PATCH 5.10 00/63] 5.10.5-rc1 review
From:   Jeffrin Jose T <jeffrin@rajagiritech.edu.in>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, stable@vger.kernel.org
Date:   Tue, 05 Jan 2021 18:25:14 +0530
In-Reply-To: <20210104155708.800470590@linuxfoundation.org>
References: <20210104155708.800470590@linuxfoundation.org>
Content-Type: multipart/mixed; boundary="=-hBprf1ZZ2vPsBR8taIo8"
User-Agent: Evolution 3.38.1-2 
MIME-Version: 1.0
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--=-hBprf1ZZ2vPsBR8taIo8
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit

On Mon, 2021-01-04 at 16:56 +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.10.5 release.
> There are 63 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied,
> please
> let me know.
> 
> Responses should be made by Wed, 06 Jan 2021 15:56:52 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.5-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-
> stable-rc.git linux-5.10.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

hello,

Compiled  and  booted  5.10.5-rc1+ . dmesg  related shows 
no new errors  and  may be no major warning. 

Having said that, "dmesg -l warn"  show  a BUG related stuff.

warning-5.10.5-rc1+.txt file is attached.

Tested-by: Jeffrin Jose T <jeffrin@rajagiritech.edu.in>

-- 
software engineer
rajagiri school of engineering and technology - autonomous



--=-hBprf1ZZ2vPsBR8taIo8
Content-Disposition: attachment; filename="warning-5.10.5-rc1+.txt"
Content-Type: text/plain; name="warning-5.10.5-rc1+.txt"; charset="UTF-8"
Content-Transfer-Encoding: base64

WyAgICAwLjgxOTA4M10gTG9jayBkZXBlbmRlbmN5IHZhbGlkYXRvcjogQ29weXJpZ2h0IChjKSAy
MDA2IFJlZCBIYXQsIEluYy4sIEluZ28gTW9sbmFyClsgICAgMC44MTkwODhdIC4uLiBNQVhfTE9D
S0RFUF9TVUJDTEFTU0VTOiAgOApbICAgIDAuODE5MDkyXSAuLi4gTUFYX0xPQ0tfREVQVEg6ICAg
ICAgICAgIDQ4ClsgICAgMC44MTkwOTddIC4uLiBNQVhfTE9DS0RFUF9LRVlTOiAgICAgICAgODE5
MgpbICAgIDAuODE5MTAxXSAuLi4gQ0xBU1NIQVNIX1NJWkU6ICAgICAgICAgIDQwOTYKWyAgICAw
LjgxOTEwNV0gLi4uIE1BWF9MT0NLREVQX0VOVFJJRVM6ICAgICAzMjc2OApbICAgIDAuODE5MTA5
XSAuLi4gTUFYX0xPQ0tERVBfQ0hBSU5TOiAgICAgIDY1NTM2ClsgICAgMC44MTkxMTRdIC4uLiBD
SEFJTkhBU0hfU0laRTogICAgICAgICAgMzI3NjgKWyAgICAwLjgxOTExOF0gIG1lbW9yeSB1c2Vk
IGJ5IGxvY2sgZGVwZW5kZW5jeSBpbmZvOiA2MzY1IGtCClsgICAgMC44MTkxMjNdICBtZW1vcnkg
dXNlZCBmb3Igc3RhY2sgdHJhY2VzOiA0MjI0IGtCClsgICAgMC44MTkxMjddICBwZXIgdGFzay1z
dHJ1Y3QgbWVtb3J5IGZvb3RwcmludDogMTkyMCBieXRlcwpbICAgIDAuOTgzNDg2XSBNRFMgQ1BV
IGJ1ZyBwcmVzZW50IGFuZCBTTVQgb24sIGRhdGEgbGVhayBwb3NzaWJsZS4gU2VlIGh0dHBzOi8v
d3d3Lmtlcm5lbC5vcmcvZG9jL2h0bWwvbGF0ZXN0L2FkbWluLWd1aWRlL2h3LXZ1bG4vbWRzLmh0
bWwgZm9yIG1vcmUgZGV0YWlscy4KWyAgICAwLjk4NTM5Ml0gICMzClsgICAgMS4xNjY5NDZdIEVO
RVJHWV9QRVJGX0JJQVM6IFNldCB0byAnbm9ybWFsJywgd2FzICdwZXJmb3JtYW5jZScKClsgICAg
NC4zNjc1NzBdID09PT09PT09PT09PT09PT09PT09PT09PT09PT09ClsgICAgNC4zNjc1ODJdIFsg
QlVHOiBJbnZhbGlkIHdhaXQgY29udGV4dCBdClsgICAgNC4zNjc1OTZdIDUuMTAuNS1yYzErICMx
MiBOb3QgdGFpbnRlZApbICAgIDQuMzY3NjA4XSAtLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0t
LQpbICAgIDQuMzY3NjIxXSBrc29mdGlycWQvMy8yNiBpcyB0cnlpbmcgdG8gbG9jazoKWyAgICA0
LjM2NzYzNV0gZmZmZjg4ODEwMDA1YzkxOCAoJm4tPmxpc3RfbG9jayl7LS4uLn0tezM6M30sIGF0
OiB1bmZyZWV6ZV9wYXJ0aWFscysweDZkLzB4MWYwClsgICAgNC4zNjc2NzFdIG90aGVyIGluZm8g
dGhhdCBtaWdodCBoZWxwIHVzIGRlYnVnIHRoaXM6ClsgICAgNC4zNjc2ODRdIGNvbnRleHQtezI6
Mn0KWyAgICA0LjM2NzY5NV0gMSBsb2NrIGhlbGQgYnkga3NvZnRpcnFkLzMvMjY6ClsgICAgNC4z
Njc3MDddICAjMDogZmZmZmZmZmZhYjk5MTE2MCAocmN1X2NhbGxiYWNrKXsuLi4ufS17MDowfSwg
YXQ6IHJjdV9jb3JlKzB4MzQwLzB4OGMwClsgICAgNC4zNjc3NDJdIHN0YWNrIGJhY2t0cmFjZToK
WyAgICA0LjM2Nzc1NV0gQ1BVOiAzIFBJRDogMjYgQ29tbToga3NvZnRpcnFkLzMgTm90IHRhaW50
ZWQgNS4xMC41LXJjMSsgIzEyClsgICAgNC4zNjc3NzNdIEhhcmR3YXJlIG5hbWU6IEFTVVNUZUsg
Q09NUFVURVIgSU5DLiBWaXZvQm9vayAxNV9BU1VTIExhcHRvcCBYNTA3VUFSL1g1MDdVQVIsIEJJ
T1MgWDUwN1VBUi4yMDMgMDUvMzEvMjAxOApbICAgIDQuMzY3Nzk0XSBDYWxsIFRyYWNlOgpbICAg
IDQuMzY3ODA1XSAgPElSUT4KWyAgICA0LjM2NzgyMF0gIGR1bXBfc3RhY2srMHhhZS8weGU1Clsg
ICAgNC4zNjc4MzVdICBfX2xvY2tfYWNxdWlyZS5jb2xkKzB4MjA0LzB4MzRjClsgICAgNC4zNjc4
NTZdICA/IF9fbG9ja19hY3F1aXJlKzB4ODcwLzB4MmQ0MApbICAgIDQuMzY3ODcyXSAgPyBsb2Nr
ZGVwX2hhcmRpcnFzX29uX3ByZXBhcmUrMHgyMjAvMHgyMjAKWyAgICA0LjM2Nzg4OV0gID8gbG9j
a2RlcF9lbmFibGVkKzB4MzkvMHg1MApbICAgIDQuMzY3OTA2XSAgbG9ja19hY3F1aXJlKzB4MjM2
LzB4NTEwClsgICAgNC4zNjc5MjJdICA/IHVuZnJlZXplX3BhcnRpYWxzKzB4NmQvMHgxZjAKWyAg
ICA0LjM2NzkzOF0gID8gbG9ja19yZWxlYXNlKzB4NDEwLzB4NDEwClsgICAgNC4zNjc5NTRdICA/
IGZyZWVfdW5yZWZfcGFnZV9jb21taXQrMHgxMjkvMHgxYjAKWyAgICA0LjM2Nzk3Nl0gIF9yYXdf
c3Bpbl9sb2NrKzB4MmMvMHg0MApbICAgIDQuMzY3OTkxXSAgPyB1bmZyZWV6ZV9wYXJ0aWFscysw
eDZkLzB4MWYwClsgICAgNC4zNjgwMDZdICB1bmZyZWV6ZV9wYXJ0aWFscysweDZkLzB4MWYwClsg
ICAgNC4zNjgwMjNdICA/IG5vaHpfYmFsYW5jZV9leGl0X2lkbGUrMHgyYy8weDI1MApbICAgIDQu
MzY4MDQzXSAgZmx1c2hfc21wX2NhbGxfZnVuY3Rpb25fcXVldWUrMHhmNC8weDJjMApbICAgIDQu
MzY4MDU5XSAgPyBzbHViX2NwdV9kZWFkKzB4ZjAvMHhmMApbICAgIDQuMzY4MDc2XSAgX19zeXN2
ZWNfY2FsbF9mdW5jdGlvbisweDcxLzB4MjUwClsgICAgNC4zNjgwOTNdICBhc21fY2FsbF9pcnFf
b25fc3RhY2srMHgxMi8weDIwClsgICAgNC4zNjgxMDZdICA8L0lSUT4KWyAgICA0LjM2ODExOV0g
IHN5c3ZlY19jYWxsX2Z1bmN0aW9uKzB4ODQvMHhhMApbICAgIDQuMzY4MTM1XSAgYXNtX3N5c3Zl
Y19jYWxsX2Z1bmN0aW9uKzB4MTIvMHgyMApbICAgIDQuMzY4MTUyXSBSSVA6IDAwMTA6X19vcmNf
ZmluZCsweDZlLzB4YzAKWyAgICA0LjM2ODE2OF0gQ29kZTogMzcgNGMgODkgZTggNGMgMjkgZjgg
NDggODkgYzEgNDggYzEgZTggM2YgNDggYzEgZjkgMDIgNDggMDEgYzggNDggZDEgZjggNGQgOGQg
MzQgODcgNGMgODkgZjcgZTggMjggYWIgM2IgMDAgNDkgNjMgMDYgNGMgMDEgZjAgPDQ4PiAzOSBj
MyA3MyBjNiA0ZCA4ZCA2ZSBmYyA0ZCAzOSBmZCA3MyBjOSA0YyAyOSBlNSA0OCA4YiAzNCAyNCA0
OApbICAgIDQuMzY4MjA0XSBSU1A6IDAwMDA6ZmZmZmM5MDAwMDIzZjgwOCBFRkxBR1M6IDAwMDAw
MjgzClsgICAgNC4zNjgyMjJdIFJBWDogZmZmZmZmZmZhOWMwNTIzZCBSQlg6IGZmZmZmZmZmYTlj
MDUyNTEgUkNYOiBkZmZmZmMwMDAwMDAwMDAwClsgICAgNC4zNjgyNDFdIFJEWDogMDAwMDAwMDAw
MDAwMDAwMyBSU0k6IGZmZmZmZmZmYWMwMzg3ODQgUkRJOiBmZmZmZmZmZmFiZTYzYjk4ClsgICAg
NC4zNjgyNTldIFJCUDogZmZmZmZmZmZhYmU2M2I5MCBSMDg6IGZmZmZmZmZmYTljOWU0ZDggUjA5
OiBmZmZmZmZmZmFjMDZmZWYxClsgICAgNC4zNjgyNzddIFIxMDogZmZmZmZiZmZmNTgwZGZkZSBS
MTE6IDAwMDAwMDAwMDAwMDAwMDEgUjEyOiBmZmZmZmZmZmFiZTYzYjY4ClsgICAgNC4zNjgyOTZd
IFIxMzogZmZmZmZmZmZhYmU2M2I5YyBSMTQ6IGZmZmZmZmZmYWJlNjNiOTggUjE1OiBmZmZmZmZm
ZmFiZTYzYjk0ClsgICAgNC4zNjgzMzNdICA/IHJldF9mcm9tX2ZvcmsrMHgyMS8weDMwClsgICAg
NC4zNjgzNDhdICA/IF9fb3JjX2ZpbmQrMHg2OC8weGMwClsgICAgNC4zNjgzNjJdICA/IHJldF9m
cm9tX2ZvcmsrMHhkLzB4MzAKWyAgICA0LjM2ODM4MF0gID8gX19vcmNfZmluZCsweDY4LzB4YzAK
WyAgICA0LjM2ODM5Nl0gIHVud2luZF9uZXh0X2ZyYW1lKzB4MTFkLzB4YTYwClsgICAgNC4zNjg0
MTJdICA/IHJldF9mcm9tX2ZvcmsrMHgyMi8weDMwClsgICAgNC4zNjg0MjddICA/IHJldF9mcm9t
X2ZvcmsrMHgyMi8weDMwClsgICAgNC4zNjg0NDFdICA/IHJldF9mcm9tX2ZvcmsrMHgyMi8weDMw
ClsgICAgNC4zNjg0NTZdICA/IGRlcmVmX3N0YWNrX3JlZysweGIwLzB4YjAKWyAgICA0LjM2ODQ3
M10gID8gX191bndpbmRfc3RhcnQrMHgyZWQvMHgzNzAKWyAgICA0LjM2ODQ4OF0gID8gY3JlYXRl
X3Byb2ZfY3B1X21hc2srMHgyMC8weDIwClsgICAgNC4zNjg1MDVdICBhcmNoX3N0YWNrX3dhbGsr
MHg4OC8weGYwClsgICAgNC4zNjg1MjJdICA/IHJldF9mcm9tX2ZvcmsrMHgyMi8weDMwClsgICAg
NC4zNjg1MzldICA/IGttZW1fY2FjaGVfZnJlZSsweGZmLzB4NDAwClsgICAgNC4zNjg1NTNdICBz
dGFja190cmFjZV9zYXZlKzB4OTEvMHhjMApbICAgIDQuMzY4NTY5XSAgPyBzdGFja190cmFjZV9j
b25zdW1lX2VudHJ5KzB4ODAvMHg4MApbICAgIDQuMzY4NTg2XSAgPyBsb2NrX2NoYWluX2NvdW50
KzB4MjAvMHgyMApbICAgIDQuMzY4NjAxXSAgPyBsb2NrX2NoYWluX2NvdW50KzB4MjAvMHgyMApb
ICAgIDQuMzY4NjE1XSAgPyBrbWVtX2NhY2hlX2ZyZWUrMHhmZi8weDQwMApbICAgIDQuMzY4NjMy
XSAga2FzYW5fc2F2ZV9zdGFjaysweDFiLzB4NDAKWyAgICA0LjM2ODY0Nl0gID8ga2FzYW5fc2F2
ZV9zdGFjaysweDFiLzB4NDAKWyAgICA0LjM2ODY2MV0gID8ga2FzYW5fc2V0X3RyYWNrKzB4MWMv
MHgzMApbICAgIDQuMzY4Njc1XSAgPyBrYXNhbl9zZXRfZnJlZV9pbmZvKzB4MWIvMHgzMApbICAg
IDQuMzY4NjkwXSAgPyBfX2thc2FuX3NsYWJfZnJlZSsweDExMC8weDE1MApbICAgIDQuMzY4NzA2
XSAgPyBzbGFiX2ZyZWVfZnJlZWxpc3RfaG9vaysweDc4LzB4MTkwClsgICAgNC4zNjg3MjJdICA/
IGttZW1fY2FjaGVfZnJlZSsweGZmLzB4NDAwClsgICAgNC4zNjg3MzZdICA/IHJjdV9jb3JlKzB4
MzdhLzB4OGMwClsgICAgNC4zNjg3NTBdICA/IF9fZG9fc29mdGlycSsweDEwOC8weDViNgpbICAg
IDQuMzY4NzY1XSAgPyBydW5fa3NvZnRpcnFkKzB4M2EvMHg2MApbICAgIDQuMzY4NzgwXSAgPyBz
bXBib290X3RocmVhZF9mbisweDFiNy8weDMwMApbICAgIDQuMzY4Nzk0XSAgPyBrdGhyZWFkKzB4
MWRlLzB4MjAwClsgICAgNC4zNjg4MDddICA/IHJldF9mcm9tX2ZvcmsrMHgyMi8weDMwClsgICAg
NC4zNjg4MjNdICA/IF9fbG9ja19hY3F1aXJlKzB4ODcwLzB4MmQ0MApbICAgIDQuMzY4ODQwXSAg
PyBfX2xvY2tfYWNxdWlyZSsweDg3MC8weDJkNDAKWyAgICA0LjM2ODg2MV0gID8gbG9ja2RlcF9o
YXJkaXJxc19vbl9wcmVwYXJlKzB4MjIwLzB4MjIwClsgICAgNC4zNjg4NzhdICA/IG1hcmtfaGVs
ZF9sb2NrcysweDQ0LzB4OTAKWyAgICA0LjM2ODg5M10gID8gbG9ja2RlcF9lbmFibGVkKzB4Mzkv
MHg1MApbICAgIDQuMzY4OTEwXSAgPyBtYXJrX2hlbGRfbG9ja3MrMHg0NC8weDkwClsgICAgNC4z
Njg5MjVdICBrYXNhbl9zZXRfdHJhY2srMHgxYy8weDMwClsgICAgNC4zNjg5MzldICBrYXNhbl9z
ZXRfZnJlZV9pbmZvKzB4MWIvMHgzMApbICAgIDQuMzY4OTU1XSAgX19rYXNhbl9zbGFiX2ZyZWUr
MHgxMTAvMHgxNTAKWyAgICA0LjM2ODk3Ml0gIHNsYWJfZnJlZV9mcmVlbGlzdF9ob29rKzB4Nzgv
MHgxOTAKWyAgICA0LjM2ODk4OF0gID8gcmN1X2NvcmUrMHgzN2EvMHg4YzAKWyAgICA0LjM2OTAw
M10gIGttZW1fY2FjaGVfZnJlZSsweGZmLzB4NDAwClsgICAgNC4zNjkwMjFdICA/IHJjdV9jb3Jl
KzB4MzQwLzB4OGMwClsgICAgNC4zNjkwMzRdICByY3VfY29yZSsweDM3YS8weDhjMApbICAgIDQu
MzY5MDQ4XSAgPyByY3VfY29yZSsweDM0MC8weDhjMApbICAgIDQuMzY5MDY1XSAgPyByY3Vfbm90
ZV9jb250ZXh0X3N3aXRjaCsweDYwLzB4NjAKWyAgICA0LjM2OTA4Ml0gID8gbWFya19oZWxkX2xv
Y2tzKzB4MjQvMHg5MApbICAgIDQuMzY5MDk3XSAgPyBsb2NrZGVwX2VuYWJsZWQrMHgzOS8weDUw
ClsgICAgNC4zNjkxMTRdICA/IGxvY2tfaXNfaGVsZF90eXBlKzB4YjQvMHhmMApbICAgIDQuMzY5
MTMxXSAgX19kb19zb2Z0aXJxKzB4MTA4LzB4NWI2ClsgICAgNC4zNjkxNDldICA/IF9fbG9jYWxf
YmhfZGlzYWJsZV9pcCsweDYwLzB4NjAKWyAgICA0LjM2OTE2NF0gIHJ1bl9rc29mdGlycWQrMHgz
YS8weDYwClsgICAgNC4zNjkxNzldICBzbXBib290X3RocmVhZF9mbisweDFiNy8weDMwMApbICAg
IDQuMzY5MTk2XSAgPyBzbXBib290X3JlZ2lzdGVyX3BlcmNwdV90aHJlYWQrMHgxOTAvMHgxOTAK
WyAgICA0LjM2OTIxNl0gID8gc21wYm9vdF9yZWdpc3Rlcl9wZXJjcHVfdGhyZWFkKzB4MTkwLzB4
MTkwClsgICAgNC4zNjkyMzJdICBrdGhyZWFkKzB4MWRlLzB4MjAwClsgICAgNC4zNjkyNDZdICA/
IGt0aHJlYWRfY3JlYXRlX3dvcmtlcl9vbl9jcHUrMHhkMC8weGQwClsgICAgNC4zNjkyNjNdICBy
ZXRfZnJvbV9mb3JrKzB4MjIvMHgzMApbICAgMTIuMzE3MDY2XSBpODA0MjogUE5QOiBQUy8yIGFw
cGVhcnMgdG8gaGF2ZSBBVVggcG9ydCBkaXNhYmxlZCwgaWYgdGhpcyBpcyBpbmNvcnJlY3QgcGxl
YXNlIGJvb3Qgd2l0aCBpODA0Mi5ub3BucApbICAgMTQuNzYxNDQ2XSBzZGhjaS1wY2kgMDAwMDow
MDoxZS42OiBmYWlsZWQgdG8gc2V0dXAgY2FyZCBkZXRlY3QgZ3BpbwpbICAgMTYuODgwMTM0XSBp
MmNfaGlkIGkyYy1FTEFOMTMwMDowMDogc3VwcGx5IHZkZCBub3QgZm91bmQsIHVzaW5nIGR1bW15
IHJlZ3VsYXRvcgpbICAgMTYuODgxMzY5XSBpMmNfaGlkIGkyYy1FTEFOMTMwMDowMDogc3VwcGx5
IHZkZGwgbm90IGZvdW5kLCB1c2luZyBkdW1teSByZWd1bGF0b3IKWyAgIDI3LjM2OTIxM10gc3lz
dGVtZFsxXTogL2xpYi9zeXN0ZW1kL3N5c3RlbS9wbHltb3V0aC1zdGFydC5zZXJ2aWNlOjE2OiBV
bml0IGNvbmZpZ3VyZWQgdG8gdXNlIEtpbGxNb2RlPW5vbmUuIFRoaXMgaXMgdW5zYWZlLCBhcyBp
dCBkaXNhYmxlcyBzeXN0ZW1kJ3MgcHJvY2VzcyBsaWZlY3ljbGUgbWFuYWdlbWVudCBmb3IgdGhl
IHNlcnZpY2UuIFBsZWFzZSB1cGRhdGUgeW91ciBzZXJ2aWNlIHRvIHVzZSBhIHNhZmVyIEtpbGxN
b2RlPSwgc3VjaCBhcyAnbWl4ZWQnIG9yICdjb250cm9sLWdyb3VwJy4gU3VwcG9ydCBmb3IgS2ls
bE1vZGU9bm9uZSBpcyBkZXByZWNhdGVkIGFuZCB3aWxsIGV2ZW50dWFsbHkgYmUgcmVtb3ZlZC4K
WyAgIDQ1LjUyNzM3M10gRkFULWZzIChzZGExKTogVm9sdW1lIHdhcyBub3QgcHJvcGVybHkgdW5t
b3VudGVkLiBTb21lIGRhdGEgbWF5IGJlIGNvcnJ1cHQuIFBsZWFzZSBydW4gZnNjay4KWyAgMTQ4
LjgxODQyOV0gc2hvd19zaWduYWxfbXNnOiA2IGNhbGxiYWNrcyBzdXBwcmVzc2VkCg==


--=-hBprf1ZZ2vPsBR8taIo8--

