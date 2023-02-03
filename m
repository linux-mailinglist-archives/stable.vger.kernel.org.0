Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 244B2689646
	for <lists+stable@lfdr.de>; Fri,  3 Feb 2023 11:31:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233659AbjBCK3I (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 3 Feb 2023 05:29:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50370 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233578AbjBCK2q (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 3 Feb 2023 05:28:46 -0500
Received: from mout.gmx.net (mout.gmx.net [212.227.17.21])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4F525A0028;
        Fri,  3 Feb 2023 02:27:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gmx.de; s=s31663417;
        t=1675420043; bh=Q0LJz/LxWYw6q7TtSJiUYu4giIEiWVMpWGsz7xVOm+U=;
        h=X-UI-Sender-Class:Date:From:To:Cc:Subject;
        b=OKQ8CCOI+lxrj2Zk6wdt5zOlD96vyALA4lhBeGGBsUeWKqyXWlDrn0tZoTkHzDfYv
         8BsFqPNy+UXY8aoPbxp/NAIOYbX+YKQBd9z5kFHlUiQi6DZKi1YN0zijW4ZWdVcvMy
         J1OMj3EQjB8tVDpJNmQ9E8jNe6kMf+qn+pfluWUqmI/BVEIETFVvvdIlDvku3Dfuom
         rvY+MZ5NGvu2stxKERXPzv3H2HtdXedUvHvxG5tNL3b9Aj1dfaqm6rFajspa+HUT2c
         XqQnsNMimX5iQDxcT5k2bVct6aaDEGBJOtLOi+kHiJYHk6E/5qdAmfI4t9HdhoyBut
         R1dNDIWzk1LHw==
X-UI-Sender-Class: 724b4f7f-cbec-4199-ad4e-598c01a50d3a
Received: from [192.168.100.20] ([46.142.35.82]) by mail.gmx.net (mrgmx105
 [212.227.17.168]) with ESMTPSA (Nemesis) id 1MTiPl-1pByY21NCn-00U69R; Fri, 03
 Feb 2023 11:27:23 +0100
Message-ID: <02913344-1f6b-6d82-82c6-8a3e7c6978e0@gmx.de>
Date:   Fri, 3 Feb 2023 11:27:22 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.7.1
From:   Ronald Warsow <rwarsow@gmx.de>
To:     linux-kernel@vger.kernel.org
Cc:     stable@vger.kernel.org
Content-Language: de-DE
Subject: Re: [PATCH 6.1 00/28] 6.1.10-rc1 review
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Provags-ID: V03:K1:tePopRpCIAu3s6iW3Je5zDJq2TgoCTgPWvrCV/MhMLusZNRVgSJ
 VFwTdDYb3X690DG31LQ/EUgPy7G88NHy6mMWDjxh1BIlLn6LxaieIrr4LHNERmbJpeeky0x
 GaR25ffGlu3nGSQ01q3Eo3ZBtxulvn2h1h64BNROjSEMk4Xc3S14DQuinAnYv8G/sTEdMq8
 Ct5bPmmuBRlHZBCErAmxg==
UI-OutboundReport: notjunk:1;M01:P0:Me7RYcVndds=;KgNUt35n/h0W+MOOKhZaRdgLP/O
 72l6QS1tlA8/j6D9nueVj4KYOGTWkWTrJ04Qlx8fy1cx2c7nHAfpf80eo/mWNUTlbRUjDqWM7
 6pfuJZawgyRLf24DIpgXA+HgHgUEkQla3vNKIHUTpt/BrpX8+2nFfGh4+OT9bS1eRRU/iNfDy
 A263taxk8waJHCpza0oLcF1aQKrBNz4j2uWIqJZHjw/nKTAasJbcMQXgcY5QAu8U/B2wlW5IB
 UA0b4U4/VjPaoDqH5NJWdT9iJkFeT8KvbK08mYxYJygfQI8We5PDHaPDFy4JDqSgVOqCJeSbG
 YyXNCc3Ii9bXBgQyR1KGCC87II843ByQRVhcuspyXUJItNWFJZOOCtceqFWeeO/teT+JEs0Xv
 8EZ+fT52O8LKMdj/fL1idjYCGQa2CS+x2HjamkVmo5zOd6xjxOdAXfy3NLapmeq+OTiOAdiBO
 JeynJiGeu4tc/7iMtctFyp+whPS7SMUYSyZqjl82WneDcYJUCaZ8/kCjrcfB3s/yqZH9vwaeV
 lPetVVHoPf/uTv2NqW2dC+p3vPgetSMUP1wOHuRbbb7kvBuMwIUjqX+UYMmAfOELo9lXs4wLW
 TVO1Og9L4KtTO2e/1NvCP5lEiWER+TdDm8G5i9QrnsCDdyRi4dDGjxgd0PVwRK7545drYujNf
 +uls+Mn6T6tVlLiL8hDswkOfIVe84NbEcaKFvMAveJngHg7u7U6ZAuEeCeB+Jlf5MvZshUout
 dr+IfTltwV2tFevyjMm01IRA/EkaF6dEF1BDU1+gSHD//CklRMur3EgpoqGZodIkNdE2Cs+Tw
 jOA+SXDCP1XnlVQr2vsg7T0gTwQFxiljrjW5ykK4JqD6nqQfGOtDUFHYpT6MwX1/bnX7EPws4
 6w9uCKB+jtnxq2I92NzhEFledyPw9xMoJIJ2+u46gkEQqQtFlEdkJXnVaJuXfSevZVSzLKS6H
 Mj6mLg==
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Greg

6.1.10-rc1

compiles, boots and runs here on x86_64
(Intel i5-11400, Fedora 37)

Thanks

Tested-by: Ronald Warsow <rwarsow@gmx.de>

