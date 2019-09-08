Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EDE3CACB75
	for <lists+stable@lfdr.de>; Sun,  8 Sep 2019 10:06:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726562AbfIHIG3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 8 Sep 2019 04:06:29 -0400
Received: from out2-smtp.messagingengine.com ([66.111.4.26]:54785 "EHLO
        out2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726504AbfIHIG3 (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 8 Sep 2019 04:06:29 -0400
Received: from compute6.internal (compute6.nyi.internal [10.202.2.46])
        by mailout.nyi.internal (Postfix) with ESMTP id 804F821D6E;
        Sun,  8 Sep 2019 04:06:25 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute6.internal (MEProxy); Sun, 08 Sep 2019 04:06:25 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kroah.com; h=
        date:from:to:cc:subject:message-id:references:mime-version
        :content-type:in-reply-to; s=fm1; bh=Ke5GRiKRIYLxrDlKozLyVhDZhQ1
        JAqHaCox9pvEKXTg=; b=mcyOUKduzCSgJ6YzjcPTPHkKvrzzDeEwb0oOwublqOo
        bNfBmajY1gKOfDaCOoTx10gC2Ucx0CtGt1bV5JCymvQAPHQuE3ChVadKVY4+DKmT
        rno1v8mHdI9k4ROCr7qaidhXVmzTdNOIDvmx89rg22Z8xwBWeHCnfvXmOuIivbI2
        Ubl+Qq8cIMkXumNjUw1x31hb51vZwXZZVR77yr4xxPbfrPEhmZWydw3Wmm2VG8I6
        DJLqFvD2CjLQSMH7/rTQZYOU1Rb9Gda+cSx+Fg8Wzervy+JQ2YddGRV6mpu/XTlv
        cy67FpSB8ycah1I8nTfVXOES3yCfghw10Gg+2hn3f3g==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=Ke5GRi
        KRIYLxrDlKozLyVhDZhQ1JAqHaCox9pvEKXTg=; b=G1hJAi2iV/YmEeqwep9YJe
        h+UpTGO+vlpSwV1oxkly0J+S9p1LFKXvPX7sNDK5WB4PEI+1m5vhtXfwikwOUIWz
        ZaFWGtB99e79b7nlkGbbWrt171UX0gMrX8Rm5nQz4YV4JV1bUUEW6YJaHEuNIWhs
        /yhdgTL6jg27x9FfFjDpYgDRambYL0F6+KA9NWHg8tjiWnXPajDLAeHEC8JE7huv
        3q7pBLYkpnhIZz8yY17zmlAE/jWOAJcw4IxIlN9N4Gvul1PFvB2vyXjXfj72Ij5V
        80Cj2Kttlb5T/W2l0O9I7raICSkeUiBxUpo7+K4jjjTWnkFmI+L7r8lbYUsjmEfA
        ==
X-ME-Sender: <xms:gbZ0XcQ-o8IV_0IetGlioMY47zV4R8Jctr1AQFBJhwBGb_TrNw4z6w>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduvddrudekgecutefuodetggdotefrodftvfcurf
    hrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecuuegr
    ihhlohhuthemuceftddtnecunecujfgurhepfffhvffukfhfgggtuggjfgesthdtredttd
    ervdenucfhrhhomhepifhrvghgucfmjfcuoehgrhgvgheskhhrohgrhhdrtghomheqnecu
    kfhppeektddrvdehuddrudeivddrudeigeenucfrrghrrghmpehmrghilhhfrhhomhepgh
    hrvghgsehkrhhorghhrdgtohhmnecuvehluhhsthgvrhfuihiivgeptd
X-ME-Proxy: <xmx:gbZ0XeFySbxDv_eex6c72ZKwDJy0ZaxdPHgBlenCG-RBN98QRIm8ag>
    <xmx:gbZ0XUOfWuHAnDgr3nKb5NoIndFkr3LgVfHZim6j8u2OxNSBwJ751A>
    <xmx:gbZ0XeCXGcqSwai2SQoYd8lRrR01SN8GvrTTwcgmFOSmCYxUokd6Iw>
    <xmx:gbZ0XVyVmCZOkOySidjrUHJ-7h3ZQTL618yOK7Kxb1HzeHN_Bmv1pA>
Received: from localhost (unknown [80.251.162.164])
        by mail.messagingengine.com (Postfix) with ESMTPA id C22C5D6005D;
        Sun,  8 Sep 2019 04:06:24 -0400 (EDT)
Date:   Sun, 8 Sep 2019 09:06:22 +0100
From:   Greg KH <greg@kroah.com>
To:     Thomas Gleixner <tglx@linutronix.de>
Cc:     stable@vger.kernel.org
Subject: Re: Linux 5.3-rc7 (fwd)
Message-ID: <20190908080622.GA31071@kroah.com>
References: <alpine.DEB.2.21.1909080903450.1944@nanos.tec.linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.21.1909080903450.1944@nanos.tec.linutronix.de>
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sun, Sep 08, 2019 at 09:05:34AM +0200, Thomas Gleixner wrote:
> 
> 950b07c14e8c ("Revert "x86/apic: Include the LDR when clearing out APIC registers"")
> 
> in Linus tree needs to go back into stable as the reverted commit
> 558682b52919 ("x86/apic: Include the LDR when clearing out APIC registers")
> hit stable trees.

Thanks for the info, Sasha queued this up yesterday, and I'll push out
the -rcs after breakfast today...

greg k-h
