Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0E8C37D7FE
	for <lists+stable@lfdr.de>; Thu,  1 Aug 2019 10:47:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726368AbfHAIrX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 1 Aug 2019 04:47:23 -0400
Received: from wout1-smtp.messagingengine.com ([64.147.123.24]:57067 "EHLO
        wout1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725946AbfHAIrX (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 1 Aug 2019 04:47:23 -0400
Received: from compute6.internal (compute6.nyi.internal [10.202.2.46])
        by mailout.west.internal (Postfix) with ESMTP id C7FB34B2;
        Thu,  1 Aug 2019 04:47:21 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute6.internal (MEProxy); Thu, 01 Aug 2019 04:47:22 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kroah.com; h=
        date:from:to:cc:subject:message-id:references:mime-version
        :content-type:in-reply-to; s=fm1; bh=OruvwqhKtwaV12zths6LqkNUy9s
        VYCbtSXzhaNxoUiY=; b=AZutz2SLJF1c285u4VuQsgEVYbvpt6qQL2LL6ypJpCJ
        sYbd/bckbZPrs5a7gPaH7J5BLFZa5jd+I1s2Q3RxtJ27aU7cvAyhSc4lTEIhZtlN
        vlxfBYgm6+MFKQymTG4oPi9Qv7HjgzQ6z4gQZrKNlglagUYVrutVfHHy1ipEJ6fc
        xGYWmw5Nus8mvr71b5vHnKGXvv47hrfsT2D9idLu0ADim7T+1KTs3uRH0q0gUz4m
        D4qKdTaKZWGLt2TdSt3cvo6CTFS4Tq4wZqP3dSAayjkEaad7MTVCU1yip7WYMdbn
        y4H/1Se9hsAA5lw9B8x09M7ZZg5zvjEi46UNqEpDhfQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=Oruvwq
        hKtwaV12zths6LqkNUy9sVYCbtSXzhaNxoUiY=; b=vnvq4Gry1p2445AnOP2UzT
        J2G2DjWIxz73bx9eHU3TYI+ravYTszVH+0pfXAjIGZzxzkMTu/i5qq+DWfS533Q/
        o5qlj6wyzGd0fHZ6oVYE1jSh1dmxB3nDlXYEVcMdgW0rgxNAIL+GQ2WEUOoRRSh/
        DUNq6yQoqVFGaRxQZsNLRO3F9crYaqZ4m5olFcBIDWTcbeTHLkLitjYbFAkQgvit
        FcEYcGUuv6VtgQmimjAOvRetYL82afb/QsYxetmkve8ulMeKSAW3Jm8bLtrX2N7i
        Jj2AZXZsNL3fuH0RU6qwip4NEpHavUGaUNcfEL9ujYAneJCiUmQ7LDRSw6NA0yqA
        ==
X-ME-Sender: <xms:GKdCXex0N2DKxVdwUeja_tILb3iDufq8ffrU3GWv4VcsyFsZbIUZRQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduvddrleejgddtjecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenuc
    fjughrpeffhffvuffkfhggtggujggfsehttdertddtredvnecuhfhrohhmpefirhgvghcu
    mffjuceoghhrvghgsehkrhhorghhrdgtohhmqeenucfkphepvddufedruddvjedrvdehud
    drvdduieenucfrrghrrghmpehmrghilhhfrhhomhepghhrvghgsehkrhhorghhrdgtohhm
    necuvehluhhsthgvrhfuihiivgeptd
X-ME-Proxy: <xmx:GKdCXatm14GaxWOFjobyPHN8_he220NrZDHkaPOwD4PyKaxiI-Y_Mg>
    <xmx:GKdCXXObapmvwDzX7Cy7CmXIEEvMAw8zhYgvvbonhToSwcl4cgsPhg>
    <xmx:GKdCXazxJHkEa85261rp1hwORH5M0RIPE7iL6krJDMMwUgJEwtE8rg>
    <xmx:GadCXatX3fVufyySbfXFtAh3x9hmXjQOr672yZt4Pvy07WexXRzhXQ>
Received: from localhost (ip-213-127-251-216.ip.prioritytelecom.net [213.127.251.216])
        by mail.messagingengine.com (Postfix) with ESMTPA id 3F17880066;
        Thu,  1 Aug 2019 04:47:20 -0400 (EDT)
Date:   Thu, 1 Aug 2019 10:47:17 +0200
From:   Greg KH <greg@kroah.com>
To:     Marta Rybczynska <mrybczyn@kalray.eu>
Cc:     stable@vger.kernel.org, kbusch@kernel.org, axboe@fb.com,
        hch@lst.de, sagi@grimberg.me
Subject: Re: Please include 66b20ac0a1a10769d059d6903202f53494e3d902 in 5.1
 and 5.2
Message-ID: <20190801084717.GB1085@kroah.com>
References: <604962916.43493351.1564642842245.JavaMail.zimbra@kalray.eu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <604962916.43493351.1564642842245.JavaMail.zimbra@kalray.eu>
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Aug 01, 2019 at 09:00:42AM +0200, Marta Rybczynska wrote:
> Dear stable maintainers,
> Please include the commit 66b20ac0a1a10769d059d6903202f53494e3d902 into the stable 5.1 and 5.2.
> 
> Commit title: nvme: fix multipath crash when ANA is deactivated
> 
> The bug that this commit fixes was seen crashing kernels or provoking an oops from 5.0 onwards.

5.1 is end-of-life, but I have now queued this up for 5.2-stable,
thanks.

greg k-h
