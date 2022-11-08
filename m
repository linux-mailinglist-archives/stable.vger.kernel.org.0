Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CF5BF621AE9
	for <lists+stable@lfdr.de>; Tue,  8 Nov 2022 18:40:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234564AbiKHRkC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 8 Nov 2022 12:40:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40416 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233961AbiKHRkA (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 8 Nov 2022 12:40:00 -0500
Received: from mout.gmx.net (mout.gmx.net [212.227.15.18])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6F18D51C00;
        Tue,  8 Nov 2022 09:39:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gmx.de; s=s31663417;
        t=1667929197; bh=S3rF+pfBjLpz8Q9K3XfYcC+6WnQNrztthBp4ESHbh0A=;
        h=X-UI-Sender-Class:Date:From:To:Cc:Subject;
        b=TntNkcbdPHFsnq6JZOV59gK+XzEF4sZmoT6gmQXEwQjnvEwxoPZkdO9Ks6Tkk55d1
         k5IBSnH2kS5IA88Nc3VsL3loOSTJmkavH1RHCg6WL2Ey3BZ4wpyCAt9U/7tVCATXj/
         uBV+q5BIaF8T62XwQKNO4l3ttphpPm91K6ZvpMH1Qv1Pp5GnN8uFSUhElYqSdQhK1X
         A5Woq/X4qKN3Lkjr2TET9VvMIDZxmGLfpB9HCd0smCPBdGcVaEtJ7naamC5xcVS+RB
         n2NQkgGsoKCDfqBqOCLuAaND+ai87ZjtSYEA6AdMvcSvxI6MV2VqJGEuPPkSdnJtl9
         XmhcnCxWTb33Q==
X-UI-Sender-Class: 724b4f7f-cbec-4199-ad4e-598c01a50d3a
Received: from [192.168.100.20] ([46.142.35.29]) by mail.gmx.net (mrgmx004
 [212.227.17.190]) with ESMTPSA (Nemesis) id 1MQvCv-1og8Uc37x9-00NxZ7; Tue, 08
 Nov 2022 18:39:57 +0100
Message-ID: <2c38e9f6-382c-0bdc-78d8-c4e07cb2ca1a@gmx.de>
Date:   Tue, 8 Nov 2022 18:39:57 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.3.1
From:   Ronald Warsow <rwarsow@gmx.de>
To:     linux-kernel@vger.kernel.org
Cc:     stable@vger.kernel.org
Content-Language: de-DE
Subject: Re: [PATCH 6.0 000/197] 6.0.8-rc1 review
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Provags-ID: V03:K1:NI7BUi7f0GvjKAW3TwyeGNCvC7HjcRmcp8GvXLzA+Uv41f7NW9t
 t3JLRnuuV3eeqA0lPV4Zteaiw8AcXxhB9xCCuBKszFnMkZnw8r/WSI05j9mNkkbzzxZ9L5e
 HCEooO8PQny74nSGzBwPzRY9wm0EW82Tx5KNjc+vQTZSX14jTPsGr7T7Bp5QZfE1P/Q7NK3
 jWge4O0wXATZrFxgrfMLg==
UI-OutboundReport: notjunk:1;M01:P0:KhYwIgTVvbk=;4W+TSIoPN2TuKYnOrLd5TciZ2Zc
 keVmQX78eYDej7mx9rjbCQ0+ZL4qDsJY6MDD1gwJwFV1lM+bFq2nU7sF9astoui1Q/XHSVk4u
 wSaUU7nGji/WKvMeDp546cTgZV3J+ggMkPPLuG+lqyF9Y4XbwE4N/EQjm7VmNsnO0jkh21oAE
 FrT8T77ZjuAS8d1+1NxL9KYwRRnnPO8jCwDwHSiO1e7aO3cRkY7OARIglMZqttxFX8UcQDWcR
 0/XFXZ1e/GHPGcEImtvLql7VtZ2qq8WXXojr+XG4UphG5JCsxicT4iagcfoBhkiOMdb4Au+hN
 IwPR0fh/oRCZBV9jYNxi7nGnnQOCYJ9CwUCHw5QP1X3rBYSPhJ9ijLfh/FodLlvM0moDJA7yU
 UZTzPrFkjmD8oR3waoOl51PszJ4EzTX07vhhRhhjK99uubZYn4SztcfsASn5RpRm4MntZkEOc
 uRqe1TKDQqVIEvLB50uquhzq4CdATaA0fSesgY/8DetrVKwkfm1ucRvrh6zgW/gw6BUpGniW/
 GwLfYoMstmMJJYSKKEes1yJzRBjJye0UPe8umygV5/DV9dl/x3umGrMSq+Frww5AW/w8R2OHc
 J4CrdyY1VrpKhcE4ebH+FmAHEtjlJXJwG9QSTKOWU08wcpEJNoJwXcvkCeNPfZF5R1gb3Srpi
 YUk43P68ODGXOheW541L+EyDACSN5bXdEXSAVi2Lxa/cQvIWYRN3SvrJch8Xsr2J/r0mnTri8
 v7HemFNhdB2mIYADZR+QveNv3IulzBjN1lvHjkI8VcjAqf8K4VCCaXBSxaT1eMCHeNeaiSGKj
 pTAQhT1DqG00A2EsH0X+Dic0GUQwpei19+GiFwPD8JAQtHppOEYyT38oU9R0o0dNT4IQTyygf
 0u/nf4SxdZ10v0OCHX54pPLP/VGNeIzf4RcaYfVv5hXWIyxDIwaJSBFOZqrMCN9d1ABwghRUc
 g9DIbQ==
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

6.0.8-rc1

compiles, boots and runs here on x86_64
(Intel i5-11400, Fedora 37 Beta)

Thanks

Tested-by: Ronald Warsow <rwarsow@gmx.de>

