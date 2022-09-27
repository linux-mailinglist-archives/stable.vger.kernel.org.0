Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 391AE5EB646
	for <lists+stable@lfdr.de>; Tue, 27 Sep 2022 02:28:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229920AbiI0A2z (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 26 Sep 2022 20:28:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45870 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229547AbiI0A2y (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 26 Sep 2022 20:28:54 -0400
Received: from mail-il1-x12b.google.com (mail-il1-x12b.google.com [IPv6:2607:f8b0:4864:20::12b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D93277EFED
        for <stable@vger.kernel.org>; Mon, 26 Sep 2022 17:28:53 -0700 (PDT)
Received: by mail-il1-x12b.google.com with SMTP id l4so4392262ilq.3
        for <stable@vger.kernel.org>; Mon, 26 Sep 2022 17:28:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date;
        bh=j7D4S2ZjZZXGxRAUPK0KsYOzH/WjYYNlPvnne6bgnzc=;
        b=MdpLzClfx5HfciwFph2WzIwD0obP21xODyO98/m91W44O098/kRpipM+jTCbkXckD8
         XisvPgiyyq1arJtjQaKqlT2NyRdNuzHmx+s4ejFd2WRObpcCHm1zrCE9mIey/CTh8zj8
         vfojp/AnRVeNTBI4oKeuactAHeMuVybMynMmY=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date;
        bh=j7D4S2ZjZZXGxRAUPK0KsYOzH/WjYYNlPvnne6bgnzc=;
        b=ilYf8JIrZJ7q86iK4H0n0mn8mO0fZT8OF04pi/cw8h1uK5z+4quPfyu9Xq5nC0V50j
         DM2LnP0eFjINqpyj0h1XUI4dXncIR00YcYOxc4097fV809m17jf7p0uh7bLZgT51zSeU
         rYbzQQxci+F8MhqWdGyPt0jW3Zd+i/2grSP6cSdoSqGU9ps2EmAWRkViuHEG3C4NEVSX
         VJdWhPXZ0Dp+R7xpfZJOjI8dnhx9aqc1auICGqToDzIDbuKnaqQb7f5JkJ6BYjs25ArS
         NntyKEwNbih2ZbvYAx9v/MgU7tiIwXjqHJrXdqbv0TjhS4o6INstp6xSFqjaLi0Zc9pz
         23pQ==
X-Gm-Message-State: ACrzQf1FOJ7bgeusGItHqykV4RLNvCTV3Q7GXYATWV96IpbpIvM7HxoN
        qw2lZwizYXQU+9hEo9TvJG59JA==
X-Google-Smtp-Source: AMsMyM6MglcbZ5exfctIprWGhX7CYvXrDNpc1yI0/hDpmcwIljH9o0bBGMxMjAQymNccXLewZGJ4wg==
X-Received: by 2002:a05:6e02:1a25:b0:2f1:b136:f01d with SMTP id g5-20020a056e021a2500b002f1b136f01dmr11046114ile.17.1664238533150;
        Mon, 26 Sep 2022 17:28:53 -0700 (PDT)
Received: from [192.168.1.128] ([38.15.45.1])
        by smtp.gmail.com with ESMTPSA id z19-20020a027a53000000b0035a468b7fbesm17697jad.71.2022.09.26.17.28.52
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 26 Sep 2022 17:28:52 -0700 (PDT)
Message-ID: <30a5914d-f9ec-76a0-67d9-271c2603d1aa@linuxfoundation.org>
Date:   Mon, 26 Sep 2022 18:28:52 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
Subject: Re: [PATCH 5.10 000/138] 5.10.146-rc2 review
Content-Language: en-US
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     stable@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, f.fainelli@gmail.com,
        sudipm.mukherjee@gmail.com, slade@sladewatkins.com,
        Shuah Khan <skhan@linuxfoundation.org>
References: <20220926163550.904900693@linuxfoundation.org>
From:   Shuah Khan <skhan@linuxfoundation.org>
In-Reply-To: <20220926163550.904900693@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: base64
X-Spam-Status: No, score=-4.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

T24gOS8yNi8yMiAxMDozNiwgR3JlZyBLcm9haC1IYXJ0bWFuIHdyb3RlOg0KPiBUaGlzIGlz
IHRoZSBzdGFydCBvZiB0aGUgc3RhYmxlIHJldmlldyBjeWNsZSBmb3IgdGhlIDUuMTAuMTQ2
IHJlbGVhc2UuDQo+IFRoZXJlIGFyZSAxMzggcGF0Y2hlcyBpbiB0aGlzIHNlcmllcywgYWxs
IHdpbGwgYmUgcG9zdGVkIGFzIGEgcmVzcG9uc2UNCj4gdG8gdGhpcyBvbmUuICBJZiBhbnlv
bmUgaGFzIGFueSBpc3N1ZXMgd2l0aCB0aGVzZSBiZWluZyBhcHBsaWVkLCBwbGVhc2UNCj4g
bGV0IG1lIGtub3cuDQo+IA0KPiBSZXNwb25zZXMgc2hvdWxkIGJlIG1hZGUgYnkgV2VkLCAy
OCBTZXAgMjAyMiAxNjozNToyNSArMDAwMC4NCj4gQW55dGhpbmcgcmVjZWl2ZWQgYWZ0ZXIg
dGhhdCB0aW1lIG1pZ2h0IGJlIHRvbyBsYXRlLg0KPiANCj4gVGhlIHdob2xlIHBhdGNoIHNl
cmllcyBjYW4gYmUgZm91bmQgaW4gb25lIHBhdGNoIGF0Og0KPiAJaHR0cHM6Ly93d3cua2Vy
bmVsLm9yZy9wdWIvbGludXgva2VybmVsL3Y1Lngvc3RhYmxlLXJldmlldy9wYXRjaC01LjEw
LjE0Ni1yYzIuZ3oNCj4gb3IgaW4gdGhlIGdpdCB0cmVlIGFuZCBicmFuY2ggYXQ6DQo+IAln
aXQ6Ly9naXQua2VybmVsLm9yZy9wdWIvc2NtL2xpbnV4L2tlcm5lbC9naXQvc3RhYmxlL2xp
bnV4LXN0YWJsZS1yYy5naXQgbGludXgtNS4xMC55DQo+IGFuZCB0aGUgZGlmZnN0YXQgY2Fu
IGJlIGZvdW5kIGJlbG93Lg0KPiANCj4gdGhhbmtzLA0KPiANCj4gZ3JlZyBrLWgNCj4gDQoN
CkNvbXBpbGVkIGFuZCBib290ZWQuIEhvd2V2ZXIgSSBhbSBzZWVpbmcgd2FybnMgb24gZnJv
bSBkcm0gYW5kIGl0IHRvb2sNCmEgbG9uZyB0aW1lIHRvIGJvb3QuIEkgd2lsbCBpc29sYXRl
IHRoZSBjb21taXQgYW5kIGxldCB5b3Uga25vdy4NCg0KDQpbICA1ODQuMzg4NjE2XSBXQVJO
SU5HOiBDUFU6IDkgUElEOiAxNDcwIGF0IGRyaXZlcnMvZ3B1L2RybS9hbWQvYW1kZ3B1Ly4u
L2Rpc3BsYXkvYW1kZ3B1X2RtL2FtZGdwdV9kbS5jOjczOTEgYW1kZ3B1X2RtX2F0b21pY19j
b21taXRfdGFpbCsweDIzYjkvMHgyNDMwIFthbWRncHVdDQpbICA1ODQuMzg4NjE3XSBNb2R1
bGVzIGxpbmtlZCBpbjogY2NtIHh0X0NIRUNLU1VNIHh0X01BU1FVRVJBREUgeHRfY29ubnRy
YWNrIGlwdF9SRUpFQ1QgbmZfcmVqZWN0X2lwdjQgeHRfdGNwdWRwIG5mdF9jb21wYXQgbmZ0
X2NoYWluX25hdCBuZl9uYXQgbmZfY29ubnRyYWNrIG5mX2RlZnJhZ19pcHY2IG5mX2RlZnJh
Z19pcHY0IG5mdF9jb3VudGVyIG5mX3RhYmxlcyBuZm5ldGxpbmsgYnJpZGdlIHN0cCBsbGMg
Y21hYyBhbGdpZl9oYXNoIGFsZ2lmX3NrY2lwaGVyIGFmX2FsZyBibmVwIGJpbmZtdF9taXNj
IHNuZF9oZGFfY29kZWNfcmVhbHRlayBzbmRfaGRhX2NvZGVjX2dlbmVyaWMgbGVkdHJpZ19h
dWRpbyBzbmRfaGRhX2NvZGVjX2hkbWkgc25kX2hkYV9pbnRlbCBzbmRfaW50ZWxfZHNwY2Zn
IHNuZF9oZGFfY29kZWMgc25kX2hkYV9jb3JlIHNuZF9od2RlcCBzbmRfcGNtIHNuZF9zZXFf
bWlkaSBzbmRfc2VxX21pZGlfZXZlbnQgc25kX3Jhd21pZGkgYXRoMTBrX3BjaSBlZGFjX21j
ZV9hbWQgc25kX3NlcSBhbWRncHUgYXRoMTBrX2NvcmUga3ZtX2FtZCBhdGggaW9tbXVfdjIg
a3ZtIGdwdV9zY2hlZCB0dG0gbmxzX2lzbzg4NTlfMSBkcm1fa21zX2hlbHBlciBjcmN0MTBk
aWZfcGNsbXVsIHNuZF9zZXFfZGV2aWNlIGdoYXNoX2NsbXVsbmlfaW50ZWwgY2VjIHNuZF90
aW1lciBhZXNuaV9pbnRlbCBtYWM4MDIxMSByY19jb3JlIGJ0dXNiIGNyeXB0b19zaW1kIGJ0
cnRsIGkyY19hbGdvX2JpdCBzbmQgY3J5cHRkIGJ0YmNtIGZiX3N5c19mb3BzIHJ0c3hfdXNi
X21zIGdsdWVfaGVscGVyIHN5c2NvcHlhcmVhIHN5c2ZpbGxyZWN0IGJ0aW50ZWwgcmFwbCBz
bmRfcm5fcGNpX2FjcDN4IHN5c2ltZ2JsdCBpbnB1dF9sZWRzIGpveWRldiBtZW1zdGljayBj
Y3Agc291bmRjb3JlIGJsdWV0b290aCB3bWlfYm1vZiBrMTB0ZW1wIHNuZF9wY2lfYWNwM3gg
Y2ZnODAyMTEgZWNkaF9nZW5lcmljIGVjYyBsaWJhcmM0IG1hY19oaWQgc2NoX2ZxX2NvZGVs
IGlwbWlfZGV2aW50Zg0KWyAgNTg0LjM4ODcwN10gIGlwbWlfbXNnaGFuZGxlciBtc3IgcGFy
cG9ydF9wYyBwcGRldiBscCBwYXJwb3J0IHJhbW9vcHMgcmVlZF9zb2xvbW9uIGRybSBlZmlf
cHN0b3JlIGlwX3RhYmxlcyB4X3RhYmxlcyBhdXRvZnM0IGJ0cmZzIGJsYWtlMmJfZ2VuZXJp
YyByYWlkMTAgcmFpZDQ1NiBhc3luY19yYWlkNl9yZWNvdiBhc3luY19tZW1jcHkgYXN5bmNf
cHEgYXN5bmNfeG9yIGFzeW5jX3R4IHhvciByYWlkNl9wcSBsaWJjcmMzMmMgcmFpZDEgcmFp
ZDAgbXVsdGlwYXRoIGxpbmVhciBydHN4X3VzYl9zZG1tYyBydHN4X3VzYiBoaWRfZ2VuZXJp
YyB1c2JoaWQgaGlkIG52bWUgY3JjMzJfcGNsbXVsIHI4MTY5IGFoY2kgbnZtZV9jb3JlIGky
Y19waWl4NCByZWFsdGVrIHhoY2lfcGNpIGxpYmFoY2kgeGhjaV9wY2lfcmVuZXNhcyB3bWkg
dmlkZW8gZ3Bpb19hbWRwdCBncGlvX2dlbmVyaWMNClsgIDU4NC4zODg3NjJdIENQVTogOSBQ
SUQ6IDE0NzAgQ29tbTogZ25vbWUtc2hlbGwgVGFpbnRlZDogRyAgICAgICAgVyAgICAgICAg
IDUuMTAuMTQ2LXJjMSsgIzEzOA0KWyAgNTg0LjM4ODc2M10gSGFyZHdhcmUgbmFtZTogTEVO
T1ZPIDkwUTMwMDA4VVMvMzcyOCwgQklPUyBPNFpLVDFDQSAwOS8xNi8yMDIwDQpbICA1ODQu
Mzg4OTE0XSBSSVA6IDAwMTA6YW1kZ3B1X2RtX2F0b21pY19jb21taXRfdGFpbCsweDIzYjkv
MHgyNDMwIFthbWRncHVdDQpbICA1ODQuMzg4OTE4XSBDb2RlOiBiMCBmZCBmZiBmZiAwMSBj
NyA4NSBhYyBmZCBmZiBmZiAzNyAwMCAwMCAwMCBjNyA4NSBiNCBmZCBmZiBmZiAyMCAwMCAw
MCAwMCBlOCAxMyBlMSAwZiAwMCBlOSBjZSBmYSBmZiBmZiAwZiAwYiBlOSAxYSBmOSBmZiBm
ZiA8MGY+IDBiIGU5IDhiIGY5IGZmIGZmIDBmIDBiIDBmIDBiIGU5IGExIGY5IGZmIGZmIDQ4
IDg5IGM4IDQ0IDhiIDg1DQpbICA1ODQuMzg4OTIwXSBSU1A6IDAwMTg6ZmZmZmFlMjMwMWJi
YjkwOCBFRkxBR1M6IDAwMDEwMDAyDQpbICA1ODQuMzg4OTIzXSBSQVg6IDAwMDAwMDAwMDAw
MDAwMDIgUkJYOiAwMDAwMDAwMDAwMDA4NzBhIFJDWDogZmZmZjkwMjY4ZTM3ODExOA0KWyAg
NTg0LjM4ODkyNF0gUkRYOiAwMDAwMDAwMDAwMDAwMDAxIFJTSTogMDAwMDAwMDAwMDAwMDI5
NyBSREk6IGZmZmY5MDI2ODY2NjAxODgNClsgIDU4NC4zODg5MjZdIFJCUDogZmZmZmFlMjMw
MWJiYmMwMCBSMDg6IDAwMDAwMDAwMDAwMDAwMDUgUjA5OiAwMDAwMDAwMDAwMDAwMDAwDQpb
ICA1ODQuMzg4OTI3XSBSMTA6IGZmZmZhZTIzMDFiYmI4NTggUjExOiBmZmZmYWUyMzAxYmJi
ODVjIFIxMjogMDAwMDAwMDAwMDAwMDI5Nw0KWyAgNTg0LjM4ODkyOV0gUjEzOiBmZmZmOTAy
Njg2NjYwMDEwIFIxNDogZmZmZjkwMjZjNTU0MDYwMCBSMTU6IGZmZmY5MDI2OGUzNzgwMDAN
ClsgIDU4NC4zODg5MzJdIEZTOiAgMDAwMDdmZDc5ZWEyYTVjMCgwMDAwKSBHUzpmZmZmOTAy
OTdmNDQwMDAwKDAwMDApIGtubEdTOjAwMDAwMDAwMDAwMDAwMDANClsgIDU4NC4zODg5MzRd
IENTOiAgMDAxMCBEUzogMDAwMCBFUzogMDAwMCBDUjA6IDAwMDAwMDAwODAwNTAwMzMNClsg
IDU4NC4zODg5MzVdIENSMjogMDAwMDU1YWNhOGFlMmZlOCBDUjM6IDAwMDAwMDAxM2I5MDIw
MDAgQ1I0OiAwMDAwMDAwMDAwMzUwZWUwDQpbICA1ODQuMzg4OTM3XSBDYWxsIFRyYWNlOg0K
WyAgNTg0LjM4ODk1Nl0gID8gaXJxX3dvcmtfcXVldWUrMHgyYi8weDUwDQpbICA1ODQuMzg4
OTYxXSAgPyB2cHJpbnRrX2VtaXQrMHgxNTMvMHgyNjANClsgIDU4NC4zODg5ODNdICBjb21t
aXRfdGFpbCsweDk5LzB4MTQwIFtkcm1fa21zX2hlbHBlcl0NClsgIDU4NC4zODg5OTZdICBk
cm1fYXRvbWljX2hlbHBlcl9jb21taXQrMHgxMmIvMHgxNTAgW2RybV9rbXNfaGVscGVyXQ0K
WyAgNTg0LjM4OTE0MF0gIGFtZGdwdV9kbV9hdG9taWNfY29tbWl0KzB4MTEvMHgyMCBbYW1k
Z3B1XQ0KWyAgNTg0LjM4OTE3MF0gIGRybV9hdG9taWNfY29tbWl0KzB4NGEvMHg2MCBbZHJt
XQ0KWyAgNTg0LjM4OTE5M10gIGRybV9tb2RlX2F0b21pY19pb2N0bCsweDliZi8weGFiMCBb
ZHJtXQ0KWyAgNTg0LjM4OTIxNl0gID8gZHJtX2F0b21pY19zZXRfcHJvcGVydHkrMHhhYzAv
MHhhYzAgW2RybV0NClsgIDU4NC4zODkyMzddICBkcm1faW9jdGxfa2VybmVsKzB4YjMvMHgx
MDAgW2RybV0NClsgIDU4NC4zODkyNjBdICBkcm1faW9jdGwrMHgyNGIvMHg0NjAgW2RybV0N
ClsgIDU4NC4zODkyODBdICA/IGRybV9hdG9taWNfc2V0X3Byb3BlcnR5KzB4YWMwLzB4YWMw
IFtkcm1dDQpbICA1ODQuMzg5Mzg3XSAgYW1kZ3B1X2RybV9pb2N0bCsweDRlLzB4OTAgW2Ft
ZGdwdV0NClsgIDU4NC4zODkzOTJdICBfX3g2NF9zeXNfaW9jdGwrMHg5NS8weGQwDQpbICA1
ODQuMzg5Mzk5XSAgZG9fc3lzY2FsbF82NCsweDM4LzB4OTANClsgIDU4NC4zODk0MDVdICBl
bnRyeV9TWVNDQUxMXzY0X2FmdGVyX2h3ZnJhbWUrMHg2MS8weGM2DQpbICA1ODQuMzg5NDA3
XSBSSVA6IDAwMzM6MHg3ZmQ3YTNkY2JhZmYNClsgIDU4NC4zODk0MTFdIENvZGU6IDAwIDQ4
IDg5IDQ0IDI0IDE4IDMxIGMwIDQ4IDhkIDQ0IDI0IDYwIGM3IDA0IDI0IDEwIDAwIDAwIDAw
IDQ4IDg5IDQ0IDI0IDA4IDQ4IDhkIDQ0IDI0IDIwIDQ4IDg5IDQ0IDI0IDEwIGI4IDEwIDAw
IDAwIDAwIDBmIDA1IDw0MT4gODkgYzAgM2QgMDAgZjAgZmYgZmYgNzcgMWYgNDggOGIgNDQg
MjQgMTggNjQgNDggMmIgMDQgMjUgMjggMDANClsgIDU4NC4zODk0MTNdIFJTUDogMDAyYjow
MDAwN2ZmZjA3OWNiMDkwIEVGTEFHUzogMDAwMDAyNDYgT1JJR19SQVg6IDAwMDAwMDAwMDAw
MDAwMTANClsgIDU4NC4zODk0MTZdIFJBWDogZmZmZmZmZmZmZmZmZmZkYSBSQlg6IDAwMDA3
ZmZmMDc5Y2IxMzAgUkNYOiAwMDAwN2ZkN2EzZGNiYWZmDQpbICA1ODQuMzg5NDE3XSBSRFg6
IDAwMDA3ZmZmMDc5Y2IxMzAgUlNJOiAwMDAwMDAwMGMwMzg2NGJjIFJESTogMDAwMDAwMDAw
MDAwMDAwOQ0KWyAgNTg0LjM4OTQxOF0gUkJQOiAwMDAwMDAwMGMwMzg2NGJjIFIwODogMDAw
MDAwMDAwMDAwMDAwYyBSMDk6IDAwMDAwMDAwMDAwMDAwMGMNClsgIDU4NC4zODk0MjBdIFIx
MDogMDAwMDdmZDdhM2VjYjBlMCBSMTE6IDAwMDAwMDAwMDAwMDAyNDYgUjEyOiAwMDAwNTVh
OTY1NWQyOGQwDQpbICA1ODQuMzg5NDIxXSBSMTM6IDAwMDAwMDAwMDAwMDAwMDkgUjE0OiAw
MDAwNTVhOTY0OTI2ZTkwIFIxNTogMDAwMDU1YTk2NTVkOGNlMA0KWyAgNTg0LjM4OTQyNl0g
LS0tWyBlbmQgdHJhY2UgNmQwMGZmYmEwZGM4ZWIxOCBdLS0tDQoNCg0KdGhhbmtzLA0KLS0g
U2h1YWgNCg==
