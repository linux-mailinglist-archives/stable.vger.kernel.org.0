Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1F0C45FA435
	for <lists+stable@lfdr.de>; Mon, 10 Oct 2022 21:30:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229481AbiJJTaV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 Oct 2022 15:30:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56262 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229459AbiJJTaU (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 10 Oct 2022 15:30:20 -0400
Received: from mout.gmx.net (mout.gmx.net [212.227.15.19])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BC23A2D1DD;
        Mon, 10 Oct 2022 12:30:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gmx.net;
        s=badeba3b8450; t=1665430217;
        bh=8PbB2bcgfVvsF8fe9tjo6R6esn6GZTHwY7RDW4iDI6w=;
        h=X-UI-Sender-Class:Date:From:Subject:To:Cc;
        b=AfQ2bV+7G4jwf3klJ+7cTVFS3lRlJ/EmsexTNCnA/lWul5Op5dA9SqcsAaJAMIyLk
         rGLJYlMoOFPOk8OQCM3dSCLVOpumESCBYY+eIhTBFqpnukl+FK/NG6ugWYvrux/yU3
         /D1UbXQ1Tx/1j3KZNNfo1aNT6UgZNXfzZzUUS4RY=
X-UI-Sender-Class: 01bb95c1-4bf8-414a-932a-4f6e2808ef9c
Received: from [192.168.100.20] ([46.142.35.3]) by mail.gmx.net (mrgmx004
 [212.227.17.190]) with ESMTPSA (Nemesis) id 1MdvmO-1pGlGY3kSU-00b3Xa; Mon, 10
 Oct 2022 21:30:16 +0200
Message-ID: <3d35d5ca-f2f1-b456-b164-2adca180ed1d@gmx.de>
Date:   Mon, 10 Oct 2022 21:30:16 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.3.1
From:   Ronald Warsow <rwarsow@gmx.de>
Subject: Re: [PATCH 6.0 00/17] 6.0.1-rc1 review
To:     linux-kernel@vger.kernel.org
Cc:     stable@vger.kernel.org
Content-Language: de-DE
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Provags-ID: V03:K1:RZGSdCdgd1lkgnBGGFdDEk8bXJN9+6bSokG+orBaBiLfu+BA7AF
 aALyqhP575eqeIFQgIMSgKNJj02ep5UTEwhjkMg1HDazd4uQAVDV9KNkg2keMfM1Y9NZf+O
 UiqdFrKpevqys749PdW8xUObLLtLNoVaadB4RMdfjAs0cruF25IL0RCRrUT1++n0MrM7LhD
 +4HLGduleoxfpdgmV5Fpg==
X-UI-Out-Filterresults: notjunk:1;V03:K0:s8vxPwVYYVA=:hyiEY9eSzR1tvgel5TcT+B
 qJemgmZXRViy5Xh+jLSiBtvjnxNGukJeqGa78aBtsF6u97+yEc1gCeBz34+0FBHWyI8T6v46p
 ek2OX/EzKHivbhXw8KGOeVO1vtrKpkk7vofMg6DQaNKJWLIWfi6n7Jn8Q+63qa0j+da2dHEnu
 zMcUs/1H4o9zD1w2tIXkAvlSgG0TKaq0cQBuJutF5UTcxCkMj1r5j0uSC0pKbKQdOHCH+CopA
 oerRqeuidmRkQLk7Ms1Dub0ZlyYhGNg0YANDyCrX5mSa/YgnHEqKXrngSw2BiKefsp+BrCH3r
 Hi8XQUehV1x3a/O2tyIB5wVOUDRM+PqhYnE8sTNLqVgI2OZUVzupVHrwKCGsx8HzWwl3FLAM3
 u1hY6hraNSR0za7ME1LWkqyPDpTWcf4Gk4XrlNwpAjZT0xfjEQb9kh2SR05rz4q7Q6n3pgYFA
 KumCH8Cel3Z69EMxVTAPItm+cJZGm8JS1NNlR9Usdg0Lr0zm2nfZ7w600APuo4ZYc/9CWfujJ
 u9rZIQ6MozHKhmsuqgFLOStQjMu30EZIUCCD0pH3xEYcQQTA8W4jw+QQpS7Q68MoCKxNN8/vf
 zdoeHljc1c5gv8K621h016skN6PrlP35JTI+DT5+y+ZLJ2m5nwhkkYc/Z5IdNeXIBgjcO6Ttj
 /UoOzVVc+jrR/1aTbHnp18BMRd8ROrXYWQNAQMudRJJFmLcWTw68icDm8LUQ+r+jDH5Vttrkw
 BYmxWZkyim4aifUhi/fFI8Oqf07yvTnPrd6Gv+5iwR+Y3uvOg5EWKFzJspZVYFRQMMbcuOXOg
 nrWPDRvGQetnr3ZOHviJxOsWbXhOqkIPZaKr1vpSsRRaNbRBtJgidsQQn3ZgCzT0h/LkgYPGl
 JhMij4aIX/tN3BB0JTLmhDcSH/0OLfCkdaRrkI4CzLPNIpEVRMyRJ9VhB3sTFW1zALYf9u5KN
 hmiyQtneanPytqg4nkevO3CzYTOEJbeqt7rC/EBL5Cqw0ryeMjBFvKp6OurYCXkyHAyk6HxdV
 hC6EzpwbV3/FhsAXNDAnC0dAqcghU6THfrY38Kn5stbkucEhp2jNCiLBYjK+CQFeBuQ7D/SV0
 nH74BSq9A4ZUI0eFTkThhLuNGDi9fJPaAQuiVxFB/p9NinjDTST3PcnW7E9cYEJyxuVnSezlJ
 RyEdtqpTNuQHxgw8vhrWTnel7U2mvKKCivJAZNYPS//dZVf9caqfbFV091waRwvpeNo3zjyEI
 ukbEnF9Er3DiGH1lSP2/cr370XddLQiR/am3Cv2U5CGug3g3frGcFkzeIGmtUEvUJ1nOeNmfX
 77uvZ2/7VmoKHZHMpWL/tq0RXTj5qA9C8FSnlOdnnKGRBSggMHjbL47nC680gPaZjBJFso6JH
 s7BKWt0G+JFw0/BllgRSDHGTJVoFgyH2KGf/kqHTraCVgkCxCNkoxaQP5iotdSnknLLXVg0+c
 u2llDQ2i7SfiZ519S1X1zwUVw49tgj89YiYFmvWeHe3/XbZ1Dq6FvvCaNxVEovooEr2GmNpzP
 D0n28MVjqgo+3HRZE72DvLSg=
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,FREEMAIL_FROM,RCVD_IN_DNSWL_LOW,RCVD_IN_MSPIKE_H2,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Greg

6.0.1-rc1

compiles, boots and runs here on x86_64
(Intel i5-11400, Fedora 37 Beta)

Thanks

Tested-by: Ronald Warsow <rwarsow@gmx.de>

