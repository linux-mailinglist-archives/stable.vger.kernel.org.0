Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 74D90A05D6
	for <lists+stable@lfdr.de>; Wed, 28 Aug 2019 17:13:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726561AbfH1PN5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 28 Aug 2019 11:13:57 -0400
Received: from wout4-smtp.messagingengine.com ([64.147.123.20]:58849 "EHLO
        wout4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726315AbfH1PN5 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 28 Aug 2019 11:13:57 -0400
Received: from compute6.internal (compute6.nyi.internal [10.202.2.46])
        by mailout.west.internal (Postfix) with ESMTP id E93395E9;
        Wed, 28 Aug 2019 11:13:55 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute6.internal (MEProxy); Wed, 28 Aug 2019 11:13:56 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kroah.com; h=
        date:from:to:cc:subject:message-id:references:mime-version
        :content-type:in-reply-to; s=fm1; bh=Trjj6uF82SKWktxH44/96I+xzA4
        khHwrYd51jf6tLeQ=; b=n79zycpJC0zNjsbpq5W6O8wNJHvZOKi7mLDI4CoY18M
        FLBymyzN37E5QxxFZ137o8r4HV++HeEkdj+Ap+MuK68DQRf+ufN5a7H4D0po6DmY
        0ExI47xsvx7gzI6bkiRq3P8iW9Zn710GbyvlFPXlsZaNcmTH8Ck7eRFmPJqvHpco
        lCJbav1IIZn2SUApKbWqhTKg1DpKmUx9oR7BmyChiESeiNL0cIX8ypoUvZOob+m/
        5VnBK744b8u+/2FyFNG/4GPLrXW1rEDRXXtHFDKb5D/Dv7BxZgWFV7P7gAtpOkUt
        v/IGbEeZmch1nJLymoQMqiHHJOYmYJzz9iBxd8RVN7Q==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=Trjj6u
        F82SKWktxH44/96I+xzA4khHwrYd51jf6tLeQ=; b=UWWuF1/MvWekwFyNC21lQw
        LbPKjnIZ4yVlfY7tOigseC/bT9SyPSieABXT2zNjlGkvoUeVIns3RPziIa6AwCxT
        DK99ohxqpdi1UHk0842JZ15uqdbrzp+5Gt+BkubNzIBtsuxPctOH6+836dU2+MRj
        gKB/rBH32w7gmLX3/BwtlCCU//a4sCfib5GcNr8QazAAaCpz8ha1HxIo8pkGfWEY
        Lx26eP4AuglCZfNkGkNvBPe6u62MMq7LerSjN9Q5+ySnaDZzFWiPMheZzfJRgLBM
        yAHjH+kJS1jpE7mWvxktlZejOj+iOqLjnDRK5n5J1Su8IQBl9TpWkPUGV2ROvA2g
        ==
X-ME-Sender: <xms:M5pmXTa_p5trJRy77SXNvc6uxt-SSL_VBRl31rJLGnYoy-Nd9apIvQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduvddrudeitddgkeeiucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpeffhffvuffkfhggtggujggfsehttd
    ertddtredvnecuhfhrohhmpefirhgvghcumffjuceoghhrvghgsehkrhhorghhrdgtohhm
    qeenucffohhmrghinhepkhgvrhhnvghlrdhorhhgnecukfhppeekfedrkeeirdekledrud
    dtjeenucfrrghrrghmpehmrghilhhfrhhomhepghhrvghgsehkrhhorghhrdgtohhmnecu
    vehluhhsthgvrhfuihiivgeptd
X-ME-Proxy: <xmx:M5pmXZ-9kGzvlguARsULLr2B2-6353cSIVNX695RViZvQDIOogIKTQ>
    <xmx:M5pmXVmhPA-0Bwsh6GeX58D7JB2GulgdTebddYjkNm-GvduZ-5L8Pg>
    <xmx:M5pmXWYIhpUIgWzqS4W7FJD84v1joTleg7SGq4qAIB8L3EEX5Mgb5w>
    <xmx:M5pmXShpOeUwo1KGiXQSEF9rCWouaJTG8Nm7Vo-GQTMthAZw7xXlaQ>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id 0FA69D60063;
        Wed, 28 Aug 2019 11:13:54 -0400 (EDT)
Date:   Wed, 28 Aug 2019 17:13:53 +0200
From:   Greg KH <greg@kroah.com>
To:     Bhaskar Chowdhury <unixbhaskar@gmail.com>,
        Konstantin Ryabitsev <mricon@kernel.org>
Cc:     StableKernel <stable@vger.kernel.org>,
        LinuxKernel <linux-kernel@vger.kernel.org>
Subject: Re: Latest kernel version no NOT reflecting on kernel.org
Message-ID: <20190828151353.GA9673@kroah.com>
References: <20190828135750.GA5841@Gentoo>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190828135750.GA5841@Gentoo>
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Aug 28, 2019 at 07:27:53PM +0530, Bhaskar Chowdhury wrote:
> Am I the only one, who is not seeing it getting reflected on
> kernel.org???
> 
> Well, I have tried it 2 different browsers.....cleared caches several
> times(heck) .....3 different devices .....and importantly 3 different
> networks.
> 
> Wondering!

Adding Konstantin.

I think there's a way to see which cdn mirror you are hitting when you
ask for "www.kernel.org".  Konstantin, any hints as to see if maybe one
of the mirrors is out of sync?

thanks,

greg k-h
