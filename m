Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DAE126371A1
	for <lists+stable@lfdr.de>; Thu, 24 Nov 2022 05:59:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229486AbiKXE7d (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 23 Nov 2022 23:59:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58678 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229495AbiKXE7X (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 23 Nov 2022 23:59:23 -0500
Received: from mout.gmx.net (mout.gmx.net [212.227.17.22])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6B6F85B854;
        Wed, 23 Nov 2022 20:59:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gmx.de; s=s31663417;
        t=1669265960; bh=psBO+i21VCwSK9h56JDgWkn2kNzroqWw4HGlKBjuHVE=;
        h=X-UI-Sender-Class:Date:From:To:Cc:Subject;
        b=PPpEK/LMbqSSI+Kg4Ujuc8lgCzkX1iOe2ZIFmPMA3YydBF4HdG2ywhjphCXMRDisv
         HooZjDHdBhvEIAOjrxHVvuH7NuD+DwbHhYvZd9+aztRU4jOUdtd/wbijy9IqM+JdVH
         6cCtlmtD9SoWV9qfcDqcTda0Y0HARZ1NIDv6EwQGyQTVjjMD9qHPZPyDmAe84FTNGR
         GmE0XvdYYfjuwRozzSmazixCdlauzi/LjksujGESh6L5g+qMClAswdLeIprA6F7ogc
         Qwp0OVDJO0RuKOXIjsdSUQC5ChQuj8cfMOFI+nRvSN5aRmtEbtH4Wtvdu0Q+8VqrmC
         VW3yNiSsedXSQ==
X-UI-Sender-Class: 724b4f7f-cbec-4199-ad4e-598c01a50d3a
Received: from [192.168.100.20] ([46.142.32.211]) by mail.gmx.net (mrgmx105
 [212.227.17.168]) with ESMTPSA (Nemesis) id 1N4Qwg-1p4yrO2zSw-011UAi; Thu, 24
 Nov 2022 05:59:20 +0100
Message-ID: <864c4420-2ebd-4b44-72c4-359c4949d819@gmx.de>
Date:   Thu, 24 Nov 2022 05:59:20 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.5.0
From:   Ronald Warsow <rwarsow@gmx.de>
To:     linux-kernel@vger.kernel.org
Cc:     stable@vger.kernel.org
Content-Language: de-DE
Subject: Re: [PATCH 6.0 000/314] 6.0.10-rc1 review
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Provags-ID: V03:K1:tFE/vUls/3xulMD1MFcKcEROOtvnbisINpq5fJlFwYi4Q1l3mvO
 wd63O22WSwDXNShkgYU4BewiAW/S/0tkixg01R4zGoF6PbejB8bpH3laec/B85szIrPKTRj
 f24xi979d+d0sdZMxvZ4IWuCLWgB9nRPRNiFzpn9XOGOGgvudwfUT+8TvuySLxG1EcS9OUk
 Meoy0hsgLyXYymYp8rYfA==
UI-OutboundReport: notjunk:1;M01:P0:V+Wd0Aw9HsI=;/HX76oIawC+68itqrQwD6z2d6U4
 4emGh5UEFi3ZfgfUH1eghD8ZBtTcgQjVE6ZhAX1QBZpK+sSr614doDxmmuTZ9se3SFdJe9twS
 MX+2EhsAPoCP7VbbveeYljhLo4yHHgjua7i5OxfLmSihWk0jnLLUvr1E3w47izRy+UEeIS/he
 KEborZi9lIEXqhHRN/rI6XTIUtCJaB0nMjuDfx1cLRrgjqT+AkplNfDiFOGUs8bNsQf4uzrEZ
 q8uwzSVDVHq7Sesa0CpYbKXRyLOexh3z7h2v0spXz68c0Duu+8bXFXfbiq7YzUrDF07asB2ER
 +2rcIxUNBgw6mjd0TWU5beVTAvtOtA4FNUX0ltJAnkKwVd9HET3D9REdZdkVxVkBiaLkwOpla
 XkrKRKthFOiH8Ikop7ENZ8pPmPuYsayqugqgp59AFRK+qKWuBYFxkWcPusO5fCmJECwujkuKe
 SR8Ia6mbMdCt+tA456UcQmIJVlGoKnM0kLSR79cBHwgUisT6apz/U6vlUPgoadnC0VH07Y1yh
 r6ZVTYIQph3vOfBtqRuPBz+WqoVgsAD+kZwaJZMvu690oTbtiS+SqnxoPctiVNwVHiJfF1kUi
 4VyZ0kihBZR/zjAQM0lIBma8WByZZo3CzNdd4HvW4shsgsR6qRBBa2cnJduu79PjDrIVycweU
 INqs/xYGkml03cvPmCxB5h6+Paao+ylpIRc2B8YQRRn5dAtL6E8S1o9/VmixEz0csUBPndPcu
 OorqJ4T8C27F8lZgeW5M6cJ7ydfWFUxT7nmsmoGrFrtwounCx+oiEoTJSYPxrC3vMaTDW2zI7
 5YP85wPRCTTfp3q0yRNhTFcKzP7PdPjbegTVJYV9AZbMKaAv2PJfTEwNGY/EUi1B6lB1jLbcn
 WvMiJLqk4gxsTkLk5FGYFMmng795ehuVqSfGDsBG7qN79TPF9O+tY2vQMizMwmQSZxRAvUPeW
 TiuPxQaIjglOouiLNVjqZbwXTU4=
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

6.0.10-rc1

compiles, boots and runs here on x86_64
(Intel i5-11400, Fedora 37)

Thanks

Tested-by: Ronald Warsow <rwarsow@gmx.de>

