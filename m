Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CB1E24A9DED
	for <lists+stable@lfdr.de>; Fri,  4 Feb 2022 18:43:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235391AbiBDRn6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 4 Feb 2022 12:43:58 -0500
Received: from mout.gmx.net ([212.227.15.19]:43873 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230087AbiBDRn6 (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 4 Feb 2022 12:43:58 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gmx.net;
        s=badeba3b8450; t=1643996637;
        bh=U/c32utP3ktSCsK73GoR8A5dbuyq12FfNbI2MiDifL4=;
        h=X-UI-Sender-Class:Date:From:To:Cc:Subject;
        b=ZjgEQN8eM/8Vkwiz/vFaUad4TkIAh/1g52MNysYOILYOVozCOzd7um+BsuIj1fDUi
         tma+w2sVXGXOHQjyiEhkxgZaFad4KygWl6khXAG86EZ2EtAN+UzqJsBfBGMOqqrJal
         r0OnqvGINZl0gM7USoiiP+yx/5HNlvzLfVTEnpww=
X-UI-Sender-Class: 01bb95c1-4bf8-414a-932a-4f6e2808ef9c
Received: from [192.168.100.20] ([46.142.34.248]) by mail.gmx.net (mrgmx004
 [212.227.17.190]) with ESMTPSA (Nemesis) id 1M4axg-1nFUOQ3mcg-001hoU; Fri, 04
 Feb 2022 18:43:56 +0100
Message-ID: <08956dbc-d882-220f-9006-54a01aa41ef9@gmx.de>
Date:   Fri, 4 Feb 2022 18:43:56 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
From:   Ronald Warsow <rwarsow@gmx.de>
To:     linux-kernel@vger.kernel.org
Cc:     stable@vger.kernel.org
Content-Language: de-DE
Subject: Re: [PATCH 5.16 00/43] 5.16.6-rc1 review
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Provags-ID: V03:K1:7hKSxxMKkbBQipIIB+Ej7VWcKB2PVSV0ar70A57y/j03SbU7pkX
 ucBXZNZA06bKbT3E+2T9b4wnkS1Z2t22aWYw1qsgKf9aLwYvr67653IXbh9nUKu14bGoaIe
 ch0FVdOchZWisNPYOq03zIWwaure88bgZPNlbONuuEEQDYgXt5GV9xsdfe1S6Ehpbj8JYFF
 NnkApp5XhtgbPiX4+ZpBA==
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:EtLJI7msm2Y=:YCyGqRkCExfu5nsmdGrLtG
 DXkAbr3ZUcvO/8qGcYHB38re/TlbqDF9iSMjNusVW+aa/7CWWUn6HVIJu0VZko/vgvpB/DI6s
 S9TBcdyV0pqPNPAc0xCIX39o3BiFAF4olRS4qKDfhb3B1mEDbCFEGoRSxdyaszZmlmiIhhdkn
 wOtrWKA82/JM2qSMEJNuNTfWFhN8Lhj60puI64YB5Oe9mfQq0uSiqdXYnBGosPvjLeaNBRlWr
 53uChPSW3F96issM2cDrlZe/4kBS8oBqslN9fq7TQzYRXjpPLsfF8PmUfeL5SJyzXuPQZH4zr
 VAwe8+q8ErC6Cl6YjqroH6bDYidDSSCd1cet/6GU6r71TDCV5GpIFEwbZUEnicIvjH05Bvb6q
 XmZs3FIFPwb64KHj8yRMBCL00md+t324K1peFJsme9Ev8K01MUP+o+IQ7qmn+k0EoOCnpn1it
 B7Leh68BH852tlnqDX4teIyq9BkjpgJPpPtr1Pl8cTiwHfdWI7HQfxWHPcAtUmxos21P8vd9W
 QemztYmtTOOrUeNyrrQy+ZRYYGt5I9ZGWpkNAE0xXp7/S0x3NcV7HjeMPkPg83/Ni2Sp5d9pq
 MqfGk5/7Z24h8wh2z+PUSzly8QnQxtemYHdl/i2kebJUJ9LJmm8h9Z0jH93O0SAHmQkDYuxTE
 VHZXU8679AmXlRlWXDEf21xuBiutFA/OdHgs3ROlSnIvJpuMmcsrAAaPGiHyN5K9dmN81XHur
 xSUMOgxfAG8TtGtvOPS40CajjVeU99CWZgtSRqMEYlFjxb/EzxmkJhkzTWg9LpN9hKW223Gnz
 /tfoA0lAPwkEMRKmXyD6xqv3SXq+k942JXIaSAZNYOpwRyX7NM2ZJXhsgMSZcQjr6i4XShXkk
 BypXWyhr5vEj1R4CRTBgykYgLLOrQLh3u7slUdp9lHud/etr2Fvs+ygtpaUBx7zrWpw6llr3z
 tg8if24FvzmikC+E+M7MgDhgMHs0vj5YT+jbM8Hr6C+3o6ii+nzTS3O/P0MX8pxzDa2+8bPjS
 cJRZT3DStklIJ7buWUegEt0yKhEMI86OGDBKXhyszfQ0NqCJh+7fO7LfkOsXBcn1FUEzLKUM8
 C//FD9KvO2occE=
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

hallo Greg

5.16.6-rc1

compiles, boots and runs on my x86_64
(Intel i5-11400, Fedora 35)

Thanks

Tested-by: Ronald Warsow <rwarsow@gmx.de>
regards
Ronald
