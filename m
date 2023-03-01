Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 906E06A73AF
	for <lists+stable@lfdr.de>; Wed,  1 Mar 2023 19:42:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229572AbjCASmG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 1 Mar 2023 13:42:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50306 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229704AbjCASmF (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 1 Mar 2023 13:42:05 -0500
Received: from mout.gmx.net (mout.gmx.net [212.227.17.20])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5C550CC38;
        Wed,  1 Mar 2023 10:42:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gmx.de; s=s31663417;
        t=1677696122; i=rwarsow@gmx.de;
        bh=trABslI0EY5unTvNoBVGKJf0c9Ev0JvkvIoY3Doq0AI=;
        h=X-UI-Sender-Class:Date:From:To:Cc:Subject;
        b=XSRqpkY5zbBGodX8BNUJ05pmSpInXAt8YWZOPTYlVbVC6uOzUpQcE6KX5yeLBpuJE
         HwdBpxyvWmQ/TxI8e+LA+TV+V+4xp0hYpPwf9jOu9HDUt73EVqKuW+qm5OtIMnZZ6Y
         sd1Pm6F4jS6ZI6hQFohrvkyfDIiKhLtIgKRIEFtTTzxi7E6SqXPMJsvSJaq+eGmbYL
         oV5dAM4OYqQ/rcdtBqWWX90WYamWrK+1XKKjQQ9/WxjPjutqy7iRG9ApWGmSoTm8c8
         ZstjFAhecmI5G///7jyYKG307vjvqSI3ubKGkLypqairl+vtcEIZ9HnSxhcp9dAvKA
         RifIzVSu3QOhA==
X-UI-Sender-Class: 724b4f7f-cbec-4199-ad4e-598c01a50d3a
Received: from [192.168.100.20] ([46.142.32.237]) by mail.gmx.net (mrgmx104
 [212.227.17.168]) with ESMTPSA (Nemesis) id 1N0G1n-1oaEVJ2xWx-00xMOT; Wed, 01
 Mar 2023 19:42:02 +0100
Message-ID: <6eb685c2-6a13-ec1d-ca98-cead97f1c75a@gmx.de>
Date:   Wed, 1 Mar 2023 19:42:02 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.8.0
From:   Ronald Warsow <rwarsow@gmx.de>
To:     linux-kernel@vger.kernel.org
Cc:     stable@vger.kernel.org
Content-Language: de-DE
Subject: Re: [PATCH 6.2 00/16] 6.2.2-rc1 review
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Provags-ID: V03:K1:d+gSyua7o8uwSCqc5uu0DzSVo2Xg4ZGldDZI7/rPpbt0KNfWhGv
 dr22N4Io8WYin6NQJvdjvKrqe0nXNTj8rvJ429/kboANKUUjKs1lapQwqJqO8vPKdYCbNzF
 URz5J96hMd4X5+Y0iByEF3yLeLwKMcROMiGI3EWgSrcTtCrO85w+HkS2vo3z6x52BmdQa43
 ALJ2aTBOTPw7Aw8i+Gqrw==
UI-OutboundReport: notjunk:1;M01:P0:vtuTygJiRIE=;t9Ih4BeZHHHItU0JfTOlupn+6DR
 ENqWL1/223/SGUaL16sEk5MPiIAtIj7213RIweLdpnBeMlRfaL4aQH/Gmi+yPEFWFbQuRFBQ0
 8mouEofocbV9nYMl5u9V5ZjiK0ZgUv5ZK6QSgy38lMoXdtRcDi8nRq1ULWfN7qEDt4JcrcQhk
 ocoTlcUzRHR/VxbzeZ/DBEFGkkIhkqDG+2V1jEN5gwgVRq3fbPThdIQxzNffPeNm0H4LU/nO2
 Na7qVqtMf2zawemwC/hkeZ/vQTkATy8gp/CF8TCguUxx1fgO9bfNC/KiKKWBhHVdzYDaP4Ein
 wQV/BYQO4qJryjTDpf1F79te00fGWCMSAhqGdhdJ/3DS8nvpEL0mXBJwBxW04B6A5KlfZgwW1
 uKb47S/VuGJKLmwAgfTd5BIS9XG/1bX0NST+X4wZ4Y3e0uTvmDHOsDV9aLqE3EBE2avqygKEc
 LT+Gfa+L5ME6hMQFTeynve1VOwiruuQYELLTMPwFIsOfCoX+8FTxKm6cCI7bjB6zm6TinQmZt
 BwJWSeB98ibqSK4JM3BaYuo9QvzHEgpwgKkBUvbuIzRyzGz2YrUmZhfXGv8gW/UOYQMebzeCV
 ZfYFueAeO+Z/kX3ZRXC9paaqpgQFFOa+CrKqiSLdeYLYP/3CFaHVmI3ZtpZs3+wsUoabjknbx
 QSEyTo3YBz+U6E51oLX4o0hhd5yvItTPltPLy6Ij3JZbnk01psZwFu8d6sY1zyCXJpZVf51rM
 wamZWllzm/lNu72DNxPg0GSSUqA/fWT2423qS7MoVShThpM61eKzO05F/dckvYDyaTIhX27GO
 6f9FW3drSGK/MFTdeHiWAuxQXVAiQQ5ooo7kYeYSTF8qH0MzevK4kB3DbEwI2KaWBZwB0Jt3m
 x2nspEqkgTXw3teA1DCJ3v6Rh9dnBPQNYxqY1WpOSJVDdnHd4KFPahNMiVOZNvQFch1/2HXEk
 N1Q8Ng==
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

6.2.2-rc1

compiles, boots and runs here on x86_64
(Intel i5-11400, Fedora 37)

Thanks

Tested-by: Ronald Warsow <rwarsow@gmx.de>

