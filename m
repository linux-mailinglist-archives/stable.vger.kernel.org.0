Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 374506C3847
	for <lists+stable@lfdr.de>; Tue, 21 Mar 2023 18:34:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229986AbjCUReY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 21 Mar 2023 13:34:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46398 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229677AbjCUReX (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 21 Mar 2023 13:34:23 -0400
Received: from mout.gmx.net (mout.gmx.net [212.227.17.21])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6EC9B53DBD;
        Tue, 21 Mar 2023 10:33:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gmx.de; s=s31663417;
        t=1679420038; i=rwarsow@gmx.de;
        bh=acxJ695h55d1k6cxhevVrjQxqBJFddoHyzszuIX/Hho=;
        h=X-UI-Sender-Class:Date:From:To:Cc:Subject;
        b=jo3gX3NYIdBQr1cBpZ5DMWknifrZ1IQGf3KgLPgbDU61EtrDNHw6pSB0MnZVC5mzX
         xml/AnmEEDZMlrJagJX3zbIqqzxI1XzZdzM+nf39qkAVBoYG2s+q55ESM8E09RQW7I
         5bUdHKP5bGaRVL97zZqy5H9VYpu/dW4/YftJGeX8PbwqqkWqAt8db+1zopctxS9MwK
         DHaYqXHg6rV3c2GACvZ+5PdHzKeC+aL3z9MSH98REpza4FF/PTnG2TcSy8yQ3l584+
         Ga4zLMV7QeuMrxwk+zzM52cOLVGueUzLwMdl4IP+2Ji2U0YaAuNEoEZ8wBjSqA6eA+
         rAembqO+ajPQw==
X-UI-Sender-Class: 724b4f7f-cbec-4199-ad4e-598c01a50d3a
Received: from [192.168.100.20] ([94.134.26.109]) by mail.gmx.net (mrgmx104
 [212.227.17.168]) with ESMTPSA (Nemesis) id 1Mwwdf-1qOwnu3y8J-00yNMY; Tue, 21
 Mar 2023 18:33:58 +0100
Message-ID: <a764c98c-9223-0bed-8565-8e68406dcb2e@gmx.de>
Date:   Tue, 21 Mar 2023 18:33:57 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.9.0
From:   Ronald Warsow <rwarsow@gmx.de>
To:     linux-kernel@vger.kernel.org
Cc:     stable@vger.kernel.org
Content-Language: de-DE
Subject: Re: [PATCH 6.2 000/213] 6.2.8-rc2 review
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Provags-ID: V03:K1:q0rIaCbi2WarhFaU71FerP4UXA5ro+pa87R46Kmeps5XuAgJA88
 vx2bGoh7dfaGMyMXBy2qbDYB96V3sijuAn7uvzoYHKu40xDOhjbEpkYgPLN/su5banMANDT
 PzHtyc8lKvY0ps9wTFTs2/GHjKWhIcnfDfKwAILbIZJp1hxdDQqA3d/zNp23pkhZMlvNY50
 AY6xK7+alUGG/McVZBwaA==
UI-OutboundReport: notjunk:1;M01:P0:+x5zNEdwUeo=;/0np1HFA4agLzgJVwRuzTk8FMWB
 wiDRuXE8HxP+Wj9XUoXLW9WFXPyswt9RGGJoNjcVgwgK2Ct1b7MeZ/9jUP14Uls8VEsEayoJS
 DMhdovHCDn3vcnrf7yW6YGXfH4dJLXNLTZukex24fzi1YgafMFXu/5FNyGKHvFxqGLTYF7TpH
 Vp+4kPn0G2ueiFSW5UORbnnj0beHdh27LW9mB18odtSe6e0PKQv7da8xMPYcVGzlA0XGVmNew
 MhXR5GpnTDTPYdOS+91Iuq++h40UIxBFel2fzg+CYiMym6pbRyX8O7FL8xmiCFBpnV4B0DZIf
 83iuopUHCFyjP+OA0he/f9b6IxUMOizsTWvot+OUh9yspUy/tWTI7n/9cSojeL5CA/eFZNXx3
 h2nMeS9qv68dno0JgIsE6RQJSMdYkXe+PDDZ64KU3mrZd1bjjEe3Jpwgo2QnZWmgnkBB+wSaH
 6aHrAwvpDHXOIlPnQG03dYH3gpnps2n0EDiYN/IJHn2NpVNR/FKJ9lBwKD/op5NiS7makL74N
 3W2FvVfvLT7UOxVRhZ5IzeMoFuAFdTd+0N0II7BuyOjAADwpKKLugfzxv040NxycpCKWv2E9Z
 L2q4zeggHau0kpXilyRcmdntqgaQaeDsq4JPaYoPQlWItld6g/Exh8DtHlufLrjMd57BWdneQ
 XSkg/KpJ1u6SnDQfYouhYUiPQuVoxBdYVtV3vtkmj6/Zk7s2fwDtWS6C2dsnIot4Ljjgec1Ag
 PN87XQIt4IIAql983PkOdfhmkhq3f/cABoj04gsqd+5Bm3z2OQa4hYsiWOsYACHF1UnhqGLxD
 JE6CQiVj/0DjZprRajO44T0AsjRUX4BIc4oMD3YHqRNa1HPrTboGde0k4ooDXrKGWB+VyU5Wk
 vzYRTIhHwaPTQK8bODuwhtUCsAgpTHlz+fCHDbXs7RC8dUd/HIEUazyOjatR5E1PBiTVwRoN7
 TU9/Iw==
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Greg

6.2.8-rc2

compiles, boots and runs here on x86_64
(Intel i5-11400, Fedora 38 Beta)

Thanks

Tested-by: Ronald Warsow <rwarsow@gmx.de>

