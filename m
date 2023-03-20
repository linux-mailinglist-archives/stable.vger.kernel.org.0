Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F3D7B6C0AD1
	for <lists+stable@lfdr.de>; Mon, 20 Mar 2023 07:45:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229977AbjCTGpI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Mar 2023 02:45:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49360 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229968AbjCTGpH (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Mar 2023 02:45:07 -0400
Received: from wp530.webpack.hosteurope.de (wp530.webpack.hosteurope.de [80.237.130.52])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 761832D40;
        Sun, 19 Mar 2023 23:45:06 -0700 (PDT)
Received: from [2a02:8108:8980:2478:8cde:aa2c:f324:937e]; authenticated
        by wp530.webpack.hosteurope.de running ExIM with esmtpsa (TLS1.3:ECDHE_RSA_AES_128_GCM_SHA256:128)
        id 1pe9GS-0007YZ-Gk; Mon, 20 Mar 2023 07:45:04 +0100
Message-ID: <e6314dd6-df75-fff8-1e3c-546b2b44be5b@leemhuis.info>
Date:   Mon, 20 Mar 2023 07:45:04 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.8.0
Subject: Re: Consider picking up "scsi: core: Fix a procfs host directory
 removal regression" for stable
Content-Language: en-US, de-DE
From:   "Linux regression tracking (Thorsten Leemhuis)" 
        <regressions@leemhuis.info>
To:     Greg KH <gregkh@linuxfoundation.org>
Cc:     Linux kernel regressions list <regressions@lists.linux.dev>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Bart Van Assche <bvanassche@acm.org>,
        scsi <linux-scsi@vger.kernel.org>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
Reply-To: Linux regressions mailing list <regressions@lists.linux.dev>,
          Linux regressions mailing list 
          <regressions@lists.linux.dev>
References: <472c53aa-4803-cde9-8f80-cbd7d33dc9c5@leemhuis.info>
In-Reply-To: <472c53aa-4803-cde9-8f80-cbd7d33dc9c5@leemhuis.info>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-bounce-key: webpack.hosteurope.de;regressions@leemhuis.info;1679294706;df4130bf;
X-HE-SMSGID: 1pe9GS-0007YZ-Gk
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 20.03.23 07:19, Linux regression tracking (Thorsten Leemhuis) wrote:
> Hi Greg. From https://bugzilla.kernel.org/show_bug.cgi?id=217215 it
> looks like you want to add be03df3d4bfe ("scsi: core: Fix a procfs host
> directory removal regression") to your stable queue. It lacks a stable
> tag, but fixes a bug in a commit that afaics was backported to all
> stable series last week.
> 
> Side note: would you scripts have noticed this automatically and added
> it to the queue today? (Just wondering if this mail actually makes any
> difference.)

Sorry, ignore that, I noticed that fix is already in your queue (I
looked at it before writing that mail, but it seems I somehow missed it
and only noticed now; sorry for the noise).

Ciao, Thorsten
