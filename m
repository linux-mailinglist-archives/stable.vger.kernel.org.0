Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D1B0FAC9A7
	for <lists+stable@lfdr.de>; Sun,  8 Sep 2019 00:04:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729366AbfIGWEv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 7 Sep 2019 18:04:51 -0400
Received: from mail.kernel.org ([198.145.29.99]:48930 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727736AbfIGWEv (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 7 Sep 2019 18:04:51 -0400
Received: from localhost (unknown [62.28.240.114])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 68A18208C3;
        Sat,  7 Sep 2019 22:04:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1567893890;
        bh=yiwL59PzzZwDqWaxr+QzIl79z/yYj6BVf3CAazvxQa4=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Xb1cdUK+gOyCZxk6wzqajZPJ3U5XmY5rN//nLEvUtI2t3QxrBR6ALsvM2aDgnsboD
         fmHB+3Q9GZ0K4B8/B/2hFEizl3jwiZs7zjELO8TbmimVKSAFk67e7VwFUSJP/JgyCJ
         NqEUenQppKK/MntPBcZcACUH0A3M3j8JI/6nNs0c=
Date:   Sat, 7 Sep 2019 18:04:48 -0400
From:   Sasha Levin <sashal@kernel.org>
To:     Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Cc:     Doug Anderson <dianders@chromium.org>,
        LKML <linux-kernel@vger.kernel.org>,
        "# 4.0+" <stable@vger.kernel.org>,
        Vadim Sukhomlinov <sukhomlinov@google.com>,
        linux-integrity@vger.kernel.org, Jason Gunthorpe <jgg@ziepe.ca>
Subject: Re: [PATCH AUTOSEL 4.19 126/167] tpm: Fix TPM 1.2 Shutdown sequence
 to prevent future TPM operations
Message-ID: <20190907220448.GB2012@sasha-vm>
References: <20190903162519.7136-1-sashal@kernel.org>
 <20190903162519.7136-126-sashal@kernel.org>
 <CAD=FV=W0YodeoOCiCv9zmv+-gswuU8U_XgrBnesE=wynTbDBiA@mail.gmail.com>
 <20190903165346.hwqlrin77cmzjiti@cantor>
 <20190903194335.GG5281@sasha-vm>
 <f2224c094836a4b8989c1cd6243a0b7ad1261a87.camel@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <f2224c094836a4b8989c1cd6243a0b7ad1261a87.camel@linux.intel.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sat, Sep 07, 2019 at 09:55:18PM +0300, Jarkko Sakkinen wrote:
>On Tue, 2019-09-03 at 15:43 -0400, Sasha Levin wrote:
>> Right. I gave a go at backporting a few patches and this happens to be
>> one of them. It will be a while before it goes in a stable tree
>> (probably way after after LPC).
>
>It *semantically* depends on
>
>db4d8cb9c9f2 ("tpm: use tpm_try_get_ops() in tpm-sysfs.c.")
>
>I.e. can cause crashes without the above patch. As a code change your
>patch is fine but it needs the above patch backported to work in stable
>manner.
>
>So... either I can backport that one (because ultimately I have
>responsibility to do that as the maintainer) but if you want to finish
>this one that is what you need to backport in addition and then it
>should be fine.

If you're ok with the backport of this commit, I can just add
db4d8cb9c9f2 on top.

--
Thanks,
Sasha
