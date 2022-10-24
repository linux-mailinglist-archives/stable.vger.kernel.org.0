Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E4A1160BFB0
	for <lists+stable@lfdr.de>; Tue, 25 Oct 2022 02:36:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231303AbiJYAgI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Oct 2022 20:36:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60442 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231189AbiJYAfq (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Oct 2022 20:35:46 -0400
Received: from mout.gmx.net (mout.gmx.net [212.227.15.19])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EEDD4A6C33;
        Mon, 24 Oct 2022 16:02:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gmx.net;
        s=badeba3b8450; t=1666652524;
        bh=sbM3L7q2j0MNanFbpvlk4CSjJOidE5xvJJaI4BLiy+Q=;
        h=X-UI-Sender-Class:Date:From:Subject:To:Cc;
        b=GFnH5zKPU/WBtJqAsjuJbAlvCe9pBknkGoevLpF+MTuEqG303mQ4c3hhSAjOjIO7p
         vQDCwf8fOYhmAtWbP5paPUsZXY6MSHQvfgdJ25CvZOoRO32WYu8FuYxE0BFcX7dgVz
         yPifcjwn/JWhwhMbrvP9rzjG9brdXVgQn1f9OUWg=
X-UI-Sender-Class: 01bb95c1-4bf8-414a-932a-4f6e2808ef9c
Received: from [192.168.100.20] ([46.142.33.170]) by mail.gmx.net (mrgmx005
 [212.227.17.190]) with ESMTPSA (Nemesis) id 1MiJZE-1pFxqs2dXC-00fTUr; Mon, 24
 Oct 2022 15:53:08 +0200
Message-ID: <b45e3d38-b25b-68a2-d089-242378900312@gmx.de>
Date:   Mon, 24 Oct 2022 15:53:08 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.3.1
From:   Ronald Warsow <rwarsow@gmx.de>
Subject: Re: [PATCH 6.0 00/20] 6.0.4-rc1 review
To:     linux-kernel@vger.kernel.org
Cc:     stable@vger.kernel.org
Content-Language: de-DE
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Provags-ID: V03:K1:5xr+p9elF+Zv+xv6wNcmG08vtaAc13A1l4JEihWoxs/1uElZyTg
 qqP4N0Ep1v6jkBEwlZZ37+3FzgmRZ9JX8ut7nvMqO4xyu4RJBovd5v70GlUjQTw5GRO6dAH
 A6eK99nExKCH7QdB7nAUf/JVzPpU4zVmSriwfadAhlG5rbJ1w7c2aqujFdGRXFvXxIYWkFQ
 hT1bWZysalLWla5qrQ4uA==
X-UI-Out-Filterresults: notjunk:1;V03:K0:MCEkuIUKcY8=:3xe01jFS9RjXOGwQMlLyCf
 m3LbshUOY2AepvlEVePrH9lRttQ6bGJdino6qoQ7cOuNfeRTz8MGECn9NFpm8RpFETwwn1KBR
 dCqU88TZWeUx4HyBIXo2bBAGDdnxUvrcxLl+ID6i9gqMb0fzsr6Yq1qvv5Fsx6Ga9GrNo68ld
 5qKv0BaGyX0n2VaU6UaYpdOHWYoFGeW1MsWUJhn7toc6kbgJKyFtN/3Jw8mvD71425qTsvGDP
 CjIxrH+QPdWddKZQf40WL7w4PWpuRegJiYFGCNnzH/CNHPI+ie7RChXv4r2sPmC6gvYTyrQR+
 R1Hrl6sUPWr/tuPDYmZdfZTnQKyqJMKtBV77dzuOxtHpTkjwEScLLz7YIk/bmtBP7Fb/LRYVE
 jCmoBjrlDwIdA4nXgoqmCiIBDXiCE0ORox7aaiHIuZeneYvsB4JJA++d6HW4SxpMIR83oIhhb
 q3+Sx+VZ3twfolovKcY23JToSYXaCEWWk6wNDntTBBRV7y7wlH4tQBS/ARg4f77JPWZ8ljTQC
 wk210iEIDj+nn386KRBE/OwvLd+zsasFygn2ueqdvVNd18ErHXO6VhC9iXS2dBLp7PR8MUTyN
 L3jvI07d+bOryWH3VPSTQyHomRaOgMTT0q1y9NzKwrv0uofnidYwYZmxJeQlIKf0zrZfLhX2V
 CKTk+dTMb3/Ebi/VEKRVVWKqgezNET60I0L98We6m03jNPcfocdAtxzIazOPGd8Rhti8B7zm5
 FSP8QW0e97zyRcvTl50I8k1lQu44rKM/V3e8HV7aDfvrVs5+VHXZpPJHHrGz1y8BGHlem4ryn
 WMBsRvtspVUJHTp2jacl5kpBL9GWt1yiLT/4VlLxwWUagZ1/25BEpwxj5Ivpxqv/nmoRmz7b+
 C4eyhmaG572MWArycyCopBgOPeFyfWyjRJUCkxPHSmththHIJ1NMm2TqHWuJubWg5HIigUd22
 aRI5FdvLrzXTsBleZlRO+Nea5idq2tKvyj7EKY9oSBevKk948FMRay8QHi2KpDeOWw/+ZVdRR
 77xWcqfwNZMb6U3UcuEEVLxUa4rV9HMrpJP8clhy9ds819xKWGGvyq4GNGyGmucACs6RsbSQ8
 5zjyqGE+CPDvAjCIbpEy225Gkx3TzD/czX797QP7lLLaAhYmAN9RT8CXwNmC2maXcqVA0blPI
 I4ZOD+q6mhaMqTL6+aTRvoWdfW+fI3wgYg2A5Aqr5S8dK9JSaJuoPIv0vZYLf06hKMlwDmxm+
 no1l4DOYkSI4NECFpqPY+V9JZiQhM/tMAfn3I1+EnPlhdZ763aO37G7P6cv1IwQbvvDwz7gtb
 FCt4YejiaDZKoQ73LNs1rO7xFS549oxFlG3A5uHNVEagI0YgBNBRa3zC47PTEtQ42Hc30nBcS
 DhdiWGuIwYqTDME91K9G7AenLAYVkOa7y8IUYFCIOVcQaLsSqJ/gnwlorLM7VUzlvMPGQwlQC
 p1EIRNwRtrNzJnUqmaeyA06NlAW8T7WgGGOWQqGHFlSIpVoc0JFQP9LLicDzR8YuoioU61g/e
 4Pd/iEUjfTPzQOfUOt9JAQFCwozKcW8KkAI5Nq2FN+G5e
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DATE_IN_PAST_06_12,
        DKIM_SIGNED,DKIM_VALID,FREEMAIL_FROM,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Greg

6.0.4-rc1

compiles, boots and runs here on x86_64
(Intel i5-11400, Fedora 37 Beta)

Thanks

Tested-by: Ronald Warsow <rwarsow@gmx.de>

