Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 97CC451B1D8
	for <lists+stable@lfdr.de>; Thu,  5 May 2022 00:28:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1377565AbiEDWcI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 4 May 2022 18:32:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48356 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1379033AbiEDWbz (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 4 May 2022 18:31:55 -0400
X-Greylist: delayed 427 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Wed, 04 May 2022 15:28:15 PDT
Received: from mout01.posteo.de (mout01.posteo.de [185.67.36.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 044F950B2D
        for <stable@vger.kernel.org>; Wed,  4 May 2022 15:28:14 -0700 (PDT)
Received: from submission (posteo.de [185.67.36.169]) 
        by mout01.posteo.de (Postfix) with ESMTPS id 8CD81240027
        for <stable@vger.kernel.org>; Thu,  5 May 2022 00:21:05 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=posteo.de; s=2017;
        t=1651702865; bh=l5fU5AlspjVNt2vkjfCweBCpgGYWhRAH4hwZaPcBIdo=;
        h=From:To:Cc:Subject:Date:From;
        b=LKN/2vLrJNi011b4JZAlXEjOoI7ZbPPNS4mQ8tWsbSVCURXg2WzN0XgeKo93zn5Y8
         Pze/9jghh0cI3S9saWXbXYN3wNBSscnXVYXYAHGfNL1dNhbTN2SVVAseLu4UwvoRNw
         JNWObC0awcnPdAxpA4hL5wNf41dlxOoeq7XB2OBYwlmlebHkQ7NSqQbzbpRjeC0JAc
         FygdvVNoMzMVoWnp9ubuRWvGJnFSfeXBHo5ZWkbUbnach1cijZgRZ2S5dkisQYyoSu
         Zl5heZ1pbYmNYu6ovP9ggBwCFjjPufkOSABkAK0xmRzblR3eFdXfRbf76A4u42onAe
         tbjCIUuziEhQg==
Received: from customer (localhost [127.0.0.1])
        by submission (posteo.de) with ESMTPSA id 4Ktrrc6vwPz6tpJ;
        Thu,  5 May 2022 00:21:04 +0200 (CEST)
From:   Manuel Ullmann <labre@posteo.de>
To:     Jordan Leppert <jordanleppert@protonmail.com>
Cc:     labre@posteo.de, stable@vger.kernel.org,
        regressions@lists.linux.dev, davem@davemloft.net
Subject: Re: Crash on resume after suspend (5.17.5 and 5.15.36)
References: <refZ3y2HAXztrRkMMmFbBaF7Dz1CctWgjchSdBtcSNlpk-TL0fqLepVVHfw9qXtIQF9uFzBvFdjQiiX9Jv2zW9oaWej952s1IYwu61d1REo=@protonmail.com>
        <9-Ehc_xXSwdXcvZqKD5aSqsqeNj5Izco4MYEwnx5cySXVEc9-x_WC4C3kAoCqNTi-H38frroUK17iobNVnkLtW36V6VWGSQEOHXhmVMm5iQ=@protonmail.com>
        <87levhnlqu.fsf@posteo.de>
        <vcehgVc5mzweaw_ru0o1up63In2GGa9jtEWuaH8op7p2753Wfr2ezPhxFJdMPFxmpiPmrUB4XnH2nakuhC_BJby3wFa87cbpdLV-lDDb6Ko=@protonmail.com>
Date:   Wed, 04 May 2022 22:21:20 +0000
In-Reply-To: <vcehgVc5mzweaw_ru0o1up63In2GGa9jtEWuaH8op7p2753Wfr2ezPhxFJdMPFxmpiPmrUB4XnH2nakuhC_BJby3wFa87cbpdLV-lDDb6Ko=@protonmail.com>
        (Jordan Leppert's message of "Wed, 04 May 2022 21:13:45 +0000")
Message-ID: <874k252b33.fsf@posteo.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

> I also probably can't test hibernation, never managed to get it
> working before. I'll give it a shot tomorrow though if I have time but
> I don't even have swap set up ATM.
That=E2=80=99s a pity, but okay, of course. Thanks for reporting this bug.

Since you are using Arch and the Wiki is quite detailed, you could try
setting up a swap on an unused USB stick floating around. This should be
the easiest setup. Make sure to add resume to the mkinitcpio hooks after
udev, but before fsck and add the resume parameter to your bootloader as
described in the Wiki. This should get you going.

Don=E2=80=99t make this a permanent setup, if you use encryption or like
performance. The permanent solution would be creating a swap partition
or, if that is not feasible, a swap file while considering the Wiki
notes for e.g. btrfs.

Best regards,
Manuel
