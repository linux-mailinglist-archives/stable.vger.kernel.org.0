Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B314851BD5D
	for <lists+stable@lfdr.de>; Thu,  5 May 2022 12:41:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230474AbiEEKpF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 5 May 2022 06:45:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53728 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350843AbiEEKpE (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 5 May 2022 06:45:04 -0400
X-Greylist: delayed 70412 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Thu, 05 May 2022 03:41:25 PDT
Received: from mail-40133.protonmail.ch (mail-40133.protonmail.ch [185.70.40.133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8EC0F53713
        for <stable@vger.kernel.org>; Thu,  5 May 2022 03:41:25 -0700 (PDT)
Date:   Thu, 05 May 2022 10:41:20 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=protonmail.com;
        s=protonmail2; t=1651747283;
        bh=HX4bsMCY4yqCwAMQt5vrUSJwA9Pa8B7VgBj9P7iping=;
        h=Date:To:From:Cc:Reply-To:Subject:Message-ID:In-Reply-To:
         References:Feedback-ID:From:To:Cc:Date:Subject:Reply-To:
         Feedback-ID:Message-ID;
        b=MZl17klYlm5FQGYsk0zl62Lo5bmr2bHWxxLFBq2vDkVWH9AbWZFfKb+D9X2XDKP1g
         gZNWbgLjXU8kQwk/XD+NT5brF4ZYaL8IjcvLnPhHl4T926lhEtKc5qC7BOsEATuBuJ
         8SZ2NBBbWeACc5aGb11+5Ef6HTaHnBJP8B4OSunmdf3ImT1MvtPqWWiWQFinm1g5GV
         cEj//tTM7sSca2WfY1yInBzudTl9DZyG+3PIOPb1DO+Q2isi0WKFNDjT4UYcoh0Rdg
         SYu7Jh9zlGPSqNt4rrJr7uJvjY/aZMFX7GV5DDTDkOt3tLzzQMGPSC6dPPy1GTpG4o
         lIPXhyHrdtvCQ==
To:     Manuel Ullmann <labre@posteo.de>
From:   Jordan Leppert <jordanleppert@protonmail.com>
Cc:     stable@vger.kernel.org, regressions@lists.linux.dev,
        davem@davemloft.net
Reply-To: Jordan Leppert <jordanleppert@protonmail.com>
Subject: Re: Crash on resume after suspend (5.17.5 and 5.15.36)
Message-ID: <qkDMdC7Zb8bQ093sjURDqQpwhYplNlnDfSc7gGyJm2Lyh_uv3HRVv2cJEH6mJWtj8x7FN2v97EIPfvVVB3ZX68VAsqj_96Cgn6bqbkEP-no=@protonmail.com>
In-Reply-To: <874k252b33.fsf@posteo.de>
References: <refZ3y2HAXztrRkMMmFbBaF7Dz1CctWgjchSdBtcSNlpk-TL0fqLepVVHfw9qXtIQF9uFzBvFdjQiiX9Jv2zW9oaWej952s1IYwu61d1REo=@protonmail.com> <9-Ehc_xXSwdXcvZqKD5aSqsqeNj5Izco4MYEwnx5cySXVEc9-x_WC4C3kAoCqNTi-H38frroUK17iobNVnkLtW36V6VWGSQEOHXhmVMm5iQ=@protonmail.com> <87levhnlqu.fsf@posteo.de> <vcehgVc5mzweaw_ru0o1up63In2GGa9jtEWuaH8op7p2753Wfr2ezPhxFJdMPFxmpiPmrUB4XnH2nakuhC_BJby3wFa87cbpdLV-lDDb6Ko=@protonmail.com> <874k252b33.fsf@posteo.de>
Feedback-ID: 43610911:user:proton
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,SPF_HELO_PASS,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Thanks for the suggestion of using a USB stick, I managed to get it set up,=
 and hibernate actually works! Slightly in shock, once I get a proper swap =
partition set up I can turn my PC off at night now.



------- Original Message -------
On Wednesday, May 4th, 2022 at 23:21, Manuel Ullmann <labre@posteo.de> wrot=
e:


>
>
> > I also probably can't test hibernation, never managed to get it
>
> > working before. I'll give it a shot tomorrow though if I have time but
> > I don't even have swap set up ATM.
>
> That=E2=80=99s a pity, but okay, of course. Thanks for reporting this bug=
.
>
> Since you are using Arch and the Wiki is quite detailed, you could try
> setting up a swap on an unused USB stick floating around. This should be
> the easiest setup. Make sure to add resume to the mkinitcpio hooks after
> udev, but before fsck and add the resume parameter to your bootloader as
> described in the Wiki. This should get you going.
>
> Don=E2=80=99t make this a permanent setup, if you use encryption or like
> performance. The permanent solution would be creating a swap partition
> or, if that is not feasible, a swap file while considering the Wiki
> notes for e.g. btrfs.
>
> Best regards,
> Manuel
