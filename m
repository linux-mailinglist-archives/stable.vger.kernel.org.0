Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 10C586BE32C
	for <lists+stable@lfdr.de>; Fri, 17 Mar 2023 09:23:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230287AbjCQIXQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 17 Mar 2023 04:23:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57088 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230148AbjCQIXL (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 17 Mar 2023 04:23:11 -0400
Received: from wout2-smtp.messagingengine.com (wout2-smtp.messagingengine.com [64.147.123.25])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 94B3694F58
        for <stable@vger.kernel.org>; Fri, 17 Mar 2023 01:22:46 -0700 (PDT)
Received: from compute6.internal (compute6.nyi.internal [10.202.2.47])
        by mailout.west.internal (Postfix) with ESMTP id 1BCAB32008FB;
        Fri, 17 Mar 2023 04:22:22 -0400 (EDT)
Received: from imap51 ([10.202.2.101])
  by compute6.internal (MEProxy); Fri, 17 Mar 2023 04:22:24 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arndb.de; h=cc
        :cc:content-transfer-encoding:content-type:content-type:date
        :date:from:from:in-reply-to:in-reply-to:message-id:mime-version
        :references:reply-to:sender:subject:subject:to:to; s=fm1; t=
        1679041341; x=1679127741; bh=JhkiIgHcTq9SiwecolHK/zmFODgtw10aWo7
        MMP1naFU=; b=UKcQCCo2mWl87bckAKY6/EEC8I9fshymrIjCEKVKwj7IO2mlp8i
        F3nIXjv4hQrGeaw22p59c8KQu/A+2NDqef6Hxt3BN3eUDCpgTYABX6XKy+uB6tZC
        QI31lyE6RCli5CtwGWsi3WB8DiFNrsjjlKAZ84IgA510a/YPTb4SjpwwJnIKp3IL
        5XRBmPKmr7BLrDWb5gVklbOyE3JIl7dNlZWuImve+mKFOwzHfGtoLg1jcBDlBbgb
        2NWtvwcH3XX70ptBfPdf7yPNPcO9a6yhaj3pfeRtxQfpU1x1Xdm7rFrbNeBKaROR
        fufGE+cECUi9De05BglAh2OPgqNko/PcBGA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:cc:content-transfer-encoding
        :content-type:content-type:date:date:feedback-id:feedback-id
        :from:from:in-reply-to:in-reply-to:message-id:mime-version
        :references:reply-to:sender:subject:subject:to:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; t=
        1679041341; x=1679127741; bh=JhkiIgHcTq9SiwecolHK/zmFODgtw10aWo7
        MMP1naFU=; b=RsR1Rc1WrLuiUDlTOQAM3vQDBw671pWf9LMkLWiHAh1p2dGcEGJ
        bvTqek3V3HG7D2kMAGov2sgQ5r5bHOiA0Hm54+4XccNp0ZS+E4ZvVQnNgoErrGPd
        ZqrpEKJJ04J/a7coi0LHt7MYylmYC8v5yspWR1xaLLkW572YzkaiC3pvTUDqpK1z
        ja9KGRJBvvdA98htyK+wsYuIonzmMoaWeQ0tC2Qtd1xklB7QF1TE3hfaI432+gpV
        lmXU1lMQIg5wpkrQvX8St08PpzMU1YZGATI1b7j/8H93dS9olRvF8iUyDsXDkLE4
        ZRWw/TQ/UBdd6xT/B4H4hPgIgYdSbdmDWsA==
X-ME-Sender: <xms:OyMUZCM63YnQXS3IptXec-oF_M4gxgnjvAxc1aIERohqSefKy520uQ>
    <xme:OyMUZA9Pp68x9pz5GVAfb78GuYnOLkbssyujeTDWRJt8Di1l0eWBtiwodE804lk3r
    CV8mfjhyhqRt_BbcVc>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvhedrvdefuddguddvtdcutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfgh
    necuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
    enucfjughrpefofgggkfgjfhffhffvvefutgfgsehtqhertderreejnecuhfhrohhmpedf
    tehrnhguuceuvghrghhmrghnnhdfuceorghrnhgusegrrhhnuggsrdguvgeqnecuggftrf
    grthhtvghrnhepgeefjeehvdelvdffieejieejiedvvdfhleeivdelveehjeelteegudek
    tdfgjeevnecuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomh
    eprghrnhgusegrrhhnuggsrdguvg
X-ME-Proxy: <xmx:OyMUZJR7ePbipbMIuZH9b2fc1kOhmjN9lvmnHxQGNbebkRDqM1mY1Q>
    <xmx:OyMUZCsCp7nBUnQuzKzLy2Xs91KYiWlrj1Ylh5cOh89gaI1BDZ6lQg>
    <xmx:OyMUZKdS9p1pdw3FXHn9Jr_LrfSZtaT6E4aK8lq9nWbCHgB1zCOIww>
    <xmx:PSMUZLu3SBTxLGDaPf-u4J7UJ_7iIzyW6dYgh-3hnqdLMBAjRiRI2A>
Feedback-ID: i56a14606:Fastmail
Received: by mailuser.nyi.internal (Postfix, from userid 501)
        id 6401DB60086; Fri, 17 Mar 2023 04:22:19 -0400 (EDT)
X-Mailer: MessagingEngine.com Webmail Interface
User-Agent: Cyrus-JMAP/3.9.0-alpha0-221-gec32977366-fm-20230306.001-gec329773
Mime-Version: 1.0
Message-Id: <f35be7b1-25d6-4ae8-a009-89b5451a10b9@app.fastmail.com>
In-Reply-To: <tencent_237449E643BFE56794AA49EAA3A09A499907@qq.com>
References: <tencent_FE90DDE46BFA03B385DFC4B367953D357206@qq.com>
 <ZBF5vkkwB+qs2GlS@kroah.com>
 <tencent_237449E643BFE56794AA49EAA3A09A499907@qq.com>
Date:   Fri, 17 Mar 2023 09:21:57 +0100
From:   "Arnd Bergmann" <arnd@arndb.de>
To:     "Wen Yang" <wenyang.linux@foxmail.com>,
        "Greg Kroah-Hartman" <gregkh@linuxfoundation.org>
Cc:     "Sasha Levin" <sashal@kernel.org>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        "Christoph Hellwig" <hch@infradead.org>,
        "Catalin Marinas" <catalin.marinas@arm.com>,
        "Will Deacon" <will@kernel.org>,
        "Thomas Bogendoerfer" <tsbogend@alpha.franken.de>,
        "James E . J . Bottomley" <James.Bottomley@hansenpartnership.com>,
        "Helge Deller" <deller@gmx.de>,
        "Michael Ellerman" <mpe@ellerman.id.au>,
        "Benjamin Herrenschmidt" <benh@kernel.crashing.org>,
        "Paul Mackerras" <paulus@samba.org>,
        "Heiko Carstens" <hca@linux.ibm.com>,
        "Vasily Gorbik" <gor@linux.ibm.com>,
        "Christian Borntraeger" <borntraeger@de.ibm.com>,
        "David S . Miller" <davem@davemloft.net>,
        "Thomas Gleixner" <tglx@linutronix.de>,
        "Ingo Molnar" <mingo@redhat.com>, "Borislav Petkov" <bp@alien8.de>,
        "H. Peter Anvin" <hpa@zytor.com>,
        "Alexander Viro" <viro@zeniv.linux.org.uk>,
        "Feng Tang" <feng.tang@intel.com>,
        "Christoph Hellwig" <hch@lst.de>,
        "Andrew Morton" <akpm@linux-foundation.org>,
        "Linus Torvalds" <torvalds@linux-foundation.org>,
        stable@vger.kernel.org
Subject: Re: [PATCH 1/3] kexec: move locking into do_kexec_load
Content-Type: text/plain;charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,URIBL_BLOCKED autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Mar 16, 2023, at 18:18, Wen Yang wrote:
> =E5=9C=A8 2023/3/15 15:54, Greg Kroah-Hartman =E5=86=99=E9=81=93:
>> On Thu, Mar 02, 2023 at 12:18:04AM +0800, wenyang.linux@foxmail.com w=
rote:
>>> From: Arnd Bergmann <arnd@arndb.de>
>>>
>>> commit 4b692e861619353ce069e547a67c8d0e32d9ef3d upstream.
>>>
>>> Patch series "compat: remove compat_alloc_user_space", v5.
>>>
>>> Going through compat_alloc_user_space() to convert indirect system c=
all
>>> arguments tends to add complexity compared to handling the native and
>>> compat logic in the same code.
>>>
>>> This patch (of 6):
>> What about the other 6?
>
> Hi,
> Both 4b692e861619 ("kexec: move locking into do_kexec_load") and=20
> 7bb5da0d490b
> ("kexec: turn all kexec_mutex acquisitions into trylocks") are prerequ=
isites
> for 05c6257433b7 ("panic, kexec: make __crash_kexec() NMI safe").
>
> In addition, although 4b692e861619 ("kexec: move locking into=20
> do_kexec_load")
> is part of patch series "compat: remove compat_alloc_user_space", it i=
s also
> independent and a general optimization,=C2=A0 and here we just need is=
 it, as=20
> follows:

Ok, this makes much more sense then, without the explanation
I had no idea why you would backport my old patch.

      Arnd
