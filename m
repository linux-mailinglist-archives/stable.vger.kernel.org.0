Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 735DD57A330
	for <lists+stable@lfdr.de>; Tue, 19 Jul 2022 17:33:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229451AbiGSPdx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 19 Jul 2022 11:33:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36734 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229585AbiGSPdw (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 19 Jul 2022 11:33:52 -0400
Received: from mout.gmx.net (mout.gmx.net [212.227.15.18])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 673B059242;
        Tue, 19 Jul 2022 08:33:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gmx.net;
        s=badeba3b8450; t=1658244828;
        bh=o8/VvZGzVY8iVXFAp5oEfYvr/GsS3dF+o8lFxhtgCJA=;
        h=X-UI-Sender-Class:Date:From:To:Cc:Subject;
        b=PbofVN986xAtI1Haki2qP+ZjEZJgCKi8X/k3523b0FnPHMVSxyf2zZcIXt52fk0nc
         ypSjcjdQB4SkwOq+2E7OtZIuZPJCCzXy132NKji8XMr/cTD8+VJYSrQjsoS0LCbjwG
         eY2zH8l0tqEZ+ApO9KGaRPDAKDDxfdxRjMSuDuaI=
X-UI-Sender-Class: 01bb95c1-4bf8-414a-932a-4f6e2808ef9c
Received: from [192.168.100.20] ([46.142.34.36]) by mail.gmx.net (mrgmx005
 [212.227.17.190]) with ESMTPSA (Nemesis) id 1M7K3i-1oAWu02fV6-007lxK; Tue, 19
 Jul 2022 17:33:48 +0200
Message-ID: <1ca489cc-491d-f78f-5743-fd47d6c98efb@gmx.de>
Date:   Tue, 19 Jul 2022 17:33:48 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
From:   Ronald Warsow <rwarsow@gmx.de>
To:     linux-kernel@vger.kernel.org
Cc:     stable@vger.kernel.org
Content-Language: de-DE
Subject: Re: [PATCH 5.18 000/231] 5.18.13-rc1 review
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:cnzUCsaZfKmWiRrYHzYGVgnWMpBgsb2N3xKUo7oDgrEtb1fc5H3
 Bg+racfYgch4fDkxSsq4fNINtw8VrDYlNjqy2yF/r/ULm/c7prO1dfDJB55EXq4LRquZQ2N
 919Tr6ILRrNj/JPhORJkRS+XTgE+RtVkqaajpB0ye4OXuyak8EcDtURdLUqgfupqcKcSirV
 UtB2aQt7PoqdOxBwt4Kdg==
X-UI-Out-Filterresults: notjunk:1;V03:K0:jQmsN5d2eLY=:nz2pd/7FzIQ2h82YexzylW
 +ix2Ck9sfpNeFgLs5z1fRH6ijqW6gZgiEIumGGaCU5G5Y17VYh3r3sROhZJOXiOlkEWKEKsH5
 kjOCZkJcM60daZKUMDvP13YaCtHlUgMJ28uTP4QN0GD9ldtDNE0U/FNjn3AdnrSXOTDQLROhB
 rrVSbbQ9W87vQu/b+XTIpElgE9k6o5WaQzdmbt9/Lulef7EcV5/ANw3SiBdqlg0H7Z2b+QofW
 7dDw65h1SheyVPILVYuChLHw44ws9iN1uTR9OxCgEfMABYcOAsscTczVhCZsdfOhyHKN+tVTS
 PYDhfy95+BhD8eN3/qVJk2VscMly9TJv0XMkbdsh+dCxy/y+JHssDt3Kl9VaROtkI1SA0zmZb
 Hq8HxId/WZxtn2iFMTo5MYDifNChX43XTePys2MzjgBdSuYg63uIAwqLnRHLQJd+CfFyr0azP
 xoJVBdxJ2cDDNAZeDchrElMJY+45tVB3/U0Yy1dkteXQObPhM15dlMFfe4TSvrsm0GXuEVaLI
 Co6uM/EFyOz33RLaKEgO2tZ8/q+Dibh0GpDMpgLCFmaztD2JS/ht1crMJBEpCkyOu75gkMlaJ
 ddnQM3bLGlDRqJip4NZJg3yuYG5H2+qqwGjHw9JIDqJR2ln6N3TcpPZ8RdPWSCGQEmVwd+Q2W
 0ckTwTc3xmG4okYiO8hhrx+etGVB1CAtLlKxwZQjS48jygM4kDL9sokwLDLMEBMkHH5ZV7utZ
 xCSL01fQYgBlLrZW8a8sNhSP9Bu0YnjIVwvWex1i46vvJXfHZP6LAZ2GUr72qsRxN48nCGt7Z
 sNWNdJP4PAwz3+RV3O/9P4m7GWkIrucP0sI8IxDaCZ5yDkHqbW1gH+zsyIHsx0peCBUPH519l
 Ay0xyPmeHZq4Z+4DNkpkRr5EuNFboC8+7Lx9bCgx1m3olugCePzDTNq3ayg+VPWXxIbraQD9H
 3Qtx+CGUjwI90cF8tHbVnNUi8CllyyZvKvhxDl6CCCysxjmnQ1JPGileKjTQM/Mrnjasq6yN/
 eMufNYaqDWQBhTzfW/hkkTvzjDya8wYNMh07PODCpeEtDXMEWNN0PH98qlGE5rarYokEtlFI6
 3K0VRrcCxFSSX/20mgdz7wiLonkAtnLe714
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,FREEMAIL_FROM,RCVD_IN_DNSWL_LOW,RCVD_IN_MSPIKE_H2,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

hallo Greg

5.18.13-rc1

compiles here with a lot of warnings on an x86_64
(Intel i5-11400, Fedora 36)

warnings all over the tree like this:
...
arch/x86/crypto/twofish-x86_64-asm_64.o: warning: objtool:
twofish_enc_blk()+0x7b2: 'naked' return found in RETPOLINE build
arch/x86/crypto/twofish-x86_64-asm_64.o: warning: objtool:
twofish_dec_blk()+0x7b2: 'naked' return found in RETPOLINE build
...

patch was applied to an clean 5.18.12

is it just me ?

Tested-by: Ronald Warsow <rwarsow@gmx.de>

