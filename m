Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3FD846CC6FC
	for <lists+stable@lfdr.de>; Tue, 28 Mar 2023 17:46:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234081AbjC1Pqb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 28 Mar 2023 11:46:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57706 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232318AbjC1PqB (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 28 Mar 2023 11:46:01 -0400
Received: from mout.gmx.net (mout.gmx.net [212.227.15.18])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4E29E1732;
        Tue, 28 Mar 2023 08:45:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gmx.de; s=s31663417;
        t=1680018342; i=rwarsow@gmx.de;
        bh=AVqTupIuF0Oe7Envzrxpf56pyUWiQ3k2WptTwa6aK8o=;
        h=X-UI-Sender-Class:Date:From:To:Cc:Subject;
        b=riN7WUkzb2sL+S6R3+mbCgYx2HFUve3p3+skD5QvubOUJl4wEER/obPToFXbmhQKv
         DjIMhdZOZQs/vKNIQdLZ24X8JT8lHgAUzbiAOCJuSxmsv+b4bQuidCHyiJEEMA7Ljd
         /QMwy5A7TAplNeEFQkeRqspbCmbj8oz+zQnra09Mdfj3vfPtcmGzAoKSQ0zi/ZRUla
         BHfYJMu/XystaW44saZseMFovT0fARFL/kkAPYnkDQvQO0qFaGsXvvTG2vnbGSPGtJ
         Lota2oQJ/iPNwOkKXWupxtEPxFeBaSTkoHqwiEjBa3ea7s8lrG2br5ghVI/eWMKEKj
         LFmsQtX9dx7SA==
X-UI-Sender-Class: 724b4f7f-cbec-4199-ad4e-598c01a50d3a
Received: from [192.168.100.20] ([46.142.34.186]) by mail.gmx.net (mrgmx004
 [212.227.17.190]) with ESMTPSA (Nemesis) id 1MfpSl-1qMqrf0qJl-00gHAI; Tue, 28
 Mar 2023 17:45:42 +0200
Message-ID: <0870ffb5-6ef0-e578-6597-6559f8469762@gmx.de>
Date:   Tue, 28 Mar 2023 17:45:41 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.9.0
From:   Ronald Warsow <rwarsow@gmx.de>
To:     linux-kernel@vger.kernel.org
Cc:     stable@vger.kernel.org
Content-Language: de-DE
Subject: Re: [PATCH 6.2 000/240] 6.2.9-rc1 review
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Provags-ID: V03:K1:uXK7CRPwQICl44qIc3v+nm+Ho0Fbvu2pLNm/JlmXRJN/G95dlwv
 wHn/ldWoEK6zvan4BEm16zejIf+zYE0M1fJYkLEuMVZSXPxVPnL3imhrXNrXvtfkYPA+iu0
 FLehiE6jTKcZxqOrzcV4m0H/1kUa84k/EqstHp2dHeAZFwdJL4fC1xq8DWvo5fQ5PFhCKGn
 Y47usVtVpv8LmaQvctxVg==
UI-OutboundReport: notjunk:1;M01:P0:3U3xmf5yfLE=;U3Lym5yyOChfw88DWDbL0EcobHA
 xThuw7TtPt+WF2/gSQ7FLZOTKPCEdl6Fc04Nwmsey9Wad0tygm7xjuFEuv3OjifTIhw0TohA1
 R5oZ4ksOSmu0mbec00mUxPXFBGYXNFXNePkxvM+OBhpqOH4gahZRaIPnsHTUmWy02z8F6vNBI
 y3aJ1vCKGyA/taKyhSBQ6J3XA1MtmEi8nuf3qI5M62nopPPpVQGt0qWnYsR2JJ2ciEDN7dsAW
 SMN0EamfixWNwqhIC7eo+UuSaDA7RGtPeuyvJkL1akA6hKUFSW/RjIj+PGyRhxkvusx/18l0U
 F0mI5Yjs7ti/nG/iewMfT0WA+Tl+X+n9Cd9doBeHXKo2Ilwx8puKhWiqdUtuF5Rmjw019AVGM
 ExSS4CGmAZB8Whe6zeE3vcyzmY5WQPpHcj9ZfpdQB4UnSrq0phPVt+Z0hIkkorobFznfoh2tJ
 JjT/HRpr+T5A8DOmI3l+CF7M3aG/Pl9NoBu//tSqYDrohzfOZSeeEcRgbmIrAmu/4cEy4n6Ck
 fGUjVPve5YTKWzmisPK3vZOP/4EHemWJ8+O+xxi+PqWdpkm3akuak04ZhctuH9k+EPH7Ypc1y
 n5y/mfdaAYzsBjdR4ztOgkLU9DZ0bzjC1nBK+t3a2o3iul530ZYA2aXjN518CRtOXUFKspnqN
 rF3MkpeIBTEKUwTdgl5j0RL+DvzHh66Tnq0w5DvkYYbKyfEs9GSm3CtOVJAUZEvmbOgMVQvg/
 9lBvBqRgm/M25Mpgmp0190cdKY3DnJGNvIkSH10o9Jn8VBXnep9/vnt47t89xn1sUDTBWn/56
 Y+udd462h6IH0aoXl907wFGFHfxypmyNCsAM2NNYoYUiep/EiEyzkDDsPTNKGUPxqKSb8HOV0
 i/dhABztoUrXqaYcMfj0BBiXmxMLVkSCSXmsSutAXFer7UzTmnTwHC/uUFUAiYJC9LQVAtEUr
 kkXDnQ==
X-Spam-Status: No, score=-0.9 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Greg

6.2.9-rc1

compiles, boots and runs here on Intel x86_64

Thanks

Tested-by: Ronald Warsow <rwarsow@gmx.de>

