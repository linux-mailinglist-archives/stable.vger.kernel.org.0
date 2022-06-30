Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4A333561F43
	for <lists+stable@lfdr.de>; Thu, 30 Jun 2022 17:30:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235361AbiF3Pad (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 30 Jun 2022 11:30:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39988 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232771AbiF3Pac (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 30 Jun 2022 11:30:32 -0400
Received: from mout.gmx.net (mout.gmx.net [212.227.17.20])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 27D753A738;
        Thu, 30 Jun 2022 08:30:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gmx.net;
        s=badeba3b8450; t=1656603028;
        bh=VhG6J9uZbMivq5MflgzUIBMPTyPiY7C4ZX9Gt4iLk3M=;
        h=X-UI-Sender-Class:Date:From:To:Cc:Subject;
        b=l1ptDq/+hzUpK5ob8IIUNDhvSJpiS4sNpTUOz5ZLGqLaMpX7PtrATzgelH1NJP31C
         QFVe3r28OdZDHTis3Xl9zr+GptRsKGQAEtW6/S25a8YvHKSj4kbDvVd6XRVPrSRQwN
         hUMHCKZ+UaBFOdMSY1GbYqly23v8dxlHXBupnnMI=
X-UI-Sender-Class: 01bb95c1-4bf8-414a-932a-4f6e2808ef9c
Received: from [192.168.100.20] ([46.142.35.76]) by mail.gmx.net (mrgmx105
 [212.227.17.168]) with ESMTPSA (Nemesis) id 1N9Mtg-1nat721k9M-015LO6; Thu, 30
 Jun 2022 17:30:28 +0200
Message-ID: <71bea837-d7c6-2163-7ef0-e7fc9484d088@gmx.de>
Date:   Thu, 30 Jun 2022 17:30:27 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
From:   Ronald Warsow <rwarsow@gmx.de>
To:     linux-kernel@vger.kernel.org
Cc:     stable@vger.kernel.org
Content-Language: de-DE
Subject: Re: [PATCH 5.18 0/6] 5.18.9-rc1 review
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Provags-ID: V03:K1:AW6KULvMMNyah6Tyt1Yge61cP2Tc8MbUMF3M4NAKxmdMDQzf9FM
 PdCtePVHIxTjwhF9SHdM/PHTAwR7AZvdLBxQA11c1VIclUp4vjgI6Mi3CMM4UWCBi7GIZyL
 xLHl2DbR0rU5jZz6avpBy8eYDqtJlN5niLjLaU7HrpbZ/6NYFcHwyAsqBTlm3S311xpksp3
 /3sgPxPvHPM1upw5y3KiQ==
X-UI-Out-Filterresults: notjunk:1;V03:K0:oSxilcCyJuY=:/RGase4Q+7ckUsbZmz+Fad
 jhxkxjvxHTkMklWCVYWkqKmRa8p8YdGdl2keKSE0L2QhSXIqRfwxRmKwP4lbt0trDwW4x4wB5
 2p1+HdQuxA+RE3LgTroWzHTJ/e28BZ1rtxplDAoI/2BlMdV+OnXxxBPJqovLTSwOz7GmXN+20
 0Tt5XB6wzzwid2MxKet9EWRmGUlOmAirzdDzxabJ74Ke6F65dFaZXSdP/3IOlUaZQIyFAhvhv
 cdPhlGY1D2370jXRn/GmNqKPB0pyJccU7Axu7U4VfnXWbzz8vc/KFrGnXu1O6cAJLwaNKGJc4
 dzAj49xuViuiLrJMmW8lvq8UbZSQVHIS4wyNb6TPZtGoi5uL+E446GMbfBfkov5t/c9vR9xHM
 dlA0CNRDM6mbN+Z0s4u3QypUthHDZTeORCwDVOi+yCjFKRBGMvk3kdQUjq7ix6smpEwtUMZvS
 Tyx6KsmYl0bd3zsG21lhzW8cOGGzK1ejDD+RS71KIwubrb2GW0PAW+zAAuu88mvCEujkdcohu
 qnBgY09S4OwQ8ctYN5HQqCrAKHPtTDtrZTy6I/L50bzdL64h2Rb+zGl/NVtQnD/3rX4GdolaM
 gl6TQVFYNpgwzqm9S3qCKQl9pXcKi+1sr6yDAsoJTctY4U836E/rTaYYxSqL1OFH/BfbMkUmo
 7AgDRdeC4snxQdxHig4b9xeZv3c4ry7SBBYLG0+rgfjirzKE7lVDNU9zXvPevRSlTqVKOevzi
 2FZbe3JbtMgWsO0MAwAfpKbzEb7iRjEXpzE+Fzelw/6Cq8ZHod7Vcs1FYqNKXkiaqia/+NgTI
 SEcM4cWzAavV9GA8UyEeSXX0pxVzj1wbEfkeee7uCrgfpXjzUhmg6Y/4mabjRvMXMfMPwvJ2n
 dLJvuJdaoEUSocTmy7TR79Wrvtgl55ij/sI8yK2HIOztClPE1/JE67WMQgnN7+LbJmK/y+xEc
 ATtklNkl6yxJPEghgNVsAiBhBInUx35vQHWPUil4KivRS/Fwefi8+D69BKEoHhp1kW0y2Ve9s
 fyK1y6p2q3VtQ6T6WfF5u2Z1A4GWKaeFUW/p2wIgqiad4j2M7RGB0aJziKV5Cd+lj3ow0UxIG
 re/ts7hIg9Tlp5o6WBX86SC21Js67YORyX/
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

5.18.9-rc1

compiles, boots and runs here on x86_64
(Intel i5-11400, Fedora 36)

Thanks

Ronald


Tested-by: Ronald Warsow <rwarsow@gmx.de


