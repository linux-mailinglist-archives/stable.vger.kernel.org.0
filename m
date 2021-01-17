Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4618C2F92C3
	for <lists+stable@lfdr.de>; Sun, 17 Jan 2021 15:15:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728838AbhAQOP3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 17 Jan 2021 09:15:29 -0500
Received: from out4-smtp.messagingengine.com ([66.111.4.28]:55135 "EHLO
        out4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728709AbhAQOP2 (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 17 Jan 2021 09:15:28 -0500
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailout.nyi.internal (Postfix) with ESMTP id 66D8F5C008F;
        Sun, 17 Jan 2021 09:14:22 -0500 (EST)
Received: from mailfrontend2 ([10.202.2.163])
  by compute4.internal (MEProxy); Sun, 17 Jan 2021 09:14:22 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kroah.com; h=
        date:from:to:cc:subject:message-id:references:mime-version
        :content-type:in-reply-to; s=fm2; bh=yej5zt6+QtYlF2LkXAAlHZoTqMR
        0i+wFGs6otaF0zrg=; b=0LwACqcbuvnW0VhGWO0TTx7EdqIE5Zl/IXsc87P7vhv
        prD0CXRJFTnQ0qWMbQ+j1+M5YjwSMpBHXSwdjFnq0ACx3eXVSXcYdAemdlppRFNc
        gpFO/lZP8j70gHKPxyMuSbsGYOpxUfty1YuKk+itsWVXnoRL/rtzX3LY+fofcszL
        nC9Di0+afTmp7ELpIAXTzueD/6cexEimSN0qqLg/3X+q+Vz9GN+40Iftb5jn9+Il
        o/LJFKT9vhkxgh4ECwsmyftPPME/bKERMk+yt1seaDAiYUvwkNYbcl+6oKv5CPdh
        xtoNJYIZm5HRmf6yFX1froKlcDsuuq/2JOhYURwg4UA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=yej5zt
        6+QtYlF2LkXAAlHZoTqMR0i+wFGs6otaF0zrg=; b=Q4OnZhZtE5RGVMHfY+GgAO
        fhmUSzzPcyPsLVYMDhAtBCdM/+NJ27FwmwhY0Uxzk6KdBTnqk547NGWFbNyf/1Be
        2ImUiKEOAAZaPx7f/p0QzZZtAg3MCiq0NNoRQ46Ig7QzG6+u8tCKeOs8qO9Wxzrs
        +6y9hxuAvleylK1hdivrzx9fYrKr8WUXgkX/aX8l95NM+Xe30OAB1q3FqtfpqmH7
        LjaTL2n3yM/pIOqHxKdkuQzBBVIdKAIq8j0pEG7ec2+ZZYK9HFcEc0uV9PsX8N8t
        YoVxZJrYV5gWPUsbRzVT7QB5Deth6uwcGssyfrQ3Q7gmZ6tmIUIKyfGJlHPznwBA
        ==
X-ME-Sender: <xms:PkYEYE9xA4Pc7NABj2lMweWmNxpzF3pfKYiBKl2sC38G0P5eNFmHcA>
    <xme:PkYEYMtUDh96Nk1cFeSuTwMnCRBu7h7u5i0shtA1CYrpyRNsS2Sijlt1hNcPtZGXE
    Biz4rAt6iZhTw>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrtdeigdeigecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecunecujfgurhepfffhvffukfhfgggtuggjsehttdertd
    dttddvnecuhfhrohhmpefirhgvghcumffjuceoghhrvghgsehkrhhorghhrdgtohhmqeen
    ucggtffrrghtthgvrhhnpeevueehjefgfffgiedvudekvdektdelleelgefhleejieeuge
    egveeuuddukedvteenucfkphepkeefrdekiedrjeegrdeigeenucevlhhushhtvghrufhi
    iigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpehgrhgvgheskhhrohgrhhdrtghomh
X-ME-Proxy: <xmx:PkYEYKDUzEW5Dx384nfflY1ApNCa8CoL3jRzFAqehoQiQsY7q6tf1Q>
    <xmx:PkYEYEe0occSy1D9G3efPldHQytbMiW6FdIa0VBHI5fiph8W4gXCcQ>
    <xmx:PkYEYJNQiUezQU-QVMOxdRM0eCh-fEg7bGoeRgFCpElGvQRKVZcMTg>
    <xmx:PkYEYAY2nq1Wk2XRj82ZviR5CYYswjIioq3-50z_2jhTHeVP0qMh7g>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA id 0A68C108005B;
        Sun, 17 Jan 2021 09:14:21 -0500 (EST)
Date:   Sun, 17 Jan 2021 15:14:20 +0100
From:   Greg KH <greg@kroah.com>
To:     "Alex G." <mr.nuke.me@gmail.com>
Cc:     stable@vger.kernel.org
Subject: Re: [PATCH] drm/bridge: sii902x: Enable I/O and core VCC supplies if
 present
Message-ID: <YARGPIHxlLMFqd41@kroah.com>
References: <369af9ad-a84f-c0ff-5595-11b80ea56f46@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <369af9ad-a84f-c0ff-5595-11b80ea56f46@gmail.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Jan 15, 2021 at 12:13:28PM -0600, Alex G. wrote:
> Please consider adding the following fixes to v5.10:
> 
> * cc5f7e2fcbe3 drm/bridge: sii902x: Enable I/O and core VCC supplies if
> present
> * 4c1e054322da dt-bindings: display: sii902x: Add supply bindings
> * 91b5e26731c5 drm/bridge: sii902x: Refactor init code into separate
> function
> 
> The STM32MP discovery board is a popular ARM platform, containing a GPU and
> attached display. The display will fail to be initialized if any of the DRM
> bridges fail initialization. The sii9022 bridge only worked correctly if the
> firmware enabled the power supplies on boot. This was the case if u-boot was
> used.
> 
> I would like this board to work correctly with v5.10, without needing to
> make assumptions about the firmware.

All now queued up, thanks.

greg k-h
