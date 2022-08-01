Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 99174586F47
	for <lists+stable@lfdr.de>; Mon,  1 Aug 2022 19:07:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232707AbiHARHe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Aug 2022 13:07:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56018 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232761AbiHARHc (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 1 Aug 2022 13:07:32 -0400
Received: from mout.gmx.net (mout.gmx.net [212.227.15.19])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2D7D862ED;
        Mon,  1 Aug 2022 10:07:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gmx.net;
        s=badeba3b8450; t=1659373649;
        bh=VFYa9caj16ZCvsjwjxd7MsRSRlr3vOBt66Ph4RKX7+g=;
        h=X-UI-Sender-Class:Date:From:To:Cc:Subject;
        b=gtwI3D2a+hobK8QhHxh05gr/RpL/HH/LdMjlJXtn8ivKASKlm72wCvD0wzMdchn1v
         VhAt4COwPtRSATG4+MMw5DM0ovpkgu6+77oPhmi0AC8EG86Efnycyczn74NuotnoJE
         wfb9FqDV3qJ4gGuZteSMxZQGe4nSgnuztyvB2Rzk=
X-UI-Sender-Class: 01bb95c1-4bf8-414a-932a-4f6e2808ef9c
Received: from [192.168.100.20] ([46.142.32.156]) by mail.gmx.net (mrgmx005
 [212.227.17.190]) with ESMTPSA (Nemesis) id 1Msq6M-1nPlNZ1Lxo-00tEnq; Mon, 01
 Aug 2022 19:07:29 +0200
Message-ID: <0678ea83-ecc2-5bf8-834c-c661440d6f2d@gmx.de>
Date:   Mon, 1 Aug 2022 19:07:28 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.12.0
From:   Ronald Warsow <rwarsow@gmx.de>
To:     linux-kernel@vger.kernel.org
Cc:     stable@vger.kernel.org
Content-Language: de-DE
Subject: Re: [PATCH 5.18 00/88] 5.18.16-rc1 review
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Provags-ID: V03:K1:CWFgIrzrn8LFmW8RrCbdCSOvXYm2r46+r6bTrHffO6nKrtqtT4w
 3DXO5gzKf1bmMdtfMUFoYjBXEpmhz49bZmBhkzX8uQM94MeewPHPYFDIeeTc8tKbMjbtJOn
 hCWxPR9hG2N4XBEt5NMVn5UiPoEk2EFQsLcNNExu0WL8nWICRW+hGa7V0bqsb0Nsfh6fDq4
 xtoH5j2C7gx+TwaTmeC2g==
X-UI-Out-Filterresults: notjunk:1;V03:K0:n8Oe46D9A98=:LoW2tXArrJQO5WC2OH8PvG
 HHIzZwA92me8BO+i8bbRN7ArEiEmUlW6WyzEqR2d9Lx2/hlNnUlt4MWI63NBJoVmF0pR3HvIc
 yzWsy2bCAgAjqPfSgcuu+t9nvAUIrHOnElmIIF9evvRCmT8AC1GHzJDVoFMh4N5vfxMfmvNjc
 nIcJZixiePIDKLFdwjAoV+Y/HPrlUc6Liu/HpeLAenhMF+NMpYx1/hKTgp7pfb47RO5J/FWjW
 o/QuuPQ+RWCMZLdaFrZrc9l82x54vwgd9g5kcdJgsyvO/f0G2aNp+OluIEjB8jzTCzad2YulM
 S5Iwer89Xjwp2x5eihD/dNu1D5LGxqVMz9IOBqCcPIvfm9iiWmunvBEi/cSt69eXZGkEIbJao
 BxzmN8SodgXHRO9x/7xFM6oHmKHyoN6a5qSbq+8sSkSDRNVSpxuEg3WUpFS1MCHxFtzzSjbw1
 n6Vfswi3Fg4zquCrQxjEqsotQP2UpmV025WvjFprjOZsxwree5v2lVFRLdjYp63SmdbclWCSU
 g7t6ClUV3jSIDI7zCFHCfwq0UaZfAc15W8Y5UwQmb+p6+d8OxeVa2nTd8udz3n5Gt4NEQmzaU
 ELcB1zmEwLLILbUu7DRHBIzQjxnTPXHc2czUksa7fDsfmRShRneoPq9IahQ28plmswg6CH68v
 jFyGHw95HfwFJCeoSSWe1KmLdLq7QsulA4Txt1AxmesLOqrZtnDLkFccw/+zu+/htWvWWzPEi
 ddP1m1HsUn0I7+wKJOTOpEaVOK7vTBEeBG1BA+VWnMMb89TcsVkabMBSSuLJH4jX3/djkiL0R
 k59Sj1rDephzq7IOwlNbZ4KE6ccS+RiK3rKoHPUEZ3GiFCRAv8yVlETH+GNli3FvsmTeLAwX8
 dYAIyn+lfK67Q/GlTc1wkfqJlp3sRtrg/9+cStTxEBaisNxB1cKPVs54cGPtSXkKL01kp7KxM
 ZZuL7SmmRxMLN4M+sDcPWMwoB7JaEQisACcJrxulHUvfOQCvDrSn/EmnSBa/Vx6r9fUYlncza
 phIKzkLiMASYD3s77FwOba1060UX33WGRvLfzURUIisOPKayfeBvZUpnXVEEUmphG+mDpkNvN
 23FruU2wRnw2YIZ+MR7SKQstA2k/o+G1qua7fR420Ytk0F5/vkBCsDoXQ==
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,FREEMAIL_FROM,RCVD_IN_DNSWL_LOW,RCVD_IN_MSPIKE_H2,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

hallo Greg

5.18.16-rc1

compiles, boots and runs here on x86_64
(Intel i5-11400, Fedora 36)

Thanks

Tested-by: Ronald Warsow <rwarsow@gmx.de>
