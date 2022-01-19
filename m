Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 10571493B78
	for <lists+stable@lfdr.de>; Wed, 19 Jan 2022 14:53:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350255AbiASNxp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 19 Jan 2022 08:53:45 -0500
Received: from mout.gmx.net ([212.227.17.21]:44909 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235698AbiASNxo (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 19 Jan 2022 08:53:44 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gmx.net;
        s=badeba3b8450; t=1642600423;
        bh=g8zJR2Jkab1ps8eQAvmK9ipWmEmdtAot34V34MMMnEM=;
        h=X-UI-Sender-Class:Date:From:Subject:To:Cc;
        b=dbOvYv7k00MMYrpwxpovh2XPzH/A2w6EiJ2bl6Y7zZRiUZEd8U1JGNkHWuW+XdJMA
         pNrmIE8WFhYn8LstXdCckIMH0V8ztjbuEwFNiQEWZLcsflX/czLvXSOSFU2JN4lBOk
         rBSUFZYv18fQKhtNWAmjF4t8Tt/WKN311hAa6woU=
X-UI-Sender-Class: 01bb95c1-4bf8-414a-932a-4f6e2808ef9c
Received: from [192.168.100.20] ([46.142.34.97]) by mail.gmx.net (mrgmx105
 [212.227.17.168]) with ESMTPSA (Nemesis) id 1M42nY-1nABPD0lwu-0001xl; Wed, 19
 Jan 2022 14:53:43 +0100
Message-ID: <a8e70042-e1c6-1d32-42c8-9f31128353f0@gmx.de>
Date:   Wed, 19 Jan 2022 14:53:42 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.4.0
From:   Ronald Warsow <rwarsow@gmx.de>
Subject: Re: [PATCH 5.16 00/28] 5.16.2-rc1 review
To:     linux-kernel@vger.kernel.org
Cc:     stable@vger.kernel.org
Content-Language: de-DE
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Provags-ID: V03:K1:XICGdjkHf2YuCXiFAqtfu1/2lrEIoddKJYLdgbvGaKjAB4Oqero
 MkfGwithc56AkSe15vmLmkpn6Hg684SxhXD6LRGcsAgokiz/l/cXOa0F71anEtqjP7RsOwh
 03lSmWa9pBhSPNcBXQ8kVReOSmhRbqRympU7eT9EoRA4ot6wPKCVqAMNbIARMZdpHxxxe/p
 a/CRhu5oQ3igG3rXVfRPA==
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:Gf/B3JynFDQ=:+slPRfWeRsvp4qADstdrLB
 3w6OJ88eOlAmy2pisgK5HqDUn7HOUKToUFANj0DsyJB5SgyKUhVJ7ELKdJ69+Ogq5Ryq4UmO6
 ANglGjyheDmO4yIvQixarKyFau6Ip296pSNsTRhslg0bziHZId1kJgzb6Ck/RihNn1LIHSI4a
 zrwG8M/duj72ciqoIGgd8UpjOPfp2pQffpzEu8C38qjVGh2nAIvoM2f3bWw2nHTURodusQcO9
 kgW7hCJM4DxAUTGm6WOLMV9RKPeD1JzQPYyflWiwFNZAD93V0pXHqMAaJwrDRWX0CVD6Wd5sE
 BO/yQ3mYUshNf0uRFo9x9U9tx3gAbS3V4kudtaU1toElj8XOn5I8izB5lwUUl+lvlTgkTJ2kW
 HMt44lReVU1/iP4EVqyswp4etE8AcI2AaR3uUqRCfvDELqPIbjNPCm67SCHz9jHq9qtBD6ChH
 Y9G/1drmAkLhp6KBbWQjJsJVZZWntipzlxAm7hNWYEePs4FCmaUke6E05hRiACfPCssQG2qw5
 4AlbajM66onEDzfaPfxff6fwJRP9dGqupXpLhX7ddTLbY8LgE1qbd0TyAzcjk96y0Sd77ZZk1
 g/VvBl+yoXQVvvzRKBAaiLeITRlXrkpbHCx5PzeL/0xQNRIJOyfDhx9dIlSkiDDnw84lj9Xkh
 pbGInMiejzIi/eXtXZNaTkFw4fAjbvKPuDYqc69BiEj7x+VXf+RrO11ss+FVp/kFBNA1g8obo
 M6XfvM0RmO208OV5dLkz1l1DPw73fV1YRkSVsbQYABsikUh0U9xiieGSmQCcnGnvH+vVNyLG/
 6hwsMN0/Ej8pAklEdgD8r4WB5wQESn/RgEjrnfwe3K7zZZobzddLCTVqkcVhOH1UkdRo6j2/Q
 ETdoRA1BlNyLRits6A812YfFEdcMAEPuMCmbtoFycV/2HlpQTqA0e52WPd6TsOyeSI+0jo7Ef
 aFah+8jIGxIurZ0NKOKnKXO77JiFamDLEvAfSds3k/esI7vC9GDugHi+tO62bEP+BQF6hH2V9
 JuHog2kI/rR/50zL1RDvKElpGKam/pqmdko1UYdMZCQ1AOU/Dfu8++yLochK2Ck3iT1bzECge
 Ki1AMeoipm+1mk=
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

hallo Greg

5.16.2-rc1

compiles, boots, suspends on my x86_64
(Intel i5-11400, Fedora 35)

Thanks

Tested-by: Ronald Warsow <rwarsow@gmx.de>

regards
Ronald

