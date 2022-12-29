Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 71F6B659065
	for <lists+stable@lfdr.de>; Thu, 29 Dec 2022 19:30:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233700AbiL2Sag (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 29 Dec 2022 13:30:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51116 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233719AbiL2Saf (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 29 Dec 2022 13:30:35 -0500
Received: from mout.gmx.net (mout.gmx.net [212.227.15.15])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D936D22B;
        Thu, 29 Dec 2022 10:30:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gmx.de; s=s31663417;
        t=1672338632; bh=r0ojIH8Vn8oM6pui9lzwJ5Xziz63tdtGqikK2Iy4tF0=;
        h=X-UI-Sender-Class:Date:From:To:Cc:Subject;
        b=t/0zHojuWW0MB2yxQ+aOUErVv1Dt8IHxWQS/h/XNyvXwtxl74ssMuhpWuaN1N/Cfr
         c1+XyHJLRbesT4kNf6xrI7BRMHm5yPMVwSJ7HRFWHRFpHyorHWohIbVq3COokhFR6N
         OsIJQPC7c8hNEau/PQuK+o5bnG4JikQa+ybe3dcG6c2Hzq//nk+W4GS9EqmCgG0G7r
         gCaf0My4Ee+MwwhWLU58/7uvBvmRGTCFi2FTj2RzlxGONuE3s+Zj/P8+BZV0TFdaf+
         bme5nkkyx/GoXK5dKMkZO899KyKk64+F0PiSpeREVpB8dSxWcswM0E9Y9ZQot882o4
         RiHbr6/xRyO2g==
X-UI-Sender-Class: 724b4f7f-cbec-4199-ad4e-598c01a50d3a
Received: from [192.168.100.20] ([46.142.34.177]) by mail.gmx.net (mrgmx005
 [212.227.17.190]) with ESMTPSA (Nemesis) id 1Mo6qv-1oVJTP0ScN-00pger; Thu, 29
 Dec 2022 19:30:32 +0100
Message-ID: <ac64a6d4-d5cd-c239-59b1-5efdeea1de60@gmx.de>
Date:   Thu, 29 Dec 2022 19:30:31 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.0
From:   Ronald Warsow <rwarsow@gmx.de>
To:     linux-kernel@vger.kernel.org
Cc:     stable@vger.kernel.org
Content-Language: de-DE
Subject: Re: [PATCH 6.1 0000/1146] 6.1.2-rc1 review
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Provags-ID: V03:K1:YhH0p53JEb/Ng9P8X9oOw4QL0Vv1Dzu8Txb2lXgH6svxmBiZdZO
 nqPxrPsXzocRqZq1BF6PK8ARfJ92YJQatKDl3iego5Asn3TChBjfnI1x8zfE/CFVkps18UU
 y5l+wcAWa2yBO/OnFehmlre4UGXM+ZNFc/Ia5dR3G0F28n1hZa4J6fnbNVOWIAXNaV9ZJGp
 11rYJ8Ez8txCvrL9Y7lQg==
UI-OutboundReport: notjunk:1;M01:P0:gZKPqI6U41o=;kRupIjEeZVRbjwBPucy1aERn0Ef
 /NKY0LpTFN9snpy9g9HpXSa//dlNFf6g9R5RofVU5KdijGVWbmL9KCo2tLfmkQgsclB7Rwiem
 f0Pl9/JWjv9jXuvTU7o1jN6gISA9s8N1fNTN/ZQTZoyCk2A3kGbbqdh2zjbbPPv47No4Qsnqv
 jQ06eP01esSgl3tNGj6S7683GRyTZg0U6ju9t0m/Da+WVdXFkzBVudP1X+fxw7/SjYh8mOjRj
 oNdVnqtRbxs3uT7Mo5xlSvr1zc0ZaCsWShu5IkzMm4g7f6F5IdeB1wOf/4rkFrfmrCVV/7US0
 tiSLRAZ0eU6K8XMCB0vbXdZnCDTzjJO3Gcxgu1O6/JfUfoTZzQRpkV6VZz+5TLDVxoaWEk9d+
 FBwIuthn9yhibkaHBuMLbBXPQAA4Z5QwH7PApwq2XU5TbI2mB9t2URESEVROQ+QaY1A24jEtK
 7NMa4swdXMSTBxBfMJx+Nzk/mmAfotlwV/lBPcbCs96UUqx/jJ4hkEFGld9JXjcoUdCcguTCV
 x6luXm2Ymr1+VxjHMJGx++ohgL3z0OWC7W1DrtnLy+gzCHIq+aJxV/GzIRYN960G75eQKaBAp
 KC+NGVFmIfCYkM4WmzF1G+fpo3eQeSPwgRAtOV9pFHLwiEYrPpHGu/V02jNt4olPev2U/9uh9
 7W2l+ZtP4d3TkfBcQ7QLuB2jf7JbtP+brKF8brIeOHed/zArJCEXTeSanYdBK/ebFpodAx4NP
 8iUtxGFlrfuk/FBSxhvrIIHh0QlSOg72f1rdrOeQ1AfxgwdiH8NB6Ss2NokZ9ivAAzjY+RMrs
 BtOf5x69U7TDs3y6sdL7WzraxuNIqFugsQURHcrWho4uNA0GBUx3ISLgkgVpTxiFqtdRER534
 aqdIcvs79Z8y1/HMZ7JSSrXULm1+5ptmJejkbrC57lkvC0qsNn/h3bITqLhNn0MyNZoDHOiNj
 +fMXkQ==
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

6.1.2-rc1

compiles, boots and runs here on x86_64
(Intel i5-11400, Fedora 37)

Thanks

Tested-by: Ronald Warsow <rwarsow@gmx.de>

