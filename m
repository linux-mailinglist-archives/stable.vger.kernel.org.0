Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ED8F855C571
	for <lists+stable@lfdr.de>; Tue, 28 Jun 2022 14:51:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234654AbiF0Qi0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 27 Jun 2022 12:38:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37676 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239250AbiF0QiZ (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 27 Jun 2022 12:38:25 -0400
Received: from mout.gmx.net (mout.gmx.net [212.227.15.19])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EC979B858;
        Mon, 27 Jun 2022 09:38:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gmx.net;
        s=badeba3b8450; t=1656347901;
        bh=yd22nbeWjoHI5mPQLuBmGHFqp7xWncZwRwI9JVbyqGE=;
        h=X-UI-Sender-Class:Date:From:To:Cc:Subject;
        b=b8tQbookbrnDkzUPpy1yCTH+YHcnv3PTTUgcNB62ISoRi13YXVlJSJFYcLI/J6BSQ
         /YL9OfgL/SX8rI2BrrzpZR2tx2v7yN1yVBdRpTg+EKxT5Osn0G/n6pPVtKNTRFeQF0
         anmOe2Z+MkqEEKkDu9ec0BCsN/R9weUS+maBhD58=
X-UI-Sender-Class: 01bb95c1-4bf8-414a-932a-4f6e2808ef9c
Received: from [192.168.100.20] ([46.142.34.201]) by mail.gmx.net (mrgmx004
 [212.227.17.190]) with ESMTPSA (Nemesis) id 1MulqD-1noL2E0Voh-00rrdd; Mon, 27
 Jun 2022 18:38:21 +0200
Message-ID: <49e7b2de-3fac-70f3-5607-a0c511b13fd6@gmx.de>
Date:   Mon, 27 Jun 2022 18:38:20 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.10.0
From:   Ronald Warsow <rwarsow@gmx.de>
To:     linux-kernel@vger.kernel.org
Cc:     stable@vger.kernel.org
Content-Language: de-DE
Subject: Re: [PATCH 5.18 000/181] 5.18.8-rc1 review
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:qAzEVzOlHfMBpYVB8i8dviaOgdIQGYytRRtrHnHuYC1Yb6F1HUH
 tgK56CDqMMtiVoIe85p4Muwi/kolyUBnlL8NWLMp/DCuVoI+84eP18sRiZK06brgg069Z7g
 hq+yb0e1LfWXvOcoBGl3MOh8yOxx6ifGxeNOSc33OMQDB0ooOLJDYb+ZSLIhMsu5LluIMCJ
 wE1VDm0/JjSmgViI4z7dA==
X-UI-Out-Filterresults: notjunk:1;V03:K0:YtcChZPsR04=:ntYZcw5nFwRHwnwVlAoUF+
 XoDBv2QJFMzizlOx+1pQ3QqMDTk5k+XmPVDxcUpiVEzh6W93T97HzPHmTH3GFCT3jf+/uv3cO
 r7qxG42gmVIq/cxLYr6tJz6beA7UL83ehanStm8n/SpcBtgH4ptnN3WF06FVRaABGek2iCjHU
 NVF2rpJAq3CFOjie7h13TBPu8fZu5QjrWmW1DofHZpIwrPdJ8zpABEL3KLf52QCE6MaHukPQ4
 +lFpavcT6l0G7R1jraS3uxSrepbz392WrzDLhEF0xeuVeqK/vJnjVIqlXUpg1RKqxtn5jfmnB
 eIx6lsxrqFsPo18De3EzBS0aa3bTFcmYgS5JOo297kMbJTCbC+VklpbQaqP7euGaazq839ipW
 uRRPXUVZEIeT4Ec0dkjzRm96T3oJqfG57AwrfwtqMUirzus95asLlNQNpWlQ62US15satmL2P
 l/y1898LtniJATMkYqltLZISh/8fCyjwUguu6xIizIn3214vjfwVkd8Nys5H8U8x0mc7JCFMI
 gC+hEojgNcjK6yaGI/a8EByA9dUElbtIMNk6+VPNP6eyQLsZdp1C6SyPofawZGWH04Nsnn5NA
 MoFLdmOvBxSe5U1r5MCaJGV2cMGRCu2ZQt4ZKUuaTp8EnbfIg8HMHctNKoVyzZopbL1R2a1F8
 Slp0KsoIOV856FF9ijYguUQtEsLiFfpjHdBvFkf2z+SRfoXfa72MNmEOHCMEeD538esSVK2wj
 Omswd9Onqb60Vt108o4OiYHnAw1yHTVSBy16Rdw74RIfTe4nPoad00NgGlPhktLEzxjyyOR3+
 M7XXhd7fthoY1TLgf2Bn3vBfaqUoqgC2ZSj8c55cBAHnKQBTzbJ8jzAVAzjP1ICUKcogY5Qqt
 Cun9RQqlpyGDgYG2DVkY0wHLL1Fwlr5ARH4/FKZL++PsiMZTvbrcrk0vqawYcJzyA9ieUu/+X
 uZNmfMyhBsIaGK5ItvESOItgYEe3SiLeFw8HywIDuENk+WA9TrKGjCJrD/3jsdfkqwsIUQVsw
 Vca6YS1kFLumVuaHNVtzKuKdVYkwadXP2c9/wrh9Z+dNp63X2ygkoyfXS0Eim+oCaiYdoFB1y
 5Oix4S6+VyL8lVWx1OmNDs6zNW2ol9awZx/
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,FREEMAIL_FROM,RCVD_IN_DNSWL_LOW,RCVD_IN_MSPIKE_H2,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

hallo Greg

5.18.8-rc1

compiles (see [1]), boots and runs here on x86_64
(Intel i5-11400, Fedora 36)

[1]
a regression against 5.18.7:

...

LD      vmlinux.o
   MODPOST vmlinux.symvers
WARNING: modpost: vmlinux.o(___ksymtab_gpl+tick_nohz_full_setup+0x0):
Section mismatch in reference from the variable
__ksymtab_tick_nohz_full_setup to the function
.init.text:tick_nohz_full_setup()
The symbol tick_nohz_full_setup is exported and annotated __init
Fix this by removing the __init annotation of tick_nohz_full_setup or
drop the export.
...


Tested-by: Ronald Warsow <rwarsow@gmx.de


Thanks

Ronald

