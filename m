Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 886986825EC
	for <lists+stable@lfdr.de>; Tue, 31 Jan 2023 08:54:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229787AbjAaHyT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 31 Jan 2023 02:54:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55610 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230273AbjAaHyS (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 31 Jan 2023 02:54:18 -0500
Received: from mout.gmx.net (mout.gmx.net [212.227.17.20])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DC39029406;
        Mon, 30 Jan 2023 23:54:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gmx.de; s=s31663417;
        t=1675151649; bh=mD8CL799/ivFKlFLLXZUVe+X80GvHc8yo2ph30a3qFk=;
        h=X-UI-Sender-Class:Date:From:To:Cc:Subject;
        b=H3E9fjzTJOvLaPG7uDuB1U/x6lt/GUk4eWscD0xFSyTP1lUkAQQE29oANo97f1/l5
         Y7Af0x2/GR9m49unhtGKeLD7By+n9CWvzfB/SiekpMq5vXv4TvwgQZwEdugxIDfHT/
         cnhKwfl7Ox/EWTopVmNYClGFeS/bYiAMfkb5Sc4tkuWszj43y9SWJ3MTIGooBRfqdm
         2Q/JjuGv7G4e0AO8YBoJXGLM4T14mDfuuhOVrSRzes/dft2rRgT4mjmP7V2qkwcKI9
         FB7Q7u5KtwraAOqG1u42iST1mOCTVyTc8/dgLzJl7fo68lpBYAuACb/bBe3bHmVJgs
         eyGsK6tpewCFg==
X-UI-Sender-Class: 724b4f7f-cbec-4199-ad4e-598c01a50d3a
Received: from [192.168.100.20] ([46.142.35.76]) by mail.gmx.net (mrgmx104
 [212.227.17.168]) with ESMTPSA (Nemesis) id 1M89L1-1pJCy33ehX-005KWc; Tue, 31
 Jan 2023 08:54:08 +0100
Message-ID: <4563b862-b0c0-390c-9212-89cf7f5d8e45@gmx.de>
Date:   Tue, 31 Jan 2023 08:54:08 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.0
From:   Ronald Warsow <rwarsow@gmx.de>
To:     linux-kernel@vger.kernel.org
Cc:     stable@vger.kernel.org
Content-Language: de-DE
Subject: Re: [PATCH 6.1 000/306] 6.1.9-rc3 review
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Provags-ID: V03:K1:xKjpXjn8WRt1KXFf5vhYf3zOCMmr6HzkCFOjNgQBovusylteV7G
 G4ff5Ag8BpIfp1CEbZoEkMCrBYyxifAMjfhXcBmqyO00Vv5tPawEiRBPSOGFRkSuIIQSTQo
 sd6rX16fw6zMiWtc92qship1cb6ySBKzdztPq24oEDtPJ0M1Yby8+xUT5Bww/mBnqni1tB0
 aB1g9QrOgaMtYd/e8tJTw==
UI-OutboundReport: notjunk:1;M01:P0:Vv5BOeygXSY=;rSG097n6EK0FtTY9LLA5zjyOU4l
 zEvMtmZBvmOFqiHa+GbLU1ZmfBOEwNGceOLq/CipUSX4b4Qiln85AFMDKHVu6Uo8qbB4awjqt
 9hEZ4Cd/cp8nB07uZPQiGA31ORRG6BCp0I2mNhsTn/aCwGi4rXRIAvk2N7r0US9cu4nWsDUbE
 CR3fYZBFr8MG/FDduzcO2tDfmnEHshyD+UMgZhcYWYlE1BO66JkKaSCh16k1tauBqEsx1sKxo
 bsZ4H8oLwKs8vETWSWWpy2UkFNShgdxx2m31+ACONotbRcpP7Y1Da15FKyIkKVrCZVp5okHxR
 jeL4Hzz+uhYibnAsCF/Uk8tBen4Kr3F2QKiMqOuj6bP0LFFf5uLlrNOUuP2wa1TMhItDq29Ay
 +yEmRoUFRcs+CyKG+Qq0/QUNJsA5BFxiAXLz6Gf/HobWJ4QV7j7yCtMDQYJvisD7PzQwNNMio
 s8MTz0eHdfER9yIlYd8OKgAjZ/deyfIUKmNMQFKc1g20k2ZLi6/17B+sf8pRKEldDesLifUcV
 chpzaf3320rU03LM58eaCt8XrQ1quY7Hovluv6NSKRtwq0At1dQoCTf6kmKvAqCH24OqbSsZW
 VwiXhrHbhG9a2kxZgKv8gwTEtNszJ5H8nE/YkfIiLEr18lhpaD2pcO9nUdKVrg0vdH5407SAT
 o9mhhby28hPqlcwX4P2oBj8mWpSEEs1h2eUazKukY85MGVLAKmIt/vHybYQPzx6MYBhBXglMX
 ze2ImfptGxcBHcPEIv9kP94LUNMrVyULT1YiR3L+frvfWMwqLZEW4OcEbJdsW6qyCBDO7ULlo
 ELxTjtqTp1PZbyJalFbM3O7mU0/txvSbk9FIcuBaPixu//k4hkTuBP7VmYL2DMAbVdpM0vreR
 PclvGddrsMqPiYwt77GZvm8Ls+Yb++u2n2plv+QKtiy8cXTwPco0sekL1JFe4P6U5TWxNjOLx
 QCN4dA==
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

6.1.9-rc3

compiles, boots and runs here on x86_64
(Intel i5-11400, Fedora 37)

Thanks

Tested-by: Ronald Warsow <rwarsow@gmx.de>

