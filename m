Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 08FE66BDFA8
	for <lists+stable@lfdr.de>; Fri, 17 Mar 2023 04:33:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229616AbjCQDde (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Mar 2023 23:33:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40910 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229629AbjCQDdd (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 16 Mar 2023 23:33:33 -0400
Received: from mout.gmx.net (mout.gmx.net [212.227.15.18])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5449A52F40;
        Thu, 16 Mar 2023 20:33:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gmx.de; s=s31663417;
        t=1679024008; i=rwarsow@gmx.de;
        bh=eC4nS2mgzWqDlj5K595EXJgONviBisueweyCngmhLp0=;
        h=X-UI-Sender-Class:Date:From:To:Cc:Subject;
        b=T/ukiUD0UoRsnjXE4p3zQT/4x2BX4K26jLZSAtyw6t76WkOSfmmck6SjfwlxllbtP
         0zlAJTfdlori+13g2Qw65Y9YSbxoS23MUPpTqUgpFgiD45yKczdO5XvMztN3TVvL2Z
         HSHUk8NoUYhdLGGFgZj4iYxLq4LTqStMNszZ5nmn8dlMArlkqk9RnMxEGEtuuTsah1
         RTxRDsAOa6BJTgt5pQ3LIsnnlmRIxVGhp8OLE5BWHgYfwp49zDqy77uynAF20euCd/
         LRB8OMQ9nGlQjXG8mfiXuZVK6zPSpnRwBWxe2LJOy9oQN6wpL3JrR6DYMGgMHSOFXI
         eWGPESTYOAr5A==
X-UI-Sender-Class: 724b4f7f-cbec-4199-ad4e-598c01a50d3a
Received: from [192.168.100.20] ([46.142.34.249]) by mail.gmx.net (mrgmx004
 [212.227.17.190]) with ESMTPSA (Nemesis) id 1N6sn7-1qaTjT1ssR-018LjR; Fri, 17
 Mar 2023 04:33:28 +0100
Message-ID: <94da21c4-3b1d-2c59-25e7-f64324f52203@gmx.de>
Date:   Fri, 17 Mar 2023 04:33:27 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.8.0
From:   Ronald Warsow <rwarsow@gmx.de>
To:     linux-kernel@vger.kernel.org
Cc:     stable@vger.kernel.org
Content-Language: de-DE
Subject: Re: [PATCH 6.2 000/137] 6.2.7-rc2 review
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Provags-ID: V03:K1:PeriEzf6NjfnE6IR/inXAbWHtd7m9g3YTehXTyotUGTqV9roLqB
 JNzd4q3v5VWYVdbDhYU93oasMQgg0vIb6P7wKtOD5bPRzgxX6WovPh9d5wgj6i37SHTzK8y
 txVv9EeTakq9kwy9WHAw+9mlOpFRUwMPPxd2x/yXpVPIO+SCp3deM+rtMmqhnbL8sS4fa2+
 b7ZBp6f5R6xPDGQOJ56DQ==
UI-OutboundReport: notjunk:1;M01:P0:Y35+E40BpKw=;KXTKezzzHYThScKhVJK2Jq5lB4L
 Q6UtDfWOaSBaTLVHI8P1bm8CYLJj0MLwKcmexTvLJxoNQ9HmnZqa94wrBXB+h3/ns+TuAHWNK
 isRparhdAOxIuIjxhLqvODfFU8kAsJfZHj/lXPJF+7+qyyPxsshFi4GwY1kcc8MWX87lR65WL
 0Kl58aaPfDWU/g0MEBvHDgicyZJMNkoGSKw3Bh89RyAAAkCHlXAQ5ppn2p7oCNmtH22gaEtuM
 PcjFdKrP8tzmZA5wzZy8eWluLj995LjKrYc5qc7tDZHJFX3rherQk7F5YYtXUjoCdJqQP7jOR
 MIVGfX/FtbnTYjPcDESVMUQvrSK1MXAQ29ZExOFcuYNfWSsA9uYvCSbo3p7g1WJx4qHo5mafO
 sPeo0XzuEtedGCnueReCROjY0zcKj9gC0hpydEWKy/fWF4D2f8B82ZbKGsf0mdYnCG79Lb1az
 nQqylG+EEkFvPs1NAptg//AhgAxB+ekjmaIuFPxOjXODFsdlfphxMK/5OTW6xclBWxQt5398G
 EDkKXMFewMH04lue2F41EhDFB1Eo0qB2IbH1pNhlQw1ySZh0PlECrh/mjpDijq7CQ/4DaHUnY
 dsYnpTqeguNsz2UGaW7NzfSD5Fq4U29p6vYALT7nqnuhUunSdnTN+AuSylkFV59s9/Z/we2fh
 9kEfqEzudP6osACdryOoekSosLnJAnOiMnk+QNUp5i89V40+LBiOWN2CvXeZZ5xeVzt/FEZSo
 vkZwPyh4n7ZvaBFjdz8J+/QNrLaUsWqqz7cyq+cBiA5H/n5wuAGXX0QUMvOfOFk3f4D3x8g3H
 5TiNEzIzrXogoqTzMeBl7ocVrwPg6ER9rnDCBWiYFTVH3RGhnFNmRYlGNJrLsFvxB1+XOzN0M
 mk5hpW37rgkOZ8Sf5UkLplIq0gcwNzeorxFyqnU0HKWZROPbBZMk/C7oWnxhp3PdvbaBl+ju/
 /iRMFg==
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

6.2.7-rc2

compiles [1], boots and runs here on x86_64
(Intel i5-11400, Fedora 38 Beta)

[1]
with gcc version 13.0.1 only with WERROR=N

Thanks

Tested-by: Ronald Warsow <rwarsow@gmx.de>

