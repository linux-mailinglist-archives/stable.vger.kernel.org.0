Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 42C4D65DB1B
	for <lists+stable@lfdr.de>; Wed,  4 Jan 2023 18:17:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230198AbjADRRz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 4 Jan 2023 12:17:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33678 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239995AbjADRRm (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 4 Jan 2023 12:17:42 -0500
Received: from mout.gmx.net (mout.gmx.net [212.227.15.18])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A2B3017078;
        Wed,  4 Jan 2023 09:17:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gmx.de; s=s31663417;
        t=1672852659; bh=FxIGK5mqqgMrCXSByHO/CJHqUJoNIGhmxTXqeE+dcEk=;
        h=X-UI-Sender-Class:Date:From:Subject:To:Cc;
        b=La8Ba2tpdawbZ5DqrUJTzLYloD+qCfcEligazURCFe4wEzz8Yv7Z1Gn4LLXEsBFmU
         lAbKOQMYjdq5Tru4I03merUGnOBCLbphrjzNUYq1kE/7+MJP/nbHicEye1Ppd0K4hB
         UDahEQFriXAq5+lvn5h3NDLLuKzaGhuPlFP5wIoWz6e6KyMShTQ7zX+KgWp/X9VX6a
         A8KMsaNxXz4SE0IcqB3tUwAhIlrp6EDS+2ulUaGA3njc4KPk0ukoCW10UBmhiICsDZ
         p5FwuZZJNZIVigGyKGqEGHaEx56X7S6A39qXwDX41J0YyI82rDDVo7Ilidw6WXyIzg
         G//1367eTpuWA==
X-UI-Sender-Class: 724b4f7f-cbec-4199-ad4e-598c01a50d3a
Received: from [192.168.100.20] ([46.142.34.216]) by mail.gmx.net (mrgmx005
 [212.227.17.190]) with ESMTPSA (Nemesis) id 1MIMfW-1oylNP03fw-00EQqw; Wed, 04
 Jan 2023 18:17:39 +0100
Message-ID: <e8760efe-d03d-ac41-4057-6d5984a93ddb@gmx.de>
Date:   Wed, 4 Jan 2023 18:17:38 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.0
From:   Ronald Warsow <rwarsow@gmx.de>
Subject: Re: [PATCH 6.1 000/207] 6.1.4-rc1 review
To:     linux-kernel@vger.kernel.org
Cc:     stable@vger.kernel.org
Content-Language: de-DE, en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Provags-ID: V03:K1:JJXjbp9K2RcexbgJCjtdUPD5nR3eNegc4WEvpap1s83g+5YvKFP
 qD9yN+mccRNqGYMZglujKOaxaPTMdZY5Z4aVAnGomy+OSluuqzJJ06zYG3SSDw9p76Zk1GI
 z2FwpzgKHev7RMN/VTTHAMekZBYTSwS59pvktUjOa9Kiavv8I0q/SW2r/DvRM/qWJi9zeFw
 ZGIc16aaIrPkRVtoWuJ/A==
UI-OutboundReport: notjunk:1;M01:P0:gagVOA6sEQk=;8iwGExUvROoTYtDddjF74O2pGyX
 7ybfqgeHBvdIy7gZr5IrZd4sNlACmcPRk+rIfNJH6n31caG+9JXQGAkwbaRvo93NHk6WqzJd6
 koYaMJp20Hkj8WkZ42oVU5nLkxmMD4pzW7sAbCpXNihwBwysuTH5cZYLM1xc40Mtvnn09QIc3
 /hkEemqzVJQiyuYp5PScCPmGgbhnk1RJHxw7HS35YA+zYxNsMzUBuepNNBCEttEFUWzcgtRJT
 5IxhUv8Lhyx9SjmJ7B7uYqpBYXUV+y619bn8DIhlSesHSbImNVr/1cjCqdWH23Z/N8sehkFvt
 08WQgd5Ue5v33kDyIuuqJkNHmnH3rScjgw1an0frBsltPWxArxNp3gtyATqb2Qf/WlA8da/7F
 0WLMFLc1Bd/YFtUJ7FC2Xaph8E29lP4uA8TxCnGBezc5DiaZQsv5zmpXg/7t2vtClCNAs9Y2a
 87BmfTpArk4+kMPaISBPQe3tuPVKr4erb8tS9qkKCSR2ZewWca4rhyFxhiun4cNwMxWvOWYxv
 I7l5YMCC+XFU8/JiqLlcixTULaS2H9MtbwW080hJ7spvpqwqX8W1S/7jw/r89Mu5jHxnr0O0c
 I81q6heP1F3fssnoFpQQairkuS/5iSff4369Xx6Po8PWdOpVYQYbJJfOcb/9YQFPjezH+o3eZ
 xvXLo9AWKdQDDCHEZz2LZygJf8JLINwI3yfr6DuJ3Royf6Glwen1wvxZLQus/bZTWupDJy404
 LlaUhPMeaFHDy1j0VTPrVZ3NIiDIwvWaNGiitGNC1z+bdVGfcIy3PJF9M4Ebf9nW0w2gmmkLW
 1AE7oo38Q5Sk1uU5z5IyGwbdW+duDr5EyiiAT962GK9KoVn6g0N9I/PfESaeg1KRSb1mN6gun
 lgIWJRCRDe9BOt2+ax5KNQ+ebp04TBugJbqfpqJfnMi6zwsMcavpYiv6+UeWOD2e6K1ncjd7/
 GNsRZFW74tV6JX7kN81Djog09pw=
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

6.1.4-rc1

compiles, boots and runs here on x86_64
(Intel i5-11400, Fedora 37)

Thanks

Tested-by: Ronald Warsow <rwarsow@gmx.de>

