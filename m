Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C457DAED0A
	for <lists+stable@lfdr.de>; Tue, 10 Sep 2019 16:32:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732771AbfIJOcr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 Sep 2019 10:32:47 -0400
Received: from wout4-smtp.messagingengine.com ([64.147.123.20]:33441 "EHLO
        wout4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1731630AbfIJOcr (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 10 Sep 2019 10:32:47 -0400
Received: from compute6.internal (compute6.nyi.internal [10.202.2.46])
        by mailout.west.internal (Postfix) with ESMTP id 0CBCD49F;
        Tue, 10 Sep 2019 10:32:45 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute6.internal (MEProxy); Tue, 10 Sep 2019 10:32:46 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kroah.com; h=
        date:from:to:cc:subject:message-id:references:mime-version
        :content-type:in-reply-to; s=fm1; bh=+wxplw0ClvEAab2tmMcZITn+xly
        4Zj9SPax4wW8MTSo=; b=owh93KPMm8nhZ33EL1kORO2mCAT9hvldORO0T1s6qHj
        ZHbwBvhRvHHnPnNSj7/Mg5RYwVeMpIXU07Yu0xyx7jJgMNinN9lRLrCv9UJh5cmb
        66WIkTYAPVJBJePOZLjV7nP+FXvqZfIgwLUCtgdY+1t8KbS18tZL9cV2Dm6cJs6N
        KKroUVQP/doAwOFHinib/sUg3KVu2ScvHKHdAbhT0qa8r55oIlzhPn+JQApwE5CK
        75i1rgR7G9sOeo0aAKpYwKs7bTCiH87WB2i2DypvNSkerEgZR2IzPtX/sb+0A7C2
        VQsXZ6P+Q0AgM8zz55zFDvcoHKJ5xgBXuryXKsFGwHQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=+wxplw
        0ClvEAab2tmMcZITn+xly4Zj9SPax4wW8MTSo=; b=KGOayJ6s8mADctJuo1Yp9p
        2++i8E96Gc7GsLD+gZkfFvJYhSQpfAkiChviD2S1PnNGRI38MzQtcue2Sh0vfXu0
        vItrK4XFJygZHVahon8FiIQccMQgwOP63rQA8q/YAmU+9Pdw67bQChv1tZi6QkAt
        hyL+RGnysRVdxG9lzcjG0i9ETmKt8tiOL50XUAfkN1aGFExK0ikRGszC+9xz3yOF
        CR3IOdchGTgnVgOVwKeWv9bp8w7e2wp44LY9E8pdYsTAU27kr/7wGT88gRg6Udlo
        8KageuMj3KHHHmRGVZd8nxHLANmDQVK2CO5Qyp+DOFHbnrKIZZczgBmRG6V3xWmQ
        ==
X-ME-Sender: <xms:DbR3XUfqCWnOxCwX0vZKaYolbwgOM3T7-VtxB30RndiX0q70DrEfTw>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedufedrtddtgdehhecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenuc
    fjughrpeffhffvuffkfhggtggujggfsehttdertddtredvnecuhfhrohhmpefirhgvghcu
    mffjuceoghhrvghgsehkrhhorghhrdgtohhmqeenucffohhmrghinhepkhgvrhhnvghlrd
    horhhgnecukfhppedvudefrdeftddrkedruddutdenucfrrghrrghmpehmrghilhhfrhho
    mhepghhrvghgsehkrhhorghhrdgtohhmnecuvehluhhsthgvrhfuihiivgeptd
X-ME-Proxy: <xmx:DbR3Xb3ZAk1coMjQt-0f5_5ZVXLDsSLm6syVCyH1vPLpdGM1FBiOrw>
    <xmx:DbR3XUt2pFoGzKoopOORe_HDO6TpICViMjeeRhq6A93rqGvYk5LqKw>
    <xmx:DbR3XX5MxFj1AG9Ij3I0AOVpFAHqtXdqOxap-12Q-A5cr8OfeMWkFQ>
    <xmx:DbR3XUmdhuAJwHNh-HB-JZM4YpD9UjsVidLU1EGZrgz7FUUCFWCRTA>
Received: from localhost (110.8.30.213.rev.vodafone.pt [213.30.8.110])
        by mail.messagingengine.com (Postfix) with ESMTPA id 8BDB58005B;
        Tue, 10 Sep 2019 10:32:44 -0400 (EDT)
Date:   Tue, 10 Sep 2019 15:32:42 +0100
From:   Greg KH <greg@kroah.com>
To:     Baolin Wang <baolin.wang@linaro.org>
Cc:     stable@vger.kernel.org, peterz@infradead.org, mingo@redhat.com,
        longman@redhat.com, arnd@arndb.de, orsonzhai@gmail.com,
        vincent.guittot@linaro.org, linux-kernel@vger.kernel.org
Subject: Re: [BACKPORT 4.14.y v2 2/6] locking/lockdep: Add debug_locks check
 in __lock_downgrade()
Message-ID: <20190910143242.GB3362@kroah.com>
References: <cover.1567649728.git.baolin.wang@linaro.org>
 <7d3d221015cd343df47de4a68ed4776aca2ca0ab.1567649729.git.baolin.wang@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <7d3d221015cd343df47de4a68ed4776aca2ca0ab.1567649729.git.baolin.wang@linaro.org>
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Sep 05, 2019 at 11:07:14AM +0800, Baolin Wang wrote:
> From: Waiman Long <longman@redhat.com>
> 
> [Upstream commit 513e1073d52e55b8024b4f238a48de7587c64ccf]
> 
> Tetsuo Handa had reported he saw an incorrect "downgrading a read lock"
> warning right after a previous lockdep warning. It is likely that the
> previous warning turned off lock debugging causing the lockdep to have
> inconsistency states leading to the lock downgrade warning.
> 
> Fix that by add a check for debug_locks at the beginning of
> __lock_downgrade().
> 
> Reported-by: Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>
> Reported-by: syzbot+53383ae265fb161ef488@syzkaller.appspotmail.com
> Signed-off-by: Waiman Long <longman@redhat.com>
> Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
> Cc: Andrew Morton <akpm@linux-foundation.org>
> Cc: Linus Torvalds <torvalds@linux-foundation.org>
> Cc: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
> Cc: Peter Zijlstra <peterz@infradead.org>
> Cc: Thomas Gleixner <tglx@linutronix.de>
> Cc: Will Deacon <will.deacon@arm.com>
> Link: https://lkml.kernel.org/r/1547093005-26085-1-git-send-email-longman@redhat.com
> Signed-off-by: Ingo Molnar <mingo@kernel.org>
> Signed-off-by: Baolin Wang <baolin.wang@linaro.org>
> ---
>  kernel/locking/lockdep.c |    3 +++
>  1 file changed, 3 insertions(+)

Why isn't this relevant for 4.19.y?  I can't add a patch to 4.14.y and
then have someone upgrade to 4.19.y and not have the same fix in there,
that would be a regression.

So can you redo this series also with a 4.19.y set at the same so we
don't get out of sync?  I've queued up your first patch already as that
was in 4.19.y (and also needed in 4.9.y).

thanks,

greg k-h
