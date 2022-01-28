Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2794249FD9B
	for <lists+stable@lfdr.de>; Fri, 28 Jan 2022 17:06:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349923AbiA1QGA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 28 Jan 2022 11:06:00 -0500
Received: from mout.gmx.net ([212.227.15.19]:53215 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234788AbiA1QGA (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 28 Jan 2022 11:06:00 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gmx.net;
        s=badeba3b8450; t=1643385958;
        bh=4macMQryATn0a9e7Su1UA9Wf+EsDWpQOtJ0zx44KV1E=;
        h=X-UI-Sender-Class:Date:From:Subject:To:Cc;
        b=Tc1Oyw+kNwcc3d3euN132DEQXQqbMSoUGANs2E+5kwec9O78D8gzM0q+A3pqNkNKd
         9/nXyvL30dw6jb2Em6bAkoIVkAq5i0dhSjPCC1fvfBDz/JCTdzR2ah0L8zECrsOPII
         84jWECsd+erBcGGThrPQfdyFUNNiWA9P0db1oNoI=
X-UI-Sender-Class: 01bb95c1-4bf8-414a-932a-4f6e2808ef9c
Received: from [192.168.100.20] ([46.142.35.55]) by mail.gmx.net (mrgmx005
 [212.227.17.190]) with ESMTPSA (Nemesis) id 1MFsUv-1n2EHZ24gJ-00HLRa; Fri, 28
 Jan 2022 17:05:58 +0100
Message-ID: <47af10ef-c043-88d7-3fed-9a4a39369340@gmx.de>
Date:   Fri, 28 Jan 2022 17:05:58 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
From:   Ronald Warsow <rwarsow@gmx.de>
Subject: Re: [PATCH 5.16 0/9] 5.16.4-rc1 review
To:     linux-kernel@vger.kernel.org
Cc:     stable@vger.kernel.org
Content-Language: de-DE
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Provags-ID: V03:K1:ZEWUY2lShNjQXNZlZC2vW1v4ij83Aeho2gSjkN0+2pXPqG9xQfc
 U0kuPxj2DquPQlJYMNFgcGG5PzDDorHRmy/MQWPDgMdeyOyzqLCHzbTazurT2qGWOljKpHl
 VpNx4YxZd0fbd60paoHYdi9aEux7xB3A/2/YfynJ/smW2VOj/LdyGBpbKWgTaP78gQgNq7W
 XSHartLTGe0lE31mNkZMg==
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:cq1S47DohJM=:cGqpeGZOayaENC/C1ZOhv9
 sOFPtzJOqD5RTFwD7WzeE3hLV3pT5b+DgCbx+URkanO2ylarYT5jLbZjsU7Mf1s2yR0Aja8/P
 lUtTmJRwAbzj5Txt2jW3FmfehvXLSN36b68VbhcXkBVleZJSa6Wtrq3npZVOw9/BEVdAoO2rV
 N9VifFoK2aWXQ0GmKufQl1YiLpBwP11NFq9S9d0ipvgB5gRTtw2Z05EMlRhGXrdRnyHE40+SG
 OyN375LcqsOUcVYNJUayp5tXt1pCpS1/23hTSM3UsjQP1hiVrzdNeq04ApucCJDnKzhlzvVZ6
 X0htS4aTj1dx6VhNwF539Q/3SfZNYzdwBOnzgxrEap+60CWDre5YGlZIw6hy0U1lK1tDrEG1K
 JZ0X8bAceGDh/sTbUcBsYRVB2p3vMb5rLyE+SVbC2mE3rnRR+SudXTY/cIAy3BTY5O+wgcrBm
 IVcjX2pnaMQnnbiDIb4D6lD1msALsdWREowfaZiry0CpBwzvhXqnjzZ9XiY9Zmkqk89u3TGth
 /yn0nFmINbnV1wdfBm6DKzgQnqnprotyLglrk0SkJ5pj7QE0Tg4iVFCHpnkhvYe2VY2F6RhCY
 YSI5l5UFIEkRRqJvKPbqRzYapt9vSqZeKp6Gheq3dBXRhuN4zqJLckKCCFNMq+V+GtoMj/W9J
 Q+FD4spl4zz8BIUV9MJ9Ovrzye/xRPHqL4rjKZZSU3nBlNFVveHpR8ljUdU7OCfmzdAVKLKDs
 sEuy9t6WuYtoc20xn/agWoSc2/2Uepiolkm6k/JxaSxo8ObyvPKDNOJCFqPh5JXF+Rc5AfEU6
 TALd2+npcGhb+A7onM6C6BXt/jHejDJMEq260uAjQoTD4Bu/UuJx3w+BAAZHEEvuVGnM9J2Df
 iJ61Gy6nGBXmjaFMoF7xTXoNoCxfecmlCqy+KPqwB2UvSA+7wfiBVmt74ikCrGXsjkI7vXD0l
 S8xuMSq9u7so2Ej1FLw+ouDhegXEI3/d1JLd8mEv0PjgMpENYPE4VPckDNbEqXX3WfdyXUeUt
 hKH/WHsfxX2OEo8NrhldkRqaPP0sMYEFvS9V37za6iGT+2IdpGGyr5hnea5b5kSoPzZcdsCsl
 cQAtvLwR2R30rE=
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

hallo Greg

5.16.4-rc1

compiles, boots and runs on my x86_64
(Intel i5-11400, Fedora 35)

Thanks

Tested-by: Ronald Warsow <rwarsow@gmx.de>


regards
Ronald

