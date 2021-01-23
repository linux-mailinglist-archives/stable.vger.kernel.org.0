Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 04BD7301478
	for <lists+stable@lfdr.de>; Sat, 23 Jan 2021 11:12:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726849AbhAWKMN convert rfc822-to-8bit (ORCPT
        <rfc822;lists+stable@lfdr.de>); Sat, 23 Jan 2021 05:12:13 -0500
Received: from lithops.sigma-star.at ([195.201.40.130]:44028 "EHLO
        lithops.sigma-star.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726810AbhAWKMF (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 23 Jan 2021 05:12:05 -0500
X-Greylist: delayed 358 seconds by postgrey-1.27 at vger.kernel.org; Sat, 23 Jan 2021 05:12:04 EST
Received: from localhost (localhost [127.0.0.1])
        by lithops.sigma-star.at (Postfix) with ESMTP id B54DA6074007;
        Sat, 23 Jan 2021 11:05:22 +0100 (CET)
Received: from lithops.sigma-star.at ([127.0.0.1])
        by localhost (lithops.sigma-star.at [127.0.0.1]) (amavisd-new, port 10032)
        with ESMTP id iF0YWO0cr0Iq; Sat, 23 Jan 2021 11:05:21 +0100 (CET)
Received: from localhost (localhost [127.0.0.1])
        by lithops.sigma-star.at (Postfix) with ESMTP id 0006C625DE06;
        Sat, 23 Jan 2021 11:05:20 +0100 (CET)
Received: from lithops.sigma-star.at ([127.0.0.1])
        by localhost (lithops.sigma-star.at [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id Artg8sMjyD81; Sat, 23 Jan 2021 11:05:20 +0100 (CET)
Received: from lithops.sigma-star.at (lithops.sigma-star.at [195.201.40.130])
        by lithops.sigma-star.at (Postfix) with ESMTP id CF7986074007;
        Sat, 23 Jan 2021 11:05:20 +0100 (CET)
Date:   Sat, 23 Jan 2021 11:05:20 +0100 (CET)
From:   Richard Weinberger <richard@nod.at>
To:     chengzhihao1 <chengzhihao1@huawei.com>
Cc:     linux-mtd <linux-mtd@lists.infradead.org>,
        david <david@sigma-star.at>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        stable <stable@vger.kernel.org>
Message-ID: <311070065.273732.1611396320672.JavaMail.zimbra@nod.at>
In-Reply-To: <5b51ff9c-8f5e-c348-5195-c0a0bf60b746@huawei.com>
References: <20210122212229.17072-1-richard@nod.at> <20210122212229.17072-4-richard@nod.at> <5b51ff9c-8f5e-c348-5195-c0a0bf60b746@huawei.com>
Subject: Re: [PATCH 3/4] ubifs: Update directory size when creating
 whiteouts
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
X-Originating-IP: [195.201.40.130]
X-Mailer: Zimbra 8.8.12_GA_3807 (ZimbraWebClient - FF78 (Linux)/8.8.12_GA_3809)
Thread-Topic: ubifs: Update directory size when creating whiteouts
Thread-Index: lBYr5nCGsjlO2WH9TnqNoD/UEPd7gA==
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

----- Ursprüngliche Mail -----
> Von: "chengzhihao1" <chengzhihao1@huawei.com>
> An: "richard" <richard@nod.at>, "linux-mtd" <linux-mtd@lists.infradead.org>
> CC: "david" <david@sigma-star.at>, "linux-kernel" <linux-kernel@vger.kernel.org>, "stable" <stable@vger.kernel.org>
> Gesendet: Samstag, 23. Januar 2021 03:45:15
> Betreff: Re: [PATCH 3/4] ubifs: Update directory size when creating whiteouts

> 在 2021/1/23 5:22, Richard Weinberger 写道:
>> Although whiteouts are unlinked files they will get re-linked later,
> I just want to make sure, is this where the count is increased?
> do_rename -> inc_nlink(whiteout)

Exactly. The logic is a little wicked, I agree.
Let me think again whether there isn't a better way to address 
the problem.

Thanks,
//richard

P.s: Thanks a lot for reviewing!
