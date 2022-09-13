Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 560B85B78C6
	for <lists+stable@lfdr.de>; Tue, 13 Sep 2022 19:51:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233316AbiIMRu3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 13 Sep 2022 13:50:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42632 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233671AbiIMRuG (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 13 Sep 2022 13:50:06 -0400
Received: from mout.gmx.net (mout.gmx.net [212.227.17.20])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C21A682773;
        Tue, 13 Sep 2022 09:48:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gmx.net;
        s=badeba3b8450; t=1663087716;
        bh=LpzHa11MGOguXVKOduQdO1HOuCibTch3WzDxxvol1EE=;
        h=X-UI-Sender-Class:Date:From:To:Cc:Subject;
        b=Ve5v6GPRNzkj4+j0Huc80z8UDRqQn/dAVK+D9S7SUQLS5BET2yBT6815qU5obfe6I
         m7z11mM5g/NYPfcc3XUwG9g9m79VnNM1YMehi/VTkYBt9cTQJGKs53LdkSkUpX8Y+A
         iEwWTJzgMG3UQmBT97w/bY6+1kNU+8eimPVgVe0c=
X-UI-Sender-Class: 01bb95c1-4bf8-414a-932a-4f6e2808ef9c
Received: from [192.168.100.20] ([46.142.35.168]) by mail.gmx.net (mrgmx105
 [212.227.17.168]) with ESMTPSA (Nemesis) id 1MFsUp-1oXpIx0PzL-00HKnw; Tue, 13
 Sep 2022 18:48:36 +0200
Message-ID: <c27bced2-83fb-ce8e-9a2b-58fcc8fa5dca@gmx.de>
Date:   Tue, 13 Sep 2022 18:48:35 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.2.1
From:   Ronald Warsow <rwarsow@gmx.de>
To:     linux-kernel@vger.kernel.org
Cc:     stable@vger.kernel.org
Content-Language: de-DE, en-US
Subject: Re: [PATCH 5.19 000/192] 5.19.9-rc1 review
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Provags-ID: V03:K1:dAhlzNmkpeaUuXM9kpR3DFanuW5YAF1fCLfx+jNGQMGKP8k07Bd
 g+Hgxe0sfgGzztYYlWDchNdzpLvUsugwfskluCrnHIVvDuzhp/1wgXkvNo7zDGSGiqYV/5I
 AsYdbcqSawkuYck40HlM3g7X2Axvg29sgx9u5x3DeSas6QWXYu9NRPzMXFHr0WGhtzyxYp4
 GA06uftxZCCk7sadizj3Q==
X-UI-Out-Filterresults: notjunk:1;V03:K0:JKM0JU3rPGs=:2iuv0B/3KJAym9EzPfgFEE
 Xpx/hfU3zUMHe7sH+oXmiUT4NFhXDeurypAn6giVlNW3UnrLyrJ6pfbSWLop+t1SlZBGqhWwt
 euNsva6MtQroHS4SugPI7fEgDyBsiNcYY6ODlxZox1rT3bJvsA0PhSD09UNGq05Vg10ObTopp
 B+w+ZI7EQQ4KOsbGQBaCd6s0lFjaDndtwhEgNjHziR8VGgVZuklOdUyKyukZImyhGzvRVGesK
 aSXz1eekbbQ1/dY61gs1UrkeHRXicbsZJ60C1mtOCCXRp019qI20sCCOwrT6Ux9rzy7zE3FRD
 7+EmUMujiDCO8vPcBi+/TsV4gYG4A2OlPM6g/ACtlx5QqsJphmXc8FywE2u2xetS6Tk1kbNJG
 aP5aiLlGdNBDV8ec+lyN0s7U2cxK5M9+4NNvoorUNFPnwmsnqXNchsU9hyQQSqWpFeTMEvDPZ
 +AAVcn4oGqo5Ci+kUHZXsBaeLPcFerkeV53+DcqWGS9ualABIGQk5GQDE5+ZltUb/paYG7v86
 pc2AIYJsBbgpLO1YRbBYe/t0LOOcqAyRIiBhgd/euNEWieJ8BagJkA1PL98Uj6fNGzVaZz1Pk
 qsNAl/H0b7kQg6qGYPSox1XW4ilXYAPzYDyjvJ9kcNrJRi8q/QaAv40ov0EDJTJx+iJNWUqTy
 8IvbxEdbKq2+WrTCd56mEkMh4FiROHL7SujEdS+m01JmXy7RbIsvJN84fDh4o/RvMjqoz4tZP
 zs7/200fuN5L20yGDviAlWkIX+uNlr1bvStHxRCbZRuF3nQibE+o8raupM0+tN+oqrD4yUcoz
 BuzFByCyEaYS2M2NqMDVahfevdq922PYhB/GBMvt4d9MlHoY3uHwiShcKn5Xh4UYm6PdWyP5m
 6VMgVIHCUsdBqebBlkjbsM6a7+uwo7irkbN413rtD2XrCFcCV8anuJ9jjAPwZ7siVNk4m4FT2
 gPSO4QHuo3THcig1izmR952T4S/OXU/lfOiowwuzMGv7rppNrPBk1EUMR2a2LjY9XfCxTKb2m
 x2JfI0ABRcMHNSV4sBs8v+ANejpxSnP/bgghuQP93WCYUnc5tAOWDOF6ODZWc/WiYbX5oVsa7
 K2gWCZmoRsJcL9/fyJioz0SVq6SFR9z3yOVGzVzeLrP0c9nQkwCZxgVQF8d9Jg8aw3e9F57D+
 spufk=
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

5.19.9-rc1

compiles, boots and runs here on x86_64
(Intel i5-11400, Fedora 37 Beta)

Thanks

Tested-by: Ronald Warsow <rwarsow@gmx.de>

