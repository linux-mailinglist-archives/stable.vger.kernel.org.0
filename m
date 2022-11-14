Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 597C8628339
	for <lists+stable@lfdr.de>; Mon, 14 Nov 2022 15:51:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236343AbiKNOu7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Nov 2022 09:50:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56912 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236642AbiKNOu6 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 14 Nov 2022 09:50:58 -0500
Received: from mout.gmx.net (mout.gmx.net [212.227.17.22])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 029C02B1AC;
        Mon, 14 Nov 2022 06:50:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gmx.de; s=s31663417;
        t=1668437455; bh=B/1yflx2z2cxbHE4OzmE90yDQ7Z9dwdRgPK6Qtfxewg=;
        h=X-UI-Sender-Class:Date:From:Subject:To:Cc;
        b=CfpQsleQsYIpnpQc9ZJIBWd0Duy84QEun7x8Z9P0HchXrWxNkrs5EIcgepCpFocf/
         KB3fhXXl071iAT1jLfUAd+v1ZpzMrDz1aqiHBaTHLBL88AQOThRS20dEJ26ujy4AuN
         Q6jyahQ17Y6X06zDxwMIP8fsGM82K/3ta/Uev516uMvEhiDBK1UMjsDSSNCc00H2Yh
         VQ5n1k03BDkPk50B2IIbGkXQC+rFXLPIMBCf6zrzSl/5kBkZL6fQrSnHCE+a/xsx3+
         rEmDLxxwqcrM1wOfvGaRF8QorUB9X+8l1Bgiu9riQeE409ZpY4PgGEufH0LuxHKAGC
         VfrmQ5H3eE1DQ==
X-UI-Sender-Class: 724b4f7f-cbec-4199-ad4e-598c01a50d3a
Received: from [192.168.100.20] ([46.142.34.171]) by mail.gmx.net (mrgmx104
 [212.227.17.168]) with ESMTPSA (Nemesis) id 1MIwz4-1oeaLV1dNa-00KSR8; Mon, 14
 Nov 2022 15:50:55 +0100
Message-ID: <2e8172d0-7c93-66e6-8b8f-531ab2083e32@gmx.de>
Date:   Mon, 14 Nov 2022 15:50:55 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.1
From:   Ronald Warsow <rwarsow@gmx.de>
Subject: Re: [PATCH 6.0 000/190] 6.0.9-rc1 review
To:     linux-kernel@vger.kernel.org
Cc:     stable@vger.kernel.org
Content-Language: de-DE
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Provags-ID: V03:K1:7HzibFwRSjmOdTpUliQJJlKsR6G8ij1tW+fHFjaODz62Y1rmqdT
 oHzqbJsBESQSYErYl8WXRw2viIPgmbZYl0aQ0bVOOuEI1UNBoucOTUd0j2SEAONCrMRoR8f
 1IbTMUDtYbugm+cYRzZGbuKF+Ydm19p85BGcMtbNq1/7fCLmV/eFPV4N6Ocb44opxVM5y66
 qo5zw+6ygPLewXNmBgaGw==
UI-OutboundReport: notjunk:1;M01:P0:MLcCs4mGgoQ=;HycfhyfkceX5vRmlmk4Sv3j7RuZ
 YsF3G37S/qBWdBYt7jN/xZ3d4SbR+NRcyeLSvyQlL6UJASXbMVFi+gklGTjLfWiQWYmkYFL7Q
 eXPsu4RwB8BR8iK127GoxDz7IX2MtFeKU1A+xP2gb5Jhb9RBH+tjjWIGr202n2SavCjnrt1Zb
 Md0YeaF3Kt5ZTZ4CHgIUcjgh+XZUoYRu5PNSlvTIobC/pEVdMZwqKK9j5liXBu56pK30PD5HY
 X0fMLrlrP+HV2btwGlKwDLMF2kcD5NWhi9abtyZtdFxahFtHGcfcCw9G9otTSNdprcfzNHIqb
 lY+ZJm4zx+Pfn+ZraTlCahwYo/5MqMVlCxgB9cIUoIukuFDtZMZZ0iuf9oVfMZCo5tisVOOBs
 OMjsds9LueKkzLPIgDc0AGG8YU790hIf2O2yvUbb+aU093o+UAWdnRNzAh6+Ae5G+Scup1W/J
 dzNG6JvguCw/1ok0SAlkxmK+8BUHwGyUc0qAiaKmNTJsDBobVabs+8HXIwMqcYBbj/ZYg1lGV
 C3774LGejnZg3jlF0gDxnaTzR+MwjpWzMUqNx8NNLE8OhTxK97ma4a4yPYaTQxU2XVIMgrhJu
 Ct3fxP4DLDfUmX4p1YVX0q06bZ3ckEPbcqnGdV9JLNz0Q8ABtpvrvizEHBZ4FvEQ689K93szU
 fLjRXvd5Hswvy/xxx+n9aQvn6uBI4HpJnPv0b3JDc9y89QOPtuaMbEW2QyRMVC9c0SN/GPon0
 l3IwVWUcAtlD3RmUun+PRbucjI5D1CtQSwmLLjiczQ0mK1VLMjetwvDHDx3hrN1Sl/wigFJ2P
 RrLVSo4zJGihD4tBrFKwPj5Xi7myN25STnNMUpvzW55YEEUYwnQG5AgGp3BCm5cbr4FjRL8i3
 dEgDUaJZ1bWRC1ynj7u6HC+rS0R3HrsVLrgxwrgV93+EBspGIkujnbrF3cVt1ewozfGS4/2pm
 slYR5g==
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

6.0.9-rc1

compiles, boots and runs here on x86_64
(Intel i5-11400, Fedora 37 Beta)

Thanks

Tested-by: Ronald Warsow <rwarsow@gmx.de>

