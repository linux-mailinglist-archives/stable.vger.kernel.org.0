Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AA779638E1F
	for <lists+stable@lfdr.de>; Fri, 25 Nov 2022 17:15:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229903AbiKYQPG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 25 Nov 2022 11:15:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60726 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229564AbiKYQPG (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 25 Nov 2022 11:15:06 -0500
Received: from mout.gmx.net (mout.gmx.net [212.227.15.19])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C0F464A58C;
        Fri, 25 Nov 2022 08:15:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gmx.de; s=s31663417;
        t=1669392903; bh=qpnvahsb1gH6U2pwNTu5bAtWc/gJIzd4bOInlsusqys=;
        h=X-UI-Sender-Class:Date:From:To:Cc:Subject;
        b=sCJ51OImfYC8k2G89c5/jjw6B1A/ABQQXGLTzZog5Qe6Hbjz4j+iQ5kTteeMyCiSD
         VCrNDiajuOkF9KvMQALTIXAbhZRhktOLkIYZk4dpBzo4h1VvOFpFJVX1JAjEhTy8zg
         plWh8BiyVYKjRWkQKAPiBVUthnqqHvP3Y7XpEpD3wAdgOgSI9VodPhqOp6NoWHO0lk
         METzI0aHheCLsgurKxnNHfw74UxM0Ij1vDHFRZFgYu67v0dm8qU0+9Kn9MgRhWDV29
         4QjjbCMPznY1UiWWobdcKKLJyISbJt97jy0NEpWUF5TSFo1+9Tkj2hvWs4mjvqE8wi
         /mgb7b48pQmBA==
X-UI-Sender-Class: 724b4f7f-cbec-4199-ad4e-598c01a50d3a
Received: from [192.168.100.20] ([46.142.34.128]) by mail.gmx.net (mrgmx005
 [212.227.17.190]) with ESMTPSA (Nemesis) id 1MGhyS-1pCKc048wc-00DlOn; Fri, 25
 Nov 2022 17:15:03 +0100
Message-ID: <1202a038-2aff-9231-70c5-0674fc79b57d@gmx.de>
Date:   Fri, 25 Nov 2022 17:15:02 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.5.0
From:   Ronald Warsow <rwarsow@gmx.de>
To:     linux-kernel@vger.kernel.org
Cc:     stable@vger.kernel.org
Content-Language: de-DE
Subject: Re: [PATCH 6.0 000/313] 6.0.10-rc2 review
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Provags-ID: V03:K1:buFftNzx751lcuZQtIicgegnH4dAcU7/c+7bt0vgUa96Vm8NH2S
 sBwwTVJZ+4ccZIul47whOFK5CfVSgRyiN3mSk9TfHJDSHJuZZKQbTWLVKRVeLGhr/oMf9Vq
 kbsLmmrKdjDtXXolqxzR2buodl+JI6bmCm6TDvywOlT5x6bzP3L5uvNsb3zL+dU31EzMrAO
 oO+sUAq+xtS+QPe/uZ1xQ==
UI-OutboundReport: notjunk:1;M01:P0:a/ogCoMootY=;n2ZQRMuBU7k6V/eXhaROQqJynoM
 p3c8EwizTVxT9fxKqyriBsbuMxAXO13wFfGf7IEy73feB/yAS+j2+zSjLSIVxFFP1ibodEREJ
 x5dtdittij6GmWyjTGsWDIuI8Jw9MG4pIT3EtjqG3qhQ7cAPGrAy/C8gXY45REFEB+WMNZaAM
 3o06qExExzIeJO2ZOHyA5GwXfoz4dXXO+xpcEZFu5LUNOUVWfhFHjDPd2pgpdNTgCHjXg83mh
 PFr3DeVQXtSKjopjWduEHwkLQMHD1cyzNhBPhObkBxpE7CFvihUrVdFyU/aXhKo60sdVrBFXS
 yPo7MBI5a63k26uJUs9ZTRftWw+StySMPfhtt3PIqJf3s9tstjBfAzuh/wOvVPgB62tZI6EuY
 jnERDgzXRhBVQAd+71RbXNR8KudU5z4jYLoRizqv5jirZyaa+7E/5vPVc2vkwYubGVAUjxsSE
 qnHc4Z1dnibQYXw1TzBUodqTTk/GwgYCtLYP7ekWpq/PE7tvDoe1MIw/0cJNBSC6YiqZ3S95w
 QJ2D9P05PC9teYVJxR1/YIptCmu/0gTyoMTHEU3xXNK5EXItIq7L9lavpHu4eeroNXccJjdTB
 H4Wk3M2yuyXRm2YMSxKz4sW6GNdWSJjxHUKiIZ39TMCnv+z88VPIvidWf5LYa69l/xGWDFegZ
 fkJKSfE5D6l2T0Il8IPkCgPQtrBW54SZEOA/HCUOM+MfIumJLRvwMDxTtOiXhyKRvmszYMLzF
 5iE2Wg0ABR5IJxuk1di9vWVpg1QNze0XW2UcGcSxN2P3iMuilh8RBa02usQVSPRuUmvkwcX2F
 Ao4BRPO3WcyQ/dVihBSM7jVxKm1L8z0lwZbJMh0EA5/n0rqjbpX/eUAAsOB2i8H6fA+2AVBoZ
 ax4H0eGVTuQJ/PYTZJRrnn2r0pAtvVEUhBTUVdH98JvozweXV0wyn6/XmcLY23OwcHyBf9mT6
 N0VFSSonukx8SPEjpAoeab4dB44=
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Greg

6.0.10-rc2

compiles [1], boots and runs here on x86_64
(Intel i5-11400, Fedora 37)

[1]
no rtc_wake_setup error seen here

Thanks

Tested-by: Ronald Warsow <rwarsow@gmx.de>

