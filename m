Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8ADEC5AD45D
	for <lists+stable@lfdr.de>; Mon,  5 Sep 2022 15:58:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236239AbiIEN4L (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 5 Sep 2022 09:56:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39596 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237362AbiIEN4J (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 5 Sep 2022 09:56:09 -0400
Received: from mail.toke.dk (mail.toke.dk [45.145.95.4])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BA71845983;
        Mon,  5 Sep 2022 06:56:04 -0700 (PDT)
From:   Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@toke.dk>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=toke.dk; s=20161023;
        t=1662386163; bh=BuTiFGRqWcD266TcYAJWnYVPIL5dSvOXAsFy0O2HOIk=;
        h=From:To:Cc:Subject:In-Reply-To:References:Date:From;
        b=a8krh8XlX8e3cgqPOevKXwrNk5JYeG69Ot5kCxJDcWEXBFcnV7leYStZsTX6mZ44m
         m0qJ77H0EXqnx1Vhuja3Q9ZbjaWhWjGzmWXPqSpCl7C6FOfDx3Z2ABiEikyYf113dV
         wdjELI6Q1gPceQordnNki6VG4f7Ca0kr1sdGmirelfVrn2Jk9aCgvnUIIjFSO7vFg5
         2mPgo0aMkoFLWp+54LYVfYqWK+1UlB/neFPIBvWt64aKIWci9do3A8M1VSYSUHSxdq
         EoX8I6JPtjjJQLleUT4RDT7Q724I2U6Ok3mvTGcqYPUhL8qBmtnKVhjFXSrzRCzNwJ
         R6w4Hn3xfiYiA==
To:     Sasha Levin <sashal@kernel.org>
Cc:     stable-commits@vger.kernel.org,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        "David S. Miller" <davem@davemloft.net>, stable@vger.kernel.org
Subject: Re: Patch "sch_cake: Return __NET_XMIT_STOLEN when consuming
 enqueued skb" has been added to the 4.19-stable tree
In-Reply-To: <YxX1jNpOCRkYlD1J@sashalap>
References: <20220905125828.1042711-1-sashal@kernel.org>
 <87sfl6yntg.fsf@toke.dk> <YxX1jNpOCRkYlD1J@sashalap>
Date:   Mon, 05 Sep 2022 15:56:03 +0200
X-Clacks-Overhead: GNU Terry Pratchett
Message-ID: <87mtbeylfw.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Sasha Levin <sashal@kernel.org> writes:

> On Mon, Sep 05, 2022 at 03:04:43PM +0200, Toke H=C3=B8iland-J=C3=B8rgense=
n wrote:
>>Sasha Levin <sashal@kernel.org> writes:
>>
>>> This is a note to let you know that I've just added the patch titled
>>>
>>>     sch_cake: Return __NET_XMIT_STOLEN when consuming enqueued skb
>>>
>>> to the 4.19-stable tree which can be found at:
>>>     http://www.kernel.org/git/?p=3Dlinux/kernel/git/stable/stable-queue=
.git;a=3Dsummary
>>>
>>> The filename of the patch is:
>>>      sch_cake-return-__net_xmit_stolen-when-consuming-enq.patch
>>> and it can be found in the queue-4.19 subdirectory.
>>>
>>> If you, or anyone else, feels it should not be added to the stable tree,
>>> please let <stable@vger.kernel.org> know about it.
>>
>>This patch was subsequently reverted; please drop it from all the stable
>>trees. The patch to be backported instead is this one:
>
> Yup, I took the revert too (makes tracking easier for us).

Ah, wasn't aware of this (and only got Cc'ed on this patch). That's
all fine, then :)

>>9efd23297cca ("sch_sfb: Don't assume the skb is still around after enqueu=
eing to child")
>
> Looks like it's not in Linus's tree yet.

No, looks like it missed the PR for -rc4. Should be included in the next
one (and presumably your normal process will pick it up).

-Toke
