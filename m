Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9EE2C5E6F55
	for <lists+stable@lfdr.de>; Fri, 23 Sep 2022 00:06:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229723AbiIVWG3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 22 Sep 2022 18:06:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49388 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229449AbiIVWG1 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 22 Sep 2022 18:06:27 -0400
Received: from mout.gmx.net (mout.gmx.net [212.227.17.21])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 54E8C10977E;
        Thu, 22 Sep 2022 15:06:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gmx.net;
        s=badeba3b8450; t=1663884384;
        bh=Z/teFEK9ZDVBvC0sxhw7pMJGKoRMgo+9Xm5hC04BvZE=;
        h=X-UI-Sender-Class:Date:From:To:Cc:Subject;
        b=PI+UePkUHOTKo7o+eIICXufBiv6wVnuMffMUVgvKrP/k/PG7Myx20yypjVBm0gsHv
         vEMoVlzO0a67gT05Ja0B/9V2E2SO7k/mQorZrXlWAZ6RvO8cXt02xiDzCbdZF0P1UY
         i3aS2EtOAEmumZqvZVlacX0+n0CCww9OR6IVvc0w=
X-UI-Sender-Class: 01bb95c1-4bf8-414a-932a-4f6e2808ef9c
Received: from [192.168.100.20] ([46.142.33.217]) by mail.gmx.net (mrgmx105
 [212.227.17.168]) with ESMTPSA (Nemesis) id 1MHXBp-1oXNjN0cAj-00DTt1; Fri, 23
 Sep 2022 00:06:24 +0200
Message-ID: <ce35cf44-756d-7606-4c1c-0b6130994831@gmx.de>
Date:   Fri, 23 Sep 2022 00:06:23 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.3.0
From:   Ronald Warsow <rwarsow@gmx.de>
To:     linux-kernel@vger.kernel.org
Cc:     stable@vger.kernel.org
Content-Language: de-DE
Subject: Re: [PATCH 5.19 00/39] 5.19.11-rc2 review
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:btTBDdIm+fB+Qgwpt7Zo4t2GGnI+vKrTf+t/oBgptncBSEhI4f3
 mzJDX3UEJCbulJWZWLYVYNbvZSYKyEO7Zb+zIYuCCA/scu6mAanY0t1iqV8xyL6LnSBv2eL
 Mg/5YcOYXf6EM3Ab5pwBYYTGGeQ+GEKSNvb6tE+KAZTewWd1b0J51tgVjiNVEckVmq0wINJ
 +MadDc+CWSZ0VTs9T3KNA==
X-UI-Out-Filterresults: notjunk:1;V03:K0:u+yxzBgMDm8=:043fBVep62VHiBeIPyIvrR
 9MTtnOYf7RKRx6PfpON1A334l1TKR+SqvNiY1hkXRuBrN2BWquwjsmqtaj0YiLf/K5vUqOR21
 YaFlf/sVnXTbq5LYpegLt+fQHHcf/EKiDxSoZWImHy5GLqW7D0PR9m6sRUCur90XYxVqg/UQi
 OE5Uk6g3rLSpGx/pJHqTHygjTUTA0KJupc0ctqo/jlfa/9Rgl4/9MD0NL4soeN9wzPYIsd1W0
 GJvA1qKJFILZ9h+KyWXpk6nklzu6OSedHCGVek8fzQi/TszXWpdnylAbZPhDRwh5pMtGo9ViG
 6OrkkpjMwFazmtu09V91GeIXeLIRBaZTmRAj5vdY0lsq/27EJYvXZo/e5/vJgC/lX89ehqvz5
 aq4J6sQm38MQuCswROls8tn2ZeQiejL+fY9J3pMtT6T1tFLkgCodNua1c5PIPe77CXh0SgkuD
 6O8NTN7cPH+zqm4PWBq/UpKJhC8Nfimc/oV1Jqv62Ltgkrxx70WR+GaWLLF6Px7+iXoPClK88
 mK/1NEgmSF50q3HS3Zh35zWYWU7MK72OmSZh+Q/riAzSZTMFRAbelCtIMAe+Ywejwx8HwOVcQ
 JVLSaXfugXmfFeGgXEUqpRJBKv7Kuhmahs0fwB58j6saDvwYudTfXB7UYRhhq8zhoUU1ZB76I
 gPn8ZYYXrcx0uWJJK03vV8ld1fAsXTlMeRoY1XZgmfIBFMvxjF+HIva662dPqbLNXccun51Bj
 vv2Fs9rYhpKgT5gSyFXyRKeSDaE7OG/Nv8DGEl0gDS+5DkRS9EQVq26nLUScnb6VOQ13qa24m
 pZB0LGk7HvkfGzRatyBbbNmybBoGRlnVNwtzeSdUs80oT79fgavF8wMWtTfjWV0xMRByIprHL
 q4EVB7OYNW2dzoJSB24D3HcqMtAznTnKTYTyoTDUGpa7Sg/4r17SN+VUMBWXCa3IQbVVfjF7k
 Z+0Hn6uWd7SGJT6JPWUcs2eCSj/si3moYHQMDw1oJeQexBH4TSex/t7xYuUAaYhoFUs4fnNez
 cvKFHJcnvK++q2i8kFb9179PMSq5jMebgQ4hTqo3aANigixZYyhDn5BM1fw+OvjKvltv2KWzv
 1/pYPZ5YCJdQpn6RdBcxngGspsJzL09sPW5ojdIB8Zbg4T5PPxSd9UqHhjHPHQZjzGGOI/8JX
 jN7vw=
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,FREEMAIL_FROM,RCVD_IN_DNSWL_LOW,RCVD_IN_MSPIKE_H2,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

hallo Greg

5.19.11-rc2

compiles [*], boots and runs here on x86_64
(Intel i5-11400, Fedora 37 Beta)

Thanks

[*]
I see the following

vmlinux.o: warning: objtool: entry_SYSCALL_compat+0x0: ANNOTATE_NOENDBR
on ENDBR

since 2 or 3 stable releases and in 6.0-rc6 too.
anyway all seems fine.

Tested-by: Ronald Warsow <rwarsow@gmx.de>

