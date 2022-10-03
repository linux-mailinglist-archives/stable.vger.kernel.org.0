Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BC0CC5F33CF
	for <lists+stable@lfdr.de>; Mon,  3 Oct 2022 18:44:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229539AbiJCQoQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 Oct 2022 12:44:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47306 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229627AbiJCQoE (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 3 Oct 2022 12:44:04 -0400
X-Greylist: delayed 90 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Mon, 03 Oct 2022 09:44:03 PDT
Received: from omta002.uswest2.a.cloudfilter.net (omta002.uswest2.a.cloudfilter.net [35.164.127.225])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7CD3E10FD5
        for <stable@vger.kernel.org>; Mon,  3 Oct 2022 09:44:03 -0700 (PDT)
Received: from mcc-obgw-6002a.ext.cloudfilter.net ([10.244.128.101])
        by cmsmtp with ESMTP
        id fKusoxWI49VNRfOWWoocId; Mon, 03 Oct 2022 16:42:32 +0000
Received: from email-vm.mattli.us ([173.27.162.33])
        by cmsmtp with ESMTPA
        id fOWToCBuBqMqMfOWUoY5MZ; Mon, 03 Oct 2022 16:42:32 +0000
X-MCC-ORCPT: stable@vger.kernel.org
Authentication-Results: mediacombb.net; auth=pass (PLAIN)
 smtp.auth=david.mattli@mediacombb.net
X-Authority-Analysis: v=2.4 cv=Zoz+lv3G c=1 sm=1 tr=0 ts=633b10f8 cx=a_idp_d
 a=tRjK+akC81Zce8LZyUhMfQ==:117 a=tRjK+akC81Zce8LZyUhMfQ==:17
 a=xqWC_Br6kY4A:10 a=MKtGQD3n3ToA:10 a=1oJP67jkp3AA:10 a=Qawa6l4ZSaYA:10
 a=ia6QREUL-R0A:10 a=ag1SF4gXAAAA:8 a=2wXMG3RYSgltRIXcnyMA:9
 a=Yupwre4RP9_Eg_Bd0iYG:22 a=eeDtFMHqlkPJeBvn9BwJ:22 a=hoQAOFghBJg7R_dSpG8l:22
 a=7PlhcU7xGnINJ2miruxK:22 a=bMrFyaAnRwegQDxt2Pzk:22 a=8iqKRNYe-yLjZuHCO3rH:22
 a=cPQSjfK2_nFv0Q5t_7PE:22 a=0UC15zM8_Iz3fgbILQhT:22
Received: from [2604:2d80:5f83:4200:89b4:795f:d2c4:903e] (port=49092 helo=framey)
        by email-vm.mattli.us with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <dmm@mattli.us>)
        id 1ofOWR-005R9I-EV; Mon, 03 Oct 2022 11:42:27 -0500
From:   David Matthew Mattli <dmm@mattli.us>
To:     Greg KH <gregkh@linuxfoundation.org>
Cc:     Jerry Ling <jiling@cern.ch>,
        Thorsten Leemhuis <regressions@leemhuis.info>,
        stable@vger.kernel.org, regressions@lists.linux.dev
References: <55905860-adf9-312c-69cc-491ac8ce1a8b@cern.ch>
        <b85bc2cf-5ea5-c5fb-465c-cd6637f6d30f@leemhuis.info>
        <36d318f0-9fc4-d5d9-9dc2-26145c963f0f@cern.ch> <YzcE/YEKcUDzuES/@kroah.com>
Date:   Mon, 03 Oct 2022 11:42:25 -0500
In-Reply-To: <YzcE/YEKcUDzuES/@kroah.com> (Greg KH's message of "Fri, 30 Sep
        2022 17:02:21 +0200")
Message-ID: <87y1twkgem.fsf@mattli.us>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/28.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-SA-Exim-Connect-IP: 2604:2d80:5f83:4200:89b4:795f:d2c4:903e
X-SA-Exim-Mail-From: dmm@mattli.us
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
X-Spam-Level: 
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
Subject: Re: Regression on 5.19.12, display flickering on Framework laptop
X-SA-Exim-Version: 4.2.1 (built Sat, 13 Feb 2021 17:57:42 +0000)
X-SA-Exim-Scanned: Yes (on email-vm.mattli.us)
X-CMAE-Envelope: MS4xfCsVYgjxw5Bdx/Oaewaujm91nULCEtYa+M+sTXB6esUE38JPksj0vawHVhFoXLglyPY1wKhMdNFOPLR2sZgfLXn5e+o++xBvP4LyFWs7R4Bh0BQNeRD2
 mwENqR9isxQbwnIz1h3BaGwVCkQiz+Nm8KNLkZGPXO1SYcYLVJIUq1ZaZ0HJPpsPeHNUlWazfRbQFf4tKEczydekZilAUJ6FFBgZBIbqdntkcSP6IdrgGWBG
 m8p9haTySOvprFmHN1c6Ea8AIOFKSf8KZej1FRb075VKe1z2Bev79HtRGshk5mnf2fq8Q/Vg8xBF0JfAhdgcRiqoEla90daGGqeSAU5jFKU=
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Greg KH <gregkh@linuxfoundation.org> writes:

> On Fri, Sep 30, 2022 at 09:05:31AM -0400, Jerry Ling wrote:
>> > If it is, simply starting with "i915.enable_psr=0" might already help.
>> 
>> unfortunately this didn't help.
>
> Ick.  Ok, can you test your own kernel build out?  If I provide a patch
> that reverts the what I think are offending commits, can you test it?
>
> Also, does 6.0-rc7 also have this same problem?  That should be tested
> first here, and if that's a problem, then we can get the i915 developers
> involved.

5.19.11 and 6.0 work fine on my 12th gen Framework. 5.19.12 has the
flickering problem that's unaffected by "i915.enable_psr=0".

I'm also available to test patches if needed.

>
> thanks,
>
> greg k-h

thanks,

David Mattli
