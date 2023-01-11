Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4DF4B665D8E
	for <lists+stable@lfdr.de>; Wed, 11 Jan 2023 15:19:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238950AbjAKOS6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 11 Jan 2023 09:18:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32942 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239254AbjAKOSe (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 11 Jan 2023 09:18:34 -0500
Received: from wout5-smtp.messagingengine.com (wout5-smtp.messagingengine.com [64.147.123.21])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BC4DC12A8A;
        Wed, 11 Jan 2023 06:18:30 -0800 (PST)
Received: from compute6.internal (compute6.nyi.internal [10.202.2.47])
        by mailout.west.internal (Postfix) with ESMTP id C00F63200909;
        Wed, 11 Jan 2023 09:18:28 -0500 (EST)
Received: from imap51 ([10.202.2.101])
  by compute6.internal (MEProxy); Wed, 11 Jan 2023 09:18:30 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arndb.de; h=cc
        :cc:content-transfer-encoding:content-type:date:date:from:from
        :in-reply-to:in-reply-to:message-id:mime-version:references
        :reply-to:sender:subject:subject:to:to; s=fm2; t=1673446708; x=
        1673533108; bh=dJ/xXFSDkjEfqMBaE24FsQ41/V3SlHaKIpW7ZnfXo14=; b=O
        3CBp4GVX4+kfAK4zkgmj7UVzvtoyfbLPKwsbxigLSQOzRSNWZ+WZOxgw6rTocR+u
        d6sjMkozZO5MIjPURkM5+iZKHdRupN/rrN7KgmDvAzqU0PN1IR/llka83TOBaKIM
        HfPNir0W/yqjrHgI+Gfw8JOOG3EOXfN7j34FoY/vsO47AUJN9SvCMfDk8d/HeR6R
        sQMQmNv3ZSr+Fu2Jfb+rnt2hOEtDj/rOetYSU6jKg3zSIIol/KMFpvULZRvFz1if
        Ay8PNmSbSkhHc3l9ts6eSKkHpf2RgFruUOa8H8DG6lWpfVgy5Agy4korlVa/loHA
        3fVLGWTNXFhzccbDFylOg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:cc:content-transfer-encoding
        :content-type:date:date:feedback-id:feedback-id:from:from
        :in-reply-to:in-reply-to:message-id:mime-version:references
        :reply-to:sender:subject:subject:to:to:x-me-proxy:x-me-proxy
        :x-me-sender:x-me-sender:x-sasl-enc; s=fm3; t=1673446708; x=
        1673533108; bh=dJ/xXFSDkjEfqMBaE24FsQ41/V3SlHaKIpW7ZnfXo14=; b=B
        QBVhkhxdRHBx+qk8OOTVGOKOmyLHgJi04smlPmb6kJ5gdCRYy5nuSXKI/ow7DDPC
        gL+4H5VWz5X9XwoVZ4fIoU1UIQeUxOzXJVy7cZdqHfQaxM5hGIthnXL+FTcSmc06
        VLz3tkXFQ0N3IwzZFjH4HxNy7gji4EJjTKZy4t//nbBCTV6JzmrJvelQFnE+bxca
        rsxM9JP1o0uShqUJppFAYYOY8B4LtHmmwK1GridVP8SPO8A4Z5AOCrw2jEdewcBT
        hlla+PlA1Fs8YbzxviQuBOc4KkW0avERrnaqBDkmtfg4flrd+7BGh0nEtP2in1T5
        a6fuMKU12OPjxFNnV2aDw==
X-ME-Sender: <xms:M8W-Y4rwJZBSegkXLoGznwe25f5Ggk8HogpmfmGSUA1MQtNxh_qJRA>
    <xme:M8W-Y-qCcSmdLUvVm21otl9wymnn7O2DTIhpLPlvS_Re_dfKhBXcD8-I2bcxf_NZc
    chVTAy1LEOkrcihYNw>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvhedrleeggdeivdcutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenuc
    fjughrpefofgggkfgjfhffhffvvefutgfgsehtqhertderreejnecuhfhrohhmpedftehr
    nhguuceuvghrghhmrghnnhdfuceorghrnhgusegrrhhnuggsrdguvgeqnecuggftrfgrth
    htvghrnhepgfekueelgeeigefhudduledtkeefffejueelheelfedutedttdfgveeufeef
    ieegnecuffhomhgrihhnpehkvghrnhgvlhdrohhrghenucevlhhushhtvghrufhiiigvpe
    dtnecurfgrrhgrmhepmhgrihhlfhhrohhmpegrrhhnugesrghrnhgusgdruggv
X-ME-Proxy: <xmx:M8W-Y9NRCzTXN6E0c-hxHHYlur2UebEpH0V3CM0wSn6ziO1E2oQUOw>
    <xmx:M8W-Y_7UvAHc0Mc93Is7ro1T23nC1WJcmVijJW9iixuVt_0fGOziZg>
    <xmx:M8W-Y36oLj_vs5mBGfsqap7w2dVXigEgCnppPBBk_Ln3SAM1vtnr0g>
    <xmx:NMW-Y2o2BW_uXjCRtuKBXRGQzKedTLLAhlGNKUMer1WMci7kMS0_Eg>
Feedback-ID: i56a14606:Fastmail
Received: by mailuser.nyi.internal (Postfix, from userid 501)
        id BC0C8B60086; Wed, 11 Jan 2023 09:18:27 -0500 (EST)
X-Mailer: MessagingEngine.com Webmail Interface
User-Agent: Cyrus-JMAP/3.7.0-alpha0-1185-g841157300a-fm-20221208.002-g84115730
Mime-Version: 1.0
Message-Id: <ff7096b8-aaee-45db-8d0a-2790d9d227eb@app.fastmail.com>
In-Reply-To: <CA+G9fYuQzq1bBt9k0PtpAc0Ubn9wXmjzVGNRhSOFBr-fx3KQQw@mail.gmail.com>
References: <20230110180018.288460217@linuxfoundation.org>
 <CA+G9fYuQzq1bBt9k0PtpAc0Ubn9wXmjzVGNRhSOFBr-fx3KQQw@mail.gmail.com>
Date:   Wed, 11 Jan 2023 15:18:08 +0100
From:   "Arnd Bergmann" <arnd@arndb.de>
To:     "Naresh Kamboju" <naresh.kamboju@linaro.org>,
        "Greg Kroah-Hartman" <gregkh@linuxfoundation.org>
Cc:     stable@vger.kernel.org, patches@lists.linux.dev,
        linux-kernel@vger.kernel.org,
        "Linus Torvalds" <torvalds@linux-foundation.org>,
        "Andrew Morton" <akpm@linux-foundation.org>,
        "Guenter Roeck" <linux@roeck-us.net>, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org,
        "Pavel Machek" <pavel@denx.de>,
        "Jon Hunter" <jonathanh@nvidia.com>,
        "Florian Fainelli" <f.fainelli@gmail.com>,
        "Sudip Mukherjee" <sudipm.mukherjee@gmail.com>,
        srw@sladewatkins.net, rwarsow@gmx.de,
        "Mark Brown" <broonie@kernel.org>
Subject: Re: [PATCH 6.1 000/159] 6.1.5-rc1 review
Content-Type: text/plain;charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_PASS,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Jan 11, 2023, at 07:55, Naresh Kamboju wrote:
> On Tue, 10 Jan 2023 at 23:44, Greg Kroah-Hartman
> <gregkh@linuxfoundation.org> wrote:
>>
>> This is the start of the stable review cycle for the 6.1.5 release.
>> There are 159 patches in this series, all will be posted as a response
>> to this one.  If anyone has any issues with these being applied, plea=
se
>> let me know.
>>
>> Responses should be made by Thu, 12 Jan 2023 17:59:42 +0000.
>> Anything received after that time might be too late.
>>
>> The whole patch series can be found in one patch at:
>>         https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/pa=
tch-6.1.5-rc1.gz
>> or in the git tree and branch at:
>>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git linux-6.1.y
>> and the diffstat can be found below.
>>
>> thanks,
>>
>> greg k-h
>
> Results from Linaro=E2=80=99s test farm.
> Regressions on arm64 FVP.
>
> Reported-by: Linux Kernel Functional Testing <lkft@linaro.org>
>
> Following kernel panic and warning notices on FVP 64k page size
> enabled gcc-12 build on 6.1 and 6.0 kernel Image while running
> LTP mm test cases.
>
> CONFIG_ARM64_64K_PAGES=3Dy

I assume you mean this only happens with 64K pages but not 4K pages?
I see the machine only has 4GB of RAM, so it's possible this is
a side-effect of an out-of-memory condition somewhere as kernels
with 64K pages need a lot more RAM.

>    SError Interrupt on CPU3, code 0x00000000be000000 -- SError
>     Kernel panic - not syncing: Asynchronous SError Interrupt

This is an SError from user space, where the 'be' bit is the
encoding for SError, and the ISS and ISS2 words are all zero.

The CPU enables the 'RAS' extension, so ISS is defined according
to [1], but none of the bits are set, so this is 'Uncategorized'.

This seems particularly unhelpful from FVP, possibly a bug
in the RAS error reporting.

>     WARNING: CPU: 3 PID: 685 at kernel/sched/core.c:3113 set_task_cpu

This again seems unrelated and only happens when it panics the
second time.

      Arnd
