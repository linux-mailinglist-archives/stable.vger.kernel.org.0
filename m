Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AA0EFA615D
	for <lists+stable@lfdr.de>; Tue,  3 Sep 2019 08:24:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726408AbfICGYh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Sep 2019 02:24:37 -0400
Received: from out2-smtp.messagingengine.com ([66.111.4.26]:57453 "EHLO
        out2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725848AbfICGYh (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 3 Sep 2019 02:24:37 -0400
Received: from compute6.internal (compute6.nyi.internal [10.202.2.46])
        by mailout.nyi.internal (Postfix) with ESMTP id 828F4218C1;
        Tue,  3 Sep 2019 02:24:36 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute6.internal (MEProxy); Tue, 03 Sep 2019 02:24:36 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kroah.com; h=
        date:from:to:cc:subject:message-id:references:mime-version
        :content-type:in-reply-to; s=fm1; bh=3BS6lEyrBSoMUIis9dZkyk94wu9
        iSafqkUU21Yn5E2g=; b=B1Iwgv0u72DppAmkz7pdZXA1I5FfFp4725l+Ka3ls0E
        4LCJBDiyOkl1bDDOOiTsiYhEETm89IVSHlbn/PCsJB7i17gWdpF888SJai9KpvvY
        viJogme/OIw2z88E1SDIR858JS4NB2ZyhAnZRoTQ8pxDez9m33+S+3o2BTxPcsEf
        ZZ8JUNpytr0wpMidbJYXjCxzJoOffSHdJzKTaiiC9obX6aHp3Us93w12l6BoWbnG
        pD2Ys1SChFPi9ALLmV1vETVXvUJFpipWmmquyPnUTxzn4iY+NKOLCtDwEvQ9qmEL
        uFKWOQfmn21IbHuWPgJ28IsL1eiO842Y0C40qZ/Onag==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=3BS6lE
        yrBSoMUIis9dZkyk94wu9iSafqkUU21Yn5E2g=; b=x4oY8sYDWDuhbykM1dgk7/
        YUC1CLKjJZz2a5Q4wDc0PSJm8JqiG/C3IPcEZbq9Dk6xnMXyxBvvd/zzJ482MG4M
        kKFw/HclCVrCCigYkIHAFXp0TOtAOlYbLpuFJ7z46x2kyOzri9/MsqcOiEXFyYyU
        Bu0ZpbDIolq4N/EpS+huiwxCILKH4Pq/3U5qcz0v2wCDf4nEIJ8VNP9v3IHiG/QW
        Duh0VGELcs3rcEODzMuA0gw8kEMMZzIj9tI52OvtIDIT+kAewssIodZ8pPj3Hck+
        3qQHil0K4nCaMGnSUPEoVytIKZdAuwBVd2ZbBTEyQzRqX5IPIEO/F8xzlrOIVk4g
        ==
X-ME-Sender: <xms:JAduXSVmpxsQ2tFqrrEaJ4DBZfPpqbk3gqKo-IyI9LZMmt5gIbzBVg>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduvddrudejuddguddtiecutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfgh
    necuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
    enucfjughrpeffhffvuffkfhggtggujggfsehttdertddtredvnecuhfhrohhmpefirhgv
    ghcumffjuceoghhrvghgsehkrhhorghhrdgtohhmqeenucffohhmrghinhepkhgvrhhnvg
    hlrdhorhhgnecukfhppeekfedrkeeirdekledruddtjeenucfrrghrrghmpehmrghilhhf
    rhhomhepghhrvghgsehkrhhorghhrdgtohhmnecuvehluhhsthgvrhfuihiivgepud
X-ME-Proxy: <xmx:JAduXT3FJnvvuyeB5cBQLStdsZBb9XOVIYb-iWUQWjN1STR67ma6gw>
    <xmx:JAduXYFohtcKdwvqxCRWTtvdxGYVyLbDl_tIcSGp2QoABybv-HP0zA>
    <xmx:JAduXRhbU-8iGO3QK5PT7cnp8yrYmdwdjllHR8ljQ1xQknVS0N7Hcw>
    <xmx:JAduXdxJzrZWSauvunj4NeLqLFQ4RHSX9KxvyAfVlnvqx5FPTIIyhg>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id D9E8ED60057;
        Tue,  3 Sep 2019 02:24:35 -0400 (EDT)
Date:   Tue, 3 Sep 2019 08:24:34 +0200
From:   Greg KH <greg@kroah.com>
To:     CKI Project <cki-project@redhat.com>
Cc:     Linux Stable maillist <stable@vger.kernel.org>,
        Xiong Zhou <xzhou@redhat.com>
Subject: Re: =?utf-8?B?4p2MIEZBSUw=?= =?utf-8?Q?=3A?= Test report for kernel
 5.2.11-c3915fe.cki (stable)
Message-ID: <20190903062434.GD16647@kroah.com>
References: <cki.EDBAAD9BB8.PJ4CXK5IUR@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cki.EDBAAD9BB8.PJ4CXK5IUR@redhat.com>
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Sep 02, 2019 at 10:38:46PM -0400, CKI Project wrote:
> 
> Hello,
> 
> We ran automated tests on a recent commit from this kernel tree:
> 
>        Kernel repo: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
>             Commit: c3915fe1bf12 - Linux 5.2.11

Same git commit id fails one test run but passes another?  You all might
want to look into this...

