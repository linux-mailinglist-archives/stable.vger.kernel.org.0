Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D4DC29CB72
	for <lists+stable@lfdr.de>; Mon, 26 Aug 2019 10:21:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728168AbfHZIVt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 26 Aug 2019 04:21:49 -0400
Received: from wout3-smtp.messagingengine.com ([64.147.123.19]:55117 "EHLO
        wout3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726401AbfHZIVs (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 26 Aug 2019 04:21:48 -0400
Received: from compute6.internal (compute6.nyi.internal [10.202.2.46])
        by mailout.west.internal (Postfix) with ESMTP id B99DC367;
        Mon, 26 Aug 2019 04:21:47 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute6.internal (MEProxy); Mon, 26 Aug 2019 04:21:48 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kroah.com; h=
        date:from:to:cc:subject:message-id:references:mime-version
        :content-type:in-reply-to; s=fm1; bh=l/mrdOMbdWknCtaf8kmwyoy6T2J
        lkEFNXRg5NWmtzf8=; b=K3O2ft+5U2+1BLa0U1Nn/wcWKd7xEeQn0eq2zNwcdqa
        JJQeRgBopfC1ihfnMztzeZI+Ik7S9qyDYdGMvP+S7bxT2KwYt9Js63a69IygjMag
        hQ8/FCPW0o/mw68/ZyqqR/SEXmhVJiYsAGaL7kYPknWCO2gWGTKuF1c0o3Wkr+Rg
        vn3qMGbkVKPC5N/Qrr56l/7CepLAR3g8yLrz0m8oYZJapDwZX0srDxaroKGOePge
        0THJRl5gVMqJLrKBXC8srZ0qMWfzD9OiDcVst8i/ADATwfXB/r9CYv2JSE3xnzE1
        ySSqARQnh+YZPwWo5J3IzUBwInPEAtcAFw4RlXtDfTg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=l/mrdO
        MbdWknCtaf8kmwyoy6T2JlkEFNXRg5NWmtzf8=; b=Vt0DXT6sln3G9MSxOpO8XD
        h+GjPwJpVFiyJR5DEOc6SrL5xVrSm5kh/NsnGh3gps+5o00RmzF/ER2tVsxmzQsm
        /bO2nZLdCaK6U7EQY1Gh2/6hXjcxOEHV7Fq+LLj8cEEPCY0VNE7ykNzLpE5EtyBu
        asqsO5uTXFi4B4lSth60IZ8+cvMaLrQtP4S7sgXFoOlzMF/iDs2uL9yaz3OzoXXE
        qeqf2rtdJxFhMzzdmWqqWuPC2Fp4U5UUcuruyWpsCfgyf/oUs/o6dNKY5n/eHtB7
        wuiOX7PwyPEkdfPBuHrvfwRACKbh5cfPXZ8OCH2ODZDPsIpgsZnShahEbngoOqAw
        ==
X-ME-Sender: <xms:mpZjXQ_wX4tF4zn-f86cago-sbtB_9iPUB3ZTCTYpcn7ksQmUcxIBw>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduvddrudehgedgtddvucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhepfffhvffukfhfgggtuggjfgesthdtredttdervdenucfhrhhomhepifhrvghg
    ucfmjfcuoehgrhgvgheskhhrohgrhhdrtghomheqnecukfhppeekledrvddthedruddvke
    drvdegieenucfrrghrrghmpehmrghilhhfrhhomhepghhrvghgsehkrhhorghhrdgtohhm
    necuvehluhhsthgvrhfuihiivgeptd
X-ME-Proxy: <xmx:mpZjXaZLt2yG1Ktr5iH5Cx39y2reo42mRGuWsCn5ieBZqFd0cTob5A>
    <xmx:mpZjXZcKCaY_RBU-vABe3Zuu_oZKz0JRn8KyzflfiEeVOIvXRC92aA>
    <xmx:mpZjXQQiAODiimhrJfzfGQN4qVDmotiaAynnq8Hh2IIfQGLXB-BW9Q>
    <xmx:m5ZjXfS0whH92R80_ONFvzWsIlcCKaY3HeR_SqhWOLjjCrNsW8K42g>
Received: from localhost (unknown [89.205.128.246])
        by mail.messagingengine.com (Postfix) with ESMTPA id 85CB5D6005A;
        Mon, 26 Aug 2019 04:21:46 -0400 (EDT)
Date:   Mon, 26 Aug 2019 10:21:38 +0200
From:   Greg KH <greg@kroah.com>
To:     Bhaskar Chowdhury <unixbhaskar@gmail.com>
Cc:     Sasha Levin <sashal@kernel.org>, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org, akpm@linux-foundation.org, jslaby@suse.cz,
        Konstantin Ryabitsev <konstantin@linuxfoundation.org>
Subject: Re: Linux 5.2.10
Message-ID: <20190826082138.GB31262@kroah.com>
References: <20190825144703.6518-1-sashal@kernel.org>
 <20190826063834.GD31983@Gentoo>
 <20190826080107.GB30396@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190826080107.GB30396@kroah.com>
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Aug 26, 2019 at 10:01:07AM +0200, Greg KH wrote:
> On Mon, Aug 26, 2019 at 12:08:38PM +0530, Bhaskar Chowdhury wrote:
> 
> <snip>
> 
> Due, learn to properly trim emails...

*Dude*

Ugh, email before coffee...
