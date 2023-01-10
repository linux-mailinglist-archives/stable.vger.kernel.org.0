Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D392E664C8A
	for <lists+stable@lfdr.de>; Tue, 10 Jan 2023 20:33:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231524AbjAJTdv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 Jan 2023 14:33:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39972 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231482AbjAJTds (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 10 Jan 2023 14:33:48 -0500
Received: from mout.gmx.net (mout.gmx.net [212.227.15.18])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 77947DAC;
        Tue, 10 Jan 2023 11:33:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gmx.de; s=s31663417;
        t=1673379224; bh=t3UQH8u9eU8QITjj4Cqptb7FYw13LIn6f7gWo3yaXXo=;
        h=X-UI-Sender-Class:Date:From:To:Cc:Subject;
        b=uAKDMh3H3AMNcHF8vHkpLOtsydnZKSRXvjUsi6VBEJJCqR9FPFx0vs8S+VfodSiAu
         2PBpf5xG1g/FBzc02uiHgKfIN8vzm9QTjCBmbAsfo7VCtfCHSjrqFEUymCF108YvGi
         kl2LX6f4kvMjHSwsisVqcNA3ZIFNLvuhBOnhq3y4yIbJ2N5YlrQj5qeKoq8E+YWy0m
         orMrURMuiHPA+NIyIXexiQ8HMl1C4hnkltn7t84OfErqtICvivxZtGukjgPZOC5Q9s
         l3tZeIHC0LGAFaJvD3IcWir/iKT4ZncC5iQ0eCxvgM2IsQEFCLhoZtoy61TNzEznCU
         BQiBuvWGpxOZQ==
X-UI-Sender-Class: 724b4f7f-cbec-4199-ad4e-598c01a50d3a
Received: from [192.168.100.20] ([46.142.32.247]) by mail.gmx.net (mrgmx005
 [212.227.17.190]) with ESMTPSA (Nemesis) id 1Mnps0-1oR5KE2w7m-00pP9Q; Tue, 10
 Jan 2023 20:33:44 +0100
Message-ID: <385b1f52-63e1-68e2-d059-ca4167041145@gmx.de>
Date:   Tue, 10 Jan 2023 20:33:43 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.0
From:   Ronald Warsow <rwarsow@gmx.de>
To:     linux-kernel@vger.kernel.org
Cc:     stable@vger.kernel.org
Content-Language: de-DE
Subject: Re: [PATCH 6.1 000/159] 6.1.5-rc1 review
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Provags-ID: V03:K1:xpCLfRAgEgN2duCVFWpFfoMS5fmfCLtIXNNNLCkBpC7mWVpMZOp
 XSPCZm7US6bvM5D2ZTMd38Eynie3gYIcd1Uq04PrIlR5VMdC6RallLx9X9adP+xptnabHeC
 5dykbScyLWVWyTwkM66rJ5UCutT/epB32oGlTU0J3LmLAVwVYMBRsUbo4sozWTyr6YlfrI9
 kjgLB6qJWADTm3rDBIE5A==
UI-OutboundReport: notjunk:1;M01:P0:pcy+NGDqngw=;h8N4sfNZB5eU8BCqTuPkyZV4Z33
 WX1DDOdfOMwr/t/YHk9Daxi3oatgo42DppXw7jJDeLVv6eV+mWDGAUqd/L4lSgntGs/UIjnJQ
 Sbb9KKqcXTT+ARIRqaLpIe/Aq4p+t5xvBFVD3vuvpZG6hXMHuVloWIXa8YqgzJ792qW/Tjqkg
 T1e968IgVjst+0Rj+E1a5TEFkqo/7bhCBNQuNPTPmWFkrotqWx+jp1qH3WD3ApdIRzpPDXxr/
 4fiNBfQXlIqeDlyDBQRFyXWwNKeVnJ+s31f4c2z/QrjBPR2OIxRA0YwNcm80Te0BB1hwhLOwv
 VHNgN5s28kAkTm7kNbTky8uOaz2haHn0jKeGAsQdPqe7eHzpZM+t7Pl1+tnaFfHhRKXVa2cVK
 D9Hafa3iOtAX1zkJgM1Za6zyOg5iSfCz74v60YSLrS0YZF+fwA9HtCfhIu73p5QS3nn8aT+ox
 NoIOKY30xSd4wzyO2RjGLuqnfbFs7acQUHnLymMIt2xAYDkPtnw/7CIMPakgSG3Fwmfht3D72
 GWhKy4DoRIhca0zSw2dl2NvE4CXLi7wFfc8XR6QLKIS4hxICW6htAVlRN3cBlYuTWppZEPQUX
 MLNdiSheFsX1ijBL741ZrFTwvzZYYG+IcVIyV4Glef9EMBTb3PHHsmon6gvnvjtgRG7HwJFf+
 hW7ZwHgM8fMWpurgpxb09ZzLDqPqHH8lL3oloc0NT17MIkRPNHDQHHtCYHU9/qSB8SHN4tP0x
 B1NrY4DvyDrwyYsBWTv/rD2F9svVGZsBSSF/6d5BTiFgsePN+VhYicAxmHV7Vehz1GbElnvnX
 hIi06pt42+lOdOEPmF1rW9F+X8xONgXQ15ol42oOX+lmjEShUDcFX9kmsNxVtfmXXrTARqYYY
 q34Sj5A/pUYv3rYWnR4FmPs7K4yp4iP0qFK9c2Fo6+K6cxx+VvCuOS+8/8nx90iBMkrqEOHB8
 38Fqlg==
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Greg

6.1.5-rc1

compiles, boots and runs here on x86_64
(Intel i5-11400, Fedora 37)

Thanks

Tested-by: Ronald Warsow <rwarsow@gmx.de>

