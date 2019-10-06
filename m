Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 67620CCF33
	for <lists+stable@lfdr.de>; Sun,  6 Oct 2019 09:44:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726338AbfJFHot (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 6 Oct 2019 03:44:49 -0400
Received: from out3-smtp.messagingengine.com ([66.111.4.27]:38587 "EHLO
        out3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726207AbfJFHot (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 6 Oct 2019 03:44:49 -0400
Received: from compute6.internal (compute6.nyi.internal [10.202.2.46])
        by mailout.nyi.internal (Postfix) with ESMTP id 2CEEE210C6;
        Sun,  6 Oct 2019 03:44:48 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute6.internal (MEProxy); Sun, 06 Oct 2019 03:44:48 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kroah.com; h=
        date:from:to:cc:subject:message-id:references:mime-version
        :content-type:in-reply-to; s=fm2; bh=NqTmr47wKTsPp74xXfpUzUzsLnv
        +eiIOi3F3PD9gWEs=; b=rofwJlW3WhyBJZOew6PumqiMSkOUB4R/aYRnVvFB+93
        QybwG8eh5MRDRDTS90UWjkFaOATduxW5eykeALe1K36scw/aVw8+d9uaipIZVMAS
        w4tE7GAESKiya0OEHf0YYnrtrM4XQUb981lOt4Z6AU21ISsV70X/jTyN0XPCidvn
        NAk8ELtD2EKU2I9aZthDicEB8vGZtAm88/5LHAfx3vdDXY0o5ZSXnfsWZ/VTdOI+
        ukrL/bk667gede2SUxms3UtHkhHY68bLSPzZvi0qeXQhHmhxrgBOPnOixWamTGdE
        EOMn5sdSz2aNfRqdqBwzieVuOtVSDa6ckKC8Ab7oipw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=NqTmr4
        7wKTsPp74xXfpUzUzsLnv+eiIOi3F3PD9gWEs=; b=qKBo0Wns5PwN3fBTwUGvVb
        jrkZXHPlF6gjJsuv5IVaeFafVu6FJyPpmTDD/vjDaAGbmZcDz1ulXbvV0/EzvRco
        Dr17aXFBPkMK4J8o89gDVFled74TlFm/NG5/HvKqeEyzMaOhpsOZ8ZbAg70nTTNH
        VV0wyKvJjY7Dd+8QlmHBY4AHbf0MBJUUzM1A1NejhbTpxO6d2W6zIbMv7lUJoSDs
        XMVmFi4ItypX4weHM85fftYiYSwW5+eP/TnPboxADXdQZeN3fCjghV617qqOr46B
        JRbcomF1f0rlfzeEySdwZnsKQlLWPSOaZh4kIYG/f27B/m1WbziiIt+NehofbYBg
        ==
X-ME-Sender: <xms:b5uZXXI-W9huW8jwMPq5kqlf9TmzCQDLrl-8TQoc-ifLXUGrTuItAQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedufedrheeggdeklecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenuc
    fjughrpeffhffvuffkfhggtggujggfsehttdertddtredvnecuhfhrohhmpefirhgvghcu
    mffjuceoghhrvghgsehkrhhorghhrdgtohhmqeenucfkphepkeefrdekiedrkeelrddutd
    ejnecurfgrrhgrmhepmhgrihhlfhhrohhmpehgrhgvgheskhhrohgrhhdrtghomhenucev
    lhhushhtvghrufhiiigvpedt
X-ME-Proxy: <xmx:b5uZXeK-s73KjgQYQ_1QyHAiqHXwA54gPWbsmcY7AxlycpD4Dp4zGQ>
    <xmx:b5uZXSS3N1EixAr0c2dUFiVnIlr2RT64bMVwrn-vz_5glGW9wNEkmA>
    <xmx:b5uZXa3FKB7OwQd9wodPX9_bL9nahy8W1UMTUZJKWIoddn84_-T_jQ>
    <xmx:cJuZXVCmYYzQKh5x4xAbT_-2kJMxfPaqxvcXj226bpOl64a9VnJDcg>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id 7AC1480059;
        Sun,  6 Oct 2019 03:44:47 -0400 (EDT)
Date:   Sun, 6 Oct 2019 09:42:25 +0200
From:   Greg KH <greg@kroah.com>
To:     Paul Cercueil <paul@crapouillou.net>
Cc:     Sasha Levin <sashal@kernel.org>, stable-commits@vger.kernel.org,
        stable@vger.kernel.org
Subject: Re: Patch "clk: jz4740: Add TCU clock" has been added to the
 4.4-stable tree
Message-ID: <20191006074225.GA2133376@kroah.com>
References: <20191005235655.C47C7206DF@mail.kernel.org>
 <1570320555.3.0@crapouillou.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1570320555.3.0@crapouillou.net>
User-Agent: Mutt/1.12.2 (2019-09-21)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sun, Oct 06, 2019 at 02:09:15AM +0200, Paul Cercueil wrote:
> Hi Sasha,
> 
> I think this patch shouldn't be added to the stable trees; it will cause the
> TCU clock to be managed by the clock framework and automatically gated after
> bootup since it has no client, causing a global system lockup. It's only
> really applicable to 5.3.

Now dropped from everywhere, thanks!

greg k-h
